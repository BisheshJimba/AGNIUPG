table 33020173 "Vehicle Registration Header"
{
    Permissions = TableData 112 = rm,
                  TableData 25006005 = rm;

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Agent Code"; Code[20])
        {
            TableRelation = Vendor.No.;

            trigger OnValidate()
            begin
                IF "Agent Code" <> Vendor."No." THEN BEGIN
                    Vendor.GET("Agent Code");
                    Name := Vendor.Name;
                    Address := Vendor.Address;
                    "Phone No." := Vendor."Phone No.";
                END
                ELSE IF "Agent Code" = '' THEN BEGIN
                    Name := '';
                    Address := '';
                    "Phone No." := '';
                END;
            end;
        }
        field(4; Name; Text[50])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address';
            Editable = false;
        }
        field(6; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            Editable = false;
            ExtendedDatatype = PhoneNo;
        }
        field(7; Description; Text[100])
        {
        }
        field(8; "No. Series"; Code[10])
        {
            Editable = false;
            TableRelation = "No. Series";
        }
        field(9; "Document Date"; Date)
        {
        }
        field(10; "Posting Date"; Date)
        {
        }
        field(11; Registered; Boolean)
        {
        }
        field(12; "Assigned User ID"; Code[50])
        {
        }
        field(50000; "Purchase Order Created"; Boolean)
        {
        }
        field(50001; "Responsibility Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Responsibility Center".Code;
        }
        field(50002; "Completely Registered"; Boolean)
        {
            CalcFormula = Min("Vehicle Registration Line"."Purchase Order Created" WHERE(Document No.=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        PurchSetup.GET;
        IF "No." = '' THEN BEGIN
          TestNoSeries;
          NoSeriesMngt.InitSeries(GetNoSeries,xRec."No. Series",0D,"No.","No. Series");
        END;
        "Document Date" := TODAY;
        "Assigned User ID" := USERID;
        UserSetup.GET(USERID);
        "Responsibility Center" := UserSetup."Default Responsibility Center";
        "Accountability Center" := UserSetup."Default Accountability Center";
    end;

    var
        NoSeriesMngt: Codeunit "396";
        PurchSetup: Record "312";
        UserSetup: Record "91";
        Vendor: Record "23";
        VehRegLine: Record "33020174";
        GLSetup: Record "98";
        GenJnlTemplate: Record "80";
        GenJnlBatch: Record "232";
        JournalSetup: Record "33019874";
        GenJnlLine: Record "81";
        LineNo: Integer;
        BalancingAmt: Decimal;

    [Scope('Internal')]
    procedure AssistEdit(xVehReg: Record "33020173"): Boolean
    begin
        PurchSetup.GET;
        TestNoSeries;
        IF NoSeriesMngt.SelectSeries(GetNoSeries,xVehReg."No. Series","No. Series") THEN BEGIN
          PurchSetup.GET;
          TestNoSeries;
          NoSeriesMngt.SetSeries("No.");
          EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure TestNoSeries(): Boolean
    begin
        PurchSetup.TESTFIELD(PurchSetup."Veh. Registration No. Series");
    end;

    [Scope('Internal')]
    procedure GetNoSeries(): Code[20]
    begin
        EXIT(PurchSetup."Veh. Registration No. Series");
    end;

    [Scope('Internal')]
    procedure PostDocument(var VehRegistration: Record "33020173")
    var
        Vehicle: Record "25006005";
        VehRegLine: Record "33020174";
        Text000: Label 'Nothing to post.';
        Text001: Label 'There is no Vehicle with Serial No. %1 and VIN %2.';
        Text002: Label 'Document %1 posted successfully.';
        Text003: Label 'Total Expected Amount must not be zero in Vehicle Serial No. %1 and VIN %2.';
        Text004: Label 'Vehicle with serial no. %1 has already been registered for 2 times.';
    begin
        WITH VehRegistration DO BEGIN
        //TESTFIELD("Agent Code"); commented as no agent required SM Agni
        TESTFIELD("Document Date");
        VehRegLine.RESET;
        VehRegLine.SETRANGE("Document No.","No.");
        IF VehRegLine.FINDSET THEN
        BEGIN
          REPEAT
            //VehRegLine.TESTFIELD("Registration No."); commented as reg. no. is not availabe before posting SM Agni
            IF (VehRegLine."Expected Expenses") <= 0 THEN
              ERROR(Text003,VehRegLine."Serial No.",VehRegLine.VIN);
            Vehicle.RESET;
            Vehicle.SETRANGE("Serial No.",VehRegLine."Serial No.");
            IF Vehicle.FINDFIRST THEN BEGIN
              IF Vehicle."No. of times registered" <= 5 THEN BEGIN //**SM 15-08-2013 as registration is done twice for sahamati vehicles
                 //Vehicle."First Registration Date" := TODAY; ER 9.23.13 Date is filled manually.
                 //Vehicle.VALIDATE("Registration No.",VehRegLine."Registration No.");  //ER 9.23.13 Vehicle Register No. validating blank
                 Vehicle.Registered := TRUE;
                 Vehicle."No. of times registered" +=1;
                 /*
                 This Amount Should be captured from Invoiced Purchase.
                 Vehicle."Registration Amount" := (VehRegLine."Vehicle Tax"+VehRegLine."Income Tax"+VehRegLine."Road Maintenance Fee"
                 +VehRegLine."Registration Fee"+VehRegLine."Ownership Transfer Fee"+VehRegLine."Other Fee");
                 */
                 Vehicle.MODIFY(TRUE);
              END ELSE
                 ERROR(Text004,Vehicle."Serial No.");
            END
            ELSE
              ERROR(Text001,VehRegLine."Serial No.",VehRegLine.VIN);
          UNTIL VehRegLine.NEXT = 0;
          Registered := TRUE;
          "Posting Date" := TODAY;
          MODIFY;
          MESSAGE(Text002,"No.");
        END
        ELSE
          ERROR(Text000);
        END;

    end;

    [Scope('Internal')]
    procedure CreatePurchOrder(var VehRegHeader: Record "33020173")
    var
        LastUsedLineNo: Integer;
        PurchLine: Record "39";
        NothingToPost: Label 'There is nothing to Create.';
        VehRegLine: Record "33020174";
        PurchSetup: Record "312";
        PurchHeader: Record "38";
        Text000: Label 'Purchase Order Created Successfully.';
        ChassisAccount: Code[20];
        TaxAccount: Code[20];
        Vehicle: Record "25006005";
        COGSType: array [2] of Option " ","ACCESSORIES-CV","ACCESSORIES-PC","BANK CHARGE-CV","BANK CHARGE-PC","BATTERY-CV","BATTERY-PC","BODY BUILDING-CV","BODY BUILDING-PC","CHASSIS REGISTR-CV","CHASSIS REGISTR-PC","CLEARING & FORW-CV","CLEARING & FORW-PC","CUSTOM DUTY-CV","CUSTOM DUTY-PC","DENT / PENT-CV","DENT / PENT-PC","DRIVER-CV","DRIVER-PC","FOREIGN CHARGE-CV","FOREIGN CHARGE-PC","FUEL & OIL-CV","FUEL & OIL-PC","INSURANCE MANAG-CV","INSURANCE MANAG-PC","INSURANCE-CV","INSURANCE-PC",,"L/C & BANK CHAR-CV","L/C & BANK CHAR-PC","LUBRICANTS-CV","LUBRICANTS-PC","NEW CHASSIS REP-CV","NEW CHASSIS REP-PC","PARKING CHARGE-CV","PARKING CHARGE-PC","PRAGYANPAN-CV","PRAGYANPAN-PC","SERVICE CHARGE-CV","SERVICE CHARGE-PC","SPARES-CV","SPARES-PC","TRANSPORTATION-CV","TRANSPORTATION-PC","VEHICLE LOGISTI-CV","VEHICLE LOGISTI-PC","VEHICLE TAX-CV","VEHICLE TAX-PC";
        RecVehRegLine: Record "33020174";
        ShortcutDim5: Code[20];
    begin
        //VehRegHeader.TESTFIELD("Purchase Order Created",FALSE);
        VehRegLine.RESET;
        VehRegLine.SETRANGE("Document No.",VehRegHeader."No.");
        VehRegLine.SETRANGE(Skip,FALSE);
        VehRegLine.SETRANGE("Purchase Order Created",FALSE);
        IF VehRegLine.FINDSET THEN BEGIN
        
            // ***** CREATE PURCHASE HEADER ********
            PurchHeader.RESET;
            CLEAR(PurchHeader);
            PurchHeader.INIT;
            PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
            PurchHeader."Order Type" := PurchHeader."Order Type"::" ";
            PurchHeader.INSERT(TRUE);
            PurchHeader.VALIDATE("Buy-from Vendor No.",VehRegHeader."Agent Code");
            PurchHeader.MODIFY(TRUE);
            LastUsedLineNo := 0;
           REPEAT
            // ***** CREATE PURCHASE LINE ********
            CLEAR(COGSType);
            Vehicle.GET(VehRegLine."Serial No.");
            Vehicle.TESTFIELD("Make Code");
            PurchSetup.GET;
            IF Vehicle."Make Code" = 'TATA CVD' THEN BEGIN
              PurchSetup.TESTFIELD("Chassis. Reg. Account (CV)");
              PurchSetup.TESTFIELD("Tax Account (CV)");
              ChassisAccount := PurchSetup."Chassis. Reg. Account (CV)";
              TaxAccount := PurchSetup."Tax Account (CV)";
              COGSType[1] := COGSType::"VEHICLE TAX-CV";
              COGSType[2] := COGSType::"CHASSIS REGISTR-CV";
            END
            ELSE IF Vehicle."Make Code" = 'TATA PCD' THEN BEGIN
              PurchSetup.TESTFIELD("Chassis. Reg. Account  (PC)");
              PurchSetup.TESTFIELD("Tax Account (PC)");
              ChassisAccount := PurchSetup."Chassis. Reg. Account  (PC)";
              TaxAccount := PurchSetup."Tax Account (PC)";
              COGSType[1] := COGSType::"VEHICLE TAX-PC";
              COGSType[2] := COGSType::"CHASSIS REGISTR-PC";
            END;
        
            // ***** VEHICLE TAX ************
            IF VehRegLine."Vehicle Tax" > 0 THEN BEGIN
              CLEAR(PurchLine);
              PurchLine.INIT;
              PurchLine."Line No." := LastUsedLineNo + 10000;
              PurchLine."Document Type" := PurchHeader."Document Type";
              PurchLine.VALIDATE("Document No.",PurchHeader."No.");
              PurchLine.VALIDATE(Type,PurchLine.Type::"G/L Account");
              PurchLine.VALIDATE("Line Type",PurchLine."Line Type"::"G/L Account");
              PurchLine.VALIDATE("No.",TaxAccount);
              PurchLine.VALIDATE("VIN - COGS",VehRegLine.VIN);
              PurchLine.VALIDATE(Quantity,1);
              PurchLine.VALIDATE("Qty. to Receive",1);
              PurchLine.VALIDATE("Qty. to Invoice",1);
              PurchLine.VALIDATE("Direct Unit Cost",VehRegLine."Vehicle Tax");
              PurchLine."COGS Type" := COGSType[1];
              PurchLine.INSERT(TRUE);
              LastUsedLineNo := LastUsedLineNo + 10000;
              // Inserting Line-Item Dimension
        
              ShortcutDim5 := 'VEH-TAX';
              PurchLine.ValidateShortcutDimCode(5,ShortcutDim5);
              PurchLine.MODIFY;
              VehRegLine."Purchase Order Created" := TRUE;
              VehRegLine.MODIFY;
        
              /*RecVehRegLine.RESET;
              RecVehRegLine.COPY(VehRegLine);
              RecVehRegLine."Purchase Order Created" := TRUE;
              RecVehRegLine.MODIFY;
              */
            END;
            // ***** CHASSIS REGD. ************
            IF
            (VehRegLine."Income Tax"+VehRegLine."Road Maintenance Fee"+VehRegLine."Registration Fee"+VehRegLine."Ownership Transfer Fee"
            +VehRegLine."Other Fee") > 0 THEN BEGIN
              CLEAR(PurchLine);
              PurchLine.INIT;
              PurchLine."Line No." := LastUsedLineNo + 10000;
              PurchLine."Document Type" := PurchHeader."Document Type";
              PurchLine.VALIDATE("Document No.",PurchHeader."No.");
              PurchLine.VALIDATE(Type,PurchLine.Type::"G/L Account");
              PurchLine.VALIDATE("Line Type",PurchLine."Line Type"::"G/L Account");
              PurchLine.VALIDATE("No.",ChassisAccount);
              PurchLine.VALIDATE("VIN - COGS",VehRegLine.VIN);
              PurchLine.VALIDATE(Quantity,1);
              PurchLine.VALIDATE("Qty. to Receive",1);
              PurchLine.VALIDATE("Qty. to Invoice",1);
              PurchLine.VALIDATE("Direct Unit Cost",
              (VehRegLine."Income Tax"+VehRegLine."Road Maintenance Fee"+VehRegLine."Registration Fee"+VehRegLine."Ownership Transfer Fee"
              +VehRegLine."Other Fee"));
              PurchLine."COGS Type" := COGSType[2];
              PurchLine.INSERT(TRUE);
              LastUsedLineNo := LastUsedLineNo + 10000;
        
              // Inserting Line-Item Dimension
              ShortcutDim5 := 'VEH-REGISTRATION';
              PurchLine.ValidateShortcutDimCode(5,ShortcutDim5);
              PurchLine.MODIFY;
        
              VehRegLine."Purchase Order Created" := TRUE;
              VehRegLine.MODIFY;
        
              /*RecVehRegLine.RESET;
              RecVehRegLine.COPY(VehRegLine);
              RecVehRegLine."Purchase Order Created" := TRUE;
              RecVehRegLine.MODIFY;*/
        
            END;
          UNTIL VehRegLine.NEXT=0;
        
          //VehRegHeader."Purchase Order Created" := TRUE;
          //VehRegHeader.MODIFY;
          IF LastUsedLineNo > 0 THEN
            MESSAGE(Text000);
        END
        ELSE
          ERROR(NothingToPost);

    end;

    [Scope('Internal')]
    procedure CreateJournalLines(var VehRegHdr: Record "33020173")
    begin
        GLSetup.GET;
        GLSetup.TESTFIELD("Vehicle Tax");
        GLSetup.TESTFIELD("Income Tax");
        GLSetup.TESTFIELD("Road Maintenance");
        GLSetup.TESTFIELD("Registration Fee");
        GLSetup.TESTFIELD("Ownership Transfer Fee");
        GLSetup.TESTFIELD("Other Fee");
        GLSetup.TESTFIELD("Balancing A/c");

        JournalSetup.RESET;
        JournalSetup.SETRANGE("Table ID",DATABASE::"Vehicle Registration Header");
        JournalSetup.SETRANGE("User ID",USERID);
        JournalSetup.FINDFIRST;

        JournalSetup.TESTFIELD("Gen. Journal Template Name");
        JournalSetup.TESTFIELD("Gen. Journal Batch Name");

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name",JournalSetup."Gen. Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name",JournalSetup."Gen. Journal Batch Name");
        IF GenJnlLine.FINDFIRST THEN BEGIN
           GenJnlLine.DELETEALL;
        END;

        LineNo := 10000;
        BalancingAmt := 0;

        VehRegLine.RESET;
        VehRegLine.SETRANGE("Document No.",VehRegHdr."No.");
        VehRegLine.SETRANGE(Skip,FALSE);
        IF VehRegLine.FINDFIRST THEN BEGIN
           REPEAT
            VehRegLine.CALCFIELDS("General Journal Created");
            //MESSAGE(FORMAT(VehRegLine."General Journal Created"));
            VehRegLine.CALCFIELDS("GL Entry Created");
            //MESSAGE(FORMAT(VehRegLine."GL Entry Created"));
            IF (NOT VehRegLine."General Journal Created") AND (NOT VehRegLine."GL Entry Created") THEN BEGIN
              IF VehRegLine."Vehicle Tax" <> 0 THEN BEGIN
                 BalancingAmt += VehRegLine."Vehicle Tax";
                 GenJnlLine.INIT;
                 GenJnlLine."Journal Template Name" := JournalSetup."Gen. Journal Template Name";
                 GenJnlLine."Journal Batch Name" := JournalSetup."Gen. Journal Batch Name";
                 GenJnlLine."Line No." := LineNo;
                 GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                 GenJnlLine.VALIDATE("Account No.",GLSetup."Vehicle Tax");
                 GenJnlLine."Document No." := VehRegHdr."No.";
                 GenJnlLine.VALIDATE(Amount,VehRegLine."Vehicle Tax");
                 GenJnlLine.VALIDATE(VIN,VehRegLine.VIN);
                 GenJnlLine.INSERT(TRUE);
                 LineNo := LineNo + 10000;
              END;
              IF VehRegLine."Income Tax" <> 0 THEN BEGIN
                 BalancingAmt += VehRegLine."Income Tax";
                 GenJnlLine.INIT;
                 GenJnlLine."Journal Template Name" := JournalSetup."Gen. Journal Template Name";
                 GenJnlLine."Journal Batch Name" := JournalSetup."Gen. Journal Batch Name";
                 GenJnlLine."Line No." := LineNo;
                 GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                 GenJnlLine.VALIDATE("Account No.",GLSetup."Income Tax");
                 GenJnlLine."Document No." := VehRegHdr."No.";
                 GenJnlLine.VALIDATE(Amount,VehRegLine."Income Tax");
                 GenJnlLine.VALIDATE(VIN,VehRegLine.VIN);
                 GenJnlLine.INSERT(TRUE);
                 LineNo := LineNo + 10000;
              END;
              IF VehRegLine."Road Maintenance Fee" <> 0 THEN BEGIN
                 BalancingAmt += VehRegLine."Road Maintenance Fee";
                 GenJnlLine.INIT;
                 GenJnlLine."Journal Template Name" := JournalSetup."Gen. Journal Template Name";
                 GenJnlLine."Journal Batch Name" := JournalSetup."Gen. Journal Batch Name";
                 GenJnlLine."Line No." := LineNo;
                 GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                 GenJnlLine.VALIDATE("Account No.",GLSetup."Road Maintenance");
                 GenJnlLine."Document No." := VehRegHdr."No.";
                 GenJnlLine.VALIDATE(Amount,VehRegLine."Road Maintenance Fee");
                 GenJnlLine.VALIDATE(VIN,VehRegLine.VIN);
                 GenJnlLine.INSERT(TRUE);
                 LineNo := LineNo + 10000;
              END;
              IF VehRegLine."Registration Fee" <> 0 THEN BEGIN
                 BalancingAmt += VehRegLine."Registration Fee";
                 GenJnlLine.INIT;
                 GenJnlLine."Journal Template Name" := JournalSetup."Gen. Journal Template Name";
                 GenJnlLine."Journal Batch Name" := JournalSetup."Gen. Journal Batch Name";
                 GenJnlLine."Line No." := LineNo;
                 GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                 GenJnlLine.VALIDATE("Account No.",GLSetup."Registration Fee");
                 GenJnlLine."Document No." := VehRegHdr."No.";
                 GenJnlLine.VALIDATE(Amount,VehRegLine."Registration Fee");
                 GenJnlLine.VALIDATE(VIN,VehRegLine.VIN);
                 GenJnlLine.INSERT(TRUE);
                 LineNo := LineNo + 10000;
              END;
              IF VehRegLine."Ownership Transfer Fee" <> 0 THEN BEGIN
                 BalancingAmt += VehRegLine."Ownership Transfer Fee";
                 GenJnlLine.INIT;
                 GenJnlLine."Journal Template Name" := JournalSetup."Gen. Journal Template Name";
                 GenJnlLine."Journal Batch Name" := JournalSetup."Gen. Journal Batch Name";
                 GenJnlLine."Line No." := LineNo;
                 GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                 GenJnlLine.VALIDATE("Account No.",GLSetup."Ownership Transfer Fee");
                 GenJnlLine."Document No." := VehRegHdr."No.";
                 GenJnlLine.VALIDATE(Amount,VehRegLine."Ownership Transfer Fee");
                 GenJnlLine.VALIDATE(VIN,VehRegLine.VIN);
                 GenJnlLine.INSERT(TRUE);
                 LineNo := LineNo + 10000;
              END;
              IF VehRegLine."Other Fee" <> 0 THEN BEGIN
                 BalancingAmt += VehRegLine."Other Fee";
                 GenJnlLine.INIT;
                 GenJnlLine."Journal Template Name" := JournalSetup."Gen. Journal Template Name";
                 GenJnlLine."Journal Batch Name" := JournalSetup."Gen. Journal Batch Name";
                 GenJnlLine."Line No." := LineNo;
                 GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                 GenJnlLine.VALIDATE("Account No.",GLSetup."Other Fee");
                 GenJnlLine."Document No." := VehRegHdr."No.";
                 GenJnlLine.VALIDATE(Amount,VehRegLine."Other Fee");
                 GenJnlLine.VALIDATE(VIN,VehRegLine.VIN);
                 GenJnlLine.INSERT(TRUE);
                 LineNo := LineNo + 10000;
              END;
            END ELSE BEGIN
              ERROR('Either Journal Lines or g/l entry already exist for the VIN %1 of Document No. %2',VehRegLine.VIN,
                    VehRegLine."Document No.");
            END;
           UNTIL VehRegLine.NEXT = 0;

           IF BalancingAmt <> 0 THEN BEGIN
              GenJnlLine.INIT;
              GenJnlLine."Journal Template Name" := JournalSetup."Gen. Journal Template Name";
              GenJnlLine."Journal Batch Name" := JournalSetup."Gen. Journal Batch Name";
              GenJnlLine."Line No." := LineNo;
              GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
              GenJnlLine.VALIDATE("Account No.",GLSetup."Balancing A/c");
              GenJnlLine."Document No." := VehRegHdr."No.";
              GenJnlLine.VALIDATE(Amount,-BalancingAmt);
              GenJnlLine.INSERT(TRUE);
           END;
        MESSAGE('The Journal Lines have been created successfullly on Journal Template %1 and Journal Batch %2 !!!',
                JournalSetup."Gen. Journal Template Name",JournalSetup."Gen. Journal Batch Name");
        END;
    end;
}


table 33020179 "Vehicle Accessories Header"
{
    DrillDownPageID = 33020230;
    LookupPageID = 33020230;

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Vehicle Serial No."; Code[20])
        {
            TableRelation = Vehicle;
        }
        field(3; VIN; Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Editable = false;
                FieldClass = FlowField;
        }
        field(4; "Make Code"; Code[20])
        {
            CalcFormula = Lookup(Vehicle."Make Code" WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Editable = false;
                FieldClass = FlowField;
        }
        field(5; "Model Code"; Code[20])
        {
            CalcFormula = Lookup(Vehicle."Model Code" WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Editable = false;
                FieldClass = FlowField;
        }
        field(6; "Model Version No."; Code[20])
        {
            CalcFormula = Lookup(Vehicle."Model Version No." WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Editable = false;
                FieldClass = FlowField;
        }
        field(7; "Vendor Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(8; "Vendor Name"; Text[50])
        {
            CalcFormula = Lookup(Vendor.Name WHERE(No.=FIELD(Vendor Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;Description;Text[50])
        {
        }
        field(10;Approved;Boolean)
        {
            Editable = false;

            trigger OnValidate()
            begin
                IF Approved THEN BEGIN
                  Approver := USERID;
                  "Approved Date" := TODAY;
                END
                ELSE BEGIN
                  Approver := '';
                  "Approved Date" := 0D;
                END;
            end;
        }
        field(11;"Purchase Order Created";Boolean)
        {
            Editable = false;
        }
        field(12;"Accessories Issued";Boolean)
        {
            Editable = true;
        }
        field(13;"Responsibility Center";Code[10])
        {
            Editable = true;
            TableRelation = "Responsibility Center";
        }
        field(14;"Document Date";Date)
        {
            Editable = false;
        }
        field(15;"Posting Date";Date)
        {
            Editable = false;
        }
        field(16;"Assigned User ID";Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(17;"No. Series";Code[10])
        {
        }
        field(18;Approver;Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(19;"Approved Date";Date)
        {
        }
        field(20;"Purchase Order No.";Code[20])
        {
            Editable = false;
        }
        field(21;"Customer Code";Code[20])
        {
            TableRelation = Customer;
        }
        field(22;"Customer Name";Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE (No.=FIELD(Customer Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(23;"Re-Opened";Boolean)
        {
            Editable = false;
        }
        field(24;"Reason Code";Code[20])
        {
            TableRelation = "Veh. Accessories Reason Master";
        }
        field(25;"Total Cost";Decimal)
        {
            CalcFormula = Sum("Vehicle Accessories Line"."Line Amount" WHERE (Document No.=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(26;"Vendor Invoice No.";Code[20])
        {
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
        key(Key2;"Vehicle Serial No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.",VIN)
        {
        }
    }

    trigger OnInsert()
    begin
        SalesSetup.GET;
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
        SalesSetup: Record "311";
        NoSeriesMngt: Codeunit "396";
        UserSetup: Record "91";

    [Scope('Internal')]
    procedure AssistEdit(xVehAcc: Record "33020179"): Boolean
    begin
        SalesSetup.GET;
        TestNoSeries;
        IF NoSeriesMngt.SelectSeries(GetNoSeries,xVehAcc."No. Series","No. Series") THEN BEGIN
          SalesSetup.GET;
          TestNoSeries;
          NoSeriesMngt.SetSeries("No.");
          EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure TestNoSeries(): Boolean
    begin
        SalesSetup.TESTFIELD("Accessories Issue No. Series");
    end;

    [Scope('Internal')]
    procedure GetNoSeries(): Code[20]
    begin
        EXIT(SalesSetup."Accessories Issue No. Series");
    end;

    [Scope('Internal')]
    procedure PostDocument(var RecVehAccHeader: Record "33020179")
    var
        VehAccLine: Record "33020180";
        Text000: Label 'Accessories for Vehicle %1 has already been issued. You must Specify the Reason Code to proceed.';
    begin
        WITH RecVehAccHeader DO BEGIN
          TESTFIELD("Vehicle Serial No.");
          TESTFIELD("Vendor Code");
          IF (VerifySerialNo("Vehicle Serial No.")) AND ("Reason Code" = '')THEN
            ERROR(Text000,"Vehicle Serial No.");

          IF NOT Approved THEN
            ERROR('Accessories for Vehicle %1 must be approved before posting.',VIN);
          VehAccLine.RESET;
          VehAccLine.SETRANGE("Document No.","No.");
          IF VehAccLine.FINDSET THEN REPEAT
            VehAccLine.TESTFIELD(Quantity);
            VehAccLine.TESTFIELD("Direct Unit Cost");
          UNTIL VehAccLine.NEXT=0
          ELSE
            ERROR('Nothing to Post');

          "Accessories Issued" := TRUE;
          "Posting Date" := TODAY;
          MODIFY;

        END;
    end;

    [Scope('Internal')]
    procedure SetLineSelection(var RecVehAccHeader: Record "33020179"): Boolean
    var
        Status: Boolean;
        UserSetup: Record "91";
        VehAccLine: Record "33020180";
        Text000: Label 'Accessories for Vehicle %1 has already been issued. You must Specify the Reason Code to proceed.';
    begin
        UserSetup.GET(USERID);
        IF UserSetup."Vehicle Accessory Approver" THEN BEGIN
          IF RecVehAccHeader.FINDFIRST THEN
            REPEAT
              RecVehAccHeader.TESTFIELD("Vehicle Serial No.");
              RecVehAccHeader.TESTFIELD("Vendor Code");
              RecVehAccHeader.TESTFIELD(Approved,FALSE);
              IF (VerifySerialNo("Vehicle Serial No.")) AND ("Reason Code" = '')THEN
                ERROR(Text000,"Vehicle Serial No.");
              VehAccLine.RESET;
              VehAccLine.SETRANGE("Document No.",RecVehAccHeader."No.");
              IF VehAccLine.FINDSET THEN BEGIN
                REPEAT
                  VehAccLine.TESTFIELD(Quantity);
                UNTIL VehAccLine.NEXT=0;
                RecVehAccHeader.Approved :=TRUE;
                RecVehAccHeader.Approver := USERID;
                RecVehAccHeader."Approved Date" := TODAY;
                RecVehAccHeader.MODIFY;
                Status := TRUE;
              END
              ELSE
                ERROR('There are no lines to Approve in Document.');
            UNTIL RecVehAccHeader.NEXT=0;
            IF Status THEN
              EXIT(TRUE);
        END
        ELSE
          ERROR('You are not authorised to Approve the Issue of Accessories for Vehicle.');
    end;

    [Scope('Internal')]
    procedure CreatePurchaseOrder(var VehAccHeader: Record "33020179"): Boolean
    var
        PurchHeader: Record "38";
        PurchLine: Record "39";
        LastUsedLineNo: Integer;
        SalesSetup: Record "311";
        GLAccount: Code[20];
        NothingToPost: Label 'There is nothing to Create.';
        Text000: Label 'Purchase Order Created Successfully.';
        VehAccLine: Record "33020180";
        TotalCost: Decimal;
        Vehicle: Record "25006005";
        COGSType: Option " ","ACCESSORIES-CV","ACCESSORIES-PC","BANK CHARGE-CV","BANK CHARGE-PC","BATTERY-CV","BATTERY-PC","BODY BUILDING-CV","BODY BUILDING-PC","CHASSIS REGISTR-CV","CHASSIS REGISTR-PC","CLEARING & FORW-CV","CLEARING & FORW-PC","CUSTOM DUTY-CV","CUSTOM DUTY-PC","DENT / PENT-CV","DENT / PENT-PC","DRIVER-CV","DRIVER-PC","FOREIGN CHARGE-CV","FOREIGN CHARGE-PC","FUEL & OIL-CV","FUEL & OIL-PC","INSURANCE MANAG-CV","INSURANCE MANAG-PC","INSURANCE-CV","INSURANCE-PC",,"L/C & BANK CHAR-CV","L/C & BANK CHAR-PC","LUBRICANTS-CV","LUBRICANTS-PC","NEW CHASSIS REP-CV","NEW CHASSIS REP-PC","PARKING CHARGE-CV","PARKING CHARGE-PC","PRAGYANPAN-CV","PRAGYANPAN-PC","SERVICE CHARGE-CV","SERVICE CHARGE-PC","SPARES-CV","SPARES-PC","TRANSPORTATION-CV","TRANSPORTATION-PC","VEHICLE LOGISTI-CV","VEHICLE LOGISTI-PC","VEHICLE TAX-CV","VEHICLE TAX-PC";
        ShortcutDim5: Code[20];
    begin
        LastUsedLineNo := 0;
        //IF VehAccHeader.FINDFIRST THEN
        BEGIN
          // ***** CREATE PURCHASE HEADER ********
          VehAccHeader.TESTFIELD("Purchase Order Created",FALSE);
          VehAccHeader.TESTFIELD("Vendor Invoice No.");
          SalesSetup.GET;
          PurchHeader.RESET;
          CLEAR(PurchHeader);
          PurchHeader.INIT;
          PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
          PurchHeader."Order Type" := PurchHeader."Order Type"::" ";
          PurchHeader.INSERT(TRUE);
          PurchHeader.VALIDATE("Buy-from Vendor No.",VehAccHeader."Vendor Code");
          PurchHeader."Vendor Invoice No." := VehAccHeader."Vendor Invoice No.";
          PurchHeader."Veh. Accessories Document" := TRUE;
          PurchHeader."Veh. Accesories Memo No." := VehAccHeader."No.";
          PurchHeader.MODIFY(TRUE);
          TotalCost := 0;
          VehAccLine.RESET;
          VehAccLine.SETRANGE("Document No.",VehAccHeader."No.");
          IF VehAccLine.FINDSET THEN
          REPEAT
            TotalCost += VehAccLine."Line Amount";
          UNTIL VehAccLine.NEXT=0;
          // ***** CREATE PURCHASE LINE ************
          CLEAR(COGSType);
          PurchLine.INIT;
          PurchLine."Line No." := LastUsedLineNo + 10000;
          PurchLine."Document Type" := PurchHeader."Document Type";
          PurchLine.VALIDATE("Document No.",PurchHeader."No.");
          PurchLine.VALIDATE(Type,PurchLine.Type::"G/L Account");
          Vehicle.RESET;
          Vehicle.SETRANGE("Serial No.",VehAccHeader."Vehicle Serial No.");
          Vehicle.FINDFIRST;
          Vehicle.TESTFIELD("Make Code");
          IF Vehicle."Make Code" = 'TATA CVD' THEN BEGIN
            SalesSetup.TESTFIELD("Accessories CVD Account");
            GLAccount := SalesSetup."Accessories CVD Account";
            COGSType := COGSType::"ACCESSORIES-CV";
          END
          ELSE IF Vehicle."Make Code" = 'TATA PCD' THEN BEGIN
            SalesSetup.TESTFIELD("Accessories PCD Account");
            GLAccount := SalesSetup."Accessories PCD Account";
            COGSType := COGSType::"ACCESSORIES-PC";
          END;
          PurchLine.VALIDATE("No.",GLAccount);
          PurchLine.VALIDATE(Quantity,1);
          PurchLine.VALIDATE("Qty. to Receive",1);
          PurchLine.VALIDATE("Qty. to Invoice",1);
          PurchLine.VALIDATE("Direct Unit Cost",TotalCost);
          VehAccHeader.CALCFIELDS(VIN);
          PurchLine."VIN - COGS" := VehAccHeader.VIN;
          PurchLine."COGS Type" := COGSType;
          PurchLine.INSERT(TRUE);
          LastUsedLineNo := LastUsedLineNo + 10000;
          // Inserting Line-Item Dimension

          ShortcutDim5 :='ACCESSIORIES';
          PurchLine.ValidateShortcutDimCode(5,ShortcutDim5);
          PurchLine.MODIFY;
          IF Vehicle."Make Code" = 'TATA CVD' THEN BEGIN
            PurchHeader.VALIDATE("Shortcut Dimension 1 Code",'105');
            PurchHeader.VALIDATE("Shortcut Dimension 2 Code",'1010');
            PurchHeader.MODIFY;
            PurchLine.VALIDATE("Shortcut Dimension 1 Code",'105');
            PurchLine.VALIDATE("Shortcut Dimension 2 Code",'1010');
            PurchLine.MODIFY;
          END
          ELSE IF Vehicle."Make Code" = 'TATA PCD' THEN BEGIN
            PurchHeader.VALIDATE("Shortcut Dimension 1 Code",'106');
            PurchHeader.VALIDATE("Shortcut Dimension 2 Code",'1020');
            PurchHeader.MODIFY;
            PurchLine.VALIDATE("Shortcut Dimension 1 Code",'106');
            PurchLine.VALIDATE("Shortcut Dimension 2 Code",'1020');
            PurchLine.MODIFY;
          END;

          VehAccHeader."Purchase Order Created" := TRUE;
          VehAccHeader."Purchase Order No." := PurchHeader."No.";
          VehAccHeader.MODIFY;
          EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure ReOpenMemo(var VehAccHeader: Record "33020179")
    var
        UserSetup: Record "91";
        Text000: Label 'You do not have Permission to Re-Open Posted Accessories Memo.';
        Text001: Label 'Do you want to Re-Open the Posted Accessories Memo?';
    begin
        UserSetup.GET(USERID);
        IF UserSetup."Vehicle Accessory Approver" THEN BEGIN
        IF CONFIRM(Text001,TRUE) THEN BEGIN
          VehAccHeader.TESTFIELD("Purchase Order Created",FALSE);
          VehAccHeader.VALIDATE(Approved,FALSE);
          VehAccHeader.VALIDATE("Accessories Issued",FALSE);
          VehAccHeader."Posting Date" := 0D;
          VehAccHeader."Re-Opened" := TRUE;
          VehAccHeader.MODIFY;
        END;
        END
        ELSE
          ERROR(Text000);
    end;

    [Scope('Internal')]
    procedure VerifySerialNo(VehSerial: Code[20]): Boolean
    var
        VehAccHeader: Record "33020179";
    begin
        VehAccHeader.RESET;
        VehAccHeader.SETCURRENTKEY("Vehicle Serial No.");
        VehAccHeader.SETRANGE("Vehicle Serial No.",VehSerial);
        VehAccHeader.SETRANGE("Accessories Issued",TRUE);
        IF VehAccHeader.FINDSET THEN BEGIN
          EXIT(TRUE);
        END;
        EXIT(FALSE);
    end;
}


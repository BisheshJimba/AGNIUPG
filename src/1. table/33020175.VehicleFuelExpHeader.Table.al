table 33020175 "Vehicle Fuel Exp. Header"
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
                FuelExpLine.RESET;
                FuelExpLine.SETRANGE("Document No", "No.");
                IF FuelExpLine.FINDFIRST THEN
                    ERROR('Please delete Lines before modifying Vendor on Header.');
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
        field(11; "Fuel Expenses Charged"; Boolean)
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
        field(33019961; "Accountability Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1; "No.")
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
            NoSeriesMngt.InitSeries(GetNoSeries, xRec."No. Series", 0D, "No.", "No. Series");
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
        FuelExpLine: Record "33020176";

    [Scope('Internal')]
    procedure AssistEdit(xVehFuel: Record "33020175"): Boolean
    begin
        PurchSetup.GET;
        TestNoSeries;
        IF NoSeriesMngt.SelectSeries(GetNoSeries, xVehFuel."No. Series", "No. Series") THEN BEGIN
            PurchSetup.GET;
            TestNoSeries;
            NoSeriesMngt.SetSeries("No.");
            EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure TestNoSeries(): Boolean
    begin
        PurchSetup.TESTFIELD("Veh. Fuel Expense No. Series");
    end;

    [Scope('Internal')]
    procedure GetNoSeries(): Code[20]
    begin
        EXIT(PurchSetup."Veh. Fuel Expense No. Series");
    end;

    [Scope('Internal')]
    procedure PostDocument(var VehFuelExpense: Record "33020175")
    var
        Vehicle: Record "25006005";
        VehFuelLine: Record "33020176";
        Text000: Label 'Nothing to post.';
        Text001: Label 'There is no Vehicle with Serial No. %1 and VIN %2.';
        Text002: Label 'Document %1 posted successfully.';
        Text003: Label 'Total Qty. Issue must not be zero in Line No %1.';
        Coupon: Record "33020177";
    begin
        VehFuelExpense.TESTFIELD("Agent Code");
        VehFuelExpense.TESTFIELD("Document Date");
        VehFuelLine.RESET;
        VehFuelLine.SETRANGE("Document No", VehFuelExpense."No.");
        IF VehFuelLine.FINDSET THEN BEGIN
            REPEAT
                VehFuelLine.TESTFIELD("Coupon Code");
                IF (VehFuelLine.Type <> VehFuelLine.Type::Generator) THEN
                    VehFuelLine.TESTFIELD(VehFuelExpense."No.");
                IF (VehFuelLine."Quantity (Ltr.)") <= 0 THEN
                    ERROR(Text003, VehFuelLine."Line No.");
                Coupon.RESET;
                Coupon.SETRANGE("Petrol Pump Code", VehFuelLine."Petrol Pump Code");
                Coupon.SETRANGE("Coupon Code", VehFuelLine."Coupon Code");
                IF Coupon.FINDFIRST THEN BEGIN
                    Coupon.Issued := TRUE;
                    Coupon."Issued Date" := TODAY;
                    Coupon.MODIFY;
                END;
            UNTIL VehFuelLine.NEXT = 0;
            VehFuelExpense."Fuel Expenses Charged" := TRUE;
            VehFuelExpense."Posting Date" := TODAY;
            VehFuelExpense.MODIFY;
            MESSAGE(Text002, VehFuelExpense."No.");
        END
        ELSE
            ERROR(Text000);
    end;

    [Scope('Internal')]
    procedure CreatePurchOrder(var VehFuelHeader: Record "33020175")
    var
        LastUsedLineNo: Integer;
        PurchLine: Record "39";
        NothingToPost: Label 'There is nothing to Create.';
        VehFuelLine: Record "33020176";
        PurchSetup: Record "312";
        PurchHeader: Record "38";
        Text000: Label 'Purchase Order Created Successfully.';
        ChassisItemCharge: Code[20];
        TaxItemCharge: Code[20];
        Vehicle: Record "25006005";
    begin
        /*
        VehFuelHeader.TESTFIELD("Purchase Order Created",FALSE);
        // ***** CREATE PURCHASE HEADER ********
        PurchHeader.RESET;
        CLEAR(PurchHeader);
        PurchHeader.INIT;
        PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
        PurchHeader."Order Type" := PurchHeader."Order Type"::Normal;
        PurchHeader."Document Profile" := PurchHeader."Document Profile"::"Vehicles Trade";
        PurchHeader.INSERT(TRUE);
        PurchHeader.VALIDATE("Buy-from Vendor No.",VehFuelHeader."Agent Code");
        PurchHeader.MODIFY(TRUE);
        
        VehFuelLine.RESET;
        VehFuelLine.SETRANGE("Document No",VehFuelHeader."No.");
        IF VehFuelLine.FINDSET THEN BEGIN
          LastUsedLineNo := 0;
          REPEAT
            // ***** CREATE PURCHASE LINE ********
            CLEAR(PurchLine);
        //    Vehicle.GET(VehFuelLine."Serial No.");
            Vehicle.TESTFIELD("Make Code");
            PurchSetup.GET;
            IF Vehicle."Make Code" = 'TATA CVD' THEN BEGIN
              PurchSetup.TESTFIELD("Veh. Fuel Exp. Item Charge(CV)");
              ChassisItemCharge := PurchSetup."Veh. Fuel Exp. Item Charge(CV)";
            END
            ELSE IF Vehicle."Make Code" = 'TATA PCD' THEN BEGIN
              PurchSetup.TESTFIELD("Veh. Fuel Exp. Item Charge(PC)");
              ChassisItemCharge := PurchSetup."Veh. Fuel Exp. Item Charge(PC)";
            END;
        
            // ***** VEHICLE FUEL EXPENSES ************
            PurchLine.INIT;
            PurchLine."Line No." := LastUsedLineNo + 10000;
            PurchLine."Document Type" := PurchHeader."Document Type";
            PurchLine.VALIDATE("Document No.",PurchHeader."No.");
            PurchLine.VALIDATE(Type,PurchLine.Type::"Charge (Item)");
            PurchLine.VALIDATE("No.",ChassisItemCharge);
            PurchLine.VALIDATE("VIN - COGS",VehFuelLine.VIN);
            PurchLine.VALIDATE(Quantity,1);
            PurchLine.VALIDATE("Qty. to Receive",1);
            PurchLine.VALIDATE("Qty. to Invoice",1);
            PurchLine.VALIDATE("Direct Unit Cost",VehFuelLine."Fuel Expenses");
            PurchLine.INSERT(TRUE);
            LastUsedLineNo := LastUsedLineNo + 10000;
        
          UNTIL VehFuelLine.NEXT=0;
          VehFuelHeader."Purchase Order Created" := TRUE;
          VehFuelHeader.MODIFY;
          MESSAGE(Text000);
        END
        ELSE
          ERROR(NothingToPost);
        */

    end;

    [Scope('Internal')]
    procedure SetLineSelection(var FuelExpHeader: Record "33020175"): Boolean
    var
        PurchHeader: Record "38";
        PurchLine: Record "39";
        LastUsedLineNo: Integer;
        FuelExpLine: Record "33020176";
        PurchSetup: Record "312";
        Vehicle: Record "25006005";
        GLAccountNo: Code[20];
        NothingToPost: Label 'There is nothing to Create.';
        Text000: Label 'Purchase Order Created Successfully.';
        PetrolPump: Code[20];
        Vendor: Record "23";
    begin
        LastUsedLineNo := 0;
        IF FuelExpHeader.FINDFIRST THEN BEGIN
            // ***** CREATE PURCHASE HEADER ********
            FuelExpHeader.TESTFIELD("Purchase Order Created", FALSE);
            Vendor.GET(FuelExpHeader."Agent Code");
            IF Vendor.Internal THEN
                ERROR('Purchase Order cannot be created for Internal Vendor.');
            PurchSetup.GET;
            PurchHeader.RESET;
            CLEAR(PurchHeader);
            PurchHeader.INIT;
            PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
            PurchHeader."Order Type" := PurchHeader."Order Type"::" ";
            PurchHeader.INSERT(TRUE);
            PurchHeader.VALIDATE("Buy-from Vendor No.", FuelExpHeader."Agent Code");
            PetrolPump := FuelExpHeader."Agent Code";
            PurchHeader.MODIFY(TRUE);
            REPEAT
                FuelExpHeader.TESTFIELD("Purchase Order Created", FALSE);
                FuelExpLine.RESET;
                FuelExpLine.SETRANGE("Document No", FuelExpHeader."No.");
                IF FuelExpLine.FINDSET THEN BEGIN
                    REPEAT
                        // ***** CREATE PURCHASE LINE ************
                        FuelExpLine.TESTFIELD("Petrol Pump Code", PetrolPump);
                        PurchLine.INIT;
                        PurchLine."Line No." := LastUsedLineNo + 10000;
                        PurchLine."Document Type" := PurchHeader."Document Type";
                        PurchLine.VALIDATE("Document No.", PurchHeader."No.");
                        PurchLine.VALIDATE(Type, PurchLine.Type::"G/L Account");
                        CASE FuelExpLine.Type OF
                            FuelExpLine.Type::"New Vehicle":
                                BEGIN
                                    PurchSetup.TESTFIELD("New Vehicle Account (CVD)");
                                    PurchLine.VALIDATE("No.", PurchSetup."New Vehicle Account (CVD)");
                                    PurchLine.VALIDATE("VIN - COGS", FuelExpLine.VIN);
                                END;
                            FuelExpLine.Type::"Office Vehicle":
                                BEGIN
                                    PurchSetup.TESTFIELD("Office Vehicle Account");
                                    PurchLine.VALIDATE("No.", PurchSetup."Office Vehicle Account");
                                END;
                            FuelExpLine.Type::"Employee as Facility":
                                BEGIN
                                    PurchSetup.TESTFIELD("Employee as Facility Account");
                                    PurchLine.VALIDATE("No.", PurchSetup."Employee as Facility Account");
                                END;
                            FuelExpLine.Type::"Employee as Advance":
                                BEGIN
                                    PurchSetup.TESTFIELD("Employee as Facility Account");
                                    PurchLine.VALIDATE("No.", PurchSetup."Employee as Facility Account");
                                END;
                            FuelExpLine.Type::Generator:
                                BEGIN
                                    PurchSetup.TESTFIELD("Generator Account");
                                    PurchLine.VALIDATE("No.", PurchSetup."Generator Account");
                                END;
                        END;
                        PurchLine."Issue No." := FuelExpLine."Document No";
                        PurchLine."Issue Line No." := FuelExpLine."Line No.";
                        PurchLine.VALIDATE(Quantity, FuelExpLine."Quantity (Ltr.)");
                        PurchLine.VALIDATE("Qty. to Receive", FuelExpLine."Quantity (Ltr.)");
                        PurchLine.VALIDATE("Qty. to Invoice", FuelExpLine."Quantity (Ltr.)");
                        PurchLine.VALIDATE("Direct Unit Cost", FuelExpLine."Fuel Expenses (Unit Cost)");
                        PurchLine.INSERT(TRUE);
                        LastUsedLineNo := LastUsedLineNo + 10000;
                    UNTIL FuelExpLine.NEXT = 0;
                    FuelExpHeader."Purchase Order Created" := TRUE;
                    FuelExpHeader.MODIFY;
                END;

            UNTIL FuelExpHeader.NEXT = 0;
            EXIT(TRUE);
        END;
    end;
}


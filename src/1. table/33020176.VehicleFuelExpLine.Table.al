table 33020176 "Vehicle Fuel Exp. Line"
{

    fields
    {
        field(1; "Document No"; Code[20])
        {
            TableRelation = "Vehicle Registration Header".No.;
        }
        field(4; VIN; Code[20])
        {
            Caption = 'VIN';
            Editable = false;
        }
        field(5; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
        }
        field(6; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            Editable = false;
        }
        field(7; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            Editable = false;

            trigger OnLookup()
            var
                recItem: Record "27";
            begin
            end;
        }
        field(9; "DRP No./ARE1 No."; Code[20])
        {
            Editable = false;
        }
        field(10; "Engine No."; Code[20])
        {
            Editable = false;
        }
        field(11; "Petrol Pump Code"; Code[20])
        {
            Editable = false;
            TableRelation = Vendor;
        }
        field(12; "Petrol Pump Name"; Text[50])
        {
            CalcFormula = Lookup("Vehicle Fuel Exp. Header".Name WHERE(No.=FIELD(Document No)));
            Caption = 'Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13;Address;Text[50])
        {
            CalcFormula = Lookup("Vehicle Fuel Exp. Header".Address WHERE (No.=FIELD(Document No)));
            Caption = 'Address';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14;"Phone No.";Text[30])
        {
            CalcFormula = Lookup("Vehicle Fuel Exp. Header"."Phone No." WHERE (No.=FIELD(Document No)));
            Caption = 'Phone No.';
            Editable = false;
            ExtendedDatatype = PhoneNo;
            FieldClass = FlowField;
        }
        field(15;Description;Text[100])
        {
            CalcFormula = Lookup("Vehicle Fuel Exp. Header".Description WHERE (No.=FIELD(Document No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(16;"Document Date";Date)
        {
            CalcFormula = Lookup("Vehicle Fuel Exp. Header"."Document Date" WHERE (No.=FIELD(Document No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17;"Posting Date";Date)
        {
            CalcFormula = Lookup("Vehicle Fuel Exp. Header"."Posting Date" WHERE (No.=FIELD(Document No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18;"Assigned User ID";Code[50])
        {
            CalcFormula = Lookup("Vehicle Fuel Exp. Header"."Assigned User ID" WHERE (No.=FIELD(Document No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19;"Responsibility Center";Code[10])
        {
            CalcFormula = Lookup("Vehicle Fuel Exp. Header"."Responsibility Center" WHERE (No.=FIELD(Document No)));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Responsibility Center".Code;
        }
        field(20;"Fuel Expenses Charged";Boolean)
        {
            CalcFormula = Lookup("Vehicle Fuel Exp. Header"."Fuel Expenses Charged" WHERE (No.=FIELD(Document No)));
            FieldClass = FlowField;
        }
        field(50000;"Fuel Expenses (Unit Cost)";Decimal)
        {
        }
        field(50001;Type;Option)
        {
            OptionCaption = 'New Vehicle,Office Vehicle,Employee as Facility,Employee as Advance,Generator,Rented Vehicle,Demo Vehicle';
            OptionMembers = "New Vehicle","Office Vehicle","Employee as Facility","Employee as Advance",Generator,"Rented Vehicle","Demo Vehicle";

            trigger OnValidate()
            begin
                VALIDATE("No.");
            end;
        }
        field(50002;"Line No.";Integer)
        {
        }
        field(50003;"No.";Code[20])
        {
            TableRelation = IF (Type=CONST(New Vehicle)) Vehicle
                            ELSE IF (Type=CONST(Office Vehicle)) "Fixed Asset"
                            ELSE IF (Type=CONST(Employee as Facility)) "Dimension Value".Code WHERE (Dimension Code=CONST(EMPLOYEE))
                            ELSE IF (Type=CONST(Employee as Advance)) "Dimension Value".Code WHERE (Dimension Code=CONST(EMPLOYEE))
                            ELSE IF (Type=CONST(Demo Vehicle)) Vehicle;

            trigger OnValidate()
            begin
                VIN := '';
                "Make Code" := '';
                "Model Code" := '';
                "Model Version No." := '';
                "DRP No./ARE1 No." := '';
                "Engine No." := '';

                IF Type IN [Type::"New Vehicle",Type::"Demo Vehicle"] THEN BEGIN
                  IF Vehicle.GET("No.") THEN BEGIN
                    VIN := Vehicle.VIN;
                    "Make Code" := Vehicle."Make Code";
                    "Model Code" := Vehicle."Model Code";
                    "Model Version No." := Vehicle."Model Version No.";
                    "DRP No./ARE1 No." := Vehicle."DRP No./ARE1 No.";
                    "Engine No." := Vehicle."Engine No.";
                   END;
                END
            end;
        }
        field(50004;"Coupon Code";Code[20])
        {

            trigger OnLookup()
            var
                CouponList: Page "33020224";
            begin
                CLEAR(CouponList);
                RecCoupon.RESET;
                RecCoupon.SETRANGE("Petrol Pump Code","Petrol Pump Code");
                RecCoupon.SETRANGE(Issued,FALSE);
                RecCoupon.SETRANGE(Selected,FALSE);
                CouponList.SETTABLEVIEW(RecCoupon);
                CouponList.LOOKUPMODE(TRUE);
                IF CouponList.RUNMODAL = ACTION::LookupOK THEN
                BEGIN
                  CouponList.GETRECORD(RecCoupon);
                  VALIDATE("Coupon Code",RecCoupon."Coupon Code");
                END;
            end;

            trigger OnValidate()
            begin
                RecCoupon.RESET;
                RecCoupon.SETCURRENTKEY("Petrol Pump Code","Coupon Code",Issued);
                RecCoupon.SETRANGE("Petrol Pump Code","Petrol Pump Code");
                RecCoupon.SETRANGE("Coupon Code","Coupon Code");
                RecCoupon.SETRANGE(Issued,FALSE);
                IF NOT RecCoupon.FINDFIRST THEN
                  ERROR(Text000,"Coupon Code","Petrol Pump Code")
                ELSE BEGIN
                  IF RecCoupon.Selected = TRUE THEN
                    ERROR(Text001,RecCoupon."Coupon Code")
                  ELSE BEGIN
                    RecCoupon.Selected := TRUE;
                    RecCoupon.MODIFY;
                  END;
                END;
            end;
        }
        field(50005;Issued;Boolean)
        {
            CalcFormula = Lookup("Vehicle Fuel Exp. Header"."Fuel Expenses Charged" WHERE (No.=FIELD(Document No),
                                                                                           Agent Code=FIELD(Petrol Pump Code)));
            FieldClass = FlowField;
        }
        field(50006;"Quantity (Ltr.)";Decimal)
        {
        }
        field(50007;"Fuel Type";Option)
        {
            OptionCaption = ' ,Diesel,Petrol';
            OptionMembers = " ",Diesel,Petrol;
        }
        field(50008;"Purchase Order Created";Boolean)
        {
        }
        field(50009;Cancelled;Boolean)
        {
            Editable = false;

            trigger OnValidate()
            begin
                "Date of Cancellation" := 0D;
                "Cancelled By" := '';
                IF Cancelled THEN BEGIN
                  "Date of Cancellation" := TODAY;
                  "Cancelled By" := USERID;
                  MESSAGE('Coupon %1 is now cancelled.',"Coupon Code");
                END
                ELSE
                  MESSAGE('Coupon %1 is now Re-Opened.',"Coupon Code");
            end;
        }
        field(50010;"Date of Cancellation";Date)
        {
        }
        field(50011;"Cancelled By";Code[50])
        {
            TableRelation = "User Setup";
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1;"Document No","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        RecCoupon.RESET;
        RecCoupon.SETRANGE("Petrol Pump Code","Petrol Pump Code");
        RecCoupon.SETRANGE("Coupon Code","Coupon Code");
        IF RecCoupon.FINDFIRST THEN BEGIN
           RecCoupon.Selected := FALSE;
           RecCoupon.MODIFY;
        END;
    end;

    trigger OnInsert()
    begin
        FuelExpHeader.GET("Document No");
        VALIDATE("Petrol Pump Code",FuelExpHeader."Agent Code");
    end;

    trigger OnModify()
    begin
        IF "Coupon Code" <> xRec."Coupon Code" THEN BEGIN
          RecCoupon.RESET;
          RecCoupon.SETRANGE("Petrol Pump Code","Petrol Pump Code");
          RecCoupon.SETRANGE("Coupon Code",xRec."Coupon Code");
          IF RecCoupon.FINDFIRST THEN BEGIN
             RecCoupon.Selected := FALSE;
             RecCoupon.MODIFY;
          END;
        END;
    end;

    var
        FuelExpHeader: Record "33020175";
        RecCoupon: Record "33020177";
        Text000: Label 'Coupon Code %1 for Petrol Pump %2 is not Valid.';
        Vehicle: Record "25006005";
        Text001: Label 'Coupon Code %1 has already been selected.';
        Dimension: Record "348";

    [Scope('Internal')]
    procedure SetLineSelection(var FuelExpLine: Record "33020176"): Boolean
    var
        PurchHeader: Record "38";
        PurchLine: Record "39";
        LastUsedLineNo: Integer;
        PurchSetup: Record "312";
        Vehicle: Record "25006005";
        GLAccountNo: Code[20];
        NothingToPost: Label 'There is nothing to Create.';
        Text000: Label 'Purchase Order Created Successfully.';
        PetrolPump: Code[20];
        Vendor: Record "23";
    begin
        LastUsedLineNo := 0;
        IF FuelExpLine.FINDFIRST THEN BEGIN
          // ***** CREATE PURCHASE HEADER ********
          FuelExpLine.TESTFIELD("Purchase Order Created",FALSE);
          FuelExpLine.TESTFIELD(Cancelled,FALSE);
          Vendor.GET(FuelExpLine."Petrol Pump Code");
          IF Vendor.Internal THEN
            ERROR('Purchase Order cannot be created for Internal Vendor.');
          PurchSetup.GET;
          PurchHeader.RESET;
          CLEAR(PurchHeader);
          PurchHeader.INIT;
          PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
          PurchHeader."Order Type" := PurchHeader."Order Type"::" ";
          PurchHeader.INSERT(TRUE);
          PurchHeader.VALIDATE("Buy-from Vendor No.",FuelExpLine."Petrol Pump Code");
          PetrolPump := FuelExpLine."Petrol Pump Code";
          PurchHeader.MODIFY(TRUE);
          REPEAT
                // ***** CREATE PURCHASE LINE ************
                FuelExpLine.TESTFIELD("Petrol Pump Code",PetrolPump);
                FuelExpLine.TESTFIELD("Purchase Order Created",FALSE);
                FuelExpLine.TESTFIELD(Cancelled,FALSE);
                FuelExpLine.CALCFIELDS("Fuel Expenses Charged");
                FuelExpLine.TESTFIELD("Fuel Expenses Charged",TRUE);
                FuelExpLine.TESTFIELD("Fuel Expenses (Unit Cost)");
                PurchLine.INIT;
                PurchLine."Line No." := LastUsedLineNo + 10000;
                PurchLine."Document Type" := PurchHeader."Document Type";
                PurchLine.VALIDATE("Document No.",PurchHeader."No.");
                PurchLine.VALIDATE(Type,PurchLine.Type::"G/L Account");
                CASE FuelExpLine.Type OF
                  FuelExpLine.Type::"New Vehicle": BEGIN
                    Vehicle.RESET;
                    Vehicle.SETCURRENTKEY(VIN);
                    Vehicle.SETRANGE(VIN,FuelExpLine.VIN);
                    Vehicle.FINDFIRST;
                    IF Vehicle."Make Code" = 'TATA CVD' THEN BEGIN
                      PurchSetup.TESTFIELD("New Vehicle Account (CVD)");
                      PurchLine.VALIDATE("No.",PurchSetup."New Vehicle Account (CVD)");
                    END
                    ELSE IF Vehicle."Make Code" = 'TATA PCD' THEN BEGIN
                      PurchSetup.TESTFIELD("New Vehicle Account (PCD)");
                      PurchLine.VALIDATE("No.",PurchSetup."New Vehicle Account (PCD)");
                    END;
                    PurchLine.VALIDATE("VIN - COGS",FuelExpLine.VIN);
                  END;
                  FuelExpLine.Type::"Office Vehicle": BEGIN
                    PurchSetup.TESTFIELD("Office Vehicle Account");
                    PurchLine.VALIDATE("No.",PurchSetup."Office Vehicle Account");
                  END;
                  FuelExpLine.Type::"Employee as Facility": BEGIN
                    PurchSetup.TESTFIELD("Employee as Facility Account");
                    PurchLine.VALIDATE("No.",PurchSetup."Employee as Facility Account");
                  END;
                  FuelExpLine.Type::"Employee as Advance": BEGIN
                    PurchSetup.TESTFIELD("Employee as Facility Account");
                    PurchLine.VALIDATE("No.",PurchSetup."Employee as Facility Account");
                  END;
                  FuelExpLine.Type::Generator: BEGIN
                    PurchSetup.TESTFIELD("Generator Account");
                    PurchLine.VALIDATE("No.",PurchSetup."Generator Account");
                  END;
                  FuelExpLine.Type::"Rented Vehicle": BEGIN
                    PurchSetup.TESTFIELD("Rented Vehicle Account");
                    PurchLine.VALIDATE("No.",PurchSetup."Rented Vehicle Account");
                  END;

                END;
                PurchLine."Issue No." := FuelExpLine."Document No";
                PurchLine."Issue Line No." := FuelExpLine."Line No.";
                PurchLine.VALIDATE(Quantity,FuelExpLine."Quantity (Ltr.)");
                PurchLine.VALIDATE("Qty. to Receive",FuelExpLine."Quantity (Ltr.)");
                PurchLine.VALIDATE("Qty. to Invoice",FuelExpLine."Quantity (Ltr.)");
                PurchLine.VALIDATE("Direct Unit Cost",FuelExpLine."Fuel Expenses (Unit Cost)");
                PurchLine.INSERT(TRUE);
                IF (FuelExpLine.Type = FuelExpLine.Type::"Employee as Facility") OR
                  (FuelExpLine.Type = FuelExpLine.Type::"Employee as Advance")  THEN BEGIN

                  //ZM Oct, 2016 >>
                  Dimension.RESET;
                  Dimension.SETRANGE(Code,'Employee');
                  Dimension.FINDFIRST;
                  //ZM Oct, 2016 <<
                  PurchLine.ValidateShortcutDimCode(3,FuelExpLine."No.");
                  PurchLine.MODIFY;

                END;

                LastUsedLineNo := LastUsedLineNo + 10000;
                FuelExpLine."Purchase Order Created" := TRUE;
                FuelExpLine.MODIFY;
          UNTIL FuelExpLine.NEXT=0;
          EXIT(TRUE);
        END;
    end;
}


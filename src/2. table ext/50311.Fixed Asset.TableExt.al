tableextension 50311 tableextension50311 extends "Fixed Asset"
{
    // 05.03.2014 Elva Baltic P7 #S0017 MMG7.00
    //   * Added fields:
    //     - "Sales Date"
    //     - "Fuel Type"
    // 
    // 04.03.2014 Elva Baltic P7 #S0017 MMG7.00
    //   * Added fields:
    //     - "Vehicle Serial No."
    //     - "VIN"
    //     - "Make Code"
    //     - "Model Code"
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Description 2"(Field 4)".


        //Unsupported feature: Property Modification (Name) on ""Warranty Date"(Field 15)".


        //Unsupported feature: Property Modification (CalcFormula) on "Insured(Field 19)".


        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 20)".


        //Unsupported feature: Property Modification (CalcFormula) on "Acquired(Field 30)".



        //Unsupported feature: Code Modification on ""FA Subclass Code"(Field 6).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        FASubclass.GET("FA Subclass Code");
        IF "FA Class Code" <> '' THEN BEGIN
          IF FASubclass."FA Class Code" IN ['',"FA Class Code"] THEN
        #4..6
        END;

        VALIDATE("FA Class Code",FASubclass."FA Class Code");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //FASubclass.RESET;
        FASubclass.SETRANGE(Code,"FA Subclass Code");
        IF FASubclass.FINDFIRST THEN BEGIN
          VALIDATE("FA Class Code",FASubclass."FA Class Code");
          FADepreBook.RESET;
          FADepreBook.SETRANGE("FA No.","No.");

          IF FADepreBook.FINDFIRST THEN BEGIN
            FADepreBook.VALIDATE("Depreciation Book Code",FASubclass."Depreciation Book");
            FADepreBook.VALIDATE("Depreciation Method",FASubclass."Depreciation Method");
            FADepreBook.VALIDATE("FA Posting Group",FASubclass."FA Posting Group");
            IF FASubclass."Depreciation Method" = FASubclass."Depreciation Method"::"Straight-Line" THEN
              FADepreBook.VALIDATE("Straight-Line %",FASubclass."Depreciation Rate");
            IF FASubclass."Depreciation Method" = FASubclass."Depreciation Method"::"Declining-Balance 1" THEN
              FADepreBook.VALIDATE("Declining-Balance %",FASubclass."Depreciation Rate");
            FADepreBook.MODIFY;
          END;

          IF NOT FADepreBook.FINDFIRST THEN BEGIN
            FADepreBook.INIT;
            FADepreBook.VALIDATE("FA No.","No.");
            FADepreBook.VALIDATE("Depreciation Book Code",FASubclass."Depreciation Book");
            FADepreBook.VALIDATE("Depreciation Method",FASubclass."Depreciation Method");
            FADepreBook.VALIDATE("FA Posting Group",FASubclass."FA Posting Group");
            IF FASubclass."Depreciation Method" = FASubclass."Depreciation Method"::"Straight-Line" THEN
              FADepreBook.VALIDATE("Straight-Line %",FASubclass."Depreciation Rate");
            IF FASubclass."Depreciation Method" = FASubclass."Depreciation Method"::"Declining-Balance 1" THEN
              FADepreBook.VALIDATE("Declining-Balance %",FASubclass."Depreciation Rate");
            FADepreBook.INSERT;
          END;
        END;

        #1..9
        */
        //end;

        //Unsupported feature: Property Deletion (Editable) on ""Main Asset/Component"(Field 12)".

        field(47; "Tariff No."; Code[20])
        {
            Caption = 'Tariff No.';
            TableRelation = "Tariff Number";

            trigger OnValidate()
            begin
                IF "Tariff No." <> '' THEN
                    IF NOT TariffNumber.GET("Tariff No.") THEN
                        ERROR('The HS Code does not exist.')
            end;
        }
        field(50001; "FA QR Text"; Text[250])
        {
        }
        field(50002; "QR Blob"; BLOB)
        {
        }
        field(50003; "Seat Capacity"; Integer)
        {
            Description = 'Fo Model Version';
        }
        field(25006000; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle."Serial No.";

            trigger OnValidate()
            begin
                IF Vehicle.GET(xRec."Vehicle Serial No.") THEN BEGIN
                    Vehicle."Fixed Asset No." := '';
                    Vehicle.MODIFY;
                END;
                IF Vehicle.GET("Vehicle Serial No.") THEN BEGIN
                    Vehicle."Fixed Asset No." := "No.";
                    Vehicle.MODIFY;
                END;
                CALCFIELDS(VIN, "Make Code", "Model Code", "Sales Date", "Fuel Type");
            end;
        }
        field(25006001; VIN; Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Caption = 'VIN';
                Editable = false;
                FieldClass = FlowField;
        }
        field(25006002; "Make Code"; Code[20])
        {
            CalcFormula = Lookup(Vehicle."Make Code" WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Caption = 'Make Code';
                Editable = false;
                FieldClass = FlowField;
        }
        field(25006003; "Model Code"; Code[20])
        {
            CalcFormula = Lookup(Vehicle."Serial No." WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Caption = 'Model Code';
                Editable = false;
                FieldClass = FlowField;
        }
        field(25006004; "Sales Date"; Date)
        {
            CalcFormula = Lookup(Vehicle."Sales Date" WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Caption = 'Sales Date';
                Editable = false;
                FieldClass = FlowField;
        }
        field(25006005; "Fuel Type"; Code[20])
        {
            CalcFormula = Lookup(Vehicle."Variable Field 25006800" WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Caption = 'Fuel Type';
                Editable = false;
                FieldClass = FlowField;
        }
        field(33019884; "Old FA No."; Code[20])
        {
        }
        field(33019885; "Depreciation Date"; Date)
        {
            CalcFormula = Lookup("FA Depreciation Book"."Depreciation Starting Date" WHERE(FA No.=FIELD(No.)));
            FieldClass = FlowField;
        }
        field(33019886;"Purchase Order No.";Code[20])
        {
            FieldClass = Normal;
        }
        field(33019887;"Vendor Invoice No.";Code[20])
        {
        }
        field(33019888;"Bill Amount Ex. VAT";Decimal)
        {
        }
        field(33019890;"Insurance Expiry Date";Date)
        {
        }
        field(33019891;Kilometrage;Decimal)
        {
        }
        field(33019892;"Renewal Date";Date)
        {
        }
        field(33019893;"Disposal Date";Date)
        {
            CalcFormula = Max("FA Depreciation Book"."Disposal Date" WHERE (FA No.=FIELD(No.)));
            FieldClass = FlowField;
        }
        field(33019894;Saved;Boolean)
        {
        }
        field(33019895;"Core Assets";Boolean)
        {
        }
        field(33019896;"Depreciation Method";Option)
        {
            Caption = 'Depreciation Method';
            OptionCaption = 'Straight-Line,Declining-Balance 1,Declining-Balance 2,DB1/SL,DB2/SL,User-Defined,Manual';
            OptionMembers = "Straight-Line","Declining-Balance 1","Declining-Balance 2","DB1/SL","DB2/SL","User-Defined",Manual;
        }
        field(33019897;"Straight-Line %";Decimal)
        {
            Caption = 'Straight-Line %';
            MinValue = 0;
        }
        field(33019898;"Declining-Balance %";Decimal)
        {
            Caption = 'Declining-Balance %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(33019899;"Depreciation Starting Date";Decimal)
        {
        }
        field(33019900;"Responsible Employee Name";Text[100])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE (No.=FIELD(Responsible Employee)));
            FieldClass = FlowField;
        }
        field(33019901;"Blue Book Renew Date";Date)
        {
        }
        field(33019902;"Tax Renew Date";Date)
        {
        }
        field(33019903;"Engine No.";Code[30])
        {
        }
        field(33019904;"VIN No.";Code[30])
        {
        }
        field(33019905;"Responsible Department";Code[10])
        {
            TableRelation = "Location Master";
        }
        field(33019906;"Disposal Invoice No.";Code[15])
        {
            CalcFormula = Max("FA Ledger Entry"."Document No." WHERE (FA No.=FIELD(No.),
                                                                      FA Posting Type=FILTER(Gain/Loss)));
            FieldClass = FlowField;
        }
        field(33019907;"Vehicle Registration Number";Code[30])
        {
        }
        field(33019908;"HS Code";Code[20])
        {
            TableRelation = "Tariff Number";
        }
    }
    keys
    {
        key(Key1;"FA Location Code","Responsible Employee")
        {
        }
        key(Key2;"Responsible Employee","FA Location Code")
        {
        }
    }


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Last Date Modified" := TODAY;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        "Last Date Modified" := TODAY;
        IF Saved THEN BEGIN
          UserSetup.GET(USERID); //MIN 4/30/2019
          IF NOT UserSetup."Can Edit Fixed Assets Card" THEN
           ERROR(NoModifyPermissionErr);
        END;
        */
    //end;

    var
        Vehicle: Record "25006005";
        OKConfirm: Boolean;
        Text26512: Label 'Do you want to assign new %1 %2 to Fixed Asset %3?';
        Text26513: Label 'Selected Fixed Asset %1 is disposed and FA Location/Responsible Employee cannot be assigned to it.';
        Text26514: Label 'Do you want to print FA assignment\discharge report?';
        FASubclass: Record "5608";
        FADepreBook: Record "5612";
        NoModifyPermissionErr: Label 'You do not have permission to modify Fixed Assets Card.';
        UserSetup: Record "91";
        "Depreciation Ending Date": Record "5611";
        TariffNumber: Record "260";
        "Tariff No.": Code[10];
}


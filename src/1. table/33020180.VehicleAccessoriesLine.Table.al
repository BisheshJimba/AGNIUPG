table 33020180 "Vehicle Accessories Line"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Accessory Code"; Code[50])
        {
            TableRelation = "Own Option"."Option Code";

            trigger OnLookup()
            var
                OwnOptions: Page "25006499";
                VehAccHeader: Record "33020179";
            begin
                VehAccHeader.GET("Document No.");
                OwnOption.RESET;
                //**SM 26-06-2013 to get the own options of the particula make and model
                VehAccHeader.RESET;
                VehAccHeader.SETRANGE("No.", "Document No.");
                IF VehAccHeader.FINDFIRST THEN BEGIN
                    VehAccHeader.CALCFIELDS("Make Code");
                    VehAccHeader.CALCFIELDS("Model Code");
                    OwnOption.SETRANGE("Make Code", VehAccHeader."Make Code");
                    OwnOption.SETRANGE("Model Code", VehAccHeader."Model Code");
                    CLEAR(OwnOptions);
                    OwnOptions.SETTABLEVIEW(OwnOption);
                    OwnOptions.LOOKUPMODE(TRUE);
                    IF OwnOptions.RUNMODAL = ACTION::LookupOK THEN BEGIN
                        OwnOptions.GETRECORD(OwnOption);
                        VALIDATE("Accessory Code", OwnOption."Option Code");
                        //OwnOption.TESTFIELD("Unit Cost");
                        //validate("Direct Unit Cost",OwnOption."Unit Cost");
                        //Description := OwnOption.Description;
                    END;
                END;
            end;

            trigger OnValidate()
            begin
                VehAccHeader.GET("Document No.");
                IF VehAccHeader.Approved THEN
                    ERROR('You cannot add/modify Accessories after approval has been made.');
                Description := '';
                VALIDATE("Direct Unit Cost", 0);
                OwnOption.RESET;
                //**SM 26-06-2013 to get the own options of the particula make and model
                VehAccHeader.RESET;
                VehAccHeader.SETRANGE("No.", "Document No.");
                IF VehAccHeader.FINDFIRST THEN BEGIN
                    VehAccHeader.CALCFIELDS("Make Code");
                    VehAccHeader.CALCFIELDS("Model Code");
                    OwnOption.SETRANGE("Make Code", VehAccHeader."Make Code");
                    OwnOption.SETRANGE("Model Code", VehAccHeader."Model Code");
                    OwnOption.SETRANGE("Option Code", "Accessory Code");
                    IF OwnOption.FINDFIRST THEN BEGIN
                        OwnOption.TESTFIELD("Unit Cost");
                        Description := OwnOption.Description;
                        VALIDATE("Direct Unit Cost", OwnOption."Unit Cost");
                    END;
                END;
            end;
        }
        field(4; Description; Text[30])
        {
        }
        field(5; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TESTFIELD("Accessory Code");
                VehAccHeader.GET("Document No.");
                IF VehAccHeader.Approved THEN
                    ERROR('You cannot modify Quantity after approval has been made.');
                "Line Amount" := Quantity * "Direct Unit Cost";
            end;
        }
        field(6; "Direct Unit Cost"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD("Accessory Code");
                "Line Amount" := Quantity * "Direct Unit Cost";
            end;
        }
        field(7; "Accessories Status"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Added,Modified';
            OptionMembers = " ",Added,Modified;
        }
        field(8; "Line Amount"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Line Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        VehAccHeader.GET("Document No.");
        IF VehAccHeader."Re-Opened" THEN
            "Accessories Status" := "Accessories Status"::Added;
    end;

    trigger OnModify()
    begin
        //after approve no allow to change lines.
    end;

    var
        VehAccHeader: Record "33020179";
        OwnOption: Record "25006372";
}


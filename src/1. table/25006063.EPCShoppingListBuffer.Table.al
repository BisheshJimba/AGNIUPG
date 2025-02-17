table 25006063 "EPC Shopping List Buffer"
{

    fields
    {
        field(10; "Entry No."; Integer)
        {
        }
        field(20; "Entry Type"; Option)
        {
            OptionMembers = Header,Line;
        }
        field(30; "File Name"; Text[250])
        {
            Description = 'XFR_FILE_NAME';
        }
        field(40; "User Name"; Text[20])
        {
            Description = 'USER_NAME';
        }
        field(50; "Shopping List Name"; Text[30])
        {
            Description = 'SHOPPINGLIST_NAME';
        }
        field(60; "Item No."; Code[20])
        {
            Description = 'PART_NUMBER';
        }
        field(70; Description; Text[100])
        {
            Description = 'PART_DESCRIPTION';
        }
        field(80; Quantity; Decimal)
        {
            Description = 'QUANTITY';
        }
        field(90; "VIN or Model No."; Code[20])
        {
            Description = 'MODEL_CHASSIS';
        }
        field(100; "Gratuity Code"; Code[10])
        {
            Description = 'GRATUITY_CODE';
        }
        field(110; "Supplementary Text"; Text[250])
        {
            Description = 'SUPPLEMENTARY_TEXT';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


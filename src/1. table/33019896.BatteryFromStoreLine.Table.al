table 33019896 "Battery From Store Line"
{

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Battery Part No."; Code[20])
        {
            TableRelation = Item.No. WHERE(Item Category Code=CONST(BATTERY));

            trigger OnLookup()
            begin

                Item.RESET;
                IF LookUpMgt.LookUpBatteryItems(Item, "Battery Part No.") THEN
                    VALIDATE("Battery Part No.", Item."No.");
            end;
        }
        field(3; Quantity; Integer)
        {
        }
        field(4; Confirmation; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "No.", "Battery Part No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Item: Record "27";
        LookUpMgt: Codeunit "25006003";
        UserSetup: Record "91";
        SerMgtSetup: Record "5911";
        NoSeriesMgmt: Codeunit "396";
}


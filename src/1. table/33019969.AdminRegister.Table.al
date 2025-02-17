table 33019969 "Admin. Register"
{
    Caption = 'F/L Register';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Creation Date"; Date)
        {
        }
        field(4; "Source Code"; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(5; "Journal Batch Name"; Code[10])
        {
        }
        field(6; "User ID"; Code[50])
        {
        }
        field(7; "From Entry No."; Integer)
        {
        }
        field(8; "To Entry No."; Integer)
        {
        }
        field(9; "Responsibility Center"; Code[10])
        {
            Editable = false;
        }
        field(10; "Entry From"; Option)
        {
            OptionCaption = ' ,Fuel,Courier,Misellaneous';
            OptionMembers = " ",Fuel,Courier,Misellaneous;
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
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

    var
        LastEntryNo: Integer;
}


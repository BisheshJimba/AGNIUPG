table 346 "Application Area Line"
{
    Caption = 'Application Area Line';

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(2; ID; Integer)
        {
            Caption = 'ID';
            Editable = false;
            TableRelation = AllObj."Object ID" where("Object Type" = const(Table));
        }
        field(3; Name; Text[80])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(4; "No. of Licensed Tables"; Integer)
        {
            Caption = 'No. of Licensed Tables';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count("Setup Checklist Line" where("Application Area ID" = field(ID), "Licensed Table" = const(true)));
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
        key(Key2; "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}


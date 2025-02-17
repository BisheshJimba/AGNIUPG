table 25006027 "Proc. Checklist Template Line"
{
    Caption = 'Questionary Template Subject Group';
    DrillDownPageID = 25006020;
    LookupPageID = 25006020;

    fields
    {
        field(10; "Template Code"; Code[20])
        {
            Caption = 'Template Code';
            TableRelation = "Process Checklist Template";
        }
        field(20; "Line No."; Integer)
        {
        }
        field(30; "Type Code"; Code[20])
        {
            Caption = 'Type Code';
            TableRelation = "Variable Field";
        }
        field(40; Description; Text[30])
        {
            CalcFormula = Lookup("Variable Field".Caption WHERE(Code = FIELD("Type Code")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Template Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


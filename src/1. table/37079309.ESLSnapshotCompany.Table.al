table 37079309 "ESL Snapshot Company"
{
    Caption = 'Snapshot Company';
    DataPerCompany = false;
    DrillDownPageID = 37079309;
    LookupPageID = 37079309;

    fields
    {
        field(1; Name; Text[30])
        {
            Caption = 'Name';
        }
        field(1001; "Snapshot No."; Code[20])
        {
            Caption = 'Snapshot No.';
            NotBlank = true;
            TableRelation = Table37079302.Field1;
        }
        field(1002; "Exists in Live"; Boolean)
        {
            CalcFormula = Exist(Company WHERE(Name = FIELD(Name)));
            Caption = 'Exists in Live';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1005; "Created Date Time"; DateTime)
        {
            CalcFormula = Lookup(Table37079302.Field4 WHERE(Field1 = FIELD(Snapshot No.)));
            Caption = 'Created Date Time';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Snapshot No.", Name)
        {
            Clustered = true;
        }
        key(Key2; Name)
        {
        }
    }

    fieldgroups
    {
    }
}


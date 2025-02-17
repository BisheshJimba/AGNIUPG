table 25006276 "Resource Work Time Entry"
{
    Caption = 'Resource Work Time Entry';
    DrillDownPageID = 25006359;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;
        }
        field(3; "Worktime Begin"; Decimal)
        {
            AutoFormatExpression = 'DATETIME';
            AutoFormatType = 10;
            Caption = 'Worktime Begin';
        }
        field(4; "Worktime End"; Decimal)
        {
            AutoFormatExpression = 'DATETIME';
            AutoFormatType = 10;
            Caption = 'Worktime End';
        }
        field(5; "Worked Hours"; Decimal)
        {
            Caption = 'Worked Hours';
            DecimalPlaces = 0 : 5;
        }
        field(6; Closed; Boolean)
        {
            Caption = 'Closed';
        }
        field(101; "Resource Name"; Text[30])
        {
            CalcFormula = Lookup(Resource.Name WHERE(No.=FIELD(Resource No.)));
            Caption = 'Resource Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Resource No.","Worktime Begin")
        {
            SumIndexFields = "Worked Hours";
        }
        key(Key3;"Resource No.",Closed,"Worktime End")
        {
            SumIndexFields = "Worked Hours";
        }
    }

    fieldgroups
    {
    }
}


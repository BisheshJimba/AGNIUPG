table 33020508 "Employee Advance Register"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*

    DrillDownPageID = 33020508;
    LookupPageID = 33020508;

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Employee Code"; Code[20])
        {
            TableRelation = Employee;
        }
        field(3; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(4; Amount; Decimal)
        {
        }
        field(5; "G/L Entry No."; Integer)
        {
            TableRelation = "G/L Entry";
        }
        field(6; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(7; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = Table2000000002;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "418";
            begin
            end;
        }
        field(8; "Document No."; Code[20])
        {
        }
        field(50; "Remaining Amount"; Decimal)
        {
            CalcFormula = Sum("Employee Advance Register".Amount WHERE(Employee Code=FIELD(Employee Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51;"Employee Name";Text[100])
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Employee Code")
        {
            SumIndexFields = Amount;
        }
        key(Key3;"Document No.","Creation Date")
        {
        }
    }

    fieldgroups
    {
    }
}


table 33020509 "Employee Loan Register"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*

    DrillDownPageID = 33020509;
    LookupPageID = 33020509;

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
            TableRelation = User;
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
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document No.", "Creation Date")
        {
        }
    }

    fieldgroups
    {
    }
}


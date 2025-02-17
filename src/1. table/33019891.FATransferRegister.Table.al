table 33019891 "FA Transfer Register"
{

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "FA No."; Code[20])
        {
        }
        field(3; Date; DateTime)
        {
        }
        field(4; "From Location Code"; Code[20])
        {
        }
        field(5; "To Location Code"; Code[20])
        {
        }
        field(6; Reason; Text[100])
        {
        }
        field(7; Remarks; Text[100])
        {
        }
        field(8; "From Responsible Emp"; Code[20])
        {
        }
        field(9; "To Responsible Emp"; Code[20])
        {
        }
        field(10; "User ID"; Code[50])
        {
        }
        field(11; Description; Text[50])
        {
            CalcFormula = Lookup("FA Location".Name WHERE(Code = FIELD(From Location Code)));
            FieldClass = FlowField;
        }
        field(12; "To Description"; Text[50])
        {
            CalcFormula = Lookup("FA Location".Name WHERE(Code = FIELD(To Location Code)));
            FieldClass = FlowField;
        }
        field(13; "From Emp Description"; Text[30])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE(No.=FIELD(From Responsible Emp)));
                FieldClass = FlowField;
        }
        field(14; "To Emp Description"; Text[30])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE(No.=FIELD(To Responsible Emp)));
                FieldClass = FlowField;
        }
        field(15; "FA Description"; Text[100])
        {
        }
        field(16; "FA Description2"; Text[100])
        {
        }
        field(17; "From Branch"; Code[20])
        {
        }
        field(18; "To Branch"; Code[20])
        {
        }
        field(50000; "To Location"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "No.", "FA No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        "User ID" := USERID;
    end;
}


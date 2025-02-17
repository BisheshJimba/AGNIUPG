table 33020076 "Captured Vehicle Activities"
{

    fields
    {
        field(1; "Loan No."; Code[20])
        {
            TableRelation = "Vehicle Finance Header"."Loan No.";
        }
        field(2; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(3; Date; Date)
        {
        }
        field(4; "User ID"; Code[30])
        {
        }
        field(5; "Action Taken"; Text[250])
        {
        }
        field(6; Remarks; Text[250])
        {
        }
        field(7; "Customer Name"; Text[50])
        {
            CalcFormula = Lookup("Vehicle Finance Header"."Customer Name" WHERE(Loan No.=FIELD(Loan No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Next Activity Date";Date)
        {
        }
        field(9;"Next Activity";Option)
        {
            OptionMembers = " ","35 Days Letter Issue","Public Notice Issue","Sales Notice";
        }
        field(10;"From Location";Text[150])
        {
        }
        field(11;"To Location";Text[150])
        {
        }
    }

    keys
    {
        key(Key1;"Loan No.","Entry No.")
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
        Date := TODAY;
    end;
}


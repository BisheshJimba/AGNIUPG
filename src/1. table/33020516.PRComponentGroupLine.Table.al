table 33020516 "PR Component Group Line"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*


    fields
    {
        field(1; "Component Group Code"; Code[20])
        {
            TableRelation = "PR Component Group";
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Component Code"; Code[20])
        {
            TableRelation = "Payroll Component";

            trigger OnValidate()
            begin
                "Component Description" := '';
                CLEAR(Type);
                Subtype := Subtype::" ";

                IF PayrollComponent.GET("Component Code") THEN BEGIN
                    "Component Description" := PayrollComponent.Description;
                    Type := PayrollComponent.Type;
                    Subtype := PayrollComponent.Subtype;
                END;
            end;
        }
        field(4; "Component Description"; Text[100])
        {
            Editable = false;
        }
        field(5; Type; Option)
        {
            Editable = false;
            OptionCaption = 'Benefits,Deduction,Employer Contribution';
            OptionMembers = Benefits,Deduction,"Employer Contribution";
        }
        field(6; Subtype; Option)
        {
            Editable = false;
            OptionCaption = ' ,Retirement,Advance,Loan';
            OptionMembers = " ",Retirement,Advance,Loan;
        }
    }

    keys
    {
        key(Key1; "Component Group Code", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Component Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PayrollComponent: Record "33020503";
}


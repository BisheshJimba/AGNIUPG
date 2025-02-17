table 33020348 "Work Shift Master"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Code"; Code[10])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "In Time"; Time)
        {

            trigger OnValidate()
            begin
                //"Work Hours" := ("Out Time" - "In Time")/(1000*60*60);
            end;
        }
        field(4; "Out Time"; Time)
        {

            trigger OnValidate()
            begin
                //"Work Hours" := ("Out Time" - "In Time")/(1000*60*60);
            end;
        }
        field(5; "Work Hours"; Decimal)
        {
        }
        field(6; "Lunch Start"; Time)
        {

            trigger OnValidate()
            begin
                //"Lunch Minute" := ("Lunch End" - "Lunch Start")/(1000*60);
            end;
        }
        field(7; "Lunch End"; Time)
        {

            trigger OnValidate()
            begin
                //"Lunch Minute" := ("Lunch End" - "Lunch Start")/(1000*60);
            end;
        }
        field(8; "Lunch Minute"; Integer)
        {
        }
        field(9; Blocked; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


table 33020340 "Recruitment Partner"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Name; Text[100])
        {

            trigger OnValidate()
            begin
                "Search Name" := Code;
            end;
        }
        field(3; Address; Text[100])
        {
        }
        field(4; "Phone No."; Code[30])
        {
        }
        field(5; Email; Text[120])
        {
        }
        field(6; Fax; Code[30])
        {
        }
        field(7; "Contact Person"; Text[80])
        {
        }
        field(8; "Home Page"; Text[100])
        {
        }
        field(9; "Last Date Modified"; Date)
        {
        }
        field(10; "Search Name"; Text[30])
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


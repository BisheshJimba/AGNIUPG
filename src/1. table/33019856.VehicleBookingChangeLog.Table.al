table 33019856 "Vehicle Booking Change Log"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = false;
        }
        field(2; "Vehicle No."; Code[20])
        {
            TableRelation = Vehicle;
        }
        field(3; Date; DateTime)
        {
        }
        field(4; "Previous Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(5; "New Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(6; "Previous Customer Name"; Text[50])
        {
        }
        field(7; "New Customer Name"; Text[50])
        {
        }
        field(8; Reason; Text[250])
        {
        }
        field(9; "User ID"; Code[50])
        {
        }
        field(10; VIN; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
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
        Date := CURRENTDATETIME;
    end;
}


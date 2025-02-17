table 33019857 "Booking Change"
{

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Vehicle No."; Code[20])
        {
            TableRelation = Vehicle."Serial No.";
        }
        field(3; Date; DateTime)
        {
        }
        field(4; "Previous Customer No."; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate()
            begin
                Customer.RESET;
                Customer.SETRANGE("No.", "Previous Customer No.");
                IF Customer.FINDFIRST THEN BEGIN
                    "Previous Customer Name" := Customer.Name;
                END;
            end;
        }
        field(5; "New Customer No."; Code[20])
        {
            FieldClass = Normal;
            TableRelation = Customer;

            trigger OnValidate()
            begin
                Customer.RESET;
                Customer.SETRANGE("No.", "New Customer No.");
                IF Customer.FINDFIRST THEN BEGIN
                    "New Customer Name" := Customer.Name;
                END;
            end;
        }
        field(6; "Previous Customer Name"; Text[50])
        {
            FieldClass = Normal;
        }
        field(7; "New Customer Name"; Text[50])
        {
            FieldClass = Normal;
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
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        VehRec: Record "25006005";
        Customer: Record "18";
}


table 33020201 "SP Daily Visit Details"
{

    fields
    {
        field(1; "Salesperson Code"; Code[10])
        {
            TableRelation = "SP Daily Visit Line"."Salesperson Code";
        }
        field(2; Year; Integer)
        {
            TableRelation = "SP Daily Visit Line".Year;
        }
        field(3; "Week No"; Integer)
        {
            TableRelation = "SP Daily Visit Line"."Week No";
        }
        field(4; Date; Date)
        {
            TableRelation = "SP Daily Visit Line".Date;
        }
        field(5; "Prospect No."; Code[20])
        {
        }
        field(6; Remarks; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Salesperson Code", Year, "Week No", Date, "Prospect No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        gblUserSetup: Record "91";
        gblContactList: Page "5052";
        gblContact: Record "5050";
}


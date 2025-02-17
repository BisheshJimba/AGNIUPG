table 33020162 "KAP Pictures"
{

    fields
    {
        field(1; "Sales Person Code"; Code[10])
        {
            TableRelation = "Salesperson KAP Activities"."Salesperson Code";
        }
        field(2; Year; Integer)
        {
            TableRelation = "Salesperson KAP Activities".Year;
        }
        field(3; Month; Option)
        {
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
            TableRelation = "Salesperson KAP Activities".Month;
        }
        field(4; "Week No."; Integer)
        {
        }
        field(10; "Serial No."; Integer)
        {
        }
        field(12; Picture; BLOB)
        {
        }
        field(15; "Use In Report"; Boolean)
        {
        }
        field(18; "Picture Exists"; Boolean)
        {
            Editable = false;
        }
        field(19; "Picture Name"; Text[100])
        {
        }
        field(20; "Picture Extension"; Text[20])
        {
        }
    }

    keys
    {
        key(Key1; "Sales Person Code", Year, Month, "Week No.", "Serial No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


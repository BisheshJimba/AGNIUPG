table 33020337 "Location Master"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[100])
        {
        }
        field(3; Type; Option)
        {
            Description = ' ,Department,Branch,Division,Workstation';
            OptionCaption = ' ,Department,Branch,Division,Workstation';
            OptionMembers = " ",Department,Branch,Division,Workstation;
        }
        field(4; Blocked; Boolean)
        {
        }
        field(5; "Global Dimension 1"; Code[10])
        {
            TableRelation = "Dimension Value".Code WHERE(Dimension Code=CONST(BRANCH));
        }
        field(6; "Global Dimension 2"; Code[10])
        {
            TableRelation = "Dimension Value".Code WHERE(Dimension Code=CONST(COST-REV));
        }
    }

    keys
    {
        key(Key1; "Code", Description)
        {
            Clustered = true;
        }
        key(Key2; Description, "Code")
        {
        }
    }

    fieldgroups
    {
    }
}


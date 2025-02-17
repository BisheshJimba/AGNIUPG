table 33020256 "Restrict Multiple Item Issue"
{
    // ***12.26.2012 YS *****
    //   * If any Items that exists in this table is issued already for any chassis then the same item cannot be issued again for the same
    //     chassis again in the same Job Type.


    fields
    {
        field(1; "Item No."; Code[20])
        {
            TableRelation = Item WHERE(Item Type=CONST(Item));
        }
        field(2; "Job Type"; Code[20])
        {
            TableRelation = "Job Type Master" WHERE(Type = CONST(Job));
        }
    }

    keys
    {
        key(Key1; "Item No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


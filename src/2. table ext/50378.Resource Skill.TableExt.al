tableextension 50378 tableextension50378 extends "Resource Skill"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Resource)) Resource.No.
                            ELSE IF (Type = CONST(Service Item Group)) "Service Item Group".Code
                            ELSE IF (Type=CONST(Item)) Item.No.
                            ELSE IF (Type=CONST(Service Item)) "Service Item".No.;
        }
    }
}


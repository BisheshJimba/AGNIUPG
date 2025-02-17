tableextension 50003 tableextension50003 extends "Job Resource Price"
{
    fields
    {
        modify("Code")
        {
            TableRelation = IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST("Group(Resource)")) "Resource Group";
        }
    }
}


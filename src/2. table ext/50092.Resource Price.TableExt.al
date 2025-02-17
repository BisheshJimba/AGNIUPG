tableextension 50092 tableextension50092 extends "Resource Price"
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


tableextension 50093 tableextension50093 extends "Resource Cost"
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


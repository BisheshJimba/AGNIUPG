tableextension 50156 tableextension50156 extends "Resource Price Change"
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


tableextension 50393 tableextension50393 extends "Service Line Price Adjmt."
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST(Cost)) "Service Cost";
        }
    }
}


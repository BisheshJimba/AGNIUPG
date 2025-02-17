tableextension 50226 tableextension50226 extends "Contact Web Source"
{
    fields
    {
        modify("Contact No.")
        {
            TableRelation = Contact WHERE(Type = CONST(" "));
        }
    }
}


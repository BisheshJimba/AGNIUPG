tableextension 50224 tableextension50224 extends "Contact Industry Group"
{
    fields
    {
        modify("Contact No.")
        {
            TableRelation = Contact WHERE(Type = CONST(" "));
        }
    }
}


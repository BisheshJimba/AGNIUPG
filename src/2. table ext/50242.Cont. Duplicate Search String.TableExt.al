tableextension 50242 tableextension50242 extends "Cont. Duplicate Search String"
{
    fields
    {
        modify("Contact Company No.")
        {
            TableRelation = Contact WHERE(Type = CONST(" "));
        }
    }
}


tableextension 50231 tableextension50231 extends "Contact Job Responsibility"
{
    fields
    {
        modify("Contact No.")
        {
            TableRelation = Contact WHERE(Type = CONST(Company));
        }
    }
}


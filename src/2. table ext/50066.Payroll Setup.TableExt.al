tableextension 50066 tableextension50066 extends "Payroll Setup"
{
    fields
    {
        modify("General Journal Template Name")
        {
            TableRelation = "Gen. Journal Template" WHERE(Type = FILTER(General),
                                                           Recurring = CONST(false));
        }
    }
}


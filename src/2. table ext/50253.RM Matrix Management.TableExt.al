tableextension 50253 tableextension50253 extends "RM Matrix Management"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Opportunities"(Field 5)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Estimated Value (LCY)"(Field 6)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Calcd. Current Value (LCY)"(Field 7)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Avg. Estimated Value (LCY)"(Field 8)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Avg.Calcd. Current Value (LCY)"(Field 9)".

        modify("Company No.")
        {
            TableRelation = Contact WHERE(Type = CONST(" "));
        }
        modify("Contact Company Filter")
        {
            TableRelation = Contact WHERE(Type = CONST(" "));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""No. of To-dos"(Field 25)".

    }
}


tableextension 50138 tableextension50138 extends "Reminder Header"
{
    fields
    {
        modify("Post Code")
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
        }
        modify(City)
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 30)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Remaining Amount"(Field 31)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Interest Amount"(Field 32)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Additional Fee"(Field 33)".


        //Unsupported feature: Property Modification (CalcFormula) on ""VAT Amount"(Field 34)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Add. Fee per Line"(Field 45)".

    }
}


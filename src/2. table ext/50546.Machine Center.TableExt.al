tableextension 50546 tableextension50546 extends "Machine Center"
{
    fields
    {
        modify(City)
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
        }
        modify("Post Code")
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 27)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Capacity (Total)"(Field 41)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Capacity (Effective)"(Field 42)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Prod. Order Need (Qty.)"(Field 44)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Prod. Order Need Amount"(Field 45)".

        modify("Location Code")
        {
            TableRelation = Location.Code WHERE (Use As In-Transit=CONST(No),
                                                 Bin Mandatory=CONST(Yes));
        }
    }
}


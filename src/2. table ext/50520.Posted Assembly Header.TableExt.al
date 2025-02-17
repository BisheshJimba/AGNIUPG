tableextension 50520 tableextension50520 extends "Posted Assembly Header"
{
    fields
    {
        modify("Variant Code")
        {

            //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 12)".

            TableRelation = "Item Variant".Code WHERE(Item No.=FIELD(No.),
                                                       Code=FIELD(Variant Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 19)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Assemble to Order"(Field 54)".

    }
}


tableextension 50498 tableextension50498 extends "Assembly Header"
{
    fields
    {
        modify("Variant Code")
        {

            //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 12)".

            TableRelation = "Item Variant".Code WHERE(Item No.=FIELD(Item No.),
                                                       Code=FIELD(Variant Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 19)".

        modify("Bin Code")
        {
            TableRelation = IF (Quantity=FILTER(<0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                     Item No.=FIELD(Item No.),
                                                                                     Variant Code=FIELD(Variant Code))
                                                                                     ELSE Bin.Code WHERE (Location Code=FIELD(Location Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity"(Field 48)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. (Base)"(Field 49)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Assemble to Order"(Field 54)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Rolled-up Assembly Cost"(Field 68)".

    }
}


tableextension 50297 tableextension50297 extends "Prod. Order Line"
{
    fields
    {
        modify("Variant Code")
        {

            //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 12)".

            TableRelation = "Item Variant".Code WHERE(Item No.=FIELD(Item No.),
                                                       Code=FIELD(Variant Code));
        }
        modify("Bin Code")
        {
            TableRelation = IF (Quantity=FILTER(<0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                     Item No.=FIELD(Item No.),
                                                                                     Variant Code=FIELD(Variant Code))
                                                                                     ELSE Bin.Code WHERE (Location Code=FIELD(Location Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity"(Field 68)".

        modify("Capacity No. Filter")
        {
            TableRelation = IF (Capacity Type Filter=CONST(Work Center)) "Work Center"
                            ELSE IF (Capacity Type Filter=CONST(Machine Center)) "Machine Center";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. (Base)"(Field 84)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Expected Operation Cost Amt."(Field 90)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Total Exp. Oper. Output (Qty.)"(Field 91)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Expected Component Cost Amt."(Field 94)".

    }
}


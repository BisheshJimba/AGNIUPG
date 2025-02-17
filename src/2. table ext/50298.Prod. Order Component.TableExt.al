tableextension 50298 tableextension50298 extends "Prod. Order Component"
{
    fields
    {
        modify("Prod. Order Line No.")
        {
            TableRelation = "Prod. Order Line"."Line No." WHERE(Status = FIELD(Status),
                                                                 Prod. Order No.=FIELD(Prod. Order No.));
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 21)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Act. Consumption (Qty)"(Field 27)".

        modify("Supplied-by Line No.")
        {
            TableRelation = "Prod. Order Line"."Line No." WHERE (Status=FIELD(Status),
                                                                 Prod. Order No.=FIELD(Prod. Order No.),
                                                                 Line No.=FIELD(Supplied-by Line No.));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. (Base)"(Field 63)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity"(Field 71)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Substitution Available"(Field 5702)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pick Qty."(Field 5750)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pick Qty. (Base)"(Field 7303)".

    }
}


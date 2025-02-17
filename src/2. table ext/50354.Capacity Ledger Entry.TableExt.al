tableextension 50354 tableextension50354 extends "Capacity Ledger Entry"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Machine Center)) "Machine Center"
                            ELSE IF (Type=CONST(Work Center)) "Work Center"
                            ELSE IF (Type=CONST(Resource)) Resource;
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 57)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Direct Cost"(Field 71)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Overhead Cost"(Field 72)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Direct Cost (ACY)"(Field 76)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Overhead Cost (ACY)"(Field 77)".

        modify("Order Line No.")
        {
            TableRelation = IF (Order Type=CONST(Production)) "Prod. Order Line"."Line No." WHERE (Status=FILTER(Released..),
                                                                                                   Prod. Order No.=FIELD(Order No.));
        }
    }
}


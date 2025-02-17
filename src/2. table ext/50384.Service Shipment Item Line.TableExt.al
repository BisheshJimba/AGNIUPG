tableextension 50384 tableextension50384 extends "Service Shipment Item Line"
{
    fields
    {
        modify("Fault Code")
        {
            TableRelation = "Fault Code".Code WHERE(Fault Area Code=FIELD(Fault Area Code),
                                                     Symptom Code=FIELD(Symptom Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Fault Comment"(Field 37)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Resolution Comment"(Field 38)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Accessory Comment"(Field 39)".


        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 40)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Active/Finished Allocs"(Field 60)".

    }
}


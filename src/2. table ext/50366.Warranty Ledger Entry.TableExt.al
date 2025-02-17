tableextension 50366 tableextension50366 extends "Warranty Ledger Entry"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code (Serviced)"(Field 8)".

        modify("Fault Code")
        {
            TableRelation = "Fault Code".Code WHERE(Fault Area Code=FIELD(Fault Area Code),
                                                     Symptom Code=FIELD(Symptom Code));
        }
        modify("No.")
        {
            TableRelation = IF (Type=CONST(" ")) "Standard Text"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST(Resource)) Resource
                            ELSE IF (Type=CONST(Service Cost)) "Service Cost";
        }
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 38)".

    }
}


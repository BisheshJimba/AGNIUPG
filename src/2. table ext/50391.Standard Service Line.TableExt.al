tableextension 50391 tableextension50391 extends "Standard Service Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST(Cost)) "Service Cost"
            ELSE
            IF (Type = CONST(G/L Account)) "G/L Account";
        }
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE(Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 11)".

    }
}


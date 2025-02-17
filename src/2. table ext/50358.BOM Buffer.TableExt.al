tableextension 50358 tableextension50358 extends "BOM Buffer"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Machine Center)) "Machine Center"
                            ELSE IF (Type=CONST(Work Center)) "Work Center"
                            ELSE IF (Type=CONST(Resource)) Resource;
        }
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE(Item No.=FIELD(No.))
                            ELSE IF (Type=CONST(Resource)) "Resource Unit of Measure".Code WHERE (Resource No.=FIELD(No.));
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 7)".

        modify("BOM Unit of Measure Code")
        {
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE IF (Type=CONST(Resource)) "Resource Unit of Measure".Code WHERE (Resource No.=FIELD(No.));
        }
    }
}


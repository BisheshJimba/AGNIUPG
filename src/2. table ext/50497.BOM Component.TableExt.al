tableextension 50497 tableextension50497 extends "BOM Component"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Item)) Item WHERE(Type = CONST(Inventory))
            ELSE
            IF (Type = CONST(Resource)) Resource;
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Assembly BOM"(Field 5)".

        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE(Item No.=FIELD(No.))
                            ELSE IF (Type=CONST(Resource)) "Resource Unit of Measure".Code WHERE (Resource No.=FIELD(No.));
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

    }
}


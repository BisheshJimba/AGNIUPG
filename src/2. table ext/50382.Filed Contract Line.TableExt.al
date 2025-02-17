tableextension 50382 tableextension50382 extends "Filed Contract Line"
{
    fields
    {
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Item No.=FILTER(<>'')) "Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.))
                            ELSE "Unit of Measure";
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 28)".

    }
}


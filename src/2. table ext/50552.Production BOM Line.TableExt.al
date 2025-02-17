tableextension 50552 tableextension50552 extends "Production BOM Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Item)) Item WHERE(Type = CONST(Inventory))
            ELSE
            IF (Type = CONST(Production BOM)) "Production BOM Header";
        }
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE(Item No.=FIELD(No.))
                            ELSE IF (Type=CONST(Production BOM)) "Unit of Measure";
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 21)".


        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 22)".

    }
}


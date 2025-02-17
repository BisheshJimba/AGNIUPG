tableextension 50499 tableextension50499 extends "Assembly Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Item)) Item WHERE(Type = CONST(Inventory))
            ELSE
            IF (Type = CONST(Resource)) Resource;
        }
        modify("Variant Code")
        {

            //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 12)".

            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE(Item No.=FIELD(No.),
                                                                             Code=FIELD(Variant Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity"(Field 48)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. (Base)"(Field 49)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Substitution Available"(Field 51)".

        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE IF (Type=CONST(Resource)) "Resource Unit of Measure".Code WHERE (Resource No.=FIELD(No.));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Pick Qty."(Field 7301)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pick Qty. (Base)"(Field 7302)".

    }
}


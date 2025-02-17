tableextension 50374 tableextension50374 extends "Service Item Component"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Service Item)) "Service Item"
                            ELSE IF (Type=CONST(Item)) Item;
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 8)".

    }
}


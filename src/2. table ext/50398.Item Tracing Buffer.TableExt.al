tableextension 50398 tableextension50398 extends "Item Tracing Buffer"
{
    fields
    {
        modify("Source No.")
        {
            TableRelation = IF (Source Type=CONST(Customer)) Customer
                            ELSE IF (Source Type=CONST(Vendor)) Vendor
                            ELSE IF (Source Type=CONST(Item)) Item;
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 18)".

    }
}


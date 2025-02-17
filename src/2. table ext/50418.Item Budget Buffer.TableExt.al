tableextension 50418 tableextension50418 extends "Item Budget Buffer"
{
    fields
    {
        modify("Source No.")
        {
            TableRelation = IF (Source Type=CONST(Customer)) Customer
                            ELSE IF (Source Type=CONST(Vendor)) Vendor
                            ELSE IF (Source Type=CONST(Item)) Item;
        }
    }
}


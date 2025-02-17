tableextension 50458 tableextension50458 extends "VAT Report Line"
{
    fields
    {
        modify("Bill-to/Pay-to No.")
        {
            TableRelation = IF (Type = CONST(Purchase)) Vendor
            ELSE
            IF (Type = CONST(Sale)) Customer;
        }
    }
}


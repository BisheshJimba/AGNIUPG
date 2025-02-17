tableextension 50496 tableextension50496 extends "Social Listening Search Topic"
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


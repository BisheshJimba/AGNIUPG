tableextension 50421 tableextension50421 extends "Item Analysis View Budg. Entry"
{
    fields
    {
        modify("Analysis View Code")
        {
            TableRelation = "Item Analysis View".Code WHERE(Analysis Area=FIELD(Analysis Area),
                                                             Code=FIELD(Analysis View Code));
        }
        modify("Source No.")
        {
            TableRelation = IF (Source Type=CONST(Customer)) Customer
                            ELSE IF (Source Type=CONST(Vendor)) Vendor
                            ELSE IF (Source Type=CONST(Item)) Item;
        }
    }
}


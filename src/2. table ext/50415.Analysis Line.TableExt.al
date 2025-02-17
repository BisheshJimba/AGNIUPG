tableextension 50415 tableextension50415 extends "Analysis Line"
{
    fields
    {
        modify(Range)
        {
            TableRelation = IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Customer)) Customer
            ELSE
            IF (Type = CONST(Vendor)) Vendor
            ELSE
            IF (Type = CONST(Item Group)) "Dimension Value".Code WHERE (Dimension Code=FIELD(Group Dimension Code))
                            ELSE IF (Type=CONST(Customer Group)) "Dimension Value".Code WHERE (Dimension Code=FIELD(Group Dimension Code))
                            ELSE IF (Type=CONST(Sales/Purchase person)) "Dimension Value".Code WHERE (Dimension Code=FIELD(Group Dimension Code));
        }
        modify("Source No. Filter")
        {
            TableRelation = IF (Source Type Filter=CONST(Customer)) Customer
                            ELSE IF (Source Type Filter=CONST(Vendor)) Vendor
                            ELSE IF (Source Type Filter=CONST(Item)) Item;
        }
    }
}


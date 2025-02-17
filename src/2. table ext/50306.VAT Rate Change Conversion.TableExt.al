tableextension 50306 tableextension50306 extends "VAT Rate Change Conversion"
{
    fields
    {
        modify("From Code")
        {
            TableRelation = IF (Type = CONST(VAT Prod.Posting Group)) "VAT Product Posting Group"
                            ELSE IF (Type=CONST(Gen. Prod. Posting Group)) "Gen. Product Posting Group";
        }
        modify("To Code")
        {
            TableRelation = IF (Type=CONST(VAT Prod. Posting Group)) "VAT Product Posting Group"
                            ELSE IF (Type=CONST(Gen. Prod. Posting Group)) "Gen. Product Posting Group";
        }
    }
}


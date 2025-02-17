tableextension 50082 tableextension50082 extends "Cancelled Document"
{
    fields
    {
        modify("Cancelled Doc. No.")
        {
            TableRelation = IF ("Source ID" = CONST(112)) "Sales Invoice Header"."No."
            ELSE IF ("Source ID" = CONST(122)) "Purch. Inv. Header"."No."
            ELSE IF ("Source ID" = CONST(114)) "Sales Cr.Memo Header"."No."
            ELSE IF ("Source ID" = CONST(124)) "Purch. Cr. Memo Hdr."."No.";
        }
        modify("Cancelled By Doc. No.")
        {
            TableRelation = IF ("Source ID" = CONST(114)) "Sales Invoice Header"."No."
            ELSE IF ("Source ID" = CONST(124)) "Purch. Inv. Header"."No."
            ELSE IF ("Source ID" = CONST(112)) "Sales Cr.Memo Header"."No."
            ELSE IF ("Source ID" = CONST(122)) "Purch. Cr. Memo Hdr."."No.";
        }
    }
}


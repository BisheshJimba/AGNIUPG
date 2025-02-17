tableextension 50146 tableextension50146 extends "Finance Charge Memo Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST(G/L Account)) "G/L Account";
        }
    }
}


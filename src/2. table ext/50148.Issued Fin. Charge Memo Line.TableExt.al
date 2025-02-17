tableextension 50148 tableextension50148 extends "Issued Fin. Charge Memo Line"
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


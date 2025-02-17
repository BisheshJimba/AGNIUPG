tableextension 50123 tableextension50123 extends "Intrastat Jnl. Line"
{
    fields
    {
        modify("Source Entry No.")
        {
            TableRelation = IF (Source Type=CONST(Item Entry)) "Item Ledger Entry"
                            ELSE IF (Source Type=CONST(Job Entry)) "Job Ledger Entry";
        }
    }
}


tableextension 50149 tableextension50149 extends "Fin. Charge Comment Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Finance Charge Memo)) "Finance Charge Memo Header"
                            ELSE IF (Type=CONST(Issued Finance Charge Memo)) "Issued Fin. Charge Memo Header";
        }
    }
}


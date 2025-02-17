tableextension 50144 tableextension50144 extends "Reminder/Fin. Charge Entry"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Reminder)) "Issued Reminder Header"
            ELSE
            IF (Type = CONST(Finance Charge Memo)) "Issued Fin. Charge Memo Header";
        }
    }
}


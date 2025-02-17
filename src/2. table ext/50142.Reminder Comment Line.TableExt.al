tableextension 50142 tableextension50142 extends "Reminder Comment Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Reminder)) "Reminder Header"
            ELSE
            IF (Type = CONST(Issued Reminder)) "Issued Reminder Header";
        }
    }
}


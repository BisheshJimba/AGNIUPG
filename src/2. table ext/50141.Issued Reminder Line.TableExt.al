tableextension 50141 tableextension50141 extends "Issued Reminder Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Line Fee)) "G/L Account";
        }
    }
}


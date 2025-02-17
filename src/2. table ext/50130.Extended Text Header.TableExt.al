tableextension 50130 tableextension50130 extends "Extended Text Header"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Table Name=CONST(Standard Text)) "Standard Text"
                            ELSE IF (Table Name=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Table Name=CONST(Item)) Item
                            ELSE IF (Table Name=CONST(Resource)) Resource;
        }
    }
}


tableextension 50131 tableextension50131 extends "Extended Text Line"
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


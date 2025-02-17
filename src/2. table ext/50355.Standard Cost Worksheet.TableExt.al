tableextension 50355 tableextension50355 extends "Standard Cost Worksheet"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Machine Center)) "Machine Center"
                            ELSE IF (Type=CONST(Work Center)) "Work Center"
                            ELSE IF (Type=CONST(Resource)) Resource;
        }
    }
}


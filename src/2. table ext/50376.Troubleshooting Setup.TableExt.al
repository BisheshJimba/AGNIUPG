tableextension 50376 tableextension50376 extends "Troubleshooting Setup"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Service Item Group)) "Service Item Group"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST(Service Item)) "Service Item";
        }
    }
}


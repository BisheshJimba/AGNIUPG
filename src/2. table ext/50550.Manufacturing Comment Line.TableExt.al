tableextension 50550 tableextension50550 extends "Manufacturing Comment Line"
{
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Table Name=CONST(Work Center)) "Work Center"
                            ELSE IF (Table Name=CONST(Machine Center)) "Machine Center"
                            ELSE IF (Table Name=CONST(Routing Header)) "Routing Header"
                            ELSE IF (Table Name=CONST(Production BOM Header)) "Production BOM Header";
        }
    }
}


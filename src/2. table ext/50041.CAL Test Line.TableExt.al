tableextension 50041 tableextension50041 extends "CAL Test Line"
{
    fields
    {
        modify("Test Codeunit")
        {
            TableRelation = IF ("Line Type" = CONST(Codeunit)) AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Codeunit),
                                                                                                "Object Subtype" = CONST('Test'));
        }
    }
}


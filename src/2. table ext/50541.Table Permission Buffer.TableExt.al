tableextension 50541 tableextension50541 extends "Table Permission Buffer"
{
    fields
    {
        modify("Object ID")
        {
            TableRelation = IF (Object Type=CONST(Table Data)) AllObj."Object ID" WHERE (Object Type=CONST(Table))
                            ELSE IF (Object Type=CONST(Table)) AllObj."Object ID" WHERE (Object Type=CONST(Table))
                            ELSE IF (Object Type=CONST(Report)) AllObj."Object ID" WHERE (Object Type=CONST(Report))
                            ELSE IF (Object Type=CONST(Codeunit)) AllObj."Object ID" WHERE (Object Type=CONST(Codeunit))
                            ELSE IF (Object Type=CONST(XMLport)) AllObj."Object ID" WHERE (Object Type=CONST(XMLport))
                            ELSE IF (Object Type=CONST(MenuSuite)) AllObj."Object ID" WHERE (Object Type=CONST(MenuSuite))
                            ELSE IF (Object Type=CONST(Page)) AllObj."Object ID" WHERE (Object Type=CONST(Page))
                            ELSE IF (Object Type=CONST(Query)) AllObj."Object ID" WHERE (Object Type=CONST(Query))
                            ELSE IF (Object Type=CONST(System)) AllObj."Object ID" WHERE (Object Type=CONST(System));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Object Name"(Field 5)".

    }
}


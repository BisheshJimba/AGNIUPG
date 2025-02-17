tableextension 50554 tableextension50554 extends "Production BOM Comment Line"
{
    fields
    {
        modify("Version Code")
        {
            TableRelation = "Production BOM Version"."Version Code" WHERE(Production BOM No.=FIELD(Production BOM No.),
                                                                           Version Code=FIELD(Version Code));
        }
    }
}


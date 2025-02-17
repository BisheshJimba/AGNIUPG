tableextension 50559 tableextension50559 extends "Routing Personnel"
{
    fields
    {
        modify("Operation No.")
        {
            TableRelation = "Routing Line"."Operation No." WHERE(Routing No.=FIELD(Routing No.),
                                                                  Version Code=FIELD(Version Code));
        }
    }
}


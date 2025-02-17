tableextension 50560 tableextension50560 extends "Routing Quality Measure"
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


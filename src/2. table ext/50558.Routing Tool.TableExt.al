tableextension 50558 tableextension50558 extends "Routing Tool"
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


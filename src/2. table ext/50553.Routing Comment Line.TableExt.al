tableextension 50553 tableextension50553 extends "Routing Comment Line"
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


tableextension 50302 tableextension50302 extends "Prod. Order Routing Personnel"
{
    fields
    {
        modify("Operation No.")
        {
            TableRelation = "Prod. Order Routing Line"."Operation No." WHERE(Status = FIELD(Status),
                                                                              Prod. Order No.=FIELD(Prod. Order No.),
                                                                              Routing No.=FIELD(Routing No.));
        }
        modify("Routing Reference No.")
        {
            TableRelation = "Prod. Order Routing Line"."Routing Reference No." WHERE (Routing No.=FIELD(Routing No.),
                                                                                      Operation No.=FIELD(Operation No.),
                                                                                      Prod. Order No.=FIELD(Prod. Order No.),
                                                                                      Status=FIELD(Status));
        }
    }
}


tableextension 50305 tableextension50305 extends "Prod. Order Comp. Cmt Line"
{
    fields
    {
        modify("Prod. Order BOM Line No.")
        {
            TableRelation = "Prod. Order Component"."Line No." WHERE(Status = FIELD(Status),
                                                                      Prod. Order No.=FIELD(Prod. Order No.),
                                                                      Prod. Order Line No.=FIELD(Prod. Order Line No.));
        }
        modify("Prod. Order Line No.")
        {
            TableRelation = "Prod. Order Line"."Line No." WHERE (Status=FIELD(Status),
                                                                 Prod. Order No.=FIELD(Prod. Order No.));
        }
    }
}


tableextension 50261 tableextension50261 extends Attendee
{
    fields
    {
        modify("Attendee No.")
        {
            TableRelation = IF (Attendee Type=CONST(Contact)) Contact WHERE (No.=FIELD(Attendee No.))
                            ELSE IF (Attendee Type=CONST(Salesperson)) Salesperson/Purchaser WHERE (Code=FIELD(Attendee No.));
        }
    }
}


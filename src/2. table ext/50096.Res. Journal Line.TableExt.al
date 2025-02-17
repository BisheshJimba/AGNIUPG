tableextension 50096 tableextension50096 extends "Res. Journal Line"
{
    fields
    {
        modify("Time Sheet Date")
        {
            TableRelation = "Time Sheet Detail".Date WHERE("Time Sheet No." = FIELD("Time Sheet No."),
                                                            "Time Sheet Line No." = FIELD("Time Sheet Line No."));
        }
    }
}


tableextension 50481 tableextension50481 extends "Acc. Schedule Line"
{
    fields
    {
        modify(Totaling)
        {
            TableRelation = IF (Totaling Type=CONST(Posting Accounts)) "G/L Account"
                            ELSE IF (Totaling Type=CONST(Total Accounts)) "G/L Account"
                            ELSE IF (Totaling Type=CONST(Cash Flow Entry Accounts)) "Cash Flow Account"
                            ELSE IF (Totaling Type=CONST(Cash Flow Total Accounts)) "Cash Flow Account"
                            ELSE IF (Totaling Type=CONST(Cost Type)) "Cost Type"
                            ELSE IF (Totaling Type=CONST(Cost Type Total)) "Cost Type";
        }
    }
}


tableextension 50480 tableextension50480 extends "Cash Flow Forecast Entry"
{
    fields
    {
        modify("Source No.")
        {
            TableRelation = IF (Source Type=CONST(Liquid Funds)) "G/L Account"
                            ELSE IF (Source Type=CONST(Receivables)) Customer
                            ELSE IF (Source Type=CONST(Payables)) Vendor
                            ELSE IF (Source Type=CONST(Fixed Assets Budget)) "Fixed Asset"
                            ELSE IF (Source Type=CONST(Fixed Assets Disposal)) "Fixed Asset"
                            ELSE IF (Source Type=CONST(Sales Order)) "Sales Header".No. WHERE (Document Type=CONST(Order))
                            ELSE IF (Source Type=CONST(Purchase Order)) "Purchase Header".No. WHERE (Document Type=CONST(Order))
                            ELSE IF (Source Type=CONST(Service Orders)) "Service Header".No. WHERE (Document Type=CONST(Order))
                            ELSE IF (Source Type=CONST(Cash Flow Manual Expense)) "Cash Flow Manual Expense"
                            ELSE IF (Source Type=CONST(Cash Flow Manual Revenue)) "Cash Flow Manual Revenue"
                            ELSE IF (Source Type=CONST(G/L Budget)) "G/L Account"
                            ELSE IF (Source Type=CONST(Job)) Job.No.;
        }
    }
}


tableextension 50479 tableextension50479 extends "Cash Flow Worksheet Line"
{
    fields
    {
        modify("Source No.")
        {
            TableRelation = IF (Source Type=CONST(Liquid Funds)) "G/L Account"
                            ELSE IF (Source Type=CONST(Receivables)) "Cust. Ledger Entry"."Document No."
                            ELSE IF (Source Type=CONST(Payables)) "Vendor Ledger Entry"."Document No."
                            ELSE IF (Source Type=CONST(Fixed Assets Budget)) "Fixed Asset"
                            ELSE IF (Source Type=CONST(Fixed Assets Disposal)) "Fixed Asset"
                            ELSE IF (Source Type=CONST(Sales Orders)) "Sales Header".No. WHERE (Document Type=CONST(Order))
                            ELSE IF (Source Type=CONST(Purchase Orders)) "Purchase Header".No. WHERE (Document Type=CONST(Order))
                            ELSE IF (Source Type=CONST(Service Orders)) "Service Header".No. WHERE (Document Type=CONST(Order))
                            ELSE IF (Source Type=CONST(Cash Flow Manual Expense)) "Cash Flow Manual Expense"
                            ELSE IF (Source Type=CONST(Cash Flow Manual Revenue)) "Cash Flow Manual Revenue"
                            ELSE IF (Source Type=CONST(G/L Budget)) "G/L Account"
                            ELSE IF (Source Type=CONST(Job)) Job.No.;
        }
    }
}


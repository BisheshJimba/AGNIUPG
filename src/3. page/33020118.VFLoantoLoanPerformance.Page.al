page 33020118 "VF Loan-to-Loan Performance"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020062;
    SourceTableView = SORTING(Loan No.)
                      ORDER(Ascending)
                      WHERE(Closed = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Loan No."; "Loan No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Loan Amount"; "Loan Amount")
                {
                }
                field("Financing Bank No."; "Financing Bank No.")
                {
                }
                field("Bank Name"; "Bank Name")
                {
                }
                field("Bank EMI"; "Bank EMI")
                {
                }
                field("EMI Amount"; "EMI Amount")
                {
                }
                field("Bank Interest Rate"; "Bank Interest Rate")
                {
                }
                field("Interest Rate"; "Interest Rate")
                {
                }
                field("Principal Outstanding in Bank"; "Principal Outstanding in Bank")
                {
                }
                field("Total Principal Paid"; "Total Principal Paid")
                {
                    Caption = 'Principal Paid by Customer';
                }
                field("Interest Paid to Bank"; "Interest Paid to Bank")
                {
                }
                field("Interest Paid by Customer"; "Interest Paid by Customer")
                {
                }
                field(Spread; Spread)
                {
                    Caption = 'Spread';
                }
                field(InterestCoverageRatio; InterestCoverageRatio)
                {
                    Caption = 'Interest Coverage Ratio';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Spread := "Bank Interest Rate" - "Interest Rate";

        IF "Interest Paid to Bank" <> 0 THEN
            InterestCoverageRatio := "Interest Paid by Customer" / "Interest Paid to Bank";
    end;

    var
        Spread: Decimal;
        InterestCoverageRatio: Decimal;
}


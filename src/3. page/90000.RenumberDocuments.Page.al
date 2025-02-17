page 90000 "Renumber Documents"
{
    PageType = List;
    SourceTable = Table90000;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("SN."; "SN.")
                {
                }
                field("Old Invoice No."; "Old Invoice No.")
                {
                }
                field("New Invoice No."; "New Invoice No.")
                {
                }
                field("Old Posting Date"; "Old Posting Date")
                {
                }
                field("New Posting Date"; "New Posting Date")
                {
                }
                field(Updated; Updated)
                {
                }
                field(Merge; Merge)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                action("Modify Posting Date (Sales)")
                {
                    Image = DateRange;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DocumentAdjustment: Codeunit "90000";
                    begin
                        DocumentAdjustment.StartProcessingDate;
                    end;
                }
                action("Modify Invoice No (Sales)")
                {
                    Image = Invoice;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DocumentAdjustment: Codeunit "90000";
                    begin
                        DocumentAdjustment.StartProcessingDocumentNo;
                    end;
                }
                action("Delete Print History")
                {
                    Image = PrintCover;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DocumentAdjustment: Codeunit "90000";
                    begin
                        DocumentAdjustment.ResetNoOfPrint;
                    end;
                }
                action("Modify Service Invoice No")
                {

                    trigger OnAction()
                    var
                        DocumentAdjustment: Codeunit "90000";
                    begin
                        DocumentAdjustment.StartProcessingServiceDocumentNoPostingDate;
                    end;
                }
                action("Modify Resource & Service Ledger")
                {

                    trigger OnAction()
                    var
                        DocumentAdjustment: Codeunit "90000";
                    begin
                        DocumentAdjustment.StartProcessingDateServiceLedgerResouceledger;
                    end;
                }
                action("Modify Bill Amount and Discount")
                {
                }
                action("Modify Posting Date (Purchase)")
                {
                    Image = Account;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DocumentAdjustment: Codeunit "90000";
                    begin
                        DocumentAdjustment.StartPurchaseProcessingDate;
                    end;
                }
                action("Modify Invoice No (Purchase)")
                {
                    Image = AddAction;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DocumentAdjustment: Codeunit "90000";
                    begin
                        DocumentAdjustment.StartPurchaseProcessingDocumentNo;
                    end;
                }
                action("Modify Posting Date (Sales Credit)")
                {
                    Caption = ')';
                    Image = DateRange;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DocumentAdjustment: Codeunit "90000";
                    begin
                        DocumentAdjustment.StartProcessingDateSalesCreditMemo;
                    end;
                }
                action("Modify Invoice No (Sales Creditm)")
                {
                    Image = Invoice;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        DocumentAdjustment: Codeunit "90000";
                    begin
                        DocumentAdjustment.StartProcessingDocumentNoSalesCreditMemo;
                    end;
                }
            }
        }
    }
}


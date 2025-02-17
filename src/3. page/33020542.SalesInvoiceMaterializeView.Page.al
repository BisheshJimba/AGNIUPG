page 33020542 "Sales Invoice Materialize View"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020293;
    SourceTableView = WHERE(Table ID=CONST(112),
                            Document Type=CONST(Sales Invoice));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; "Document Type")
                {
                    Visible = false;
                }
                field("Bill No"; "Bill No")
                {
                }
                field("Fiscal Year"; "Fiscal Year")
                {
                }
                field("Bill Date"; "Bill Date")
                {
                }
                field("Posting Time"; "Posting Time")
                {
                }
                field("Source Type"; "Source Type")
                {
                }
                field("Customer Code"; "Customer Code")
                {
                }
                field("Source Code"; "Source Code")
                {
                    Visible = false;
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                }
                field(Amount; Amount)
                {
                }
                field(Discount; Discount)
                {
                }
                field("Taxable Amount"; "Taxable Amount")
                {
                }
                field("TAX Amount"; "TAX Amount")
                {
                }
                field("Total Amount"; "Total Amount")
                {
                }
                field("Entered By"; "Entered By")
                {
                }
                field("Is BIll Printed"; "Is BIll Printed")
                {
                }
                field("Is Bill Active"; "Is Bill Active")
                {
                }
                field("Printed By"; "Printed By")
                {
                }
                field("Accountability Center"; "Accountability Center")
                {
                }
                field("Is Realtime"; "Is Realtime")
                {
                }
                field("Sync Status"; "Sync Status")
                {
                }
                field("Synced Date"; "Synced Date")
                {
                }
                field("Sync with IRD"; "Sync with IRD")
                {
                }
                field("CBMS Sync. Response"; "CBMS Sync. Response")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group()
            {
                action("Sync. Selected Data to IRD")
                {
                    Image = Union;

                    trigger OnAction()
                    var
                        InvoiceMaterializedView: Record "33020293";
                        PushInvoices: Codeunit "33020513";
                    begin
                        IF NOT CONFIRM('Do you want to Sync. selected data to IRD?', FALSE) THEN
                            EXIT;
                        InvoiceMaterializedView.COPY(Rec);
                        CurrPage.SETSELECTIONFILTER(InvoiceMaterializedView);
                        CLEAR(PushInvoices);
                        PushInvoices.PushBatchBill(InvoiceMaterializedView);
                    end;
                }
            }
        }
    }
}


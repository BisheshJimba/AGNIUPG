page 33019842 "Modify Financer - Vehicle Sale"
{

    layout
    {
        area(content)
        {
            group("Change Financer")
            {
                Caption = 'Change Financer';
                field(InvoiceNo; InvoiceNo)
                {
                    Caption = 'Invoice No.';
                    TableRelation = "Sales Invoice Header".No.;

                    trigger OnValidate()
                    begin
                        SalesInvoiceHeader.RESET;
                        SalesInvoiceHeader.SETRANGE("No.", InvoiceNo);
                        IF SalesInvoiceHeader.FINDFIRST THEN
                            OldFinancedBy := SalesInvoiceHeader."Financed By"
                        ELSE
                            ERROR('Invoice Not found!');
                    end;
                }
                field(OldFinancedBy; OldFinancedBy)
                {
                    Caption = 'Old Financer No.';
                    Editable = false;
                    TableRelation = Contact.No.;
                }
                field(NewFinancedBy; NewFinancedBy)
                {
                    Caption = 'New Financer No.';
                    TableRelation = Contact.No.;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Update)
            {
                Image = Update;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    IF (InvoiceNo = '') OR (OldFinancedBy = '') OR (NewFinancedBy = '') THEN
                        ERROR('All fields are mandatory.');

                    OK := CONFIRM('Are you sure to update the financer information for the selected invoice?');

                    IF OK THEN BEGIN
                        SalesInvoiceHeader.SETRANGE("No.", InvoiceNo);
                        IF SalesInvoiceHeader.FINDFIRST THEN BEGIN
                            SalesInvoiceHeader."Financed By" := NewFinancedBy;
                            SalesInvoiceHeader."No. Printed" := 0;
                            SalesInvoiceHeader.MODIFY;
                            CustomerLedgerEntry.RESET;
                            CustomerLedgerEntry.SETRANGE("Document No.", InvoiceNo);
                            IF CustomerLedgerEntry.FINDFIRST THEN BEGIN
                                CustomerLedgerEntry."Financed By" := NewFinancedBy;
                                CustomerLedgerEntry.MODIFY;
                            END;
                            MESSAGE('Financer information has been modified successfylly.');
                        END;
                    END;
                end;
            }
        }
    }

    var
        InvoiceNo: Code[20];
        OldFinancedBy: Code[20];
        NewFinancedBy: Code[20];
        SalesInvoiceHeader: Record "112";
        CustomerLedgerEntry: Record "21";
        OK: Boolean;
}


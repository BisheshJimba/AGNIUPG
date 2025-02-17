page 25006223 "Ext. Service Ledger Entries"
{
    Caption = 'External Service Ledger Entries';
    Editable = false;
    PageType = List;
    SourceTable = Table25006137;
    SourceTableView = SORTING(External Serv. No., External Serv. Tracking No., Entry Type);

    layout
    {
        area(content)
        {
            repeater()
            {
                field("External Serv. No."; "External Serv. No.")
                {
                }
                field("External Serv. Tracking No."; "External Serv. Tracking No.")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field(Amount; Amount)
                {
                    Caption = 'Purchase Amount';
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("Source Type"; "Source Type")
                {
                }
                field("Source No."; "Source No.")
                {
                }
                field("Entry No."; "Entry No.")
                {
                }
                field("Service Order No."; "Service Order No.")
                {
                }
                field(Name; Name)
                {
                    Caption = 'Name';
                }
                field(VIN; VIN)
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field(TotalJobAmount; TotalJobAmount)
                {
                    Caption = 'Total Job Amount';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Dimensions)
            {
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortCutKey = 'Shift+Ctrl+D';

                trigger OnAction()
                begin
                    ShowDimensions;
                    CurrPage.SAVERECORD;
                end;
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date", "Document No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Name := '';
        IF "Source Type" = "Source Type"::Vendor THEN BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("No.", "Source No.");
            IF Vendor.FINDFIRST THEN
                Name := Vendor.Name;
        END
        ELSE
            IF "Source Type" = "Source Type"::Customer THEN BEGIN
                Customer.RESET;
                Customer.SETRANGE("No.", "Source No.");
                IF Customer.FINDFIRST THEN
                    Name := Customer.Name;
            END;
        TotalJobAmount := 0;
        SalesInvoiceHeader.RESET;
        SalesInvoiceHeader.SETCURRENTKEY("Service Order No.");
        SalesInvoiceHeader.SETRANGE("Service Order No.", "Service Order No.");
        IF SalesInvoiceHeader.FINDFIRST THEN BEGIN
            SalesInvoiceHeader.CALCFIELDS(Amount);
            TotalJobAmount := SalesInvoiceHeader.Amount;
        END;
    end;

    var
        Navigate: Page "344";
        Name: Text[50];
        Vendor: Record "23";
        Customer: Record "18";
        TotalJobAmount: Decimal;
        SalesInvoiceHeader: Record "112";
}


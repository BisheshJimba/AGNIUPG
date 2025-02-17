page 25006457 "Veh.Trade-In App.Entries"
{
    Caption = 'Veh.Trade-In App.Entries';
    Editable = false;
    PageType = List;
    SourceTable = Table25006391;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Entry Type"; "Entry Type")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                }
                field("Amount (FCY)"; "Amount (FCY)")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
                {
                }
                field("Applies-to Vehicle Serial No."; "Applies-to Vehicle Serial No.")
                {
                }
                field("Applies-to Veh. Acc. Cycle No."; "Applies-to Veh. Acc. Cycle No.")
                {
                }
                field("Entry No."; "Entry No.")
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                    Visible = false;
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
                Caption = 'Functions';
                action("Link Purchase Order")
                {
                    Caption = 'Link Purchase Order';
                    Image = Purchase;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PurchaseLine: Record "39";
                        PurchaseLine2: Record "39";
                    begin
                        SaleSetup.GET;
                        PurchaseLine.RESET;
                        CLEAR(PurchaseLines);

                        PurchaseLine.SETRANGE("Line Type", PurchaseLine."Line Type"::Vehicle);
                        PurchaseLine.SETRANGE("Link Trade-In Entry", 0);
                        PurchaseLines.LOOKUPMODE(TRUE);
                        PurchaseLines.SETTABLEVIEW(PurchaseLine);
                        IF PurchaseLines.RUNMODAL = ACTION::LookupOK THEN BEGIN
                            PurchaseLines.GETRECORD(PurchaseLine);
                            VehTradeInMgt.InsertPurchaseLineEntry(PurchaseLine."Document No.", PurchaseLine."Line No.",
                                                                  PurchaseLine."Document Type");
                        END;

                        IF FINDLAST THEN;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LOOKUPMODE := TRUE;
    end;

    var
        SaleSetup: Record "311";
        VehTradeInMgt: Codeunit "25006314";
        PurchaseLines: Page "518";
}


pageextension 50117 pageextension50117 extends "Vendor Ledger Entries"
{
    Editable = false;

    //Unsupported feature: Property Modification (SourceTableView) on ""Vendor Ledger Entries"(Page 29)".

    layout
    {
        addafter("Control 51")
        {
            field("Document Date"; Rec."Document Date")
            {
            }
        }
        addafter("Control 10")
        {
            field(Narration; Narration)
            {
            }
        }
        addafter("Control 56")
        {
            field("No. Series"; Rec."No. Series")
            {
            }
            field("Debit Amount"; Rec."Debit Amount")
            {
            }
            field("Credit Amount"; Rec."Credit Amount")
            {
            }
            field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
            {
                Visible = false;
            }
            field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
            {
                Visible = false;
            }
        }
        addafter("Control 47")
        {
            field("TDS Amount"; "TDS Amount")
            {
                Editable = false;
            }
        }
        addafter("Control 26")
        {
            field("Service Order No."; "Service Order No.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Service Order No.';
                Editable = false;
                Enabled = true;
                ToolTip = 'Specifies the service order number that was entered on the purchase header or journal line.';
            }
        }
        addafter("Control 62")
        {
            field("VAT Registration No."; "VAT Registration No.")
            {
            }
        }
        addafter("Control 30")
        {
            field(BankLCNo; BankLCNo)
            {
                Caption = 'Bank LC No.';
            }
        }
        addafter("Control 290")
        {
            field("Vendor Posting Group"; Rec."Vendor Posting Group")
            {
            }
            field("Debit Note No."; "Debit Note No.")
            {
            }
            field("Credit Note No."; "Credit Note No.")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 54".

        addafter("Action 54")
        {
            action("<Action1000000013>")
            {
                Caption = 'Debit/Credit Note';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    VendLedgEntry: Record "25";
                begin
                    VendLedgEntry.SETRANGE("Posting Date", Rec."Posting Date");
                    VendLedgEntry.SETRANGE("Document No.", Rec."Document No.");
                    VendLedgEntry.SETRANGE("Vendor No.", Rec."Vendor No.");
                    IF VendLedgEntry.FINDFIRST THEN
                        REPORT.RUNMODAL(33020029, TRUE, FALSE, VendLedgEntry);
                end;
            }
        }
    }

    var
        BankLCNo: Code[20];
        PurchInvHdr: Record "122";


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    StyleTxt := SetStyle;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    StyleTxt := SetStyle;
    IF PurchInvHdr.GET("Document No.") THEN //Min 2.12.2020
      BankLCNo := PurchInvHdr."Bank LC No.";
    */
    //end;
}


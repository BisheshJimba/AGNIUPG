pageextension 50097 pageextension50097 extends "Customer Ledger Entries"
{
    Editable = false;

    //Unsupported feature: Property Modification (SourceTableView) on ""Customer Ledger Entries"(Page 25)".

    layout
    {
        addafter("Control 10")
        {
            field(Narration; Narration)
            {
            }
        }
        addafter("Control 53")
        {
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
        addafter("Control 73")
        {
            field("Customer Posting Group"; Rec."Customer Posting Group")
            {
            }
        }
        addafter("Control 61")
        {
            field("Sales Order No."; "Sales Order No.")
            {
                Editable = false;
            }
        }
        addafter("Control 83")
        {
            field("Bank LC No."; "Bank LC No.")
            {
            }
        }
        addafter("Control 75")
        {
            field("Document Date"; Rec."Document Date")
            {
                Visible = false;
            }
            field("VF Posting Type"; "VF Posting Type")
            {
            }
            field("Loan File No."; "Loan File No.")
            {
            }
            field("External Document No."; Rec."External Document No.")
            {
            }
        }
        addafter("Control 30")
        {
            field("Invertor Serial No."; "Invertor Serial No.")
            {
            }
            field("Debit Note No."; "Debit Note No.")
            {
            }
            field("Credit Note No."; "Credit Note No.")
            {
            }
            field("Vehicle Reg. No."; "Vehicle Reg. No.")
            {
            }
        }
        addafter("Control 291")
        {
            field("Province No."; "Province No.")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 52".

        addafter("Action 52")
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
                    CustLedgEntry: Record "21";
                begin
                    CustLedgEntry.SETRANGE("Posting Date", Rec."Posting Date");
                    CustLedgEntry.SETRANGE("Document No.", Rec."Document No.");
                    CustLedgEntry.SETRANGE("Customer No.", Rec."Customer No.");
                    IF CustLedgEntry.FINDFIRST THEN
                        REPORT.RUNMODAL(33020032, TRUE, FALSE, CustLedgEntry);
                end;
            }
        }
        addafter("Action 13")
        {
            action(UpdateBankLC)
            {

                trigger OnAction()
                var
                    CustLedgerEntry: Record "21";
                    SalesInvHeader: Record "112";
                    ProgressWindow: Dialog;
                    DocNo: Code[20];
                begin
                end;
            }
        }
    }
}


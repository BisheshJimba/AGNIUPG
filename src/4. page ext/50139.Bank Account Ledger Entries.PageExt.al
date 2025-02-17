pageextension 50139 pageextension50139 extends "Bank Account Ledger Entries"
{

    //Unsupported feature: Property Modification (SourceTableView) on ""Bank Account Ledger Entries"(Page 372)".

    layout
    {
        addafter("Control 2")
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
        addafter("Control 14")
        {
            field("Cheque No."; "Cheque No.")
            {
            }
            field("External Document No."; Rec."External Document No.")
            {
            }
        }
        addafter("Control 26")
        {
            field("Debit Amount"; Rec."Debit Amount")
            {
            }
            field("Credit Amount"; Rec."Credit Amount")
            {
            }
            field("Debit Amount (LCY)"; Rec."Debit Amount (LCY)")
            {
            }
            field("Credit Amount (LCY)"; Rec."Credit Amount (LCY)")
            {
            }
        }
        addafter("Control 44")
        {
            field("VF Loan File No."; "VF Loan File No.")
            {
            }
            field("VF Customer Name"; "VF Customer Name")
            {
            }
            field("VF Posting Type"; "VF Posting Type")
            {
            }
        }
    }

    var
        GLEntry: Record "17";
        NextEntryNarration: Text[250];
}


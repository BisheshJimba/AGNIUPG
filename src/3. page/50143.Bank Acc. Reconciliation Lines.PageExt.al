pageextension 50143 pageextension50143 extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        addafter("Control 24")
        {
            field("Cheque No."; "Cheque No.")
            {
            }
        }
        addafter("Control 14")
        {
            field(Narration; Narration)
            {
            }
            field("Document Class"; "Document Class")
            {
            }
            field("Document Subclass"; "Document Subclass")
            {
            }
            field("Doc. Subclass Description"; "Doc. Subclass Description")
            {
            }
            field("Bal. Account No."; "Bal. Account No.")
            {
            }
            field("Bal. Account Name"; "Bal. Account Name")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "ShowStatementLineDetails(Action 9)".

    }
}


page 25006409 "Warranty Reimbursement Entries"
{
    Caption = 'Warranty Reimbursement Entries';
    Editable = false;
    PageType = List;
    SourceTable = Table25006407;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Warranty Document No."; "Warranty Document No.")
                {
                }
                field("Warranty Document Line No."; "Warranty Document Line No.")
                {
                }
                field("Document Date"; "Document Date")
                {
                    Visible = false;
                }
                field("Debit Code"; "Debit Code")
                {
                }
                field("Debit Description"; "Debit Description")
                {
                }
                field("Reject Code"; "Reject Code")
                {
                }
                field("Reject Description"; "Reject Description")
                {
                }
                field(Status; Status)
                {
                }
                field(Amount; Amount)
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}


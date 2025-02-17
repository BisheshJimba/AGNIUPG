page 25006227 "Ext. Service Registers"
{
    Caption = 'External Service Registers';
    Editable = false;
    PageType = List;
    SourceTable = Table25006152;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field("Creation Date"; "Creation Date")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Source Code"; "Source Code")
                {
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                }
                field("From Entry No."; "From Entry No.")
                {
                }
                field("To Entry No."; "To Entry No.")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Register")
            {
                Caption = '&Register';
                action("External Service Ledger")
                {
                    Caption = 'External Service Ledger';
                    Image = ServiceLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit 25006117;
                }
            }
        }
    }
}


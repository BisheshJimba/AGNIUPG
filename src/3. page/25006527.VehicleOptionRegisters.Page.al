page 25006527 "Vehicle Option Registers"
{
    // 28.06.2004 EDMS P1
    //    *Opened fields:
    //         - 25006670 "From Item Replmt. Entry No."
    //         - 25006680 "To Item Replmt. Entry No."
    // 
    // 12.07.2004 EDMS P1
    //    *Changed MenuButton "Register"
    //      - added new menu item: "Item replacement ledger"

    Caption = 'Vehicle Option Registers';
    Editable = false;
    PageType = List;
    SourceTable = Table25006390;

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
                action("Vehicle Option Ledger")
                {
                    Caption = 'Vehicle Option Ledger';
                    Image = LedgerEntries;
                    RunObject = Codeunit 25006313;
                }
            }
        }
    }
}


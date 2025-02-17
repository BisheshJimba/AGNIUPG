page 25006212 "Service Registers"
{
    Caption = 'Service Registers';
    Editable = false;
    PageType = List;
    SourceTable = Table25006168;

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
                field("Creation Time"; "Creation Time")
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
                field("From Tire Entry No."; "From Tire Entry No.")
                {
                }
                field("To Tire Entry No."; "To Tire Entry No.")
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
                action("Service Ledger")
                {
                    Caption = 'Service Ledger';
                    Image = ServiceLedger;
                    RunObject = Codeunit 25006102;
                }
                action("Tire Entries")
                {
                    Caption = 'Tire Entries';
                    Image = ServiceLedger;

                    trigger OnAction()
                    begin
                        TireEntry.SETRANGE("Entry No.", "From Tire Entry No.", "To Tire Entry No.");
                        PAGE.RUN(PAGE::"Tire Entries", TireEntry);
                    end;
                }
            }
        }
    }

    var
        TireEntry: Record "25006181";
}


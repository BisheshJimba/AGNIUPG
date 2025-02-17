page 33019981 "Cheque Registers"
{
    // Name        Version         Date        Description
    // ***********************************************************
    //             CTS6.1.2        24-09-12    Page Courier Tracking Check Lines
    // Ravi        CNY1.0          25-09-12    Previous Page "Courier Tracking Check Lines" has been changed to "Check Registers"

    Caption = 'Cheque Registers';
    Editable = false;
    PageType = List;
    SourceTable = Table33019972;

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
                field("Bank Account No."; "Bank Account No.")
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
                action("<Action11>")
                {
                    Caption = 'Cheque Entries';

                    trigger OnAction()
                    begin

                        ChequeEntry_G.RESET;
                        ChequeEntry_G.SETRANGE("Entry No.", "From Entry No.", "To Entry No.");
                        CheqEntriesPage.SETTABLEVIEW(ChequeEntry_G);
                        CheqEntriesPage.RUN;
                    end;
                }
            }
        }
    }

    var
        ChequeEntry_G: Record "33019971";
        CheqEntriesPage: Page "33019980";
}


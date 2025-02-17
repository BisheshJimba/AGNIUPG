pageextension 50290 pageextension50290 extends "FA Ledger Entries"
{
    layout
    {
        addafter("Control 10")
        {
            field("FA Posting Group"; Rec."FA Posting Group")
            {
            }
        }
    }
    actions
    {
        addafter("Action 18")
        {
            action("FA Ledger Entry Correction")
            {
                Visible = false;

                trigger OnAction()
                begin
                    TempCod.RUN;
                end;
            }
        }
    }

    var
        TempCod: Codeunit "25006202";
}


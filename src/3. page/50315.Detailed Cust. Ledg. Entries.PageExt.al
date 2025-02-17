pageextension 50315 pageextension50315 extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        addafter("Control 20")
        {
            field("Debit Amount"; Rec."Debit Amount")
            {
            }
            field("Credit Amount"; Rec."Credit Amount")
            {
            }
        }
        addafter("Control 2")
        {
            field("Ship-to Code"; Rec."Ship-to Code")
            {
            }
            field("Ship-to Address"; Rec."Ship-to Address")
            {
            }
            field("Ship-to Address 2"; Rec."Ship-to Address 2")
            {
            }
            field("Ship-to City"; Rec."Ship-to City")
            {
            }
            field("Ship-to Country"; Rec."Ship-to Country")
            {
            }
            field("Province No."; Rec."Province No.")
            {
            }
            field("Sys. LC No."; Rec."Sys. LC No.")
            {
            }
        }
    }
}


pageextension 50015 pageextension50015 extends "Inventory Posting Groups"
{
    // 21.01.2015 EDMS P11
    //   Vehicle special cost adjustment
    //   Added fields:
    //     25006001 "Split Value Entries"
    layout
    {
        addafter("Control 4")
        {
            field("Vehicle Additional Expenses"; Rec."Vehicle Additional Expenses")
            {
            }
            field("Split Value Entries"; Rec."Split Value Entries")
            {
            }
            field("Dealer Group"; Rec."Dealer Group")
            {
            }
            field("Description for VAT Book"; Rec."Description for VAT Book")
            {
            }
            field("HS Code Mandatory"; Rec."HS Code Mandatory")
            {
            }
        }
    }
}


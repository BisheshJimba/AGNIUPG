pageextension 50130 pageextension50130 extends "Gen. Product Posting Groups"
{
    // 21.01.2015 EDMS P11
    //   Vehicle special cost adjustment
    //   Added fields:
    //     25006000 "Split Value Entries"
    layout
    {
        addafter("Control 9")
        {
            field("Def. Inventory Posting Group"; Rec."Def. Inventory Posting Group")
            {
            }
            field("Make Inventory Value Zero"; Rec."Make Inventory Value Zero")
            {
            }
        }
        addafter("Control 12")
        {
            field("Split Value Entries"; Rec."Split Value Entries")
            {
            }
            field("Dealer Group"; Rec."Dealer Group")
            {
            }
            field("Description for VAT Book"; Rec."Description for VAT Book")
            {
            }
        }
    }
}


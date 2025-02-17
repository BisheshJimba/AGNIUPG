tableextension 50529 tableextension50529 extends "Inventory Posting Group"
{
    // 21.01.2015 EDMS P11
    //   Vehicle special cost adjustment
    //   Added fields:
    //     25006001 "Split Value Entries"
    Caption = 'Invt Posting Group';
    fields
    {
        field(50000; "Dealer Group"; Code[10])
        {
            TableRelation = "Inventory Posting Group";
        }
        field(60000; "Description for VAT Book"; Text[50])
        {
        }
        field(25006000; "Vehicle Additional Expenses"; Boolean)
        {
            Caption = 'Vehicle Additional Expenses';
        }
        field(25006001; "Split Value Entries"; Boolean)
        {
            Caption = 'Split Value Entries';
        }
        field(25006002; "HS Code Mandatory"; Boolean)
        {
        }
    }
}


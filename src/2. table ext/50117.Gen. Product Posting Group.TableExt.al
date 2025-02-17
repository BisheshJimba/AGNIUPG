tableextension 50117 tableextension50117 extends "Gen. Product Posting Group"
{
    // 21.01.2015 EDMS P11
    //   Vehicle special cost adjustment
    //   Added fields:
    //     25006000 "Split Value Entries"
    fields
    {
        field(50000; "Dealer Group"; Code[10])
        {
            TableRelation = "Gen. Product Posting Group";
        }
        field(50001; "Def. Inventory Posting Group"; Code[10])
        {
            TableRelation = "Inventory Posting Group";
        }
        field(50002; "Make Inventory Value Zero"; Boolean)
        {
        }
        field(60000; "Description for VAT Book"; Text[50])
        {
        }
        field(25006000; "Split Value Entries"; Boolean)
        {
            Caption = 'Split Value Entries';
        }
    }


    //Unsupported feature: Code Insertion on "OnInsert".

    //trigger OnInsert()
    //begin
    /*
    //Agile SRT 12/31/2018 >>
    TESTFIELD("Def. Inventory Posting Group");
    TESTFIELD("Def. VAT Prod. Posting Group");
    //Agile SRT 12/31/2018 <<
    */
    //end;
}


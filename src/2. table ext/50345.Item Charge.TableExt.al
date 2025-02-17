tableextension 50345 tableextension50345 extends "Item Charge"
{
    // //30-08-2007 EDMS P3
    //    * New field Inventory Posting Group
    fields
    {
        field(50000; "Link To Register Type"; Option)
        {
            OptionCaption = ' ,Insurance,Letter of Credit';
            OptionMembers = " ",Insurance,"Letter of Credit";
        }
        field(25006000; "Inventory Posting Group"; Code[10])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
    }
}


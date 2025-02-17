tableextension 50272 tableextension50272 extends "Misc. Article Information"
{
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 8)".

        field(25006000; "Inventory Posting Group"; Code[10])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(25006010; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
        }
    }
    keys
    {
        key(Key1; "Employee No.", "Misc. Article Code", "From Date", "To Date")
        {
        }
    }
}


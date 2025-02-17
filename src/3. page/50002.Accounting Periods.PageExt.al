pageextension 50002 pageextension50002 extends "Accounting Periods"
{
    Editable = false;
    Editable = false;
    layout
    {
        addafter(Control18)
        {
            field("Nepali Fiscal Year"; Rec."Nepali Fiscal Year")
            {
            }
            field("English Fiscal Year"; Rec."English Fiscal Year")
            {
            }
        }
    }
}


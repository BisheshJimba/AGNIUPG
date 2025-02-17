pageextension 50184 pageextension50184 extends "VAT Posting Setup"
{
    Editable = true;
    layout
    {
        addafter("Control 45")
        {
            field("Localized VAT Identifier"; Rec."Localized VAT Identifier")
            {
            }
        }
    }
}


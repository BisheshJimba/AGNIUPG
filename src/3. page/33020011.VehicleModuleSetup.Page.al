page 33020011 "Vehicle Module Setup"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table33020011;

    layout
    {
        area(content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field("LC Details Nos."; "LC Details Nos.")
                {
                }
                field("CC Nos."; "CC Nos.")
                {
                }
                field("CC PCD Nos."; "CC PCD Nos.")
                {
                    Visible = false;
                }
                field("Ins. Nos."; "Ins. Nos.")
                {
                }
                field("Ins. PCD Nos."; "Ins. PCD Nos.")
                {
                    Visible = false;
                }
            }
            group(Posting)
            {
                field("LC Template Name"; "LC Template Name")
                {
                }
                field("LC Batch Name"; "LC Batch Name")
                {
                }
                field("Markup %"; "Markup %")
                {
                }
                field("Prepaid Insurance A/C"; "Prepaid Insurance A/C")
                {
                }
                field("Reponsibility Center"; "Reponsibility Center")
                {
                    Visible = false;
                }
                field("Accountability Center"; "Accountability Center")
                {
                }
            }
        }
    }

    actions
    {
    }
}


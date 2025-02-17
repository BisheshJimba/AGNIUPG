pageextension 50426 pageextension50426 extends "Approval Request Entries"
{
    actions
    {
        addafter("Action 25")
        {
            action("<Action1000000000>")
            {
                Caption = 'Purchase Quote Comparison';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = false;
                RunObject = Report 50069;
            }
        }
    }
}


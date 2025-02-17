pageextension 50424 pageextension50424 extends "Approval Entries"
{

    //Unsupported feature: Property Modification (SourceTableView) on ""Approval Entries"(Page 658)".

    actions
    {
        addafter("Action 35")
        {
            action("<Action1000000000>")
            {
                Caption = 'Purchase Quote Comparison';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 50069;
            }
        }
    }
}


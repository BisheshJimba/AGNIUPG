pageextension 50419 pageextension50419 extends "Serial No. Information List"
{
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 1102601003".

        addfirst("Action 1102601001")
        {
            action("General Ledger Entries")
            {
                Image = Ledger;
                RunObject = Page 20;
                RunPageLink = Invertor Serial No.=FIELD(Serial No.);
                RunPageView = SORTING(Document No.,Posting Date);
            }
            action("Customer Ledger Entries")
            {
                Image = Ledger;
                RunObject = Page 25;
                                RunPageLink = Invertor Serial No.=FIELD(Serial No.);
                RunPageView = SORTING(Document No.,Posting Date,Currency Code);
            }
        }
    }
}


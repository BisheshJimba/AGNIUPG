pageextension 50544 pageextension50544 extends "Accounting Manager Role Center"
{
    Editable = false;
    actions
    {

        //Unsupported feature: Property Modification (RunPageView) on "PurchaseJournals(Action 117)".


        //Unsupported feature: Property Modification (RunPageView) on "SalesJournals(Action 118)".


        //Unsupported feature: Property Modification (RunPageView) on "CashReceiptJournals(Action 113)".


        //Unsupported feature: Property Modification (RunPageView) on "PaymentJournals(Action 114)".


        //Unsupported feature: Property Modification (RunPageView) on "ICGeneralJournals(Action 1102601000)".


        //Unsupported feature: Property Modification (RunPageView) on "GeneralJournals(Action 1102601001)".


        //Unsupported feature: Property Modification (RunPageView) on "Action 19".


        //Unsupported feature: Property Modification (RunPageView) on ""<Action3>"(Action 3)".

        addafter(VendorsBalance)
        {
            action("Sales Invoices")
            {
                RunObject = Page 33020251;
            }
        }
        addafter("Action 95")
        {
            action("General Journal")
            {
                Image = GLJournal;
                RunObject = Page 39;
            }
        }
    }
}


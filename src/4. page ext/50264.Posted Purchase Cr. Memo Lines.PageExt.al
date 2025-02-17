pageextension 50264 pageextension50264 extends "Posted Purchase Cr. Memo Lines"
{
    actions
    {

        //Unsupported feature: Code Modification on "Action 74.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        PurchCrMemoHeader.GET("Document No.");
        PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHeader);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        PurchCrMemoHeader.GET("Document No.");
        PAGE.RUN(PAGE::"Posted Debit Note",PurchCrMemoHeader);
        */
        //end;
    }
}


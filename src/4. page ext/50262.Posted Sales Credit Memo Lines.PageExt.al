pageextension 50262 pageextension50262 extends "Posted Sales Credit Memo Lines"
{
    actions
    {

        //Unsupported feature: Code Modification on "Action 60.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        SalesCrMemoHeader.GET("Document No.");
        PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        SalesCrMemoHeader.GET("Document No.");
        PAGE.RUN(PAGE::"Posted Credit Note",SalesCrMemoHeader);
        */
        //end;
    }
}


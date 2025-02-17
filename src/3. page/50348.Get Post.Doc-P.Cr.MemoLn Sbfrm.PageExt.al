pageextension 50348 pageextension50348 extends "Get Post.Doc-P.Cr.MemoLn Sbfrm"
{

    //Unsupported feature: Code Modification on "ShowDocument(PROCEDURE 5)".

    //procedure ShowDocument();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF NOT PurchCrMemoHeader.GET("Document No.") THEN
      EXIT;
    PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHeader);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF NOT PurchCrMemoHeader.GET("Document No.") THEN
      EXIT;
    PAGE.RUN(PAGE::"Posted Debit Note",PurchCrMemoHeader);
    */
    //end;
}


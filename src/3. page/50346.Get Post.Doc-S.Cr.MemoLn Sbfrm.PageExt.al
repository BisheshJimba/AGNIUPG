pageextension 50346 pageextension50346 extends "Get Post.Doc-S.Cr.MemoLn Sbfrm"
{

    //Unsupported feature: Code Modification on "ShowDocument(PROCEDURE 7)".

    //procedure ShowDocument();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF NOT SalesCrMemoHeader.GET("Document No.") THEN
      EXIT;
    PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF NOT SalesCrMemoHeader.GET("Document No.") THEN
      EXIT;
    PAGE.RUN(PAGE::"Posted Credit Note",SalesCrMemoHeader);
    */
    //end;
}


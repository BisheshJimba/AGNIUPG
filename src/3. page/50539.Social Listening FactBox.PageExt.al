pageextension 50539 pageextension50539 extends "Social Listening FactBox"
{

    //Unsupported feature: Code Modification on "UpdateAddIn(PROCEDURE 6)".

    //procedure UpdateAddIn();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF "Search Topic" = '' THEN
      EXIT;
    IF NOT IsAddInReady THEN
      EXIT;

    #6..11
      EXIT;

    CurrPage.SocialListening.DetermineUserAuthentication(SocialListeningMgt.MSLAuthenticationStatusURL);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF "Search Topic" = '' THEN
      EXIT;

    #3..14
    */
    //end;
}


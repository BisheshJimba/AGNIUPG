pageextension 50068 pageextension50068 extends "Office New Contact Dlg"
{
    layout
    {

        //Unsupported feature: Code Modification on "NewContact(Control 3).OnDrillDown".

        //trigger OnDrillDown()
        //>>>> ORIGINAL CODE:
        //begin
        /*
        Contact.SETRANGE("Search E-Mail",TempOfficeAddinContext.Email);
        IF NOT Contact.FINDFIRST THEN BEGIN
          NameLength := 50;
          IF STRPOS(TempOfficeAddinContext.Name,' ') = 0 THEN
            NameLength := 30;
          TempContact.INIT;
          TempContact.VALIDATE(Type,Contact.Type::Person);
          TempContact.VALIDATE(Name,COPYSTR(TempOfficeAddinContext.Name,1,NameLength));
          TempContact.VALIDATE("E-Mail",TempOfficeAddinContext.Email);
          TempContact.INSERT;
        #11..21
            Contact.ShowCustVendBank;
          CurrPage.CLOSE;
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..6
          TempContact.VALIDATE(Type,Contact.Type::Company);
        #8..24
        */
        //end;
    }
}


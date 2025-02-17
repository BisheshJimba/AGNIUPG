pageextension 50069 pageextension50069 extends "Office No Company Dlg"
{
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Company(Control 3)".


        //Unsupported feature: Code Modification on "CreateContactCompany(Control 6).OnDrillDown".

        //trigger OnDrillDown()
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ContactCompany.INIT;
        ContactCompany.COPY(Rec);
        ContactCompany."No." := '';
        ContactCompany.Type := ContactCompany.Type::Company;
        ContactCompany.INSERT(TRUE);
        COMMIT;
        IF ACTION::LookupOK = PAGE.RUNMODAL(PAGE::"Contact Card",ContactCompany) THEN BEGIN
          VALIDATE("Company No.",ContactCompany."No.");
          MODIFY(TRUE);
          PAGE.RUN(PAGE::"Contact Card",Rec);
        END ELSE
          ContactCompany.DELETE;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..3
        ContactCompany.Type := ContactCompany.Type::" ";
        #5..12
        */
        //end;
    }
}


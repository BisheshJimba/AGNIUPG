pageextension 50229 pageextension50229 extends "Opportunity List"
{
    // 11.11.2015 EB.P7 #T066
    //   Bugfix Oportunity Assign Quote
    // 
    // 09.01.2014 EDMS P8
    //   * Use Rec.SetPromptProfile
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 37".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 42".



        //Unsupported feature: Code Modification on "AssignSalesQuote(Action 34).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        AssignQuote;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //11.11.2015 EB.P7 #T066>>
        //SetPromptProfile(TRUE);
        //11.11.2015 EB.P7 #T066<<
        AssignQuote;
        */
        //end;
    }
}


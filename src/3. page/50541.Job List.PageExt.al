pageextension 50541 pageextension50541 extends "Job List"
{

    //Unsupported feature: Property Insertion (Permissions) on ""Job List"(Page 89)".

    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 84".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 34".


        //Unsupported feature: Property Modification (RunPageView) on "Action 153".


        //Unsupported feature: Property Modification (RunPageView) on "Action 154".


        //Unsupported feature: Property Modification (RunPageView) on "Action 32".

        addafter("Action 1901294206")
        {
            action("Temp. Update")
            {

                trigger OnAction()
                var
                    RecordRest: Record "1550";
                    PurchaseHeader: Record "38";
                    ValueEntry: Record "5802";
                    PostValueEntry: Record "5811";
                begin
                    //AASTHA UPG
                    PurchaseHeader.RESET;
                    PurchaseHeader.SETRANGE("No.", 'BIDPO75-02348');
                    IF PurchaseHeader.FINDFIRST THEN BEGIN
                        RecordRest.RESET;
                        IF RecordRest.FINDFIRST THEN
                            REPEAT
                            UNTIL RecordRest.NEXT = 0;
                    END;
                    //AASTHA UPG
                end;
            }
        }
    }
}


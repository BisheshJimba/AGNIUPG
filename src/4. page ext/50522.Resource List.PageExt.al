pageextension 50522 pageextension50522 extends "Resource List"
{
    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "Control 1906609707".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1907012907".

        addafter("Control 8")
        {
            field(Address; Rec.Address)
            {
            }
            field("Job Title"; Rec."Job Title")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 32".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 84".


        //Unsupported feature: Property Modification (RunPageView) on "Action 33".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 25".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 34".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 35".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 39".

    }

    procedure SetSelectionFilter1(var Resource: Record "156")
    begin
        CurrPage.SETSELECTIONFILTER(Resource);
    end;
}


pageextension 50207 pageextension50207 extends "Create Interaction"
{
    // 10.11.2015 EB.P30 #T065
    //   Added field "Vehicle Serial No."
    Editable = false;
    Editable = ENU=SpecifiesÙthe time when the interaction took place;
    layout
    {
        addafter("Control 22")
        {
            field("Model Version No."; Rec."Model Version No.")
            {
            }
            field("Vehicle Serial No."; Rec."Vehicle Serial No.")
            {
                Visible = false;
            }
        }
        addafter("Control 54")
        {
            field(Remarks; Remarks)
            {
            }
        }
    }

    var
        [InDataSet]
        NextEnable: Boolean;


    //Unsupported feature: Code Modification on "OnInit".

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SalespersonCodeEditable := TRUE;
    OpportunityDescriptionEditable := TRUE;
    CampaignDescriptionEditable := TRUE;
    IsOnMobile := CURRENTCLIENTTYPE = CLIENTTYPE::Phone;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    NextEnable := TRUE;
    #1..4
    */
    //end;
}


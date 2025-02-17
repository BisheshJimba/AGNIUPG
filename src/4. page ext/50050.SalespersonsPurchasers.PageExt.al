pageextension 50050 pageextension50050 extends "Salespersons/Purchasers"
{
    PromotedActionCategories = 'New,Process,Report,Pipeline';
    layout
    {
        addafter("Control 4")
        {
            field("Job Title"; Rec."Job Title")
            {
            }
        }
        addafter("Control 12")
        {
            field("SP for Vehicle"; "SP for Vehicle")
            {
            }
            field("Vehicle Division"; "Vehicle Division")
            {
            }
        }
        addafter("Control 6")
        {
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
            }
            field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
            {
            }
            field("Accountability Center"; "Accountability Center")
            {
            }
        }
        moveafter("Control 4"; "Control 12")
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 18".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 24".

        addfirst("Action 11")
        {
            action("<Action1102159010>")
            {
                Caption = 'Target';
                Image = EditList;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 33020200;
                RunPageLink = Salesperson Code=FIELD(Code);
                RunPageMode = View;
            }
        }
        addafter(CreateInteraction)
        {
            group("<Action1102159007>")
            {
                Caption = 'Function(s)';
                action("<Action1102159008>")
                {
                    Caption = 'KAP Activities';
                    Image = EditList;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page 33020201;
                                    RunPageLink = Salesperson Code=FIELD(Code);
                    RunPageMode = View;
                }
                action("<Action1000000000>")
                {
                    Caption = 'Pipeline Mgmt Details';
                    Image = EditList;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        // CNY.CRM >>
                        IF "Resource Group" <> '' THEN BEGIN
                          PipeLineDetails.RESET;
                          FILTERGROUP(2);
                          PipeLineDetails.SETRANGE("Make Code","Make Code");
                          IF ("Resource Group" = 'API') OR ("Resource Group" = 'PI') THEN
                            PipeLineDetails.SETRANGE("Model Code","Model Code")
                          ELSE IF "Resource Group" = 'SC' THEN
                            PipeLineDetails.SETRANGE("Global Dimension 1 Code","Global Dimension 1 Code");
                          FILTERGROUP(0);
                          PipelineDetailsPage.SETTABLEVIEW(PipeLineDetails);
                          PipelineDetailsPage.EDITABLE(TRUE);
                          PipelineDetailsPage.RUN;
                        END ELSE BEGIN
                          PipeLineDetails.RESET;
                          FILTERGROUP(2);
                          PipeLineDetails.SETRANGE("Salesperson Code",Code);
                          FILTERGROUP(0);
                          PipelineDetailsPage.SETTABLEVIEW(PipeLineDetails);
                          PipelineDetailsPage.EDITABLE(TRUE);
                          PipelineDetailsPage.RUN;
                        END;
                        // CNY.CRM <<
                    end;
                }
            }
        }
    }

    var
        gblUserSetup: Record "91";
        PipeLineDetails: Record "33020141";
        PipelineDetailsPage: Page "33020135";


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
        /*
        //Setting filter according to user
        gblUserSetup.GET(USERID);

        IF (gblUserSetup."Salespers./Purch. Code" <> '') THEN BEGIN
          FILTERGROUP(2);
          SETRANGE(Code,gblUserSetup."Salespers./Purch. Code");
          FILTERGROUP(0);
        END;
        */
    //end;
}


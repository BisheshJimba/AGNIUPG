pageextension 50225 pageextension50225 extends "Salesperson/Purchaser Card"
{
    Editable = false;
    Editable = false;
    layout
    {
        addafter("Control 6")
        {
            field("SP for Vehicle"; "SP for Vehicle")
            {
            }
        }
        addafter("Control 12")
        {
            field("Is Dealer"; "Is Dealer")
            {
            }
            field("Dealer Information"; "Dealer Information")
            {
            }
            field(Area;Area)
            {
            }
            field("Vehicle Division";"Vehicle Division")
            {
            }
            field("M Skill";"M Skill")
            {
            }
            field("Accountability Center";"Accountability Center")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 23".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 35".

        addfirst("Action 19")
        {
            action(Target)
            {
                Image = EditList;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 33020200;
                                RunPageLink = Salesperson Code=FIELD(Code);
                RunPageMode = View;
            }
        }
        addafter(Coupling)
        {
            group(Functions)
            {
                Caption = 'Functions';
            }
            action("KAP Activities")
            {
                Image = EditList;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 33020201;
                                RunPageLink = Salesperson Code=FIELD(Code);
                RunPageMode = View;
            }
            action("Pipeline Mgmt Details")
            {
                Image = EditList;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    // CNY.CRM >>
                    IF "Resource Group" <> '' THEN BEGIN
                      FILTERGROUP(2);
                      PipeLineDetails.RESET;
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
                      FILTERGROUP(2);
                      PipeLineDetails.RESET;
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

    var
        Mail: Codeunit "397";
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


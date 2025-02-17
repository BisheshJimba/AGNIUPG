pageextension 50138 pageextension50138 extends "Bank Account List"
{
    PromotedActionCategories = 'New,Process,Report,Bank Statement Service,Letter of Credit';
    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "Control 1905532107".

        addafter("Control 97")
        {
            field("Bank Branch Name"; "Bank Branch Name")
            {
            }
        }
        addafter("Control 10")
        {
            field("Balance (LCY)"; Rec."Balance (LCY)")
            {
            }
            field("Net Change (LCY)"; Rec."Net Change (LCY)")
            {
            }
            field("Balance at Date (LCY)"; Rec."Balance at Date (LCY)")
            {
            }
            field(Limit; Limit)
            {
            }
            field("Remaining Limit"; "Remaining Limit")
            {
                Editable = false;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 17".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 18".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 84".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 6".


        //Unsupported feature: Property Modification (RunPageView) on "Action 19".


        //Unsupported feature: Property Modification (RunPageView) on "Action 20".


        //Unsupported feature: Property Modification (RunPageView) on "PagePosPayEntries(Action 5)".

        addfirst("Action 15")
        {
            action("Test Bank Account Validation")
            {
                Image = TestFile;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = TestAccVisible;

                trigger OnAction()
                var
                    CIPSWebServiceMgt: Codeunit "33019811";
                    ResponseMessage: Text;
                    AccMatchPercent: Code[10];
                    ResponseCode: Code[10];
                begin
                    IF CIPSWebServiceMgt.CheckBankAccountValidation("Bank ID", Rec."Bank Account No.", "Bank Account Name") THEN BEGIN
                        CIPSWebServiceMgt.GetBankAccountValidationResponse(ResponseCode, ResponseMessage, AccMatchPercent);
                        MESSAGE('Account is applicable for IPS.\Account Match Percentage : %1\Response Message : %2',
                                 AccMatchPercent, ResponseMessage);
                    END ELSE BEGIN
                        CIPSWebServiceMgt.GetBankAccountValidationResponse(ResponseCode, ResponseMessage, AccMatchPercent);
                        MESSAGE('Account is not valid. Response code does not indicate success.\Account Match Percentage : %1\Response Message : %2',
                                AccMatchPercent, ResponseMessage);
                    END;
                end;
            }
        }
        addafter("Action 25")
        {
            action("Bank LC Credit Limit")
            {
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page 33020020;
                RunPageLink = Bank No.=FIELD(No.);
                Visible = false;
            }
        }
    }

    var
        "--NCHL-NPI_1.00--": Integer;
        CompanyInfo: Record "79";
        TestAccVisible: Boolean;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CALCFIELDS("Check Report Name");
        GetOnlineFeedStatementStatus(OnlineFeedStatementStatus,Linked);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        CALCFIELDS("Check Report Name");
        GetOnlineFeedStatementStatus(OnlineFeedStatementStatus,Linked);
        SetControlAppearance; //NCHL-NPI_1.00
        CALCFIELDS("Balance (LCY)");
        "Remaining Limit" := Limit - "Balance (LCY)"; //Min
        */
    //end;

    local procedure SetControlAppearance()
    begin
        CompanyInfo.GET;
        TestAccVisible := CompanyInfo."Enable NCHL-NPI Integration";
    end;
}


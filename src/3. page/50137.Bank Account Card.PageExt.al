pageextension 50137 pageextension50137 extends "Bank Account Card"
{
    PromotedActionCategories = 'New,Process,Report,Bank Statement Service,Bank Account,Letter of Credit';
    layout
    {
        addafter("Control 17")
        {
            field("Interest Rate"; "Interest Rate")
            {
            }
            field(Saved; Saved)
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
        addafter("Control 1902768601")
        {
            group("NCHL-NPI Setup")
            {
                field("Bank ID"; "Bank ID")
                {
                }
                field("Bank Name"; "Bank Name")
                {
                }
                field("Bank Branch ID"; Rec."Bank Branch No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Branch No.';
                    ToolTip = 'Specifies a number of the bank branch.';
                }
                field("Bank Branch Name"; "Bank Branch Name")
                {
                }
                field("Bank Account Name"; "Bank Account Name")
                {
                }
                field("Bank Account No"; Rec."Bank Account No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bank Account No';
                    Importance = Promoted;
                    ToolTip = 'Specifies the number used by the bank for the bank account.';
                }
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 42".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 43".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 84".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 52".


        //Unsupported feature: Property Modification (RunPageView) on "Action 44".


        //Unsupported feature: Property Modification (RunPageView) on "Action 46".


        //Unsupported feature: Property Modification (RunPageView) on "PagePositivePayEntries(Action 35)".

        addfirst("Action 40")
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
        addafter("Action 86")
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
        addafter(AutomaticBankStatementImportSetup)
        {
            action(Save)
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to save the customer card?') THEN BEGIN //MIN 4/30/2019
                     Saved := TRUE;
                     MODIFY;
                    END;
                    TESTFIELD(Name);
                    TESTFIELD("Bank Account No.");
                    TESTFIELD(Address);
                    TESTFIELD(City);
                    TESTFIELD("Phone No.");
                    TESTFIELD("Bank Acc. Posting Group");
                    TESTFIELD("SWIFT Code");
                end;
            }
        }
    }

    var
        SaveBankPageConf: Label 'You must first save the Bank Card page before close it.';
        "--NCHL-NPI_1.00--": Integer;
        CompanyInfo: Record "79";
        TestAccVisible: Boolean;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        GetOnlineFeedStatementStatus(OnlineFeedStatementStatus,Linked);
        CALCFIELDS("Check Report Name");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        GetOnlineFeedStatementStatus(OnlineFeedStatementStatus,Linked);
        CALCFIELDS("Check Report Name");
        SetControlAppearance; //NCHL-NPI_1.00
        CALCFIELDS("Balance (LCY)");
        "Remaining Limit" := Limit - "Balance (LCY)"; //Min
        */
    //end;


    //Unsupported feature: Code Insertion on "OnQueryClosePage".

    //trigger OnQueryClosePage(CloseAction: Action): Boolean
    //begin
        /*
        IF NOT Saved THEN //MIN 4/30/2019
          ERROR(SaveBankPageConf);
        */
    //end;

    local procedure SetControlAppearance()
    begin
        CompanyInfo.GET;
        TestAccVisible := CompanyInfo."Enable NCHL-NPI Integration";
    end;
}


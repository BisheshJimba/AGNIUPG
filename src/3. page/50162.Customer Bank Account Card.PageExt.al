pageextension 50162 pageextension50162 extends "Customer Bank Account Card"
{
    layout
    {
        modify("Control 64")
        {
            Visible = false;
        }
        modify("Control 36")
        {
            Visible = false;
        }
        modify("Control 50")
        {
            Visible = false;
        }
        addafter("Control 4")
        {
            field("Name 2"; Rec."Name 2")
            {
            }
        }
        addafter("Control 1")
        {
            group("NCHL-NPI Integration")
            {
                field("Bank ID"; "Bank ID")
                {
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                }
                field("Bank Branch Name"; "Bank Branch Name")
                {
                }
                field("Bank Account Name"; "Bank Account Name")
                {
                }
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 5".

        addfirst("Action 5")
        {
            action("Test Bank Account Validation")
            {
                Image = TestFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CIPSWebServiceMgt: Codeunit "33019811";
                    Vendor: Record "23";
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
    }
}


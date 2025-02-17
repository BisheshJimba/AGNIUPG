page 33019810 "NCHL-NPI Setup"
{
    PageType = Card;
    SourceTable = Table33019810;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Base URL"; "Base URL")
                {
                }
                field("Username (Basic Auth.)"; "Username (Basic Auth.)")
                {
                }
                field("Password (Basic Auth.)"; "Password (Basic Auth.)")
                {
                }
                field("Username (User Auth.)"; "Username (User Auth.)")
                {
                }
                field("Password (User Auth.)"; "Password (User Auth.)")
                {
                }
                field("Success Status Code"; "Success Status Code")
                {
                }
                field("Rest Method"; "Rest Method")
                {
                }
                field("Max API Call Count"; "Max API Call Count")
                {
                    ToolTip = 'Defines how many records can be updated at a time while calling transaction response update API';
                }
                field("User Change Approver Email"; "User Change Approver Email")
                {
                }
                field("Notify Receiver via Email"; "Notify Receiver via Email")
                {
                    ToolTip = 'if the value is true then email will be sent to receiver regarding the payment ';
                }
                field("Notification Gateway Method"; "Notification Gateway Method")
                {
                }
                field("APP ID IRD"; "APP ID IRD")
                {
                }
                field("APP ID CIT"; "APP ID CIT")
                {
                }
            }
            group("No. Series")
            {
                field("Real Time Batch ID Series"; "Real Time Batch ID Series")
                {
                }
                field("Non-Real Time Batch ID Series"; "Non-Real Time Batch ID Series")
                {
                }
            }
            group("Token Setup")
            {
                field("Refresh Token Validity"; "Refresh Token Validity")
                {
                }
                field("Access Token Validity"; "Access Token Validity")
                {
                }
                field("Refresh Token Generated On"; "Refresh Token Generated On")
                {
                }
                field("Access Token Generated On"; "Access Token Generated On")
                {
                }
                field("Refresh Token"; "Refresh Token")
                {
                    Editable = true;
                }
                field("Access Token"; "Access Token")
                {
                    Editable = true;
                }
            }
            group(Certificate)
            {
                field("Hash Algorithm"; "Hash Algorithm")
                {
                }
                field("Certificate Path"; "Certificate Path")
                {
                    Caption = 'Path';
                }
                field("Certificate Password"; "Certificate Password")
                {
                    Caption = 'Password';
                }
            }
            group("Alternative for Bank Validation")
            {
                Caption = 'Alternative for Bank Validation';
                field("Alt. Code (Bank Validation)"; "Alt. Code (Bank Validation)")
                {
                }
                field("Alt. Match % (Bank Validation)"; "Alt. Match % (Bank Validation)")
                {
                }
            }
            group("Payment Limit")
            {
                Caption = 'Payment Limit';
                field("Per Transaction Limit"; "Per Transaction Limit")
                {
                }
                field("Per Day Total Trans. Limit"; "Per Day Total Trans. Limit")
                {
                }
            }
            group("OTP Setup")
            {
                field("Use OTP Authentication"; "Use OTP Authentication")
                {
                }
                field("OTP Character Length"; "OTP Character Length")
                {
                }
                field("OTP Expiry Period"; "OTP Expiry Period")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Token Generation")
            {
                Image = Task;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CIPSWebServiceMgt.GetAccessToken;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;
    end;

    var
        CIPSWebServiceMgt: Codeunit "33019811";
        CIPSIntegrationMgt: Codeunit "33019810";
}


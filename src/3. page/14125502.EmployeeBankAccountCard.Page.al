page 14125502 "Employee Bank Account Card"
{
    PageType = Card;
    SourceTable = Table14125604;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Code)
                {
                }
                field("Employee No."; "Employee No.")
                {
                }
                field(Name; Name)
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field(City; City)
                {
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field(Contact; Contact)
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Transit No."; "Transit No.")
                {
                }
            }
            group("NCHL-NPI Integration")
            {
                field("Bank ID"; "Bank ID")
                {
                }
                field("Bank Branch No."; "Bank Branch No.")
                {
                }
                field("Bank Account No."; "Bank Account No.")
                {
                }
                field("Bank Branch Name"; "Bank Branch Name")
                {
                }
                field("Bank Account Name"; "Bank Account Name")
                {
                }
            }
            group(Communication)
            {
                field("Fax No."; "Fax No.")
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
                field("Home Page"; "Home Page")
                {
                }
            }
            group(Transfer)
            {
                field("SWIFT Code"; "SWIFT Code")
                {
                }
                field(IBAN; IBAN)
                {
                }
                field("Bank Clearing Code"; "Bank Clearing Code")
                {
                }
                field("Bank Clearing standred"; "Bank Clearing standred")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup19)
            {
                action("Test Bank Account Validation")
                {
                    Image = TestFile;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = TestAccVisible;

                    trigger OnAction()
                    var
                        CIPSWebServiceMgt: Codeunit "33019811";
                        Vendor: Record "23";
                        ResponseMessage: Text;
                        AccMatchPercent: Code[10];
                        ResponseCode: Code[10];
                    begin
                        BEGIN
                            IF CIPSWebServiceMgt.CheckBankAccountValidation("Bank ID", "Bank Account No.", Name) THEN BEGIN
                                CIPSWebServiceMgt.GetBankAccountValidationResponse(ResponseCode, ResponseMessage, AccMatchPercent);
                                MESSAGE('Account is applicable for IPS.\Account Match Percentage : %1\Response Message : %2',
                                                                   AccMatchPercent, ResponseMessage);
                            END ELSE BEGIN
                                CIPSWebServiceMgt.GetBankAccountValidationResponse(ResponseCode, ResponseMessage, AccMatchPercent);
                                MESSAGE('Account is not valid. Response code does not indicate success.\Account Match Percentage : %1\Response Message : %2',
                                                              AccMatchPercent, ResponseMessage);
                            END

                        END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BEGIN
            SetControlAppearance;
        END;
    end;

    trigger OnOpenPage()
    begin
        BEGIN
            SetControlAppearance;
        END;

        VALIDATE("Employee No.", GETFILTER("Employee No."));
    end;

    var
        CIPSWebServiceMgt: Codeunit "33019811";
        CompanyInfo: Record "79";
        TestAccVisible: Boolean;

    local procedure SetControlAppearance()
    begin
        BEGIN
            CompanyInfo.GET;
            TestAccVisible := CompanyInfo."Enable NCHL-NPI Integration";
        END;
    end;
}


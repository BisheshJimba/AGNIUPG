page 14125501 "Employee Bank Account List"
{
    CardPageID = "Employee Bank Account Card";
    PageType = List;
    SourceTable = Table14125604;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field(Code; Code)
                {
                }
                field(Name; Name)
                {
                }
                field("Name 2"; "Name 2")
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field(City; City)
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
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
                    CIPSWebServiceMgmt: Codeunit "33019811";
                    Vendor: Record "23";
                    ResponseMessage: Text;
                    AccMatchPercent: Code[10];
                    ResponseCode: Code[10];
                begin
                    BEGIN
                        IF CIPSWebServiceMgmt.CheckBankAccountValidation("Bank ID", "Bank Account No.", Name) THEN BEGIN
                            CIPSWebServiceMgmt.GetBankAccountValidationResponse(ResponseCode, ResponseMessage, AccMatchPercent);
                            MESSAGE('Account is applicable for IPS.\Account Match Percentage : %1\Response Message : %2', AccMatchPercent, ResponseMessage);
                        END ELSE BEGIN
                            CIPSWebServiceMgmt.GetBankAccountValidationResponse(ResponseCode, ResponseMessage, AccMatchPercent);
                            MESSAGE('Account is not valid. Response code does not indicate success.\Account Match Percentage : %1\Response Message : %2',
                                                             AccMatchPercent, ResponseMessage);
                        END;
                    END;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BEGIN
            SetControlAppearance;
        END;
    end;

    var
        TestAccVisible: Boolean;
        "--NCHL-NPI_1.00--": Integer;
        CompanyInfo: Record "79";

    local procedure SetControlAppearance()
    begin
        BEGIN
            CompanyInfo.GET();
            TestAccVisible := CompanyInfo."Enable NCHL-NPI Integration";
        END;
    end;
}


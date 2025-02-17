page 33019817 "NCHL-NPI Approval Workflow"
{
    PageType = Card;
    SourceTable = Table33019815;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Amount Filter"; "Amount Filter")
                {
                    Visible = false;
                }
                field("Source Code"; "Source Code")
                {
                }
            }
            part(; 33019818)
            {
                SubPageLink = Approval Code=FIELD(Code);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group()
            {
                action("Send Change Request")
                {
                    Image = SendApprovalRequest;
                    Visible = NOT ApprovalVisible;

                    trigger OnAction()
                    begin
                        IF NOT CONFIRM('Do you want to send approver user change request?', FALSE) THEN
                            EXIT;
                        NCHLNPIIntegrationMgt.SendUserChangeRequestApproval(Rec);
                    end;
                }
                action(Approve)
                {
                    Image = Approve;
                    Visible = ApprovalVisible;

                    trigger OnAction()
                    begin
                        IF NOT CONFIRM('Do you want to approve the user change request?', FALSE) THEN
                            EXIT;
                        NCHLNPIIntegrationMgt.ApproveUserChangeRequest(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlProperty;
    end;

    trigger OnOpenPage()
    begin
        SetControlProperty;
    end;

    var
        NCHLNPIIntegrationMgt: Codeunit "33019810";
        UserSetup: Record "91";
        ApprovalVisible: Boolean;

    local procedure SetControlProperty()
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Can Approve NCHL-NPI User" THEN
            ApprovalVisible := FALSE
        ELSE
            ApprovalVisible := TRUE;
    end;
}


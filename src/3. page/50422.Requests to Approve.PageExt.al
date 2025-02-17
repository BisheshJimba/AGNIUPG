pageextension 50422 pageextension50422 extends "Requests to Approve"
{

    //Unsupported feature: Property Modification (SourceTableView) on ""Requests to Approve"(Page 654)".

    layout
    {
        addafter("Control 6")
        {
            field(Amount; Rec.Amount)
            {
                AutoFormatExpression = Rec."Currency Code";
            }
            field("Receiver Name"; Rec."Receiver Name")
            {
                Editable = false;
                Visible = NPIVisible;
            }
            field("Sender Name"; Rec."Sender Name")
            {
                Editable = false;
                Visible = NPIVisible;
            }
        }
    }
    actions
    {
        modify(Delegate)
        {
            Visible = false;
            Enabled = false;
        }


        //Unsupported feature: Code Modification on "Approve(Action 19).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CurrPage.SETSELECTIONFILTER(ApprovalEntry);
        ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        CompanyInformation.GET;
        IF (CompanyInformation."Enable NCHL-NPI Integration") AND (NOT "Custom Approval") THEN BEGIN //NCHL-NPI_1.00
          NCHLNPIIntegrationMgt.ApproveJournalApprovalRequest("Journal Template Name","Journal Batch Name","Document No.");
        END
        ELSE BEGIN
          IF "Custom Approval" THEN
            CustomApproval.OnApproveDoc("Document No.")//aakrista for procurement approval
          ELSE BEGIN
            CurrPage.SETSELECTIONFILTER(ApprovalEntry);
            ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
          END;
        END;
        */
        //end;


        //Unsupported feature: Code Modification on "Reject(Action 2).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CurrPage.SETSELECTIONFILTER(ApprovalEntry);
        ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        CompanyInformation.GET;
        IF CompanyInformation."Enable NCHL-NPI Integration" AND (NOT "Custom Approval") THEN BEGIN //NCHL-NPI_1.00
          NCHLNPIIntegrationMgt.RejectJournalApprovalRequest("Journal Template Name","Journal Batch Name","Document No.");
        END
        ELSE BEGIN
          IF "Custom Approval" THEN
            CustomApproval.OnRejectDoc("Document No.")//aakrista for procurement approval
          ELSE BEGIN
            CurrPage.SETSELECTIONFILTER(ApprovalEntry);
            ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
          END;
        END;
        */
        //end;
    }

    var
        "--NCHL-NPI_1.00": Integer;
        CompanyInformation: Record "79";
        NCHLNPIIntegrationMgt: Codeunit "33019810";
        NPIVisible: Boolean;
        CustomApproval: Codeunit "25006201";


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetDateStyle;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    SetDateStyle;
    SetControlProperty; //NCHL-NPI_1.00
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    FILTERGROUP(2);
    SETRANGE("Approver ID",USERID);
    FILTERGROUP(0);
    SETRANGE(Status,Status::Open);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4
    SetControlProperty; //NCHL-NPI_1.00
    */
    //end;

    local procedure SetControlProperty()
    begin
        CompanyInformation.GET;
        NPIVisible := CompanyInformation."Enable NCHL-NPI Integration";
    end;
}


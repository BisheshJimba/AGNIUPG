codeunit 33019915 "Doc. Approval Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text33019915: Label 'Already sent for approval.';
        Text33019928: Label 'Status changed to Approved!';
        Text33019929: Label 'Status changed to Rejected!';
        Text33019930: Label 'Document sent for further approval process!';
        GblDocAppvNotificationMngt: Codeunit "33019917";
        GblUserSetup: Record "91";
        Text33019931: Label 'Sorry, you cannot approve the document. Document is already - %1.';
        Text33019932: Label 'Sorry, you cannot Cancel the request. Document is already - %1.';
        Text33019933: Label 'Sorry, you cannot Reject this document. Document is already - %1.';

    [Scope('Internal')]
    procedure sendAppReqVehInsurance(PrmTableNo: Integer; PrmDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll; PrmDocNo: Code[20]; PrmVehDiv: Option " ",Coupon,Stock,Cash,CVD,PCD,Requisition,Summary)
    var
        LclDocAppEntry: Record "33019915";
        LclDocAppEntry2: Record "33019915";
        LclEntryNo: Integer;
        Text33019920: Label 'Approval request by - %1 has been sent to approver - %2.';
    begin
        //Checking the record in Document Approval Entry table and inserting informations - Insurance.
        LclDocAppEntry.RESET;
        LclDocAppEntry.SETRANGE("Table ID", PrmTableNo);
        LclDocAppEntry.SETRANGE("Document Type", PrmDocType);
        LclDocAppEntry.SETRANGE("Document No.", PrmDocNo);
        LclDocAppEntry.SETRANGE("Entry Type", PrmVehDiv);
        IF NOT LclDocAppEntry.FIND('-') THEN BEGIN
            LclDocAppEntry2.INIT;
            LclDocAppEntry2."Entry No." := getLastEntryNo + 1;
            LclDocAppEntry2."Table ID" := PrmTableNo;
            LclDocAppEntry2."Document Type" := PrmDocType;
            LclDocAppEntry2."Document No." := PrmDocNo;
            LclDocAppEntry2."Sender ID" := USERID;
            LclDocAppEntry2."Approver ID" := getApproverID;
            LclDocAppEntry2.Status := LclDocAppEntry2.Status::Open;
            LclDocAppEntry2."Date Time Sent for Approval" := CURRENTDATETIME;
            LclDocAppEntry2."Due Date" := CALCDATE('1D', TODAY);
            LclDocAppEntry."Entry Type" := PrmVehDiv;
            LclDocAppEntry2.INSERT;
            //Calling approval notification.
            GblDocAppvNotificationMngt.sendInsMemoAppNot(LclDocAppEntry2."Sender ID");
            MESSAGE(Text33019920, LclDocAppEntry2."Sender ID", LclDocAppEntry2."Approver ID");
        END ELSE
            MESSAGE(Text33019915);
    end;

    [Scope('Internal')]
    procedure cancelAppReqVehIns(PrmTableNo: Integer; PrmDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll; PrmDocNo: Code[20])
    var
        LclDocAppEntry4: Record "33019915";
        Text33019921: Label 'Are you sure - cancel?';
        Text33019922: Label 'Approval request has been canceled!';
        LclConfirmCancel: Boolean;
        Text33019923: Label 'Aborted by user - %1!';
    begin
        //Canceling the approval request.
        LclConfirmCancel := DIALOG.CONFIRM(Text33019921, FALSE);
        IF LclConfirmCancel THEN BEGIN
            LclDocAppEntry4.RESET;
            LclDocAppEntry4.SETRANGE("Table ID", PrmTableNo);
            LclDocAppEntry4.SETRANGE("Document Type", PrmDocType);
            LclDocAppEntry4.SETRANGE("Document No.", PrmDocNo);
            IF LclDocAppEntry4.FIND('-') THEN BEGIN
                IF (LclDocAppEntry4.Status = LclDocAppEntry4.Status::Open) THEN BEGIN
                    LclDocAppEntry4.Status := LclDocAppEntry4.Status::Canceled;
                    LclDocAppEntry4."Last Modified By" := USERID;
                    LclDocAppEntry4."Last Date Time Modified" := CURRENTDATETIME;
                    LclDocAppEntry4.MODIFY;
                    //Sending calcellation information to approver.
                    GblDocAppvNotificationMngt.sendInsMemoCnclNot(LclDocAppEntry4."Sender ID");
                    MESSAGE(Text33019922);
                END ELSE
                    ERROR(Text33019932, LclDocAppEntry4.Status);
            END;
        END ELSE
            MESSAGE(Text33019923, USERID);
    end;

    [Scope('Internal')]
    procedure sendAppReqVehCC(PrmTableNo: Integer; PrmDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll; PrmDocNo: Code[20]; PrmVehDiv: Option " ",Coupon,Stock,Cash,CVD,PCD,Requisition,Summary)
    var
        LclDocAppEntry: Record "33019915";
        LclDocAppEntry2: Record "33019915";
        LclEntryNo: Integer;
        Text33019916: Label 'Approval request by - %1 has been sent to approver - %2.';
    begin
        //Checking the record in Document Approval Entry table and inserting informations if not available.
        LclDocAppEntry.RESET;
        LclDocAppEntry.SETRANGE("Table ID", PrmTableNo);
        LclDocAppEntry.SETRANGE("Document Type", PrmDocType);
        LclDocAppEntry.SETRANGE("Document No.", PrmDocNo);
        IF NOT LclDocAppEntry.FIND('-') THEN BEGIN
            LclDocAppEntry2.INIT;
            LclDocAppEntry2."Entry No." := getLastEntryNo + 1;
            LclDocAppEntry2."Table ID" := PrmTableNo;
            LclDocAppEntry2."Document Type" := PrmDocType;
            LclDocAppEntry2."Document No." := PrmDocNo;
            LclDocAppEntry2."Sender ID" := USERID;
            LclDocAppEntry2."Approver ID" := getApproverID;
            LclDocAppEntry2.Status := LclDocAppEntry2.Status::Open;
            LclDocAppEntry2."Date Time Sent for Approval" := CURRENTDATETIME;
            LclDocAppEntry2."Due Date" := CALCDATE('1D', TODAY);
            LclDocAppEntry2."Entry Type" := PrmVehDiv;
            LclDocAppEntry2.INSERT;
            //Sending approval notification email to approver.
            GblDocAppvNotificationMngt.sendCCMemoAppNot(LclDocAppEntry2."Sender ID");
            MESSAGE(Text33019916, LclDocAppEntry2."Sender ID", LclDocAppEntry2."Approver ID");
        END ELSE
            MESSAGE(Text33019915);
    end;

    [Scope('Internal')]
    procedure cancelAppReqVehCC(PrmTableNo: Integer; PrmDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll; PrmDocNo: Code[20])
    var
        LclDocAppEntry: Record "33019915";
        Text33019917: Label 'Are you sure - Cancel?';
        Text33019918: Label 'Approval request has been canceled!';
        LclConfirmCancel: Boolean;
        Text33019919: Label 'Aborted by user - %1!';
    begin
        //Canceling the approval request for Custom Clearance Memo.
        LclConfirmCancel := DIALOG.CONFIRM(Text33019917, FALSE);
        IF LclConfirmCancel THEN BEGIN
            LclDocAppEntry.RESET;
            LclDocAppEntry.SETRANGE("Table ID", PrmTableNo);
            LclDocAppEntry.SETRANGE("Document Type", PrmDocType);
            LclDocAppEntry.SETRANGE("Document No.", PrmDocNo);
            IF LclDocAppEntry.FIND('-') THEN BEGIN
                IF (LclDocAppEntry.Status = LclDocAppEntry.Status::Open) THEN BEGIN
                    LclDocAppEntry.Status := LclDocAppEntry.Status::Canceled;
                    LclDocAppEntry."Last Modified By" := USERID;
                    LclDocAppEntry."Last Date Time Modified" := CURRENTDATETIME;
                    LclDocAppEntry.MODIFY;
                    //Sending cancelation notification to approver.
                    GblDocAppvNotificationMngt.sendCCMemoCnclNot(LclDocAppEntry."Sender ID");
                    MESSAGE(Text33019918);
                END ELSE
                    ERROR(Text33019932, LclDocAppEntry.Status);
            END;
        END ELSE
            MESSAGE(Text33019919, USERID);
    end;

    [Scope('Internal')]
    procedure sendAppReqFuelIssue(PrmTableNo: Integer; PrmDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll; PrmDocNo: Code[20]; PrmFuelIssueType: Option " ",Coupon,Stock,Cash,CVD,PCD,Requisition,Summary)
    var
        LclDocAppEntry: Record "33019915";
        LclDocAppEntry2: Record "33019915";
        LclEntryNo: Integer;
        Text33019924: Label 'Approval request by - %1 has been sent to approver - %2.';
    begin
        //Checking the record in Document Approval Entry table and inserting informations if not available.
        LclDocAppEntry.RESET;
        LclDocAppEntry.SETRANGE("Table ID", PrmTableNo);
        LclDocAppEntry.SETRANGE("Document Type", PrmDocType);
        LclDocAppEntry.SETRANGE("Document No.", PrmDocNo);
        LclDocAppEntry.SETRANGE("Entry Type", PrmFuelIssueType);
        IF NOT LclDocAppEntry.FIND('-') THEN BEGIN
            LclDocAppEntry2.INIT;
            LclDocAppEntry2."Entry No." := getLastEntryNo + 1;
            LclDocAppEntry2."Table ID" := PrmTableNo;
            LclDocAppEntry2."Document Type" := PrmDocType;
            LclDocAppEntry2."Document No." := PrmDocNo;
            LclDocAppEntry2."Sender ID" := USERID;
            LclDocAppEntry2."Approver ID" := getApproverID;
            LclDocAppEntry2.Status := LclDocAppEntry2.Status::Open;
            LclDocAppEntry2."Date Time Sent for Approval" := CURRENTDATETIME;
            LclDocAppEntry2."Due Date" := CALCDATE('1D', TODAY);
            LclDocAppEntry2."Entry Type" := PrmFuelIssueType;
            LclDocAppEntry2.INSERT;
            //Sending approval notification email to approver.
            GblDocAppvNotificationMngt.sendFuelIssueAppNot(LclDocAppEntry2."Sender ID");
            MESSAGE(Text33019924, LclDocAppEntry2."Sender ID", LclDocAppEntry2."Approver ID");
        END ELSE
            MESSAGE(Text33019915);
    end;

    [Scope('Internal')]
    procedure cancelAppReqFuelIssue(PrmTableNo: Integer; PrmDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll; PrmDocNo: Code[20]; PrmFuelIssueType: Option " ",Coupon,Stock,Cash,CVD,PCD,Requisition,Summary)
    var
        LclDocAppEntry4: Record "33019915";
        Text33019925: Label 'Are you sure - cancel?';
        Text33019926: Label 'Approval request has been canceled!';
        LclConfirmCancel: Boolean;
        Text33019927: Label 'Aborted by user - %1!';
    begin
        //Canceling the approval request.
        LclConfirmCancel := DIALOG.CONFIRM(Text33019925, FALSE);
        IF LclConfirmCancel THEN BEGIN
            LclDocAppEntry4.RESET;
            LclDocAppEntry4.SETRANGE("Table ID", PrmTableNo);
            LclDocAppEntry4.SETRANGE("Document Type", PrmDocType);
            LclDocAppEntry4.SETRANGE("Document No.", PrmDocNo);
            LclDocAppEntry4.SETRANGE("Entry Type", PrmFuelIssueType);
            IF LclDocAppEntry4.FIND('-') THEN BEGIN
                IF (LclDocAppEntry4.Status = LclDocAppEntry4.Status::Open) THEN BEGIN
                    LclDocAppEntry4.Status := LclDocAppEntry4.Status::Canceled;
                    LclDocAppEntry4."Last Modified By" := USERID;
                    LclDocAppEntry4."Last Date Time Modified" := CURRENTDATETIME;
                    LclDocAppEntry4.MODIFY;
                    //Sending calcellation information to approver.
                    GblDocAppvNotificationMngt.sendFuelIssueCnclNot(LclDocAppEntry4."Sender ID");
                    MESSAGE(Text33019926);
                END ELSE
                    ERROR(Text33019932, LclDocAppEntry4.Status);
            END;
        END ELSE
            MESSAGE(Text33019927, USERID);
    end;

    [Scope('Internal')]
    procedure appvVehCCReq(PrmDocAppEntry: Record "33019915")
    var
        LclDocAppEntry2: Record "33019915";
    begin
        //Approving Custom Clearance document.
        LclDocAppEntry2.RESET;
        LclDocAppEntry2.SETRANGE("Table ID", PrmDocAppEntry."Table ID");
        LclDocAppEntry2.SETRANGE("Document Type", PrmDocAppEntry."Document Type");
        LclDocAppEntry2.SETRANGE("Document No.", PrmDocAppEntry."Document No.");
        IF LclDocAppEntry2.FIND('-') THEN BEGIN
            IF (LclDocAppEntry2.Status = LclDocAppEntry2.Status::Open) THEN BEGIN
                LclDocAppEntry2.Status := LclDocAppEntry2.Status::Approved;
                LclDocAppEntry2."Last Modified By" := USERID;
                LclDocAppEntry2."Last Date Time Modified" := CURRENTDATETIME;
                LclDocAppEntry2.MODIFY;
                //Send approved notification to sender goes here.
                GblDocAppvNotificationMngt.sendVehCCApvdNot(LclDocAppEntry2."Sender ID", LclDocAppEntry2."Approver ID");
                MESSAGE(Text33019928);
            END ELSE
                MESSAGE(Text33019931, LclDocAppEntry2.Status);
        END;
    end;

    [Scope('Internal')]
    procedure rejtVehCCReq(PrmDocAppEntry: Record "33019915")
    var
        LcLDocAppEntry3: Record "33019915";
    begin
        //Rejecting Custom Clearance document.
        LcLDocAppEntry3.RESET;
        LcLDocAppEntry3.SETRANGE("Table ID", PrmDocAppEntry."Table ID");
        LcLDocAppEntry3.SETRANGE("Document Type", PrmDocAppEntry."Document Type");
        LcLDocAppEntry3.SETRANGE("Document No.", PrmDocAppEntry."Document No.");
        IF LcLDocAppEntry3.FIND('-') THEN BEGIN
            IF NOT (LcLDocAppEntry3.Status IN [LcLDocAppEntry3.Status::Approved, LcLDocAppEntry3.Status::Canceled]) THEN BEGIN
                LcLDocAppEntry3.Status := LcLDocAppEntry3.Status::Rejected;
                LcLDocAppEntry3."Last Modified By" := USERID;
                LcLDocAppEntry3."Last Date Time Modified" := CURRENTDATETIME;
                LcLDocAppEntry3.MODIFY;
                //Send approved notification to sender goes here.
                GblDocAppvNotificationMngt.sendVehCCRejdNot(LcLDocAppEntry3."Sender ID", LcLDocAppEntry3."Approver ID");
                MESSAGE(Text33019929);
            END ELSE
                ERROR(Text33019933, LcLDocAppEntry3.Status);
        END;
    end;

    [Scope('Internal')]
    procedure delegateVehCCAppReq(PrmDocAppEntry: Record "33019915")
    var
        LclDocAppEntry: Record "33019915";
        LclSubstituteID: Code[20];
    begin
        //Delegating Fuel Issue document.
        GblUserSetup.GET(PrmDocAppEntry."Sender ID");
        LclSubstituteID := GblUserSetup.Substitute;
        //Sending notification to Subsitute for approval.
        GblDocAppvNotificationMngt.sendVehCCDelgtNot(PrmDocAppEntry."Approver ID", LclSubstituteID);
    end;

    [Scope('Internal')]
    procedure appvVehInsReq(PrmDocAppEntry: Record "33019915")
    var
        LclDocAppEntry3: Record "33019915";
    begin
        //Approving Insurance document.
        LclDocAppEntry3.RESET;
        LclDocAppEntry3.SETRANGE("Table ID", PrmDocAppEntry."Table ID");
        LclDocAppEntry3.SETRANGE("Document Type", PrmDocAppEntry."Document Type");
        LclDocAppEntry3.SETRANGE("Document No.", PrmDocAppEntry."Document No.");
        IF LclDocAppEntry3.FIND('-') THEN BEGIN
            IF (LclDocAppEntry3.Status = LclDocAppEntry3.Status::Open) THEN BEGIN
                LclDocAppEntry3.Status := LclDocAppEntry3.Status::Approved;
                LclDocAppEntry3."Last Modified By" := USERID;
                LclDocAppEntry3."Last Date Time Modified" := CURRENTDATETIME;
                LclDocAppEntry3.MODIFY;
                //Send approved notification to sender goes here.
                GblDocAppvNotificationMngt.sendVehInsApvdNot(LclDocAppEntry3."Sender ID", LclDocAppEntry3."Approver ID");
                MESSAGE(Text33019928);
            END ELSE
                MESSAGE(Text33019931, LclDocAppEntry3.Status);
        END;
    end;

    [Scope('Internal')]
    procedure delegateVehInsAppReq(PrmDocAppEntry: Record "33019915")
    var
        LclDocAppEntry4: Record "33019915";
        LclSubstituteID: Code[20];
    begin
        //Delegating Insurance Memo document.
        GblUserSetup.GET(PrmDocAppEntry."Sender ID");
        LclSubstituteID := GblUserSetup.Substitute;
        //Sending notification to Subsitute for approval.
        GblDocAppvNotificationMngt.sendVehInsDelgtNot(PrmDocAppEntry."Approver ID", LclSubstituteID);
    end;

    [Scope('Internal')]
    procedure rejtVehInsReq(PrmDocAppEntry: Record "33019915")
    var
        LclDocAppEntry4: Record "33019915";
    begin
        //Rejecting Insurance document.
        LclDocAppEntry4.RESET;
        LclDocAppEntry4.SETRANGE("Table ID", PrmDocAppEntry."Table ID");
        LclDocAppEntry4.SETRANGE("Document Type", PrmDocAppEntry."Document Type");
        LclDocAppEntry4.SETRANGE("Document No.", PrmDocAppEntry."Document No.");
        IF LclDocAppEntry4.FIND('-') THEN BEGIN
            IF NOT (LclDocAppEntry4.Status IN [LclDocAppEntry4.Status::Approved, LclDocAppEntry4.Status::Canceled]) THEN BEGIN
                LclDocAppEntry4.Status := LclDocAppEntry4.Status::Rejected;
                LclDocAppEntry4."Last Modified By" := USERID;
                LclDocAppEntry4."Last Date Time Modified" := CURRENTDATETIME;
                LclDocAppEntry4.MODIFY;
                //Send approved notification to sender goes here.
                GblDocAppvNotificationMngt.sendVehInsRejdNot(LclDocAppEntry4."Sender ID", LclDocAppEntry4."Approver ID");
                MESSAGE(Text33019929);
            END ELSE
                ERROR(Text33019933, LclDocAppEntry4.Status);
        END;
    end;

    [Scope('Internal')]
    procedure appFuelIssue(PrmDocAppEntry: Record "33019915")
    var
        LclDocAppEntry: Record "33019915";
    begin
        //Approving Fuel Issue document.
        LclDocAppEntry.RESET;
        LclDocAppEntry.SETRANGE("Table ID", PrmDocAppEntry."Table ID");
        LclDocAppEntry.SETRANGE("Document Type", PrmDocAppEntry."Document Type");
        LclDocAppEntry.SETRANGE("Document No.", PrmDocAppEntry."Document No.");
        IF LclDocAppEntry.FIND('-') THEN BEGIN
            IF (LclDocAppEntry.Status = LclDocAppEntry.Status::Open) THEN BEGIN
                LclDocAppEntry.Status := LclDocAppEntry.Status::Approved;
                LclDocAppEntry."Last Modified By" := USERID;
                LclDocAppEntry."Last Date Time Modified" := CURRENTDATETIME;
                LclDocAppEntry.MODIFY;
                //Send approved notification to sender goes here.
                GblDocAppvNotificationMngt.sendFuelIssueApvdNot(LclDocAppEntry."Sender ID", LclDocAppEntry."Approver ID");
                MESSAGE(Text33019928);
            END ELSE
                MESSAGE(Text33019931, LclDocAppEntry.Status);
        END;
    end;

    [Scope('Internal')]
    procedure rejtFuelIssue(PrmDocAppEntry: Record "33019915")
    var
        LclDocAppEntry: Record "33019915";
    begin
        //Rejecting Fuel Issue document.
        LclDocAppEntry.RESET;
        LclDocAppEntry.SETRANGE("Table ID", PrmDocAppEntry."Table ID");
        LclDocAppEntry.SETRANGE("Document Type", PrmDocAppEntry."Document Type");
        LclDocAppEntry.SETRANGE("Document No.", PrmDocAppEntry."Document No.");
        IF LclDocAppEntry.FIND('-') THEN BEGIN
            IF NOT (LclDocAppEntry.Status IN [LclDocAppEntry.Status::Approved, LclDocAppEntry.Status::Canceled]) THEN BEGIN
                LclDocAppEntry.Status := LclDocAppEntry.Status::Rejected;
                LclDocAppEntry."Last Modified By" := USERID;
                LclDocAppEntry."Last Date Time Modified" := CURRENTDATETIME;
                LclDocAppEntry.MODIFY;
                //Send approved notification to sender goes here.
                GblDocAppvNotificationMngt.sendFuelIssueRejdNot(LclDocAppEntry."Sender ID", LclDocAppEntry."Approver ID");
                MESSAGE(Text33019929);
            END ELSE
                ERROR(Text33019933, LclDocAppEntry.Status);
        END;
    end;

    [Scope('Internal')]
    procedure delegateFuelIssue(PrmDocAppEntry: Record "33019915")
    var
        LclDocAppEntry: Record "33019915";
        LclSubstituteID: Code[20];
    begin
        //Delegating Fuel Issue document.
        GblUserSetup.GET(PrmDocAppEntry."Sender ID");
        LclSubstituteID := GblUserSetup.Substitute;
        //Sending notification to Subsitute for approval.
        GblDocAppvNotificationMngt.sendFuelIssueDelgtNot(PrmDocAppEntry."Approver ID", LclSubstituteID);
    end;

    [Scope('Internal')]
    procedure getLastEntryNo(): Integer
    var
        LclDocAppEntry: Record "33019915";
    begin
        LclDocAppEntry.RESET;
        IF LclDocAppEntry.FIND('+') THEN
            EXIT(LclDocAppEntry."Entry No.");
    end;

    [Scope('Internal')]
    procedure getApproverID(): Code[50]
    var
        UserSetup: Record "91";
    begin
        UserSetup.GET(USERID);
        EXIT(UserSetup."Approver ID");
    end;

    [Scope('Internal')]
    procedure sendAppReqGenStrReq(PrmTableNo: Integer; PrmDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll; PrmDocNo: Code[20]; PrmEntryType: Option " ",Coupon,Stock,Cash,CVD,PCD,Requisition,Summary)
    var
        LclDocAppEntry: Record "33019915";
        LclDocAppEntry2: Record "33019915";
        LclEntryNo: Integer;
        Text33019920: Label 'Approval request by - %1 has been sent to approver - %2.';
    begin
        //Checking the record in Document Approval Entry table and inserting informations - Insurance.
        LclDocAppEntry.RESET;
        LclDocAppEntry.SETRANGE("Table ID", PrmTableNo);
        LclDocAppEntry.SETRANGE("Document Type", PrmDocType);
        LclDocAppEntry.SETRANGE("Document No.", PrmDocNo);
        IF NOT LclDocAppEntry.FIND('-') THEN BEGIN
            LclDocAppEntry2.INIT;
            LclDocAppEntry2."Entry No." := getLastEntryNo + 1;
            LclDocAppEntry2."Table ID" := PrmTableNo;
            LclDocAppEntry2."Document Type" := PrmDocType;
            LclDocAppEntry2."Document No." := PrmDocNo;
            LclDocAppEntry2."Sender ID" := USERID;
            LclDocAppEntry2."Approver ID" := getApproverID;
            LclDocAppEntry2.Status := LclDocAppEntry2.Status::Open;
            LclDocAppEntry2."Date Time Sent for Approval" := CURRENTDATETIME;
            LclDocAppEntry2."Due Date" := CALCDATE('1D', TODAY);
            LclDocAppEntry2."Entry Type" := PrmEntryType;
            LclDocAppEntry2.INSERT;
            //Calling approval notification.
            GblDocAppvNotificationMngt.sendGenStrReqAppNot(LclDocAppEntry2."Sender ID", PrmDocNo);
            MESSAGE(Text33019920, LclDocAppEntry2."Sender ID", LclDocAppEntry2."Approver ID");
        END ELSE
            MESSAGE(Text33019915);
    end;

    [Scope('Internal')]
    procedure cancelAppReqGenStrReq(PrmTableNo: Integer; PrmDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll; PrmDocNo: Code[20])
    var
        LclDocAppEntry4: Record "33019915";
        Text33019921: Label 'Are you sure - cancel?';
        Text33019922: Label 'Approval request has been canceled!';
        LclConfirmCancel: Boolean;
        Text33019923: Label 'Aborted by user - %1!';
    begin
        //Canceling the approval request.
        LclConfirmCancel := DIALOG.CONFIRM(Text33019921, FALSE);
        IF LclConfirmCancel THEN BEGIN
            LclDocAppEntry4.RESET;
            LclDocAppEntry4.SETRANGE("Table ID", PrmTableNo);
            LclDocAppEntry4.SETRANGE("Document Type", PrmDocType);
            LclDocAppEntry4.SETRANGE("Document No.", PrmDocNo);
            IF LclDocAppEntry4.FIND('-') THEN BEGIN
                IF (LclDocAppEntry4.Status = LclDocAppEntry4.Status::Open) THEN BEGIN
                    LclDocAppEntry4.Status := LclDocAppEntry4.Status::Canceled;
                    LclDocAppEntry4."Last Modified By" := USERID;
                    LclDocAppEntry4."Last Date Time Modified" := CURRENTDATETIME;
                    LclDocAppEntry4.MODIFY;
                    //Sending calcellation information to approver.
                    GblDocAppvNotificationMngt.sendGenStrReqCncllNot(LclDocAppEntry4."Sender ID", PrmDocNo);
                    MESSAGE(Text33019922);
                END ELSE
                    ERROR(Text33019932, LclDocAppEntry4.Status);
            END;
        END ELSE
            MESSAGE(Text33019923, USERID);
    end;

    [Scope('Internal')]
    procedure appGenStrReq(PrmDocAppEntry: Record "33019915")
    var
        LclDocAppEntry: Record "33019915";
    begin
        //Approving General Procurement document.
        LclDocAppEntry.RESET;
        LclDocAppEntry.SETRANGE("Table ID", PrmDocAppEntry."Table ID");
        LclDocAppEntry.SETRANGE("Document Type", PrmDocAppEntry."Document Type");
        LclDocAppEntry.SETRANGE("Document No.", PrmDocAppEntry."Document No.");
        IF LclDocAppEntry.FIND('-') THEN BEGIN
            IF (LclDocAppEntry.Status = LclDocAppEntry.Status::Open) THEN BEGIN
                LclDocAppEntry.Status := LclDocAppEntry.Status::Approved;
                LclDocAppEntry."Last Modified By" := USERID;
                LclDocAppEntry."Last Date Time Modified" := CURRENTDATETIME;
                LclDocAppEntry.MODIFY;
                //Send approved notification to sender goes here.
                GblDocAppvNotificationMngt.sendGenStrReqApvdNot(LclDocAppEntry."Sender ID", LclDocAppEntry."Approver ID");
                MESSAGE(Text33019928);
            END ELSE
                MESSAGE(Text33019931, LclDocAppEntry.Status);
        END;
    end;

    [Scope('Internal')]
    procedure rejtGenStrReq(PrmDocAppEntry: Record "33019915")
    var
        LclDocAppEntry: Record "33019915";
    begin
        //Rejecting Store Requisition document.
        LclDocAppEntry.RESET;
        LclDocAppEntry.SETRANGE("Table ID", PrmDocAppEntry."Table ID");
        LclDocAppEntry.SETRANGE("Document Type", PrmDocAppEntry."Document Type");
        LclDocAppEntry.SETRANGE("Document No.", PrmDocAppEntry."Document No.");
        IF LclDocAppEntry.FIND('-') THEN BEGIN
            IF NOT (LclDocAppEntry.Status IN [LclDocAppEntry.Status::Approved, LclDocAppEntry.Status::Canceled]) THEN BEGIN
                LclDocAppEntry.Status := LclDocAppEntry.Status::Rejected;
                LclDocAppEntry."Last Modified By" := USERID;
                LclDocAppEntry."Last Date Time Modified" := CURRENTDATETIME;
                LclDocAppEntry.MODIFY;
                //Send approved notification to sender goes here.
                GblDocAppvNotificationMngt.sendGenStrReqRejdNot(LclDocAppEntry."Sender ID", LclDocAppEntry."Approver ID");
                MESSAGE(Text33019929);
            END ELSE
                ERROR(Text33019933, LclDocAppEntry.Status);
        END;
    end;

    [Scope('Internal')]
    procedure delegateGenStrReq(PrmDocAppEntry: Record "33019915")
    var
        LclDocAppEntry: Record "33019915";
        LclSubstituteID: Code[20];
    begin
        //Delegating Store Requisition document.
        GblUserSetup.GET(PrmDocAppEntry."Sender ID");
        LclSubstituteID := GblUserSetup.Substitute;
        //Sending notification to Subsitute for approval.
        GblDocAppvNotificationMngt.sendGenStrReqDelgtNot(PrmDocAppEntry."Approver ID", LclSubstituteID);
    end;

    [Scope('Internal')]
    procedure sendAppReqHRTraining(PrmTableNo: Integer; PrmDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll; PrmDocNo: Code[20])
    var
        LclDocAppEntry: Record "33019915";
        LclDocAppEntry2: Record "33019915";
        LclEntryNo: Integer;
        Text33019920: Label 'Approval request by - %1 has been sent to approver - %2.';
        TrainingHdr: Record "33020359";
    begin
        //Checking the record in Document Approval Entry table and inserting informations if not available.
        LclDocAppEntry.RESET;
        LclDocAppEntry.SETRANGE("Table ID", PrmTableNo);
        LclDocAppEntry.SETRANGE("Document Type", PrmDocType);
        LclDocAppEntry.SETRANGE("Document No.", PrmDocNo);
        IF NOT LclDocAppEntry.FIND('-') THEN BEGIN
            LclDocAppEntry2.INIT;
            LclDocAppEntry2."Entry No." := getLastEntryNo + 1;
            LclDocAppEntry2."Table ID" := PrmTableNo;
            LclDocAppEntry2."Document Type" := PrmDocType;
            LclDocAppEntry2."Document No." := PrmDocNo;
            LclDocAppEntry2."Sender ID" := USERID;
            LclDocAppEntry2."Approver ID" := getApproverIDI;
            LclDocAppEntry2.Status := LclDocAppEntry2.Status::Open;
            LclDocAppEntry2."Date Time Sent for Approval" := CURRENTDATETIME;
            LclDocAppEntry2."Due Date" := CALCDATE('1D', TODAY);
            LclDocAppEntry2.INSERT;
            //Calling approval notification.

            //SRT Feb 24th 2019 >>
            IF PrmDocType = PrmDocType::HR THEN BEGIN
                TrainingHdr.RESET;
                TrainingHdr.SETRANGE("Tr. Req. No.", PrmDocNo);
                IF TrainingHdr.FINDFIRST THEN BEGIN
                    GblDocAppvNotificationMngt.SendTrainingRequestMailtoReportingManager(TrainingHdr);
                END;
            END;
            //SRT Feb 24th 2019 <<
            //MESSAGE(Text33019920,LclDocAppEntry2."Sender ID",LclDocAppEntry2."Approver ID");

        END ELSE
            MESSAGE(Text33019915);
    end;

    [Scope('Internal')]
    procedure CancelAppReqHRTraining(PrmTableNo: Integer; PrmDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll; PrmDocNo: Code[20])
    var
        Text33019921: Label 'Are you sure - cancel?';
        Text33019922: Label 'Approval request has been canceled!';
        Text33019923: Label 'Aborted by user - %1!';
        LclDocAppEntry4: Record "33019915";
        LclConfirmCancel: Boolean;
        TrReqHdr: Record "33020359";
    begin
        //Canceling the approval request.
        LclConfirmCancel := DIALOG.CONFIRM(Text33019921, FALSE);
        IF LclConfirmCancel THEN BEGIN
            LclDocAppEntry4.RESET;
            LclDocAppEntry4.SETRANGE("Table ID", PrmTableNo);
            LclDocAppEntry4.SETRANGE("Document Type", PrmDocType);
            LclDocAppEntry4.SETRANGE("Document No.", PrmDocNo);
            IF LclDocAppEntry4.FIND('-') THEN BEGIN
                IF (LclDocAppEntry4.Status = LclDocAppEntry4.Status::Open) THEN BEGIN
                    LclDocAppEntry4.Status := LclDocAppEntry4.Status::Canceled;
                    LclDocAppEntry4."Last Modified By" := USERID;
                    LclDocAppEntry4."Last Date Time Modified" := CURRENTDATETIME;
                    LclDocAppEntry4.MODIFY;

                    //Sending calcellation information to approver.
                    //SRT Feb 24th 2019 >>
                    TrReqHdr.RESET;
                    TrReqHdr.SETRANGE("Tr. Req. No.", PrmDocNo);
                    IF TrReqHdr.FINDFIRST THEN
                        GblDocAppvNotificationMngt.SendTrainingCancelNotificationtoReportingManager(TrReqHdr);
                    //SRT Feb 24th 2019 <<
                END ELSE
                    ERROR(Text33019932, LclDocAppEntry4.Status);
            END;
        END ELSE
            MESSAGE(Text33019923, USERID);
    end;

    [Scope('Internal')]
    procedure sendAppReqLC(PrmTableNo: Integer; PrmDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll; PrmDocNo: Code[20])
    var
        LclDocAppEntry: Record "33019915";
        LclDocAppEntry2: Record "33019915";
        LclEntryNo: Integer;
        Text33019916: Label 'Approval request by - %1 has been sent to approver - %2.';
    begin
        //Checking the record in Document Approval Entry table and inserting informations if not available.
        LclDocAppEntry.RESET;
        LclDocAppEntry.SETRANGE("Table ID", PrmTableNo);
        LclDocAppEntry.SETRANGE("Document Type", PrmDocType);
        LclDocAppEntry.SETRANGE("Document No.", PrmDocNo);
        IF NOT LclDocAppEntry.FIND('-') THEN BEGIN
            LclDocAppEntry2.INIT;
            LclDocAppEntry2."Entry No." := getLastEntryNo + 1;
            LclDocAppEntry2."Table ID" := PrmTableNo;
            LclDocAppEntry2."Document Type" := PrmDocType;
            LclDocAppEntry2."Document No." := PrmDocNo;
            LclDocAppEntry2."Sender ID" := USERID;
            LclDocAppEntry2."Approver ID" := getApproverID;
            LclDocAppEntry2.Status := LclDocAppEntry2.Status::Open;
            LclDocAppEntry2."Date Time Sent for Approval" := CURRENTDATETIME;
            LclDocAppEntry2."Due Date" := CALCDATE('1D', TODAY);
            LclDocAppEntry2.INSERT;
            //Sending approval notification email to approver.
            GblDocAppvNotificationMngt.sendLCAppNot(LclDocAppEntry2."Sender ID");
            MESSAGE(Text33019916, LclDocAppEntry2."Sender ID", LclDocAppEntry2."Approver ID");
        END ELSE
            MESSAGE(Text33019915);
    end;

    [Scope('Internal')]
    procedure cancelAppReqLC(PrmTableNo: Integer; PrmDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll; PrmDocNo: Code[20])
    var
        LclDocAppEntry: Record "33019915";
        Text33019917: Label 'Are you sure - Cancel?';
        Text33019918: Label 'Approval request has been canceled!';
        LclConfirmCancel: Boolean;
        Text33019919: Label 'Aborted by user - %1!';
    begin
        //Canceling the approval request for Custom Clearance Memo.
        LclConfirmCancel := DIALOG.CONFIRM(Text33019917, FALSE);
        IF LclConfirmCancel THEN BEGIN
            LclDocAppEntry.RESET;
            LclDocAppEntry.SETRANGE("Table ID", PrmTableNo);
            LclDocAppEntry.SETRANGE("Document Type", PrmDocType);
            LclDocAppEntry.SETRANGE("Document No.", PrmDocNo);
            IF LclDocAppEntry.FIND('-') THEN BEGIN
                IF (LclDocAppEntry.Status = LclDocAppEntry.Status::Open) THEN BEGIN
                    LclDocAppEntry.Status := LclDocAppEntry.Status::Canceled;
                    LclDocAppEntry."Last Modified By" := USERID;
                    LclDocAppEntry."Last Date Time Modified" := CURRENTDATETIME;
                    LclDocAppEntry.MODIFY;
                    //Sending cancelation notification to approver.
                    GblDocAppvNotificationMngt.sendLCCnclNot(LclDocAppEntry."Sender ID");
                    MESSAGE(Text33019918);
                END ELSE
                    ERROR(Text33019932, LclDocAppEntry.Status);
            END;
        END ELSE
            MESSAGE(Text33019919, USERID);
    end;

    [Scope('Internal')]
    procedure appvLCReq(PrmDocAppEntry: Record "33019915")
    var
        LclDocAppEntry2: Record "33019915";
    begin
        //Approving Vehicle Purchase - LC document.
        LclDocAppEntry2.RESET;
        LclDocAppEntry2.SETRANGE("Table ID", PrmDocAppEntry."Table ID");
        LclDocAppEntry2.SETRANGE("Document Type", PrmDocAppEntry."Document Type");
        LclDocAppEntry2.SETRANGE("Document No.", PrmDocAppEntry."Document No.");
        IF LclDocAppEntry2.FIND('-') THEN BEGIN
            IF (LclDocAppEntry2.Status = LclDocAppEntry2.Status::Open) THEN BEGIN
                LclDocAppEntry2.Status := LclDocAppEntry2.Status::Approved;
                LclDocAppEntry2."Last Modified By" := USERID;
                LclDocAppEntry2."Last Date Time Modified" := CURRENTDATETIME;
                LclDocAppEntry2.MODIFY;
                //Send approved notification to sender goes here.
                GblDocAppvNotificationMngt.sendLCApvdNot(LclDocAppEntry2."Sender ID", LclDocAppEntry2."Approver ID");
                MESSAGE(Text33019928);
            END ELSE
                MESSAGE(Text33019931, LclDocAppEntry2.Status);
        END;
    end;

    [Scope('Internal')]
    procedure rejtLCReq(PrmDocAppEntry: Record "33019915")
    var
        LcLDocAppEntry3: Record "33019915";
    begin
        //Rejecting Custom Clearance document.
        LcLDocAppEntry3.RESET;
        LcLDocAppEntry3.SETRANGE("Table ID", PrmDocAppEntry."Table ID");
        LcLDocAppEntry3.SETRANGE("Document Type", PrmDocAppEntry."Document Type");
        LcLDocAppEntry3.SETRANGE("Document No.", PrmDocAppEntry."Document No.");
        IF LcLDocAppEntry3.FIND('-') THEN BEGIN
            IF NOT (LcLDocAppEntry3.Status IN [LcLDocAppEntry3.Status::Approved, LcLDocAppEntry3.Status::Canceled]) THEN BEGIN
                LcLDocAppEntry3.Status := LcLDocAppEntry3.Status::Rejected;
                LcLDocAppEntry3."Last Modified By" := USERID;
                LcLDocAppEntry3."Last Date Time Modified" := CURRENTDATETIME;
                LcLDocAppEntry3.MODIFY;
                //Send approved notification to sender goes here.
                GblDocAppvNotificationMngt.sendLCCRejdNot(LcLDocAppEntry3."Sender ID", LcLDocAppEntry3."Approver ID");
                MESSAGE(Text33019929);
            END ELSE
                ERROR(Text33019933, LcLDocAppEntry3.Status);
        END;
    end;

    [Scope('Internal')]
    procedure delegateLCAppReq(PrmDocAppEntry: Record "33019915")
    var
        LclDocAppEntry: Record "33019915";
        LclSubstituteID: Code[20];
    begin
        //Delegating Fuel Issue document.
        GblUserSetup.GET(PrmDocAppEntry."Sender ID");
        LclSubstituteID := GblUserSetup.Substitute;
        //Sending notification to Subsitute for approval.
        GblDocAppvNotificationMngt.sendLCDelgtNot(PrmDocAppEntry."Approver ID", LclSubstituteID);
    end;

    [Scope('Internal')]
    procedure SendEmpVacReq(PrmTableNo: Integer; PrmDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll; PrmDocNo: Code[20])
    var
        LclDocAppEntry: Record "33019915";
        LclDocAppEntry2: Record "33019915";
        LclEntryNo: Integer;
        Text33019920: Label 'Approval request by - %1 has been sent to approver - %2.';
    begin
        //Checking the record in Document Approval Entry table and inserting informations if not available.
        LclDocAppEntry.RESET;
        LclDocAppEntry.SETRANGE("Table ID", PrmTableNo);
        LclDocAppEntry.SETRANGE("Document Type", PrmDocType);
        LclDocAppEntry.SETRANGE("Document No.", PrmDocNo);
        IF NOT LclDocAppEntry.FIND('-') THEN BEGIN
            LclDocAppEntry2.INIT;
            LclDocAppEntry2."Entry No." := getLastEntryNo + 1;
            LclDocAppEntry2."Table ID" := PrmTableNo;
            LclDocAppEntry2."Document Type" := PrmDocType;
            LclDocAppEntry2."Document No." := PrmDocNo;
            LclDocAppEntry2."Sender ID" := USERID;
            LclDocAppEntry2."Approver ID" := getApproverID;
            LclDocAppEntry2.Status := LclDocAppEntry2.Status::Open;
            LclDocAppEntry2."Date Time Sent for Approval" := CURRENTDATETIME;
            LclDocAppEntry2."Due Date" := CALCDATE('1D', TODAY);
            LclDocAppEntry2.INSERT;
            //Calling approval notification.
            GblDocAppvNotificationMngt.SendEmpVacAppNot(LclDocAppEntry2."Sender ID");
            MESSAGE(Text33019920, LclDocAppEntry2."Sender ID", LclDocAppEntry2."Approver ID");
        END ELSE
            MESSAGE(Text33019915);
    end;

    [Scope('Internal')]
    procedure CancelEmpVacReq(PrmTableNo: Integer; PrmDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll; PrmDocNo: Code[20])
    var
        LclDocAppEntry4: Record "33019915";
        LclConfirmCancel: Boolean;
        Text33019921: Label 'Are you sure - cancel?';
        Text33019922: Label 'Approval request has been canceled!';
        Text33019923: Label 'Aborted by user - %1!';
    begin
        //Canceling the approval request.
        LclConfirmCancel := DIALOG.CONFIRM(Text33019921, FALSE);
        IF LclConfirmCancel THEN BEGIN
            LclDocAppEntry4.RESET;
            LclDocAppEntry4.SETRANGE("Table ID", PrmTableNo);
            LclDocAppEntry4.SETRANGE("Document Type", PrmDocType);
            LclDocAppEntry4.SETRANGE("Document No.", PrmDocNo);
            IF LclDocAppEntry4.FIND('-') THEN BEGIN
                IF (LclDocAppEntry4.Status = LclDocAppEntry4.Status::Open) THEN BEGIN
                    LclDocAppEntry4.Status := LclDocAppEntry4.Status::Canceled;
                    LclDocAppEntry4."Last Modified By" := USERID;
                    LclDocAppEntry4."Last Date Time Modified" := CURRENTDATETIME;
                    LclDocAppEntry4.MODIFY;
                    //Sending calcellation information to approver.
                    GblDocAppvNotificationMngt.SendEmpVacCnclNot(LclDocAppEntry4."Sender ID");
                    MESSAGE(Text33019922);
                END ELSE
                    ERROR(Text33019932, LclDocAppEntry4.Status);
            END;
        END ELSE
            MESSAGE(Text33019923, USERID);
    end;

    local procedure getApproverIDI(): Text
    var
        Employee: Record "5200";
    begin
        Employee.RESET;
        Employee.SETRANGE("Is Traning Manager", TRUE);
        Employee.FINDFIRST;
        EXIT(Employee."User ID");
    end;
}


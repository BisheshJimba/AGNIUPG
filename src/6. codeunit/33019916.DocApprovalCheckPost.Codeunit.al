codeunit 33019916 "Doc. Approval Check - Post"
{

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure checkDocApproval(PrmTableNo: Integer; PrmDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll; PrmDocNo: Code[20]; PrmDocTypeText: Text[50])
    var
        LclDocAppEntry: Record "33019915";
        LclAppvExist: Boolean;
        Text33019915: Label '%1 Document with Document No. - %2 is not approved. Please get approval and then post. \ Or contact your system administrator.';
    begin
        //Checking approver ID.
        LclAppvExist := checkApproverID;

        IF LclAppvExist THEN BEGIN
            LclDocAppEntry.RESET;
            LclDocAppEntry.SETRANGE("Table ID", PrmTableNo);
            LclDocAppEntry.SETRANGE("Document Type", PrmDocType);
            LclDocAppEntry.SETRANGE("Document No.", PrmDocNo);
            LclDocAppEntry.SETRANGE(Status, LclDocAppEntry.Status::Approved);
            IF NOT LclDocAppEntry.FIND('-') THEN
                ERROR(Text33019915, PrmDocTypeText, PrmDocNo);
        END;
    end;

    [Scope('Internal')]
    procedure checkApproverID(): Boolean
    var
        LclUserSetup: Record "91";
    begin
        LclUserSetup.GET(USERID);
        IF LclUserSetup."Approver ID" <> '' THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure checkDocApplWithBoolRet(PrmTableNo: Integer; PrmDocType: Option " ","Fuel Issue",Courier,LC,"Vehicle Insurance","Vehicle Custom Clearance","General Procurement",HR,Payroll; PrmDocNo: Code[20]): Boolean
    var
        LclDocAppEntry: Record "33019915";
        LclAppvExist: Boolean;
    begin
        //Checking for approval data entry. Returns true or false.
        LclAppvExist := checkApproverID;

        IF LclAppvExist THEN BEGIN
            LclDocAppEntry.RESET;
            LclDocAppEntry.SETRANGE("Table ID", PrmTableNo);
            LclDocAppEntry.SETRANGE("Document Type", PrmDocType);
            LclDocAppEntry.SETRANGE("Document No.", PrmDocNo);
            LclDocAppEntry.SETRANGE(Status, LclDocAppEntry.Status::Approved);
            IF NOT LclDocAppEntry.FIND('-') THEN
                EXIT(FALSE)
            ELSE
                EXIT(TRUE);
        END;
    end;
}


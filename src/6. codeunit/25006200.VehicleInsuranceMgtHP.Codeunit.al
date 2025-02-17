codeunit 25006200 "Vehicle Insurance Mgt. HP"
{

    trigger OnRun()
    begin
    end;

    var
        HirepurchaseSetup: Record "33020064";
        ConfirmTxt001: Label 'Do you want to Create Vehicle Insurance of Loan file %1 ?';
        ConfirmTxt002: Label 'Do you want to Send Vehicle Insurance of Loan file  %1 for Apporval ?';
        ConfirmTxt003: Label 'Do you want to Approve Vehicle Insurance ?';
        ConfirmTxt004: Label 'Do you want to Reject the Vehicle Insurance ?';
        ConfirmTxt005: Label 'Do you want to Post the Vehicle Insurance ?';
        ConfirmTxt006: Label 'Do you want to Cancel the Vehicle Insurance Document ?';
        ExpireDaysErr: Label 'Insurance Policy %1 of Loan file %2 will expire on %3. You can only create new insurance  %4  days before the Exipre date. ';
        AbortErr: Label 'Aborted By User!';
        ConfirmOpenDoc: Label 'Vehicle Insurance for Loan file %1 already exits.\Document Status :  %2.\Do you want to open the Document? ';
        UserSetup: Record "91";
        ErrApprove: Label 'You do not have permission to approve/reject the Document.';
        ErrPost: Label 'You do not have permission to Post the Document.';
        TemplateName: Code[10];
        JournalBatch: Code[10];
        PostTextMessage: Label 'Journal Lines have been Posted for Vehicle Insurance of Loan No. %1';
        MsgText0001: Label 'Vehicle Insurance has been Created.';
        MsgText0002: Label 'Document has been Send For Approval.';
        MsgText0003: Label 'Document has been Approved.';
        MsgText0004: Label 'Document has been Send for Cancellation Approval.';
        MsgText0005: Label 'Document has been Rejected.';
        ErrText001: Label 'Document has already been Cancelled.';
        DocNo: Code[20];

    [Scope('Internal')]
    procedure CreateVehicleInsurance(var VehicleFinanceHeader: Record "33020062")
    var
        VehicleInsuranceHP: Record "33020085";
        VehicleInsurance: Record "33020085";
        VehicleInsurance2: Record "33020085";
        VehicleInsurancePage: Page "33020288";
    begin
        IF CheckInsuranceAlreadyExits(VehicleFinanceHeader."Loan No.") THEN
            EXIT;

        IF NOT CONFIRM(ConfirmTxt001, TRUE, VehicleFinanceHeader."Loan No.") THEN
            ERROR(AbortErr);

        VehicleInsuranceHP.INIT;

        VehicleInsuranceHP.VALIDATE("Loan No.", VehicleFinanceHeader."Loan No.");

        VehicleInsurance2.RESET;
        VehicleInsurance2.SETRANGE("Loan No.", VehicleFinanceHeader."Loan No.");
        IF VehicleInsurance2.FINDLAST THEN
            VehicleInsuranceHP."Line No." := VehicleInsurance2."Line No." + 10000
        ELSE
            VehicleInsuranceHP."Line No." := 10000;

        VehicleInsuranceHP.Status := VehicleInsuranceHP.Status::Open;

        VehicleInsuranceHP.INSERT(TRUE);
        MESSAGE(MsgText0001);
        VehicleInsurancePage.SETRECORD(VehicleInsuranceHP);
        VehicleInsurancePage.SETTABLEVIEW(VehicleInsuranceHP);
        VehicleInsurancePage.RUN;
    end;

    [Scope('Internal')]
    procedure CheckInsuranceAlreadyExits(LoanNo: Code[20]): Boolean
    var
        VehicleInsuranceHP: Record "33020085";
        VehicleInsurancePage: Page "33020288";
    begin
        VehicleInsuranceHP.RESET;
        VehicleInsuranceHP.SETRANGE("Loan No.", LoanNo);
        VehicleInsuranceHP.SETRANGE(Cancel, FALSE);
        IF VehicleInsuranceHP.FINDLAST THEN BEGIN
            IF VehicleInsuranceHP.Approved THEN BEGIN
                HirepurchaseSetup.GET;
                //IF HirepurchaseSetup."Ins. Entry Before Expire Days" <> 0 THEN
                IF VehicleInsuranceHP."End Date" > TODAY + HirepurchaseSetup."Ins. Entry Before Expire Days" THEN
                    ERROR(ExpireDaysErr, VehicleInsuranceHP."Policy No.", VehicleInsuranceHP."Loan No.", VehicleInsuranceHP."End Date", HirepurchaseSetup."Ins. Entry Before Expire Days");
            END ELSE BEGIN
                IF CONFIRM(ConfirmOpenDoc, TRUE, VehicleInsuranceHP."Loan No.", VehicleInsuranceHP.Status) THEN BEGIN
                    VehicleInsurancePage.SETRECORD(VehicleInsuranceHP);
                    VehicleInsurancePage.SETTABLEVIEW(VehicleInsuranceHP);
                    VehicleInsurancePage.RUN;
                    EXIT(TRUE);
                END ELSE
                    EXIT(TRUE);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure SendForApproval(var VehicleInsuranceHP: Record "33020085")
    begin

        VehicleInsuranceHP.TESTFIELD("Policy No.");
        VehicleInsuranceHP.TESTFIELD("Start Date");
        VehicleInsuranceHP.TESTFIELD("End Date");
        VehicleInsuranceHP.TESTFIELD("Insurance Company Code");
        VehicleInsuranceHP.TESTFIELD("Vehicle Serial No.");
        VehicleInsuranceHP.TESTFIELD("VIN No.");
        VehicleInsuranceHP.TESTFIELD("Customer No.");
        VehicleInsuranceHP.TESTFIELD("Ins. Prem Value (with VAT)");

        IF NOT CONFIRM(ConfirmTxt002, TRUE, VehicleInsuranceHP."Loan No.") THEN
            ERROR(AbortErr);

        VehicleInsuranceHP.VALIDATE(Status, VehicleInsuranceHP.Status::"Pending Approval");
        VehicleInsuranceHP."Send For Approval DateTime" := CURRENTDATETIME;
        VehicleInsuranceHP."Send for Approval By" := USERID;
        VehicleInsuranceHP.MODIFY;
        MESSAGE(MsgText0002);
    end;

    [Scope('Internal')]
    procedure ApproveVehicleInsurance(var VehicleInsuranceHP: Record "33020085")
    begin
        IF VehicleInsuranceHP.FINDFIRST THEN BEGIN
            REPEAT
                VehicleInsuranceHP.TESTFIELD("Policy No.");
                VehicleInsuranceHP.TESTFIELD("Start Date");
                VehicleInsuranceHP.TESTFIELD("End Date");
                VehicleInsuranceHP.TESTFIELD("Insurance Company Code");
                VehicleInsuranceHP.TESTFIELD("Vehicle Serial No.");
                VehicleInsuranceHP.TESTFIELD("VIN No.");
                VehicleInsuranceHP.TESTFIELD("Customer No.");
                VehicleInsuranceHP.TESTFIELD("Ins. Prem Value (with VAT)");

                UserSetup.GET(USERID);
                IF NOT UserSetup."Can Approve Veh. Ins. HP" THEN
                    ERROR(ErrApprove);

                IF NOT CONFIRM(ConfirmTxt003) THEN
                    ERROR(AbortErr);

                IF VehicleInsuranceHP."Request for Cancellation" THEN BEGIN
                    VehicleInsuranceHP.VALIDATE(Status, VehicleInsuranceHP.Status::Approved);
                    VehicleInsuranceHP.Cancel := TRUE;
                    VehicleInsuranceHP."Cancelled By" := USERID;
                    VehicleInsuranceHP."Cancelled Date" := TODAY;
                    VehicleInsuranceHP."Cancelled Time" := TIME;
                END ELSE BEGIN
                    VehicleInsuranceHP.VALIDATE(Status, VehicleInsuranceHP.Status::Approved);
                    VehicleInsuranceHP.Approved := TRUE;
                    VehicleInsuranceHP."Approved By" := USERID;
                    VehicleInsuranceHP."Approved Date" := TODAY;
                    VehicleInsuranceHP."Approved Time" := TIME;
                END;

                IF VehicleInsuranceHP."Insurance Type" = VehicleInsuranceHP."Insurance Type"::"Third Party" THEN BEGIN
                    VehicleInsuranceHP.VALIDATE(Status, VehicleInsuranceHP.Status::Posted);
                    VehicleInsuranceHP.Posted := TRUE;
                    //"Approved By" := USERID;
                    //"Approved Date" := TODAY;
                    //"Approved Time" := TIME;
                END;

                VehicleInsuranceHP.MODIFY;
            UNTIL VehicleInsuranceHP.NEXT = 0;

            MESSAGE(MsgText0003);
        END;
    end;

    [Scope('Internal')]
    procedure RejectVehicleInsurance(var VehicleInsuranceHP: Record "33020085")
    begin
        IF VehicleInsuranceHP.FINDFIRST THEN BEGIN
            REPEAT
                UserSetup.GET(USERID);
                IF NOT UserSetup."Can Approve Veh. Ins. HP" THEN
                    ERROR(ErrApprove);

                IF NOT CONFIRM(ConfirmTxt004) THEN
                    ERROR(AbortErr);

                IF VehicleInsuranceHP."Request for Cancellation" THEN BEGIN
                    VehicleInsuranceHP.VALIDATE(Status, VehicleInsuranceHP.Status::Posted);
                    VehicleInsuranceHP."Request for Cancellation" := FALSE;

                END ELSE
                    VehicleInsuranceHP.VALIDATE(Status, VehicleInsuranceHP.Status::Open);

                VehicleInsuranceHP.MODIFY;
            UNTIL VehicleInsuranceHP.NEXT = 0;
            MESSAGE(MsgText0005);
        END;
    end;

    [Scope('Internal')]
    procedure CancleVehicleInsurance(var VehicleInsuranceHP: Record "33020085")
    begin
        IF VehicleInsuranceHP.Cancel THEN
            ERROR(ErrText001);

        IF VehicleInsuranceHP.Status = VehicleInsuranceHP.Status::Posted THEN BEGIN

            IF NOT CONFIRM(ConfirmTxt006) THEN
                ERROR(AbortErr);

            VehicleInsuranceHP."Request for Cancellation" := TRUE;
            VehicleInsuranceHP."Cancellation Request Sent By" := USERID;
            VehicleInsuranceHP."Cancellation Request Sent DT" := CURRENTDATETIME;
            VehicleInsuranceHP.VALIDATE(Status, VehicleInsuranceHP.Status::"Pending Approval");
            VehicleInsuranceHP.MODIFY;
            MESSAGE(MsgText0004);
        END;
    end;

    [Scope('Internal')]
    procedure PostVehicleInsurance(var VehicleInsuranceHP: Record "33020085")
    begin

        VehicleInsuranceHP.TESTFIELD("Policy No.");
        VehicleInsuranceHP.TESTFIELD("Start Date");
        VehicleInsuranceHP.TESTFIELD("End Date");
        VehicleInsuranceHP.TESTFIELD("Insurance Company Code");
        VehicleInsuranceHP.TESTFIELD("Vehicle Serial No.");
        VehicleInsuranceHP.TESTFIELD("VIN No.");
        VehicleInsuranceHP.TESTFIELD("Customer No.");
        VehicleInsuranceHP.TESTFIELD("Ins. Prem Value (with VAT)");

        UserSetup.GET(USERID);
        IF NOT UserSetup."Can Post Veh. Ins. HP" THEN
            ERROR(ErrPost);

        IF NOT CONFIRM(ConfirmTxt005) THEN
            ERROR(AbortErr);

        ProcessPaymentIns(VehicleInsuranceHP);

        VehicleInsuranceHP.VALIDATE(Status, VehicleInsuranceHP.Status::Posted);

        VehicleInsuranceHP.Posted := TRUE;

        IF NOT VehicleInsuranceHP."Request for Cancellation" THEN BEGIN
            VehicleInsuranceHP."Posted By" := USERID;
            VehicleInsuranceHP."Posted Date" := TODAY;
            VehicleInsuranceHP."Posted Time" := TIME;
        END;

        VehicleInsuranceHP.MODIFY;
    end;

    [Scope('Internal')]
    procedure ProcessPaymentIns(var VehicleInsuranceHP: Record "33020085")
    var
        VFSetup: Record "33020064";
        CreateVFJournal_HP: Codeunit "33020063";
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        VFPostingType: Option " ",Principal,Interest,Penalty,"Service Charge",Insurance,"Other Charges",Prepayment,"Insurance Interest","Interest on CAD";
        ReceiptType: Option " ",Booking,"Part Payment","Retention Amount","Finance Amount",Invoice,Installment,Deposit,"Tendor Amount","LC Amount","Cheque Returned","VF Payment",Advance,"Inter-Party Journal","CICL Amount";
        VehicleFinanceHeader: Record "33020062";
        GenJnlLine: Record "81";
        JournalBatchRec: Record "232";
        NoSeriesMgt: Codeunit "396";
        GenJnlBatchRec: Record "232";
        GenJnlPost: Codeunit "12";
        GenJnlTemplateRec: Record "80";
    begin
        DocNo := '';
        VehicleFinanceHeader.GET(VehicleInsuranceHP."Loan No.");
        VehicleFinanceHeader.TESTFIELD("Shortcut Dimension 1 Code");
        VehicleFinanceHeader.TESTFIELD("Shortcut Dimension 2 Code");

        VFSetup.GET;
        VFSetup.TESTFIELD("VF Journal Template Name");

        VFSetup.VALIDATE("Veh. Ins.Journal Template Name");
        VFSetup.VALIDATE("Veh. Ins. Journal Batch Name");

        TemplateName := VFSetup."Veh. Ins.Journal Template Name";
        JournalBatch := VFSetup."Veh. Ins. Journal Batch Name";

        //Customer Entry >>>
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := TemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatch;
        GenJnlLine."Posting Date" := WORKDATE;

        CLEAR(NoSeriesMgt);
        GenJnlBatchRec.RESET;
        GenJnlBatchRec.SETRANGE("Journal Template Name", TemplateName);
        GenJnlBatchRec.SETRANGE(Name, JournalBatch);
        GenJnlBatchRec.SETFILTER("Posting No. Series", '<>%1', '');
        IF GenJnlBatchRec.FINDFIRST THEN BEGIN
            DocNo := NoSeriesMgt.GetNextNo(GenJnlBatchRec."Posting No. Series", GenJnlLine."Posting Date", TRUE);
            GenJnlLine."Document No." := DocNo;
            GenJnlLine."Posting No. Series" := GenJnlBatchRec."Posting No. Series";
            IF GenJnlTemplateRec.GET(GenJnlBatchRec."Journal Template Name") THEN
                GenJnlLine."Source Code" := GenJnlTemplateRec."Source Code";
        END;

        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
        GenJnlLine.VALIDATE("Account No.", VehicleInsuranceHP."Customer No.");

        IF VehicleInsuranceHP."Request for Cancellation" THEN
            GenJnlLine.VALIDATE(Amount, -VehicleInsuranceHP."Ins. Prem Value (with VAT)")
        ELSE
            GenJnlLine.VALIDATE(Amount, VehicleInsuranceHP."Ins. Prem Value (with VAT)");

        GenJnlLine.VALIDATE("Document Class", GenJnlLine."Document Class"::Vendor);
        GenJnlLine.VALIDATE("Document Subclass", VehicleInsuranceHP."Insurance Company Code");

        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", VehicleFinanceHeader."Shortcut Dimension 1 Code");
        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", VehicleFinanceHeader."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, VehicleFinanceHeader."Shortcut Dimension 3 Code");

        GenJnlLine.VALIDATE(Description, 'Insurance Premium of Loan ' + VehicleInsuranceHP."Loan No.");

        GenJnlLine.VALIDATE("VF Posting Type", VFPostingType::Insurance);
        GenJnlLine.VALIDATE("Receipt Type", ReceiptType::"VF Payment");
        GenJnlLine.VALIDATE(VIN, VehicleInsuranceHP."VIN No.");

        GenJnlLine.VALIDATE("External Document No.", '');

        IF VehicleInsuranceHP."Request for Cancellation" THEN
            GenJnlLine.Narration := 'System Created Entry: Cancellation of Insurance Premium of Loan '
                                    + VehicleInsuranceHP."Loan No." + 'Policy No. ' + VehicleInsuranceHP."Policy No."

        ELSE
            GenJnlLine.Narration := 'System Created Entry: Insurance Premium of Loan '
                                    + VehicleInsuranceHP."Loan No." + 'Policy No. ' + VehicleInsuranceHP."Policy No.";

        GenJnlLine."VF Loan File No." := VehicleInsuranceHP."Loan No.";

        GenJnlLine."Posting Date" := WORKDATE;
        //GenJnlPost.RUN(GenJnlLine);
        GenJnlPost.RunWithCheck(GenJnlLine);

        //Vendor Entry >>>
        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := TemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatch;

        GenJnlLine."Posting Date" := WORKDATE;

        CLEAR(NoSeriesMgt);
        GenJnlBatchRec.RESET;
        GenJnlBatchRec.SETRANGE("Journal Template Name", TemplateName);
        GenJnlBatchRec.SETRANGE(Name, JournalBatch);
        GenJnlBatchRec.SETFILTER("Posting No. Series", '<>%1', '');
        IF GenJnlBatchRec.FINDFIRST THEN BEGIN
            GenJnlLine."Document No." := DocNo;
            GenJnlLine."Posting No. Series" := GenJnlBatchRec."Posting No. Series";
            IF GenJnlTemplateRec.GET(GenJnlBatchRec."Journal Template Name") THEN
                GenJnlLine."Source Code" := GenJnlTemplateRec."Source Code";
        END;


        GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
        GenJnlLine.VALIDATE("Account No.", VehicleInsuranceHP."Insurance Company Code");

        IF VehicleInsuranceHP."Request for Cancellation" THEN BEGIN
            GenJnlLine.VALIDATE(Amount, VehicleInsuranceHP."Ins. Prem Value (with VAT)");
        END ELSE BEGIN
            GenJnlLine.VALIDATE(Amount, -VehicleInsuranceHP."Ins. Prem Value (with VAT)");
        END;

        GenJnlLine.VALIDATE("Document Class", GenJnlLine."Document Class"::Customer);
        GenJnlLine.VALIDATE("Document Subclass", VehicleInsuranceHP."Customer No.");

        GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", VehicleFinanceHeader."Shortcut Dimension 1 Code");
        GenJnlLine.VALIDATE("Shortcut Dimension 2 Code", VehicleFinanceHeader."Shortcut Dimension 2 Code");
        GenJnlLine.ValidateShortcutDimCode(3, VehicleFinanceHeader."Shortcut Dimension 3 Code");
        GenJnlLine.VALIDATE(Description, 'Insurance Premium of Loan ' + VehicleInsuranceHP."Loan No.");

        GenJnlLine.VALIDATE("VF Posting Type", VFPostingType::Insurance);
        GenJnlLine.VALIDATE("Receipt Type", ReceiptType::"VF Payment");
        GenJnlLine.VALIDATE(VIN, VehicleInsuranceHP."VIN No.");

        GenJnlLine.VALIDATE("External Document No.", '');

        IF VehicleInsuranceHP."Request for Cancellation" THEN
            GenJnlLine.Narration := 'System Created Entry: Cancellation of Insurance Premium of Loan '
                                    + VehicleInsuranceHP."Loan No." + 'Policy No. ' + VehicleInsuranceHP."Policy No."

        ELSE
            GenJnlLine.Narration := 'System Created Entry: Insurance Premium of Loan '
                                    + VehicleInsuranceHP."Loan No." + 'Policy No. ' + VehicleInsuranceHP."Policy No.";

        GenJnlLine."VF Loan File No." := VehicleInsuranceHP."Loan No.";

        GenJnlLine."Posting Date" := WORKDATE;

        //GenJnlPost.RUN(GenJnlLine);
        GenJnlPost.RunWithCheck(GenJnlLine);

        IF VehicleInsuranceHP."Request for Cancellation" THEN
            VehicleInsuranceHP."Cancellation Jnl. Doc. No." := DocNo
        ELSE
            VehicleInsuranceHP."Jnl. Document No." := DocNo;

        MESSAGE(PostTextMessage, VehicleInsuranceHP."Loan No.");
    end;

    [Scope('Internal')]
    procedure CalcExpiringIns(ExpiringDays: Integer): Integer
    var
        VehicleInsurance: Record "33020085";
        VFHeader: Record "33020062";
        TotalCount: Integer;
        VehicleInsurance2: Record "33020085";
    begin
        TotalCount := 0;
        VehicleInsurance.RESET;
        VehicleInsurance.SETRANGE(Status, VehicleInsurance.Status::Posted);
        VehicleInsurance.SETRANGE(Cancel, FALSE);
        VehicleInsurance.SETRANGE("End Date", TODAY, TODAY + ExpiringDays);
        IF VehicleInsurance.FINDFIRST THEN BEGIN
            REPEAT
                VehicleInsurance2.RESET;
                VehicleInsurance2.SETRANGE("Loan No.", VehicleInsurance."Loan No.");
                VehicleInsurance2.SETRANGE(Status, VehicleInsurance.Status::Posted);
                VehicleInsurance2.SETRANGE(Cancel, FALSE);
                VehicleInsurance2.SETFILTER("End Date", '>=%1', TODAY);

                VehicleInsurance2.SETCURRENTKEY("Loan No.", "End Date");

                IF VehicleInsurance2.FINDLAST THEN
                    IF VehicleInsurance2."End Date" <= VehicleInsurance."End Date" THEN   //Skiping the records if new insurance policy has been added
                        IF VFHeader.GET(VehicleInsurance."Loan No.") THEN
                            IF NOT VFHeader.Closed THEN
                                TotalCount += 1;
            UNTIL VehicleInsurance.NEXT = 0;
        END;

        EXIT(TotalCount);
    end;

    [Scope('Internal')]
    procedure DrillExpiringIns(ExpiringDays: Integer)
    var
        VehicleInsurance: Record "33020085";
        PostedVehiceInsList: Page "33020290";
        VFHeader: Record "33020062";
        VehicleInsurance2: Record "33020085";
    begin
        VehicleInsurance.RESET;
        VehicleInsurance.SETRANGE(Status, VehicleInsurance.Status::Posted);
        VehicleInsurance.SETRANGE(Cancel, FALSE);
        VehicleInsurance.SETRANGE("End Date", TODAY, TODAY + ExpiringDays);
        IF VehicleInsurance.FINDFIRST THEN BEGIN
            REPEAT
                VehicleInsurance2.RESET;
                VehicleInsurance2.SETRANGE("Loan No.", VehicleInsurance."Loan No.");
                VehicleInsurance2.SETRANGE(Status, VehicleInsurance.Status::Posted);
                VehicleInsurance2.SETRANGE(Cancel, FALSE);
                VehicleInsurance2.SETFILTER("End Date", '>=%1', TODAY);

                VehicleInsurance2.SETCURRENTKEY("Loan No.", "End Date");

                IF VehicleInsurance2.FINDLAST THEN
                    IF VehicleInsurance2."End Date" <= VehicleInsurance."End Date" THEN   //Skiping the records if new insurance policy has been added
                        IF VFHeader.GET(VehicleInsurance."Loan No.") THEN
                            IF NOT VFHeader.Closed THEN
                                VehicleInsurance.MARK(TRUE);

            UNTIL VehicleInsurance.NEXT = 0;

            VehicleInsurance.MARKEDONLY(TRUE);
            PAGE.RUN(PAGE::"Posted Vehicle Insurance List ", VehicleInsurance);
        END;
    end;

    [Scope('Internal')]
    procedure GetVehicleInsuranceHP(LoanNo: Code[20]; var VehicleInsuranceHP: Record "33020085"): Boolean
    begin
        VehicleInsuranceHP.RESET;
        VehicleInsuranceHP.SETRANGE("Loan No.", LoanNo);
        VehicleInsuranceHP.SETRANGE(Approved, TRUE);
        VehicleInsuranceHP.SETRANGE(Cancel, FALSE);
        VehicleInsuranceHP.SETFILTER("End Date", '>=%1', TODAY);
        IF VehicleInsuranceHP.FINDLAST THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure LookupVehicleInsuranceHP(LoanNo: Code[20])
    var
        VehicleInsuranceHP: Record "33020085";
    begin
        VehicleInsuranceHP.RESET;
        VehicleInsuranceHP.SETRANGE("Loan No.", LoanNo);
        VehicleInsuranceHP.SETRANGE(Approved, TRUE);
        VehicleInsuranceHP.SETRANGE(Cancel, FALSE);
        VehicleInsuranceHP.SETFILTER("End Date", '>=%1', TODAY);
        IF VehicleInsuranceHP.FINDLAST THEN
            IF VehicleInsuranceHP.Posted THEN
                PAGE.RUN(PAGE::"Posted Vehicle Insurance List ", VehicleInsuranceHP)
            ELSE
                PAGE.RUN(PAGE::"Approved Veh. Insurance List", VehicleInsuranceHP)
    end;

    [Scope('Internal')]
    procedure CalcExpiredIns(): Integer
    var
        VehicleInsurance: Record "33020085";
        VFHeader: Record "33020062";
        TotalCount: Integer;
        VehicleInsurance2: Record "33020085";
    begin
        TotalCount := 0;
        VFHeader.RESET;
        VFHeader.SETRANGE(Closed, FALSE);
        IF VFHeader.FINDFIRST THEN BEGIN
            REPEAT
                VehicleInsurance.RESET;
                VehicleInsurance.SETRANGE("Loan No.", VFHeader."Loan No.");
                VehicleInsurance.SETRANGE(Status, VehicleInsurance.Status::Posted);
                VehicleInsurance.SETRANGE(Cancel, FALSE);
                VehicleInsurance.SETCURRENTKEY("Loan No.", "End Date");
                IF VehicleInsurance.FINDLAST THEN
                    IF VehicleInsurance."End Date" < TODAY THEN
                        TotalCount += 1;
            UNTIL VFHeader.NEXT = 0;
        END;

        EXIT(TotalCount);
    end;

    [Scope('Internal')]
    procedure DrillExpiredIns()
    var
        VehicleInsurance: Record "33020085";
        PostedVehiceInsList: Page "33020290";
        VFHeader: Record "33020062";
        VehicleInsuranceTemp: Record "33020085" temporary;
    begin
        VFHeader.RESET;
        VFHeader.SETRANGE(Closed, FALSE);
        IF VFHeader.FINDFIRST THEN BEGIN
            REPEAT
                VehicleInsurance.RESET;
                VehicleInsurance.SETRANGE("Loan No.", VFHeader."Loan No.");
                VehicleInsurance.SETRANGE(Status, VehicleInsurance.Status::Posted);
                VehicleInsurance.SETRANGE(Cancel, FALSE);
                VehicleInsurance.SETCURRENTKEY("Loan No.", "End Date");
                IF VehicleInsurance.FINDLAST THEN
                    IF VehicleInsurance."End Date" < TODAY THEN BEGIN
                        VehicleInsuranceTemp.INIT;
                        VehicleInsuranceTemp.TRANSFERFIELDS(VehicleInsurance);
                        VehicleInsuranceTemp.INSERT;
                        //VehicleInsurance.MARK(TRUE);
                    END;
            UNTIL VFHeader.NEXT = 0;
            //VehicleInsurance.MARKEDONLY(TRUE);
            PAGE.RUN(PAGE::"Posted Vehicle Insurance List ", VehicleInsuranceTemp);
        END;
    end;
}


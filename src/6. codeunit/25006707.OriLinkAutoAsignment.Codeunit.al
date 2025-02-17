codeunit 25006707 "OriLink Auto Asignment"
{

    trigger OnRun()
    begin
        Code
    end;

    var
        Text030: Label 'Is going to AutoAssign via C %1 with %2 record No: %3.';

    [Scope('Internal')]
    procedure "Code"()
    var
        SIERegister: Record "25006709";
        OriLinkAutoAsignment: Codeunit "25006707";
    begin
        SIERegister.RESET;
        SIERegister.SETCURRENTKEY("Auto Asigned", "Creation Date");
        SIERegister.SETRANGE("Auto Asigned", FALSE);
        SIERegister.SETRANGE("Creation Date", TODAY);
        IF SIERegister.FINDFIRST THEN
            REPEAT
                //IF NOT GUIALLOWED THEN
                //MESSAGE('NASMSG: is going to MarkRegister');
                MarkRegister(SIERegister);
                //IF NOT GUIALLOWED THEN
                //MESSAGE('NASMSG: is going to FillSIEAssignment for SIERegister:'+ FORMAT(SIERegister."No."));
                FillSIEAssignment(SIERegister);
            UNTIL SIERegister.NEXT = 0;
        //IF NOT GUIALLOWED THEN
        //MESSAGE('NASMSG: HAS FINISHED AutoAsignUnit');
    end;

    [Scope('Internal')]
    procedure MarkRegister(var SIERegister: Record "25006709")
    var
        SIERegister2: Record "25006709";
    begin
        SIERegister2.GET(SIERegister."No.");
        SIERegister2."Auto Asigned" := TRUE;
        SIERegister2.MODIFY;
    end;

    [Scope('Internal')]
    procedure FillSIEAssignment(var SIERegister: Record "25006709")
    var
        SIELedgerEntry: Record "25006703";
        SIEAssignment: Record "25006706";
        SIEAssignmentCU: Codeunit "25006702";
        FilterSIEAssgnt: Record "25006706";
        SIESetup: Record "25006701";
    begin
        SIESetup.GET;
        SIELedgerEntry.RESET;
        SIELedgerEntry.SETRANGE("Entry No.", SIERegister."From Entry No.", SIERegister."To Entry No.");
        IF SIELedgerEntry.FINDFIRST THEN BEGIN
            IF SIESetup."Automatic Assign" THEN BEGIN
                REPEAT
                    CreateAssignmentFilter(FilterSIEAssgnt, SIELedgerEntry."External Document No.", 0);
                    //IF NOT GUIALLOWED THEN
                    //MESSAGE('NASMSG: is going to ReopenServOrder:'+ SIELedgerEntry."External Document No.");
                    ReopenServOrder(SIELedgerEntry."External Document No.");
                    //IF NOT GUIALLOWED THEN
                    //MESSAGE('NASMSG: is going to SIEAssignmentCU.AddUnassignedTranSilent for SLE:'+
                    //FORMAT(SIELedgerEntry."Entry No."));
                    SIEAssignmentCU.AddUnassignedTranSilent(FilterSIEAssgnt, SIELedgerEntry."Entry No.");
                    //IF NOT GUIALLOWED THEN
                    //MESSAGE('NASMSG: is going to SIEAssignmentCU.PostAssignment for FilterSIEAssgnt:'+
                    //FORMAT(FilterSIEAssgnt."Entry No."));
                    SIEAssignmentCU.PostAssignment(FilterSIEAssgnt, 0);
                UNTIL SIELedgerEntry.NEXT = 0;
            END;

            IF SIESetup."Automatic PutInTakeOut" THEN BEGIN
                SIELedgerEntry.FINDFIRST;
                REPEAT
                    //IF NOT GUIALLOWED THEN
                    //MESSAGE('NASMSG: is going to CreateAssignmentFilter for SIELedgerEntry."External Document No."='+
                    //SIELedgerEntry."External Document No.");
                    CreateAssignmentFilter(FilterSIEAssgnt, SIELedgerEntry."External Document No.", 0);
                    //IF NOT GUIALLOWED THEN
                    //MESSAGE('NASMSG: is going to SIEAssignmentCU.TransferAll for FilterSIEAssgnt:'+
                    //FORMAT(FilterSIEAssgnt."Entry No."));
                    SIEAssignmentCU.TransferAll(FilterSIEAssgnt);
                    //SIEAssignmentCU.PostTransferAll(FilterSIEAssgnt);  // 21.12.2012 P8
                    COMMIT;
                UNTIL SIELedgerEntry.NEXT = 0;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure CreateAssignmentFilter(var FilterSIEAssgnt: Record "25006706"; DocNo: Code[20]; LineNo: Integer)
    begin
        CLEAR(FilterSIEAssgnt);
        FilterSIEAssgnt.SETRANGE("Applies-to Type", DATABASE::"Service Line EDMS");
        FilterSIEAssgnt.SETRANGE("Applies-to Doc. Type", "Applies-to Doc. Type"::Order);
        FilterSIEAssgnt.SETRANGE("Applies-to Doc. No.", DocNo);
        IF NOT FilterSIEAssgnt.FINDLAST THEN BEGIN
            FilterSIEAssgnt."Applies-to Type" := DATABASE::"Service Line EDMS";
            FilterSIEAssgnt."Applies-to Doc. Type" := "Applies-to Doc. Type"::Order;
            FilterSIEAssgnt."Applies-to Doc. No." := DocNo;
        END;
        FilterSIEAssgnt."Applies-to Doc. Line No." := 0;
    end;

    [Scope('Internal')]
    procedure ReopenServOrder(DocNo: Code[20])
    var
        ServHeader: Record "25006145";
        ReleaseServDoc: Codeunit "25006119";
    begin
        ServHeader.RESET;
        IF NOT ServHeader.GET(ServHeader."Document Type"::Order, DocNo) THEN
            EXIT;

        IF ServHeader.Status = ServHeader.Status::Released THEN
            ReleaseServDoc.PerformManualReopen(ServHeader);
    end;
}


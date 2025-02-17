codeunit 25006111 "Ext. Service Jnl.-Post Line"
{
    // 27.02.2013 EDMS P8
    //   * Implement new dimension set

    TableNo = 25006143;

    trigger OnRun()
    begin
        GetGLSetup;

        RunWithCheck(Rec);
    end;

    var
        GLSetup: Record "98";
        ExtServiceJnlLine: Record "25006143";
        ExtServiceLedgEntry: Record "25006137";
        ExtService: Record "25006133";
        ExtServiceReg: Record "25006152";
        ExtServiceJnlCheckLine: Codeunit "25006110";
        NextEntryNo: Integer;
        GLSetupRead: Boolean;
        Error100: Label 'Tracking Number is required for External Service %1.';

    [Scope('Internal')]
    procedure RunWithCheck(var ExtServiceJnlLine2: Record "25006143")
    begin
        ExtServiceJnlLine.COPY(ExtServiceJnlLine2);


        Code;
        ExtServiceJnlLine2 := ExtServiceJnlLine;
    end;

    local procedure "Code"()
    begin
        //  ExtServiceJnlCheckLine.RunCheck(ExtServiceJnlLine,TempJnlLineDim);//30.10.2012 EDMS
        ExtServiceJnlCheckLine.RunCheck(ExtServiceJnlLine);//30.10.2012 EDMS

        IF NextEntryNo = 0 THEN BEGIN
            ExtServiceLedgEntry.LOCKTABLE;
            IF ExtServiceLedgEntry.FINDLAST THEN
                NextEntryNo := ExtServiceLedgEntry."Entry No.";
            NextEntryNo := NextEntryNo + 1;
        END;

        IF ExtServiceReg."No." = 0 THEN BEGIN
            ExtServiceReg.LOCKTABLE;
            IF (NOT ExtServiceReg.FINDLAST) OR (ExtServiceReg."To Entry No." <> 0) THEN BEGIN
                ExtServiceReg.INIT;
                ExtServiceReg."No." := ExtServiceReg."No." + 1;
                ExtServiceReg."From Entry No." := NextEntryNo;
                ExtServiceReg."To Entry No." := NextEntryNo;
                ExtServiceReg."Creation Date" := TODAY;
                ExtServiceReg."Source Code" := "Source Code";
                ExtServiceReg."Journal Batch Name" := ExtServiceJnlLine."Journal Batch Name";
                ExtServiceReg."User ID" := USERID;
                ExtServiceReg.INSERT;
            END;
        END;
        ExtServiceReg."To Entry No." := NextEntryNo;
        ExtServiceReg.MODIFY;

        ExtService.GET(ExtServiceJnlLine."Ext. Service No.");
        ExtService.TESTFIELD(Blocked, FALSE);

        IF ExtService."Allow Tracking Nos." THEN
            IF ExtServiceJnlLine."Ext. Service Tracking No." = '' THEN
                ERROR(Error100, ExtServiceJnlLine."Ext. Service No.");

        ExtServiceLedgEntry.INIT;
        ExtServiceLedgEntry."Entry No." := NextEntryNo;
        ExtServiceLedgEntry."External Serv. No." := ExtServiceJnlLine."Ext. Service No.";
        ExtServiceLedgEntry."External Serv. Tracking No." := ExtServiceJnlLine."Ext. Service Tracking No.";
        ExtServiceLedgEntry."Posting Date" := ExtServiceJnlLine."Posting Date";
        ExtServiceLedgEntry."Entry Type" := ExtServiceJnlLine."Entry Type";
        ExtServiceLedgEntry."Source Type" := ExtServiceJnlLine."Source Type";
        ExtServiceLedgEntry."Source No." := ExtServiceJnlLine."Source No.";
        ExtServiceLedgEntry."Document No." := ExtServiceJnlLine."Document No.";
        ExtServiceLedgEntry."External Document No." := ExtServiceJnlLine."External Document No.";
        ExtServiceLedgEntry.Description := ExtServiceJnlLine.Description;
        ExtServiceLedgEntry."Location Code" := ExtServiceJnlLine."Location Code";
        ExtServiceLedgEntry."Journal Batch Name" := ExtServiceJnlLine."Journal Batch Name";
        ExtServiceLedgEntry.Quantity := Quantity;
        ExtServiceLedgEntry.Amount := Amount;
        ExtServiceLedgEntry."Dimension Set ID" := "Dimension Set ID";
        ExtServiceLedgEntry."Service Order No." := "Service Order No.";
        ExtServiceLedgEntry.INSERT;


        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
            GLSetup.GET;
        GLSetupRead := TRUE;
    end;
}


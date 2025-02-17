codeunit 25006212 "Warranty Jnl.-Post Line"
{
    TableNo = 25006206;

    trigger OnRun()
    begin
        GetGLSetup;

        RunWithCheck(Rec);
    end;

    var
        GLSetup: Record "98";
        WarrantyJnlLine: Record "25006206";
        WarrantyLedgEntry: Record "25006407";
        Veh: Record "25006005";
        WarrantyReg: Record "25006207";
        GenPostingSetup: Record "252";
        WarrantyJnlCheckLine: Codeunit "25006211";
        NextEntryNo: Integer;
        GLSetupRead: Boolean;
        Text001: Label 'Would you like to recalculate expected dates in plan?';

    [Scope('Internal')]
    procedure GetWarrantyReg(var NewWarrantyReg: Record "25006207")
    begin
        NewWarrantyReg := WarrantyReg;
    end;

    [Scope('Internal')]
    procedure RunWithCheck(var WarrantyJnlLine2: Record "25006206")
    begin
        WarrantyJnlLine.COPY(WarrantyJnlLine2);

        Code;
        WarrantyJnlLine2 := WarrantyJnlLine;
    end;

    local procedure "Code"()
    var
        ServiceLabor: Record "25006121";
        VehicleServicePlan: Record "25006126";
        ServicePlanDocumentLink: Record "25006157";
        ServicePlanManagement: Codeunit "25006103";
        VehicleServicePlanStageTmp: Record "25006132" temporary;
    begin
        IF EmptyLine THEN
            EXIT;

        WarrantyJnlCheckLine.RunCheck(WarrantyJnlLine);

        IF NextEntryNo = 0 THEN BEGIN
            WarrantyLedgEntry.LOCKTABLE;
            IF WarrantyLedgEntry.FINDLAST THEN
                NextEntryNo := WarrantyLedgEntry."Entry No.";
            NextEntryNo := NextEntryNo + 1;
        END;

        IF WarrantyJnlLine."Document Date" = 0D THEN
            WarrantyJnlLine."Document Date" := WarrantyJnlLine."Posting Date";

        InsertWarrantyReg(NextEntryNo);

        //Veh.GET("Vehicle Serial No.");
        //Veh.TESTFIELD(Blocked,FALSE);

        WarrantyLedgEntry.INIT;
        WarrantyLedgEntry.Amount := WarrantyJnlLine.Amount;
        WarrantyLedgEntry."Currency Code" := WarrantyJnlLine."Currency Code";
        WarrantyLedgEntry."Document No." := WarrantyJnlLine."Document No.";
        WarrantyLedgEntry."Document Date" := WarrantyJnlLine."Document Date";
        WarrantyLedgEntry."Debit Code" := WarrantyJnlLine."Debit Code";
        WarrantyLedgEntry."Debit Description" := WarrantyJnlLine."Debit Description";
        WarrantyLedgEntry."Entry No." := NextEntryNo;
        WarrantyLedgEntry."Reject Code" := WarrantyJnlLine."Reject Code";
        WarrantyLedgEntry."Reject Description" := WarrantyJnlLine."Reject Description";
        WarrantyLedgEntry.Status := WarrantyJnlLine.Status;
        WarrantyLedgEntry."Warranty Document Line No." := "Warranty Document Line No.";
        WarrantyLedgEntry."Warranty Document No." := "Warranty Document No.";

        WarrantyLedgEntry."Posting Date" := WarrantyJnlLine."Posting Date";
        WarrantyLedgEntry.VIN := WarrantyJnlLine.VIN;
        WarrantyLedgEntry."Vehicle Serial No." := WarrantyJnlLine."Vehicle Serial No.";
        WarrantyLedgEntry."Make Code" := WarrantyJnlLine."Make Code";
        WarrantyLedgEntry."Model Code" := WarrantyJnlLine."Model Code";
        WarrantyLedgEntry."Model Version No." := "Model Version No.";
        WarrantyLedgEntry."Vehicle Accounting Cycle No." := WarrantyJnlLine."Vehicle Accounting Cycle No.";
        WarrantyLedgEntry.Type := WarrantyJnlLine.Type;

        WarrantyLedgEntry.INSERT;
        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
            GLSetup.GET;
        GLSetupRead := TRUE;
    end;

    local procedure InsertWarrantyReg(LedgEntryNo: Integer)
    begin
        IF NOT (WarrantyReg.FINDLAST AND (WarrantyReg."To Entry No." = 0)) THEN BEGIN
            //  IF WarrantyReg."No." = 0 THEN BEGIN
            WarrantyReg.LOCKTABLE;
            IF WarrantyReg.FINDLAST THEN
                WarrantyReg."No." := WarrantyReg."No." + 1
            ELSE
                WarrantyReg."No." := 1;

            WarrantyReg.INIT;
            WarrantyReg."No." := WarrantyReg."No.";
            WarrantyReg."From Entry No." := LedgEntryNo;
            WarrantyReg."To Entry No." := LedgEntryNo;
            WarrantyReg."Creation Date" := TODAY;
            WarrantyReg."Creation Time" := TIME;
            WarrantyReg."Journal Batch Name" := WarrantyJnlLine."Journal Batch Name";
            WarrantyReg."User ID" := USERID;
            WarrantyReg.INSERT;
        END ELSE BEGIN
            IF ((LedgEntryNo < WarrantyReg."From Entry No.") AND (LedgEntryNo <> 0)) OR
               ((WarrantyReg."From Entry No." = 0) AND (LedgEntryNo > 0))
            THEN
                WarrantyReg."From Entry No." := LedgEntryNo;
            IF LedgEntryNo > WarrantyReg."To Entry No." THEN
                WarrantyReg."To Entry No." := LedgEntryNo;

            WarrantyReg.MODIFY;
        END;
    end;
}


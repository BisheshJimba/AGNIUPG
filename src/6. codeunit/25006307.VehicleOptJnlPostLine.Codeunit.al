codeunit 25006307 "Vehicle Opt. Jnl.-Post Line"
{
    // 21.03.2013 EDMS P8
    //   * FIX
    // 
    // //==================================================================================================================================
    // MËÇr“is: Veikt “ÿurn–Æla rindas gr–Æmato“òanu
    // //==================================================================================================================================

    Permissions = TableData 46 = imd;
    TableNo = 25006387;

    trigger OnRun()
    var
        iTVehOptRegNo: Integer;
    begin
        fGetGLSetup;
        fRunWithCheck(Rec, iTVehOptRegNo);
    end;

    var
        Text000: Label 'cannot be less than zero';
        Text001: Label 'Item Tracking is signed wrongly.';
        Text003: Label 'Reserved item %1 is not on inventory.';
        Text004: Label 'is too low';
        Text005: Label 'Item %1 is not on inventory.';
        Text008: Label 'Item tracking must be defined for item %1 %2.';
        Text011: Label 'Tracking Specification is missing.';
        Text012: Label 'Item %1 must be reserved.';
        Text013: Label '%1 in %2 for item %3 %4 is %5 it must be %6.';
        Text014: Label 'Serial No. %1 is already on inventory.';
        Text015: Label 'Serial Number is required for Item %1.';
        Text016: Label 'Lot Number is required for Item %1.';
        Text017: Label ' is before the posting date.';
        Text018: Label 'Item Tracking Serial No. %1 Lot No. %2 for Item No. %3 Variant %4 cannot be fully applied.';
        Text019: Label 'Order Tracking and Item Tracking conflict detected for Item %1.';
        Text020: Label 'The Item Tracking on the %1 does not match with the Item Tracking on the %2.  ';
        Text021: Label 'You must not define item tracking on %1 %2';
        Text022: Label 'You cannot apply %1 to %2 on the same item %3 on Production Order %4';
        Text99000000: Label 'must not be filled out when reservations exist';
        recGLSetup: Record "98";
        recInvtSetup: Record "313";
        recItem: Record "27";
        recGlobalVehOptLedgEntry: Record "25006388";
        recOldVehOptLedgEntry: Record "25006388";
        recVehOptReg: Record "25006390";
        recVehOptJnlLine: Record "25006387";
        recVehOptJnlLineOrigin: Record "25006387";
        recSourceCodeSetup: Record "242";
        recGenPostingSetup: Record "252";
        recTempSplitVehOptJnlLine: Record "25006387" temporary;
        cuVehOptJnlCheckLine: Codeunit "25006306";
        iVehOptLedgEntryNo: Integer;
        recInvtSetupRead: Boolean;
        bGLSetupRead: Boolean;
        iGlobalLastEntryNo: Integer;
        iGlobalVehOptRegNo: Integer;

    [Scope('Internal')]
    procedure fRunWithCheck(var recVehOptJnlLinePar: Record "25006387"; var iVehOptRegNo: Integer)
    var
        bPostVehOptJnlLine: Boolean;
        recVehOptLedgEntry55: Record "25006388";
    begin
        iGlobalVehOptRegNo := iVehOptRegNo; //Ieg“ùstam reËÇªistra Nr.

        recVehOptJnlLine.COPY(recVehOptJnlLinePar);

        bPostVehOptJnlLine := TRUE;

        fSetupSplitJnlLine(recVehOptJnlLinePar, bPostVehOptJnlLine);

        bPostVehOptJnlLine := TRUE;

        //Pamatcikls
        WHILE fSplitJnlLine(recVehOptJnlLine, bPostVehOptJnlLine) DO BEGIN
            IF bPostVehOptJnlLine THEN BEGIN
                fCode; //Pamatkods
            END
        END;

        recVehOptJnlLinePar := recVehOptJnlLine;

        iVehOptRegNo := iGlobalVehOptRegNo;
    end;

    local procedure fCode()
    begin

        cuVehOptJnlCheckLine.fRunCheck(recVehOptJnlLine); //Veicam rindas pamatp–Ærbaudi

        IF recVehOptJnlLine."Document Date" = 0D THEN
            recVehOptJnlLine."Document Date" := recVehOptJnlLine."Posting Date";

        //Ieg“ùstam pËÇdËÇjo gr–Æmatas ieraksta Nr.
        IF iVehOptLedgEntryNo = 0 THEN BEGIN
            recGlobalVehOptLedgEntry.LOCKTABLE;
            IF recGlobalVehOptLedgEntry.FINDLAST THEN
                iVehOptLedgEntryNo := recGlobalVehOptLedgEntry."Entry No.";
        END;

        fPostVehOptLine;//Gr–Æmato“òana
    end;

    local procedure fPostVehOptLine()
    begin
        //MËÇr“is: Veikt aizvieto“òanas rindas gr–Æmato“òanu
        //P–Ærbaudam vai prece nav blo“ËÇta
        //InicializËÇjam un iesprau“ÿam gr–Æmatas ierakstu
        IF "Update Sales Amounts" THEN BEGIN
            fUpdateSalesAmounts(recGlobalVehOptLedgEntry);
        END
        ELSE BEGIN
            fInitVehOptLedgEntry(recGlobalVehOptLedgEntry);
            fInsertVehOptLedgEntry(recGlobalVehOptLedgEntry);
        END;
    end;

    local procedure fInitVehOptLedgEntry(var recVehOptLedgEntry: Record "25006388")
    begin
        //MËÇr“is: Veikt aizvieto“òanas gr–Æmatas ieraksta inicializ–Æciju

        iVehOptLedgEntryNo := iVehOptLedgEntryNo + 1; //Ieg“ùstam jaunu ieraksta Nr.
                                                      //Veidojam ieraksta pamatdatus
                                                      //Attiecin–Æ“òana
        IF "Applies-to Entry" <> 0 THEN BEGIN
            //recVehOptJnlLine.TESTFIELD("Applies-to Entry");
            recVehOptLedgEntry.GET("Applies-to Entry");
            recVehOptLedgEntry.TESTFIELD(Open, TRUE);
            recVehOptLedgEntry.Open := FALSE;
            recVehOptLedgEntry."Closed by Entry No." := iVehOptLedgEntryNo;
            recVehOptLedgEntry.MODIFY;
        END;

        recVehOptLedgEntry.INIT;
        recVehOptLedgEntry."Entry No." := iVehOptLedgEntryNo;
        recVehOptLedgEntry."Posting Date" := recVehOptJnlLine."Posting Date";
        recVehOptLedgEntry."Document No." := recVehOptJnlLine."Document No.";
        recVehOptLedgEntry."Document Date" := recVehOptJnlLine."Document Date";
        recVehOptLedgEntry."External Document No." := recVehOptJnlLine."External Document No.";
        recVehOptLedgEntry."Vehicle Serial No." := recVehOptJnlLine."Vehicle Serial No.";
        recVehOptLedgEntry."Option Type" := recVehOptJnlLine."Option Type";
        recVehOptLedgEntry."Option Code" := recVehOptJnlLine."Option Code";
        recVehOptLedgEntry."Make Code" := recVehOptJnlLine."Make Code";
        recVehOptLedgEntry."Model Code" := recVehOptJnlLine."Model Code";
        recVehOptLedgEntry."Model Version No." := recVehOptJnlLine."Model Version No.";
        recVehOptLedgEntry.Standard := recVehOptJnlLine.Standard;
        recVehOptLedgEntry."Option Subtype" := recVehOptJnlLine."Option Subtype";
        recVehOptLedgEntry.Description := recVehOptJnlLine.Description;
        recVehOptLedgEntry."Description 2" := recVehOptJnlLine."Description 2";
        recVehOptLedgEntry."External Code" := recVehOptJnlLine."External Code";
        recVehOptLedgEntry."Cost Amount (LCY)" := recVehOptJnlLine."Cost Amount (LCY)";
        recVehOptLedgEntry."User ID" := USERID;
        recVehOptLedgEntry."Entry Type" := recVehOptJnlLine."Entry Type";
        recVehOptLedgEntry.Correction := recVehOptJnlLine.Correction;
        recVehOptLedgEntry.Open := NOT recVehOptLedgEntry.Correction;
        IF recVehOptJnlLine."Entry Type" = recVehOptJnlLine."Entry Type"::Disassemble THEN
            recVehOptLedgEntry.Open := FALSE;
        recVehOptLedgEntry."Assembly ID" := recVehOptJnlLine."Assembly ID";
        iGlobalLastEntryNo := recVehOptLedgEntry."Entry No."
    end;

    local procedure fInsertVehOptLedgEntry(var recVehOptLedgEntry: Record "25006388")
    begin
        //MËÇr“is: Veikt aizvieto“òanas gr–Æmatas ieraksta iesprau“òanu
        //Isprau“ÿam gr–Æmatas ierakstu
        recVehOptLedgEntry.INSERT;
        //Papildinam pre“æu reËÇªistru
        fInsertVehOptReg(recVehOptLedgEntry."Entry No.");
    end;

    local procedure fSplitJnlLine(var recVehOptJnlLine2: Record "25006387"; bPostVehOptJnlLine: Boolean): Boolean
    var
        FreeEntryNo: Integer;
        JnlLineNo: Integer;
        SignFactor: Integer;
    begin
        IF recTempSplitVehOptJnlLine.FINDFIRST THEN BEGIN
            JnlLineNo := recVehOptJnlLine2."Line No.";
            recVehOptJnlLine2 := recTempSplitVehOptJnlLine;
            recVehOptJnlLine2."Line No." := JnlLineNo;
            recTempSplitVehOptJnlLine.DELETE;
            EXIT(TRUE);
        END ELSE BEGIN
            EXIT(FALSE);
        END
    end;

    local procedure fGetGLSetup()
    begin
        IF NOT bGLSetupRead THEN BEGIN
            recGLSetup.GET;
        END;
        bGLSetupRead := TRUE;
    end;

    local procedure fGetVehOptSetup()
    begin
        IF NOT recInvtSetupRead THEN BEGIN
            recInvtSetup.GET;
            recSourceCodeSetup.GET;
        END;
        recInvtSetupRead := TRUE;
    end;

    local procedure fSetupSplitJnlLine(var recVehOptJnlLine2: Record "25006387"; var bPostVehOptJnlLine: Boolean)
    var
        Text100: Label 'Fatal error when retrieving Tracking Specification';
        decFactor: Decimal;
        decFloatingFactor: Decimal;
        decNonDistrQuantity: Decimal;
        decNonDistrAmount: Decimal;
        decNonDistrAmountACY: Decimal;
        decNonDistrDiscountAmount: Decimal;
        iSignFactor: Integer;
        datCalcWarrantyDate: Date;
        datCalcExpirationDate: Date;
        bInvoice: Boolean;
        bSNInfoRequired: Boolean;
        bLotInfoRequired: Boolean;
        bItemTrackingOK: Boolean;
    begin

        recVehOptJnlLineOrigin := recVehOptJnlLine2;
        recTempSplitVehOptJnlLine.RESET;
        recTempSplitVehOptJnlLine.DELETEALL;

        fGetGLSetup;
        fGetVehOptSetup;


        recTempSplitVehOptJnlLine := recVehOptJnlLine2;
        recTempSplitVehOptJnlLine.INSERT;
    end;

    local procedure fInsertVehOptReg(iItemReplmtLedgEntryNo: Integer)
    var
        recSourceCodeSetup: Record "242";
    begin
        //MËÇr“is: Veikt aizvieto“òanas ieraksta ierakst•Æ“òanu pre“æu reËÇªistr–Æ
        IF recVehOptReg."No." = 0 THEN BEGIN //Ja reËÇªistra ieraksts neeksistËÇ
            recVehOptReg.LOCKTABLE;
            //Ieg“ùstam reËÇªistra Nr.
            IF recVehOptReg.FINDLAST THEN
                recVehOptReg."No." := recVehOptReg."No." + 1
            ELSE
                recVehOptReg."No." := 1;

            iGlobalVehOptRegNo := recVehOptReg."No.";

            recVehOptReg.INIT;
            recVehOptReg."From Entry No." := iVehOptLedgEntryNo;
            recVehOptReg."To Entry No." := iVehOptLedgEntryNo;
            recVehOptReg."Creation Date" := TODAY;
            recVehOptReg."Source Code" := recVehOptJnlLine."Source Code";
            recVehOptReg."Journal Batch Name" := recVehOptJnlLine."Journal Batch Name";
            recVehOptReg."User ID" := USERID;
            recVehOptReg.INSERT;
        END ELSE BEGIN
            IF ((iVehOptLedgEntryNo < recVehOptReg."From Entry No.") AND (iVehOptLedgEntryNo <> 0)) OR
               ((recVehOptReg."From Entry No." = 0) AND (iVehOptLedgEntryNo > 0))
            THEN
                recVehOptReg."From Entry No." := iVehOptLedgEntryNo;
            IF iVehOptLedgEntryNo > recVehOptReg."To Entry No." THEN
                recVehOptReg."To Entry No." := iVehOptLedgEntryNo;

            recVehOptReg.MODIFY;
        END;
    end;

    local procedure fUpdateSalesAmounts(var recVehOptLedgEntry: Record "25006388")
    begin
        //Atjauninam p–Ærdo“òans summas
        recVehOptJnlLine.TESTFIELD("Vehicle Serial No.");
        IF recVehOptJnlLine."Option Type" <> recVehOptJnlLine."Option Type"::"Vehicle Base" THEN
            recVehOptJnlLine.TESTFIELD("Option Code");

        recVehOptLedgEntry.RESET;
        recVehOptLedgEntry.SETCURRENTKEY("Vehicle Serial No.", "Entry Type", "Option Type", "Option Code", Open);
        recVehOptLedgEntry.SETRANGE("Vehicle Serial No.", recVehOptJnlLine."Vehicle Serial No.");
        recVehOptLedgEntry.SETRANGE("Option Type", recVehOptJnlLine."Option Type");
        recVehOptLedgEntry.SETRANGE("Option Code", recVehOptJnlLine."Option Code");
        IF recVehOptLedgEntry.FINDSET(TRUE, FALSE) THEN
            REPEAT
                recVehOptLedgEntry."Sales Price (LCY)" := "Sales Price (LCY)";
                recVehOptLedgEntry."Sales Discount %" := "Sales Discount %";
                recVehOptLedgEntry."Sales Discount Amount (LCY)" := "Sales Discount Amount (LCY)";
                recVehOptLedgEntry."Sales Amount (LCY)" := "Sales Amount (LCY)";
                recVehOptLedgEntry.MODIFY;
            UNTIL recVehOptLedgEntry.NEXT = 0;
    end;
}


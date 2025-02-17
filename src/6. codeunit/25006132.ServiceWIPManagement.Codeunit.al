codeunit 25006132 "Service WIP Management"
{

    trigger OnRun()
    begin
    end;

    var
        ServWIPMngt: Record "25006132";
        TmpWIPEntry: Record "25006194" temporary;
        GenJnPostLine: Codeunit "12";
        TEXT01: Label 'Do You want to delete calculated WIP for Service Order %1 ?';

    [Scope('Internal')]
    procedure ReCalcWIP2(WIPServiceOrderHeader: Record "25006192")
    var
        WIPServiceOrderLine: Record "25006193";
        ServiceWIPSetup: Record "25006191";
        ResourceCost: Decimal;
        UnitCost: Decimal;
        ReservQty: Decimal;
        FinishedQty: Decimal;
    begin
        ServiceWIPSetup.GET;
        WIPServiceOrderLine.RESET;
        WIPServiceOrderLine.SETRANGE("Service Order No.", WIPServiceOrderHeader."Service Order No.");
        IF WIPServiceOrderLine.FIND('-') THEN
            REPEAT
                CASE WIPServiceOrderLine.Type OF
                    WIPServiceOrderLine.Type::Item:
                        BEGIN
                            CalcTransferedQtyOnDate(WIPServiceOrderHeader."Service Order No.", WIPServiceOrderLine."Service Order Line No.", WIPServiceOrderHeader."WIP Date", "Unit Cost", ReservQty);
                            WIPServiceOrderLine.VALIDATE("Recognized Cost Qty.", ReservQty);
                            WIPServiceOrderLine.VALIDATE("Recognized Sales Qty.", ReservQty);
                        END;

                    WIPServiceOrderLine.Type::Labor:
                        BEGIN
                            ResourceCost := ServiceWIPSetup."Default Resource Unit Cost";
                            CalcFinishedLaborOnDate(WIPServiceOrderHeader."Service Order No.", WIPServiceOrderLine."Service Order Line No.", WIPServiceOrderHeader."WIP Date", ResourceCost, FinishedQty);
                            "Unit Cost" := ResourceCost;
                            WIPServiceOrderLine.VALIDATE("Recognized Cost Qty.", FinishedQty);
                            IF Finished THEN
                                WIPServiceOrderLine.VALIDATE("Recognized Sales Qty.", Quantity);
                        END;

                    WIPServiceOrderLine.Type::"External Service":
                        BEGIN
                            CalcFinishedExtServOnDate(WIPServiceOrderLine."No.", WIPServiceOrderHeader."WIP Date", "External Serv. Tracking No.", "Unit Cost", "Finished Qty.");
                            WIPServiceOrderLine.VALIDATE("Recognized Cost Qty.", "Finished Qty.");
                            WIPServiceOrderLine.VALIDATE("Recognized Sales Qty.", "Finished Qty.");
                        END;
                END;
                WIPServiceOrderLine.MODIFY;
            UNTIL WIPServiceOrderLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure ReCalcWIP(WIPServiceOrderHeader: Record "25006192")
    var
        WIPServiceOrderLine: Record "25006193";
        ServiceWIPSetup: Record "25006191";
        ResourceCost: Decimal;
        UnitCost: Decimal;
        ReservQty: Decimal;
        FinishedQty: Decimal;
    begin
        ServiceWIPSetup.GET;
        WIPServiceOrderLine.RESET;
        WIPServiceOrderLine.SETRANGE("Service Order No.", WIPServiceOrderHeader."Service Order No.");
        IF WIPServiceOrderLine.FIND('-') THEN
            REPEAT
                WIPServiceOrderLine.VALIDATE("Recognized Cost Qty.", "Recognized Cost Qty. (Calc)");
                WIPServiceOrderLine.VALIDATE("Recognized Sales Qty.", "Recognized Sales Qty. (Calc)");
                WIPServiceOrderLine.MODIFY;
            UNTIL WIPServiceOrderLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CalcWIP(ServiceHeader: Record "25006145"; DocumentNo: Code[20]; WIPDate: Date; DeleteCalculated: Boolean)
    var
        WIPServiceOrderHeader: Record "25006192";
        WIPServiceOrderLine: Record "25006193";
        ServiceWIPSetup: Record "25006191";
        ServiceLine: Record "25006146";
        ServiceWorkStatusEDMS: Record "25006166";
        Item: Record "27";
        Resource: Record "156";
        FinishedCost: Decimal;
        ResourceCost: Decimal;
        FinishedQty: Decimal;
        NoSeries: Code[20];
        NoSeriesMgt: Codeunit "396";
        LaborFinishPercentage: Decimal;
    begin
        WIPServiceOrderHeader.RESET;
        WIPServiceOrderHeader.SETRANGE("Service Order No.", ServiceHeader."No.");
        IF WIPServiceOrderHeader.FINDFIRST THEN BEGIN
            IF DeleteCalculated THEN
                WIPServiceOrderHeader.DELETE(TRUE)
            ELSE
                EXIT;
        END;

        ServiceWIPSetup.GET;
        WIPServiceOrderHeader.INIT;
        //IF DocumentNo = '' THEN
        //  NoSeriesMgt.InitSeries(ServiceWIPSetup."WIP Document No. Series",NoSeries,WIPDate,WIPServiceOrderHeader."WIP Document No.",NoSeries)
        //ELSE
        //  WIPServiceOrderHeader."WIP Document No." := DocumentNo;

        WIPServiceOrderHeader."WIP Date" := WIPDate;
        WIPServiceOrderHeader."Service Order No." := ServiceHeader."No.";
        WIPServiceOrderHeader."Service Order Date" := ServiceHeader."Document Date";
        WIPServiceOrderHeader."Sell-to Customer No." := ServiceHeader."Sell-to Customer No.";
        WIPServiceOrderHeader."Sell-to Customer Name" := ServiceHeader."Sell-to Customer Name";
        WIPServiceOrderHeader."Gen. Bus. Posting Group" := ServiceHeader."Gen. Bus. Posting Group";
        WIPServiceOrderHeader."Currency Code" := ServiceHeader."Currency Code";
        WIPServiceOrderHeader."Currency Factor" := ServiceHeader."Currency Factor";
        WIPServiceOrderHeader."Prices Including VAT" := ServiceHeader."Prices Including VAT";
        WIPServiceOrderHeader."Vehicle Registration No." := ServiceHeader."Vehicle Registration No.";
        WIPServiceOrderHeader."Make Code" := ServiceHeader."Make Code";
        WIPServiceOrderHeader."Model Code" := ServiceHeader."Model Code";
        WIPServiceOrderHeader."Vehicle Serial No." := ServiceHeader."Vehicle Serial No.";
        WIPServiceOrderHeader."Vehicle Accounting Cycle No." := ServiceHeader."Vehicle Accounting Cycle No.";
        WIPServiceOrderHeader.INSERT;

        WIPServiceOrderLine.RESET;
        WIPServiceOrderLine.SETRANGE("Service Order No.", ServiceHeader."No.");
        WIPServiceOrderLine.DELETEALL;
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETFILTER(Type, '%1|%2|%3', 2, 3, 4);
        IF ServiceLine.FIND('-') THEN
            REPEAT
                WIPServiceOrderLine.INIT;
                WIPServiceOrderLine."Service Order No." := ServiceHeader."No.";
                WIPServiceOrderLine."Service Order Line No." := ServiceLine."Line No.";
                //"WIP Date" := WIPServiceOrderHeader."WIP Date";
                WIPServiceOrderLine."WIP Method" := ServiceWIPSetup."WIP Method";
                WIPServiceOrderLine."Service Order Date." := ServiceHeader."Order Date";
                WIPServiceOrderLine."Sell-to Customer No." := ServiceHeader."Sell-to Customer No.";
                WIPServiceOrderLine."Sell-to Customer Name" := ServiceHeader."Sell-to Customer Name";

                WIPServiceOrderLine."No." := ServiceLine."No.";
                WIPServiceOrderLine.Description := ServiceLine.Description;
                WIPServiceOrderLine."Gen. Prod. Posting Group" := ServiceLine."Gen. Prod. Posting Group";
                WIPServiceOrderLine."Gen. Bus. Posting Group" := ServiceHeader."Gen. Bus. Posting Group";
                WIPServiceOrderLine."Unit of Measure Code" := ServiceLine."Unit of Measure Code";
                "Dimension Set ID" := ServiceLine."Dimension Set ID";
                Quantity := ServiceLine.Quantity;
                "VAT %" := ServiceLine."VAT %";
                "Line Discount %" := ServiceLine."Line Discount %";

                IF ServiceLine.Status <> '' THEN
                    ServiceWorkStatusEDMS.GET(ServiceLine.Status);

                IF ServiceWorkStatusEDMS."Service Order Status" = ServiceWorkStatusEDMS."Service Order Status"::Finished THEN
                    Finished := TRUE;

                IF (WIPServiceOrderHeader."Currency Code" <> '') AND (WIPServiceOrderHeader."Currency Factor" <> 0) THEN
                    "Unit Price (LCY)" := ServiceLine."Unit Price" / WIPServiceOrderHeader."Currency Factor"
                ELSE
                    "Unit Price (LCY)" := ServiceLine."Unit Price";

                IF WIPServiceOrderHeader."Prices Including VAT" THEN
                    "Unit Price (LCY)" := ROUND("Unit Price (LCY)" / ((100 + "VAT %") / 100), 0.00001);

                IF "Line Discount %" <> 0 THEN
                    "Unit Price (LCY)" := ROUND("Unit Price (LCY)" * ((100 - "Line Discount %") / 100), 0.00001);

                CASE ServiceLine.Type OF
                    ServiceLine.Type::Item:
                        BEGIN
                            WIPServiceOrderLine.Type := WIPServiceOrderLine.Type::Item;
                            CalcTransferedQtyOnDate(ServiceHeader."No.", ServiceLine."Line No.", WIPServiceOrderHeader."WIP Date", "Unit Cost", "Finished Qty.");
                            WIPServiceOrderLine.VALIDATE("Recognized Cost Qty.", "Finished Qty.");
                            WIPServiceOrderLine.VALIDATE("Recognized Sales Qty.", "Finished Qty.");
                            IF "Finished Qty." = Quantity THEN
                                Finished := TRUE;
                        END;
                    ServiceLine.Type::Labor:
                        BEGIN
                            LaborFinishPercentage := 0;
                            WIPServiceOrderLine.Type := WIPServiceOrderLine.Type::Labor;
                            ResourceCost := ServiceWIPSetup."Default Resource Unit Cost";
                            CalcFinishedLaborOnDate(ServiceHeader."No.", ServiceLine."Line No.", WIPServiceOrderHeader."WIP Date", ResourceCost, FinishedQty);
                            "Unit Cost" := ResourceCost;
                            WIPServiceOrderLine.VALIDATE("Recognized Cost Qty.", FinishedQty);

                            IF Finished THEN
                                WIPServiceOrderLine.VALIDATE("Recognized Sales Qty.", Quantity)
                            ELSE BEGIN
                                IF Quantity <> 0 THEN
                                    LaborFinishPercentage := FinishedQty / Quantity;
                                IF LaborFinishPercentage > 1 THEN
                                    LaborFinishPercentage := 1;
                                WIPServiceOrderLine.VALIDATE("Recognized Sales Qty.", ROUND(Quantity * LaborFinishPercentage, 0.01));
                            END;
                        END;
                    ServiceLine.Type::"External Service":
                        BEGIN
                            WIPServiceOrderLine.Type := WIPServiceOrderLine.Type::"External Service";
                            CalcFinishedExtServOnDate(WIPServiceOrderLine."No.", WIPServiceOrderHeader."WIP Date", "External Serv. Tracking No.", "Unit Cost", "Finished Qty.");
                            WIPServiceOrderLine.VALIDATE("Recognized Cost Qty.", "Finished Qty.");
                            WIPServiceOrderLine.VALIDATE("Recognized Sales Qty.", "Finished Qty.");
                            IF "Finished Qty." > 0 THEN
                                Finished := TRUE;
                        END;
                END;
                "Recognized Cost Qty. (Calc)" := "Recognized Cost Qty.";
                "Recognized Sales Qty. (Calc)" := "Recognized Sales Qty.";
                Amount := ROUND(Quantity * "Unit Price");
                WIPServiceOrderLine.INSERT;

            UNTIL ServiceLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CheckWIPGLAcc(AccNo: Code[20])
    var
        GLAcc: Record "15";
    begin
        GLAcc.GET(AccNo);
        GLAcc.CheckGLAcc;
        GLAcc.TESTFIELD("Gen. Posting Type", GLAcc."Gen. Posting Type"::" ");
        GLAcc.TESTFIELD("Gen. Bus. Posting Group", '');
        GLAcc.TESTFIELD("Gen. Prod. Posting Group", '');
        GLAcc.TESTFIELD("VAT Bus. Posting Group", '');
        GLAcc.TESTFIELD("VAT Prod. Posting Group", '');
    end;

    [Scope('Internal')]
    procedure PostWIPLine(TmpWIPEntry: Record "25006194" temporary; Reversed: Boolean) GLEntryPosted: Integer
    var
        GLAmount: Decimal;
        SorceCodeSetup: Record "242";
    begin
        SorceCodeSetup.GET;

        CheckWIPGLAcc(TmpWIPEntry."G/L Account No.");
        CheckWIPGLAcc(TmpWIPEntry."G/L Bal. Account No.");
        GLAmount := TmpWIPEntry."WIP Entry Amount";
        IF Reversed THEN
            GLAmount := -GLAmount;

        GLEntryPosted := InsertWIPGL(TmpWIPEntry."G/L Account No.", TmpWIPEntry."G/L Bal. Account No.", TmpWIPEntry."Document No.", TmpWIPEntry."Posting Date",
            SorceCodeSetup."Service G/L WIP EDMS", GLAmount, TmpWIPEntry.Description, TmpWIPEntry."Dimension Set ID",
            TmpWIPEntry."Vehicle Accounting Cycle No.", TmpWIPEntry."Vehicle Serial No.");
    end;

    [Scope('Internal')]
    procedure InsertWIPGL(GLAccountNo: Code[20]; BalGLAccountNo: Code[20]; WIPDocNo: Code[20]; PostingDate: Date; SourceCode: Code[10]; GLAmount: Decimal; Description: Text[50]; DimSetID: Integer; VehAccCycleNo: Code[20]; VehicleSerialNo: Code[20]) GLEntryPosted: Integer
    var
        GLAcc: Record "15";
        GenJnlLine: Record "81";
        DimMgt: Codeunit "408";
        GLReg: Record "45";
        WIPGLLink: Record "25006195";
        GLEntry: Record "17";
        n: Integer;
    begin
        GLAcc.GET(GLAccountNo);
        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine."Account No." := GLAccountNo;
        GenJnlLine."Bal. Account No." := BalGLAccountNo;
        GenJnlLine.Amount := GLAmount;
        GenJnlLine."Document No." := WIPDocNo;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine.Description := GenJnlLine.Description;
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Dimension Set ID" := DimSetID;
        //  "Vehicle Serial No." := VehicleSerialNo;
        //  "Vehicle Accounting Cycle No." := VehAccCycleNo;
        CLEAR(DimMgt);
        DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code",
          GenJnlLine."Shortcut Dimension 2 Code");
        GLEntryPosted := GenJnPostLine.RunWithCheck(GenJnlLine);

        //GenJnPostLine.GetGLReg(GLReg);
        //GLEntry.RESET;
        //GLEntry.SETFILTER("Entry No.", '%1..%2', GLReg."From Entry No.", GLReg."To Entry No.");
        //IF GLEntry.FIND('-') THEN REPEAT
        //  n += 1;   // only for test. Must remove
        //  WIPGLLink.INIT;
        //  WIPGLLink."G/L Register No." := GLReg."No.";
        //  WIPGLLink."G/L Entry No." := GLEntry."Entry No.";
        //  WIPGLLink."WIP Entry No." := n;
        //  WIPGLLink.INSERT;
        //UNTIL GLEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CalcTransferedQtyOnDate(ServiceHeaderNo: Code[20]; ServiceLineNo: Integer; WIPCalcDate: Date; var UnitCost: Decimal; var ReservQty: Decimal)
    var
        ReservationEntry: Record "337";
        ReservationEntry2: Record "337";
        ItemLedgEntry: Record "32";
        TotalCost: Decimal;
    begin
        ReservQty := 0;
        UnitCost := 0;
        ReservationEntry.RESET;
        ReservationEntry.SETRANGE("Source Type", 25006146);
        ReservationEntry.SETRANGE("Source ID", ServiceHeaderNo);
        ReservationEntry.SETRANGE("Source Ref. No.", ServiceLineNo);
        IF ReservationEntry.FIND('-') THEN
            REPEAT
                ReservationEntry2.GET(ReservationEntry."Entry No.", TRUE);
                IF ReservationEntry2."Source Type" = 32 THEN BEGIN
                    ItemLedgEntry.GET(ReservationEntry2."Source Ref. No.");
                    IF ItemLedgEntry."Posting Date" <= WIPCalcDate THEN BEGIN
                        ReservQty += ReservationEntry2."Quantity (Base)";
                        IF ItemLedgEntry.Quantity <> 0 THEN BEGIN
                            ItemLedgEntry.CALCFIELDS("Cost Amount (Actual)");
                            TotalCost += ReservationEntry2."Quantity (Base)" * (ItemLedgEntry."Cost Amount (Actual)" / ItemLedgEntry.Quantity);
                        END;
                    END;
                END;
            UNTIL ReservationEntry.NEXT = 0;
        IF ReservQty <> 0 THEN
            UnitCost := ROUND(TotalCost / ReservQty, 0.01);                   // ROUNDING precision ? 0.00001
    end;

    [Scope('Internal')]
    procedure CalcFinishedLaborOnDate(ServiceHeaderNo: Code[20]; ServiceLineNo: Integer; WIPCalcDate: Date; var UnitCost: Decimal; var FinishedQty: Decimal)
    var
        ServLaborAllocApplication: Record "25006277";
        ServLaborAllocEntry: Record "25006271";
        DatetimeMgt: Codeunit "25006012";
        ResourceCost: Decimal;
        FinishedCost: Decimal;
        Resource: Record "156";
    begin
        FinishedCost := 0;
        FinishedQty := 0;
        ServLaborAllocApplication.RESET;
        ServLaborAllocApplication.SETRANGE("Document Type", ServLaborAllocApplication."Document Type"::Order);
        ServLaborAllocApplication.SETRANGE("Document No.", ServiceHeaderNo);
        ServLaborAllocApplication.SETRANGE("Document Line No.", ServiceLineNo);
        IF ServLaborAllocApplication.FIND('-') THEN
            REPEAT
                IF ServLaborAllocApplication."Finished Quantity (Hours)" <> 0 THEN BEGIN
                    IF ServLaborAllocApplication."Allocation Entry No." <> 0 THEN BEGIN
                        ServLaborAllocEntry.GET(ServLaborAllocApplication."Allocation Entry No.");
                        IF DatetimeMgt.Datetime2Date(ServLaborAllocEntry."End Date-Time") <= WIPCalcDate THEN
                            FinishedQty += ServLaborAllocApplication."Finished Quantity (Hours)";
                    END ELSE
                        FinishedQty += ServLaborAllocApplication."Finished Quantity (Hours)";
                    Resource.GET(ServLaborAllocApplication."Resource No.");
                    ResourceCost := UnitCost;
                    IF Resource."Unit Cost" <> 0 THEN
                        ResourceCost := Resource."Unit Cost";
                    FinishedCost += ServLaborAllocApplication."Finished Quantity (Hours)" * ResourceCost;
                END;
            UNTIL ServLaborAllocApplication.NEXT = 0;
        IF FinishedQty <> 0 THEN
            UnitCost := ROUND(FinishedCost / FinishedQty, 0.01);             // ROUNDING precision ? 0.00001

        FinishedQty := ROUND(FinishedQty, 0.01);                          // ROUNDING precision ? 0.01
    end;

    [Scope('Internal')]
    procedure CalcFinishedExtServOnDate(ExtServiceNo: Code[20]; WIPCalcDate: Date; ExternalServTrackingNo: Code[10]; var UnitCost: Decimal; var FinishedQty: Decimal)
    var
        ExternalService: Record "25006133";
        ExternalServLedgEntry: Record "25006137";
    begin
        UnitCost := 0;
        FinishedQty := 0;
        ExternalService.GET(ExtServiceNo);
        ExternalServLedgEntry.RESET;
        ExternalServLedgEntry.SETCURRENTKEY("External Serv. No.", "External Serv. Tracking No.", "Entry Type");
        ExternalServLedgEntry.SETRANGE("External Serv. No.", ExternalService."No.");
        ExternalServLedgEntry.SETRANGE("Entry Type", ExternalServLedgEntry."Entry Type"::Purchase);
        ExternalServLedgEntry.SETRANGE("External Serv. Tracking No.", ExternalServTrackingNo);
        ExternalServLedgEntry.SETFILTER("Posting Date", '..%1', WIPCalcDate);
        ExternalServLedgEntry.CALCSUMS(Amount);
        UnitCost := ExternalServLedgEntry.Amount;
        IF UnitCost <> 0 THEN
            FinishedQty := 1;
    end;

    [Scope('Internal')]
    procedure PostWIP(var WIPServiceOrderHeader: Record "25006192"; PostingDate: Date; Consolidated: Boolean; ReverseDocumentNo: Code[20]; ReversePostingDate: Date)
    var
        WIPServiceOrderLine: Record "25006193";
        GeneralPostingSetup: Record "252";
        EntryNo: Integer;
        TmpEntryNo: Integer;
        WIPTransactionNo: Integer;
        WIPTotals: Record "25006196";
        NoSeriesMgt: Codeunit "396";
        ServiceWIPSetup: Record "25006191";
        NoSeries: Code[10];
    begin
        //-------- Post reverse WIP

        WIPTotals.RESET;
        WIPTotals.SETRANGE("Service Order No.", WIPServiceOrderHeader."Service Order No.");
        WIPTotals.SETRANGE(Reversed, FALSE);
        IF WIPTotals.FINDFIRST THEN
            PostReverseWIP(WIPTotals."Document No.", ReverseDocumentNo, ReversePostingDate);

        //-------- Post WIP

        ServiceWIPSetup.GET;
        NoSeriesMgt.InitSeries(ServiceWIPSetup."WIP Document No. Series", NoSeries, PostingDate, WIPServiceOrderHeader."WIP Document No.", NoSeries);

        CLEAR(TmpWIPEntry);
        WIPServiceOrderLine.RESET;
        WIPServiceOrderLine.SETRANGE("Service Order No.", WIPServiceOrderHeader."Service Order No.");
        IF WIPServiceOrderLine.FIND('-') THEN
            REPEAT
                GeneralPostingSetup.GET(WIPServiceOrderLine."Gen. Bus. Posting Group", WIPServiceOrderLine."Gen. Prod. Posting Group");


                IF WIPServiceOrderLine."WIP Method" = WIPServiceOrderLine."WIP Method"::"Sales Method" THEN BEGIN
                    InsertWIPEntry(WIPServiceOrderHeader."WIP Document No.", WIPServiceOrderLine, GeneralPostingSetup."WIP Cost Adjustment Acc.", GeneralPostingSetup."WIP Accured Cost Acc.",
                                        PostingDate, TmpWIPEntry."Entry Type"::"Accrued Costs", Consolidated, WIPServiceOrderLine."Recognized Cost Amount",
                                        WIPServiceOrderHeader."Vehicle Serial No.", WIPServiceOrderHeader."Vehicle Accounting Cycle No.");
                    InsertWIPEntry(WIPServiceOrderHeader."WIP Document No.", WIPServiceOrderLine, GeneralPostingSetup."WIP Accured Sales Acc.", GeneralPostingSetup."WIP Sales Adjusment Acc.",
                                        PostingDate, TmpWIPEntry."Entry Type"::"Accrued Sales", Consolidated, WIPServiceOrderLine."Recognized Sales Amount",
                                        WIPServiceOrderHeader."Vehicle Serial No.", WIPServiceOrderHeader."Vehicle Accounting Cycle No.");

                END ELSE
                    IF WIPServiceOrderLine."WIP Method" = WIPServiceOrderLine."WIP Method"::"Cost Method" THEN
                        InsertWIPEntry(WIPServiceOrderHeader."WIP Document No.", WIPServiceOrderLine, GeneralPostingSetup."WIP Accured Cost Acc.", GeneralPostingSetup."WIP Cost Adjustment Acc.",
                                            PostingDate, TmpWIPEntry."Entry Type"::"Accrued Costs", Consolidated, WIPServiceOrderLine."Recognized Cost Amount",
                                            WIPServiceOrderHeader."Vehicle Serial No.", WIPServiceOrderHeader."Vehicle Accounting Cycle No.");

                InsertPostedWIPServLine(WIPServiceOrderHeader."WIP Document No.", WIPServiceOrderLine);

            UNTIL WIPServiceOrderLine.NEXT = 0;

        TmpWIPEntry.RESET;
        IF TmpWIPEntry.FIND('-') THEN
            REPEAT
                IF TmpWIPEntry."WIP Entry Amount" <> 0 THEN BEGIN
                    PostWIPLine(TmpWIPEntry, FALSE);
                    WIPTotals.RESET;
                    IF WIPTotals.FINDLAST THEN
                        EntryNo := WIPTotals."Entry No.";
                    WIPTotals.SETRANGE("Document No.", WIPServiceOrderHeader."WIP Document No.");                // ?
                    WIPTotals.SETRANGE("Service Order No.", WIPServiceOrderHeader."Service Order No.");          // ?
                    IF NOT WIPTotals.FINDFIRST THEN BEGIN
                        WIPTotals.INIT;
                        WIPTotals."Entry No." := EntryNo + 1;
                        WIPTotals."Document No." := TmpWIPEntry."Document No.";                                      // WIP Document No.
                        WIPTotals."Posting Date" := TmpWIPEntry."Posting Date";
                        WIPTotals."Service Order No." := WIPServiceOrderHeader."Service Order No.";
                        WIPTotals.Consolidated := Consolidated;
                        WIPTotals.INSERT;
                    END;
                END;
            UNTIL TmpWIPEntry.NEXT = 0;

        WIPServiceOrderHeader.DELETE(TRUE);
    end;

    [Scope('Internal')]
    procedure PostReverseWIP(WIPDocumentNo: Code[20]; ReverseDocumentNo: Code[20]; ReversePostingDate: Date)
    var
        WIPTotal: Record "25006196";
        WIPEntry: Record "25006194";
        Consolidated: Boolean;
        TmpWIPEntry: Record "25006194" temporary;
        TmpEntryNo: Integer;
        NoSeries: Code[20];
        NoSeriesMgt: Codeunit "396";
        ServiceWIPSetup: Record "25006191";
        PostedOK: Boolean;
        GLEntryPosted: Integer;
    begin
        CLEAR(TmpWIPEntry);
        WIPTotal.RESET;
        WIPTotal.SETRANGE("Document No.", WIPDocumentNo);                          // must Find by WIPTotal Entry No
        IF WIPTotal.FINDFIRST THEN
            Consolidated := WIPTotal.Consolidated;

        ServiceWIPSetup.GET;
        IF ReverseDocumentNo = '' THEN
            NoSeriesMgt.InitSeries(ServiceWIPSetup."WIP Document No. Series", NoSeries, ReversePostingDate, ReverseDocumentNo, NoSeries);


        WIPEntry.RESET;
        WIPEntry.SETRANGE("Document No.", WIPDocumentNo);
        IF WIPEntry.FIND('-') THEN
            REPEAT
                //--------- Consolidate Postings >>
                TmpWIPEntry.RESET;
                TmpWIPEntry.SETRANGE("Document No.", ReverseDocumentNo);
                TmpWIPEntry.SETRANGE("Service Order No.", WIPEntry."Service Order No.");
                TmpWIPEntry.SETRANGE("G/L Account No.", WIPEntry."G/L Account No.");
                TmpWIPEntry.SETRANGE("G/L Bal. Account No.", WIPEntry."G/L Bal. Account No.");
                TmpWIPEntry.SETRANGE("Posting Date", ReversePostingDate);
                TmpWIPEntry.SETRANGE("Gen. Bus. Posting Group", WIPEntry."Gen. Bus. Posting Group");
                TmpWIPEntry.SETRANGE("Gen. Prod. Posting Group", WIPEntry."Gen. Prod. Posting Group");
                TmpWIPEntry.SETRANGE("Entry Type", WIPEntry."Entry Type");
                TmpWIPEntry.SETRANGE("WIP Method", WIPEntry."WIP Method");
                TmpWIPEntry.SETRANGE("Dimension Set ID", WIPEntry."Dimension Set ID");
                IF TmpWIPEntry.FIND('-') AND Consolidated THEN BEGIN
                    TmpWIPEntry."WIP Entry Amount" += WIPEntry."WIP Entry Amount";
                    TmpWIPEntry.MODIFY;
                END ELSE BEGIN
                    //---------- Consolidate Postings <<
                    TmpWIPEntry.RESET;
                    IF TmpWIPEntry.FINDLAST THEN BEGIN
                        TmpEntryNo := TmpWIPEntry."Entry No." + 1;
                    END ELSE BEGIN
                        TmpEntryNo := 1;
                    END;

                    TmpWIPEntry.INIT;
                    TmpWIPEntry."Entry No." := TmpEntryNo;
                    TmpWIPEntry."Document No." := ReverseDocumentNo;
                    TmpWIPEntry."Service Order No." := WIPEntry."Service Order No.";
                    TmpWIPEntry."G/L Account No." := WIPEntry."G/L Account No.";
                    TmpWIPEntry."G/L Bal. Account No." := WIPEntry."G/L Bal. Account No.";
                    TmpWIPEntry."Posting Date" := ReversePostingDate;
                    TmpWIPEntry."Gen. Bus. Posting Group" := WIPEntry."Gen. Bus. Posting Group";
                    TmpWIPEntry."Gen. Prod. Posting Group" := WIPEntry."Gen. Prod. Posting Group";
                    TmpWIPEntry."Entry Type" := WIPEntry."Entry Type";
                    TmpWIPEntry."WIP Method" := WIPEntry."WIP Method";
                    TmpWIPEntry."Dimension Set ID" := WIPEntry."Dimension Set ID";
                    TmpWIPEntry."WIP Entry Amount" := WIPEntry."WIP Entry Amount";
                    TmpWIPEntry.INSERT;
                END;
            UNTIL WIPEntry.NEXT = 0;

        TmpWIPEntry.RESET;
        IF TmpWIPEntry.FIND('-') THEN
            REPEAT
                IF TmpWIPEntry."WIP Entry Amount" <> 0 THEN
                    GLEntryPosted := PostWIPLine(TmpWIPEntry, TRUE);
            UNTIL TmpWIPEntry.NEXT = 0;

        IF GLEntryPosted <> 0 THEN BEGIN
            WIPTotal.RESET;
            WIPTotal.SETRANGE("Document No.", WIPDocumentNo);
            IF WIPTotal.FINDFIRST THEN BEGIN
                WIPTotal.Reversed := TRUE;
                WIPTotal."Reverse Document No." := ReverseDocumentNo;
                WIPTotal."Reverse Posting Date" := ReversePostingDate;
                WIPTotal.MODIFY;
            END;
            WIPEntry.RESET;
            WIPEntry.SETRANGE("Document No.", WIPDocumentNo);
            IF WIPEntry.FIND('-') THEN
                REPEAT
                    WIPEntry.Reversed := TRUE;
                    WIPEntry."Reverse Document No." := ReverseDocumentNo;
                    WIPEntry."Reverse Date" := ReversePostingDate;
                    WIPEntry.MODIFY;
                UNTIL WIPEntry.NEXT = 0;
        END;
    end;

    local procedure InsertWIPEntry(WIPDocumentNo: Code[20]; WIPServiceOrderLine: Record "25006193"; GLAccountNo: Code[10]; GLBalAccountNo: Code[10]; PostingDate: Date; EntryType: Integer; Consolidated: Boolean; Amount: Decimal; VehicleSerialNo: Code[20]; VehAccCycleNo: Code[20])
    var
        TmpEntryNo: Integer;
        EntryNo: Integer;
        WIPEntry: Record "25006194";
        ServWIPSetup: Record "25006191";
        DimMgt: Codeunit "408";
    begin
        ServWIPSetup.GET;
        IF (WIPServiceOrderLine."WIP Method" = WIPServiceOrderLine."WIP Method"::"Sales Method") AND (EntryType = 0) AND (NOT ServWIPSetup."Post Labor Cost for Sales Meth") THEN
            Amount := 0;
        //--------- Consolidate Postings >>
        TmpWIPEntry.RESET;
        TmpWIPEntry.SETRANGE("Document No.", WIPDocumentNo);
        TmpWIPEntry.SETRANGE("Service Order No.", WIPServiceOrderLine."Service Order No.");
        TmpWIPEntry.SETRANGE("G/L Account No.", GLAccountNo);
        TmpWIPEntry.SETRANGE("G/L Bal. Account No.", GLBalAccountNo);
        TmpWIPEntry.SETRANGE("Posting Date", PostingDate);
        TmpWIPEntry.SETRANGE("Gen. Bus. Posting Group", WIPServiceOrderLine."Gen. Bus. Posting Group");
        TmpWIPEntry.SETRANGE("Gen. Prod. Posting Group", WIPServiceOrderLine."Gen. Prod. Posting Group");
        TmpWIPEntry.SETRANGE("Entry Type", EntryType);
        TmpWIPEntry.SETRANGE("WIP Method", WIPServiceOrderLine."WIP Method");
        TmpWIPEntry.SETRANGE("Dimension Set ID", WIPServiceOrderLine."Dimension Set ID");
        IF Consolidated AND TmpWIPEntry.FIND('-') THEN BEGIN
            TmpWIPEntry."WIP Entry Amount" += Amount;
            TmpWIPEntry.MODIFY;
        END ELSE BEGIN
            //---------- Consolidate Postings <<

            TmpWIPEntry.RESET;
            IF TmpWIPEntry.FINDLAST THEN
                TmpEntryNo := TmpWIPEntry."Entry No." + 1
            ELSE
                TmpEntryNo := 1;

            TmpWIPEntry.INIT;
            TmpWIPEntry."Entry No." := TmpEntryNo;
            TmpWIPEntry."Document No." := WIPDocumentNo;
            TmpWIPEntry."Service Order No." := WIPServiceOrderLine."Service Order No.";
            TmpWIPEntry."G/L Account No." := GLAccountNo;
            TmpWIPEntry."G/L Bal. Account No." := GLBalAccountNo;
            TmpWIPEntry."Posting Date" := PostingDate;
            TmpWIPEntry."Gen. Bus. Posting Group" := WIPServiceOrderLine."Gen. Bus. Posting Group";
            TmpWIPEntry."Gen. Prod. Posting Group" := WIPServiceOrderLine."Gen. Prod. Posting Group";
            TmpWIPEntry."Entry Type" := EntryType;
            TmpWIPEntry."WIP Method" := WIPServiceOrderLine."WIP Method";
            TmpWIPEntry."Dimension Set ID" := WIPServiceOrderLine."Dimension Set ID";
            TmpWIPEntry."WIP Entry Amount" := Amount;
            TmpWIPEntry."Vehicle Serial No." := VehAccCycleNo;
            TmpWIPEntry."Vehicle Accounting Cycle No." := VehicleSerialNo;
            TmpWIPEntry.INSERT;
        END;

        WIPEntry.RESET;
        IF WIPEntry.FINDLAST THEN BEGIN
            EntryNo := WIPEntry."Entry No." + 1;
        END ELSE BEGIN
            EntryNo := 1;
        END;


        WIPEntry.INIT;
        WIPEntry."Entry No." := EntryNo;
        WIPEntry."Document No." := WIPDocumentNo;
        WIPEntry."Service Order No." := WIPServiceOrderLine."Service Order No.";
        WIPEntry."Service Order Line No." := WIPServiceOrderLine."Service Order Line No.";
        WIPEntry.Type := WIPServiceOrderLine.Type;
        WIPEntry."No." := WIPServiceOrderLine."No.";
        WIPEntry.Quantity := WIPServiceOrderLine.Quantity;
        WIPEntry."Finished Qty." := WIPServiceOrderLine."Finished Qty.";
        WIPEntry."G/L Account No." := GLAccountNo;
        WIPEntry."G/L Bal. Account No." := GLBalAccountNo;
        WIPEntry."Posting Date" := PostingDate;
        WIPEntry."Gen. Bus. Posting Group" := WIPServiceOrderLine."Gen. Bus. Posting Group";
        WIPEntry."Gen. Prod. Posting Group" := WIPServiceOrderLine."Gen. Prod. Posting Group";
        WIPEntry."Entry Type" := EntryType;
        WIPEntry."WIP Method" := WIPServiceOrderLine."WIP Method";
        WIPEntry."Dimension Set ID" := WIPServiceOrderLine."Dimension Set ID";
        WIPEntry."WIP Entry Amount" := Amount;
        WIPEntry.Description := WIPServiceOrderLine.Description;
        WIPEntry."Vehicle Serial No." := VehAccCycleNo;
        WIPEntry."Vehicle Accounting Cycle No." := VehicleSerialNo;

        DimMgt.UpdateGlobalDimFromDimSetID(WIPEntry."Dimension Set ID", WIPEntry."Global Dimension 1 Code",
          WIPEntry."Global Dimension 2 Code");

        WIPEntry.INSERT;
    end;

    [Scope('Internal')]
    procedure ServiceOrderCheckAndPostWIP(ServiceOrderNo: Code[20]; ReversePostingDate: Date)
    var
        WIPTotals: Record "25006196";
    begin
        WIPTotals.RESET;
        WIPTotals.SETRANGE("Service Order No.", ServiceOrderNo);
        WIPTotals.SETRANGE(Reversed, FALSE);
        IF WIPTotals.FINDFIRST THEN
            PostReverseWIP(WIPTotals."Document No.", '', ReversePostingDate);
    end;

    [Scope('Internal')]
    procedure DeleteCalculatedWIP(ServiceOrderNo: Code[20])
    var
        ServiceWIPHeader: Record "25006192";
        ServiceWIPLine: Record "25006193";
    begin
        ServiceWIPHeader.RESET;
        ServiceWIPHeader.SETRANGE("Service Order No.", ServiceOrderNo);
        IF ServiceWIPHeader.FIND('-') THEN BEGIN
            IF CONFIRM(STRSUBSTNO(TEXT01, ServiceOrderNo), TRUE) THEN
                ServiceWIPHeader.DELETE(TRUE);
        END;
    end;

    local procedure InsertPostedWIPServLine(WIPDocumentNo: Code[20]; ServOrderWIPLine: Record "25006193")
    var
        PostedServWIPOrdLine: Record "25006197";
    begin
        PostedServWIPOrdLine.INIT;
        PostedServWIPOrdLine."Document No." := WIPDocumentNo;
        PostedServWIPOrdLine.TRANSFERFIELDS(ServOrderWIPLine);
        PostedServWIPOrdLine.INSERT;
    end;
}


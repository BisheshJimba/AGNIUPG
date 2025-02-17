codeunit 25006314 "Veh.Trade-In Mgt."
{
    // 20.10.2008. EDMS P2
    //   * Added function SyncronizePurchaseAmount
    // 
    // 17.10.2008. EDMS P2
    //   * Changed code ApplyTradeIn
    // 
    // 01.09.2008. EDMS P2
    //   * Added function InsertPurcahseLineEntry
    //   * Added code PostPurchaseEntry, ApplyTradeIn, InsertSalesLine
    // 
    // 23.05.2007. EDMS P2
    //   * Created functions
    //      PostPurchaseEntry(DocumentNo : Code[20];DocumentLine : Integer;DocumentType : Integer)
    //      PostSalesEntry(DocumentNo : Code[20];DocumentLine : Integer;DocumentType : Integer)


    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'This Purchase Line is already in Vehicle Trade-In Entries.';
        SalesSetup: Record "311";

    [Scope('Internal')]
    procedure PostPurchaseEntry(DocumentNo: Code[20]; DocumentLine: Integer; DocumentType: Integer; LinkTradeInEntry: Integer)
    var
        VehTradeInAppEntry: Record "25006391";
        PurchInvHeader: Record "122";
        PurchInvLine: Record "123";
        PurchCrMemoHdr: Record "124";
        PurchCrMemoLine: Record "125";
        EntryNo: Integer;
    begin
        //01.09.2008. EDMS P2 >>
        IF NOT ((LinkTradeInEntry <> 0) AND VehTradeInAppEntry.GET(LinkTradeInEntry)) THEN BEGIN
            //01.09.2008. EDMS P2 <<
            VehTradeInAppEntry.RESET;
            IF VehTradeInAppEntry.FINDLAST THEN
                EntryNo := VehTradeInAppEntry."Entry No."
            ELSE
                EntryNo := 0;
            EntryNo += 1;

            VehTradeInAppEntry.INIT;
            VehTradeInAppEntry."Entry No." := EntryNo;
            VehTradeInAppEntry."Entry Type" := VehTradeInAppEntry."Entry Type"::Purchase;
            VehTradeInAppEntry.INSERT;
        END;
        IF DocumentType = 1 THEN BEGIN
            IF PurchInvHeader.GET(DocumentNo) THEN
                IF PurchInvLine.GET(DocumentNo, DocumentLine) THEN;
            VehTradeInAppEntry."Posting Date" := PurchInvHeader."Posting Date";
            VehTradeInAppEntry."Document Type" := VehTradeInAppEntry."Document Type"::Invoice;
            VehTradeInAppEntry."Document No." := DocumentNo;
            IF PurchInvHeader."Currency Code" <> '' THEN
                VehTradeInAppEntry."Amount (LCY)" := ROUND(PurchInvLine.Amount / PurchInvHeader."Currency Factor", 0.01)
            ELSE
                VehTradeInAppEntry."Amount (LCY)" := PurchInvLine.Amount;
            VehTradeInAppEntry."Amount (FCY)" := PurchInvLine.Amount;
            VehTradeInAppEntry."Currency Code" := PurchInvHeader."Currency Code";
            VehTradeInAppEntry."Vehicle Serial No." := PurchInvLine."Vehicle Serial No.";
            VehTradeInAppEntry."Vehicle Accounting Cycle No." := PurchInvLine."Vehicle Accounting Cycle No.";
        END
        ELSE BEGIN
            IF PurchCrMemoHdr.GET(DocumentNo) THEN
                IF PurchCrMemoLine.GET(DocumentNo, DocumentLine) THEN;
            VehTradeInAppEntry."Posting Date" := PurchCrMemoHdr."Posting Date";
            VehTradeInAppEntry."Document Type" := VehTradeInAppEntry."Document Type"::"Cr.Memo";
            VehTradeInAppEntry."Document No." := DocumentNo;
            IF PurchCrMemoHdr."Currency Code" <> '' THEN
                VehTradeInAppEntry."Amount (LCY)" := -ROUND(PurchCrMemoLine.Amount / PurchCrMemoHdr."Currency Factor", 0.01)
            ELSE
                VehTradeInAppEntry."Amount (LCY)" := -PurchCrMemoLine.Amount;
            VehTradeInAppEntry."Amount (FCY)" := -PurchCrMemoLine.Amount;
            VehTradeInAppEntry."Currency Code" := PurchCrMemoHdr."Currency Code";
            VehTradeInAppEntry."Vehicle Serial No." := PurchCrMemoLine."Vehicle Serial No.";
            VehTradeInAppEntry."Vehicle Accounting Cycle No." := PurchCrMemoLine."Vehicle Accounting Cycle No.";
        END;
        VehTradeInAppEntry.MODIFY;
    end;

    [Scope('Internal')]
    procedure InsertPurchaseLineEntry(DocumentNo: Code[20]; DocumentLine: Integer; DocumentType: Integer)
    var
        VehTradeInAppEntry: Record "25006391";
        PurchaseHdr: Record "38";
        PurchaseLine: Record "39";
        PurchaseLineAmount: Decimal;
        EntryNo: Integer;
    begin
        IF PurchaseHdr.GET(DocumentType, DocumentNo) THEN
            IF PurchaseLine.GET(DocumentType, DocumentNo, DocumentLine) THEN;

        IF PurchaseLine."Link Trade-In Entry" <> 0 THEN
            ERROR(Text001);

        VehTradeInAppEntry.RESET;
        IF VehTradeInAppEntry.FINDLAST THEN
            EntryNo := VehTradeInAppEntry."Entry No."
        ELSE
            EntryNo := 0;
        EntryNo += 1;

        VehTradeInAppEntry.INIT;
        VehTradeInAppEntry."Entry No." := EntryNo;
        VehTradeInAppEntry."Entry Type" := VehTradeInAppEntry."Entry Type"::Purchase;
        VehTradeInAppEntry."Posting Date" := PurchaseHdr."Posting Date";
        IF PurchaseHdr."Document Type" = PurchaseHdr."Document Type"::Order THEN
            VehTradeInAppEntry."Document Type" := VehTradeInAppEntry."Document Type"::Order
        ELSE
            VehTradeInAppEntry."Document Type" := VehTradeInAppEntry."Document Type"::"Ret. Order";

        VehTradeInAppEntry."Document No." := DocumentNo;

        IF PurchaseHdr."Prices Including VAT" THEN
            PurchaseLineAmount := PurchaseLine."Line Amount" / (1 + PurchaseLine."VAT %" / 100)
        ELSE
            PurchaseLineAmount := PurchaseLine."Line Amount";

        IF PurchaseHdr."Currency Code" <> '' THEN
            VehTradeInAppEntry."Amount (LCY)" := ROUND(PurchaseLineAmount / PurchaseHdr."Currency Factor", 0.01)
        ELSE
            VehTradeInAppEntry."Amount (LCY)" := ROUND(PurchaseLineAmount, 0.01);

        VehTradeInAppEntry."Amount (FCY)" := ROUND(PurchaseLineAmount, 0.01);
        VehTradeInAppEntry."Currency Code" := PurchaseHdr."Currency Code";
        VehTradeInAppEntry."Vehicle Serial No." := PurchaseLine."Vehicle Serial No.";
        VehTradeInAppEntry."Vehicle Accounting Cycle No." := PurchaseLine."Vehicle Accounting Cycle No.";
        VehTradeInAppEntry.INSERT;

        PurchaseLine."Link Trade-In Entry" := EntryNo;
        PurchaseLine.MODIFY;
    end;

    [Scope('Internal')]
    procedure SyncronizePurchaseAmount(PurchaseLine: Record "39")
    var
        VehTradeInAppEntry: Record "25006391";
        PurchaseHdr: Record "38";
        PurchaseLineAmount: Decimal;
    begin
        IF PurchaseLine."Link Trade-In Entry" = 0 THEN
            EXIT;

        PurchaseHdr.GET(PurchaseLine."Document Type", PurchaseLine."Document No.");

        IF NOT VehTradeInAppEntry.GET(PurchaseLine."Link Trade-In Entry") THEN
            EXIT;

        IF PurchaseHdr."Prices Including VAT" THEN
            PurchaseLineAmount := PurchaseLine."Line Amount" / (1 + PurchaseLine."VAT %" / 100)
        ELSE
            PurchaseLineAmount := PurchaseLine."Line Amount";

        IF PurchaseHdr."Currency Code" <> '' THEN
            VehTradeInAppEntry."Amount (LCY)" := ROUND(PurchaseLineAmount / PurchaseHdr."Currency Factor", 0.01)
        ELSE
            VehTradeInAppEntry."Amount (LCY)" := ROUND(PurchaseLineAmount, 0.01);

        VehTradeInAppEntry."Amount (FCY)" := ROUND(PurchaseLineAmount, 0.01);
        VehTradeInAppEntry."Currency Code" := PurchaseHdr."Currency Code";
        VehTradeInAppEntry.MODIFY;
    end;

    [Scope('Internal')]
    procedure PostSalesEntry(DocumentNo: Code[20]; DocumentLine: Integer; DocumentType: Integer)
    var
        VehTradeInAppEntry: Record "25006391";
        SalesInvHdr: Record "112";
        SalesInvLine: Record "113";
        SalesCrMemoHdr: Record "114";
        SalesCrMemoLine: Record "115";
        EntryNo: Integer;
    begin
        VehTradeInAppEntry.RESET;
        IF VehTradeInAppEntry.FINDLAST THEN
            EntryNo := VehTradeInAppEntry."Entry No."
        ELSE
            EntryNo := 0;
        EntryNo += 1;

        VehTradeInAppEntry.INIT;
        VehTradeInAppEntry."Entry No." := EntryNo;
        VehTradeInAppEntry."Entry Type" := VehTradeInAppEntry."Entry Type"::Sale;
        IF DocumentType = 1 THEN BEGIN
            IF SalesInvHdr.GET(DocumentNo) THEN
                IF SalesInvLine.GET(DocumentNo, DocumentLine) THEN;
            VehTradeInAppEntry."Posting Date" := SalesInvHdr."Posting Date";
            VehTradeInAppEntry."Document Type" := VehTradeInAppEntry."Document Type"::Invoice;
            VehTradeInAppEntry."Document No." := DocumentNo;
            IF SalesInvHdr."Currency Code" <> '' THEN
                VehTradeInAppEntry."Amount (LCY)" := ROUND(SalesInvLine.Amount / SalesInvHdr."Currency Factor", 0.01)
            ELSE
                VehTradeInAppEntry."Amount (LCY)" := SalesInvLine.Amount;
            VehTradeInAppEntry."Amount (FCY)" := SalesInvLine.Amount;
            VehTradeInAppEntry."Currency Code" := SalesInvHdr."Currency Code";
            VehTradeInAppEntry."Vehicle Serial No." := SalesInvLine."Vehicle Serial No.";
            VehTradeInAppEntry."Vehicle Accounting Cycle No." := SalesInvLine."Vehicle Accounting Cycle No.";
            VehTradeInAppEntry."Applies-to Vehicle Serial No." := SalesInvLine."Applies-to Veh. Serial No.";
            VehTradeInAppEntry."Applies-to Veh. Acc. Cycle No." := SalesInvLine."Applies-to Veh. Cycle No.";
        END
        ELSE BEGIN
            IF SalesCrMemoHdr.GET(DocumentNo) THEN
                IF SalesCrMemoLine.GET(DocumentNo, DocumentLine) THEN;
            VehTradeInAppEntry."Posting Date" := SalesCrMemoHdr."Posting Date";
            VehTradeInAppEntry."Document Type" := VehTradeInAppEntry."Document Type"::"Cr.Memo";
            VehTradeInAppEntry."Document No." := DocumentNo;
            IF SalesCrMemoHdr."Currency Code" <> '' THEN
                VehTradeInAppEntry."Amount (LCY)" := -ROUND(SalesCrMemoLine.Amount / SalesCrMemoHdr."Currency Factor", 0.01)
            ELSE
                VehTradeInAppEntry."Amount (LCY)" := -SalesCrMemoLine.Amount;
            VehTradeInAppEntry."Amount (FCY)" := -SalesCrMemoLine.Amount;
            VehTradeInAppEntry."Currency Code" := SalesCrMemoHdr."Currency Code";
            VehTradeInAppEntry."Vehicle Serial No." := SalesCrMemoLine."Vehicle Serial No.";
            VehTradeInAppEntry."Vehicle Accounting Cycle No." := SalesCrMemoLine."Vehicle Accounting Cycle No.";
            VehTradeInAppEntry."Applies-to Vehicle Serial No." := SalesCrMemoLine."Applies-to Veh. Serial No.";
            VehTradeInAppEntry."Applies-to Veh. Acc. Cycle No." := SalesCrMemoLine."Applies-to Veh. Cycle No.";
        END;
        VehTradeInAppEntry.INSERT;
    end;

    [Scope('Internal')]
    procedure ApplyTradeIn(var SalesLine: Record "37")
    var
        VehTradeInApp: Record "25006391";
        TradeInType: Option TradeIn,Interdepartament;
        TradeInAmount: Decimal;
        InterdepartAmount: Decimal;
        VehTradeIn: Page "25006457";
        VehTradeInAppPurchase: Page "25006458";
    begin
        CLEAR(VehTradeIn);
        VehTradeIn.LOOKUPMODE(TRUE);
        IF VehTradeIn.RUNMODAL = ACTION::LookupOK THEN BEGIN
            VehTradeIn.GETRECORD(VehTradeInApp);
            VehTradeInAppPurchase.SetVariables(VehTradeInApp, SalesLine);
            IF VehTradeInAppPurchase.RUNMODAL = ACTION::OK THEN BEGIN
                TradeInAmount := VehTradeInAppPurchase.GetTradeInAmount;
                IF TradeInAmount <> 0 THEN
                    InsertSalesLine(SalesLine, VehTradeInApp, TradeInAmount, TradeInType::TradeIn);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure InsertSalesLine(SalesLine: Record "37"; VehTradeInApp: Record "25006391"; TradeInAmount: Decimal; TradeInType: Option TradeIn,Interdepartement)
    var
        SalesLine2: Record "37";
        SalesHdr: Record "36";
        SalesSetup: Record "311";
        Currency: Record "4";
        Vehicle: Record "25006005";
        Item: Record "27";
        SalesAmount: Decimal;
        LineNo: Integer;
    begin
        SalesSetup.GET;
        IF SalesHdr.GET(SalesLine."Document Type", SalesLine."Document No.") THEN;  //19.07.2013 EDMS P8
        IF SalesHdr."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
        ELSE
            Currency.GET(SalesHdr."Currency Code");


        IF SalesHdr."Currency Code" <> '' THEN
            SalesAmount := TradeInAmount * SalesHdr."Currency Factor"
        ELSE
            SalesAmount := TradeInAmount;

        IF SalesHdr."Prices Including VAT" THEN BEGIN
            SalesAmount := ROUND(SalesAmount * (1 + (SalesLine."VAT %" / 100)),
              Currency."Unit-Amount Rounding Precision");
        END;

        SalesLine2.RESET;
        SalesLine2.SETRANGE("Document Type", SalesLine."Document Type");
        SalesLine2.SETRANGE("Document No.", SalesLine."Document No.");
        SalesLine2.FINDLAST;
        LineNo := SalesLine2."Line No." + 10000;

        SalesLine2.INIT;
        SalesLine2.VALIDATE("Document Type", SalesLine."Document Type");
        SalesLine2.VALIDATE("Document No.", SalesLine."Document No.");
        SalesLine2.VALIDATE("Line No.", LineNo);
        SalesLine2.INSERT;
        SalesLine2.Type := SalesLine2.Type::"G/L Account";
        SalesLine2."Line Type" := SalesLine2."Line Type"::"G/L Account";
        IF TradeInType = TradeInType::TradeIn THEN BEGIN
            SalesLine2."No." := SalesSetup."Trade-In Sales Account No.";
            SalesLine2."Vehicle Trade-In Line" := TRUE;
        END;

        SalesLine2.VALIDATE(Description, SalesLine.Description);
        SalesLine2.VALIDATE("Location Code", SalesLine."Location Code");
        SalesLine2.VALIDATE("VAT Prod. Posting Group", SalesLine."VAT Prod. Posting Group");
        SalesLine2.VALIDATE("VAT Bus. Posting Group", SalesLine."VAT Bus. Posting Group");
        SalesLine2.VALIDATE("Gen. Prod. Posting Group", SalesLine."Gen. Prod. Posting Group");
        SalesLine2.VALIDATE("Gen. Bus. Posting Group", SalesLine."Gen. Bus. Posting Group");
        SalesLine2.VALIDATE(Quantity, -1);
        SalesLine2.VALIDATE("Unit Price", SalesAmount);

        Vehicle.GET(VehTradeInApp."Vehicle Serial No.");
        SalesLine2.VALIDATE("Make Code", Vehicle."Make Code");
        SalesLine2.VALIDATE("Model Code", Vehicle."Model Code");
        SalesLine2.VALIDATE("Model Version No.", Vehicle."Model Version No.");
        SalesLine2.VALIDATE("Vehicle Serial No.", VehTradeInApp."Vehicle Serial No.");
        SalesLine2.VALIDATE("Vehicle Status Code", Vehicle."Status Code");
        SalesLine2.VALIDATE("Vehicle Accounting Cycle No.", VehTradeInApp."Vehicle Accounting Cycle No.");
        IF Item.GET(Vehicle."Model Version No.") THEN
            SalesLine2.VALIDATE(Description, Item.Description);

        SalesLine2.VALIDATE("Vehicle Assembly ID", SalesLine."Vehicle Assembly ID");
        SalesLine2."Applies-to Veh. Serial No." := VehTradeInApp."Vehicle Serial No.";
        SalesLine2."Applies-to Veh. Cycle No." := VehTradeInApp."Vehicle Accounting Cycle No.";
        SalesLine2.MODIFY;
    end;
}


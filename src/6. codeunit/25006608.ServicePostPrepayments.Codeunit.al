codeunit 25006608 "Service-Post Prepayments"
{
    // 27.02.2013 EDMS P8
    //   * Implement new dimension set
    // 
    // 13.02.2013 EDMS P8
    //   * Add use of GetInvCount. Use of fields *" Run 1", Resources
    //   * Same Variables in name has BT - means Bill-To
    // 
    // 08.04.2008. EDMS P2
    //   * Added new functions for statistics
    //              UpdatePrepmtAmountOnServLines
    //              SumPrepmt
    // 
    // 08.11.2007 P3
    //   * Code - to assign default CM PVN posting grp. if it is set up
    // 
    // 05-09-2007 EDMS P3
    //   * Added code to hold correction status in posted prepayments
    // 
    // 13.07.2007. EDMS M.Kumerdanks
    //   * Added function
    //      GetServiceLines

    Permissions = TableData 112 = rim,
                  TableData 113 = rim,
                  TableData 114 = rim,
                  TableData 115 = rim;

    trigger OnRun()
    begin
    end;

    var
        DimBufMgt: Codeunit "411";
        GenJnlPostLine: Codeunit "12";
        GenPostingSetup: Record "252";
        Text000: Label 'is not within your range of allowed posting dates';
        Text001: Label 'There is nothing to post.';
        Text020: Label 'There prepayment part of Sell-To is bigger than amount of total document split.';
        Text002: Label 'Posting Prepayment Lines   #2######\';
        Text003: Label '%1 %2 -> Invoice %3';
        Text004: Label 'Posting purchases and VAT  #3######\';
        Text005: Label 'Posting to vendors         #4######\';
        Text006: Label 'Posting to bal. account    #5######';
        Text007: Label 'The combination of dimensions used in %1 %2 is blocked. %3';
        Text008: Label 'The combination of dimensions used in %1 %2, line no. %3 is blocked. %4';
        Text009: Label 'The dimensions used in %1 %2 are invalid. %3';
        Text010: Label 'The dimensions used in %1 %2, line no. %3 are invalid. %4';
        Text011: Label '%1 %2 -> Credit Memo %3';
        Text012: Label 'Prepayment %1, %2 %3.';
        Text013: Label 'It is not possible to assign a prepayment amount of %1 to the purchase lines.';
        Text014: Label 'VAT Amount';
        Text015: Label '%1% VAT';
        Text016: Label 'The new prepayment amount must be between %1 and %2.';
        Text017: Label 'At least one line must have %1 > 0 to distribute prepayment amount.';
        Text018: Label 'must be positive when %1 is not 0';
        Text019: Label 'Invoice,Credit Memo';
        EDMSSetup: Record "25006050";
        DocumentTypeGlobal: Option Invoice,"Credit Memo";

    [Scope('Internal')]
    procedure Invoice(var ServHeader: Record "25006145")
    begin
        Code(ServHeader, 0);
    end;

    [Scope('Internal')]
    procedure CreditMemo(var ServHeader: Record "25006145")
    begin
        Code(ServHeader, 1);
    end;

    local procedure "Code"(var ServHeader2: Record "25006145"; DocumentType: Option Invoice,"Credit Memo")
    var
        ServiceSetup: Record "25006120";
        SourceCodeSetup: Record "242";
        PaymentTerms: Record "3";
        Cust: Record "18";
        ServHeader: Record "25006145";
        ServLine: Record "25006146";
        SalesInvHeader: Record "112";
        SalesInvHeaderBT: Record "112";
        SalesCrMemoHeader: Record "114";
        SalesCrMemoHeaderBT: Record "114";
        SalesInvLine: Record "113";
        SalesCrMemoLine: Record "115";
        PrepmtInvBuffer: Record "461" temporary;
        PrepmtInvBufferST: Record "461" temporary;
        TotalPrepmtInvLineBuffer: Record "461";
        TotalPrepmtInvLineBufferLCY: Record "461";
        GenJnlLine: Record "81";
        TempVATAmountLine: Record "290" temporary;
        TempDimBuf: Record "360" temporary;
        CustLedgEntry: Record "21";
        GenJnlCheckLine: Codeunit "11";
        NoSeriesMgt: Codeunit "396";
        DimMgt: Codeunit "408";
        Window: Dialog;
        GenJnlLineDocNo: Code[20];
        GenJnlLineDocNoBT: Code[20];
        GenJnlLineExtDocNo: Code[20];
        SrcCode: Code[10];
        PostingDescription: Text[50];
        GenJnlLineDocType: Integer;
        PrevLineNo: Integer;
        LineCount: Integer;
        LineNo: Integer;
        DocRef: RecordRef;
        SalesSetup: Record "311";
        BillTo: Code[20];
        CompressPrepayment: Boolean;
    begin
        ServHeader := ServHeader2;
        ServHeader.TESTFIELD("Document Type", ServHeader."Document Type"::Order);
        ServHeader.TESTFIELD("Sell-to Customer No.");
        ServHeader.TESTFIELD("Bill-to Customer No.");
        ServHeader.TESTFIELD("Posting Date");
        ServHeader.TESTFIELD("Document Date");
        IF GenJnlCheckLine.DateNotAllowed(ServHeader."Posting Date") THEN
            ServHeader.FIELDERROR("Posting Date", Text000);

        IF NOT CheckOpenPrepaymentLines(ServHeader, DocumentType) THEN
            ERROR(Text001);

        Cust.GET(ServHeader."Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust, PrepmtDocTypeToDocType(ServHeader."Document Type"), FALSE, TRUE);
        IF ServHeader."Bill-to Customer No." <> ServHeader."Sell-to Customer No." THEN BEGIN
            Cust.GET(ServHeader."Bill-to Customer No.");
            Cust.CheckBlockedCustOnDocs(Cust, PrepmtDocTypeToDocType(ServHeader."Document Type"), FALSE, TRUE);
        END;

        // Get Doc. No. and save
        CASE DocumentType OF
            DocumentType::Invoice:
                BEGIN
                    ServHeader.TESTFIELD("Prepayment Due Date");
                    ServHeader.TESTFIELD("Prepmt. Cr. Memo No.", '');
                    IF "Prepayment No." = '' THEN BEGIN
                        ServHeader.TESTFIELD("Prepayment No. Series");
                        "Prepayment No." :=
                          NoSeriesMgt.GetNextNo("Prepayment No. Series", ServHeader."Posting Date", TRUE);
                        ServHeader.MODIFY;
                        COMMIT;
                    END;
                    GenJnlLineDocNo := "Prepayment No.";
                END;
            DocumentType::"Credit Memo":
                BEGIN
                    ServHeader.TESTFIELD("Prepayment No.", '');
                    IF "Prepmt. Cr. Memo No." = '' THEN BEGIN
                        ServHeader.TESTFIELD("Prepmt. Cr. Memo No. Series");
                        "Prepmt. Cr. Memo No." :=
                          NoSeriesMgt.GetNextNo("Prepmt. Cr. Memo No. Series", ServHeader."Posting Date", TRUE);
                        ServHeader.MODIFY;
                        COMMIT;
                    END;
                    GenJnlLineDocNo := "Prepmt. Cr. Memo No.";
                END;
        END;

        Window.OPEN(
          '#1#################################\\' +
          Text002 +
          Text004 +
          Text005 +
          Text006);
        Window.UPDATE(1, STRSUBSTNO('%1 %2', SELECTSTR(1 + DocumentType, Text019), ServHeader."No."));

        ServiceSetup.GET;
        SourceCodeSetup.GET;
        EDMSSetup.GET("Make Code");  //EDMS P1
        SrcCode := SourceCodeSetup."Service Management EDMS";
        IF "Prepmt. Posting Description" <> '' THEN
            PostingDescription := "Prepmt. Posting Description"
        ELSE
            PostingDescription :=
              COPYSTR(
                STRSUBSTNO(Text012, SELECTSTR(1 + DocumentType, Text019), ServHeader."Document Type", ServHeader."No."),
                1, MAXSTRLEN(ServHeader."Posting Description"));

        // Create posted header
        IF ServiceSetup."Ext. Doc. No. Mandatory" THEN
            ServHeader.TESTFIELD("External Document No.");
        CASE DocumentType OF
            DocumentType::Invoice:
                BEGIN
                    //Creates Sales Headers
                    GenJnlLineDocType := GenJnlLine."Document Type"::Invoice;
                    CreateSalesHeader(ServHeader, SalesInvHeader, PostingDescription, GenJnlLineDocNo, SrcCode,
                      ServHeader."Bill-to Customer No.");
                    Window.UPDATE(1, STRSUBSTNO(Text003, ServHeader."Document Type", ServHeader."No.", SalesInvHeader."No."));
                END;
            DocumentType::"Credit Memo":
                BEGIN
                    //Creates Sales Headers
                    GenJnlLineDocType := GenJnlLine."Document Type"::"Credit Memo";
                    CreateCrMemoHeader(ServHeader, SalesCrMemoHeader, PostingDescription, GenJnlLineDocNo, SrcCode,
                      ServHeader."Bill-to Customer No.");
                    Window.UPDATE(1, STRSUBSTNO(Text003, ServHeader."Document Type", ServHeader."No.", SalesCrMemoHeader."No."));
                END;
        END;

        GenJnlLineExtDocNo := "External Document No.";

        // Create Lines
        PrepmtInvBuffer.DELETEALL;
        CalcVATAmountLines(ServHeader, ServLine, TempVATAmountLine, DocumentType);
        UpdateVATOnLines(ServHeader, ServLine, TempVATAmountLine, DocumentType);
        CompressPrepayment := "Compress Prepayment";
        "Compress Prepayment" := FALSE;
        BuildInvLineBuffer(
          ServHeader, ServLine, DocumentType, PrepmtInvBuffer, SalesSetup."Invoice Rounding");

        CopyBufferToBuffer(PrepmtInvBuffer, PrepmtInvBufferST, TRUE);

        "Compress Prepayment" := CompressPrepayment;
        IF "Compress Prepayment" THEN BEGIN
            CompressInvLineBuffer(ServHeader, PrepmtInvBuffer);
        END;
        IF PrepmtInvBuffer.FINDFIRST THEN BEGIN
            TempDimBuf.INIT;
            REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(2, LineCount);
                IF PrepmtInvBuffer."Line No." <> 0 THEN
                    LineNo := LineNo + PrepmtInvBuffer."Line No."
                ELSE
                    LineNo := LineNo + 10000;
                TempDimBuf.RESET;
                TempDimBuf.DELETEALL;
                CASE DocumentType OF
                    DocumentType::Invoice:
                        BEGIN
                            CreateSalesLine(ServHeader, SalesInvHeader, PrepmtInvBuffer, SalesInvLine, TempDimBuf, LineNo, 100);
                        END;
                    DocumentType::"Credit Memo":
                        BEGIN
                            CreateCrMemoLine(ServHeader, SalesCrMemoHeader, PrepmtInvBuffer, SalesCrMemoLine, TempDimBuf, LineNo, 100);
                        END;
                END;
            UNTIL PrepmtInvBuffer.NEXT = 0;
        END;

        // G/L Posting
        LineCount := 0;
        CompressInvLineBuffer(ServHeader, PrepmtInvBuffer);

        TotalPrepmtInvLineBuffer.INIT;
        TotalPrepmtInvLineBufferLCY.INIT;
        IF PrepmtInvBuffer.FINDLAST THEN BEGIN
            REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(3, LineCount);

                IF DocumentType = DocumentType::Invoice THEN
                    ReverseAmounts(PrepmtInvBuffer);
                RoundAmounts(ServHeader, PrepmtInvBuffer, TotalPrepmtInvLineBuffer, TotalPrepmtInvLineBufferLCY);
                CreateGenJnlLine(ServHeader, PrepmtInvBuffer, GenJnlLine, PostingDescription, GenJnlLineDocType,
                  GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, BillTo);
            UNTIL PrepmtInvBuffer.NEXT(-1) = 0;
        END;
        LineCount := 0;

        // Post customer entry
        Window.UPDATE(4, 1);
        IF TotalPrepmtInvLineBuffer.Amount <> 0 THEN BEGIN
            CreateGenJnlLineCustomer(ServHeader, TotalPrepmtInvLineBuffer, TotalPrepmtInvLineBufferLCY,
              GenJnlLine, PostingDescription, GenJnlLineDocType,
              GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, ServHeader."Bill-to Customer No.", ServHeader."Bill-to Customer No.");
        END;

        // Balancing account
        IF "Bal. Account No." <> '' THEN BEGIN
            Window.UPDATE(5, 1);
            CustLedgEntry.FINDLAST;
            IF TotalPrepmtInvLineBuffer.Amount <> 0 THEN
                CreateGenJnlLineBalanc(ServHeader, TotalPrepmtInvLineBuffer, TotalPrepmtInvLineBufferLCY,
                  GenJnlLine, CustLedgEntry, PostingDescription, GenJnlLineDocType,
                  GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode, ServHeader."Bill-to Customer No.", ServHeader."Bill-to Customer No.");
        END;

        // Update lines & header
        PrepmtInvBufferST.RESET;
        ServLine.RESET;
        ServLine.SETRANGE("Document Type", ServHeader."Document Type");
        ServLine.SETRANGE("Document No.", ServHeader."No.");
        IF DocumentType = DocumentType::Invoice THEN BEGIN
            "Last Prepayment No." := GenJnlLineDocNo;
            "Prepayment No." := '';
            ServLine.SETFILTER("Prepmt. Line Amount", '<>0');
            IF ServLine.FINDSET THEN BEGIN
                REPEAT
                    IF ServLine."Prepmt. Line Amount" <> ServLine."Prepmt. Amt. Inv." THEN BEGIN
                        ServLine."Prepmt. Amt. Inv." := ServLine."Prepmt. Line Amount";
                        ServLine."Prepmt. Amt. Incl. VAT" += ServLine."Prepayment Amount Incl. VAT";  //13.03.2013 EDMS P8
                        ServLine."Prepmt Amt to Deduct" :=
                          ServLine."Prepmt. Amt. Inv." - ServLine."Prepmt Amt Deducted";
                        PrepmtInvBufferST.SETRANGE("Line No.", ServLine."Line No.");
                        ServLine.MODIFY;
                    END;
                UNTIL ServLine.NEXT = 0;
            END;
        END ELSE BEGIN
            "Last Prepmt. Cr. Memo No." := GenJnlLineDocNo;
            "Prepmt. Cr. Memo No." := '';
            ServLine.SETFILTER("Prepmt. Amt. Inv.", '<>0');
            IF ServLine.FINDSET(TRUE, FALSE) THEN
                REPEAT
                    ServLine."Prepmt. Amt. Inv." := ServLine."Prepmt Amt Deducted";
                    ServLine."Prepmt Amt to Deduct" := 0;
                    ServLine.MODIFY;
                UNTIL ServLine.NEXT = 0;
        END;
        IF ServHeader.Status <> ServHeader.Status::"Pending Prepayment" THEN
            ServHeader.Status := ServHeader.Status::"Pending Prepayment";
        ServHeader.MODIFY;

        ServHeader2 := ServHeader;
    end;

    [Scope('Internal')]
    procedure CheckOpenPrepaymentLines(ServHeader: Record "25006145"; DocumentType: Option Invoice,"Credit Memo"): Boolean
    var
        ServLine: Record "25006146";
    begin
        ApplyFilter(ServHeader, DocumentType, ServLine);
        IF ServLine.FINDSET THEN BEGIN
            REPEAT
                IF PrepmtAmount(ServLine, DocumentType) <> 0 THEN
                    EXIT(TRUE);
            UNTIL ServLine.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure CreateSalesHeader(ServiceHeaderPar: Record "25006145"; var SalesInvHeaderPar: Record "112"; PostingDescription: Text[50]; GenJnlLineDocNo: Code[20]; SrcCode: Code[10]; BillTo: Code[20])
    var
        SalesHeaderLoc: Record "36";
        DocRef: RecordRef;
        DimMgt: Codeunit "408";
        PostedDocTabNo: Integer;
    begin
        SalesInvHeaderPar.INIT;
        DocRef.GETTABLE(SalesInvHeaderPar);
        TransferServDoc(DocRef, ServiceHeaderPar, 0);
        DocRef.SETTABLE(SalesInvHeaderPar);
        SalesInvHeaderPar."Posting Description" := PostingDescription;
        SalesInvHeaderPar."Payment Terms Code" := ServiceHeaderPar."Prepmt. Payment Terms Code";
        SalesInvHeaderPar."Due Date" := ServiceHeaderPar."Prepayment Due Date";
        SalesInvHeaderPar."Pmt. Discount Date" := ServiceHeaderPar."Prepmt. Pmt. Discount Date";
        SalesInvHeaderPar."Payment Discount %" := ServiceHeaderPar."Prepmt. Payment Discount %";
        SalesInvHeaderPar."No." := GenJnlLineDocNo;
        SalesInvHeaderPar."Pre-Assigned No. Series" := '';
        SalesInvHeaderPar."Source Code" := SrcCode;
        SalesInvHeaderPar."User ID" := USERID;
        SalesInvHeaderPar."No. Printed" := 0;
        SalesInvHeaderPar."Prepayment Invoice" := TRUE;
        SalesInvHeaderPar."Prepayment Order No." := ServiceHeaderPar."No.";
        SalesInvHeaderPar."Order Date" := ServiceHeaderPar."Order Date";
        SalesInvHeaderPar."Document Profile" := SalesInvHeaderPar."Document Profile"::Service;
        SalesInvHeaderPar.Resources := COPYSTR(ServiceHeaderPar.GetResourceTextFieldValue, 1, 100);

        SalesInvHeaderPar.INSERT;
        SalesInvHeaderPar.VALIDATE("Sell-to Customer No.", ServiceHeaderPar."Sell-to Customer No.");
        IF NOT (SalesInvHeaderPar."Sell-to Contact No." = ServiceHeaderPar."Sell-to Contact No.") THEN
            SalesInvHeaderPar.VALIDATE("Sell-to Contact No.", ServiceHeaderPar."Sell-to Contact No.");
        IF BillTo <> SalesInvHeaderPar."Bill-to Customer No." THEN BEGIN
            SalesInvHeaderPar.VALIDATE("Bill-to Customer No.", BillTo);
        END;
        SalesHeaderLoc.INIT;
        SalesHeaderLoc."Bill-to Customer No." := BillTo;
        SalesHeaderLoc.UpdateBillToCont(SalesHeaderLoc."Bill-to Customer No.");
        IF SalesInvHeaderPar."Bill-to Contact No." <> SalesHeaderLoc."Bill-to Contact No." THEN
            SalesInvHeaderPar.VALIDATE("Bill-to Contact No.", SalesHeaderLoc."Bill-to Contact No.");
        SalesInvHeaderPar.MODIFY;
        PostedDocTabNo := DATABASE::"Sales Invoice Header";
    end;

    [Scope('Internal')]
    procedure CreateSalesLine(ServiceHeaderPar: Record "25006145"; SalesInvHeaderPar: Record "112"; PrepmtInvBufferPar: Record "461" temporary; var SalesInvLinePar: Record "113"; var TempDimBuf: Record "360" temporary; LineNo: Integer; decPart: Decimal)
    var
        DocRef: RecordRef;
        DimMgt: Codeunit "408";
        PostedDocTabNo: Integer;
    begin
        SalesInvLinePar.INIT;
        SalesInvLinePar."Document No." := SalesInvHeaderPar."No.";
        SalesInvLinePar.TESTFIELD("Document No.");
        SalesInvLinePar."Line No." := LineNo;
        SalesInvLinePar."Sell-to Customer No." := SalesInvHeaderPar."Sell-to Customer No.";
        SalesInvLinePar."Bill-to Customer No." := SalesInvHeaderPar."Bill-to Customer No.";
        SalesInvLinePar.Type := SalesInvLinePar.Type::"G/L Account";
        SalesInvLinePar."No." := PrepmtInvBufferPar."G/L Account No.";
        SalesInvLinePar."Shortcut Dimension 1 Code" := PrepmtInvBufferPar."Global Dimension 1 Code";
        SalesInvLinePar."Shortcut Dimension 2 Code" := PrepmtInvBufferPar."Global Dimension 2 Code";

        SalesInvLinePar."Shipment Date" := SalesInvHeaderPar."Posting Date";
        SalesInvLinePar.VIN := SalesInvHeaderPar.VIN;
        SalesInvLinePar."Model Version No." := SalesInvHeaderPar."Model Version No.";
        SalesInvLinePar."Vehicle Serial No." := SalesInvHeaderPar."Vehicle Serial No.";
        SalesInvLinePar."Vehicle Accounting Cycle No." := SalesInvHeaderPar."Vehicle Accounting Cycle No.";
        SalesInvLinePar.Description := PrepmtInvBufferPar.Description;
        SalesInvLinePar.Quantity := 1;
        IF ServiceHeaderPar."Prices Including VAT" THEN BEGIN
            SalesInvLinePar."Unit Price" := PrepmtInvBufferPar."Amount Incl. VAT";
            SalesInvLinePar."Line Amount" := PrepmtInvBufferPar."Amount Incl. VAT" * decPart / 100;
        END ELSE BEGIN
            SalesInvLinePar."Unit Price" := PrepmtInvBufferPar.Amount;
            SalesInvLinePar."Line Amount" := PrepmtInvBufferPar.Amount * decPart / 100;
        END;
        SalesInvLinePar."Gen. Bus. Posting Group" := PrepmtInvBufferPar."Gen. Bus. Posting Group";
        SalesInvLinePar."Gen. Prod. Posting Group" := PrepmtInvBufferPar."Gen. Prod. Posting Group";
        SalesInvLinePar."VAT Bus. Posting Group" := PrepmtInvBufferPar."VAT Bus. Posting Group";
        SalesInvLinePar."VAT Prod. Posting Group" := PrepmtInvBufferPar."VAT Prod. Posting Group";
        SalesInvLinePar."VAT %" := PrepmtInvBufferPar."VAT %";
        SalesInvLinePar.Amount := PrepmtInvBufferPar.Amount * decPart / 100;
        SalesInvLinePar."Amount Including VAT" := PrepmtInvBufferPar."Amount Incl. VAT" * decPart / 100;
        SalesInvLinePar."VAT Calculation Type" := PrepmtInvBufferPar."VAT Calculation Type";
        SalesInvLinePar."VAT Base Amount" := PrepmtInvBufferPar."VAT Base Amount" * decPart / 100;
        SalesInvLinePar."VAT Identifier" := PrepmtInvBufferPar."VAT Identifier";
        SalesInvLinePar."Document Profile" := SalesInvLinePar."Document Profile"::Service;
        SalesInvLinePar.INSERT;
        PostedDocTabNo := DATABASE::"Sales Invoice Line";
        InsertExtendedText(
          PostedDocTabNo, SalesInvLinePar."Document No.", PrepmtInvBufferPar."G/L Account No.",
            ServiceHeaderPar."Document Date", ServiceHeaderPar."Language Code", LineNo);
    end;

    [Scope('Internal')]
    procedure CreateCrMemoHeader(ServiceHeaderPar: Record "25006145"; var SalesCrMemoHeaderPar: Record "114"; PostingDescription: Text[50]; GenJnlLineDocNo: Code[20]; SrcCode: Code[10]; BillTo: Code[20])
    var
        SalesHeaderLoc: Record "36";
        PaymentTerms: Record "3";
        DocRef: RecordRef;
    begin
        SalesCrMemoHeaderPar.INIT;
        DocRef.GETTABLE(SalesCrMemoHeaderPar);
        TransferServDoc(DocRef, ServiceHeaderPar, 1);
        DocRef.SETTABLE(SalesCrMemoHeaderPar);
        SalesCrMemoHeaderPar."Payment Terms Code" := ServiceHeaderPar."Prepmt. Payment Terms Code";
        SalesCrMemoHeaderPar."Pmt. Discount Date" := ServiceHeaderPar."Prepmt. Pmt. Discount Date";
        SalesCrMemoHeaderPar."Payment Discount %" := ServiceHeaderPar."Prepmt. Payment Discount %";
        IF ServiceHeaderPar."Prepmt. Payment Terms Code" <> '' THEN BEGIN
            PaymentTerms.GET(ServiceHeaderPar."Prepmt. Payment Terms Code");
            IF NOT PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN BEGIN
                SalesCrMemoHeaderPar."Payment Discount %" := 0;
                SalesCrMemoHeaderPar."Pmt. Discount Date" := 0D;
            END;
        END;
        SalesCrMemoHeaderPar."Posting Description" := PostingDescription;
        SalesCrMemoHeaderPar."Due Date" := ServiceHeaderPar."Prepayment Due Date";
        SalesCrMemoHeaderPar."No." := GenJnlLineDocNo;
        SalesCrMemoHeaderPar."Pre-Assigned No. Series" := '';
        SalesCrMemoHeaderPar."Source Code" := SrcCode;
        SalesCrMemoHeaderPar."User ID" := USERID;
        SalesCrMemoHeaderPar."No. Printed" := 0;
        SalesCrMemoHeaderPar."Prepayment Credit Memo" := TRUE;
        SalesCrMemoHeaderPar."Prepayment Order No." := ServiceHeaderPar."No.";
        SalesCrMemoHeaderPar.Correction := SalesCrMemoHeaderPar.Correction;  //05-09-2007 EDMS P3
        SalesCrMemoHeaderPar."Document Profile" := SalesCrMemoHeaderPar."Document Profile"::Service;
        SalesCrMemoHeaderPar.INSERT;
        SalesCrMemoHeaderPar.VALIDATE("Sell-to Customer No.", ServiceHeaderPar."Sell-to Customer No.");
        IF NOT (SalesCrMemoHeaderPar."Sell-to Contact No." = ServiceHeaderPar."Sell-to Contact No.") THEN
            SalesCrMemoHeaderPar.VALIDATE("Sell-to Contact No.", ServiceHeaderPar."Sell-to Contact No.");
        IF BillTo <> SalesCrMemoHeaderPar."Bill-to Customer No." THEN
            SalesCrMemoHeaderPar.VALIDATE("Bill-to Customer No.", BillTo);
        SalesHeaderLoc.INIT;
        SalesHeaderLoc."Bill-to Customer No." := BillTo;
        SalesHeaderLoc.UpdateBillToCont(SalesHeaderLoc."Bill-to Customer No.");
        IF SalesCrMemoHeaderPar."Bill-to Contact No." <> SalesHeaderLoc."Bill-to Contact No." THEN
            SalesCrMemoHeaderPar.VALIDATE("Bill-to Contact No.", SalesHeaderLoc."Bill-to Contact No.");
        SalesCrMemoHeaderPar.MODIFY;
    end;

    [Scope('Internal')]
    procedure CreateCrMemoLine(ServiceHeaderPar: Record "25006145"; SalesCrMemoHeaderPar: Record "114"; PrepmtInvBufferPar: Record "461" temporary; var SalesCrMemoLinePar: Record "115"; var TempDimBuf: Record "360" temporary; LineNo: Integer; decPart: Decimal)
    var
        DocRef: RecordRef;
        DimMgt: Codeunit "408";
        PostedDocTabNo: Integer;
    begin
        SalesCrMemoLinePar.INIT;
        SalesCrMemoLinePar."Document No." := SalesCrMemoHeaderPar."No.";
        SalesCrMemoLinePar."Line No." := LineNo;
        SalesCrMemoLinePar."Sell-to Customer No." := SalesCrMemoHeaderPar."Sell-to Customer No.";
        SalesCrMemoLinePar."Bill-to Customer No." := SalesCrMemoHeaderPar."Bill-to Customer No.";
        SalesCrMemoLinePar.Type := SalesCrMemoLinePar.Type::"G/L Account";
        SalesCrMemoLinePar."No." := PrepmtInvBufferPar."G/L Account No.";
        SalesCrMemoLinePar."Shortcut Dimension 1 Code" := PrepmtInvBufferPar."Global Dimension 1 Code";
        SalesCrMemoLinePar."Shortcut Dimension 2 Code" := PrepmtInvBufferPar."Global Dimension 2 Code";
        SalesCrMemoLinePar.Description := PrepmtInvBufferPar.Description;
        SalesCrMemoLinePar.Quantity := 1;
        IF ServiceHeaderPar."Prices Including VAT" THEN BEGIN
            SalesCrMemoLinePar."Unit Price" := PrepmtInvBufferPar."Amount Incl. VAT";
            SalesCrMemoLinePar."Line Amount" := PrepmtInvBufferPar."Amount Incl. VAT";
        END ELSE BEGIN
            SalesCrMemoLinePar."Unit Price" := PrepmtInvBufferPar.Amount;
            SalesCrMemoLinePar."Line Amount" := PrepmtInvBufferPar.Amount;
        END;
        SalesCrMemoLinePar."Gen. Bus. Posting Group" := PrepmtInvBufferPar."Gen. Bus. Posting Group";
        SalesCrMemoLinePar."Gen. Prod. Posting Group" := PrepmtInvBufferPar."Gen. Prod. Posting Group";
        SalesCrMemoLinePar."VAT Bus. Posting Group" := PrepmtInvBufferPar."VAT Bus. Posting Group";
        SalesCrMemoLinePar."VAT Prod. Posting Group" := PrepmtInvBufferPar."VAT Prod. Posting Group";
        SalesCrMemoLinePar."VAT %" := PrepmtInvBufferPar."VAT %";
        SalesCrMemoLinePar.Amount := PrepmtInvBufferPar.Amount;
        SalesCrMemoLinePar."Amount Including VAT" := PrepmtInvBufferPar."Amount Incl. VAT";
        SalesCrMemoLinePar."VAT Calculation Type" := PrepmtInvBufferPar."VAT Calculation Type";
        SalesCrMemoLinePar."VAT Base Amount" := PrepmtInvBufferPar."VAT Base Amount";
        SalesCrMemoLinePar."VAT Identifier" := PrepmtInvBufferPar."VAT Identifier";
        SalesCrMemoLinePar."Document Profile" := SalesCrMemoLinePar."Document Profile"::Service;
        SalesCrMemoLinePar.INSERT;
        PostedDocTabNo := DATABASE::"Sales Cr.Memo Line";
        InsertExtendedText(
          PostedDocTabNo, SalesCrMemoLinePar."Document No.", PrepmtInvBufferPar."G/L Account No.",
            ServiceHeaderPar."Document Date", ServiceHeaderPar."Language Code", LineNo);
    end;

    [Scope('Internal')]
    procedure CreateGenJnlLine(ServiceHeaderPar: Record "25006145"; PrepmtInvBuffer: Record "461" temporary; var GenJnlLinePar: Record "81"; PostingDescription: Text[50]; GenJnlLineDocType: Integer; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[20]; SrcCode: Code[10]; BillTo: Code[20])
    var
        DocRef: RecordRef;
        DimMgt: Codeunit "408";
        PostedDocTabNo: Integer;
    begin
        GenJnlLinePar.INIT;
        GenJnlLinePar."Posting Date" := ServiceHeaderPar."Posting Date";
        GenJnlLinePar."Document Date" := ServiceHeaderPar."Document Date";
        GenJnlLinePar.Description := PostingDescription;
        GenJnlLinePar."Document Type" := GenJnlLineDocType;
        GenJnlLinePar."Document No." := GenJnlLineDocNo;
        GenJnlLinePar.TESTFIELD("Document No.");
        GenJnlLinePar."External Document No." := GenJnlLineExtDocNo;
        GenJnlLinePar."Account No." := PrepmtInvBuffer."G/L Account No.";
        GenJnlLinePar."System-Created Entry" := TRUE;
        GenJnlLinePar.Amount := PrepmtInvBuffer.Amount;
        GenJnlLinePar."Source Currency Code" := ServiceHeaderPar."Currency Code";
        GenJnlLinePar."Source Currency Amount" := PrepmtInvBuffer."Amount (ACY)";
        GenJnlLinePar.Correction := ServiceHeaderPar.Correction;
        GenJnlLinePar."Gen. Posting Type" := GenJnlLinePar."Gen. Posting Type"::Sale;
        GenJnlLinePar."Gen. Bus. Posting Group" := PrepmtInvBuffer."Gen. Bus. Posting Group";
        GenJnlLinePar."Gen. Prod. Posting Group" := PrepmtInvBuffer."Gen. Prod. Posting Group";
        GenJnlLinePar."VAT Bus. Posting Group" := PrepmtInvBuffer."VAT Bus. Posting Group";
        GenJnlLinePar."VAT Prod. Posting Group" := PrepmtInvBuffer."VAT Prod. Posting Group";
        GenJnlLinePar."Tax Area Code" := PrepmtInvBuffer."Tax Area Code";
        GenJnlLinePar."Tax Liable" := PrepmtInvBuffer."Tax Liable";
        GenJnlLinePar."Tax Group Code" := PrepmtInvBuffer."Tax Group Code";
        GenJnlLinePar."VAT Calculation Type" := PrepmtInvBuffer."VAT Calculation Type";
        GenJnlLinePar."VAT Base Amount" := PrepmtInvBuffer."VAT Base Amount";
        GenJnlLinePar."VAT Base Discount %" := ServiceHeaderPar."VAT Base Discount %";
        GenJnlLinePar."Source Curr. VAT Base Amount" := PrepmtInvBuffer."VAT Base Amount (ACY)";
        GenJnlLinePar."VAT Amount" := PrepmtInvBuffer."VAT Amount";
        GenJnlLinePar."Source Curr. VAT Amount" := PrepmtInvBuffer."VAT Amount (ACY)";
        GenJnlLinePar."VAT Difference" := PrepmtInvBuffer."VAT Difference";
        GenJnlLinePar."VAT Posting" := GenJnlLinePar."VAT Posting"::"Manual VAT Entry";
        GenJnlLinePar."Shortcut Dimension 1 Code" := PrepmtInvBuffer."Global Dimension 1 Code";
        GenJnlLinePar."Shortcut Dimension 2 Code" := PrepmtInvBuffer."Global Dimension 2 Code";
        GenJnlLinePar."Job No." := PrepmtInvBuffer."Job No.";
        GenJnlLinePar."Source Code" := SrcCode;
        GenJnlLinePar."Bill-to/Pay-to No." := BillTo;
        GenJnlLinePar."VAT Registration No." := ServiceHeaderPar."VAT Registration No.";
        GenJnlLinePar."Source Type" := GenJnlLinePar."Source Type"::Customer;
        GenJnlLinePar."Source No." := ServiceHeaderPar."Bill-to Customer No.";
        GenJnlLinePar."Posting No. Series" := ServiceHeaderPar."Posting No. Series";
        VIN := ServiceHeaderPar.VIN;
        "Make Code" := ServiceHeaderPar."Make Code";
        "Model Code" := ServiceHeaderPar."Model Code";
        "Model Version No." := ServiceHeaderPar."Model Version No.";
        "Vehicle Accounting Cycle No." := ServiceHeaderPar."Vehicle Accounting Cycle No.";
        "Vehicle Serial No." := ServiceHeaderPar."Vehicle Serial No.";
        RunGenJnlPostLine(GenJnlLinePar);
    end;

    [Scope('Internal')]
    procedure CreateGenJnlLineCustomer(ServiceHeaderPar: Record "25006145"; PrepmtInvBuffer: Record "461" temporary; PrepmtInvBufferLCY: Record "461" temporary; var GenJnlLinePar: Record "81"; PostingDescription: Text[50]; GenJnlLineDocType: Integer; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[20]; SrcCode: Code[10]; BillTo: Code[20]; AcctNo: Code[20])
    var
        PaymentTerms: Record "3";
        DimMgt: Codeunit "408";
        PostedDocTabNo: Integer;
    begin
        GenJnlLinePar.INIT;
        GenJnlLinePar."Posting Date" := ServiceHeaderPar."Posting Date";
        GenJnlLinePar."Document Date" := ServiceHeaderPar."Document Date";
        GenJnlLinePar.Description := PostingDescription;
        GenJnlLinePar."Shortcut Dimension 1 Code" := ServiceHeaderPar."Shortcut Dimension 1 Code";
        GenJnlLinePar."Shortcut Dimension 2 Code" := ServiceHeaderPar."Shortcut Dimension 2 Code";
        GenJnlLinePar."Account Type" := GenJnlLinePar."Account Type"::Customer;
        GenJnlLinePar."Account No." := AcctNo;
        GenJnlLinePar."Document Type" := GenJnlLineDocType;
        GenJnlLinePar."Document No." := GenJnlLineDocNo;
        GenJnlLinePar.TESTFIELD("Document No.");
        GenJnlLinePar."External Document No." := GenJnlLineExtDocNo;
        GenJnlLinePar."Currency Code" := ServiceHeaderPar."Currency Code";
        GenJnlLinePar.Amount := -PrepmtInvBuffer."Amount Incl. VAT";
        GenJnlLinePar."Source Currency Code" := ServiceHeaderPar."Currency Code";
        GenJnlLinePar."Source Currency Amount" := -PrepmtInvBuffer."Amount Incl. VAT";
        GenJnlLinePar."Amount (LCY)" := -PrepmtInvBufferLCY."Amount Incl. VAT";
        IF ServiceHeaderPar."Currency Code" = '' THEN
            GenJnlLinePar."Currency Factor" := 1
        ELSE
            GenJnlLinePar."Currency Factor" := ServiceHeaderPar."Currency Factor";
        GenJnlLinePar.Correction := ServiceHeaderPar.Correction;
        GenJnlLinePar."Sales/Purch. (LCY)" := -PrepmtInvBufferLCY.Amount;
        GenJnlLinePar."Profit (LCY)" := -PrepmtInvBufferLCY.Amount;
        GenJnlLinePar."Sell-to/Buy-from No." := ServiceHeaderPar."Sell-to Customer No.";
        GenJnlLinePar."Bill-to/Pay-to No." := ServiceHeaderPar."Bill-to Customer No.";
        GenJnlLinePar."Salespers./Purch. Code" := ServiceHeaderPar."Service Person";
        GenJnlLinePar."System-Created Entry" := TRUE;
        GenJnlLinePar."Due Date" := ServiceHeaderPar."Prepayment Due Date";
        GenJnlLinePar."Payment Terms Code" := ServiceHeaderPar."Prepmt. Payment Terms Code";
        IF GenJnlLinePar."Payment Terms Code" <> '' THEN
            PaymentTerms.GET(GenJnlLinePar."Payment Terms Code");
        IF (DocumentTypeGlobal = DocumentTypeGlobal::Invoice) OR
           PaymentTerms."Calc. Pmt. Disc. on Cr. Memos"
        THEN BEGIN
            GenJnlLinePar."Pmt. Discount Date" := ServiceHeaderPar."Prepmt. Pmt. Discount Date";
            GenJnlLinePar."Payment Discount %" := ServiceHeaderPar."Prepmt. Payment Discount %";
        END;
        GenJnlLinePar."Source Type" := GenJnlLinePar."Source Type"::Customer;
        GenJnlLinePar."Source No." := ServiceHeaderPar."Bill-to Customer No.";
        GenJnlLinePar."Source Code" := SrcCode;
        GenJnlLinePar."Posting No. Series" := ServiceHeaderPar."Posting No. Series";
        GenJnlLinePar.Prepayment := TRUE;

        VIN := ServiceHeaderPar.VIN;
        "Make Code" := ServiceHeaderPar."Make Code";
        "Model Code" := ServiceHeaderPar."Model Code";
        "Model Version No." := ServiceHeaderPar."Model Version No.";
        "Vehicle Accounting Cycle No." := ServiceHeaderPar."Vehicle Accounting Cycle No.";
        "Vehicle Serial No." := ServiceHeaderPar."Vehicle Serial No.";
        GenJnlPostLine.RunWithCheck(GenJnlLinePar);
    end;

    [Scope('Internal')]
    procedure CreateGenJnlLineBalanc(ServiceHeaderPar: Record "25006145"; PrepmtInvBuffer: Record "461" temporary; PrepmtInvBufferLCY: Record "461" temporary; var GenJnlLinePar: Record "81"; CustLedgEntry: Record "21"; PostingDescription: Text[50]; GenJnlLineDocType: Integer; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[20]; SrcCode: Code[10]; BillTo: Code[20]; AcctNo: Code[20])
    var
        PaymentTerms: Record "3";
        TempDimBuf: Record "360" temporary;
        DimMgt: Codeunit "408";
        PostedDocTabNo: Integer;
    begin
        GenJnlLinePar.INIT;
        GenJnlLinePar."Posting Date" := ServiceHeaderPar."Posting Date";
        GenJnlLinePar."Document Date" := ServiceHeaderPar."Document Date";
        GenJnlLinePar.Description := PostingDescription;
        GenJnlLinePar."Shortcut Dimension 1 Code" := ServiceHeaderPar."Shortcut Dimension 1 Code";
        GenJnlLinePar."Shortcut Dimension 2 Code" := ServiceHeaderPar."Shortcut Dimension 2 Code";
        GenJnlLinePar."Account Type" := GenJnlLinePar."Account Type"::Customer;
        GenJnlLinePar."Account No." := AcctNo;
        IF GenJnlLineDocType = GenJnlLinePar."Document Type"::"Credit Memo" THEN
            GenJnlLinePar."Document Type" := GenJnlLinePar."Document Type"::Refund
        ELSE
            GenJnlLinePar."Document Type" := GenJnlLinePar."Document Type"::Payment;
        GenJnlLinePar."Document No." := GenJnlLineDocNo;
        GenJnlLinePar.TESTFIELD("Document No.");
        GenJnlLinePar."External Document No." := GenJnlLineExtDocNo;
        IF ServiceHeaderPar."Bal. Account Type" = ServiceHeaderPar."Bal. Account Type"::"Bank Account" THEN
            GenJnlLinePar."Bal. Account Type" := GenJnlLinePar."Bal. Account Type"::"Bank Account";
        GenJnlLinePar."Bal. Account No." := ServiceHeaderPar."Bal. Account No.";
        GenJnlLinePar."Currency Code" := ServiceHeaderPar."Currency Code";
        GenJnlLinePar.Amount :=
            PrepmtInvBuffer."Amount Incl. VAT" + CustLedgEntry."Remaining Pmt. Disc. Possible";
        GenJnlLinePar."Source Currency Code" := ServiceHeaderPar."Currency Code";
        GenJnlLinePar."Source Currency Amount" := GenJnlLinePar.Amount;
        CustLedgEntry.CALCFIELDS(Amount);
        IF CustLedgEntry.Amount = 0 THEN
            GenJnlLinePar."Amount (LCY)" := PrepmtInvBufferLCY.Amount
        ELSE
            GenJnlLinePar."Amount (LCY)" :=
              PrepmtInvBufferLCY.Amount +
              ROUND(
                CustLedgEntry."Remaining Pmt. Disc. Possible" / CustLedgEntry."Adjusted Currency Factor");
        IF ServiceHeaderPar."Currency Code" = '' THEN
            GenJnlLinePar."Currency Factor" := 1
        ELSE
            GenJnlLinePar."Currency Factor" := ServiceHeaderPar."Currency Factor";
        GenJnlLinePar.Correction := ServiceHeaderPar.Correction;
        GenJnlLinePar."Applies-to Doc. Type" := GenJnlLineDocType;
        GenJnlLinePar."Applies-to Doc. No." := GenJnlLineDocNo;
        GenJnlLinePar."Source Type" := GenJnlLinePar."Source Type"::Customer;
        GenJnlLinePar."Source No." := BillTo;
        GenJnlLinePar."Source Code" := SrcCode;
        GenJnlLinePar."Posting No. Series" := ServiceHeaderPar."Posting No. Series";
        GenJnlLinePar."System-Created Entry" := TRUE;

        VIN := ServiceHeaderPar.VIN;
        "Make Code" := ServiceHeaderPar."Make Code";
        "Model Code" := ServiceHeaderPar."Model Code";
        "Model Version No." := ServiceHeaderPar."Model Version No.";
        "Vehicle Accounting Cycle No." := ServiceHeaderPar."Vehicle Accounting Cycle No.";
        "Vehicle Serial No." := ServiceHeaderPar."Vehicle Serial No.";
        GenJnlPostLine.RunWithCheck(GenJnlLinePar);
    end;

    local procedure PrepmtDocTypeToDocType(DocumentType: Option Invoice,"Credit Memo"): Integer
    begin
        CASE DocumentType OF
            DocumentType::Invoice:
                EXIT(2);
            DocumentType::"Credit Memo":
                EXIT(3);
        END;
        EXIT(2);
    end;

    local procedure CopyCommentLines(FromNumber: Code[20]; ToDocType: Integer; ToNumber: Code[20])
    var
        ServCommentLine: Record "25006148";
        SalesCommentLine2: Record "44";
    begin
        ServCommentLine.SETRANGE("No.", FromNumber);
        IF ServCommentLine.FINDSET THEN
            REPEAT
                SalesCommentLine2.TRANSFERFIELDS(ServCommentLine);
                CASE ToDocType OF
                    DATABASE::"Sales Invoice Header":
                        SalesCommentLine2."Document Type" :=
                          SalesCommentLine2."Document Type"::"Posted Invoice";
                    DATABASE::"Sales Cr.Memo Header":
                        SalesCommentLine2."Document Type" :=
                          SalesCommentLine2."Document Type"::"Posted Credit Memo";
                END;
                SalesCommentLine2."No." := ToNumber;
                SalesCommentLine2.INSERT;
            UNTIL ServCommentLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure UpdateVATOnLines(ServHeader: Record "25006145"; var ServLine: Record "25006146"; var VATAmountLine: Record "290"; DocumentType: Option Invoice,"Credit Memo",Statistic)
    var
        TempVATAmountLineRemainder: Record "290" temporary;
        Currency: Record "4";
        ChangeLogMgt: Codeunit "423";
        RecRef: RecordRef;
        xRecRef: RecordRef;
        PrepmtAmt: Decimal;
        NewAmount: Decimal;
        NewAmountIncludingVAT: Decimal;
        NewVATBaseAmount: Decimal;
        VATAmount: Decimal;
        ServSetup: Record "25006120";
    begin
        IF ServHeader."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
        ELSE
            Currency.GET(ServHeader."Currency Code");

        ApplyFilter(ServHeader, DocumentType, ServLine);
        ServLine.LOCKTABLE;
        IF ServLine.FINDSET THEN
            REPEAT
                PrepmtAmt := PrepmtAmount(ServLine, DocumentType);
                IF PrepmtAmt <> 0 THEN BEGIN
                    VATAmountLine.GET(
                      "Prepayment VAT Identifier",
                      "Prepmt. VAT Calc. Type",
                      "Prepayment Tax Group Code",
                      FALSE,
                      PrepmtAmt >= 0);
                    IF VATAmountLine.Modified THEN BEGIN
                        xRecRef.GETTABLE(ServLine);
                        IF NOT TempVATAmountLineRemainder.GET(
                             "Prepayment VAT Identifier",
                             "Prepmt. VAT Calc. Type",
                             "Prepayment Tax Group Code",
                             FALSE,
                             PrepmtAmt >= 0)
                        THEN BEGIN
                            TempVATAmountLineRemainder := VATAmountLine;
                            TempVATAmountLineRemainder.INIT;
                            TempVATAmountLineRemainder.INSERT;
                        END;

                        IF ServHeader."Prices Including VAT" THEN BEGIN
                            IF PrepmtAmt = 0 THEN BEGIN
                                VATAmount := 0;
                                NewAmountIncludingVAT := 0;
                            END ELSE BEGIN
                                VATAmount :=
                                  TempVATAmountLineRemainder."VAT Amount" +
                                  VATAmountLine."VAT Amount" * PrepmtAmt / VATAmountLine."Line Amount";
                                NewAmountIncludingVAT :=
                                  TempVATAmountLineRemainder."Amount Including VAT" +
                                  VATAmountLine."Amount Including VAT" * PrepmtAmt / VATAmountLine."Line Amount";
                            END;
                            NewAmount :=
                              ROUND(NewAmountIncludingVAT, Currency."Amount Rounding Precision") -
                              ROUND(VATAmount, Currency."Amount Rounding Precision");
                            NewVATBaseAmount :=
                              ROUND(
                                NewAmount * (1 - ServHeader."VAT Base Discount %" / 100),
                                Currency."Amount Rounding Precision");
                        END ELSE BEGIN
                            NewAmount := PrepmtAmt;
                            NewVATBaseAmount :=
                              ROUND(
                                NewAmount * (1 - ServHeader."VAT Base Discount %" / 100),
                                Currency."Amount Rounding Precision");
                            IF VATAmountLine."VAT Base" = 0 THEN
                                VATAmount := 0
                            ELSE
                                VATAmount :=
                                  TempVATAmountLineRemainder."VAT Amount" +
                                  VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base";
                            NewAmountIncludingVAT := NewAmount + ROUND(VATAmount, Currency."Amount Rounding Precision");
                        END;

                        "Prepayment Amount" := NewAmount;
                        "Prepayment Amount Incl. VAT" :=
                          ROUND(NewAmountIncludingVAT, Currency."Amount Rounding Precision");  //13.03.2013 EDMS P8
                        "Prepmt. VAT Base Amt." := NewVATBaseAmount;

                        ServLine.MODIFY;
                        RecRef.GETTABLE(ServLine);

                        // ChangeLogMgt.LogModification(RecRef,xRecRef);//30.10.2012 EDMS
                        ChangeLogMgt.LogModification(RecRef);//30.10.2012 EDMS

                        TempVATAmountLineRemainder."Amount Including VAT" :=
                          NewAmountIncludingVAT - ROUND(NewAmountIncludingVAT, Currency."Amount Rounding Precision");
                        TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
                        TempVATAmountLineRemainder.MODIFY;
                    END;
                END;
            UNTIL ServLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CalcVATAmountLines(var ServHeader: Record "25006145"; var ServLine: Record "25006146"; var VATAmountLine: Record "290"; DocumentType: Option Invoice,"Credit Memo",Statistic)
    var
        PrevVatAmountLine: Record "290";
        Currency: Record "4";
        SalesTaxCalculate: Codeunit "398";
        NewAmount: Decimal;
    begin
        IF ServHeader."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
        ELSE
            Currency.GET(ServHeader."Currency Code");

        VATAmountLine.DELETEALL;

        ApplyFilter(ServHeader, DocumentType, ServLine);
        IF ServLine.FINDSET THEN
            REPEAT
                NewAmount := PrepmtAmount(ServLine, DocumentType);
                IF NewAmount <> 0 THEN BEGIN
                    IF "Prepmt. VAT Calc. Type" IN
                       ["VAT Calculation Type"::"Reverse Charge VAT", "VAT Calculation Type"::"Sales Tax"]
                    THEN
                        "VAT %" := 0;
                    IF NOT VATAmountLine.GET(
                         "Prepayment VAT Identifier",
                         "Prepmt. VAT Calc. Type", "Prepayment Tax Group Code",
                         FALSE, NewAmount >= 0)
                    THEN BEGIN
                        VATAmountLine.INIT;
                        VATAmountLine."VAT Identifier" := "Prepayment VAT Identifier";
                        VATAmountLine."VAT Calculation Type" := "Prepmt. VAT Calc. Type";
                        VATAmountLine."Tax Group Code" := "Prepayment Tax Group Code";
                        VATAmountLine."VAT %" := "Prepayment VAT %";
                        VATAmountLine.Modified := TRUE;
                        VATAmountLine.Positive := NewAmount >= 0;
                        VATAmountLine."Includes Prepayment" := TRUE;
                        VATAmountLine.INSERT;
                    END;
                    VATAmountLine."Line Amount" := VATAmountLine."Line Amount" + NewAmount;
                    VATAmountLine.MODIFY;
                END;
            UNTIL ServLine.NEXT = 0;

        IF VATAmountLine.FINDSET THEN
            REPEAT
                IF (PrevVatAmountLine."VAT Identifier" <> VATAmountLine."VAT Identifier") OR
                   (PrevVatAmountLine."VAT Calculation Type" <> VATAmountLine."VAT Calculation Type") OR
                   (PrevVatAmountLine."Tax Group Code" <> VATAmountLine."Tax Group Code") OR
                   (PrevVatAmountLine."Use Tax" <> VATAmountLine."Use Tax")
                THEN
                    PrevVatAmountLine.INIT;
                IF ServHeader."Prices Including VAT" THEN BEGIN
                    CASE VATAmountLine."VAT Calculation Type" OF
                        VATAmountLine."VAT Calculation Type"::"Normal VAT",
                        VATAmountLine."VAT Calculation Type"::"Reverse Charge VAT":
                            BEGIN
                                VATAmountLine."VAT Base" :=
                                  ROUND(
                                    (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount") / (1 + VATAmountLine."VAT %" / 100),
                                    Currency."Amount Rounding Precision") - VATAmountLine."VAT Difference";
                                VATAmountLine."VAT Amount" :=
                                  VATAmountLine."VAT Difference" +
                                  ROUND(
                                    PrevVatAmountLine."VAT Amount" +
                                    (VATAmountLine."Line Amount" - VATAmountLine."VAT Base" - VATAmountLine."VAT Difference") *
                                    (1 - ServHeader."VAT Base Discount %" / 100),
                                    Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                VATAmountLine."Amount Including VAT" := VATAmountLine."VAT Base" + VATAmountLine."VAT Amount";
                                IF VATAmountLine.Positive THEN
                                    PrevVatAmountLine.INIT
                                ELSE BEGIN
                                    PrevVatAmountLine := VATAmountLine;
                                    PrevVatAmountLine."VAT Amount" :=
                                      (VATAmountLine."Line Amount" - VATAmountLine."VAT Base" - VATAmountLine."VAT Difference") *
                                      (1 - ServHeader."VAT Base Discount %" / 100);
                                    PrevVatAmountLine."VAT Amount" :=
                                      PrevVatAmountLine."VAT Amount" -
                                      ROUND(PrevVatAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                END;
                            END;
                        VATAmountLine."VAT Calculation Type"::"Sales Tax":
                            BEGIN
                                VATAmountLine."Amount Including VAT" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."VAT Base" :=
                                  ROUND(
                                    SalesTaxCalculate.ReverseCalculateTax(
                                      ServHeader."Tax Area Code", VATAmountLine."Tax Group Code", ServHeader."Tax Liable",
                                      ServHeader."Posting Date", VATAmountLine."Amount Including VAT", VATAmountLine.Quantity, ServHeader."Currency Factor"),
                                    Currency."Amount Rounding Precision");
                                VATAmountLine."VAT Amount" := VATAmountLine."VAT Difference" + VATAmountLine."Amount Including VAT" - VATAmountLine."VAT Base";
                                IF VATAmountLine."VAT Base" = 0 THEN
                                    VATAmountLine."VAT %" := 0
                                ELSE
                                    VATAmountLine."VAT %" := ROUND(100 * VATAmountLine."VAT Amount" / VATAmountLine."VAT Base", 0.00001);
                            END;
                    END;
                END ELSE BEGIN
                    CASE VATAmountLine."VAT Calculation Type" OF
                        VATAmountLine."VAT Calculation Type"::"Normal VAT",
                        VATAmountLine."VAT Calculation Type"::"Reverse Charge VAT":
                            BEGIN
                                VATAmountLine."VAT Base" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."VAT Amount" :=
                                  VATAmountLine."VAT Difference" +
                                  ROUND(
                                    PrevVatAmountLine."VAT Amount" +
                                    VATAmountLine."VAT Base" * VATAmountLine."VAT %" / 100 * (1 - ServHeader."VAT Base Discount %" / 100),
                                    Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                VATAmountLine."Amount Including VAT" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount" + VATAmountLine."VAT Amount";
                                IF VATAmountLine.Positive THEN
                                    PrevVatAmountLine.INIT
                                ELSE BEGIN
                                    PrevVatAmountLine := VATAmountLine;
                                    PrevVatAmountLine."VAT Amount" :=
                                      VATAmountLine."VAT Base" * VATAmountLine."VAT %" / 100 * (1 - ServHeader."VAT Base Discount %" / 100);
                                    PrevVatAmountLine."VAT Amount" :=
                                      PrevVatAmountLine."VAT Amount" -
                                      ROUND(PrevVatAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                END;
                            END;
                        VATAmountLine."VAT Calculation Type"::"Sales Tax":
                            BEGIN
                                VATAmountLine."VAT Base" := VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount";
                                VATAmountLine."VAT Amount" :=
                                  SalesTaxCalculate.CalculateTax(
                                    ServHeader."Tax Area Code", VATAmountLine."Tax Group Code", ServHeader."Tax Liable",
                                    ServHeader."Posting Date", VATAmountLine."VAT Base", VATAmountLine.Quantity, ServHeader."Currency Factor");
                                IF VATAmountLine."VAT Base" = 0 THEN
                                    VATAmountLine."VAT %" := 0
                                ELSE
                                    VATAmountLine."VAT %" := ROUND(100 * VATAmountLine."VAT Amount" / VATAmountLine."VAT Base", 0.00001);
                                VATAmountLine."VAT Amount" :=
                                  VATAmountLine."VAT Difference" +
                                  ROUND(VATAmountLine."VAT Amount", Currency."Amount Rounding Precision", Currency.VATRoundingDirection);
                                VATAmountLine."Amount Including VAT" := VATAmountLine."VAT Base" + VATAmountLine."VAT Amount";
                            END;
                    END;
                END;
                VATAmountLine."Calculated VAT Amount" := VATAmountLine."VAT Amount" - VATAmountLine."VAT Difference";
                VATAmountLine.MODIFY;
            UNTIL VATAmountLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure BuildInvLineBuffer(ServHeader: Record "25006145"; var ServLine: Record "25006146"; DocumentType: Option Invoice,"Credit Memo",Statistic; var PrepmtInvBuf: Record "461"; InvoiceRounding: Boolean)
    var
        GLAcc: Record "15";
        PrepmtInvBuf2: Record "461";
        PrepmtInvBufBillTo2: Record "461";
        TotalPrepmtInvLineBuffer: Record "461";
        TotalPrepmtInvLineBufferDummy: Record "461";
    begin
        ApplyFilter(ServHeader, DocumentType, ServLine);
        IF ServLine.FINDSET THEN
            REPEAT
                IF PrepmtAmount(ServLine, DocumentType) <> 0 THEN BEGIN
                    IF ServLine.Quantity < 0 THEN
                        ServLine.FIELDERROR(Quantity, STRSUBSTNO(Text018, ServHeader.FIELDCAPTION("Prepayment %")));
                    IF ServLine."Unit Price" < 0 THEN
                        ServLine.FIELDERROR("Unit Price", STRSUBSTNO(Text018, ServHeader.FIELDCAPTION("Prepayment %")));
                    IF (ServLine."Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") OR
                       (ServLine."Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
                    THEN BEGIN
                        GenPostingSetup.GET(
                          ServLine."Gen. Bus. Posting Group", ServLine."Gen. Prod. Posting Group");
                        GenPostingSetup.TESTFIELD("Service Prepayments Account");
                    END;
                    GLAcc.GET(GenPostingSetup."Service Prepayments Account");

                    //08.11.2007 P3 >>
                    IF NOT ServHeader.Correction AND (EDMSSetup."Default CM VAT Prod. Post. Grp" <> '')
                      AND (DocumentType = DocumentType::"Credit Memo")
                    THEN
                        ServLine."VAT Prod. Posting Group" := EDMSSetup."Default CM VAT Prod. Post. Grp";
                    //08.11.2007 P3 >>
                    FillInvLineBuffer2(ServHeader, ServLine, GLAcc, PrepmtInvBuf2, PrepmtInvBufBillTo2);
                    IF PrepmtInvBuf2.Amount <> 0 THEN BEGIN
                        InsertInvLineBuffer(PrepmtInvBuf, PrepmtInvBuf2);
                        IF InvoiceRounding THEN
                            RoundAmounts(
                              ServHeader, PrepmtInvBuf2, TotalPrepmtInvLineBuffer, TotalPrepmtInvLineBufferDummy);
                    END;
                END;
            UNTIL ServLine.NEXT = 0;
        IF InvoiceRounding THEN
            IF InsertInvoiceRounding(
              ServHeader, PrepmtInvBuf2, TotalPrepmtInvLineBuffer, ServLine."Line No.")
            THEN
                InsertInvLineBuffer(PrepmtInvBuf, PrepmtInvBuf2); // P8 the question is to which part rounding goes? For now is SellTo
    end;

    local procedure InsertExtendedText(TabNo: Integer; DocNo: Code[20]; GLAccNo: Code[20]; DocDate: Date; LanguageCode: Code[10]; var PrevLineNo: Integer)
    var
        TempExtTextLine: Record "280" temporary;
        SalesInvLine: Record "113";
        SalesCrMemoLine: Record "115";
        TransferExtText: Codeunit "378";
        NextLineNo: Integer;
    begin
        TransferExtText.PrepmtGetAnyExtText(GLAccNo, TabNo, DocDate, LanguageCode, TempExtTextLine);
        IF TempExtTextLine.FINDSET THEN BEGIN
            NextLineNo := PrevLineNo + 10000;
            REPEAT
                CASE TabNo OF
                    DATABASE::"Sales Invoice Line":
                        BEGIN
                            SalesInvLine."Document No." := DocNo;
                            SalesInvLine."Line No." := NextLineNo;
                            SalesInvLine.Description := TempExtTextLine.Text;
                            SalesInvLine.INSERT;
                        END;
                    DATABASE::"Sales Cr.Memo Line":
                        BEGIN
                            SalesCrMemoLine."Document No." := DocNo;
                            SalesCrMemoLine."Line No." := NextLineNo;
                            SalesCrMemoLine.Description := TempExtTextLine.Text;
                            SalesCrMemoLine.INSERT;
                        END;
                END;
                PrevLineNo := NextLineNo;
                NextLineNo := NextLineNo + 10000;
            UNTIL TempExtTextLine.NEXT = 0;
        END;
    end;

    local procedure CompressInvLineBuffer(ServHeader: Record "25006145"; var PrepmtInvBuffer: Record "461")
    var
        PrepmtInvBuffer2: Record "461" temporary;
    begin
        IF ServHeader."Compress Prepayment" THEN
            EXIT;

        PrepmtInvBuffer.FINDSET;
        REPEAT
            PrepmtInvBuffer2 := PrepmtInvBuffer;
            PrepmtInvBuffer2."Line No." := 0;
            IF PrepmtInvBuffer2.FIND THEN BEGIN
                IncrAmountsEDMS(PrepmtInvBuffer, PrepmtInvBuffer2);
                PrepmtInvBuffer2.MODIFY;
            END ELSE
                PrepmtInvBuffer2.INSERT;
        UNTIL PrepmtInvBuffer.NEXT = 0;

        PrepmtInvBuffer.DELETEALL;

        PrepmtInvBuffer2.FINDSET;
        REPEAT
            PrepmtInvBuffer := PrepmtInvBuffer2;
            PrepmtInvBuffer.INSERT;
        UNTIL PrepmtInvBuffer2.NEXT = 0;
    end;

    local procedure ReverseAmounts(var PrepmtInvLineBuffer: Record "461")
    begin
        PrepmtInvLineBuffer.Amount := -PrepmtInvLineBuffer.Amount;
        PrepmtInvLineBuffer."Amount Incl. VAT" := -PrepmtInvLineBuffer."Amount Incl. VAT";
        PrepmtInvLineBuffer."VAT Amount" := -PrepmtInvLineBuffer."VAT Amount";
        PrepmtInvLineBuffer."VAT Base Amount" := -PrepmtInvLineBuffer."VAT Base Amount";
        PrepmtInvLineBuffer."Amount (ACY)" := -PrepmtInvLineBuffer."Amount (ACY)";
        PrepmtInvLineBuffer."VAT Amount (ACY)" := -PrepmtInvLineBuffer."VAT Amount (ACY)";
        PrepmtInvLineBuffer."VAT Base Amount (ACY)" := -PrepmtInvLineBuffer."VAT Base Amount (ACY)";
        PrepmtInvLineBuffer."VAT Difference" := -PrepmtInvLineBuffer."VAT Difference";
    end;

    local procedure RoundAmounts(ServHeader: Record "25006145"; var PrepmtInvLineBuf: Record "461"; var TotalPrepmtInvLineBuf: Record "461"; var TotalPrepmtInvLineBufLCY: Record "461")
    var
        VAT: Boolean;
    begin
        IncrAmountsEDMS(PrepmtInvLineBuf, TotalPrepmtInvLineBuf);

        IF ServHeader."Currency Code" <> '' THEN BEGIN
            VAT := PrepmtInvLineBuf.Amount <> PrepmtInvLineBuf."Amount Incl. VAT";

            PrepmtInvLineBuf."Amount Incl. VAT" :=
              AmountToLCY(
                ServHeader, TotalPrepmtInvLineBuf."Amount Incl. VAT", TotalPrepmtInvLineBufLCY."Amount Incl. VAT");
            IF VAT THEN
                PrepmtInvLineBuf.Amount :=
                  AmountToLCY(
                    ServHeader, TotalPrepmtInvLineBuf.Amount, TotalPrepmtInvLineBufLCY.Amount)
            ELSE
                PrepmtInvLineBuf.Amount := PrepmtInvLineBuf."Amount Incl. VAT";
            PrepmtInvLineBuf."VAT Amount" :=
              AmountToLCY(
                ServHeader, TotalPrepmtInvLineBuf."VAT Amount", TotalPrepmtInvLineBufLCY."VAT Amount");
            PrepmtInvLineBuf."VAT Base Amount" :=
              AmountToLCY(
                ServHeader, TotalPrepmtInvLineBuf."VAT Base Amount", TotalPrepmtInvLineBufLCY."VAT Base Amount");
        END;

        IncrAmountsEDMS(PrepmtInvLineBuf, TotalPrepmtInvLineBufLCY);
    end;

    [Scope('Internal')]
    procedure ApplyFilter(ServHeader: Record "25006145"; DocumentType: Option Invoice,"Credit Memo",Statistic; var ServLine: Record "25006146")
    begin
        ServLine.RESET;
        ServLine.SETRANGE("Document Type", ServHeader."Document Type");
        ServLine.SETRANGE("Document No.", ServHeader."No.");
        ServLine.SETFILTER(Type, '<>%1', Type::" ");
        IF DocumentType IN [DocumentType::Invoice, DocumentType::Statistic] THEN
            ServLine.SETFILTER("Prepmt. Line Amount", '<>0')
        ELSE
            ServLine.SETFILTER("Prepmt. Amt. Inv.", '<>0');
    end;

    [Scope('Internal')]
    procedure PrepmtAmount(ServLine: Record "25006146"; DocumentType: Option Invoice,"Credit Memo",Statistic): Decimal
    begin
        CASE DocumentType OF
            DocumentType::Statistic:
                EXIT("Prepmt. Line Amount");
            DocumentType::Invoice:
                EXIT("Prepmt. Line Amount" - "Prepmt. Amt. Inv.");
            ELSE
                EXIT("Prepmt. Amt. Inv." - "Prepmt Amt Deducted");
        END;
    end;

    [Scope('Internal')]
    procedure GetServiceLines(ServiceHeader: Record "25006145"; DocumentType: Option Invoice,"Credit Memo",Statistic; var ToServiceLine: Record "25006146")
    var
        SalesSetup: Record "311";
        FromServiceLine: Record "25006146";
        InvRoundingServiceLine: Record "25006146";
        TempVATAmountLine: Record "290" temporary;
        TotalAmt: Decimal;
        NextLineNo: Integer;
    begin
        ApplyFilter(ServiceHeader, DocumentType, FromServiceLine);
        IF FromServiceLine.FINDSET THEN BEGIN
            REPEAT
                ToServiceLine := FromServiceLine;
                ToServiceLine.INSERT;
            UNTIL FromServiceLine.NEXT = 0;

            SalesSetup.GET;
            IF SalesSetup."Invoice Rounding" THEN BEGIN
                CalcVATAmountLines(ServiceHeader, ToServiceLine, TempVATAmountLine, 2);
                UpdateVATOnLines(ServiceHeader, ToServiceLine, TempVATAmountLine, 2);
                ToServiceLine.FINDSET;
                REPEAT
                    TotalAmt := TotalAmt + ToServiceLine."Prepmt. Amt. Incl. VAT";
                UNTIL ToServiceLine.NEXT = 0;
                IF InitInvoiceRoundingLine(ServiceHeader, TotalAmt, InvRoundingServiceLine) THEN BEGIN
                    NextLineNo := "Line No." + 1;
                    ToServiceLine := InvRoundingServiceLine;
                    "Line No." := NextLineNo;

                    IF DocumentType <> DocumentType::"Credit Memo" THEN
                        "Prepmt. Line Amount" := "Line Amount"
                    ELSE
                        "Prepmt. Amt. Inv." := "Line Amount";
                    "Prepmt. VAT Calc. Type" := "VAT Calculation Type";
                    "Prepayment VAT Identifier" := "VAT Identifier";
                    "Prepayment Tax Group Code" := "Tax Group Code";
                    "Prepayment VAT Identifier" := "VAT Identifier";
                    "Prepayment Tax Group Code" := "Tax Group Code";
                    "Prepayment VAT %" := "VAT %";
                    ToServiceLine.INSERT;
                END;
            END;
        END;
    end;

    local procedure CheckDimValuePosting(ServHeader: Record "25006145"; var ServLine: Record "25006146")
    var
        DimMgt: Codeunit "408";
        TableIDArr: array[10] of Integer;
        NumberArr: array[10] of Code[20];
    begin
        IF ServLine."Line No." = 0 THEN BEGIN
            TableIDArr[1] := DATABASE::Customer;
            NumberArr[1] := ServHeader."Bill-to Customer No.";
            TableIDArr[2] := DATABASE::Job;
            // NumberArr[2] := ServHeader."Job No.";
            TableIDArr[3] := DATABASE::"Salesperson/Purchaser";
            NumberArr[3] := ServHeader."Service Person";
            TableIDArr[4] := DATABASE::Campaign;
            NumberArr[4] := ServHeader."Campaign No.";
            TableIDArr[5] := DATABASE::"Responsibility Center";
            NumberArr[5] := ServHeader."Responsibility Center";
        END ELSE BEGIN
            TableIDArr[1] := DimMgt.TypeToTableID3(ServLine.Type);
            NumberArr[1] := ServLine."No.";
            TableIDArr[2] := DATABASE::Job;
            NumberArr[2] := ServLine."Job No.";
        END;
    end;

    [Scope('Internal')]
    procedure FillInvLineBuffer(ServHeader: Record "25006145"; ServLine: Record "25006146"; GLAcc: Record "15"; var PrepmtInvBuf: Record "461")
    begin
        CLEAR(PrepmtInvBuf);

        PrepmtInvBuf."G/L Account No." := GLAcc."No.";
        PrepmtInvBuf."Gen. Bus. Posting Group" := ServLine."Gen. Bus. Posting Group";
        PrepmtInvBuf."VAT Bus. Posting Group" := ServLine."VAT Bus. Posting Group";
        PrepmtInvBuf."Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
        PrepmtInvBuf."VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
        PrepmtInvBuf."VAT Calculation Type" := ServLine."Prepmt. VAT Calc. Type";
        PrepmtInvBuf."Global Dimension 1 Code" := ServLine."Shortcut Dimension 1 Code";
        PrepmtInvBuf."Global Dimension 2 Code" := ServLine."Shortcut Dimension 2 Code";
        PrepmtInvBuf."Job No." := ServLine."Job No.";
        PrepmtInvBuf.Amount := ServLine."Prepayment Amount";
        PrepmtInvBuf."Amount Incl. VAT" := ServLine."Prepayment Amount Incl. VAT";  //13.03.2013 EDMS P8
        PrepmtInvBuf."VAT Base Amount" := ServLine."Prepayment Amount";
        PrepmtInvBuf."VAT Amount" := (ServLine."Prepayment Amount Incl. VAT" - ServLine."Prepayment Amount");
        PrepmtInvBuf."Amount (ACY)" := ServLine."Prepayment Amount";
        PrepmtInvBuf."VAT Base Amount (ACY)" := ServLine."Prepayment Amount";
        PrepmtInvBuf."VAT Amount (ACY)" := (ServLine."Prepayment Amount Incl. VAT" - ServLine."Prepayment Amount");
        PrepmtInvBuf."VAT %" := ServLine."Prepayment VAT %";
        PrepmtInvBuf."VAT Identifier" := ServLine."Prepayment VAT Identifier";
        PrepmtInvBuf."Tax Area Code" := ServLine."Tax Area Code";
        PrepmtInvBuf."Tax Liable" := ServLine."Tax Liable";
        PrepmtInvBuf."Tax Group Code" := ServLine."Tax Group Code";
        IF NOT ServHeader."Compress Prepayment" THEN BEGIN
            PrepmtInvBuf."Line No." := ServLine."Line No.";
            PrepmtInvBuf.Description := ServLine.Description;
        END ELSE
            PrepmtInvBuf.Description := GLAcc.Name;
    end;

    [Scope('Internal')]
    procedure FillInvLineBuffer2(ServHeader: Record "25006145"; ServLine: Record "25006146"; GLAcc: Record "15"; var PrepmtInvBuf: Record "461"; var PrepmtInvBufBillTo: Record "461")
    var
        amtPart: Decimal;
    begin
        CLEAR(PrepmtInvBuf);
        CLEAR(PrepmtInvBufBillTo);
        FillInvLineBuffer(ServHeader, ServLine, GLAcc, PrepmtInvBuf);
    end;

    [Scope('Internal')]
    procedure InsertInvLineBuffer(var PrepmtInvBuf: Record "461"; PrepmtInvBuf2: Record "461")
    begin
        PrepmtInvBuf := PrepmtInvBuf2;
        IF PrepmtInvBuf.FIND THEN BEGIN
            IncrAmountsEDMS(PrepmtInvBuf2, PrepmtInvBuf);
            PrepmtInvBuf.MODIFY;
        END ELSE
            PrepmtInvBuf.INSERT;
    end;

    local procedure InsertInvoiceRounding(ServHeader: Record "25006145"; var PrepmtInvBuf: Record "461"; TotalPrepmtInvBuf: Record "461"; PrevLineNo: Integer): Boolean
    var
        ServLine: Record "25006146";
    begin
        IF InitInvoiceRoundingLine(ServHeader, TotalPrepmtInvBuf."Amount Incl. VAT", ServLine) THEN BEGIN
            CreateDimensions(ServLine);//30.10.2012 EDMS
            CLEAR(PrepmtInvBuf);
            PrepmtInvBuf."Invoice Rounding" := TRUE;
            PrepmtInvBuf."G/L Account No." := ServLine."No.";
            PrepmtInvBuf."Gen. Bus. Posting Group" := ServHeader."Gen. Bus. Posting Group";
            PrepmtInvBuf."VAT Bus. Posting Group" := ServHeader."VAT Bus. Posting Group";
            PrepmtInvBuf."Gen. Prod. Posting Group" := ServLine."Gen. Prod. Posting Group";
            PrepmtInvBuf."VAT Prod. Posting Group" := ServLine."VAT Prod. Posting Group";
            PrepmtInvBuf."VAT Calculation Type" := ServLine."VAT Calculation Type";
            PrepmtInvBuf."Global Dimension 1 Code" := ServLine."Shortcut Dimension 1 Code";
            PrepmtInvBuf."Global Dimension 2 Code" := ServLine."Shortcut Dimension 2 Code";
            PrepmtInvBuf.Amount := ServLine."Line Amount";
            PrepmtInvBuf."Amount Incl. VAT" := ServLine."Amount Including VAT";
            PrepmtInvBuf."VAT Base Amount" := ServLine."Line Amount";
            PrepmtInvBuf."VAT Amount" := ServLine."Amount Including VAT" - ServLine."Line Amount";
            PrepmtInvBuf."Amount (ACY)" := ServLine."Prepayment Amount";
            PrepmtInvBuf."VAT Base Amount (ACY)" := ServLine."Line Amount";
            PrepmtInvBuf."VAT Amount (ACY)" := ServLine."Amount Including VAT" - ServLine."Line Amount";
            PrepmtInvBuf."VAT %" := ServLine."VAT %";
            PrepmtInvBuf."VAT Identifier" := ServLine."VAT Identifier";
            PrepmtInvBuf."Tax Area Code" := ServLine."Tax Area Code";
            PrepmtInvBuf."Tax Liable" := ServLine."Tax Liable";
            PrepmtInvBuf."Tax Group Code" := ServLine."Tax Group Code";
            PrepmtInvBuf."Line No." := PrevLineNo + 10000;
            EXIT(TRUE);
        END;
    end;

    local procedure IncrAmountsEDMS(PrepmtInvLineBuf: Record "461"; var TotalPrepmtInvLineBuf: Record "461")
    begin
        TotalPrepmtInvLineBuf.Amount := TotalPrepmtInvLineBuf.Amount + PrepmtInvLineBuf.Amount;
        TotalPrepmtInvLineBuf."Amount Incl. VAT" := TotalPrepmtInvLineBuf."Amount Incl. VAT" + PrepmtInvLineBuf."Amount Incl. VAT";
        TotalPrepmtInvLineBuf."VAT Amount" := TotalPrepmtInvLineBuf."VAT Amount" + PrepmtInvLineBuf."VAT Amount";
        TotalPrepmtInvLineBuf."VAT Base Amount" := TotalPrepmtInvLineBuf."VAT Base Amount" + PrepmtInvLineBuf."VAT Base Amount";
        TotalPrepmtInvLineBuf."Amount (ACY)" := TotalPrepmtInvLineBuf."Amount (ACY)" + PrepmtInvLineBuf."Amount (ACY)";
        TotalPrepmtInvLineBuf."VAT Amount (ACY)" := TotalPrepmtInvLineBuf."VAT Amount (ACY)" + PrepmtInvLineBuf."VAT Amount (ACY)";
        TotalPrepmtInvLineBuf."VAT Base Amount (ACY)" := TotalPrepmtInvLineBuf."VAT Base Amount (ACY)" + PrepmtInvLineBuf."VAT Base Amount (ACY)";
    end;

    local procedure AmountToLCY(ServHeader: Record "25006145"; TotalAmt: Decimal; PrevTotalAmt: Decimal): Decimal
    var
        CurrExchRate: Record "330";
    begin
        CurrExchRate.INIT;
        EXIT(
  ROUND(
    CurrExchRate.ExchangeAmtFCYToLCY(ServHeader."Posting Date", ServHeader."Currency Code", TotalAmt, ServHeader."Currency Factor")) -
  PrevTotalAmt);
    end;

    local procedure InitInvoiceRoundingLine(ServHeader: Record "25006145"; TotalAmount: Decimal; var ServLine: Record "25006146"): Boolean
    var
        Currency: Record "4";
        CustPostingGr: Record "92";
        GLAcc: Record "15";
        InvoiceRoundingAmount: Decimal;
    begin
        IF ServHeader."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
        ELSE
            Currency.GET(ServHeader."Currency Code");
        Currency.TESTFIELD("Invoice Rounding Precision");
        InvoiceRoundingAmount :=
          -ROUND(
            TotalAmount -
            ROUND(
              TotalAmount,
              Currency."Invoice Rounding Precision",
              Currency.InvoiceRoundingDirection),
            Currency."Amount Rounding Precision");

        IF InvoiceRoundingAmount = 0 THEN
            EXIT(FALSE);

        CustPostingGr.GET(ServHeader."Customer Posting Group");
        CustPostingGr.TESTFIELD("Invoice Rounding Account");
        GLAcc.GET(CustPostingGr."Invoice Rounding Account");
        SetHideValidationDialog(TRUE);
        ServLine."Document Type" := ServHeader."Document Type";
        ServLine."Document No." := ServHeader."No.";
        "System-Created Entry" := TRUE;
        Type := Type::"G/L Account";
        ServLine.VALIDATE("No.", CustPostingGr."Invoice Rounding Account");
        ServLine.VALIDATE(Quantity, 1);
        IF ServHeader."Prices Including VAT" THEN
            ServLine.VALIDATE("Unit Price", InvoiceRoundingAmount)
        ELSE
            ServLine.VALIDATE(
              "Unit Price",
              ROUND(
                InvoiceRoundingAmount /
                (1 + (1 - ServHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                Currency."Amount Rounding Precision"));
        ServLine.VALIDATE("Amount Including VAT", InvoiceRoundingAmount);
        EXIT(TRUE);
    end;

    local procedure CreateDimensions(var ServLine: Record "25006146")
    var
        SourceCodeSetup: Record "242";
        DimMgt: Codeunit "408";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        SourceCodeSetup.GET;
        TableID[1] := DATABASE::"G/L Account";
        No[1] := ServLine."No.";
        TableID[2] := DATABASE::Job;
        No[2] := ServLine."Job No.";
        TableID[3] := DATABASE::"Responsibility Center";
        No[3] := ServLine."Responsibility Center";
        ServLine."Shortcut Dimension 1 Code" := '';
        ServLine."Shortcut Dimension 2 Code" := '';

        DimMgt.GetDefaultDimID(
          TableID, No, SourceCodeSetup."Service Management EDMS",
          ServLine."Shortcut Dimension 1 Code", ServLine."Shortcut Dimension 2 Code", ServLine."Dimension Set ID", DATABASE::"Service Line EDMS");//30.10.2012 EDMS
    end;

    [Scope('Internal')]
    procedure TransferServDoc(var DocRef: RecordRef; ServHeader: Record "25006145"; DocType: Option Inv,CrMem)
    var
        FieldR: FieldRef;
        SourceCodeSetup: Record "242";
    begin
        SourceCodeSetup.GET;
        FieldR := DocRef.FIELD(2);
        FieldR.VALUE(ServHeader."Sell-to Customer No.");
        FieldR := DocRef.FIELD(4);
        FieldR.VALUE(ServHeader."Bill-to Customer No.");
        FieldR := DocRef.FIELD(35);
        FieldR.VALUE(ServHeader."Prices Including VAT");
        FieldR := DocRef.FIELD(28);
        FieldR.VALUE(ServHeader."Location Code");
        FieldR := DocRef.FIELD(31);
        FieldR.VALUE(ServHeader."Customer Posting Group");
        FieldR := DocRef.FIELD(74);
        FieldR.VALUE("Gen. Bus. Posting Group");
        FieldR := DocRef.FIELD(5);
        FieldR.VALUE(ServHeader."Bill-to Name");
        FieldR := DocRef.FIELD(7);
        FieldR.VALUE(ServHeader."Bill-to Address");
        FieldR := DocRef.FIELD(9);
        FieldR.VALUE(ServHeader."Bill-to City");
        FieldR := DocRef.FIELD(10);
        FieldR.VALUE(ServHeader."Bill-to Contact");
        FieldR := DocRef.FIELD(20);
        FieldR.VALUE(ServHeader."Posting Date");
        FieldR := DocRef.FIELD(29);
        FieldR.VALUE(ServHeader."Shortcut Dimension 1 Code");
        FieldR := DocRef.FIELD(30);
        FieldR.VALUE(ServHeader."Shortcut Dimension 2 Code");
        FieldR := DocRef.FIELD(37);
        FieldR.VALUE(ServHeader."Invoice Disc. Code");
        FieldR := DocRef.FIELD(40);
        FieldR.VALUE(ServHeader."Customer Disc. Group");
        FieldR := DocRef.FIELD(41);
        FieldR.VALUE(ServHeader."Language Code");
        FieldR := DocRef.FIELD(43);
        FieldR.VALUE(ServHeader."Service Person");
        FieldR := DocRef.FIELD(70);
        FieldR.VALUE("VAT Registration No.");
        FieldR := DocRef.FIELD(79);
        FieldR.VALUE("Sell-to Customer Name");
        FieldR := DocRef.FIELD(81);
        FieldR.VALUE("Sell-to Address");
        FieldR := DocRef.FIELD(83);
        FieldR.VALUE("Sell-to City");
        FieldR := DocRef.FIELD(84);
        FieldR.VALUE("Sell-to Contact");
        FieldR := DocRef.FIELD(85);
        FieldR.VALUE("Bill-to Post Code");
        FieldR := DocRef.FIELD(87);
        FieldR.VALUE("Bill-to Country/Region Code");
        FieldR := DocRef.FIELD(94);
        FieldR.VALUE("Bal. Account Type");
        FieldR := DocRef.FIELD(99);
        FieldR.VALUE("Document Date");
        FieldR := DocRef.FIELD(100);
        FieldR.VALUE("External Document No.");
        FieldR := DocRef.FIELD(104);
        FieldR.VALUE("Payment Method Code");
        FieldR := DocRef.FIELD(108);
        FieldR.VALUE("No. Series");
        FieldR := DocRef.FIELD(113);
        FieldR.VALUE(SourceCodeSetup."Service Management EDMS");
        FieldR := DocRef.FIELD(116);
        FieldR.VALUE("VAT Bus. Posting Group");
        FieldR := DocRef.FIELD(119);
        FieldR.VALUE("VAT Base Discount %");
        FieldR := DocRef.FIELD(480);
        FieldR.VALUE("Dimension Set ID");
        FieldR := DocRef.FIELD(25006000);
        FieldR.VALUE(2);
        FieldR := DocRef.FIELD(25006001);
        FieldR.VALUE("Deal Type");
        FieldR := DocRef.FIELD(25006120);
        FieldR.VALUE(ServHeader."No.");
        FieldR := DocRef.FIELD(25006370);
        FieldR.VALUE("Make Code");
        FieldR := DocRef.FIELD(25006371);
        FieldR.VALUE("Model Code");
        FieldR := DocRef.FIELD(25006378);
        FieldR.VALUE("Vehicle Serial No.");
        FieldR := DocRef.FIELD(25006379);
        FieldR.VALUE("Vehicle Accounting Cycle No.");
        FieldR := DocRef.FIELD(25006670);
        FieldR.VALUE(VIN);
        FieldR := DocRef.FIELD(25006995);
        FieldR.VALUE(Kilometrage);
        FieldR := DocRef.FIELD(25006996);
        FieldR.VALUE("Variable Field Run 2");
        FieldR := DocRef.FIELD(25006997);
        FieldR.VALUE("Variable Field Run 3");
        FieldR := DocRef.FIELD(25006400);
        FieldR.VALUE(COPYSTR(GetResourceTextFieldValue, 1, FieldR.LENGTH));
        CASE DocType OF
            DocType::Inv:
                BEGIN
                    FieldR := DocRef.FIELD(131);
                    FieldR.VALUE("Prepayment No. Series")
                END;
            DocType::CrMem:
                BEGIN
                    FieldR := DocRef.FIELD(134);
                    FieldR.VALUE("Prepmt. Cr. Memo No. Series")
                END
        END
    end;

    [Scope('Internal')]
    procedure GetFieldNo(RecRef: RecordRef; FieldName: Text[50]): Integer
    var
        i: Integer;
        FieldRef2: FieldRef;
    begin
        FOR i := 1 TO RecRef.FIELDCOUNT DO BEGIN
            FieldRef2 := RecRef.FIELDINDEX(i);
            IF FieldRef2.NAME = FieldName THEN EXIT(FieldRef2.NUMBER);
        END;
        ERROR('Field %1 was not found in table %2', FieldName, RecRef.NAME);
    end;

    [Scope('Internal')]
    procedure UpdatePrepmtAmountOnServLines(ServiceHeader: Record "25006145"; NewTotalPrepmtAmount: Decimal)
    var
        Currency: Record "4";
        ServiceLine: Record "25006146";
        ChangeLogMgt: Codeunit "423";
        RecRef: RecordRef;
        xRecRef: RecordRef;
        TotalLineAmount: Decimal;
        TotalPrepmtAmount: Decimal;
        TotalPrepmtAmtInv: Decimal;
        LastLineNo: Integer;
    begin
        IF ServiceHeader."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
        ELSE
            Currency.GET(ServiceHeader."Currency Code");

        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETFILTER(Type, '<>%1', Type::" ");
        ServiceLine.SETFILTER("Line Amount", '<>0');
        ServiceLine.SETFILTER("Prepayment %", '<>0');
        ServiceLine.LOCKTABLE;
        IF ServiceLine.FIND('-') THEN
            REPEAT
                TotalLineAmount := TotalLineAmount + "Line Amount";
                TotalPrepmtAmtInv := TotalPrepmtAmtInv + "Prepmt. Amt. Inv.";
                LastLineNo := "Line No.";
            UNTIL ServiceLine.NEXT = 0
        ELSE
            ERROR(Text017, ServiceLine.FIELDCAPTION("Prepayment %"));
        IF TotalLineAmount = 0 THEN
            ERROR(Text013, NewTotalPrepmtAmount);
        IF NOT (NewTotalPrepmtAmount IN [TotalPrepmtAmtInv .. TotalLineAmount]) THEN
            ERROR(Text016, TotalPrepmtAmtInv, TotalLineAmount);
        IF ServiceLine.FINDSET THEN
            REPEAT
                xRecRef.GETTABLE(ServiceLine);
                IF "Line No." <> LastLineNo THEN
                    ServiceLine.VALIDATE(
                      "Prepmt. Line Amount",
                      ROUND(
                        NewTotalPrepmtAmount * "Line Amount" / TotalLineAmount,
                        Currency."Amount Rounding Precision"))
                ELSE
                    ServiceLine.VALIDATE("Prepmt. Line Amount", NewTotalPrepmtAmount - TotalPrepmtAmount);
                TotalPrepmtAmount := TotalPrepmtAmount + "Prepmt. Line Amount";
                ServiceLine.MODIFY;
                RecRef.GETTABLE(ServiceLine);

                // ChangeLogMgt.LogModification(RecRef,xRecRef);//30.10.2012 EDMS
                ChangeLogMgt.LogModification(RecRef);//30.10.2012 EDMS
            UNTIL ServiceLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CopyBufferToBuffer(var PrepmtInvBufferFrom: Record "461"; var PrepmtInvBufferTo: Record "461"; ClearBufferTo: Boolean)
    begin
        IF ClearBufferTo THEN
            PrepmtInvBufferTo.DELETEALL;
        IF PrepmtInvBufferFrom.FINDFIRST THEN
            REPEAT
                PrepmtInvBufferTo.TRANSFERFIELDS(PrepmtInvBufferFrom);
                PrepmtInvBufferTo.INSERT;
            UNTIL PrepmtInvBufferFrom.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SumPrepmt(ServiceHeader: Record "25006145"; var ServiceLine: Record "25006146"; var VATAmountLine: Record "290"; var TotalAmount: Decimal; var TotalVATAmount: Decimal; var VATAmountText: Text[30])
    var
        SalesSetup: Record "311";
        PrepmtInvBuf: Record "461" temporary;
        PrepmtInvBufferBillTo: Record "461" temporary;
        TotalPrepmtBuf: Record "461";
        TotalPrepmtBufLCY: Record "461";
        DifVATPct: Boolean;
        PrevVATPct: Decimal;
    begin
        SalesSetup.GET;
        CalcVATAmountLines(ServiceHeader, ServiceLine, VATAmountLine, 2);
        UpdateVATOnLines(ServiceHeader, ServiceLine, VATAmountLine, 2);
        BuildInvLineBuffer(ServiceHeader, ServiceLine, 2, PrepmtInvBuf, SalesSetup."Invoice Rounding");//30.10.2012 EDMS

        IF PrepmtInvBuf.FINDSET THEN BEGIN
            PrevVATPct := PrepmtInvBuf."VAT %";
            REPEAT
                RoundAmounts(ServiceHeader, PrepmtInvBuf, TotalPrepmtBuf, TotalPrepmtBufLCY);
                IF PrepmtInvBuf."VAT %" <> PrevVATPct THEN
                    DifVATPct := TRUE;
            UNTIL PrepmtInvBuf.NEXT = 0;
        END;
        IF PrepmtInvBufferBillTo.FINDSET THEN BEGIN
            PrevVATPct := PrepmtInvBufferBillTo."VAT %";
            REPEAT
                RoundAmounts(ServiceHeader, PrepmtInvBufferBillTo, TotalPrepmtBuf, TotalPrepmtBufLCY);
                IF PrepmtInvBufferBillTo."VAT %" <> PrevVATPct THEN
                    DifVATPct := TRUE;
            UNTIL PrepmtInvBufferBillTo.NEXT = 0;
        END;

        TotalAmount := TotalPrepmtBuf.Amount;
        TotalVATAmount := TotalPrepmtBuf."VAT Amount";
        IF DifVATPct OR (PrepmtInvBuf."VAT %" = 0) THEN
            VATAmountText := Text014
        ELSE
            VATAmountText := STRSUBSTNO(Text015, PrevVATPct);
    end;

    [Scope('Internal')]
    procedure GetDimBuf(DimEntryNo: Integer)
    var
        TempDimBuf: Record "360" temporary;
        DimMgt: Codeunit "408";
    begin
        TempDimBuf.INIT;
        DimBufMgt.GetDimensions(DimEntryNo, TempDimBuf);
    end;

    local procedure RunGenJnlPostLine(var GenJnlLine: Record "81")
    begin
        GenJnlPostLine.RUN(GenJnlLine);
    end;
}


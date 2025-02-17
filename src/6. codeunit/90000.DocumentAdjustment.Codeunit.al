codeunit 90000 "Document Adjustment"
{
    Permissions = TableData 17 = rim,
                  TableData 21 = rim,
                  TableData 25 = rim,
                  TableData 32 = rim,
                  TableData 110 = rim,
                  TableData 111 = rim,
                  TableData 112 = rim,
                  TableData 113 = rim,
                  TableData 120 = rimd,
                  TableData 121 = rimd,
                  TableData 203 = rim,
                  TableData 254 = rim,
                  TableData 271 = rim,
                  TableData 339 = rim,
                  TableData 379 = rim,
                  TableData 380 = rim,
                  TableData 5802 = rim,
                  TableData 5906 = rim,
                  TableData 5907 = rim,
                  TableData 5936 = rim,
                  TableData 5990 = rim,
                  TableData 5991 = rim,
                  TableData 5992 = rim,
                  TableData 5993 = rim,
                  TableData 5994 = rim,
                  TableData 5995 = rim,
                  TableData 50001 = rim,
                  TableData 50002 = rim;

    trigger OnRun()
    begin
    end;

    var
        ProgressWindow: Dialog;
        Text000: Label 'Processed : #1######\Total Records : #2########\Modifying...#3#######################';
        totalcount: Integer;

    [Scope('Internal')]
    procedure StartProcessingDate()
    var
        RenumberDocument: Record "90000";
        GLEntry: Record "17";
        CustLedgerEntry: Record "21";
        ItemLedgerEntry: Record "32";
        SalesShipmentHeader: Record "110";
        SalesShipmentLine: Record "111";
        SalesInvoiceHeader: Record "112";
        SalesInvoiceLine: Record "113";
        VATEntry: Record "254";
        ItemAppEntry: Record "339";
        DetailedCustLedgEntry: Record "379";
        ValueEntry: Record "5802";
        InvoiceMaterializeView: Record "33020293";
        ServiceDocumentRegister: Record "5936";
        ServiceShipmentHeader: Record "5990";
        ServiceShipmentLine: Record "5991";
        ServiceInvoiceHeader: Record "5992";
        ServiceInvoiceLine: Record "5993";
        BankAccountLedgerEntry: Record "271";
        PostingDate: Date;
        SalesShipmentNo: Code[20];
        SalesOrderNo: Code[20];
        ItemLedgEntryNo: Integer;
        LineNo: Integer;
        ServiceLedgEntry: Record "25006167";
        ResourceLedgerEntry: Record "203";
        RecServiceLedgEntry: Record "25006167";
        RecResourceLedgerEntry: Record "203";
    begin
        ProgressWindow.OPEN(Text000);
        RenumberDocument.RESET;
        IF RenumberDocument.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, RenumberDocument.COUNT);
            REPEAT
                RenumberDocument.TESTFIELD(Updated, FALSE);
                RenumberDocument.TESTFIELD("Old Posting Date");
                RenumberDocument.TESTFIELD("New Posting Date");
                CLEAR(SalesOrderNo);
                CLEAR(SalesShipmentNo);
                CLEAR(ItemLedgEntryNo);
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF GLEntry.FINDSET THEN BEGIN
                    REPEAT
                        GLEntry."Document Date" := RenumberDocument."New Posting Date";
                        GLEntry."Posting Date" := RenumberDocument."New Posting Date";
                        GLEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL GLEntry.NEXT = 0;
                END;
                CustLedgerEntry.RESET;
                CustLedgerEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF CustLedgerEntry.FINDSET THEN BEGIN
                    REPEAT
                        CustLedgerEntry."Document Date" := RenumberDocument."New Posting Date";
                        CustLedgerEntry."Posting Date" := RenumberDocument."New Posting Date";
                        CustLedgerEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL CustLedgerEntry.NEXT = 0;
                END;

                SalesInvoiceHeader.RESET;
                SalesInvoiceHeader.SETRANGE("No.", RenumberDocument."Old Invoice No.");
                IF SalesInvoiceHeader.FINDFIRST THEN BEGIN
                    SalesOrderNo := SalesInvoiceHeader."Order No.";
                    SalesInvoiceHeader."Document Date" := RenumberDocument."New Posting Date";
                    SalesInvoiceHeader."Posting Date" := RenumberDocument."New Posting Date";
                    SalesInvoiceHeader.MODIFY;
                    RenumberDocument.Updated := TRUE;
                    RenumberDocument.MODIFY;
                END;

                SalesInvoiceLine.RESET;
                SalesInvoiceLine.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF SalesInvoiceLine.FINDFIRST THEN BEGIN
                    REPEAT
                        SalesInvoiceLine."Shipment Date" := RenumberDocument."New Posting Date";
                        SalesInvoiceLine."Posting Date" := RenumberDocument."New Posting Date";
                        SalesInvoiceLine.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL SalesInvoiceLine.NEXT = 0;
                END;

                IF SalesOrderNo <> '' THEN BEGIN
                    SalesShipmentHeader.RESET;
                    SalesShipmentHeader.SETRANGE("Order No.", SalesOrderNo);
                    IF SalesShipmentHeader.FINDFIRST THEN BEGIN
                        SalesShipmentNo := SalesShipmentHeader."No.";
                        SalesShipmentHeader."Document Date" := RenumberDocument."New Posting Date";
                        SalesShipmentHeader."Shipment Date" := RenumberDocument."New Posting Date";
                        SalesShipmentHeader."Order Date" := RenumberDocument."New Posting Date";
                        SalesShipmentHeader."Posting Date" := RenumberDocument."New Posting Date";
                        SalesShipmentHeader.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    END;

                    SalesShipmentLine.RESET;
                    SalesShipmentLine.SETRANGE("Document No.", SalesShipmentNo);
                    IF SalesShipmentLine.FINDSET THEN BEGIN
                        REPEAT
                            SalesShipmentLine."Shipment Date" := RenumberDocument."New Posting Date";
                            SalesShipmentLine."Posting Date" := RenumberDocument."New Posting Date";
                            SalesShipmentLine.MODIFY;
                            RenumberDocument.Updated := TRUE;
                            RenumberDocument.MODIFY;
                        UNTIL SalesShipmentLine.NEXT = 0;
                    END;
                END;

                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Document No.", SalesShipmentNo);
                IF ItemLedgerEntry.FINDSET THEN BEGIN
                    REPEAT
                        ItemLedgEntryNo := ItemLedgerEntry."Entry No.";
                        ItemLedgerEntry."Posting Date" := RenumberDocument."New Posting Date";
                        ItemLedgerEntry."Document Date" := RenumberDocument."New Posting Date";
                        ItemLedgerEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL ItemLedgerEntry.NEXT = 0;
                END;

                ItemAppEntry.RESET;
                ItemAppEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntryNo);
                IF ItemAppEntry.FINDSET THEN BEGIN
                    REPEAT
                        ItemAppEntry."Posting Date" := RenumberDocument."New Posting Date";
                        ItemAppEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL ItemAppEntry.NEXT = 0;
                END;

                VATEntry.RESET;
                VATEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF VATEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        VATEntry."Document Date" := RenumberDocument."New Posting Date";
                        VATEntry."Posting Date" := RenumberDocument."New Posting Date";
                        VATEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL VATEntry.NEXT = 0;
                END;

                DetailedCustLedgEntry.RESET;
                DetailedCustLedgEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF DetailedCustLedgEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        DetailedCustLedgEntry."Posting Date" := RenumberDocument."New Posting Date";
                        DetailedCustLedgEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL DetailedCustLedgEntry.NEXT = 0;
                END;

                ValueEntry.RESET;
                ValueEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF ValueEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        ValueEntry."Document Date" := RenumberDocument."New Posting Date";
                        ValueEntry."Posting Date" := RenumberDocument."New Posting Date";
                        ValueEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL ValueEntry.NEXT = 0;
                END;

                InvoiceMaterializeView.RESET;
                InvoiceMaterializeView.SETRANGE("Document Type", InvoiceMaterializeView."Document Type"::"Sales Invoice");
                InvoiceMaterializeView.SETRANGE("Bill No", RenumberDocument."Old Invoice No.");
                IF InvoiceMaterializeView.FINDFIRST THEN BEGIN
                    InvoiceMaterializeView."Bill Date" := RenumberDocument."New Posting Date";
                    InvoiceMaterializeView.MODIFY;
                    RenumberDocument.Updated := TRUE;
                    RenumberDocument.MODIFY;
                END;

                CLEAR(SalesOrderNo);
                ServiceInvoiceHeader.RESET;
                ServiceInvoiceHeader.SETRANGE("No.", RenumberDocument."Old Invoice No.");
                IF ServiceInvoiceHeader.FINDFIRST THEN BEGIN
                    SalesOrderNo := ServiceInvoiceHeader."Order No.";
                    ServiceInvoiceHeader."Posting Date" := RenumberDocument."New Posting Date";
                    ServiceInvoiceHeader."Document Date" := RenumberDocument."New Posting Date";
                    ServiceInvoiceHeader."Order Date" := RenumberDocument."New Posting Date";
                    ServiceInvoiceHeader.MODIFY;
                    ServiceInvoiceLine.RESET;
                    ServiceInvoiceLine.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                    IF ServiceInvoiceLine.FINDSET THEN
                        REPEAT
                            ServiceInvoiceLine."Posting Date" := RenumberDocument."New Posting Date";
                            ServiceInvoiceLine.MODIFY;
                        UNTIL ServiceInvoiceLine.NEXT = 0;
                    RenumberDocument.Updated := TRUE;
                    RenumberDocument.MODIFY;
                END;

                IF SalesOrderNo <> '' THEN BEGIN
                    ServiceShipmentHeader.RESET;
                    ServiceShipmentHeader.SETRANGE("Order No.", SalesOrderNo);
                    IF ServiceShipmentHeader.FINDFIRST THEN BEGIN
                        ServiceShipmentHeader."Document Date" := RenumberDocument."New Posting Date";
                        ServiceShipmentHeader."Order Date" := RenumberDocument."New Posting Date";
                        ServiceShipmentHeader."Posting Date" := RenumberDocument."New Posting Date";
                        ServiceShipmentHeader.MODIFY;
                        ServiceShipmentLine.RESET;
                        ServiceShipmentLine.SETRANGE("Document No.", ServiceShipmentHeader."No.");
                        IF ServiceShipmentLine.FINDSET THEN
                            REPEAT
                                ServiceShipmentLine."Posting Date" := RenumberDocument."New Posting Date";
                                ServiceShipmentLine.MODIFY;
                            UNTIL ServiceShipmentLine.NEXT = 0;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    END;
                END;
                //Service Ledger Entry
                ServiceLedgEntry.RESET;
                ServiceLedgEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF ServiceLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Service Ledger Entry EDMS');
                    REPEAT
                        RecServiceLedgEntry := ServiceLedgEntry;
                        RecServiceLedgEntry."Posting Date" := RenumberDocument."New Posting Date";
                        RecServiceLedgEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL ServiceLedgEntry.NEXT = 0;
                END;
                //Resource Ledger Entry
                ResourceLedgerEntry.RESET;
                ResourceLedgerEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF ResourceLedgerEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Resource Ledger Entry');
                    REPEAT
                        RecResourceLedgerEntry := ResourceLedgerEntry;
                        RecResourceLedgerEntry."Posting Date" := RenumberDocument."New Posting Date";
                        RecResourceLedgerEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL ResourceLedgerEntry.NEXT = 0;
                END;

                BankAccountLedgerEntry.RESET;
                BankAccountLedgerEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF BankAccountLedgerEntry.FINDSET THEN
                    REPEAT
                        BankAccountLedgerEntry."Document Date" := RenumberDocument."New Posting Date";
                        BankAccountLedgerEntry."Posting Date" := RenumberDocument."New Posting Date";
                        BankAccountLedgerEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL BankAccountLedgerEntry.NEXT = 0;

                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);

            UNTIL RenumberDocument.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure StartProcessingDocumentNo()
    var
        GLEntry: Record "17";
        CustLedgerEntry: Record "21";
        ItemLedgerEntry: Record "32";
        SalesCommentLine: Record "44";
        SalesInvoiceHeader: Record "112";
        SalesInvoiceLine: Record "113";
        VATEntry: Record "254";
        BankAccLedgEntry: Record "271";
        DetailedCustLedgEntry: Record "379";
        ValueEntry: Record "5802";
        ServiceLedgEntry: Record "25006167";
        ReNumberingData: Record "90000";
        SalesInvoicePrintHistory: Record "50002";
        InvoiceMaterializeView: Record "33020293";
        InvoiceMaterializeViewMerged: Record "33020293";
        ServiceCommentLine: Record "5906";
        ServiceInvoiceHeader: Record "5992";
        ServiceInvoiceLine: Record "5993";
        ResourceLedgerEntry: Record "203";
        IDofTable: Integer;
        RecCount: Integer;
        LineNo: Integer;
        "--Rec": Integer;
        RecGLEntry: Record "17";
        RecCustLedgerEntry: Record "21";
        RecItemLedgerEntry: Record "32";
        RecSalesCommentLine: Record "44";
        RecSalesInvoiceHeader: Record "112";
        RecSalesInvoiceLine: Record "113";
        RecVATEntry: Record "254";
        RecBankAccLedgEntry: Record "271";
        RecDetailedCustLedgEntry: Record "379";
        RecValueEntry: Record "5802";
        RecServiceLedgEntry: Record "25006167";
        RecInvoiceMaterializeView: Record "33020293";
        RecSalesInvoicePrintHistory: Record "50002";
        RecServiceCommentLine: Record "5906";
        RecServiceInvoiceHeader: Record "5992";
        RecServiceInvoiceLine: Record "5993";
        RecResourceLedgerEntry: Record "203";
    begin

        ProgressWindow.OPEN(Text000);
        ReNumberingData.RESET;
        IF ReNumberingData.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, ReNumberingData.COUNT);
            REPEAT
                ReNumberingData.TESTFIELD(Updated, FALSE);
                ReNumberingData.TESTFIELD("New Invoice No.");
                ReNumberingData.TESTFIELD("Old Invoice No.");
                CheckPostedSalesandServiceInvoiceNo(ReNumberingData."New Invoice No.");
                //G/L Entry->Document No.
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF GLEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'G/L Entry');
                    REPEAT
                        RecGLEntry := GLEntry;
                        RecGLEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecGLEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL GLEntry.NEXT = 0;
                END;
                //Cust. Ledger Entry->Document No.
                CustLedgerEntry.RESET;
                CustLedgerEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF CustLedgerEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Cust. Ledger Entry');
                    REPEAT
                        RecCustLedgerEntry := CustLedgerEntry;
                        RecCustLedgerEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecCustLedgerEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL CustLedgerEntry.NEXT = 0;
                END;
                //Item Ledger Entry->Document No.
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF ItemLedgerEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Item Ledger Entry');
                    REPEAT
                        RecItemLedgerEntry := ItemLedgerEntry;
                        RecItemLedgerEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecItemLedgerEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ItemLedgerEntry.NEXT = 0;
                END;
                //Sales Comment Line->No.
                SalesCommentLine.RESET;
                SalesCommentLine.SETRANGE("No.", ReNumberingData."Old Invoice No.");
                IF SalesCommentLine.FINDFIRST THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Sales Comment Line');
                    REPEAT
                        RecSalesCommentLine := SalesCommentLine;
                        RecSalesCommentLine.RENAME(SalesCommentLine."Document Type"::"Posted Invoice", ReNumberingData."New Invoice No.", SalesCommentLine."Document Line No.", SalesCommentLine."Line No.");
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL SalesCommentLine.NEXT = 0;
                END;
                //Sales Invoice Header->No.
                LineNo := 0;
                IF NOT ReNumberingData.Merge THEN BEGIN
                    SalesInvoiceHeader.RESET;
                    SalesInvoiceHeader.SETRANGE("No.", ReNumberingData."Old Invoice No.");
                    IF SalesInvoiceHeader.FINDSET THEN BEGIN
                        ProgressWindow.UPDATE(3, 'Sales Invoice Header');
                        BEGIN
                            RecSalesInvoiceHeader := SalesInvoiceHeader;
                            RecSalesInvoiceHeader.RENAME(ReNumberingData."New Invoice No.");
                            ReNumberingData.Updated := TRUE;
                            ReNumberingData.MODIFY;
                        END;
                    END
                END ELSE BEGIN
                    SalesInvoiceLine.RESET;
                    SalesInvoiceLine.SETRANGE("Document No.", ReNumberingData."New Invoice No.");
                    IF SalesInvoiceLine.FINDLAST THEN BEGIN
                        LineNo += SalesInvoiceLine."Line No.";
                    END;
                    SalesInvoiceHeader.RESET;
                    SalesInvoiceHeader.SETRANGE("No.", ReNumberingData."Old Invoice No.");
                    IF SalesInvoiceHeader.FINDFIRST THEN
                        SalesInvoiceHeader.DELETE;
                END;
                //Sales Invoice Line->Document No.
                SalesInvoiceLine.RESET;
                SalesInvoiceLine.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF SalesInvoiceLine.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Sales Invoice Line');
                    REPEAT
                        IF ReNumberingData.Merge THEN
                            LineNo += 10000
                        ELSE
                            LineNo := SalesInvoiceLine."Line No.";

                        RecSalesInvoiceLine := SalesInvoiceLine;
                        RecSalesInvoiceLine.RENAME(ReNumberingData."New Invoice No.", LineNo);
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL SalesInvoiceLine.NEXT = 0;
                END;

                //VAT Entry->Document No.
                VATEntry.RESET;
                VATEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF VATEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'VAT Entry');
                    REPEAT
                        RecVATEntry := VATEntry;
                        RecVATEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecVATEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL VATEntry.NEXT = 0;
                END;

                //Bank Account Ledger Entry->Document No.
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF BankAccLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Bank Account Ledger Entry');
                    REPEAT
                        RecBankAccLedgEntry := BankAccLedgEntry;
                        RecBankAccLedgEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecBankAccLedgEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL BankAccLedgEntry.NEXT = 0;
                END;

                //Detailed Cust. Ledg. Entry->Document No.
                DetailedCustLedgEntry.RESET;
                DetailedCustLedgEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF DetailedCustLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Detailed Cust. Ledg. Entry');
                    REPEAT
                        RecDetailedCustLedgEntry := DetailedCustLedgEntry;
                        RecDetailedCustLedgEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecDetailedCustLedgEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL DetailedCustLedgEntry.NEXT = 0;
                END;

                //Value Entry->Document No.
                ValueEntry.RESET;
                ValueEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF ValueEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Value Entry');
                    REPEAT
                        RecValueEntry := ValueEntry;
                        RecValueEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecValueEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ValueEntry.NEXT = 0;
                END;

                //Service Ledger Entry EDMS->Document No.
                ServiceLedgEntry.RESET;
                ServiceLedgEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF ServiceLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Service Ledger Entry EDMS');
                    REPEAT
                        RecServiceLedgEntry := ServiceLedgEntry;
                        RecServiceLedgEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecServiceLedgEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ServiceLedgEntry.NEXT = 0;
                END;

                //Resource Ledger Entry
                ResourceLedgerEntry.RESET;
                ResourceLedgerEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF ResourceLedgerEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Resource Ledger Entry');
                    REPEAT
                        RecResourceLedgerEntry := ResourceLedgerEntry;
                        RecResourceLedgerEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecResourceLedgerEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ResourceLedgerEntry.NEXT = 0;
                END;

                IF NOT ReNumberingData.Merge THEN BEGIN
                    InvoiceMaterializeView.RESET;
                    InvoiceMaterializeView.SETRANGE("Document Type", InvoiceMaterializeView."Document Type"::"Sales Invoice");
                    InvoiceMaterializeView.SETRANGE("Bill No", ReNumberingData."Old Invoice No.");
                    IF InvoiceMaterializeView.FINDFIRST THEN BEGIN
                        ProgressWindow.UPDATE(3, 'Invoice Materialize View');
                        RecInvoiceMaterializeView := InvoiceMaterializeView;
                        RecInvoiceMaterializeView.RENAME(InvoiceMaterializeView."Table ID", InvoiceMaterializeView."Document Type", ReNumberingData."New Invoice No.", InvoiceMaterializeView."Fiscal Year");
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    END;
                END ELSE BEGIN
                    InvoiceMaterializeView.RESET;
                    InvoiceMaterializeView.SETRANGE("Document Type", InvoiceMaterializeView."Document Type"::"Sales Invoice");
                    InvoiceMaterializeView.SETRANGE("Bill No", ReNumberingData."Old Invoice No.");
                    IF InvoiceMaterializeView.FINDFIRST THEN BEGIN
                        ProgressWindow.UPDATE(3, 'Invoice Materialize View');
                        InvoiceMaterializeViewMerged.RESET;
                        InvoiceMaterializeViewMerged.SETRANGE("Document Type", InvoiceMaterializeView."Document Type"::"Sales Invoice");
                        InvoiceMaterializeViewMerged.SETRANGE("Bill No", ReNumberingData."New Invoice No.");
                        IF InvoiceMaterializeViewMerged.FINDFIRST THEN BEGIN
                            InvoiceMaterializeViewMerged.Amount += InvoiceMaterializeView.Amount;
                            InvoiceMaterializeViewMerged.Discount += InvoiceMaterializeView.Discount;
                            InvoiceMaterializeViewMerged."Taxable Amount" += InvoiceMaterializeView."Taxable Amount";
                            InvoiceMaterializeViewMerged."TAX Amount" += InvoiceMaterializeView."TAX Amount";
                            InvoiceMaterializeViewMerged."Total Amount" += InvoiceMaterializeView."Total Amount";
                            InvoiceMaterializeViewMerged.MODIFY;
                        END;
                        InvoiceMaterializeView.DELETE;
                    END;
                END;

                IF NOT ReNumberingData.Merge THEN BEGIN
                    /*
                    SalesInvoicePrintHistory.RESET;
                    SalesInvoicePrintHistory.SETRANGE("Document Type",SalesInvoicePrintHistory."Document Type"::"Sales Invoice");
                    SalesInvoicePrintHistory.SETRANGE("Document No.",ReNumberingData."Old Invoice No.");
                    IF SalesInvoicePrintHistory.FINDFIRST THEN BEGIN
                      ProgressWindow.UPDATE(3,'Sales Invoice Print History');
                      RecSalesInvoicePrintHistory := SalesInvoicePrintHistory;
                      RecSalesInvoicePrintHistory.RENAME(SalesInvoicePrintHistory."Table ID",SalesInvoicePrintHistory."Document Type",ReNumberingData."New Invoice No.",SalesInvoicePrintHistory."Fiscal Year",SalesInvoicePrintHistory."Line No.");
                      ReNumberingData.Updated := TRUE;
                      ReNumberingData.MODIFY;
                    END;
                    */
                END;
                /*
                ServiceInvoiceHeader.RESET;
                ServiceInvoiceHeader.SETRANGE("No.",ReNumberingData."Old Invoice No.");
                IF ServiceInvoiceHeader.FINDFIRST THEN BEGIN
                  ProgressWindow.UPDATE(3,'Service Invoice Header');
                  RecServiceInvoiceHeader := ServiceInvoiceHeader;
                  RecServiceInvoiceHeader.RENAME(ReNumberingData."New Invoice No.");
                  ReNumberingData.Updated := TRUE;
                  ReNumberingData.MODIFY;
                END;

                ServiceInvoiceLine.RESET;
                ServiceInvoiceLine.SETRANGE("Document No.",ReNumberingData."Old Invoice No.");
                IF ServiceInvoiceLine.FINDSET THEN REPEAT
                  ProgressWindow.UPDATE(3,'Service Invoice Line');
                  RecServiceInvoiceLine := ServiceInvoiceLine;
                  RecServiceInvoiceLine.RENAME(ReNumberingData."New Invoice No.",ServiceInvoiceLine."Line No.");//
                  ReNumberingData.Updated := TRUE;
                  ReNumberingData.MODIFY;
                UNTIL ServiceInvoiceLine.NEXT = 0;
                */
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);

            UNTIL ReNumberingData.NEXT = 0;
        END;

    end;

    [Scope('Internal')]
    procedure ResetNoOfPrint()
    var
        SalesInvoiceHeader: Record "112";
        ServiceInvoiceHeader: Record "5992";
        InvoiceMaterializeView: Record "50001";
        SalesInvoicePrintHistory: Record "50002";
    begin
        SalesInvoiceHeader.RESET;
        IF SalesInvoiceHeader.FINDSET THEN
            REPEAT
                SalesInvoiceHeader."No. Printed" := 0;
                SalesInvoiceHeader."Tax Invoice Printed By" := '';
                SalesInvoiceHeader.MODIFY;
            UNTIL SalesInvoiceHeader.NEXT = 0;

        /*
        ServiceInvoiceHeader.RESET;
        IF ServiceInvoiceHeader.FINDSET THEN REPEAT
          ServiceInvoiceHeader."No. Printed" := 0;
          ServiceInvoiceHeader."Tax Invoice Printed By" := '';
          ServiceInvoiceHeader.MODIFY;
        UNTIL ServiceInvoiceHeader.NEXT = 0;
        
        InvoiceMaterializeView.RESET;
        IF InvoiceMaterializeView.FINDSET THEN REPEAT
          InvoiceMaterializeView.Printed := FALSE;
          InvoiceMaterializeView."Printed By" := '';
          InvoiceMaterializeView."Printed Time" := 0T;
          InvoiceMaterializeView."Is Printed" := 0;
          InvoiceMaterializeView.MODIFY;
        UNTIL InvoiceMaterializeView.NEXT = 0;
        */
        SalesInvoicePrintHistory.RESET;
        SalesInvoicePrintHistory.DELETEALL;

    end;

    [Scope('Internal')]
    procedure StartProcessingServiceDocumentNoPostingDate()
    var
        GLEntry: Record "17";
        CustLedgerEntry: Record "21";
        ItemLedgerEntry: Record "32";
        SalesCommentLine: Record "44";
        SalesInvoiceHeader: Record "112";
        SalesInvoiceLine: Record "113";
        VATEntry: Record "254";
        BankAccLedgEntry: Record "271";
        DetailedCustLedgEntry: Record "379";
        ValueEntry: Record "5802";
        ServiceLedgEntry: Record "5907";
        ReNumberingData: Record "90000";
        SalesInvoicePrintHistory: Record "50002";
        InvoiceMaterializeView: Record "33020293";
        InvoiceMaterializeViewMerged: Record "33020293";
        ServiceCommentLine: Record "5906";
        ServiceInvoiceHeader: Record "5992";
        ServiceInvoiceLine: Record "5993";
        IDofTable: Integer;
        RecCount: Integer;
        LineNo: Integer;
        ResourceLedgerEntry: Record "203";
        "--Rec": Integer;
        RecGLEntry: Record "17";
        RecCustLedgerEntry: Record "21";
        RecItemLedgerEntry: Record "32";
        RecSalesCommentLine: Record "44";
        RecSalesInvoiceHeader: Record "112";
        RecSalesInvoiceLine: Record "113";
        RecVATEntry: Record "254";
        RecBankAccLedgEntry: Record "271";
        RecDetailedCustLedgEntry: Record "379";
        RecValueEntry: Record "5802";
        RecServiceLedgEntry: Record "5907";
        RecInvoiceMaterializeView: Record "33020293";
        RecSalesInvoicePrintHistory: Record "50002";
        RecServiceCommentLine: Record "5906";
        RecServiceInvoiceHeader: Record "5992";
        RecServiceInvoiceLine: Record "5993";
        RecResourceLedgerEntry: Record "203";
    begin

        ProgressWindow.OPEN(Text000);
        ReNumberingData.RESET;
        IF ReNumberingData.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, ReNumberingData.COUNT);
            REPEAT
                ReNumberingData.TESTFIELD(Updated, FALSE);
                ReNumberingData.TESTFIELD("New Invoice No.");
                ReNumberingData.TESTFIELD("Old Invoice No.");
                ReNumberingData.TESTFIELD("New Posting Date");
                ReNumberingData.TESTFIELD("Old Posting Date");
                //G/L Entry->Document No.
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                GLEntry.SETRANGE("Posting Date", ReNumberingData."Old Posting Date");//
                IF GLEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'G/L Entry');
                    REPEAT
                        RecGLEntry := GLEntry;
                        RecGLEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecGLEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL GLEntry.NEXT = 0;
                END;
                //Cust. Ledger Entry->Document No.
                CustLedgerEntry.RESET;
                CustLedgerEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                CustLedgerEntry.SETRANGE("Posting Date", ReNumberingData."Old Posting Date");//
                IF CustLedgerEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Cust. Ledger Entry');
                    REPEAT
                        RecCustLedgerEntry := CustLedgerEntry;
                        RecCustLedgerEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecCustLedgerEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL CustLedgerEntry.NEXT = 0;
                END;
                /*
              //Item Ledger Entry->Document No.
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Document No.",ReNumberingData."Old Invoice No.");
                IF ItemLedgerEntry.FINDSET THEN BEGIN
                  ProgressWindow.UPDATE(3,'Item Ledger Entry');
                  REPEAT
                    RecItemLedgerEntry := ItemLedgerEntry;
                    RecItemLedgerEntry."Document No." := ReNumberingData."New Invoice No.";
                    RecItemLedgerEntry.MODIFY;
                    ReNumberingData.Updated := TRUE;
                    ReNumberingData.MODIFY;
                  UNTIL ItemLedgerEntry.NEXT=0;
                END;

              //Sales Comment Line->No.
                SalesCommentLine.RESET;
                SalesCommentLine.SETRANGE("No.",ReNumberingData."Old Invoice No.");
                IF SalesCommentLine.FINDFIRST THEN BEGIN
                  ProgressWindow.UPDATE(3,'Sales Comment Line');
                  REPEAT
                    RecSalesCommentLine := SalesCommentLine;
                    RecSalesCommentLine.RENAME(SalesCommentLine."Document Type"::"Posted Invoice",ReNumberingData."New Invoice No.",SalesCommentLine."Document Line No.",SalesCommentLine."Line No.");
                    ReNumberingData.Updated := TRUE;
                    ReNumberingData.MODIFY;
                  UNTIL SalesCommentLine.NEXT=0;
                END;
              //Sales Invoice Header->No.
              LineNo := 0;
              IF NOT ReNumberingData.Merge THEN BEGIN
                SalesInvoiceHeader.RESET;
                SalesInvoiceHeader.SETRANGE("No.",ReNumberingData."Old Invoice No.");
                IF SalesInvoiceHeader.FINDSET THEN BEGIN
                  ProgressWindow.UPDATE(3,'Sales Invoice Header');
                  BEGIN
                    RecSalesInvoiceHeader := SalesInvoiceHeader;
                    RecSalesInvoiceHeader.RENAME(ReNumberingData."New Invoice No.");
                    ReNumberingData.Updated := TRUE;
                    ReNumberingData.MODIFY;
                  END;
                END
               END ELSE BEGIN
                  SalesInvoiceLine.RESET;
                  SalesInvoiceLine.SETRANGE("Document No.",ReNumberingData."New Invoice No.");
                  IF SalesInvoiceLine.FINDLAST THEN BEGIN
                    LineNo += SalesInvoiceLine."Line No.";
                  END;
                  SalesInvoiceHeader.RESET;
                  SalesInvoiceHeader.SETRANGE("No.",ReNumberingData."Old Invoice No.");
                  IF SalesInvoiceHeader.FINDFIRST THEN
                    SalesInvoiceHeader.DELETE;
                END;
              //Sales Invoice Line->Document No.
                SalesInvoiceLine.RESET;
                SalesInvoiceLine.SETRANGE("Document No.",ReNumberingData."Old Invoice No.");
                IF SalesInvoiceLine.FINDSET THEN BEGIN
                  ProgressWindow.UPDATE(3,'Sales Invoice Line');
                  REPEAT
                    IF ReNumberingData.Merge THEN
                      LineNo += 10000
                    ELSE
                      LineNo := SalesInvoiceLine."Line No.";

                    RecSalesInvoiceLine := SalesInvoiceLine;
                    RecSalesInvoiceLine.RENAME(ReNumberingData."New Invoice No.",LineNo);
                    ReNumberingData.Updated := TRUE;
                    ReNumberingData.MODIFY;
                  UNTIL SalesInvoiceLine.NEXT=0;
                END;
                */
                //VAT Entry->Document No.
                VATEntry.RESET;
                VATEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                VATEntry.SETRANGE("Posting Date", ReNumberingData."Old Posting Date");//
                IF VATEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'VAT Entry');
                    REPEAT
                        RecVATEntry := VATEntry;
                        RecVATEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecVATEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL VATEntry.NEXT = 0;
                END;

                //Bank Account Ledger Entry->Document No.
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                BankAccLedgEntry.SETRANGE("Posting Date", ReNumberingData."Old Posting Date");//
                IF BankAccLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Bank Account Ledger Entry');
                    REPEAT
                        RecBankAccLedgEntry := BankAccLedgEntry;
                        RecBankAccLedgEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecBankAccLedgEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL BankAccLedgEntry.NEXT = 0;
                END;

                //Detailed Cust. Ledg. Entry->Document No.
                DetailedCustLedgEntry.RESET;
                DetailedCustLedgEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                DetailedCustLedgEntry.SETRANGE("Posting Date", ReNumberingData."Old Posting Date");//
                IF DetailedCustLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Detailed Cust. Ledg. Entry');
                    REPEAT
                        RecDetailedCustLedgEntry := DetailedCustLedgEntry;
                        RecDetailedCustLedgEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecDetailedCustLedgEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL DetailedCustLedgEntry.NEXT = 0;
                END;
                /*
              //Value Entry->Document No.
                ValueEntry.RESET;
                ValueEntry.SETRANGE("Document No.",ReNumberingData."Old Invoice No.");
                IF ValueEntry.FINDSET THEN BEGIN
                  ProgressWindow.UPDATE(3,'Value Entry');
                  REPEAT
                    RecValueEntry := ValueEntry;
                    RecValueEntry."Document No." := ReNumberingData."New Invoice No.";
                    RecValueEntry.MODIFY;
                    ReNumberingData.Updated := TRUE;
                    ReNumberingData.MODIFY;
                  UNTIL ValueEntry.NEXT=0;
                END;
                */
                //Service Ledger Entry EDMS->Document No.
                ServiceLedgEntry.RESET;
                ServiceLedgEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                ServiceLedgEntry.SETRANGE("Posting Date", ReNumberingData."Old Posting Date");//
                IF ServiceLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Service Ledger Entry');
                    REPEAT
                        RecServiceLedgEntry := ServiceLedgEntry;
                        RecServiceLedgEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecServiceLedgEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ServiceLedgEntry.NEXT = 0;
                END;

                //Resource Ledger Entry
                ResourceLedgerEntry.RESET;
                ResourceLedgerEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                ResourceLedgerEntry.SETRANGE("Posting Date", ReNumberingData."Old Posting Date");//
                IF ResourceLedgerEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Resource Ledger Entry');
                    REPEAT
                        RecResourceLedgerEntry := ResourceLedgerEntry;
                        RecResourceLedgerEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecResourceLedgerEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ResourceLedgerEntry.NEXT = 0;
                END;

                // IF NOT ReNumberingData.Merge THEN BEGIN
                InvoiceMaterializeView.RESET;
                InvoiceMaterializeView.SETRANGE("Document Type", InvoiceMaterializeView."Document Type"::"Sales Invoice");
                InvoiceMaterializeView.SETRANGE("Bill No", ReNumberingData."Old Invoice No.");
                InvoiceMaterializeView.SETRANGE("Bill Date", ReNumberingData."Old Posting Date");//
                IF InvoiceMaterializeView.FINDFIRST THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Invoice Materialize View');
                    RecInvoiceMaterializeView := InvoiceMaterializeView;
                    RecInvoiceMaterializeView.RENAME(InvoiceMaterializeView."Table ID", InvoiceMaterializeView."Document Type", ReNumberingData."New Invoice No.", InvoiceMaterializeView."Fiscal Year");
                    ReNumberingData.Updated := TRUE;
                    ReNumberingData.MODIFY;
                END;
                /*
                END ELSE BEGIN
                  InvoiceMaterializeView.RESET;
                  InvoiceMaterializeView.SETRANGE("Document Type",InvoiceMaterializeView."Document Type"::"Sales Invoice");
                  InvoiceMaterializeView.SETRANGE("Document No.",ReNumberingData."Old Invoice No.");
                  IF InvoiceMaterializeView.FINDFIRST THEN BEGIN
                    ProgressWindow.UPDATE(3,'Invoice Materialize View');
                    InvoiceMaterializeViewMerged.RESET;
                    InvoiceMaterializeViewMerged.SETRANGE("Document Type",InvoiceMaterializeView."Document Type"::"Sales Invoice");
                    InvoiceMaterializeViewMerged.SETRANGE("Document No.",ReNumberingData."New Invoice No.");
                    IF InvoiceMaterializeViewMerged.FINDFIRST THEN BEGIN
                      InvoiceMaterializeViewMerged.Amount += InvoiceMaterializeView.Amount;
                      InvoiceMaterializeViewMerged.Discount += InvoiceMaterializeView.Discount;
                      InvoiceMaterializeViewMerged."Taxable Amount" += InvoiceMaterializeView."Taxable Amount";
                      InvoiceMaterializeViewMerged."VAT Amount" += InvoiceMaterializeView."VAT Amount";
                      InvoiceMaterializeViewMerged."Total Amount" += InvoiceMaterializeView."Total Amount";
                      InvoiceMaterializeViewMerged.MODIFY;
                    END;
                    InvoiceMaterializeView.DELETE;
                  END;
                END;
               */
                // IF NOT ReNumberingData.Merge THEN BEGIN
                /*
                SalesInvoicePrintHistory.RESET;
                SalesInvoicePrintHistory.SETRANGE("Document Type",SalesInvoicePrintHistory."Document Type"::"Sales Invoice");
                SalesInvoicePrintHistory.SETRANGE("Document No.",ReNumberingData."Old Invoice No.");//
                SalesInvoicePrintHistory.SETRANGE("Table ID",5992);
                IF SalesInvoicePrintHistory.FINDFIRST THEN BEGIN
                  ProgressWindow.UPDATE(3,'Sales Invoice Print History');
                  RecSalesInvoicePrintHistory := SalesInvoicePrintHistory;
                  RecSalesInvoicePrintHistory.RENAME(SalesInvoicePrintHistory."Table ID",SalesInvoicePrintHistory."Document Type",ReNumberingData."New Invoice No.",SalesInvoicePrintHistory."Fiscal Year",SalesInvoicePrintHistory."Line No.");
                  ReNumberingData.Updated := TRUE;
                  ReNumberingData.MODIFY;
                END;
                */
                //END;

                ServiceInvoiceHeader.RESET;
                ServiceInvoiceHeader.SETRANGE("No.", ReNumberingData."Old Invoice No.");
                ServiceInvoiceHeader.SETRANGE("Posting Date", ReNumberingData."Old Posting Date");//
                IF ServiceInvoiceHeader.FINDFIRST THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Service Invoice Header');
                    RecServiceInvoiceHeader := ServiceInvoiceHeader;
                    RecServiceInvoiceHeader.RENAME(ReNumberingData."New Invoice No.");
                    ReNumberingData.Updated := TRUE;
                    ReNumberingData.MODIFY;
                END;

                ServiceInvoiceLine.RESET;
                ServiceInvoiceLine.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                ServiceInvoiceLine.SETRANGE("Posting Date", ReNumberingData."Old Posting Date");
                IF ServiceInvoiceLine.FINDSET THEN
                    REPEAT
                        ProgressWindow.UPDATE(3, 'Service Invoice Line');
                        RecServiceInvoiceLine := ServiceInvoiceLine;
                        RecServiceInvoiceLine.RENAME(ReNumberingData."New Invoice No.", ServiceInvoiceLine."Line No.");//
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ServiceInvoiceLine.NEXT = 0;

                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);

            UNTIL ReNumberingData.NEXT = 0;
        END;

    end;

    local procedure CheckPostedSalesandServiceInvoiceNo(DocumentNo: Code[20])
    var
        ServInvHeader: Record "5992";
        SaleInvHeader: Record "112";
        Error1: Label '%1 already exists in %2. Please renumber %1.';
    begin
        ServInvHeader.RESET;
        ServInvHeader.SETRANGE("No.", DocumentNo);
        IF ServInvHeader.FINDFIRST THEN
            ERROR(Error1, DocumentNo, ServInvHeader.TABLECAPTION);

        SaleInvHeader.RESET;
        SaleInvHeader.SETRANGE("No.", DocumentNo);
        IF SaleInvHeader.FINDFIRST THEN
            ERROR(Error1, DocumentNo, SaleInvHeader.TABLECAPTION);
    end;

    [Scope('Internal')]
    procedure StartProcessingDateServiceLedgerResouceledger()
    var
        RenumberDocument: Record "90000";
        GLEntry: Record "17";
        CustLedgerEntry: Record "21";
        ItemLedgerEntry: Record "32";
        SalesShipmentHeader: Record "110";
        SalesShipmentLine: Record "111";
        SalesInvoiceHeader: Record "112";
        SalesInvoiceLine: Record "113";
        VATEntry: Record "254";
        ItemAppEntry: Record "339";
        DetailedCustLedgEntry: Record "379";
        ValueEntry: Record "5802";
        InvoiceMaterializeView: Record "33020293";
        ServiceDocumentRegister: Record "5936";
        ServiceShipmentHeader: Record "5990";
        ServiceShipmentLine: Record "5991";
        ServiceInvoiceHeader: Record "5992";
        ServiceInvoiceLine: Record "5993";
        BankAccountLedgerEntry: Record "271";
        PostingDate: Date;
        SalesShipmentNo: Code[20];
        SalesOrderNo: Code[20];
        ItemLedgEntryNo: Integer;
        LineNo: Integer;
        ServiceLedgEntry: Record "5907";
        ResourceLedgerEntry: Record "203";
        RecServiceLedgEntry: Record "5907";
        RecResourceLedgerEntry: Record "203";
    begin
        ProgressWindow.OPEN(Text000);
        RenumberDocument.RESET;
        IF RenumberDocument.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, RenumberDocument.COUNT);
            REPEAT
                RenumberDocument.TESTFIELD(Updated, FALSE);
                RenumberDocument.TESTFIELD("Old Posting Date");
                RenumberDocument.TESTFIELD("New Posting Date");
                //Service Ledger Entry
                ServiceLedgEntry.RESET;
                ServiceLedgEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF ServiceLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Service Ledger Entry');
                    REPEAT
                        RecServiceLedgEntry := ServiceLedgEntry;
                        RecServiceLedgEntry."Posting Date" := RenumberDocument."New Posting Date";
                        RecServiceLedgEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL ServiceLedgEntry.NEXT = 0;
                END;
                //Resource Ledger Entry
                ResourceLedgerEntry.RESET;
                ResourceLedgerEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF ResourceLedgerEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Resource Ledger Entry');
                    REPEAT
                        RecResourceLedgerEntry := ResourceLedgerEntry;
                        RecResourceLedgerEntry."Posting Date" := RenumberDocument."New Posting Date";
                        RecResourceLedgerEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL ResourceLedgerEntry.NEXT = 0;
                END;
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);

            UNTIL RenumberDocument.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure StartPurchaseProcessingDate()
    var
        RenumberDocument: Record "90000";
        GLEntry: Record "17";
        CustLedgerEntry: Record "21";
        ItemLedgerEntry: Record "32";
        SalesShipmentHeader: Record "110";
        SalesShipmentLine: Record "111";
        SalesInvoiceHeader: Record "112";
        SalesInvoiceLine: Record "113";
        VATEntry: Record "254";
        ItemAppEntry: Record "339";
        DetailedCustLedgEntry: Record "379";
        ValueEntry: Record "5802";
        InvoiceMaterializeView: Record "33020293";
        ServiceDocumentRegister: Record "5936";
        ServiceShipmentHeader: Record "5990";
        ServiceShipmentLine: Record "5991";
        ServiceInvoiceHeader: Record "5992";
        ServiceInvoiceLine: Record "5993";
        BankAccountLedgerEntry: Record "271";
        PostingDate: Date;
        SalesShipmentNo: Code[20];
        SalesOrderNo: Code[20];
        ItemLedgEntryNo: Integer;
        LineNo: Integer;
        ServiceLedgEntry: Record "25006167";
        ResourceLedgerEntry: Record "203";
        RecServiceLedgEntry: Record "25006167";
        RecResourceLedgerEntry: Record "203";
        VendorLedgerEntry: Record "25";
        PurchInvHdr: Record "122";
        PurchInvLine: Record "123";
        PurchReceiptHdr: Record "120";
        PurchReceiptLine: Record "121";
        DetailedVendLedgEntry: Record "380";
    begin
        ProgressWindow.OPEN(Text000);
        RenumberDocument.RESET;
        IF RenumberDocument.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, RenumberDocument.COUNT);
            REPEAT
                RenumberDocument.TESTFIELD(Updated, FALSE);
                RenumberDocument.TESTFIELD("Old Posting Date");
                RenumberDocument.TESTFIELD("New Posting Date");
                CLEAR(SalesOrderNo);
                CLEAR(SalesShipmentNo);
                CLEAR(ItemLedgEntryNo);
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF GLEntry.FINDSET THEN BEGIN
                    REPEAT
                        GLEntry."Document Date" := RenumberDocument."New Posting Date";
                        GLEntry."Posting Date" := RenumberDocument."New Posting Date";
                        GLEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL GLEntry.NEXT = 0;
                END;
                VendorLedgerEntry.RESET;
                VendorLedgerEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF VendorLedgerEntry.FINDSET THEN BEGIN
                    REPEAT
                        VendorLedgerEntry."Document Date" := RenumberDocument."New Posting Date";
                        VendorLedgerEntry."Posting Date" := RenumberDocument."New Posting Date";
                        VendorLedgerEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL VendorLedgerEntry.NEXT = 0;
                END;

                PurchInvHdr.RESET;
                PurchInvHdr.SETRANGE("No.", RenumberDocument."Old Invoice No.");
                IF PurchInvHdr.FINDFIRST THEN BEGIN
                    SalesOrderNo := PurchInvHdr."Order No.";
                    PurchInvHdr."Document Date" := RenumberDocument."New Posting Date";
                    PurchInvHdr."Posting Date" := RenumberDocument."New Posting Date";
                    PurchInvHdr.MODIFY;
                    RenumberDocument.Updated := TRUE;
                    RenumberDocument.MODIFY;
                END;

                PurchInvLine.RESET;
                PurchInvLine.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF PurchInvLine.FINDFIRST THEN BEGIN
                    REPEAT
                        PurchInvLine."Expected Receipt Date" := RenumberDocument."New Posting Date";
                        PurchInvLine."Posting Date" := RenumberDocument."New Posting Date";
                        PurchInvLine.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL PurchInvLine.NEXT = 0;
                END;

                IF SalesOrderNo <> '' THEN BEGIN
                    PurchReceiptHdr.RESET;
                    PurchReceiptHdr.SETRANGE("Order No.", SalesOrderNo);
                    IF PurchReceiptHdr.FINDFIRST THEN BEGIN
                        SalesShipmentNo := PurchReceiptHdr."No.";
                        PurchReceiptHdr."Document Date" := RenumberDocument."New Posting Date";
                        PurchReceiptHdr."Expected Receipt Date" := RenumberDocument."New Posting Date";
                        PurchReceiptHdr."Order Date" := RenumberDocument."New Posting Date";
                        PurchReceiptHdr."Posting Date" := RenumberDocument."New Posting Date";
                        PurchReceiptHdr.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    END;

                    PurchReceiptLine.RESET;
                    PurchReceiptLine.SETRANGE("Document No.", SalesShipmentNo);
                    IF PurchReceiptLine.FINDSET THEN BEGIN
                        REPEAT
                            PurchReceiptLine."Expected Receipt Date" := RenumberDocument."New Posting Date";
                            PurchReceiptLine."Posting Date" := RenumberDocument."New Posting Date";
                            PurchReceiptLine.MODIFY;
                            RenumberDocument.Updated := TRUE;
                            RenumberDocument.MODIFY;
                        UNTIL PurchReceiptLine.NEXT = 0;
                    END;
                END;

                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Document No.", SalesShipmentNo);
                IF ItemLedgerEntry.FINDSET THEN BEGIN
                    REPEAT
                        ItemLedgEntryNo := ItemLedgerEntry."Entry No.";
                        ItemLedgerEntry."Posting Date" := RenumberDocument."New Posting Date";
                        ItemLedgerEntry."Document Date" := RenumberDocument."New Posting Date";
                        ItemLedgerEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL ItemLedgerEntry.NEXT = 0;
                END;

                ItemAppEntry.RESET;
                ItemAppEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntryNo);
                IF ItemAppEntry.FINDSET THEN BEGIN
                    REPEAT
                        ItemAppEntry."Posting Date" := RenumberDocument."New Posting Date";
                        ItemAppEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL ItemAppEntry.NEXT = 0;
                END;

                VATEntry.RESET;
                VATEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF VATEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        VATEntry."Document Date" := RenumberDocument."New Posting Date";
                        VATEntry."Posting Date" := RenumberDocument."New Posting Date";
                        VATEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL VATEntry.NEXT = 0;
                END;

                DetailedVendLedgEntry.RESET;
                DetailedVendLedgEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF DetailedVendLedgEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        DetailedVendLedgEntry."Posting Date" := RenumberDocument."New Posting Date";
                        DetailedVendLedgEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL DetailedVendLedgEntry.NEXT = 0;
                END;

                ValueEntry.RESET;
                ValueEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF ValueEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        ValueEntry."Document Date" := RenumberDocument."New Posting Date";
                        ValueEntry."Posting Date" := RenumberDocument."New Posting Date";
                        ValueEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL ValueEntry.NEXT = 0;
                END;

                InvoiceMaterializeView.RESET;
                InvoiceMaterializeView.SETRANGE("Document Type", InvoiceMaterializeView."Document Type"::"Sales Invoice");
                InvoiceMaterializeView.SETRANGE("Bill No", RenumberDocument."Old Invoice No.");
                IF InvoiceMaterializeView.FINDFIRST THEN BEGIN
                    InvoiceMaterializeView."Bill Date" := RenumberDocument."New Posting Date";
                    InvoiceMaterializeView.MODIFY;
                    RenumberDocument.Updated := TRUE;
                    RenumberDocument.MODIFY;
                END;

                CLEAR(SalesOrderNo);
                ServiceInvoiceHeader.RESET;
                ServiceInvoiceHeader.SETRANGE("No.", RenumberDocument."Old Invoice No.");
                IF ServiceInvoiceHeader.FINDFIRST THEN BEGIN
                    SalesOrderNo := ServiceInvoiceHeader."Order No.";
                    ServiceInvoiceHeader."Posting Date" := RenumberDocument."New Posting Date";
                    ServiceInvoiceHeader."Document Date" := RenumberDocument."New Posting Date";
                    ServiceInvoiceHeader."Order Date" := RenumberDocument."New Posting Date";
                    ServiceInvoiceHeader.MODIFY;
                    ServiceInvoiceLine.RESET;
                    ServiceInvoiceLine.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                    IF ServiceInvoiceLine.FINDSET THEN
                        REPEAT
                            ServiceInvoiceLine."Posting Date" := RenumberDocument."New Posting Date";
                            ServiceInvoiceLine.MODIFY;
                        UNTIL ServiceInvoiceLine.NEXT = 0;
                    RenumberDocument.Updated := TRUE;
                    RenumberDocument.MODIFY;
                END;

                IF SalesOrderNo <> '' THEN BEGIN
                    ServiceShipmentHeader.RESET;
                    ServiceShipmentHeader.SETRANGE("Order No.", SalesOrderNo);
                    IF ServiceShipmentHeader.FINDFIRST THEN BEGIN
                        ServiceShipmentHeader."Document Date" := RenumberDocument."New Posting Date";
                        ServiceShipmentHeader."Order Date" := RenumberDocument."New Posting Date";
                        ServiceShipmentHeader."Posting Date" := RenumberDocument."New Posting Date";
                        ServiceShipmentHeader.MODIFY;
                        ServiceShipmentLine.RESET;
                        ServiceShipmentLine.SETRANGE("Document No.", ServiceShipmentHeader."No.");
                        IF ServiceShipmentLine.FINDSET THEN
                            REPEAT
                                ServiceShipmentLine."Posting Date" := RenumberDocument."New Posting Date";
                                ServiceShipmentLine.MODIFY;
                            UNTIL ServiceShipmentLine.NEXT = 0;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    END;
                END;
                //Service Ledger Entry
                ServiceLedgEntry.RESET;
                ServiceLedgEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF ServiceLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Service Ledger Entry EDMS');
                    REPEAT
                        RecServiceLedgEntry := ServiceLedgEntry;
                        RecServiceLedgEntry."Posting Date" := RenumberDocument."New Posting Date";
                        RecServiceLedgEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL ServiceLedgEntry.NEXT = 0;
                END;
                //Resource Ledger Entry
                ResourceLedgerEntry.RESET;
                ResourceLedgerEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF ResourceLedgerEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Resource Ledger Entry');
                    REPEAT
                        RecResourceLedgerEntry := ResourceLedgerEntry;
                        RecResourceLedgerEntry."Posting Date" := RenumberDocument."New Posting Date";
                        RecResourceLedgerEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL ResourceLedgerEntry.NEXT = 0;
                END;

                BankAccountLedgerEntry.RESET;
                BankAccountLedgerEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF BankAccountLedgerEntry.FINDSET THEN
                    REPEAT
                        BankAccountLedgerEntry."Document Date" := RenumberDocument."New Posting Date";
                        BankAccountLedgerEntry."Posting Date" := RenumberDocument."New Posting Date";
                        BankAccountLedgerEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL BankAccountLedgerEntry.NEXT = 0;

                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);

            UNTIL RenumberDocument.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure StartPurchaseProcessingDocumentNo()
    var
        GLEntry: Record "17";
        CustLedgerEntry: Record "21";
        ItemLedgerEntry: Record "32";
        SalesCommentLine: Record "44";
        SalesInvoiceHeader: Record "112";
        SalesInvoiceLine: Record "113";
        VATEntry: Record "254";
        BankAccLedgEntry: Record "271";
        DetailedCustLedgEntry: Record "379";
        ValueEntry: Record "5802";
        ServiceLedgEntry: Record "25006167";
        ReNumberingData: Record "90000";
        SalesInvoicePrintHistory: Record "50002";
        InvoiceMaterializeView: Record "33020293";
        InvoiceMaterializeViewMerged: Record "33020293";
        ServiceCommentLine: Record "5906";
        ServiceInvoiceHeader: Record "5992";
        ServiceInvoiceLine: Record "5993";
        ResourceLedgerEntry: Record "203";
        IDofTable: Integer;
        RecCount: Integer;
        LineNo: Integer;
        "--Rec": Integer;
        RecGLEntry: Record "17";
        RecCustLedgerEntry: Record "21";
        RecItemLedgerEntry: Record "32";
        RecSalesCommentLine: Record "44";
        RecSalesInvoiceHeader: Record "112";
        RecSalesInvoiceLine: Record "113";
        RecVATEntry: Record "254";
        RecBankAccLedgEntry: Record "271";
        RecDetailedCustLedgEntry: Record "379";
        RecValueEntry: Record "5802";
        RecServiceLedgEntry: Record "25006167";
        RecInvoiceMaterializeView: Record "33020293";
        RecSalesInvoicePrintHistory: Record "50002";
        RecServiceCommentLine: Record "5906";
        RecServiceInvoiceHeader: Record "5992";
        RecServiceInvoiceLine: Record "5993";
        RecResourceLedgerEntry: Record "203";
        VendorLedgEntry: Record "25";
        DetailedVednLedgEntry: Record "380";
        RecDetailedVendLedgEntry: Record "380";
        RecVendLedgEntry: Record "25";
        PurchINvHdr: Record "122";
        RecPurchInvHdr: Record "122";
        PurchInvLine: Record "123";
        RecPurchInvLine: Record "123";
    begin

        ProgressWindow.OPEN(Text000);
        ReNumberingData.RESET;
        IF ReNumberingData.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, ReNumberingData.COUNT);
            REPEAT
                ReNumberingData.TESTFIELD(Updated, FALSE);
                ReNumberingData.TESTFIELD("New Invoice No.");
                ReNumberingData.TESTFIELD("Old Invoice No.");
                CheckPostedPurchaseInvoiceNo(ReNumberingData."New Invoice No.");
                //G/L Entry->Document No.
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF GLEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'G/L Entry');
                    REPEAT
                        RecGLEntry := GLEntry;
                        RecGLEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecGLEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL GLEntry.NEXT = 0;
                END;
                //Cust. Ledger Entry->Document No.
                VendorLedgEntry.RESET;
                VendorLedgEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF VendorLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Vendor Ledger Entry');
                    REPEAT
                        RecVendLedgEntry := VendorLedgEntry;
                        RecVendLedgEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecVendLedgEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL VendorLedgEntry.NEXT = 0;
                END;
                //Item Ledger Entry->Document No.
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF ItemLedgerEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Item Ledger Entry');
                    REPEAT
                        RecItemLedgerEntry := ItemLedgerEntry;
                        RecItemLedgerEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecItemLedgerEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ItemLedgerEntry.NEXT = 0;
                END;
                //Sales Comment Line->No.
                SalesCommentLine.RESET;
                SalesCommentLine.SETRANGE("No.", ReNumberingData."Old Invoice No.");
                IF SalesCommentLine.FINDFIRST THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Sales Comment Line');
                    REPEAT
                        RecSalesCommentLine := SalesCommentLine;
                        RecSalesCommentLine.RENAME(SalesCommentLine."Document Type"::"Posted Invoice", ReNumberingData."New Invoice No.", SalesCommentLine."Document Line No.", SalesCommentLine."Line No.");
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL SalesCommentLine.NEXT = 0;
                END;
                //Sales Invoice Header->No.
                LineNo := 0;
                IF NOT ReNumberingData.Merge THEN BEGIN
                    PurchINvHdr.RESET;
                    PurchINvHdr.SETRANGE("No.", ReNumberingData."Old Invoice No.");
                    IF PurchINvHdr.FINDSET THEN BEGIN
                        ProgressWindow.UPDATE(3, 'Purch. Invoice Header');
                        BEGIN
                            RecPurchInvHdr := PurchINvHdr;
                            RecPurchInvHdr.RENAME(ReNumberingData."New Invoice No.");
                            ReNumberingData.Updated := TRUE;
                            ReNumberingData.MODIFY;
                        END;
                    END
                END ELSE BEGIN
                    PurchInvLine.RESET;
                    PurchInvLine.SETRANGE("Document No.", ReNumberingData."New Invoice No.");
                    IF PurchInvLine.FINDLAST THEN BEGIN
                        LineNo += PurchInvLine."Line No.";
                    END;
                    PurchINvHdr.RESET;
                    PurchINvHdr.SETRANGE("No.", ReNumberingData."Old Invoice No.");
                    IF PurchINvHdr.FINDFIRST THEN
                        PurchINvHdr.DELETE;
                END;
                //Sales Invoice Line->Document No.
                PurchInvLine.RESET;
                PurchInvLine.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF PurchInvLine.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Purch. Invoice Line');
                    REPEAT
                        IF ReNumberingData.Merge THEN
                            LineNo += 10000
                        ELSE
                            LineNo := PurchInvLine."Line No.";

                        RecPurchInvLine := PurchInvLine;
                        RecPurchInvLine.RENAME(ReNumberingData."New Invoice No.", LineNo);
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL RecPurchInvLine.NEXT = 0;
                END;

                //VAT Entry->Document No.
                VATEntry.RESET;
                VATEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF VATEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'VAT Entry');
                    REPEAT
                        RecVATEntry := VATEntry;
                        RecVATEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecVATEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL VATEntry.NEXT = 0;
                END;

                //Bank Account Ledger Entry->Document No.
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF BankAccLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Bank Account Ledger Entry');
                    REPEAT
                        RecBankAccLedgEntry := BankAccLedgEntry;
                        RecBankAccLedgEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecBankAccLedgEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL BankAccLedgEntry.NEXT = 0;
                END;

                //Detailed Cust. Ledg. Entry->Document No.
                DetailedVednLedgEntry.RESET;
                DetailedVednLedgEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF DetailedVednLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Detailed Vend. Ledg. Entry');
                    REPEAT
                        RecDetailedVendLedgEntry := DetailedVednLedgEntry;
                        RecDetailedVendLedgEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecDetailedVendLedgEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL DetailedVednLedgEntry.NEXT = 0;
                END;

                //Value Entry->Document No.
                ValueEntry.RESET;
                ValueEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF ValueEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Value Entry');
                    REPEAT
                        RecValueEntry := ValueEntry;
                        RecValueEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecValueEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ValueEntry.NEXT = 0;
                END;

                //Service Ledger Entry EDMS->Document No.
                ServiceLedgEntry.RESET;
                ServiceLedgEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF ServiceLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Service Ledger Entry EDMS');
                    REPEAT
                        RecServiceLedgEntry := ServiceLedgEntry;
                        RecServiceLedgEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecServiceLedgEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ServiceLedgEntry.NEXT = 0;
                END;

                //Resource Ledger Entry
                ResourceLedgerEntry.RESET;
                ResourceLedgerEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF ResourceLedgerEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Resource Ledger Entry');
                    REPEAT
                        RecResourceLedgerEntry := ResourceLedgerEntry;
                        RecResourceLedgerEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecResourceLedgerEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ResourceLedgerEntry.NEXT = 0;
                END;

                IF NOT ReNumberingData.Merge THEN BEGIN
                    InvoiceMaterializeView.RESET;
                    InvoiceMaterializeView.SETRANGE("Document Type", InvoiceMaterializeView."Document Type"::"Sales Invoice");
                    InvoiceMaterializeView.SETRANGE("Bill No", ReNumberingData."Old Invoice No.");
                    IF InvoiceMaterializeView.FINDFIRST THEN BEGIN
                        ProgressWindow.UPDATE(3, 'Invoice Materialize View');
                        RecInvoiceMaterializeView := InvoiceMaterializeView;
                        RecInvoiceMaterializeView.RENAME(InvoiceMaterializeView."Table ID", InvoiceMaterializeView."Document Type", ReNumberingData."New Invoice No.", InvoiceMaterializeView."Fiscal Year");
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    END;
                END ELSE BEGIN
                    InvoiceMaterializeView.RESET;
                    InvoiceMaterializeView.SETRANGE("Document Type", InvoiceMaterializeView."Document Type"::"Sales Invoice");
                    InvoiceMaterializeView.SETRANGE("Bill No", ReNumberingData."Old Invoice No.");
                    IF InvoiceMaterializeView.FINDFIRST THEN BEGIN
                        ProgressWindow.UPDATE(3, 'Invoice Materialize View');
                        InvoiceMaterializeViewMerged.RESET;
                        InvoiceMaterializeViewMerged.SETRANGE("Document Type", InvoiceMaterializeView."Document Type"::"Sales Invoice");
                        InvoiceMaterializeViewMerged.SETRANGE("Bill No", ReNumberingData."New Invoice No.");
                        IF InvoiceMaterializeViewMerged.FINDFIRST THEN BEGIN
                            InvoiceMaterializeViewMerged.Amount += InvoiceMaterializeView.Amount;
                            InvoiceMaterializeViewMerged.Discount += InvoiceMaterializeView.Discount;
                            InvoiceMaterializeViewMerged."Taxable Amount" += InvoiceMaterializeView."Taxable Amount";
                            InvoiceMaterializeViewMerged."TAX Amount" += InvoiceMaterializeView."TAX Amount";
                            InvoiceMaterializeViewMerged."Total Amount" += InvoiceMaterializeView."Total Amount";
                            InvoiceMaterializeViewMerged.MODIFY;
                        END;
                        InvoiceMaterializeView.DELETE;
                    END;
                END;

                IF NOT ReNumberingData.Merge THEN BEGIN
                    /*
                    SalesInvoicePrintHistory.RESET;
                    SalesInvoicePrintHistory.SETRANGE("Document Type",SalesInvoicePrintHistory."Document Type"::"Sales Invoice");
                    SalesInvoicePrintHistory.SETRANGE("Document No.",ReNumberingData."Old Invoice No.");
                    IF SalesInvoicePrintHistory.FINDFIRST THEN BEGIN
                      ProgressWindow.UPDATE(3,'Sales Invoice Print History');
                      RecSalesInvoicePrintHistory := SalesInvoicePrintHistory;
                      RecSalesInvoicePrintHistory.RENAME(SalesInvoicePrintHistory."Table ID",SalesInvoicePrintHistory."Document Type",ReNumberingData."New Invoice No.",SalesInvoicePrintHistory."Fiscal Year",SalesInvoicePrintHistory."Line No.");
                      ReNumberingData.Updated := TRUE;
                      ReNumberingData.MODIFY;
                    END;
                    */
                END;
                /*
                ServiceInvoiceHeader.RESET;
                ServiceInvoiceHeader.SETRANGE("No.",ReNumberingData."Old Invoice No.");
                IF ServiceInvoiceHeader.FINDFIRST THEN BEGIN
                  ProgressWindow.UPDATE(3,'Service Invoice Header');
                  RecServiceInvoiceHeader := ServiceInvoiceHeader;
                  RecServiceInvoiceHeader.RENAME(ReNumberingData."New Invoice No.");
                  ReNumberingData.Updated := TRUE;
                  ReNumberingData.MODIFY;
                END;

                ServiceInvoiceLine.RESET;
                ServiceInvoiceLine.SETRANGE("Document No.",ReNumberingData."Old Invoice No.");
                IF ServiceInvoiceLine.FINDSET THEN REPEAT
                  ProgressWindow.UPDATE(3,'Service Invoice Line');
                  RecServiceInvoiceLine := ServiceInvoiceLine;
                  RecServiceInvoiceLine.RENAME(ReNumberingData."New Invoice No.",ServiceInvoiceLine."Line No.");//
                  ReNumberingData.Updated := TRUE;
                  ReNumberingData.MODIFY;
                UNTIL ServiceInvoiceLine.NEXT = 0;
                */
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);

            UNTIL ReNumberingData.NEXT = 0;
        END;

    end;

    local procedure CheckPostedPurchaseInvoiceNo(DocumentNo: Code[20])
    var
        ServInvHeader: Record "5992";
        SaleInvHeader: Record "112";
        Error1: Label '%1 already exists in %2. Please renumber %1.';
        PurchInvHdr: Record "122";
    begin
        PurchInvHdr.RESET;
        PurchInvHdr.SETRANGE("No.", DocumentNo);
        IF PurchInvHdr.FINDFIRST THEN
            ERROR(Error1, DocumentNo, PurchInvHdr.TABLECAPTION);
    end;

    [Scope('Internal')]
    procedure StartProcessingDateSalesCreditMemo()
    var
        RenumberDocument: Record "90000";
        GLEntry: Record "17";
        CustLedgerEntry: Record "21";
        ItemLedgerEntry: Record "32";
        VATEntry: Record "254";
        ItemAppEntry: Record "339";
        DetailedCustLedgEntry: Record "379";
        ValueEntry: Record "5802";
        InvoiceMaterializeView: Record "33020293";
        ServiceDocumentRegister: Record "5936";
        ServiceShipmentHeader: Record "5990";
        ServiceShipmentLine: Record "5991";
        ServiceInvoiceHeader: Record "5992";
        ServiceInvoiceLine: Record "5993";
        BankAccountLedgerEntry: Record "271";
        PostingDate: Date;
        SalesShipmentNo: Code[20];
        SalesOrderNo: Code[20];
        ItemLedgEntryNo: Integer;
        LineNo: Integer;
        ServiceLedgEntry: Record "25006167";
        ResourceLedgerEntry: Record "203";
        RecServiceLedgEntry: Record "25006167";
        RecResourceLedgerEntry: Record "203";
        SalesCrMemoHeader: Record "114";
        SalesCrMemoLine: Record "115";
        ReturnReceiptHeader: Record "6660";
        ReturnReceiptLine: Record "6661";
    begin
        ProgressWindow.OPEN(Text000);
        RenumberDocument.RESET;
        IF RenumberDocument.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, RenumberDocument.COUNT);
            REPEAT
                RenumberDocument.TESTFIELD(Updated, FALSE);
                RenumberDocument.TESTFIELD("Old Posting Date");
                RenumberDocument.TESTFIELD("New Posting Date");
                CLEAR(SalesOrderNo);
                CLEAR(SalesShipmentNo);
                CLEAR(ItemLedgEntryNo);
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF GLEntry.FINDSET THEN BEGIN
                    REPEAT
                        GLEntry."Document Date" := RenumberDocument."New Posting Date";
                        GLEntry."Posting Date" := RenumberDocument."New Posting Date";
                        GLEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL GLEntry.NEXT = 0;
                END;
                CustLedgerEntry.RESET;
                CustLedgerEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF CustLedgerEntry.FINDSET THEN BEGIN
                    REPEAT
                        CustLedgerEntry."Document Date" := RenumberDocument."New Posting Date";
                        CustLedgerEntry."Posting Date" := RenumberDocument."New Posting Date";
                        CustLedgerEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL CustLedgerEntry.NEXT = 0;
                END;

                SalesCrMemoHeader.RESET;
                SalesCrMemoHeader.SETRANGE("No.", RenumberDocument."Old Invoice No.");
                IF SalesCrMemoHeader.FINDFIRST THEN BEGIN
                    SalesOrderNo := SalesCrMemoHeader."Return Order No.";
                    SalesCrMemoHeader."Document Date" := RenumberDocument."New Posting Date";
                    SalesCrMemoHeader."Posting Date" := RenumberDocument."New Posting Date";
                    SalesCrMemoHeader.MODIFY;
                    RenumberDocument.Updated := TRUE;
                    RenumberDocument.MODIFY;
                END;

                SalesCrMemoLine.RESET;
                SalesCrMemoLine.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF SalesCrMemoLine.FINDFIRST THEN BEGIN
                    REPEAT
                        SalesCrMemoLine."Shipment Date" := RenumberDocument."New Posting Date";
                        SalesCrMemoLine."Posting Date" := RenumberDocument."New Posting Date";
                        SalesCrMemoLine.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL SalesCrMemoLine.NEXT = 0;
                END;

                VATEntry.RESET;
                VATEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF VATEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        VATEntry."Document Date" := RenumberDocument."New Posting Date";
                        VATEntry."Posting Date" := RenumberDocument."New Posting Date";
                        VATEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL VATEntry.NEXT = 0;
                END;

                DetailedCustLedgEntry.RESET;
                DetailedCustLedgEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF DetailedCustLedgEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        DetailedCustLedgEntry."Posting Date" := RenumberDocument."New Posting Date";
                        DetailedCustLedgEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL DetailedCustLedgEntry.NEXT = 0;
                END;

                ValueEntry.RESET;
                ValueEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF ValueEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        ValueEntry."Document Date" := RenumberDocument."New Posting Date";
                        ValueEntry."Posting Date" := RenumberDocument."New Posting Date";
                        ValueEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL ValueEntry.NEXT = 0;
                END;

                InvoiceMaterializeView.RESET;
                InvoiceMaterializeView.SETRANGE("Document Type", InvoiceMaterializeView."Document Type"::"Sales Invoice");
                InvoiceMaterializeView.SETRANGE("Bill No", RenumberDocument."Old Invoice No.");
                IF InvoiceMaterializeView.FINDFIRST THEN BEGIN
                    InvoiceMaterializeView."Bill Date" := RenumberDocument."New Posting Date";
                    InvoiceMaterializeView.MODIFY;
                    RenumberDocument.Updated := TRUE;
                    RenumberDocument.MODIFY;
                END;

                CLEAR(SalesOrderNo);
                ServiceInvoiceHeader.RESET;
                ServiceInvoiceHeader.SETRANGE("No.", RenumberDocument."Old Invoice No.");
                IF ServiceInvoiceHeader.FINDFIRST THEN BEGIN
                    SalesOrderNo := ServiceInvoiceHeader."Order No.";
                    ServiceInvoiceHeader."Posting Date" := RenumberDocument."New Posting Date";
                    ServiceInvoiceHeader."Document Date" := RenumberDocument."New Posting Date";
                    ServiceInvoiceHeader."Order Date" := RenumberDocument."New Posting Date";
                    ServiceInvoiceHeader.MODIFY;
                    ServiceInvoiceLine.RESET;
                    ServiceInvoiceLine.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                    IF ServiceInvoiceLine.FINDSET THEN
                        REPEAT
                            ServiceInvoiceLine."Posting Date" := RenumberDocument."New Posting Date";
                            ServiceInvoiceLine.MODIFY;
                        UNTIL ServiceInvoiceLine.NEXT = 0;
                    RenumberDocument.Updated := TRUE;
                    RenumberDocument.MODIFY;
                END;

                IF SalesOrderNo <> '' THEN BEGIN
                    ServiceShipmentHeader.RESET;
                    ServiceShipmentHeader.SETRANGE("Order No.", SalesOrderNo);
                    IF ServiceShipmentHeader.FINDFIRST THEN BEGIN
                        ServiceShipmentHeader."Document Date" := RenumberDocument."New Posting Date";
                        ServiceShipmentHeader."Order Date" := RenumberDocument."New Posting Date";
                        ServiceShipmentHeader."Posting Date" := RenumberDocument."New Posting Date";
                        ServiceShipmentHeader.MODIFY;
                        ServiceShipmentLine.RESET;
                        ServiceShipmentLine.SETRANGE("Document No.", ServiceShipmentHeader."No.");
                        IF ServiceShipmentLine.FINDSET THEN
                            REPEAT
                                ServiceShipmentLine."Posting Date" := RenumberDocument."New Posting Date";
                                ServiceShipmentLine.MODIFY;
                            UNTIL ServiceShipmentLine.NEXT = 0;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    END;
                END;
                //Service Ledger Entry
                ServiceLedgEntry.RESET;
                ServiceLedgEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF ServiceLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Service Ledger Entry EDMS');
                    REPEAT
                        RecServiceLedgEntry := ServiceLedgEntry;
                        RecServiceLedgEntry."Posting Date" := RenumberDocument."New Posting Date";
                        RecServiceLedgEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL ServiceLedgEntry.NEXT = 0;
                END;
                //Resource Ledger Entry
                ResourceLedgerEntry.RESET;
                ResourceLedgerEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF ResourceLedgerEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Resource Ledger Entry');
                    REPEAT
                        RecResourceLedgerEntry := ResourceLedgerEntry;
                        RecResourceLedgerEntry."Posting Date" := RenumberDocument."New Posting Date";
                        RecResourceLedgerEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL ResourceLedgerEntry.NEXT = 0;
                END;

                BankAccountLedgerEntry.RESET;
                BankAccountLedgerEntry.SETRANGE("Document No.", RenumberDocument."Old Invoice No.");
                IF BankAccountLedgerEntry.FINDSET THEN
                    REPEAT
                        BankAccountLedgerEntry."Document Date" := RenumberDocument."New Posting Date";
                        BankAccountLedgerEntry."Posting Date" := RenumberDocument."New Posting Date";
                        BankAccountLedgerEntry.MODIFY;
                        RenumberDocument.Updated := TRUE;
                        RenumberDocument.MODIFY;
                    UNTIL BankAccountLedgerEntry.NEXT = 0;

                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);

            UNTIL RenumberDocument.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure StartProcessingDocumentNoSalesCreditMemo()
    var
        GLEntry: Record "17";
        CustLedgerEntry: Record "21";
        ItemLedgerEntry: Record "32";
        SalesCommentLine: Record "44";
        VATEntry: Record "254";
        BankAccLedgEntry: Record "271";
        DetailedCustLedgEntry: Record "379";
        ValueEntry: Record "5802";
        ServiceLedgEntry: Record "25006167";
        ReNumberingData: Record "90000";
        SalesInvoicePrintHistory: Record "50002";
        InvoiceMaterializeView: Record "33020293";
        InvoiceMaterializeViewMerged: Record "33020293";
        ServiceCommentLine: Record "5906";
        ServiceInvoiceHeader: Record "5992";
        ServiceInvoiceLine: Record "5993";
        ResourceLedgerEntry: Record "203";
        IDofTable: Integer;
        RecCount: Integer;
        LineNo: Integer;
        "--Rec": Integer;
        RecGLEntry: Record "17";
        RecCustLedgerEntry: Record "21";
        RecItemLedgerEntry: Record "32";
        RecSalesCommentLine: Record "44";
        RecSalesInvoiceHeader: Record "112";
        RecSalesInvoiceLine: Record "113";
        RecVATEntry: Record "254";
        RecBankAccLedgEntry: Record "271";
        RecDetailedCustLedgEntry: Record "379";
        RecValueEntry: Record "5802";
        RecServiceLedgEntry: Record "25006167";
        RecInvoiceMaterializeView: Record "33020293";
        RecSalesInvoicePrintHistory: Record "50002";
        RecServiceCommentLine: Record "5906";
        RecServiceInvoiceHeader: Record "5992";
        RecServiceInvoiceLine: Record "5993";
        RecResourceLedgerEntry: Record "203";
        SalesCrMemoHeader: Record "114";
        SalesCrMemoLine: Record "115";
        ReturnReceiptHeader: Record "6660";
        ReturnReceiptLine: Record "6661";
        RecSalesCrMemoHeader: Record "114";
        RecSalesCrMemoLine: Record "115";
    begin

        ProgressWindow.OPEN(Text000);
        ReNumberingData.RESET;
        IF ReNumberingData.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, ReNumberingData.COUNT);
            REPEAT
                ReNumberingData.TESTFIELD(Updated, FALSE);
                ReNumberingData.TESTFIELD("New Invoice No.");
                ReNumberingData.TESTFIELD("Old Invoice No.");
                CheckPostedSalesandServiceInvoiceNo(ReNumberingData."New Invoice No.");
                //G/L Entry->Document No.
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF GLEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'G/L Entry');
                    REPEAT
                        RecGLEntry := GLEntry;
                        RecGLEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecGLEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL GLEntry.NEXT = 0;
                END;
                //Cust. Ledger Entry->Document No.
                CustLedgerEntry.RESET;
                CustLedgerEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF CustLedgerEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Cust. Ledger Entry');
                    REPEAT
                        RecCustLedgerEntry := CustLedgerEntry;
                        RecCustLedgerEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecCustLedgerEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL CustLedgerEntry.NEXT = 0;
                END;
                //Item Ledger Entry->Document No.
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF ItemLedgerEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Item Ledger Entry');
                    REPEAT
                        RecItemLedgerEntry := ItemLedgerEntry;
                        RecItemLedgerEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecItemLedgerEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ItemLedgerEntry.NEXT = 0;
                END;
                //Sales Comment Line->No.
                SalesCommentLine.RESET;
                SalesCommentLine.SETRANGE("No.", ReNumberingData."Old Invoice No.");
                IF SalesCommentLine.FINDFIRST THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Sales Comment Line');
                    REPEAT
                        RecSalesCommentLine := SalesCommentLine;
                        RecSalesCommentLine.RENAME(SalesCommentLine."Document Type"::"Posted Invoice", ReNumberingData."New Invoice No.", SalesCommentLine."Document Line No.", SalesCommentLine."Line No.");
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL SalesCommentLine.NEXT = 0;
                END;
                //Sales Invoice Header->No.
                LineNo := 0;
                IF NOT ReNumberingData.Merge THEN BEGIN
                    SalesCrMemoHeader.RESET;
                    SalesCrMemoHeader.SETRANGE("No.", ReNumberingData."Old Invoice No.");
                    IF SalesCrMemoHeader.FINDSET THEN BEGIN
                        ProgressWindow.UPDATE(3, 'Sales Invoice Header');
                        BEGIN
                            RecSalesCrMemoHeader := SalesCrMemoHeader;
                            RecSalesCrMemoHeader.RENAME(ReNumberingData."New Invoice No.");
                            ReNumberingData.Updated := TRUE;
                            ReNumberingData.MODIFY;
                        END;
                    END
                END ELSE BEGIN
                    SalesCrMemoLine.RESET;
                    SalesCrMemoLine.SETRANGE("Document No.", ReNumberingData."New Invoice No.");
                    IF SalesCrMemoLine.FINDLAST THEN BEGIN
                        LineNo += SalesCrMemoLine."Line No.";
                    END;
                    SalesCrMemoHeader.RESET;
                    SalesCrMemoHeader.SETRANGE("No.", ReNumberingData."Old Invoice No.");
                    IF SalesCrMemoHeader.FINDFIRST THEN
                        SalesCrMemoHeader.DELETE;
                END;
                //Sales Invoice Line->Document No.
                SalesCrMemoLine.RESET;
                SalesCrMemoLine.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF SalesCrMemoLine.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Sales Invoice Line');
                    REPEAT
                        IF ReNumberingData.Merge THEN
                            LineNo += 10000
                        ELSE
                            LineNo := SalesCrMemoLine."Line No.";

                        RecSalesCrMemoLine := SalesCrMemoLine;
                        RecSalesCrMemoLine.RENAME(ReNumberingData."New Invoice No.", LineNo);
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL SalesCrMemoLine.NEXT = 0;
                END;

                //VAT Entry->Document No.
                VATEntry.RESET;
                VATEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF VATEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'VAT Entry');
                    REPEAT
                        RecVATEntry := VATEntry;
                        RecVATEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecVATEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL VATEntry.NEXT = 0;
                END;

                //Bank Account Ledger Entry->Document No.
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF BankAccLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Bank Account Ledger Entry');
                    REPEAT
                        RecBankAccLedgEntry := BankAccLedgEntry;
                        RecBankAccLedgEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecBankAccLedgEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL BankAccLedgEntry.NEXT = 0;
                END;

                //Detailed Cust. Ledg. Entry->Document No.
                DetailedCustLedgEntry.RESET;
                DetailedCustLedgEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF DetailedCustLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Detailed Cust. Ledg. Entry');
                    REPEAT
                        RecDetailedCustLedgEntry := DetailedCustLedgEntry;
                        RecDetailedCustLedgEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecDetailedCustLedgEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL DetailedCustLedgEntry.NEXT = 0;
                END;

                //Value Entry->Document No.
                ValueEntry.RESET;
                ValueEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF ValueEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Value Entry');
                    REPEAT
                        RecValueEntry := ValueEntry;
                        RecValueEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecValueEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ValueEntry.NEXT = 0;
                END;

                //Service Ledger Entry EDMS->Document No.
                ServiceLedgEntry.RESET;
                ServiceLedgEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF ServiceLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Service Ledger Entry EDMS');
                    REPEAT
                        RecServiceLedgEntry := ServiceLedgEntry;
                        RecServiceLedgEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecServiceLedgEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ServiceLedgEntry.NEXT = 0;
                END;

                //Resource Ledger Entry
                ResourceLedgerEntry.RESET;
                ResourceLedgerEntry.SETRANGE("Document No.", ReNumberingData."Old Invoice No.");
                IF ResourceLedgerEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, 'Resource Ledger Entry');
                    REPEAT
                        RecResourceLedgerEntry := ResourceLedgerEntry;
                        RecResourceLedgerEntry."Document No." := ReNumberingData."New Invoice No.";
                        RecResourceLedgerEntry.MODIFY;
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ResourceLedgerEntry.NEXT = 0;
                END;

                IF NOT ReNumberingData.Merge THEN BEGIN
                    InvoiceMaterializeView.RESET;
                    InvoiceMaterializeView.SETRANGE("Document Type", InvoiceMaterializeView."Document Type"::"Sales Invoice");
                    InvoiceMaterializeView.SETRANGE("Bill No", ReNumberingData."Old Invoice No.");
                    IF InvoiceMaterializeView.FINDFIRST THEN BEGIN
                        ProgressWindow.UPDATE(3, 'Invoice Materialize View');
                        RecInvoiceMaterializeView := InvoiceMaterializeView;
                        RecInvoiceMaterializeView.RENAME(InvoiceMaterializeView."Table ID", InvoiceMaterializeView."Document Type", ReNumberingData."New Invoice No.", InvoiceMaterializeView."Fiscal Year");
                        ReNumberingData.Updated := TRUE;
                        ReNumberingData.MODIFY;
                    END;
                END ELSE BEGIN
                    InvoiceMaterializeView.RESET;
                    InvoiceMaterializeView.SETRANGE("Document Type", InvoiceMaterializeView."Document Type"::"Sales Invoice");
                    InvoiceMaterializeView.SETRANGE("Bill No", ReNumberingData."Old Invoice No.");
                    IF InvoiceMaterializeView.FINDFIRST THEN BEGIN
                        ProgressWindow.UPDATE(3, 'Invoice Materialize View');
                        InvoiceMaterializeViewMerged.RESET;
                        InvoiceMaterializeViewMerged.SETRANGE("Document Type", InvoiceMaterializeView."Document Type"::"Sales Invoice");
                        InvoiceMaterializeViewMerged.SETRANGE("Bill No", ReNumberingData."New Invoice No.");
                        IF InvoiceMaterializeViewMerged.FINDFIRST THEN BEGIN
                            InvoiceMaterializeViewMerged.Amount += InvoiceMaterializeView.Amount;
                            InvoiceMaterializeViewMerged.Discount += InvoiceMaterializeView.Discount;
                            InvoiceMaterializeViewMerged."Taxable Amount" += InvoiceMaterializeView."Taxable Amount";
                            InvoiceMaterializeViewMerged."TAX Amount" += InvoiceMaterializeView."TAX Amount";
                            InvoiceMaterializeViewMerged."Total Amount" += InvoiceMaterializeView."Total Amount";
                            InvoiceMaterializeViewMerged.MODIFY;
                        END;
                        InvoiceMaterializeView.DELETE;
                    END;
                END;

                IF NOT ReNumberingData.Merge THEN BEGIN
                    /*
                    SalesInvoicePrintHistory.RESET;
                    SalesInvoicePrintHistory.SETRANGE("Document Type",SalesInvoicePrintHistory."Document Type"::"Sales Invoice");
                    SalesInvoicePrintHistory.SETRANGE("Document No.",ReNumberingData."Old Invoice No.");
                    IF SalesInvoicePrintHistory.FINDFIRST THEN BEGIN
                      ProgressWindow.UPDATE(3,'Sales Invoice Print History');
                      RecSalesInvoicePrintHistory := SalesInvoicePrintHistory;
                      RecSalesInvoicePrintHistory.RENAME(SalesInvoicePrintHistory."Table ID",SalesInvoicePrintHistory."Document Type",ReNumberingData."New Invoice No.",SalesInvoicePrintHistory."Fiscal Year",SalesInvoicePrintHistory."Line No.");
                      ReNumberingData.Updated := TRUE;
                      ReNumberingData.MODIFY;
                    END;
                    */
                END;
                /*
                ServiceInvoiceHeader.RESET;
                ServiceInvoiceHeader.SETRANGE("No.",ReNumberingData."Old Invoice No.");
                IF ServiceInvoiceHeader.FINDFIRST THEN BEGIN
                  ProgressWindow.UPDATE(3,'Service Invoice Header');
                  RecServiceInvoiceHeader := ServiceInvoiceHeader;
                  RecServiceInvoiceHeader.RENAME(ReNumberingData."New Invoice No.");
                  ReNumberingData.Updated := TRUE;
                  ReNumberingData.MODIFY;
                END;

                ServiceInvoiceLine.RESET;
                ServiceInvoiceLine.SETRANGE("Document No.",ReNumberingData."Old Invoice No.");
                IF ServiceInvoiceLine.FINDSET THEN REPEAT
                  ProgressWindow.UPDATE(3,'Service Invoice Line');
                  RecServiceInvoiceLine := ServiceInvoiceLine;
                  RecServiceInvoiceLine.RENAME(ReNumberingData."New Invoice No.",ServiceInvoiceLine."Line No.");//
                  ReNumberingData.Updated := TRUE;
                  ReNumberingData.MODIFY;
                UNTIL ServiceInvoiceLine.NEXT = 0;
                */
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);

            UNTIL ReNumberingData.NEXT = 0;
        END;

    end;
}


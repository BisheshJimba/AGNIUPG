codeunit 50012 "Item Charge Assgnt Purch."
{
    Permissions = TableData 38 = r,
                  TableData 39 = r,
                  TableData 121 = r,
                  TableData 50012 = imd,
                  TableData 6651 = r;

    trigger OnRun()
    begin
    end;

    var
        Text000: Label '&Equally,&Amount';
        "--KMT2016CU5--": Integer;
        ILE: Record "32";

    [Scope('Internal')]
    procedure InsertItemChargeAssgnt(ItemChargeAssgntPurch: Record "5805"; ApplToDocType: Option; ApplToDocNo2: Code[20]; ApplToDocLineNo2: Integer; ItemNo2: Code[20]; Description2: Text[50]; var NextLineNo: Integer)
    var
        ItemChargeAssgntPurch2: Record "5805";
    begin
        NextLineNo := NextLineNo + 10000;

        ItemChargeAssgntPurch2.INIT;
        ItemChargeAssgntPurch2."Document Type" := ItemChargeAssgntPurch."Document Type";
        ItemChargeAssgntPurch2."Document No." := ItemChargeAssgntPurch."Document No.";
        ItemChargeAssgntPurch2."Document Line No." := ItemChargeAssgntPurch."Document Line No.";
        ItemChargeAssgntPurch2."Line No." := NextLineNo;
        ItemChargeAssgntPurch2."Item Charge No." := ItemChargeAssgntPurch."Item Charge No.";
        ItemChargeAssgntPurch2."Applies-to Doc. Type" := ApplToDocType;
        ItemChargeAssgntPurch2."Applies-to Doc. No." := ApplToDocNo2;
        ItemChargeAssgntPurch2."Applies-to Doc. Line No." := ApplToDocLineNo2;
        ItemChargeAssgntPurch2."Item No." := ItemNo2;
        ItemChargeAssgntPurch2.Description := Description2;
        ItemChargeAssgntPurch2."Unit Cost" := ItemChargeAssgntPurch."Unit Cost";
        //KMT2016CU5 >>
        //ItemChargeAssgntPurch2.PragyapanPatra := ItemChargeAssgntPurch.PragyapanPatra;
        //ItemChargeAssgntPurch2."Letter of Credit/Telex Trans." := ItemChargeAssgntPurch."Letter of Credit/Telex Trans.";
        //KMT2016CU5 <<
        ItemChargeAssgntPurch2.INSERT;
    end;

    [Scope('Internal')]
    procedure CreateDocChargeAssgnt(LastItemChargeAssgntPurch: Record "5805"; ReceiptNo: Code[20])
    var
        FromPurchLine: Record "39";
        ItemChargeAssgntPurch: Record "5805";
        NextLineNo: Integer;
    begin
        FromPurchLine.SETRANGE("Document Type", LastItemChargeAssgntPurch."Document Type");
        FromPurchLine.SETRANGE("Document No.", LastItemChargeAssgntPurch."Document No.");
        FromPurchLine.SETRANGE(Type, FromPurchLine.Type::Item);
        IF FromPurchLine.FIND('-') THEN BEGIN
            NextLineNo := LastItemChargeAssgntPurch."Line No.";
            ItemChargeAssgntPurch.RESET;
            ItemChargeAssgntPurch.SETRANGE("Document Type", LastItemChargeAssgntPurch."Document Type");
            ItemChargeAssgntPurch.SETRANGE("Document No.", LastItemChargeAssgntPurch."Document No.");
            ItemChargeAssgntPurch.SETRANGE("Document Line No.", LastItemChargeAssgntPurch."Document Line No.");
            ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.", LastItemChargeAssgntPurch."Document No.");
            REPEAT
                IF (FromPurchLine.Quantity <> 0) AND
                   (FromPurchLine.Quantity <> FromPurchLine."Quantity Invoiced") AND
                   (FromPurchLine."Work Center No." = '') AND
                   ((ReceiptNo = '') OR (FromPurchLine."Receipt No." = ReceiptNo)) AND
                   FromPurchLine."Allow Item Charge Assignment"
                THEN BEGIN
                    ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.", FromPurchLine."Line No.");
                    IF NOT ItemChargeAssgntPurch.FINDFIRST THEN
                        InsertItemChargeAssgnt(
                          LastItemChargeAssgntPurch, FromPurchLine."Document Type",
                          FromPurchLine."Document No.", FromPurchLine."Line No.",
                          FromPurchLine."No.", FromPurchLine.Description, NextLineNo);
                END;
            UNTIL FromPurchLine.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure CreateRcptChargeAssgnt(var FromPurchRcptLine: Record "121"; ItemChargeAssgntPurch: Record "5805")
    var
        ItemChargeAssgntPurch2: Record "5805";
        NextLine: Integer;
    begin
        FromPurchRcptLine.TESTFIELD("Work Center No.", '');
        NextLine := ItemChargeAssgntPurch."Line No.";
        ItemChargeAssgntPurch2.SETRANGE("Document Type", ItemChargeAssgntPurch."Document Type");
        ItemChargeAssgntPurch2.SETRANGE("Document No.", ItemChargeAssgntPurch."Document No.");
        ItemChargeAssgntPurch2.SETRANGE("Document Line No.", ItemChargeAssgntPurch."Document Line No.");
        ItemChargeAssgntPurch2.SETRANGE(
          "Applies-to Doc. Type", ItemChargeAssgntPurch2."Applies-to Doc. Type"::Receipt);
        REPEAT
            ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. No.", FromPurchRcptLine."Document No.");
            ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. Line No.", FromPurchRcptLine."Line No.");
            IF NOT ItemChargeAssgntPurch2.FINDFIRST THEN
                InsertItemChargeAssgnt(ItemChargeAssgntPurch, ItemChargeAssgntPurch2."Applies-to Doc. Type"::Receipt,
                  FromPurchRcptLine."Document No.", FromPurchRcptLine."Line No.",
                  FromPurchRcptLine."No.", FromPurchRcptLine.Description, NextLine);
        UNTIL FromPurchRcptLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CreateTransferRcptChargeAssgnt(var FromTransRcptLine: Record "5747"; ItemChargeAssgntPurch: Record "5805")
    var
        ItemChargeAssgntPurch2: Record "5805";
        NextLine: Integer;
    begin
        NextLine := ItemChargeAssgntPurch."Line No.";
        ItemChargeAssgntPurch2.SETRANGE("Document Type", ItemChargeAssgntPurch."Document Type");
        ItemChargeAssgntPurch2.SETRANGE("Document No.", ItemChargeAssgntPurch."Document No.");
        ItemChargeAssgntPurch2.SETRANGE("Document Line No.", ItemChargeAssgntPurch."Document Line No.");
        ItemChargeAssgntPurch2.SETRANGE(
          "Applies-to Doc. Type", ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Transfer Receipt");
        REPEAT
            ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. No.", FromTransRcptLine."Document No.");
            ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. Line No.", FromTransRcptLine."Line No.");
            IF NOT ItemChargeAssgntPurch2.FINDFIRST THEN
                InsertItemChargeAssgnt(ItemChargeAssgntPurch, ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Transfer Receipt",
                  FromTransRcptLine."Document No.", FromTransRcptLine."Line No.",
                  FromTransRcptLine."Item No.", FromTransRcptLine.Description, NextLine);
        UNTIL FromTransRcptLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CreateShptChargeAssgnt(var FromReturnShptLine: Record "6651"; ItemChargeAssgntPurch: Record "5805")
    var
        ItemChargeAssgntPurch2: Record "5805";
        NextLine: Integer;
    begin
        FromReturnShptLine.TESTFIELD("Job No.", '');
        NextLine := ItemChargeAssgntPurch."Line No.";
        ItemChargeAssgntPurch2.SETRANGE("Document Type", ItemChargeAssgntPurch."Document Type");
        ItemChargeAssgntPurch2.SETRANGE("Document No.", ItemChargeAssgntPurch."Document No.");
        ItemChargeAssgntPurch2.SETRANGE("Document Line No.", ItemChargeAssgntPurch."Document Line No.");
        ItemChargeAssgntPurch2.SETRANGE(
          "Applies-to Doc. Type", ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Return Shipment");
        REPEAT
            ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. No.", FromReturnShptLine."Document No.");
            ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. Line No.", FromReturnShptLine."Line No.");
            IF NOT ItemChargeAssgntPurch2.FINDFIRST THEN
                InsertItemChargeAssgnt(ItemChargeAssgntPurch, ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Return Shipment",
                  FromReturnShptLine."Document No.", FromReturnShptLine."Line No.",
                  FromReturnShptLine."No.", FromReturnShptLine.Description, NextLine);
        UNTIL FromReturnShptLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CreateSalesShptChargeAssgnt(var FromSalesShptLine: Record "111"; ItemChargeAssgntPurch: Record "5805")
    var
        ItemChargeAssgntPurch2: Record "5805";
        NextLine: Integer;
    begin
        FromSalesShptLine.TESTFIELD("Job No.", '');
        NextLine := ItemChargeAssgntPurch."Line No.";
        ItemChargeAssgntPurch2.SETRANGE("Document Type", ItemChargeAssgntPurch."Document Type");
        ItemChargeAssgntPurch2.SETRANGE("Document No.", ItemChargeAssgntPurch."Document No.");
        ItemChargeAssgntPurch2.SETRANGE("Document Line No.", ItemChargeAssgntPurch."Document Line No.");
        ItemChargeAssgntPurch2.SETRANGE(
          "Applies-to Doc. Type", ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Sales Shipment");
        REPEAT
            ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. No.", FromSalesShptLine."Document No.");
            ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. Line No.", FromSalesShptLine."Line No.");
            IF NOT ItemChargeAssgntPurch2.FINDFIRST THEN
                InsertItemChargeAssgnt(ItemChargeAssgntPurch, ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Sales Shipment",
                  FromSalesShptLine."Document No.", FromSalesShptLine."Line No.",
                  FromSalesShptLine."No.", FromSalesShptLine.Description, NextLine);
        UNTIL FromSalesShptLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CreateReturnRcptChargeAssgnt(var FromReturnRcptLine: Record "6661"; ItemChargeAssgntPurch: Record "5805")
    var
        ItemChargeAssgntPurch2: Record "5805";
        NextLine: Integer;
    begin
        FromReturnRcptLine.TESTFIELD("Job No.", '');
        NextLine := ItemChargeAssgntPurch."Line No.";
        ItemChargeAssgntPurch2.SETRANGE("Document Type", ItemChargeAssgntPurch."Document Type");
        ItemChargeAssgntPurch2.SETRANGE("Document No.", ItemChargeAssgntPurch."Document No.");
        ItemChargeAssgntPurch2.SETRANGE("Document Line No.", ItemChargeAssgntPurch."Document Line No.");
        ItemChargeAssgntPurch2.SETRANGE(
          "Applies-to Doc. Type", ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Return Receipt");
        REPEAT
            ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. No.", FromReturnRcptLine."Document No.");
            ItemChargeAssgntPurch2.SETRANGE("Applies-to Doc. Line No.", FromReturnRcptLine."Line No.");
            IF NOT ItemChargeAssgntPurch2.FINDFIRST THEN
                InsertItemChargeAssgnt(ItemChargeAssgntPurch, ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Return Receipt",
                  FromReturnRcptLine."Document No.", FromReturnRcptLine."Line No.",
                  FromReturnRcptLine."No.", FromReturnRcptLine.Description, NextLine);
        UNTIL FromReturnRcptLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SuggestAssgnt(PurchLine2: Record "39"; TotalQtyToAssign: Decimal; TotalAmtToAssign: Decimal)
    var
        Selection: Integer;
    begin
        Selection := STRMENU(Text000, 2);
        IF Selection = 0 THEN
            EXIT;
        SuggestAssgnt2(PurchLine2, TotalQtyToAssign, TotalAmtToAssign, Selection);
    end;

    [Scope('Internal')]
    procedure SuggestAssgnt2(PurchLine2: Record "39"; TotalQtyToAssign: Decimal; TotalAmtToAssign: Decimal; Selection: Integer)
    var
        Currency: Record "4";
        CurrExchRate: Record "330";
        PurchHeader: Record "38";
        PurchLine: Record "39";
        PurchRcptLine: Record "121";
        ReturnShptLine: Record "6651";
        SalesShptLine: Record "111";
        ReturnRcptLine: Record "6661";
        ItemChargeAssgntPurch2: Record "5805";
        TempItemChargeAssgntPurch: Record "5805" temporary;
        CurrencyCode: Code[10];
        TotalAppliesToDocLineAmount: Decimal;
        RemainingNumOfLines: Integer;
        PurchRcptLine1: Record "121";
    begin
        PurchHeader.GET(PurchLine2."Document Type", PurchLine2."Document No.");
        IF NOT Currency.GET(PurchLine2."Currency Code") THEN
            Currency.InitRoundingPrecision;
        ItemChargeAssgntPurch2.SETRANGE("Document Type", PurchLine2."Document Type");
        ItemChargeAssgntPurch2.SETRANGE("Document No.", PurchLine2."Document No.");
        ItemChargeAssgntPurch2.SETRANGE("Document Line No.", PurchLine2."Line No.");
        IF ItemChargeAssgntPurch2.FIND('-') THEN BEGIN
            IF Selection = 1 THEN BEGIN
                REPEAT
                    /*//KMT2016CU5 >>
                    PurchRcptLine1.SETRANGE("Document No.",ItemChargeAssgntPurch2."Applies-to Doc. No.");
                    IF PurchRcptLine1.FINDFIRST THEN BEGIN
                      ItemChargeAssgntPurch2.PragyapanPatra := PurchRcptLine1.PragyapanPatra;
                      ItemChargeAssgntPurch2."Letter of Credit/Telex Trans." := PurchRcptLine1."Letter of Credit/Telex Trans.";
                      ItemChargeAssgntPurch2.MODIFY;
                    END;
                    //KMT2016CU5 <<*/
                    IF NOT ItemChargeAssgntPurch2.PurchLineInvoiced THEN BEGIN
                        TempItemChargeAssgntPurch.INIT;
                        TempItemChargeAssgntPurch := ItemChargeAssgntPurch2;
                        TempItemChargeAssgntPurch.INSERT;
                    END;
                UNTIL ItemChargeAssgntPurch2.NEXT = 0;

                IF TempItemChargeAssgntPurch.FIND('-') THEN BEGIN
                    RemainingNumOfLines := TempItemChargeAssgntPurch.COUNT;
                    REPEAT
                        ItemChargeAssgntPurch2.GET(
                          TempItemChargeAssgntPurch."Document Type",
                          TempItemChargeAssgntPurch."Document No.",
                          TempItemChargeAssgntPurch."Document Line No.",
                          TempItemChargeAssgntPurch."Line No.");
                        ItemChargeAssgntPurch2."Qty. to Assign" := ROUND(TotalQtyToAssign / RemainingNumOfLines, 0.00001);
                        ItemChargeAssgntPurch2."Amount to Assign" :=
                          ROUND(
                            ItemChargeAssgntPurch2."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                            Currency."Amount Rounding Precision");
                        ItemChargeAssgntPurch2."Unit Cost" :=
                          ROUND(ItemChargeAssgntPurch2."Amount to Assign" / ItemChargeAssgntPurch2."Qty. to Assign",
                            Currency."Unit-Amount Rounding Precision");
                        TotalQtyToAssign -= ItemChargeAssgntPurch2."Qty. to Assign";
                        TotalAmtToAssign -= ItemChargeAssgntPurch2."Amount to Assign";
                        RemainingNumOfLines := RemainingNumOfLines - 1;
                        ItemChargeAssgntPurch2.MODIFY;
                    UNTIL TempItemChargeAssgntPurch.NEXT = 0;
                END;
            END ELSE BEGIN
                REPEAT
                    /*//KMT2016CU5 >>
                    PurchRcptLine1.SETRANGE("Document No.",ItemChargeAssgntPurch2."Applies-to Doc. No.");
                    IF PurchRcptLine1.FINDFIRST THEN BEGIN
                      ItemChargeAssgntPurch2.PragyapanPatra := PurchRcptLine1.PragyapanPatra;
                      ItemChargeAssgntPurch2."Letter of Credit/Telex Trans." := PurchRcptLine1."Letter of Credit/Telex Trans.";
                      ItemChargeAssgntPurch2.MODIFY;
                    END;
                    //KMT2016CU5 <<*/
                    IF NOT ItemChargeAssgntPurch2.PurchLineInvoiced THEN BEGIN
                        TempItemChargeAssgntPurch.INIT;
                        TempItemChargeAssgntPurch := ItemChargeAssgntPurch2;
                        CASE ItemChargeAssgntPurch2."Applies-to Doc. Type" OF
                            ItemChargeAssgntPurch2."Applies-to Doc. Type"::Quote,
                            ItemChargeAssgntPurch2."Applies-to Doc. Type"::Order,
                            ItemChargeAssgntPurch2."Applies-to Doc. Type"::Invoice,
                            ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Return Order",
                            ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Credit Memo":
                                BEGIN
                                    PurchLine.GET(
                                      ItemChargeAssgntPurch2."Applies-to Doc. Type",
                                      ItemChargeAssgntPurch2."Applies-to Doc. No.",
                                      ItemChargeAssgntPurch2."Applies-to Doc. Line No.");
                                    TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                      ABS(PurchLine."Line Amount");
                                END;
                            ItemChargeAssgntPurch2."Applies-to Doc. Type"::Receipt:
                                BEGIN
                                    PurchRcptLine.GET(
                                      ItemChargeAssgntPurch2."Applies-to Doc. No.",
                                      ItemChargeAssgntPurch2."Applies-to Doc. Line No.");
                                    CurrencyCode := PurchRcptLine.GetCurrencyCodeFromHeader;
                                    //STD Code
                                    /*IF CurrencyCode = PurchHeader."Currency Code" THEN
                                      TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                        ABS(PurchRcptLine."Item Charge Base Amount")
                                    ELSE
                                      TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                        CurrExchRate.ExchangeAmtFCYToFCY(
                                          PurchHeader."Posting Date",CurrencyCode,PurchHeader."Currency Code",
                                          ABS(PurchRcptLine."Item Charge Base Amount"));*/
                                    //  STD Code

                                    //KMT2016CU5  BEGIN>>
                                    IF CurrencyCode = PurchHeader."Currency Code" THEN BEGIN
                                        TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                          ABS(PurchRcptLine."Item Charge Base Amount");
                                        ILE.SETRANGE("Document No.", ItemChargeAssgntPurch2."Applies-to Doc. No.");
                                        ILE.SETRANGE("Document Line No.", ItemChargeAssgntPurch2."Applies-to Doc. Line No.");
                                        IF ILE.FINDFIRST THEN BEGIN
                                            TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                            CurrExchRate.ExchangeAmtFCYToFCY(
                                              PurchHeader."Posting Date", CurrencyCode, PurchHeader."Currency Code",
                                              ABS(ILE."Cost Amount (Actual)"));
                                        END;
                                        //MESSAGE(FORMAT(ABS(ILE."Cost Amount (Actual)")));
                                    END ELSE BEGIN
                                        TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                          CurrExchRate.ExchangeAmtFCYToFCY(
                                            PurchHeader."Posting Date", CurrencyCode, PurchHeader."Currency Code",
                                          ABS(PurchRcptLine."Item Charge Base Amount"));
                                        ILE.SETRANGE("Document No.", ItemChargeAssgntPurch2."Applies-to Doc. No.");
                                        ILE.SETRANGE("Document Line No.", ItemChargeAssgntPurch2."Applies-to Doc. Line No.");
                                        IF ILE.FINDFIRST THEN BEGIN
                                            ILE.CALCFIELDS("Cost Amount (Actual)");
                                            TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                            CurrExchRate.ExchangeAmtFCYToFCY(
                                              PurchHeader."Posting Date", CurrencyCode, PurchHeader."Currency Code",
                                              ABS(ILE."Cost Amount (Actual)"));
                                        END;
                                        //MESSAGE(FORMAT(ABS(ILE."Cost Amount (Actual)")));
                                    END;
                                    //KMT2016CU5 END <<
                                END;
                            ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Return Shipment":
                                BEGIN
                                    ReturnShptLine.GET(
                                      ItemChargeAssgntPurch2."Applies-to Doc. No.",
                                      ItemChargeAssgntPurch2."Applies-to Doc. Line No.");
                                    CurrencyCode := ReturnShptLine.GetCurrencyCode;
                                    IF CurrencyCode = PurchHeader."Currency Code" THEN
                                        TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                          ABS(ReturnShptLine."Item Charge Base Amount")
                                    ELSE
                                        TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                          CurrExchRate.ExchangeAmtFCYToFCY(
                                            PurchHeader."Posting Date", CurrencyCode, PurchHeader."Currency Code",
                                            ABS(ReturnShptLine."Item Charge Base Amount"));
                                END;
                            ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Sales Shipment":
                                BEGIN
                                    SalesShptLine.GET(
                                      ItemChargeAssgntPurch2."Applies-to Doc. No.",
                                      ItemChargeAssgntPurch2."Applies-to Doc. Line No.");
                                    CurrencyCode := SalesShptLine.GetCurrencyCode;
                                    IF CurrencyCode = PurchHeader."Currency Code" THEN
                                        TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                          ABS(SalesShptLine."Item Charge Base Amount")
                                    ELSE
                                        TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                          CurrExchRate.ExchangeAmtFCYToFCY(
                                            PurchHeader."Posting Date", CurrencyCode, PurchHeader."Currency Code",
                                            ABS(SalesShptLine."Item Charge Base Amount"));
                                END;
                            ItemChargeAssgntPurch2."Applies-to Doc. Type"::"Return Receipt":
                                BEGIN
                                    ReturnRcptLine.GET(
                                      ItemChargeAssgntPurch2."Applies-to Doc. No.",
                                      ItemChargeAssgntPurch2."Applies-to Doc. Line No.");
                                    CurrencyCode := ReturnRcptLine.GetCurrencyCode;
                                    IF CurrencyCode = PurchHeader."Currency Code" THEN
                                        TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                          ABS(ReturnRcptLine."Item Charge Base Amount")
                                    ELSE
                                        TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" :=
                                          CurrExchRate.ExchangeAmtFCYToFCY(
                                            PurchHeader."Posting Date", CurrencyCode, PurchHeader."Currency Code",
                                            ABS(ReturnRcptLine."Item Charge Base Amount"));
                                END;
                        END;
                        IF TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" <> 0 THEN
                            TempItemChargeAssgntPurch.INSERT
                        ELSE BEGIN
                            ItemChargeAssgntPurch2."Amount to Assign" := 0;
                            ItemChargeAssgntPurch2."Qty. to Assign" := 0;
                            ItemChargeAssgntPurch2.MODIFY;
                        END;
                        TotalAppliesToDocLineAmount += TempItemChargeAssgntPurch."Applies-to Doc. Line Amount";
                    END;
                UNTIL ItemChargeAssgntPurch2.NEXT = 0;

                IF TempItemChargeAssgntPurch.FIND('-') THEN
                    REPEAT
                        ItemChargeAssgntPurch2.GET(
                          TempItemChargeAssgntPurch."Document Type",
                          TempItemChargeAssgntPurch."Document No.",
                          TempItemChargeAssgntPurch."Document Line No.",
                          TempItemChargeAssgntPurch."Line No.");
                        IF TotalQtyToAssign <> 0 THEN BEGIN
                            ItemChargeAssgntPurch2."Qty. to Assign" :=
                              ROUND(TempItemChargeAssgntPurch."Applies-to Doc. Line Amount" / TotalAppliesToDocLineAmount * TotalQtyToAssign,
                                0.00001);
                            ItemChargeAssgntPurch2."Amount to Assign" :=
                              ROUND(
                                ItemChargeAssgntPurch2."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                                Currency."Amount Rounding Precision");
                            IF ItemChargeAssgntPurch2."Qty. to Assign" <> 0 THEN
                                ItemChargeAssgntPurch2."Unit Cost" :=
                                  ROUND(ItemChargeAssgntPurch2."Amount to Assign" / ItemChargeAssgntPurch2."Qty. to Assign",
                                    Currency."Unit-Amount Rounding Precision");
                            TotalQtyToAssign -= ItemChargeAssgntPurch2."Qty. to Assign";
                            TotalAmtToAssign -= ItemChargeAssgntPurch2."Amount to Assign";
                            TotalAppliesToDocLineAmount -= TempItemChargeAssgntPurch."Applies-to Doc. Line Amount";
                            ItemChargeAssgntPurch2.MODIFY;
                        END;
                    UNTIL TempItemChargeAssgntPurch.NEXT = 0;
            END;
            TempItemChargeAssgntPurch.DELETEALL;
        END;

    end;
}


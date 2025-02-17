codeunit 33019831 "Spare Req. Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        PurchaseLine: Record "39";
        StockKeepingUnit: Record "5700";

    [Scope('Internal')]
    procedure ChangeLocationToCentralWhse(): Code[10]
    var
        UserSetup: Record "91";
        ResponsibilityCenter: Record "5714";
        DefaultLocation: Code[10];
        AccountabilityCenter: Record "33019846";
    begin
        // Sipradi-YS BEGIN >> SPR6.1.0 - 33019831.1
        CLEAR(DefaultLocation);
        UserSetup.GET(USERID);
        AccountabilityCenter.GET(UserSetup."Default Accountability Center");
        //ResponsibilityCenter.GET(UserSetup."Default Responsibility Center");
        //IF ResponsibilityCenter."Location Code" <> '' THEN BEGIN
        IF AccountabilityCenter."Location Code" <> '' THEN BEGIN
            DefaultLocation := AccountabilityCenter."Location Code";
            //DefaultLocation := ResponsibilityCenter."Location Code";
        END;
        EXIT(DefaultLocation);
        // Sipradi-YS END >> SPR6.1.0 - 33019831.1
    end;

    [Scope('Internal')]
    procedure MergePurchaseLines(var PurchaseHeader: Record "38")
    var
        i: Integer;
        DuplicateFound: Boolean;
        TempPurchaseLine: Record "39" temporary;
        TempPurchaseLine2: Record "39" temporary;
        TotalQty: Decimal;
        LastNo: Integer;
    begin
        // Sipradi-YS BEGIN >> SPR6.1.0 - 33019831.2
        PurchaseLine.SETCURRENTKEY("Document No.");
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        IF PurchaseLine.FINDFIRST THEN BEGIN
            REPEAT
                // Copying All Purchase Line to temporary table.
                TempPurchaseLine.INIT;
                TempPurchaseLine.COPY(PurchaseLine);
                TempPurchaseLine.INSERT;

                // Copying Distinct Item No. to temporary table.
                TempPurchaseLine2.RESET;
                TempPurchaseLine2.SETRANGE("No.", PurchaseLine."No.");
                IF NOT TempPurchaseLine2.FINDFIRST THEN BEGIN
                    TempPurchaseLine2.INIT;
                    TempPurchaseLine2."Line No." := LastNo + 1;
                    TempPurchaseLine2.Type := TempPurchaseLine2.Type::Item;
                    TempPurchaseLine2."No." := PurchaseLine."No.";
                    TempPurchaseLine2.INSERT;
                END;
                LastNo := LastNo + 1;
            UNTIL PurchaseLine.NEXT = 0;
            PurchaseLine.DELETEALL;
        END;

        TempPurchaseLine2.RESET;
        TempPurchaseLine2.FINDFIRST;
        REPEAT
            TotalQty := 0;
            TempPurchaseLine.RESET;
            TempPurchaseLine.SETRANGE("No.", TempPurchaseLine2."No.");
            TempPurchaseLine.FINDFIRST;
            CLEAR(PurchaseLine);
            PurchaseLine.INIT;
            PurchaseLine.COPY(TempPurchaseLine);
            PurchaseLine.INSERT(TRUE);

            REPEAT
                TotalQty := TempPurchaseLine.Quantity + TotalQty;
            UNTIL TempPurchaseLine.NEXT = 0;

            PurchaseLine.VALIDATE(Quantity, TotalQty);
            PurchaseLine.VALIDATE("Location Code", ChangeLocationToCentralWhse);
            PurchaseLine.MODIFY(TRUE);

        UNTIL TempPurchaseLine2.NEXT = 0;
        PurchaseHeader.VALIDATE("Location Code", ChangeLocationToCentralWhse);
        PurchaseHeader.MODIFY(TRUE);
        // Sipradi-YS END >> SPR6.1.0 - 33019831.2
    end;

    [Scope('Internal')]
    procedure CreatePurchHeader(Vendor: Code[20]): Boolean
    var
        PurchHeader: Record "38";
        NoVendor: Label 'Please Select Vendor before creating Purchase Order.';
    begin
        //Need to modify if uploaded csv contains multiple vendors.
        IF Vendor = '' THEN BEGIN
            ERROR(NoVendor);
            EXIT(FALSE);
        END;
        PurchHeader.RESET;
        CLEAR(PurchHeader);
        PurchHeader.INIT;
        PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
        PurchHeader."Document Profile" := PurchHeader."Document Profile"::"Spare Parts Trade";
        PurchHeader."Order Type" := PurchHeader."Order Type"::" ";
        PurchHeader.INSERT(TRUE);
        PurchHeader.VALIDATE("Buy-from Vendor No.", Vendor);
        PurchHeader.MODIFY(TRUE);
        CreatePurchLine(PurchHeader);
        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure CreatePurchLine(var PurchHeader: Record "38")
    var
        LastUsedLineNo: Integer;
        PurchLine: Record "39";
        CSVReqBuffer: Record "33019835";
        NothingToPost: Label 'There is nothing to Post.';
    begin
        CSVReqBuffer.RESET;
        IF CSVReqBuffer.FINDFIRST THEN BEGIN
            LastUsedLineNo := 0;
            REPEAT
                CLEAR(PurchLine);
                PurchLine.INIT;
                PurchLine."Line No." := LastUsedLineNo + 10000;
                PurchLine."Document Type" := PurchHeader."Document Type";
                PurchLine.VALIDATE("Document No.", PurchHeader."No.");
                PurchLine.VALIDATE(Type, PurchLine.Type::Item);
                PurchLine.VALIDATE("No.", CSVReqBuffer."Item No.");
                PurchLine.VALIDATE(Quantity, CSVReqBuffer."Order Quantity");
                PurchLine.INSERT(TRUE);
                LastUsedLineNo := LastUsedLineNo + 10000;
            UNTIL CSVReqBuffer.NEXT = 0;
            CSVReqBuffer.DELETEALL(TRUE);
        END
        ELSE
            ERROR(NothingToPost);
    end;

    [Scope('Internal')]
    procedure CalculateItemClass(StartDate: Date; EndDate: Date; LocationFilter: Code[20]; GenProdPostingGroup: Code[10]; ItemCategoryCode: Code[10])
    var
        ItemLedgerEntry: Record "32";
    begin
    end;

    [Scope('Internal')]
    procedure UploadSKU()
    var
        CsvMinMaxBuffer: Record "33019865";
    begin
        /*
        CsvMinMaxBuffer.reset;
        if CsvMinMaxBuffer.findfirst then begin
           StockKeepingUnit.RESET;
           StockKeepingUnit.SETRANGE("Item No.",CsvMinMaxBuffer."Item No");
           StockKeepingUnit.SETRANGE("Location Code",CsvMinMaxBuffer."Location Code");
           StockKeepingUnit.SETRANGE("Variant Code",CsvMinMaxBuffer."Variant Code");
           IF StockKeepingUnit.FINDFIRST THEN BEGIN
        
           END;
        end;
        */

    end;

    [Scope('Internal')]
    procedure CreateImportPurchHeader(Vendor: Code[20]): Boolean
    var
        PurchHeader: Record "38";
        NoVendor: Label 'Please Select Vendor before creating Purchase Order.';
        NoOrderType: Label 'Please Select Order Type before creating Purchase Order.';
        OrderType: Option " ","Local",VOR,Import;
    begin
        IF Vendor = '' THEN BEGIN
            ERROR(NoVendor);
            EXIT(FALSE);
        END;
        IF OrderType = OrderType::" " THEN BEGIN
            ERROR(NoOrderType);
            EXIT(FALSE);
        END;
        PurchHeader.RESET;
        CLEAR(PurchHeader);
        PurchHeader.INIT;
        PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
        PurchHeader.VALIDATE("Import Purch. Order", TRUE);
        PurchHeader."Document Profile" := PurchHeader."Document Profile"::"Spare Parts Trade";
        //PurchHeader."Order Type" := PurchHeader."Order Type"::" ";
        PurchHeader.INSERT(TRUE);
        PurchHeader.VALIDATE("Buy-from Vendor No.", Vendor);
        PurchHeader.VALIDATE("Order Type", OrderType);
        PurchHeader.MODIFY(TRUE);
        CreateImportPurchLine(PurchHeader);
        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure CreateImportPurchLine(var PurchHeader: Record "38")
    var
        LastUsedLineNo: Integer;
        PurchLine: Record "39";
        CSVReqBuffer: Record "33019835";
        NothingToPost: Label 'There is nothing to Post.';
    begin
        CSVReqBuffer.RESET;
        IF CSVReqBuffer.FINDFIRST THEN BEGIN
            LastUsedLineNo := 0;
            REPEAT
                CLEAR(PurchLine);
                PurchLine.INIT;
                PurchLine."Line No." := LastUsedLineNo + 10000;
                PurchLine."Document Type" := PurchHeader."Document Type";
                PurchLine."Import Purch. Order" := PurchHeader."Import Purch. Order";
                PurchLine.VALIDATE("Document No.", PurchHeader."No.");
                PurchLine."Document Profile" := PurchLine."Document Profile"::"Spare Parts Trade";
                PurchLine.VALIDATE(Type, PurchLine.Type::Item);
                PurchLine.VALIDATE("No.", CSVReqBuffer."Item No.");
                PurchLine.VALIDATE(Quantity, CSVReqBuffer."Order Quantity");
                PurchLine.INSERT(TRUE);
                LastUsedLineNo := LastUsedLineNo + 10000;
            UNTIL CSVReqBuffer.NEXT = 0;
            CSVReqBuffer.DELETEALL(TRUE);
        END
        ELSE
            ERROR(NothingToPost);
    end;
}


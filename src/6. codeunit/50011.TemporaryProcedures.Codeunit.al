codeunit 50011 "Temporary Procedures"
{
    Permissions = TableData 17 = rm,
                  TableData 21 = rm,
                  TableData 25 = rm,
                  TableData 32 = rm,
                  TableData 110 = rm,
                  TableData 111 = rmd,
                  TableData 112 = rm,
                  TableData 113 = rm,
                  TableData 114 = rm,
                  TableData 115 = rm,
                  TableData 120 = rm,
                  TableData 121 = rm,
                  TableData 122 = rm,
                  TableData 123 = rm,
                  TableData 124 = rm,
                  TableData 125 = rm,
                  TableData 271 = rm,
                  TableData 339 = rm,
                  TableData 379 = rm,
                  TableData 380 = rm,
                  TableData 5601 = rm,
                  TableData 5802 = rm,
                  TableData 6650 = rm,
                  TableData 6651 = rm,
                  TableData 6660 = rm,
                  TableData 6661 = rm,
                  TableData 33020293 = rim;

    trigger OnRun()
    var
        DealerSync: Codeunit "33020509";
    begin
        //UpdateCustomerName;
        //CreateUserSetup;
        /*
        //DealerSync.SetDealerCrMemoLine;
        */
        //UpdateNepDate;

        //UpdateLedgerDimensions;
        //UpdateDimensionswithoutDocuments;
        //UpdateDimensionsOnAsterikDocuments;
        //UpdateDimensionsPurchaseSales;
        //UpdateItemTrackingCode;
        //UppercaseItems;
        //UPdateDimensionsNegative;
        //CreateQRDetails;
        //UpdateLotNoItemLedgerEntry;
        //MESSAGE('done');
        //UpdatePostingGroupInValueEntry; //Min 5.6.2020
        //UpdatePostingGroupInGLEntry //Min 5.7.2020
        //UpdatePostingGroupOnAsterikDocuments;//Min 5.7.2020
        //RemoveSymbolsFromItem;
        //UpdateReservationEntry;
        //MESSAGE('hello');
        //UpdateCostingMethodItem //Amisha 5/12/2021
        //UpdateDealerPO;
        //UpdateDealerPONoThroughQuoteNo;
        //UpdateCustNameMaterilaize;
        //MESSAGE('Done');
        //UpdateExemptPurchNoInGLEntry;
        //UpdateExemptPurchNoInVATEntry;
        //UpdateItemLedgerEntries;
        //UpdateItemApplicationEntry;
        //TempCode;
        //DeleteSalesShipment;
        //updateSalesIncBase;
        MESSAGE('Done');

    end;

    var
        DimMgt: Codeunit "408";
        ProgressWindow: Dialog;
        Text000: Label 'Total Records: #1######\Processed : #2########\Modifying...#3#######################';
        counttotal: Integer;
        ChangeLogSetup: Record "402";
        Item: Record "27";
        SalesInvHead: Record "112";
        SalesHdrArchive: Record "5107";
        SalesInvoiceHeader: Record "112";
        SalesShipmentLine: Record "111";

    local procedure CreateUserSetup()
    var
        UserSetup: Record "91";
        NewUserSetup: Record "91";
        User: Record "2000000120";
    begin
        UserSetup.RESET;
        IF UserSetup.FINDSET THEN
            REPEAT
                User.RESET;
                User.SETRANGE("User Name", 'AGNIINC\' + UserSetup."User ID");
                IF User.FINDFIRST THEN BEGIN
                    CLEAR(NewUserSetup);
                    NewUserSetup.INIT;
                    NewUserSetup.TRANSFERFIELDS(UserSetup);
                    NewUserSetup.VALIDATE("User ID", 'AGNIINC\' + UserSetup."User ID");
                    NewUserSetup.INSERT(TRUE);
                END;
            UNTIL UserSetup.NEXT = 0;
    end;

    local procedure UpdateNepDate()
    var
        EnglishNepali: Record "33020302";
    begin
        EnglishNepali.RESET;
        EnglishNepali.SETFILTER("English Year", '>=%1', 2016);
        IF EnglishNepali.FINDFIRST THEN
            REPEAT
                IF STRLEN(EnglishNepali."Nepali Date") = 9 THEN BEGIN
                    EnglishNepali."Nepali Date" := COPYSTR(EnglishNepali."Nepali Date", 1, 8) + '0' + COPYSTR(EnglishNepali."Nepali Date", 9, 1);
                    EnglishNepali.MODIFY;
                END;
            UNTIL EnglishNepali.NEXT = 0;
        MESSAGE('Done');
    end;

    local procedure UpdateItemTrackingCode()
    var
        Item: Record "27";
        ItemTranslation: Record "25006032";
        Location: Record "14";
    begin
        Item.RESET;
        Item.SETRANGE(Type, Item.Type::Inventory);
        Item.SETRANGE("Item Type", Item."Item Type"::Item);
        Item.SETFILTER("Inventory Posting Group", '<>SUNDRYAST');
        //Item.SETRANGE("No.",ItemTranslation.Code);
        IF Item.FINDSET THEN
            REPEAT
                ItemTranslation.RESET;
                ItemTranslation.SETRANGE(Code, Item."No.");
                IF NOT ItemTranslation.FINDFIRST THEN BEGIN
                    Item."Item Tracking Code" := 'LOT';
                    //Item."Supplier Code" := 'MAHItemTranslation.Description;
                    Item.MODIFY;
                END;
            UNTIL Item.NEXT = 0;

        Location.RESET;
        IF Location.FINDSET THEN
            REPEAT
                Location."Check QR Excess Qty." := TRUE;
                Location.MODIFY;
            UNTIL Location.NEXT = 0;
    end;

    local procedure UppercaseItems()
    var
        Item: Record "27";
    begin
        Item.RESET;
        IF Item.FINDFIRST THEN
            REPEAT
                Item.Description := UPPERCASE(Item.Description);
                Item.MODIFY;
            UNTIL Item.NEXT = 0
    end;

    local procedure UpdateDimensionswithoutDocuments()
    var
        Location: Record "14";
        CorrectDimensionSetID: Integer;
        TransferShipmentHeader: Record "5744";
        TransferShipmentLine: Record "5745";
        ItemLedgEntry: Record "32";
        ItemLedgEntry2: Record "32";
        GLEntry: Record "17";
        ValueEntry: Record "5802";
        ValueEntry2: Record "5802";
        WarehouseEntry: Record "7312";
        TransferReceiptHeader: Record "5746";
        TransferReceiptLine: Record "5747";
        InTransitDimensionSetID: Integer;
        InTransitDim: Code[20];
        GLItemLedgRelation: Record "5823";
    begin
        InTransitDim := 'INTRANSIT';

        ItemLedgEntry.RESET;
        ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Transfer);
        //ItemLedgEntry.SETRANGE("Entry No.",936078);
        ItemLedgEntry.SETRANGE(Updated, FALSE);
        ItemLedgEntry.SETFILTER("Location Code", '<>%1', 'INTRANSIT');
        ItemLedgEntry.SETRANGE("Posting Date", 071621D, TODAY);
        IF ItemLedgEntry.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);

                Location.GET(ItemLedgEntry."Location Code");

                ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                ValidateShortcutDimCode(2, ItemLedgEntry."Global Dimension 2 Code", CorrectDimensionSetID);

                ItemLedgEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                ItemLedgEntry."Dimension Set ID" := CorrectDimensionSetID;
                ItemLedgEntry.Updated := TRUE;
                ItemLedgEntry.MODIFY;

                ValueEntry.RESET;
                ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
                IF ValueEntry.FINDSET THEN
                    REPEAT
                        ValueEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                        ValueEntry."Dimension Set ID" := CorrectDimensionSetID;
                        ValueEntry.MODIFY;

                        GLItemLedgRelation.RESET;
                        GLItemLedgRelation.SETRANGE("Value Entry No.", ValueEntry."Entry No.");
                        IF GLItemLedgRelation.FINDSET THEN
                            REPEAT
                                GLEntry.RESET;
                                GLEntry.SETRANGE("Document No.", ItemLedgEntry."Document No.");
                                GLEntry.SETRANGE("Entry No.", GLItemLedgRelation."G/L Entry No.");
                                IF GLEntry.FINDSET THEN
                                    REPEAT
                                        GLEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                                        GLEntry."Dimension Set ID" := ValueEntry."Dimension Set ID";
                                        GLEntry.MODIFY;
                                    UNTIL GLEntry.NEXT = 0;
                            UNTIL GLItemLedgRelation.NEXT = 0;
                    UNTIL ValueEntry.NEXT = 0;
            UNTIL ItemLedgEntry.NEXT = 0;


        //*******************************FOR INTRANSIT Entries****************************
        ItemLedgEntry.RESET;
        ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Transfer);
        ItemLedgEntry.SETRANGE(Updated, FALSE);
        ItemLedgEntry.SETRANGE("Posting Date", 071621D, TODAY);
        ItemLedgEntry.SETRANGE("Location Code", 'INTRANSIT');
        IF ItemLedgEntry.FINDSET THEN
            REPEAT

                ValidateShortcutDimCode(1, InTransitDim, InTransitDimensionSetID);
                ValidateShortcutDimCode(2, ItemLedgEntry."Global Dimension 2 Code", InTransitDimensionSetID);

                ItemLedgEntry."Global Dimension 1 Code" := InTransitDim;
                ItemLedgEntry."Dimension Set ID" := InTransitDimensionSetID;
                ItemLedgEntry.Updated := TRUE;
                ItemLedgEntry.MODIFY;

                ValueEntry.RESET;
                ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
                IF ValueEntry.FINDSET THEN
                    REPEAT
                        ValueEntry."Global Dimension 1 Code" := InTransitDim;
                        ValueEntry."Dimension Set ID" := InTransitDimensionSetID;
                        ValueEntry.MODIFY;

                        GLItemLedgRelation.RESET;
                        GLItemLedgRelation.SETRANGE("Value Entry No.", ValueEntry."Entry No.");
                        IF GLItemLedgRelation.FINDSET THEN
                            REPEAT
                                GLEntry.RESET;
                                GLEntry.SETRANGE("Document No.", ItemLedgEntry."Document No.");
                                GLEntry.SETRANGE("Entry No.", GLItemLedgRelation."G/L Entry No.");
                                IF GLEntry.FINDSET THEN
                                    REPEAT
                                        GLEntry."Global Dimension 1 Code" := InTransitDim;
                                        GLEntry."Dimension Set ID" := ValueEntry."Dimension Set ID";
                                        GLEntry.MODIFY;
                                    UNTIL GLEntry.NEXT = 0;
                            UNTIL GLItemLedgRelation.NEXT = 0;
                    UNTIL ValueEntry.NEXT = 0;
            UNTIL ItemLedgEntry.NEXT = 0;
    end;

    local procedure UpdateLedgerDimensions()
    var
        Location: Record "14";
        CorrectDimensionSetID: Integer;
        TransferShipmentHeader: Record "5744";
        TransferShipmentLine: Record "5745";
        ItemLedgEntry: Record "32";
        ItemLedgEntry2: Record "32";
        GLEntry: Record "17";
        ValueEntry: Record "5802";
        ValueEntry2: Record "5802";
        WarehouseEntry: Record "7312";
        TransferReceiptHeader: Record "5746";
        TransferReceiptLine: Record "5747";
        InTransitDimensionSetID: Integer;
        InTransitDim: Code[20];
        GLItemLedgRelation: Record "5823";
    begin
        InTransitDim := 'INTRANSIT';
        TransferShipmentHeader.RESET;
        TransferShipmentHeader.SETRANGE("Posting Date", 071621D, TODAY);
        //TransferShipmentHeader.SETRANGE("No.",'BIDTS70-00003');
        IF TransferShipmentHeader.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                CLEAR(InTransitDimensionSetID);
                Location.GET(TransferShipmentHeader."Transfer-from Code");
                ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                ValidateShortcutDimCode(2, TransferShipmentHeader."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                TransferShipmentHeader."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                TransferShipmentHeader."Shortcut Dimension 2 Code" := TransferShipmentHeader."Shortcut Dimension 2 Code";
                TransferShipmentHeader."Dimension Set ID" := CorrectDimensionSetID;
                TransferShipmentHeader.MODIFY;

                TransferShipmentLine.RESET;
                TransferShipmentLine.SETRANGE("Document No.", TransferShipmentHeader."No.");
                IF TransferShipmentLine.FINDSET THEN
                    REPEAT
                        TransferShipmentLine."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                        TransferShipmentLine."Shortcut Dimension 2 Code" := TransferShipmentHeader."Shortcut Dimension 2 Code";
                        TransferShipmentLine."Dimension Set ID" := CorrectDimensionSetID;
                        TransferShipmentLine.MODIFY;
                    UNTIL TransferShipmentLine.NEXT = 0;

                ItemLedgEntry.RESET;
                ItemLedgEntry.SETRANGE("Document No.", TransferShipmentHeader."No.");
                ItemLedgEntry.SETRANGE("Location Code", TransferShipmentHeader."Transfer-from Code");
                IF ItemLedgEntry.FINDSET THEN
                    REPEAT
                        ItemLedgEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                        ItemLedgEntry."Global Dimension 2 Code" := TransferShipmentHeader."Shortcut Dimension 2 Code";
                        ItemLedgEntry."Dimension Set ID" := CorrectDimensionSetID;
                        ItemLedgEntry.Updated := TRUE;
                        ItemLedgEntry.MODIFY;
                    UNTIL ItemLedgEntry.NEXT = 0;

                ItemLedgEntry.RESET;
                ItemLedgEntry.SETRANGE("Document No.", TransferShipmentHeader."No.");
                ItemLedgEntry.SETRANGE("Location Code", 'INTRANSIT');
                IF ItemLedgEntry.FINDSET THEN
                    REPEAT
                        ValidateShortcutDimCode(1, InTransitDim, InTransitDimensionSetID);
                        ValidateShortcutDimCode(2, TransferShipmentHeader."Shortcut Dimension 2 Code", InTransitDimensionSetID);

                        ItemLedgEntry."Global Dimension 1 Code" := InTransitDim;
                        ItemLedgEntry."Global Dimension 2 Code" := TransferShipmentHeader."Shortcut Dimension 2 Code";
                        ItemLedgEntry."Dimension Set ID" := InTransitDimensionSetID;
                        ItemLedgEntry.Updated := TRUE;
                        ItemLedgEntry.MODIFY;
                    UNTIL ItemLedgEntry.NEXT = 0;


                ValueEntry.RESET;
                ValueEntry.SETRANGE("Document No.", TransferShipmentHeader."No.");
                ValueEntry.SETRANGE("Location Code", TransferShipmentHeader."Transfer-from Code");
                IF ValueEntry.FINDSET THEN
                    REPEAT
                        ValueEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                        ValueEntry."Global Dimension 2 Code" := TransferShipmentHeader."Shortcut Dimension 2 Code";
                        ValueEntry."Dimension Set ID" := CorrectDimensionSetID;
                        ValueEntry.MODIFY;

                        GLItemLedgRelation.RESET;
                        GLItemLedgRelation.SETRANGE("Value Entry No.", ValueEntry."Entry No.");
                        IF GLItemLedgRelation.FINDSET THEN
                            REPEAT
                                GLEntry.RESET;
                                GLEntry.SETRANGE("Document No.", TransferShipmentHeader."No.");
                                GLEntry.SETRANGE("Entry No.", GLItemLedgRelation."G/L Entry No.");
                                IF GLEntry.FINDSET THEN
                                    REPEAT
                                        GLEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                                        GLEntry."Global Dimension 2 Code" := TransferShipmentHeader."Shortcut Dimension 2 Code";
                                        GLEntry."Dimension Set ID" := ValueEntry."Dimension Set ID";
                                        GLEntry.MODIFY;
                                    UNTIL GLEntry.NEXT = 0;
                            UNTIL GLItemLedgRelation.NEXT = 0;
                    UNTIL ValueEntry.NEXT = 0;

                ValueEntry.RESET;
                ValueEntry.SETRANGE("Document No.", TransferShipmentHeader."No.");
                ValueEntry.SETRANGE("Location Code", 'INTRANSIT');
                IF ValueEntry.FINDSET THEN
                    REPEAT
                        ValueEntry."Global Dimension 1 Code" := InTransitDim;
                        ValueEntry."Global Dimension 2 Code" := TransferShipmentHeader."Shortcut Dimension 2 Code";
                        ValueEntry."Dimension Set ID" := InTransitDimensionSetID;
                        ValueEntry.MODIFY;
                        GLItemLedgRelation.RESET;
                        GLItemLedgRelation.SETRANGE("Value Entry No.", ValueEntry."Entry No.");
                        IF GLItemLedgRelation.FINDSET THEN
                            REPEAT
                                GLEntry.RESET;
                                GLEntry.SETRANGE("Document No.", TransferShipmentHeader."No.");
                                GLEntry.SETRANGE("Entry No.", GLItemLedgRelation."G/L Entry No.");
                                IF GLEntry.FINDSET THEN
                                    REPEAT
                                        GLEntry."Global Dimension 1 Code" := InTransitDim;
                                        GLEntry."Global Dimension 2 Code" := TransferShipmentHeader."Shortcut Dimension 2 Code";
                                        GLEntry."Dimension Set ID" := ValueEntry."Dimension Set ID";
                                        GLEntry.MODIFY;
                                    UNTIL GLEntry.NEXT = 0;
                            UNTIL GLItemLedgRelation.NEXT = 0;
                    UNTIL ValueEntry.NEXT = 0;
            UNTIL TransferShipmentHeader.NEXT = 0;

        TransferReceiptHeader.RESET;
        //TransferReceiptHeader.SETRANGE("No.",'KULTR70-00048');
        TransferReceiptHeader.SETRANGE("Posting Date", 071621D, TODAY);
        IF TransferReceiptHeader.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                CLEAR(InTransitDimensionSetID);
                Location.GET(TransferReceiptHeader."Transfer-to Code");
                ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                ValidateShortcutDimCode(2, TransferReceiptHeader."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                ItemLedgEntry.RESET;
                ItemLedgEntry.SETRANGE("Document No.", TransferReceiptHeader."No.");
                ItemLedgEntry.SETRANGE("Location Code", TransferReceiptHeader."Transfer-to Code");
                IF ItemLedgEntry.FINDSET THEN
                    REPEAT
                        ItemLedgEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                        ItemLedgEntry."Global Dimension 2 Code" := TransferReceiptHeader."Shortcut Dimension 2 Code";
                        ItemLedgEntry."Dimension Set ID" := CorrectDimensionSetID;
                        ItemLedgEntry.Updated := TRUE;
                        ItemLedgEntry.MODIFY;
                    UNTIL ItemLedgEntry.NEXT = 0;

                ValueEntry2.RESET;
                ValueEntry2.SETRANGE("Document No.", TransferReceiptHeader."No.");
                ValueEntry2.SETRANGE("Location Code", TransferReceiptHeader."Transfer-to Code");
                IF ValueEntry2.FINDSET THEN
                    REPEAT
                        ValueEntry2."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                        ValueEntry2."Global Dimension 2 Code" := TransferReceiptHeader."Shortcut Dimension 2 Code";
                        ValueEntry2."Dimension Set ID" := CorrectDimensionSetID;
                        ValueEntry2.MODIFY;
                        GLItemLedgRelation.RESET;
                        GLItemLedgRelation.SETRANGE("Value Entry No.", ValueEntry2."Entry No.");
                        IF GLItemLedgRelation.FINDSET THEN
                            REPEAT
                                GLEntry.RESET;
                                GLEntry.SETRANGE("Document No.", TransferReceiptHeader."No.");
                                GLEntry.SETRANGE("Entry No.", GLItemLedgRelation."G/L Entry No.");
                                IF GLEntry.FINDSET THEN
                                    REPEAT
                                        GLEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                                        GLEntry."Global Dimension 2 Code" := TransferReceiptHeader."Shortcut Dimension 2 Code";
                                        GLEntry."Dimension Set ID" := ValueEntry2."Dimension Set ID";
                                        GLEntry.MODIFY;
                                    UNTIL GLEntry.NEXT = 0;
                            UNTIL GLItemLedgRelation.NEXT = 0;
                    UNTIL ValueEntry2.NEXT = 0;


                TransferReceiptHeader."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                TransferReceiptHeader."Shortcut Dimension 2 Code" := TransferReceiptHeader."Shortcut Dimension 2 Code";
                TransferReceiptHeader."Dimension Set ID" := CorrectDimensionSetID;
                TransferReceiptHeader.MODIFY;


                TransferReceiptLine.RESET;
                TransferReceiptLine.SETRANGE("Document No.", TransferReceiptHeader."No.");
                IF TransferReceiptLine.FINDSET THEN
                    REPEAT
                        TransferReceiptLine."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                        TransferReceiptLine."Shortcut Dimension 2 Code" := TransferReceiptHeader."Shortcut Dimension 2 Code";
                        TransferReceiptLine."Dimension Set ID" := CorrectDimensionSetID;
                        TransferReceiptLine.MODIFY;
                    UNTIL TransferReceiptLine.NEXT = 0;

                ItemLedgEntry2.RESET;
                ItemLedgEntry2.SETRANGE("Document No.", TransferReceiptHeader."No.");
                ItemLedgEntry2.SETRANGE("Location Code", 'INTRANSIT');
                IF ItemLedgEntry2.FINDSET THEN BEGIN
                    ValidateShortcutDimCode(1, InTransitDim, InTransitDimensionSetID);
                    ValidateShortcutDimCode(2, TransferReceiptHeader."Shortcut Dimension 2 Code", InTransitDimensionSetID);
                    REPEAT
                        ItemLedgEntry2."Global Dimension 1 Code" := InTransitDim;
                        ItemLedgEntry2."Global Dimension 2 Code" := TransferReceiptHeader."Shortcut Dimension 2 Code";
                        ItemLedgEntry2."Dimension Set ID" := InTransitDimensionSetID;
                        ItemLedgEntry2.Updated := TRUE;
                        ItemLedgEntry2.MODIFY;
                    UNTIL ItemLedgEntry2.NEXT = 0;
                END;

                ValueEntry.RESET;
                ValueEntry.SETRANGE("Document No.", TransferReceiptHeader."No.");
                ValueEntry.SETRANGE("Location Code", 'INTRANSIT');
                IF ValueEntry.FINDSET THEN
                    REPEAT
                        ValueEntry."Global Dimension 1 Code" := InTransitDim;
                        ValueEntry."Global Dimension 2 Code" := TransferReceiptHeader."Shortcut Dimension 2 Code";
                        ValueEntry."Dimension Set ID" := InTransitDimensionSetID;
                        ValueEntry.MODIFY;
                        GLItemLedgRelation.RESET;
                        GLItemLedgRelation.SETRANGE("Value Entry No.", ValueEntry."Entry No.");
                        IF GLItemLedgRelation.FINDSET THEN
                            REPEAT
                                GLEntry.RESET;
                                GLEntry.SETRANGE("Document No.", TransferReceiptHeader."No.");
                                GLEntry.SETRANGE("Entry No.", GLItemLedgRelation."G/L Entry No.");
                                IF GLEntry.FINDSET THEN
                                    REPEAT
                                        GLEntry."Global Dimension 1 Code" := InTransitDim;
                                        GLEntry."Global Dimension 2 Code" := TransferReceiptHeader."Shortcut Dimension 2 Code";
                                        GLEntry."Dimension Set ID" := ValueEntry."Dimension Set ID";
                                        GLEntry.MODIFY;
                                    UNTIL GLEntry.NEXT = 0;
                            UNTIL GLItemLedgRelation.NEXT = 0;
                    UNTIL ValueEntry.NEXT = 0;
            UNTIL TransferReceiptHeader.NEXT = 0;
    end;

    local procedure UpdateDimensionsOnAsterikDocuments()
    var
        ValueEntry: Record "5802";
        GLEntry: Record "17";
        Location: Record "14";
        GLItemLedgRelation: Record "5823";
    begin
        GLEntry.RESET;
        GLEntry.SETRANGE("Source Code", 'INVTPCOST');
        GLEntry.SETFILTER("Posting Date", '>=%1', 030517D);
        IF GLEntry.FINDSET THEN
            REPEAT
                IF GLEntry."Document No." = '*' THEN BEGIN
                    GLItemLedgRelation.RESET;
                    GLItemLedgRelation.SETRANGE("G/L Entry No.", GLEntry."Entry No.");
                    IF GLItemLedgRelation.FINDFIRST THEN BEGIN
                        ValueEntry.GET(GLItemLedgRelation."Value Entry No.");
                        GLEntry."Global Dimension 1 Code" := ValueEntry."Global Dimension 1 Code";
                        GLEntry."Global Dimension 2 Code" := ValueEntry."Global Dimension 2 Code";
                        GLEntry."Dimension Set ID" := ValueEntry."Dimension Set ID";
                        GLEntry.MODIFY;
                    END;
                END;
            UNTIL GLEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]; var DimensionSetID: Integer)
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, DimensionSetID);
    end;

    local procedure UpdateDimensionsPurchaseSales()
    var
        Location: Record "14";
        CorrectDimensionSetID: Integer;
        TransferShipmentHeader: Record "5744";
        TransferShipmentLine: Record "5745";
        ItemLedgEntry: Record "32";
        ItemLedgEntry2: Record "32";
        GLEntry: Record "17";
        ValueEntry: Record "5802";
        ValueEntry2: Record "5802";
        WarehouseEntry: Record "7312";
        TransferReceiptHeader: Record "5746";
        TransferReceiptLine: Record "5747";
        InTransitDimensionSetID: Integer;
        InTransitDim: Code[20];
        GLItemLedgRelation: Record "5823";
        PurchRcptHdr: Record "120";
        PurchRcptLine: Record "121";
        PurchInvHeader: Record "122";
        PurchInvLine: Record "123";
        ReturnReceiptHeader: Record "6650";
        ReturnReceiptLine: Record "6651";
        PurchCrMemoHdr: Record "124";
        PurchCrMemoLine: Record "125";
        SalesShipmentHdr: Record "110";
        SalesShipmentLine: Record "111";
        SalesInvoiceHeader: Record "112";
        SalesInvoiceLine: Record "113";
        ReturnShipmentHdr: Record "6660";
        ReturnShipmentLine: Record "6661";
        SalesCrMemoHeader: Record "114";
        SalesCrMemoLine: Record "115";
        VendorLedgerEntry: Record "25";
        DetailedVendorLedgEntry: Record "380";
        CustLedgerEntry: Record "21";
        DetailedCustLedgEntry: Record "379";
        GLAccountNetChange: Record "269";
    begin


















        ItemLedgEntry.RESET;
        ItemLedgEntry.SETRANGE("Posting Date", 071621D, TODAY);
        ItemLedgEntry.SETFILTER("Entry Type", '%1|%2|%3', ItemLedgEntry."Entry Type"::Purchase, ItemLedgEntry."Entry Type"::"Positive Adjmt.", ItemLedgEntry."Entry Type"::"Negative Adjmt.");
        //ItemLedgEntry.SETRANGE("Document Profile",ItemLedgEntry."Document Profile"::"Spare Parts Trade");
        ItemLedgEntry.SETRANGE(Updated, FALSE);
        IF ItemLedgEntry.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(ItemLedgEntry."Location Code");


                //IF ItemLedgEntry."Global Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                ValidateShortcutDimCode(2, ItemLedgEntry."Global Dimension 2 Code", CorrectDimensionSetID);

                ItemLedgEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                ItemLedgEntry."Dimension Set ID" := CorrectDimensionSetID;
                ItemLedgEntry.Updated := TRUE;
                ItemLedgEntry.MODIFY;
                ValueEntry.RESET;
                ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
                IF ValueEntry.FINDSET THEN
                    REPEAT
                        ValueEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                        ValueEntry."Dimension Set ID" := CorrectDimensionSetID;
                        ValueEntry.MODIFY;

                        GLItemLedgRelation.RESET;
                        GLItemLedgRelation.SETRANGE("Value Entry No.", ValueEntry."Entry No.");
                        IF GLItemLedgRelation.FINDSET THEN
                            REPEAT
                                GLEntry.RESET;
                                GLEntry.SETRANGE("Document No.", ItemLedgEntry."Document No.");
                                GLEntry.SETRANGE("Entry No.", GLItemLedgRelation."G/L Entry No.");
                                IF GLEntry.FINDSET THEN
                                    REPEAT
                                        GLEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                                        GLEntry."Dimension Set ID" := ValueEntry."Dimension Set ID";
                                        GLEntry.MODIFY;
                                    UNTIL GLEntry.NEXT = 0;
                            UNTIL GLItemLedgRelation.NEXT = 0;
                    UNTIL ValueEntry.NEXT = 0;
            //END;

            UNTIL ItemLedgEntry.NEXT = 0;

        PurchRcptHdr.RESET;
        //PurchRcptHdr.SETRANGE("Document Profile",PurchRcptHdr."Document Profile"::"Spare Parts Trade");
        PurchRcptHdr.SETRANGE("Posting Date", 071621D, TODAY);
        PurchRcptHdr.SETFILTER("Location Code", '<>%1', '');
        IF PurchRcptHdr.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(PurchRcptHdr."Location Code");
                IF PurchRcptHdr."Shortcut Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                    ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                    ValidateShortcutDimCode(2, PurchRcptHdr."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                    PurchRcptHdr."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                    PurchRcptHdr."Dimension Set ID" := CorrectDimensionSetID;
                    PurchRcptHdr.MODIFY;
                END;
            UNTIL PurchRcptHdr.NEXT = 0;

        PurchRcptLine.RESET;
        //PurchRcptLine.SETRANGE("Document Profile",PurchRcptLine."Document Profile"::"Spare Parts Trade");
        PurchRcptLine.SETRANGE("Posting Date", 071621D, TODAY);
        PurchRcptLine.SETFILTER("Location Code", '<>%1', '');
        IF PurchRcptLine.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(PurchRcptLine."Location Code");
                IF PurchRcptLine."Shortcut Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                    ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                    ValidateShortcutDimCode(2, PurchRcptLine."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                    PurchRcptLine."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                    PurchRcptLine."Dimension Set ID" := CorrectDimensionSetID;
                    PurchRcptLine.MODIFY;
                END;
            UNTIL PurchRcptLine.NEXT = 0;

        PurchInvHeader.RESET;
        //PurchInvHeader.SETRANGE("Document Profile",PurchInvHeader."Document Profile"::"Spare Parts Trade");
        PurchInvHeader.SETRANGE("Posting Date", 071621D, TODAY);
        PurchInvHeader.SETFILTER("Location Code", '<>%1', '');
        IF PurchInvHeader.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(PurchInvHeader."Location Code");
                IF PurchInvHeader."Shortcut Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                    ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                    ValidateShortcutDimCode(2, PurchInvHeader."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                    PurchInvHeader."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                    PurchInvHeader."Dimension Set ID" := CorrectDimensionSetID;
                    PurchInvHeader.MODIFY;
                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SETRANGE("Document No.", PurchInvHeader."No.");
                    IF VendorLedgerEntry.FINDFIRST THEN
                        REPEAT
                            VendorLedgerEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                            VendorLedgerEntry."Dimension Set ID" := CorrectDimensionSetID;
                            VendorLedgerEntry.MODIFY;
                            DetailedVendorLedgEntry.RESET;
                            DetailedVendorLedgEntry.SETRANGE("Vendor Ledger Entry No.", VendorLedgerEntry."Entry No.");
                            IF DetailedVendorLedgEntry.FINDSET THEN
                                REPEAT
                                    DetailedVendorLedgEntry."Initial Entry Global Dim. 1" := Location."Shortcut Dimension 1 Code";
                                    DetailedVendorLedgEntry.MODIFY;
                                UNTIL DetailedVendorLedgEntry.NEXT = 0;
                        UNTIL VendorLedgerEntry.NEXT = 0;

                END;
            UNTIL PurchInvHeader.NEXT = 0;













        PurchInvLine.RESET;
        //PurchInvLine.SETRANGE("Document Profile",PurchInvLine."Document Profile"::"Spare Parts Trade");
        PurchInvLine.SETRANGE("Posting Date", 071621D, TODAY);
        PurchInvLine.SETFILTER("Location Code", '<>%1', '');
        IF PurchInvLine.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(PurchInvLine."Location Code");
                IF PurchInvLine."Shortcut Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                    ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                    ValidateShortcutDimCode(2, PurchInvLine."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                    PurchInvLine."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                    PurchInvLine."Dimension Set ID" := CorrectDimensionSetID;
                    PurchInvLine.MODIFY;
                END;
            UNTIL PurchInvLine.NEXT = 0;












        ReturnReceiptHeader.RESET;
        //ReturnReceiptHeader.SETRANGE("Document Profile",ReturnReceiptHeader."Document Profile"::"Spare Parts Trade");
        ReturnReceiptHeader.SETRANGE("Posting Date", 071621D, TODAY);
        ReturnReceiptHeader.SETFILTER("Location Code", '<>%1', '');
        IF ReturnReceiptHeader.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(ReturnReceiptHeader."Location Code");
                IF ReturnReceiptHeader."Shortcut Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                    ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                    ValidateShortcutDimCode(2, ReturnReceiptHeader."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                    ReturnReceiptHeader."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                    ReturnReceiptHeader."Dimension Set ID" := CorrectDimensionSetID;
                    ReturnReceiptHeader.MODIFY;
                END;
            UNTIL ReturnReceiptHeader.NEXT = 0;

        ReturnReceiptLine.RESET;
        //ReturnReceiptLine.SETRANGE("Document Profile",ReturnReceiptLine."Document Profile"::"Spare Parts Trade");
        ReturnReceiptLine.SETRANGE("Posting Date", 071621D, TODAY);
        ReturnReceiptLine.SETFILTER("Location Code", '<>%1', '');
        IF ReturnReceiptLine.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(ReturnReceiptLine."Location Code");
                IF ReturnReceiptLine."Shortcut Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                    ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                    ValidateShortcutDimCode(2, ReturnReceiptLine."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                    ReturnReceiptLine."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                    ReturnReceiptLine."Dimension Set ID" := CorrectDimensionSetID;
                    ReturnReceiptLine.MODIFY;
                END;
            UNTIL ReturnReceiptLine.NEXT = 0;

        PurchCrMemoHdr.RESET;
        //PurchCrMemoHdr.SETRANGE("Document Profile",PurchCrMemoHdr."Document Profile"::"Spare Parts Trade");
        PurchCrMemoHdr.SETRANGE("Posting Date", 071621D, TODAY);
        PurchCrMemoHdr.SETFILTER("Location Code", '<>%1', '');
        IF PurchCrMemoHdr.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(PurchCrMemoHdr."Location Code");
                IF PurchCrMemoHdr."Shortcut Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                    ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                    ValidateShortcutDimCode(2, PurchCrMemoHdr."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                    PurchCrMemoHdr."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                    PurchCrMemoHdr."Dimension Set ID" := CorrectDimensionSetID;
                    PurchCrMemoHdr.MODIFY;
                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SETRANGE("Document No.", PurchCrMemoHdr."No.");
                    IF VendorLedgerEntry.FINDFIRST THEN
                        REPEAT
                            VendorLedgerEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                            VendorLedgerEntry."Dimension Set ID" := CorrectDimensionSetID;
                            VendorLedgerEntry.MODIFY;
                            DetailedVendorLedgEntry.RESET;
                            DetailedVendorLedgEntry.SETRANGE("Vendor Ledger Entry No.", VendorLedgerEntry."Entry No.");
                            IF DetailedVendorLedgEntry.FINDSET THEN
                                REPEAT
                                    DetailedVendorLedgEntry."Initial Entry Global Dim. 1" := Location."Shortcut Dimension 1 Code";
                                    DetailedVendorLedgEntry.MODIFY;
                                UNTIL DetailedVendorLedgEntry.NEXT = 0;
                        UNTIL VendorLedgerEntry.NEXT = 0;
                END;
            UNTIL PurchCrMemoHdr.NEXT = 0;

        PurchCrMemoLine.RESET;
        //PurchCrMemoLine.SETRANGE("Document Profile",PurchCrMemoLine."Document Profile"::"Spare Parts Trade");
        PurchCrMemoLine.SETRANGE("Posting Date", 071621D, TODAY);
        PurchCrMemoLine.SETFILTER("Location Code", '<>%1', '');
        IF PurchCrMemoLine.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(PurchCrMemoLine."Location Code");
                IF PurchCrMemoLine."Shortcut Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                    ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                    ValidateShortcutDimCode(2, PurchCrMemoLine."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                    PurchCrMemoLine."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                    PurchCrMemoLine."Dimension Set ID" := CorrectDimensionSetID;
                    PurchCrMemoLine.MODIFY;
                END;
            UNTIL PurchCrMemoLine.NEXT = 0;














        //SALES
        ItemLedgEntry.RESET;
        ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Sale);
        ItemLedgEntry.SETRANGE("Posting Date", 071621D, TODAY);
        //ItemLedgEntry.SETRANGE("Document Profile",ItemLedgEntry."Document Profile"::"Spare Parts Trade");
        ItemLedgEntry.SETRANGE(Updated, FALSE);
        IF ItemLedgEntry.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);

                Location.GET(ItemLedgEntry."Location Code");


                //IF ItemLedgEntry."Global Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                ValidateShortcutDimCode(2, ItemLedgEntry."Global Dimension 2 Code", CorrectDimensionSetID);

                ItemLedgEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                ItemLedgEntry."Dimension Set ID" := CorrectDimensionSetID;
                ItemLedgEntry.Updated := TRUE;
                ItemLedgEntry.MODIFY;

                ValueEntry.RESET;
                ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
                IF ValueEntry.FINDSET THEN
                    REPEAT
                        ValueEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                        ValueEntry."Dimension Set ID" := CorrectDimensionSetID;
                        ValueEntry.MODIFY;

                        GLItemLedgRelation.RESET;
                        GLItemLedgRelation.SETRANGE("Value Entry No.", ValueEntry."Entry No.");
                        IF GLItemLedgRelation.FINDSET THEN
                            REPEAT
                                GLEntry.RESET;
                                GLEntry.SETRANGE("Document No.", ItemLedgEntry."Document No.");
                                GLEntry.SETRANGE("Entry No.", GLItemLedgRelation."G/L Entry No.");
                                IF GLEntry.FINDSET THEN
                                    REPEAT
                                        GLEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                                        GLEntry."Dimension Set ID" := ValueEntry."Dimension Set ID";
                                        GLEntry.MODIFY;
                                    UNTIL GLEntry.NEXT = 0;
                            UNTIL GLItemLedgRelation.NEXT = 0;
                    UNTIL ValueEntry.NEXT = 0;
            //END;
            UNTIL ItemLedgEntry.NEXT = 0;

        SalesShipmentHdr.RESET;
        SalesShipmentHdr.SETRANGE("Posting Date", 071621D, TODAY);
        //PurchRcptHdr.SETRANGE("Document Profile",PurchRcptHdr."Document Profile"::"Spare Parts Trade");
        SalesShipmentHdr.SETFILTER("Location Code", '<>%1', '');
        IF SalesShipmentHdr.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(SalesShipmentHdr."Location Code");
                IF SalesShipmentHdr."Shortcut Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                    ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                    ValidateShortcutDimCode(2, SalesShipmentHdr."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                    SalesShipmentHdr."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                    SalesShipmentHdr."Dimension Set ID" := CorrectDimensionSetID;
                    SalesShipmentHdr.MODIFY;
                END;
            UNTIL SalesShipmentHdr.NEXT = 0;

        SalesShipmentLine.RESET;
        //PurchRcptLine.SETRANGE("Document Profile",PurchRcptLine."Document Profile"::"Spare Parts Trade");
        SalesShipmentLine.SETRANGE("Posting Date", 071621D, TODAY);
        SalesShipmentLine.SETFILTER("Location Code", '<>%1', '');
        IF SalesShipmentLine.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(SalesShipmentLine."Location Code");
                IF SalesShipmentLine."Shortcut Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                    ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                    ValidateShortcutDimCode(2, SalesShipmentLine."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                    SalesShipmentLine."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                    SalesShipmentLine."Dimension Set ID" := CorrectDimensionSetID;
                    SalesShipmentLine.MODIFY;
                END;
            UNTIL SalesShipmentLine.NEXT = 0;

        SalesInvoiceHeader.RESET;
        //PurchInvHeader.SETRANGE("Document Profile",PurchInvHeader."Document Profile"::"Spare Parts Trade");
        SalesInvoiceHeader.SETRANGE("Posting Date", 071621D, TODAY);
        SalesInvoiceHeader.SETFILTER("Location Code", '<>%1', '');
        IF SalesInvoiceHeader.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(SalesInvoiceHeader."Location Code");
                IF SalesInvoiceHeader."Shortcut Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                    ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                    ValidateShortcutDimCode(2, SalesInvoiceHeader."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                    SalesInvoiceHeader."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                    SalesInvoiceHeader."Dimension Set ID" := CorrectDimensionSetID;
                    SalesInvoiceHeader.MODIFY;
                    CustLedgerEntry.RESET;
                    CustLedgerEntry.SETRANGE("Document No.", SalesInvoiceHeader."No.");
                    IF CustLedgerEntry.FINDFIRST THEN
                        REPEAT
                            CustLedgerEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                            CustLedgerEntry."Dimension Set ID" := CorrectDimensionSetID;
                            CustLedgerEntry.MODIFY;
                            DetailedCustLedgEntry.RESET;
                            DetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", VendorLedgerEntry."Entry No.");
                            IF DetailedCustLedgEntry.FINDSET THEN
                                REPEAT
                                    DetailedCustLedgEntry."Initial Entry Global Dim. 1" := Location."Shortcut Dimension 1 Code";
                                    DetailedCustLedgEntry.MODIFY;
                                UNTIL DetailedCustLedgEntry.NEXT = 0;
                        UNTIL CustLedgerEntry.NEXT = 0;
                END;
            UNTIL SalesInvoiceHeader.NEXT = 0;

        SalesInvoiceLine.RESET;
        //PurchInvLine.SETRANGE("Document Profile",PurchInvLine."Document Profile"::"Spare Parts Trade");
        SalesInvoiceLine.SETRANGE("Posting Date", 071621D, TODAY);
        SalesInvoiceLine.SETFILTER("Location Code", '<>%1', '');
        IF SalesInvoiceLine.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(SalesInvoiceLine."Location Code");
                IF SalesInvoiceLine."Shortcut Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                    ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                    ValidateShortcutDimCode(2, SalesInvoiceLine."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                    SalesInvoiceLine."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                    SalesInvoiceLine."Dimension Set ID" := CorrectDimensionSetID;
                    SalesInvoiceLine.MODIFY;
                END;
            UNTIL SalesInvoiceLine.NEXT = 0;




        ReturnShipmentHdr.RESET;
        ReturnShipmentHdr.SETRANGE("Posting Date", 071621D, TODAY);
        //ReturnReceiptHeader.SETRANGE("Document Profile",ReturnReceiptHeader."Document Profile"::"Spare Parts Trade");
        ReturnShipmentHdr.SETFILTER("Location Code", '<>%1', '');
        IF ReturnShipmentHdr.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(ReturnShipmentHdr."Location Code");
                IF ReturnShipmentHdr."Shortcut Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                    ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                    ValidateShortcutDimCode(2, ReturnShipmentHdr."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                    ReturnShipmentHdr."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                    ReturnShipmentHdr."Dimension Set ID" := CorrectDimensionSetID;
                    ReturnShipmentHdr.MODIFY;
                END;
            UNTIL ReturnShipmentHdr.NEXT = 0;

        ReturnShipmentLine.RESET;
        ReturnShipmentLine.SETRANGE("Posting Date", 071621D, TODAY);
        //ReturnReceiptLine.SETRANGE("Document Profile",ReturnReceiptLine."Document Profile"::"Spare Parts Trade");
        ReturnShipmentLine.SETFILTER("Location Code", '<>%1', '');
        IF ReturnShipmentLine.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(ReturnShipmentLine."Location Code");
                IF ReturnShipmentLine."Shortcut Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                    ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                    ValidateShortcutDimCode(2, ReturnShipmentLine."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                    ReturnShipmentLine."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                    ReturnShipmentLine."Dimension Set ID" := CorrectDimensionSetID;
                    ReturnShipmentLine.MODIFY;
                END;
            UNTIL ReturnShipmentLine.NEXT = 0;














        SalesCrMemoHeader.RESET;
        SalesCrMemoHeader.SETRANGE("Posting Date", 071621D, TODAY);
        //PurchCrMemoHdr.SETRANGE("Document Profile",PurchCrMemoHdr."Document Profile"::"Spare Parts Trade");
        SalesCrMemoHeader.SETFILTER("Location Code", '<>%1', '');
        IF SalesCrMemoHeader.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(SalesCrMemoHeader."Location Code");
                IF SalesCrMemoHeader."Shortcut Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                    ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                    ValidateShortcutDimCode(2, SalesCrMemoHeader."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                    SalesCrMemoHeader."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                    SalesCrMemoHeader."Dimension Set ID" := CorrectDimensionSetID;
                    SalesCrMemoHeader.MODIFY;
                    CustLedgerEntry.RESET;
                    CustLedgerEntry.SETRANGE("Document No.", SalesCrMemoHeader."No.");
                    IF CustLedgerEntry.FINDFIRST THEN
                        REPEAT
                            CustLedgerEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                            CustLedgerEntry."Dimension Set ID" := CorrectDimensionSetID;
                            CustLedgerEntry.MODIFY;
                            DetailedCustLedgEntry.RESET;
                            DetailedCustLedgEntry.SETRANGE("Cust. Ledger Entry No.", VendorLedgerEntry."Entry No.");
                            IF DetailedCustLedgEntry.FINDSET THEN
                                REPEAT
                                    DetailedCustLedgEntry."Initial Entry Global Dim. 1" := Location."Shortcut Dimension 1 Code";
                                    DetailedCustLedgEntry.MODIFY;
                                UNTIL DetailedCustLedgEntry.NEXT = 0;
                        UNTIL CustLedgerEntry.NEXT = 0;
                END;
            UNTIL SalesCrMemoHeader.NEXT = 0;

        SalesCrMemoLine.RESET;
        //PurchCrMemoLine.SETRANGE("Document Profile",PurchCrMemoLine."Document Profile"::"Spare Parts Trade");
        SalesCrMemoLine.SETRANGE("Posting Date", 071621D, TODAY);
        SalesCrMemoLine.SETFILTER("Location Code", '<>%1', '');
        IF SalesCrMemoLine.FINDSET THEN
            REPEAT
                CLEAR(CorrectDimensionSetID);
                Location.GET(SalesCrMemoLine."Location Code");
                IF SalesCrMemoLine."Shortcut Dimension 1 Code" <> Location."Shortcut Dimension 1 Code" THEN BEGIN
                    ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                    ValidateShortcutDimCode(2, SalesCrMemoLine."Shortcut Dimension 2 Code", CorrectDimensionSetID);

                    SalesCrMemoLine."Shortcut Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                    SalesCrMemoLine."Dimension Set ID" := CorrectDimensionSetID;
                    SalesCrMemoLine.MODIFY;
                END;
            UNTIL SalesCrMemoLine.NEXT = 0;
    end;

    local procedure UPdateDimensionsNegative()
    var
        ItemLedgEntry: Record "32";
        ValueEntry: Record "5802";
        Location: Record "14";
        CorrectDimensionSetID: Integer;
        CostRe: Code[20];
    begin
        CostRe := '1002';
        ItemLedgEntry.RESET;
        ItemLedgEntry.SETRANGE("Document No.", 'BIDIPPRN75-000003');
        ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::"Negative Adjmt.");
        IF ItemLedgEntry.FINDSET THEN
            REPEAT
                Location.GET(ItemLedgEntry."Location Code");
                ValidateShortcutDimCode(1, Location."Shortcut Dimension 1 Code", CorrectDimensionSetID);
                ValidateShortcutDimCode(2, CostRe, CorrectDimensionSetID);
                ItemLedgEntry."Global Dimension 1 Code" := Location."Shortcut Dimension 1 Code";
                ItemLedgEntry."Global Dimension 2 Code" := ItemLedgEntry."Global Dimension 2 Code";
                ItemLedgEntry."Dimension Set ID" := CorrectDimensionSetID;
                ItemLedgEntry.Updated := TRUE;
                ItemLedgEntry.MODIFY;
                ValueEntry.RESET;
                ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
                IF ValueEntry.FINDFIRST THEN
                    REPEAT
                        ValueEntry."Global Dimension 1 Code" := ItemLedgEntry."Global Dimension 1 Code";
                        ValueEntry."Global Dimension 2 Code" := ItemLedgEntry."Global Dimension 2 Code";
                        ValueEntry."Dimension Set ID" := ItemLedgEntry."Dimension Set ID";
                        ValueEntry.MODIFY;
                    UNTIL ValueEntry.NEXT = 0;
            UNTIL ItemLedgEntry.NEXT = 0;
    end;

    local procedure CreateQRDetails()
    var
        QrDetail: Record "33019978";
    begin
        QrDetail.INIT;
        QrDetail.Type := QrDetail.Type::"Transfer Pick";
        //QrDetail."Line No." := 10000;
        QrDetail."Item No." := '000010778P03';
        QrDetail."Document No." := 'BIDTO76-04685';
        QrDetail.VALIDATE("QR Text", 'MAH/000010778P03/MAH-19-20-54|76/77-AB467B778915/2');
        QrDetail.INSERT(TRUE);


        QrDetail.INIT;
        QrDetail.Type := QrDetail.Type::"Transfer Pick";
        //QrDetail."Line No." := 20000;
        QrDetail."Item No." := '000010778P03';
        QrDetail."Document No." := 'BIDTO76-04685';
        QrDetail.VALIDATE("QR Text", 'MAH/000010778P03/MAH-19-20-54|76/77-9F225022B23A/2');
        QrDetail.INSERT(TRUE);

        QrDetail.INIT;
        QrDetail.Type := QrDetail.Type::"Transfer Pick";
        //QrDetail."Line No." := 30000;
        QrDetail."Item No." := '000010778P03';
        QrDetail."Document No." := 'BIDTO76-04685';
        QrDetail.VALIDATE("QR Text", 'MAH/000010778P03/MAH-19-20-54|76/77-15FC95DE3E02/2');
        QrDetail.INSERT(TRUE);


        QrDetail.INIT;
        QrDetail.Type := QrDetail.Type::"Transfer Pick";
        //QrDetail."Line No." := 40000;
        QrDetail."Item No." := '000012019P04';
        QrDetail."Document No." := 'BIDTO76-04685';
        QrDetail.VALIDATE("QR Text", 'MAH/000012019P04/MAH-19-20-54|76/77-5AC980156DA2/2');
        QrDetail.INSERT(TRUE);

        QrDetail.INIT;
        QrDetail.Type := QrDetail.Type::"Transfer Pick";
        //QrDetail."Line No." := 50000;
        QrDetail."Item No." := '000012019P04';
        QrDetail."Document No." := 'BIDTO76-04685';
        QrDetail.VALIDATE("QR Text", 'MAH/000012019P04/MAH-19-20-54|76/77-1CDA84ED349D/2');
        QrDetail.INSERT(TRUE);

        QrDetail.INIT;
        QrDetail.Type := QrDetail.Type::"Transfer Pick";
        //QrDetail."Line No." := 60000;
        QrDetail."Item No." := '000012019P04';
        QrDetail."Document No." := 'BIDTO76-04685';
        QrDetail.VALIDATE("QR Text", 'MAH/000012019P04/MAH-19-20-54|76/77-DE43648AB132/2');
        QrDetail.INSERT(TRUE);

        QrDetail.INIT;
        QrDetail.Type := QrDetail.Type::"Transfer Pick";
        //QrDetail."Line No." := 70000;
        QrDetail."Item No." := '000012020P04';
        QrDetail."Document No." := 'BIDTO76-04685';
        QrDetail.VALIDATE("QR Text", 'MAH/000012020P04/MAH-19-20-54|76/77-1F44AE0C5758/2');
        QrDetail.INSERT(TRUE);

        QrDetail.INIT;
        QrDetail.Type := QrDetail.Type::"Transfer Pick";
        //QrDetail."Line No." := 80000;
        QrDetail."Item No." := '000012020P04';
        QrDetail."Document No." := 'BIDTO76-04685';
        QrDetail.VALIDATE("QR Text", 'MAH/000012020P04/MAH-19-20-54|76/77-0537D19EC639/2');
        QrDetail.INSERT(TRUE);

        QrDetail.INIT;
        QrDetail.Type := QrDetail.Type::"Transfer Pick";
        //QrDetail."Line No." := 90000;
        QrDetail."Item No." := '000012020P04';
        QrDetail."Document No." := 'BIDTO76-04685';
        QrDetail.VALIDATE("QR Text", 'MAH/000012020P04/MAH-19-20-54|76/77-EFD6E06DD451/2');
        QrDetail.INSERT(TRUE);
    end;

    local procedure UpdateLotNoItemLedgerEntry()
    var
        ItemLedgerEntry: Record "32";
        InventorySetup: Record "313";
        Item: Record "27";
        WarehouseEntry: Record "7312";
        ItemTranslation: Record "30";
    begin
        InventorySetup.GET;
        InventorySetup.TESTFIELD("Default Old Lot No.");
        Item.RESET;
        Item.SETFILTER("Item Tracking Code", '<>%1', '');
        IF Item.FINDFIRST THEN
            REPEAT
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
                ItemLedgerEntry.SETFILTER("Remaining Quantity", '<>%1', 0);
                //ItemLedgerEntry.SETRANGE("Entry No.",2989065);
                ItemLedgerEntry.SETRANGE("Lot No.", '');
                IF ItemLedgerEntry.FINDFIRST THEN
                    REPEAT
                        ItemLedgerEntry."Lot No." := InventorySetup."Default Old Lot No.";
                        ItemLedgerEntry.MODIFY;
                    UNTIL ItemLedgerEntry.NEXT = 0;

                WarehouseEntry.RESET;
                WarehouseEntry.SETRANGE("Item No.", Item."No.");
                WarehouseEntry.SETRANGE("Lot No.", '');
                IF WarehouseEntry.FINDFIRST THEN
                    REPEAT
                        WarehouseEntry."Lot No." := InventorySetup."Default Old Lot No.";
                        WarehouseEntry.MODIFY;
                    UNTIL WarehouseEntry.NEXT = 0;
            UNTIL Item.NEXT = 0;
    end;

    local procedure UpdatePostingGroupInValueEntry()
    var
        ValueEntry: Record "5802";
        Item: Record "27";
        ItemFirst: Record "27";
    begin
        IF NOT CONFIRM('Do you want to Update Posting Group in Value Entry.') THEN
            ERROR('Aborted by user.');
        ChangeLogSetup.GET;
        ChangeLogSetup."Change Log Activated" := FALSE;
        ChangeLogSetup.MODIFY;
        ProgressWindow.OPEN(Text000);
        ValueEntry.RESET;
        ValueEntry.SETCURRENTKEY("Entry No.", "Item No.");
        //ValueEntry.SETFILTER("Item No.",'%1','0093075');
        ValueEntry.SETFILTER("Item No.", '<>%1', '');
        ValueEntry.SETRANGE("Posting Date", 071719D, 071620D);
        //ValueEntry.SETFILTER("Item Ledger Entry No.",'%1',156506);
        ProgressWindow.UPDATE(1, ValueEntry.COUNT);
        IF ValueEntry.FINDSET THEN BEGIN
            //TotalCount
            REPEAT
                ItemFirst.RESET;
                ItemFirst.SETRANGE("No.", ValueEntry."Item No.");
                IF ItemFirst.FINDFIRST THEN BEGIN
                    IF (ValueEntry."Gen. Prod. Posting Group" <> ItemFirst."Gen. Prod. Posting Group")
                      AND (ValueEntry."Inventory Posting Group" <> ItemFirst."Inventory Posting Group") THEN BEGIN
                        Item.RESET;
                        Item.SETRANGE("No.", ValueEntry."Item No.");
                        IF Item.FINDFIRST THEN BEGIN
                            //Modifying
                            ProgressWindow.UPDATE(3, Item.COUNT);
                            REPEAT
                                ValueEntry."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                                ValueEntry."Inventory Posting Group" := Item."Inventory Posting Group";
                                ValueEntry.MODIFY;
                            UNTIL Item.NEXT = 0;
                        END;
                    END;
                END;
                //Processed
                counttotal += 1;
                ProgressWindow.UPDATE(2, counttotal);
            UNTIL ValueEntry.NEXT = 0;
        END;
        ChangeLogSetup."Change Log Activated" := TRUE;
        ChangeLogSetup.MODIFY;
        ProgressWindow.CLOSE;
        MESSAGE('Successfully Updated...');
    end;

    local procedure UpdatePostingGroupInGLEntry()
    var
        GLEntry: Record "17";
        ValueEntry: Record "5802";
    begin
        IF NOT CONFIRM('Do you want to Update Posting Group in GL Entry.') THEN
            ERROR('Aborted by user.');
        ChangeLogSetup.GET;
        ChangeLogSetup."Change Log Activated" := FALSE;
        ChangeLogSetup.MODIFY;
        ProgressWindow.OPEN(Text000);
        GLEntry.RESET;
        GLEntry.SETCURRENTKEY("Entry No.", "Document No.");
        //GLEntry.SETFILTER("Inventory Posting Group",'%1','');
        GLEntry.SETFILTER("Source Code", 'INVTPCOST');
        GLEntry.SETRANGE("Posting Date", 071719D, 071620D);
        IF GLEntry.FINDSET THEN BEGIN
            //TotalCount
            ProgressWindow.UPDATE(1, GLEntry.COUNT);
            REPEAT
                ValueEntry.RESET;
                ValueEntry.SETRANGE("Document No.", GLEntry."Document No.");
                IF ValueEntry.FINDFIRST THEN BEGIN
                    //Modifying
                    ProgressWindow.UPDATE(3, ValueEntry.COUNT);
                    REPEAT
                        GLEntry."Inventory Posting Group" := ValueEntry."Inventory Posting Group";
                        GLEntry."Gen. Prod. Posting Group" := ValueEntry."Gen. Prod. Posting Group";
                        GLEntry.MODIFY;
                    UNTIL ValueEntry.NEXT = 0;
                END;
                //Processed
                counttotal += 1;
                ProgressWindow.UPDATE(2, counttotal);
            UNTIL GLEntry.NEXT = 0;
        END;
        ChangeLogSetup."Change Log Activated" := TRUE;
        ChangeLogSetup.MODIFY;
        ProgressWindow.CLOSE;
        MESSAGE('Successfully Updated...');
    end;

    local procedure UpdatePostingGroupOnAsterikDocuments()
    var
        ValueEntry: Record "5802";
        GLEntry: Record "17";
        Location: Record "14";
        GLItemLedgRelation: Record "5823";
    begin
        IF NOT CONFIRM('Do you want to Update Posting Group in GL Entry Asterik Document.') THEN
            ERROR('Aborted by user.');
        ProgressWindow.OPEN(Text000);
        GLEntry.RESET;
        GLEntry.SETRANGE("Source Code", 'INVTPCOST');
        GLEntry.SETRANGE("Posting Date", 071719D, 071620D);
        IF GLEntry.FINDSET THEN
            REPEAT
                ProgressWindow.UPDATE(1, GLEntry.COUNT);
                IF GLEntry."Document No." = '*' THEN BEGIN
                    GLItemLedgRelation.RESET;
                    GLItemLedgRelation.SETRANGE("G/L Entry No.", GLEntry."Entry No.");
                    IF GLItemLedgRelation.FINDFIRST THEN BEGIN
                        ProgressWindow.UPDATE(3, GLItemLedgRelation.COUNT);
                        ValueEntry.GET(GLItemLedgRelation."Value Entry No.");
                        GLEntry."Inventory Posting Group" := ValueEntry."Inventory Posting Group";
                        GLEntry."Gen. Prod. Posting Group" := ValueEntry."Gen. Prod. Posting Group";
                        GLEntry.MODIFY;
                    END;
                    //Processed
                    counttotal += 1;
                    ProgressWindow.UPDATE(2, counttotal);
                END;
            UNTIL GLEntry.NEXT = 0;
        MESSAGE('Successfully Updated...');
    end;

    local procedure UpdateDetailCustLedgerEntryLCNo()
    var
        DetailCustLedgerEntry: Record "379";
    begin
        IF NOT CONFIRM('Do you want to Update Posting Group in Value Entry.') THEN
            ERROR('Aborted by user.');
        ChangeLogSetup.GET;
        ChangeLogSetup."Change Log Activated" := FALSE;
        ChangeLogSetup.MODIFY;
        DetailCustLedgerEntry.RESET;
        DetailCustLedgerEntry.SETRANGE("Document No.", 'BIRSPI77-00447');
        IF DetailCustLedgerEntry.FINDFIRST THEN BEGIN
            DetailCustLedgerEntry."Sys. LC No." := 'BG-000001';
            DetailCustLedgerEntry.MODIFY;
        END;
        ChangeLogSetup."Change Log Activated" := TRUE;
        ChangeLogSetup.MODIFY;
        MESSAGE('Successfully Updated...');
    end;

    [Scope('Internal')]
    procedure DeleteInactivefromFA()
    var
        FixedAsset: Record "5600";
    begin
        FixedAsset.RESET;
        FixedAsset.CALCFIELDS("Disposal Date");
        FixedAsset.SETFILTER("Disposal Date", '<>%1', 0D);
        IF FixedAsset.FINDSET THEN BEGIN
            REPEAT
                FixedAsset.Inactive := FALSE;
                FixedAsset.MODIFY;
            UNTIL FixedAsset.NEXT = 0;
        END;

        MESSAGE('Finished!');
    end;

    [Scope('Internal')]
    procedure UpdatePriceIncludingVAT()
    var
        SalePrice: Record "7002";
        SalesAndReceiveSetup: Record "311";
    begin
        SalePrice.RESET;
        SalePrice.SETRANGE("Document Profile", SalePrice."Document Profile"::"Spare Parts Trade");
        SalePrice.SETFILTER("VAT%", '%1', 0);
        IF SalePrice.FINDSET THEN BEGIN
            REPEAT
                SalesAndReceiveSetup.GET;
                SalesAndReceiveSetup.TESTFIELD("Def. Sales VAT %");
                SalePrice."VAT%" := SalesAndReceiveSetup."Def. Sales VAT %";
                SalePrice."Unit Price including VAT" := ROUND((SalePrice."Unit Price" * (1 + SalePrice."VAT%" / 100)), 0.01);
                SalePrice.MODIFY;
            UNTIL SalePrice.NEXT = 0;
        END;

        MESSAGE('Finished!');
    end;

    [Scope('Internal')]
    procedure UpdateDimensionSales()
    var
        SalesHeader: Record "36";
    begin
        /*
        SalesHeader.RESET;
        SalesHeader.SETFILTER("Assigned User ID",'ROSHAN|GOKUL|HARICHANDRA.SHRESTHA|RASHMI.PRADHAN|ANU.KAFLE|NIRU');
        IF SalesHeader.FINDFIRST THEN REPEAT
          SalesHeader."Accountability Center" := 'A-UTRDHOKA';
          SalesHeader.VALIDATE("Shortcut Dimension 1 Code",'501');
          SalesHeader.MODIFY;
        UNTIL SalesHeader.NEXT = 0;
        */
        SalesHeader.RESET;
        SalesHeader.SETFILTER("Assigned User ID", 'PRAKASH|UDDHAB|BALKRISHNA|SANJEEV|RANVIR|KRISHNAKUMAR.PANDEY|DURGA|PRADEEP');
        //'SUDHA.POKHREL|RAMESHWOR|BINAY.KHATRI|BARDAN|RSJAISWAI|PRAKESH|PRATIBHA.SHRESTHA|PRATAP|SANDEEP|RUDRA|DARBIN.POKHREL|NIRANJAN');
        IF SalesHeader.FINDFIRST THEN
            REPEAT
                SalesHeader."Accountability Center" := 'AHO-NEW';
                SalesHeader.VALIDATE("Shortcut Dimension 1 Code", '301');
                SalesHeader.MODIFY;
            UNTIL SalesHeader.NEXT = 0;
        /*
        SalesHeader.RESET;
        SalesHeader.SETFILTER("Assigned User ID",'SURAJ|GANGA.PRADHANANG|EKTA|EKTA.SHRESTHA|ROMAN.SHRESTHA');
        IF SalesHeader.FINDFIRST THEN REPEAT
          SalesHeader."Accountability Center" := 'A-NAXAL';
          SalesHeader.VALIDATE("Shortcut Dimension 1 Code",'401');
          SalesHeader.MODIFY;
        UNTIL SalesHeader.NEXT = 0;
        */
        SalesHeader.RESET;
        //SalesHeader.SETFILTER("Assigned User ID",'LAXMAN|BIJENDRA|SUBHAS');
        SalesHeader.SETFILTER("Assigned User ID", 'SUBHAS');
        IF SalesHeader.FINDFIRST THEN
            REPEAT
                SalesHeader."Accountability Center" := 'ABR';
                SalesHeader.VALIDATE("Shortcut Dimension 1 Code", '201');
                SalesHeader.MODIFY;
            UNTIL SalesHeader.NEXT = 0;

    end;

    [Scope('Internal')]
    procedure UpdateDimensionPUR()
    var
        PurchaseHeader: Record "38";
    begin
        PurchaseHeader.RESET;
        PurchaseHeader.SETFILTER("Assigned User ID", 'BINNY.MAINALI');
        IF PurchaseHeader.FINDFIRST THEN
            REPEAT
                PurchaseHeader."Accountability Center" := 'A-UTRDHOKA';
                PurchaseHeader.VALIDATE("Shortcut Dimension 1 Code", '501');
                PurchaseHeader.MODIFY;
            UNTIL PurchaseHeader.NEXT = 0;

        PurchaseHeader.RESET;
        PurchaseHeader.SETFILTER("Assigned User ID",
        'LELIZA.MASKEY|NARENDRA|NIRU');
        IF PurchaseHeader.FINDFIRST THEN
            REPEAT
                PurchaseHeader."Accountability Center" := 'AHO-NEW';
                PurchaseHeader.VALIDATE("Shortcut Dimension 1 Code", '301');
                PurchaseHeader.MODIFY;
            UNTIL PurchaseHeader.NEXT = 0;

        PurchaseHeader.RESET;
        PurchaseHeader.SETFILTER("Assigned User ID", 'JAMUNA.NEUPANE');
        IF PurchaseHeader.FINDFIRST THEN
            REPEAT
                PurchaseHeader."Accountability Center" := 'A-NAXAL';
                PurchaseHeader.VALIDATE("Shortcut Dimension 1 Code", '401');
                PurchaseHeader.MODIFY;
            UNTIL PurchaseHeader.NEXT = 0;

        PurchaseHeader.RESET;
        PurchaseHeader.SETFILTER("Assigned User ID", 'RABINDRA|BASANT|AMRITBRJ');
        IF PurchaseHeader.FINDFIRST THEN
            REPEAT
                PurchaseHeader."Accountability Center" := 'ABR';
                PurchaseHeader.VALIDATE("Shortcut Dimension 1 Code", '201');
                PurchaseHeader.MODIFY;
            UNTIL PurchaseHeader.NEXT = 0;
    end;

    local procedure RemoveSymbolsFromItem()
    var
        Item: Record "27";
        NewItemCode: Code[20];
        Starttime: Time;
        Endttime: Time;
    begin
        Starttime := TIME;
        Item.RESET;
        //Item.SETRANGE("No.",'WIRE/UV 2X2.5MM2');
        //item.SETFILTER("No.",'*/*');
        IF Item.FINDSET THEN
            REPEAT
                NewItemCode := DELCHR(Item."No.", '=', '/,"');
                IF Item."No." <> NewItemCode THEN
                    Item.RENAME(NewItemCode);
            UNTIL Item.NEXT = 0;
        Endttime := TIME;
        MESSAGE('Start Time: ' + FORMAT(Starttime) + 'End time:' + FORMAT(Endttime));
    end;

    local procedure UpdateReservationEntry()
    var
        TransferHeader: Record "5740";
        TransferLine: Record "5741";
        ReservationEntry: Record "337";
        Item: Record "27";
        InventorySetup: Record "313";
        TransferShipmentHeader: Record "5744";
        ItemLedgerEntry: Record "32";
        TransitLine: Record "5741";
        EntryNo: Integer;
        ServiceDocument: Boolean;
    begin
        InventorySetup.GET;

        ReservationEntry.RESET;
        ReservationEntry.LOCKTABLE;
        IF ReservationEntry.FINDLAST THEN
            EntryNo := ReservationEntry."Entry No." + 1;

        TransferLine.RESET;
        //TransferLine.SETRANGE("Document Date",071620D,012221D);
        //TransferLine.SETRANGE("Document No.",'BRRTO77-02499');
        TransferLine.SETFILTER("Quantity Shipped", '<>0');
        TransferLine.SETFILTER("Quantity Received", '0');
        TransferLine.SETRANGE("Derived From Line No.", 0);
        IF TransferLine.FINDFIRST THEN BEGIN
            TransferHeader.GET(TransferLine."Document No.");
            IF TransferHeader."Source No." <> '' THEN
                ServiceDocument := TRUE;

            REPEAT
                TransitLine.RESET;
                TransitLine.SETRANGE("Document No.", TransferLine."Document No.");
                TransitLine.SETRANGE("Derived From Line No.", TransferLine."Line No.");
                TransitLine.FINDFIRST;
                //TransferShipmentHeader.RESET;
                //TransferShipmentHeader.SETRANGE("Transfer Order No.",TransferLine."Document No.");
                //TransferShipmentHeader.FINDFIRST;
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Order No.", TransferLine."Document No.");
                ItemLedgerEntry.SETRANGE("Item No.", TransferLine."Item No.");
                ItemLedgerEntry.SETRANGE("Order Line No.", TransferLine."Line No.");
                ItemLedgerEntry.FINDFIRST;
                Item.RESET;
                Item.SETRANGE("No.", TransferLine."Item No.");
                IF Item.FINDFIRST THEN BEGIN
                    IF Item."Item Tracking Code" <> '' THEN BEGIN
                        IF ServiceDocument THEN BEGIN
                            ReservationEntry.RESET;
                            ReservationEntry.SETRANGE("Source ID", TransferHeader."Source No.");
                            ReservationEntry.SETRANGE("Item No.", TransferLine."Item No.");
                            IF ReservationEntry.FINDSET THEN
                                REPEAT
                                    ReservationEntry."Lot No." := InventorySetup."Default Old Lot No.";
                                    ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                                    ReservationEntry.MODIFY;
                                UNTIL ReservationEntry.NEXT = 0;
                        END;
                        ReservationEntry.RESET;
                        ReservationEntry.SETRANGE("Source ID", TransferLine."Document No.");
                        ReservationEntry.SETRANGE("Item No.", TransferLine."Item No.");
                        IF ReservationEntry.FINDFIRST THEN BEGIN
                            REPEAT
                                ReservationEntry."Lot No." := InventorySetup."Default Old Lot No.";
                                ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                                ReservationEntry.MODIFY;
                            UNTIL ReservationEntry.NEXT = 0;
                        END ELSE BEGIN
                            ReservationEntry.INIT;
                            ReservationEntry."Entry No." := EntryNo;
                            ReservationEntry."Item No." := TransferLine."Item No.";
                            ReservationEntry."Location Code" := TransferLine."Transfer-to Code";
                            ReservationEntry.Quantity := TransferLine."Quantity Shipped";
                            ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
                            ReservationEntry."Source Type" := 5741;
                            ReservationEntry."Source Subtype" := 1;
                            ReservationEntry."Source ID" := TransferLine."Document No.";
                            ReservationEntry.Positive := TRUE;
                            ReservationEntry."Qty. per Unit of Measure" := 1;
                            ReservationEntry."Quantity (Base)" := TransferLine."Quantity Shipped";
                            ReservationEntry."Qty. to Handle (Base)" := TransferLine."Quantity Shipped";
                            ReservationEntry."Qty. to Invoice (Base)" := TransferLine."Quantity Shipped";
                            ReservationEntry."Lot No." := InventorySetup."Default Old Lot No.";
                            ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                            ReservationEntry."Item Ledger Entry No." := ItemLedgerEntry."Entry No.";
                            ReservationEntry."Source Prod. Order Line" := TransferLine."Line No.";
                            ReservationEntry."Source Ref. No." := TransitLine."Line No.";
                            ReservationEntry.INSERT;
                            EntryNo += 1;
                        END;
                    END;
                END;
            UNTIL TransferLine.NEXT = 0;
        END;
    end;

    local procedure UpdateCostingMethodItem()
    begin
        Item.RESET;
        //Item.SETRANGE("No." , '931000-15095');
        Item.SETRANGE(Inventory, 0);
        Item.SETRANGE("Costing Method", Item."Costing Method"::FIFO);
        ProgressWindow.OPEN(Text000);
        ProgressWindow.UPDATE(1, Item.COUNT);
        IF Item.FINDFIRST THEN BEGIN
            MESSAGE(FORMAT(Item."No."));
            REPEAT
                ProgressWindow.UPDATE(3, Item.COUNT);
                Item."Costing Method" := Item."Costing Method"::Average;
                Item.MODIFY;
                MESSAGE(FORMAT(Item."Costing Method"));
                counttotal += 1;
                ProgressWindow.UPDATE(2, counttotal);
            UNTIL Item.NEXT = 0;
            MESSAGE('Successfully Updated...');
        END;
    end;

    local procedure UpdateDealerPO()
    var
        SalesHdrArchive: Record "5107";
        SalesInvHead: Record "112";
    begin
        IF NOT CONFIRM('Do you want to Update Dealer PO No. in Sales Header Archive by Order No.?') THEN
            ERROR('Aborted by user.');
        SalesInvHead.RESET;//aakrista.
        SalesInvHead.SETFILTER("Dealer PO No.", '<>%1', '');
        ProgressWindow.OPEN(Text000);
        ProgressWindow.UPDATE(1, SalesInvHead.COUNT);
        IF SalesInvHead.FINDSET THEN
            REPEAT
                SalesHdrArchive.RESET;
                SalesHdrArchive.SETRANGE("No.", SalesInvHead."Order No.");
                IF SalesHdrArchive.FINDFIRST THEN
                    REPEAT
                        ProgressWindow.UPDATE(3, SalesHdrArchive.COUNT);
                        SalesHdrArchive."Dealer PO No." := SalesInvHead."Dealer PO No.";
                        SalesHdrArchive.MODIFY;
                        counttotal += 1;
                        ProgressWindow.UPDATE(2, counttotal);
                    UNTIL SalesHdrArchive.NEXT = 0;
            UNTIL SalesInvHead.NEXT = 0;
        MESSAGE('Updated Successfully.');
    end;

    local procedure UpdateDealerPONoThroughQuoteNo()
    begin
        IF NOT CONFIRM('Do you want to Update Dealer PO No. in Sales Header Archive by Quote No.?') THEN
            ERROR('Aborted by user.');
        SalesInvHead.RESET;
        SalesInvHead.SETFILTER("Dealer PO No.", '<>%1', '');
        ProgressWindow.OPEN(Text000);
        ProgressWindow.UPDATE(1, SalesInvHead.COUNT);
        IF SalesInvHead.FINDSET THEN
            REPEAT
                SalesHdrArchive.RESET;
                SalesHdrArchive.SETRANGE("No.", SalesInvHead."Quote No.");
                IF SalesHdrArchive.FINDFIRST THEN
                    REPEAT
                        ProgressWindow.UPDATE(3, SalesHdrArchive.COUNT);
                        SalesHdrArchive."Dealer PO No." := SalesInvHead."Dealer PO No.";
                        SalesHdrArchive.MODIFY;
                        counttotal += 1;
                        ProgressWindow.UPDATE(2, counttotal);
                    UNTIL SalesHdrArchive.NEXT = 0;
            UNTIL SalesInvHead.NEXT = 0;
        MESSAGE('Updated Successfully.');
    end;

    local procedure UpdateCustomerName()
    begin
        SalesInvHead.RESET;
        SalesInvHead.SETRANGE("Posting Date", 111121D);
        SalesInvHead.SETFILTER("Bill-to Name", '');
        IF SalesInvHead.FINDSET THEN
            REPEAT
                SalesInvHead."Bill-to Name" := SalesInvHead."Sell-to Customer Name";
                SalesInvHead.MODIFY;
            UNTIL SalesInvHead.NEXT = 0;
    end;

    local procedure UpdateCustNameMaterilaize()
    var
        SalesInvMat: Record "33020293";
        Cust: Record "18";
    begin
        IF NOT CONFIRM('Do you want to Update Cust Name in Sales Inv. Materialize?') THEN
            ERROR('Aborted by user.');
        SalesInvMat.RESET;
        SalesInvMat.SETFILTER("Customer Name", '');
        SalesInvMat.SETRANGE("Bill Date", 101821D, 111621D);
        ProgressWindow.OPEN(Text000);
        ProgressWindow.UPDATE(1, SalesInvMat.COUNT);
        IF SalesInvMat.FINDSET THEN
            REPEAT
                IF Cust.GET(SalesInvMat."Customer Code") THEN BEGIN
                    ProgressWindow.UPDATE(3, Cust.COUNT);
                    SalesInvMat."Customer Name" := Cust.Name;
                    SalesInvMat.MODIFY;
                    counttotal += 1;
                    ProgressWindow.UPDATE(2, counttotal);
                END;
            UNTIL SalesInvMat.NEXT = 0;
        MESSAGE('Updated Successfully.');
    end;

    local procedure UpdateExemptPurchNoInGLEntry()
    var
        GLEntry: Record "17";
    begin
        IF NOT CONFIRM('Do you want to Update Exempt Purchase No. in GL Entry.') THEN
            ERROR('Aborted by user.');
        ChangeLogSetup.GET;
        ChangeLogSetup."Change Log Activated" := FALSE;
        ChangeLogSetup.MODIFY;
        ProgressWindow.OPEN(Text000);
        GLEntry.RESET;
        GLEntry.SETFILTER("Document No.", 'AHOIPPI78-000835');
        GLEntry.SETRANGE("Document Type", GLEntry."Document Type"::Invoice);
        IF GLEntry.FINDFIRST THEN
            REPEAT
                GLEntry."Exempt Purchase No." := 'EXPT78-00005';
                GLEntry.MODIFY;
            UNTIL GLEntry.NEXT = 0;
        ChangeLogSetup."Change Log Activated" := TRUE;
        ChangeLogSetup.MODIFY;
        MESSAGE('Successfully Updated...');
    end;

    local procedure UpdateExemptPurchNoInVATEntry()
    var
        VatEntry: Record "254";
    begin
        IF NOT CONFIRM('Do you want to Update Exempt Purchase No. in VAT Entry.') THEN
            ERROR('Aborted by user.');
        ChangeLogSetup.GET;
        ChangeLogSetup."Change Log Activated" := FALSE;
        ChangeLogSetup.MODIFY;
        ProgressWindow.OPEN(Text000);
        VatEntry.RESET;
        VatEntry.SETFILTER("Document No.", 'AHOIPPI78-000835');
        IF VatEntry.FINDFIRST THEN
            REPEAT
                VatEntry."Exempt Purchase No." := 'EXPT78-00005';
                VatEntry.MODIFY;
            UNTIL VatEntry.NEXT = 0;
        ChangeLogSetup."Change Log Activated" := TRUE;
        ChangeLogSetup.MODIFY;
        MESSAGE('Successfully Updated...');
    end;

    local procedure UpdateItemLedgerEntries()
    var
        ItemLedgerEntry: Record "32";
    begin

        ChangeLogSetup.GET;
        ChangeLogSetup."Change Log Activated" := FALSE;
        ChangeLogSetup.MODIFY;
        /*
        ItemLedgerEntry.RESET;
        //ItemLedgerEntry.SETCURRENTKEY("Remaining Quantity");
        ItemLedgerEntry.SETFILTER("Remaining Quantity",'<%1',0);
        IF ItemLedgerEntry.FINDSET THEN REPEAT
          ItemLedgerEntry."Remaining Quantity" := 0;
          ItemLedgerEntry.Open := FALSE;
          ItemLedgerEntry.MODIFY;
        UNTIL ItemLedgerEntry.NEXT = 0;
        */

        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Posting Date", 010120D, TODAY);
        ItemLedgerEntry.SETFILTER("Transfer Source No.", '<>%1', '');
        ItemLedgerEntry.SETFILTER("Remaining Quantity", '>%1', 0);
        ItemLedgerEntry.SETRANGE("Document Type", ItemLedgerEntry."Document Type"::"Transfer Receipt");
        IF ItemLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                SalesInvoiceHeader.RESET;
                SalesInvoiceHeader.SETRANGE("Service Order No.", ItemLedgerEntry."Transfer Source No.");
                SalesInvoiceHeader.SETFILTER("Accountability Center", '%1|%2', 'BIR', 'GDK');
                IF SalesInvoiceHeader.FINDFIRST THEN BEGIN
                    ItemLedgerEntry."Remaining Quantity" := 0;
                    ItemLedgerEntry.Open := FALSE;
                    ItemLedgerEntry.MODIFY;
                END;
            UNTIL ItemLedgerEntry.NEXT = 0;
        END;

        ChangeLogSetup."Change Log Activated" := TRUE;
        ChangeLogSetup.MODIFY;


        MESSAGE('Updated');

    end;

    local procedure UpdateItemApplicationEntry()
    var
        ItemApplicationEntry: Record "339";
        ItemLedgerEntry: Record "32";
    begin
        /*ItemApplicationEntry.RESET;
        ItemApplicationEntry.SETFILTER("Entry No.",'459039|459041');
        IF ItemApplicationEntry.FINDFIRST THEN REPEAT
          ItemApplicationEntry."Inbound Item Entry No." := 458192;
          ItemApplicationEntry.MODIFY;
        UNTIL ItemApplicationEntry.NEXT = 0;
        
        */

        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETFILTER("Entry No.", '445090|445089');
        IF ItemLedgerEntry.FINDFIRST THEN
            REPEAT
                ItemLedgerEntry."Remaining Quantity" := 1;
                ItemLedgerEntry.Open := TRUE;
                ItemLedgerEntry.MODIFY;
            UNTIL ItemLedgerEntry.NEXT = 0;

        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETFILTER("Entry No.", '458192');
        IF ItemLedgerEntry.FINDFIRST THEN
            REPEAT
                ItemLedgerEntry."Remaining Quantity" := 0;
                ItemLedgerEntry.Open := FALSE;
                ItemLedgerEntry.MODIFY;
            UNTIL ItemLedgerEntry.NEXT = 0;

        MESSAGE('Done');

    end;

    local procedure TempCode()
    var
        TransferLine: Record "5741";
    begin
        TransferLine.RESET;
        TransferLine.SETRANGE("Document No.", 'BRRTO77-01809');
        IF TransferLine.FINDFIRST THEN BEGIN
            TransferLine."Qty. Received (Base)" := 3;
            TransferLine.MODIFY;
        END;
        MESSAGE('complete');
    end;

    [Scope('Internal')]
    procedure UpdateInstallMentNo()
    var
        VehPayMentLineRec: Record "33020072";
    begin
        VehPayMentLineRec.GET('LO-000154', 11, 10000);
        VehPayMentLineRec.RENAME('LO-000154', 10, 10000);
    end;

    local procedure DeleteSalesShipment()
    begin
        SalesShipmentLine.RESET;
        SalesShipmentLine.SETRANGE("Document No.", 'BIRSPS80-01050');
        SalesShipmentLine.SETFILTER("Line No.", '%1|%2|%3|%4|%5|%6|%7|%8|%9|%10', 290000, 300000, 440000, 450000, 610000, 620000, 160000, 170000, 180000, 190000);
        IF SalesShipmentLine.FINDSET THEN
            REPEAT
                SalesShipmentLine.DELETE;
            UNTIL SalesShipmentLine.NEXT = 0;
    end;

    local procedure updateSalesIncBase()
    var
        SalesLine: Record "37";
    begin
        /*
        SalesShipmentLine.RESET;
        SalesShipmentLine.SETRANGE("Document No.",'SNBSPS80-00952');
        SalesShipmentLine.SETRANGE("Line No.",680000);
        IF SalesShipmentLine.FINDFIRST THEN
          SalesShipmentLine."Qty. Invoiced (Base)" := 0;
        SalesShipmentLine.MODIFY;
        MESSAGE('done');
        */

        SalesLine.RESET;
        SalesLine.SETRANGE("Document No.", 'SNBSO80-01053');
        SalesLine.SETFILTER("Line No.", '%1|%2|%3', 570000, 610000, 1540000);
        IF SalesLine.FINDSET THEN
            REPEAT
                IF SalesLine."Line No." = 570000 THEN BEGIN
                    SalesLine.VALIDATE("Outstanding Quantity", 10);
                    SalesLine.VALIDATE("Qty. Shipped Not Invoiced", 0);
                    SalesLine.VALIDATE("Quantity Shipped", 0);
                    SalesLine.VALIDATE("Shipped Not Invoiced", 0);
                    SalesLine.VALIDATE("Shipped Not Invoiced (LCY)", 0);
                    SalesLine.VALIDATE("Qty. Shipped Not Invd. (Base)", 0);
                END;
                SalesLine.VALIDATE("Quantity Invoiced", 0);
                SalesLine.VALIDATE("Qty. Invoiced (Base)", 0);
                SalesLine.MODIFY;
            UNTIL SalesLine.NEXT = 0;

    end;
}


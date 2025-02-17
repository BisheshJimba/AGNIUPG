codeunit 33019834 "Temp. Codeunit"
{
    Permissions = TableData 115 = rm;

    trigger OnRun()
    var
        DateForm: DateFormula;
        SL: Record "25006121";
    begin
        //UpdateImportInvoice;
        //UpdatePostedServiceLine; //MIN 3/11/2019
        //UpdatePostedCreditMemos;
        //UpdateDealerPO;
        //UpdateDimensionsInItemLedgerEntry;
        UpdateProcurementType;
        MESSAGE('DONE');
    end;

    var
        scheduleres: Record "25006275";
        Resource: Record "156";
        Vehicle: Record "25006005";
        totalcount: Integer;
        ProgressWindow: Dialog;
        Text000: Label '#1###### of #2######## Records being Processed for #3######.';
        SalesPrice: Record "7002";
        PostedService: Record "25006149";
        WarrantyEntries: Record "33020249";
        Item: Record "27";
        SalesLine: Record "37";
        TotalModified: Integer;

    [Scope('Internal')]
    procedure UpdateVehicleModel()
    begin
        ProgressWindow.OPEN(Text000);
        Vehicle.RESET;
        Vehicle.SETCURRENTKEY(VIN);
        Vehicle.SETFILTER(VIN, '<>%1', '');
        IF Vehicle.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, Vehicle.COUNT);
            REPEAT
                Vehicle.VALIDATE(VIN, Vehicle.VIN);
                Vehicle.MODIFY;
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);
            UNTIL Vehicle.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateScheduleResDescription()
    begin
        scheduleres.RESET;
        IF scheduleres.FINDFIRST THEN BEGIN
            REPEAT
                scheduleres.VALIDATE("Resource No.", scheduleres."Resource No.");
                scheduleres.MODIFY;
            UNTIL scheduleres.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateItemUnitOfMeasure()
    var
        Item: Record "27";
        ItemUnitOfMeasure: Record "5404";
        RecItem: Record "27";
        ItemLedgEntry: Record "32";
    begin
        ProgressWindow.OPEN(Text000);
        Item.RESET;
        Item.SETRANGE("Item Type", Item."Item Type"::Item);
        Item.SETRANGE("Base Unit of Measure", '');
        IF Item.FINDFIRST THEN BEGIN
            ProgressWindow.UPDATE(2, Item.COUNTAPPROX);
            REPEAT
                ItemLedgEntry.RESET;
                ItemLedgEntry.SETRANGE("Item No.", Item."No.");
                IF NOT ItemLedgEntry.FINDFIRST THEN BEGIN
                    ItemUnitOfMeasure.RESET;
                    ItemUnitOfMeasure.SETCURRENTKEY("Item No.", Code);
                    ItemUnitOfMeasure.SETRANGE("Item No.", Item."No.");
                    ItemUnitOfMeasure.SETRANGE("Qty. per Unit of Measure", 1);
                    IF ItemUnitOfMeasure.FINDFIRST THEN BEGIN
                        RecItem := Item;
                        RecItem.VALIDATE("Base Unit of Measure", ItemUnitOfMeasure.Code);
                        RecItem.MODIFY;
                    END;
                END;
                totalcount := totalcount + 1;
                ProgressWindow.UPDATE(1, totalcount);
            UNTIL Item.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure ModifyMAT()
    var
        tempMat: Record "33019842";
        vehicle: Record "25006005";
    begin
        /*totalcount :=0;
        tempMat.RESET;
        IF tempMat.FINDFIRST THEN BEGIN
        MESSAGE(FORMAT(tempMat.COUNT));
        REPEAT
          vehicle.RESET;
          vehicle.SETCURRENTKEY(VIN);
          vehicle.SETRANGE(VIN,tempMat."Old Value");
          IF vehicle.FINDFIRST THEN BEGIN
            vehicle.VIN := tempMat."New Value";
            vehicle.MODIFY;
            totalcount := totalcount +1;
          END;
        UNTIL tempMat.NEXT=0;
        
        END;
         */

    end;

    [Scope('Internal')]
    procedure UpdateDRPNo()
    var
        vehicle: Record "25006005";
        temptable: Record "33019842";
    begin
        temptable.RESET;
        totalcount := 0;
        IF temptable.FINDFIRST THEN BEGIN
            REPEAT
                vehicle.RESET;
                vehicle.SETCURRENTKEY(VIN);
                vehicle.SETRANGE(VIN, temptable."New Value");
                IF vehicle.FINDFIRST THEN BEGIN
                    vehicle."DRP No./ARE1 No." := temptable."Old Value";
                    vehicle.MODIFY;
                    totalcount := totalcount + 1;
                END;
            UNTIL temptable.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure FindInvalidBin()
    var
        Bin: Record "7354";
        BinContent: Record "7302";
        tempTable: Record "33019842";
    begin
        ProgressWindow.OPEN(Text000);
        BinContent.RESET;
        IF BinContent.FINDFIRST THEN BEGIN
            ProgressWindow.UPDATE(2, BinContent.COUNT);
            REPEAT
                ProgressWindow.UPDATE(1, totalcount);
                Bin.RESET;
                Bin.SETRANGE("Location Code", BinContent."Location Code");
                Bin.SETRANGE(Code, BinContent."Bin Code");
                IF NOT Bin.FINDFIRST THEN BEGIN
                    CLEAR(tempTable);
                    tempTable.INIT;
                    tempTable."New Value" := BinContent."Location Code";
                    tempTable."Old Value" := BinContent."Bin Code";
                    tempTable.INSERT;
                END;
                totalcount += 1;
            UNTIL BinContent.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure CreateTransferRoutes()
    var
        TransferRoute: Record "5742";
        LocationFrom: Record "14";
        LocationTo: Record "14";
        IntransitCode: Code[10];
        Text000: Label 'Creating Transfer Routes for #1##############\';
        Text001: Label '#2#############';
    begin
        ProgressWindow.OPEN(Text000 + Text001);
        LocationFrom.RESET;
        IF LocationFrom.FINDFIRST THEN BEGIN
            REPEAT
                // IF (LocationFrom."Use As Store") OR (LocationFrom."Use As Service Location") THEN BEGIN
                ProgressWindow.UPDATE(1, LocationFrom.Code);
                LocationTo.RESET;
                IF LocationTo.FINDFIRST THEN BEGIN
                    REPEAT
                        //IF (NOT LocationFrom."Use As Store") OR ( NOT LocationFrom."Use As Service Location") THEN BEGIN
                        IF LocationTo.Code <> LocationFrom.Code THEN BEGIN
                            ProgressWindow.UPDATE(2, LocationTo.Code);
                            CLEAR(TransferRoute);
                            TransferRoute.INIT;
                            TransferRoute."Transfer-from Code" := LocationFrom.Code;
                            TransferRoute."Transfer-to Code" := LocationTo.Code;
                            TransferRoute."In-Transit Code" := 'IN-TRANSIT';
                            TransferRoute.INSERT;
                        END;
                    UNTIL LocationTo.NEXT = 0;
                END;
            // END;
            UNTIL LocationFrom.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateSalesPrice()
    var
        SalesPrice: Record "7002";
        Text000: Label '#1####### of #2######## records processed.';
    begin
        SalesPrice.RESET;
        totalcount := 0;
        ProgressWindow.OPEN(Text000);
        IF SalesPrice.FINDFIRST THEN BEGIN
            ProgressWindow.UPDATE(2, SalesPrice.COUNT);
            REPEAT
                SalesPrice."Minimum Quantity" := 0;
                SalesPrice.MODIFY(TRUE);
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);
            UNTIL SalesPrice.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateModelFilterInItem()
    var
        ItemVehicleModel: Record "25006755";
        Item: Record "27";
        Text000: Label '#1####### of #2####### records.';
    begin
        ItemVehicleModel.RESET;
        ProgressWindow.OPEN(Text000);
        IF ItemVehicleModel.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, ItemVehicleModel.COUNT);

            REPEAT
                Item.RESET;
                Item.SETCURRENTKEY("No.");
                Item.SETRANGE("No.", ItemVehicleModel."No.");
                IF Item.FINDFIRST THEN BEGIN
                    IF (Item."Model Filter 1" <> '') AND (STRLEN(Item."Model Filter 1") < 230) THEN BEGIN
                        IF STRPOS(Item."Model Filter 1", '|' + ItemVehicleModel."Model No.") = 0 THEN
                            Item."Model Filter 1" := Item."Model Filter 1" + '|' + ItemVehicleModel."Model No."
                    END
                    ELSE
                        IF Item."Model Filter 1" = '' THEN
                            Item."Model Filter 1" := ItemVehicleModel."Model No."
                        ELSE
                            IF (Item."Model Filter 2" <> '') AND (STRLEN(Item."Model Filter 2") < 230) THEN BEGIN
                                IF STRPOS(Item."Model Filter 2", '|' + ItemVehicleModel."Model No.") = 0 THEN
                                    Item."Model Filter 2" := Item."Model Filter 2" + '|' + ItemVehicleModel."Model No."
                            END
                            ELSE
                                IF Item."Model Filter 2" = '' THEN
                                    Item."Model Filter 2" := ItemVehicleModel."Model No."
                END;
                Item.MODIFY;
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);
            UNTIL ItemVehicleModel.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateVehicleForSanjivani(SalesHeader: Record "36")
    var
        Vehicle: Record "25006005";
        SchemeRegVeh: Record "33020240";
        EndDate: Date;
        Text000: Label 'Sanjivani Scheme for Vehicle with VIN %1 and Registration No. %2 is expired. Do you want to re-register the vehicle for Sanjivani Scheme?';
        Text001: Label 'Do you want to register Vehicle with VIN %1 and Registration No. %2 for Sanjivani?';
    begin
        SchemeRegVeh.RESET;
        SchemeRegVeh.SETRANGE("VIN Code", SalesHeader.VIN);
        SchemeRegVeh.SETRANGE("Scheme Type", SchemeRegVeh."Scheme Type"::SANJIVANI);
        IF SchemeRegVeh.FINDLAST THEN BEGIN
            IF SchemeRegVeh."Valid Until" < TODAY THEN BEGIN // if true sanjivani period is expired.
                IF CONFIRM(Text000, FALSE, SalesHeader.VIN, SalesHeader."Vehicle Regd. No.") THEN
                    RegisterSanjivani(SalesHeader);
            END
        END
        ELSE BEGIN
            IF CONFIRM(Text001, FALSE, SalesHeader.VIN, SalesHeader."Vehicle Regd. No.") THEN
                RegisterSanjivani(SalesHeader);
        END;
    end;

    [Scope('Internal')]
    procedure GetValidSanjivaniPeriod(var ValidityPeriod: DateFormula; SalesHeader: Record "36")
    var
        ServicePackageVersion: Record "25006135";
        SalesLine: Record "25006146";
        ServicePackage: Record "25006134";
    begin
        SalesLine.RESET;
        SalesLine.SETCURRENTKEY("Document Type", "Document No.");
        SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETRANGE("Package No.", '<>''');
        IF SalesLine.FINDSET THEN BEGIN
            ServicePackage.RESET;
            ServicePackage.SETRANGE("No.", SalesLine."Package No.");
            IF ServicePackage.FINDFIRST THEN
                ValidityPeriod := ServicePackage."Validity (Sanjivani)";
        END;
    end;

    [Scope('Internal')]
    procedure RegisterSanjivani(SalesHeader: Record "36")
    var
        Vehicle: Record "25006005";
        SchemeRegVeh: Record "33020240";
        ValidityPeriod: DateFormula;
    begin
        SchemeRegVeh.RESET;
        SchemeRegVeh.INIT;
        SchemeRegVeh."VIN Code" := SalesHeader.VIN;
        SchemeRegVeh."Scheme Type" := SchemeRegVeh."Scheme Type"::SANJIVANI;
        SchemeRegVeh."Start Date" := TODAY;
        GetValidSanjivaniPeriod(ValidityPeriod, SalesHeader);
        SchemeRegVeh.VALIDATE(Period, ValidityPeriod);
        SchemeRegVeh."Registered By" := USERID;
        SchemeRegVeh.INSERT;
        Vehicle.RESET;
        IF Vehicle.GET(SalesHeader."Vehicle Serial No.") THEN BEGIN
            IF Vehicle."Sanjivani Registered" <> TRUE THEN BEGIN
                Vehicle."Sanjivani Registered" := TRUE;
                Vehicle.MODIFY;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure testSanj()
    var
        ServicePackageVersion: Record "25006135";
        SalesLine: Record "37";
        ServicePackage: Record "25006134";
    begin
        SalesLine.RESET;
        SalesLine.SETCURRENTKEY("Document Type", "Document No.");
        SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Invoice);
        SalesLine.SETRANGE("Document No.", 'NKP-SC-CV1-SI-00033');
        SalesLine.SETFILTER("Package No.", '<>''''');
        IF SalesLine.FINDSET THEN BEGIN
            MESSAGE('f');
            ServicePackage.RESET;
            ServicePackage.SETRANGE("No.", SalesLine."Package No.");
            IF ServicePackage.FINDFIRST THEN
                MESSAGE(FORMAT(ServicePackage."Validity (Sanjivani)"));
        END;
    end;

    [Scope('Internal')]
    procedure getLocWiseNoSeries("Document Profile": Option Purchase,Sales,Service,Transfer; "Document Type": Option Quote,"Blanket Order","Order","Return Order",Invoice,"Posted Invoice","Credit Memo","Posted Credit Memo","Posted Shipment","Posted Receipt","Posted Prepmt. Inv.","Posted Prepmt. Cr. Memo","Posted Return Receipt","Posted Return Shipment",Booking,"Posted Order","Posted Debit Note"): Code[10]
    var
        ResponsibilityCenter: Record "5714";
        UserSetup: Record "91";
    begin
        // Sipradi-YS BEGIN >> Returns Posting No. Series for current User as per Location Code, Document Profile, Document Type
        UserSetup.GET(USERID);
        IF ResponsibilityCenter.GET(UserSetup."Default Responsibility Center") THEN BEGIN
            CASE "Document Profile" OF
                "Document Profile"::Purchase:
                    BEGIN
                        CASE "Document Type" OF
                            "Document Type"::Quote:
                                EXIT(ResponsibilityCenter."Purch. Quote Nos.");
                            "Document Type"::"Blanket Order":
                                EXIT(ResponsibilityCenter."Purch. Blanket Order Nos.");
                            "Document Type"::Order:
                                EXIT(ResponsibilityCenter."Purch. Order Nos.");
                            "Document Type"::"Return Order":
                                EXIT(ResponsibilityCenter."Purch. Return Order Nos.");
                            "Document Type"::Invoice:
                                EXIT(ResponsibilityCenter."Purch. Invoice Nos.");
                            "Document Type"::"Posted Invoice":
                                EXIT(ResponsibilityCenter."Purch. Posted Invoice Nos.");
                            "Document Type"::"Credit Memo":
                                EXIT(ResponsibilityCenter."Purch. Credit Memo Nos.");
                            "Document Type"::"Posted Credit Memo":
                                EXIT(ResponsibilityCenter."Purch. Posted Credit Memo Nos.");
                            "Document Type"::"Posted Receipt":
                                EXIT(ResponsibilityCenter."Purch. Posted Receipt Nos.");
                            "Document Type"::"Posted Return Shipment":
                                EXIT(ResponsibilityCenter."Purch. Ptd. Return Shpt. Nos.");

                        END;
                    END;
                "Document Profile"::Sales:
                    BEGIN
                        CASE "Document Type" OF
                            "Document Type"::Quote:
                                EXIT(ResponsibilityCenter."Sales Quote Nos.");
                            "Document Type"::"Blanket Order":
                                EXIT(ResponsibilityCenter."Sales Blanket Order Nos.");
                            "Document Type"::Order:
                                EXIT(ResponsibilityCenter."Sales Order Nos.");
                            "Document Type"::"Return Order":
                                EXIT(ResponsibilityCenter."Sales Return Order Nos.");
                            "Document Type"::Invoice:
                                EXIT(ResponsibilityCenter."Sales Invoice Nos.");
                            "Document Type"::"Posted Invoice":
                                EXIT(ResponsibilityCenter."Sales Posted Invoice Nos.");
                            "Document Type"::"Credit Memo":
                                EXIT(ResponsibilityCenter."Sales Credit Memo Nos.");
                            "Document Type"::"Posted Credit Memo":
                                EXIT(ResponsibilityCenter."Sales Posted Credit Memo Nos.");
                            "Document Type"::"Posted Shipment":
                                EXIT(ResponsibilityCenter."Sales Posted Shipment Nos.");
                            "Document Type"::"Posted Return Receipt":
                                EXIT(ResponsibilityCenter."Sales Ptd. Return Receipt Nos.");
                            "Document Type"::"Posted Debit Note":
                                EXIT(ResponsibilityCenter."Sales Posted Debit Note Nos.");

                        END;

                    END;
                "Document Profile"::Service:
                    BEGIN
                        CASE "Document Type" OF
                            "Document Type"::Booking:
                                EXIT(ResponsibilityCenter."Serv. Booking Nos.");
                            "Document Type"::"Posted Order":
                                EXIT(ResponsibilityCenter."Serv. Posted Order Nos.");
                            "Document Type"::Order:
                                EXIT(ResponsibilityCenter."Serv. Order Nos.");
                            "Document Type"::Invoice:
                                EXIT(ResponsibilityCenter."Serv. Invoice Nos.");
                            "Document Type"::"Posted Invoice":
                                EXIT(ResponsibilityCenter."Serv. Posted Invoice Nos.");
                            "Document Type"::"Credit Memo":
                                EXIT(ResponsibilityCenter."Serv. Credit Memo Nos.");
                            "Document Type"::"Posted Credit Memo":
                                EXIT(ResponsibilityCenter."Serv. Posted Credit Memo Nos.");
                        END;
                    END;
                "Document Profile"::Transfer:
                    BEGIN
                        CASE "Document Type" OF
                            "Document Type"::Order:
                                EXIT(ResponsibilityCenter."Trans. Order Nos.");
                            "Document Type"::"Posted Receipt":
                                EXIT(ResponsibilityCenter."Posted Transfer Rcpt. Nos.");
                            "Document Type"::"Posted Shipment":
                                EXIT(ResponsibilityCenter."Posted Transfer Shpt. Nos.");
                        END;
                    END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateUnitVATPrice()
    begin
        ProgressWindow.OPEN(Text000);
        SalesPrice.RESET;
        SalesPrice.SETFILTER("Model Code", '%1', '<>''');
        IF SalesPrice.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, SalesPrice.COUNT);
            REPEAT
                SalesPrice.VALIDATE("Unit Price", SalesPrice."Unit Price");
                SalesPrice.MODIFY;
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);
            UNTIL SalesPrice.NEXT = 0;

        END;
    end;

    [Scope('Internal')]
    procedure UpdateVehEngCode()
    begin
        Vehicle.RESET;
        Vehicle.SETRANGE("Variable Field 25006803", '');
        Vehicle.SETFILTER("Engine No.", '<>%1', '');
        ProgressWindow.OPEN(Text000);
        IF Vehicle.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, Vehicle.COUNT);
            REPEAT
                Vehicle."Variable Field 25006803" := Vehicle."Engine No.";
                Vehicle.MODIFY;
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);
            UNTIL Vehicle.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateGateSetup()
    var
        Location: Record "14";
        GateSetup: Record "33020037";
    begin
        ProgressWindow.OPEN(Text000);
        Location.RESET;
        IF Location.FINDSET THEN BEGIN
            REPEAT
                ProgressWindow.UPDATE(2, Location.COUNT);
                GateSetup.INIT;
                GateSetup."Entry Type" := GateSetup."Entry Type"::Outward;
                GateSetup."Location Code" := Location.Code;
                GateSetup."Posting No. Series" := 'GATEPASS';
                GateSetup.INSERT;
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);

            UNTIL Location.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure GetVehicleSalesDate()
    var
        WarrantyRegister: Record "33020238";
        Vehicle: Record "25006005";
    begin
        WarrantyRegister.FINDFIRST;
        REPEAT
            Vehicle.RESET;
            Vehicle.SETRANGE(VIN, WarrantyRegister.VIN);
            IF Vehicle.FINDFIRST THEN BEGIN
                WarrantyRegister."Vehicle Sales Date" := Vehicle."Sales Date";
                WarrantyRegister.MODIFY;
            END;
        UNTIL WarrantyRegister.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure UpdateModelInCustLedger()
    var
        DetailCustLedg: Record "379";
        CustLedg: Record "21";
    begin
        ProgressWindow.OPEN(Text000);
        CustLedg.RESET;
        CustLedg.SETRANGE("Model Code", '');
        IF CustLedg.FINDFIRST THEN BEGIN
            REPEAT
                ProgressWindow.UPDATE(2, CustLedg.COUNT);
                DetailCustLedg.RESET;
                DetailCustLedg.SETRANGE("Cust. Ledger Entry No.", CustLedg."Entry No.");
                DetailCustLedg.SETRANGE("Document Type", DetailCustLedg."Document Type"::Invoice);
                IF DetailCustLedg.FINDFIRST THEN BEGIN
                    CustLedg."Model Code" := DetailCustLedg."Model Code";
                    CustLedg.MODIFY;
                END;
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);

            UNTIL CustLedg.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateDueDateOnDetailCust()
    var
        CustLedger: Record "21";
        DetailCustLedger: Record "379";
    begin
        ProgressWindow.OPEN(Text000);
        DetailCustLedger.RESET;
        DetailCustLedger.SETRANGE("Entry Type", DetailCustLedger."Entry Type"::"Initial Entry");
        DetailCustLedger.SETFILTER("Document No.", '%1', 'ARAP*');
        IF DetailCustLedger.FINDSET THEN BEGIN
            REPEAT
                ProgressWindow.UPDATE(2, DetailCustLedger.COUNT);
                CustLedger.RESET;
                CustLedger.SETRANGE("Entry No.", DetailCustLedger."Cust. Ledger Entry No.");
                IF CustLedger.FINDFIRST THEN BEGIN
                    DetailCustLedger."Initial Entry Due Date" := CustLedger."Due Date";
                    DetailCustLedger.MODIFY;
                END;
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);

            UNTIL DetailCustLedger.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure GetSalesPriceFromBuffer()
    var
        SalesPriceBuffer: Record "50011";
        SalesPrice: Record "7002";
        Item: Record "27";
    begin
        ProgressWindow.OPEN(Text000);
        SalesPriceBuffer.RESET;
        SalesPriceBuffer.SETRANGE(Invalid, FALSE);
        SalesPriceBuffer.SETRANGE(Processed, FALSE);
        IF SalesPriceBuffer.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, SalesPriceBuffer.COUNT);
            REPEAT
                // Modify/Insert Code
                SalesPrice.RESET;
                SalesPrice.SETRANGE("Item No.", SalesPriceBuffer."Item No.");
                SalesPrice.SETRANGE("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
                SalesPrice.SETRANGE("Sales Code", 'CVD');
                IF SalesPrice.FINDSET THEN BEGIN
                    REPEAT
                        SalesPrice.VALIDATE("Unit Price", SalesPriceBuffer."Sales Price");
                        SalesPrice.MODIFY;
                    UNTIL SalesPrice.NEXT = 0;
                    SalesPriceBuffer.Processed := TRUE;
                    SalesPriceBuffer.Process := FALSE;
                    SalesPriceBuffer.MODIFY;
                    totalcount += 1;
                    ProgressWindow.UPDATE(1, totalcount);
                END
                ELSE BEGIN
                    CLEAR(SalesPrice);
                    SalesPrice.INIT;
                    SalesPrice."Item No." := SalesPriceBuffer."Item No.";
                    SalesPrice."Sales Type" := SalesPrice."Sales Type"::"Customer Price Group";
                    SalesPrice."Sales Code" := 'CVD';
                    SalesPrice."Starting Date" := TODAY;
                    CLEAR(Item);
                    Item.RESET;
                    Item.GET(SalesPriceBuffer."Item No.");
                    Item.TESTFIELD("Base Unit of Measure");
                    SalesPrice."Unit of Measure Code" := Item."Base Unit of Measure";
                    SalesPrice.VALIDATE("Unit Price", SalesPriceBuffer."Sales Price");
                    SalesPrice.INSERT(TRUE);
                    SalesPriceBuffer.Processed := TRUE;
                    SalesPriceBuffer.Process := FALSE;
                    SalesPriceBuffer.MODIFY;
                    totalcount += 1;
                    ProgressWindow.UPDATE(1, totalcount);
                END;
            UNTIL SalesPriceBuffer.NEXT = 0;
        END;
        /*
        
        // Finding Invalid Items
        ProgressWindow.OPEN(Text000);
        SalesPriceBuffer.RESET;
        SalesPriceBuffer.SETRANGE(Invalid,FALSE);
        SalesPriceBuffer.SETRANGE(Processed,FALSE);
        IF SalesPriceBuffer.FINDSET THEN BEGIN
          ProgressWindow.UPDATE(2,SalesPriceBuffer.COUNT);
        REPEAT
        
          IF NOT Item.GET(SalesPriceBuffer."Item No.") THEN BEGIN
            SalesPriceBuffer.Invalid := TRUE;
            SalesPriceBuffer.MODIFY;
          END;
        totalcount += 1;
        ProgressWindow.UPDATE(1,totalcount);
        
        UNTIL SalesPriceBuffer.NEXT = 0;
        
        END;
        */

    end;

    [Scope('Internal')]
    procedure RenumberPostedInvoices()
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
        CustLedgEntryLink: Record "25006054";
        ServiceLedgEntryEDMS: Record "25006167";
        ReNumberingData: Record "50012";
        IDofTable: Integer;
        Text000: Label '#1###### of #2######## Records being Processed\ Modifying #3#### Records on #4#####################.';
        RecCount: Integer;
    begin
        ProgressWindow.OPEN(Text000);
        ReNumberingData.RESET;
        ReNumberingData.SETRANGE(Modified, FALSE);
        IF ReNumberingData.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, ReNumberingData.COUNT);
            REPEAT
                //G/L Entry->Document No.
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", ReNumberingData."Old No.");
                IF GLEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, GLEntry.COUNT);
                    ProgressWindow.UPDATE(4, 'G/L Entry');
                    REPEAT
                        GLEntry."Document No." := ReNumberingData."New No.";
                        GLEntry.MODIFY;
                        //ReNumberingData."Modified Tables" += FORMAT(DATABASE::"G/L Entry")+',';
                        ReNumberingData.Modified := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL GLEntry.NEXT = 0;
                END;
                //Cust. Ledger Entry->Document No.
                CustLedgerEntry.RESET;
                CustLedgerEntry.SETRANGE("Document No.", ReNumberingData."Old No.");
                IF CustLedgerEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, CustLedgerEntry.COUNT);
                    ProgressWindow.UPDATE(4, 'Cust. Ledger Entry');
                    REPEAT
                        CustLedgerEntry."Document No." := ReNumberingData."New No.";
                        CustLedgerEntry.MODIFY;
                        //ReNumberingData."Modified Tables" += FORMAT(DATABASE::"Cust. Ledger Entry")+',';
                        ReNumberingData.Modified := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL CustLedgerEntry.NEXT = 0;
                END;
                //Item Ledger Entry->Document No.
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Document No.", ReNumberingData."Old No.");
                IF ItemLedgerEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, ItemLedgerEntry.COUNT);
                    ProgressWindow.UPDATE(4, 'Item Ledger Entry');
                    REPEAT
                        ItemLedgerEntry."Document No." := ReNumberingData."New No.";
                        ItemLedgerEntry.MODIFY;
                        // ReNumberingData."Modified Tables" += FORMAT(DATABASE::"Item Ledger Entry")+',';
                        ReNumberingData.Modified := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ItemLedgerEntry.NEXT = 0;
                END;
                //Sales Comment Line->No.
                SalesCommentLine.RESET;
                SalesCommentLine.SETRANGE("No.", ReNumberingData."Old No.");
                IF SalesCommentLine.FINDFIRST THEN BEGIN
                    ProgressWindow.UPDATE(3, SalesCommentLine.COUNT);
                    ProgressWindow.UPDATE(4, 'Sales Comment Line');
                    REPEAT
                        //        SalesCommentLine."No." := ReNumberingData."New No.";
                        SalesCommentLine.RENAME(SalesCommentLine."Document Type"::"Posted Invoice", ReNumberingData."New No.");
                        //ReNumberingData."Modified Tables" += FORMAT(DATABASE::"Sales Comment Line")+',';
                        ReNumberingData.Modified := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL SalesCommentLine.NEXT = 0;
                END;
                //Sales Invoice Header->No.
                SalesInvoiceHeader.RESET;
                SalesInvoiceHeader.SETRANGE("No.", ReNumberingData."Old No.");
                IF SalesInvoiceHeader.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, SalesInvoiceHeader.COUNT);
                    ProgressWindow.UPDATE(4, 'Sales Invoice Header');
                    REPEAT
                        //SalesInvoiceHeader."No." := ReNumberingData."New No.";
                        SalesInvoiceHeader.RENAME(ReNumberingData."New No.");
                        //ReNumberingData."Modified Tables" += FORMAT(DATABASE::"Sales Invoice Header")+',';
                        ReNumberingData.Modified := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL SalesInvoiceHeader.NEXT = 0;
                END;

                //Sales Invoice Line->Document No.
                SalesInvoiceLine.RESET;
                SalesInvoiceLine.SETRANGE("Document No.", ReNumberingData."Old No.");
                IF SalesInvoiceLine.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, SalesInvoiceLine.COUNT);
                    ProgressWindow.UPDATE(4, 'Sales Invoice Line');
                    REPEAT
                        SalesInvoiceLine."Document No." := ReNumberingData."New No.";
                        SalesInvoiceLine.MODIFY;
                        //ReNumberingData."Modified Tables" += FORMAT(DATABASE::"Sales Invoice Line")+',';
                        ReNumberingData.Modified := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL SalesInvoiceLine.NEXT = 0;
                END;

                //VAT Entry->Document No.
                VATEntry.RESET;
                VATEntry.SETRANGE("Document No.", ReNumberingData."Old No.");
                IF VATEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, VATEntry.COUNT);
                    ProgressWindow.UPDATE(4, 'VAT Entry');
                    REPEAT
                        VATEntry."Document No." := ReNumberingData."New No.";
                        VATEntry.MODIFY;
                        //ReNumberingData."Modified Tables" += FORMAT(DATABASE::"VAT Entry")+',';
                        ReNumberingData.Modified := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL VATEntry.NEXT = 0;
                END;

                //Bank Account Ledger Entry->Document No.
                BankAccLedgEntry.RESET;
                BankAccLedgEntry.SETRANGE("Document No.", ReNumberingData."Old No.");
                IF BankAccLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, BankAccLedgEntry.COUNT);
                    ProgressWindow.UPDATE(4, 'Bank Account Ledger Entry');
                    REPEAT
                        BankAccLedgEntry."Document No." := ReNumberingData."New No.";
                        BankAccLedgEntry.MODIFY;
                        //ReNumberingData."Modified Tables" += FORMAT(DATABASE::"Bank Account Ledger Entry")+',';
                        ReNumberingData.Modified := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL BankAccLedgEntry.NEXT = 0;
                END;


                //Detailed Cust. Ledg. Entry->Document No.
                DetailedCustLedgEntry.RESET;
                DetailedCustLedgEntry.SETRANGE("Document No.", ReNumberingData."Old No.");
                IF DetailedCustLedgEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, DetailedCustLedgEntry.COUNT);
                    ProgressWindow.UPDATE(4, 'Detailed Cust. Ledg. Entry');
                    REPEAT
                        DetailedCustLedgEntry."Document No." := ReNumberingData."New No.";
                        DetailedCustLedgEntry.MODIFY;
                        //ReNumberingData."Modified Tables" += FORMAT(DATABASE::"Detailed Cust. Ledg. Entry")+',';
                        ReNumberingData.Modified := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL DetailedCustLedgEntry.NEXT = 0;
                END;

                //Value Entry->Document No.
                ValueEntry.RESET;
                ValueEntry.SETRANGE("Document No.", ReNumberingData."Old No.");
                IF ValueEntry.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, ValueEntry.COUNT);
                    ProgressWindow.UPDATE(4, 'Value Entry');
                    REPEAT
                        ValueEntry."Document No." := ReNumberingData."New No.";
                        ValueEntry.MODIFY;
                        //ReNumberingData."Modified Tables" += FORMAT(DATABASE::"Value Entry")+',';
                        ReNumberingData.Modified := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ValueEntry.NEXT = 0;
                END;

                //Cust. Ledg. Entry Link->Document No.
                CustLedgEntryLink.RESET;
                CustLedgEntryLink.SETRANGE("Document No.", ReNumberingData."Old No.");
                IF CustLedgEntryLink.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, CustLedgEntryLink.COUNT);
                    ProgressWindow.UPDATE(4, 'Cust. Ledg. Entry Link');
                    REPEAT
                        CustLedgEntryLink."Document No." := ReNumberingData."New No.";
                        CustLedgEntryLink.MODIFY;
                        //ReNumberingData."Modified Tables" += FORMAT(DATABASE::"Cust. Ledg. Entry Link")+',';
                        ReNumberingData.Modified := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL CustLedgEntryLink.NEXT = 0;
                END;

                //Service Ledger Entry EDMS->Document No.
                ServiceLedgEntryEDMS.RESET;
                ServiceLedgEntryEDMS.SETRANGE("Document No.", ReNumberingData."Old No.");
                IF ServiceLedgEntryEDMS.FINDSET THEN BEGIN
                    ProgressWindow.UPDATE(3, ServiceLedgEntryEDMS.COUNT);
                    ProgressWindow.UPDATE(4, 'Service Ledger Entry EDMS');
                    REPEAT
                        ServiceLedgEntryEDMS."Document No." := ReNumberingData."New No.";
                        ServiceLedgEntryEDMS.MODIFY;
                        //ReNumberingData."Modified Tables" += FORMAT(DATABASE::"Service Ledger Entry EDMS")+',';
                        ReNumberingData.Modified := TRUE;
                        ReNumberingData.MODIFY;
                    UNTIL ServiceLedgEntryEDMS.NEXT = 0;
                END;
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);

            UNTIL ReNumberingData.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure ModifySalesPostingDate()
    var
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
        PostingDate: Date;
        ModifySalesDate: Record "50013";
        SalesShipmentNo: Code[20];
        SalesOrderNo: Code[20];
        ItemLedgEntryNo: Integer;
    begin
        ProgressWindow.OPEN(Text000);
        ModifySalesDate.RESET;
        IF ModifySalesDate.FINDSET THEN BEGIN
            CLEAR(SalesOrderNo);
            CLEAR(SalesShipmentNo);
            CLEAR(ItemLedgEntryNo);
            ProgressWindow.UPDATE(2, ModifySalesDate.COUNT);
            REPEAT
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", ModifySalesDate."Document No.");
                IF GLEntry.FINDSET THEN BEGIN
                    REPEAT
                        GLEntry."Posting Date" := ModifySalesDate."Posting Date";
                        GLEntry.MODIFY;
                    UNTIL GLEntry.NEXT = 0;
                END;
                CustLedgerEntry.RESET;
                CustLedgerEntry.SETRANGE("Document No.", ModifySalesDate."Document No.");
                IF CustLedgerEntry.FINDSET THEN BEGIN
                    REPEAT
                        CustLedgerEntry."Posting Date" := ModifySalesDate."Posting Date";
                        CustLedgerEntry.MODIFY;
                    UNTIL CustLedgerEntry.NEXT = 0;
                END;

                SalesInvoiceHeader.RESET;
                SalesInvoiceHeader.SETRANGE("No.", ModifySalesDate."Document No.");
                IF SalesInvoiceHeader.FINDFIRST THEN BEGIN
                    SalesOrderNo := SalesInvoiceHeader."Order No.";
                    SalesInvoiceHeader."Posting Date" := ModifySalesDate."Posting Date";
                    SalesInvoiceHeader.MODIFY;
                END;

                SalesInvoiceLine.RESET;
                SalesInvoiceLine.SETRANGE("Document No.", ModifySalesDate."Document No.");
                IF SalesInvoiceLine.FINDFIRST THEN BEGIN
                    REPEAT
                        SalesInvoiceLine."Posting Date" := ModifySalesDate."Posting Date";
                        SalesInvoiceLine.MODIFY;
                    UNTIL SalesInvoiceLine.NEXT = 0;
                END;

                SalesShipmentHeader.RESET;
                SalesShipmentHeader.SETRANGE("Order No.", SalesOrderNo);
                IF SalesShipmentHeader.FINDFIRST THEN BEGIN
                    SalesShipmentNo := SalesShipmentHeader."No.";
                    SalesShipmentHeader."Posting Date" := ModifySalesDate."Posting Date";
                    SalesShipmentHeader.MODIFY;
                END;

                SalesShipmentLine.RESET;
                SalesShipmentLine.SETRANGE("Document No.", SalesShipmentNo);
                IF SalesShipmentLine.FINDSET THEN BEGIN
                    REPEAT
                        SalesShipmentLine."Posting Date" := ModifySalesDate."Posting Date";
                        SalesShipmentLine.MODIFY;
                    UNTIL SalesShipmentLine.NEXT = 0;
                END;

                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Document No.", SalesShipmentNo);
                IF ItemLedgerEntry.FINDSET THEN BEGIN
                    REPEAT
                        ItemLedgEntryNo := ItemLedgerEntry."Entry No.";
                        ItemLedgerEntry."Posting Date" := ModifySalesDate."Posting Date";
                        ItemLedgerEntry.MODIFY;
                    UNTIL ItemLedgerEntry.NEXT = 0;
                END;

                ItemAppEntry.RESET;
                ItemAppEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntryNo);
                IF ItemAppEntry.FINDSET THEN BEGIN
                    REPEAT
                        ItemAppEntry."Posting Date" := ModifySalesDate."Posting Date";
                        ItemAppEntry.MODIFY;
                    UNTIL ItemAppEntry.NEXT = 0;
                END;

                VATEntry.RESET;
                VATEntry.SETRANGE("Document No.", ModifySalesDate."Document No.");
                IF VATEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        VATEntry."Posting Date" := ModifySalesDate."Posting Date";
                        VATEntry.MODIFY;
                    UNTIL VATEntry.NEXT = 0;
                END;

                DetailedCustLedgEntry.RESET;
                DetailedCustLedgEntry.SETRANGE("Document No.", ModifySalesDate."Document No.");
                IF DetailedCustLedgEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        DetailedCustLedgEntry."Posting Date" := ModifySalesDate."Posting Date";
                        DetailedCustLedgEntry.MODIFY;
                    UNTIL DetailedCustLedgEntry.NEXT = 0;
                END;

                ValueEntry.RESET;
                ValueEntry.SETRANGE("Document No.", ModifySalesDate."Document No.");
                IF ValueEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        ValueEntry."Posting Date" := ModifySalesDate."Posting Date";
                        ValueEntry.MODIFY;
                    UNTIL ValueEntry.NEXT = 0;
                END;

                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);

            UNTIL ModifySalesDate.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateVehicleInsurance()
    var
        VehicleInsurance: Record "25006033";
        InsPayamentLine: Record "33020170";
    begin
        InsPayamentLine.RESET;
        IF InsPayamentLine.FINDSET THEN
            REPEAT
                VehicleInsurance.RESET;
                VehicleInsurance.SETRANGE("Vehicle Serial No.", InsPayamentLine."Vehicle Serial No.");
                VehicleInsurance.SETRANGE("Insurance Policy No.", InsPayamentLine."Insurance Policy No.");
                IF VehicleInsurance.FINDFIRST THEN BEGIN
                    VehicleInsurance.VALIDATE("Payment Memo Generated", TRUE);
                    VehicleInsurance.MODIFY;
                END;
            UNTIL InsPayamentLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CreateItem()
    var
        Item: Record "27";
        SalesPrice: Record "7002";
        PriceBuffer: Record "50011";
        UOM: Record "5404";
    begin
        ProgressWindow.OPEN(Text000);
        PriceBuffer.RESET;
        PriceBuffer.SETRANGE(Invalid, TRUE);
        ProgressWindow.UPDATE(2, PriceBuffer.COUNT);
        IF PriceBuffer.FINDSET THEN
            REPEAT
                CLEAR(Item);
                Item.INIT;
                Item.VALIDATE("No.", PriceBuffer."Item No.");
                Item.INSERT(TRUE);

                CLEAR(UOM);
                UOM.INIT;
                UOM.VALIDATE("Item No.", PriceBuffer."Item No.");
                UOM.VALIDATE(Code, 'UNIT');
                UOM.VALIDATE("Qty. per Unit of Measure", 1);
                UOM.INSERT(TRUE);

                Item.VALIDATE(Description, PriceBuffer.Description);
                Item.VALIDATE("Inventory Posting Group", 'SP-CV');
                Item.VALIDATE("Costing Method", Item."Costing Method"::Average);
                Item.VALIDATE("Gen. Prod. Posting Group", 'SP-CV');
                Item.VALIDATE("VAT Prod. Posting Group", 'VAT13');
                Item.VALIDATE("Price/Profit Calculation", Item."Price/Profit Calculation"::"No Relationship");
                Item.VALIDATE("Item Category Code", 'SP-CV');
                Item.VALIDATE("Item Type", Item."Item Type"::Item);
                Item.VALIDATE("Base Unit of Measure", 'UNIT');
                Item.MODIFY;

                CLEAR(SalesPrice);
                SalesPrice.INIT;
                SalesPrice.VALIDATE("Item No.", PriceBuffer."Item No.");
                SalesPrice.VALIDATE("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
                SalesPrice.VALIDATE("Sales Code", 'CVD');
                SalesPrice.VALIDATE("Starting Date", TODAY);
                SalesPrice.VALIDATE("Unit of Measure Code", 'UNIT');
                SalesPrice.VALIDATE("Unit Price", PriceBuffer."Sales Price");
                SalesPrice.INSERT(TRUE);

                PriceBuffer.Processed := TRUE;
                PriceBuffer.MODIFY;
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);

            UNTIL PriceBuffer.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure UpdateDimensionItemLedger()
    var
        ItemLedgerEntry: Record "32";
        ItemLedg2: Record "32";
    begin
        ProgressWindow.OPEN(Text000);
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Global Dimension 1 Code", '');
        ItemLedgerEntry.SETRANGE("Location Code", 'IN-TRANSIT');
        IF ItemLedgerEntry.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, ItemLedgerEntry.COUNT);
            REPEAT
                ItemLedg2.RESET;
                ItemLedg2.SETRANGE("Document No.", ItemLedgerEntry."Document No.");
                ItemLedg2.SETFILTER("Global Dimension 1 Code", '<>%1', '');
                ItemLedg2.FINDFIRST;

                ItemLedgerEntry.VALIDATE("Global Dimension 1 Code", ItemLedg2."Global Dimension 1 Code");
                ItemLedgerEntry.MODIFY;
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);
            UNTIL ItemLedgerEntry.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateDimensionValueEntry()
    var
        ValueEntry: Record "5802";
        Location: Record "14";
        ValueEntry2: Record "5802";
    begin
        ProgressWindow.OPEN(Text000);
        ValueEntry.RESET;
        ValueEntry.SETRANGE("Global Dimension 1 Code", '');
        IF ValueEntry.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, ValueEntry.COUNT);
            REPEAT
                ValueEntry2.RESET;
                ValueEntry2.SETRANGE("Document No.", ValueEntry."Document No.");
                ValueEntry2.SETFILTER("Global Dimension 1 Code", '<>%1', '');
                ValueEntry2.FINDFIRST;
                ValueEntry.VALIDATE("Global Dimension 1 Code", ValueEntry2."Global Dimension 1 Code");
                ValueEntry.MODIFY;
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);
            UNTIL ValueEntry.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure ModifyPurchaseDate(ModifyReg: Boolean; ModifyCompletelyInvdDateOnIAE: Boolean)
    var
        GLEntry: Record "17";
        VendorLedgerEntry: Record "25";
        ItemLedgerEntry: Record "32";
        GLRegister: Record "45";
        ItemRegister: Record "46";
        PurchInvHeader: Record "122";
        PurchInvLine: Record "123";
        PurchRcptHeader: Record "120";
        PurchRcptLine: Record "121";
        VATEntry: Record "254";
        ItemAppEntry: Record "339";
        DetailedVendorLedgerEntry: Record "380";
        PurchHeaderArch: Record "5109";
        PurchLineArch: Record "5110";
        ValueEntry: Record "5802";
        AvgCostAdjmt: Record "5804";
        WarehouseEntry: Record "7312";
        WarehouseRegister: Record "7313";
        ModifyPurchDate: Record "50013";
        PurchOrderNo: Code[20];
        PurchRcptNo: Code[20];
        PurchCrMemoHeader: Record "124";
        PurchCrMemoLine: Record "125";
    begin
        /*
        Table17G/L Entry
        Table25Vendor Ledger Entry
        Table32Item Ledger Entry
        Table45G/L Register
        Table46Item Register
        Table120Purch. Rcpt. Header
        Table121Purch. Rcpt. Line
        Table122Purch. Inv. Header
        Table123Purch. Inv. Line
        Table254VAT Entry
        Table339Item Application Entry
        Table380Detailed Vendor Ledg. Entry
        Table5109Purchase Header Archive
        Table5110Purchase Line Archive
        Table5802Value Entry
        Table5804Avg. Cost Adjmt. Entry Point
        Table7312Warehouse Entry
        Table7313Warehouse Register
        */
        /*
          **************** FUNCTIONALITY *****************************
          # IF INVOICE NO. IS GIVEN, IT SEARCHES FOR RECEIPTS AS WELL AND MODIFIES THE POSTING DATE SAME AS INVOICED DATE
          # IF ModifyReg PARAMETER HAS TRUE VALUE, THEN IT MODIFIES ITEM AND GL REGISTER'S POSTING DATES
          # IF ModifyCompletelyInvdDateOnIAE HAS TRUE VALUE, THEN IT AFFECTS ON COST ADJUSTMENT AS WELL
          # ONLY INVOICE NO. ARE ALLOWED
        */

        ProgressWindow.OPEN(Text000);
        ModifyPurchDate.RESET;
        IF ModifyPurchDate.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, ModifyPurchDate.COUNT);
            REPEAT

                //*********** G/L ENTRY/G/L REGISTER ******************
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", ModifyPurchDate."Document No.");
                IF GLEntry.FINDSET THEN
                    REPEAT
                        GLEntry."Posting Date" := ModifyPurchDate."Posting Date";
                        GLEntry.MODIFY;
                        IF ModifyReg THEN BEGIN
                            GLRegister.RESET;
                            GLRegister.SETRANGE("From Entry No.", GLEntry."Entry No.");
                            IF GLRegister.FINDFIRST THEN BEGIN
                                GLRegister."Creation Date" := ModifyPurchDate."Posting Date";
                            END;
                        END;
                    UNTIL GLEntry.NEXT = 0;

                //********** Vendor Ledger Entry *****************
                VendorLedgerEntry.RESET;
                VendorLedgerEntry.SETRANGE("Document No.", ModifyPurchDate."Document No.");
                IF VendorLedgerEntry.FINDSET THEN
                    REPEAT
                        VendorLedgerEntry."Posting Date" := ModifyPurchDate."Posting Date";
                        VendorLedgerEntry.MODIFY;
                    UNTIL VendorLedgerEntry.NEXT = 0;

                //********** Purch. Inv. Header  *****************
                PurchInvHeader.RESET;
                PurchInvHeader.SETRANGE("No.", ModifyPurchDate."Document No.");
                IF PurchInvHeader.FINDFIRST THEN BEGIN
                    IF PurchInvHeader."Order No." <> '' THEN
                        PurchOrderNo := PurchInvHeader."Order No."
                    ELSE
                        IF PurchInvHeader."Pre-Assigned No." <> '' THEN
                            PurchOrderNo := PurchInvHeader."Pre-Assigned No.";
                    PurchInvHeader."Posting Date" := ModifyPurchDate."Posting Date";
                    PurchInvHeader.MODIFY;
                END;

                //********** Purch. Inv. Line  *****************
                PurchInvLine.RESET;
                PurchInvLine.SETRANGE("Document No.", ModifyPurchDate."Document No.");
                IF PurchInvLine.FINDSET THEN
                    REPEAT
                        PurchInvLine."Posting Date" := ModifyPurchDate."Posting Date";
                        PurchInvLine.MODIFY;
                    UNTIL PurchInvLine.NEXT = 0;

                //********** Purch. Rcpt. Header/Purch. Rcpt. Line  *****************
                /*
                PurchRcptHeader.RESET;
                PurchRcptHeader.SETCURRENTKEY("Order No.");
                PurchRcptHeader.SETRANGE("Order No.",PurchOrderNo);
                IF PurchRcptHeader.FINDFIRST THEN BEGIN
                  PurchRcptNo := PurchRcptHeader."No.";
                  PurchRcptHeader."Posting Date" := ModifyPurchDate."Posting Date";
                  PurchRcptHeader.MODIFY;
                  PurchRcptLine.RESET;
                  PurchRcptLine.SETRANGE("Document No.",ModifyPurchDate."Document No.");
                  IF PurchRcptLine.FINDSET THEN REPEAT
                    PurchRcptLine."Posting Date" := ModifyPurchDate."Posting Date";
                    PurchRcptLine.MODIFY;
                  UNTIL PurchRcptLine.NEXT=0;
                END;
                */
                //********** Item Ledger Entry/Item Register/Item Application Entry  *****************
                /*
                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Document No.",PurchRcptNo);
                IF ItemLedgerEntry.FINDSET THEN REPEAT
                  ItemLedgerEntry."Posting Date" := ModifyPurchDate."Posting Date";
                  ModifyPurchDate.MODIFY;
                  IF ModifyReg THEN BEGIN
                    ItemRegister.RESET;
                    ItemRegister.SETRANGE("From Entry No.",ItemLedgerEntry."Entry No.");
                    IF ItemRegister.FINDFIRST THEN BEGIN
                      ItemRegister."Creation Date" := ModifyPurchDate."Posting Date";
                      ItemRegister.MODIFY;
                    END;
                  END;
                  ItemAppEntry.RESET;
                  ItemAppEntry.SETCURRENTKEY("Item Ledger Entry No.");
                  ItemAppEntry.SETRANGE("Item Ledger Entry No.",ItemLedgerEntry."Entry No.");
                  IF ItemAppEntry.FINDSET THEN REPEAT
                    IF ModifyCompletelyInvdDateOnIAE THEN
                      ItemAppEntry."Output Completely Invd. Date" := ModifyPurchDate."Posting Date";
                    ItemAppEntry."Posting Date" := ModifyPurchDate."Posting Date";
                    ItemAppEntry.MODIFY;
                  UNTIL ItemAppEntry.NEXT=0;
                UNTIL ItemLedgerEntry.NEXT=0;

                ItemLedgerEntry.RESET;
                ItemLedgerEntry.SETRANGE("Document No.",ModifyPurchDate."Document No.");
                IF ItemLedgerEntry.FINDSET THEN REPEAT
                  ItemLedgerEntry."Posting Date" := ModifyPurchDate."Posting Date";
                  ItemLedgerEntry.MODIFY;
                  IF ModifyReg THEN BEGIN
                    ItemRegister.RESET;
                    ItemRegister.SETRANGE("From Entry No.",ItemLedgerEntry."Entry No.");
                    IF ItemRegister.FINDFIRST THEN BEGIN
                      ItemRegister."Creation Date" := ModifyPurchDate."Posting Date";
                      ItemRegister.MODIFY;
                    END;
                  END;
                  ItemAppEntry.RESET;
                  ItemAppEntry.SETCURRENTKEY("Item Ledger Entry No.");
                  ItemAppEntry.SETRANGE("Item Ledger Entry No.",ItemLedgerEntry."Entry No.");
                  IF ItemAppEntry.FINDSET THEN REPEAT
                    IF ModifyCompletelyInvdDateOnIAE THEN
                      ItemAppEntry."Output Completely Invd. Date" := ModifyPurchDate."Posting Date";
                    ItemAppEntry."Posting Date" := ModifyPurchDate."Posting Date";
                    ItemAppEntry.MODIFY;
                  UNTIL ItemAppEntry.NEXT=0;

                UNTIL ItemLedgerEntry.NEXT=0;
                */
                //********** VAT ENTRY  *****************
                VATEntry.RESET;
                VATEntry.SETCURRENTKEY("Document No.");
                VATEntry.SETRANGE("Document No.", ModifyPurchDate."Document No.");
                IF VATEntry.FINDSET THEN
                    REPEAT
                        VATEntry."Posting Date" := ModifyPurchDate."Posting Date";
                        VATEntry.MODIFY;
                    UNTIL VATEntry.NEXT = 0;

                //********** Detailed Vendor Ledg. Entry  *****************
                DetailedVendorLedgerEntry.RESET;
                DetailedVendorLedgerEntry.SETCURRENTKEY("Document No.");
                DetailedVendorLedgerEntry.SETRANGE("Document No.", ModifyPurchDate."Document No.");
                IF DetailedVendorLedgerEntry.FINDSET THEN
                    REPEAT
                        DetailedVendorLedgerEntry."Posting Date" := ModifyPurchDate."Posting Date";
                        DetailedVendorLedgerEntry.MODIFY;
                    UNTIL DetailedVendorLedgerEntry.NEXT = 0;

                //********** Value Entry/Item Ledger Entry  *****************
                ValueEntry.RESET;
                ValueEntry.SETCURRENTKEY("Document No.");
                ValueEntry.SETRANGE("Document No.", ModifyPurchDate."Document No.");
                IF ValueEntry.FINDSET THEN
                    REPEAT
                        ValueEntry."Posting Date" := ModifyPurchDate."Posting Date";
                        ValueEntry.MODIFY;
                        ItemLedgerEntry.RESET;
                        ItemLedgerEntry.SETRANGE(ItemLedgerEntry."Entry No.", ValueEntry."Item Ledger Entry No.");
                        IF ItemLedgerEntry.FINDFIRST THEN BEGIN
                            ItemLedgerEntry."Posting Date" := ModifyPurchDate."Posting Date";
                            ItemLedgerEntry.MODIFY;
                        END;
                    UNTIL ValueEntry.NEXT = 0;

                //*********** Purchase Cr. Memo Header/Line *******************
                PurchCrMemoHeader.RESET;
                PurchCrMemoHeader.SETRANGE("No.", ModifyPurchDate."Document No.");
                IF PurchCrMemoHeader.FINDFIRST THEN BEGIN
                    PurchCrMemoHeader."Posting Date" := ModifyPurchDate."Posting Date";
                    PurchCrMemoHeader.MODIFY;
                    PurchCrMemoLine.RESET;
                    PurchCrMemoLine.SETRANGE("Document No.", PurchCrMemoHeader."No.");
                    IF PurchCrMemoLine.FINDSET THEN
                        REPEAT
                            PurchCrMemoLine."Posting Date" := ModifyPurchDate."Posting Date";
                            PurchCrMemoLine.MODIFY;
                        UNTIL PurchCrMemoLine.NEXT = 0;
                END;

                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);
            UNTIL ModifyPurchDate.NEXT = 0;
        END;

        /*
        
        Table5804Avg. Cost Adjmt. Entry Point
        Table7312Warehouse Entry
        Table7313Warehouse Register
        
        */

    end;

    [Scope('Internal')]
    procedure SyncILEWithWarehouseEntries(LocationCode: Code[20])
    var
        Item: Record "27";
        BinContent: Record "7302";
        ILEQty: Decimal;
        WEQty: Decimal;
    begin
        ProgressWindow.OPEN(Text000);
        CLEAR(totalcount);
        Item.RESET;
        Item.SETFILTER("Inventory Posting Group", '%1|%2|%3|%4|%5', 'SP-COMMON', 'SP-CV', 'SP-PC', 'LUBE', 'BATTERY');
        //Item.SETFILTER("Inventory Posting Group",'%1|%2','LUBE','BATTERY');
        Item.SETFILTER("Location Filter", '%1', LocationCode);
        IF Item.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, Item.COUNT);
            ProgressWindow.UPDATE(3, LocationCode);
            REPEAT
                BinContent.RESET;
                BinContent.SETCURRENTKEY("Location Code", "Item No.");
                BinContent.SETRANGE("Location Code", LocationCode);
                BinContent.SETRANGE("Item No.", Item."No.");
                IF BinContent.FINDSET THEN BEGIN
                    Item.CALCFIELDS(Inventory);
                    BinContent.CALCFIELDS(Quantity);
                    ILEQty := Item.Inventory;
                    WEQty := BinContent.Quantity;
                    IF ILEQty <> WEQty THEN BEGIN
                        IF (BinContent.COUNT = 1) THEN BEGIN
                            BinContent.VALIDATE(Quantity, ILEQty);
                            BinContent.VALIDATE("Quantity (Base)", ILEQty);
                            BinContent.MODIFY(TRUE);
                            TotalModified += 1;
                        END
                        ELSE
                            IF BinContent.COUNT > 1 THEN BEGIN
                                BinContent."Has Multiple Bin" := TRUE;
                                BinContent.MODIFY;
                            END;
                    END;
                END;
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);
            UNTIL Item.NEXT = 0;
        END;
        MESSAGE('Total Modified :' + FORMAT(TotalModified));
    end;

    [Scope('Internal')]
    procedure ApplySync()
    var
        Location: Record "14";
    begin
        ProgressWindow.OPEN(Text000);
        Location.RESET;
        Location.SETFILTER(Code, '%1|%2|%3|%4,''*ST-CV', '*ST-PC', '*WH-CV', '*WH-PC');
        IF Location.FINDSET THEN
            REPEAT
                SyncILEWithWarehouseEntries(Location.Code);
            UNTIL Location.NEXT = 0;
        MESSAGE('Total Modified :' + FORMAT(TotalModified));
    end;

    [Scope('Internal')]
    procedure SendEmailNotification()
    var
        ReceiverEmail: Text[100];
        SenderEmail: Text[100];
        Subject: Text[250];
        Body: Text[1024];
        SendName: Text[50];
        UserSetup: Record "91";
        SMTPMail: Codeunit "400";
    begin
        //UserSetup.GET(SenderID);
        ReceiverEmail := 'diwakar.chaurasia@sipradi.com.np';

        //UserSetup.GET(receiverID);
        SenderEmail := 'sipradi.test@sipradi.com.np';

        SendName := 'Yuran Shrestha';
        Body := 'Test Email From MS Dynamics NAV';
        Subject := 'Test Email from Yuran';
        SMTPMail.CreateMessage(SendName, SenderEmail, ReceiverEmail, Subject, Body, TRUE);
        //SMTPMail.AppendBody();
        SMTPMail.Send;
        //message('Message Successfully Sent.');
    end;

    [Scope('Internal')]
    procedure UpdateVehFinPaymentLines()
    var
        VehFinPayment: Record "33020072";
        GLEntry: Record "17";
    begin
        ProgressWindow.OPEN(Text000);
        VehFinPayment.RESET;
        ProgressWindow.UPDATE(2, VehFinPayment.COUNT);
        IF VehFinPayment.FINDSET THEN
            REPEAT
                GLEntry.RESET;
                GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
                GLEntry.SETRANGE("Document No.", VehFinPayment."G/L Receipt No.");
                IF GLEntry.FINDFIRST THEN BEGIN
                    VehFinPayment."User ID" := GLEntry."User ID";
                    VehFinPayment."Shortcut Dimension 1 Code" := GLEntry."Global Dimension 1 Code";
                    VehFinPayment."Shortcut Dimension 2 Code" := GLEntry."Global Dimension 2 Code";
                    VehFinPayment.MODIFY;
                END;
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);
            UNTIL VehFinPayment.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure UpdateSatisfactionFeedback()
    var
        PostedServHeader: Record "25006149";
        ServSatis: Record "33020243";
    begin
        ProgressWindow.OPEN(Text000);
        ServSatis.RESET;
        ServSatis.SETRANGE("Order No.", '');
        ProgressWindow.UPDATE(2, ServSatis.COUNT);
        IF ServSatis.FINDSET THEN
            REPEAT
                PostedServHeader.RESET;
                PostedServHeader.SETRANGE("No.", ServSatis."Service Order No.");
                IF PostedServHeader.FINDFIRST THEN BEGIN
                    ServSatis."Order No." := PostedServHeader."Order No.";
                    ServSatis.MODIFY;
                END;
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);
            UNTIL ServSatis.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CorrectKilometrage(JobNo: Code[20]; Kilometrage: Decimal)
    var
        PostedServHeader: Record "25006149";
        SalesInvHeader: Record "112";
        SalesInvLine: Record "113";
        ServLedger: Record "25006167";
        Text000L: Label 'Job No. Cannot be Empty.';
        Text001L: Label 'Kilometrage must have a value.';
        RecordsModified: Boolean;
    begin


        // Checking Validation
        IF JobNo = '' THEN
            ERROR(Text000L);
        IF Kilometrage = 0 THEN
            ERROR(Text001L);

        // Modify Posted Service Header
        PostedServHeader.RESET;
        PostedServHeader.SETCURRENTKEY("Order No.");
        PostedServHeader.SETRANGE("Order No.", JobNo);
        IF PostedServHeader.FINDFIRST THEN BEGIN
            PostedServHeader.Kilometrage := Kilometrage;
            PostedServHeader.MODIFY;
            RecordsModified := TRUE;
        END;

        // Modify Service Ledger Entry
        ServLedger.RESET;
        ServLedger.SETCURRENTKEY("Service Order No.");
        ServLedger.SETRANGE("Service Order No.", JobNo);
        IF ServLedger.FINDSET THEN
            REPEAT
                ServLedger.Kilometrage := Kilometrage;
                ServLedger.MODIFY;
                RecordsModified := TRUE;
            UNTIL ServLedger.NEXT = 0;

        // Modify Sales Invoice Header
        SalesInvHeader.RESET;
        SalesInvHeader.SETCURRENTKEY("Service Order No.");
        SalesInvHeader.SETRANGE("Service Order No.", JobNo);
        IF SalesInvHeader.FINDSET THEN
            REPEAT
                SalesInvHeader.Kilometrage := Kilometrage;
                SalesInvHeader.MODIFY;
                RecordsModified := TRUE;
                // Modify Sales Invoice Line
                SalesInvLine.RESET;
                SalesInvLine.SETRANGE("Document No.", SalesInvHeader."No.");
                IF SalesInvLine.FINDSET THEN
                    REPEAT
                        SalesInvLine.Kilometrage := Kilometrage;
                        SalesInvLine.MODIFY;
                        RecordsModified := TRUE;
                    UNTIL SalesInvLine.NEXT = 0;
            UNTIL SalesInvHeader.NEXT = 0;

        IF RecordsModified THEN
            MESSAGE('Records Modified Successfully.')
        ELSE
            ERROR('Could not find Job No.');
    end;

    [Scope('Internal')]
    procedure UpdateTransReqDate()
    var
        TransLine: Record "5741";
        ShipLine: Record "5745";
    begin
        ShipLine.RESET;
        ShipLine.SETRANGE("Requisition Date", 0D);
        IF ShipLine.FINDSET THEN
            REPEAT
                ShipLine."Requisition Date" := ShipLine."Shipment Date";
                ShipLine.MODIFY;
            UNTIL ShipLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetProwacDealerCode()
    var
        PDM: Record "33020248";
        WEH: Record "33020249";
    begin
        WEH.RESET;
        IF WEH.FINDSET THEN
            REPEAT
                PDM.RESET;
                PDM.SETRANGE("Location Code", WEH."Location Code");
                IF PDM.FINDFIRST THEN BEGIN
                    WEH.RENAME(WEH."No.", WEH."Prowac Year", PDM."Prowac Dealer Code");
                END;
            UNTIL WEH.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure UpdateFABranch()
    var
        FixedAssets: Record "5600";
        PurchInvLine: Record "123";
    begin
        ProgressWindow.OPEN(Text000);
        FixedAssets.RESET;
        ProgressWindow.UPDATE(2, FixedAssets.COUNT);
        IF FixedAssets.FINDSET THEN
            REPEAT
                IF (FixedAssets."Global Dimension 1 Code" = '') OR
                  (FixedAssets."Global Dimension 2 Code" = '') THEN BEGIN
                    PurchInvLine.RESET;
                    PurchInvLine.SETRANGE(Type, PurchInvLine.Type::"Fixed Asset");
                    PurchInvLine.SETRANGE("No.", FixedAssets."No.");
                    IF PurchInvLine.FINDFIRST THEN BEGIN
                        FixedAssets.VALIDATE("Global Dimension 1 Code", PurchInvLine."Shortcut Dimension 1 Code");
                        FixedAssets.VALIDATE("Global Dimension 2 Code", PurchInvLine."Shortcut Dimension 2 Code");
                        FixedAssets.MODIFY;
                    END;
                    totalcount += 1;
                    ProgressWindow.UPDATE(1, totalcount);
                END;
            UNTIL FixedAssets.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure ValidateItem()
    var
        ItemJournal: Record "83";
        UnitCost: Decimal;
        Dim1: Code[20];
        Dim2: Code[20];
    begin
        ProgressWindow.OPEN(Text000);
        ItemJournal.RESET;
        ItemJournal.SETRANGE("Journal Template Name", 'ITEM');
        ItemJournal.SETRANGE("Journal Batch Name", 'DEFAULT');
        IF ItemJournal.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, ItemJournal.COUNT);
            REPEAT
                UnitCost := ItemJournal."Unit Cost";
                Dim1 := ItemJournal."Shortcut Dimension 1 Code";
                Dim2 := ItemJournal."Shortcut Dimension 2 Code";
                ItemJournal."Document No." := 'OPENING STOCK BIR';
                ItemJournal.VALIDATE("Item No.", ItemJournal."Item No.");
                ItemJournal.MODIFY(TRUE);
                ItemJournal.VALIDATE("Unit Cost", UnitCost);
                ItemJournal.VALIDATE("Unit Amount", UnitCost);
                ItemJournal.VALIDATE(Amount, ItemJournal.Quantity * UnitCost);
                ItemJournal.VALIDATE("Shortcut Dimension 1 Code", Dim1);
                ItemJournal.VALIDATE("Shortcut Dimension 2 Code", Dim2);
                ItemJournal.MODIFY(TRUE);
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);
            UNTIL ItemJournal.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure ModifyVehicleOpeningDate()
    var
        GLEntry: Record "17";
        ILE: Record "32";
        GLRegister: Record "45";
        ItemRegister: Record "46";
        ItemAppEntry: Record "339";
        ValueEntry: Record "5802";
        AvgCostAdjmt: Record "5804";
        RenData: Record "50012";
    begin
        /************* ********************
        17         G/L Entry
        32         Item Ledger Entry
        45         G/L Register
        46         Item Register
        339        Item Application Entry
        5802       Value Entry
        5804       Avg. Cost Adjmt. Entry Point
        ************************************/
        ProgressWindow.OPEN(Text000);
        RenData.RESET;
        RenData.SETRANGE(Invalid, FALSE);
        IF RenData.FINDSET THEN BEGIN
            //G/L Entry
            GLEntry.RESET;
            GLEntry.SETRANGE("Document No.", RenData."Old No.");
            IF GLEntry.FINDSET THEN BEGIN
                totalcount := 0;
                ProgressWindow.UPDATE(2, GLEntry.COUNT);
                ProgressWindow.UPDATE(3, 'G/L Entry');
                REPEAT
                    GLEntry."Posting Date" := RenData."New Date";
                    GLEntry."Document Date" := RenData."New Date";
                    GLEntry.MODIFY;
                    //G/L Register
                    GLRegister.RESET;
                    GLRegister.SETRANGE("From Entry No.", GLEntry."Entry No.");
                    IF GLRegister.FINDFIRST THEN BEGIN
                        GLRegister."Creation Date" := RenData."New Date";
                        GLRegister.MODIFY;
                    END;
                    totalcount += 1;
                    ProgressWindow.UPDATE(1, totalcount);
                UNTIL GLEntry.NEXT = 0;
            END;

            //Item Ledger Entry
            ILE.RESET;
            ILE.SETRANGE("Document No.", RenData."Old No.");
            IF ILE.FINDFIRST THEN BEGIN
                totalcount := 0;
                ProgressWindow.UPDATE(2, ILE.COUNT);
                ProgressWindow.UPDATE(3, 'Item Ledger Entry');
                REPEAT
                    ILE."Document Date" := RenData."New Date";
                    ILE."Last Invoice Date" := RenData."New Date";
                    ILE."Posting Date" := RenData."New Date";
                    ILE.MODIFY;
                    //Item Register
                    ItemRegister.RESET;
                    ItemRegister.SETRANGE("From Entry No.", ILE."Entry No.");
                    IF ItemRegister.FINDFIRST THEN BEGIN
                        ItemRegister."Creation Date" := RenData."New Date";
                        ItemRegister.MODIFY;
                    END;
                    //Item Application Entry
                    ItemAppEntry.RESET;
                    ItemAppEntry.SETRANGE("Item Ledger Entry No.", ILE."Entry No.");
                    IF ItemAppEntry.FINDSET THEN BEGIN
                        REPEAT
                            ItemAppEntry."Posting Date" := RenData."New Date";
                            ItemAppEntry."Creation Date" := CREATEDATETIME(RenData."New Date", DT2TIME(ItemAppEntry."Creation Date"));
                            //ItemAppEntry."Last Modified Date" := createdatetime(RenData."New Date",dt2time(ItemAppEntry."Creation Date"));
                            //ItemAppEntry."Output Completely Invd. Date" :=  RenData."New Date";
                            ItemAppEntry.MODIFY;
                        UNTIL ItemAppEntry.NEXT = 0;
                    END;
                    totalcount += 1;
                    ProgressWindow.UPDATE(1, totalcount);
                UNTIL ILE.NEXT = 0;
            END;

            //Value Entry
            ValueEntry.RESET;
            ValueEntry.SETRANGE("Document No.", RenData."Old No.");
            IF ValueEntry.FINDSET THEN BEGIN
                totalcount := 0;
                ProgressWindow.UPDATE(2, ValueEntry.COUNT);
                ProgressWindow.UPDATE(3, 'Value Entry');
                REPEAT
                    ValueEntry."Posting Date" := RenData."New Date";
                    ValueEntry."Document Date" := RenData."New Date";
                    ValueEntry.MODIFY;
                    totalcount += 1;
                    ProgressWindow.UPDATE(1, totalcount);
                UNTIL ValueEntry.NEXT = 0;
            END;
            //Avg. Cost Adjmt. Entry Point

            REPEAT UNTIL RenData.NEXT = 0;
        END;

    end;

    [Scope('Internal')]
    procedure ValidatePurchaseLine()
    var
        PurchaseHeader: Record "38";
        PurchaseLine: Record "39";
        SerialNo: Code[20];
        UnitPrice: Decimal;
    begin
        PurchaseHeader.RESET;
        PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Order);
        PurchaseHeader.SETRANGE("No.", 'AHOPO70-00002');
        IF PurchaseHeader.FINDFIRST THEN BEGIN
            PurchaseLine.RESET;
            PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
            PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
            IF PurchaseLine.FINDSET THEN
                REPEAT
                    SerialNo := PurchaseLine."Vehicle Serial No.";
                    UnitPrice := PurchaseLine."Direct Unit Cost";
                    PurchaseLine.VALIDATE("Buy-from Vendor No.", PurchaseHeader."Buy-from Vendor No.");
                    PurchaseLine.VALIDATE("Line Type", PurchaseLine."Line Type"::Vehicle);
                    PurchaseLine.VALIDATE("Vehicle Serial No.", SerialNo);
                    PurchaseLine.VALIDATE("Unit of Measure", 'Unit');
                    PurchaseLine.VALIDATE("Location Code", 'SUN-VH-YD');
                    PurchaseLine.VALIDATE(Quantity, 1);
                    PurchaseLine.VALIDATE("Direct Unit Cost", UnitPrice);
                    PurchaseLine.MODIFY(TRUE);
                UNTIL PurchaseLine.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure ValidateDimItemJnlLine()
    var
        IJL: Record "83";
    begin
        ProgressWindow.OPEN(Text000);
        IJL.RESET;
        IJL.SETRANGE("Journal Template Name", 'REVALUATIO');
        IJL.SETRANGE("Journal Batch Name", 'DEFAULT');
        IF IJL.FINDSET THEN BEGIN
            ProgressWindow.UPDATE(2, IJL.COUNT);
            REPEAT
                IJL.VALIDATE("Shortcut Dimension 1 Code", '101');
                IJL.VALIDATE("Shortcut Dimension 2 Code", '1001');
                IJL.MODIFY(TRUE);
                totalcount += 1;
                ProgressWindow.UPDATE(1, totalcount);
            UNTIL IJL.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure ValidatePayrollComponent()
    var
        sl: Record "33020511";
        psl: Record "33020513";
    begin
    end;

    [Scope('Internal')]
    procedure UpdateAttend()
    var
        att: Record "33020556";
    begin
        /*att.RESET;
        IF att.FINDFIRST THEN BEGIN
        REPEAT
          att."Employee Name" := '';
          att.MODIFY;
        UNTIL att.NEXT = 0;
        END;
         */

    end;

    [Scope('Internal')]
    procedure UpdateTaxInfo()
    var
        SumOfTax: Decimal;
        PostedSalaryLine: Record "33020513";
        RemainingAmount: Decimal;
        TaxSetupHeader: Record "33020505";
        TaxSetupLine: Record "33020506";
        Employee: Record "5200";
    begin
        PostedSalaryLine.RESET;
        IF PostedSalaryLine.FINDSET THEN
            REPEAT
                Employee.GET(PostedSalaryLine."Employee No.");
                TaxSetupHeader.RESET;
                TaxSetupHeader.SETRANGE(Code, Employee."Tax Code");
                TaxSetupHeader.FINDFIRST;

                RemainingAmount := PostedSalaryLine."Taxable Income";
                SumOfTax := 0;
                TaxSetupLine.RESET;
                TaxSetupLine.SETRANGE(Code, TaxSetupHeader.Code);
                IF TaxSetupLine.FINDSET THEN
                    REPEAT
                        IF RemainingAmount > 0 THEN BEGIN
                            IF TaxSetupLine."Tax Rate" = 1 THEN
                                PostedSalaryLine."Tax Paid on First Account" :=
                                  (GetTax(TaxSetupLine."Start Amount", TaxSetupLine."End Amount", RemainingAmount) * TaxSetupLine."Tax Rate" / 100.0) / 12
                            ELSE
                                SumOfTax += (GetTax(TaxSetupLine."Start Amount", TaxSetupLine."End Amount", RemainingAmount) * TaxSetupLine."Tax Rate" / 100.0) /
                                12;
                        END;
                    UNTIL (TaxSetupLine.NEXT = 0);
                PostedSalaryLine."Tax Paid on Second Account" := SumOfTax;
                PostedSalaryLine.MODIFY;
            UNTIL PostedSalaryLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetTax(StartAmount: Decimal; EndAmount: Decimal; var RemainingAmount: Decimal): Decimal
    var
        RemainingAmountCopy: Decimal;
    begin
        IF (EndAmount - StartAmount) <= RemainingAmount THEN BEGIN
            RemainingAmount := RemainingAmount - (EndAmount - StartAmount + 1);
            EXIT(EndAmount - StartAmount + 1)
        END
        ELSE BEGIN
            RemainingAmountCopy := RemainingAmount;
            RemainingAmount := 0;
            EXIT(RemainingAmountCopy);
        END;
    end;

    [Scope('Internal')]
    procedure SplitTax()
    var
        SumOfTax: Decimal;
        PostedSalaryLine: Record "33020513";
        PSL: Record "33020513";
        RemainingAmount: Decimal;
        TaxSetupHeader: Record "33020505";
        TaxSetupLine: Record "33020506";
        Employee: Record "5200";
        SalaryLedgEntry: Record "33020520";
        PRSetup: Record "33020507";
        TotalTax: Decimal;
        FirstMargin: Decimal;
        PreviouslyPaid: Decimal;
    begin
        PSL.RESET;
        IF PSL.FINDSET THEN
            REPEAT
                PSL."Tax Paid on First Account" := 0;
                PSL."Tax Paid on Second Account" := 0;
                PSL.MODIFY;
            UNTIL PSL.NEXT = 0;
        PRSetup.GET;
        PostedSalaryLine.RESET;
        IF PostedSalaryLine.FINDSET THEN
            REPEAT
                TotalTax := 0;
                PreviouslyPaid := 0;
                FirstMargin := 0;
                PSL.RESET;
                PSL.SETRANGE("Employee No.", PostedSalaryLine."Employee No.");
                IF PSL.FINDSET THEN
                    REPEAT
                        PreviouslyPaid += PSL."Tax Paid on First Account";
                    UNTIL PSL.NEXT = 0;
                TotalTax := PreviouslyPaid + PostedSalaryLine."Monthly Tax";
                Employee.GET(PostedSalaryLine."Employee No.");
                TaxSetupLine.RESET;
                TaxSetupLine.SETRANGE(Code, Employee."Tax Code");
                IF TaxSetupLine.FINDFIRST THEN BEGIN
                    FirstMargin := (TaxSetupLine."End Amount" * TaxSetupLine."Tax Rate") / 100;
                END;
                IF TotalTax <= FirstMargin THEN
                    PostedSalaryLine."Tax Paid on First Account" := PostedSalaryLine."Monthly Tax"
                ELSE
                    IF TotalTax > FirstMargin THEN BEGIN
                        PostedSalaryLine."Tax Paid on First Account" := FirstMargin - PreviouslyPaid;
                        PostedSalaryLine."Tax Paid on Second Account" := PostedSalaryLine."Monthly Tax" - PostedSalaryLine."Tax Paid on First Account";
                    END;
                PostedSalaryLine.MODIFY;
            UNTIL PostedSalaryLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure MapEmployee()
    var
        Emp: Record "5200";
        EmpMap: Record "33020559";
    begin
        EmpMap.RESET;
        IF EmpMap.FINDSET THEN
            REPEAT
                Emp.RESET;
                Emp.SETRANGE("No.", EmpMap."Employee Code");
                IF Emp.FINDFIRST THEN BEGIN
                    Emp."Attendance Emp Code" := EmpMap."Employee Mapping Code";
                    Emp.MODIFY;
                END;
            UNTIL EmpMap.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure UpdateImportInvoice()
    var
        VATEntry: Record "254";
        GLEntry: Record "17";
    begin
        VATEntry.RESET;
        VATEntry.SETFILTER("Import Invoice No.", '<>%1', '');
        IF VATEntry.FINDSET THEN
            REPEAT
                GLEntry.RESET;
                GLEntry.SETRANGE("Document No.", VATEntry."Document No.");
                IF GLEntry.FINDSET THEN
                    REPEAT
                        GLEntry."Import Invoice No." := VATEntry."Import Invoice No.";
                        GLEntry.MODIFY;
                    UNTIL GLEntry.NEXT = 0;
            UNTIL VATEntry.NEXT = 0;

        MESSAGE('Import Invoice Nos. Updated in GL Entries!!!');
    end;

    local procedure UpdatePostedServiceLine()
    var
        SalesInvoiceHeader: Record "112";
        SalesInvoiceLine: Record "113";
        LineNo: Integer;
        PostedServOrderLine: Record "25006150";
        PostedServOrderHeader: Record "25006149";
    begin
        PostedServOrderHeader.RESET;
        PostedServOrderHeader.SETRANGE("No.", 'BRRSPO75-01581');
        IF PostedServOrderHeader.FINDFIRST THEN BEGIN
            SalesInvoiceHeader.RESET;
            SalesInvoiceHeader.SETRANGE("Service Order No.", 'BRRSO75-03086');
            IF SalesInvoiceHeader.FINDFIRST THEN BEGIN
                SalesInvoiceLine.RESET;
                SalesInvoiceLine.SETRANGE("Document No.", 'BRRSPI75-02902');
                IF SalesInvoiceLine.FINDFIRST THEN
                    REPEAT
                        PostedServOrderLine.RESET;
                        PostedServOrderLine.SETRANGE("Document No.", PostedServOrderHeader."No.");
                        IF PostedServOrderLine.FINDLAST THEN
                            LineNo := PostedServOrderLine."Line No." + 10000;
                        PostedServOrderLine.INIT;
                        PostedServOrderLine."Document No." := PostedServOrderHeader."No.";
                        PostedServOrderLine."Line No." := LineNo;
                        PostedServOrderLine."Sell-to Customer No." := SalesInvoiceLine."Sell-to Customer No.";
                        PostedServOrderLine.Type := SalesInvoiceLine.Type;
                        PostedServOrderLine."No." := SalesInvoiceLine."No.";
                        PostedServOrderLine."Location Code" := SalesInvoiceLine."Location Code";
                        PostedServOrderLine.Description := SalesInvoiceLine.Description;
                        PostedServOrderLine."Unit of Measure" := SalesInvoiceLine."Unit of Measure";
                        PostedServOrderLine.Quantity := SalesInvoiceLine.Quantity;
                        PostedServOrderLine."Unit Price" := SalesInvoiceLine."Unit Price";
                        PostedServOrderLine."Unit Cost" := SalesInvoiceLine."Unit Cost";
                        PostedServOrderLine."VAT %" := SalesInvoiceLine."VAT %";
                        PostedServOrderLine.Amount := SalesInvoiceLine.Amount;
                        PostedServOrderLine."Amount Including VAT" := SalesInvoiceLine."Amount Including VAT";
                        PostedServOrderLine."Allow Invoice Disc." := SalesInvoiceLine."Allow Invoice Disc.";
                        PostedServOrderLine."Shortcut Dimension 1 Code" := SalesInvoiceLine."Shortcut Dimension 1 Code";
                        PostedServOrderLine."Shortcut Dimension 2 Code" := SalesInvoiceLine."Shortcut Dimension 2 Code";
                        PostedServOrderLine."Customer Price Group" := SalesInvoiceLine."Customer Price Group";
                        PostedServOrderLine."Bill-to Customer No." := SalesInvoiceLine."Bill-to Customer No.";
                        PostedServOrderLine."Drop Shipment" := SalesInvoiceLine."Drop Shipment";
                        PostedServOrderLine."Gen. Bus. Posting Group" := SalesInvoiceLine."Gen. Bus. Posting Group";
                        PostedServOrderLine."Gen. Prod. Posting Group" := SalesInvoiceLine."Gen. Prod. Posting Group";
                        PostedServOrderLine."VAT Calculation Type" := SalesInvoiceLine."VAT Calculation Type";
                        PostedServOrderLine."Tax Liable" := SalesInvoiceLine."Tax Liable";
                        PostedServOrderLine."VAT Bus. Posting Group" := SalesInvoiceLine."VAT Bus. Posting Group";
                        PostedServOrderLine."VAT Prod. Posting Group" := SalesInvoiceLine."VAT Prod. Posting Group";
                        PostedServOrderLine."VAT Base Amount" := SalesInvoiceLine."VAT Base Amount";
                        PostedServOrderLine."Line Amount" := SalesInvoiceLine."Line Amount";
                        PostedServOrderLine."VAT Identifier" := SalesInvoiceLine."VAT Identifier";
                        PostedServOrderLine."Dimension Set ID" := SalesInvoiceLine."Dimension Set ID";
                        PostedServOrderLine."Qty. per Unit of Measure" := SalesInvoiceLine."Qty. per Unit of Measure";
                        PostedServOrderLine."Unit of Measure Code" := SalesInvoiceLine."Unit of Measure Code";
                        PostedServOrderLine."Quantity (Base)" := SalesInvoiceLine."Quantity (Base)";
                        PostedServOrderLine."Allow Line Disc." := SalesInvoiceLine."Allow Line Disc.";
                        PostedServOrderLine."Order No." := SalesInvoiceHeader."Service Order No.";
                        PostedServOrderLine."Vehicle Serial No." := SalesInvoiceLine."Vehicle Serial No.";
                        PostedServOrderLine."Make Code" := SalesInvoiceLine."Make Code";
                        PostedServOrderLine."Vehicle Accounting Cycle No." := SalesInvoiceLine."Vehicle Accounting Cycle No.";
                        PostedServOrderLine."Accountability Center" := SalesInvoiceLine."Accountability Center";
                        PostedServOrderLine."Job Category" := SalesInvoiceLine."Job Category";
                        PostedServOrderLine."Job Type" := SalesInvoiceLine."Job Type";
                        PostedServOrderLine.INSERT(TRUE);
                    UNTIL SalesInvoiceLine.NEXT = 0;
            END;
        END;
        MESSAGE('Successfully');
    end;

    local procedure UpdatePostedCreditMemos()
    var
        PostedCrMemoHdr: Record "114";
        PostedCrMemoLine: Record "115";
    begin
        PostedCrMemoLine.RESET;
        PostedCrMemoLine.SETRANGE("Returned Invoice No.", '');
        IF PostedCrMemoLine.FINDSET THEN
            REPEAT
                PostedCrMemoHdr.GET(PostedCrMemoLine."Document No.");
                PostedCrMemoLine."Returned Invoice No." := PostedCrMemoHdr."External Document No.";
                PostedCrMemoLine.MODIFY;
            UNTIL PostedCrMemoLine.NEXT = 0;
    end;

    local procedure UpdateDimensionsInItemLedgerEntry()
    begin
    end;

    local procedure UpdateDealerPO()
    var
        SalesHdrArchive: Record "5107";
        SalesInvHead: Record "112";
    begin
        SalesInvHead.RESET;//aakrista.
        SalesInvHead.SETFILTER("Dealer PO No.", '<>%1', '');
        IF SalesInvHead.FINDFIRST THEN
            REPEAT
                SalesHdrArchive.RESET;
                SalesHdrArchive.SETRANGE("No.", SalesInvHead."Order No.");
                IF SalesHdrArchive.FINDFIRST THEN
                    REPEAT
                        SalesHdrArchive."Dealer PO No." := SalesInvHead."Dealer PO No.";
                        SalesHdrArchive.MODIFY;
                    UNTIL SalesHdrArchive.NEXT = 0;
            UNTIL SalesInvHead.NEXT = 0;


        /*SalesInvHead.SETRANGE("Order No.",SalesHdrArchive."No.");
        IF SalesInvHead.FINDFIRST THEN REPEAT
          SalesHdrArchive."Dealer PO No." := SalesInvHead."Dealer PO No.";
          SalesHdrArchive.MODIFY;
        UNTIL SalesInvHead.NEXT = 0;*/

    end;

    [Scope('Internal')]
    procedure UpdateProcurementType()
    var
        ProcurementMemo: Record "130415";
    begin
        ProcurementMemo.RESET;
        ProcurementMemo.SETFILTER("Procurement Type", '%1', ProcurementMemo."Procurement Type"::" ");
        IF ProcurementMemo.FINDSET THEN
            REPEAT
                ProcurementMemo."Procurement Type" := ProcurementMemo."Procurement Type"::Purchase;
                ProcurementMemo.MODIFY;
            UNTIL ProcurementMemo.NEXT = 0;
        MESSAGE('Success');
    end;
}


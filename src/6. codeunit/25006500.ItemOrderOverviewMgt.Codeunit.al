codeunit 25006500 "Item Order Overview Mgt."
{
    // 10.06.2014 Elva Baltic P8 #F0003 EDMS7.10
    //   * ADDED "Quantity Shipped" use
    // 
    // 13.05.2010 EBMSM01 P2
    //   * Added function SetrangeSaleOrderDate, SetrangeServiceOrderDate
    //   * Changed code FindRec, FillSalesEntries, FillServiceEntries


    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Mixed';
        Text005: Label 'Outbound,Inbound';
        PlannedDate: Date;
        PlannedDateNull: Boolean;

    [Scope('Internal')]
    procedure FindRec(var ItemOrderEntry: Record "25006730"; SourceTypeFilter: Option " ",Sale,Service,Transfer; DocNoFilter: Text[250]; SellToCustomerFilter: Code[20]; BillToCustomerFilter: Code[20]; ItemNoFilter: Code[20]; VehSerialNoFilter: Code[20]; DateFilter: Text[100])
    begin
        ItemOrderEntry.RESET;
        ItemOrderEntry.DELETEALL;

        CASE SourceTypeFilter OF
            SourceTypeFilter::" ":
                BEGIN
                    FillSalesEntries(ItemOrderEntry, DocNoFilter, SellToCustomerFilter, BillToCustomerFilter, ItemNoFilter, DateFilter);
                    FillServiceEntries(ItemOrderEntry, DocNoFilter, SellToCustomerFilter, BillToCustomerFilter,
                                     ItemNoFilter, VehSerialNoFilter, DateFilter);
                    FillTransferEntries(ItemOrderEntry, DocNoFilter, ItemNoFilter, DateFilter);

                END;

            SourceTypeFilter::Sale:
                FillSalesEntries(ItemOrderEntry, DocNoFilter, SellToCustomerFilter, BillToCustomerFilter, ItemNoFilter, DateFilter);

            SourceTypeFilter::Service:
                FillServiceEntries(ItemOrderEntry, DocNoFilter, SellToCustomerFilter, BillToCustomerFilter,
                                 ItemNoFilter, VehSerialNoFilter, DateFilter);

            SourceTypeFilter::Transfer:
                FillTransferEntries(ItemOrderEntry, DocNoFilter, ItemNoFilter, DateFilter);
        END
    end;

    [Scope('Internal')]
    procedure FillSalesEntries(var ItemOrderEntry: Record "25006730"; DocNoFilter: Text[250]; SellToCustomerFilter: Code[20]; BillToCustomerFilter: Code[20]; ItemNoFilter: Code[20]; DateFilter: Text[100])
    var
        SalesHeader: Record "36";
        SalesLine: Record "37";
        EntryNo: Integer;
    begin
        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("Document Profile");
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SETRANGE("Document Profile", SalesLine."Document Profile"::"Spare Parts Trade");

        SetrangeSaleDocNo(SalesHeader, DocNoFilter);
        SetrangeSaleSellToCustomer(SalesHeader, SellToCustomerFilter);
        SetrangeSaleBillToCustomer(SalesHeader, BillToCustomerFilter);
        SetrangeSaleOrderDate(SalesHeader, DateFilter);

        IF SalesHeader.FINDFIRST THEN
            REPEAT
                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                SalesLine.SETRANGE(Type, SalesLine.Type::Item);
                SetrangeSaleItem(SalesLine, ItemNoFilter);

                IF SalesLine.FINDFIRST THEN BEGIN
                    ItemOrderEntry.RESET;
                    IF ItemOrderEntry.FINDLAST THEN
                        EntryNo := ItemOrderEntry."Entry No."
                    ELSE
                        EntryNo := 0;

                    REPEAT
                        EntryNo += 1;
                        ItemOrderEntry.TRANSFERFIELDS(SalesLine);
                        ItemOrderEntry."Entry No." := EntryNo;
                        ItemOrderEntry."Document Profile" := 37;
                        ItemOrderEntry.INSERT;
                        SalesLine.CALCFIELDS("Reserved Quantity");
                        IF SalesLine."Reserved Quantity" = SalesLine.Quantity THEN BEGIN
                            PlannedDate := 0D;
                            PlannedDateNull := FALSE;
                            GetPlannedAvailDate(DATABASE::"Sales Line", SalesLine."Document Type", SalesLine."Document No.",
                                                SalesLine."Line No.");
                            IF PlannedDateNull THEN
                                PlannedDate := 0D;
                            ItemOrderEntry."Planned Avail. Date" := PlannedDate;
                            ItemOrderEntry.MODIFY;
                        END;
                    UNTIL SalesLine.NEXT = 0;
                END;
            UNTIL SalesHeader.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure FillServiceEntries(var ItemOrderEntry: Record "25006730"; DocNoFilter: Text[250]; SellToCustomerFilter: Code[20]; BillToCustomerFilter: Code[20]; ItemNoFilter: Code[20]; VehSerialNoFilter: Code[20]; DateFilter: Text[100])
    var
        ServiceHeader: Record "25006145";
        ServiceLine: Record "25006146";
        EntryNo: Integer;
    begin
        ServiceHeader.RESET;
        SetrangeServiceDocNo(ServiceHeader, DocNoFilter);
        SetrangeServiceSellToCustomer(ServiceHeader, SellToCustomerFilter);
        SetrangeServiceBillToCustomer(ServiceHeader, BillToCustomerFilter);
        SetrangeServiceVehicle(ServiceHeader, VehSerialNoFilter);
        SetrangeServiceOrderDate(ServiceHeader, DateFilter);

        IF ServiceHeader.FINDFIRST THEN
            REPEAT
                ServiceLine.RESET;
                ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
                ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
                ServiceLine.SETRANGE(Type, ServiceLine.Type::Item);
                SetrangeServiceItem(ServiceLine, ItemNoFilter);

                IF ServiceLine.FINDFIRST THEN BEGIN
                    ItemOrderEntry.RESET;
                    IF ItemOrderEntry.FINDLAST THEN
                        EntryNo := ItemOrderEntry."Entry No."
                    ELSE
                        EntryNo := 0;

                    REPEAT
                        EntryNo += 1;
                        ItemOrderEntry.TRANSFERFIELDS(ServiceLine);
                        ItemOrderEntry."Quantity Shipped" := 0; //10.06.2014 Elva Baltic P8 #F0003 EDMS7.10
                        ItemOrderEntry."Entry No." := EntryNo;
                        ItemOrderEntry."Document Profile" := 25006146;
                        ItemOrderEntry.INSERT;
                        ServiceLine.CALCFIELDS("Reserved Quantity");
                        IF ServiceLine."Reserved Quantity" = ServiceLine.Quantity THEN BEGIN
                            PlannedDate := 0D;
                            PlannedDateNull := FALSE;
                            GetPlannedAvailDate(DATABASE::"Service Line EDMS", ServiceLine."Document Type", ServiceLine."Document No.",
                                                ServiceLine."Line No.");
                            IF PlannedDateNull THEN
                                PlannedDate := 0D;
                            ItemOrderEntry."Planned Avail. Date" := PlannedDate;
                            ItemOrderEntry.MODIFY;
                        END;
                    UNTIL ServiceLine.NEXT = 0;
                END;
            UNTIL ServiceHeader.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure FillTransferEntries(var ItemOrderEntry: Record "25006730"; DocNoFilter: Text[250]; ItemNoFilter: Code[20]; DateFilter: Text[100])
    var
        TransferLine: Record "5741";
        EntryNo: Integer;
    begin
        TransferLine.RESET;
        SetrangeTransferDocNo(TransferLine, DocNoFilter);
        SetrangeTransferItem(TransferLine, ItemNoFilter);
        SetrangeTransferShipmentDate(TransferLine, DateFilter);

        IF TransferLine.FINDFIRST THEN BEGIN
            ItemOrderEntry.RESET;
            IF ItemOrderEntry.FINDLAST THEN
                EntryNo := ItemOrderEntry."Entry No."
            ELSE
                EntryNo := 0;

            REPEAT
                EntryNo += 1;
                ItemOrderEntry."Entry No." := EntryNo;
                ItemOrderEntry."Document Profile" := DATABASE::"Transfer Line";
                ItemOrderEntry."Document No." := TransferLine."Document No.";
                ItemOrderEntry."Line No." := TransferLine."Line No.";
                ItemOrderEntry.Description := TransferLine.Description;
                ItemOrderEntry."Description 2" := TransferLine."Description 2";
                ItemOrderEntry."Item No." := TransferLine."Item No.";
                ItemOrderEntry."Unit of Measure" := TransferLine."Unit of Measure";
                ItemOrderEntry.Quantity := TransferLine.Quantity;
                ItemOrderEntry."Shortcut Dimension 1 Code" := TransferLine."Shortcut Dimension 1 Code";
                ItemOrderEntry."Shortcut Dimension 2 Code" := TransferLine."Shortcut Dimension 2 Code";
                ItemOrderEntry."Location Code" := TransferLine."Transfer-from Code";
                ItemOrderEntry."Planned Shipment Date" := TransferLine."Shipment Date";
                ItemOrderEntry."Planned Delivery Date" := TransferLine."Receipt Date";
                TransferLine.CALCFIELDS("Reserved Quantity Outbnd.");
                IF TransferLine."Reserved Quantity Outbnd." = TransferLine.Quantity THEN BEGIN
                    PlannedDate := 0D;
                    PlannedDateNull := FALSE;
                    GetPlannedAvailDate(DATABASE::"Transfer Line", 0, TransferLine."Document No.",
                                        TransferLine."Line No.");
                    IF PlannedDateNull THEN
                        PlannedDate := 0D;
                    ItemOrderEntry."Planned Avail. Date" := PlannedDate;
                END;
                ItemOrderEntry.INSERT;
            UNTIL TransferLine.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure SetrangeSaleDocNo(var SalesHeader: Record "36"; DocNoFilter: Text[250])
    begin
        IF DocNoFilter <> '' THEN
            SalesHeader.SETRANGE("No.", DocNoFilter);
    end;

    [Scope('Internal')]
    procedure SetrangeSaleSellToCustomer(var Salesheader: Record "36"; SellToCustomerFilter: Code[20])
    begin
        IF SellToCustomerFilter <> '' THEN
            Salesheader.SETRANGE("Sell-to Customer No.", SellToCustomerFilter);
    end;

    [Scope('Internal')]
    procedure SetrangeSaleBillToCustomer(var Salesheader: Record "36"; BillToCustomerFilter: Code[20])
    begin
        IF BillToCustomerFilter <> '' THEN
            Salesheader.SETRANGE("Bill-to Customer No.", BillToCustomerFilter);
    end;

    [Scope('Internal')]
    procedure SetrangeSaleItem(var SalesLine: Record "37"; ItemNoFilter: Code[20])
    begin
        IF ItemNoFilter <> '' THEN
            SalesLine.SETRANGE("No.", ItemNoFilter);
    end;

    [Scope('Internal')]
    procedure SetrangeSaleOrderDate(var SalesHeader: Record "36"; DateFilter: Text[100])
    begin
        IF DateFilter <> '' THEN
            SalesHeader.SETFILTER("Order Date", DateFilter);
    end;

    [Scope('Internal')]
    procedure SetrangeServiceDocNo(var ServiceHeader: Record "25006145"; DocNoFilter: Text[250])
    begin
        IF DocNoFilter <> '' THEN
            ServiceHeader.SETRANGE("No.", DocNoFilter);
    end;

    [Scope('Internal')]
    procedure SetrangeServiceSellToCustomer(var ServiceHeader: Record "25006145"; SellToCustomerFilter: Code[20])
    begin
        IF SellToCustomerFilter <> '' THEN
            ServiceHeader.SETRANGE("Sell-to Customer No.", SellToCustomerFilter);
    end;

    [Scope('Internal')]
    procedure SetrangeServiceBillToCustomer(var ServiceHeader: Record "25006145"; BillToCustomerFilter: Code[20])
    begin
        IF BillToCustomerFilter <> '' THEN
            ServiceHeader.SETRANGE("Bill-to Customer No.", BillToCustomerFilter);
    end;

    [Scope('Internal')]
    procedure SetrangeServiceItem(var ServiceLine: Record "25006146"; ItemNoFilter: Code[20])
    begin
        IF ItemNoFilter <> '' THEN
            ServiceLine.SETRANGE("No.", ItemNoFilter);
    end;

    [Scope('Internal')]
    procedure SetrangeServiceVehicle(var ServiceHeader: Record "25006145"; VehSerialNoFilter: Code[20])
    begin
        IF VehSerialNoFilter <> '' THEN
            ServiceHeader.SETRANGE("Vehicle Serial No.", VehSerialNoFilter);
    end;

    [Scope('Internal')]
    procedure SetrangeServiceOrderDate(var ServiceHeader: Record "25006145"; DateFilter: Text[100])
    begin
        IF DateFilter <> '' THEN
            ServiceHeader.SETFILTER("Order Date", DateFilter);
    end;

    [Scope('Internal')]
    procedure SetrangeTransferDocNo(var TransferLine: Record "5741"; DocNoFilter: Text[250])
    begin
        IF DocNoFilter <> '' THEN
            TransferLine.SETRANGE("Document No.", DocNoFilter);
    end;

    [Scope('Internal')]
    procedure SetrangeTransferItem(var TransferLine: Record "5741"; ItemNoFilter: Code[20])
    begin
        IF ItemNoFilter <> '' THEN
            TransferLine.SETRANGE("Item No.", ItemNoFilter);
    end;

    [Scope('Internal')]
    procedure SetrangeTransferShipmentDate(var TransferLine: Record "5741"; DateFilter: Text[100])
    begin
        IF DateFilter <> '' THEN
            TransferLine.SETFILTER("Shipment Date", DateFilter);
    end;

    [Scope('Internal')]
    procedure CreateText(SourceTypeID: Integer): Text[80]
    var
        DocProfile: Option " ","Spare Part Sale",Service;
        SourceTypeText: Label ' Spare Part Sale,Service';
    begin
        CASE SourceTypeID OF
            DATABASE::"Sales Line":
                BEGIN
                    DocProfile := DocProfile::"Spare Part Sale";
                    EXIT(STRSUBSTNO('%1', SELECTSTR(DocProfile, SourceTypeText)));
                END;
            DATABASE::"Service Line EDMS":
                BEGIN
                    DocProfile := DocProfile::Service;
                    EXIT(STRSUBSTNO('%1', SELECTSTR(DocProfile, SourceTypeText)));
                END;
        END;

        EXIT('');
    end;

    [Scope('Internal')]
    procedure GetSourceDescription(ItemOrderEntry: Record "25006730"): Text[30]
    var
        ReservationEntry: Record "337";
        ReservationEntry2: Record "337";
        SourceType: Integer;
    begin
        ItemOrderEntry.CALCFIELDS("Reserved Qty. (Base)");
        IF ItemOrderEntry."Reserved Qty. (Base)" = 0 THEN
            EXIT('');

        SourceType := -1;

        ReservationEntry.RESET;
        ReservationEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ReservationEntry.SETRANGE("Source ID", ItemOrderEntry."Document No.");
        ReservationEntry.SETRANGE("Source Ref. No.", ItemOrderEntry."Line No.");
        ReservationEntry.SETRANGE("Source Type", ItemOrderEntry."Document Profile");
        ReservationEntry.SETRANGE("Source Subtype", ItemOrderEntry."Document Type");
        ReservationEntry.SETRANGE("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        IF ReservationEntry.COUNT = 1 THEN BEGIN
            ReservationEntry.FINDFIRST;
            EXIT(CreateSourceText(ReservationEntry));
        END;
        IF ReservationEntry.FINDFIRST THEN
            REPEAT
                IF ReservationEntry2.GET(ReservationEntry."Entry No.", TRUE) THEN BEGIN
                    IF SourceType = -1 THEN
                        SourceType := ReservationEntry2."Source Type";
                    IF SourceType <> ReservationEntry2."Source Type" THEN
                        EXIT(Text001);
                END;
            UNTIL ReservationEntry.NEXT = 0;

        IF ReservationEntry.FINDFIRST THEN
            EXIT(CreateSourceText(ReservationEntry))
        ELSE
            EXIT('');
    end;

    [Scope('Internal')]
    procedure GetSourceDescription2(ItemOrderEntry: Record "25006730"): Text[30]
    var
        ReservationEntry: Record "337";
        ReservationEntry2: Record "337";
        ReservationEntry3: Record "337";
        ReservationEntry4: Record "337";
        SourceType: Integer;
        EntryNo: Integer;
    begin
        ItemOrderEntry.CALCFIELDS("Reserved Qty. (Base)");
        IF ItemOrderEntry."Reserved Qty. (Base)" = 0 THEN
            EXIT('');

        SourceType := -1;

        ReservationEntry.RESET;
        ReservationEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ReservationEntry.SETRANGE("Source ID", ItemOrderEntry."Document No.");
        ReservationEntry.SETRANGE("Source Ref. No.", ItemOrderEntry."Line No.");
        ReservationEntry.SETRANGE("Source Type", ItemOrderEntry."Document Profile");
        ReservationEntry.SETRANGE("Source Subtype", ItemOrderEntry."Document Type");
        ReservationEntry.SETRANGE("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        IF ReservationEntry.FINDFIRST THEN
            REPEAT
                IF ReservationEntry2.GET(ReservationEntry."Entry No.", TRUE) THEN BEGIN
                    IF ReservationEntry2."Source Type" = DATABASE::"Transfer Line" THEN BEGIN
                        ReservationEntry3.RESET;
                        ReservationEntry3.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
                        ReservationEntry3.SETRANGE("Source ID", ReservationEntry2."Source ID");
                        ReservationEntry3.SETRANGE("Source Ref. No.", ReservationEntry2."Source Ref. No.");
                        ReservationEntry3.SETRANGE("Source Type", ReservationEntry2."Source Type");
                        ReservationEntry3.SETRANGE("Reservation Status", ReservationEntry3."Reservation Status"::Reservation);
                        ReservationEntry3.SETRANGE(Positive, FALSE);

                        IF ReservationEntry3.FINDFIRST THEN
                            REPEAT
                                IF ReservationEntry4.GET(ReservationEntry3."Entry No.", TRUE) THEN BEGIN
                                    IF SourceType = -1 THEN BEGIN
                                        SourceType := ReservationEntry4."Source Type";
                                        EntryNo := ReservationEntry4."Entry No.";
                                    END;
                                    IF SourceType <> ReservationEntry4."Source Type" THEN
                                        EXIT(Text001);
                                END;
                            UNTIL ReservationEntry3.NEXT = 0;
                    END;
                END;
            UNTIL ReservationEntry.NEXT = 0;

        IF EntryNo <> 0 THEN BEGIN
            ReservationEntry4.GET(EntryNo, TRUE);
            EXIT(CreateSourceText(ReservationEntry4));
        END ELSE
            EXIT('');
    end;

    [Scope('Internal')]
    procedure GetSourceColor(ItemOrderEntry: Record "25006730"): Integer
    var
        ReservationEntry: Record "337";
        ReservationEntry2: Record "337";
        SourceType: Integer;
        IOOSetup: Record "25006737";
    begin
        IF NOT IOOSetup.GET THEN
            EXIT(0);
        IF NOT IOOSetup."Highlight Statuses" THEN
            EXIT(0);

        ItemOrderEntry.CALCFIELDS("Reserved Qty. (Base)");
        IF ItemOrderEntry."Reserved Qty. (Base)" = 0 THEN
            EXIT(IOOSetup."Not Reserved Color");

        SourceType := -1;

        ReservationEntry.RESET;
        ReservationEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ReservationEntry.SETRANGE("Source ID", ItemOrderEntry."Document No.");
        ReservationEntry.SETRANGE("Source Ref. No.", ItemOrderEntry."Line No.");
        ReservationEntry.SETRANGE("Source Type", ItemOrderEntry."Document Profile");
        ReservationEntry.SETRANGE("Source Subtype", ItemOrderEntry."Document Type");
        ReservationEntry.SETRANGE("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        IF ReservationEntry.COUNT = 1 THEN BEGIN
            ReservationEntry.FINDFIRST;
            IF ReservationEntry2.GET(ReservationEntry."Entry No.", TRUE) THEN BEGIN
                CASE ReservationEntry2."Source Type" OF
                    DATABASE::"Item Ledger Entry":
                        EXIT(IOOSetup."Item Ledger Entry Color");
                    DATABASE::"Transfer Line":
                        EXIT(IOOSetup."Transfer Line Color");
                    DATABASE::"Purchase Line":
                        EXIT(IOOSetup."Purchase Line Color");
                    DATABASE::"Requisition Line":
                        EXIT(IOOSetup."Requisition Line Color");
                END;
            END;
        END;

        IF ReservationEntry.FINDFIRST THEN
            REPEAT
                IF ReservationEntry2.GET(ReservationEntry."Entry No.", TRUE) THEN BEGIN
                    IF SourceType = -1 THEN
                        SourceType := ReservationEntry2."Source Type";
                    IF SourceType <> ReservationEntry2."Source Type" THEN
                        EXIT(IOOSetup."Mixed Color");
                END;
            UNTIL ReservationEntry.NEXT = 0;
        CASE ReservationEntry2."Source Type" OF
            DATABASE::"Item Ledger Entry":
                EXIT(IOOSetup."Item Ledger Entry Color");
            DATABASE::"Transfer Line":
                EXIT(IOOSetup."Transfer Line Color");
            DATABASE::"Purchase Line":
                EXIT(IOOSetup."Purchase Line Color");
            DATABASE::"Requisition Line":
                EXIT(IOOSetup."Requisition Line Color");
        END;
    end;

    [Scope('Internal')]
    procedure GetSourceColor2(ItemOrderEntry: Record "25006730"): Integer
    var
        ReservationEntry: Record "337";
        ReservationEntry2: Record "337";
        ReservationEntry3: Record "337";
        ReservationEntry4: Record "337";
        SourceType: Integer;
        EntryNo: Integer;
        IOOSetup: Record "25006737";
    begin
        IF NOT IOOSetup.GET THEN
            EXIT(16777215);
        IF NOT IOOSetup."Highlight Statuses" THEN
            EXIT(16777215);

        ItemOrderEntry.CALCFIELDS("Reserved Qty. (Base)");
        IF ItemOrderEntry."Reserved Qty. (Base)" = 0 THEN
            EXIT(16777215);

        SourceType := -1;

        ReservationEntry.RESET;
        ReservationEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ReservationEntry.SETRANGE("Source ID", ItemOrderEntry."Document No.");
        ReservationEntry.SETRANGE("Source Ref. No.", ItemOrderEntry."Line No.");
        ReservationEntry.SETRANGE("Source Type", ItemOrderEntry."Document Profile");
        ReservationEntry.SETRANGE("Source Subtype", ItemOrderEntry."Document Type");
        ReservationEntry.SETRANGE("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        IF ReservationEntry.FINDFIRST THEN
            REPEAT
                IF ReservationEntry2.GET(ReservationEntry."Entry No.", TRUE) THEN BEGIN
                    IF ReservationEntry2."Source Type" = DATABASE::"Transfer Line" THEN BEGIN
                        ReservationEntry3.RESET;
                        ReservationEntry3.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
                        ReservationEntry3.SETRANGE("Source ID", ReservationEntry2."Source ID");
                        ReservationEntry3.SETRANGE("Source Ref. No.", ReservationEntry2."Source Ref. No.");
                        ReservationEntry3.SETRANGE("Source Type", ReservationEntry2."Source Type");
                        ReservationEntry3.SETRANGE("Reservation Status", ReservationEntry3."Reservation Status"::Reservation);
                        ReservationEntry3.SETRANGE(Positive, FALSE);

                        IF ReservationEntry3.FINDFIRST THEN
                            REPEAT
                                IF ReservationEntry4.GET(ReservationEntry3."Entry No.", TRUE) THEN BEGIN
                                    IF SourceType = -1 THEN BEGIN
                                        SourceType := ReservationEntry4."Source Type";
                                        EntryNo := ReservationEntry4."Entry No.";
                                    END;
                                    IF SourceType <> ReservationEntry4."Source Type" THEN
                                        EXIT(IOOSetup."Mixed Color");
                                END;
                            UNTIL ReservationEntry3.NEXT = 0;
                    END;
                END;
            UNTIL ReservationEntry.NEXT = 0;

        IF EntryNo <> 0 THEN BEGIN
            ReservationEntry4.GET(EntryNo, TRUE);
            CASE ReservationEntry4."Source Type" OF
                DATABASE::"Item Ledger Entry":
                    EXIT(IOOSetup."Item Ledger Entry Color");
                DATABASE::"Transfer Line":
                    EXIT(IOOSetup."Transfer Line Color");
                DATABASE::"Purchase Line":
                    EXIT(IOOSetup."Purchase Line Color");
                DATABASE::"Requisition Line":
                    EXIT(IOOSetup."Requisition Line Color");
            END;
        END ELSE
            EXIT(16777215);
    end;

    [Scope('Internal')]
    procedure CreateSourceText(ReservEntry: Record "337"): Text[80]
    begin
        IF ReservEntry.GET(ReservEntry."Entry No.", TRUE) THEN
            EXIT(CreateSource(ReservEntry))
        ELSE
            EXIT('');
    end;

    [Scope('Internal')]
    procedure CreateSource(ReservEntry: Record "337"): Text[80]
    var
        CalcSalesLine: Record "37";
        CalcPurchLine: Record "39";
        CalcItemJnlLine: Record "83";
        CalcProdOrderLine: Record "5406";
        CalcJobJnlLine: Record "210";
        SourceType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry","Prod. Order Line","Prod. Order Component","Planning Line","Planning Component",Transfer,"Service Order","Job Journal";
        SourceTypeText: Label 'Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Prod. Order Line,Prod. Order Component,Planning Line,Planning Component,Transfer,Service Order';
    begin
        CASE ReservEntry."Source Type" OF
            DATABASE::"Sales Line":
                BEGIN
                    SourceType := SourceType::Sales;
                    CalcSalesLine."Document Type" := ReservEntry."Source Subtype";
                    EXIT(STRSUBSTNO('%1 %2', SELECTSTR(SourceType, SourceTypeText),
                      CalcSalesLine."Document Type"));
                END;
            DATABASE::"Purchase Line":
                BEGIN
                    SourceType := SourceType::Purchase;
                    CalcPurchLine."Document Type" := ReservEntry."Source Subtype";
                    EXIT(STRSUBSTNO('%1 %2', SELECTSTR(SourceType, SourceTypeText),
                      CalcPurchLine."Document Type"));
                END;
            DATABASE::"Requisition Line":
                BEGIN
                    SourceType := SourceType::"Requisition Line";
                    EXIT(STRSUBSTNO('%1', SELECTSTR(SourceType, SourceTypeText)));
                END;
            DATABASE::"Planning Component":
                BEGIN
                    SourceType := SourceType::"Planning Component";
                    EXIT(STRSUBSTNO('%1', SELECTSTR(SourceType, SourceTypeText)));
                END;
            DATABASE::Table89:
                BEGIN
                    SourceType := SourceType::"BOM Journal";
                    EXIT(STRSUBSTNO('%1', SELECTSTR(SourceType, SourceTypeText)));
                END;
            DATABASE::"Item Journal Line":
                BEGIN
                    SourceType := SourceType::"Item Journal";
                    CalcItemJnlLine."Entry Type" := ReservEntry."Source Subtype";
                    EXIT(STRSUBSTNO('%1 %2', SELECTSTR(SourceType, SourceTypeText),
                      CalcItemJnlLine."Entry Type"));
                END;
            DATABASE::"Job Journal Line":
                BEGIN
                    SourceType := SourceType::"Job Journal";
                    EXIT(STRSUBSTNO('%1 %2', SELECTSTR(SourceType, SourceTypeText),
                      CalcJobJnlLine."Entry Type"));
                END;
            DATABASE::"Item Ledger Entry":
                BEGIN
                    SourceType := SourceType::"Item Ledger Entry";
                    EXIT(STRSUBSTNO('%1', SELECTSTR(SourceType, SourceTypeText)));
                END;
            DATABASE::"Prod. Order Line":
                BEGIN
                    SourceType := SourceType::"Prod. Order Line";
                    CalcProdOrderLine.Status := ReservEntry."Source Subtype";
                    EXIT(STRSUBSTNO('%1 %2', SELECTSTR(SourceType, SourceTypeText),
                      CalcProdOrderLine.Status));
                END;
            DATABASE::"Prod. Order Component":
                BEGIN
                    SourceType := SourceType::"Prod. Order Component";
                    CalcProdOrderLine.Status := ReservEntry."Source Subtype";
                    EXIT(STRSUBSTNO('%1 %2', SELECTSTR(SourceType, SourceTypeText),
                      CalcProdOrderLine.Status));
                END;
            DATABASE::"Transfer Line":
                BEGIN
                    SourceType := SourceType::Transfer;
                    EXIT(STRSUBSTNO('%1, %2', SELECTSTR(SourceType, SourceTypeText),
                      SELECTSTR(ReservEntry."Source Subtype" + 1, Text005)));
                END;
            DATABASE::"Service Line":
                BEGIN
                    SourceType := SourceType::"Service Order";
                    EXIT(STRSUBSTNO('%1', SELECTSTR(SourceType, SourceTypeText)));
                END;
            DATABASE::"Service Line EDMS": //08.07.08 EDMS P1
                BEGIN
                    SourceType := SourceType::"Service Order";
                    EXIT(STRSUBSTNO('%1', SELECTSTR(SourceType, SourceTypeText)));
                END;
        END;

        EXIT('');
    end;

    [Scope('Internal')]
    procedure ShowRec(ItemOrderEntry: Record "25006730")
    var
        SalesHeader: Record "36";
        ServiceHeader: Record "25006145";
    begin
        CASE ItemOrderEntry."Document Profile" OF
            DATABASE::"Sales Line":
                BEGIN
                    IF SalesHeader.GET(ItemOrderEntry."Document Type", ItemOrderEntry."Document No.") THEN;
                    CASE ItemOrderEntry."Document Type" OF
                        ItemOrderEntry."Document Type"::Quote:
                            PAGE.RUN(PAGE::"Sales Quote", SalesHeader);
                        ItemOrderEntry."Document Type"::Order:
                            PAGE.RUN(PAGE::"Sales Order", SalesHeader);
                        ItemOrderEntry."Document Type"::"Return Order":
                            PAGE.RUN(PAGE::"Sales Return Order", SalesHeader);
                        ItemOrderEntry."Document Type"::Invoice:
                            PAGE.RUN(PAGE::"Sales Invoice", SalesHeader);
                    END;
                END;
            DATABASE::"Service Line EDMS":
                BEGIN
                    IF ServiceHeader.GET(ItemOrderEntry."Document Type", ItemOrderEntry."Document No.") THEN;
                    CASE ItemOrderEntry."Document Type" OF
                        ItemOrderEntry."Document Type"::Quote:
                            PAGE.RUN(PAGE::"Service Quote EDMS", ServiceHeader);
                        ItemOrderEntry."Document Type"::Order:
                            PAGE.RUN(PAGE::"Service Order EDMS", ServiceHeader);
                        ItemOrderEntry."Document Type"::"Return Order":
                            PAGE.RUN(PAGE::"Service Return Order EDMS", ServiceHeader);
                    END;
                END;
        END;
    end;

    [Scope('Internal')]
    procedure GetPlannedAvailDate(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    var
        ReservationEntry1: Record "337";
        ReservationEntry2: Record "337";
        PurchLine: Record "39";
        TransferLine: Record "5741";
    begin
        ReservationEntry1.SETCURRENTKEY("Source ID");
        ReservationEntry1.SETRANGE("Source ID", SourceID);
        ReservationEntry1.SETRANGE("Source Type", SourceType);
        IF SourceType <> DATABASE::"Transfer Line" THEN
            ReservationEntry1.SETRANGE("Source Subtype", SourceSubtype);
        ReservationEntry1.SETRANGE("Source Ref. No.", SourceRefNo);
        IF ReservationEntry1.FINDFIRST THEN BEGIN
            REPEAT
                IF ReservationEntry2.GET(ReservationEntry1."Entry No.", NOT ReservationEntry1.Positive) THEN BEGIN
                    CASE ReservationEntry2."Source Type" OF
                        DATABASE::"Item Ledger Entry":
                            IF (PlannedDate = 0D) OR (PlannedDate < TODAY) THEN
                                PlannedDate := TODAY;
                        DATABASE::"Transfer Line":
                            IF TransferLine.GET(ReservationEntry2."Source ID", ReservationEntry2."Source Ref. No.") THEN BEGIN
                                TransferLine.CALCFIELDS("Reserved Quantity Outbnd.");
                                IF TransferLine."Reserved Quantity Outbnd." < TransferLine.Quantity THEN BEGIN
                                    PlannedDateNull := TRUE;
                                    EXIT;
                                END;
                                GetPlannedAvailDate(ReservationEntry2."Source Type", ReservationEntry2."Source Subtype",
                                                    ReservationEntry2."Source ID", ReservationEntry2."Source Ref. No.");
                            END;
                        DATABASE::"Purchase Line":
                            BEGIN
                                IF PurchLine.GET(ReservationEntry2."Source Subtype", ReservationEntry2."Source ID",
                                                 ReservationEntry2."Source Ref. No.") THEN
                                    ;
                                IF (PlannedDate = 0D) OR (PlannedDate < PurchLine."Expected Receipt Date") THEN
                                    PlannedDate := PurchLine."Expected Receipt Date";
                            END;
                    END;
                END;
            UNTIL ReservationEntry1.NEXT = 0;
        END
    end;
}


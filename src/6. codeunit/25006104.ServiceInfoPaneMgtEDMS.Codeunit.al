codeunit 25006104 "Service Info-Pane Mgt. EDMS"
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified CalcAvailability(), Usert Profile Setup to Branch Profile Setup
    // 
    // 14.05.2014 Elva Baltic P8 #S0038 MMG7.00
    //   * PERFORMANCE ISSUE resolve
    // 
    // 10.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added functions:
    //     GetVehicleDocCount
    //     LookupVehicleDoc
    // 
    // 30.01.2014 Elva Baltic P8 #F038 MMG7.00
    //   * Added functions *VehicleContracts*, *VehicleWarranty*
    // 
    // 26.04.2013 EDMS P8
    //   * Added functions: LookupRet*


    trigger OnRun()
    begin
    end;

    var
        Cust: Record "18";
        Item: Record "27";
        ServiceHeader: Record "25006145";
        ServPlanDocumentLink: Record "25006157";
        SalesPriceCalcMgt: Codeunit "7000";
        Text000: Label 'The Ship-to Address has been changed.';
        cuLookUpMgt: Codeunit "25006003";
        Text001: Label 'Pending';
        Text002: Label 'Serviced';
        Text003: Label 'In Process';
        Text004: Label 'Skipped';

    [Scope('Internal')]
    procedure CalcNoOfDocuments(var Cust: Record "18")
    begin
        Cust.CALCFIELDS(
          "No. of Quotes", "No. of Blanket Orders", "No. of Orders", "No. of Invoices",
          "No. of Return Orders", "No. of Credit Memos", "No. of Pstd. Shipments",
          "No. of Pstd. Invoices", "No. of Pstd. Return Receipts", "No. of Pstd. Credit Memos");
    end;

    [Scope('Internal')]
    procedure CalcTotalNoOfDocuments(CustNo: Code[20]): Integer
    begin
        GetCust(CustNo);
        CalcNoOfDocuments(Cust);
        EXIT(
          Cust."No. of Quotes" + Cust."No. of Blanket Orders" + Cust."No. of Orders" + Cust."No. of Invoices" +
          Cust."No. of Return Orders" + Cust."No. of Credit Memos" + Cust."No. of Pstd. Shipments" +
          Cust."No. of Pstd. Invoices" + Cust."No. of Pstd. Return Receipts" + Cust."No. of Pstd. Credit Memos");
    end;

    [Scope('Internal')]
    procedure CalcNoOfShipToAddr(CustNo: Code[20]): Integer
    begin
        GetCust(CustNo);
        Cust.CALCFIELDS("No. of Ship-to Addresses");
        EXIT(Cust."No. of Ship-to Addresses");
    end;

    [Scope('Internal')]
    procedure CalcNoOfContacts(ServiceHeader: Record "25006145"): Integer
    var
        Cont: Record "5050";
        ContBusRelation: Record "5054";
    begin
        Cont.SETCURRENTKEY("Company No.");
        IF ServiceHeader."Sell-to Customer No." <> '' THEN BEGIN
            IF Cont.GET("Sell-to Contact No.") THEN
                Cont.SETRANGE("Company No.", Cont."Company No.")
            ELSE BEGIN
                ContBusRelation.RESET;
                ContBusRelation.SETCURRENTKEY("Link to Table", "No.");
                ContBusRelation.SETRANGE("Link to Table", ContBusRelation."Link to Table"::Customer);
                ContBusRelation.SETRANGE("No.", ServiceHeader."Sell-to Customer No.");
                IF ContBusRelation.FINDFIRST THEN
                    Cont.SETRANGE("Company No.", ContBusRelation."Contact No.")
                ELSE
                    Cont.SETRANGE("No.", '');
            END;
            EXIT(Cont.COUNT);
        END;
    end;

    [Scope('Internal')]
    procedure CalcAvailableCredit(CustNo: Code[20]): Decimal
    var
        TotalAmountLCY: Decimal;
    begin
        GetCust(CustNo);
        Cust.SETRANGE("Date Filter", 0D, WORKDATE);
        Cust.CALCFIELDS("Balance (LCY)", "Outstanding Orders (LCY)", "Shipped Not Invoiced (LCY)");
        TotalAmountLCY := Cust."Balance (LCY)" + Cust."Outstanding Orders (LCY)" + Cust."Shipped Not Invoiced (LCY)";

        IF Cust."Credit Limit (LCY)" <> 0 THEN
            EXIT(Cust."Credit Limit (LCY)" - TotalAmountLCY);
    end;

    [Scope('Internal')]
    procedure CalcAvailability(var recServiceLine: Record "25006146"): Decimal
    var
        UserProfile: Record "25006067";
        AvailableToPromise: Codeunit "5790";
        SingleInstanceMgt: Codeunit "25006001";
        LocationCode: Code[20];
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        PeriodType: Option Day,Week,Month,Quarter,Year;
        AvailabilityDate: Date;
        LookaheadDateformula: DateFormula;
        UserProfileMgt: Codeunit "25006002";
    begin
        IF GetItem(recServiceLine) THEN BEGIN
            IF recServiceLine."Planned Service Date" <> 0D THEN
                AvailabilityDate := recServiceLine."Planned Service Date"
            ELSE
                AvailabilityDate := WORKDATE;

            //25.02.2010 EDMSB P2 >>
            LocationCode := recServiceLine."Location Code";
            //Sipradi-YS VSW6.1.1 * Code commented Because Location Code Must be Service Location Code
            /*
            IF UserProfile.GET(UserProfileMgt.CurrProfileID,UserProfileMgt.CurrBranchNo) AND (UserProfile."Def. Spare Part Location Code" <> '') THEN
              LocationCode := UserProfile."Def. Spare Part Location Code";
            */
            //25.02.2010 EDMSB P2 <<

            Item.RESET;
            Item.SETRANGE("Date Filter", 0D, AvailabilityDate);
            Item.SETRANGE("Variant Filter", recServiceLine."Variant Code");
            Item.SETRANGE("Location Filter", LocationCode);
            Item.SETRANGE("Drop Shipment Filter", FALSE);

            EXIT(
              AvailableToPromise.QtyAvailabletoPromise(
                Item,
                GrossRequirement,
                ScheduledReceipt,
                AvailabilityDate,
                PeriodType,
                LookaheadDateformula));
        END;

    end;

    [Scope('Internal')]
    procedure CalcNoOfSubstitutions(var recServiceLine: Record "25006146"): Integer
    begin
        IF GetItem(recServiceLine) THEN BEGIN
            Item.CALCFIELDS("No. of Substitutes");
            EXIT(Item."No. of Substitutes");
        END;
    end;

    [Scope('Internal')]
    procedure CalcNoOfSalesPrices(var recServiceLine: Record "25006146"): Integer
    begin
        IF GetItem(recServiceLine) THEN BEGIN
            GetServiceHeader(recServiceLine);
            EXIT(SalesPriceCalcMgt.NoOfServLinePriceEDMS(ServiceHeader, recServiceLine, TRUE));
        END;
    end;

    [Scope('Internal')]
    procedure CalcNoOfSalesLineDisc(var recServiceLine: Record "25006146"): Integer
    begin
        IF GetItem(recServiceLine) THEN BEGIN
            GetServiceHeader(recServiceLine);
            EXIT(SalesPriceCalcMgt.NoOfServLineLineDiscEDMS(ServiceHeader, recServiceLine, TRUE));
        END;
    end;

    [Scope('Internal')]
    procedure DocExist(CurrentSalesHeader: Record "36"; CustNo: Code[20]): Boolean
    var
        SalesInvHeader: Record "112";
        SalesShptHeader: Record "110";
        SalesCrMemoHeader: Record "114";
        ReturnReceipt: Record "6660";
        SalesHeader: Record "36";
    begin
        IF CustNo = '' THEN
            EXIT(FALSE);
        SalesInvHeader.SETCURRENTKEY("Sell-to Customer No.");
        SalesInvHeader.SETRANGE("Sell-to Customer No.", CustNo);
        IF NOT SalesInvHeader.ISEMPTY THEN
            EXIT(TRUE);
        SalesShptHeader.SETCURRENTKEY("Sell-to Customer No.");
        SalesShptHeader.SETRANGE("Sell-to Customer No.", CustNo);
        IF NOT SalesShptHeader.ISEMPTY THEN
            EXIT(TRUE);
        SalesCrMemoHeader.SETCURRENTKEY("Sell-to Customer No.");
        SalesCrMemoHeader.SETRANGE("Sell-to Customer No.", CustNo);
        IF NOT SalesCrMemoHeader.ISEMPTY THEN
            EXIT(TRUE);
        SalesHeader.SETCURRENTKEY("Sell-to Customer No.");
        SalesHeader.SETRANGE("Sell-to Customer No.", CustNo);
        IF SalesHeader.FINDFIRST THEN BEGIN
            IF (SalesHeader."Document Type" <> CurrentSalesHeader."Document Type") OR
               (SalesHeader."No." <> CurrentSalesHeader."No.")
            THEN
                EXIT(TRUE);
            IF SalesHeader.FIND('>') THEN
                EXIT(TRUE);
        END;
        ReturnReceipt.SETCURRENTKEY("Sell-to Customer No.");
        ReturnReceipt.SETRANGE("Sell-to Customer No.", CustNo);
        IF NOT ReturnReceipt.ISEMPTY THEN
            EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure CustCommentExists(CustNo: Code[20]): Boolean
    begin
        GetCust(CustNo);
        Cust.CALCFIELDS(Comment);
        EXIT(Cust.Comment);
    end;

    [Scope('Internal')]
    procedure ItemCommentExists(recServiceLine: Record "25006146"): Boolean
    begin
        IF GetItem(recServiceLine) THEN BEGIN
            Item.CALCFIELDS(Comment);
            EXIT(Item.Comment);
        END;
    end;

    [Scope('Internal')]
    procedure LookupShipToAddr(var SalesHeader: Record "36")
    var
        ShipToAddr: Record "222";
    begin
        ShipToAddr.SETRANGE("Customer No.", SalesHeader."Sell-to Customer No.");
        IF PAGE.RUNMODAL(0, ShipToAddr) = ACTION::LookupOK THEN BEGIN
            SalesHeader.VALIDATE("Ship-to Code", ShipToAddr.Code);
            SalesHeader.MODIFY(TRUE);
            MESSAGE(Text000);
        END;
    end;

    [Scope('Internal')]
    procedure LookupContacts(var SalesHeader: Record "36")
    var
        Cont: Record "5050";
        ContBusRelation: Record "5054";
    begin
        IF (SalesHeader."Sell-to Customer No." <> '') AND (Cont.GET(SalesHeader."Sell-to Contact No.")) THEN
            Cont.SETRANGE("Company No.", Cont."Company No.")
        ELSE
            IF SalesHeader."Sell-to Customer No." <> '' THEN BEGIN
                ContBusRelation.RESET;
                ContBusRelation.SETCURRENTKEY("Link to Table", "No.");
                ContBusRelation.SETRANGE("Link to Table", ContBusRelation."Link to Table"::Customer);
                ContBusRelation.SETRANGE("No.", SalesHeader."Sell-to Customer No.");
                IF ContBusRelation.FINDFIRST THEN
                    Cont.SETRANGE("Company No.", ContBusRelation."Contact No.");
            END ELSE
                Cont.SETFILTER("Company No.", '<>''''');

        IF SalesHeader."Sell-to Contact No." <> '' THEN
            IF Cont.GET(SalesHeader."Sell-to Contact No.") THEN;
        IF PAGE.RUNMODAL(0, Cont) = ACTION::LookupOK THEN BEGIN
            SalesHeader.VALIDATE("Sell-to Contact No.", Cont."No.");
            SalesHeader.MODIFY(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure LookupServContacts(var ServiceHeader: Record "25006145")
    var
        Cont: Record "5050";
        ContBusRelation: Record "5054";
    begin
        IF (ServiceHeader."Sell-to Customer No." <> '') AND (Cont.GET("Sell-to Contact No.")) THEN
            Cont.SETRANGE("Company No.", Cont."Company No.")
        ELSE
            IF ServiceHeader."Sell-to Customer No." <> '' THEN BEGIN
                ContBusRelation.RESET;
                ContBusRelation.SETCURRENTKEY("Link to Table", "No.");
                ContBusRelation.SETRANGE("Link to Table", ContBusRelation."Link to Table"::Customer);
                ContBusRelation.SETRANGE("No.", ServiceHeader."Sell-to Customer No.");
                IF ContBusRelation.FINDFIRST THEN
                    Cont.SETRANGE("Company No.", ContBusRelation."Contact No.");
            END ELSE
                Cont.SETFILTER("Company No.", '<>''''');

        IF "Sell-to Contact No." <> '' THEN
            IF Cont.GET("Sell-to Contact No.") THEN;
        IF PAGE.RUNMODAL(0, Cont) = ACTION::LookupOK THEN BEGIN
            ServiceHeader.VALIDATE("Sell-to Contact No.", Cont."No.");
            ServiceHeader.MODIFY(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure LookupAvailCredit(CustNo: Code[20])
    begin
        GetCust(CustNo);
        PAGE.RUNMODAL(PAGE::"Available Credit", Cust);
    end;

    [Scope('Internal')]
    procedure LookupItem(recServiceLine: Record "25006146")
    begin
        recServiceLine.TESTFIELD(Type, recServiceLine.Type::Item);
        recServiceLine.TESTFIELD("No.");
        GetItem(recServiceLine);
        PAGE.RUNMODAL(PAGE::"Sales Invoice List SP", Item);
    end;

    [Scope('Internal')]
    procedure LookupItemComment(recServiceLine: Record "25006146")
    var
        CommentLine: Record "97";
    begin
        IF GetItem(recServiceLine) THEN BEGIN
            CommentLine.SETRANGE("Table Name", CommentLine."Table Name"::Item);
            CommentLine.SETRANGE("No.", recServiceLine."No.");
            PAGE.RUNMODAL(PAGE::"Comment Sheet", CommentLine);
        END;
    end;

    local procedure GetCust(CustNo: Code[20])
    begin
        IF CustNo <> '' THEN BEGIN
            IF CustNo <> Cust."No." THEN
                IF NOT Cust.GET(CustNo) THEN
                    CLEAR(Cust);
        END ELSE
            CLEAR(Cust);
    end;

    local procedure GetItem(var recServiceLine: Record "25006146"): Boolean
    begin
        IF (recServiceLine.Type <> recServiceLine.Type::Item) OR (recServiceLine."No." = '') THEN
            EXIT(FALSE);

        IF recServiceLine."No." <> Item."No." THEN
            Item.GET(recServiceLine."No.");
        EXIT(TRUE);
    end;

    local procedure GetServiceHeader(recServiceLine: Record "25006146")
    begin
        IF (recServiceLine."Document Type" <> ServiceHeader."Document Type") OR
           (recServiceLine."Document No." <> ServiceHeader."No.")
        THEN
            ServiceHeader.GET(recServiceLine."Document Type", recServiceLine."Document No.");
    end;

    [Scope('Internal')]
    procedure CalcNoOfBillToDocuments(var Cust: Record "18")
    begin
        Cust.CALCFIELDS(
          "Bill-To No. of Quotes", "Bill-To No. of Blanket Orders", "Bill-To No. of Orders", "Bill-To No. of Invoices",
          "Bill-To No. of Return Orders", "Bill-To No. of Credit Memos", "Bill-To No. of Pstd. Shipments",
          "Bill-To No. of Pstd. Invoices", "Bill-To No. of Pstd. Return R.", "Bill-To No. of Pstd. Cr. Memos");
    end;

    [Scope('Internal')]
    procedure GetServiceContractCount(ServiceHdr: Record "25006145"): Integer
    var
        ContractHdr: Record "25006016";
    begin
        ContractHdr.RESET;
        ContractHdr.SETCURRENTKEY("Bill-to Customer No.");
        ContractHdr.SETRANGE("Bill-to Customer No.", ServiceHdr."Bill-to Customer No.");
        ContractHdr.SETFILTER("Document Profile", '%1|%2', ContractHdr."Document Profile"::" ", ContractHdr."Document Profile"::Service);
        EXIT(ContractHdr.COUNT);
    end;

    [Scope('Internal')]
    procedure LookupOrdTransf(ServHeader: Record "25006145")
    var
        TransfHeader: Record "5740";
        TransfList: Page "5742";
    begin
        CLEAR(TransfList);
        TransfHeader.RESET;
        TransfHeader.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.", "Document Profile");
        TransfHeader.SETRANGE("Source Type", DATABASE::"Service Header EDMS");
        TransfHeader.SETRANGE("Source Subtype", 1);
        TransfHeader.SETRANGE("Source No.", ServHeader."No.");
        TransfHeader.SETRANGE("Document Profile", "Document Profile"::Service);

        IF TransfHeader.COUNT = 1 THEN BEGIN
            PAGE.RUNMODAL(PAGE::"Transfer Order", TransfHeader);


        END ELSE BEGIN
            PAGE.RUNMODAL(PAGE::"Transfer List", TransfHeader)
        END
    end;

    [Scope('Internal')]
    procedure LookupRetOrdTransf(ServHeader: Record "25006145")
    var
        TransfHeader: Record "5740";
        TransfList: Page "5742";
    begin
        CLEAR(TransfList);
        TransfHeader.RESET;
        TransfHeader.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.", "Document Profile");
        TransfHeader.SETRANGE("Source Type", DATABASE::"Service Header EDMS");
        TransfHeader.SETRANGE("Source Subtype", 2);
        TransfHeader.SETRANGE("Source No.", ServHeader."No.");
        TransfHeader.SETRANGE("Document Profile", "Document Profile"::Service);

        IF TransfHeader.COUNT = 1 THEN BEGIN
            PAGE.RUNMODAL(PAGE::"Transfer Order", TransfHeader);
        END ELSE BEGIN
            PAGE.RUNMODAL(PAGE::"Transfer List", TransfHeader)
        END
    end;

    [Scope('Internal')]
    procedure LookupTransferShipment(ServHeader: Record "25006145")
    var
        TransferShipment: Record "5744";
        TransferShipmentList: Page "5752";
    begin
        CLEAR(TransferShipmentList);
        TransferShipment.RESET;
        TransferShipment.SETCURRENTKEY("Document Profile", "Source Type", "Source Subtype", "Source No.");
        TransferShipment.SETRANGE("Document Profile", TransferShipment."Document Profile"::Service);
        TransferShipment.SETRANGE("Source Type", DATABASE::"Service Header EDMS");
        TransferShipment.SETRANGE("Source Subtype", 1);
        TransferShipment.SETRANGE("Source No.", ServHeader."No.");

        IF TransferShipment.COUNT = 1 THEN
            PAGE.RUNMODAL(PAGE::"Service Line FactBox EDMS", TransferShipment)
        ELSE BEGIN
            TransferShipmentList.SETTABLEVIEW(TransferShipment);
            TransferShipmentList.RUNMODAL
        END
    end;

    [Scope('Internal')]
    procedure LookupRetTransferShipment(ServHeader: Record "25006145")
    var
        TransferShipment: Record "5744";
        TransferShipmentList: Page "5752";
    begin
        CLEAR(TransferShipmentList);
        TransferShipment.RESET;
        TransferShipment.SETCURRENTKEY("Document Profile", "Source Type", "Source Subtype", "Source No.");
        TransferShipment.SETRANGE("Document Profile", TransferShipment."Document Profile"::Service);
        TransferShipment.SETRANGE("Source Type", DATABASE::"Service Header EDMS");
        TransferShipment.SETRANGE("Source Subtype", 2);
        TransferShipment.SETRANGE("Source No.", ServHeader."No.");

        IF TransferShipment.COUNT = 1 THEN
            PAGE.RUNMODAL(PAGE::"Service Line FactBox EDMS", TransferShipment)
        ELSE BEGIN
            TransferShipmentList.SETTABLEVIEW(TransferShipment);
            TransferShipmentList.RUNMODAL
        END
    end;

    [Scope('Internal')]
    procedure LookupTransferReceipt(ServHeader: Record "25006145")
    var
        TransferReceiptHeader: Record "5746";
        TransferReceiptList: Page "5753";
    begin
        CLEAR(TransferReceiptList);
        TransferReceiptHeader.RESET;
        TransferReceiptHeader.SETCURRENTKEY("Document Profile", "Source Type", "Source Subtype", "Source No.");
        TransferReceiptHeader.SETRANGE("Document Profile", TransferReceiptHeader."Document Profile"::Service);
        TransferReceiptHeader.SETRANGE("Source Type", DATABASE::"Service Header EDMS");
        TransferReceiptHeader.SETRANGE("Source Subtype", 1);
        TransferReceiptHeader.SETRANGE("Source No.", ServHeader."No.");

        TransferReceiptList.SETTABLEVIEW(TransferReceiptHeader);
        TransferReceiptList.RUNMODAL
    end;

    [Scope('Internal')]
    procedure LookupRetTransferReceipt(ServHeader: Record "25006145")
    var
        TransferReceiptHeader: Record "5746";
        TransferReceiptList: Page "5753";
    begin
        CLEAR(TransferReceiptList);
        TransferReceiptHeader.RESET;
        TransferReceiptHeader.SETCURRENTKEY("Document Profile", "Source Type", "Source Subtype", "Source No.");
        TransferReceiptHeader.SETRANGE("Document Profile", TransferReceiptHeader."Document Profile"::Service);
        TransferReceiptHeader.SETRANGE("Source Type", DATABASE::"Service Header EDMS");
        TransferReceiptHeader.SETRANGE("Source Subtype", 2);
        TransferReceiptHeader.SETRANGE("Source No.", ServHeader."No.");

        TransferReceiptList.SETTABLEVIEW(TransferReceiptHeader);
        TransferReceiptList.RUNMODAL
    end;

    [Scope('Internal')]
    procedure LookupServiceContracts(ServiceHdr: Record "25006145")
    var
        ContractHdr: Record "25006016";
    begin
        ContractHdr.RESET;
        ContractHdr.SETCURRENTKEY("Bill-to Customer No.");
        ContractHdr.FILTERGROUP(2);
        ContractHdr.SETRANGE("Bill-to Customer No.", ServiceHdr."Bill-to Customer No.");
        ContractHdr.SETFILTER("Document Profile", '%1|%2', ContractHdr."Document Profile"::" ",
            ContractHdr."Document Profile"::Service);
        ContractHdr.FILTERGROUP(0);
        IF ContractHdr.COUNT = 1 THEN
            PAGE.RUNMODAL(PAGE::Contract, ContractHdr)
        ELSE
            PAGE.RUNMODAL(PAGE::"Contract List EDMS", ContractHdr);
    end;

    [Scope('Internal')]
    procedure CalcLastVisitVFRun1(VehSerialNo: Code[20]): Integer
    var
        ServiceLedgerEntry: Record "25006167";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.", "Entry Type", "Posting Date");
        ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SETRANGE("Entry Type", ServiceLedgerEntry."Entry Type"::Usage);
        IF ServiceLedgerEntry.FINDLAST THEN
            EXIT(ServiceLedgerEntry.Kilometrage)
        ELSE
            EXIT(0);
    end;

    [Scope('Internal')]
    procedure CalcLastVisitVFRun2(VehSerialNo: Code[20]): Decimal
    var
        ServiceLedgerEntry: Record "25006167";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.", "Entry Type", "Posting Date");
        ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SETRANGE("Entry Type", ServiceLedgerEntry."Entry Type"::Usage);
        IF ServiceLedgerEntry.FINDLAST THEN
            EXIT(ServiceLedgerEntry."Variable Field Run 2")
        ELSE
            EXIT(0);
    end;

    [Scope('Internal')]
    procedure CalcLastVisitVFRun3(VehSerialNo: Code[20]): Decimal
    var
        ServiceLedgerEntry: Record "25006167";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.", "Entry Type", "Posting Date");
        ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SETRANGE("Entry Type", ServiceLedgerEntry."Entry Type"::Usage);
        IF ServiceLedgerEntry.FINDLAST THEN
            EXIT(ServiceLedgerEntry."Variable Field Run 3")
        ELSE
            EXIT(0);
    end;

    [Scope('Internal')]
    procedure CalcLastVFRun1(VehSerialNo: Code[20]): Decimal
    var
        ServiceLedgerEntry: Record "25006167";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.", "Posting Date", "Entry Type");
        ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SETFILTER("Entry Type", '%1|%2', ServiceLedgerEntry."Entry Type"::Usage, ServiceLedgerEntry."Entry Type"::Info);
        IF ServiceLedgerEntry.FINDLAST THEN
            EXIT(ServiceLedgerEntry.Kilometrage)
        ELSE
            EXIT(0);
    end;

    [Scope('Internal')]
    procedure CalcLastVFRun2(VehSerialNo: Code[20]): Decimal
    var
        ServiceLedgerEntry: Record "25006167";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.", "Posting Date", "Entry Type");
        ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SETFILTER("Entry Type", '%1|%2', ServiceLedgerEntry."Entry Type"::Usage, ServiceLedgerEntry."Entry Type"::Info);
        IF ServiceLedgerEntry.FINDLAST THEN
            EXIT(ServiceLedgerEntry."Variable Field Run 2")
        ELSE
            EXIT(0);
    end;

    [Scope('Internal')]
    procedure CalcLastVFRun3(VehSerialNo: Code[20]): Decimal
    var
        ServiceLedgerEntry: Record "25006167";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.", "Posting Date", "Entry Type");
        ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SETFILTER("Entry Type", '%1|%2', ServiceLedgerEntry."Entry Type"::Usage, ServiceLedgerEntry."Entry Type"::Info);
        IF ServiceLedgerEntry.FINDLAST THEN
            EXIT(ServiceLedgerEntry."Variable Field Run 3")
        ELSE
            EXIT(0);
    end;

    [Scope('Internal')]
    procedure CalcLastVisitDate(VehSerialNo: Code[20]): Date
    var
        ServiceLedgerEntry: Record "25006167";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.", "Entry Type", "Posting Date");
        ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SETRANGE("Entry Type", ServiceLedgerEntry."Entry Type"::Usage);
        IF ServiceLedgerEntry.FINDLAST THEN
            EXIT(ServiceLedgerEntry."Posting Date")
        ELSE
            EXIT(0D);
    end;

    [Scope('Internal')]
    procedure CalcVehSalesDate(VehSerialNo: Code[20]): Date
    var
        Vehicle: Record "25006005";
    begin
        Vehicle.RESET;
        IF Vehicle.GET(VehSerialNo) THEN
            EXIT(Vehicle."Sales Date");
    end;

    [Scope('Internal')]
    procedure LookupServiceHistory(VehSerialNo: Code[20])
    var
        Vehicle: Record "25006005";
        ServiceLedgerEntry: Record "25006167";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.");
        ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SETRANGE("Entry Type", ServiceLedgerEntry."Entry Type"::Usage);
        PAGE.RUNMODAL(PAGE::"Service Ledger Entries EDMS", ServiceLedgerEntry);
    end;

    [Scope('Internal')]
    procedure LookupServiceHistory2(VehSerialNo: Code[20])
    var
        Vehicle: Record "25006005";
        ServiceLedgerEntry: Record "25006167";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.");
        ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", VehSerialNo);
        PAGE.RUNMODAL(PAGE::"Service Ledger Entries EDMS", ServiceLedgerEntry);
    end;

    [Scope('Internal')]
    procedure GetTransfCount(ServHeader: Record "25006145"): Integer
    var
        TransfHeader: Record "5740";
    begin
        TransfHeader.RESET;
        TransfHeader.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.", "Document Profile");
        TransfHeader.SETRANGE("Source Type", DATABASE::"Service Header EDMS");
        TransfHeader.SETRANGE("Source Subtype", 1);
        TransfHeader.SETRANGE("Source No.", ServHeader."No.");
        TransfHeader.SETRANGE("Document Profile", "Document Profile"::Service);
        IF NOT TransfHeader.FINDFIRST THEN
            EXIT(0)
        ELSE
            EXIT(TransfHeader.COUNT)
    end;

    [Scope('Internal')]
    procedure LookupVehicle(SerialNo: Code[20])
    var
        Vehicle: Record "25006005";
    begin
        IF Vehicle.GET(SerialNo) THEN
            PAGE.RUNMODAL(PAGE::"Vehicle Card", Vehicle);
    end;

    [Scope('Internal')]
    procedure LookupLastServiceOrder(VehSerialNo: Code[20])
    var
        Vehicle: Record "25006005";
        ServiceLedgerEntry: Record "25006167";
    begin
        ServiceLedgerEntry.RESET;
        //ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.");  //14.05.2014 Elva Baltic P8 #S0038 MMG7.00
        ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SETRANGE("Entry Type", ServiceLedgerEntry."Entry Type"::Usage);
        IF ServiceLedgerEntry.FINDLAST THEN
            ServiceLedgerEntry.SETRANGE("Document No.", ServiceLedgerEntry."Document No.");
        PAGE.RUNMODAL(PAGE::"Service Ledger Entries EDMS", ServiceLedgerEntry);
    end;

    [Scope('Internal')]
    procedure LookupLastSLEntry(VehSerialNo: Code[20])
    var
        Vehicle: Record "25006005";
        ServiceLedgerEntry: Record "25006167";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.", "Posting Date", "Entry Type");
        ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", VehSerialNo);
        PAGE.RUNMODAL(PAGE::"Service Ledger Entries EDMS", ServiceLedgerEntry);
    end;

    [Scope('Internal')]
    procedure LookupVehWarranties(ServiceHdr: Record "25006145")
    var
        VehWarranty: Record "25006036";
    begin
        VehWarranty.RESET;
        VehWarranty.FILTERGROUP(2);
        VehWarranty.SETRANGE("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        VehWarranty.FILTERGROUP(0);
        IF VehWarranty.COUNT = 1 THEN
            PAGE.RUNMODAL(PAGE::"Vehicle Warranty Card", VehWarranty)
        ELSE
            PAGE.RUNMODAL(PAGE::"Vehicle Warranty List", VehWarranty);
    end;

    [Scope('Internal')]
    procedure GetVehWarrantyCount(ServiceHdr: Record "25006145"): Integer
    var
        VehWarranty: Record "25006036";
    begin
        VehWarranty.RESET;
        VehWarranty.SETRANGE("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        EXIT(VehWarranty.COUNT);
    end;

    [Scope('Internal')]
    procedure LookupServicePlans(ServiceHdr: Record "25006145")
    var
        VehServicePlanStage: Record "25006132";
        TempVehServicePlanStage: Record "25006132" temporary;
        ChooseServicePlanStages: Page "25006251";
    begin
        IF ServiceHdr."Vehicle Serial No." = '' THEN
            EXIT;

        //write two group records >>
        IF NOT ISSERVICETIER THEN BEGIN
            TempVehServicePlanStage.INIT;
            TempVehServicePlanStage.Code := Text001;
            TempVehServicePlanStage.Group := TRUE;
            TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::Pending;
            TempVehServicePlanStage.INSERT;

            TempVehServicePlanStage.INIT;
            TempVehServicePlanStage.Code := Text002;
            TempVehServicePlanStage.Group := TRUE;
            TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::Serviced;
            TempVehServicePlanStage.INSERT;

            TempVehServicePlanStage.INIT;
            TempVehServicePlanStage.Code := Text003;
            TempVehServicePlanStage.Group := TRUE;
            TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::"In Process";
            TempVehServicePlanStage.INSERT;

            TempVehServicePlanStage.INIT;
            TempVehServicePlanStage.Code := Text004;
            TempVehServicePlanStage.Group := TRUE;
            TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::Skipped;
            TempVehServicePlanStage.INSERT;
        END;
        //write two group records <<

        VehServicePlanStage.SETRANGE("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        IF VehServicePlanStage.FINDFIRST THEN
            REPEAT
                TempVehServicePlanStage := VehServicePlanStage;
                CASE TempVehServicePlanStage.Status OF
                    TempVehServicePlanStage.Status::"In Process":
                        TempVehServicePlanStage."Applies-to Code" := Text003;
                    TempVehServicePlanStage.Status::Pending:
                        TempVehServicePlanStage."Applies-to Code" := Text001;
                    TempVehServicePlanStage.Status::Skipped:
                        TempVehServicePlanStage."Applies-to Code" := Text004
                    ELSE
                        TempVehServicePlanStage."Applies-to Code" := Text002;
                END;
                TempVehServicePlanStage.INSERT;
            UNTIL VehServicePlanStage.NEXT = 0;

        IF PAGE.RUNMODAL(PAGE::"Choose Service Plan Stages", TempVehServicePlanStage) = ACTION::LookupOK THEN BEGIN
            TempVehServicePlanStage.RESET;
            TempVehServicePlanStage.SETRANGE("Maintain Stage", TRUE);
            IF TempVehServicePlanStage.FINDFIRST THEN
                // for now there should be only one record
                REPEAT
                    InsertServicePackByPlanStages(ServiceHdr, TempVehServicePlanStage);
                UNTIL TempVehServicePlanStage.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure GetServicePlanCount(ServiceHdr: Record "25006145"): Integer
    var
        ServicePlan: Record "25006126";
    begin
        ServicePlan.RESET;
        ServicePlan.SETRANGE("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");

        //09.02.2010 EDMSB P2 >>
        ServicePlan.SETRANGE(Active, TRUE);
        //09.02.2010 EDMSB P2 <<

        EXIT(ServicePlan.COUNT);
    end;

    [Scope('Internal')]
    procedure GetActiveRecallCount(ServiceHdr: Record "25006145"): Integer
    var
        RecallVehicle: Record "25006172";
    begin
        RecallVehicle.RESET;
        RecallVehicle.SETRANGE(VIN, ServiceHdr.VIN);
        RecallVehicle.SETRANGE(Serviced, FALSE);
        RecallVehicle.SETRANGE("Active Campaign", TRUE);
        EXIT(RecallVehicle.COUNT);
    end;

    [Scope('Internal')]
    procedure LookupActiveRecalls(var ServiceHdr: Record "25006145")
    var
        RecallVehicle: Record "25006172";
        ServicePackageVersionTmp: Record "25006135" temporary;
        ServiceHeader2: Record "25006145";
        RecallCampaignVehicles: Page "25006247";
    begin
        RecallVehicle.RESET;
        RecallVehicle.FILTERGROUP(2);
        RecallVehicle.SETRANGE(VIN, ServiceHdr.VIN);
        RecallVehicle.SETRANGE(Serviced, FALSE);
        RecallVehicle.SETRANGE("Active Campaign", TRUE);
        RecallVehicle.FILTERGROUP(0);

        RecallCampaignVehicles.SETTABLEVIEW(RecallVehicle);
        RecallCampaignVehicles.LOOKUPMODE := TRUE;
        RecallCampaignVehicles.RUNMODAL;
        //IF PAGE.RUNMODAL(PAGE::"Recall Campaign Vehicles", RecallVehicle) = ACTION::LookupOK THEN BEGIN
        RecallVehicle.RESET;
        RecallVehicle.SETRANGE(VIN, ServiceHdr.VIN);
        RecallVehicle.SETRANGE("Active Campaign", TRUE);
        RecallVehicle.SETRANGE(Serviced, FALSE, TRUE);
        RecallVehicle.SETRANGE("Campaign No.", RecallCampaignVehicles.GetSelectedRecallNo);
        IF RecallVehicle.FINDFIRST THEN BEGIN
            IF ServiceHdr."Sell-to Customer No." = '' THEN BEGIN
                RecallVehicle.Serviced := FALSE;
                RecallVehicle.MODIFY(TRUE);
                COMMIT;
                ServiceHdr.TESTFIELD("Sell-to Customer No.");
            END ELSE
                IF RecallVehicle.Serviced THEN BEGIN
                    ServiceHdr.InsertServPackageByRecallNo(RecallCampaignVehicles.GetSelectedRecallNo);
                END;
        END;
    end;

    [Scope('Internal')]
    procedure InsertServicePackByPlanStages(var ServiceHdr: Record "25006145"; VehicleServicePlanStage: Record "25006132")
    var
        PackageNoFilter: Text[1024];
        SPVersion: Record "25006135";
    begin
        ServiceHdr.InsertServPlanDocLink(VehicleServicePlanStage);
        COMMIT;
        SPVersion.SETRANGE("Package No.", VehicleServicePlanStage."Package No.");
        ServiceHdr.SetCurrPlanStage(VehicleServicePlanStage);
        ServiceHdr.InsertLookupSPVersion(SPVersion);
    end;

    [Scope('Internal')]
    procedure InsertLookupSPVersions(var SPVersion: Record "25006135"; ServiceHeader: Record "25006145")
    var
        SPVersionSpec: Record "25006136";
        ServLine: Record "25006146";
        ServicePackage: Record "25006134";
        LastLineNo: Integer;
        Text001: Label 'No records to list.';
        SPVersionResult: Record "25006135";
        SPVersionForm: Page "25006164";
    begin
        // main source is taken from T2500645.InsertLookupSPVersion
        // but the difference is that is able to work with multiselect
        SPVersionForm.SETTABLEVIEW(SPVersion);
        SPVersionForm.LOOKUPMODE := TRUE;
        IF SPVersionForm.RUNMODAL = ACTION::LookupOK THEN BEGIN

            IF SPVersionForm.GetSelectedRecordSet(SPVersionResult) THEN BEGIN
                // means is multiselect
                IF SPVersionResult.FINDFIRST THEN
                    REPEAT
                        InsertSPVesionToSHeader(SPVersionResult, ServiceHeader);
                    UNTIL SPVersionResult.NEXT = 0;
            END ELSE BEGIN
                // only current record to be inerted
                IF SPVersionResult."Package No." <> '' THEN
                    InsertSPVesionToSHeader(SPVersionResult, ServiceHeader);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure InsertSPVesionToSHeader(SPVersion: Record "25006135"; ServiceHeader: Record "25006145")
    var
        SPVersionSpec: Record "25006136";
        ServLine: Record "25006146";
        ServicePackage: Record "25006134";
        LastLineNo: Integer;
        Text001: Label 'No records to list.';
        SPVersionForm: Page "25006164";
        SPVersionResult: Record "25006135";
        Text124: Label 'Service package %1 is blocked.';
    begin
        IF ServicePackage.GET(SPVersion."Package No.") THEN BEGIN
            IF ServicePackage.Blocked THEN
                ERROR(STRSUBSTNO(Text124, SPVersionResult."Package No."));

            SPVersionSpec.RESET;
            SPVersionSpec.SETRANGE("Package No.", SPVersionResult."Package No.");
            SPVersionSpec.SETRANGE("Version No.", SPVersionResult."Version No.");
            IF SPVersionSpec.FINDSET THEN
                REPEAT
                    SPVersionSpec.CreateServLine(ServiceHeader."Document Type", ServiceHeader."No.");
                UNTIL SPVersionSpec.NEXT = 0
        END;
    end;

    [Scope('Internal')]
    procedure GetComponentServicePlansCount(ServiceHdr: Record "25006145") RetValue: Integer
    var
        VehicleComponent: Record "25006010";
        VehicleServicePlan: Record "25006126";
    begin
        VehicleComponent.RESET;
        VehicleComponent.SETRANGE("Parent Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        VehicleComponent.SETRANGE(Active, TRUE);
        IF VehicleComponent.FINDFIRST THEN BEGIN
            REPEAT
                VehicleServicePlan.RESET;
                VehicleServicePlan.SETRANGE("Vehicle Serial No.", VehicleComponent."No.");
                VehicleServicePlan.SETRANGE(Active, TRUE);
                RetValue += VehicleServicePlan.COUNT;
            UNTIL VehicleComponent.NEXT = 0;
        END;

        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure LookupVehicleComponentsPlans(ServiceHdr: Record "25006145")
    var
        VehicleComponent: Record "25006010";
        VehServicePlanStage: Record "25006132";
        TempVehServicePlanStage: Record "25006132" temporary;
        ChooseServicePlanStages: Page "25006251";
        ServicePlanMgt: Codeunit "25006103";
        ServiceHeaderTmp: Record "25006145" temporary;
        VehicleServicePlanStage: Record "25006132";
        ServicePackage: Record "25006134";
        ServicePackageVersion: Record "25006135";
        Customer: Record "18";
        TextLoc001: Label 'New %2 created: %1';
        NewCreatedIDs: Text[250];
        ServiceHdrLocal: Record "25006145";
    begin
        IF ServiceHdr."Vehicle Serial No." = '' THEN
            EXIT;

        //write two group records >>
        IF NOT ISSERVICETIER THEN BEGIN
            TempVehServicePlanStage.INIT;
            TempVehServicePlanStage.Code := Text001;
            TempVehServicePlanStage.Group := TRUE;
            TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::Pending;
            TempVehServicePlanStage.INSERT;

            TempVehServicePlanStage.INIT;
            TempVehServicePlanStage.Code := Text002;
            TempVehServicePlanStage.Group := TRUE;
            TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::Serviced;
            TempVehServicePlanStage.INSERT;

            TempVehServicePlanStage.INIT;
            TempVehServicePlanStage.Code := Text003;
            TempVehServicePlanStage.Group := TRUE;
            TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::"In Process";
            TempVehServicePlanStage.INSERT;

            TempVehServicePlanStage.INIT;
            TempVehServicePlanStage.Code := Text004;
            TempVehServicePlanStage.Group := TRUE;
            TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::Skipped;
            TempVehServicePlanStage.INSERT;
        END;
        TempVehServicePlanStage.INIT;
        TempVehServicePlanStage.Code := 'COMPONENTS';
        TempVehServicePlanStage.Group := TRUE;
        TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::Pending;
        TempVehServicePlanStage.INSERT;

        VehicleComponent.RESET;
        VehicleComponent.SETRANGE("Parent Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        VehicleComponent.SETRANGE(Active, TRUE);
        IF VehicleComponent.FINDFIRST THEN
            REPEAT
                VehServicePlanStage.SETRANGE("Vehicle Serial No.", VehicleComponent."No.");
                IF VehServicePlanStage.FINDFIRST THEN
                    REPEAT
                        TempVehServicePlanStage := VehServicePlanStage;
                        CASE TempVehServicePlanStage.Status OF
                            TempVehServicePlanStage.Status::"In Process":
                                TempVehServicePlanStage."Applies-to Code" := Text003;
                            TempVehServicePlanStage.Status::Skipped:
                                TempVehServicePlanStage."Applies-to Code" := Text004;
                            TempVehServicePlanStage.Status::Pending:
                                TempVehServicePlanStage."Applies-to Code" := Text001
                            ELSE
                                TempVehServicePlanStage."Applies-to Code" := Text002;
                        END;
                        TempVehServicePlanStage.INSERT;
                    UNTIL VehServicePlanStage.NEXT = 0;
            UNTIL VehicleComponent.NEXT = 0;

        IF PAGE.RUNMODAL(PAGE::"Choose Service Plan Stages", TempVehServicePlanStage) = ACTION::LookupOK THEN BEGIN
            //IF ChooseServicePlanStages.RUNMODAL = ACTION::LookupOK THEN BEGIN
            TempVehServicePlanStage.RESET;
            TempVehServicePlanStage.SETRANGE("Maintain Stage", TRUE);
            IF TempVehServicePlanStage.FINDFIRST THEN
                // for now there should be only one record
                REPEAT
                    VehicleServicePlanStage.GET(TempVehServicePlanStage."Vehicle Serial No.", TempVehServicePlanStage."Plan No.",
                      TempVehServicePlanStage.Recurrence, TempVehServicePlanStage.Code);
                    ServicePackage.GET(VehicleServicePlanStage."Package No.");
                    ServicePackageVersion.SETRANGE("Package No.", ServicePackage."No.");
                    IF ServicePackageVersion.FINDFIRST THEN BEGIN
                        IF Customer.GET(ServiceHdr."Sell-to Customer No.") THEN BEGIN
                            CLEAR(ServicePlanMgt);
                            ServiceHdrLocal.RESET;
                            ServiceHeaderTmp.RESET;
                            ServiceHeaderTmp.SETRANGE("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                            IF ServiceHeaderTmp.FINDFIRST THEN BEGIN
                                ServiceHdrLocal.GET(ServiceHeaderTmp."Document Type", ServiceHeaderTmp."No.");
                            END ELSE BEGIN
                                ServiceHdrLocal.CreateServHeader(ServiceHdrLocal."Document Type"::Order, ServiceHdr."Order Date",
                                  ServiceHdr."Planned Service Date", ServiceHdr.Description, ServiceHdr."Sell-to Customer No.",
                                  ServiceHdr."Bill-to Customer No.", VehicleServicePlanStage."Vehicle Serial No.");

                            END;
                            InsertServicePackByPlanStages(ServiceHdrLocal, TempVehServicePlanStage);
                            ServiceHeaderTmp.TRANSFERFIELDS(ServiceHdrLocal);
                            ServiceHeaderTmp.INSERT;
                        END;
                    END;
                UNTIL TempVehServicePlanStage.NEXT = 0;
            IF ServiceHeaderTmp.FINDFIRST THEN BEGIN
                CLEAR(NewCreatedIDs);
                REPEAT
                    NewCreatedIDs += ServiceHeaderTmp."No." + ', ';
                UNTIL ServiceHeaderTmp.NEXT = 0;
                NewCreatedIDs := COPYSTR(NewCreatedIDs, 1, STRLEN(NewCreatedIDs) - 2);
                MESSAGE(TextLoc001, NewCreatedIDs, ServiceHdr.TABLECAPTION);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure GetInsuranceCount(ServiceHdr: Record "25006145") RetValue: Integer
    var
        VehicleInsurance: Record "25006033";
    begin
        VehicleInsurance.RESET;
        VehicleInsurance.SETRANGE("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        RetValue := VehicleInsurance.COUNT;

        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure LookupVehicleInsurancesPlans(ServiceHdr: Record "25006145")
    var
        VehicleInsurance: Record "25006033";
    begin
        IF ServiceHdr."Vehicle Serial No." = '' THEN
            EXIT;

        VehicleInsurance.RESET;
        VehicleInsurance.FILTERGROUP(2);
        VehicleInsurance.SETRANGE("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        VehicleInsurance.FILTERGROUP(0);
        PAGE.RUNMODAL(0, VehicleInsurance);
    end;

    [Scope('Internal')]
    procedure GetVehicleContractsCount(Vehicle: Record "25006005"): Integer
    var
        ContractHdr: Record "25006016";
    begin
        //31.01.2014 Elva Baltic P8 #F038 MMG7.00 >>
        //HOTFIX P1 !! >>
        EXIT(0);
        //HOTFIX P1 !! <<
        PrepareVehicleContractsFilteredTable(Vehicle, ContractHdr);
        EXIT(ContractHdr.COUNT);
    end;

    [Scope('Internal')]
    procedure LookupVehicleContracts(Vehicle: Record "25006005")
    var
        ContractHdr: Record "25006016";
    begin
        PrepareVehicleContractsFilteredTable(Vehicle, ContractHdr);
        IF ContractHdr.COUNT = 1 THEN
            PAGE.RUNMODAL(PAGE::Contract, ContractHdr)
        ELSE
            PAGE.RUNMODAL(PAGE::"Contract List EDMS", ContractHdr);
    end;

    [Scope('Internal')]
    procedure PrepareVehicleContractsFilteredTable(Vehicle: Record "25006005"; var ContractHdr: Record "25006016")
    var
        ContractSalesLineDiscount: Record "25006017";
        ContractSalesPrice: Record "25006031";
        FilterStr: Text[250];
    begin
        ContractHdr.FILTERGROUP(2);
        FilterStr := '';
        ContractSalesLineDiscount.RESET;
        ContractSalesLineDiscount.SETRANGE("Vehicle Serial No.", Vehicle."Serial No.");
        IF ContractSalesLineDiscount.FINDFIRST THEN
            REPEAT
                IF STRPOS(FilterStr, ContractSalesLineDiscount."Contract No.") = 0 THEN BEGIN
                    IF FilterStr = '' THEN
                        FilterStr := ContractSalesLineDiscount."Contract No."
                    ELSE
                        FilterStr += '|' + ContractSalesLineDiscount."Contract No.";
                    ContractHdr.SETFILTER("Contract No.", FilterStr);
                END;
            UNTIL ContractSalesLineDiscount.NEXT = 0;
        ContractSalesPrice.RESET;
        ContractSalesPrice.SETRANGE("Vehicle Serial No.", Vehicle."Serial No.");
        IF ContractSalesPrice.FINDFIRST THEN
            REPEAT
                IF STRPOS(FilterStr, "Contract No.") = 0 THEN BEGIN
                    IF FilterStr = '' THEN
                        FilterStr := "Contract No."
                    ELSE
                        FilterStr += '|' + "Contract No.";
                    ContractHdr.SETFILTER("Contract No.", FilterStr);
                END;
            UNTIL ContractSalesPrice.NEXT = 0;
        ContractHdr.FILTERGROUP(0);
    end;

    [Scope('Internal')]
    procedure LookupVehicleWarranties(Vehicle: Record "25006005")
    var
        VehWarranty: Record "25006036";
    begin
        VehWarranty.RESET;
        VehWarranty.FILTERGROUP(2);
        VehWarranty.SETRANGE("Vehicle Serial No.", Vehicle."Serial No.");
        VehWarranty.FILTERGROUP(0);
        IF VehWarranty.COUNT = 1 THEN
            PAGE.RUNMODAL(PAGE::"Vehicle Warranty Card", VehWarranty)
        ELSE
            PAGE.RUNMODAL(PAGE::"Vehicle Warranty List", VehWarranty);
    end;

    [Scope('Internal')]
    procedure GetVehicleWarrantyCount(Vehicle: Record "25006005"): Integer
    var
        VehWarranty: Record "25006036";
    begin
        VehWarranty.RESET;
        VehWarranty.SETRANGE("Vehicle Serial No.", Vehicle."Serial No.");
        EXIT(VehWarranty.COUNT);
    end;

    [Scope('Internal')]
    procedure GetVehicleDocCount(ServiceHdr: Record "25006145"; DocType: Option Quote,"Order","Return Order"): Integer
    var
        ServiceHeader: Record "25006145";
    begin
        IF ServiceHdr."Vehicle Serial No." = '' THEN
            EXIT(0);

        ServiceHeader.RESET;
        ServiceHeader.SETRANGE("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        ServiceHeader.SETRANGE("Document Type", DocType);
        EXIT(ServiceHeader.COUNT);
    end;

    [Scope('Internal')]
    procedure LookupVehicleDoc(ServiceHdr: Record "25006145"; DocType: Option Quote,"Order","Return Order")
    begin
        IF ServiceHdr."Vehicle Serial No." = '' THEN
            EXIT;

        ServiceHeader.RESET;
        ServiceHeader.SETRANGE("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        ServiceHeader.SETRANGE("Document Type", DocType);
        IF ServiceHeader.COUNT = 1 THEN BEGIN
            CASE DocType OF
                DocType::Quote:
                    PAGE.RUNMODAL(PAGE::"Service Quote EDMS", ServiceHeader);
                DocType::Order:
                    PAGE.RUNMODAL(PAGE::"Service Order EDMS", ServiceHeader);
            END
        END ELSE BEGIN
            CASE DocType OF
                DocType::Quote:
                    PAGE.RUNMODAL(PAGE::"Service Quotes EDMS", ServiceHeader);
                DocType::Order:
                    PAGE.RUNMODAL(PAGE::"Service Orders EDMS", ServiceHeader);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure VehicleGetInsuranceCount(Vehicle: Record "25006005") RetValue: Integer
    var
        VehicleInsurance: Record "25006033";
    begin
        VehicleInsurance.RESET;
        VehicleInsurance.SETRANGE("Vehicle Serial No.", Vehicle."Serial No.");
        RetValue := VehicleInsurance.COUNT;

        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure VehicleLookupVehicleInsurancesPlans(Vehicle: Record "25006005")
    var
        VehicleInsurance: Record "25006033";
    begin
        VehicleInsurance.RESET;
        VehicleInsurance.FILTERGROUP(2);
        VehicleInsurance.SETRANGE("Vehicle Serial No.", Vehicle."Serial No.");
        VehicleInsurance.FILTERGROUP(0);
        PAGE.RUNMODAL(0, VehicleInsurance);
    end;

    [Scope('Internal')]
    procedure VehicleGetActiveRecallCount(Vehicle: Record "25006005"): Integer
    var
        RecallVehicle: Record "25006172";
    begin
        RecallVehicle.RESET;
        RecallVehicle.SETRANGE(VIN, Vehicle.VIN);
        RecallVehicle.SETRANGE(Serviced, FALSE);
        RecallVehicle.SETRANGE("Active Campaign", TRUE);
        EXIT(RecallVehicle.COUNT);
    end;

    [Scope('Internal')]
    procedure VehicleLookupActiveRecalls(var Vehicle: Record "25006005")
    var
        RecallVehicle: Record "25006172";
        ServicePackageVersionTmp: Record "25006135" temporary;
        ServiceHeader2: Record "25006145";
        RecallCampaignVehicles: Page "25006247";
    begin
        RecallVehicle.RESET;
        RecallVehicle.FILTERGROUP(2);
        RecallVehicle.SETRANGE(VIN, Vehicle.VIN);
        RecallVehicle.SETRANGE(Serviced, FALSE);
        RecallVehicle.SETRANGE("Active Campaign", TRUE);
        RecallVehicle.FILTERGROUP(0);

        RecallCampaignVehicles.SETTABLEVIEW(RecallVehicle);
        RecallCampaignVehicles.LOOKUPMODE := TRUE;
        RecallCampaignVehicles.RUNMODAL;
        //IF PAGE.RUNMODAL(PAGE::"Recall Campaign Vehicles", RecallVehicle) = ACTION::LookupOK THEN BEGIN
    end;

    [Scope('Internal')]
    procedure PrepareVehicleInfoContractsFilteredTable(Vehicle: Record "25006005"; var ContractHdr: Record "25006016")
    var
        FilterStr: Text[250];
        VehicleContract: Record "25006059";
    begin
        ContractHdr.FILTERGROUP(2);
        FilterStr := '';
        VehicleContract.RESET;
        VehicleContract.SETRANGE("Vehicle Serial No.", Vehicle."Serial No.");
        IF VehicleContract.FINDFIRST THEN
            REPEAT
                IF STRPOS(FilterStr, VehicleContract."Contract No.") = 0 THEN BEGIN
                    IF FilterStr = '' THEN
                        FilterStr := VehicleContract."Contract No."
                    ELSE
                        FilterStr += '|' + VehicleContract."Contract No.";
                    ContractHdr.SETFILTER("Contract No.", FilterStr);
                END;
            UNTIL VehicleContract.NEXT = 0;

        IF FilterStr = '' THEN
            ContractHdr.SETFILTER("Contract No.", '%1', '');

        ContractHdr.FILTERGROUP(0);
    end;

    [Scope('Internal')]
    procedure LookupVehicleInfoContracts(Vehicle: Record "25006005")
    var
        ContractHdr: Record "25006016";
    begin
        PrepareVehicleInfoContractsFilteredTable(Vehicle, ContractHdr);
        IF ContractHdr.COUNT = 1 THEN
            PAGE.RUNMODAL(PAGE::Contract, ContractHdr)
        ELSE
            PAGE.RUNMODAL(PAGE::"Contract List EDMS", ContractHdr);
    end;

    [Scope('Internal')]
    procedure GetVehicleInfoContractsCount(Vehicle: Record "25006005"): Integer
    var
        ContractHdr: Record "25006016";
    begin
        PrepareVehicleInfoContractsFilteredTable(Vehicle, ContractHdr);
        EXIT(ContractHdr.COUNT);
    end;

    [Scope('Internal')]
    procedure CalcAvailabilityForRequisition(var recReqLine: Record "246"): Decimal
    var
        UserProfile: Record "25006067";
        AvailableToPromise: Codeunit "5790";
        SingleInstanceMgt: Codeunit "25006001";
        LocationCode: Code[20];
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        PeriodType: Option Day,Week,Month,Quarter,Year;
        AvailabilityDate: Date;
        LookaheadDateformula: DateFormula;
    begin
        Item.RESET;
        Item.SETRANGE("No.", recReqLine."No.");
        Item.SETRANGE("Location Filter", recReqLine."Location Code");
        IF Item.FINDFIRST THEN BEGIN
            Item.CALCFIELDS(Inventory);
            EXIT(Item.Inventory);
        END
        ELSE
            EXIT(0);
    end;

    [Scope('Internal')]
    procedure StoreRequisition(DocNo: Code[20]; WhatToReturn: Option ReceivedItems,ShippedItems; ConcernedItem: Code[20]): Decimal
    var
        TransRcptHeader: Record "5746";
        TransRcptLine: Record "5747";
        TransShipHeader: Record "5744";
        TransShipLine: Record "5745";
        ServiceLine: Record "25006146";
        ServiceHeader: Record "25006145";
        RecQty: Decimal;
        ShipQty: Decimal;
    begin
        //Sipradi-YS BEGIN *
        RecQty := 0;
        ShipQty := 0;
        ServiceHeader.RESET;
        ServiceHeader.SETRANGE("Document Type", ServiceHeader."Document Type"::Order);
        ServiceHeader.SETRANGE("No.", DocNo);
        IF ServiceHeader.FINDFIRST THEN;
        IF WhatToReturn = WhatToReturn::ReceivedItems THEN BEGIN
            TransRcptHeader.RESET;
            TransRcptHeader.SETCURRENTKEY("Document Profile", "Source Type", "Source Subtype", "Source No.");
            TransRcptHeader.SETRANGE("Document Profile", TransRcptHeader."Document Profile"::Service);
            TransRcptHeader.SETRANGE("Source Type", 25006145);
            TransRcptHeader.SETRANGE("Source Subtype", 1);
            TransRcptHeader.SETRANGE("Source No.", DocNo);
            TransRcptHeader.SETRANGE("Transfer-to Code", ServiceHeader."Location Code");
            IF TransRcptHeader.FINDSET THEN BEGIN
                REPEAT
                    TransRcptLine.RESET;
                    TransRcptLine.SETCURRENTKEY("Transfer Order No.", "Item No.");
                    TransRcptLine.SETRANGE("Document No.", TransRcptHeader."No.");
                    TransRcptLine.SETRANGE("Item No.", ConcernedItem);
                    IF TransRcptLine.FINDSET THEN
                        REPEAT
                            RecQty += TransRcptLine.Quantity;
                        UNTIL TransRcptLine.NEXT = 0;
                UNTIL TransRcptHeader.NEXT = 0;
                EXIT(RecQty);
            END;
        END;
        IF WhatToReturn = WhatToReturn::ShippedItems THEN BEGIN
            TransShipHeader.RESET;
            TransShipHeader.SETCURRENTKEY("Document Profile", "Source Type", "Source Subtype", "Source No.");
            TransShipHeader.SETRANGE("Document Profile", TransShipHeader."Document Profile"::Service);
            TransShipHeader.SETRANGE("Source Type", 25006145);
            TransShipHeader.SETRANGE("Source Subtype", 1);
            TransShipHeader.SETRANGE("Source No.", DocNo);
            TransShipHeader.SETRANGE("Transfer-to Code", ServiceHeader."Location Code");
            IF TransShipHeader.FINDSET THEN BEGIN
                REPEAT
                    TransShipLine.RESET;
                    TransShipLine.SETCURRENTKEY("Transfer Order No.", "Item No.");
                    TransShipLine.SETRANGE("Document No.", TransShipHeader."No.");
                    TransShipLine.SETRANGE("Item No.", ConcernedItem);
                    IF TransShipLine.FINDSET THEN
                        REPEAT
                            ShipQty += TransShipLine.Quantity;
                        UNTIL TransShipLine.NEXT = 0;
                UNTIL TransShipHeader.NEXT = 0;
                EXIT(ShipQty);
            END;
        END;
        EXIT(0);
    end;

    [Scope('Internal')]
    procedure GetNoofReceivedItems(ServiceLineEDMS: Record "25006146"): Decimal
    var
        WhatToReturn: Option ReceivedItems,ShippedItems;
    begin
        EXIT(StoreRequisition(ServiceLineEDMS."Document No.", WhatToReturn::ReceivedItems, ServiceLineEDMS."No."));
    end;

    [Scope('Internal')]
    procedure GetNoofShippedItems(ServiceLineEDMS: Record "25006146"): Decimal
    var
        WhatToReturn: Option ReceivedItems,ShippedItems;
    begin
        EXIT(StoreRequisition(ServiceLineEDMS."Document No.", WhatToReturn::ShippedItems, ServiceLineEDMS."No."));
    end;

    [Scope('Internal')]
    procedure CalcLastVisitHour(VehSerialNo: Code[20]): Decimal
    var
        ServiceLedgerEntry: Record "25006167";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.", "Entry Type", "Posting Date");
        ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SETRANGE("Entry Type", ServiceLedgerEntry."Entry Type"::Usage);
        IF ServiceLedgerEntry.FINDLAST THEN
            EXIT(ServiceLedgerEntry."Hour Reading")
        ELSE
            EXIT(0);
    end;

    [Scope('Internal')]
    procedure GetSanjivaniInfo(VIN: Code[20]): Text[30]
    var
        SchemeRegVeh: Record "33020240";
        Status: Text[30];
    begin
        Status := 'NA';
        SchemeRegVeh.RESET;
        SchemeRegVeh.SETRANGE("VIN Code", VIN);
        SchemeRegVeh.SETRANGE("Scheme Type", SchemeRegVeh."Scheme Type"::SANJIVANI);
        IF SchemeRegVeh.FINDLAST THEN BEGIN
            IF SchemeRegVeh."Valid Until" >= TODAY THEN
                Status := 'Active'
            ELSE
                Status := 'Expired';
        END;
        EXIT(Status);
    end;

    [Scope('Internal')]
    procedure LookupPurchOrder(ServHeader: Record "25006145")
    var
        TransfHeader: Record "5740";
        TransfList: Page "5742";
    begin
        CLEAR(TransfList);
        TransfHeader.RESET;
        TransfHeader.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.", "Document Profile");
        TransfHeader.SETRANGE("Source Type", DATABASE::"Service Header EDMS");
        TransfHeader.SETRANGE("Source Subtype", 1);
        TransfHeader.SETRANGE("Source No.", ServHeader."No.");
        TransfHeader.SETRANGE("Document Profile", "Document Profile"::Service);

        IF TransfHeader.COUNT = 1 THEN
            IF ISSERVICETIER THEN
                PAGE.RUNMODAL(PAGE::"Transfer Order", TransfHeader)
            ELSE BEGIN
                IF ISSERVICETIER THEN
                    PAGE.RUNMODAL(PAGE::"Transfer List", TransfHeader)
                ELSE BEGIN
                    TransfList.SETTABLEVIEW(TransfHeader);
                    TransfList.RUNMODAL
                END
            END
    end;

    [Scope('Internal')]
    procedure LookupLastSanjivaniReg(VIN: Code[20]): Text[30]
    var
        SchemeRegVeh: Record "33020240";
        Status: Text[30];
    begin
        SchemeRegVeh.RESET;
        SchemeRegVeh.FILTERGROUP(2);
        SchemeRegVeh.SETRANGE("VIN Code", VIN);
        SchemeRegVeh.SETRANGE("Scheme Type", SchemeRegVeh."Scheme Type"::SANJIVANI);
        SchemeRegVeh.FILTERGROUP(0);
        //IF SchemeRegVeh.FINDLAST THEN
        PAGE.RUNMODAL(PAGE::"Scheme Registered Vehicle List", SchemeRegVeh);
    end;

    [Scope('Internal')]
    procedure GetWarrantyInfo(ServiceHdr: Record "25006145"): Text[10]
    var
        VehWarranty: Record "25006036";
    begin
        VehWarranty.RESET;
        VehWarranty.SETRANGE("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        VehWarranty.SETRANGE(Status, VehWarranty.Status::Active);
        IF VehWarranty.FINDFIRST THEN
            EXIT('ACTIVE')
        ELSE
            EXIT('NA');
    end;

    [Scope('Internal')]
    procedure CalcNextServiceDate(VehSerialNo: Code[20]): Date
    var
        ServiceLedgerEntry: Record "25006167";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.", "Entry Type", "Next Service Date");
        ServiceLedgerEntry.SETRANGE("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SETRANGE("Entry Type", ServiceLedgerEntry."Entry Type"::Usage);
        IF ServiceLedgerEntry.FINDLAST THEN
            EXIT(ServiceLedgerEntry."Next Service Date")
        ELSE
            EXIT(0D);
    end;
}


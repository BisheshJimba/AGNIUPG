codeunit 25006101 "Service-Post EDMS"
{
    // 20.12.2016 EB.RC DMS bug corrected
    //   Modified function:
    //     FillDetServJnlByResource
    // 
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified CreateInvoices(), removed UserProfile variable
    // 
    // 30.07.2015 EB.P30 #T045
    //   Modified procedure
    //     CreatePostedServiceLines
    // 
    // 30.07.2015 EB.P30 #T043
    //   Modified procedure
    //     PostServiceOrder
    //     ArchiveUnpostedOrder
    // 
    // 27.07.2015 EB.P30 #WIP
    //   Modified procedure:
    //     PostServiceOrder
    // 
    // 07.07.2015 EB.P7 #Schedule 3.0
    //   Modified procedure:
    //     FillDetServJnlByResource
    // 
    // 28.05.2015 EB.P30 #T030
    //   Modified procedure:
    //     FillDetServJnlByResource
    // 
    // 12.05.2015 EB.P30 #T030
    //   Modified procedures:
    //     FillDetServJnlByResource
    //     CreatePostedServiceLines
    // 
    // 12.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified procedure:
    //     CreatePostedServiceLines
    // 
    // 10.05.2014 Elva Baltic P8 #S0082 MMG7.00
    //   * At prepaiment create in order must be filled vehicle
    // 
    // 08.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified procedure:
    //     CreateInvoices
    // 
    // 22.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified procedures:
    //     CreateInvoices
    //     CreateSalesLine
    // 
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified procedure:
    //     CreateInvoices
    // 
    // 02.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *Modified function CreateSalesHeader
    // 
    // 31.03.2014 Elva Baltic P18
    //   Modified
    //     GetNewInvoiceNo
    // 
    // 31.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     CreateSalesHeader
    //     CreateSalesLine
    // 
    // 26.03.2014 Elva Baltic P18 MMG7.00
    //   Added Code to
    //     CopyServCommLinesToPosted()
    //     CreatePostedServiceHeader(VAR ServiceOrder : Record "Service Header EDMS")
    // 
    // 14.02.2014 Elva Baltic P7 #F145 MMG7.00
    //   * Reset Due Date
    // 
    // 25.10.2013 EDMS P8
    //   * Added function CheckDim
    // 
    // 13.06.2013 EDMS P8
    //   * Merged code with NAV2009
    // 
    // 10.04.2013 EDMS P8
    //   * fix in dimension set for header
    // 
    // 27.02.2013 EDMS P8
    //   * Implement new dimension set
    // 
    // 23.01.2013 EDMS P8
    //   * Implement use of Resources
    // 
    // 2012.09.15 EDMS P8
    //   * Add support for fields: "Minutes Per UoM", "Quantity (Hours)"
    // 
    // 2012.07.31 EDMS P8
    //   * fill of new fields: 'Variable Field Run 2', 'Variable Field Run 3', 'Document Line No.'
    // 
    // 2012.04.17 EDMS P8
    //   * Implemet use of "Det. Serv. Journal Line" table
    // 
    // 29.09.2011 EDMS P8
    //   * Implement Tire Management
    // 
    // 28.01.2010 EDMS P2
    //   * Added function CreateTodoFromService
    //   * Added code CreateServiceHeader, CreateServiceLine, CreateSalesLine
    // 
    // 10.07.2009. EDMS P2
    //   * Added function SumServiceLines2
    //   * Added code CreateSalesHeader

    TableNo = 25006145;

    trigger OnRun()
    begin
        ServiceHeaderTemp := Rec;
        ServiceHeaderGlobal.GET(Rec."Document Type", Rec."No.");
        CheckServiceHeader(Rec);
        CheckDim(Rec);  //25.10.2013 EDMS P8
        CreateInvoices(Rec);
        getCurrentServiceLine(Rec."No."); //psf
        postIntoPSFHistory(Rec); //psf
        PostServiceOrder(Rec);
        PostSalesInvoices(ServiceHeaderTemp);
    end;

    var
        ServiceSetup: Record "25006120";
        cuReleaseSalesDoc: Codeunit "414";
        tcSer003: Label 'Put Items to "';
        ScheduleMgt: Codeunit "25006201";
        tcSer004: Label '" invoice.';
        tcSer005: Label 'Invoice creation is interupted.';
        TotalServiceLine: Record "25006146";
        TempServiceLine: Record "25006146" temporary;
        TempPrepaymentServiceLine: Record "25006146" temporary;
        GenPostingSetup: Record "252";
        TempVATAmountLine: Record "290" temporary;
        TempVATAmountLineRemainder: Record "290" temporary;
        GLSetup: Record "98";
        CustPostingGr: Record "92";
        ServiceHeaderGlobal: Record "25006145";
        ServiceLineGlobal: Record "25006146";
        ServiceLineACY: Record "25006146";
        TotalServiceLineLCY: Record "25006146";
        SalesSetup: Record "311";
        CurrExchRate: Record "330";
        Currency: Record "4";
        UseDate: Date;
        RoundingLineNo: Integer;
        RoundingLineInserted: Boolean;
        LastLineRetrieved: Boolean;
        Text004: Label 'An error occurred during the posting of the %1 %2.';
        Text016: Label 'VAT Amount';
        Text017: Label '%1% VAT';
        Text028: Label 'The combination of dimensions used in %1 %2 is blocked. %3';
        Text029: Label 'The combination of dimensions used in %1 %2, line no. %3 is blocked. %4';
        Text030: Label 'The dimensions used in %1 %2 are invalid. %3';
        Text031: Label 'The dimensions used in %1 %2, line no. %3 are invalid. %4';
        Text047: Label 'The quantity to ship does not match the quantity defined in Item Tracking.';
        Text048: Label 'must be at least %1';
        SourceCode: Code[20];
        SourceCodeSetup: Record "242";
        SIEAssgntLine: Record "25006706";
        SIEAssgnt: Codeunit "25006702";
        NoSeriesMgt: Codeunit "396";
        ServiceHeaderTemp: Record "25006145" temporary;
        ReserveServLine: Codeunit "25006121";
        Text050: Label 'Service Line reservation must be to inventory.';
        InvPartSellTo: Boolean;
        InvPartBillTo: Boolean;
        SalesDocType: Integer;
        SalesDocNoSellTo: Code[20];
        SalesDocNoBillTo: Code[20];
        TempDocNo: Code[20];
        Text100: Label 'Resource must be specified for %1 %2 line No. %3';
        Text101: Label 'Transfer Order exist for service document %1 %2.';

    [Scope('Internal')]
    procedure CreateInvoices(ServiceHeader: Record "25006145")
    var
        Vehicle: Record "25006005";
        ServiceLine: Record "25006146";
        SalesHeader: Record "36";
        SalesLine: Record "37";
        Location: Record "14";
        NewSalesLine: Record "37";
        ServLedgEntry: Record "25006167";
        ReservEntryST: Record "337";
        ReservEntryBT: Record "337";
        BalLineOffset: Integer;
        AllTransferred: Boolean;
        TextNothingToPost: Label 'Nothing to post.';
        NewLineNo: Integer;
        UseServiceLineNo: Boolean;
        Item: Record "27";
        InvPostGroup: Record "94";
    begin
        ServiceSetup.GET;
        UseServiceLineNo := TRUE;

        // Checks whether there is anything to post
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETFILTER(Type, '<>''''');
        ServiceLine.SETFILTER("No.", '<>''''');
        IF NOT ServiceLine.FINDFIRST THEN
            ERROR(TextNothingToPost);

        //<<prabesh for HS Code
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETRANGE(Type, ServiceLine.Type::Item);
        IF ServiceLine.FINDSET THEN
            REPEAT
                Item.GET(ServiceLine."No.");
                IF Item.Type = Item.Type::Inventory THEN BEGIN
                    InvPostGroup.GET(Item."Inventory Posting Group");
                    IF InvPostGroup."HS Code Mandatory" THEN
                        IF ServiceLine."HS Code" = '' THEN
                            ERROR('Hs Code is empty for Item %1', Item."No.");
                END;
            UNTIL ServiceLine.NEXT = 0;
        //>>

        IF ServiceSetup."Resource No. Mandatory" THEN BEGIN
            ServiceLine.RESET;
            ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
            ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
            ServiceLine.SETRANGE(Type, ServiceLine.Type::Labor);
            IF ServiceLine.FINDFIRST THEN
                REPEAT
                    IF (ServiceLine.GetResourceTextFieldValue = '') AND (GetResourceTextFieldValue = '') THEN
                        ERROR(Text100, ServiceLine."Document Type", ServiceLine."Document No.", ServiceLine."Line No.");
                UNTIL ServiceLine.NEXT = 0;
        END;

        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.FINDFIRST;

        IF (ServiceHeader."Document Type" = ServiceHeader."Document Type"::Order) AND ServiceSetup."Payment Method Mandatory" THEN
            ServiceHeader.TESTFIELD("Payment Method Code");

        ServiceHeader.TESTFIELD("Location Code");

        ArchiveUnpostedOrder(ServiceHeader);

        // Creates Sales Headers
        SalesHeader.RESET;
        CreateSalesHeader(ServiceHeader, SalesHeader);
        SalesDocType := SalesHeader."Document Type";

        CASE SalesDocType OF
            SalesHeader."Document Type"::Invoice:
                IF (ServiceSetup."Posted Invoice Nos." <> '')
                   AND NOT ServiceSetup."Use Order No. for Inv.&Cr.Memo"
                THEN
                    SalesHeader.VALIDATE("Posting No. Series", ServiceSetup."Posted Invoice Nos.");
            SalesHeader."Document Type"::"Credit Memo":
                BEGIN
                    IF (ServiceSetup."Posted Credit Memo Nos." <> '')
                       AND NOT ServiceSetup."Use Order No. for Inv.&Cr.Memo"
                    THEN
                        SalesHeader.VALIDATE("Posting No. Series", ServiceSetup."Posted Credit Memo Nos.");

                    // Automatic application
                    ServLedgEntry.SETCURRENTKEY("Document Type", "Service Order No.", "Bill-to Customer No.");
                    ServLedgEntry.SETRANGE("Document Type", ServLedgEntry."Document Type"::Invoice);
                    ServLedgEntry.SETRANGE("Service Order No.", ServiceHeader."Applies-to Doc. No.");
                    ServLedgEntry.SETRANGE("Bill-to Customer No.", ServiceHeader."Bill-to Customer No.");
                    IF ServLedgEntry.FINDFIRST THEN BEGIN
                        SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type"::Invoice;
                        SalesHeader."Applies-to Doc. No." := ServLedgEntry."Document No."
                    END;
                END
        END;

        SalesHeader.VALIDATE("Salesperson Code", ServiceHeader."Service Person");
        SalesHeader."Allow Line Disc." := TRUE;
        SalesHeader.VALIDATE("Payment Method Code", "Payment Method Code");
        SalesHeader.VALIDATE("Payment Terms Code", ServiceHeader."Payment Terms Code");
        SalesHeader."Due Date" := ServiceHeader."Due Date";
        SalesHeader."External Document No." := "External Document No.";
        SalesHeader."Prices Including VAT" := ServiceHeader."Prices Including VAT";
        SalesHeader.VALIDATE("Document Profile", SalesHeader."Document Profile"::Service);
        SalesHeader.VALIDATE("Location Code", ServiceHeader."Location Code");
        Vehicle.GET(ServiceHeader."Vehicle Serial No.");
        IF "Vehicle Item Charge No." <> '' THEN BEGIN
            Vehicle.TESTFIELD("Model Version No.");
            SalesHeader."Vehicle Item Charge No." := "Vehicle Item Charge No.";
        END;
        SalesHeader."Model Version No." := Vehicle."Model Version No.";
        SalesHeader."Shortcut Dimension 1 Code" := ServiceHeader."Shortcut Dimension 1 Code";
        SalesHeader."Shortcut Dimension 2 Code" := ServiceHeader."Shortcut Dimension 2 Code";
        SalesHeader."Dimension Set ID" := "Dimension Set ID";

        SalesHeader."Ship-to Code" := "Service Address Code";
        SalesHeader."Ship-to Name" := "Service Address Name";
        SalesHeader."Ship-to Address" := "Service Address";
        SalesHeader."Ship-to Address 2" := "Service Address 2";
        SalesHeader."Ship-to Post Code" := "Service Address Post Code";
        SalesHeader."Ship-to City" := "Service Address City";
        SalesHeader."Ship-to Contact" := "Service Address Contact";

        SalesHeader.MODIFY;

        CopyServCommLinesToSale(ServiceHeader."Document Type", SalesHeader."Document Type", ServiceHeader."No.", SalesHeader."No.");

        // Create Sales Lines
        REPEAT
            CreateSalesLine(SalesHeader, ServiceLine, NewSalesLine, NewLineNo, UseServiceLineNo);
        UNTIL ServiceLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetNoSeriesCode(SalesHeader: Record "36"): Code[10]
    begin
        CASE SalesHeader."Document Type" OF
            SalesHeader."Document Type"::Invoice:
                EXIT(ServiceSetup."Invoice Nos.");
            SalesHeader."Document Type"::"Credit Memo":
                EXIT(ServiceSetup."Credit Memo Nos.")
        END
    end;

    [Scope('Internal')]
    procedure CreateSalesHeader(ServiceHeader: Record "25006145"; var SalesHeader: Record "36")
    var
        NoSeriesMgt: Codeunit "396";
        codNo: Code[20];
        Vehicle: Record "25006005";
    begin
        // Creates sales invoice header
        ServiceSetup.GET;
        IF ServiceSetup."Deal Type Mandatory" THEN
            ServiceHeader.TESTFIELD("Deal Type");

        SalesHeader.INIT;

        IF ServiceHeader."Document Type" = ServiceHeader."Document Type"::Order THEN
            SalesHeader.VALIDATE("Document Type", SalesHeader."Document Type"::Invoice)
        ELSE
            SalesHeader.VALIDATE("Document Type", SalesHeader."Document Type"::"Credit Memo");

        IF ServiceSetup."Use Order No. for Inv.&Cr.Memo" THEN BEGIN
            codNo := GetNewInvoiceNo(ServiceHeader);
            SalesHeader.VALIDATE("No.", codNo);
        END ELSE
            SalesHeader."No. Series" := GetNoSeriesCode(SalesHeader);

        SalesHeader.INSERT(TRUE);

        SalesHeader.SkipIfService; //SP
        SalesHeader.SetDontFindContract(TRUE);
        SalesHeader.VALIDATE("Posting Date", ServiceHeader."Posting Date");
        SalesHeader.VALIDATE("Document Profile", SalesHeader."Document Profile"::Service);
        SalesHeader.VALIDATE("Sell-to Customer No.", ServiceHeader."Sell-to Customer No.");
        SalesHeader.SetHideValidationDialog(TRUE);
        SalesHeader.VALIDATE("Bill-to Customer No.", ServiceHeader."Bill-to Customer No.");
        SalesHeader.VALIDATE("Document Date", "Document Date");
        SalesHeader.VALIDATE("Payment Method Code", "Payment Method Code");
        SalesHeader."Make Code" := "Make Code";
        SalesHeader."Model Code" := "Model Code";
        SalesHeader."Vehicle Serial No." := "Vehicle Serial No.";
        SalesHeader."Vehicle Accounting Cycle No." := "Vehicle Accounting Cycle No.";
        SalesHeader."Vehicle Registration No." := "Vehicle Registration No.";
        SalesHeader."Service Document" := TRUE;
        SalesHeader."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
        SalesHeader."Service Document No." := ServiceHeader."No.";
        SalesHeader."Order Date" := ServiceHeader."Order Date";
        SalesHeader."Posting No." := codNo;
        SalesHeader."Deal Type Code" := "Deal Type";
        SalesHeader."Vehicle Status Code" := "Vehicle Status Code";
        SalesHeader."Language Code" := ServiceHeader."Language Code";
        SalesHeader."Warranty Claim No." := "Warranty Claim No.";
        SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type";
        SalesHeader."Applies-to Doc. No." := SalesHeader."Applies-to Doc. No.";
        SalesHeader."Delay Reason Code" := "Delay Reason Code"; //PSF
        SalesHeader."Quality Control" := "Quality Control";
        SalesHeader."Floor Control" := "Floor Control";
        SalesHeader."RV RR Code" := "RV RR Code";
        SalesHeader."Revisit Repair Reason" := "Revisit Repair Reason";
        SalesHeader."Resource PSF" := "Resources PSF";

        FillSalesVariableFields(SalesHeader, ServiceHeader);
        SalesHeader.Kilometrage := Kilometrage;
        //SalesHeader."Variable Field Run 2" := "Variable Field Run 2"; //Bishesh Jimba
        //SalesHeader."Variable Field Run 3" := "Variable Field Run 3"; //Bishesh Jimba

        SalesHeader."Currency Code" := ServiceHeader."Currency Code";
        SalesHeader."Currency Factor" := ServiceHeader."Currency Factor";
        SalesHeader."EU 3-Party Trade" := "EU 3-Party Trade";
        SalesHeader."Transaction Type" := "Transaction Type";
        SalesHeader."Transport Method" := "Transport Method";
        SalesHeader."Exit Point" := "Exit Point";
        SalesHeader.Area := Area;
        SalesHeader."Transaction Specification" := "Transaction Specification";
        SalesHeader."Shortcut Dimension 1 Code" := ServiceHeader."Shortcut Dimension 1 Code";
        SalesHeader."Shortcut Dimension 2 Code" := ServiceHeader."Shortcut Dimension 2 Code";
        SalesHeader."Dimension Set ID" := ServiceHeader."Dimension Set ID";
        SalesHeader."Invoice Discount Calculation" := ServiceHeader."Invoice Discount Calculation";
        SalesHeader."Invoice Discount Value" := ServiceHeader."Invoice Discount Value";

        SalesHeader."Service Document No." := ServiceHeader."No.";        // link to service document
        SalesHeader.Correction := ServiceHeader.Correction;
        SalesHeader."Contract No." := "Contract No.";

        SalesHeader."Prepayment %" := "Prepayment %";
        SalesHeader."Last Prepayment No." := "Last Prepayment No.";
        SalesHeader."Prepayment No. Series" := "Prepayment No. Series";
        SalesHeader."Prepmt. Cr. Memo No. Series" := "Prepmt. Cr. Memo No. Series";
        SalesHeader."Prepmt. Payment Discount %" := "Prepmt. Payment Discount %";

        IF (SalesHeader."Vehicle Registration No." = '') AND (SalesHeader."Vehicle Serial No." <> '') THEN
            IF Vehicle.GET(SalesHeader."Vehicle Serial No.") THEN
                SalesHeader."Vehicle Registration No." := Vehicle."Registration No.";

        SalesHeader.MODIFY
    end;

    [Scope('Internal')]
    procedure CreateSalesLine(SalesHeader: Record "36"; var ServiceLine: Record "25006146"; var SalesLine: Record "37"; var NewLineNo: Integer; UseServiceLineNo: Boolean)
    var
        GenPostSetup: Record "252";
        SalesInvHdr: Record "112";
        SalesShpmtHdr: Record "110";
        ItemLedgEntry: Record "32";
        ReservationEntry: Record "337";
        ReservationEntry1: Record "337";
    begin
        // Creates a new sales line

        IF UseServiceLineNo THEN
            NewLineNo := ServiceLine."Line No."
        ELSE
            NewLineNo += 10000;

        SalesLine.INIT;
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := NewLineNo;
        SalesLine."Make Code" := "Make Code";
        SalesLine."Line Type" := Type;
        SalesLine."Service Order No. EDMS" := ServiceLine."Document No.";
        SalesLine."Service Order Line No. EDMS" := "Line No.";
        SalesLine."Order Line Type No." := "No.";
        SalesLine."Appl.-to Item Entry" := "Appl.-to Item Entry";
        SalesLine.Group := Group;
        SalesLine."Group ID" := "Group ID";
        SalesLine."Package No." := "Package No.";
        SalesLine."Package Version No." := "Package Version No.";
        SalesLine."Package Version Spec. Line No." := "Package Version Spec. Line No.";
        SalesLine."External Serv. Tracking No." := "External Serv. Tracking No.";
        SalesLine."Contract No." := "Contract No.";

        CASE Type OF
            Type::Labor:
                BEGIN
                    SalesLine.Type := SalesLine.Type::"G/L Account";
                    GenPostSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                    SalesLine."No." := GenPostSetup."Sales Account";
                END;

            Type::"External Service":
                BEGIN
                    SalesLine.Type := SalesLine.Type::"External Service";
                    SalesLine."No." := "No.";
                END;

            Type::Item:
                BEGIN
                    ReservationEntry.RESET;
                    ReservationEntry.SETRANGE("Source ID", ServiceLine."Document No.");
                    ReservationEntry.SETRANGE("Item No.", "No.");
                    ReservationEntry.SETRANGE("Source Ref. No.", "Line No.");
                    IF ReservationEntry.FINDFIRST THEN
                        REPEAT
                            IF ReservationEntry1.GET(ReservationEntry."Entry No.", TRUE) THEN
                                REPEAT
                                    ReservationEntry."Lot No." := ReservationEntry1."Lot No.";
                                    ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                                    ReservationEntry.MODIFY;
                                UNTIL ReservationEntry.NEXT = 0;
                        UNTIL ReservationEntry.NEXT = 0;
                    SalesLine.Type := SalesLine.Type::Item;
                    SalesLine."No." := "No.";
                END;

            Type::"G/L Account":
                BEGIN
                    SalesLine.Type := SalesLine.Type::"G/L Account";
                    SalesLine."No." := "No.";
                END;

            Type::" ":
                BEGIN
                    SalesLine.Type := SalesLine.Type::" ";
                    SalesLine."No." := "No.";
                END;
        END;

        SalesLine."Line Discount %" := "Line Discount %";

        SalesLine.VALIDATE("No.");
        SalesLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
        SalesLine."VAT Bus. Posting Group" := "VAT Bus. Posting Group";

        SalesLine."Location Code" := "Location Code";
        SalesLine."Allow Line Disc." := TRUE;

        IF Type <> Type::" " THEN BEGIN
            SalesLine.VALIDATE("Gen. Prod. Posting Group", "Gen. Prod. Posting Group");
            SalesLine.VALIDATE("VAT Prod. Posting Group", "VAT Prod. Posting Group");
            SalesLine.VALIDATE("Unit of Measure Code", "Unit of Measure Code");
            SalesLine.VALIDATE(Quantity, Quantity);
            SalesLine.VALIDATE("Unit Price", "Unit Price");
            SalesLine.VALIDATE("Unit Cost (LCY)");
            SalesLine.VALIDATE("Line Discount %", "Line Discount %");
        END;

        SalesLine."Unit Cost (LCY)" := "Unit Cost (LCY)";
        SalesLine.Description := Description;
        SalesLine."Shipment Date" := SalesHeader."Posting Date";
        SalesLine.VIN := SalesHeader.VIN;
        SalesLine."Vehicle Accounting Cycle No." := SalesHeader."Vehicle Accounting Cycle No.";
        SalesLine."Document Profile" := SalesLine."Document Profile"::Service;
        SalesLine."Appl.-from Item Entry" := "Appl.-from Item Entry";
        SalesLine."Inv. Discount Amount" := "Inv. Discount Amount";
        SalesLine."Inv. Disc. Amount to Invoice" := "Inv. Disc. Amount to Invoice";

        SalesLine."Prepayment %" := "Prepayment %";
        SalesLine."Prepmt. Line Amount" := "Prepmt. Line Amount";
        SalesLine."Prepmt. Amt. Inv." := "Prepmt. Amt. Inv.";
        SalesLine."Prepmt. Amt. Incl. VAT" := "Prepmt. Amt. Incl. VAT";
        SalesLine."Prepayment Amount" := "Prepayment Amount";
        SalesLine."Prepmt. VAT Base Amt." := "Prepmt. VAT Base Amt.";
        SalesLine."Prepayment VAT %" := "Prepayment VAT %";
        SalesLine."Prepmt. VAT Calc. Type" := "Prepmt. VAT Calc. Type";
        SalesLine."Prepayment VAT Identifier" := "Prepayment VAT Identifier";
        SalesLine."Prepayment Tax Area Code" := "Prepayment Tax Area Code";
        SalesLine."Prepayment Tax Liable" := "Prepayment Tax Liable";
        SalesLine."Prepayment Tax Group Code" := "Prepayment Tax Group Code";
        SalesLine."Prepmt Amt to Deduct" := "Prepmt Amt to Deduct";
        SalesLine."Prepmt Amt Deducted" := "Prepmt Amt Deducted";
        SalesLine."Prepayment Line" := "Prepayment Line";
        SalesLine."Prepmt. Amount Inv. Incl. VAT" := "Prepayment Amount Incl. VAT";
        SalesLine."Prepmt. Amount Inv. (LCY)" :=
          ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code",
                "Prepayment Amount", SalesHeader."Currency Factor"), 0.01);
        SalesLine."Prepmt. VAT Amount Inv. (LCY)" :=
          ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code",
                "Prepayment Amount Incl. VAT" - "Prepmt. VAT Base Amt.", SalesHeader."Currency Factor"), 0.01);

        ReserveServLine.TransServLineToSalesLine(
          ServiceLine, SalesLine, ServiceLine."Outstanding Qty. (Base)");

        SalesLine."Standard Time" := "Standard Time";
        SalesLine."Campaign No." := "Campaign No.";
        FillSalesLineVariableFields(SalesLine, ServiceLine);
        SalesLine."Shortcut Dimension 1 Code" := ServiceLine."Shortcut Dimension 1 Code";
        SalesLine."Shortcut Dimension 2 Code" := ServiceLine."Shortcut Dimension 2 Code";
        SalesLine."Dimension Set ID" := ServiceLine."Dimension Set ID";

        // do link to service document
        SalesLine."Service Order No. EDMS" := ServiceLine."Document No.";
        SalesLine."Service Order Line No. EDMS" := "Line No.";

        SalesLine.INSERT;
    end;

    [Scope('Internal')]
    procedure GetNewInvoiceNo(ServiceHeader: Record "25006145") codNo: Code[20]
    var
        SalHed: Record "36";
        SalInv: Record "112";
        NoPost: Code[20];
    begin
        SalHed.SETFILTER("No.", ServiceHeader."No." + '*');
        IF SalHed.FINDLAST THEN BEGIN
            IF SalHed."No." = ServiceHeader."No." THEN
                codNo := ServiceHeader."No." + '-01'
            ELSE
                codNo := INCSTR(SalHed."No.");
        END ELSE
            codNo := ServiceHeader."No.";

        SalInv.SETFILTER("No.", ServiceHeader."No." + '*');
        IF SalInv.FINDLAST THEN BEGIN
            IF SalInv."No." = ServiceHeader."No." THEN
                NoPost := ServiceHeader."No." + '-01'
            ELSE
                NoPost := INCSTR(SalInv."No.");
        END ELSE
            NoPost := ServiceHeader."No.";

        IF codNo < NoPost THEN
            codNo := NoPost;
    end;

    [Scope('Internal')]
    procedure InsertServiceHeaderLine(ServiceHeader: Record "25006145"; var NewServiceLine: Record "25006146"; LineNo: Integer; BillTo: Code[20]; LineType: Integer; ItemNo: Code[20])
    begin
        NewServiceLine.INIT;
        NewServiceLine."Document Type" := ServiceHeader."Document Type";
        NewServiceLine."Document No." := ServiceHeader."No.";
        "Line No." := LineNo;
        NewServiceLine.VALIDATE("Sell-to Customer No.", ServiceHeader."Sell-to Customer No.");
        NewServiceLine.VALIDATE("Bill-to Customer No.", BillTo);
        "Location Code" := ServiceHeader."Location Code";
        "System-Created Entry" := TRUE;
        "Vehicle Serial No." := ServiceHeader."Vehicle Serial No.";
        "Make Code" := ServiceHeader."Make Code";
        "Vehicle Registration No." := ServiceHeader."Vehicle Registration No.";
        "Model Code" := ServiceHeader."Model Code";
        VIN := ServiceHeader.VIN;
        Type := LineType;
        NewServiceLine.VALIDATE("No.", ItemNo);
        NewServiceLine.INSERT;
    end;

    [Scope('Internal')]
    procedure PostSalesInvoices(var ServiceHeader: Record "25006145" temporary): Boolean
    var
        SalesHeader: Record "36";
        SalesHeader2: Record "36";
        SalesPost: Codeunit "80";
    begin
        //COMMIT;                                                                 // 30.07.2015 EB.P30 #T043
        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("Service Document No.");
        SalesHeader.SETRANGE("Service Document No.", ServiceHeader."No.");
        IF ServiceHeader."Document Type" = ServiceHeader."Document Type"::Order THEN
            SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Invoice)
        ELSE
            SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::"Credit Memo");
        IF SalesHeader.FINDFIRST THEN
            REPEAT
                SalesHeader2 := SalesHeader;
                CLEAR(SalesPost);
                //      IF NOT                                                            // 30.07.2015 EB.P30 #T043
                SalesPost.RUN(SalesHeader2)
            //      THEN                                                              // 30.07.2015 EB.P30 #T043
            //        ERROR(Text004,SalesHeader2.TABLECAPTION,SalesHeader2."No.")     // 30.07.2015 EB.P30 #T043
            UNTIL SalesHeader.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure DelSalesInvoices(var ServiceHeader: Record "25006145" temporary): Boolean
    var
        SalesHeader: Record "36";
        SalesHeader2: Record "36";
        SalesPost: Codeunit "80";
    begin
        SalesHeader.RESET;
        SalesHeader.SETCURRENTKEY("Service Document No.");
        SalesHeader.SETRANGE("Service Document No.", ServiceHeader."No.");
        IF ServiceHeader."Document Type" = ServiceHeader."Document Type"::Order THEN
            SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Invoice)
        ELSE
            SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::"Credit Memo");
        IF SalesHeader.FINDFIRST THEN
            REPEAT
                SalesHeader2 := SalesHeader;
                SalesHeader2.DELETE(TRUE);
            UNTIL SalesHeader.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetServiceLines(var NewServiceHeader: Record "25006145"; var NewServiceLine: Record "25006146"; QtyType: Option General,Invoicing,Shipping)
    var
        OldServiceLine: Record "25006146";
        MergedServiceLines: Record "25006146" temporary;
        TotalAdjCostLCY: Decimal;
    begin
        ServiceHeaderGlobal := NewServiceHeader;

        //EDMS1.0.00 >>
        IF QtyType = QtyType::Invoicing THEN BEGIN
            CreateServPrepaymentLines(ServiceHeaderGlobal, TempPrepaymentServiceLine, FALSE);
            MergeServiceLines(ServiceHeaderGlobal, OldServiceLine, TempPrepaymentServiceLine, MergedServiceLines);
            SumServiceLines(NewServiceLine, MergedServiceLines, QtyType, TRUE, FALSE, TotalAdjCostLCY);
        END ELSE
            SumServiceLines(NewServiceLine, OldServiceLine, QtyType, TRUE, FALSE, TotalAdjCostLCY);
        //EDMS1.0.00 <<
    end;

    [Scope('Internal')]
    procedure CreateServPrepaymentLines(ServiceHeader: Record "25006145"; var TempPrepmtServiceLine: Record "25006146"; CompleteFunctionality: Boolean)
    var
        GLAcc: Record "15";
        ServiceLine: Record "25006146";
        TempExtTextLine: Record "280" temporary;
        DimMgt: Codeunit "408";
        TransferExtText: Codeunit "378";
        NextLineNo: Integer;
        Fraction: Decimal;
        TempLineFound: Boolean;
        GenLedgSetup: Record "98";
    begin
        GLSetup.GET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        IF NOT ServiceLine.FINDLAST THEN
            EXIT;
        NextLineNo := "Line No." + 10000;
        ServiceLine.SETFILTER(Quantity, '>0');
        TempPrepmtServiceLine.SetHasBeenShown;
        IF ServiceLine.FINDSET THEN
            REPEAT
                IF CompleteFunctionality THEN BEGIN
                    Fraction := Quantity / Quantity;
                    CASE TRUE OF
                        ("Prepmt Amt to Deduct" <> 0) AND
                      ("Prepmt Amt to Deduct" > Fraction * "Line Amount"):
                            ServiceLine.FIELDERROR(
                              "Prepmt Amt to Deduct",
                              STRSUBSTNO(Text047,
                                ROUND(Fraction * "Line Amount", GLSetup."Amount Rounding Precision")));
                        ("Prepmt. Amt. Inv." <> 0) AND
                      ((1 - Fraction) * "Line Amount" <
                      "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" - "Prepmt Amt to Deduct"):
                            ServiceLine.FIELDERROR(
                              "Prepmt Amt to Deduct",
                              STRSUBSTNO(Text048,
                                ROUND(
                                  "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" - (1 - Fraction) * "Line Amount",
                                  GLSetup."Amount Rounding Precision")));
                    END;
                END;
                IF "Prepmt Amt to Deduct" <> 0 THEN BEGIN
                    IF ("Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") OR
                       ("Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
                    THEN BEGIN
                        GenPostingSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                        GenPostingSetup.TESTFIELD("Service Prepayments Account");
                    END;
                    GLAcc.GET(GenPostingSetup."Service Prepayments Account");
                    TempLineFound := FALSE;
                    IF ServiceHeader."Compress Prepayment" THEN BEGIN
                        TempPrepmtServiceLine.SETRANGE("No.", GLAcc."No.");
                        IF TempPrepmtServiceLine.FINDFIRST THEN
                            TempLineFound := (ServiceLine."Dimension Set ID" = TempPrepmtServiceLine."Dimension Set ID");
                        TempPrepmtServiceLine.SETRANGE("No.");
                    END;
                    IF TempLineFound THEN BEGIN
                        TempPrepmtServiceLine.VALIDATE(
                          "Unit Price", TempPrepmtServiceLine."Unit Price" + "Prepmt Amt to Deduct");
                        TempPrepmtServiceLine.MODIFY;
                    END ELSE BEGIN
                        TempPrepmtServiceLine.INIT;
                        TempPrepmtServiceLine."Document Type" := ServiceHeader."Document Type";
                        TempPrepmtServiceLine."Document No." := ServiceHeader."No.";
                        TempPrepmtServiceLine."Line No." := 0;
                        TempPrepmtServiceLine."System-Created Entry" := TRUE;
                        IF CompleteFunctionality THEN
                            TempPrepmtServiceLine.VALIDATE(Type, TempPrepmtServiceLine.Type::"G/L Account")
                        ELSE
                            TempPrepmtServiceLine.Type := TempPrepmtServiceLine.Type::"G/L Account";
                        TempPrepmtServiceLine.VALIDATE("No.", GenPostingSetup."Service Prepayments Account");
                        IF GLSetup."Calc.Prepmt.VAT by Line PostGr" THEN BEGIN
                            TempPrepmtServiceLine.VALIDATE("Gen. Prod. Posting Group", "Gen. Prod. Posting Group");
                            TempPrepmtServiceLine.VALIDATE("VAT Prod. Posting Group", "VAT Prod. Posting Group")
                        END;
                        TempPrepmtServiceLine.VALIDATE(Quantity, -1);
                        TempPrepmtServiceLine."Prepayment Line" := TRUE;
                        TempPrepmtServiceLine.VALIDATE("Unit Price", "Prepmt Amt to Deduct");
                        TempPrepmtServiceLine."Line No." := NextLineNo;
                        NextLineNo := NextLineNo + 10000;
                        TempPrepmtServiceLine.INSERT;


                        TransferExtText.PrepmtGetAnyExtText(
                          TempPrepmtServiceLine."No.", DATABASE::"Sales Invoice Line",
                          ServiceHeader."Document Date", ServiceHeader."Language Code", TempExtTextLine);
                        IF TempExtTextLine.FINDSET THEN
                            REPEAT
                                TempPrepmtServiceLine.INIT;
                                TempPrepmtServiceLine.Description := TempExtTextLine.Text;
                                TempPrepmtServiceLine."System-Created Entry" := TRUE;
                                TempPrepmtServiceLine."Prepayment Line" := TRUE;
                                TempPrepmtServiceLine."Line No." := NextLineNo;
                                NextLineNo := NextLineNo + 10000;
                                TempPrepmtServiceLine.INSERT;
                            UNTIL TempExtTextLine.NEXT = 0;
                    END;
                END;
            UNTIL ServiceLine.NEXT = 0
    end;

    [Scope('Internal')]
    procedure MergeServiceLines(ServiceHeader: Record "25006145"; var ServiceLine: Record "25006146"; var ServiceLine2: Record "25006146"; var MergedServiceLine: Record "25006146")
    begin
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        IF ServiceLine.FINDSET THEN
            REPEAT
                MergedServiceLine := ServiceLine;
                MergedServiceLine.INSERT;
            UNTIL ServiceLine.NEXT = 0;
        ServiceLine2.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine2.SETRANGE("Document No.", ServiceHeader."No.");
        IF ServiceLine2.FINDSET THEN
            REPEAT
                MergedServiceLine := ServiceLine2;
                MergedServiceLine.INSERT;
            UNTIL ServiceLine2.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure PostServiceOrder(ServiceHeader: Record "25006145")
    var
        ServiceOrder: Record "25006145";
        Vehicle: Record "25006005";
        DocType: Option Quote,"Order","Return Order";
        ServiceWIPMgt: Codeunit "25006132";
    begin
        // 27.07.2015 EB.P30 #WIP >>
        ServiceWIPMgt.ServiceOrderCheckAndPostWIP(ServiceHeader."No.", ServiceHeader."Posting Date");
        ServiceWIPMgt.DeleteCalculatedWIP(ServiceHeader."No.");
        // 27.07.2015 EB.P30 #WIP <<

        CreateServPrepaymentLines(ServiceHeader, TempPrepaymentServiceLine, TRUE);

        ServiceHeader.TESTFIELD("Document Type");
        ServiceHeader.TESTFIELD("Sell-to Customer No.");
        ServiceHeader.TESTFIELD("Bill-to Customer No.");
        ServiceHeader.TESTFIELD("Posting Date");
        ServiceHeader.TESTFIELD("Document Date");

        SourceCodeSetup.GET;
        SourceCode := SourceCodeSetup."Service Management EDMS";

        CreatePostedServiceHeader(ServiceHeader);

        CreatePostedServiceLines(ServiceHeader);

        UpdateConsumptionChecklist(ServiceHeader."No.", ServiceHeader."Posting No.");

        //Copy SIE Assignment lines
        SIEAssgntLine.SETCURRENTKEY("Applies-to Type", "Applies-to Doc. Type", "Applies-to Doc. No.", "Line No.");
        SIEAssgntLine.SETRANGE("Applies-to Type", DATABASE::"Service Line EDMS");
        SIEAssgntLine.SETRANGE("Applies-to Doc. Type", SIEAssgntLine."Applies-to Doc. Type"::Order);
        SIEAssgntLine.SETRANGE("Applies-to Doc. No.", ServiceHeader."No.");
        IF SIEAssgntLine.COUNT > 0 THEN
            SIEAssgnt.MoveAssgntToPostedDocLine(DATABASE::"Service Line EDMS", ServiceHeader."Document Type",
              ServiceHeader."No.", 0, DATABASE::"Posted Serv. Order Line", ServiceHeader."Document Type",
              ServiceHeader."Posting No.", 0);

        DeleteServiceOrder(ServiceHeader);
    end;

    [Scope('Internal')]
    procedure CreatePostedServiceHeader(var ServiceOrder: Record "25006145")
    var
        PstOrdHeader: Record "25006149";
        PstReturnOrdHeader: Record "25006154";
        ServCommentLine: Record "25006148";
        ServPlanMgt: Codeunit "25006103";
    begin
        CASE ServiceOrder."Document Type" OF
            ServiceOrder."Document Type"::"Return Order":
                BEGIN
                    // Insert posted return order header
                    PstReturnOrdHeader.INIT;
                    PstReturnOrdHeader.TRANSFERFIELDS(ServiceOrder);

                    IF ("Pst. Return Order No." = '') THEN BEGIN
                        ServiceOrder.TESTFIELD("Pst. Return Order No. Series");
                        "Pst. Return Order No." := NoSeriesMgt.GetNextNo("Pst. Return Order No. Series", ServiceOrder."Posting Date", TRUE);
                    END;
                    PstReturnOrdHeader.TESTFIELD("No.");

                    PstReturnOrdHeader."No." := "Pst. Return Order No.";
                    PstReturnOrdHeader."No. Series" := "Pst. Return Order No. Series";
                    PstReturnOrdHeader."Return Order No. Series" := "No. Series";
                    PstReturnOrdHeader."Return Order No." := ServiceOrder."No.";
                    IF ServiceSetup."Ext. Doc. No. Mandatory" THEN
                        ServiceOrder.TESTFIELD("External Document No.");

                    PstReturnOrdHeader."No. Printed" := 0;
                    FillPstReturnVariableFields(PstReturnOrdHeader, ServiceOrder);
                    CopyServCommLinesToPosted(ServiceOrder."Document Type", ServiceOrder."Document Type", ServiceOrder."No.", PstReturnOrdHeader."No."); // 26.03.2014 Elva Baltic P18 MMG7.00
                    PstReturnOrdHeader.INSERT(TRUE);

                    ServPlanMgt.UpdateDocLinkDocNo(1, ServiceOrder."No.", 3, PstReturnOrdHeader."No.");

                    ModifyProcessChecklist(ServiceOrder, DATABASE::"Posted Serv. Ret. Order Header", PstReturnOrdHeader."No.");

                    //23.02.2010 EDMSB P2 >>
                    ScheduleMgt.PostingServHdr(ServiceOrder, PstReturnOrdHeader."No.");
                    //23.02.2010 EDMSB P2 <<
                END;

            ServiceOrder."Document Type"::Order:
                BEGIN
                    PstOrdHeader.INIT;
                    PstOrdHeader.TRANSFERFIELDS(ServiceOrder);

                    IF ("Posting No." = '') THEN BEGIN
                        ServiceOrder.TESTFIELD("Posting No. Series");
                        "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series", ServiceOrder."Posting Date", TRUE);
                    END;

                    PstOrdHeader.TESTFIELD("No.");
                    PstOrdHeader."No." := "Posting No.";
                    PstOrdHeader."No. Series" := "Posting No. Series";
                    PstOrdHeader."Order No." := ServiceOrder."No.";
                    PstOrdHeader."Order No. Series" := "No. Series";
                    IF ServiceSetup."Ext. Doc. No. Mandatory" THEN
                        ServiceOrder.TESTFIELD("External Document No.");
                    PstOrdHeader."Delay Reason Code" := "Delay Reason Code"; //PSF
                    PstOrdHeader."RV RR Code" := "RV RR Code";
                    PstOrdHeader."Quality Control" := "Quality Control";
                    PstOrdHeader."Floor Control" := "Floor Control";
                    PstOrdHeader."Revisit Repair Reason" := "Revisit Repair Reason"; //PSF
                    PstOrdHeader."Resources PSF" := "Resources PSF";
                    PstOrdHeader."Posted By" := COPYSTR(USERID, 1, 30);

                    FillPstOrderVariableFields(PstOrdHeader, ServiceOrder);
                    //23.01.2013 EDMS P8 >>
                    PstOrdHeader.Resources := COPYSTR(GetResourceTextFieldValue, 1, 100);
                    //23.01.2013 EDMS P8 <<
                    CopyServCommLinesToPosted(ServiceOrder."Document Type", ServiceOrder."Document Type", ServiceOrder."No.", PstOrdHeader."No."); // 26.03.2014 Elva Baltic P18 MMG7.00
                    PstOrdHeader.INSERT;

                    ServPlanMgt.UpdateDocLinkDocNo(0, ServiceOrder."No.", 2, PstOrdHeader."No.");

                    ModifyProcessChecklist(ServiceOrder, DATABASE::"Posted Serv. Order Header", PstOrdHeader."No.");

                    //28.01.2010 EDMSB P2 >>
                    CreateToDoFromService(PstOrdHeader);
                    //28.01.2010 EDMSB P2 <<

                    //23.02.2010 EDMSB P2 >>
                    ScheduleMgt.PostingServHdr(ServiceOrder, PstOrdHeader."No.");
                    //23.02.2010 EDMSB P2 <<
                END
        END
    end;

    [Scope('Internal')]
    procedure CreatePostedServiceLines(ServiceHeader: Record "25006145")
    var
        ServiceLine: Record "25006146";
        PstOrdLine: Record "25006150";
        ServJnlLine: Record "25006165";
        ServJnlPostLine: Codeunit "25006107";
        DimMgt: Codeunit "408";
        PstReturnOrdLine: Record "25006155";
        ServJnlLineLineNo: Integer;
        ServLedgEntry: Record "25006167";
    begin
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        IF NOT ServiceLine.FINDFIRST THEN
            EXIT;
        ServJnlLineLineNo := 0;
        REPEAT
            ServJnlLine.INIT;
            ServJnlLine."Posting Date" := ServiceHeader."Posting Date";
            ServJnlLine."Document Date" := "Document Date";
            ServJnlLine."Vehicle Serial No." := "Vehicle Serial No.";
            ServJnlLine."Make Code" := "Make Code";
            ServJnlLine."Model Code" := "Model Code";
            ServJnlLine."Vehicle Accounting Cycle No." := "Vehicle Accounting Cycle No.";
            ServJnlLine."Model Version No." := "Model Version No.";

            ServJnlLine.Description := ServiceLine.Description;
            ServJnlLine."Job No." := ServiceLine."Job No.";
            ServJnlLine."Unit of Measure Code" := ServiceLine."Unit of Measure Code";
            ServJnlLine."Minutes Per UoM" := ServiceLine."Minutes Per UoM";
            ServJnlLine."Shortcut Dimension 1 Code" := ServiceLine."Shortcut Dimension 1 Code";
            ServJnlLine."Shortcut Dimension 2 Code" := ServiceLine."Shortcut Dimension 2 Code";
            ServJnlLine."Dimension Set ID" := ServiceLine."Dimension Set ID";
            ServJnlLine."Gen. Bus. Posting Group" := ServiceLine."Gen. Bus. Posting Group";
            ServJnlLine."Delay Reason Code" := "Delay Reason Code"; //PSF
            ServJnlLine."RV RR Code" := "RV RR Code";
            ServJnlLine."Quality Control" := "Quality Control";
            ServJnlLine."Floor Control" := "Floor Control";
            ServJnlLine."Revisit Repair Reason" := "Revisit Repair Reason";
            ServJnlLine."Resources PSF" := "Resources PSF";

            ServJnlLine."Gen. Prod. Posting Group" := ServiceLine."Gen. Prod. Posting Group";
            ServJnlLine."Entry Type" := ServJnlLine."Entry Type"::Usage;

            CASE ServiceHeader."Document Type" OF
                ServiceHeader."Document Type"::"Return Order":
                    BEGIN
                        ServJnlLine."Document Type" := ServJnlLine."Document Type"::"Return Order";
                        ServJnlLine."Document No." := "Pst. Return Order No.";
                        IF "Applies-to Doc. No." <> '' THEN
                            ServJnlLine."Service Order No." := "Applies-to Doc. No."
                        ELSE
                            ServJnlLine."Service Order No." := ServiceHeader."No.";
                    END;
                ServiceHeader."Document Type"::Order:
                    BEGIN
                        ServJnlLine."Document Type" := ServJnlLine."Document Type"::Order;
                        ServJnlLine."Document No." := "Posting No.";
                        ServJnlLine."Service Order No." := ServiceHeader."No."
                    END
            END;

            ServJnlLine."Pre-Assigned No." := ServiceHeader."No.";
            ServJnlLine."External Document No." := "External Document No.";

            CalculateAmountLCY(ServJnlLine, ServiceHeader, ServiceLine);
            IF NOT ServiceHeader."Prices Including VAT" THEN BEGIN
                ServJnlLine."Line Discount Amount" := ServiceLine."Line Discount Amount";
                ServJnlLine."Inv. Discount Amount" := ServiceLine."Inv. Discount Amount";
                ServJnlLine."Unit Price" := ServiceLine."Unit Price";
            END ELSE BEGIN
                ServJnlLine."Line Discount Amount" := ROUND(ServiceLine."Line Discount Amount" / (1 + ServiceLine."VAT %" / 100));
                ServJnlLine."Inv. Discount Amount" := ROUND(ServiceLine."Inv. Discount Amount" / (1 + ServiceLine."VAT %" / 100));
                ServJnlLine."Unit Price" := ROUND(ServiceLine."Unit Price" / (1 + ServiceLine."VAT %" / 100));
            END;

            IF ServiceHeader."Document Type" = ServiceHeader."Document Type"::Order THEN BEGIN
                ServJnlLine.Quantity := ServiceLine.Quantity;
                ServJnlLine."Quantity (Hours)" := ServiceLine.GetTimeQty;
                ServJnlLine."Unit Cost" := ServiceLine."Unit Cost (LCY)";
                ServJnlLine."Total Cost" := ServiceLine."Unit Cost (LCY)" * ServJnlLine.Quantity;
                ServJnlLine.Amount := ServiceLine.Amount;
                ServJnlLine."Amount Including VAT" := ServiceLine."Amount Including VAT";
                ServJnlLine."Amount (LCY)" := ServJnlLine."Amount (LCY)";
                ServJnlLine."Amount Including VAT (LCY)" := ServJnlLine."Amount Including VAT (LCY)";
                ServJnlLine."Line Discount Amount" := ServJnlLine."Line Discount Amount";
                ServJnlLine."Inv. Discount Amount" := ServJnlLine."Inv. Discount Amount";
                ServJnlLine."Line Discount Amount (LCY)" := ServJnlLine."Line Discount Amount (LCY)";
                ServJnlLine."Inv. Discount Amount (LCY)" := ServJnlLine."Inv. Discount Amount (LCY)";
            END ELSE BEGIN  //Return Order
                ServJnlLine.Quantity := -ServiceLine.Quantity;
                ServJnlLine."Quantity (Hours)" := -ServiceLine.GetTimeQty;
                ServJnlLine."Unit Cost" := ServiceLine."Unit Cost (LCY)";
                ServJnlLine."Total Cost" := ServiceLine."Unit Cost (LCY)" * ServJnlLine.Quantity;
                ServJnlLine.Amount := -ServiceLine.Amount;
                ServJnlLine."Amount Including VAT" := -ServiceLine."Amount Including VAT";
                ServJnlLine."Amount (LCY)" := -ServJnlLine."Amount (LCY)";
                ServJnlLine."Amount Including VAT (LCY)" := -ServJnlLine."Amount Including VAT (LCY)";
                ServJnlLine."Line Discount Amount" := -ServJnlLine."Line Discount Amount";
                ServJnlLine."Inv. Discount Amount" := -ServJnlLine."Inv. Discount Amount";
                ServJnlLine."Line Discount Amount (LCY)" := -ServJnlLine."Line Discount Amount (LCY)";
                ServJnlLine."Inv. Discount Amount (LCY)" := -ServJnlLine."Inv. Discount Amount (LCY)";
            END;
            ServJnlLine."Source Code" := SourceCode;
            ServJnlLine.Chargeable := TRUE;
            ServJnlLine.Type := ServiceLine.Type;
            ServJnlLine."No." := ServiceLine."No.";
            ServJnlLine."Customer No." := ServiceHeader."Sell-to Customer No.";
            ServJnlLine."Bill-to Customer No." := ServiceHeader."Bill-to Customer No.";
            ServJnlLine."Posting No. Series" := "Posting No. Series";
            ServJnlLine."Location Code" := ServiceHeader."Location Code";
            ServJnlLine."Discount %" := ServiceLine."Line Discount %";
            ServJnlLine."Payment Method Code" := "Payment Method Code";
            ServJnlLine."Warranty Claim No." := "Warranty Claim No.";
            ServJnlLine.Kilometrage := Kilometrage;
            //ServJnlLine."Variable Field Run 2" := "Variable Field Run 2";
            //ServJnlLine."Variable Field Run 3" := "Variable Field Run 3";
            ServJnlLine."Package No." := ServiceLine."Package No.";
            ServJnlLine."Package Version No." := ServiceLine."Package Version No.";
            ServJnlLine."Package Version Spec. Line No." := ServiceLine."Package Version Spec. Line No.";
            ServJnlLine."Currency Code" := ServiceHeader."Currency Code";
            ServJnlLine."Deal Type Code" := "Deal Type";

            //28.01.2010 EDMSB P2 >>
            ServJnlLine."Standard Time" := ServiceLine."Standard Time";
            ServJnlLine."Campaign No." := ServiceLine."Campaign No.";
            //28.01.2010 EDMSB P2 <<

            // 29.09.2011 EDMS P8 >>
            ServJnlLine."Vehicle Axle Code" := ServiceLine."Vehicle Axle Code";
            ServJnlLine."Tire Position Code" := ServiceLine."Tire Position Code";
            ServJnlLine."Tire Code" := ServiceLine."Tire Code";
            ServJnlLine."Tire Operation Type" := ServiceLine."Tire Operation Type";
            ServJnlLine."New Vehicle Axle Code" := ServiceLine."New Vehicle Axle Code";
            ServJnlLine."New Tire Position Code" := ServiceLine."New Tire Position Code";
            // 29.09.2011 EDMS P8 <<

            // 2012.07.31 EDMS P8 >>
            ServJnlLine."Document Line No." := ServiceLine."Line No.";
            ServJnlLine."Plan No." := ServiceLine."Plan No.";
            ServJnlLine."Plan Stage Recurrence" := ServiceLine."Plan Stage Recurrence";
            ServJnlLine."Plan Stage Code" := ServiceLine."Plan Stage Code";
            // 2012.07.31 EDMS P8 <<

            // 30.07.2015 EB.P30 #T045 >>
            ServJnlLine."Service Receiver" := ServiceHeader."Service Person";
            // 30.07.2015 EB.P30 #T045 <<

            ServJnlLine."Service Address Code" := "Service Address Code";
            ServJnlLine."Service Address" := "Service Address";

            FillServJournalVariableFields(ServJnlLine, ServiceLine);

            //2012.06.28 EDMS P8 >>
            FillDetServJnlByResource(ServJnlLine, ServiceLine."Document Type", ServiceLine."Document No.",
              ServiceLine."Line No.", '110');
            //2012.06.28 EDMS P8 <<

            ServJnlPostLine.RunWithCheck(ServJnlLine);

            CASE ServiceHeader."Document Type" OF
                ServiceHeader."Document Type"::"Return Order":
                    BEGIN
                        PstReturnOrdLine.INIT;
                        PstReturnOrdLine.TRANSFERFIELDS(ServiceLine);
                        PstReturnOrdLine."Document No." := "Pst. Return Order No.";
                        //12.05.2015 EB.P30 #T030 >>
                        ServiceLine.CALCFIELDS("Res. Cost Amount Finished");
                        ServLedgEntry.RESET;
                        ServLedgEntry.SETRANGE("Document Type", ServLedgEntry."Document Type"::"Return Order");
                        ServLedgEntry.SETRANGE("Document No.", ServiceLine."Document No.");
                        ServLedgEntry.SETRANGE("Document Line No.", ServiceLine."Line No.");
                        IF ServLedgEntry.FINDFIRST THEN
                            ServLedgEntry.CALCFIELDS("Resource Cost Amount");
                        PstReturnOrdLine."Resource Cost Amount" := -ServLedgEntry."Resource Cost Amount";
                        //12.05.2015 EB.P30 #T030 <<

                        // 29.09.2011 EDMS P8 >>
                        PstReturnOrdLine."Vehicle Serial No." := ServJnlLine."Vehicle Serial No.";
                        // 29.09.2011 EDMS P8 <<

                        FillPstReturnLineVarFields(PstReturnOrdLine, ServiceLine);

                        PstReturnOrdLine.Resources := COPYSTR(ServiceLine.GetResourceTextFieldValue, 1, 100);      // 12.05.2014 Elva Baltic P21

                        PstReturnOrdLine.INSERT;
                        ScheduleMgt.PostingServLine(ServiceLine, "Pst. Return Order No.");
                    END;
                ServiceHeader."Document Type"::Order:
                    BEGIN
                        PstOrdLine.INIT;
                        PstOrdLine.TRANSFERFIELDS(ServiceLine);
                        PstOrdLine."Document No." := "Posting No.";
                        //12.05.2015 EB.P30 #T030 >>
                        ServLedgEntry.RESET;
                        ServLedgEntry.SETRANGE("Document Type", ServLedgEntry."Document Type"::Order);
                        ServLedgEntry.SETRANGE("Document No.", ServiceLine."Document No.");
                        ServLedgEntry.SETRANGE("Document Line No.", ServiceLine."Line No.");
                        IF ServLedgEntry.FINDFIRST THEN
                            ServLedgEntry.CALCFIELDS("Resource Cost Amount");
                        PstOrdLine."Resource Cost Amount" := ServLedgEntry."Resource Cost Amount";
                        //12.05.2015 EB.P30 #T030 <<

                        // 29.09.2011 EDMS P8 >>
                        PstOrdLine."Vehicle Serial No." := ServJnlLine."Vehicle Serial No.";
                        // 29.09.2011 EDMS P8 <<

                        FillPstOrderLineVariableFields(PstOrdLine, ServiceLine);

                        //23.01.2013 EDMS P8 >>
                        PstOrdLine.Resources := COPYSTR(ServiceLine.GetResourceTextFieldValue, 1, 100);
                        //23.01.2013 EDMS P8 <<

                        PstOrdLine.INSERT;

                        ScheduleMgt.PostingServLine(ServiceLine, "Posting No.");
                    END
            END;

        UNTIL GetNextServiceLine(ServiceLine);
        //2012.06.28 EDMS P8 >>
        ClearDetServJnlOfLine(ServJnlLine);
        //2012.06.28 EDMS P8 <<
    end;

    [Scope('Internal')]
    procedure DeleteServiceOrder(ServiceOrder: Record "25006145")
    var
        ServiceLine: Record "25006146";
    begin
        //Dimensions

        IF ServiceOrder.HASLINKS THEN ServiceOrder.DELETELINKS;

        //Lines
        ServiceLine.SETRANGE("Document Type", ServiceOrder."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceOrder."No.");
        IF ServiceLine.FINDFIRST THEN
            REPEAT
                IF ServiceLine.HASLINKS THEN
                    ServiceLine.DELETELINKS;
            UNTIL ServiceLine.NEXT = 0;

        ServiceLine.DELETEALL;

        //Header
        ServiceOrder.DELETE;
    end;

    [Scope('Internal')]
    procedure CopyServCommLinesToPosted(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    var
        ServCommentLine: Record "25006148";
        ServCommentLine2: Record "25006148";
        FrDocType: Option Quote,"Order","Return Order";
        ToDocType: Option "Service Quote","Service Order",Symtom,"Recall Campaign",Labor,"External Service","Service Package","Service Package Specification",Contract,Vehicle,"Service Return Order","Posted Service Order","Posted Service Return Order";
    begin
        // 26.03.2014 Elva Baltic P18 MMG7.00 >>
        IF FromDocumentType = FrDocType::Order THEN
            ToDocumentType := ToDocType::"Posted Service Order";
        IF FromDocumentType = FrDocType::"Return Order" THEN
            ToDocumentType := ToDocType::"Posted Service Return Order";
        // 26.03.2014 Elva Baltic P18 MMG7.00 <<
        ServCommentLine.SETRANGE(Type, FromDocumentType);
        ServCommentLine.SETRANGE("No.", FromNumber);
        IF ServCommentLine.FIND('-') THEN
            REPEAT
                ServCommentLine2.INIT;
                ServCommentLine2 := ServCommentLine;
                ServCommentLine2.Type := ToDocumentType;
                ServCommentLine2."No." := ToNumber;
                ServCommentLine2.INSERT;
            UNTIL ServCommentLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CopyServCommLinesToSale(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    var
        ServCommentLine: Record "25006148";
        SalesCommentLine: Record "44";
    begin
        ServCommentLine.SETRANGE(Type, FromDocumentType);
        ServCommentLine.SETRANGE("No.", FromNumber);
        IF ServCommentLine.FINDSET THEN
            REPEAT
                SalesCommentLine.INIT;
                SalesCommentLine."Document Type" := ToDocumentType;
                SalesCommentLine."No." := ToNumber;
                SalesCommentLine."Line No." := ServCommentLine."Line No.";
                SalesCommentLine.Date := ServCommentLine.Date;
                SalesCommentLine.Comment := ServCommentLine.Comment;
                SalesCommentLine.INSERT;
            UNTIL ServCommentLine.NEXT = 0;
    end;

    local procedure SumServiceLines(var NewServiceLine: Record "25006146"; var OldServiceLine: Record "25006146"; QtyType: Option General,Invoicing,Shipping; InsertServiceLine: Boolean; CalcAdCostLCY: Boolean; var TotalAdjCostLCY: Decimal)
    var
        ServiceLineQty: Decimal;
        AdjCostLCY: Decimal;
    begin
        TotalAdjCostLCY := 0;

        TempVATAmountLineRemainder.DELETEALL;
        OldServiceLine.CalcVATAmountLines(QtyType, ServiceHeaderGlobal, OldServiceLine, TempVATAmountLine);
        GLSetup.GET;
        SalesSetup.GET;
        GetCurrency;
        OldServiceLine.SETRANGE("Document Type", ServiceHeaderGlobal."Document Type");
        OldServiceLine.SETRANGE("Document No.", ServiceHeaderGlobal."No.");
        RoundingLineInserted := FALSE;
        IF OldServiceLine.FINDSET THEN
            REPEAT
                IF NOT RoundingLineInserted THEN
                    ServiceLineGlobal := OldServiceLine;
                CASE QtyType OF
                    QtyType::General:
                        ServiceLineQty := ServiceLineGlobal.Quantity;
                    QtyType::Invoicing:
                        ServiceLineQty := ServiceLineGlobal.Quantity;
                END;
                DivideAmount(QtyType, ServiceLineQty);
                ServiceLineGlobal.Quantity := ServiceLineQty;
                IF ServiceLineQty <> 0 THEN BEGIN
                    IF (ServiceLineGlobal.Amount <> 0) AND NOT RoundingLineInserted THEN
                        IF TotalServiceLine.Amount = 0 THEN
                            TotalServiceLine."VAT %" := ServiceLineGlobal."VAT %"
                        ELSE
                            IF TotalServiceLine."VAT %" <> ServiceLineGlobal."VAT %" THEN
                                TotalServiceLine."VAT %" := 0;
                    RoundAmount(ServiceLineQty);
                    ServiceLineGlobal := TempServiceLine;
                END;
                IF InsertServiceLine THEN BEGIN
                    NewServiceLine := ServiceLineGlobal;
                    NewServiceLine.INSERT;
                END;
                IF RoundingLineInserted THEN
                    LastLineRetrieved := TRUE
                ELSE BEGIN
                    LastLineRetrieved := OldServiceLine.NEXT = 0;
                    IF LastLineRetrieved AND SalesSetup."Invoice Rounding" THEN
                        InvoiceRounding(TRUE);
                END;
            UNTIL LastLineRetrieved;
    end;

    local procedure GetCurrency()
    begin
        IF ServiceHeaderGlobal."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
        ELSE BEGIN
            Currency.GET(ServiceHeaderGlobal."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
        END;
    end;

    local procedure DivideAmount(QtyType: Option General,Invoicing,Shipping; ServiceLineQty: Decimal)
    begin
        IF RoundingLineInserted AND (RoundingLineNo = ServiceLineGlobal."Line No.") THEN
            EXIT;
        IF ServiceLineQty = 0 THEN BEGIN
            "Line Amount" := 0;
            "Line Discount Amount" := 0;
            "VAT Base Amount" := 0;
            Amount := 0;
            "Amount Including VAT" := 0;
        END ELSE BEGIN
            TempVATAmountLine.GET("VAT Identifier", "VAT Calculation Type", "Tax Group Code", FALSE, "Line Amount" >= 0);
            IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN
                "VAT %" := TempVATAmountLine."VAT %";
            TempVATAmountLineRemainder := TempVATAmountLine;
            IF NOT TempVATAmountLineRemainder.FIND THEN BEGIN
                TempVATAmountLineRemainder.INIT;
                TempVATAmountLineRemainder.INSERT;
            END;
            "Line Amount" := ROUND(ServiceLineQty * "Unit Price", Currency."Amount Rounding Precision");
            IF ServiceLineQty <> Quantity THEN
                "Line Discount Amount" :=
                  ROUND("Line Amount" * "Line Discount %" / 100, Currency."Amount Rounding Precision");
            "Line Amount" := "Line Amount" - "Line Discount Amount";

            IF "Allow Invoice Disc." AND (TempVATAmountLine."Inv. Disc. Base Amount" <> 0) THEN
                IF NOT (QtyType = QtyType::Invoicing) THEN BEGIN
                    TempVATAmountLineRemainder."Invoice Discount Amount" :=
                      TempVATAmountLineRemainder."Invoice Discount Amount" +
                      TempVATAmountLine."Invoice Discount Amount" * "Line Amount" /
                      TempVATAmountLine."Inv. Disc. Base Amount";
                    TempVATAmountLineRemainder."Invoice Discount Amount" :=
                      TempVATAmountLineRemainder."Invoice Discount Amount";
                END;

            IF ServiceHeaderGlobal."Prices Including VAT" THEN BEGIN
                IF (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount" = 0) OR
                   ("Line Amount" = 0)
                THEN BEGIN
                    TempVATAmountLineRemainder."VAT Amount" := 0;
                    TempVATAmountLineRemainder."Amount Including VAT" := 0;
                END ELSE BEGIN
                    TempVATAmountLineRemainder."VAT Amount" :=
                      TempVATAmountLineRemainder."VAT Amount" +
                      TempVATAmountLine."VAT Amount" *
                      ("Line Amount") /
                      (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                    TempVATAmountLineRemainder."Amount Including VAT" :=
                      TempVATAmountLineRemainder."Amount Including VAT" +
                      TempVATAmountLine."Amount Including VAT" *
                      ("Line Amount") /
                      (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                END;
                "Amount Including VAT" :=
                  ROUND(TempVATAmountLineRemainder."Amount Including VAT", Currency."Amount Rounding Precision");
                Amount :=
                  ROUND("Amount Including VAT", Currency."Amount Rounding Precision") -
                  ROUND(TempVATAmountLineRemainder."VAT Amount", Currency."Amount Rounding Precision");
                "VAT Base Amount" :=
                  ROUND(
                    Amount * (1 - ServiceHeaderGlobal."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                TempVATAmountLineRemainder."Amount Including VAT" :=
                  TempVATAmountLineRemainder."Amount Including VAT" - "Amount Including VAT";
                TempVATAmountLineRemainder."VAT Amount" :=
                  TempVATAmountLineRemainder."VAT Amount" - "Amount Including VAT" + Amount;
            END ELSE BEGIN
                IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN BEGIN
                    "Amount Including VAT" := "Line Amount";
                    Amount := 0;
                    "VAT Base Amount" := 0;
                END ELSE BEGIN
                    Amount := "Line Amount";
                    "VAT Base Amount" :=
                      ROUND(
                        Amount * (1 - ServiceHeaderGlobal."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
                    IF TempVATAmountLine."VAT Base" = 0 THEN
                        TempVATAmountLineRemainder."VAT Amount" := 0
                    ELSE
                        TempVATAmountLineRemainder."VAT Amount" :=
                         TempVATAmountLineRemainder."VAT Amount" +
                         TempVATAmountLine."VAT Amount" *
                         ("Line Amount") /
                         (TempVATAmountLine."Line Amount" - TempVATAmountLine."Invoice Discount Amount");
                    "Amount Including VAT" :=
                      Amount + ROUND(TempVATAmountLineRemainder."VAT Amount", Currency."Amount Rounding Precision");
                    TempVATAmountLineRemainder."VAT Amount" :=
                      TempVATAmountLineRemainder."VAT Amount" - "Amount Including VAT" + Amount;
                END;
            END;

            TempVATAmountLineRemainder.MODIFY;
        END;
    end;

    local procedure RoundAmount(ServiceLineQty: Decimal)
    var
        NoVAT: Boolean;
    begin
        IncrAmount(TotalServiceLine);
        Increment(TotalServiceLine.Quantity, ServiceLineQty);
        TempServiceLine := ServiceLineGlobal;
        ServiceLineACY := ServiceLineGlobal;

        IF ServiceHeaderGlobal."Currency Code" <> '' THEN BEGIN
            IF (ServiceLineGlobal."Document Type" IN [ServiceLineGlobal."Document Type"::Quote]) AND
               (ServiceHeaderGlobal."Posting Date" = 0D)
            THEN
                UseDate := WORKDATE
            ELSE
                UseDate := ServiceHeaderGlobal."Posting Date";

            NoVAT := Amount = "Amount Including VAT";
            "Amount Including VAT" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, ServiceHeaderGlobal."Currency Code",
                  TotalServiceLine."Amount Including VAT", ServiceHeaderGlobal."Currency Factor")) -
                    TotalServiceLineLCY."Amount Including VAT";
            IF NoVAT THEN
                Amount := "Amount Including VAT"
            ELSE
                Amount :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, ServiceHeaderGlobal."Currency Code",
                      TotalServiceLine.Amount, ServiceHeaderGlobal."Currency Factor")) -
                        TotalServiceLineLCY.Amount;
            "Line Amount" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, ServiceHeaderGlobal."Currency Code",
                  TotalServiceLine."Line Amount", ServiceHeaderGlobal."Currency Factor")) -
                    TotalServiceLineLCY."Line Amount";
            "Line Discount Amount" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, ServiceHeaderGlobal."Currency Code",
                  TotalServiceLine."Line Discount Amount", ServiceHeaderGlobal."Currency Factor")) -
                    TotalServiceLineLCY."Line Discount Amount";
            "VAT Difference" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, ServiceHeaderGlobal."Currency Code",
                  TotalServiceLine."VAT Difference", ServiceHeaderGlobal."Currency Factor")) -
                    TotalServiceLineLCY."VAT Difference";
        END;

        IncrAmount(TotalServiceLineLCY);
        Increment(TotalServiceLineLCY."Unit Cost (LCY)", ROUND(ServiceLineQty * "Unit Cost (LCY)"));
    end;

    local procedure InvoiceRounding(UseTempData: Boolean)
    var
        InvoiceRoundingAmount: Decimal;
        NextLineNo: Integer;
    begin
        Currency.TESTFIELD("Invoice Rounding Precision");
        InvoiceRoundingAmount :=
          -ROUND(
            TotalServiceLine."Amount Including VAT" -
            ROUND(
              TotalServiceLine."Amount Including VAT",
              Currency."Invoice Rounding Precision",
              Currency.InvoiceRoundingDirection),
            Currency."Amount Rounding Precision");
        IF InvoiceRoundingAmount <> 0 THEN BEGIN
            CustPostingGr.GET(ServiceHeaderGlobal."Customer Posting Group");
            CustPostingGr.TESTFIELD("Invoice Rounding Account");
            ServiceLineGlobal.INIT;
            NextLineNo := "Line No." + 10000;
            "System-Created Entry" := TRUE;
            IF UseTempData THEN BEGIN
                "Line No." := 0;
                Type := Type::"G/L Account";
            END ELSE BEGIN
                "Line No." := NextLineNo;
                ServiceLineGlobal.VALIDATE(Type, Type::"G/L Account");
            END;
            ServiceLineGlobal.VALIDATE("No.", CustPostingGr."Invoice Rounding Account");
            ServiceLineGlobal.VALIDATE(Quantity, 1);
            IF ServiceHeaderGlobal."Prices Including VAT" THEN
                ServiceLineGlobal.VALIDATE("Unit Price", InvoiceRoundingAmount)
            ELSE
                ServiceLineGlobal.VALIDATE(
                  "Unit Price",
                  ROUND(
                    InvoiceRoundingAmount /
                    (1 + (1 - ServiceHeaderGlobal."VAT Base Discount %" / 100) * "VAT %" / 100),
                    Currency."Amount Rounding Precision"));
            ServiceLineGlobal.VALIDATE("Amount Including VAT", InvoiceRoundingAmount);
            "Line No." := NextLineNo;
            IF NOT UseTempData THEN BEGIN


            END;
            LastLineRetrieved := FALSE;
            RoundingLineInserted := TRUE;
            RoundingLineNo := "Line No.";
        END;
    end;

    local procedure IncrAmount(var TotalServiceLine: Record "25006146")
    begin
        IF ServiceHeaderGlobal."Prices Including VAT" OR
   ("VAT Calculation Type" <> "VAT Calculation Type"::"Full VAT")
THEN
            Increment(TotalServiceLine."Line Amount", "Line Amount");
        Increment(TotalServiceLine.Amount, Amount);
        Increment(TotalServiceLine."VAT Base Amount", "VAT Base Amount");
        Increment(TotalServiceLine."VAT Difference", "VAT Difference");
        Increment(TotalServiceLine."Amount Including VAT", "Amount Including VAT");
        Increment(TotalServiceLine."Line Discount Amount", "Line Discount Amount");
        Increment(TotalServiceLine."Inv. Discount Amount", "Inv. Discount Amount");
        Increment(TotalServiceLine."Inv. Disc. Amount to Invoice", "Inv. Disc. Amount to Invoice");

        //EDMS1.0.00 P3>>
        Increment(TotalServiceLine."Prepmt. Line Amount", "Prepmt. Line Amount");
        Increment(TotalServiceLine."Prepmt. Amt. Inv.", "Prepmt. Amt. Inv.");
        Increment(TotalServiceLine."Prepmt Amt to Deduct", "Prepmt Amt to Deduct");
        Increment(TotalServiceLine."Prepmt Amt Deducted", "Prepmt Amt Deducted");
        //EDMS1.0.00 P3>>
    end;

    local procedure Increment(var Number: Decimal; Number2: Decimal)
    begin
        Number := Number + Number2;
    end;

    [Scope('Internal')]
    procedure SumServiceLinesTemp(var NewServiceHeader: Record "25006145"; var OldServiceLine: Record "25006146"; QtyType: Option General,Invoicing,Shipping; var NewTotalServiceLine: Record "25006146"; var NewTotalServiceLineLCY: Record "25006146"; var VATAmount: Decimal; var VATAmountText: Text[30]; var ProfitLCY: Decimal; var ProfitPct: Decimal; var TotalAdjCostLCY: Decimal)
    var
        ServiceLine: Record "25006146";
    begin
        ServiceHeaderGlobal := NewServiceHeader;

        SumServiceLines(ServiceLine, OldServiceLine, QtyType, FALSE, TRUE, TotalAdjCostLCY);

        ProfitLCY := TotalServiceLineLCY.Amount - TotalServiceLineLCY."Unit Cost (LCY)";
        IF TotalServiceLineLCY.Amount = 0 THEN
            ProfitPct := 0
        ELSE
            ProfitPct := ROUND(ProfitLCY / TotalServiceLineLCY.Amount * 100, 0.1);
        VATAmount := TotalServiceLine."Amount Including VAT" - TotalServiceLine.Amount;
        IF TotalServiceLine."VAT %" = 0 THEN
            VATAmountText := Text016
        ELSE
            VATAmountText := STRSUBSTNO(Text017, TotalServiceLine."VAT %");
        NewTotalServiceLine := TotalServiceLine;
        NewTotalServiceLineLCY := TotalServiceLineLCY;
    end;

    [Scope('Internal')]
    procedure ModifyProcessChecklist(ServiceHdr: Record "25006145"; NewSourceType: Integer; NewSourceID: Code[20])
    var
        ProcessChecklistHdr: Record "25006025";
    begin
        ProcessChecklistHdr.RESET;
        ProcessChecklistHdr.SETCURRENTKEY("Source Type", "Source Subtype", "Source ID");
        ProcessChecklistHdr.SETRANGE("Source Type", DATABASE::"Service Header EDMS");
        ProcessChecklistHdr.SETRANGE("Source Subtype", ServiceHdr."Document Type");
        ProcessChecklistHdr.SETRANGE("Source ID", ServiceHdr."No.");
        IF ProcessChecklistHdr.FINDFIRST THEN
            REPEAT
                ProcessChecklistHdr."Source Type" := NewSourceType;
                ProcessChecklistHdr."Source Subtype" := 0;
                ProcessChecklistHdr."Source ID" := NewSourceID;
                ProcessChecklistHdr.MODIFY;
            UNTIL ProcessChecklistHdr.NEXT = 0;
    end;

    local procedure GetNextServiceLine(var ServiceLine: Record "25006146"): Boolean
    begin
        IF ServiceLine.NEXT = 1 THEN
            EXIT(FALSE);
        IF TempPrepaymentServiceLine.FINDFIRST THEN BEGIN
            ServiceLine := TempPrepaymentServiceLine;
            TempPrepaymentServiceLine.DELETE;
            EXIT(FALSE);
        END;
        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure CalculateAmountLCY(var ServJnlLine: Record "25006165"; ServiceHeader: Record "25006145"; ServiceLine: Record "25006146")
    var
        UseDate: Date;
    begin
        IF ServiceHeader."Currency Code" <> '' THEN BEGIN
            IF (ServiceHeader."Document Type" IN [ServiceHeader."Document Type"::Quote]) AND (ServiceHeader."Posting Date" = 0D) THEN
                UseDate := WORKDATE
            ELSE
                UseDate := ServiceHeader."Posting Date";

            ServJnlLine."Amount (LCY)" :=
                ROUND(
                     CurrExchRate.ExchangeAmtFCYToLCY(
                     UseDate, ServiceHeader."Currency Code",
                     ServiceLine.Amount, ServiceHeader."Currency Factor"));
            ServJnlLine."Amount Including VAT (LCY)" :=
                ROUND(
                     CurrExchRate.ExchangeAmtFCYToLCY(
                     UseDate, ServiceHeader."Currency Code",
                     ServiceLine."Amount Including VAT", ServiceHeader."Currency Factor"));
            ServJnlLine."Line Discount Amount (LCY)" :=
                ROUND(
                     CurrExchRate.ExchangeAmtFCYToLCY(
                     UseDate, ServiceHeader."Currency Code",
                     ServiceLine."Line Discount Amount", ServiceHeader."Currency Factor"));
            ServJnlLine."Inv. Discount Amount (LCY)" :=
                ROUND(
                     CurrExchRate.ExchangeAmtFCYToLCY(
                     UseDate, ServiceHeader."Currency Code",
                     ServiceLine."Inv. Discount Amount", ServiceHeader."Currency Factor"));
        END ELSE BEGIN
            ServJnlLine."Amount (LCY)" := ServiceLine.Amount;
            ServJnlLine."Amount Including VAT (LCY)" := ServiceLine."Amount Including VAT";
            ServJnlLine."Line Discount Amount (LCY)" := ServiceLine."Line Discount Amount";
            ServJnlLine."Inv. Discount Amount (LCY)" := ServiceLine."Inv. Discount Amount";
        END;

        IF ServiceHeader."Prices Including VAT" THEN BEGIN
            ServJnlLine."Line Discount Amount (LCY)" := ROUND(ServJnlLine."Line Discount Amount (LCY)" / (1 + ServiceLine."VAT %" / 100));
            ServJnlLine."Inv. Discount Amount (LCY)" := ROUND(ServJnlLine."Inv. Discount Amount (LCY)" / (1 + ServiceLine."VAT %" / 100));
        END;
    end;

    [Scope('Internal')]
    procedure ArchiveUnpostedOrder(ServiceHeader: Record "25006145")
    var
        ServiceLine: Record "25006146";
        ArchiveManagement: Codeunit "5063";
    begin
        IF NOT ServiceSetup."Archive Quotes and Orders" THEN
            EXIT;
        IF NOT (ServiceHeader."Document Type" IN [ServiceHeader."Document Type"::Order, ServiceHeader."Document Type"::"Return Order"])
        THEN
            EXIT;
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETFILTER(Quantity, '<>0');
        IF NOT ServiceLine.ISEMPTY THEN BEGIN
            ArchiveManagement.ArchServDocumentNoConfirm(ServiceHeader);
            //COMMIT;  // 30.07.2015 EB.P30 #T043
        END;
    end;

    [Scope('Internal')]
    procedure FillSalesVariableFields(var SalesHdr: Record "36"; ServiceHdr: Record "25006145")
    var
        VariableFieldUsage: Record "25006006";
        VariableFieldUsage2: Record "25006006";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        SalesHdr."Variable Field 25006800" := '';
        SalesHdr."Variable Field 25006801" := '';
        SalesHdr."Variable Field 25006802" := '';

        RecordRef.OPEN(DATABASE::"Service Header EDMS");
        RecordRef.GETTABLE(ServiceHdr);
        RecordRef2.OPEN(DATABASE::"Sales Header");
        RecordRef2.GETTABLE(SalesHdr);

        VariableFieldUsage.RESET;
        VariableFieldUsage.SETRANGE("Table No.", DATABASE::"Service Header EDMS");
        IF VariableFieldUsage.FINDFIRST THEN
            REPEAT
                VariableFieldUsage2.RESET;
                VariableFieldUsage2.SETRANGE("Table No.", DATABASE::"Sales Header");
                VariableFieldUsage2.SETRANGE("Variable Field Code", VariableFieldUsage."Variable Field Code");
                IF VariableFieldUsage2.FINDFIRST THEN BEGIN
                    FieldRef := RecordRef.FIELD(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.FIELD(VariableFieldUsage2."Field No.");
                    FieldRef2.VALUE(FieldRef.VALUE);
                END;
            UNTIL VariableFieldUsage.NEXT = 0;
        RecordRef2.SETTABLE(SalesHdr);
    end;

    [Scope('Internal')]
    procedure FillPstReturnVariableFields(var PstReturnOrdHeader: Record "25006154"; ServiceHdr: Record "25006145")
    var
        VariableFieldUsage: Record "25006006";
        VariableFieldUsage2: Record "25006006";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        PstReturnOrdHeader."Variable Field 25006800" := '';
        PstReturnOrdHeader."Variable Field 25006801" := '';
        PstReturnOrdHeader."Variable Field 25006802" := '';

        RecordRef.OPEN(DATABASE::"Service Header EDMS");
        RecordRef.GETTABLE(ServiceHdr);
        RecordRef2.OPEN(DATABASE::"Posted Serv. Ret. Order Header");
        RecordRef2.GETTABLE(PstReturnOrdHeader);

        VariableFieldUsage.RESET;
        VariableFieldUsage.SETRANGE("Table No.", DATABASE::"Service Header EDMS");
        IF VariableFieldUsage.FINDFIRST THEN
            REPEAT
                VariableFieldUsage2.RESET;
                VariableFieldUsage2.SETRANGE("Table No.", DATABASE::"Posted Serv. Ret. Order Header");
                VariableFieldUsage2.SETRANGE("Variable Field Code", VariableFieldUsage."Variable Field Code");
                IF VariableFieldUsage2.FINDFIRST THEN BEGIN
                    FieldRef := RecordRef.FIELD(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.FIELD(VariableFieldUsage2."Field No.");
                    FieldRef2.VALUE(FieldRef.VALUE);
                END;
            UNTIL VariableFieldUsage.NEXT = 0;
        RecordRef2.SETTABLE(PstReturnOrdHeader);
    end;

    [Scope('Internal')]
    procedure FillPstOrderVariableFields(var PstOrdHeader: Record "25006149"; ServiceHdr: Record "25006145")
    var
        VariableFieldUsage: Record "25006006";
        VariableFieldUsage2: Record "25006006";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        //PstOrdHeader."Variable Field 25006800" := ''; //Bishesh Jimba
        //PstOrdHeader."Variable Field 25006801" := ''; //Bishesh Jimba
        //PstOrdHeader."Variable Field 25006802" := ''; //Bishesh Jimba

        RecordRef.OPEN(DATABASE::"Service Header EDMS");
        RecordRef.GETTABLE(ServiceHdr);
        RecordRef2.OPEN(DATABASE::"Posted Serv. Order Header");
        RecordRef2.GETTABLE(PstOrdHeader);

        VariableFieldUsage.RESET;
        VariableFieldUsage.SETRANGE("Table No.", DATABASE::"Service Header EDMS");
        IF VariableFieldUsage.FINDFIRST THEN
            REPEAT
                VariableFieldUsage2.RESET;
                VariableFieldUsage2.SETRANGE("Table No.", DATABASE::"Posted Serv. Order Header");
                VariableFieldUsage2.SETRANGE("Variable Field Code", VariableFieldUsage."Variable Field Code");
                IF VariableFieldUsage2.FINDFIRST THEN BEGIN
                    FieldRef := RecordRef.FIELD(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.FIELD(VariableFieldUsage2."Field No.");
                    FieldRef2.VALUE(FieldRef.VALUE);
                END;
            UNTIL VariableFieldUsage.NEXT = 0;
        RecordRef2.SETTABLE(PstOrdHeader);
    end;

    [Scope('Internal')]
    procedure FillSalesLineVariableFields(var SalesLine: Record "37"; ServiceLine: Record "25006146")
    var
        VariableFieldUsage: Record "25006006";
        VariableFieldUsage2: Record "25006006";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        SalesLine."Variable Field 25006800" := '';
        SalesLine."Variable Field 25006801" := '';
        SalesLine."Variable Field 25006802" := '';

        RecordRef.OPEN(DATABASE::"Service Line EDMS");
        RecordRef.GETTABLE(ServiceLine);
        RecordRef2.OPEN(DATABASE::"Sales Line");
        RecordRef2.GETTABLE(SalesLine);

        VariableFieldUsage.RESET;
        VariableFieldUsage.SETRANGE("Table No.", DATABASE::"Service Line EDMS");
        IF VariableFieldUsage.FINDFIRST THEN
            REPEAT
                VariableFieldUsage2.RESET;
                VariableFieldUsage2.SETRANGE("Table No.", DATABASE::"Sales Line");
                VariableFieldUsage2.SETRANGE("Variable Field Code", VariableFieldUsage."Variable Field Code");
                IF VariableFieldUsage2.FINDFIRST THEN BEGIN
                    FieldRef := RecordRef.FIELD(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.FIELD(VariableFieldUsage2."Field No.");
                    FieldRef2.VALUE(FieldRef.VALUE);
                END;
            UNTIL VariableFieldUsage.NEXT = 0;
        RecordRef2.SETTABLE(SalesLine);
    end;

    [Scope('Internal')]
    procedure FillPstReturnLineVarFields(var PstReturnOrdLine: Record "25006155"; ServiceLine: Record "25006146")
    var
        VariableFieldUsage: Record "25006006";
        VariableFieldUsage2: Record "25006006";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        PstReturnOrdLine."Variable Field 25006800" := '';
        PstReturnOrdLine."Variable Field 25006801" := '';
        PstReturnOrdLine."Variable Field 25006802" := '';

        RecordRef.OPEN(DATABASE::"Service Line EDMS");
        RecordRef.GETTABLE(ServiceLine);
        RecordRef2.OPEN(DATABASE::"Posted Serv. Return Order Line");
        RecordRef2.GETTABLE(PstReturnOrdLine);

        VariableFieldUsage.RESET;
        VariableFieldUsage.SETRANGE("Table No.", DATABASE::"Service Line EDMS");
        IF VariableFieldUsage.FINDFIRST THEN
            REPEAT
                VariableFieldUsage2.RESET;
                VariableFieldUsage2.SETRANGE("Table No.", DATABASE::"Posted Serv. Return Order Line");
                VariableFieldUsage2.SETRANGE("Variable Field Code", VariableFieldUsage."Variable Field Code");
                IF VariableFieldUsage2.FINDFIRST THEN BEGIN
                    FieldRef := RecordRef.FIELD(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.FIELD(VariableFieldUsage2."Field No.");
                    FieldRef2.VALUE(FieldRef.VALUE);
                END;
            UNTIL VariableFieldUsage.NEXT = 0;
        RecordRef2.SETTABLE(PstReturnOrdLine);
    end;

    [Scope('Internal')]
    procedure FillPstOrderLineVariableFields(var PstOrdLine: Record "25006150"; ServiceLine: Record "25006146")
    var
        VariableFieldUsage: Record "25006006";
        VariableFieldUsage2: Record "25006006";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        PstOrdLine."Variable Field 25006800" := '';
        PstOrdLine."Variable Field 25006801" := '';
        PstOrdLine."Variable Field 25006802" := '';

        RecordRef.OPEN(DATABASE::"Service Line EDMS");
        RecordRef.GETTABLE(ServiceLine);
        RecordRef2.OPEN(DATABASE::"Posted Serv. Order Line");
        RecordRef2.GETTABLE(PstOrdLine);

        VariableFieldUsage.RESET;
        VariableFieldUsage.SETRANGE("Table No.", DATABASE::"Service Line EDMS");
        IF VariableFieldUsage.FINDFIRST THEN
            REPEAT
                VariableFieldUsage2.RESET;
                VariableFieldUsage2.SETRANGE("Table No.", DATABASE::"Posted Serv. Order Line");
                VariableFieldUsage2.SETRANGE("Variable Field Code", VariableFieldUsage."Variable Field Code");
                IF VariableFieldUsage2.FINDFIRST THEN BEGIN
                    FieldRef := RecordRef.FIELD(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.FIELD(VariableFieldUsage2."Field No.");
                    FieldRef2.VALUE(FieldRef.VALUE);
                END;
            UNTIL VariableFieldUsage.NEXT = 0;
        RecordRef2.SETTABLE(PstOrdLine);
    end;

    [Scope('Internal')]
    procedure FillServJournalVariableFields(var ServJournalLine: Record "25006165"; ServiceLine: Record "25006146")
    var
        VariableFieldUsage: Record "25006006";
        VariableFieldUsage2: Record "25006006";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        ServJournalLine."Variable Field 25006800" := '';
        ServJournalLine."Variable Field 25006801" := '';
        ServJournalLine."Variable Field 25006802" := '';

        RecordRef.OPEN(DATABASE::"Service Line EDMS");
        RecordRef.GETTABLE(ServiceLine);
        RecordRef2.OPEN(DATABASE::"Serv. Journal Line");
        RecordRef2.GETTABLE(ServJournalLine);

        VariableFieldUsage.RESET;
        VariableFieldUsage.SETRANGE("Table No.", DATABASE::"Service Line EDMS");
        IF VariableFieldUsage.FINDFIRST THEN
            REPEAT
                VariableFieldUsage2.RESET;
                VariableFieldUsage2.SETRANGE("Table No.", DATABASE::"Serv. Journal Line");
                VariableFieldUsage2.SETRANGE("Variable Field Code", VariableFieldUsage."Variable Field Code");
                IF VariableFieldUsage2.FINDFIRST THEN BEGIN
                    FieldRef := RecordRef.FIELD(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.FIELD(VariableFieldUsage2."Field No.");
                    FieldRef2.VALUE(FieldRef.VALUE);
                END;
            UNTIL VariableFieldUsage.NEXT = 0;
        RecordRef2.SETTABLE(ServJournalLine);
    end;

    [Scope('Internal')]
    procedure SumServiceLines2(var NewServHeader: Record "25006145"; QtyType: Option General,Invoicing,Shipping; var NewTotalServLine: Record "25006146"; var NewTotalServLineLCY: Record "25006146"; var VATAmount: Decimal; var VATAmountText: Text[30]; var ProfitLCY: Decimal; var ProfitPct: Decimal; var TotalAdjCostLCY: Decimal)
    var
        OldServLine: Record "25006146";
    begin
        SumServiceLinesTemp(
          NewServHeader, OldServLine, QtyType, NewTotalServLine, NewTotalServLineLCY,
          VATAmount, VATAmountText, ProfitLCY, ProfitPct, TotalAdjCostLCY);
    end;

    [Scope('Internal')]
    procedure CreateToDoFromService(PstServiceHeader: Record "25006149")
    var
        ToDo: Record "5080";
    begin
        ServiceSetup.GET;
        IF NOT ServiceSetup."Create To-do After Posting" THEN
            EXIT;

        ToDo.INIT;
        ToDo."No." := '';
        ToDo.INSERT(TRUE);
        ToDo.VALIDATE(Type, ToDo.Type::"Phone Call");
        ToDo.VALIDATE("Interaction Template Code", ServiceSetup."To-do Interaction Template");
        ToDo.VALIDATE("Salesperson Code", PstServiceHeader."Service Advisor");
        ToDo.VALIDATE("Contact No.", PstServiceHeader."Sell-to Contact No.");
        ToDo.VALIDATE(Date, CALCDATE(ServiceSetup."To-do Date Formula", PstServiceHeader."Posting Date"));
        ToDo.VALIDATE(Description, COPYSTR(ToDo.Description + ';' + PstServiceHeader."No." + ' ' + PstServiceHeader.Description,
                                           1, MAXSTRLEN(ToDo.Description)));
        ToDo.VALIDATE(Location, PstServiceHeader."Location Code");
        ToDo.VALIDATE("Vehicle Serial No.", PstServiceHeader."Vehicle Serial No.");
        ToDo."Service Source Type" := DATABASE::"Posted Serv. Order Header";
        ToDo."Service Source ID" := PstServiceHeader."No.";
        ToDo.MODIFY;
    end;

    [Scope('Internal')]
    procedure CheckFullyReservedToInventory(ServiceHeader: Record "25006145")
    var
        ServiceLine: Record "25006146";
        Text001: Label 'Items on Service Lines are not fully transfered to service location';
    begin
        IF ServiceHeader."Document Type" <> ServiceHeader."Document Type"::Order THEN
            EXIT;
        ServiceLine.RESET;
        ServiceLine.SETCURRENTKEY(Type, "No.");
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETRANGE(Type, ServiceLine.Type::Item);
        IF ServiceLine.FINDFIRST THEN
            REPEAT
                IF NOT ServiceLine.FullyReservedToInventory THEN
                    ERROR(Text001);
            UNTIL ServiceLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CheckServiceHeader(ServiceHeader: Record "25006145")
    var
        TransferHeader: Record "5740";
    begin
        IF NOT ServiceHeader."Km Error" THEN BEGIN
            ServiceHeader."Km Error" := TRUE;
            ServiceHeader.MODIFY;
            COMMIT;
            ERROR('Please Verify the KM.');
        END;
        IF ServiceHeader."RV RR Code" = ServiceHeader."RV RR Code"::" " THEN //PSF1.0
            ServiceHeader.verifyIfItsRepatAlreadyDOC(ServiceHeader);

        IF ServiceHeader."Document Type" = ServiceHeader."Document Type"::Order THEN BEGIN
            ServiceSetup.GET;
            IF ServiceSetup."Fully Transfered Mandatory" THEN
                CheckFullyReservedToInventory(ServiceHeader);
        END;
        //17.04.2014 Elva Baltic P1 #RX MMG7.00 >>
        TransferHeader.RESET;
        TransferHeader.SETRANGE("Document Profile", TransferHeader."Document Profile"::Service);
        TransferHeader.SETRANGE("Source Type", DATABASE::"Service Header EDMS");
        TransferHeader.SETRANGE("Source Subtype", ServiceHeader."Document Type");
        TransferHeader.SETRANGE("Source No.", ServiceHeader."No.");
        IF TransferHeader.FINDFIRST THEN
            ERROR(Text101, ServiceHeader."Document Type", ServiceHeader."No.");
        //17.04.2014 Elva Baltic P1 #RX MMG7.00 <<

        /*
        ServiceHeader.CALCFIELDS("Amount Including VAT");
        IF BlanceLCYcheckForPaymentMethodCode(ServiceHeader."Sell-to Customer No.",ServiceHeader."Amount Including VAT") THEN
          ServiceHeader.TESTFIELD("Payment Terms Code");
          */

        IF (ServiceHeader."Posting Date" - "Arrival Date") > 0 THEN //PSF
            ServiceHeader.TESTFIELD("Delay Reason Code");

        IF "RV RR Code" <> "RV RR Code"::" " THEN
            ServiceHeader.TESTFIELD("Revisit Repair Reason"); //psf

        verifyIfDefectExists(ServiceHeader."No.");

    end;

    [Scope('Internal')]
    procedure FillDetServJnlByResource(ServJournalLine: Record "25006165"; DocType: Integer; DocNo: Code[20]; LineNo: Integer; ModeParams: Text[30])
    var
        ServLaborAllocApplication: Record "25006277";
        ServLaborAllocEntry: Record "25006271";
        ServLaborAllocEntry2: Record "25006271";
        DetServJournalLine: Record "25006187";
        ServiceHeaderLoc: Record "25006145";
        ServiceLineLoc: Record "25006146";
        PostedServOrderHeaderLoc: Record "25006149";
        PostedServOrderLineLoc: Record "25006150";
        DetservJnlLineStep: Integer;
        DetservJnlLineNo: Integer;
        DoLookHeaderResources: Boolean;
        DoLookLineResources: Boolean;
        DoLookHeaderPosted: Boolean;
        QuantityLine: Decimal;
        QuantityHeader: Decimal;
        QuantitySum: Decimal;
        AllocTotalTimeSpent: Decimal;
        Resource: Record "156";
        ResourceQuantitySum: Decimal;
        TotalResourceCountLine: Integer;
        QuantityLineCoef: Decimal;
        QuantityHeaderCoef: Decimal;
        TotalTimeSpentSum: Decimal;
        AllocTotalTimeSpentResource: Decimal;
    begin
        ClearDetServJnlOfLine(ServJournalLine);
        IF ServJournalLine.Type <> ServJournalLine.Type::Labor THEN
            EXIT;
        DoLookLineResources := TRUE;
        IF STRLEN(ModeParams) > 0 THEN
            EVALUATE(DoLookHeaderResources, COPYSTR(ModeParams, 1, 1));
        IF STRLEN(ModeParams) > 1 THEN
            EVALUATE(DoLookLineResources, COPYSTR(ModeParams, 2, 1));
        IF STRLEN(ModeParams) > 2 THEN
            EVALUATE(DoLookHeaderPosted, COPYSTR(ModeParams, 3, 1));

        DetservJnlLineStep := 10000;
        ServLaborAllocApplication.RESET;
        ServLaborAllocApplication.SETRANGE("Document Type", DocType);
        ServLaborAllocApplication.SETRANGE("Document No.", DocNo);
        ServLaborAllocApplication.SETRANGE("Document Line No.", LineNo);
        IF (DoLookHeaderResources AND DoLookLineResources) THEN BEGIN
            ServLaborAllocApplication.SETFILTER("Document Line No.", '=0|' + FORMAT(LineNo));
        END ELSE BEGIN
            IF DoLookHeaderResources THEN
                ServLaborAllocApplication.SETRANGE("Document Line No.", 0);
        END;
        DetservJnlLineNo := 0;
        IF ServLaborAllocApplication.FINDFIRST THEN BEGIN

            // part to define quantity of header
            IF DoLookHeaderPosted THEN BEGIN
                IF PostedServOrderHeaderLoc.GET(DocNo) THEN BEGIN
                    PostedServOrderLineLoc.SETRANGE("Document No.", DocNo);
                    PostedServOrderLineLoc.SETRANGE(Type, PostedServOrderLineLoc.Type::Labor);
                    IF PostedServOrderLineLoc.FINDFIRST THEN
                        REPEAT
                            QuantityHeader += PostedServOrderLineLoc.Quantity;
                        UNTIL PostedServOrderLineLoc.NEXT = 0;
                END;
            END ELSE BEGIN
                IF ServiceHeaderLoc.GET(DocType, DocNo) THEN BEGIN
                    ServiceLineLoc.SETRANGE("Document Type", DocType);
                    ServiceLineLoc.SETRANGE("Document No.", DocNo);
                    ServiceLineLoc.SETRANGE(Type, ServiceLineLoc.Type::Labor);
                    IF ServiceLineLoc.FINDFIRST THEN
                        REPEAT
                            QuantityHeader += ServiceLineLoc.Quantity;
                        UNTIL ServiceLineLoc.NEXT = 0;
                END;
            END;

            REPEAT
                TotalTimeSpentSum := 0;

                DetservJnlLineNo += DetservJnlLineStep;
                DetServJournalLine.INIT;
                DetServJournalLine."Journal Template Name" := ServJournalLine."Journal Template Name";
                DetServJournalLine."Journal Batch Name" := ServJournalLine."Journal Batch Name";
                DetServJournalLine."Journal Line No." := ServJournalLine."Line No.";
                DetServJournalLine."Line No." := DetservJnlLineNo;
                DetServJournalLine."Resource No." := ServLaborAllocApplication."Resource No.";
                DetServJournalLine."Unit Cost" := ServLaborAllocApplication."Unit Cost";

                //IF ServLaborAllocEntry.GET("Allocation Entry No.") THEN;
                //ServLaborAllocEntry.CALCFIELDS("Total Time Spent","Total Time Spent Travel");  //time spent for one resource from time reg entries

                //TotalTimeSpentLine := GetAllocTotalTimeSpent(DocType,DocNo,LineNo); //Summ Application entries for line
                //TotalTimeSpentLineTravel := GetAllocTotalTimeSpentTravel(DocType,DocNo,LineNo);//Summ Application travel entries for line
                TotalResourceCountLine := GetAllocResourceCountLine(DocType, DocNo, LineNo); //Resource count on line
                QuantityLine := ABS(ServJournalLine."Quantity (Hours)"); //Quantity on line for coef
                QuantitySum := GetQuantityOfLinesInAlloc(ServLaborAllocApplication, DoLookHeaderPosted, ServJournalLine."Quantity (Hours)"); //Quantity summed for coef
                IF QuantitySum = 0 THEN
                    QuantitySum := QuantityLine;

                //20.12.2016 EB.RC DMS bug corrected >>
                IF QuantitySum = 0 THEN
                    QuantityLineCoef := 0
                ELSE
                    QuantityLineCoef := QuantityLine / QuantitySum;
                //20.12.2016 EB.RC DMS bug corrected <<

                IF QuantityHeader = 0 THEN
                    QuantityHeader := QuantityLine;
                QuantityHeaderCoef := QuantityLine / QuantityHeader;

                IF ServLaborAllocApplication."Document Line No." <> 0 THEN BEGIN
                    //Line Allocations
                    IF ServLaborAllocEntry.GET(ServLaborAllocApplication."Allocation Entry No.") THEN BEGIN
                        IF GetApplicationCount(ServLaborAllocApplication."Allocation Entry No.") > 1 THEN BEGIN
                            AllocTotalTimeSpent := GetAllocTotalTimeSpent(ServLaborAllocApplication."Allocation Entry No.");
                            TotalTimeSpentSum := AllocTotalTimeSpent * QuantityLineCoef;
                        END ELSE BEGIN
                            IF ServLaborAllocApplication."Allocation Entry No." <> 0 THEN BEGIN
                                ServLaborAllocEntry2.GET(ServLaborAllocApplication."Allocation Entry No.");
                                ServLaborAllocEntry2.CALCFIELDS("Total Time Spent", "Total Time Spent Travel");
                                TotalTimeSpentSum := ServLaborAllocEntry2."Total Time Spent" + ServLaborAllocEntry2."Total Time Spent Travel"; //Manual time + Time Reg Entries
                            END ELSE
                                TotalTimeSpentSum := ServLaborAllocApplication."Finished Quantity (Hours)";
                        END;
                    END ELSE BEGIN
                        TotalTimeSpentSum := ServLaborAllocApplication."Finished Quantity (Hours)";
                    END;
                END ELSE BEGIN
                    //Header Allocation
                    IF ServLaborAllocApplication."Allocation Entry No." <> 0 THEN BEGIN
                        ServLaborAllocEntry2.GET(ServLaborAllocApplication."Allocation Entry No.");
                        ServLaborAllocEntry2.CALCFIELDS("Total Time Spent", "Total Time Spent Travel");
                        TotalTimeSpentSum := (ServLaborAllocEntry2."Total Time Spent" + ServLaborAllocEntry2."Total Time Spent Travel") * QuantityHeaderCoef;
                    END ELSE
                        TotalTimeSpentSum := ServLaborAllocApplication."Finished Quantity (Hours)" * QuantityHeaderCoef;
                END;

                IF NOT (TotalTimeSpentSum = 0) THEN BEGIN
                    IF ServLaborAllocApplication.Travel THEN
                        DetServJournalLine."Finished Qty. (Hours) Travel" := TotalTimeSpentSum
                    ELSE
                        DetServJournalLine."Finished Quantity (Hours)" := TotalTimeSpentSum;
                    DetServJournalLine."Quantity (Hours)" := TotalTimeSpentSum;
                END ELSE BEGIN
                    IF TotalResourceCountLine <> 0 THEN BEGIN //20.12.2016 EB.RC DMS bug corrected
                        DetServJournalLine."Finished Quantity (Hours)" := QuantityLine / TotalResourceCountLine;
                        DetServJournalLine."Quantity (Hours)" := QuantityLine / TotalResourceCountLine;
                    END; //20.12.2016 EB.RC DMS bug corrected
                END;

                DetServJournalLine."Cost Amount" := DetServJournalLine."Finished Quantity (Hours)" * ServLaborAllocApplication."Unit Cost";
                DetServJournalLine.INSERT;
            UNTIL ServLaborAllocApplication.NEXT = 0;

            //23.03.2016 EB.P7 #Correct Rounded Resource Quantity >>
            ResourceQuantitySum := 0;
            DetServJournalLine.RESET;
            DetServJournalLine.SETRANGE("Journal Template Name", ServJournalLine."Journal Template Name");
            DetServJournalLine.SETRANGE("Journal Batch Name", ServJournalLine."Journal Batch Name");
            DetServJournalLine.SETRANGE("Journal Line No.", ServJournalLine."Line No.");
            IF DetServJournalLine.FINDFIRST THEN
                REPEAT
                    ResourceQuantitySum += DetServJournalLine."Quantity (Hours)";
                UNTIL DetServJournalLine.NEXT = 0;

            IF ServJournalLine."Quantity (Hours)" - ResourceQuantitySum > 0 THEN
                IF DetServJournalLine.FINDLAST THEN BEGIN
                    DetServJournalLine."Quantity (Hours)" += ServJournalLine."Quantity (Hours)" - ResourceQuantitySum;
                    ServLaborAllocApplication.MODIFY;
                END;

            //23.03.2016 EB.P7 #Correct Rounded Resource Quantity <<


        END;
    end;

    [Scope('Internal')]
    procedure ClearDetServJnlOfLine(ServJournalLine: Record "25006165")
    var
        ServLaborAllocApplication: Record "25006277";
        DetServJournalLine: Record "25006187";
        DetservJnlLineStep: Integer;
        DetservJnlLineNo: Integer;
        DoLookHeaderResources: Boolean;
    begin
        DetServJournalLine.RESET;
        DetServJournalLine.SETRANGE("Journal Template Name", ServJournalLine."Journal Template Name");
        DetServJournalLine.SETRANGE("Journal Batch Name", ServJournalLine."Journal Batch Name");
        DetServJournalLine.SETRANGE("Journal Line No.", ServJournalLine."Line No.");
        DetServJournalLine.DELETEALL;
    end;

    [Scope('Internal')]
    procedure GetQuantityOfLinesInAlloc(ServLaborAllocApplicationPar: Record "25006277"; DoLookHeaderPosted: Boolean; CurrentLineQty: Decimal) RetValue: Decimal
    var
        ServLaborAllocApplication: Record "25006277";
        ServiceLine: Record "25006146";
        PostedServOrderLineLoc: Record "25006150";
    begin
        IF ServLaborAllocApplicationPar."Allocation Entry No." = 0 THEN
            EXIT(CurrentLineQty);
        IF NOT (ServLaborAllocApplication."Document Type" IN [0, 1]) THEN
            EXIT(0);
        ServLaborAllocApplication.RESET;
        ServLaborAllocApplication.SETRANGE("Allocation Entry No.", ServLaborAllocApplicationPar."Allocation Entry No.");
        IF ServLaborAllocApplication.FINDFIRST THEN
            REPEAT
                IF DoLookHeaderPosted THEN BEGIN
                    PostedServOrderLineLoc.SETRANGE("Document No.", ServLaborAllocApplication."Document No.");
                    PostedServOrderLineLoc.SETRANGE(Type, PostedServOrderLineLoc.Type::Labor);
                    PostedServOrderLineLoc.SETRANGE("Line No.", ServLaborAllocApplication."Document Line No.");
                    IF PostedServOrderLineLoc.FINDFIRST THEN
                        REPEAT
                            RetValue += PostedServOrderLineLoc."Quantity (Hours)";
                        UNTIL PostedServOrderLineLoc.NEXT = 0;
                END ELSE BEGIN
                    ServiceLine.SETRANGE("Document Type", ServLaborAllocApplication."Document Type");
                    ServiceLine.SETRANGE("Document No.", ServLaborAllocApplication."Document No.");
                    ServiceLine.SETRANGE(Type, ServiceLine.Type::Labor);
                    ServiceLine.SETRANGE("Line No.", ServLaborAllocApplication."Document Line No.");
                    IF ServiceLine.FINDFIRST THEN
                        REPEAT
                            RetValue += ServiceLine."Quantity (Hours)";
                        UNTIL ServiceLine.NEXT = 0;
                END;
            UNTIL ServLaborAllocApplication.NEXT = 0;

        EXIT(RetValue);
    end;

    local procedure CheckDim(ServiceHeader: Record "25006145")
    var
        ServiceLineLoc: Record "25006146";
    begin
        //25.10.2013 EDMS P8 >>
        IF (ServiceHeader."Document Type" <> ServiceHeaderGlobal."Document Type") OR
            (ServiceHeaderGlobal."No." <> ServiceHeader."No.") THEN
            ServiceHeaderGlobal.GET(ServiceHeader."Document Type", ServiceHeader."No.");
        ServiceLineLoc."Line No." := 0;
        CheckDimValuePosting(ServiceLineLoc);
        CheckDimComb(ServiceLineLoc);

        ServiceLineLoc.SETRANGE("Document Type", ServiceHeaderGlobal."Document Type");
        ServiceLineLoc.SETRANGE("Document No.", ServiceHeaderGlobal."No.");
        ServiceLineLoc.SETFILTER(Type, '<>%1', ServiceLineLoc.Type::" ");
        IF ServiceLineLoc.FINDSET THEN
            REPEAT
                CheckDimComb(ServiceLineLoc);
                CheckDimValuePosting(ServiceLineLoc);
            UNTIL ServiceLineLoc.NEXT = 0;
    end;

    local procedure CheckDimComb(ServiceLinePar: Record "25006146")
    var
        DimMgt: Codeunit "408";
    begin
        IF ServiceLinePar."Line No." = 0 THEN
            IF NOT DimMgt.CheckDimIDComb(ServiceHeaderGlobal."Dimension Set ID") THEN
                ERROR(
                  Text028,
                  ServiceHeaderGlobal."Document Type", ServiceHeaderGlobal."No.", DimMgt.GetDimCombErr);

        IF ServiceLinePar."Line No." <> 0 THEN
            IF NOT DimMgt.CheckDimIDComb(ServiceLinePar."Dimension Set ID") THEN
                ERROR(
                  Text029,
                  ServiceHeaderGlobal."Document Type", ServiceHeaderGlobal."No.", ServiceLinePar."Line No.", DimMgt.GetDimCombErr);
    end;

    local procedure CheckDimValuePosting(var ServiceLinePar: Record "25006146")
    var
        TableIDArr: array[10] of Integer;
        NumberArr: array[10] of Code[20];
        DimMgt: Codeunit "408";
    begin
        IF ServiceLinePar."Line No." = 0 THEN BEGIN
            TableIDArr[1] := DATABASE::"Vehicle Status";
            NumberArr[1] := ServiceHeaderGlobal."Vehicle Status Code";
            TableIDArr[2] := DATABASE::Customer;
            NumberArr[2] := ServiceHeaderGlobal."Bill-to Customer No.";
            TableIDArr[3] := DATABASE::"Salesperson/Purchaser";
            NumberArr[3] := ServiceHeaderGlobal."Service Person";
            TableIDArr[4] := DATABASE::"Responsibility Center";
            NumberArr[4] := ServiceHeaderGlobal."Responsibility Center";
            TableIDArr[5] := DATABASE::"Deal Type";
            NumberArr[5] := ServiceHeaderGlobal."Deal Type";
            TableIDArr[6] := DATABASE::Vehicle;
            NumberArr[6] := ServiceHeaderGlobal.VIN;
            TableIDArr[7] := DATABASE::Make;
            NumberArr[7] := ServiceHeaderGlobal."Make Code";
            TableIDArr[8] := DATABASE::Vehicle;
            NumberArr[8] := ServiceHeaderGlobal."Vehicle Serial No.";
            IF NOT DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, ServiceHeaderGlobal."Dimension Set ID") THEN
                ERROR(
                  Text030,
                  ServiceHeaderGlobal."Document Type", ServiceHeaderGlobal."No.", DimMgt.GetDimValuePostingErr);
        END ELSE BEGIN
            TableIDArr[1] := DATABASE::"Responsibility Center";
            NumberArr[1] := ServiceLinePar."Responsibility Center";
            TableIDArr[2] := DimMgt.TypeToTableID5(ServiceLinePar.Type);
            NumberArr[2] := ServiceLinePar."No.";
            TableIDArr[3] := DATABASE::Vehicle;
            NumberArr[3] := ServiceLinePar."Vehicle Serial No.";

            IF NOT DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, ServiceLinePar."Dimension Set ID") THEN
                ERROR(
                  Text031,
                  ServiceLinePar."Document Type", ServiceLinePar."Document No.", ServiceLinePar."Line No.", DimMgt.GetDimValuePostingErr);
        END;
    end;

    local procedure GetAllocTotalTimeSpent(AllocationEntryNo: Integer) TotalTimeSpent: Decimal
    var
        ServLaborAllocApplication: Record "25006277";
        ServLaborAllocEntry: Record "25006271";
    begin
        IF ServLaborAllocEntry.GET(AllocationEntryNo) THEN BEGIN
            ServLaborAllocEntry.CALCFIELDS("Total Time Spent", "Total Time Spent Travel");
            TotalTimeSpent := ServLaborAllocEntry."Total Time Spent" + ServLaborAllocEntry."Total Time Spent Travel";
        END;

        // ServLaborAllocApplication.RESET;
        // ServLaborAllocApplication.SETRANGE("Allocation Entry No.",AllocationEntryNo);
        // IF ServLaborAllocApplication.FINDFIRST THEN
        //  REPEAT
        //    TotalTimeSpent += ServLaborAllocApplication."Finished Quantity (Hours)";
        //  UNTIL ServLaborAllocApplication.NEXT = 0;
    end;

    local procedure GetAllocResourceCountLine(DocType: Integer; DocNo: Code[20]; LineNo: Integer) ResourceCount: Decimal
    var
        LaborAllocEntry: Record "25006271";
        ServLaborAllocApplication: Record "25006277";
    begin
        ServLaborAllocApplication.SETRANGE("Document Type", DocType);
        ServLaborAllocApplication.SETRANGE("Document No.", DocNo);
        ServLaborAllocApplication.SETRANGE("Document Line No.", LineNo);
        ResourceCount := ServLaborAllocApplication.COUNT;
    end;

    local procedure GetAllocResourceCountHead(DocType: Integer; DocNo: Code[20]) ResourceCount: Decimal
    var
        LaborAllocEntry: Record "25006271";
        ServLaborAllocApplication: Record "25006277";
    begin
        ServLaborAllocApplication.SETRANGE("Document Type", DocType);
        ServLaborAllocApplication.SETRANGE("Document No.", DocNo);
        ServLaborAllocApplication.SETRANGE("Document Line No.", 0);
        ResourceCount := ServLaborAllocApplication.COUNT;
    end;

    local procedure GetApplicationCount(AllocationEntryNo: Integer) ResourceCount: Decimal
    var
        LaborAllocEntry: Record "25006271";
        ServLaborAllocApplication: Record "25006277";
    begin
        ServLaborAllocApplication.SETRANGE("Allocation Entry No.", AllocationEntryNo);
        ServLaborAllocApplication.SETFILTER("Allocation Entry No.", '<>%1', 0);
        ResourceCount := ServLaborAllocApplication.COUNT;
    end;

    local procedure UpdateConsumptionChecklist(JobNo: Code[20]; PostingNo: Code[20])
    var
        ConsumptionChecklist: Record "33020528";
    begin
        ConsumptionChecklist.RESET;
        ConsumptionChecklist.SETRANGE("Job Card No.", JobNo);
        IF ConsumptionChecklist.FINDSET THEN
            REPEAT
                ConsumptionChecklist."Posted Job Card No." := PostingNo;
                ConsumptionChecklist.MODIFY;
            UNTIL ConsumptionChecklist.NEXT = 0;
    end;

    local procedure BlanceLCYcheckForPaymentMethodCode(CusNo: Code[20]; BillAmt: Decimal): Boolean
    var
        CustRec: Record "18";
    begin
        IF CustRec.GET(CusNo) THEN BEGIN
            CustRec.CALCFIELDS("Balance (LCY)");
            IF (CustRec."Balance (LCY)" < 0) AND (CustRec."Balance (LCY)" < BillAmt) THEN
                EXIT(TRUE);
        END;
    end;

    local procedure postIntoPSFHistory(ServHdr: Record "25006145")
    var
        PSFHistory: Record "14125605";
        ServLine: Record "25006146";
        PartsAmt: Decimal;
        LaborAmt: Decimal;
        LubeQty: Decimal;
        DefectAndCasual: Record "14125606";
        RevistReason: Text;
        RepairReason: Text;
        SSkill: Code[20];
        MSkill: Code[20];
        RepairActionTkn: Text;
        RevistActionTaken: Text;
        sttpl: Codeunit "50000";
    begin
        IF NOT sttpl.isBAW THEN
            EXIT;

        CLEAR(PartsAmt);
        CLEAR(LubeQty);
        CLEAR(LaborAmt);

        //to calculate the Amounts

        ServLine.RESET;
        ServLine.SETRANGE("Document No.", ServHdr."No.");
        IF ServLine.FINDSET THEN
            REPEAT
                IF ServLine.Type = ServLine.Type::Item THEN
                    PartsAmt += ServLine."Amount Including VAT";
                IF ServLine.Type = ServLine.Type::Labor THEN
                    LaborAmt += ServLine."Amount Including VAT";
                IF ServLine."Unit of Measure" = 'LTR' THEN
                    LubeQty += ServLine.Quantity;
            UNTIL ServHdr.NEXT = 0;

        // to find repair codes

        DefectAndCasual.RESET;
        DefectAndCasual.SETRANGE("Service Order No.", ServHdr."No.");
        DefectAndCasual.SETRANGE(Type, DefectAndCasual.Type::Order);
        IF DefectAndCasual.FINDSET THEN
            REPEAT
                IF DefectAndCasual."RV RR Code" = DefectAndCasual."RV RR Code"::Revisit THEN BEGIN
                    IF RevistReason = '' THEN BEGIN
                        RevistReason := DefectAndCasual."Defect Value";
                        RevistActionTaken := DefectAndCasual."Action Taken";
                    END ELSE BEGIN
                        // RevistReason +=','+ DefectAndCasual."Defect Value";
                        RevistActionTaken += ',' + DefectAndCasual."Action Taken";
                    END;
                END ELSE
                    IF DefectAndCasual."RV RR Code" = DefectAndCasual."RV RR Code"::"Repeat Repair" THEN BEGIN
                        IF RepairReason = '' THEN BEGIN
                            //   RepairReason := DefectAndCasual."Defect Value";
                            RepairActionTkn := DefectAndCasual."Action Taken";
                        END ELSE BEGIN
                            // RepairReason += ','+ DefectAndCasual."Defect Value";
                            RepairActionTkn += ',' + DefectAndCasual."Action Taken";
                        END;
                    END;
            UNTIL DefectAndCasual.NEXT = 0;

        PSFHistory.RESET;
        PSFHistory.SETRANGE("Document No.", ServHdr."No.");
        IF NOT PSFHistory.FINDFIRST THEN BEGIN
            PSFHistory.INIT;
            PSFHistory."Document No." := ServHdr."No.";

            insertOrUpdatePSF(PSFHistory, ServHdr, PartsAmt, LaborAmt, LubeQty);

            IF "RV RR Code" = "RV RR Code"::"Repeat Repair" THEN BEGIN
                // PSFHistory."Revisit Repair Reason" := COPYSTR(RepairReason,1,250);
                PSFHistory."Action Taken" := COPYSTR(RepairActionTkn, 1, 250);
            END
            ELSE
                IF "RV RR Code" = "RV RR Code"::Revisit THEN BEGIN
                    // PSFHistory."Revisit Repair Reason" :=COPYSTR(RevistReason,1,250);
                    PSFHistory."Action Taken" := COPYSTR(RevistActionTaken, 1, 250);
                END;
            PSFHistory."Revisit Repair Reason" := "Revisit Repair Reason";
            PSFHistory."Repeat Group Code" := '';
            PSFHistory.INSERT;
        END
        ELSE BEGIN
            insertOrUpdatePSF(PSFHistory, ServHdr, PartsAmt, LaborAmt, LubeQty);

            PSFHistory."Customer Verbatism" := DefectAndCasual."Customer Verbatim";

            PSFHistory."RV RR Code" := "RV RR Code";
            IF "RV RR Code" = "RV RR Code"::"Repeat Repair" THEN BEGIN
                // PSFHistory."Revisit Repair Reason" := COPYSTR(RepairReason,1,250);
                PSFHistory."Action Taken" := COPYSTR(RepairActionTkn, 1, 250);
            END
            ELSE
                IF "RV RR Code" = "RV RR Code"::Revisit THEN BEGIN
                    //PSFHistory."Revisit Repair Reason" :=COPYSTR(RevistReason,1,250);
                    PSFHistory."Action Taken" := COPYSTR(RevistActionTaken, 1, 250);
                END;
            PSFHistory."Revisit Repair Reason" := "Revisit Repair Reason";
            PSFHistory."Repeat Group Code" := '';
            PSFHistory.MODIFY;
        END;
    end;

    local procedure insertOrUpdatePSF(var PSFHistory: Record "14125605"; SrvHdr: Record "25006145"; _PAmt: Decimal; _LAmt: Decimal; _LubeAmt: Decimal)
    var
        SalesPrsn: Record "13";
        Resource: Record "156";
    begin
        PSFHistory.VIN := VIN;
        PSFHistory.Make := "Make Code";
        PSFHistory.Model := "Model Code";
        PSFHistory."Model Version" := "Model Version No.";
        PSFHistory."Odometer Reading" := Kilometrage;
        //PSFHistory."Service Type" := "Service Type";
        PSFHistory."Date In" := "Arrival Date";
        PSFHistory."Time In" := "Arrival Time";
        PSFHistory."Date Out" := TODAY;
        PSFHistory."Time Out" := TIME;
        PSFHistory."Delay Reason" := FORMAT("Delay Reason Code");
        PSFHistory."Job Card No." := SrvHdr."No.";
        PSFHistory."Parts Amount" := _PAmt;
        PSFHistory."Labour Amount" := _LAmt;
        PSFHistory."Lube Qty" := _LubeAmt;
        PSFHistory."Vehicle Redg No." := "Vehicle Registration No.";
        PSFHistory."Customer Name" := "Sell-to Customer Name";
        PSFHistory."Contact No." := "Mobile Phone No.";
        PSFHistory."Alernative Contact" := "Mobile No. for SMS";
        PSFHistory."User Code" := USERID;
        PSFHistory.CAPS := '';
        PSFHistory."Distributor Branch Delaer" := SrvHdr."Shortcut Dimension 1 Code";
        PSFHistory."Distributor Name" := 'BALAJU AUTO WORKS';
        PSFHistory."Posting Date" := SrvHdr."Posting Date";
    end;

    [Scope('Internal')]
    procedure getCurrentServiceLine(ServNo: Code[20])
    var
        ServLine: Record "25006146";
        ServiceOrder: Record "14125607";
        ServHdr: Record "25006145";
        lineNo: Integer;
        ServiceOrder1: Record "14125607";
        sttpl: Codeunit "50000";
    begin
        IF NOT sttpl.isBAW THEN
            EXIT;

        CLEAR(ServiceOrder);
        ServHdr.RESET;
        ServHdr.SETRANGE("No.", ServNo);
        IF ServHdr.FINDFIRST THEN;

        ServiceOrder1.RESET;
        ServiceOrder1.SETRANGE("Document No.", ServNo);
        IF ServiceOrder1.FINDLAST THEN
            lineNo := ServiceOrder1."Line No."
        ELSE
            lineNo := 0;

        ServiceOrder.RESET;
        ServiceOrder.SETRANGE("Document No.", ServNo);
        ServiceOrder.SETRANGE(Type, ServiceOrder.Type::Header);
        IF NOT ServiceOrder.FINDFIRST THEN BEGIN
            lineNo += 10000;
            ServiceOrder.INIT;
            ServiceOrder."Document No." := ServNo;
            ServiceOrder.Type := ServiceOrder.Type::Header;
            ServiceOrder.VIN := ServHdr.VIN;
            ServiceOrder."Line No." := lineNo;
            ServiceOrder."Vehicle Registration No." := ServHdr."Vehicle Registration No.";
            ServiceOrder."Vehicle Serial No." := ServHdr."Vehicle Serial No.";
            ServiceOrder."Posting Date" := ServHdr."Posting Date";
            //ServiceOrder."Posting Date" := TODAY; Agni INC UPG
            ServiceOrder.INSERT;
        END;


        ServLine.RESET;
        ServLine.SETRANGE("Document No.", ServNo);
        IF ServLine.FINDSET THEN
            REPEAT

                lineNo += 10000;
                ServiceOrder.RESET;
                ServiceOrder.SETRANGE("Document No.", ServNo);
                ServiceOrder.SETRANGE(Type, ServiceOrder.Type::Line);
                ServiceOrder.SETRANGE("No.", ServLine."No.");
                IF ServiceOrder.FINDFIRST THEN BEGIN
                    ServiceOrder.VIN := ServHdr.VIN;
                    ServiceOrder."Line Type" := ServLine.Type;
                    ServiceOrder."No." := ServLine."No.";
                    ServiceOrder.Descrption := ServLine.Description;
                    ServiceOrder.Qunatity := ServLine.Quantity;
                    ServiceOrder."Location Code" := ServLine."Location Code";
                    ServiceOrder."Line Amt. Inc VAT" := ServLine."Line Amount";
                    ServiceOrder."Vehicle Registration No." := ServHdr."Vehicle Registration No.";
                    ServiceOrder."Vehicle Serial No." := ServHdr."Vehicle Serial No.";
                    ServiceOrder.MODIFY;
                END ELSE BEGIN
                    ServiceOrder.INIT;
                    ServiceOrder."Document No." := ServNo;
                    ServiceOrder.VIN := ServHdr.VIN;
                    ServiceOrder."Line Type" := ServLine.Type;
                    ServiceOrder."No." := ServLine."No.";
                    ServiceOrder.Descrption := ServLine.Description;
                    ServiceOrder."Line No." := lineNo;
                    ServiceOrder.Qunatity := ServLine.Quantity;
                    ServiceOrder."Location Code" := ServLine."Location Code";
                    ServiceOrder."Line Amt. Inc VAT" := ServLine."Line Amount";
                    //ServiceOrder.Type := ServiceOrder.Type::"Line Order";
                    ServiceOrder.Type := ServiceOrder.Type::Line;
                    ServiceOrder."Vehicle Registration No." := ServHdr."Vehicle Registration No.";
                    ServiceOrder."Vehicle Serial No." := ServHdr."Vehicle Serial No.";
                    ServiceOrder.INSERT;
                END;
            UNTIL ServLine.NEXT = 0;
    end;

    local procedure verifyIfDefectExists(ServCode: Code[20])
    var
        Defect: Record "14125606";
        sttpl: Codeunit "50000";
    begin
        IF NOT sttpl.isBAW THEN
            EXIT;
        Defect.RESET;
        Defect.SETRANGE("Service Order No.", ServCode);
        Defect.SETFILTER("Defect Code", '<>%1', '');
        IF NOT Defect.FINDFIRST THEN
            ERROR('Defect and Casual is mandatory to be filled.');
    end;
}


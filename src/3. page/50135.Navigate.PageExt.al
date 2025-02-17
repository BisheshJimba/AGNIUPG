pageextension 50135 pageextension50135 extends Navigate
{

    //Unsupported feature: Property Modification (Length) on "SourceName(Variable 1077)".

    //var
    //>>>> ORIGINAL VALUE:
    //SourceName : 50;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //SourceName : 60;
    //Variable type has not been exported.

    var
        ServLedgerEntryEDMS: Record "25006167";
        PstServHeaderEDMS: Record "25006149";
        PstServRetHeaderEDMS: Record "25006154";
        ExtServiceLedgerEntry: Record "25006137";
        VehOptionLedgerEntry: Record "25006388";
        TireEntry: Record "25006181";
        PstSalaryHeader: Record "33020512";
        AdvRegister: Record "33020508";
        LoanRegister: Record "33020509";
        TDSEntry: Record "33019850";
        SalaryLedgerEntry: Record "33020520";
        "--NCHL-NPI_1.00--": Integer;
        CIPSTransactionEntry: Record "33019814";


    //Unsupported feature: Code Modification on "FindRecords(PROCEDURE 2)".

    //procedure FindRecords();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    Window.OPEN(Text002);
    RESET;
    DELETEALL;
    "Entry No." := 0;
    FindIncomingDocumentRecords;
    IF SalesShptHeader.READPERMISSION THEN BEGIN
      SalesShptHeader.RESET;
      SalesShptHeader.SETFILTER("No.",DocNoFilter);
    #9..481
    IF UpdateForm THEN
      UpdateFormAfterFindRecords;
    Window.CLOSE;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5
    //PAYROLL 6.1.0 BEGIN >>>
      IF PstSalaryHeader.READPERMISSION THEN BEGIN
        PstSalaryHeader.RESET;
        PstSalaryHeader.SETFILTER("No.",DocNoFilter);
        PstSalaryHeader.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Posted Salary Header",0,PstSalaryHeader.TABLECAPTION,PstSalaryHeader.COUNT);
      END;
      IF AdvRegister.READPERMISSION THEN BEGIN
        AdvRegister.RESET;
        AdvRegister.SETCURRENTKEY("Document No.");
        AdvRegister.SETFILTER("Document No.",DocNoFilter);
        AdvRegister.SETFILTER("Creation Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Employee Advance Register",0,AdvRegister.TABLECAPTION,AdvRegister.COUNT);
      END;
      //RD 18.04.05
      IF SalaryLedgerEntry.READPERMISSION THEN BEGIN
        SalaryLedgerEntry.RESET;
        SalaryLedgerEntry.SETCURRENTKEY("Source No.");
        SalaryLedgerEntry.SETFILTER("Source No.",DocNoFilter);
        SalaryLedgerEntry.SETFILTER("Creation Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Salary Ledger Entry",0,SalaryLedgerEntry.TABLECAPTION,SalaryLedgerEntry.COUNT);
      END;
      //RD 18.04.05
      IF LoanRegister.READPERMISSION THEN BEGIN
        LoanRegister.RESET;
        LoanRegister.SETCURRENTKEY("Document No.");
        LoanRegister.SETFILTER("Document No.",DocNoFilter);
        LoanRegister.SETFILTER("Creation Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Employee Loan Register",0,LoanRegister.TABLECAPTION,LoanRegister.COUNT);
      END;

    //PAYROLL 6.1.0 END <<<

    //TDS2.00
      IF TDSEntry.READPERMISSION THEN BEGIN
        TDSEntry.RESET;
        TDSEntry.SETCURRENTKEY("Document No.");
        TDSEntry.SETFILTER("Document No.",DocNoFilter);
        TDSEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"TDS Entry",0,TDSEntry.TABLECAPTION,TDSEntry.COUNT);
      END;
    //TDS2.00
      //NCHL-NPI_1.00 >>
      IF CIPSTransactionEntry.READPERMISSION THEN BEGIN
        CIPSTransactionEntry.RESET;
        CIPSTransactionEntry.SETCURRENTKEY("Document No.","Posting Date");
        CIPSTransactionEntry.SETFILTER("Document No.",DocNoFilter);
        CIPSTransactionEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"NCHL-NPI Entry",0,CIPSTransactionEntry.TABLECAPTION,CIPSTransactionEntry.COUNT);
      END;
      //NCHL-NPI_1.00 <<
    //EDMS >>
      IF VehOptionLedgerEntry.READPERMISSION THEN BEGIN
        VehOptionLedgerEntry.RESET;
        VehOptionLedgerEntry.SETCURRENTKEY("Document No.","Posting Date");
        VehOptionLedgerEntry.SETFILTER("Document No.",DocNoFilter);
        VehOptionLedgerEntry.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Vehicle Opt. Ledger Entry",0,VehOptionLedgerEntry.TABLECAPTION,VehOptionLedgerEntry.COUNT);
      END;
      IF ServLedgerEntryEDMS.READPERMISSION THEN BEGIN
        ServLedgerEntryEDMS.RESET;
        ServLedgerEntryEDMS.SETCURRENTKEY("Document No.","Posting Date");
        ServLedgerEntryEDMS.SETFILTER("Document No.",DocNoFilter);
        ServLedgerEntryEDMS.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Service Ledger Entry EDMS",0,ServLedgerEntryEDMS.TABLECAPTION,ServLedgerEntryEDMS.COUNT);
      END;

      // 29.09.2011 EDMS P8 >>
      IF TireEntry.READPERMISSION THEN BEGIN
        TireEntry.RESET;
        TireEntry.SETCURRENTKEY("Document No.","Posting Date");
        TireEntry.SETFILTER("Document No.",DocNoFilter);
        TireEntry.SETFILTER("Posting Date",PostingDateFilter);
        IF TireEntry.COUNT > 0 THEN
          InsertIntoDocEntry(
            DATABASE::"Tire Entry",0,TireEntry.TABLECAPTION, TireEntry.COUNT);
      END;
      // 29.09.2011 EDMS P8 <<

      IF PstServHeaderEDMS.READPERMISSION THEN BEGIN
        PstServHeaderEDMS.RESET;
        PstServHeaderEDMS.SETFILTER("No.",DocNoFilter);
        PstServHeaderEDMS.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Posted Serv. Order Header",0,PstServHeaderEDMS.TABLECAPTION,PstServHeaderEDMS.COUNT);
      END;
      IF PstServRetHeaderEDMS.READPERMISSION THEN BEGIN
        PstServRetHeaderEDMS.RESET;
        PstServRetHeaderEDMS.SETFILTER("No.",DocNoFilter);
        PstServRetHeaderEDMS.SETFILTER("Posting Date",PostingDateFilter);
        InsertIntoDocEntry(
          DATABASE::"Posted Serv. Ret. Order Header",0,PstServRetHeaderEDMS.TABLECAPTION,PstServRetHeaderEDMS.COUNT);
      END;
    //EDMS <<

    #6..484
    */
    //end;


    //Unsupported feature: Code Modification on "ShowRecords(PROCEDURE 6)".

    //procedure ShowRecords();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF ItemTrackingSearch THEN
      ItemTrackingNavigateMgt.Show("Table ID")
    ELSE
    #4..12
            PAGE.RUN(PAGE::"Posted Sales Invoices",SalesInvHeader);
        DATABASE::"Sales Cr.Memo Header":
          IF "No. of Records" = 1 THEN
            PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader)
          ELSE
            PAGE.RUN(PAGE::"Posted Sales Credit Memos",SalesCrMemoHeader);
        DATABASE::"Return Receipt Header":
    #20..42
            PAGE.RUN(PAGE::"Posted Purchase Invoices",PurchInvHeader);
        DATABASE::"Purch. Cr. Memo Hdr.":
          IF "No. of Records" = 1 THEN
            PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHeader)
          ELSE
            PAGE.RUN(PAGE::"Posted Purchase Credit Memos",PurchCrMemoHeader);
        DATABASE::"Return Shipment Header":
    #50..141
          PAGE.RUN(0,WarrantyLedgerEntry);
        DATABASE::"Cost Entry":
          PAGE.RUN(0,CostEntry);
      END;

    OnAfterNavigateShowRecords("Table ID",DocNoFilter,PostingDateFilter,ItemTrackingSearch);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..15
            PAGE.RUN(PAGE::"Posted Credit Note",SalesCrMemoHeader)
    #17..45
            PAGE.RUN(PAGE::"Posted Debit Note",PurchCrMemoHeader)
    #47..144
        //EDMS>>
        DATABASE::"Service Ledger Entry EDMS":
          PAGE.RUN(0,ServLedgerEntryEDMS);
        DATABASE::"Posted Serv. Order Header":
          PAGE.RUN(0,PstServHeaderEDMS);
        DATABASE::"Posted Serv. Ret. Order Header":
          PAGE.RUN(0,PstServRetHeaderEDMS);
        DATABASE::"External Serv. Ledger Entry":
          PAGE.RUN(0,ExtServiceLedgerEntry);
        DATABASE::"Vehicle Opt. Ledger Entry":
          PAGE.RUN(0,VehOptionLedgerEntry);
        //EDMS <<
        // 29.09.2011 EDMS P8 >>
        DATABASE::"Tire Entry":
          PAGE.RUN(0, TireEntry);
        // 29.09.2011 EDMS P8 <<
        //PAYROLL 6.1.0 >>>
        DATABASE::"Posted Salary Header":
          PAGE.RUN(PAGE::"Posted Salary Plan Lines",PstSalaryHeader);
        DATABASE::"Employee Advance Register":
          PAGE.RUN(PAGE::"Employee Advance Register",AdvRegister);
        DATABASE::"Employee Loan Register":
          PAGE.RUN(PAGE::"Employee Loan Register",LoanRegister);
        DATABASE::"Salary Ledger Entry":
          PAGE.RUN(PAGE::"Salary Ledger Entries",SalaryLedgerEntry);
        //PAYROLL 6.1.0 <<<

        //TDS2.00
        DATABASE::"TDS Entry":
          PAGE.RUN(0,TDSEntry);
        //TDS2.00

        //NCHL-NPI_1.00 >>
        DATABASE::"NCHL-NPI Entry":
          PAGE.RUN(0,CIPSTransactionEntry);
        //NCHL-NPI_1.00 <<
    #145..147
    */
    //end;


    //Unsupported feature: Code Modification on "ShowSalesHeaderRecords(PROCEDURE 28)".

    //procedure ShowSalesHeaderRecords();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TESTFIELD("Table ID",DATABASE::"Sales Header");

    CASE "Document Type" OF
    #4..17
          PAGE.RUN(0,SROSalesHeader);
      "Document Type"::"Credit Memo":
        IF "No. of Records" = 1 THEN
          PAGE.RUN(PAGE::"Sales Credit Memo",SCMSalesHeader)
        ELSE
          PAGE.RUN(0,SCMSalesHeader);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..20
          PAGE.RUN(PAGE::"Credit Note",SCMSalesHeader)
    #22..24
    */
    //end;
}


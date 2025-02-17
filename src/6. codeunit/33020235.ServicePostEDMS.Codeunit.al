codeunit 33020235 "Service Post EDMS"
{
    // 23.02.2012 Sipradi-YS
    //   * Added code on CreateSalesLine function
    //   * Added code on CreateBalanceSalesLine function
    //   * Added code on CreatePostedServiceLines function
    //   * Added Function CreateServiceHeader
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
    var
        Text000: Label '#1#############';
        ProgressWindow: Dialog;
    begin
        ProgressWindow.OPEN(Text000);
        ProgressWindow.UPDATE(1, 'Posting Service Order.....');
        // IF "Posting Date" = TODAY THEN ERROR ('You cannot post today');
        Rec."Posting Date" := TODAY;
        "Actual Delivery Time" := TIME;
        Rec.MODIFY;

        IF (Rec."Posting Date" - "Arrival Date") > 0 THEN //PSF
            Rec.TESTFIELD("Delay Reason Code");

        IF "RV RR Code" <> "RV RR Code"::" " THEN
            Rec.TESTFIELD("Revisit Repair Reason"); //psf

        verifyIfDefectExists(Rec."No.");//psf
        getCurrentServiceLine(Rec."No."); //psf
        postIntoPSFHistory(Rec); //psf

        ServiceHeaderTemp := Rec;
        ServiceHeaderGlobal.GET(Rec."Document Type", Rec."No.");
        ProgressWindow.UPDATE(1, 'Validating Service Details.....');
        CheckServiceHeader(Rec);
        CheckDim(Rec);  //25.10.2013 EDMS P8
        ProgressWindow.UPDATE(1, 'Creating Invoices.....');
        CreateInvoices(Rec);
        ProgressWindow.UPDATE(1, 'Creating Service Ledgers.....');
        PostServiceOrder(Rec);
        ProgressWindow.CLOSE;
        //PostSalesInvoices(ServiceHeaderTemp);
    end;

    var
        ServiceSetup: Record "25006120";
        cuReleaseSalesDoc: Codeunit "414";
        tcSer003: Label 'Put Items to "';
        ScheduleMgt: Codeunit "25006201";
        tcSer004: Label '" invoice.';
        tcSer005: Label 'Invoice creation is interupted!';
        tcSer006: Label 'Not all quantity is transferred.';
        TotalServiceLine: Record "25006146";
        TempServiceLine: Record "25006146" temporary;
        TempPrepaymentServiceLine: Record "25006146" temporary;
        GenPostingSetup: Record "252";
        TempVATAmountLine: Record "290" temporary;
        TempVATAmountLineRemainder: Record "290" temporary;
        GLSetup: Record "98";
        CustPostingGr: Record "92";
        ServiceHeader: Record "25006145";
        ServiceHeaderGlobal: Record "25006145";
        ServiceLine: Record "25006146";
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
        BillToCustomer: array[1000] of Code[20];
        StplSysMgt: Codeunit "50000";
        DocumentProfile: Option Purchase,Sales,Service,Transfer;
        DocumentType: Option Quote,"Blanket Order","Order","Return Order",Invoice,"Posted Invoice","Credit Memo","Posted Credit Memo","Posted Shipment","Posted Receipt","Posted Prepmt. Inv.","Posted Prepmt. Cr. Memo","Posted Return Receipt","Posted Return Shipment",Booking,"Posted Order","Posted Debit Note";
        QuantityZero: Label 'Quantity Cannot be 0 in Service Line %1.';
        AmountZero: Label 'Amount Cannot be 0 in Service Line %1.';
        WarrantyEntries: Record "33020249";
        JobTypeMaster: Record "33020235";
        Text030: Label 'The dimensions used in %1 %2 are invalid. %3';
        Text031: Label 'The dimensions used in %1 %2, line no. %3 are invalid. %4';
        Text028: Label 'The combination of dimensions used in %1 %2 is blocked. %3';
        Text029: Label 'The combination of dimensions used in %1 %2, line no. %3 is blocked. %4';
        TransHdrExists: Label 'Please delete transfer orders before posting service order.';

    [Scope('Internal')]
    procedure CreateInvoices(ServiceHeader: Record "25006145")
    var
        Vehicle: Record "25006005";
        ServiceLine: Record "25006146";
        SalesHeader2: Record "36";
        SalesLine2: Record "37";
        UserProfile: Record "25006067";
        Location: Record "14";
        cuWorkplaceMgt: Codeunit "25006002";
        NewSalesLine: Record "37";
        ServLedgEntry: Record "25006167";
        ReservEntry: Record "337";
        ReservEntry2: Record "337";
        BalLineOffset: Integer;
        AllTransferred: Boolean;
        TextNothingToPost: Label 'Nothing to post!';
        InvCount: Integer;
        NewLineNo: Integer;
        NewLineNo2: Integer;
        SalesHeader: Record "36";
        SalesHeader3: Record "36";
        SalesLine3: Record "37";
        SalesHeader4: Record "36";
        SaleLine4: Record "37";
        i: Integer;
        SalesHeaders: Record "36";
        DN: array[4] of Boolean;
    begin
        ServiceSetup.GET;

        IF ServiceHeader."Vehicle Item Charge No." <> '' THEN BEGIN
            IF Vehicle.GET(ServiceHeader."Vehicle Serial No.") THEN
                Vehicle.TESTFIELD("Model Version No.");
        END;

        IF (ServiceHeader."Arrival Date" - ServiceHeader."Posting Date") > 0 THEN //PSF
            ServiceHeader.TESTFIELD("Delay Reason Code");

        //Checks whether there is anything to post
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETFILTER(Type, '<>''''');
        ServiceLine.SETFILTER("No.", '<>''''');
        IF NOT ServiceLine.FINDFIRST THEN
            ERROR(TextNothingToPost);

        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.FINDFIRST;

        ServiceSetup.GET;
        SalesSetup.GET;

        IF ServiceHeader."Document Type" = ServiceHeader."Document Type"::Order THEN
            IF ServiceSetup."Payment Method Mandatory" THEN
                ServiceHeader.TESTFIELD("Payment Method Code");

        ServiceHeader.TESTFIELD("Location Code");
        ServiceHeader.TESTFIELD("Make Code");
        ServiceHeader.TESTFIELD("Model Code");
        ServiceHeader.TESTFIELD("Job Category"); //***SM 15-07-2013 as per Agni's report
                                                 //Agile CPJB 24 May 2016
        IF "Job Category" = "Job Category"::"Under Warranty" THEN
            ServiceHeader.TESTFIELD("Service Type");
        //Agile CPJB 24 May 2016
        ServiceHeader.TESTFIELD("Job Finished Date");
        IF "Job Type" <> 'PDI' THEN
            ServiceHeader.TESTFIELD("Next Service Date");//***SM 15-07-2013 as per Agni's report

        ArchiveUnpostedOrder(ServiceHeader);

        //Gets the number of invoices/cr.memos
        InvCount := GetInvCount2(ServiceHeader);

        SalesHeader.RESET;
        SalesHeader2.RESET;
        SalesHeader3.RESET;
        SalesHeader4.RESET;
        //Creates Sales Headers
        CreateSalesHeader(ServiceHeader, SalesHeader);

        IF InvCount = 2 THEN
            CreateSalesHeader(ServiceHeader, SalesHeader2);

        //Sipradi-YS BEGIN
        IF InvCount = 3 THEN BEGIN
            CreateSalesHeader(ServiceHeader, SalesHeader2);
            CreateSalesHeader(ServiceHeader, SalesHeader3);
        END;

        IF InvCount = 4 THEN BEGIN
            CreateSalesHeader(ServiceHeader, SalesHeader2);
            CreateSalesHeader(ServiceHeader, SalesHeader3);
            CreateSalesHeader(ServiceHeader, SalesHeader4);
        END;
        //Sipradi-YS END


        SalesHeader.SetHideValidationDialog(TRUE);
        //IF ServiceHeader."Bill-to Customer No." <> ServiceHeader."Sell-to Customer No." THEN Standard
        //SalesHeader.VALIDATE("Bill-to Customer No.",ServiceHeader."Bill-to Customer No."); Standard
        //Sipradi-YS BEGIN
        FOR i := 1 TO InvCount DO BEGIN
            IF i = 1 THEN BEGIN
                SalesHeader.VALIDATE("Bill-to Customer No.", BillToCustomer[i]);
                IF FindDebitCustomer(BillToCustomer[i]) THEN BEGIN
                    SalesHeader.VALIDATE("Debit Note", TRUE);
                    DN[i] := TRUE;
                END;
            END
            ELSE
                IF i = 2 THEN BEGIN
                    SalesHeader2.VALIDATE("Bill-to Customer No.", BillToCustomer[i]);
                    IF FindDebitCustomer(BillToCustomer[i]) THEN BEGIN
                        SalesHeader2.VALIDATE("Debit Note", TRUE);
                        DN[i] := TRUE;
                    END;
                END
                ELSE
                    IF i = 3 THEN BEGIN
                        SalesHeader3.VALIDATE("Bill-to Customer No.", BillToCustomer[i]);
                        IF FindDebitCustomer(BillToCustomer[i]) THEN BEGIN
                            SalesHeader3.VALIDATE("Debit Note", TRUE);
                            DN[i] := TRUE;
                        END;
                    END
                    ELSE
                        IF i = 4 THEN BEGIN
                            SalesHeader4.VALIDATE("Bill-to Customer No.", BillToCustomer[i]);
                            IF FindDebitCustomer(BillToCustomer[i]) THEN BEGIN
                                SalesHeader4.VALIDATE("Debit Note", TRUE);
                                DN[i] := TRUE;
                            END;
                        END
        END;
        //Sipradi-YS END

        CASE SalesHeader."Document Type" OF
            SalesHeader."Document Type"::Invoice:
                IF (ServiceSetup."Posted Invoice Nos." <> '')
                   AND NOT ServiceSetup."Use Order No. for Inv.&Cr.Memo"
                THEN BEGIN
                    //SalesHeader.VALIDATE("Posting No. Series",ServiceSetup."Posted Invoice Nos."); Standard
                    FOR i := 1 TO InvCount DO BEGIN
                        IF i = 1 THEN BEGIN
                            IF DN[i] THEN
                                SalesHeader.VALIDATE("Posting No. Series",
                                                StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,
                                                DocumentType::"Posted Debit Note")) // SIPRADI-YS GEN6.1.0
                            ELSE
                                SalesHeader.VALIDATE("Posting No. Series",
                                                StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service,
                                                DocumentType::"Posted Invoice")); // SIPRADI-YS GEN6.1.0
                        END
                        ELSE
                            IF i = 2 THEN BEGIN
                                IF DN[i] THEN
                                    SalesHeader2.VALIDATE("Posting No. Series",
                                                    StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,
                                                    DocumentType::"Posted Debit Note")) // SIPRADI-YS GEN6.1.0
                                ELSE
                                    SalesHeader2.VALIDATE("Posting No. Series",
                                                    StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service,
                                                    DocumentType::"Posted Invoice")) // SIPRADI-YS GEN6.1.0
                            END
                            ELSE
                                IF i = 3 THEN BEGIN
                                    IF DN[i] THEN
                                        SalesHeader3.VALIDATE("Posting No. Series",
                                                        StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,
                                                        DocumentType::"Posted Debit Note")) // SIPRADI-YS GEN6.1.0
                                    ELSE
                                        SalesHeader3.VALIDATE("Posting No. Series",
                                                        StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service,
                                                        DocumentType::"Posted Invoice")) // SIPRADI-YS GEN6.1.0
                                END
                                ELSE
                                    IF i = 4 THEN BEGIN
                                        IF DN[i] THEN
                                            SalesHeader4.VALIDATE("Posting No. Series",
                                                            StplSysMgt.getLocWiseNoSeries(DocumentProfile::Sales,
                                                            DocumentType::"Posted Debit Note")) // SIPRADI-YS GEN6.1.0
                                        ELSE
                                            SalesHeader4.VALIDATE("Posting No. Series",
                                                            StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service,
                                                            DocumentType::"Posted Invoice")) // SIPRADI-YS GEN6.1.0
                                    END
                    END;
                END;
            SalesHeader."Document Type"::"Credit Memo":
                BEGIN
                    IF (ServiceSetup."Posted Credit Memo Nos." <> '')
                      AND NOT ServiceSetup."Use Order No. for Inv.&Cr.Memo"
                    THEN BEGIN
                        // SalesHeader.VALIDATE("Posting No. Series",ServiceSetup."Posted Credit Memo Nos.");   Standard
                        // IF InvCount = 2 THEN                                                                 Standard
                        //   SalesHeader2.VALIDATE("Posting No. Series",ServiceSetup."Posted Credit Memo Nos.");Standard
                        //Sipradi-YS BEGIN
                        FOR i := 1 TO InvCount DO BEGIN
                            IF i = 1 THEN
                                SalesHeader.VALIDATE("Posting No. Series",
                                        StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service, DocumentType::"Posted Credit Memo"))
                            ELSE
                                IF i = 2 THEN
                                    SalesHeader2.VALIDATE("Posting No. Series",
                                            StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service, DocumentType::"Posted Credit Memo"))
                                ELSE
                                    IF i = 3 THEN
                                        SalesHeader3.VALIDATE("Posting No. Series",
                                                StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service, DocumentType::"Posted Credit Memo"))
                                    ELSE
                                        IF i = 4 THEN
                                            SalesHeader4.VALIDATE("Posting No. Series",
                                                    StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service, DocumentType::"Posted Credit Memo"))
                        END;
                        //Sipradi-YS END

                    END;

                    FOR i := 1 TO InvCount DO BEGIN
                        //Automatic application
                        IF i = 1 THEN BEGIN
                            ServLedgEntry.SETCURRENTKEY("Document Type", "Service Order No.", "Bill-to Customer No.");
                            ServLedgEntry.SETRANGE("Document Type", ServLedgEntry."Document Type"::Invoice);
                            ServLedgEntry.SETRANGE("Service Order No.", ServiceHeader."Applies-to Doc. No.");
                            //ServLedgEntry.SETRANGE("Bill-to Customer No.",ServiceHeader."Bill-to Customer No."); Standard
                            ServLedgEntry.SETRANGE("Bill-to Customer No.", BillToCustomer[1]);
                            IF ServLedgEntry.FINDFIRST THEN BEGIN
                                SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type"::Invoice;
                                SalesHeader."Applies-to Doc. No." := ServLedgEntry."Document No."
                            END;
                        END
                        ELSE
                            IF i = 2 THEN BEGIN
                                ServLedgEntry.SETCURRENTKEY("Document Type", "Service Order No.", "Bill-to Customer No.");
                                ServLedgEntry.SETRANGE("Document Type", ServLedgEntry."Document Type"::Invoice);
                                ServLedgEntry.SETRANGE("Service Order No.", ServiceHeader."Applies-to Doc. No.");
                                //ServLedgEntry.SETRANGE("Bill-to Customer No.",ServiceHeader."Sell-to Customer No."); Standard
                                //Sipradi-YS BEGIN
                                ServLedgEntry.SETRANGE("Bill-to Customer No.", BillToCustomer[2]);
                                //Sipradi-YS END
                                IF ServLedgEntry.FINDFIRST THEN BEGIN
                                    SalesHeader2."Applies-to Doc. Type" := SalesHeader2."Applies-to Doc. Type"::Invoice;
                                    SalesHeader2."Applies-to Doc. No." := ServLedgEntry."Document No."
                                END
                            END
                            //Sipradi-YS BEGIN
                            ELSE
                                IF i = 3 THEN BEGIN
                                    ServLedgEntry.SETCURRENTKEY("Document Type", "Service Order No.", "Bill-to Customer No.");
                                    ServLedgEntry.SETRANGE("Document Type", ServLedgEntry."Document Type"::Invoice);
                                    ServLedgEntry.SETRANGE("Service Order No.", ServiceHeader."Applies-to Doc. No.");
                                    ServLedgEntry.SETRANGE("Bill-to Customer No.", BillToCustomer[3]);
                                    IF ServLedgEntry.FINDFIRST THEN BEGIN
                                        SalesHeader3."Applies-to Doc. Type" := SalesHeader3."Applies-to Doc. Type"::Invoice;
                                        SalesHeader3."Applies-to Doc. No." := ServLedgEntry."Document No."
                                    END
                                END
                                //Sipradi-YS END

                                //Sipradi-YS BEGIN
                                ELSE
                                    IF i = 4 THEN BEGIN
                                        ServLedgEntry.SETCURRENTKEY("Document Type", "Service Order No.", "Bill-to Customer No.");
                                        ServLedgEntry.SETRANGE("Document Type", ServLedgEntry."Document Type"::Invoice);
                                        ServLedgEntry.SETRANGE("Service Order No.", ServiceHeader."Applies-to Doc. No.");
                                        ServLedgEntry.SETRANGE("Bill-to Customer No.", BillToCustomer[4]);
                                        IF ServLedgEntry.FINDFIRST THEN BEGIN
                                            SalesHeader4."Applies-to Doc. Type" := SalesHeader4."Applies-to Doc. Type"::Invoice;
                                            SalesHeader4."Applies-to Doc. No." := ServLedgEntry."Document No."
                                        END
                                    END;
                        //Sipradi-YS END
                    END

                END
        END;

        FOR i := 1 TO InvCount DO BEGIN
            IF i = 1 THEN BEGIN
                SalesHeader.VALIDATE("Salesperson Code", ServiceHeader."Service Person");
                SalesHeader."Allow Line Disc." := TRUE;
                SalesHeader.VALIDATE("Payment Method Code", ServiceHeader."Payment Method Code");
                SalesHeader.VALIDATE("Payment Terms Code", ServiceHeader."Payment Terms Code");
                SalesHeader."External Document No." := ServiceHeader."External Document No.";
                SalesHeader."Prices Including VAT" := ServiceHeader."Prices Including VAT";
                SalesHeader.VALIDATE("Document Profile", SalesHeader."Document Profile"::Service);
                SalesHeader.VALIDATE("Location Code", ServiceHeader."Location Code");
                IF ServiceHeader."Vehicle Item Charge No." <> '' THEN BEGIN
                    Vehicle.GET(ServiceHeader."Vehicle Serial No.");
                    Vehicle.TESTFIELD("Model Version No.");
                    SalesHeader."Vehicle Item Charge No." := ServiceHeader."Vehicle Item Charge No.";
                    SalesHeader."Model Version No." := Vehicle."Model Version No.";
                END;
                SalesHeader.MODIFY;
                CopyServDimToSales(ServiceHeader, SalesHeader);
                CopyServCommLinesToSale(ServiceHeader."Document Type", SalesHeader."Document Type", ServiceHeader."No.", SalesHeader."No.");
            END
            ELSE
                IF i = 2 THEN BEGIN
                    SalesHeader2.VALIDATE("Salesperson Code", ServiceHeader."Service Person");
                    SalesHeader2."Allow Line Disc." := TRUE;
                    SalesHeader2.VALIDATE("Payment Method Code", ServiceHeader."Payment Method Code");
                    SalesHeader2.VALIDATE("Payment Terms Code", ServiceHeader."Payment Terms Code");
                    SalesHeader2."External Document No." := ServiceHeader."External Document No.";
                    SalesHeader2."Prices Including VAT" := ServiceHeader."Prices Including VAT";
                    SalesHeader2.VALIDATE("Document Profile", SalesHeader2."Document Profile"::Service);
                    SalesHeader2.VALIDATE("Location Code", ServiceHeader."Location Code");
                    IF ServiceHeader."Vehicle Item Charge No." <> '' THEN BEGIN
                        Vehicle.GET(ServiceHeader."Vehicle Serial No.");
                        Vehicle.TESTFIELD("Model Version No.");
                        SalesHeader2."Vehicle Item Charge No." := ServiceHeader."Vehicle Item Charge No.";
                        SalesHeader2."Model Version No." := Vehicle."Model Version No.";
                    END;
                    SalesHeader2.MODIFY;
                    CopyServDimToSales(ServiceHeader, SalesHeader2);
                    CopyServCommLinesToSale(ServiceHeader."Document Type", SalesHeader2."Document Type", ServiceHeader."No.", SalesHeader2."No.");

                END
                ELSE
                    IF i = 3 THEN BEGIN
                        SalesHeader3.VALIDATE("Salesperson Code", ServiceHeader."Service Person");
                        SalesHeader3."Allow Line Disc." := TRUE;
                        SalesHeader3.VALIDATE("Payment Method Code", ServiceHeader."Payment Method Code");
                        SalesHeader3.VALIDATE("Payment Terms Code", ServiceHeader."Payment Terms Code");
                        SalesHeader3."External Document No." := ServiceHeader."External Document No.";
                        SalesHeader3."Prices Including VAT" := ServiceHeader."Prices Including VAT";
                        SalesHeader3.VALIDATE("Document Profile", SalesHeader3."Document Profile"::Service);
                        SalesHeader3.VALIDATE("Location Code", ServiceHeader."Location Code");
                        IF ServiceHeader."Vehicle Item Charge No." <> '' THEN BEGIN
                            Vehicle.GET(ServiceHeader."Vehicle Serial No.");
                            Vehicle.TESTFIELD("Model Version No.");
                            SalesHeader3."Vehicle Item Charge No." := ServiceHeader."Vehicle Item Charge No.";
                            SalesHeader3."Model Version No." := Vehicle."Model Version No.";
                        END;
                        SalesHeader3.MODIFY;
                        CopyServDimToSales(ServiceHeader, SalesHeader3);
                        CopyServCommLinesToSale(ServiceHeader."Document Type", SalesHeader3."Document Type", ServiceHeader."No.", SalesHeader3."No.");

                    END
                    ELSE
                        IF i = 4 THEN BEGIN
                            SalesHeader4.VALIDATE("Salesperson Code", ServiceHeader."Service Person");
                            SalesHeader4."Allow Line Disc." := TRUE;
                            SalesHeader4.VALIDATE("Payment Method Code", ServiceHeader."Payment Method Code");
                            SalesHeader4.VALIDATE("Payment Terms Code", ServiceHeader."Payment Terms Code");
                            SalesHeader4."External Document No." := ServiceHeader."External Document No.";
                            SalesHeader4."Prices Including VAT" := ServiceHeader."Prices Including VAT";
                            SalesHeader4.VALIDATE("Document Profile", SalesHeader4."Document Profile"::Service);
                            SalesHeader4.VALIDATE("Location Code", ServiceHeader."Location Code");
                            IF ServiceHeader."Vehicle Item Charge No." <> '' THEN BEGIN
                                Vehicle.GET(ServiceHeader."Vehicle Serial No.");
                                Vehicle.TESTFIELD("Model Version No.");
                                SalesHeader4."Vehicle Item Charge No." := ServiceHeader."Vehicle Item Charge No.";
                                SalesHeader4."Model Version No." := Vehicle."Model Version No.";
                            END;
                            SalesHeader4.MODIFY;
                            CopyServDimToSales(ServiceHeader, SalesHeader4);
                            CopyServCommLinesToSale(ServiceHeader."Document Type", SalesHeader4."Document Type", ServiceHeader."No.", SalesHeader4."No.");

                        END;

        END;

        //Sipradi-YS Lines Copy BEGIN
        FOR i := 1 TO InvCount DO BEGIN
            ServiceLine.RESET;
            ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
            ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
            ServiceLine.SETRANGE("Bill-to Customer No.", BillToCustomer[i]);
            ServiceLine.FINDFIRST;
            REPEAT
                JobTypeMaster.RESET;
                JobTypeMaster.SETRANGE("No.", ServiceLine."Job Type");
                JobTypeMaster.SETRANGE(Scheme, FALSE);
                IF JobTypeMaster.FINDFIRST THEN BEGIN
                    IF i = 1 THEN BEGIN
                        CreateSalesLine2(SalesHeader, ServiceLine, NewSalesLine, 100, NewLineNo, TRUE);
                        SalesHeaders := SalesHeader;
                    END;
                    IF i = 2 THEN BEGIN
                        CreateSalesLine2(SalesHeader2, ServiceLine, NewSalesLine, 100, NewLineNo, TRUE);
                        SalesHeaders := SalesHeader2;
                    END;
                    IF i = 3 THEN BEGIN
                        CreateSalesLine2(SalesHeader3, ServiceLine, NewSalesLine, 100, NewLineNo, TRUE);
                        SalesHeaders := SalesHeader3;
                    END;
                    IF i = 4 THEN BEGIN
                        CreateSalesLine2(SalesHeader4, ServiceLine, NewSalesLine, 100, NewLineNo, TRUE);
                        SalesHeaders := SalesHeader4;
                    END;
                END;
            UNTIL ServiceLine.NEXT = 0;
            IF (SalesHeaders."Package No." <> '') AND (SalesHeaders."Job Type (Before Posting)" = 'SANJIVANI')
            AND (SalesHeaders."Sell-to Customer No." = SalesHeaders."Bill-to Customer No.")
            THEN
                CalcRemainingSanjivaniAmount(SalesHeaders)
        END;
        //Sipradi-YS Line Copy END
        /*
        //Lines copy standard
          REPEAT
           CASE TRUE OF
            (InvCount = 1) OR ((ServiceLine."Sell-to Customer Bill %" = 0) AND (InvCount = 2)):
             CreateSalesLine(SalesHeader,ServiceLine,NewSalesLine,100,NewLineNo,TRUE);

            (ServiceLine."Sell-to Customer Bill %" = 100) AND (InvCount = 2):
             CreateSalesLine(SalesHeader2,ServiceLine,NewSalesLine,100,NewLineNo2,TRUE);

            ((ServiceLine."Sell-to Customer Bill %" > 0) AND (ServiceLine."Sell-to Customer Bill %" < 100)) AND (InvCount = 2):
             BEGIN
              IF ServiceLine.Type = ServiceLine.Type::Item THEN BEGIN
                WITH ServiceHeader DO BEGIN
                  IF "To Whom Place Items"=0 THEN
                   BEGIN
                    "To Whom Place Items" := STRMENU(tcSer003+ServiceHeader."Sell-to Customer Name"+tcSer004+','+
                    tcSer003+ServiceHeader."Bill-to Name"+tcSer004);
                    IF "To Whom Place Items"=0 THEN ERROR(tcSer005); // ToWhomPlaceItems := 2; //Default "Bill-to Customer"
                    ServiceHeader.MODIFY;
                   END;
                  CASE "To Whom Place Items" OF
                    1: BEGIN   //Items goes to sell-to customer (salesheader2)
                      CreateSalesLine(SalesHeader2,ServiceLine,NewSalesLine,100,NewLineNo2,TRUE);
                      CreateBalanceSalesLine(SalesHeader2,NewSalesLine,-100 + ServiceLine."Sell-to Customer Bill %",NewLineNo2);
                      CreateBalanceSalesLine(SalesHeader,NewSalesLine,100 - ServiceLine."Sell-to Customer Bill %",NewLineNo);
                    END;
                    2: BEGIN //Items goes to bill-to customer (salesheader)
                      CreateSalesLine(SalesHeader,ServiceLine,NewSalesLine,100,NewLineNo,TRUE);
                      CreateBalanceSalesLine(SalesHeader,NewSalesLine,-ServiceLine."Sell-to Customer Bill %",NewLineNo);
                      CreateBalanceSalesLine(SalesHeader2,NewSalesLine,ServiceLine."Sell-to Customer Bill %",NewLineNo2)
                    END
                  END
                END
              END ELSE BEGIN
                CreateSalesLine(SalesHeader,ServiceLine,NewSalesLine,100-ServiceLine."Sell-to Customer Bill %",NewLineNo,TRUE);
                CreateSalesLine(SalesHeader2,ServiceLine,NewSalesLine,ServiceLine."Sell-to Customer Bill %",NewLineNo2,TRUE);
              END
             END;
           END;
          UNTIL ServiceLine.NEXT=0;
          */

    end;

    [Scope('Internal')]
    procedure GetInvCount(ServiceHeader: Record "25006145") InvCount: Integer
    var
        ServiceLine: Record "25006146";
    begin
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETFILTER(Type, '<>''''');
        ServiceLine.SETFILTER("Sell-to Customer Bill %", '<>0');
        IF (ServiceLine.COUNT = 0) OR (ServiceHeader."Sell-to Customer No." = ServiceHeader."Bill-to Customer No.") THEN
            InvCount := 1
        ELSE
            InvCount := 2;
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
        CompInfo: Record "79";
    begin
        //Creates customer's invoice header
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
            SalesHeader."No. Series" := GetNoSeriesCode2(SalesHeader);

        SalesHeader.INSERT(TRUE);

        //SalesHeader.VALIDATE("Posting Date", "Posting Date");  Job Close Date = Posting Date of Service Order.
        SalesHeader.VALIDATE("Posting Date", TODAY);
        SalesHeader.VALIDATE("Document Date", TODAY);
        SalesHeader.VALIDATE("Sell-to Customer No.", ServiceHeader."Sell-to Customer No.");
        SalesHeader.VALIDATE("Payment Method Code", "Payment Method Code");
        SalesHeader."Make Code" := "Make Code";
        SalesHeader."Model Code" := "Model Code";
        SalesHeader."Model Version No." := "Model Version No.";
        SalesHeader."Vehicle Serial No." := "Vehicle Serial No.";
        SalesHeader."Vehicle Accounting Cycle No." := "Vehicle Accounting Cycle No.";
        SalesHeader."Service Document" := TRUE;
        SalesHeader."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
        SalesHeader."Service Document No." := ServiceHeader."No.";
        SalesHeader."Order Date" := ServiceHeader."Order Date";
        SalesHeader."Posting No." := codNo;
        SalesHeader."Deal Type Code" := "Deal Type";
        SalesHeader."Vehicle Status Code" := "Vehicle Status Code";
        SalesHeader."Language Code" := ServiceHeader."Language Code";
        SalesHeader."Warranty Claim No." := "Warranty Claim No.";
        SalesHeader."Salesperson Code" := ServiceHeader."Service Person";
        SalesHeader."Delay Reason Code" := "Delay Reason Code"; //PSF
        SalesHeader."RV RR Code" := "RV RR Code";
        SalesHeader."Quality Control" := "Quality Control";
        SalesHeader."Floor Control" := "Floor Control";
        SalesHeader."Revisit Repair Reason" := "Revisit Repair Reason";
        SalesHeader."Resource PSF" := "Resources PSF";
        SalesHeader."Insurance Type" := "Insurance Type";//Bishesh Jimba
        SalesHeader."Insurance Company Name" := "Insurance Company Name";//Bishesh Jimba
        SalesHeader."Insurance Policy Number" := "Insurance Policy Number";//Bishesh Jimba
        CompInfo.GET;
        IF CompInfo."Balaju Auto Works" THEN BEGIN
            SalesHeader."Sell-to Address" := "Sell-to Address";
            SalesHeader."Sell-to Address 2" := "Sell-to Address 2";
            SalesHeader."Sell-to City" := "Sell-to City";
            SalesHeader."Sell-to Post Code" := "Sell-to Post Code";
            SalesHeader."Sell-to County" := "Sell-to County";
            SalesHeader."Sell-to Country/Region Code" := "Sell-to Country/Region Code";
            SalesHeader."Ship Add Name 2" := "Ship Add Name 2";
        END;


        //SM 14-07-2013 to copy the job category inserted in service header
        SalesHeader."Job Category" := "Job Category";
        SalesHeader."Service Type" := "Service Type";
        //SM 14-07-2013 to copy the job category inserted in service header


        //SS1.00
        SalesHeader."Scheme Code" := "Scheme Code";
        SalesHeader."Membership No." := "Membership No.";
        //SS1.00

        // Sipradi-YS BEGIN GEN6.1.0 - 33020235.1
        SalesHeader."Posting No. Series" := "Posting No. Series";
        // Sipradi-YS END
        //Sipradi - YS BEGINS
        SalesHeader."Responsibility Center" := "Responsibility Center";
        SalesHeader."Accountability Center" := "Accountability Center";
        SalesHeader."Package No." := "Package No.";
        SalesHeader."Job Type (Before Posting)" := ServiceHeader."Job Type";
        //Sipradi - YS ENDS
        //10.07.2009. S100 P2 >>
        SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type";
        SalesHeader."Applies-to Doc. No." := SalesHeader."Applies-to Doc. No.";
        //10.07.2009. S100 P2 <<

        FillSalesVariableFields(SalesHeader, ServiceHeader);
        //SalesHeader."DMS Variable Field 25006800" := "DMS Variable Field 25006800";
        //SalesHeader."DMS Variable Field 25006801" := "DMS Variable Field 25006801";
        //SalesHeader."DMS Variable Field 25006802" := "DMS Variable Field 25006802";

        SalesHeader.Kilometrage := Kilometrage;
        //02.28.2012 Sipradi-YS BEGIN

        //02.28.2012 SIpradi-YS END
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
        //13.07.2009. EDMS P2 >>
        //STANDAR CODE BELOW
        /*IF GetInvCount2(ServiceHeader) < 2 THEN BEGIN
          SalesHeader."Invoice Discount Calculation" := ServiceHeader."Invoice Discount Calculation";
          SalesHeader."Invoice Discount Value" := ServiceHeader."Invoice Discount Value";
        END;*/
        SalesHeader.MODIFY

    end;

    [Scope('Internal')]
    procedure CreateSalesLine(SalesHeader: Record "36"; var ServiceLine: Record "25006146"; var SalesLine: Record "37"; decPart: Decimal; var NewLineNo: Integer; UseServiceLineNo: Boolean)
    var
        GenPostSetup: Record "252";
        SalesInvHdr: Record "112";
        SalesShpmtHdr: Record "110";
        ItemLedgEntry: Record "32";
    begin

        //Creates a new sales line

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
        //SalesLine."Resource No. (Serv.)" := "Resource No."; //UPG2017
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
        //23.02.2012. Sipradi-YS BEGIN
        SalesLine."Job Type" := "Job Type";
        //23.02.2012. Sipradi-YS END
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
        SalesLine."Location Code" := "Location Code";
        SalesLine."Allow Line Disc." := TRUE;

        IF Type <> Type::" " THEN BEGIN
            SalesLine.VALIDATE("Unit of Measure Code", "Unit of Measure Code");
            SalesLine.VALIDATE(Quantity, Quantity * decPart / 100);
            SalesLine.VALIDATE("Unit Price", "Unit Price");
            SalesLine.VALIDATE("Unit Cost (LCY)");
            SalesLine.VALIDATE("Line Discount %", "Line Discount %");
        END;

        SalesLine."Unit Cost (LCY)" := "Unit Cost (LCY)";

        SalesLine."Part %" := decPart;

        //YS Sipradi Begins
        IF ServiceLine.Type = Type::Labor THEN
            SalesLine.Description := "Description 2"
        ELSE
            SalesLine.Description := Description;
        //YS Sipradi Ends

        SalesLine."Shipment Date" := SalesHeader."Posting Date";

        /*IF Type = Type::Labor THEN
          TESTFIELD("Resource No.");
        SalesLine."Mechanic No." := "Resource No.";*/

        SalesLine.VIN := SalesHeader.VIN;
        SalesLine."Vehicle Accounting Cycle No." := SalesHeader."Vehicle Accounting Cycle No.";
        SalesLine."Document Profile" := SalesLine."Document Profile"::Service;

        //13.07.2009. EDMS P2 >>
        /* IF GetInvCount2(ServiceHeader) < 2 THEN BEGIN
           SalesLine."Inv. Discount Amount" := "Inv. Discount Amount";
           SalesLine."Inv. Disc. Amount to Invoice" := "Inv. Disc. Amount to Invoice";
         END;*/
        //13.07.2009. EDMS P2 <<

        IF (Type = Type::Item) AND ServiceSetup."AutoApply Credit Memo" THEN BEGIN
            IF SalesHeader."Applies-to Doc. No." <> '' THEN BEGIN
                ItemLedgEntry.RESET;
                ItemLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
                SalesInvHdr.GET(SalesHeader."Applies-to Doc. No.");


                /*//P1 - Should be rebuilt
                IF SalesInvHdr."Linked Sales Shipment No." <> '' THEN
                 BEGIN
                  SalesShpmtHdr.GET(SalesInvHdr."Linked Sales Shipment No.");
                  ItemLedgEntry.SETRANGE("Document No.", SalesShpmtHdr."No.");
                  ItemLedgEntry.SETRANGE("Posting Date", SalesShpmtHdr."Posting Date");
                  ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Sale);
                  ItemLedgEntry.SETRANGE("Item No.", "No.");
                  ItemLedgEntry.SETRANGE(Quantity, - SalesLine.Quantity);
                  IF ItemLedgEntry.FINDFIRST THEN
                    SalesLine."Appl.-from Item Entry" := ItemLedgEntry."Entry No.";
                 END
                ELSE
                 BEGIN
                  ItemLedgEntry.SETRANGE("Document No.", SalesInvHdr."No.");
                  ItemLedgEntry.SETRANGE("Posting Date", SalesInvHdr."Posting Date");
                  ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Sale);
                  ItemLedgEntry.SETRANGE("Item No.", "No.");
                  ItemLedgEntry.SETRANGE(Quantity, - SalesLine.Quantity);
                  IF ItemLedgEntry.FINDFIRST THEN
                    SalesLine."Appl.-from Item Entry" := ItemLedgEntry."Entry No.";
                 END;
                */
            END;
        END;


        SalesLine."Prepayment %" := ServiceLine."Prepayment %";
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

        SalesLine."Variant Code" := "Variant Code";
        //17.07.2008. EDMS P2 >>
        ReserveServLine.TransServLineToSalesLine(
          ServiceLine, SalesLine, ServiceLine."Outstanding Qty. (Base)");
        //17.07.2008. EDMS P2 <<

        //28.10.2010 EDMSB P2 >>
        SalesLine."Standard Time" := "Standard Time";
        SalesLine."Campaign No." := "Campaign No.";
        FillSalesLineVariableFields(SalesLine, ServiceLine);
        SalesLine.Kilometrage := SalesHeader.Kilometrage;
        //28.10.2010 EDMSB P2 <<
        SalesLine."Shortcut Dimension 1 Code" := ServiceLine."Shortcut Dimension 1 Code";
        SalesLine."Shortcut Dimension 2 Code" := ServiceLine."Shortcut Dimension 2 Code";
        SalesLine."Package No." := "Package No.";

        SalesLine.INSERT;

    end;

    [Scope('Internal')]
    procedure CopyServDimToSales(ServiceHeader: Record "25006145"; var SalesHeader: Record "36")
    begin
        //Copying dimensions
        SalesHeader."Dimension Set ID" := ServiceHeader."Dimension Set ID"; //STPL 201 R2
        SalesHeader.MODIFY;
        /*
        //Deletes Line Dimensions
        DocDimSale.SETRANGE("Table ID",DATABASE::"Sales Header");
        DocDimSale.SETRANGE("Document Type",SalesHeader."Document Type");
        DocDimSale.SETRANGE("Document No.",SalesHeader."No.");
        DocDimSale.DELETEALL;
        
        DocDim.SETRANGE("Table ID",DATABASE::"Service Header EDMS");
        DocDim.SETRANGE("Document Type",ServiceHeader."Document Type");
        DocDim.SETRANGE("Document No.",ServiceHeader."No.");
        IF DocDim.FINDFIRST THEN
         REPEAT
          DocDimSale.COPY(DocDim);
          DocDimSale."Table ID" := DATABASE::"Sales Header";
          DocDimSale."Document Type" := SalesHeader."Document Type";
          DocDimSale."Document No." := SalesHeader."No.";
          DocDimSale.INSERT;
         UNTIL DocDim.NEXT = 0;
        
        //Deletes Line Dimensions
        DocDimSale.SETRANGE("Table ID",DATABASE::"Sales Line");
        DocDimSale.SETRANGE("Document Type",SalesHeader."Document Type");
        DocDimSale.SETRANGE("Document No.",SalesHeader."No.");
        DocDimSale.DELETEALL;
        
        DocDim.SETRANGE("Table ID",DATABASE::"Service Line EDMS");
        DocDim.SETRANGE("Document Type",ServiceHeader."Document Type");
        DocDim.SETRANGE("Document No.",ServiceHeader."No.");
        IF DocDim.FINDFIRST THEN
         REPEAT
          DocDimSale.COPY(DocDim);
          DocDimSale."Table ID" := DATABASE::"Sales Line";
          DocDimSale."Document Type" := SalesHeader."Document Type";
          DocDimSale."Document No." := SalesHeader."No.";
          DocDimSale.INSERT;
         UNTIL DocDim.NEXT = 0;
         */

    end;

    [Scope('Internal')]
    procedure GetNewInvoiceNo(ServiceHeader: Record "25006145") codNo: Code[20]
    var
        SalHed: Record "36";
        SalInv: Record "112";
        NoPost: Code[20];
    begin
        SalHed.SETFILTER("No.", ServiceHeader."No." + '*');
        IF SalHed.FIND('+') THEN BEGIN
            IF SalHed."No." = ServiceHeader."No." THEN
                codNo := ServiceHeader."No." + '-01'
            ELSE
                codNo := INCSTR(SalHed."No.");
        END
        ELSE
            codNo := ServiceHeader."No.";

        SalInv.SETFILTER("No.", ServiceHeader."No." + '*');
        IF SalInv.FIND('+') THEN BEGIN
            IF SalInv."No." = ServiceHeader."No." THEN
                NoPost := ServiceHeader."No." + '-01'
            ELSE
                NoPost := INCSTR(SalInv."No.");
        END
        ELSE
            NoPost := ServiceHeader."No.";

        IF codNo < NoPost THEN
            codNo := NoPost;
    end;

    [Scope('Internal')]
    procedure CreateBalanceSalesLine(SalesHeader: Record "36"; SalesLine: Record "37"; decPart: Decimal; var NewLineNo: Integer)
    var
        NewSalesLine: Record "37";
        recGenPostSetup: Record "252";
        GLAccount: Record "15";
    begin
        NewLineNo += 10000;

        ServiceSetup.TESTFIELD("Split Invc.Balance G/L Account");
        NewSalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        NewSalesLine.SETRANGE("Document No.", SalesHeader."No.");
        NewSalesLine.SETRANGE(NewSalesLine."No.", ServiceSetup."Split Invc.Balance G/L Account");

        NewSalesLine.INIT;
        NewSalesLine."Document Type" := SalesHeader."Document Type";
        NewSalesLine."Document No." := SalesHeader."No.";
        NewSalesLine."Line No." := NewLineNo;
        NewSalesLine."Make Code" := SalesLine."Make Code";
        NewSalesLine."Line Type" := SalesLine.Type;
        NewSalesLine."Campaign No." := SalesLine."Campaign No.";
        //23.02.2012. Sipradi-YS BEGIN
        NewSalesLine."Job Type" := SalesLine."Job Type";
        //23.02.2012. Sipradi-YS END
        NewSalesLine.Type := NewSalesLine.Type::"G/L Account";
        NewSalesLine."No." := ServiceSetup."Split Invc.Balance G/L Account";
        NewSalesLine."System-Created Entry" := TRUE;

        NewSalesLine.VALIDATE("No.");

        NewSalesLine."Location Code" := SalesLine."Location Code";
        NewSalesLine."Unit of Measure Code" := SalesLine."Unit of Measure Code";
        NewSalesLine."Allow Line Disc." := TRUE;
        IF SalesLine."Unit Price" <> 0 THEN
            NewSalesLine.VALIDATE(Quantity, (SalesLine."Line Amount" * decPart / 100) / SalesLine."Unit Price")
        ELSE
            NewSalesLine.VALIDATE(Quantity, 0);

        NewSalesLine.VALIDATE("Unit Price", SalesLine."Unit Price");
        NewSalesLine.VALIDATE("Unit Cost (LCY)");

        IF GLAccount.GET(NewSalesLine."No.") THEN
            NewSalesLine.Description := COPYSTR(SalesLine.Description + ' ' + GLAccount.Name, 1, MAXSTRLEN(NewSalesLine.Description))
        ELSE
            NewSalesLine.Description := SalesLine.Description;

        NewSalesLine."Shipment Date" := SalesHeader."Posting Date";

        NewSalesLine.VIN := SalesHeader.VIN;
        NewSalesLine."Vehicle Serial No." := SalesHeader."Vehicle Serial No.";
        NewSalesLine."Vehicle Accounting Cycle No." := SalesHeader."Vehicle Accounting Cycle No.";
        NewSalesLine."Document Profile" := NewSalesLine."Document Profile"::Service;

        NewSalesLine.INSERT;
    end;

    [Scope('Internal')]
    procedure PostSalesInvoices(var ServiceHeader: Record "25006145" temporary): Boolean
    var
        SalesHeader: Record "36";
        SalesHeader2: Record "36";
        SalesPost: Codeunit "80";
    begin
        COMMIT;
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
                SalesPost.RUN(SalesHeader2);/*
             IF NOT SalesPost.RUN(SalesHeader2) THEN
               ERROR(Text004,SalesHeader2.TABLECAPTION,SalesHeader2."No.")*/
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
        ServiceHeader := NewServiceHeader;

        //EDMS1.0.00 >>
        IF QtyType = QtyType::Invoicing THEN BEGIN
            CreateServPrepaymentLines(ServiceHeader, TempPrepaymentServiceLine, FALSE);
            MergeServiceLines(ServiceHeader, OldServiceLine, TempPrepaymentServiceLine, MergedServiceLines);
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
        IF ServiceLine.FIND('-') THEN
            REPEAT
                MergedServiceLine := ServiceLine;
                MergedServiceLine.INSERT;
            UNTIL ServiceLine.NEXT = 0;
        ServiceLine2.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine2.SETRANGE("Document No.", ServiceHeader."No.");
        IF ServiceLine2.FIND('-') THEN
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
    begin
        CreateServPrepaymentLines(ServiceHeader, TempPrepaymentServiceLine, TRUE);

        ServiceHeader.TESTFIELD("Document Type");
        ServiceHeader.TESTFIELD("Sell-to Customer No.");
        ServiceHeader.TESTFIELD("Bill-to Customer No.");
        ServiceHeader.TESTFIELD("Posting Date");
        ServiceHeader.TESTFIELD("Document Date");

        SourceCodeSetup.GET;
        SourceCode := SourceCodeSetup."Service Management EDMS";

        CreatePostedServiceHeader(ServiceHeader);
        CreatePsCallHeader(ServiceHeader); //***SM 21-07-2013 to insert data in the PS Calls Table
        UpdateWarrantyRegister(ServiceHeader);
        CreatePostedServiceLines(ServiceHeader);

        CopyServDimToPosted(ServiceHeader);

        //Copy SIE Assignment lines
        SIEAssgntLine.SETCURRENTKEY("Applies-to Type", "Applies-to Doc. Type", "Applies-to Doc. No.", "Line No.");
        SIEAssgntLine.SETRANGE("Applies-to Type", DATABASE::"Service Line EDMS");
        SIEAssgntLine.SETRANGE("Applies-to Doc. Type", SIEAssgntLine."Applies-to Doc. Type"::Order);
        SIEAssgntLine.SETRANGE("Applies-to Doc. No.", ServiceHeader."No.");
        IF SIEAssgntLine.COUNT > 0 THEN
            SIEAssgnt.MoveAssgntToPostedDocLine(DATABASE::"Service Line EDMS", ServiceHeader."Document Type",
            ServiceHeader."No.", 0, DATABASE::"Posted Serv. Order Line", ServiceHeader."Document Type",
            ServiceHeader."Posting No.", 0);
        SendSMSPost(ServiceHeader);
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
                    PstReturnOrdHeader."Variable Field Run 1" := ServiceOrder.Kilometrage;
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
                    //Sipradi-YS Following Lines are commented to get new no series for posted service document.
                    /*
                    IF ("Posting No." = '') THEN BEGIN
                      TESTFIELD("Posting No. Series");
                      "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series","Posting Date",TRUE);
                    END;

                    PstOrdHeader.TESTFIELD("No.");
                    PstOrdHeader."No." := "Posting No.";
                    PstOrdHeader."No. Series" := "Posting No. Series";
                    */
                    //Sipradi YS-END;
                    //Sipradi-YS BEGIN * Overiding Code
                    ServiceOrder.TESTFIELD("Order Posting No. Series");
                    "Posting No." := NoSeriesMgt.GetNextNo("Order Posting No. Series", ServiceOrder."Posting Date", TRUE);
                    PstOrdHeader.TESTFIELD("No.");
                    PstOrdHeader."No." := "Posting No.";
                    PstOrdHeader."No. Series" := "Order Posting No. Series";
                    //Sipradi-YS END;
                    PstOrdHeader."Order No." := ServiceOrder."No.";
                    PstOrdHeader."Order No. Series" := "No. Series";
                    IF ServiceSetup."Ext. Doc. No. Mandatory" THEN
                        ServiceOrder.TESTFIELD("External Document No.");

                    FillPstOrderVariableFields(PstOrdHeader, ServiceOrder);
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
        //suman

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
    begin
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        IF NOT ServiceLine.FIND('-') THEN
            EXIT;

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
            ServJnlLine."Shortcut Dimension 1 Code" := ServiceLine."Shortcut Dimension 1 Code";
            ServJnlLine."Shortcut Dimension 2 Code" := ServiceLine."Shortcut Dimension 2 Code";
            ServJnlLine."Gen. Bus. Posting Group" := ServiceLine."Gen. Bus. Posting Group";
            //09.05.2012 Sipradi-YS BEGIN
            ServJnlLine."Job Type" := ServiceLine."Job Type";
            ServJnlLine."Warranty Approved" := ServiceLine."Warranty Approved";
            ServJnlLine."Approved Date" := ServiceLine."Approved Date";
            ServJnlLine."Customer Verified" := ServiceLine."Customer Verified";
            ServJnlLine."Hour Reading" := "Hour Reading";
            ServJnlLine."External Service Purchased" := ServiceLine."External Service Purchased";
            ServJnlLine."Accountability Center" := "Accountability Center";
            ServJnlLine."Responsibility Center" := "Responsibility Center";
            //09.05.2012 SIpradi-YS END

            //SS1.00
            ServJnlLine."Scheme Code" := "Scheme Code";
            ServJnlLine."Membership No." := "Membership No.";
            //SS1.00

            //Agile CPJB 24/05/2016
            ServJnlLine."Job Category" := "Job Category";
            ServJnlLine."Service Type" := "Service Type";
            ServJnlLine."Job Type (Service Header)" := "Job Type";
            //Agile CPJB 24/05/2016

            //**SM 14-08-2013 for service reminder
            ServJnlLine."Next Service Date" := "Next Service Date";
            //**SM 14-08-2013 for service reminder

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
            END
            ELSE  //Return Order
             BEGIN
                ServJnlLine.Quantity := -ServiceLine.Quantity;
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

            //ServJnlLine."Variable Field Run 2" := "Variable Field Run 2";//nilesh
            ServJnlLine."Package No." := ServiceLine."Package No.";
            ServJnlLine."Package Version No." := ServiceLine."Package Version No.";
            ServJnlLine."Package Version Spec. Line No." := ServiceLine."Package Version Spec. Line No.";
            ServJnlLine."Currency Code" := ServiceHeader."Currency Code";
            ServJnlLine."Deal Type Code" := "Deal Type";

            //28.01.2010 EDMSB P2 >>
            ServJnlLine."Standard Time" := ServiceLine."Standard Time";
            ServJnlLine."Campaign No." := ServiceLine."Campaign No.";
            //28.01.2010 EDMSB P2 <<

            FillServJournalVariableFields(ServJnlLine, ServiceLine);
            ServJnlLine.Kilometrage := Kilometrage;
            ServJnlLine."Dimension Set ID" := ServiceLine."Dimension Set ID"; //STPL 2013 R2
                                                                              /*
                                                                              TempJnlLineDim.DELETEALL;
                                                                              TempDocDim.RESET;
                                                                              TempDocDim.SETRANGE("Table ID",DATABASE::"Service Line EDMS");
                                                                              TempDocDim.SETRANGE("Line No.",ServiceLine."Line No.");
                                                                              DimMgt.CopyDocDimToJnlLineDim(TempDocDim,TempJnlLineDim);
                                                                              */
            ServJnlPostLine.RunWithCheck(ServJnlLine);


            CASE ServiceHeader."Document Type" OF
                ServiceHeader."Document Type"::"Return Order":
                    BEGIN
                        PstReturnOrdLine.INIT;
                        PstReturnOrdLine.TRANSFERFIELDS(ServiceLine);
                        PstReturnOrdLine."Document No." := "Pst. Return Order No.";
                        PstReturnOrdLine.Resources := ServiceLine.Resources;
                        FillPstReturnLineVarFields(PstReturnOrdLine, ServiceLine);

                        PstReturnOrdLine.INSERT;
                        ScheduleMgt.PostingServLine(ServiceLine, "Pst. Return Order No.");

                    END;
                ServiceHeader."Document Type"::Order:
                    BEGIN
                        PstOrdLine.INIT;
                        PstOrdLine.TRANSFERFIELDS(ServiceLine);
                        PstOrdLine."Document No." := "Posting No.";

                        FillPstOrderLineVariableFields(PstOrdLine, ServiceLine);
                        PstOrdLine.Resources := ServiceLine.Resources;  //SRT
                        PstOrdLine.INSERT;

                        ScheduleMgt.PostingServLine(ServiceLine, "Posting No.");

                    END
            END;
        UNTIL GetNextServiceLine(ServiceLine);

    end;

    [Scope('Internal')]
    procedure CopyServDimToPosted(ServiceHeader: Record "25006145")
    begin
        /*DocDim.SETFILTER("Table ID",'%1|%2',DATABASE::"Service Header EDMS",DATABASE::"Service Line EDMS");
        DocDim.SETRANGE("Document Type",DocDim."Document Type"::Order);
        DocDim.SETRANGE("Document No.",ServiceHeader."No.");
        IF NOT DocDim.FINDFIRST THEN
         EXIT;
        
        REPEAT
         PostedDocDim.INIT;
          IF ServiceHeader."Document Type" = ServiceHeader."Document Type"::Order THEN BEGIN
            PostedDocDim."Document No." := ServiceHeader."Posting No.";
            IF DocDim."Table ID" = DATABASE::"Service Header EDMS" THEN
              PostedDocDim."Table ID" := DATABASE::"Posted Serv. Order Header"
            ELSE
              PostedDocDim."Table ID" := DATABASE::"Posted Serv. Order Line"
          END ELSE BEGIN
            PostedDocDim."Document No." := ServiceHeader."Pst. Return Order No.";
            IF DocDim."Table ID" = DATABASE::"Service Header EDMS" THEN
              PostedDocDim."Table ID" := DATABASE::"Posted Serv. Ret. Order Header"
            ELSE
              PostedDocDim."Table ID" := DATABASE::"Posted Serv. Return Order Line"
          END;
        
          PostedDocDim."Line No." := DocDim."Line No.";
          PostedDocDim."Dimension Code" := DocDim."Dimension Code";
          PostedDocDim."Dimension Value Code" := DocDim."Dimension Value Code";
         PostedDocDim.INSERT(TRUE);
        UNTIL DocDim.NEXT = 0;
        */

    end;

    [Scope('Internal')]
    procedure DeleteServiceOrder(ServiceOrder: Record "25006145")
    var
        ServiceLine: Record "25006146";
    begin
        //Dimensions
        /*
        DocDim.SETFILTER("Table ID",'%1|%2',DATABASE::"Service Header EDMS",DATABASE::"Service Line EDMS");
        DocDim.SETRANGE("Document Type",DocDim."Document Type"::Order);
        DocDim.SETRANGE("Document No.",ServiceOrder."No.");
        DocDim.DELETEALL;
        */
        IF ServiceOrder.HASLINKS THEN ServiceOrder.DELETELINKS;

        //Lines
        ServiceLine.SETRANGE("Document Type", ServiceLine."Document Type"::Order);
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
    begin
        ServCommentLine.SETRANGE(Type, FromDocumentType);
        ServCommentLine.SETRANGE("No.", FromNumber);
        IF ServCommentLine.FIND('-') THEN
            REPEAT
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
        IF ServCommentLine.FIND('-') THEN
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
        OldServiceLine.CalcVATAmountLines(QtyType, ServiceHeader, OldServiceLine, TempVATAmountLine);
        GLSetup.GET;
        SalesSetup.GET;
        GetCurrency;
        OldServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        OldServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        RoundingLineInserted := FALSE;
        IF OldServiceLine.FIND('-') THEN
            REPEAT
                IF NOT RoundingLineInserted THEN
                    ServiceLine := OldServiceLine;
                CASE QtyType OF
                    QtyType::General:
                        ServiceLineQty := ServiceLine.Quantity;
                    QtyType::Invoicing:
                        ServiceLineQty := ServiceLine.Quantity;
                END;
                DivideAmount(QtyType, ServiceLineQty);
                ServiceLine.Quantity := ServiceLineQty;
                IF ServiceLineQty <> 0 THEN BEGIN
                    IF (ServiceLine.Amount <> 0) AND NOT RoundingLineInserted THEN
                        IF TotalServiceLine.Amount = 0 THEN
                            TotalServiceLine."VAT %" := ServiceLine."VAT %"
                        ELSE
                            IF TotalServiceLine."VAT %" <> ServiceLine."VAT %" THEN
                                TotalServiceLine."VAT %" := 0;
                    RoundAmount(ServiceLineQty);
                    ServiceLine := TempServiceLine;
                END;
                IF InsertServiceLine THEN BEGIN
                    NewServiceLine := ServiceLine;
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

    local procedure DocDimMatch(ServiceLine: Record "25006146"; LineNo2: Integer): Boolean
    var
        Found: Boolean;
        Found2: Boolean;
    begin
        /*WITH DocDim DO BEGIN
          SETRANGE("Table ID",DATABASE::"Service Line EDMS");
          SETRANGE("Document Type",ServiceLine."Document Type");
          SETRANGE("Document No.",ServiceLine."Document No.");
          SETRANGE("Line No.",ServiceLine."Line No.");
          IF NOT FIND('-') THEN
            CLEAR(DocDim);
        END;
        WITH TempDocDim DO BEGIN
          SETRANGE("Table ID",DATABASE::"Service Line EDMS");
          SETRANGE("Document Type",ServiceLine."Document Type");
          SETRANGE("Document No.",ServiceLine."Document No.");
          SETRANGE("Line No.",LineNo2);
          IF NOT FIND('-') THEN
            CLEAR(TempDocDim);
        END;
        
        WHILE (DocDim."Dimension Code" = TempDocDim."Dimension Code") AND
              (DocDim."Dimension Value Code" = TempDocDim."Dimension Value Code") AND
              (DocDim."Dimension Code" <> '')
        DO BEGIN
          IF NOT DocDim.FIND('>') THEN
            CLEAR(DocDim);
          IF NOT TempDocDim.FIND('>') THEN
            CLEAR(TempDocDim);
        END;
        
        EXIT((DocDim."Dimension Code" = TempDocDim."Dimension Code") AND
            (DocDim."Dimension Value Code" = TempDocDim."Dimension Value Code"));
        */

    end;

    local procedure GetCurrency()
    begin
        IF ServiceHeader."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
        ELSE BEGIN
            Currency.GET(ServiceHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
        END;
    end;

    local procedure DivideAmount(QtyType: Option General,Invoicing,Shipping; ServiceLineQty: Decimal)
    begin
        IF RoundingLineInserted AND (RoundingLineNo = ServiceLine."Line No.") THEN
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

            IF ServiceHeader."Prices Including VAT" THEN BEGIN
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
                    Amount * (1 - ServiceHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
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
                        Amount * (1 - ServiceHeader."VAT Base Discount %" / 100), Currency."Amount Rounding Precision");
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
        TempServiceLine := ServiceLine;
        ServiceLineACY := ServiceLine;

        IF ServiceHeader."Currency Code" <> '' THEN BEGIN
            IF (ServiceLine."Document Type" IN [ServiceLine."Document Type"::Quote]) AND
               (ServiceHeader."Posting Date" = 0D)
            THEN
                UseDate := WORKDATE
            ELSE
                UseDate := ServiceHeader."Posting Date";

            NoVAT := Amount = "Amount Including VAT";
            "Amount Including VAT" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, ServiceHeader."Currency Code",
                  TotalServiceLine."Amount Including VAT", ServiceHeader."Currency Factor")) -
                    TotalServiceLineLCY."Amount Including VAT";
            IF NoVAT THEN
                Amount := "Amount Including VAT"
            ELSE
                Amount :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      UseDate, ServiceHeader."Currency Code",
                      TotalServiceLine.Amount, ServiceHeader."Currency Factor")) -
                        TotalServiceLineLCY.Amount;
            "Line Amount" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, ServiceHeader."Currency Code",
                  TotalServiceLine."Line Amount", ServiceHeader."Currency Factor")) -
                    TotalServiceLineLCY."Line Amount";
            "Line Discount Amount" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, ServiceHeader."Currency Code",
                  TotalServiceLine."Line Discount Amount", ServiceHeader."Currency Factor")) -
                    TotalServiceLineLCY."Line Discount Amount";
            "VAT Difference" :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  UseDate, ServiceHeader."Currency Code",
                  TotalServiceLine."VAT Difference", ServiceHeader."Currency Factor")) -
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
            CustPostingGr.GET(ServiceHeader."Customer Posting Group");
            CustPostingGr.TESTFIELD("Invoice Rounding Account");
            ServiceLine.INIT;
            NextLineNo := "Line No." + 10000;
            "System-Created Entry" := TRUE;
            IF UseTempData THEN BEGIN
                "Line No." := 0;
                Type := Type::"G/L Account";
            END ELSE BEGIN
                "Line No." := NextLineNo;
                ServiceLine.VALIDATE(Type, Type::"G/L Account");
            END;
            ServiceLine.VALIDATE("No.", CustPostingGr."Invoice Rounding Account");
            ServiceLine.VALIDATE(Quantity, 1);
            IF ServiceHeader."Prices Including VAT" THEN
                ServiceLine.VALIDATE("Unit Price", InvoiceRoundingAmount)
            ELSE
                ServiceLine.VALIDATE(
                  "Unit Price",
                  ROUND(
                    InvoiceRoundingAmount /
                    (1 + (1 - ServiceHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                    Currency."Amount Rounding Precision"));
            ServiceLine.VALIDATE("Amount Including VAT", InvoiceRoundingAmount);
            "Line No." := NextLineNo;
            /*
            IF NOT UseTempData THEN BEGIN
              DocDim2.SETRANGE("Table ID",DATABASE::"Service Line EDMS");
              DocDim2.SETRANGE("Document Type",ServiceHeader."Document Type");
              DocDim2.SETRANGE("Document No.",ServiceHeader."No.");
              DocDim2.SETRANGE("Line No.","Line No.");
              IF DocDim2.FIND('-') THEN
                REPEAT
                  TempDocDim := DocDim2;
                  TempDocDim.INSERT;
                UNTIL DocDim2.NEXT = 0;
            END;
            */
            LastLineRetrieved := FALSE;
            RoundingLineInserted := TRUE;
            RoundingLineNo := "Line No.";
        END;

    end;

    local procedure IncrAmount(var TotalServiceLine: Record "25006146")
    begin
        IF ServiceHeader."Prices Including VAT" OR
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
        ServiceHeader := NewServiceHeader;

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
        IF TempPrepaymentServiceLine.FIND('-') THEN BEGIN
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
            COMMIT;
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
        //PstOrdHeader."Variable Field 25006800" := '';
        //PstOrdHeader."Variable Field 25006801" := '';
        //PstOrdHeader."Variable Field 25006802" := '';

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
        Text001: Label 'Item %1 on %2 is not fully transfered to service location.';
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
                    ERROR(Text001, ServiceLine."No.", ServiceLine."Line No.");
            UNTIL ServiceLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CheckServiceHeader(ServiceHeader: Record "25006145")
    var
        ServiceLineEDMS: Record "25006146";
        ServLaborApplication: Record "25006277";
    begin
        IF ServiceHeader."Document Type" = ServiceHeader."Document Type"::Order THEN BEGIN
            ServiceSetup.GET;
            IF ServiceSetup."Fully Transfered Mandatory" THEN
                CheckFullyReservedToInventory(ServiceHeader);
        END;
        ServiceHeader.TESTFIELD("Job Type");
        ServiceHeader.TESTFIELD("Service Person");
        IF ServiceHeader."Document Type" = ServiceHeader."Document Type"::Order THEN BEGIN
            ServiceLineEDMS.RESET;
            ServiceLineEDMS.SETRANGE("Document No.", ServiceHeader."No.");
            ServiceLineEDMS.SETRANGE(Type, ServiceLineEDMS.Type::Labor);
            IF ServiceLineEDMS.FINDFIRST THEN
                REPEAT
                    ServLaborApplication.RESET;
                    ServLaborApplication.SETRANGE("Document Type", ServiceHeader."Document Type");
                    ServLaborApplication.SETRANGE("Document No.", ServiceLineEDMS."Document No.");
                    ServLaborApplication.SETRANGE("Document Line No.", ServiceLineEDMS."Line No.");
                    IF ServLaborApplication.FINDFIRST THEN BEGIN
                        ServiceLineEDMS.Resources := ServLaborApplication."Resource No.";
                        ServiceLineEDMS.MODIFY;
                        IF ServiceLineEDMS.Resources = '' THEN
                            ERROR('Resouce should not be blank in Document No. %1 and Line No. %2', ServiceLineEDMS."Document No.", ServiceLineEDMS."Line No.");  //ZM May 5, 2017
                    END ELSE
                        ERROR('Service Labor Application not found for Document no. %1, Document Line No. %2', ServiceLineEDMS."Document No.", ServiceLineEDMS."Line No.");  //ZM May 5, 2017

                UNTIL ServiceLineEDMS.NEXT = 0;
        END;
        IF ServiceSetup."Inbound/Outbound Consistency" THEN
            PendingTransferOrders(ServiceHeader);
    end;

    [Scope('Internal')]
    procedure GetInvCount2(ServiceHeader: Record "25006145") InvCount: Integer
    var
        ServiceLine: Record "25006146";
        i: Integer;
        j: Integer;
        DuplicateBillToCustomer: Boolean;
        k: Integer;
    begin
        //1.0 Finding Total Unique Service Lines Distingusing by Bill-to Customer Name.
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.FINDSET;
        k := 1;
        REPEAT
            i += 1;
            DuplicateBillToCustomer := FALSE;
            //  message('i='+format(i));
            IF i > 1 THEN
                FOR j := i - 1 DOWNTO 1 DO BEGIN
                    IF BillToCustomer[j] = ServiceLine."Bill-to Customer No." THEN BEGIN
                        DuplicateBillToCustomer := TRUE;
                        //message('j='+format(j));
                    END;
                END;
            IF NOT DuplicateBillToCustomer THEN BEGIN
                BillToCustomer[k] := ServiceLine."Bill-to Customer No.";
                InvCount += 1;
                k += 1;
                //message('k'+format(k));
            END
        UNTIL ServiceLine.NEXT = 0;
        //1.0 END
    end;

    [Scope('Internal')]
    procedure CreateSalesLine2(SalesHeader: Record "36"; var ServiceLine: Record "25006146"; var SalesLine: Record "37"; decPart: Decimal; var NewLineNo: Integer; UseServiceLineNo: Boolean)
    var
        GenPostSetup: Record "252";
        SalesInvHdr: Record "112";
        SalesShpmtHdr: Record "110";
        ItemLedgEntry: Record "32";
        WarrantyError: Label '%1 must be approved for "%2."';
        ExternalServiceNotPurchased: Label 'External Service %1 has not been Purchased.';
        ServMgtSetup: Record "25006120";
        Customer: Record "18";
        JobTypeMaster: Record "33020235";
    begin

        //Creates a new sales line
        IF ServiceLine.Type <> ServiceLine.Type::" " THEN BEGIN
            IF ServiceLine.Quantity = 0 THEN
                ERROR(QuantityZero, ServiceLine."Line No.");
            Customer.GET(ServiceLine."Bill-to Customer No.");
            IF NOT (Customer."Non-Billable") THEN BEGIN
                IF ServiceLine."Line Amount" = 0 THEN
                    ERROR(AmountZero, ServiceLine."Line No.");
            END;
        END;
        //JobTypeMaster.RESET;
        //JobTypeMaster.SETRANGE("No.",ServiceLine."Job Type");
        //JobTypeMaster.SETRANGE(Scheme,FALSE);
        //IF JobTypeMaster.FINDFIRST THEN BEGIN
        IF UseServiceLineNo THEN
            NewLineNo := ServiceLine."Line No."
        ELSE
            NewLineNo += 10000;
        //END;
        //SS1.00
        //JobTypeMaster.RESET;
        //JobTypeMaster.SETRANGE("No.","Job Type");
        //JobTypeMaster.SETRANGE(Scheme,FALSE);
        //IF JobTypeMaster.FINDFIRST THEN BEGIN
        //SS1.00
        SalesLine.INIT;
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := NewLineNo;
        SalesLine."Make Code" := "Make Code";
        SalesLine."Line Type" := Type;
        //SalesLine."Resource No. (Serv.)" := "Resource No."; //UPG2017
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
        //23.02.2012. Sipradi-YS BEGIN
        SalesLine."Responsibility Center" := "Responsibility Center";
        SalesLine."Accountability Center" := "Accountability Center";
        SalesLine."Warranty Approved" := "Warranty Approved";
        SalesLine."Approved Date" := "Approved Date";
        //23.02.2012. Sipradi-YS END

        //SS1.00
        SalesLine."Scheme Code" := "Scheme Code";
        SalesLine."Membership No." := "Membership No.";
        //SS1.00

        CASE Type OF
            Type::Labor:
                BEGIN
                    //Sipradi-YS BEGIN
                    /* IF (SalesLine."Job Type" = 'SANJIVANI') OR (SalesLine."Job Type" = 'SANJIVANI WARRANTY') THEN BEGIN
                       SalesLine.Type := SalesLine.Type::"G/L Account";
                       ServMgtSetup.GET;
                       SalesLine."No." := ServMgtSetup."Sanjivani Labor B/C Account No";
                     END
                     ELSE BEGIN
                       SalesLine.Type := SalesLine.Type::"G/L Account";
                       GenPostSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
                       SalesLine."No.":=GenPostSetup."Sales Account";
                     END;
                     */
                    //SIPRADI-YS END

                    SalesLine.Type := SalesLine.Type::"G/L Account";
                    GenPostSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
                    SalesLine."No." := GenPostSetup."Sales Account";

                END;

            Type::"External Service":
                BEGIN
                    SalesLine.Type := SalesLine.Type::"External Service";
                    SalesLine."No." := "No.";
                    ServiceLine.TESTFIELD(ServiceLine."External Serv. Tracking No.");
                    IF NOT "External Service Purchased" THEN
                        ERROR(ExternalServiceNotPurchased, "No.");
                END;

            Type::Item:
                BEGIN
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
        SalesLine."Location Code" := "Location Code";
        SalesLine."Allow Line Disc." := TRUE;

        IF Type <> Type::" " THEN BEGIN
            SalesLine.VALIDATE("Unit of Measure Code", "Unit of Measure Code");
            SalesLine.VALIDATE(Quantity, Quantity * decPart / 100);
            SalesLine.VALIDATE("Unit Price", "Unit Price");
            SalesLine.VALIDATE("Unit Cost (LCY)");
            SalesLine.VALIDATE("Line Discount %", "Line Discount %");
        END;

        SalesLine."Unit Cost (LCY)" := "Unit Cost (LCY)";

        SalesLine."Part %" := decPart;
        SalesLine.Description := Description;
        SalesLine."Description 2" := "Description 2";
        SalesLine."Shipment Date" := SalesHeader."Posting Date";
        /*
        IF Type = Type::Labor THEN
          TESTFIELD("Resource No.");
        */
        //Sipradi-YS BEGIN
        ServiceLine.TESTFIELD("Job Type");

        //7.30.2012
        //IF (Type IN [Type::Item,Type::Labor]) AND ("Job Type" = ServiceSetup."Warranty Job Type Code") THEN BEGIN
        IF ("Warranty Approved" <> TRUE) AND ("Need Approval" = TRUE) THEN
            ERROR(WarrantyError, "Job Type", Description);
        // END;
        //SIpradi-YS END

        SalesLine."Mechanic No." := "Resource No."; //UPG2017
        SalesLine.VIN := SalesHeader.VIN;
        SalesLine."Vehicle Accounting Cycle No." := SalesHeader."Vehicle Accounting Cycle No.";
        SalesLine."Document Profile" := SalesLine."Document Profile"::Service;

        //13.07.2009. EDMS P2 >>
        /*IF GetInvCount2(ServiceHeader) < 2 THEN BEGIN
          SalesLine."Inv. Discount Amount" := "Inv. Discount Amount";
          SalesLine."Inv. Disc. Amount to Invoice" := "Inv. Disc. Amount to Invoice";
        END;*/
        //13.07.2009. EDMS P2 <<

        IF (Type = Type::Item) AND ServiceSetup."AutoApply Credit Memo" THEN BEGIN
            IF SalesHeader."Applies-to Doc. No." <> '' THEN BEGIN
                ItemLedgEntry.RESET;
                ItemLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
                SalesInvHdr.GET(SalesHeader."Applies-to Doc. No.");


                /*//P1 - Should be rebuilt
                IF SalesInvHdr."Linked Sales Shipment No." <> '' THEN
                 BEGIN
                  SalesShpmtHdr.GET(SalesInvHdr."Linked Sales Shipment No.");
                  ItemLedgEntry.SETRANGE("Document No.", SalesShpmtHdr."No.");
                  ItemLedgEntry.SETRANGE("Posting Date", SalesShpmtHdr."Posting Date");
                  ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Sale);
                  ItemLedgEntry.SETRANGE("Item No.", "No.");
                  ItemLedgEntry.SETRANGE(Quantity, - SalesLine.Quantity);
                  IF ItemLedgEntry.FINDFIRST THEN
                    SalesLine."Appl.-from Item Entry" := ItemLedgEntry."Entry No.";
                 END
                ELSE
                 BEGIN
                  ItemLedgEntry.SETRANGE("Document No.", SalesInvHdr."No.");
                  ItemLedgEntry.SETRANGE("Posting Date", SalesInvHdr."Posting Date");
                  ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Sale);
                  ItemLedgEntry.SETRANGE("Item No.", "No.");
                  ItemLedgEntry.SETRANGE(Quantity, - SalesLine.Quantity);
                  IF ItemLedgEntry.FINDFIRST THEN
                    SalesLine."Appl.-from Item Entry" := ItemLedgEntry."Entry No.";
                 END;
                */
            END;
        END;
        SalesLine."Job Type" := "Job Type";
        SalesLine.Kilometrage := SalesHeader.Kilometrage;
        SalesLine."Prepayment %" := ServiceLine."Prepayment %";
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
        SalesLine."Variant Code" := "Variant Code";
        //17.07.2008. EDMS P2 >>
        ReserveServLine.TransServLineToSalesLine(
          ServiceLine, SalesLine, ServiceLine."Outstanding Qty. (Base)");
        //17.07.2008. EDMS P2 <<

        //28.10.2010 EDMSB P2 >>
        SalesLine."Standard Time" := "Standard Time";
        SalesLine."Campaign No." := "Campaign No.";
        FillSalesLineVariableFields(SalesLine, ServiceLine);
        //28.10.2010 EDMSB P2 <<
        SalesLine."Shortcut Dimension 1 Code" := ServiceLine."Shortcut Dimension 1 Code";
        SalesLine."Shortcut Dimension 2 Code" := ServiceLine."Shortcut Dimension 2 Code";

        SalesLine.INSERT;
        //END;
        //VSW6.1.2 Sipradi-YS 03.01.2013
        SalesLine.VALIDATE("Shortcut Dimension 1 Code", ServiceLine."Shortcut Dimension 1 Code");
        SalesLine.VALIDATE("Shortcut Dimension 2 Code", ServiceLine."Shortcut Dimension 2 Code");
        SalesLine."Dimension Set ID" := ServiceLine."Dimension Set ID"; //STPL 2013 R2
        SalesLine.MODIFY;

    end;

    local procedure GetNoSeriesCode2(SalesHeader: Record "36"): Code[10]
    begin
        CASE SalesHeader."Document Type" OF
            SalesHeader."Document Type"::Invoice:
                EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service, DocumentType::Invoice));
            SalesHeader."Document Type"::"Credit Memo":
                EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Service,
                     DocumentType::"Credit Memo"));
        END;
    end;

    [Scope('Internal')]
    procedure InsertJobsDone(ServiceHeader: Record "25006145")
    var
        Diagnosis: Record "25006148";
        ServiceLine: Record "25006146";
    begin
        /*ServiceLine.RESET;
        ServiceLine.SETCURRENTKEY("Document Type","Document No.");
        ServiceLine.SETRANGE("Document Type",ServiceLine."Document Type"::Order);
        ServiceLine.SETRANGE("Document No.",ServiceHeader."No.");
        ServiceLine.SETRANGE(Type,ServiceLine.Type::Labor);
        if serviceline.findset then begin
        repeat
          Diagnosis.reset;
          Diagnosis.setrange(type,Diagnosis.Type::"Service Order");
          Diagnosis.setrange("No.",ServiceHeader."No.");
          if diagnosis.findfirst then begin
            if Diagnosis."Jobs Done" = '' then begin
              Diagnosis."Jobs Done" := ServiceLine.Description;
              Diagnosis.Modify;
            end
            else if strlen(Diagnosis."Jobs Done") < (250-strlen(ServiceLine.Description)) then begin
              Diagnosis."Jobs Done" := Diagnosis."Jobs Done"+'; '+ServiceLine.Description;
              Diagnosis.Modify;
            end
            else begin
              if diagnosis.next(1) <> 0 then begin
        
              end;
            end;
          end;
        until ServiceLine.next=0;
        end;
        */

    end;

    [Scope('Internal')]
    procedure CalcRemainingSanjivaniAmount(SalesHeader: Record "36")
    var
        TotalIssuedAmount: Decimal;
        ServicePackage: Record "25006134";
        TotalPackageAmount: Decimal;
        InvalidAmount: Label 'Service Package Amount for Sanjivani (%1) cannot be %2.';
        NewLineNo: Integer;
        SalesLine2: Record "37";
        ServMgtSetup: Record "25006120";
        GenBus: Code[20];
        GenProd: Code[20];
        SanjivaniText: Label 'REMAINING SANJIVANI AMOUNT';
    begin
        TotalIssuedAmount := 0;
        NewLineNo := 0;
        SalesLine2.RESET;
        SalesLine2.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine2.SETRANGE("Document No.", SalesHeader."No.");
        IF SalesLine2.FINDLAST THEN
            NewLineNo := SalesLine2."Line No." + 10000;

        SalesLine2.RESET;
        SalesLine2.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine2.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine2.SETFILTER("Job Type", '%1|%2', 'SANJIVANI', 'SANIJIVANI WARRANTY');

        ServicePackage.RESET;
        ServicePackage.GET(SalesHeader."Package No.");
        IF ServicePackage."Total Amount (Sanjivani)" <= 0 THEN
            ERROR(InvalidAmount, ServicePackage."No.", ServicePackage."Total Amount (Sanjivani)");
        TotalPackageAmount := ServicePackage."Total Amount (Sanjivani)";
        IF SalesLine2.FINDFIRST THEN
            GenBus := SalesLine2."Gen. Bus. Posting Group";
        GenProd := SalesLine2."Gen. Prod. Posting Group";
        REPEAT
            TotalIssuedAmount += SalesLine2."Line Amount";
        UNTIL SalesLine2.NEXT = 0;

        //Insert Sales Line for Remaining Sanjivani Amount
        IF TotalIssuedAmount <> TotalPackageAmount THEN BEGIN
            SalesLine2.INIT;
            SalesLine2."Document Type" := SalesHeader."Document Type";
            SalesLine2."Document No." := SalesHeader."No.";
            SalesLine2."Line No." := NewLineNo;
            SalesLine2.Type := SalesLine2.Type::"G/L Account";

            ServMgtSetup.RESET;
            ServMgtSetup.GET;
            SalesLine2.VALIDATE("No.", ServMgtSetup."Sanjivani Rem. B/C Account No.");
            SalesLine2."Document Profile" := SalesLine2."Document Profile"::Service;
            SalesLine2."Service Order No. EDMS" := "Service Document No.";
            SalesLine2."Package No." := ServicePackage."No.";
            SalesLine2."Responsibility Center" := SalesHeader."Responsibility Center";
            SalesLine2."Accountability Center" := "Accountability Center";
            SalesLine2."Job Type" := 'SANJIVANI';

            SalesLine2.VALIDATE(Quantity, 1);
            SalesLine2.VALIDATE("Unit Price", TotalPackageAmount - TotalIssuedAmount);
            SalesLine2."Location Code" := SalesHeader."Location Code";
            SalesLine2.Description := SanjivaniText;
            SalesLine2."Shipment Date" := SalesHeader."Posting Date";
            SalesLine2.INSERT(TRUE);
            SalesLine2.VALIDATE("Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 1 Code");
            SalesLine2.VALIDATE("Shortcut Dimension 2 Code", SalesHeader."Shortcut Dimension 2 Code");

            SalesLine2.VALIDATE("Vehicle Serial No.", "Vehicle Serial No.");
            SalesLine2.Kilometrage := Kilometrage;
            //    SalesLine2."Gen. Prod. Posting Group" := ServMgtSetup."Sanjivani Gen. Bus. Posting Gr";
            //    SalesLine2."Gen. Prod. Posting Group" := ServMgtSetup."Sanjivani Gen. Pro. Posting Gr";
            SalesLine2.MODIFY;


        END;
    end;

    [Scope('Internal')]
    procedure FindDebitCustomer(CustomerCode: Code[20]): Boolean
    var
        Customer: Record "18";
    begin
        IF Customer.GET(CustomerCode) THEN
            EXIT(Customer."Non-Billable");
    end;

    [Scope('Internal')]
    procedure UpdateWarrantyRegister(ServHeader: Record "25006145")
    begin
        WarrantyEntries.RESET;
        WarrantyEntries.SETRANGE(WarrantyEntries."Service Order No.", ServHeader."No.");
        IF WarrantyEntries.FINDFIRST THEN BEGIN
            WarrantyEntries."Job Close Date" := ServHeader."Posting Date";
            WarrantyEntries.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure PendingTransferOrders(ServiceHeader: Record "25006145")
    var
        TransferHeader: Record "5740";
        TransferLine: Record "5741";
        ServiceLine: Record "25006146";
        ServiceQty: Decimal;
        ReceivedQty: Decimal;
        ReturnedQty: Decimal;
        WhatToReturn: Option Received,Returned;
        Text000: Label 'You have not returned %3 Qty. of Item : %1 (%2) to Store. Skipping this process will lead to accumulation of Inventory in Service.';
        TransRcptLine: Record "5747";
        TransRcptLine2: Record "5747";
        SelectedItem: array[150] of Code[20];
        TotalItem: Integer;
        j: Integer;
        SameItem: Boolean;
        Text001: Label '%3 Qty. of Item %1 (%2) has been received and has not been used in Service Order. So, Please return this item back to Store.Skipping this process will lead to accumulation of Inventory in Service.';
        Text002: Label 'Checking on #1##### #2#####';
        TransRcptHeader: Record "5746";
    begin
        TransferHeader.RESET;
        TransferHeader.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.", "Document Profile");
        TransferHeader.SETRANGE("Source Type", 25006145);
        TransferHeader.SETRANGE("Source Subtype", 1);
        TransferHeader.SETRANGE("Source No.", ServiceHeader."No.");

        IF TransferHeader.FINDSET THEN BEGIN
            ERROR(TransHdrExists);
            REPEAT
                TransferLine.RESET;
                TransferLine.SETRANGE("Document No.", TransferHeader."No.");
                IF TransferLine.FINDSET THEN
                    REPEAT
                        // 1) Checking if Receiving is missing.
                        IF TransferLine."Derived From Line No." <> 0 THEN
                            ERROR('Item No. %1 (%2) has been shipped (%3 Qty.) to %4 but not received yet in' +
                                  ' Transfer Order %5',
                                  TransferLine."Item No.", TransferLine.Description, TransferLine.Quantity,
                                  TransferLine."Transfer-to Code", TransferLine."Document No.")
                        // 2) Checking if Shipment is missing
                        ELSE
                            IF (TransferLine.Quantity > TransferLine."Quantity Shipped") AND
                               (TransferLine."Reason Code" = '') THEN
                                ERROR('There is pending Items in Transfer Order %4. ' +
                                      '%1 Qty. of Item No. %2 (%3) has not been shipped yet by %5.',
                                        TransferLine.Quantity - TransferLine."Quantity Shipped", TransferLine."Item No.",
                                        TransferLine.Description, TransferLine."Document No.", TransferLine."Transfer-from Code")

                    UNTIL TransferLine.NEXT = 0;
            UNTIL TransferHeader.NEXT = 0;
        END;

        // 3) Return if Qty in service line < (Qty. shipped by Store) - (Qty. Returned by Service)

        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETRANGE(Type, ServiceLine.Type::Item);
        IF ServiceLine.FINDSET THEN BEGIN
            REPEAT
                ServiceLine.CALCFIELDS("Total Qty.");
                ServiceQty := ServiceLine."Total Qty.";
                ReceivedQty := GetConcernedQty(ServiceHeader, ServiceLine."No.", WhatToReturn::Received);
                ReturnedQty := GetConcernedQty(ServiceHeader, ServiceLine."No.", WhatToReturn::Returned);
                IF (ServiceQty < ReceivedQty - ReturnedQty) THEN BEGIN
                    ERROR(Text000, ServiceLine."No.", ServiceLine.Description, ReceivedQty - ServiceQty - ReturnedQty)
                END;
            UNTIL ServiceLine.NEXT = 0;

        END;

        // 4) Return if items has not been used in service line

        TotalItem := 1;
        TransRcptHeader.RESET;
        TransRcptHeader.SETCURRENTKEY("Document Profile", "Source Type", "Source Subtype", "Source No.");
        TransRcptHeader.SETRANGE("Document Profile", TransRcptHeader."Document Profile"::Service);
        TransRcptHeader.SETRANGE("Source Type", 25006145);
        TransRcptHeader.SETRANGE("Source Subtype", 1);
        TransRcptHeader.SETRANGE("Source No.", ServiceHeader."No.");
        IF TransRcptHeader.FINDSET THEN
            REPEAT
                TransRcptLine.RESET;
                TransRcptLine.SETRANGE("Document No.", TransRcptHeader."No.");
                IF TransRcptLine.FINDSET THEN
                    REPEAT
                        TransRcptLine.CALCFIELDS("Source No.", "Line Exist in Job");
                        IF NOT TransRcptLine."Line Exist in Job" THEN BEGIN
                            SameItem := FALSE;
                            FOR j := 1 TO TotalItem DO BEGIN
                                IF SelectedItem[j] = TransRcptLine."Item No." THEN BEGIN
                                    SameItem := TRUE;
                                END;
                            END;
                            IF NOT SameItem THEN BEGIN
                                SelectedItem[TotalItem] := TransRcptLine."Item No.";
                                TotalItem += 1;
                                ReceivedQty := 0;
                                ReturnedQty := 0;
                                TransRcptLine2.RESET;
                                TransRcptLine2.SETRANGE("Item No.", TransRcptLine."Item No.");
                                TransRcptLine2.SETRANGE("Transfer-to Code", ServiceHeader."Location Code");
                                TransRcptLine2.SETRANGE("Source No.", ServiceHeader."No.");
                                IF TransRcptLine2.FINDSET THEN
                                    REPEAT
                                        ReceivedQty += TransRcptLine2.Quantity;
                                    UNTIL TransRcptLine2.NEXT = 0;
                                TransRcptLine2.RESET;
                                TransRcptLine2.SETRANGE("Item No.", TransRcptLine."Item No.");
                                TransRcptLine2.SETRANGE("Transfer-from Code", ServiceHeader."Location Code");
                                TransRcptLine2.SETRANGE("Source No.", ServiceHeader."No.");
                                IF TransRcptLine2.FINDSET THEN
                                    REPEAT
                                        ReturnedQty += TransRcptLine2.Quantity;
                                    UNTIL TransRcptLine2.NEXT = 0;
                                IF ReturnedQty < ReceivedQty THEN
                                    ERROR(Text001, TransRcptLine2."Item No.",
                                          TransRcptLine2.Description, ReceivedQty - ReturnedQty)
                            END;
                        END;
                    UNTIL TransRcptLine.NEXT = 0;
            UNTIL TransRcptHeader.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetConcernedQty(RecServHeader: Record "25006145"; ItemNo: Code[20]; WhatToReturn: Option Received,Returned): Decimal
    var
        ShipHeader: Record "5744";
        ShipLine: Record "5745";
        TransRcptHeader: Record "5746";
        TransRcptLine: Record "5747";
        Qty: Decimal;
    begin
        Qty := 0;
        TransRcptHeader.RESET;
        TransRcptHeader.SETCURRENTKEY("Document Profile", "Source Type", "Source Subtype", "Source No.");
        TransRcptHeader.SETRANGE("Document Profile", TransRcptHeader."Document Profile"::Service);
        TransRcptHeader.SETRANGE("Source Type", 25006145);
        TransRcptHeader.SETRANGE("Source Subtype", 1);
        TransRcptHeader.SETRANGE("Source No.", RecServHeader."No.");
        IF WhatToReturn = WhatToReturn::Received THEN
            TransRcptHeader.SETRANGE("Transfer-to Code", RecServHeader."Location Code")
        ELSE
            IF WhatToReturn = WhatToReturn::Returned THEN
                TransRcptHeader.SETRANGE("Transfer-from Code", RecServHeader."Location Code");
        IF TransRcptHeader.FINDSET THEN
            REPEAT
                TransRcptLine.RESET;
                TransRcptLine.SETRANGE("Document No.", TransRcptHeader."No.");
                TransRcptLine.SETRANGE("Item No.", ItemNo);
                IF TransRcptLine.FINDSET THEN
                    REPEAT
                        Qty += TransRcptLine.Quantity;
                    UNTIL TransRcptLine.NEXT = 0;
            UNTIL TransRcptHeader.NEXT = 0;
        EXIT(Qty);
    end;

    [Scope('Internal')]
    procedure CreatePsCallHeader(ServOrder: Record "25006145")
    var
        CustCompHeader: Record "33019847";
    begin
        //***SM 22-07-2013 to flow the data of the job card to post service call table
        IF "Job Type" <> 'PDI' THEN BEGIN
            CustCompHeader.LOCKTABLE;
            CustCompHeader.INIT;
            CustCompHeader.VALIDATE("Customer No.", ServOrder."Sell-to Customer No.");
            //CustCompHeader."Location Code" := ServOrder."Location Code";
            CustCompHeader."Service Person" := ServOrder."Service Person";
            CustCompHeader.VIN := VIN;
            CustCompHeader."Vehicle Registration No." := "Vehicle Registration No.";
            CustCompHeader.Kilometrage := Kilometrage;
            CustCompHeader."Make Code" := "Make Code";
            CustCompHeader."Model Code" := "Model Code";
            CustCompHeader."Model Version No." := "Model Version No.";
            CustCompHeader."Vehicle Serial No." := "Vehicle Serial No.";
            CustCompHeader."Vehicle Accounting Cycle No." := "Vehicle Accounting Cycle No.";
            CustCompHeader."Vehicle Status Code" := "Vehicle Status Code";
            CustCompHeader."Service Order No." := ServOrder."No.";
            CustCompHeader."Delivery Date" := ServOrder."Posting Date";
            CustCompHeader.INSERT(TRUE);
        END;
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

    [Scope('Internal')]
    procedure SendSMSPost(ServiceHdrEDMS: Record "25006145")
    var
        SMSTemplate: Record "33020257";
        SysMgt: Codeunit "50000";
    begin
        CheckMobileNo;
        ServiceHdrEDMS.CALCFIELDS("Amount Including VAT");
        IF "Amount Including VAT" > 0 THEN BEGIN
            SMSTemplate.RESET;
            SMSTemplate.SETRANGE(Type, SMSTemplate.Type::Job);
            IF SMSTemplate.FINDSET THEN
                SysMgt.InsertSMSDetail(SMSTemplate.Type::Job, ServiceHdrEDMS."No.", "Mobile No. for SMS", STRSUBSTNO(SMSTemplate."Message Text", ServiceHdrEDMS."Bill-to Name", "Vehicle Registration No.", "Amount Including VAT"));
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
        PSFHistory."Service Type" := "Job Type"; //"Service Type";//nilesh
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
        lineNo1: Integer;
        sttpl: Codeunit "50000";
    begin
        IF NOT sttpl.isBAW THEN
            EXIT;
        CLEAR(ServiceOrder);
        CLEAR(lineNo);

        ServHdr.RESET;
        ServHdr.SETRANGE("No.", ServNo);
        IF ServHdr.FINDFIRST THEN;

        lineNo := 0;
        ServiceOrder1.RESET;
        ServiceOrder1.SETRANGE("Document No.", ServNo);
        IF ServiceOrder1.FINDSET THEN
            REPEAT
                IF lineNo <= ServiceOrder1."Line No." THEN
                    lineNo := ServiceOrder1."Line No.";
            UNTIL ServiceOrder1.NEXT = 0;

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
            ServiceOrder."Posting Date" := TODAY;
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


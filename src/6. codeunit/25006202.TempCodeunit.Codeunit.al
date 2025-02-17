codeunit 25006202 "Temp.Codeunit"
{
    Permissions = TableData 17 = rim,
                  TableData 21 = rimd,
                  TableData 111 = rimd,
                  TableData 254 = rim,
                  TableData 5601 = rimd,
                  TableData 33020293 = rim;

    trigger OnRun()
    var
        DealerSync: Codeunit "33020509";
    begin
        //CreateUserSetup;
        /*
        //DealerSync.SetDealerCrMemoLine;
        */
        //UpdateNepDate;
        //UpdatepostingdateValueEntries;
        //MESSAGE('done');
        //UpdateBankLCNo;
        //UpdateCustLedgerEntryLCNo;
        //UpdateCostingMethodItem; //Amisha 5/12/2021
        //UpdateDealerPO;
        //UpdateDealerPONoThroughQuoteNo;
        //UpdateFADocumentType;
        //UpdateVariantILE;
        //MESSAGE('Sucess');
        //UpdateGLEntry;
        //UpdateFALedgerEntry;
        //UpdateCustNameMaterilaize;
        //UpdateExemptPurchNoInGLEntry;
        //UpdateExemptPurchNoInVATEntry;
        //DeleteSalesShipment;
        MESSAGE('done');

    end;

    var
        ChangeLogSetup: Record "402";
        Item: Record "27";
        ProgressWindow: Dialog;
        Text000: Label 'Total Records: #1######\Processed : #2########\Modifying...#3#######################';
        counttotal: Integer;
        FALedgerEntry: Record "5601";

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

    local procedure UpdatepostingdateValueEntries()
    var
        ValueEntry: Record "5802";
    begin
        ValueEntry.RESET;
        ValueEntry.SETFILTER("Entry No.", '6542526');
        IF ValueEntry.FINDFIRST THEN BEGIN
            ValueEntry."Posting Date" := 111919D;
            ValueEntry.MODIFY;
        END;
    end;

    local procedure UpdateBankLCNo()
    var
        CustLedgerEntry: Record "21";
        SalesInvHeader: Record "112";
        Progresswindow: Dialog;
        CountTotal: Integer;
    begin
        IF NOT CONFIRM('Do you want to update Bank LC No. in Customer Ledger Entries?') THEN
            ERROR('Aborted by user!');
        SalesInvHeader.RESET;
        SalesInvHeader.SETFILTER("Bank LC No.", '<>%1', '');
        Progresswindow.OPEN('Total Records: #1######\Document No : #2########\ Processed : #3########');
        Progresswindow.UPDATE(1, SalesInvHeader.COUNT);
        IF SalesInvHeader.FINDFIRST THEN BEGIN
            REPEAT
                SLEEP(1000);
                Progresswindow.UPDATE(2, SalesInvHeader."No.");
                CustLedgerEntry.RESET;
                CustLedgerEntry.SETRANGE("Document No.", SalesInvHeader."No.");
                CustLedgerEntry.SETRANGE("Document Type", CustLedgerEntry."Document Type"::Invoice);
                IF CustLedgerEntry.FINDFIRST THEN BEGIN
                    CustLedgerEntry."Bank LC No." := SalesInvHeader."Bank LC No.";
                    CustLedgerEntry.MODIFY;
                END;
                CountTotal += 1;
                Progresswindow.UPDATE(3, CountTotal);
            UNTIL SalesInvHeader.NEXT = 0;
        END;
        Progresswindow.CLOSE;
        MESSAGE('Update Successful!');
    end;

    local procedure UpdateCustLedgerEntryLCNo()
    var
        CustLedgerEntry: Record "21";
    begin
        IF NOT CONFIRM('Do you want to Update Posting Group in Value Entry.') THEN
            ERROR('Aborted by user.');
        ChangeLogSetup.GET;
        ChangeLogSetup."Change Log Activated" := FALSE;
        ChangeLogSetup.MODIFY;
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Document No.", 'CBAN77-00237');
        IF CustLedgerEntry.FINDFIRST THEN BEGIN
            CustLedgerEntry."Bank LC No." := 'NMB0BG777800441';
            CustLedgerEntry.MODIFY;
        END;
        ChangeLogSetup."Change Log Activated" := TRUE;
        ChangeLogSetup.MODIFY;
        MESSAGE('Successfully Updated...');
    end;

    local procedure UpdateCostingMethodItem()
    begin
        Item.RESET;
        Item.SETRANGE(Inventory, 0);
        Item.SETRANGE("Costing Method", Item."Costing Method"::FIFO);
        ProgressWindow.OPEN(Text000);
        ProgressWindow.UPDATE(1, Item.COUNT);
        IF Item.FINDSET THEN BEGIN
            REPEAT
                ProgressWindow.UPDATE(3, Item.COUNT);
                Item."Costing Method" := Item."Costing Method"::Average;
                Item.MODIFY;
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
    var
        SalesInvHead: Record "112";
        SalesHdrArchive: Record "5107";
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

    local procedure UpdateFADocumentType()
    var
        FALedgEntry: Record "5601";
        GLEntry: Record "17";
    begin
        FALedgEntry.RESET;
        //FALedgEntry.SETRANGE("Document No.",'JVHO75-00008|FAGLAI076-00002');
        FALedgEntry.SETRANGE("Document No.", 'JVHO75-00008');
        IF FALedgEntry.FINDSET THEN
            REPEAT
                FALedgEntry."FA Posting Type" := FALedgEntry."FA Posting Type"::"Acquisition Cost";
                FALedgEntry.MODIFY;
            UNTIL FALedgEntry.NEXT = 0;
    end;

    local procedure UpdateVariantILE()
    var
        ItemLedgerEntry: Record "32";
    begin
        IF NOT CONFIRM('Do you want to Update Variant Code in Item Ledger Entry ?') THEN
            ERROR('Aborted by user.');
        IF ItemLedgerEntry.GET('3407553') THEN BEGIN
            ItemLedgerEntry."Variant Code" := '1';
            ItemLedgerEntry.MODIFY;
        END;
        MESSAGE('Updated Successfully.');
    end;

    local procedure SalesInvLineCorr()
    var
        SalesInvLine: Record "113";
    begin
        SalesInvLine.RESET;
        SalesInvLine.SETRANGE("Document No.", 'BHWSPI78-00001');
        SalesInvLine.SETFILTER("Line No.", '20000');
        IF SalesInvLine.FINDFIRST THEN BEGIN
            SalesInvLine."Line Amount" := 705660.33;
            SalesInvLine.MODIFY;
        END;
    end;

    local procedure SalesInvNoofPrintUpdate()
    var
        SalesInvHeader: Record "112";
    begin
        SalesInvHeader.RESET;
        SalesInvHeader.SETRANGE("No.", 'BHWSPI78-00006');
        IF SalesInvHeader.FINDFIRST THEN BEGIN
            SalesInvHeader."No. Printed" := 0;
            SalesInvHeader.MODIFY;
        END;
    end;

    local procedure UpdateGLEntry()
    var
        GLEntry: Record "17";
    begin
        GLEntry.RESET;
        GLEntry.SETRANGE("Entry No.", 12268);
        IF GLEntry.FINDFIRST THEN BEGIN
            GLEntry."G/L Account No." := '703003';
            GLEntry.MODIFY;
        END;
        MESSAGE('success');
    end;

    local procedure UpdateFALedgerEntry()
    begin
        FALedgerEntry.RESET;
        FALedgerEntry.SETRANGE("Entry No.", 777);
        IF FALedgerEntry.FINDFIRST THEN BEGIN
            FALedgerEntry."Debit Amount" := 0;
            FALedgerEntry.MODIFY;
        END;
        MESSAGE('success');
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
        //SalesInvMat.SETRANGE("Bill No",'BRRSPI78-01739');
        SalesInvMat.SETRANGE("Bill Date", 101821D, 111621D);
        ProgressWindow.OPEN(Text000);
        ProgressWindow.UPDATE(1, SalesInvMat.COUNT);
        IF SalesInvMat.FINDSET THEN
            REPEAT
                IF Cust.GET(SalesInvMat."Customer Code") THEN BEGIN
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
        GLEntry.SETFILTER("Document No.", 'AHOIPPI78-000849');
        GLEntry.SETRANGE("Document Type", GLEntry."Document Type"::Invoice);
        IF GLEntry.FINDFIRST THEN
            REPEAT
                GLEntry."Exempt Purchase No." := 'EXPT78-00004';
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
        VatEntry.SETFILTER("Document No.", 'AHOIPPI78-000849');
        IF VatEntry.FINDFIRST THEN
            REPEAT
                VatEntry."Exempt Purchase No." := 'EXPT78-00004';
                VatEntry.MODIFY;
            UNTIL VatEntry.NEXT = 0;
        ChangeLogSetup."Change Log Activated" := TRUE;
        ChangeLogSetup.MODIFY;
        MESSAGE('Successfully Updated...');
    end;

    local procedure DeleteSalesShipment()
    var
        SalesShipmentLine: Record "111";
    begin
        SalesShipmentLine.RESET;
        SalesShipmentLine.SETRANGE("Document No.", 'BIRSPS80-01050');
        SalesShipmentLine.SETFILTER("Line No.", '%1|%2|%3|%4|%5|%6|%7|%8|%9|%10', 180000, 190000, 200000, 210000, 220000, 230000, 240000, 250000, 260000, 270000);
        IF SalesShipmentLine.FINDSET THEN
            REPEAT
                SalesShipmentLine.DELETE;
            UNTIL SalesShipmentLine.NEXT = 0;
    end;
}


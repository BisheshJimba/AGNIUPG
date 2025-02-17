codeunit 33019964 "Fuel Issue - Post + Print"
{
    TableNo = 33019963;

    trigger OnRun()
    begin
        //Copying the records.
        GlobalFuelIssEntry.COPY(Rec);

        //Check document before posting.
        IF (GlobalFuelIssEntry."Document Type" = GlobalFuelIssEntry."Document Type"::Coupon) THEN
            GlobalFuelIssueChkDoc.CouponCheckDocument(GlobalFuelIssEntry)
        ELSE
            IF (GlobalFuelIssEntry."Document Type" = GlobalFuelIssEntry."Document Type"::Stock) THEN
                GlobalFuelIssueChkDoc.StockCheckDocument(GlobalFuelIssEntry)
            ELSE
                IF (GlobalFuelIssEntry."Document Type" = GlobalFuelIssEntry."Document Type"::Cash) THEN
                    GlobalFuelIssueChkDoc.CashCheckDocument(GlobalFuelIssEntry);

        //Checking for approval for Demo movement type.
        //GlobalFuelIssueChkDoc.checkMovementType(GlobalFuelIssEntry);

        //Checking for Fuel Issue Limit per user.
        //GlobalFuelIssueChkDoc.checkUserIssueLimit(GlobalFuelIssEntry);

        //Inserting Posted Fuel Issue Entry.
        insertPostedFuelEntry(GlobalFuelIssEntry);

        //Inserting Ledger Entry.
        insertLedgerEntry(GlobalFuelIssEntry);

        //Viewing report.
        printDocument(GlobalFuelIssEntry);
        COMMIT;

        //Delete Records after posting.
        deleteFuelEntry(GlobalFuelIssEntry);
    end;

    var
        GlobalFuelIssEntry: Record "33019963";
        GlobalPostedFuelIssueEntry: Record "33019967";
        GlobalFuelIssueLedEntry: Record "33019965";
        GlobalFuelRegister: Record "33019969";
        GlobalFuelIssueLedEntry2: Record "33019965";
        GlobalFuelIssueChkDoc: Codeunit "33019974";

    [Scope('Internal')]
    procedure insertPostedFuelEntry(ParmFuelIssEntry1: Record "33019963")
    var
        Window: Dialog;
        Text33019961: Label 'Posting -  ##1#####################';
    begin
        //Inserting Posted Fuel Issue Entry.
        Window.OPEN(Text33019961);
        Window.UPDATE(1, STRSUBSTNO('%1,%2', ParmFuelIssEntry1."Document Type", ParmFuelIssEntry1."No."));
        GlobalPostedFuelIssueEntry.INIT;
        GlobalPostedFuelIssueEntry.TRANSFERFIELDS(ParmFuelIssEntry1);
        GlobalPostedFuelIssueEntry.INSERT;
        Window.CLOSE;
    end;

    [Scope('Internal')]
    procedure insertLedgerEntry(ParmFuelIssueEntry2: Record "33019963")
    begin
        GlobalFuelIssueLedEntry.INIT;
        GlobalFuelIssueLedEntry."Entry No." := getLedEntryNo + 1;
        GlobalFuelIssueLedEntry."Document Type" := ParmFuelIssueEntry2."Document Type";
        GlobalFuelIssueLedEntry."Document No." := ParmFuelIssueEntry2."No.";
        GlobalFuelIssueLedEntry.VIN := ParmFuelIssueEntry2."VIN (Chasis No.)";
        GlobalFuelIssueLedEntry."From City" := ParmFuelIssueEntry2."From City Code";
        GlobalFuelIssueLedEntry."To City" := ParmFuelIssueEntry2."To City Code";
        GlobalFuelIssueLedEntry."Issue Type" := ParmFuelIssueEntry2."Issue Type";
        GlobalFuelIssueLedEntry."Movement Type" := ParmFuelIssueEntry2."Movement Type";
        GlobalFuelIssueLedEntry.Description := ParmFuelIssueEntry2."Purpose of Travel";
        GlobalFuelIssueLedEntry."Fuel Type" := ParmFuelIssueEntry2."Fuel Type";
        GlobalFuelIssueLedEntry."Petrol Pump" := ParmFuelIssueEntry2."Petrol Pump Code";
        GlobalFuelIssueLedEntry."Issued Coupon No." := ParmFuelIssueEntry2."Issued Coupon No.";
        GlobalFuelIssueLedEntry."Issued Date" := ParmFuelIssueEntry2."Issue Date";
        GlobalFuelIssueLedEntry."Posting Type" := GlobalFuelIssueLedEntry."Posting Type"::"Negative Adjmt.";
        GlobalFuelIssueLedEntry."Issued For" := "Issued For";
        GlobalFuelIssueLedEntry.Location := ParmFuelIssueEntry2.Location;
        GlobalFuelIssueLedEntry.Department := ParmFuelIssueEntry2.Department;
        GlobalFuelIssueLedEntry."Staff No." := "Staff No.";
        GlobalFuelIssueLedEntry."Vehicle Registration No." := "Registration No.";
        GlobalFuelIssueLedEntry.Manufacturer := Manufacturer;
        GlobalFuelIssueLedEntry.Amount := "Amount (Rs.)";
        GlobalFuelIssueLedEntry."Add. From City" := "Add. From City Code";
        GlobalFuelIssueLedEntry."Add. To City" := "Add. To City Name";
        GlobalFuelIssueLedEntry."Issued By" := "Issued By";
        GlobalFuelIssueLedEntry."Unit of Measure" := "Unit of Measure";
        GlobalFuelIssueLedEntry.Rate := "Rate (Rs.)";
        GlobalFuelIssueLedEntry.Quantity := "Total Fuel Issued" + "Add. Total Fuel Issued";
        GlobalFuelIssueLedEntry."Posting Date" := TODAY;
        GlobalFuelIssueLedEntry."Vehicle Last Visit KM" := "Kilometerage (KM)";
        GlobalFuelIssueLedEntry."Document Date" := "Document Date";
        GlobalFuelIssueLedEntry."User ID" := USERID;
        GlobalFuelIssueLedEntry."Source Code" := "Source Code";
        GlobalFuelIssueLedEntry.INSERT;

        //Copying the records.
        GlobalFuelIssueLedEntry2.COPY(GlobalFuelIssueLedEntry);

        //Inserting Fuel Register.
        insertFuelRegister(GlobalFuelIssueLedEntry2);
    end;

    [Scope('Internal')]
    procedure insertFuelRegister(ParmFuelLedgEntry3: Record "33019965")
    begin
        GlobalFuelRegister.INIT;
        GlobalFuelRegister."Entry No." := getFLRegEntryNo + 1;
        GlobalFuelRegister."Document No." := ParmFuelLedgEntry3."Document No.";
        GlobalFuelRegister."Creation Date" := TODAY;
        GlobalFuelRegister."Source Code" := ParmFuelLedgEntry3."Source Code";
        GlobalFuelRegister."User ID" := USERID;
        GlobalFuelRegister."From Entry No." := ParmFuelLedgEntry3."Entry No.";
        GlobalFuelRegister."To Entry No." := ParmFuelLedgEntry3."Entry No.";
        GlobalFuelRegister."Entry From" := GlobalFuelRegister."Entry From"::Fuel;
        GlobalFuelRegister.INSERT;
    end;

    [Scope('Internal')]
    procedure getLedEntryNo(): Integer
    var
        LocalFuelLedEntry: Record "33019965";
    begin
        LocalFuelLedEntry.RESET;
        IF LocalFuelLedEntry.FIND('+') THEN
            EXIT(LocalFuelLedEntry."Entry No.");
    end;

    [Scope('Internal')]
    procedure getFLRegEntryNo(): Integer
    var
        LocalFuelRegister: Record "33019969";
    begin
        LocalFuelRegister.RESET;
        IF LocalFuelRegister.FIND('+') THEN
            EXIT(LocalFuelRegister."Entry No.");
    end;

    [Scope('Internal')]
    procedure deleteFuelEntry(ParmFuelIssueEntry4: Record "33019963")
    var
        LocalFuelIssueEntry2: Record "33019963";
    begin
        LocalFuelIssueEntry2.RESET;
        LocalFuelIssueEntry2.SETRANGE("Document Type", ParmFuelIssueEntry4."Document Type");
        LocalFuelIssueEntry2.SETRANGE("No.", ParmFuelIssueEntry4."No.");
        IF LocalFuelIssueEntry2.FIND('-') THEN
            LocalFuelIssueEntry2.DELETEALL;
    end;

    [Scope('Internal')]
    procedure printDocument(ParmFuelIssueEntry5: Record "33019963")
    var
        LocalPostedFuelIssueEntry: Record "33019967";
        LocalPostedFuelDocCoupon: Report "33019962";
    begin
        IF ParmFuelIssueEntry5."Document Type" = ParmFuelIssueEntry5."Document Type"::Coupon THEN BEGIN
            LocalPostedFuelIssueEntry.RESET;
            LocalPostedFuelIssueEntry.SETRANGE("Document Type", ParmFuelIssueEntry5."Document Type");
            LocalPostedFuelIssueEntry.SETRANGE("No.", ParmFuelIssueEntry5."No.");
            REPORT.RUN(33019962, FALSE, TRUE, LocalPostedFuelIssueEntry);
        END ELSE
            IF ParmFuelIssueEntry5."Document Type" = ParmFuelIssueEntry5."Document Type"::Stock THEN BEGIN
                LocalPostedFuelIssueEntry.RESET;
                LocalPostedFuelIssueEntry.SETRANGE("Document Type", ParmFuelIssueEntry5."Document Type");
                LocalPostedFuelIssueEntry.SETRANGE("No.", ParmFuelIssueEntry5."No.");
                REPORT.RUN(33019964, FALSE, TRUE, LocalPostedFuelIssueEntry);
            END ELSE
                IF ParmFuelIssueEntry5."Document Type" = ParmFuelIssueEntry5."Document Type"::Cash THEN BEGIN
                    LocalPostedFuelIssueEntry.RESET;
                    LocalPostedFuelIssueEntry.SETRANGE("Document Type", ParmFuelIssueEntry5."Document Type");
                    LocalPostedFuelIssueEntry.SETRANGE("No.", ParmFuelIssueEntry5."No.");
                    REPORT.RUN(33019966, FALSE, TRUE, LocalPostedFuelIssueEntry);
                END;
    end;
}


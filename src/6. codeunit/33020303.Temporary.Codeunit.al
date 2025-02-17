codeunit 33020303 "Temporary"
{
    Permissions = TableData 17 = rm,
                  TableData 25 = rm,
                  TableData 254 = rm,
                  TableData 5802 = m;

    trigger OnRun()
    begin
        //UpdateServiceOrderNo;
        //UpdateIRDSyncStatus;
        //UpdateSavedVendor;
        //UpdateStartEndDateTime;    //<< MIN 4/28/2019
        //UpdateJobCategoryinServiceline();
        //"UpdateJobCat&SeTyinServiceLedg";
        //UpdateDocumentProfileinValueEn();
        //UpdatePurchaseLine();
        //UpdatePurchaseReceiptLine();
        ////timesprinted
        //UpdateUnitCostZeroSundryAssets;
        //UpdateVatentry;
        //UpdateNepaliDate;
        //UpdateGLEntrywithdocumentNo;
        //MESSAGE(FORMAT(Alphanumeric('213234332')));
        //UpdateModificationDateItems;
    end;

    var
        counttotal: Integer;
        GLEntry: Record "17";
        "count": Integer;

    [Scope('Internal')]
    procedure UpdateLeaveEntries()
    var
        LeaveRegister: Record "33020343";
        LeaveAccount: Record "33020370";
        EmployeeRec: Record "5200";
        BalanceDays: Decimal;
        EarnDays: Decimal;
        UsedDays: Decimal;
    begin
        EmployeeRec.RESET;
        IF EmployeeRec.FINDSET THEN BEGIN
            REPEAT
                BalanceDays := 0;
                EarnDays := 0;
                UsedDays := 0;
                LeaveRegister.RESET;
                LeaveRegister.SETRANGE("Employee No.", EmployeeRec."No.");
                LeaveRegister.SETRANGE("Leave Type Code", 'CL');
                IF LeaveRegister.FINDSET THEN BEGIN
                    REPEAT
                        BalanceDays := LeaveRegister."Earn Days" - LeaveRegister."Used Days" + BalanceDays;
                        LeaveRegister."Balance Days" := BalanceDays;
                        LeaveRegister.MODIFY;
                        EarnDays += LeaveRegister."Earn Days";
                        UsedDays += LeaveRegister."Used Days";
                    UNTIL LeaveRegister.NEXT = 0;
                END;
                LeaveAccount.RESET;
                LeaveAccount.SETRANGE("Employee Code", EmployeeRec."No.");
                LeaveAccount.SETRANGE("Leave Type", 'CL');
                IF LeaveAccount.FINDFIRST THEN BEGIN
                    LeaveAccount."Earned Days" := EarnDays;
                    LeaveAccount."Used Days" := UsedDays;
                    LeaveAccount."Balance Days" := BalanceDays;
                    LeaveAccount.MODIFY;
                END;
                counttotal += 1;
            UNTIL EmployeeRec.NEXT = 0;
            MESSAGE('Updated: %1', counttotal);
        END;
    end;

    [Scope('Internal')]
    procedure LeaveRegisterForEarn()
    var
        LeaveRegister: Record "33020343";
    begin
        LeaveRegister.RESET;
        LeaveRegister.SETFILTER(Remarks, 'AUTO INSERTED');
        IF LeaveRegister.FINDSET THEN BEGIN
            REPEAT
                IF LeaveRegister."Leave Start Date" = 0D THEN BEGIN
                    LeaveRegister."Leave Start Date" := LeaveRegister."Request Date";
                    LeaveRegister."Leave End Date" := LeaveRegister."Request Date";
                    LeaveRegister.MODIFY;
                END;
            UNTIL LeaveRegister.NEXT = 0;
            MESSAGE('Complete');
        END;
    end;

    [Scope('Internal')]
    procedure SalaryLdrEnt()
    var
        SalaryLedgerEntry: Record "33020520";
    begin
        SalaryLedgerEntry.RESET;
        SalaryLedgerEntry.SETFILTER("Basic Salary", '0');
        IF SalaryLedgerEntry.FINDFIRST THEN
            REPEAT
                SalaryLedgerEntry."Irregular Process" := TRUE;
                SalaryLedgerEntry.MODIFY;
            UNTIL SalaryLedgerEntry.NEXT = 0;
        MESSAGE('Updated!');
    end;

    [Scope('Internal')]
    procedure ClearPayrollUsage()
    var
        PayrollUsage: Record "33020504";
    begin
        PayrollUsage.RESET;
        IF PayrollUsage.FINDSET THEN
            REPEAT
                PayrollUsage."Applicable Month" := PayrollUsage."Applicable Month"::" ";
                PayrollUsage."Applicable from" := 0D;
                PayrollUsage."Applicable to" := 0D;
                PayrollUsage.MODIFY;
            UNTIL PayrollUsage.NEXT = 0;

        MESSAGE('Updated!');
    end;

    [Scope('Internal')]
    procedure UpdateJobCategoryinServiceline()
    var
        ServicelineEDMS: Record "25006146";
        ServiceheaderEDMS: Record "25006145";
    begin
        ServicelineEDMS.RESET;
        IF ServicelineEDMS.FINDSET THEN BEGIN
            REPEAT
                ServiceheaderEDMS.RESET;
                ServiceheaderEDMS.SETRANGE("Document Type", ServiceheaderEDMS."Document Type"::Order);
                ServiceheaderEDMS.SETRANGE("No.", ServicelineEDMS."Document No.");
                IF ServiceheaderEDMS.FINDFIRST THEN BEGIN
                    ServicelineEDMS."Job Category" := ServiceheaderEDMS."Job Category";
                    ServicelineEDMS.MODIFY;
                END;
            UNTIL ServicelineEDMS.NEXT = 0;
        END;
        MESSAGE('Updated!');
    end;

    [Scope('Internal')]
    procedure "UpdateJobCat&SeTyinServiceLedg"()
    var
        ServiceLedgerEntry: Record "25006167";
        PostedServiceOrderHeader: Record "25006149";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETRANGE("Posting Date", 030116D, 053116D);
        IF ServiceLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                PostedServiceOrderHeader.RESET;
                PostedServiceOrderHeader.SETRANGE("Order No.", ServiceLedgerEntry."Service Order No.");
                IF PostedServiceOrderHeader.FINDFIRST THEN BEGIN
                    ServiceLedgerEntry."Job Type (Service Header)" := PostedServiceOrderHeader."Job Type";
                    ServiceLedgerEntry."Service Type" := PostedServiceOrderHeader."Service Type";
                    ServiceLedgerEntry."Job Category" := PostedServiceOrderHeader."Job Category";
                    ServiceLedgerEntry.MODIFY;
                END;
            UNTIL ServiceLedgerEntry.NEXT = 0;
        END;
        MESSAGE('Updated!');
    end;

    [Scope('Internal')]
    procedure UpdateDocumentProfileinValueEn()
    var
        ValueEntry: Record "5802";
        ItemLedEntry: Record "32";
    begin
        ValueEntry.SETRANGE("Posting Date", 030116D, 072316D);
        IF ValueEntry.FINDSET THEN
            REPEAT
                IF ItemLedEntry.GET(ValueEntry."Item Ledger Entry No.") THEN BEGIN
                    ValueEntry."Document Profile" := ItemLedEntry."Document Profile";
                    ValueEntry.MODIFY;
                END;
            UNTIL ValueEntry.NEXT = 0;
        MESSAGE('Updated!');
    end;

    [Scope('Internal')]
    procedure UpdatePurchaseLine()
    var
        PurchaseLine: Record "39";
    begin
        PurchaseLine.SETRANGE("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SETRANGE("Document No.", 'BIDIPO73-000141');
        PurchaseLine.SETRANGE(Type, PurchaseLine.Type::Item);
        PurchaseLine.SETRANGE("Line No.", 60000);
        MESSAGE('PurchaseLine-->' + FORMAT(PurchaseLine.COUNT));
        IF PurchaseLine.FINDSET THEN
            REPEAT
                /*
                  IF PurchaseLine."Line No." = 20000 THEN
                     PurchaseLine."Receipt Line No." := 20000;
                  IF PurchaseLine."Line No." = 30000 THEN
                     PurchaseLine."Receipt Line No." := 30000;
                  IF PurchaseLine."Line No." = 60000 THEN
                     PurchaseLine."Receipt Line No." := 10000;
                */
                PurchaseLine."Qty. to Invoice (Base)" := 1153;
                PurchaseLine."Qty. Received (Base)" := 1153;
                PurchaseLine."Outstanding Qty. (Base)" := 0;
                //PurchaseLine."Outstanding Quantity" := 0;
                PurchaseLine.MODIFY;
            UNTIL PurchaseLine.NEXT = 0;
        MESSAGE('Updated!');

    end;

    [Scope('Internal')]
    procedure UpdatePurchaseReceiptLine()
    var
        PurchaseReceiptLine: Record "121";
    begin
        PurchaseReceiptLine.SETRANGE("Document No.", 'BIDIPPR73-000268');
        PurchaseReceiptLine.SETRANGE(Type, PurchaseReceiptLine.Type::Item);
        PurchaseReceiptLine.SETRANGE("Line No.", 10000);
        MESSAGE('PurchaseReceiptLine-->' + FORMAT(PurchaseReceiptLine.COUNT));
        IF PurchaseReceiptLine.FINDFIRST THEN BEGIN
            PurchaseReceiptLine."Order Line No." := 60000;
            PurchaseReceiptLine.MODIFY;
        END;
        MESSAGE('Updated!');
    end;

    local procedure timesprinted()
    var
        InvHeader: Record "112";
    begin
        InvHeader.RESET;
        InvHeader.SETRANGE("No.", 'AHOSPI73-06588');
        IF InvHeader.FINDFIRST THEN BEGIN
            InvHeader."No. Printed" := 0;
            InvHeader.MODIFY;
        END;
        MESSAGE('dne');
    end;

    local procedure UpdateUnitCostZeroSundryAssets()
    var
        Item: Record "27";
    begin
        Item.RESET;
        Item.SETRANGE("Gen. Prod. Posting Group", 'SUNDRYASST');
        IF Item.FINDSET THEN
            REPEAT
                Item."Unit Cost" := 0;
                Item.MODIFY;
            UNTIL Item.NEXT = 0;
        MESSAGE('Done!!!');
    end;

    local procedure UpdateVatentry()
    var
        vatentry: Record "254";
    begin
        vatentry.RESET;
        vatentry.SETRANGE("Document No.", 'BIDPPI74-02133');
        vatentry.FINDFIRST;
        vatentry."Exempt Purchase No." := 'BIDPPI74-02133';
        vatentry.MODIFY;
    end;

    [Scope('Internal')]
    procedure UpdateNepaliDate()
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

    local procedure UpdateGLEntrywithdocumentNo()
    var
        GLEntry: Record "17";
        GLItemLedgRelation: Record "5823";
        ValueEntry: Record "5802";
        DocNo: Text;
        VENo: Text;
        LastdocNo: Code[20];
    begin
        GLEntry.RESET;
        GLEntry.SETRANGE("Source Code", 'INVTPCOST');
        GLEntry.SETRANGE("User ID", 'SHARMILA.THAPA');
        GLEntry.SETRANGE("Value Entry Doc 1", '');
        MESSAGE(FORMAT(GLEntry.COUNT));
        IF GLEntry.FINDSET THEN
            REPEAT
                CLEAR(DocNo);
                CLEAR(VENo);
                GLItemLedgRelation.RESET;
                GLItemLedgRelation.SETRANGE("G/L Entry No.", GLEntry."Entry No.");
                IF GLItemLedgRelation.FINDSET THEN
                    REPEAT
                        IF VENo = '' THEN
                            VENo := FORMAT(GLItemLedgRelation."Value Entry No.")
                        ELSE
                            VENo += '|' + FORMAT(GLItemLedgRelation."Value Entry No.");
                    UNTIL GLItemLedgRelation.NEXT = 0;
                CLEAR(LastdocNo);
                IF VENo <> '' THEN BEGIN
                    ValueEntry.RESET;
                    ValueEntry.SETFILTER("Entry No.", VENo);
                    ValueEntry.SETCURRENTKEY("Document No.");
                    ValueEntry.SETASCENDING("Document No.", TRUE);
                    //ValueEntry.GET(GLItemLedgRelation."Value Entry No.");
                    IF ValueEntry.FINDSET THEN
                        REPEAT
                            IF DocNo = '' THEN
                                DocNo := ValueEntry."Document No."
                            ELSE
                                IF LastdocNo <> ValueEntry."Document No." THEN
                                    DocNo += '|' + ValueEntry."Document No.";

                            LastdocNo := ValueEntry."Document No.";
                        UNTIL ValueEntry.NEXT = 0;
                END;
                GLEntry."Value Entry Doc 1" := COPYSTR(DocNo, 1, 250);
                GLEntry."Value Entry Doc 2" := COPYSTR(DocNo, 251, 250);
                GLEntry."Value Entry Doc 3" := COPYSTR(DocNo, 501, 250);
                GLEntry."Value Entry Doc 4" := COPYSTR(DocNo, 751, 250);
                GLEntry.Narration := '';
                GLEntry.MODIFY;
            UNTIL GLEntry.NEXT = 0;

        MESSAGE('FINISHED');
    end;

    local procedure UpdatImportPurchLine()
    var
        PurchaseLine: Record "39";
    begin
        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document No.", 'AHOIPO75-000023');
        PurchaseLine.SETFILTER("Quantity Received", '%1', 0);
        IF PurchaseLine.FINDFIRST THEN
            REPEAT
                PurchaseLine."Qty. Received (Base)" := 0;
                PurchaseLine."Qty. Invoiced (Base)" := 0;
                PurchaseLine."Qty. to Invoice (Base)" := 0;
                PurchaseLine."Qty. Rcd. Not Invoiced" := 0;
                PurchaseLine."Outstanding Qty. (Base)" := 1;
                PurchaseLine.MODIFY;
            UNTIL PurchaseLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure Alphanumeric(VATNo: Text[30]): Boolean
    var
        IntLoop: Integer;
        Char: Code[30];
    begin
        Char := '';
        FOR IntLoop := 1 TO STRLEN(VATNo) DO BEGIN
            Char := COPYSTR(VATNo, IntLoop, 1);
            IF Char IN ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'] THEN BEGIN
                EXIT(TRUE)
            END;
        END;
        EXIT(FALSE)
    end;

    local procedure UpdateStartEndDateTime()
    var
        ServLaborAllocationEntry: Record "25006271";
        DateTimeMgt: Codeunit "25006012";
    begin
        IF NOT CONFIRM('Do you want to Update Start Date Time and End Date Time?') THEN
            ERROR('Aborted by user!');
        ServLaborAllocationEntry.RESET;
        ServLaborAllocationEntry.SETRANGE("Start Date Time", 0DT);
        ServLaborAllocationEntry.SETRANGE("End Date Time", 0DT);
        IF ServLaborAllocationEntry.FINDFIRST THEN
            REPEAT
                ServLaborAllocationEntry."Start Date Time" := CREATEDATETIME(DateTimeMgt.Datetime2Date(ServLaborAllocationEntry."Start Date-Time"), DateTimeMgt.Datetime2Time(ServLaborAllocationEntry."Start Date-Time"));
                ServLaborAllocationEntry."End Date Time" := CREATEDATETIME(DateTimeMgt.Datetime2Date(ServLaborAllocationEntry."End Date-Time"), DateTimeMgt.Datetime2Time(ServLaborAllocationEntry."End Date-Time"));
                ServLaborAllocationEntry.MODIFY;
            UNTIL ServLaborAllocationEntry.NEXT = 0;
        MESSAGE('Update Successful!');
    end;

    local procedure UpdateSavedVendor()
    var
        Vend: Record "23";
    begin
        IF NOT CONFIRM('Do you want to Saved?') THEN
            ERROR('Aborted by user!');
        Vend.RESET;
        IF Vend.FINDFIRST THEN
            REPEAT
                Vend.Saved := TRUE;
                Vend.MODIFY;
            UNTIL Vend.NEXT = 0;
        MESSAGE('Update Successful!');
    end;

    [Scope('Internal')]
    procedure UpdateIRDSyncStatus()
    var
        InvoiceMaterializeView: Record "33020293";
    begin
        IF NOT CONFIRM('Do you want to update sync status?', FALSE) THEN
            ERROR('Aborted by user!');
        IF COMPANYNAME = 'BALAJU AUTO WORKS PVT. LTD.' THEN BEGIN
            InvoiceMaterializeView.RESET;
            InvoiceMaterializeView.SETRANGE("Sync Status", InvoiceMaterializeView."Sync Status"::"Not Valid");
            InvoiceMaterializeView.SETRANGE("Bill Date", 071719D, TODAY);
            IF InvoiceMaterializeView.FINDFIRST THEN
                REPEAT
                    InvoiceMaterializeView."Sync Status" := InvoiceMaterializeView."Sync Status"::Pending;
                    InvoiceMaterializeView.MODIFY;
                UNTIL InvoiceMaterializeView.NEXT = 0;
            MESSAGE('Update Successful!');
        END;
    end;

    local procedure UpdateServiceOrderNo()
    var
        PurchInvHeader: Record "122";
        VendorLedgerEntry: Record "25";
    begin
        IF NOT CONFIRM('Do you want to Update Service Order No. in Vendor Ledger Enteries?') THEN
            ERROR('Aborted by user!');
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETFILTER("Service Order No.", '%1', '');
        IF VendorLedgerEntry.FINDFIRST THEN BEGIN
            REPEAT
                PurchInvHeader.RESET;
                PurchInvHeader.SETRANGE("No.", VendorLedgerEntry."Document No.");
                IF PurchInvHeader.FINDFIRST THEN BEGIN
                    VendorLedgerEntry."Service Order No." := PurchInvHeader."Service Order No.";
                    VendorLedgerEntry.MODIFY;
                END;
            UNTIL VendorLedgerEntry.NEXT = 0;
        END;
        MESSAGE('Update Successful!');
    end;

    local procedure RemovePurchaserelatedDoc()
    var
        PurchInvHdr: Record "122";
        PurchInvLine: Record "123";
        GLEntry: Record "17";
        ValueEntry: Record "5802";
        VendorLedgerEntry: Record "25";
        DetailVendorLedgerEntry: Record "380";
        VATEntry: Record "254";
    begin
        IF NOT CONFIRM('Do you want to Remove Posted Purchase Invoice Related table.?') THEN
            ERROR('Aborted by user!');
        PurchInvHdr.RESET;
        PurchInvHdr.SETFILTER("No.", 'AHOIPPI76-000480');
        IF PurchInvHdr.FINDFIRST THEN
            REPEAT
                PurchInvHdr.DELETE;
            UNTIL PurchInvHdr.NEXT = 0;

        PurchInvLine.RESET;
        PurchInvLine.SETFILTER("Document No.", 'AHOIPPI76-000480');
        IF PurchInvLine.FINDFIRST THEN
            REPEAT
                PurchInvLine.DELETE;
            UNTIL PurchInvLine.NEXT = 0;

        ValueEntry.RESET;
        ValueEntry.SETFILTER("Document No.", 'AHOIPPI76-000480');
        IF ValueEntry.FINDFIRST THEN
            REPEAT
                ValueEntry.DELETE;
            UNTIL ValueEntry.NEXT = 0;

        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETFILTER("Document No.", 'AHOIPPI76-000480');
        IF VendorLedgerEntry.FINDFIRST THEN
            REPEAT
                VendorLedgerEntry.DELETE;
            UNTIL VendorLedgerEntry.NEXT = 0;

        DetailVendorLedgerEntry.RESET;
        DetailVendorLedgerEntry.SETFILTER("Document No.", 'AHOIPPI76-000480');
        IF DetailVendorLedgerEntry.FINDFIRST THEN
            REPEAT
                DetailVendorLedgerEntry.DELETE;
            UNTIL DetailVendorLedgerEntry.NEXT = 0;

        VATEntry.RESET;
        VATEntry.SETFILTER("Document No.", 'AHOIPPI76-000480');
        IF VATEntry.FINDFIRST THEN
            REPEAT
                VATEntry.DELETE;
            UNTIL VATEntry.NEXT = 0;

        GLEntry.RESET;
        GLEntry.SETFILTER("Document No.", 'AHOIPPI76-000480');
        IF GLEntry.FINDFIRST THEN
            REPEAT
                GLEntry.DELETE;
            UNTIL GLEntry.NEXT = 0;

        MESSAGE('Update Successful!');
    end;

    [Scope('Internal')]
    procedure UpdateModificationDateItems()
    var
        Items: Record "27";
    begin
        IF NOT CONFIRM('Do you want to Update Modification Date in Items?') THEN
            ERROR('Aborted by user!');
        Items.RESET;
        Items.SETRANGE("Inventory Posting Group", 'SPAREMMTRA');
        Items.SETRANGE("Modification Date", 0D);
        IF Items.FINDFIRST THEN
            REPEAT
                Items."Modification Date" := 122920D;
                Items.MODIFY;
            UNTIL Items.NEXT = 0;
        MESSAGE('Update Successful!');
    end;
}


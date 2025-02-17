codeunit 25006124 "Serv-Quote to Order EDMS"
{
    // 18.02.2015 EB.P7 #S0010
    //   Removed Autoreserv functionality for Quote
    // 
    // 27.02.2013 EDMS P8
    //   * Implement new dimension set

    TableNo = 25006145;

    trigger OnRun()
    var
        OldServCommentLine: Record "25006148";
        Opp: Record "5092";
        OpportunityEntry: Record "5093";
        TempOpportunityEntry: Record "5093" temporary;
        Cust: Record "18";
    begin
        Rec.TESTFIELD("Document Type", Rec."Document Type"::Quote);
        Cust.GET(Rec."Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust, Rec."Document Type"::Order, TRUE, FALSE);
        Rec.CALCFIELDS("Amount Including VAT");
        ServiceOrderHeader := Rec;
        IF GUIALLOWED AND NOT HideValidationDialog THEN
            CustCheckCreditLimit.ServiceHeaderCheckEDMS(ServiceOrderHeader);
        ServiceOrderHeader."Document Type" := ServiceOrderHeader."Document Type"::Order;

        ServiceQuoteLine.SETRANGE("Document Type", Rec."Document Type");
        ServiceQuoteLine.SETRANGE("Document No.", Rec."No.");
        ServiceQuoteLine.SETRANGE(Type, ServiceQuoteLine.Type::Item);
        ServiceQuoteLine.SETFILTER("No.", '<>%1', '');
        IF ServiceQuoteLine.FINDSET THEN
            REPEAT
                IF (ServiceQuoteLine."Outstanding Quantity" > 0) THEN BEGIN
                    ServiceLine := ServiceQuoteLine;
                    ServiceLine.VALIDATE("Reserved Qty. (Base)", 0);
                    ServiceLine."Line No." := 0;
                END;
            UNTIL ServiceQuoteLine.NEXT = 0;

        ServiceOrderHeader."No. Printed" := 0;
        ServiceOrderHeader.Status := ServiceOrderHeader.Status::Open;
        ServiceOrderHeader."No." := '';
        ServiceOrderHeader."Quote No." := Rec."No.";
        ServiceOrderLine.LOCKTABLE;
        ServiceOrderHeader.INSERT(TRUE);


        ServiceOrderHeader."Order Date" := Rec."Order Date";
        IF Rec."Posting Date" <> 0D THEN
            ServiceOrderHeader."Posting Date" := Rec."Posting Date";
        ServiceOrderHeader."Document Date" := "Document Date";
        ServiceOrderHeader."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
        ServiceOrderHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        ServiceOrderHeader."Dimension Set ID" := "Dimension Set ID";
        ServiceOrderHeader."Date Sent" := 0D;
        ServiceOrderHeader."Time Sent" := 0T;

        ServiceOrderHeader."Location Code" := Rec."Location Code";

        ServiceOrderHeader."Prepayment %" := Cust."Prepayment %";

        ServiceOrderHeader.MODIFY;

        ModifyScheduleEntries(Rec, ServiceOrderHeader);

        ServiceQuoteLine.RESET;
        ServiceQuoteLine.SETRANGE("Document Type", Rec."Document Type");
        ServiceQuoteLine.SETRANGE("Document No.", Rec."No.");


        IF ServiceQuoteLine.FINDSET THEN
            REPEAT
                ServiceOrderLine := ServiceQuoteLine;
                ServiceOrderLine."Document Type" := ServiceOrderHeader."Document Type";
                ServiceOrderLine."Document No." := ServiceOrderHeader."No.";
                ReserveServLine.TransServLineToServLine(
                  ServiceQuoteLine, ServiceOrderLine, ServiceQuoteLine."Outstanding Qty. (Base)");
                ServiceOrderLine."Shortcut Dimension 1 Code" := ServiceQuoteLine."Shortcut Dimension 1 Code";
                ServiceOrderLine."Shortcut Dimension 2 Code" := ServiceQuoteLine."Shortcut Dimension 2 Code";
                ServiceOrderLine."Dimension Set ID" := ServiceQuoteLine."Dimension Set ID";

                IF Cust."Prepayment %" <> 0 THEN
                    ServiceOrderLine."Prepayment %" := Cust."Prepayment %";

                ServiceOrderLine.VALIDATE("Prepayment %");

                ServiceOrderLine.INSERT;

                ServiceQuoteLine."Quantity (Base)" := 0;
                ReserveServLine.VerifyQuantity(ServiceOrderLine, ServiceQuoteLine);

            UNTIL ServiceQuoteLine.NEXT = 0;

        ServSetup.GET;
        IF ServSetup."Archive Quotes and Orders" THEN
            ArchiveManagement.ArchServDocumentNoConfirm(Rec);

        ServiceCommentLine.SETRANGE(Type, Rec."Document Type");
        ServiceCommentLine.SETRANGE("No.", Rec."No.");
        IF NOT ServiceCommentLine.ISEMPTY THEN BEGIN
            ServiceCommentLine.LOCKTABLE;
            IF ServiceCommentLine.FINDSET THEN
                REPEAT
                    OldServCommentLine := ServiceCommentLine;
                    ServiceCommentLine.DELETE;
                    ServiceCommentLine.Type := ServiceOrderHeader."Document Type";
                    ServiceCommentLine."No." := ServiceOrderHeader."No.";
                    ServiceCommentLine.INSERT;
                    ServiceCommentLine := OldServCommentLine;
                UNTIL ServiceCommentLine.NEXT = 0;
        END;
        ServiceOrderHeader.COPYLINKS(Rec);

        // change doclink
        ServicePlanDocumentLink.RESET;
        ServicePlanDocumentLink.SETCURRENTKEY("Document Type", "Document No.");
        ServicePlanDocumentLink.SETRANGE("Document Type", ServicePlanDocumentLink."Document Type"::Quote);
        ServicePlanDocumentLink.SETRANGE("Document No.", Rec."No.");
        ServicePlanDocumentLink.MODIFYALL("Document Type", ServicePlanDocumentLink."Document Type"::Order, FALSE);
        ServicePlanDocumentLink.SETRANGE("Document Type", ServicePlanDocumentLink."Document Type"::Order);
        ServicePlanDocumentLink.MODIFYALL("Document No.", ServiceOrderHeader."No.", FALSE);


        Rec.DELETE;

        ServiceQuoteLine.DELETEALL;

        COMMIT;
        CLEAR(CustCheckCreditLimit);
        CLEAR(ItemCheckAvail);
    end;

    var
        ServiceQuoteLine: Record "25006146";
        ServiceLine: Record "25006146";
        ServiceOrderHeader: Record "25006145";
        ServiceOrderLine: Record "25006146";
        ServiceCommentLine: Record "25006148";
        ServicePlanDocumentLink: Record "25006157";
        CustCheckCreditLimit: Codeunit "312";
        ItemCheckAvail: Codeunit "311";
        ReserveServLine: Codeunit "25006121";
        DocDim: Codeunit "408";
        HideValidationDialog: Boolean;
        ServSetup: Record "25006120";
        ArchiveManagement: Codeunit "5063";

    [Scope('Internal')]
    procedure GetSalesOrderHeader(var ServiceHeader2: Record "25006145")
    begin
        ServiceHeader2 := ServiceOrderHeader;
    end;

    [Scope('Internal')]
    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    [Scope('Internal')]
    procedure ModifyScheduleEntries(ServiceQoute: Record "25006145"; ServiceOrder: Record "25006145")
    var
        ServAllocationEntry: Record "25006271";
        ServLaborApplication: Record "25006277";
        ServLaborApplication2: Record "25006277";
    begin
        ServAllocationEntry.RESET;
        ServAllocationEntry.SETRANGE("Source Type", ServAllocationEntry."Source Type"::"Service Document");
        ServAllocationEntry.SETRANGE("Source Subtype", ServAllocationEntry."Source Subtype"::Quote);
        ServAllocationEntry.SETRANGE("Source ID", ServiceQoute."No.");
        IF ServAllocationEntry.FINDFIRST THEN
            REPEAT
                ServAllocationEntry."Source Subtype" := ServAllocationEntry."Source Subtype"::Order;
                ServAllocationEntry."Source ID" := ServiceOrder."No.";
                ServAllocationEntry.MODIFY;
            UNTIL ServAllocationEntry.NEXT = 0;

        ServLaborApplication.RESET;
        ServLaborApplication.SETRANGE("Document Type", ServiceQoute."Document Type");
        ServLaborApplication.SETRANGE("Document No.", ServiceQoute."No.");
        IF ServLaborApplication.FINDFIRST THEN
            REPEAT
                ServLaborApplication2 := ServLaborApplication;
                ServLaborApplication2."Document Type" := ServiceOrder."Document Type";
                ServLaborApplication2."Document No." := ServiceOrder."No.";
                ServLaborApplication2.INSERT;
                ServLaborApplication.DELETE;
            UNTIL ServLaborApplication.NEXT = 0;
    end;
}


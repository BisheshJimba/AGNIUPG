codeunit 25006872 "Service Booking to Order"
{
    TableNo = 25006145;

    trigger OnRun()
    var
        OldServCommentLine: Record "25006148";
        Cust: Record "18";
    begin
        Rec.TESTFIELD("Document Type", Rec."Document Type"::Booking);
        Rec.TESTFIELD("Booking Resource No.");

        Cust.GET(Rec."Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust, Rec."Document Type"::Order, TRUE, FALSE);
        Rec.CALCFIELDS("Amount Including VAT");

        ServiceOrderHeader := Rec;
        IF GUIALLOWED AND NOT HideValidationDialog THEN
            CustCheckCreditLimit.ServiceHeaderCheckEDMS(ServiceOrderHeader);
        ServiceOrderHeader."Document Type" := ServiceOrderHeader."Document Type"::Order;

        ServiceOrderHeader."No. Printed" := 0;
        ServiceOrderHeader.Status := ServiceOrderHeader.Status::Open;
        ServiceOrderHeader."No." := '';
        ServiceOrderHeader."Booking No." := Rec."No.";
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


        ServiceBookingLine.RESET;
        ServiceBookingLine.SETRANGE("Document Type", Rec."Document Type");
        ServiceBookingLine.SETRANGE("Document No.", Rec."No.");


        IF ServiceBookingLine.FINDSET THEN
            REPEAT
                ServiceOrderLine := ServiceBookingLine;
                ServiceOrderLine."Document Type" := ServiceOrderHeader."Document Type";
                ServiceOrderLine."Document No." := ServiceOrderHeader."No.";
                ServiceOrderLine."Shortcut Dimension 1 Code" := ServiceBookingLine."Shortcut Dimension 1 Code";
                ServiceOrderLine."Shortcut Dimension 2 Code" := ServiceBookingLine."Shortcut Dimension 2 Code";
                ServiceOrderLine."Dimension Set ID" := ServiceBookingLine."Dimension Set ID";

                IF Cust."Prepayment %" <> 0 THEN
                    ServiceOrderLine."Prepayment %" := Cust."Prepayment %";

                ServiceOrderLine.VALIDATE("Prepayment %");

                ServiceOrderLine.INSERT;

                ServiceBookingLine."Quantity (Base)" := 0;
            UNTIL ServiceBookingLine.NEXT = 0;

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
        ServicePlanDocumentLink.SETRANGE("Document Type", ServicePlanDocumentLink."Document Type"::Booking);
        ServicePlanDocumentLink.SETRANGE("Document No.", Rec."No.");
        ServicePlanDocumentLink.MODIFYALL("Document Type", ServicePlanDocumentLink."Document Type"::Order, FALSE);
        ServicePlanDocumentLink.SETRANGE("Document Type", ServicePlanDocumentLink."Document Type"::Order);
        ServicePlanDocumentLink.MODIFYALL("Document No.", ServiceOrderHeader."No.", FALSE);

        Rec.DELETE;

        ServiceBookingLine.DELETEALL;

        COMMIT;
        CLEAR(CustCheckCreditLimit);
        CLEAR(ItemCheckAvail);
    end;

    var
        ServiceBookingLine: Record "25006146";
        ServiceOrderHeader: Record "25006145";
        ServiceOrderLine: Record "25006146";
        ServiceCommentLine: Record "25006148";
        ServicePlanDocumentLink: Record "25006157";
        CustCheckCreditLimit: Codeunit "312";
        ItemCheckAvail: Codeunit "311";
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
}


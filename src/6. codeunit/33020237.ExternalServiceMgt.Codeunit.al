codeunit 33020237 "External Service Mgt."
{
    // find unique vendors from external service
    // loop all vendors
    // create purchase header for all unique vendors
    // get corresponding lines from service line

    TableNo = 25006145;

    trigger OnRun()
    var
        i: Integer;
    begin
        IF NOT
           CONFIRM(
             Text001, FALSE)
        THEN
            EXIT;

        TotalVendors := 1;
        ServLine.RESET;
        ServLine.SETCURRENTKEY("Document Type", "Document No.");
        ServLine.SETRANGE("Document Type", Rec."Document Type"::Order);
        ServLine.SETRANGE("Document No.", Rec."No.");
        ServLine.SETRANGE(Type, ServLine.Type::"External Service");
        ServLine.SETRANGE("External Service Purchased", FALSE);
        IF NOT ServLine.FINDFIRST THEN
            ERROR(Text004)
        ELSE BEGIN
            REPEAT
                ServLine.TESTFIELD(Rec."No.");
                ServLine.TESTFIELD(Quantity);
                ServLine.TESTFIELD("External Serv. Tracking No.");
                SetVendor;
            UNTIL ServLine.NEXT = 0;
        END;
        FOR i := 1 TO TotalVendors - 1 DO BEGIN
            IF NOT CreatePurchaseHeader(i, Rec) THEN
                ERROR(Text003);
        END;
        MESSAGE(Text002);
    end;

    var
        PurchHeader: Record "38";
        PurchLine: Record "39";
        TotalVendors: Integer;
        ServLine: Record "25006146";
        Vendors: array[10] of Code[20];
        ServLineNo: array[50] of Integer;
        ExtService: Record "25006133";
        NoVendorInExtCard: Label 'Vendor No. for External Service %1 is empty in External Service Card.';
        DuplicateFound: Boolean;
        Text001: Label 'Do you want to create the Purchase Order?';
        PurchHeaderNos: array[10] of Code[20];
        Text002: Label 'Purchase Order created Successfully.';
        Text003: Label 'Error in creating Purchase Order.';
        Text004: Label 'There are no External Services within the filter.';

    [Scope('Internal')]
    procedure CreatePurchaseHeader(i: Integer; ServHeader: Record "25006145"): Boolean
    begin

        PurchHeader.RESET;
        CLEAR(PurchHeader);
        PurchHeader.INIT;
        PurchHeader."Document Type" := PurchHeader."Document Type"::Order;
        PurchHeader.INSERT(TRUE);
        PurchHeader.VALIDATE("Buy-from Vendor No.", Vendors[i]);
        PurchHeader.VALIDATE("Pay-to Vendor No.");

        PurchHeader."Document Profile" := PurchHeader."Document Profile"::Service;
        PurchHeader.VALIDATE("Service Order No.", ServHeader."No.");
        PurchHeader.MODIFY;

        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure CreatePurchaseLine()
    begin
    end;

    [Scope('Internal')]
    procedure SetVendor()
    var
        i: Integer;
    begin
        DuplicateFound := FALSE;
        ExtService.RESET;
        ExtService.SETRANGE("No.", ServLine."No.");
        IF ExtService.FINDFIRST THEN BEGIN
            IF ExtService."Vendor No." <> '' THEN BEGIN
                FOR i := 1 TO TotalVendors DO BEGIN
                    IF ExtService."Vendor No." = Vendors[i] THEN
                        DuplicateFound := TRUE;
                END;
                IF NOT DuplicateFound THEN BEGIN
                    Vendors[TotalVendors] := ExtService."Vendor No.";
                    TotalVendors := TotalVendors + 1;

                END;
            END
            ELSE
                ERROR(NoVendorInExtCard, ServLine."No.");
        END;
    end;
}


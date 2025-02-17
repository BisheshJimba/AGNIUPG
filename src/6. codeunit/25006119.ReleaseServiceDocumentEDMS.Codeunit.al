codeunit 25006119 "Release Service Document EDMS"
{
    // 12.05.2016 EB.P30 GH
    //   Modified procedure:
    //     Reopen
    // 
    // 22.10.2015 NAV2016 Merge
    //   Removed approvals
    // 
    // 04.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Modified trigger OnRun
    // 
    // 03.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Modified trigger OnRun
    // 
    // 2012.03.07 EDMS P8
    //   * Tire management
    // 
    // 19.01.2009. EDMS P2
    //   * Added code PerformManualRelease
    // 
    // 07.11.2007. EDMS P2
    //   * Added code OnRun
    // 
    // 23.10.2007 EDMS P2
    //   * Added code OnRun
    // 
    // 26.07.2007. EDMS P2
    //   * Added code in function TestServPrepayment(ServHeader : Record "Service Header EDMS") : Boolean

    TableNo = 25006145;

    trigger OnRun()
    var
        ServLine: Record "25006146";
        TempVATAmountLine0: Record "290" temporary;
        TempVATAmountLine1: Record "290" temporary;
        NotOnlyDropShipment: Boolean;
    begin
        IF Status = Status::Released THEN
            EXIT;

        IF Rec."Document Type" = Rec."Document Type"::Quote THEN
            IF CheckContactCreated(TRUE) AND
               CheckCustomerCreated(TRUE) AND
               CheckVehicleCreated(TRUE) THEN
                Rec.GET(Rec."Document Type"::Quote, Rec."No.")
            ELSE
                EXIT;


        Rec.TESTFIELD("Sell-to Customer No.");
        //03.04.2014 Elva Baltic P1 #RX MMG7.00 >>
        Rec.TESTFIELD("Make Code");
        Rec.TESTFIELD("Model Code");
        Rec.TESTFIELD("Vehicle Status Code");
        Rec.TESTFIELD("Vehicle Serial No.");
        Rec.TESTFIELD("Vehicle Accounting Cycle No.");
        //03.04.2014 Elva Baltic P1 #RX MMG7.00 <<

        //07.11.2007. EDMS P2 >>
        ServiceSetup.GET;
        IF (Rec."Document Type" = Rec."Document Type"::Order)
         AND (ServiceSetup."Payment Method Mandatory") THEN
            Rec.TESTFIELD("Payment Method Code");
        //07.11.2007. EDMS P2 <<
        //04.04.2014 Elva Baltic P1 #RX MMG7.00
        IF ServiceSetup."Deal Type Mandatory" THEN
            Rec.TESTFIELD("Deal Type");
        //04.04.2014 Elva Baltic P1 #RX MMG7.00

        ServLine.SETRANGE("Document Type", Rec."Document Type");
        ServLine.SETRANGE("Document No.", Rec."No.");
        ServLine.SETFILTER(Type, '>0');
        ServLine.SETFILTER(Quantity, '<>0');
        IF ServLine.ISEMPTY THEN
            ERROR(Text001, Rec."Document Type", Rec."No.");

        //23.10.2007. EDMS P2 >>
        ServLine.RESET;
        ServLine.SETRANGE("Document Type", Rec."Document Type");
        ServLine.SETRANGE("Document No.", Rec."No.");
        ServLine.SETRANGE(Type, ServLine.Type::Item);
        IF ServLine.FINDFIRST THEN
            REPEAT
                ServLine.ApplyMarkupRestrictions(1);
            UNTIL ServLine.NEXT = 0;
        //23.10.2007. EDMS P2 <<

        //2012.03.07 EDMS P8 >>
        IF ServLine.FINDFIRST THEN
            REPEAT
                IF ServLine."Tire Operation Type" > 0 THEN BEGIN
                    ServLine.TESTFIELD("Vehicle Axle Code");
                    ServLine.TESTFIELD("Tire Position Code");
                    ServLine.TESTFIELD("Tire Code");
                END;
            UNTIL ServLine.NEXT = 0;
        //2012.03.07 EDMS P8 <<

        InvtSetup.GET;
        IF InvtSetup."Location Mandatory" THEN BEGIN
            ServLine.SETRANGE(Type, ServLine.Type::Item);
            IF ServLine.FINDSET THEN
                REPEAT
                    ServLine.TESTFIELD(Rec."Location Code");
                UNTIL ServLine.NEXT = 0;
            ServLine.SETFILTER(Type, '>0');
        END;
        ServLine.RESET;

        IF TestPrepayment(Rec) AND (Rec."Document Type" = Rec."Document Type"::Order) THEN
            Status := Status::"Pending Prepayment"
        ELSE
            Status := Status::Released;

        ServLine.SetServHeader(Rec);
        ServLine.CalcVATAmountLines(0, Rec, ServLine, TempVATAmountLine0);
        ServLine.CalcVATAmountLines(1, Rec, ServLine, TempVATAmountLine1);
        ServLine.UpdateVATOnLines(0, Rec, ServLine, TempVATAmountLine0);
        ServLine.UpdateVATOnLines(1, Rec, ServLine, TempVATAmountLine1);

        Rec.MODIFY(TRUE);
    end;

    var
        Text001: Label 'There is nothing to release for %1 %2.';
        Text002: Label 'This document can only be released when the approval process is complete.';
        Text003: Label 'The approval process must be cancelled or completed to reopen this document.';
        InvtSetup: Record "313";
        Text100: Label '%1 cannot be less than or equal to last posted.';
        ServiceSetup: Record "25006120";
        Approved: Boolean;
        Text101: Label '%1 must not be 0 in Service Document.';
        Text004: Label 'The Hour Reading cannot be less than or equal during the previous visit.';
        EDMS001: Label 'The kilometrage cannot be less than or equal during the previous visit.';

    [Scope('Internal')]
    procedure PerformManualRelease(var ServHeader: Record "25006145")
    var
        ApprovalEntry: Record "454";
        VehicleLoc: Record "25006005";
        ServiceSetup: Record "25006120";
        ServOrdInfoPaneMgt: Codeunit "25006104";
        ApprovedOnly: Boolean;
        AppMgt: Codeunit "1";
    begin
        //26.07.2007. EDMS P2>>
        ServiceSetup.GET;
        IF (ServHeader."Document Type" <> ServHeader."Document Type"::Quote) AND
         (ServHeader."Document Type" <> ServHeader."Document Type"::"Return Order")
          THEN BEGIN
            IF ServiceSetup."Check Kilometrage on Release" THEN BEGIN
                ServHeader.TESTFIELD("Vehicle Serial No.");
                IF ServHeader.Kilometrage = 0 THEN
                    ERROR(EDMS001);
                IF ServHeader.Kilometrage <= ServOrdInfoPaneMgt.CalcLastVFRun1(ServHeader."Vehicle Serial No.") THEN
                    ERROR(EDMS001);
                IF ServHeader."Model Code" IN ['HCV TIPPER', 'MCV TIPPER'] THEN BEGIN
                    ServHeader.TESTFIELD(ServHeader."Hour Reading");
                    IF ServHeader."Hour Reading" <= ServOrdInfoPaneMgt.CalcLastVisitHour(ServHeader."Vehicle Serial No.") THEN
                        ERROR(Text004);
                END;
            END;
        END;

        IF ServiceSetup."Check VF Run 2 on Release" THEN BEGIN
            ServHeader.TESTFIELD("Vehicle Serial No.");
            IF ServHeader."Variable Field Run 2" = 0 THEN
                ERROR(Text101, AppMgt.CaptionClassTranslate(GLOBALLANGUAGE, '7,25006145,25006255'));
            IF ServHeader."Variable Field Run 2" < ServOrdInfoPaneMgt.CalcLastVFRun2(ServHeader."Vehicle Serial No.") THEN
                ERROR(Text100, AppMgt.CaptionClassTranslate(GLOBALLANGUAGE, '7,25006145,25006255'));
        END;

        IF ServiceSetup."Check VF Run 3 on Release" THEN BEGIN
            ServHeader.TESTFIELD("Vehicle Serial No.");
            IF ServHeader."Variable Field Run 3" = 0 THEN
                ERROR(Text101, AppMgt.CaptionClassTranslate(GLOBALLANGUAGE, '7,25006145,25006260'));
            IF ServHeader."Variable Field Run 3" < ServOrdInfoPaneMgt.CalcLastVFRun3(ServHeader."Vehicle Serial No.") THEN
                ERROR(Text100, AppMgt.CaptionClassTranslate(GLOBALLANGUAGE, '7,25006145,25006260'));
        END;

        //26.07.2007. EDMS P2 <<

        //19.01.2009. EDMS P2 >>
        IF ServiceSetup."Check Vehicle Sales Date" THEN BEGIN
            VehicleLoc.GET(ServHeader."Vehicle Serial No.");
            VehicleLoc.CALCFIELDS(Inventory);
            IF VehicleLoc.Inventory = 0 THEN
                VehicleLoc.TESTFIELD("Sales Date");
        END;
        //19.01.2009. EDMS P2 <<

        IF ServiceSetup."Make and Model Mandatory" THEN BEGIN
            ServHeader.TESTFIELD("Make Code");
            ServHeader.TESTFIELD("Model Code");
        END;

        //22.10.2015 NAV2016 Merge >>
        //Approved := ApprovalManagement.CheckApprServDocument(ServHeader);
        //22.10.2015 NAV2016 Merge <<
        IF Approved THEN BEGIN
            CASE Status OF
                Status::"Pending Approval":
                    ERROR(Text002);
                Status::Released:
                    CODEUNIT.RUN(CODEUNIT::"Release Service Document EDMS", ServHeader);
                Status::Open:
                    BEGIN
                        ApprovedOnly := TRUE;
                        ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
                        ApprovalEntry.SETRANGE("Table ID", DATABASE::"Sales Header");
                        ApprovalEntry.SETRANGE("Document Type", ServHeader."Document Type");
                        ApprovalEntry.SETRANGE("Document No.", ServHeader."No.");
                        ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
                        IF ApprovalEntry.FINDSET THEN BEGIN
                            REPEAT
                                IF (ApprovedOnly = TRUE) AND (ApprovalEntry.Status <> ApprovalEntry.Status::Approved) THEN
                                    ApprovedOnly := FALSE;
                            UNTIL ApprovalEntry.NEXT = 0;

                            IF ApprovedOnly = TRUE AND TestApprovalLimit(ServHeader) THEN
                                CODEUNIT.RUN(CODEUNIT::"Release Service Document EDMS", ServHeader)
                            ELSE
                                ERROR(Text002);
                        END ELSE
                            ERROR(Text002);
                    END;
            END;
        END ELSE
            CODEUNIT.RUN(CODEUNIT::"Release Service Document EDMS", ServHeader);
    end;

    [Scope('Internal')]
    procedure PerformManualReopen(var ServHeader: Record "25006145")
    begin
        //22.10.2015 NAV2016 Merge >>
        //Approved := ApprovalManagement.CheckApprServDocument(ServHeader);
        //22.10.2015 NAV2016 Merge <<
        IF Approved THEN BEGIN
            CASE Status OF
                Status::"Pending Approval":
                    ERROR(Text003);
                Status::Open, Status::Released, Status::"Pending Prepayment":
                    Reopen(ServHeader);
            END;
        END ELSE
            Reopen(ServHeader);
    end;

    [Scope('Internal')]
    procedure TestApprovalLimit(ServHeader: Record "25006145"): Boolean
    var
        UserSetup: Record "91";
        AppAmount: Decimal;
        AppAmountLCY: Decimal;
    begin
        //22.10.2015 NAV2016 Merge >>
        //AppManagement.CalcServEDMSDocAmount(ServHeader,AppAmount,AppAmountLCY);
        //22.10.2015 NAV2016 Merge <<
        UserSetup.GET(USERID);
        IF UserSetup."Unlimited Sales Approval" THEN
            EXIT(TRUE)
        ELSE BEGIN
            IF AppAmountLCY > UserSetup."Sales Amount Approval Limit" THEN
                ERROR(Text002)
            ELSE
                EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure Reopen(var ServHeader: Record "25006145")
    var
        ServLine: Record "25006146";
    begin
        IF Status = Status::Open THEN
            EXIT;
        Status := Status::Open;

        // 12.05.2016 EB.P30 GH >>
        /*
        ServLine.SetServHeader(ServHeader);
        ServLine.SETRANGE("Document Type","Document Type");
        ServLine.SETRANGE("Document No.","No.");
        ServLine.SETFILTER(Type,'>0');
        ServLine.SETFILTER(Quantity,'<>0');
        IF RECORDLEVELLOCKING THEN
          ServLine.LOCKTABLE;
        IF ServLine.FINDSET THEN
          REPEAT
            ServLine.Amount := 0;
            ServLine."Amount Including VAT" := 0;
            ServLine."VAT Base Amount" := 0;
            ServLine.MODIFY;
          UNTIL ServLine.NEXT = 0;
        ServLine.RESET;
        */
        // << 12.05.2016 EB.P30 GH

        ServHeader.MODIFY(TRUE);

    end;

    [Scope('Internal')]
    procedure TestPrepayment(ServHeader: Record "25006145"): Boolean
    var
        ServLines: Record "25006146";
    begin
        ServLines.SETRANGE("Document Type", ServHeader."Document Type");
        ServLines.SETRANGE("Document No.", ServHeader."No.");
        ServLines.SETFILTER("Prepmt. Line Amount", '<>%1', 0);
        IF ServLines.FINDSET THEN BEGIN
            REPEAT
                IF ServLines."Prepmt. Amt. Inv." <> ServLines."Prepmt. Line Amount" THEN
                    EXIT(TRUE);
            UNTIL ServLines.NEXT = 0;
        END;
    end;
}


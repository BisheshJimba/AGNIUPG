codeunit 25006291 "Application Event Management"
{
    // 23.11.2015 EB.P7 #T017
    // Removed form EDMS version:
    //   TypeIDNameModifiedVersion ListDateTimeCompiledLockedLocked By
    //   511Gen. Jnl.-Check LineNoNAVW19.0015.09.1512:00:00YesYesEB\reinisc
    //   521Item Jnl.-Check LineNoNAVW19.0015.09.1512:00:00YesYesEB\reinisc
    //   5414Release Sales DocumentNoNAVW19.0015.09.1512:00:00YesYesEB\reinisc
    //   5415Release Purchase DocumentNoNAVW19.0015.09.1512:00:00YesYesEB\reinisc
    //   17302Bin ContentNoNAVW19.0015.09.1512:00:00YesYesEB\reinisc
    // 
    // Customer table changes:
    //   OnInsert Modified, code moved to Events
    //   Added function GetInsertFromContacts
    //   Moved function CustomerUpdateFromTemplate to Events
    //   OnDelete Modified code moved to events
    //   Blocked field OnValidate Code moved to events
    // 
    // Item table partly moved code to events
    // Requisition Wksh. Name table code moved to events
    // Nonstock Item OnDelete Code moved to events
    // SalesPrice Trigger code moved to events (viss kods)
    // Sales Line Discount code moved from triggers to events (viss kods)
    // Purchase Price code moved from triggers to events (viss kods)
    // Bin Content viss kods uz eventiem (izÕemts no dms)


    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'is not within your range of allowed posting dates';
        Text100: Label 'Do you want to use a Customer Template to create a Customer?';
        Text101: Label 'The Creation of the customer has been aborted.';
        tcDMS005: Label 'You have no right to block/unblock customer!';
        Text102: Label 'Don''t forget to set %1';
        Text103: Label 'You cannot change a default bin content for bin %1, because this is SIE Bin.';

    [EventSubscriber(ObjectType::Codeunit, 11, 'OnAfterCheckGenJnlLine', '', false, false)]
    local procedure ValidateOnAfterCheckGenJnlLine(var GenJournalLine: Record "81")
    var
        LicensePermission: Record "2000000043";
        UserSetup: Record "91";
        ApprAllowed: Boolean;
    begin
        IF "Vehicle Serial No." <> '' THEN BEGIN
            LicensePermission.SETRANGE("Object Type", LicensePermission."Object Type"::Codeunit);
            LicensePermission.SETRANGE("Object Number", CODEUNIT::VehicleAccountingCycleMgt);
            LicensePermission.SETFILTER("Execute Permission", '<>%1', LicensePermission."Execute Permission"::" ");
            ApprAllowed := NOT LicensePermission.ISEMPTY;
            IF ApprAllowed THEN
                GenJournalLine.TESTFIELD("Vehicle Accounting Cycle No.");
        END;

        IF USERID <> '' THEN
            IF UserSetup.GET(USERID) THEN
                IF UserSetup."Allow Posting Only Today" AND (GenJournalLine."Posting Date" <> TODAY) THEN
                    GenJournalLine.FIELDERROR("Posting Date", Text001);
    end;

    [EventSubscriber(ObjectType::Codeunit, 21, 'OnAfterCheckItemJnlLine', '', false, false)]
    local procedure ValidateOnAfterCheckItemJnlLine(var ItemJnlLine: Record "83")
    var
        VehicleCostMgt: Codeunit "25006016";
        Item: Record "27";
    begin
        IF ("Item Type" = "Item Type"::"Model Version")
 AND (ItemJnlLine."Item Charge No." = '') THEN
            ItemJnlLine.TESTFIELD("Vehicle Accounting Cycle No.");

        IF Item.GET(ItemJnlLine."Item No.") THEN
            IF VehicleCostMgt.ItemHaveSpecialVehicleCost(Item) THEN
                VehicleCostMgt.CheckItemJnlVehicleCostReq(Item, ItemJnlLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, 414, 'OnBeforeReleaseSalesDoc', '', false, false)]
    local procedure ValidateOnBeforeReleaseSalesDoc(var SalesHeader: Record "36")
    var
        SalesLine: Record "37";
        SalesSetup: Record "311";
        ServiceSetup: Record "25006120";
        MakeSetup: Record "25006050";
        Approved: Boolean;
    begin
        SalesSetup.GET;
        CASE SalesHeader."Document Profile" OF
            SalesHeader."Document Profile"::"Spare Parts Trade", SalesHeader."Document Profile"::"Vehicles Trade":
                CASE SalesHeader."Document Type" OF
                    SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order:
                        IF SalesSetup."Payment Method Mandatory" THEN
                            SalesHeader.TESTFIELD("Payment Method Code");
                END;
            SalesHeader."Document Profile"::Service:
                BEGIN
                    ServiceSetup.GET;
                    CASE SalesHeader."Document Type" OF
                        SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::Order:
                            IF ServiceSetup."Payment Method Mandatory" THEN
                                SalesHeader.TESTFIELD("Payment Method Code");
                    END;
                END;
        END;

        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETFILTER(Type, '>0');
        SalesLine.SETFILTER(Quantity, '<>0');
        SalesLine.SETRANGE("Line Type", SalesLine."Line Type"::Vehicle);
        IF SalesLine.FINDSET THEN
            REPEAT
                MakeSetup.GET(SalesLine."Make Code");
                IF MakeSetup."Use Vehicle Assemblies" THEN
                    SalesLine.TESTFIELD(SalesLine."Vehicle Assembly ID")    //05.12.2007 EDMS P3
            UNTIL SalesLine.NEXT = 0;
        SalesLine.SETRANGE("Line Type");

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETRANGE(Type, SalesLine.Type::Item);
        IF SalesLine.FINDFIRST THEN
            REPEAT
                SalesLine.ApplyMarkupRestrictions(1);
            UNTIL SalesLine.NEXT = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, 415, 'OnBeforeReleasePurchaseDoc', '', false, false)]
    local procedure ValidateOnBeforeReleasePurchaseDoc(var PurchaseHeader: Record "38")
    var
        PurchLine: Record "39";
        MakeSetup: Record "25006050";
    begin
        PurchLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchLine.SETRANGE("Document No.", PurchaseHeader."No.");
        PurchLine.SETRANGE("Line Type", PurchLine."Line Type"::Vehicle);
        IF PurchLine.FIND('-') THEN
            REPEAT
                //08.24.2015 chandra
                CASE TRUE OF
                    // Order and invoice
                    (PurchLine."Qty. to Receive" > 0) AND (PurchLine."Qty. to Invoice" > 0):
                        PurchLine.TESTFIELD("Vehicle Status Code");
                    (PurchLine."Qty. to Receive" > 0) AND (PurchLine."Qty. to Invoice" = 0):
                        PurchLine.TESTFIELD("Vehicle Status Code");
                    (PurchLine."Qty. to Receive" = 0) AND (PurchLine."Qty. to Invoice" > 0):
                        PurchLine.TESTFIELD("Vehicle Status Code");
                    // Return Order and Credit Memo
                    (PurchLine."Return Qty. to Ship" > 0) AND (PurchLine."Qty. to Invoice" > 0):
                        PurchLine.TESTFIELD("Vehicle Status Code");
                    (PurchLine."Return Qty. to Ship" > 0) AND (PurchLine."Qty. to Invoice" = 0):
                        PurchLine.TESTFIELD("Vehicle Status Code");
                    (PurchLine."Return Qty. to Ship" = 0) AND (PurchLine."Qty. to Invoice" > 0):
                        PurchLine.TESTFIELD("Vehicle Status Code");
                END;
                //08.24.2015 chandra
                //PurchLine.TESTFIELD("Vehicle Status Code");
                MakeSetup.GET(PurchLine."Make Code");
                IF MakeSetup."Use Vehicle Assemblies" THEN
                    PurchLine.TESTFIELD(PurchLine."Vehicle Assembly ID")
            UNTIL PurchLine.NEXT = 0;
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnBeforeInsertEvent', '', false, false)]
    local procedure UpdateCustomerOnAfterInsertCustomer(var Rec: Record "18"; RunTrigger: Boolean)
    var
        CustTemplate: Record "5105";
    begin
        IF RunTrigger THEN
            IF NOT Rec.GetInsertFromContact THEN BEGIN
                CustTemplate.RESET;
                IF CustTemplate.FIND('-') THEN BEGIN
                    IF CONFIRM(Text100, TRUE) THEN BEGIN
                        COMMIT;
                        CustUpdateFromTemplate(Rec, '');
                    END;
                END;
            END;
    end;

    [Scope('Internal')]
    procedure CustUpdateFromTemplate(var Customer2: Record "18"; CustTemplateCode: Code[10])
    var
        CustTemplate: Record "5105";
        DefaultDim: Record "352";
        DefaultDim2: Record "352";
    begin
        IF CustTemplateCode <> '' THEN
            CustTemplate.GET(CustTemplateCode)
        ELSE BEGIN
            IF PAGE.RUNMODAL(0, CustTemplate) = ACTION::LookupOK THEN
                CustTemplateCode := CustTemplate.Code
            ELSE
                ERROR(Text101);
        END;

        IF CustTemplate.Code <> '' THEN BEGIN
            Customer2."Dealer Segment Type" := CustTemplate."Territory Code";
            Customer2."Currency Code" := CustTemplate."Currency Code";
            Customer2."Country/Region Code" := CustTemplate."Country/Region Code";
            Customer2."Customer Posting Group" := CustTemplate."Customer Posting Group";
            Customer2."Customer Price Group" := CustTemplate."Customer Price Group";
            Customer2."Invoice Disc. Code" := CustTemplate."Invoice Disc. Code";
            Customer2."Customer Disc. Group" := CustTemplate."Customer Disc. Group";
            Customer2."Allow Line Disc." := CustTemplate."Allow Line Disc.";
            Customer2."Gen. Bus. Posting Group" := CustTemplate."Gen. Bus. Posting Group";
            Customer2."VAT Bus. Posting Group" := CustTemplate."VAT Bus. Posting Group";
            Customer2."Prices Including VAT" := CustTemplate."Prices Including VAT";
            Customer2."Payment Terms Code" := CustTemplate."Payment Terms Code";
            Customer2."Payment Method Code" := CustTemplate."Payment Method Code";
            Customer2.Reserve := CustTemplate.Reserve;

            DefaultDim.SETRANGE("Table ID", DATABASE::"Customer Template");
            DefaultDim.SETRANGE(DefaultDim."No.", CustTemplate.Code);
            IF DefaultDim.FINDSET THEN
                REPEAT
                    CLEAR(DefaultDim2);
                    DefaultDim2.INIT;
                    DefaultDim2.VALIDATE("Table ID", DATABASE::Customer);
                    DefaultDim2."No." := Customer2."No.";
                    DefaultDim2.VALIDATE("Dimension Code", DefaultDim."Dimension Code");
                    DefaultDim2.VALIDATE("Dimension Value Code", DefaultDim."Dimension Value Code");
                    DefaultDim2."Value Posting" := DefaultDim."Value Posting";
                    DefaultDim2.INSERT(TRUE);
                UNTIL DefaultDim.NEXT = 0;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure DeletePrepmtOnAfterDeleteCustomer(var Rec: Record "18"; RunTrigger: Boolean)
    var
        SalesPrepmtPct: Record "459";
    begin
        IF RunTrigger THEN BEGIN
            SalesPrepmtPct.SETCURRENTKEY("Sales Type", "Sales Code");
            SalesPrepmtPct.SETRANGE("Sales Type", SalesPrepmtPct."Sales Type"::Customer);
            SalesPrepmtPct.SETRANGE("Sales Code", Rec."No.");
            SalesPrepmtPct.DELETEALL;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 18, 'OnAfterValidateEvent', 'Blocked', false, false)]
    local procedure CheckAllowOnAfterValidateCustomerBlocked(var Rec: Record "18"; var xRec: Record "18"; CurrFieldNo: Integer)
    var
        UserSetup: Record "91";
    begin
        IF CurrFieldNo = Rec.FIELDNO(Blocked) THEN
            IF UserSetup.GET(USERID) THEN BEGIN
                IF NOT UserSetup."Allow Block Customer" THEN
                    ERROR(tcDMS005);
            END ELSE
                ERROR(tcDMS005);
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterInsertEvent', '', false, false)]
    local procedure AfterOnInsertItem(var Rec: Record "27"; RunTrigger: Boolean)
    var
        InvtSetup: Record "313";
    begin
        IF RunTrigger THEN
            IF Rec."Item Type" = Rec."Item Type"::"Model Version" THEN BEGIN
                InvtSetup.GET;
                IF InvtSetup."Def. Model Version Item Cat." <> '' THEN
                    Rec.SetNewEntryVariable(TRUE);
                Rec.VALIDATE("Item Category Code", InvtSetup."Def. Model Version Item Cat.");
                Rec.SetNewEntryVariable(FALSE);
            END;
    end;

    [Scope('Internal')]
    procedure FillItemGroupDefDim(var Rec: Record "27")
    var
        ItemGrDefDim: Record "25006769";
        DefDim: Record "352";
        InvSetup: Record "313";
    begin
        InvSetup.GET;
        IF NOT InvSetup."Fill Item Group Def. Dimension" THEN
            EXIT;

        IF Rec."Item Category Code" = '' THEN
            EXIT;

        ItemGrDefDim.RESET;
        ItemGrDefDim.SETFILTER(ItemGrDefDim."Item Category Code", '%1|%2', '', Rec."Item Category Code");
        ItemGrDefDim.SETFILTER(ItemGrDefDim."Product Group Code", '%1|%2', '', Rec."Product Group Code");
        ItemGrDefDim.SETFILTER(ItemGrDefDim."Product Subgroup Code", '%1|%2', '', "Product Subgroup Code");
        IF NOT ItemGrDefDim.FINDLAST THEN
            EXIT;

        Rec.MODIFY;                                // EB.P21 #T0047

        IF ItemGrDefDim.FINDSET THEN           // EB.P21 #T0047
            REPEAT                               // EB.P21 #T0047
                DefDim.RESET;
                DefDim.SETRANGE("Table ID", DATABASE::Item);
                DefDim.SETRANGE("No.", Rec."No.");
                DefDim.SETRANGE("Dimension Code", ItemGrDefDim."Dimension Code");
                IF DefDim.FIND('-') THEN BEGIN
                    DefDim."Dimension Value Code" := ItemGrDefDim."Dimension Value Code";
                    DefDim."Value Posting" := DefDim."Value Posting"::" ";
                    DefDim.MODIFY(TRUE);
                END ELSE BEGIN
                    DefDim.INIT;
                    DefDim."Table ID" := DATABASE::Item;
                    DefDim."No." := Rec."No.";
                    DefDim."Dimension Code" := ItemGrDefDim."Dimension Code";
                    DefDim."Dimension Value Code" := ItemGrDefDim."Dimension Value Code";
                    DefDim."Value Posting" := DefDim."Value Posting"::" ";
                    DefDim.INSERT(TRUE);
                END;
            UNTIL ItemGrDefDim.NEXT = 0;         // EB.P21 #T0047

        // EB.P21 #T0047 >>
        Rec.GET(Rec."No.");
        Rec.MODIFY(TRUE);
        // EB.P21 #T0047 <<
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterValidateEvent', 'Item Category Code', false, false)]
    local procedure AfterOnValidateItemCategoryCode(var Rec: Record "27"; var xRec: Record "27"; CurrFieldNo: Integer)
    begin
        IF CurrFieldNo = Rec.FIELDNO("Item Category Code") THEN
            FillItemGroupDefDim(Rec);
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterValidateEvent', 'Product Group Code', false, false)]
    local procedure AfterOnValidateItemProductGroupCode(var Rec: Record "27"; var xRec: Record "27"; CurrFieldNo: Integer)
    var
        ProductSubgrp: Record "25006746";
    begin
        IF CurrFieldNo = Rec.FIELDNO("Product Group Code") THEN BEGIN
            IF NOT ProductSubgrp.GET(Rec."Item Category Code", Rec."Product Group Code", Rec."Product Subgroup Code") THEN
                Rec.VALIDATE("Product Subgroup Code", '')
            ELSE
                Rec.VALIDATE("Product Subgroup Code");

            FillItemGroupDefDim(Rec);
        END;
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterValidateEvent', 'Product Subgroup Code', false, false)]
    local procedure AfterOnValidateItemProductSubgroupCode(var Rec: Record "27"; var xRec: Record "27"; CurrFieldNo: Integer)
    var
        ProductSubgrp: Record "25006746";
    begin
        IF CurrFieldNo = Rec.FIELDNO("Product Subgroup Code") THEN BEGIN
            FillItemGroupDefDim(Rec);
        END;
    end;

    [EventSubscriber(ObjectType::Table, 27, 'OnAfterValidateEvent', 'Exchange Unit', false, false)]
    local procedure AfterOnValidateItemExchangeUnit(var Rec: Record "27"; var xRec: Record "27"; CurrFieldNo: Integer)
    var
        recNonstockItem: Record "5718";
    begin
        IF CurrFieldNo = Rec.FIELDNO("Exchange Unit") THEN BEGIN
            recNonstockItem.RESET;
            recNonstockItem.SETCURRENTKEY("Item No.");
            recNonstockItem.SETRANGE("Item No.", Rec."No.");
            IF recNonstockItem.FINDFIRST THEN BEGIN
                recNonstockItem."Exchange Unit" := Rec."Exchange Unit";
                recNonstockItem.MODIFY;
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 245, 'OnAfterInsertEvent', '', false, false)]
    local procedure AfterOnInsertRequisitionWkshName(var Rec: Record "245"; RunTrigger: Boolean)
    var
        ReqWkshTmpl: Record "244";
    begin
        IF RunTrigger THEN BEGIN
            IF Rec."Document Profile" = 0 THEN BEGIN
                ReqWkshTmpl.GET(Rec."Worksheet Template Name");
                Rec."Document Profile" := ReqWkshTmpl."Document Profile";
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 5718, 'OnAfterDeleteEvent', '', false, false)]
    local procedure AfterOnDeleteNonstockItem(var Rec: Record "5718"; RunTrigger: Boolean)
    var
        NonstockSalesPrice: Record "25006749";
        NonstockPurchasePrice: Record "25006751";
        NonstockSalesLineDiscount: Record "25006750";
        NonstockPurchaseLineDisc: Record "25006752";
        ItemSubstitution: Record "5715";
    begin
        IF RunTrigger THEN BEGIN
            NonstockSalesPrice.RESET;
            NonstockSalesPrice.SETRANGE("Nonstock Item Entry No.", Rec."Entry No.");
            NonstockSalesPrice.DELETEALL;

            NonstockPurchasePrice.RESET;
            NonstockPurchasePrice.SETRANGE("Nonstock Item Entry No.", Rec."Entry No.");
            NonstockPurchasePrice.DELETEALL;

            NonstockSalesLineDiscount.RESET;
            NonstockSalesLineDiscount.SETRANGE("Nonstock Item Entry No.", Rec."Entry No.");
            NonstockSalesLineDiscount.DELETEALL;

            NonstockPurchaseLineDisc.RESET;
            NonstockPurchaseLineDisc.SETRANGE("Nonstock Item Entry No.", Rec."Entry No.");
            NonstockPurchaseLineDisc.DELETEALL;

            ItemSubstitution.RESET;
            ItemSubstitution.SETRANGE(Type, ItemSubstitution.Type::"Nonstock Item");
            ItemSubstitution.SETRANGE("No.", Rec."Entry No.");
            ItemSubstitution.DELETEALL;

            ItemSubstitution.RESET;
            ItemSubstitution.SETRANGE("Substitute Type", ItemSubstitution."Substitute Type"::"Nonstock Item");
            ItemSubstitution.SETRANGE("Substitute No.", Rec."Entry No.");
            ItemSubstitution.DELETEALL;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 7002, 'OnBeforeInsertEvent', '', false, false)]
    local procedure BeforeOnInsertSalesPrice(var Rec: Record "7002"; RunTrigger: Boolean)
    var
        SalesPriceCalcMgt: Codeunit "7000";
        xRec: Record "7002";
    begin
        IF RunTrigger THEN BEGIN
            xRec := Rec;
            SalesPriceCalcMgt.ItemSalesPriceToNonstock(Rec, xRec, 0);
        END;
    end;

    [EventSubscriber(ObjectType::Table, 7002, 'OnBeforeModifyEvent', '', false, false)]
    local procedure BeforeOnModifySalesPrice(var Rec: Record "7002"; var xRec: Record "7002"; RunTrigger: Boolean)
    var
        SalesPriceCalcMgt: Codeunit "7000";
    begin
        IF RunTrigger THEN
            SalesPriceCalcMgt.ItemSalesPriceToNonstock(Rec, xRec, 1);
    end;

    [EventSubscriber(ObjectType::Table, 7002, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure BeforeOnDeleteSalesPrice(var Rec: Record "7002"; RunTrigger: Boolean)
    var
        xRec: Record "7002";
        SalesPriceCalcMgt: Codeunit "7000";
    begin
        IF RunTrigger THEN BEGIN
            xRec := Rec;
            SalesPriceCalcMgt.ItemSalesPriceToNonstock(Rec, xRec, 3);
        END;
    end;

    [EventSubscriber(ObjectType::Table, 7002, 'OnBeforeRenameEvent', '', false, false)]
    local procedure BeforeOnRenameSalesPrice(var Rec: Record "7002"; var xRec: Record "7002"; RunTrigger: Boolean)
    var
        SalesPriceCalcMgt: Codeunit "7000";
    begin
        IF RunTrigger THEN
            SalesPriceCalcMgt.ItemSalesPriceToNonstock(Rec, xRec, 2);
    end;

    [EventSubscriber(ObjectType::Table, 7002, 'OnBeforeValidateEvent', 'Item No.', false, false)]
    local procedure BeforeOnValidateSalesPriceItemNo(var Rec: Record "7002"; var xRec: Record "7002"; CurrFieldNo: Integer)
    var
        Item: Record "27";
    begin
        IF Item.GET(Rec."Item No.") THEN BEGIN
            Rec."Make Code" := Item."Make Code";
            Rec."Model Code" := Item."Model Code";
            Rec."Allow Invoice Disc." := Item."Allow Invoice Disc.";
        END;
    end;

    [EventSubscriber(ObjectType::Table, 7002, 'OnBeforeValidateEvent', 'Price Includes VAT', false, false)]
    local procedure BeforeOnValidateSalesPricePriceIncVat(var Rec: Record "7002"; var xRec: Record "7002"; CurrFieldNo: Integer)
    begin
        IF (Rec."Price Includes VAT" <> xRec."Price Includes VAT") AND Rec."Price Includes VAT" THEN
            MESSAGE(Text102, Rec.FIELDCAPTION(Rec."VAT Bus. Posting Gr. (Price)"))
    end;

    [EventSubscriber(ObjectType::Table, 7004, 'OnAfterInsertEvent', '', false, false)]
    local procedure AfterOnInsertSalesLineDiscount(var Rec: Record "7004"; RunTrigger: Boolean)
    var
        SalesPriceCalcMgt: Codeunit "7000";
        xRec: Record "7004";
    begin
        IF RunTrigger THEN BEGIN
            xRec := Rec;
            SalesPriceCalcMgt.ItemSalesLineDiscToNonstock(Rec, xRec, 0);
        END;
    end;

    [EventSubscriber(ObjectType::Table, 7004, 'OnAfterModifyEvent', '', false, false)]
    local procedure AfterOnModifySalesLineDiscount(var Rec: Record "7004"; var xRec: Record "7004"; RunTrigger: Boolean)
    var
        SalesPriceCalcMgt: Codeunit "7000";
    begin
        IF RunTrigger THEN
            SalesPriceCalcMgt.ItemSalesLineDiscToNonstock(Rec, xRec, 1);
    end;

    [EventSubscriber(ObjectType::Table, 7004, 'OnAfterDeleteEvent', '', false, false)]
    local procedure AfterOnDeleteSalesLineDiscount(var Rec: Record "7004"; RunTrigger: Boolean)
    var
        SalesPriceCalcMgt: Codeunit "7000";
        xRec: Record "7004";
    begin
        IF RunTrigger THEN BEGIN
            xRec := Rec;
            SalesPriceCalcMgt.ItemSalesLineDiscToNonstock(Rec, xRec, 3);
        END;
    end;

    [EventSubscriber(ObjectType::Table, 7004, 'OnAfterRenameEvent', '', false, false)]
    local procedure AfterOnRenameSalesLineDiscount(var Rec: Record "7004"; var xRec: Record "7004"; RunTrigger: Boolean)
    var
        SalesPriceCalcMgt: Codeunit "7000";
    begin
        IF RunTrigger THEN
            SalesPriceCalcMgt.ItemSalesLineDiscToNonstock(Rec, xRec, 2);
    end;

    [EventSubscriber(ObjectType::Table, 7012, 'OnAfterInsertEvent', '', false, false)]
    local procedure AfterOnInsertPurchasePrice(var Rec: Record "7012"; RunTrigger: Boolean)
    var
        PurchPriceCalcMgt: Codeunit "7010";
        xRec: Record "7012";
    begin
        IF RunTrigger THEN BEGIN
            xRec := Rec;
            PurchPriceCalcMgt.ItemPurchPriceToNonstock(Rec, xRec, 0);
        END;
    end;

    [EventSubscriber(ObjectType::Table, 7012, 'OnAfterModifyEvent', '', false, false)]
    local procedure AfterOnModifyPurchasePrice(var Rec: Record "7012"; var xRec: Record "7012"; RunTrigger: Boolean)
    var
        PurchPriceCalcMgt: Codeunit "7010";
    begin
        IF RunTrigger THEN
            PurchPriceCalcMgt.ItemPurchPriceToNonstock(Rec, xRec, 1);
    end;

    [EventSubscriber(ObjectType::Table, 7012, 'OnAfterDeleteEvent', '', false, false)]
    local procedure AfterOnDeletePurchasePrice(var Rec: Record "7012"; RunTrigger: Boolean)
    var
        PurchPriceCalcMgt: Codeunit "7010";
        xRec: Record "7012";
    begin
        IF RunTrigger THEN BEGIN
            xRec := Rec;
            PurchPriceCalcMgt.ItemPurchPriceToNonstock(Rec, xRec, 3);
        END;
    end;

    [EventSubscriber(ObjectType::Table, 7012, 'OnAfterRenameEvent', '', false, false)]
    local procedure AfterOnRenamePurchasePrice(var Rec: Record "7012"; var xRec: Record "7012"; RunTrigger: Boolean)
    var
        PurchPriceCalcMgt: Codeunit "7010";
    begin
        IF RunTrigger THEN
            PurchPriceCalcMgt.ItemPurchPriceToNonstock(Rec, xRec, 2);
    end;

    [EventSubscriber(ObjectType::Table, 7014, 'OnAfterInsertEvent', '', false, false)]
    local procedure AfterOnInsertPurchaseLineDiscount(var Rec: Record "7014"; RunTrigger: Boolean)
    var
        PurchPriceCalcMgt: Codeunit "7010";
        xRec: Record "7014";
    begin
        IF RunTrigger THEN BEGIN
            xRec := Rec;
            PurchPriceCalcMgt.ItemPurLineDiscToNonstock(Rec, xRec, 0);
        END;
    end;

    [EventSubscriber(ObjectType::Table, 7014, 'OnAfterModifyEvent', '', false, false)]
    local procedure AfterOnModifyPurchaseLineDiscount(var Rec: Record "7014"; var xRec: Record "7014"; RunTrigger: Boolean)
    var
        PurchPriceCalcMgt: Codeunit "7010";
    begin
        IF RunTrigger THEN
            PurchPriceCalcMgt.ItemPurLineDiscToNonstock(Rec, xRec, 1);
    end;

    [EventSubscriber(ObjectType::Table, 7014, 'OnAfterDeleteEvent', '', false, false)]
    local procedure AfterOnDeletePurchaseLineDiscount(var Rec: Record "7014"; RunTrigger: Boolean)
    var
        PurchPriceCalcMgt: Codeunit "7010";
        xRec: Record "7014";
    begin
        IF RunTrigger THEN BEGIN
            xRec := Rec;
            PurchPriceCalcMgt.ItemPurLineDiscToNonstock(Rec, xRec, 3);
        END;
    end;

    [EventSubscriber(ObjectType::Table, 7014, 'OnAfterRenameEvent', '', false, false)]
    local procedure AfterOnRenamePurchaseLineDiscount(var Rec: Record "7014"; var xRec: Record "7014"; RunTrigger: Boolean)
    var
        PurchPriceCalcMgt: Codeunit "7010";
    begin
        IF RunTrigger THEN
            PurchPriceCalcMgt.ItemPurLineDiscToNonstock(Rec, xRec, 2);
    end;

    [EventSubscriber(ObjectType::Table, 7302, 'OnAfterValidateEvent', 'Default', false, false)]
    local procedure AfterOnValidateBinContentDefault(var Rec: Record "7302"; var xRec: Record "7302"; CurrFieldNo: Integer)
    var
        SIE: Record "25006700";
        SIESAMOAMgt: Codeunit "25006703";
    begin
        /*
          There is possible generalisation - through SIE management and
          generalized procedure that will call all sie interfaces. (AS event)
          Now it is for samoa only
        */
        IF (xRec.Default <> Rec.Default) AND NOT Rec.Default THEN BEGIN
            SIE.SETRANGE(Active, TRUE);
            SIE.SETRANGE(SystemCode, SIE.SystemCode::SAMOA);
            IF SIE.FINDFIRST THEN
                IF SIESAMOAMgt.CheckSIEBin(Rec."Location Code", Rec."Bin Code") AND SIE."Check 1" THEN
                    ERROR(Text103, Rec."Bin Code")
        END;

    end;
}


codeunit 25006016 "Vehicle Cost Management"
{
    // 21.01.2015 EDMS P11
    //   Vehicle special cost adjustment
    //   Created


    trigger OnRun()
    begin
    end;

    var
        InvtSetup: Record "313";
        SetupIsLoaded: Boolean;
        InvalidCostingMethodErr: Label 'Vehicle Cost: Item %1 has invalid costing method %2.', Comment = '%1 = Item No., %2 = item costing method';
        ItemNeedTrackingErr: Label 'Vehicle Cost: Item %1 need tracking code.', Comment = '%1 - Item No.';
        InvalidQuantityErr: Label 'Vehicle Cost: Quantity must have only values 1 or -1. Item No. %1, %2.', Comment = '%1 = Item No., %2 = Detailed info about record';
        InvalidEntryType: Label 'Vehicle Cost: Entry type of item %1 cannot be %2. %3.', Comment = '%1 = Item No., %2 = Item Ledger Entry Type, %3 = Detailed info about record';

    local procedure LoadSetup()
    begin
        IF SetupIsLoaded THEN
            EXIT;
        InvtSetup.GET;
        SetupIsLoaded := TRUE;
    end;

    [Scope('Internal')]
    procedure ItemHaveSpecialVehicleCost(var TheItem: Record "27") result: Boolean
    var
        Item: Record "27";
    begin
        LoadSetup;
        result := InvtSetup."Vehicle Special Costing" AND (TheItem."Item Type" = TheItem."Item Type"::"Model Version");
    end;

    [Scope('Internal')]
    procedure CheckAllItemLedgVehicleCostReq(var TheItem: Record "27")
    var
        ItemLedgerEntry: Record "32";
    begin
        ItemLedgerEntry.SETRANGE("Item No.", TheItem."No.");
        IF ItemLedgerEntry.FINDSET THEN
            REPEAT
                CheckItemLedgVehicleCostReq(TheItem, ItemLedgerEntry);
            UNTIL ItemLedgerEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CheckItemVehicleCostReq(TheItem: Record "27"; Quantity: Decimal; EntryType: Integer; TableCapt: Text; DetailedInfo: Text)
    var
        ItemLedgerEntry: Record "32";
    begin
        IF TheItem."Costing Method" <> TheItem."Costing Method"::Specific THEN
            ERROR(InvalidCostingMethodErr, TheItem."No.", TheItem."Costing Method");

        IF TheItem."Item Tracking Code" = '' THEN
            ERROR(ItemNeedTrackingErr, TheItem."No.");

        //TODO: Check Stock keeping units
        //TODO: Check Variants

        IF NOT (Quantity IN [1, -1, 0]) THEN
            ERROR(InvalidQuantityErr, TheItem."No.", DetailedInfo);

        ItemLedgerEntry."Entry Type" := EntryType;
        IF NOT (ItemLedgerEntry."Entry Type" IN [ItemLedgerEntry."Entry Type"::Purchase,
                                                 ItemLedgerEntry."Entry Type"::Sale,
                                                 ItemLedgerEntry."Entry Type"::"Positive Adjmt.",
                                                 ItemLedgerEntry."Entry Type"::"Negative Adjmt.",
                                                 ItemLedgerEntry."Entry Type"::Transfer])
        THEN
            ERROR(InvalidEntryType,
                  TheItem."No.", ItemLedgerEntry."Entry Type", DetailedInfo);
    end;

    [Scope('Internal')]
    procedure CheckItemLedgVehicleCostReq(TheItem: Record "27"; ItemLedgerEntry: Record "32")
    begin
        CheckItemVehicleCostReq(TheItem, ItemLedgerEntry.Quantity, ItemLedgerEntry."Entry Type", ItemLedgerEntry.TABLECAPTION,
                        STRSUBSTNO('%1: %2.', ItemLedgerEntry.FIELDCAPTION("Entry No."), ItemLedgerEntry."Entry No."));
    end;

    [Scope('Internal')]
    procedure CheckItemJnlVehicleCostReq(TheItem: Record "27"; ItemJnlLine: Record "83")
    var
        DetailedInfo: Text;
    begin
        IF ItemJnlLine.Adjustment THEN
            EXIT;
        IF ItemJnlLine."Item Charge No." <> '' THEN
            EXIT;
        IF ItemJnlLine."Value Entry Type" <> ItemJnlLine."Value Entry Type"::"Direct Cost" THEN
            EXIT;
        IF (ItemJnlLine."Journal Template Name" <> '') OR (ItemJnlLine."Journal Batch Name" <> '') THEN
            DetailedInfo := STRSUBSTNO('%1: %2, %3: %4, %5: %6.',
                                       ItemJnlLine.FIELDCAPTION("Journal Template Name"), ItemJnlLine."Journal Template Name",
                                       ItemJnlLine.FIELDCAPTION("Journal Batch Name"), ItemJnlLine."Journal Batch Name",
                                       ItemJnlLine.FIELDCAPTION("Line No."), ItemJnlLine."Line No.");
        CheckItemVehicleCostReq(TheItem, ItemJnlLine.Quantity, ItemJnlLine."Entry Type", ItemJnlLine.TABLECAPTION, DetailedInfo);
    end;

    [Scope('Internal')]
    procedure GetPrevItemLedgEntry(CurrItemLedgEntryNo: Integer; var PrevItemLedgEntry: Record "32") Result: Boolean
    var
        ItemApplEntry: Record "339";
    begin
        Result := FALSE;

        ItemApplEntry.SETRANGE("Item Ledger Entry No.", CurrItemLedgEntryNo);
        IF ItemApplEntry.FINDFIRST THEN BEGIN
            IF (ItemApplEntry."Item Ledger Entry No." = ItemApplEntry."Outbound Item Entry No.") AND (ItemApplEntry."Inbound Item Entry No." <> 0) THEN
                Result := PrevItemLedgEntry.GET(ItemApplEntry."Inbound Item Entry No.")
            ELSE
                IF (ItemApplEntry."Item Ledger Entry No." = ItemApplEntry."Inbound Item Entry No.") AND (ItemApplEntry."Outbound Item Entry No." <> 0) THEN
                    Result := PrevItemLedgEntry.GET(ItemApplEntry."Outbound Item Entry No.");
        END;
    end;

    [Scope('Internal')]
    procedure GetNextItemLedgEntry(CurrItemLedgEntryNo: Integer; var NextItemLedgEntry: Record "32") Result: Boolean
    var
        ItemApplEntry: Record "339";
    begin
        Result := FALSE;

        ItemApplEntry.SETRANGE("Item Ledger Entry No.", CurrItemLedgEntryNo);
        IF ItemApplEntry.FINDFIRST THEN BEGIN
            IF (ItemApplEntry."Item Ledger Entry No." = ItemApplEntry."Inbound Item Entry No.") THEN BEGIN
                ItemApplEntry.RESET;
                ItemApplEntry.SETRANGE("Inbound Item Entry No.", ItemApplEntry."Inbound Item Entry No.");
                ItemApplEntry.SETFILTER("Item Ledger Entry No.", '<>%1', ItemApplEntry."Item Ledger Entry No.");
                IF ItemApplEntry.FINDFIRST THEN
                    Result := NextItemLedgEntry.GET(ItemApplEntry."Item Ledger Entry No.");
            END
            ELSE
                IF (ItemApplEntry."Item Ledger Entry No." = ItemApplEntry."Outbound Item Entry No.") THEN BEGIN
                    ItemApplEntry.RESET;
                    ItemApplEntry.SETRANGE("Outbound Item Entry No.", ItemApplEntry."Outbound Item Entry No.");
                    ItemApplEntry.SETFILTER("Item Ledger Entry No.", '<>%1', ItemApplEntry."Item Ledger Entry No.");
                    IF ItemApplEntry.FINDFIRST THEN
                        Result := NextItemLedgEntry.GET(ItemApplEntry."Item Ledger Entry No.");
                END;
        END;
    end;
}


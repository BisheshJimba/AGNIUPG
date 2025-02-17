tableextension 50360 tableextension50360 extends "Inventory Adjustment Buffer"
{
    // 21.01.2015 EDMS P11
    //   Vehicle special cost adjustment
    //   Added fields:
    //     25006001  "Applies-to Entry"
    //     25006002  "Inventory Posting Group"
    //     25006003  "Gen. Prod. Posting Group"
    //   Added functions:
    //     ReadSetup
    //     AddActualCostBufEDMS
    //   Added global variables:
    //     InventSetupRead
    //     InventorySetup
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

        field(25006001; "Applies-to Entry"; Integer)
        {
        }
        field(25006002; "Inventory Posting Group"; Code[10])
        {
        }
        field(25006003; "Gen. Prod. Posting Group"; Code[10])
        {
        }
    }

    procedure AddActualCostBufEDMS(OrigValueEntry: Record "5802"; ValueEntry: Record "5802"; NewAdjustedCost: Decimal; NewAdjustedCostACY: Decimal)
    var
        InvntPostGroup: Record "94";
        GenProdPostGroup: Record "251";
        InvPostGroupCode: Code[10];
        GenProdGroupCode: Code[10];
        NextEntryNo: Integer;
        ValueEntryPostingDate: Date;
    begin
        ReadSetup;
        ValueEntryPostingDate := OrigValueEntry."Posting Date";
        IF InventorySetup."Vehicle Original Cost Date" THEN
            IF OrigValueEntry."Posting Date" < ValueEntry."Posting Date" THEN
                ValueEntryPostingDate := ValueEntry."Posting Date";

        IF NOT InvntPostGroup.GET(ValueEntry."Inventory Posting Group") THEN
            CLEAR(InvntPostGroup);
        IF InvntPostGroup."Split Value Entries" THEN
            InvPostGroupCode := ValueEntry."Inventory Posting Group"
        ELSE
            InvPostGroupCode := OrigValueEntry."Inventory Posting Group";

        IF NOT GenProdPostGroup.GET(ValueEntry."Gen. Prod. Posting Group") THEN
            CLEAR(GenProdPostGroup);
        IF GenProdPostGroup."Split Value Entries" THEN
            GenProdGroupCode := ValueEntry."Gen. Prod. Posting Group"
        ELSE
            GenProdGroupCode := OrigValueEntry."Gen. Prod. Posting Group";

        RESET;
        SETRANGE("Applies-to Entry", OrigValueEntry."Entry No.");
        SETRANGE("Inventory Posting Group", InvPostGroupCode);
        SETRANGE("Gen. Prod. Posting Group", GenProdGroupCode);
        SETRANGE("Posting Date", ValueEntryPostingDate);

        IF FINDFIRST THEN BEGIN
            IF ValueEntry."Expected Cost" THEN BEGIN
                "Cost Amount (Expected)" := "Cost Amount (Expected)" + NewAdjustedCost;
                "Cost Amount (Expected) (ACY)" := "Cost Amount (Expected) (ACY)" + NewAdjustedCostACY;
            END ELSE BEGIN
                "Cost Amount (Actual)" := "Cost Amount (Actual)" + NewAdjustedCost;
                "Cost Amount (Actual) (ACY)" := "Cost Amount (Actual) (ACY)" + NewAdjustedCostACY;
            END;
            MODIFY;
        END ELSE BEGIN
            RESET;
            IF FINDLAST THEN
                NextEntryNo := "Entry No.";
            NextEntryNo += 1;

            INIT;
            "Entry No." := NextEntryNo;
            "Applies-to Entry" := OrigValueEntry."Entry No.";
            "Item No." := ValueEntry."Item No.";
            "Document No." := ValueEntry."Document No.";
            "Location Code" := ValueEntry."Location Code";
            "Variant Code" := ValueEntry."Variant Code";
            "Entry Type" := ValueEntry."Entry Type";
            "Item Ledger Entry No." := ValueEntry."Item Ledger Entry No.";
            "Expected Cost" := ValueEntry."Expected Cost";
            "Posting Date" := ValueEntryPostingDate;
            IF ValueEntry."Expected Cost" THEN BEGIN
                "Cost Amount (Expected)" := NewAdjustedCost;
                "Cost Amount (Expected) (ACY)" := NewAdjustedCostACY;
            END ELSE BEGIN
                "Cost Amount (Actual)" := NewAdjustedCost;
                "Cost Amount (Actual) (ACY)" := NewAdjustedCostACY;
            END;
            "Valued By Average Cost" := ValueEntry."Valued By Average Cost";
            "Valuation Date" := ValueEntry."Valuation Date";
            "Inventory Posting Group" := InvPostGroupCode;
            "Gen. Prod. Posting Group" := GenProdGroupCode;
            INSERT;
        END;
        RESET;
    end;

    local procedure ReadSetup()
    begin
        IF InventSetupRead THEN
            EXIT;
        InventorySetup.GET;
        InventSetupRead := TRUE;
    end;

    var
        Item: Record "27";

    var
        InventSetupRead: Boolean;
        InventorySetup: Record "313";
}


tableextension 50351 tableextension50351 extends "Cost Element Buffer"
{
    // 30.08.2013 EDMS P8
    //   * fix to store data. It could situations when temporary line data filled but then need to save it - purpose not to loose amounts, some times because of movements lost amounts
    // 
    // 08.01.2009. EDMS P2
    //   * Added fields "Gen. Prod. Posting Group", "Gen. Bus. Posting Group" to group cost adjustments for vehicles by it
    //   * Added code AddActualCost2, AddExpectedCost2, AddRndgResidual2, Retreive2
    // 
    // 24-08-2007 EDMS P3
    //   * Added new field "Inventory Posting Group" to group cost adjustments for vehicles by it
    //   * To AddActualCost, AddExpectedCost, AddRndgResidual  added new parameter - to group by Invt. posting group
    //   * Created Retreive2 procedure to support new field "Inventory Posting Group"
    fields
    {
        modify(Type)
        {
            OptionCaption = 'Direct Cost,Revaluation,Rounding,Indirect Cost,Variance,Total,Quantity';

            //Unsupported feature: Property Modification (OptionString) on "Type(Field 1)".

        }
        field(25006000; "Inventory Posting Group"; Code[10])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }
        field(25006010; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
        }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on ""Type,Variance Type"(Key)".

        key(Key1; Type, "Variance Type", "Inventory Posting Group", "Gen. Prod. Posting Group")
        {
            Clustered = true;
        }
        key(Key2; "Inventory Posting Group", "Gen. Prod. Posting Group")
        {
            SumIndexFields = "Actual Cost", "Actual Cost (ACY)", "Expected Cost", "Expected Cost (ACY)";
        }
    }


    //Unsupported feature: Code Modification on "RoundActualCost(PROCEDURE 77)".

    //procedure RoundActualCost();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Actual Cost" := ROUND("Actual Cost" * ShareOfTotalCost,AmtRndgPrec);
    "Actual Cost (ACY)" := ROUND("Actual Cost (ACY)" * ShareOfTotalCost,AmtRndgPrecACY);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    "Actual Cost" := ROUND("Actual Cost" * ShareOfTotalCost,AmtRndgPrec);
    "Actual Cost (ACY)" := ROUND("Actual Cost (ACY)" * ShareOfTotalCost,AmtRndgPrecACY);
    IF NOT MODIFY THEN  //30.08.2013 EDMS P8
      INSERT;
    */
    //end;


    //Unsupported feature: Code Modification on "Retrieve(PROCEDURE 72)".

    //procedure Retrieve();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    RESET;
    Type := NewType;
    "Variance Type" := NewVarianceType;
    IF NOT FIND THEN BEGIN
      INIT;
      EXIT(FALSE);
    END;
    EXIT(TRUE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    // EDMS >>
    SETRANGE(Type);
    SETRANGE("Variance Type");
    SETRANGE("Inventory Posting Group");
    SETRANGE("Gen. Prod. Posting Group");
    // EDMS <<

    Type := NewType;
    "Variance Type" := NewVarianceType;

    // EDMS >>
    "Inventory Posting Group" := TempBufConditionEDMS."Inventory Posting Group";
    "Gen. Prod. Posting Group" := TempBufConditionEDMS."Gen. Prod. Posting Group";
    // EDMS <<

    #4..8
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateAvgCostBuffer(PROCEDURE 4)".

    //procedure UpdateAvgCostBuffer();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Actual Cost" := CostElementBuf."Actual Cost";
    "Actual Cost (ACY)" := CostElementBuf."Actual Cost (ACY)";
    "Last Valid Value Entry No" := LastValidEntryNo;
    "Remaining Quantity" := CostElementBuf."Remaining Quantity";
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4
    IF NOT MODIFY THEN  //30.08.2013 EDMS P8
      INSERT;
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateCostElementBuffer(PROCEDURE 5)".

    //procedure UpdateCostElementBuffer();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Remaining Quantity" := AvgCostBuf."Remaining Quantity";
    "Actual Cost" := AvgCostBuf."Actual Cost";
    "Actual Cost (ACY)" := AvgCostBuf."Actual Cost (ACY)";
    "Rounding Residual" := AvgCostBuf."Rounding Residual";
    "Rounding Residual (ACY)" := AvgCostBuf."Rounding Residual (ACY)";
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5
    IF NOT MODIFY THEN  //30.08.2013 EDMS P8
      INSERT;
    */
    //end;

    procedure PrepareBufOnValueEntryEDMS(ValueEntry: Record "5802")
    begin
        CLEAR(TempBufConditionEDMS);
        TempBufConditionEDMS.INIT;

        IF ValueEntry."Item No." = '' THEN
            EXIT;

        IF ItemEDMS."No." <> ValueEntry."Item No." THEN
            ItemEDMS.GET(ValueEntry."Item No.");

        IF (ItemEDMS."Item Type" IN [ItemEDMS."Item Type"::"Model Version"]) THEN BEGIN
            IF ValueEntry."Inventory Posting Group" <> '' THEN BEGIN
                IF InvntPostGroupEDMS.Code <> ValueEntry."Inventory Posting Group" THEN
                    InvntPostGroupEDMS.GET(ValueEntry."Inventory Posting Group");
                IF InvntPostGroupEDMS."Split Value Entries" THEN
                    TempBufConditionEDMS."Inventory Posting Group" := ValueEntry."Inventory Posting Group";
            END;

            IF ValueEntry."Gen. Prod. Posting Group" <> '' THEN BEGIN
                IF GenProdPostGroupEDMS.Code <> ValueEntry."Gen. Prod. Posting Group" THEN
                    GenProdPostGroupEDMS.GET(ValueEntry."Gen. Prod. Posting Group");
                IF GenProdPostGroupEDMS."Split Value Entries" THEN
                    TempBufConditionEDMS."Gen. Prod. Posting Group" := ValueEntry."Gen. Prod. Posting Group";
            END;
        END;
    end;

    procedure PrepareBufOnAdjmtBufEDMS(InventoryAdjustmentBuffer: Record "5895")
    begin
        CLEAR(TempBufConditionEDMS);
        TempBufConditionEDMS.INIT;

        IF InventoryAdjustmentBuffer."Item No." = '' THEN
            EXIT;

        IF ItemEDMS."No." <> InventoryAdjustmentBuffer."Item No." THEN
            ItemEDMS.GET(InventoryAdjustmentBuffer."Item No.");

        IF (ItemEDMS."Item Type" IN [ItemEDMS."Item Type"::"Model Version"]) THEN BEGIN
            IF InventoryAdjustmentBuffer."Inventory Posting Group" <> '' THEN BEGIN
                IF InvntPostGroupEDMS.Code <> InventoryAdjustmentBuffer."Inventory Posting Group" THEN
                    InvntPostGroupEDMS.GET(InventoryAdjustmentBuffer."Inventory Posting Group");
                IF InvntPostGroupEDMS."Split Value Entries" THEN
                    TempBufConditionEDMS."Inventory Posting Group" := InventoryAdjustmentBuffer."Inventory Posting Group";
            END;

            IF InventoryAdjustmentBuffer."Gen. Prod. Posting Group" <> '' THEN BEGIN
                IF GenProdPostGroupEDMS.Code <> InventoryAdjustmentBuffer."Gen. Prod. Posting Group" THEN
                    GenProdPostGroupEDMS.GET(InventoryAdjustmentBuffer."Gen. Prod. Posting Group");
                IF GenProdPostGroupEDMS."Split Value Entries" THEN
                    TempBufConditionEDMS."Gen. Prod. Posting Group" := InventoryAdjustmentBuffer."Gen. Prod. Posting Group";
            END;
        END;
    end;

    procedure PrepareBufOnCostElementEDMS(CostElementBuf: Record "5820")
    begin
        CLEAR(TempBufConditionEDMS);
        TempBufConditionEDMS.INIT;
        TempBufConditionEDMS."Inventory Posting Group" := CostElementBuf."Inventory Posting Group";
        TempBufConditionEDMS."Gen. Prod. Posting Group" := CostElementBuf."Gen. Prod. Posting Group";
    end;

    procedure ClearSplitEDMS()
    begin
        CLEAR(TempBufConditionEDMS);
        TempBufConditionEDMS.INIT;
    end;

    var
        ItemEDMS: Record "27";
        InvntPostGroupEDMS: Record "94";
        GenProdPostGroupEDMS: Record "251";
        TempBufConditionEDMS: Record "5820" temporary;
}


pageextension 50463 pageextension50463 extends "Sales Budget Overview"
{
    Editable = EnableInvPostingGroup;
    layout
    {
        modify(SalesCodeFilterCtrl)
        {
            Enabled = EnableCustPostingGroup;
        }

        //Unsupported feature: Code Modification on "Control 5.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF (UPPERCASE(LineDimCode) = UPPERCASE(ColumnDimCode)) AND (LineDimCode <> '') THEN BEGIN
          ColumnDimCode := '';
          ItemBudgetManagement.ValidateColumnDimCode(
        #4..7
          ItemBudgetName,LineDimCode,LineDimOption,ColumnDimOption,
          InternalDateFilter,DateFilter,ItemStatisticsBuffer,PeriodInitialized);
        LineDimCodeOnAfterValidate;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..10

        ShowOrHideFilter;
        */
        //end;
        addafter("Control 32")
        {
            field("Item Type Filter"; ItemTypeFilter)
            {
                Enabled = EnableInvPostingGroup;

                trigger OnValidate()
                begin
                    //ItemFilterOnAfterValidate;//chandra
                end;
            }
        }
        addafter(GlobalDim2Filter)
        {
            field("Customer Posting Group Filter"; CustomerPostingGroupFilter)
            {
                Caption = 'Customer Posting Group Filter';
                Enabled = EnableCustPostingGroup;

                trigger OnLookup(var Text: Text): Boolean
                var
                    CustomerPostingGroups: Page "110";
                begin
                    ///AGNI2017CU8 >>
                    CustomerPostingGroups.LOOKUPMODE := TRUE;
                    IF CustomerPostingGroups.RUNMODAL = ACTION::LookupOK THEN
                        Text := CustomerPostingGroups.GetSelectionFilter
                    ELSE
                        EXIT(FALSE);
                    EXIT(TRUE);
                    //AGNI2017CU8 <<
                end;

                trigger OnValidate()
                begin
                    CustomerPostGroupFilterOnAfterValidate;
                end;
            }
            field(InventoryPostingGroupFilter; InventoryPostingGroupFilter)
            {
                Caption = 'Inventory Posting Group Filter';
                Enabled = EnableInvPostingGroup;

                trigger OnLookup(var Text: Text): Boolean
                var
                    InventoryPostingGroups: Page "112";
                begin
                    ///AGNI2017CU8 >>
                    InventoryPostingGroups.LOOKUPMODE := TRUE;
                    IF InventoryPostingGroups.RUNMODAL = ACTION::LookupOK THEN
                        Text := InventoryPostingGroups.GetSelectionFilter
                    ELSE
                        EXIT(FALSE);
                    EXIT(TRUE);
                    //AGNI2017CU8 <<
                end;

                trigger OnValidate()
                begin
                    InvPostGroupFilterOnAfterValidate;
                end;
            }
        }
    }

    var
        ItemTypeFilter: Option " ",Item,"Model Version";
        CustomerPostingGroupFilter: Code[250];
        InventoryPostingGroupFilter: Code[250];
        EnableCustPostingGroup: Boolean;
        EnableInvPostingGroup: Boolean;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF ValueType = 0 THEN
      ValueType := ValueType::"Sales Amount";
    CurrentAnalysisArea := CurrentAnalysisArea::Sales;
    #4..23
    FindPeriod('');
    MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
    UpdateMatrixSubForm;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..26

    ShowOrHideFilter;
    */
    //end;

    //Unsupported feature: Variable Insertion (Variable: InventoryPostingGroups) (VariableCollection) on ""MATRIX_GenerateColumnCaptions"(PROCEDURE 1152)".



    //Unsupported feature: Code Modification on ""MATRIX_GenerateColumnCaptions"(PROCEDURE 1152)".

    //procedure "MATRIX_GenerateColumnCaptions"();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CLEAR(MATRIX_CaptionSet);
    CLEAR(MATRIX_MatrixRecords);
    FirstColumn := '';
    #4..43
          IF ItemFilter <> '' THEN BEGIN
            FieldRef := RecRef.FIELDINDEX(1);
            FieldRef.SETFILTER(ItemFilter);
          END;
          MatrixMgt.GenerateMatrixData(
            RecRef,MATRIX_SetWanted,12,1,
    #50..88
              RecRef,MATRIX_SetWanted::Same,12,2,
              MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
        END;
      GLSetup."Global Dimension 1 Code":
        MatrixMgt.GenerateDimColumnCaption(
          GLSetup."Global Dimension 1 Code",
    #95..114
          BudgetDim3Filter,MATRIX_SetWanted,MATRIX_PrimKeyFirstCaptionInCu,FirstColumn,LastColumn,
          MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,ShowColumnName,MATRIX_CaptionRange);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..46
            //FieldRef.SETFILTER(ItemTypeFilter);//
    #47..91
      InventoryPostingGroups.TABLECAPTION: //>>MIN 12/3/2019
        BEGIN
          CLEAR(MATRIX_CaptionSet);
          RecRef.GETTABLE(InventoryPostingGroups);
          RecRef.SETTABLE(InventoryPostingGroups);
          MatrixMgt.GenerateMatrixData(
            RecRef,MATRIX_SetWanted,12,1,
            MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
          FOR i := 1 TO MATRIX_CurrentNoOfColumns DO
            MATRIX_MatrixRecords[i].Code := MATRIX_CaptionSet[i];
          IF ShowColumnName THEN
            MatrixMgt.GenerateMatrixData(
              RecRef,MATRIX_SetWanted::Same,12,2,
              MATRIX_PrimKeyFirstCaptionInCu,MATRIX_CaptionSet,MATRIX_CaptionRange,MATRIX_CurrentNoOfColumns);
        END;
    #92..117
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateMatrixSubForm(PROCEDURE 7)".

    //procedure UpdateMatrixSubForm();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CurrPage.MATRIX.PAGE.SetFilters(
      DateFilter,ItemFilter,SourceNoFilter,
      GlobalDim1Filter,GlobalDim2Filter,
      BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter);
    CurrPage.MATRIX.PAGE.Load(
      MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,
      CurrentBudgetName,LineDimOption,ColumnDimOption,RoundingFactor,ValueType,PeriodType);
    CurrPage.UPDATE(FALSE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    {CurrPage.MATRIX.PAGE.SetFilters(
      DateFilter,ItemFilter,SourceNoFilter,
      GlobalDim1Filter,GlobalDim2Filter,
      BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter);}

    #1..3
      BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter,InventoryPostingGroupFilter,CustomerPostingGroupFilter);  //ratan 10/31/19

    #5..8
    */
    //end;

    local procedure CustomerPostGroupFilterOnAfterValidate()
    begin
        IF ColumnDimOption = ColumnDimOption::Customer THEN
            MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
        UpdateMatrixSubForm;
    end;

    local procedure InvPostGroupFilterOnAfterValidate()
    begin
        IF ColumnDimOption = ColumnDimOption::Item THEN
            MATRIX_GenerateColumnCaptions(MATRIX_Step::Initial);
        UpdateMatrixSubForm;
    end;

    local procedure ShowOrHideFilter()
    begin
        //>>ratan
        IF LineDimCode = 'Customer' THEN BEGIN
            EnableCustPostingGroup := TRUE;
            EnableInvPostingGroup := FALSE;
        END;
        IF LineDimCode = 'Item' THEN BEGIN
            EnableInvPostingGroup := TRUE;
            EnableCustPostingGroup := FALSE;
        END;
        //<<ratan
    end;
}


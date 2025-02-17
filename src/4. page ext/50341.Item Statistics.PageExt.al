pageextension 50341 pageextension50341 extends "Item Statistics"
{
    actions
    {

        //Unsupported feature: Code Modification on "ShowMatrix(Action 19).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CLEAR(MatrixForm);
        MatrixForm.Load(MATRIX_CaptionSet,MATRIX_MatrixRecords,MATRIX_CurrentNoOfColumns,
          RoundingFactor,PerUnit,IncludeExpected,ItemBuffer,Item,PeriodType,AmountType,
          ColumnDimCode,DateFilter,ItemFilter,LocationFilter,VariantFilter);
        MatrixForm.SETTABLEVIEW(Rec);
        MatrixForm.RUNMODAL;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..4

        MatrixForm.SETTABLEVIEW(Rec);
        MatrixForm.RUNMODAL;
        */
        //end;
    }

    var
        MATRIX_MatrixRecord: Record "367";

    var
        Qty: Decimal;
        GLSetupRead: Boolean;


    //Unsupported feature: Code Modification on "OnFindRecord".

    //trigger OnFindRecord()
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH ItemBuffer DO BEGIN
      IF "Line Option" = "Line Option"::"Profit Calculation" THEN
        IntegerLine.SETRANGE(Number,1,5)
      ELSE
        IF "Line Option" = "Line Option"::"Cost Specification" THEN
          IntegerLine.SETRANGE(Number,1,9);

      EXIT(FindRec("Line Option",Rec,Which));
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    WITH ItemBuffer DO BEGIN
      //10.11.2011 EDMS P8 >>

      //IF "Line Option" = "Line Option"::"Profit Calculation" THEN
      //  IntegerLine.SETRANGE(Number,1,5)
      //ELSE
      //  IF "Line Option" = "Line Option"::"Cost Specification" THEN
      //    IntegerLine.SETRANGE(Number,1,9);

      CASE "Line Option" OF
        "Line Option"::"Profit Calculation":
         IntegerLine.SETRANGE(Number,1,5);
        "Line Option"::"Cost Specification":
         IntegerLine.SETRANGE(Number,1,9);
        "Line Option"::"Sales Qty.":
         IntegerLine.SETRANGE(Number,1,1);
      END;
      //10.11.2011 EDMS P8 <<
    #7..9
    */
    //end;


    //Unsupported feature: Code Modification on "FindRec(PROCEDURE 59)".

    //procedure FindRec();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CASE DimOption OF
      DimOption::"Profit Calculation",
      DimOption::"Cost Specification":
    #4..38
          IF Found THEN
            CopyLocationToBuf(Location,DimCodeBuf);
        END;
    END;
    EXIT(Found);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..41
      //10.11.2011 EDMS P8 >>
      DimOption::"Sales Qty.":
        BEGIN
          IF EVALUATE(IntegerLine.Number,DimCodeBuf.Code) THEN;
          Found := IntegerLine.FIND(Which);
          IF Found THEN
            CopyDimValueToBuf(IntegerLine,DimCodeBuf);
        END;
      //10.11.2011 EDMS P8 <<
    END;
    EXIT(Found);
    */
    //end;


    //Unsupported feature: Code Modification on "CopyDimValueToBuf(PROCEDURE 9)".

    //procedure CopyDimValueToBuf();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH ItemBuffer DO
      CASE "Line Option" OF
        "Line Option"::"Profit Calculation":
    #4..33
            9:
              InsertRow('9',FIELDCAPTION("Inventory (LCY)"),0,TRUE,TheDimCodeBuf);
          END;
      END
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..36
        //10.11.2011 EDMS P8 >>
        "Line Option"::"Sales Qty.":
          CASE TheDimValue.Number OF
            1: InsertRow('1',FIELDCAPTION("Sales (Qty.)"),0,FALSE,TheDimCodeBuf);
          END;
        //10.11.2011 EDMS P8 >>

      END
    */
    //end;


    //Unsupported feature: Code Modification on "DateFilterOnAfterValidate(PROCEDURE 19006009)".

    //procedure DateFilterOnAfterValidate();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    MATRIX_GenerateColumnCaptions(MATRIX_SetWanted::Initial);
    CurrPage.UPDATE;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    MATRIX_GenerateColumnCaptions(MATRIX_SetWanted::Initial);
    PeriodTypeOnAfterValidate;  //10.11.2011 EDMS P8
    CurrPage.UPDATE;
    */
    //end;

    local procedure SetCommonFilters(var TheItemBuffer: Record "5821")
    begin
        TheItemBuffer.RESET;
        IF ItemFilter <> '' THEN
            TheItemBuffer.SETFILTER("Item Filter", ItemFilter);
        IF DateFilter <> '' THEN
            TheItemBuffer.SETFILTER("Date Filter", DateFilter);
        IF LocationFilter <> '' THEN
            TheItemBuffer.SETFILTER("Location Filter", LocationFilter);
        IF VariantFilter <> '' THEN
            TheItemBuffer.SETFILTER("Variant Filter", VariantFilter);
    end;

    local procedure SetFilters(var ItemBuffer: Record "5821"; LineOrColumn: Option Line,Column)
    var
        DimOption: Option "Profit Calculation","Cost Specification","Purch. Item Charge Spec.","Sales Item Charge Spec.",Period,Location,"Sales Qty.";
        DimCodeBuf: Record "367";
    begin
        IF LineOrColumn = LineOrColumn::Line THEN BEGIN
            DimCodeBuf := Rec;
            DimOption := ItemBuffer."Line Option";
        END ELSE BEGIN
            DimCodeBuf := MATRIX_MatrixRecord;
            DimOption := ItemBuffer."Column Option";
        END;

        CASE DimOption OF
            DimOption::Location:
                ItemBuffer.SETRANGE("Location Filter", DimCodeBuf.Code);
            DimOption::Period:
                IF AmountType = AmountType::"Net Change" THEN
                    ItemBuffer.SETRANGE("Date Filter", DimCodeBuf."Period Start", DimCodeBuf."Period End")
                ELSE
                    ItemBuffer.SETRANGE("Date Filter", 0D, DimCodeBuf."Period End");
            DimOption::"Profit Calculation",
  DimOption::"Cost Specification":
                CASE Rec.Name OF
                    ItemBuffer.FIELDCAPTION("Sales (LCY)"),
                    ItemBuffer.FIELDCAPTION("COGS (LCY)"),
                    ItemBuffer.FIELDCAPTION("Profit (LCY)"),
                    ItemBuffer.FIELDCAPTION("Sales (Qty.)"), //10.11.2011 EDMS P8
                    ItemBuffer.FIELDCAPTION("Profit %"):
                        BEGIN
                            ItemBuffer.SETRANGE("Item Ledger Entry Type Filter", ItemBuffer."Item Ledger Entry Type Filter"::Sale);
                            IF DimOption = DimOption::"Profit Calculation" THEN
                                ItemBuffer.SETFILTER("Entry Type Filter", '<>%1', ItemBuffer."Entry Type Filter"::Revaluation);
                            ItemBuffer.SETRANGE("Variance Type Filter", ItemBuffer."Variance Type Filter"::" ");
                        END;
                    ItemBuffer.FIELDCAPTION("Direct Cost (LCY)"),
                    ItemBuffer.FIELDCAPTION("Revaluation (LCY)"),
                    ItemBuffer.FIELDCAPTION("Rounding (LCY)"),
                    ItemBuffer.FIELDCAPTION("Indirect Cost (LCY)"),
                    ItemBuffer.FIELDCAPTION("Variance (LCY)"),
                    ItemBuffer.FIELDCAPTION("Inventoriable Costs, Total"):
                        BEGIN
                            ItemBuffer.SETFILTER(
                              "Item Ledger Entry Type Filter", '<>%1&<>%2',
                              ItemBuffer."Item Ledger Entry Type Filter"::Sale,
                              ItemBuffer."Item Ledger Entry Type Filter"::_);
                            ItemBuffer.SETRANGE("Variance Type Filter", ItemBuffer."Variance Type Filter"::" ");
                            CASE Rec.Name OF
                                ItemBuffer.FIELDCAPTION("Direct Cost (LCY)"):
                                    ItemBuffer.SETRANGE("Entry Type Filter", ItemBuffer."Entry Type Filter"::"Direct Cost");
                                ItemBuffer.FIELDCAPTION("Revaluation (LCY)"):
                                    ItemBuffer.SETRANGE("Entry Type Filter", ItemBuffer."Entry Type Filter"::Revaluation);
                                ItemBuffer.FIELDCAPTION("Rounding (LCY)"):
                                    ItemBuffer.SETRANGE("Entry Type Filter", ItemBuffer."Entry Type Filter"::Rounding);
                                ItemBuffer.FIELDCAPTION("Indirect Cost (LCY)"):
                                    ItemBuffer.SETRANGE("Entry Type Filter", ItemBuffer."Entry Type Filter"::"Indirect Cost");
                                ItemBuffer.FIELDCAPTION("Variance (LCY)"):
                                    BEGIN
                                        ItemBuffer.SETRANGE("Entry Type Filter", ItemBuffer."Entry Type Filter"::Variance);
                                        ItemBuffer.SETFILTER("Variance Type Filter", '<>%1', ItemBuffer."Variance Type Filter"::" ");
                                    END;
                                ItemBuffer.FIELDCAPTION("Inventoriable Costs, Total"):
                                    ItemBuffer.SETRANGE("Variance Type Filter");
                            END;
                        END;
                    ELSE
                        ItemBuffer.SETRANGE("Item Ledger Entry Type Filter");
                        ItemBuffer.SETRANGE("Variance Type Filter");
                END;
            DimOption::"Purch. Item Charge Spec.":
                BEGIN
                    ItemBuffer.SETRANGE("Variance Type Filter", ItemBuffer."Variance Type Filter"::" ");
                    ItemBuffer.SETRANGE("Item Ledger Entry Type Filter", ItemBuffer."Item Ledger Entry Type Filter"::Purchase);
                    ItemBuffer.SETRANGE("Item Charge No. Filter", DimCodeBuf.Code);
                END;
            DimOption::"Sales Item Charge Spec.":
                BEGIN
                    ItemBuffer.SETRANGE("Variance Type Filter", ItemBuffer."Variance Type Filter"::" ");
                    ItemBuffer.SETRANGE("Item Ledger Entry Type Filter", ItemBuffer."Item Ledger Entry Type Filter"::Sale);
                    ItemBuffer.SETRANGE("Item Charge No. Filter", DimCodeBuf.Code);
                END;
            //10.11.2011 EDMS P8 >>
            DimOption::"Sales Qty.":
                BEGIN
                    CASE Rec.Name OF
                        ItemBuffer.FIELDCAPTION("Sales (Qty.)"):
                            BEGIN
                                ItemBuffer.SETRANGE("Item Ledger Entry Type Filter", ItemBuffer."Item Ledger Entry Type Filter"::Sale);
                                IF DimOption = DimOption::"Sales Qty." THEN
                                    ItemBuffer.SETFILTER("Entry Type Filter", '<>%1', ItemBuffer."Entry Type Filter"::Revaluation);
                            END;
                    END;
                END;
        //10.11.2011 EDMS P8 <<
        END;
        IF ItemBuffer.GETFILTER("Item Ledger Entry Type Filter") = '' THEN
            ItemBuffer.SETFILTER(
              "Item Ledger Entry Type Filter", '<>%1',
              ItemBuffer."Item Ledger Entry Type Filter"::_)
    end;

    local procedure Calculate(SetColumnFilter: Boolean) Amount: Decimal
    begin
        GetGLSetup;

        CASE ItemBuffer."Line Option" OF
            ItemBuffer."Line Option"::"Profit Calculation",
  ItemBuffer."Line Option"::"Cost Specification":
                CASE Rec.Name OF
                    ItemBuffer.FIELDCAPTION("Sales (LCY)"):
                        Amount := CalcSalesAmount(SetColumnFilter);
                    ItemBuffer.FIELDCAPTION("COGS (LCY)"):
                        Amount := CalcCostAmount(SetColumnFilter);
                    ItemBuffer.FIELDCAPTION("Non-Invtbl. Costs (LCY)"):
                        Amount := CalcCostAmountNonInvnt(SetColumnFilter);
                    ItemBuffer.FIELDCAPTION("Profit (LCY)"):
                        Amount :=
                          CalcSalesAmount(SetColumnFilter) +
                          CalcCostAmount(SetColumnFilter) +
                          CalcCostAmountNonInvnt(SetColumnFilter);
                    ItemBuffer.FIELDCAPTION("Profit %"):
                        IF CalcSalesAmount(SetColumnFilter) <> 0 THEN
                            Amount :=
                              ROUND(
                                100 * (CalcSalesAmount(SetColumnFilter) +
                                       CalcCostAmount(SetColumnFilter) +
                                       CalcCostAmountNonInvnt(SetColumnFilter))
                                / CalcSalesAmount(SetColumnFilter))
                        ELSE
                            Amount := 0;
                    ItemBuffer.FIELDCAPTION("Direct Cost (LCY)"), ItemBuffer.FIELDCAPTION("Revaluation (LCY)"),
                  ItemBuffer.FIELDCAPTION("Rounding (LCY)"), ItemBuffer.FIELDCAPTION("Indirect Cost (LCY)"),
                  ItemBuffer.FIELDCAPTION("Variance (LCY)"), ItemBuffer.FIELDCAPTION("Inventory (LCY)"),
                  ItemBuffer.FIELDCAPTION("Inventoriable Costs, Total"):
                        Amount := CalcCostAmount(SetColumnFilter);
                    ELSE
                        Amount := 0;
                END;
            ItemBuffer."Line Option"::"Sales Item Charge Spec.":
                Amount := CalcSalesAmount(SetColumnFilter);
            ItemBuffer."Line Option"::"Purch. Item Charge Spec.":
                Amount := CalcCostAmount(SetColumnFilter);
            //10.11.2011 EDMS P8 >>
            ItemBuffer."Line Option"::"Sales Qty.":
                Amount := CalcQty(SetColumnFilter);
        //10.11.2011 EDMS P8 <<
        END;

        IF PerUnit THEN BEGIN
            IF (ItemBuffer."Line Option" = ItemBuffer."Line Option"::"Profit Calculation") AND
               (Rec.Name = ItemBuffer.FIELDCAPTION("Profit %"))
            THEN
                Qty := 1
            ELSE
                Qty := CalcQty(SetColumnFilter);

            IF Qty <> 0 THEN
                Amount :=
                  ROUND(Amount / ABS(Qty), GLSetup."Unit-Amount Rounding Precision")
            ELSE
                Amount := 0;
        END;
    end;

    local procedure CalcSalesAmount(SetColumnFilter: Boolean): Decimal
    begin
        SetCommonFilters(ItemBuffer);
        SetFilters(ItemBuffer, 0);
        IF SetColumnFilter THEN
            SetFilters(ItemBuffer, 1);

        IF IncludeExpected THEN BEGIN
            ItemBuffer.CALCFIELDS("Sales Amount (Actual)", "Sales Amount (Expected)");
            EXIT(ItemBuffer."Sales Amount (Actual)" + ItemBuffer."Sales Amount (Expected)");
        END;
        ItemBuffer.CALCFIELDS("Sales Amount (Actual)");
        EXIT(ItemBuffer."Sales Amount (Actual)");
    end;

    local procedure CalcCostAmount(SetColumnFilter: Boolean): Decimal
    begin
        SetCommonFilters(ItemBuffer);
        SetFilters(ItemBuffer, 0);
        IF SetColumnFilter THEN
            SetFilters(ItemBuffer, 1);

        IF IncludeExpected THEN BEGIN
            ItemBuffer.CALCFIELDS("Cost Amount (Actual)", "Cost Amount (Expected)");
            EXIT(ItemBuffer."Cost Amount (Actual)" + ItemBuffer."Cost Amount (Expected)");
        END;
        ItemBuffer.CALCFIELDS("Cost Amount (Actual)");
        EXIT(ItemBuffer."Cost Amount (Actual)");
    end;

    local procedure CalcCostAmountNonInvnt(SetColumnFilter: Boolean): Decimal
    begin
        SetCommonFilters(ItemBuffer);
        SetFilters(ItemBuffer, 0);
        IF SetColumnFilter THEN
            SetFilters(ItemBuffer, 1);

        ItemBuffer.SETRANGE("Item Ledger Entry Type Filter");
        ItemBuffer.CALCFIELDS("Cost Amount (Non-Invtbl.)");
        EXIT(ItemBuffer."Cost Amount (Non-Invtbl.)");
    end;

    local procedure CalcQty(SetColumnFilter: Boolean): Decimal
    begin
        SetCommonFilters(ItemBuffer);
        SetFilters(ItemBuffer, 0);
        IF SetColumnFilter THEN
            SetFilters(ItemBuffer, 1);

        ItemBuffer.SETRANGE("Entry Type Filter");
        ItemBuffer.SETRANGE("Item Charge No. Filter");

        IF IncludeExpected THEN BEGIN
            ItemBuffer.CALCFIELDS(Quantity);
            EXIT(ItemBuffer.Quantity);
        END;
        ItemBuffer.CALCFIELDS("Invoiced Quantity");
        EXIT(ItemBuffer."Invoiced Quantity");
    end;

    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
            GLSetup.GET;
        GLSetupRead := TRUE;
    end;

    //Unsupported feature: Property Modification (OptionString) on "FindRec(PROCEDURE 59).DimOption(Parameter 1000)".

}


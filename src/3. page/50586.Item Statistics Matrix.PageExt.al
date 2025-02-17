pageextension 50586 pageextension50586 extends "Item Statistics Matrix"
{

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
      EXIT(FindRec("Line Option",Rec,Which));
    END;
    */
    //end;


    //Unsupported feature: Code Modification on "FindRec(PROCEDURE 1112)".

    //procedure FindRec();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CASE DimOption OF
      DimOption::"Profit Calculation",
      DimOption::"Cost Specification":
    #4..42
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
    #1..45
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


    //Unsupported feature: Code Modification on "NextRec(PROCEDURE 1118)".

    //procedure NextRec();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CASE DimOption OF
      DimOption::"Profit Calculation",
      DimOption::"Cost Specification":
    #4..34
          IF ResultSteps <> 0 THEN
            CopyLocationToBuf(Location,DimCodeBuf);
        END;
    END;
    EXIT(ResultSteps);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..37
      //10.11.2011 EDMS P8 >>
      DimOption::"Sales Qty.":
        BEGIN
          IF EVALUATE(IntegerLine.Number,DimCodeBuf.Code) THEN;
          ResultSteps := IntegerLine.NEXT(Steps);
          IF ResultSteps <> 0 THEN
            CopyDimValueToBuf(IntegerLine,DimCodeBuf);
        END;
      //10.11.2011 EDMS P8 <<
    END;
    EXIT(ResultSteps);
    */
    //end;


    //Unsupported feature: Code Modification on "CopyDimValueToBuf(PROCEDURE 1124)".

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


    //Unsupported feature: Code Modification on "DrillDown(PROCEDURE 1139)".

    //procedure DrillDown();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH ItemBuffer DO BEGIN
      ValueEntry.SETCURRENTKEY(
        "Item No.","Posting Date","Item Ledger Entry Type","Entry Type","Variance Type",
    #4..23
        (("Line Option" = "Line Option"::"Profit Calculation") AND (Name = FIELDCAPTION("Sales (LCY)"))) OR
        ("Line Option" = "Line Option"::"Sales Item Charge Spec."):
          PAGE.RUN(0,ValueEntry,ValueEntry."Sales Amount (Actual)");
        Name = FIELDCAPTION("Non-Invtbl. Costs (LCY)"):
          PAGE.RUN(0,ValueEntry,ValueEntry."Cost Amount (Non-Invtbl.)");
        ELSE
          PAGE.RUN(0,ValueEntry,ValueEntry."Cost Amount (Actual)");
      END;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..26
        //10.11.2011 EDMS P8 >>
        ("Line Option" = "Line Option"::"Sales Qty.") AND (Name = FIELDCAPTION("Sales (Qty.)")):
          PAGE.RUN(0,ValueEntry,ValueEntry."Invoiced Quantity");
        //10.11.2011 EDMS P8 <<
    #27..32
    */
    //end;


    //Unsupported feature: Code Modification on "SetFilters(PROCEDURE 1142)".

    //procedure SetFilters();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF LineOrColumn = LineOrColumn::Line THEN BEGIN
      DimCodeBuf := Rec;
      DimOption := ItemBuffer."Line Option";
    #4..19
            FIELDCAPTION("Sales (LCY)"),
            FIELDCAPTION("COGS (LCY)"),
            FIELDCAPTION("Profit (LCY)"),
            FIELDCAPTION("Profit %"):
              BEGIN
                SETRANGE("Item Ledger Entry Type Filter","Item Ledger Entry Type Filter"::Sale);
    #26..36
                SETFILTER(
                  "Item Ledger Entry Type Filter",'<>%1&<>%2',
                  "Item Ledger Entry Type Filter"::Sale,
                  "Item Ledger Entry Type Filter"::" ");
                SETRANGE("Variance Type Filter","Variance Type Filter"::" ");
                CASE Name OF
                  FIELDCAPTION("Direct Cost (LCY)"):
    #44..72
            SETRANGE("Item Ledger Entry Type Filter","Item Ledger Entry Type Filter"::Sale);
            SETRANGE("Item Charge No. Filter",DimCodeBuf.Code);
          END;
      END;
      IF GETFILTER("Item Ledger Entry Type Filter") = '' THEN
        SETFILTER(
          "Item Ledger Entry Type Filter",'<>%1',
          "Item Ledger Entry Type Filter"::" ")
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..22
            FIELDCAPTION("Sales (Qty.)"), //10.11.2011 EDMS P8
    #23..39
                  "Item Ledger Entry Type Filter"::_);
    #41..75
        //10.11.2011 EDMS P8 >>
        DimOption::"Sales Qty.":
          BEGIN
           CASE Name OF
            FIELDCAPTION("Sales (Qty.)"):
              BEGIN
                SETRANGE("Item Ledger Entry Type Filter","Item Ledger Entry Type Filter"::Sale);
                IF DimOption = DimOption::"Sales Qty." THEN
                  SETFILTER("Entry Type Filter",'<>%1',"Entry Type Filter"::Revaluation);
              END;
           END;
          END;
        //10.11.2011 EDMS P8 <<
    #76..79
          "Item Ledger Entry Type Filter"::_)
    END;
    */
    //end;


    //Unsupported feature: Code Modification on "Calculate(PROCEDURE 1147)".

    //procedure Calculate();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    WITH ItemBuffer DO BEGIN
      CASE "Line Option" OF
        "Line Option"::"Profit Calculation",
    #4..32
          Amount := CalcSalesAmount(SetColumnFilter);
        "Line Option"::"Purch. Item Charge Spec.":
          Amount := CalcCostAmount(SetColumnFilter);
      END;
      IF PerUnit THEN BEGIN
        IF ("Line Option" = "Line Option"::"Profit Calculation") AND
    #39..48
      IF Name <> FIELDCAPTION("Profit %") THEN
        Amount := MatrixMgt.RoundValue(Amount,RoundingFactor);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..35
        //10.11.2011 EDMS P8 >>
        "Line Option"::"Sales Qty.":
          Amount := CalcQty(SetColumnFilter);
        //10.11.2011 EDMS P8 <<
    #36..51
    */
    //end;

    //Unsupported feature: Property Modification (OptionString) on "FindRec(PROCEDURE 1112).DimOption(Parameter 1000)".


    //Unsupported feature: Property Modification (OptionString) on "NextRec(PROCEDURE 1118).DimOption(Parameter 1000)".


    //Unsupported feature: Property Modification (OptionString) on "SetFilters(PROCEDURE 1142).DimOption(Variable 1143)".

}


pageextension 50589 pageextension50589 extends "Sales Budget Overview Matrix"
{
    layout
    {

        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 20".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 22".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Quantity(Control 26)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Amount(Control 24)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Field1(Control 1012)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Field2(Control 1013)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Field3(Control 1014)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Field4(Control 1015)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Field5(Control 1016)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Field6(Control 1017)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Field7(Control 1018)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Field8(Control 1019)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Field9(Control 1020)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Field10(Control 1021)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Field11(Control 1022)".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Field12(Control 1023)".

    }
    var
        InventoryPostingGroupFilter: Text;
        CustomerPostingGroupFilter: Text;


    //Unsupported feature: Code Modification on "OnFindRecord".

    //trigger OnFindRecord()
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    EXIT(
      ItemBudgetManagement.FindRec(
        ItemBudgetName,LineDimOption,Rec,Which,
        ItemFilter,SourceNoFilter,PeriodType,DateFilter,PeriodInitialized,InternalDateFilter,
        GlobalDim1Filter,GlobalDim2Filter,BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter));
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4
        GlobalDim1Filter,GlobalDim2Filter,BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter,InventoryPostingGroupFilter,CustomerPostingGroupFilter)); //ratan 10/31/19
    */
    //end;


    //Unsupported feature: Code Modification on "OnNextRecord".

    //trigger OnNextRecord()
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    EXIT(
      ItemBudgetManagement.NextRec(
        ItemBudgetName,LineDimOption,Rec,Steps,
        ItemFilter,SourceNoFilter,PeriodType,DateFilter,
        GlobalDim1Filter,GlobalDim2Filter,BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter));
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4
        GlobalDim1Filter,GlobalDim2Filter,BudgetDim1Filter,BudgetDim2Filter,BudgetDim3Filter,InventoryPostingGroupFilter,CustomerPostingGroupFilter)); //ratan 10/31/19
    */
    //end;

    //Unsupported feature: Parameter Insertion (Parameter: _InventoryPostingGroupFilter) (ParameterCollection) on "SetFilters(PROCEDURE 1102601000)".


    //Unsupported feature: Parameter Insertion (Parameter: _CustomerPostingGroupFilter) (ParameterCollection) on "SetFilters(PROCEDURE 1102601000)".



    //Unsupported feature: Code Modification on "SetFilters(PROCEDURE 1102601000)".

    //procedure SetFilters();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    DateFilter := _DateFilter;
    ItemFilter := _ItemFilter;
    SourceNoFilter := _SourceNoFilter;
    GlobalDim1Filter := _GlobalDim1Filter;
    GlobalDim2Filter := _GlobalDim2Filter;
    BudgetDim1Filter := _BudgetDim1Filter;
    BudgetDim2Filter := _BudgetDim2Filter;
    BudgetDim3Filter := _BudgetDim3Filter;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8
    InventoryPostingGroupFilter := _InventoryPostingGroupFilter;   //ratan 10/31/19
    CustomerPostingGroupFilter := _CustomerPostingGroupFilter;
    */
    //end;
}


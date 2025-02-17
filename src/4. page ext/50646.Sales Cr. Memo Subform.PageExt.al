pageextension 50646 pageextension50646 extends "Sales Cr. Memo Subform"
{
    // 23.04.2014 Elva Baltic P8 #X01 MMG7.00
    //   * Added:
    //     "Vehicle Serial No."
    //     "Vehicle Accounting Cycle No."
    //     VIN
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".

        modify("Total VAT Amount")
        {

            //Unsupported feature: Property Modification (Level) on ""Total VAT Amount"(Control 13)".


            //Unsupported feature: Property Modification (SourceExpr) on ""Total VAT Amount"(Control 13)".

            Visible = false;
        }
        modify("Total Amount Incl. VAT")
        {

            //Unsupported feature: Property Modification (Level) on ""Total Amount Incl. VAT"(Control 11)".


            //Unsupported feature: Property Modification (SourceExpr) on ""Total Amount Incl. VAT"(Control 11)".

            Visible = false;
        }
        modify(RefreshTotals)
        {

            //Unsupported feature: Property Modification (Level) on "RefreshTotals(Control 9)".


            //Unsupported feature: Property Modification (SourceExpr) on "RefreshTotals(Control 9)".

            Editable = IsEditable;
            Visible = false;
        }

        //Unsupported feature: Property Deletion (Name) on ""Total VAT Amount"(Control 13)".


        //Unsupported feature: Property Deletion (CaptionML) on ""Total VAT Amount"(Control 13)".


        //Unsupported feature: Property Deletion (ToolTipML) on ""Total VAT Amount"(Control 13)".


        //Unsupported feature: Property Deletion (ApplicationArea) on ""Total VAT Amount"(Control 13)".


        //Unsupported feature: Property Deletion (AutoFormatType) on ""Total VAT Amount"(Control 13)".


        //Unsupported feature: Property Deletion (AutoFormatExpr) on ""Total VAT Amount"(Control 13)".


        //Unsupported feature: Property Deletion (CaptionClass) on ""Total VAT Amount"(Control 13)".


        //Unsupported feature: Property Deletion (Editable) on ""Total VAT Amount"(Control 13)".


        //Unsupported feature: Property Deletion (Style) on ""Total VAT Amount"(Control 13)".


        //Unsupported feature: Property Deletion (StyleExpr) on ""Total VAT Amount"(Control 13)".


        //Unsupported feature: Property Deletion (Name) on ""Total Amount Incl. VAT"(Control 11)".


        //Unsupported feature: Property Deletion (CaptionML) on ""Total Amount Incl. VAT"(Control 11)".


        //Unsupported feature: Property Deletion (ToolTipML) on ""Total Amount Incl. VAT"(Control 11)".


        //Unsupported feature: Property Deletion (ApplicationArea) on ""Total Amount Incl. VAT"(Control 11)".


        //Unsupported feature: Property Deletion (AutoFormatType) on ""Total Amount Incl. VAT"(Control 11)".


        //Unsupported feature: Property Deletion (AutoFormatExpr) on ""Total Amount Incl. VAT"(Control 11)".


        //Unsupported feature: Property Deletion (CaptionClass) on ""Total Amount Incl. VAT"(Control 11)".


        //Unsupported feature: Property Deletion (Editable) on ""Total Amount Incl. VAT"(Control 11)".


        //Unsupported feature: Property Deletion (StyleExpr) on ""Total Amount Incl. VAT"(Control 11)".

        modify(RefreshTotals)
        {
            Visible = false;
        }

        //Unsupported feature: Property Deletion (Name) on "RefreshTotals(Control 9)".


        //Unsupported feature: Property Deletion (DrillDown) on "RefreshTotals(Control 9)".


        //Unsupported feature: Property Deletion (Enabled) on "RefreshTotals(Control 9)".


        //Unsupported feature: Property Deletion (ShowCaption) on "RefreshTotals(Control 9)".

        addafter("Control 4")
        {
            field("HS Code"; "HS Code")
            {
                Editable = false;
                Visible = false;
            }
        }
        addafter("Total Amount Excl. VAT")
        {
            field("Total VAT Amount"; VATAmount)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatExpression = TotalSalesHeader."Currency Code";
                AutoFormatType = 1;
                CaptionClass = DocumentTotals.GetTotalVATCaption(SalesHeader."Currency Code");
                Caption = 'Total VAT';
                Editable = false;
                Style = Subordinate;
                StyleExpr = RefreshMessageEnabled;
                ToolTip = 'Specifies the sum of VAT amounts on all lines in the document.';
            }
            field("Total Amount Incl. VAT"; TotalSalesLine."Amount Including VAT")
            {
                ApplicationArea = Basic, Suite;
                AutoFormatExpression = TotalSalesHeader."Currency Code";
                AutoFormatType = 1;
                CaptionClass = DocumentTotals.GetTotalInclVATCaption(SalesHeader."Currency Code");
                Caption = 'Total Amount Incl. VAT';
                Editable = false;
                StyleExpr = TotalAmountStyle;
                ToolTip = 'Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
            }
            field(RefreshTotals; RefreshMessageText)
            {
                DrillDown = true;
                Editable = false;
                Enabled = RefreshMessageEnabled;
                ShowCaption = false;

                trigger OnDrillDown()
                begin
                    DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
                    DocumentTotals.SalesUpdateTotalsControls(Rec, TotalSalesHeader, TotalSalesLine, RefreshMessageEnabled,
                      TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, CurrPage.EDITABLE, VATAmount);
                end;
            }
        }
        moveafter("Control 310"; "Total VAT Amount")
    }

    var
        SystemMgt: Codeunit "50000";
        [InDataSet]
        IsEditable: Boolean;


    //Unsupported feature: Code Modification on "OnAfterGetCurrRecord".

    //trigger OnAfterGetCurrRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    UpdateEditableOnRow;

    IF SalesHeader.GET("Document Type","Document No.") THEN;

    DocumentTotals.SalesUpdateTotalsControls(Rec,TotalSalesHeader,TotalSalesLine,RefreshMessageEnabled,
      TotalAmountStyle,RefreshMessageText,InvDiscAmountEditable,CurrPage.EDITABLE,VATAmount);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6

    IsEditable := SystemMgt.CheckReturnAmtQtyEditable;
    */
    //end;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ShowShortcutDimCode(ShortcutDimCode);
    CLEAR(DocumentTotals);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ShowShortcutDimCode(ShortcutDimCode);
    CLEAR(DocumentTotals);

    IsEditable := SystemMgt.CheckReturnAmtQtyEditable;
    */
    //end;
}


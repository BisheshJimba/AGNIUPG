pageextension 50652 pageextension50652 extends "Purch. Cr. Memo Subform"
{
    // 22.04.2014 Elva Baltic P8 #X01 MMG7.00
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


        //Unsupported feature: Property Modification (Level) on ""Total VAT Amount"(Control 19)".


        //Unsupported feature: Property Modification (SourceExpr) on ""Total VAT Amount"(Control 19)".

        modify("Total Amount Incl. VAT")
        {

            //Unsupported feature: Property Modification (Level) on ""Total Amount Incl. VAT"(Control 17)".


            //Unsupported feature: Property Modification (SourceExpr) on ""Total Amount Incl. VAT"(Control 17)".

            Visible = false;
        }
        modify(RefreshTotals)
        {

            //Unsupported feature: Property Modification (Level) on "RefreshTotals(Control 15)".


            //Unsupported feature: Property Modification (SourceExpr) on "RefreshTotals(Control 15)".

            Visible = false;
        }

        //Unsupported feature: Property Deletion (Name) on ""Total VAT Amount"(Control 19)".


        //Unsupported feature: Property Deletion (CaptionML) on ""Total VAT Amount"(Control 19)".


        //Unsupported feature: Property Deletion (ToolTipML) on ""Total VAT Amount"(Control 19)".


        //Unsupported feature: Property Deletion (ApplicationArea) on ""Total VAT Amount"(Control 19)".


        //Unsupported feature: Property Deletion (AutoFormatType) on ""Total VAT Amount"(Control 19)".


        //Unsupported feature: Property Deletion (AutoFormatExpr) on ""Total VAT Amount"(Control 19)".


        //Unsupported feature: Property Deletion (CaptionClass) on ""Total VAT Amount"(Control 19)".


        //Unsupported feature: Property Deletion (Editable) on ""Total VAT Amount"(Control 19)".


        //Unsupported feature: Property Deletion (Style) on ""Total VAT Amount"(Control 19)".


        //Unsupported feature: Property Deletion (StyleExpr) on ""Total VAT Amount"(Control 19)".


        //Unsupported feature: Property Deletion (Name) on ""Total Amount Incl. VAT"(Control 17)".


        //Unsupported feature: Property Deletion (CaptionML) on ""Total Amount Incl. VAT"(Control 17)".


        //Unsupported feature: Property Deletion (ToolTipML) on ""Total Amount Incl. VAT"(Control 17)".


        //Unsupported feature: Property Deletion (ApplicationArea) on ""Total Amount Incl. VAT"(Control 17)".


        //Unsupported feature: Property Deletion (AutoFormatType) on ""Total Amount Incl. VAT"(Control 17)".


        //Unsupported feature: Property Deletion (AutoFormatExpr) on ""Total Amount Incl. VAT"(Control 17)".


        //Unsupported feature: Property Deletion (CaptionClass) on ""Total Amount Incl. VAT"(Control 17)".


        //Unsupported feature: Property Deletion (Editable) on ""Total Amount Incl. VAT"(Control 17)".


        //Unsupported feature: Property Deletion (StyleExpr) on ""Total Amount Incl. VAT"(Control 17)".

        modify(RefreshTotals)
        {
            Visible = false;
        }

        //Unsupported feature: Property Deletion (Name) on "RefreshTotals(Control 15)".


        //Unsupported feature: Property Deletion (DrillDown) on "RefreshTotals(Control 15)".


        //Unsupported feature: Property Deletion (Enabled) on "RefreshTotals(Control 15)".


        //Unsupported feature: Property Deletion (Editable) on "RefreshTotals(Control 15)".


        //Unsupported feature: Property Deletion (ShowCaption) on "RefreshTotals(Control 15)".

        addafter("Control 74")
        {
            field("Use Tax"; Rec."Use Tax")
            {
            }
        }
        addafter("Control 310")
        {
            field("External Serv. Tracking No."; "External Serv. Tracking No.")
            {
                Visible = false;
            }
            field(VIN; VIN)
            {
                Visible = false;
            }
            field("Vehicle Serial No."; "Vehicle Serial No.")
            {
                Visible = false;
            }
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                Visible = false;
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                Visible = false;
            }
            field("Document Class"; "Document Class")
            {
            }
            field("Document Subclass"; "Document Subclass")
            {
            }
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                Visible = false;
            }
            field("TDS Group"; "TDS Group")
            {
            }
            field("TDS%"; "TDS%")
            {
            }
            field("TDS Type"; "TDS Type")
            {
            }
            field("TDS Amount"; "TDS Amount")
            {
            }
        }
        addafter("Control 310")
        {
            field("TDS Base Amount"; "TDS Base Amount")
            {
            }
        }
        addafter("Control 310")
        {
            field("Tax Purchase Type"; "Tax Purchase Type")
            {
            }
        }
        addafter("Total Amount Excl. VAT")
        {
            field("Total VAT Amount"; VATAmount)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatExpression = TotalPurchaseHeader."Currency Code";
                AutoFormatType = 1;
                CaptionClass = DocumentTotals.GetTotalVATCaption(PurchHeader."Currency Code");
                Caption = 'Total VAT';
                Editable = false;
                Style = Subordinate;
                StyleExpr = RefreshMessageEnabled;
                ToolTip = 'Specifies the sum of VAT amounts on all lines in the document.';
            }
            field("Total Amount Incl. VAT"; TotalPurchaseLine."Amount Including VAT")
            {
                ApplicationArea = Basic, Suite;
                AutoFormatExpression = TotalPurchaseHeader."Currency Code";
                AutoFormatType = 1;
                CaptionClass = DocumentTotals.GetTotalInclVATCaption(PurchHeader."Currency Code");
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
                    DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalPurchaseLine);
                    DocumentTotals.PurchaseUpdateTotalsControls(Rec, TotalPurchaseHeader, TotalPurchaseLine, RefreshMessageEnabled,
                      TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, VATAmount);
                end;
            }
        }
        moveafter("Control 310"; "Total Amount Incl. VAT")
        moveafter("Control 17"; "Total VAT Amount")
        moveafter("Control 19"; RefreshTotals)
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

    IF PurchHeader.GET("Document Type","Document No.") THEN;

    DocumentTotals.PurchaseUpdateTotalsControls(Rec,TotalPurchaseHeader,TotalPurchaseLine,RefreshMessageEnabled,
      TotalAmountStyle,RefreshMessageText,InvDiscAmountEditable,VATAmount);
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


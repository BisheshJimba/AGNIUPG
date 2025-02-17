pageextension 50280 pageextension50280 extends "Purch. Invoice Subform"
{
    // 14.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added fields:
    //     - "Vehicle Serial No."
    //     - "Vehicle Accounting Cycle No."
    //     - "VIN"
    Caption = ' Reason Code';
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

            //Unsupported feature: Property Modification (Level) on ""Total VAT Amount"(Control 11)".


            //Unsupported feature: Property Modification (SourceExpr) on ""Total VAT Amount"(Control 11)".

            Visible = false;
        }
        modify("Total Amount Incl. VAT")
        {

            //Unsupported feature: Property Modification (Level) on ""Total Amount Incl. VAT"(Control 9)".


            //Unsupported feature: Property Modification (SourceExpr) on ""Total Amount Incl. VAT"(Control 9)".

            Visible = false;
        }

        //Unsupported feature: Property Deletion (Name) on ""Total VAT Amount"(Control 11)".


        //Unsupported feature: Property Deletion (CaptionML) on ""Total VAT Amount"(Control 11)".


        //Unsupported feature: Property Deletion (ToolTipML) on ""Total VAT Amount"(Control 11)".


        //Unsupported feature: Property Deletion (ApplicationArea) on ""Total VAT Amount"(Control 11)".


        //Unsupported feature: Property Deletion (AutoFormatType) on ""Total VAT Amount"(Control 11)".


        //Unsupported feature: Property Deletion (AutoFormatExpr) on ""Total VAT Amount"(Control 11)".


        //Unsupported feature: Property Deletion (CaptionClass) on ""Total VAT Amount"(Control 11)".


        //Unsupported feature: Property Deletion (Editable) on ""Total VAT Amount"(Control 11)".


        //Unsupported feature: Property Deletion (Name) on ""Total Amount Incl. VAT"(Control 9)".


        //Unsupported feature: Property Deletion (CaptionML) on ""Total Amount Incl. VAT"(Control 9)".


        //Unsupported feature: Property Deletion (ToolTipML) on ""Total Amount Incl. VAT"(Control 9)".


        //Unsupported feature: Property Deletion (ApplicationArea) on ""Total Amount Incl. VAT"(Control 9)".


        //Unsupported feature: Property Deletion (AutoFormatType) on ""Total Amount Incl. VAT"(Control 9)".


        //Unsupported feature: Property Deletion (AutoFormatExpr) on ""Total Amount Incl. VAT"(Control 9)".


        //Unsupported feature: Property Deletion (CaptionClass) on ""Total Amount Incl. VAT"(Control 9)".


        //Unsupported feature: Property Deletion (Editable) on ""Total Amount Incl. VAT"(Control 9)".

        addafter("Control 4")
        {
            field("Account Name"; "Account Name")
            {
            }
        }
        addafter("Control 14")
        {
            field("External Serv. Tracking No."; "External Serv. Tracking No.")
            {
                Visible = false;
            }
        }
        addafter("Control 8")
        {
            field(ABC; ABC)
            {
            }
        }
        addafter("Control 102")
        {
            field("PI/ARE Code"; "PI/ARE Code")
            {
            }
        }
        addafter("Control 40")
        {
            field("Unit Cost"; Rec."Unit Cost")
            {
            }
        }
        addafter("Control 23")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
            }
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
            }
            field(VIN; VIN)
            {
                Visible = false;
            }
            field("VIN - COGS"; "VIN - COGS")
            {
                Visible = false;
            }
            label()
            {
                Visible = false;
            }
            label()
            {
                Visible = false;
            }
            label()
            {
                Visible = false;
            }
            field("Document Class"; "Document Class")
            {
            }
            field("Document Subclass"; "Document Subclass")
            {
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
            field("TDS Base Amount"; "TDS Base Amount")
            {
            }
            field("Tax Purchase Type"; "Tax Purchase Type")
            {
            }
            field("Cost Type"; "Cost Type")
            {
            }
        }
        addafter("Total Amount Excl. VAT")
        {
            field("Total VAT Amount"; VATAmount)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatExpression = Currency.Code;
                AutoFormatType = 1;
                CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
                Caption = 'Total VAT';
                Editable = false;
                ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
            }
            field("Total Amount Incl. VAT"; TotalPurchaseLine."Amount Including VAT")
            {
                ApplicationArea = Basic, Suite;
                AutoFormatExpression = TotalPurchaseHeader."Currency Code";
                AutoFormatType = 1;
                CaptionClass = DocumentTotals.GetTotalInclVATCaption(Currency.Code);
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
                    DocumentTotals.PurchaseUpdateTotalsControls(
                      Rec, TotalPurchaseHeader, TotalPurchaseLine, RefreshMessageEnabled,
                      TotalAmountStyle, RefreshMessageText, InvDiscAmountEditable, VATAmount);
                end;
            }
        }
        moveafter("Control 17"; "Total Amount Incl. VAT")
        moveafter("Control 9"; "Total VAT Amount")
    }

    var
        TotalAmountStyle: Text;
        RefreshMessageText: Text;
        RefreshMessageEnabled: Boolean;
}


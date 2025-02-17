pageextension 50432 pageextension50432 extends "Sales Return Order Subform"
{
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = IsEditable;
    Editable = ISVisible;
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

        addafter("Control 72")
        {
            field(ABC; ABC)
            {
            }
        }
        addafter("Control 54")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
            }
        }
        addafter("Control 32")
        {
            field("External Serv. Tracking No."; "External Serv. Tracking No.")
            {
            }
        }
    }

    var
        ISVisible: Boolean;
        UserSetup: Record "91";
        SystemMgt: Codeunit "50000";
        [InDataSet]
        IsEditable: Boolean;


    //Unsupported feature: Code Modification on "OnAfterGetCurrRecord".

    //trigger OnAfterGetCurrRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF SalesHeader.GET("Document Type","Document No.") THEN;

    DocumentTotals.SalesUpdateTotalsControls(Rec,TotalSalesHeader,TotalSalesLine,RefreshMessageEnabled,
      TotalAmountStyle,RefreshMessageText,InvDiscAmountEditable,CurrPage.EDITABLE,VATAmount);

    TypeChosen := HasTypeToFillMandatotyFields;
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
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ShowShortcutDimCode(ShortcutDimCode);

    IsEditable := SystemMgt.CheckReturnAmtQtyEditable;
    */
    //end;


    //Unsupported feature: Code Insertion on "OnInit".

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //begin
    /*
    //AGNI2017CU8 >>
    UserSetup.GET(USERID);
    IF UserSetup."Can See Cost" THEN
      ISVisible :=TRUE
    ELSE
      ISVisible := FALSE;
    //AGNI2017CU8 <<
    */
    //end;
}


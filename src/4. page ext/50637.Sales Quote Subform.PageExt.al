pageextension 50637 pageextension50637 extends "Sales Quote Subform"
{
    // 08.06.2016 EB.P7 #PAR28
    //   Added action "Apply Replacement"
    //   Added field "Has Replacement"
    //   Modified Trigger OnAfterGetRecord
    Editable = ItemNoAttention;
    Editable = TypeChosen;
    Editable = IsEditable;
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".



        //Unsupported feature: Code Insertion on "Control 4".

        //trigger OnAssistEdit()
        //begin
        /*
        NoAssistEdit //EDMS
        */
        //end;


        //Unsupported feature: Code Modification on "Control 4.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ShowShortcutDimCode(ShortcutDimCode);
        NoOnAfterValidate;

        IF xRec."No." <> '' THEN
          RedistributeTotalsOnAfterValidate;

        UpdateEditableOnRow;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..5
                                    UpdateEditableOnRow;
        IF COMPANYNAME = 'JOHN DEWEY H.S. SCHOOL' THEN BEGIN //Min 4.22.2020
          IF Type = Type::"G/L Account" THEN BEGIN
            SalesHeader.RESET;
            SalesHeader.SETRANGE("No.","Document No.");
            IF SalesHeader.FINDFIRST THEN BEGIN
              SalesQuoteLines.RESET;
              SalesQuoteLines.SETRANGE("Customer No.",SalesHeader."Sell-to Customer No.");
              SalesQuoteLines.SETRANGE("Component No.","No.");
              IF NOT SalesQuoteLines.FINDFIRST THEN
                ERROR(Text001);
              END;
           END;
        END;
        */
        //end;


        //Unsupported feature: Code Modification on "Control 8.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        QuantityOnAfterValidate;
        RedistributeTotalsOnAfterValidate;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        QuantityOnAfterValidate;
        RedistributeTotalsOnAfterValidate;
        CurrPage.UPDATE;
        */
        //end;
        addafter("Control 4")
        {
            field("Has Replacement"; "Has Replacement")
            {
                Editable = false;
            }
        }
        addafter("Control 48")
        {
            field(Inventory; Inventory)
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
        addafter("Control 6")
        {
            field("Forward Location Code"; "Forward Location Code")
            {
            }
            field("Forward Accountability Center"; "Forward Accountability Center")
            {
                Editable = false;
            }
        }
        addafter("Control 10")
        {
            field(ABC; ABC)
            {
            }
        }
        addafter("Control 18")
        {
            field("Ordering Price Type Code"; "Ordering Price Type Code")
            {
                Visible = false;
            }
        }
        addafter("Control 50")
        {
            field("Bin Code"; Rec."Bin Code")
            {
            }
        }
        addafter("Control 22")
        {
            field("Quote Forwarded"; "Quote Forwarded")
            {
            }
        }
        addafter("Control 310")
        {
            field(CBM; CBM)
            {
                Editable = false;
            }
        }
        moveafter("Control 6"; "Control 8")
    }
    actions
    {

        //Unsupported feature: Property Insertion (Image) on "Action 3".


        //Unsupported feature: Property Insertion (Image) on "Action 9".


        //Unsupported feature: Property Insertion (Image) on "Action 7".

        addafter("Action 19")
        {
            action("<Action1101904000>")
            {
                Caption = 'Register Lost Sale';
                Image = Register;

                trigger OnAction()
                begin
                    RegLostSales
                end;
            }
            action("Apply Replacement")
            {
                Caption = 'Apply Replacement';
                Image = ItemSubstitution;

                trigger OnAction()
                var
                    ItemSubstSync: Codeunit "25006513";
                begin
                    //08.06.2016 EB.P7 #PAR28 >>
                    ItemSubstSync.ReplaceSalesLineItemNo(Rec);
                    //08.06.2016 EB.P7 #PAR28 <<
                    CurrPage.UPDATE;
                end;
            }
        }
    }

    var
        [InDataSet]
        ItemPanelVisible: Boolean;
        LostSalesMgt: Codeunit "25006504";
        TotalAmountStyle: Text;
        RefreshMessageEnabled: Boolean;
        RefreshMessageText: Text;
        TypeChosen: Boolean;
        ItemNoAttention: Text[20];
        SalesQuoteLines: Record "33020184";
        Text001: Label 'You cannot directly insert Student Fee Component.';
        UserSetup: Record "91";
        IsEditable: Boolean;


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
    CLEAR(DocumentTotals);

    //08.06.2016 EB.P7 #PAR28 >>
    CheckHasReplacement;
    //08.06.2016 EB.P7 #PAR28 <<
    */
    //end;


    //Unsupported feature: Code Modification on "OnDeleteRecord".

    //trigger OnDeleteRecord(): Boolean
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
      COMMIT;
      IF NOT ReserveSalesLine.DeleteLineConfirm(Rec) THEN
        EXIT(FALSE);
      ReserveSalesLine.DeleteLine(Rec);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..6
    LostSalesMgt.OnSalesLineDelete(Rec); //EDMS
    */
    //end;


    //Unsupported feature: Code Insertion on "OnOpenPage".

    //trigger OnOpenPage()
    //begin
    /*
    UserSetup.GET(USERID);
    IF UserSetup."Can Edit Item Description" THEN
      IsEditable := TRUE
    ELSE
      IsEditable := FALSE;
    */
    //end;

    local procedure CheckHasReplacement()
    begin
        IF "Has Replacement" THEN
            ItemNoAttention := 'Attention'
        ELSE
            ItemNoAttention := '';
    end;
}


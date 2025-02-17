pageextension 50180 pageextension50180 extends "Sales Order Subform"
{
    // 05.07.2016 EB.P7 #PAR28
    //   "No." OnLookup() added code from Sales Line
    //   "No." OnValidate added update code
    // 
    // 11.05.2016 EB.P7 #PAR28
    //   Modified OnAfterGetRecord trigger.
    // 
    // 12.05.2014 Elva Baltic P21 #S0104 MMG7.00
    //   Modified trigger: OnAfterGetRecord() GetReservationColor
    // 
    // 30.01.2014 Elva Baltic P7 #F115 MMG7.00
    //   * New field added "Print In Order"
    Editable = ItemNoAttention;
    Editable = TypeChosen;
    Editable = true;
    Editable = StyleTxt;
    Editable = ISVisible;
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


        //Unsupported feature: Code Insertion on "Control 4".

        //trigger OnLookup(var Text: Text): Boolean
        //var
        //Item: Record "27";
        //ExternalService: Record "25006133";
        //GLAccount: Record "15";
        //StandardText: Record "7";
        //FixedAsset: Record "5600";
        //ItemCharge: Record "5800";
        //Resource: Record "156";
        //begin
        /*
        CASE Type OF
          Type::" ":
            BEGIN
              StandardText.RESET;
              IF LookUpMgt.LookUpStandardText(StandardText,"No.") THEN
                VALIDATE("No.",StandardText.Code);
            END;

          Type::"G/L Account":
            BEGIN
              GLAccount.RESET;
              IF LookUpMgt.LookUpGLAccount(GLAccount,"No.") THEN
                VALIDATE("No.",GLAccount."No.");
            END;

          Type::Item:
            BEGIN
              Item.RESET;
              IF "Line Type" = "Line Type"::Vehicle THEN BEGIN
                IF LookUpMgt.LookUpModelVersion(Item, "No.", "Make Code", "Model Code") THEN
                  VALIDATE("No.",Item."No.")
              END ELSE BEGIN
                IF LookUpMgt.LookUpItemREZ(Item,"No.") THEN
                  VALIDATE("No.",Item."No.");
              END;
            END;

          Type::Resource:
            BEGIN
              Resource.RESET;
              IF LookUpMgt.LookUpResource(Resource,"No.") THEN
                VALIDATE("No.",Resource."No.");
            END;

          Type::"Fixed Asset":
            BEGIN
              FixedAsset.RESET;
              IF LookUpMgt.LookUpFixedAsset(FixedAsset,"No.") THEN
                VALIDATE("No.",FixedAsset."No.");
            END;

          Type::"Charge (Item)":
            BEGIN
              ItemCharge.RESET;
              IF LookUpMgt.LookUpItemCharges_Sale(ItemCharge,"No.") THEN
                VALIDATE("No.",ItemCharge."No.");
            END;

          Type::"External Service":
            BEGIN
              ExternalService.RESET;
              IF LookUpMgt.LookUpExternalService(ExternalService,"No.") THEN
                VALIDATE("No.",ExternalService."No.");
            END;
        END;
        CurrPage.UPDATE;
        */
        //end;


        //Unsupported feature: Code Modification on "Control 4.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        NoOnAfterValidate;
        UpdateEditableOnRow;
        ShowShortcutDimCode(ShortcutDimCode);

        QuantityOnAfterValidate;
        IF xRec."No." <> '' THEN
          RedistributeTotalsOnAfterValidate;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..7

        CurrPage.UPDATE;
        */
        //end;
        modify("Control 78")
        {
            Visible = false;
        }


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


        //Unsupported feature: Code Modification on "Control 18.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "Qty. to Asm. to Order (Base)" <> 0 THEN BEGIN
          CurrPage.SAVERECORD;
          CurrPage.UPDATE(FALSE);
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        RedistributeTotalsOnAfterValidate; //ratan 3.8.21
        #1..4
        */
        //end;
        addafter("Control 4")
        {
            field("HS Code"; "HS Code")
            {
                Editable = false;
            }
            field("Item Movement Code"; "Item Movement Code")
            {
                Editable = false;
            }
            field("Has Replacement"; "Has Replacement")
            {
                Editable = false;
            }
            field("Local Parts"; "Local Parts")
            {
            }
        }
        addafter("Control 30")
        {
            field(ABC; ABC)
            {
            }
        }
        addafter("Control 70")
        {
            field("External Serv. Tracking No."; "External Serv. Tracking No.")
            {
                Visible = false;
            }
        }
        addafter("Control 42")
        {
            field("Forward Accountability Center"; "Forward Accountability Center")
            {
            }
            field("Forward Location Code"; "Forward Location Code")
            {
            }
        }
        addafter("Control 3")
        {
            field(Inventory; Inventory)
            {
            }
        }
        addafter("Control 38")
        {
            field("Ordering Price Type Code"; "Ordering Price Type Code")
            {
                Visible = false;
            }
        }
        addafter("Control 148")
        {
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
            }
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
            }
            field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                ToolTip = 'Specifies the code for the VAT product posting group of the item, resource, or general ledger account on this line.';
                Visible = false;

                trigger OnValidate()
                begin
                    RedistributeTotalsOnAfterValidate;
                end;
            }
            field("Board Minute Code"; "Board Minute Code")
            {
            }
            field(CBM; CBM)
            {
                Editable = false;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Insertion (Image) on "AssembleToOrderLines(Action 9)".


        //Unsupported feature: Property Insertion (Image) on "Action 11".


        //Unsupported feature: Property Insertion (Image) on "Action 13".

        addafter("Action 1905968604")
        {
            action("Register Lost Sale")
            {
                Caption = 'Register Lost Sale';
                Image = Register;
            }
            action("Move Lines")
            {
                Caption = 'Move Lines';
                Image = MoveUp;

                trigger OnAction()
                var
                    SalesLine: Record "37";
                begin
                end;
            }
        }
        addafter("Action 1905926804")
        {
            action("Apply Replacement")
            {
                Caption = 'Apply Replacement';
                Image = ItemSubstitution;

                trigger OnAction()
                var
                    ItemSubstSync: Codeunit "25006513";
                begin
                    //10.05.2016 EB.P7 #PAR_28 >>
                    ItemSubstSync.ReplaceSalesLineItemNo(Rec);
                    //10.05.2016 EB.P7 #PAR_28 <<
                    CurrPage.UPDATE;
                end;
            }
            action("QR Specifications")
            {
                Image = SpecialOrder;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ShortCutKey = 'Ctrl+Q';

                trigger OnAction()
                var
                    QRScan: Page "50011";
                    SalesHeader: Record "36";
                begin
                    SalesHeader.GET(Rec."Document Type", Rec."Document No.");
                    QRScan.SetSalesHeader(SalesHeader);
                    QRScan.SetPageCaption(Rec."Document No." + ', ' + SalesHeader."Sell-to Customer Name");
                    QRScan.RUNMODAL;
                    CurrPage.UPDATE;
                end;
            }
            action("Create Lost Sales Entries")
            {
                Image = Create;
                Visible = false;

                trigger OnAction()
                var
                    LostSalesMgt: Codeunit "25006504";
                    lostSalesEntries: Record "25006747";
                begin
                    Rec.TESTFIELD("No.");
                    Rec.TESTFIELD(Quantity);
                    SalesHeader.GET(Rec."Document Type", Rec."Document No.");
                    lostSalesEntries.RESET;
                    lostSalesEntries.SETRANGE(Date, Rec."Posting Date");
                    lostSalesEntries.SETRANGE("Item No.", Rec."No.");
                    IF NOT lostSalesEntries.FINDFIRST THEN
                        LostSalesMgt.CreateEntry_Item(SalesHeader."Posting Date", Rec."No.", SalesHeader."Sell-to Customer No.", '', Rec."Document No.", '', 3, FALSE, FALSE, Rec.Quantity)
                    ELSE
                        ERROR('Lost Sales Entries for Item %1 is already made.', Rec."No.");
                end;
            }
        }
    }

    var
        [InDataSet]
        ItemPanelVisible: Boolean;
        LostSalesMgt: Codeunit "25006504";
        StyleTxt: Text[30];
        TypeChosen: Boolean;
        TotalAmountStyle: Text;
        RefreshMessageEnabled: Boolean;
        RefreshMessageText: Text;
        ItemNoAttention: Text[20];
        LookUpMgt: Codeunit "25006003";
        [InDataSet]
        ISVisible: Boolean;
        UserSetup: Record "91";
        IsEditable: Boolean;


    //Unsupported feature: Code Modification on "OnAfterGetCurrRecord".

    //trigger OnAfterGetCurrRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CalculateTotals;
    SetLocationCodeMandatory;
    UpdateEditableOnRow;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    CalculateTotals;
    //RedistributeTotalsOnAfterValidate2; //ratan 3.9.2021
    SetLocationCodeMandatory;
    UpdateEditableOnRow;
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
    CLEAR(DocumentTotals);
    StyleTxt := GetReservationColor;                                  // 12.05.2014 Elva Baltic P21 #S0104 MMG7.00

    //11.05.2016 EB.P7 #PAR_28 >>
    CheckHasReplacement;
    //11.05.2016 EB.P7 #PAR_28 <<
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
    //LostSalesMgt.OnSalesLineDelete(Rec); //EDMS
    */
    //end;


    //Unsupported feature: Code Modification on "OnInit".

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SalesSetup.GET;
    Currency.InitRoundingPrecision;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    SalesSetup.GET;
    Currency.InitRoundingPrecision;

    UserSetup.GET(USERID);
    IF UserSetup."Can See Cost" THEN
      ISVisible :=TRUE
    ELSE
      ISVisible := FALSE;
    */
    //end;


    //Unsupported feature: Code Insertion on "OnModifyRecord".

    //trigger OnModifyRecord(): Boolean
    //begin
    /*
    //11.05.2016 EB.P7 #PAR_28 >>
    CheckHasReplacement;
    //11.05.2016 EB.P7 #PAR_28 <<
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF Location.READPERMISSION THEN
      LocationCodeVisible := NOT Location.ISEMPTY;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF Location.READPERMISSION THEN
      LocationCodeVisible := NOT Location.ISEMPTY;
    CALCFIELDS(Inventory);

    UserSetup.GET(USERID);
    IF UserSetup."Can Edit Item Description" THEN
      IsEditable := TRUE
    ELSE
      IsEditable := FALSE;
    */
    //end;


    //Unsupported feature: Code Modification on "RedistributeTotalsOnAfterValidate(PROCEDURE 2)".

    //procedure RedistributeTotalsOnAfterValidate();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CurrPage.SAVERECORD;

    SalesHeader.GET("Document Type","Document No.");
    DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
    CurrPage.UPDATE;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    CurrPage.SAVERECORD;
    #3..5
    */
    //end;

    local procedure CheckHasReplacement()
    begin
        IF "Has Replacement" THEN
            ItemNoAttention := 'Attention'
        ELSE
            ItemNoAttention := '';
    end;

    local procedure RedistributeTotalsOnAfterValidate2()
    begin
        //CurrPage.SAVERECORD;
        SalesHeader.GET(Rec."Document Type", Rec."Document No.");
        DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
        //CurrPage.UPDATE;
    end;
}


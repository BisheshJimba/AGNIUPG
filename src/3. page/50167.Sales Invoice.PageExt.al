pageextension 50167 pageextension50167 extends "Sales Invoice"
{
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    // 
    // 20.11.2014 EB.P8 MERGE
    layout
    {
        modify(SalesLines)
        {
            Visible = NOT VehicleTradeDocument;
        }
        modify(ShippingOptions)
        {
            OptionCaption = 'Default (Sell-to Address),Alternate Shipping Address,Custom Address,Service Address';
        }

        //Unsupported feature: Property Modification (SubPageLink) on "Control 31".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1906127307".


        //Unsupported feature: Property Deletion (Enabled) on "SalesLines(Control 56)".

        addafter("Control 2")
        {
            field("Sell-to Customer No."; Rec."Sell-to Customer No.")
            {
                Importance = Promoted;

                trigger OnValidate()
                begin
                    IF "Document Profile" = "Document Profile"::Service THEN
                        ERROR('You cannot change Sell-to Customer No. from this Page. Please Consult Authorize Person.')
                    ELSE
                        SelltoCustomerNoOnAfterValidat;
                    ShipToOptions := ShipToOptions::"Service Address";
                end;
            }
        }
        addafter("Control 5")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
            }
            field("Accountability Center"; "Accountability Center")
            {
            }
        }
        addafter("Control 118")
        {
            field("Scheme Code"; "Scheme Code")
            {
            }
            field("Membership No."; "Membership No.")
            {
            }
            field("Financed By No."; "Financed By No.")
            {
            }
            field("Re-Financed By"; "Re-Financed By")
            {
            }
            field("Job Type"; "Job Type")
            {
                Visible = ServiceDocument;

                trigger OnValidate()
                begin
                    ERROR('You cannot modify Job Type in Sales Line. Please consult with authorize person');
                end;
            }
            field("Vehicle Regd. No."; "Vehicle Regd. No.")
            {
            }
            field("Tender Sales"; "Tender Sales")
            {
            }
            field("Direct Sales"; "Direct Sales")
            {
            }
            field("Direct Sales Commission No."; "Direct Sales Commission No.")
            {
            }
            field("Invertor Serial No."; "Invertor Serial No.")
            {
            }
            field("Insurance Type"; "Insurance Type")
            {
                Editable = false;
            }
            field("Insurance Company Name"; "Insurance Company Name")
            {
                Editable = false;
            }
            field("Insurance Policy Number"; "Insurance Policy Number")
            {
                Editable = false;
            }
            group("Letter of Credit/Delivery Order")
            {
                Caption = 'Letter of Credit/Delivery Order';
                Visible = "Veh&SpareTrade";
                field("Sys. LC No."; "Sys. LC No.")
                {
                    Caption = 'LC / DO No.';
                }
                field("LC Amend No."; "LC Amend No.")
                {
                }
            }
        }
        addafter("Control 135")
        {
            field("Phone No."; "Phone No.")
            {
                Importance = Additional;
            }
            field("Mobile Phone No."; "Mobile Phone No.")
            {
                Importance = Additional;
            }
        }
        addafter(SalesLines)
        {
            part(SalesLinesVeh; 25006470)
            {
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
        }
        addfirst("Control 205")
        {
            field("Bill-to Customer No."; Rec."Bill-to Customer No.")
            {
                Importance = Promoted;

                trigger OnValidate()
                begin
                    IF "Document Profile" = "Document Profile"::Service THEN
                        ERROR('You cannot change Bill-to Customer No. from this Page. Please Consult with Authorize Person.')
                    ELSE
                        BilltoCustomerNoOnAfterValidat;
                end;
            }
        }
        addafter("Control 24")
        {
            field("Dealer VIN"; "Dealer VIN")
            {
            }
        }
        addafter("Control 1907468901")
        {
            group(Service)
            {
                Caption = 'Service';
                field("Document Profile"; "Document Profile")
                {
                }
                field("Service Document No."; "Service Document No.")
                {
                    Caption = 'Service Order No.';
                }
                field("Vehicle Item Charge No."; "Vehicle Item Charge No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
            }
        }
        moveafter("Control 129"; "Control 67")
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 61".

        modify(Release)
        {
            ShortCutKey = 'Ctrl+r';
        }
        modify(Reopen)
        {
            ShortCutKey = 'Ctrl+o';
        }


        //Unsupported feature: Code Modification on "Post(Action 71).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        Post(CODEUNIT::"Sales-Post (Yes/No)",NavigateAfterPost::"Posted Document");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        //*** SM 14-07-2013 to check the commission no. in case of direct sales of vehicle
        IF "Document Profile" = "Document Profile"::"Vehicles Trade" THEN BEGIN
           IF "Direct Sales" THEN
              TESTFIELD("Direct Sales Commission No.");
        END;

        //*** SM 14-06-2013 VAT Registration No. mandatory
        Customer.RESET;
        Customer.SETRANGE("No.","Bill-to Customer No.");
        IF Customer.FINDFIRST THEN BEGIN
          // Customer.TESTFIELD("VAT Registration No.");
        END;

        recServiceInvoice.COPY(Rec);
        Post(CODEUNIT::"Sales-Post (Yes/No)",NavigateAfterPost::"Posted Document");

        IF VFHeader.GET(recServiceInvoice."VF Loan No") THEN BEGIN
          VFHeader."Service Invoice Posted":=TRUE;
          VFHeader.MODIFY;
          END;
        */
        //end;
        addafter("Action 115")
        {
            action("Apply Sanjivani Amount")
            {
                Caption = 'Apply Sanjivani Amount';
                Visible = false;

                trigger OnAction()
                begin
                    CalcRemainingSanjivaniAmount(Rec);
                end;
            }
            action("Make Debit Note")
            {
                Caption = 'Make Debit Note';
                Visible = false;

                trigger OnAction()
                begin
                    "Debit Note" := TRUE;
                end;
            }
            action("Get Scheme Discount")
            {
                Caption = 'Get Scheme Discount';
                Image = Trace;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    //***SM 10-08-2013 to get schemewise discount
                    GetSchemeDiscount(Rec)
                end;
            }
        }
        addafter("Action 69")
        {
            group("<Action1000000001>")
            {
                Caption = 'W&rranty';
                action("<Action1000000002>")
                {
                    Caption = 'Choose Applicable PCR';
                    Image = BulletList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunPageMode = View;
                    Visible = WarantyDocument;

                    trigger OnAction()
                    begin
                        WarrantySettle.RESET;
                        WarrantySettlePage.SETTABLEVIEW(WarrantySettle);
                        WarrantySettlePage.SETRECORD(WarrantySettle);
                        WarrantySettlePage.SetPreAssignNo(Rec."No.");
                        WarrantySettlePage.RUN;
                    end;
                }
                action("Choose Applicable Warranties")
                {
                    Caption = 'Choose Applicable Warranties';
                    Image = BulletList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = WarantyDocumentBattery;

                    trigger OnAction()
                    begin
                        ExideClaim.RESET;
                        ExideClaimList.SETTABLEVIEW(ExideClaim);
                        ExideClaimList.SETRECORD(ExideClaim);
                        ExideClaimList.SetPreAssignNo(Rec."No.");
                        ExideClaimList.RUN;
                    end;
                }
            }
        }
    }

    var
        CompInfo: Record "79";


    //Unsupported feature: Property Modification (OptionString) on "ShipToOptions(Variable 1050)".

    //var
    //>>>> ORIGINAL VALUE:
    //ShipToOptions : Default (Sell-to Address),Alternate Shipping Address,Custom Address;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //ShipToOptions : Default (Sell-to Address),Alternate Shipping Address,Custom Address,Service Address;
    //Variable type has not been exported.


    //Unsupported feature: Property Modification (OptionString) on "BillToOptions(Variable 1051)".

    //var
    //>>>> ORIGINAL VALUE:
    //BillToOptions : Default (Customer),Another Customer;
    //Variable type has not been exported.
    //>>>> MODIFIED VALUE:
    //BillToOptions : Default (Customer),Another Customer,Service Address;
    //Variable type has not been exported.

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        [InDataSet]
        ServiceDocument: Boolean;
        DocumentProfileFilter: Text[250];
        recServiceInvoice: Record "36";
        VFHeader: Record "33020062";
        WarrantyDocumentFilter: Text[30];
        WarrantyDocumentBatteryFilter: Text[30];
        [InDataSet]
        WarantyDocument: Boolean;
        WarrantySettle: Record "33020252";
        WarrantySettlePage: Page "33020256";
        [InDataSet]
        WarantyDocumentBattery: Boolean;
        ExideClaim: Record "33019886";
        ExideClaimList: Page "33019934";
        Customer: Record "18";
        [InDataSet]
        "Veh&SpareTrade": Boolean;
        DebitNoteCaption: Label 'Debit Memo';


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetControlAppearance;
    WorkDescription := GetWorkDescription;
    UpdateShipToBillToGroupVisibility
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //EDMS >>
      VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
      SparePartDocument := "Document Profile" = "Document Profile"::"Spare Parts Trade";
      ServiceDocument := "Document Profile" = "Document Profile"::Service;
      {IF ServiceDocument THEN
        IF UserMgt.GetServiceFilterEDMS <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserMgt.GetServiceFilterEDMS);
          FILTERGROUP(0);
        END;}
    //EDMS >>

    //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
      "Veh&SpareTrade" := ("Document Profile" = "Document Profile"::"Vehicles Trade") OR
                       ("Document Profile" = "Document Profile"::"Spare Parts Trade");
    //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****



    //Sipradi-YS

      IF ("Document Profile" IN ["Document Profile"::Service]) THEN
        ServiceDocument := TRUE
      ELSE
        ServiceDocument := FALSE;
      IF "Warranty Settlement" THEN
        WarantyDocument := TRUE;
      IF "Warranty Settlement (Battery)" THEN
        WarantyDocumentBattery := TRUE;
    //Sipradi-YS

    #1..3
    */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnNewRecord".

    //trigger (Variable: CompInfo)()
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: Code Modification on "OnNewRecord".

    //trigger OnNewRecord(BelowxRec: Boolean)
    //>>>> ORIGINAL CODE:
    //begin
    /*
    xRec.INIT;
    "Responsibility Center" := UserMgt.GetSalesFilter;
    IF (NOT DocNoVisible) AND ("No." = '') THEN
      SetSellToCustomerFromFilter;

    SetDefaultPaymentServices;
    UpdateShipToBillToGroupVisibility;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..7
    //EDMS >>
      CASE DocumentProfileFilter OF
        FORMAT("Document Profile"::"Vehicles Trade"): BEGIN
          "Document Profile" := "Document Profile"::"Vehicles Trade";
          "Veh&SpareTrade" := TRUE; //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
          VehicleTradeDocument := TRUE;
        END;
        FORMAT("Document Profile"::"Spare Parts Trade"): BEGIN
          "Document Profile" := "Document Profile"::"Spare Parts Trade";
          "Veh&SpareTrade" := TRUE; //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
          SparePartDocument := TRUE;
        END;
        FORMAT("Document Profile"::Service): BEGIN
          "Document Profile" := "Document Profile"::Service;
          ServiceDocument := TRUE;
        END;
      END;
    //EDMS >>

    //Sipradi-YS BEGIN
    CASE WarrantyDocumentFilter OF
      'Yes': BEGIN
      "Warranty Settlement" := TRUE;
      WarantyDocument := TRUE;
      END;
    END;
    CASE WarrantyDocumentBatteryFilter OF
      'Yes':BEGIN
        "Warranty Settlement (Battery)" := TRUE;
        WarantyDocumentBattery := TRUE;
       END;
    END;
    //Sipradi-YS END
    CompInfo.GET;
    IF CompInfo."Balaju Auto Works" THEN BEGIN
      BillToOptions := BillToOptions::"Service Address";
      ShipToOptions := ShipToOptions::"Service Address";
    END;
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF UserMgt.GetSalesFilter <> '' THEN BEGIN
      FILTERGROUP(2);
      SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
      FILTERGROUP(0);
    END;

    SetDocNoVisible;

    IF "Quote No." <> '' THEN
      ShowQuoteNo := TRUE;

    IF "No." = '' THEN
      IF OfficeMgt.CheckForExistingInvoice("Sell-to Customer No.") THEN
        ERROR(''); // Cancel invoice creation
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    FilterOnRecord;

    {
    #1..5
    }
    #7..14

    //EDMS >>
      FILTERGROUP(3);
      DocumentProfileFilter := GETFILTER("Document Profile");
      WarrantyDocumentFilter := GETFILTER("Warranty Settlement");
      WarrantyDocumentBatteryFilter :=  GETFILTER("Warranty Settlement (Battery)");
      FILTERGROUP(0);
    //EDMS <<

    //Sipradi-YS
      IF ("Document Profile" IN ["Document Profile"::Service]) THEN
        ServiceDocument := TRUE
      ELSE
        ServiceDocument := FALSE;

    IF "Debit Note" THEN
      CurrPage.CAPTION(DebitNoteCaption);
    IF "Warranty Settlement" THEN
      WarantyDocument := TRUE;
    IF "Warranty Settlement (Battery)" THEN
      WarantyDocumentBattery := TRUE;
    //Sipradi-YS
    */
    //end;

    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
        SkipFilter: Boolean;
        UserSetup: Record "91";
    begin
        UserSetup.GET(USERID);
        IF ("Document Profile" = "Document Profile"::"Vehicles Trade") THEN
            IF UserSetup."Allow View all Veh. Invoice" THEN
                SkipFilter := TRUE;
        IF NOT SkipFilter THEN BEGIN
            RespCenterFilter := UserMgt.GetSalesFilter();
            IF RespCenterFilter <> '' THEN BEGIN
                Rec.FILTERGROUP(2);
                IF UserMgt.DefaultResponsibility THEN
                    Rec.SETRANGE("Responsibility Center", RespCenterFilter)
                ELSE
                    Rec.SETRANGE("Accountability Center", RespCenterFilter);
                Rec.FILTERGROUP(0);
            END;
        END;
    end;

    local procedure SelltoCustomerNoOnAfterValidat()
    begin
        CurrPage.UPDATE;
    end;

    local procedure BilltoCustomerNoOnAfterValidat()
    begin
        CurrPage.UPDATE;
    end;
}


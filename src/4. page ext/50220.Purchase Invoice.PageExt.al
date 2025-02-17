pageextension 50220 pageextension50220 extends "Purchase Invoice"
{
    // 12.06.2015 EB.P30 #T042
    //   Added field:
    //     "Deal Type Code"
    // 
    //   20.11.2014 EB.P8 MERGE
    Caption = 'Vendor Invoice No./ Date:';
    Editable = false;
    layout
    {
        modify(PurchLines)
        {
            Visible = NOT VehicleTradeDocument;
        }

        //Unsupported feature: Property Modification (SubPageLink) on "Control 27".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 3".

        addafter("Control 6")
        {
            field("Posting Description"; Rec."Posting Description")
            {
                ShowMandatory = true;
            }
        }
        addafter("Control 14")
        {
            field("Purch. VAT No."; "Purch. VAT No.")
            {
            }
        }
        addafter("Control 1102601000")
        {
            field("Reason Code"; Rec."Reason Code")
            {
            }
            field("Accountability Center"; "Accountability Center")
            {
            }
        }
        addafter("Control 5")
        {
            field(Correction; Rec.Correction)
            {
            }
            field("Order Type"; "Order Type")
            {
            }
            field("Deal Type Code"; "Deal Type Code")
            {
                Visible = false;
            }
            field("Import Invoice No."; "Import Invoice No.")
            {
            }
            field("Service Order No."; "Service Order No.")
            {
                Visible = ServiceDocument;
            }
            field(Narration; Narration)
            {
            }
            group("Letter of Credit")
            {
                Caption = 'Letter of Credit';
                Visible = "Veh&SpareTrade";
                field("Sys. LC No."; "Sys. LC No.")
                {
                }
                field("Bank LC No."; "Bank LC No.")
                {
                }
                field("LC Amend No."; "LC Amend No.")
                {
                    Caption = 'Amendment No.';
                    Importance = Promoted;
                }
            }
        }
        addafter(PurchLines)
        {
            part(PurchLinesVehicle; 25006478)
            {
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
        }
        addafter("Control 138")
        {
            field("TDS Posting Group"; "TDS Posting Group")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 59".

        addfirst("Action 60")
        {
            action("<Action1000000014>")
            {
                Caption = 'Calculte TDS';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CalculateTDS(); //TDS2.00
                end;
            }
        }
    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        [InDataSet]
        ServiceDocument: Boolean;
        DocumentProfileFilter: Text[250];
        [InDataSet]
        "Veh&SpareTrade": Boolean;


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*
    SetControlAppearance;

    //EDMS >>
      VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
      SparePartDocument := "Document Profile" = "Document Profile"::"Spare Parts Trade";
      ServiceDocument := "Document Profile" = "Document Profile"::Service;
    //EDMS >>

    //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
      "Veh&SpareTrade" := ("Document Profile" = "Document Profile"::"Vehicles Trade") OR
                       ("Document Profile" = "Document Profile"::"Spare Parts Trade");
    //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
    */
    //end;


    //Unsupported feature: Code Modification on "OnNewRecord".

    //trigger OnNewRecord(BelowxRec: Boolean)
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Responsibility Center" := UserMgt.GetPurchasesFilter;

    IF (NOT DocNoVisible) AND ("No." = '') THEN
      SetBuyFromVendorFromFilter;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4

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
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetDocNoVisible;
    IsOfficeAddin := OfficeMgt.IsAvailable;
    CreateIncomingDocFromEmailAttachment := OfficeMgt.OCRAvailable;
    CreateIncomingDocumentVisible := NOT OfficeMgt.IsOutlookMobileApp;

    IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
      FILTERGROUP(2);
      SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
      FILTERGROUP(0);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    FilterOnRecord;
    #1..4
    {
    #6..10
    }
    //EDMS >>
      FILTERGROUP(3);
      DocumentProfileFilter := GETFILTER("Document Profile");
      FILTERGROUP(0);
    //EDMS <<

    IF ("Document Profile" IN ["Document Profile"::Service]) THEN
      ServiceDocument := TRUE
    ELSE
      ServiceDocument := FALSE;
    */
    //end;

    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetPurchasesFilter();
        IF RespCenterFilter <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            IF UserMgt.DefaultResponsibility THEN
                Rec.SETRANGE("Responsibility Center", RespCenterFilter)
            ELSE
                Rec.SETRANGE("Accountability Center", RespCenterFilter);
            Rec.FILTERGROUP(0);
        END;
    end;
}


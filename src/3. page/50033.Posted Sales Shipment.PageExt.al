pageextension 50033 pageextension50033 extends "Posted Sales Shipment"
{
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    Editable = false;
    PromotedActionCategories = 'New,Process,Report,Document';
    layout
    {
        modify(SalesShipmLines)
        {

            //Unsupported feature: Property Insertion (SubPageView) on "SalesShipmLines(Control 46)".

            Visible = NOT VehicleTradeDocument;
        }
        addafter("Control 12")
        {
            field("Accountability Center"; Rec."Accountability Center")
            {
            }
        }
        addafter("Control 82")
        {
            field("Forward Accountability Center"; Rec."Forward Accountability Center")
            {
            }
            field("Forward Location Code"; Rec."Forward Location Code")
            {
            }
            field("Phone No."; Rec."Phone No.")
            {
                Editable = false;
                Importance = Additional;
            }
            field("Mobile Phone No."; Rec."Mobile Phone No.")
            {
                Editable = false;
                Importance = Additional;
            }
            field("User ID"; Rec."User ID")
            {
            }
            field("Financed By"; Rec."Financed By")
            {
            }
            field("Re-Financed By"; Rec."Re-Financed By")
            {
            }
            field("Tender Sales"; Rec."Tender Sales")
            {
            }
            field("Direct Sales Commission No."; Rec."Direct Sales Commission No.")
            {
            }
            field("Invertor Serial No."; Rec."Invertor Serial No.")
            {
            }
            field("Total CBM"; Rec."Total CBM")
            {
            }
            group("Letter of Credit/Delivery Order")
            {
                Caption = 'Letter of Credit/Delivery Order';
                Visible = "Veh&SpareTrade";
                field("Sys. LC No."; Rec."Sys. LC No.")
                {
                }
                field("LC Amend No."; Rec."LC Amend No.")
                {
                }
            }
        }
        addafter(SalesShipmLines)
        {
            part(SalesShipmLinesVehicle; 25006540)
            {
                SubPageLink = Document No.=FIELD(No.);
                    SubPageView = WHERE(Quantity=FILTER(<>0));
                Visible = VehicleTradeDocument;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 78".


        //Unsupported feature: Property Modification (RunPageLink) on "CertificateOfSupplyDetails(Action 3)".

        modify("Action 49")
        {
            Visible = false;
        }
        addafter("Action 79")
        {
            action("&Undo Shipment")
            {
                Caption = '&Undo Shipment';
                Enabled = false;
                Visible = false;

                trigger OnAction()
                begin
                    //CurrPage.SalesShipmLines.Page.UndoShipmentPosting;
                    //CurrPage.SalesShipmLines.FORM.UndoShipmentPosting;
                    //RL 7/19/2019
                    SaleShipmentLine.RESET;
                    SaleShipmentLine.SETRANGE("Document No.",Rec."No.");
                    IF SaleShipmentLine.FINDFIRST THEN
                      CODEUNIT.RUN(CODEUNIT::"Undo Sales Shipment Line",SaleShipmentLine);
                end;
            }
            action("&Deliver Vehicle")
            {
                Caption = '&Deliver Vehicle';
                Image = MakeAgreement;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    DeliverVehicle(Rec)
                end;
            }
            action("<Action49>")
            {
                Caption = '&Print Delivery Order';
                Ellipsis = true;
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    /*
                    CurrPage.SETSELECTIONFILTER(SalesShptHeader);
                    SalesShptHeader.PrintRecords(TRUE);
                    */
                    
                    SalesShptHeader.RESET;
                    SalesShptHeader.SETRANGE("No.","No.");
                    SalesShptHeader.SETRANGE("Document Profile","Document Profile");
                    REPORT.RUN(33020199,TRUE,TRUE,SalesShptHeader);

                end;
            }
        }
        addafter("Action 50")
        {
            action("Print sales shipment")
            {
                Caption = 'Print sales shipment';
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(SalesShptHeader);
                    REPORT.RUN(50014,TRUE,TRUE,SalesShptHeader);
                end;
            }
            action("<Action1102159011>")
            {
                Caption = 'Print Batt-Lube Sales Shipment';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(SalesShptHeader);
                    REPORT.RUN(50030,TRUE,TRUE,SalesShptHeader);
                end;
            }
        }
    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        [InDataSet]
        "Veh&SpareTrade": Boolean;
        SaleShipmentLine: Record "111";
        UndoShipment: Codeunit "5815";
        ABC: Record "27";


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
        /*
        //EDMS >>
          VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
        //EDMS >>

        //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
          "Veh&SpareTrade" := ("Document Profile" = "Document Profile"::"Vehicles Trade") OR
                           ("Document Profile" = "Document Profile"::"Spare Parts Trade");
        //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
        */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SetSecurityFilterOnRespCenter;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        // SetSecurityFilterOnRespCenter;

        FilterOnRecord;
        */
    //end;

    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetSalesFilter();
        IF RespCenterFilter <> '' THEN BEGIN
          FILTERGROUP(2);
           IF UserMgt.DefaultResponsibility THEN
              SETRANGE("Responsibility Center",RespCenterFilter)
          ELSE
              SETRANGE("Accountability Center",RespCenterFilter);
          FILTERGROUP(0);
        END;
    end;
}


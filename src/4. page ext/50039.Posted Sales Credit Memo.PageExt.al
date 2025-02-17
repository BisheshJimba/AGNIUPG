pageextension 50039 pageextension50039 extends "Posted Sales Credit Memo"
{
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    Editable = false;

    //Unsupported feature: Property Modification (Name) on ""Posted Sales Credit Memo"(Page 134)".

    Caption = 'Posted Credit Note';
    layout
    {
        modify(SalesCrMemoLines)
        {
            Visible = NOT VehicleTradeDocument;
        }
        addafter("Control 12")
        {
            field("Return Reason"; Rec."Return Reason")
            {
            }
        }
        addafter("Control 10")
        {
            field("Accountability Center"; Rec."Accountability Center")
            {
            }
        }
        addafter("Control 37")
        {
            field("Tender Sales"; Rec."Tender Sales")
            {
            }
            field("Direct Sales Commission No."; Rec."Direct Sales Commission No.")
            {
            }
        }
        addafter("Control 18")
        {
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
            field("Invertor Serial No."; Rec."Invertor Serial No.")
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
        addafter(SalesCrMemoLines)
        {
            part(SalesCrMemoLinesVehicle; 25006542)
            {
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
        }
        addafter("Control 1906801201")
        {
            group(Service)
            {
                Caption = 'Service';
                field("Document Profile"; Rec."Document Profile")
                {
                    Editable = false;
                }
                field("Service Return Order No."; Rec."Service Return Order No.")
                {
                    Editable = false;
                }
                field("Make Code"; Rec."Make Code")
                {
                    Editable = false;
                }
                field("Model Code"; Rec."Model Code")
                {
                    Editable = false;
                }
                field("Model Version No."; Rec."Model Version No.")
                {
                    Editable = false;
                }
                field("Vehicle Registration No."; Rec."Vehicle Registration No.")
                {
                    Editable = false;
                }
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 49".



        //Unsupported feature: Code Modification on "Print(Action 50).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        SalesCrMemoHeader := Rec;
        CurrPage.SETSELECTIONFILTER(SalesCrMemoHeader);
        SalesCrMemoHeader.PrintRecords(TRUE);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        SalesCrMemoHeader := Rec;
        CurrPage.SETSELECTIONFILTER(SalesCrMemoHeader);
        SalesCrMemoHeader.PrintRecords2(TRUE);
        */
        //end;
    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        [InDataSet]
        "Veh&SpareTrade": Boolean;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    DocExchStatusStyle := GetDocExchStatusStyle;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    DocExchStatusStyle := GetDocExchStatusStyle;
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
    IsOfficeAddin := OfficeMgt.IsAvailable;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    // SetSecurityFilterOnRespCenter;
    IsOfficeAddin := OfficeMgt.IsAvailable;
    FilterOnRecord;
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
        IF (Rec."Document Profile" = Rec."Document Profile"::"Vehicles Trade") THEN
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
}


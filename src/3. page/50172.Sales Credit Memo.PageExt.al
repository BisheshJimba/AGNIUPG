pageextension 50172 pageextension50172 extends "Sales Credit Memo"
{
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    // 
    // 20.11.2014 EB.P8 MERGE
    Editable = false;

    //Unsupported feature: Property Modification (Name) on ""Sales Credit Memo"(Page 44)".

    Caption = 'Credit Note';
    layout
    {
        modify(SalesLines)
        {
            Visible = NOT VehicleTradeDocument;
        }

        //Unsupported feature: Property Modification (SubPageLink) on "Control 19".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1906127307".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 14".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 14".


        //Unsupported feature: Property Deletion (Importance) on "Control 14".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 16".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 16".


        //Unsupported feature: Property Deletion (Importance) on "Control 16".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 94".


        //Unsupported feature: Property Deletion (ApplicationArea) on "Control 94".


        //Unsupported feature: Property Deletion (Importance) on "Control 94".

        addafter("Control 104")
        {
            field("Accountability Center"; "Accountability Center")
            {
            }
        }
        addafter("Control 107")
        {
            field("Tender Sales"; "Tender Sales")
            {
            }
            field("Direct Sales Commission No."; "Direct Sales Commission No.")
            {
            }
        }
        addafter("Control 110")
        {
            field("Phone No."; "Phone No.")
            {
                Importance = Additional;
            }
            field("Mobile Phone No."; "Mobile Phone No.")
            {
                Importance = Additional;
            }
            field("Return Reason"; "Return Reason")
            {
            }
            field("Invertor Serial No."; "Invertor Serial No.")
            {
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
        addafter("Control 1906801201")
        {
            part(SalesLinesVeh; 25006487)
            {
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
            }
        }
        addafter("Control 1907468901")
        {
            group(Application)
            {
                Caption = 'Application';
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
        moveafter("Control 110"; SalesLines)
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 53".



        //Unsupported feature: Code Modification on "Post(Action 61).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        Post(CODEUNIT::"Sales-Post (Yes/No)");
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

        Post(CODEUNIT::"Sales-Post (Yes/No)");
        */
        //end;
    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        ServiceDocument: Boolean;
        DocumentProfileFilter: Text[250];
        [InDataSet]
        "Veh&SpareTrade": Boolean;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetControlAppearance;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    SetControlAppearance;
    //EDMS >>
      VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
      SparePartDocument := "Document Profile" = "Document Profile"::"Spare Parts Trade";
      ServiceDocument := "Document Profile" = "Document Profile"::Service;
      IF ServiceDocument THEN
        IF UserMgt.GetServiceFilterEDMS <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Accountability Center",UserMgt.GetServiceFilterEDMS);
          FILTERGROUP(0);
        END;
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
    "Responsibility Center" := UserMgt.GetSalesFilter;
    IF (NOT DocNoVisible) AND ("No." = '') THEN
      SetSellToCustomerFromFilter;
    SetControlAppearance;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //"Responsibility Center" := UserMgt.GetSalesFilter;
    #2..4
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
    IF UserMgt.GetSalesFilter <> '' THEN BEGIN
      FILTERGROUP(2);
      SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
      FILTERGROUP(0);
    END;

    SetDocNoVisible;
    SetControlAppearance;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    IF UserMgt.DefaultResponsibility THEN BEGIN
      IF UserMgt.GetSalesFilter <> '' THEN BEGIN
        FILTERGROUP(2);
        SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
        FILTERGROUP(0);
      END;
    END ELSE BEGIN
      IF UserMgt.GetSalesFilter <> '' THEN BEGIN
        FILTERGROUP(2);
        SETRANGE("Accountability Center",UserMgt.GetSalesFilter);
        FILTERGROUP(0);
      END;
    END;

    #6..8
    //EDMS >>
      FILTERGROUP(3);
      DocumentProfileFilter := GETFILTER("Document Profile");
      FILTERGROUP(0);
    //EDMS <<
    */
    //end;


    //Unsupported feature: Code Modification on "Post(PROCEDURE 4)".

    //procedure Post();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CheckSalesCheckAllLinesHaveQuantityAssigned;
    PreAssignedNo := "No.";

    #4..13
    IF OfficeMgt.IsAvailable THEN BEGIN
      SalesCrMemoHeader.SETRANGE("Pre-Assigned No.",PreAssignedNo);
      IF SalesCrMemoHeader.FINDFIRST THEN
        PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
    END ELSE
      IF InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) THEN
        ShowPostedConfirmationMessage(PreAssignedNo);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..16
        PAGE.RUN(PAGE::"Posted Credit Note",SalesCrMemoHeader);
    #18..20
    */
    //end;


    //Unsupported feature: Code Modification on "ShowPostedConfirmationMessage(PROCEDURE 7)".

    //procedure ShowPostedConfirmationMessage();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SalesCrMemoHeader.SETRANGE("Pre-Assigned No.",PreAssignedNo);
    IF SalesCrMemoHeader.FINDFIRST THEN
      IF InstructionMgt.ShowConfirm(OpenPostedSalesCrMemoQst,InstructionMgt.ShowPostedConfirmationMessageCode) THEN
        PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
        PAGE.RUN(PAGE::"Posted Credit Note",SalesCrMemoHeader);
    */
    //end;
}


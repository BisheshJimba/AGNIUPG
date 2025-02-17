pageextension 50431 pageextension50431 extends "Sales Return Order"
{
    // 11.07.2016 EB.P30 #T089
    //   Added fields:
    //     "Make Code"
    //     "Model Code"
    // 
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    // 
    // 20.11.2014 EB.P8 MERGE
    Editable = false;
    layout
    {
        modify(SalesLines)
        {
            Visible = NOT VehicleTradeDocument;
        }

        //Unsupported feature: Property Modification (SubPageLink) on "Control 19".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1906127307".

        addafter("Control 117")
        {
            field("Return Reason"; "Return Reason")
            {
            }
        }
        addafter("Control 39")
        {
            field("Document Profile"; "Document Profile")
            {
            }
        }
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
            field("Invertor Serial No."; "Invertor Serial No.")
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
        }
        addafter(SalesLines)
        {
            part(SalesLinesVeh; 25006481)
            {
                Caption = 'Vehicle Lines';
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
            group("Letter of Credit/Delivery Order")
            {
                Caption = 'Letter of Credit/Delivery Order';
                field("Sys. LC No."; "Sys. LC No.")
                {
                    Caption = 'LC / DO No.';
                }
                field("LC Amend No."; "LC Amend No.")
                {
                }
            }
        }
        addafter("Control 137")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
            }
            field("Payment Method Code"; Rec."Payment Method Code")
            {
            }
        }
        addafter("Control 44")
        {
            field("Payment Terms Code"; Rec."Payment Terms Code")
            {
            }
        }
        addafter("Control 1907468901")
        {
            group(Vehicle)
            {
                Caption = 'Vehicle';
                Visible = SparePartDocument;
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 53".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 130".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 120".



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
        //*** SM 14-07-2013 to check the commission no. in case of direct sales of vehicle
        Post(CODEUNIT::"Sales-Post (Yes/No)");
        */
        //end;
        addafter(GetPostedDocumentLinesToReverse)
        {
            action("Update Rounding Lines")
            {
                Image = Reuse;
                Visible = false;

                trigger OnAction()
                var
                    SysMgt: Codeunit "50000";
                begin
                    SysMgt.UpdateInvoiceRoundingLineInReturnOrder(Rec);  //SRT Feb 15th 2019
                end;
            }
        }
    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        DocumentProfileFilter: Text[250];
        EnableExtDocumentNo: Boolean;
        SIDNo: Text[100];
        UserSetup: Record "91";
        VehSpareTrade: Boolean;


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
      //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
      VehSpareTrade := ("Document Profile" = "Document Profile"::"Vehicles Trade") OR
                    ("Document Profile" = "Document Profile"::"Spare Parts Trade");
      //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
    //EDMS >>
    {
    IF VehicleTradeDocument THEN
      EnableExtDocumentNo := FALSE
    ELSE
      EnableExtDocumentNo := TRUE;
    }
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
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    "Responsibility Center" := UserMgt.GetSalesFilter;
    "Accountability Center" := UserMgt.GetSalesFilter;  //AGNI2017CU8
    IF (NOT DocNoVisible) AND ("No." = '') THEN
      SetSellToCustomerFromFilter;
    //EDMS >>
      CASE DocumentProfileFilter OF
        FORMAT("Document Profile"::"Vehicles Trade"): BEGIN
          "Document Profile" := "Document Profile"::"Vehicles Trade";
          VehicleTradeDocument := TRUE;
          VehSpareTrade := TRUE; //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
        END;
        FORMAT("Document Profile"::"Spare Parts Trade"): BEGIN
          "Document Profile" := "Document Profile"::"Spare Parts Trade";
          SparePartDocument := TRUE;
          VehSpareTrade := TRUE; //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
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
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    {
    #1..5
    }
    SetDocNoVisible;

    //EDMS >>
      FILTERGROUP(3);
      DocumentProfileFilter := GETFILTER("Document Profile");
      FILTERGROUP(0);
    //EDMS <<
    FilterOnRecord;  //AGNI2017CU8
    */
    //end;


    //Unsupported feature: Code Modification on "ShowPostedConfirmationMessage(PROCEDURE 17)".

    //procedure ShowPostedConfirmationMessage();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF NOT ReturnOrderSalesHeader.GET("Document Type","No.") THEN BEGIN
      SalesCrMemoHeader.SETRANGE("No.","Last Posting No.");
      IF SalesCrMemoHeader.FINDFIRST THEN
        IF InstructionMgt.ShowConfirm(OpenPostedSalesReturnOrderQst,InstructionMgt.ShowPostedConfirmationMessageCode) THEN
          PAGE.RUN(PAGE::"Posted Sales Credit Memo",SalesCrMemoHeader);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4
          PAGE.RUN(PAGE::"Posted Credit Note",SalesCrMemoHeader);
    END;
    */
    //end;

    local procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetSalesFilter();
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


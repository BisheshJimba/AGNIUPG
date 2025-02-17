pageextension 50250 pageextension50250 extends "Purchase Credit Memo"
{
    //   20.11.2014 EB.P8 MERGE
    // 
    // **** code added to insert accountability center in credit memo and filter the data acc. to accountability center***
    Editable = false;

    //Unsupported feature: Property Modification (Name) on ""Purchase Credit Memo"(Page 52)".

    Caption = 'Debit Memo';
    layout
    {
        modify(PurchLines)
        {
            Visible = NOT VehicleTradeDocument;
        }

        //Unsupported feature: Property Modification (SubPageLink) on "Control 15".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 5".

        addafter("Control 2")
        {
            field("Posting Description"; Rec."Posting Description")
            {
            }
        }
        addafter("Control 12")
        {
            field("Purch. VAT No."; "Purch. VAT No.")
            {
            }
        }
        addafter("Control 72")
        {
            field("Order Type"; "Order Type")
            {
            }
        }
        addafter("Control 1102601000")
        {
            field("Accountability Center"; "Accountability Center")
            {
            }
        }
        addafter("Control 1")
        {
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
            part(PurchLinesVehicle; 25006485)
            {
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
        }
        addafter("Control 141")
        {
            field("TDS Posting Group"; "TDS Posting Group")
            {
            }
        }
        addafter("Control 16")
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 51".

        addfirst("Action 52")
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
        addafter("Action 3")
        {
            action(Print)
            {

                trigger OnAction()
                begin
                    REPORT.RUN(407);
                end;
            }
        }
    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
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
    IF UserMgt.DefaultResponsibility THEN
    "Responsibility Center" := UserMgt.GetPurchasesFilter
    ELSE
    "Accountability Center" := UserMgt.GetPurchasesFilter;
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
    SetDocNoVisible;
    IsOfficeAddin := OfficeMgt.IsAvailable;

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
    #1..5
      IF UserMgt.DefaultResponsibility THEN
        SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter)
      ELSE
        SETRANGE("Accountability Center",UserMgt.GetPurchasesFilter);
      FILTERGROUP(0);
    END;

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
    IF ApplicationAreaSetup.IsFoundationEnabled THEN
      LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);

    #4..14
    IF IsOfficeAddin THEN BEGIN
      PurchCrMemoHdr.SETRANGE("Pre-Assigned No.","No.");
      IF PurchCrMemoHdr.FINDFIRST THEN
        PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHdr);
    END ELSE
      IF InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode) THEN
        ShowPostedConfirmationMessage;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..17
        PAGE.RUN(PAGE::"Posted Debit Note",PurchCrMemoHdr);
    #19..21
    */
    //end;


    //Unsupported feature: Code Modification on "ShowPostedConfirmationMessage(PROCEDURE 13)".

    //procedure ShowPostedConfirmationMessage();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    PurchCrMemoHdr.SETRANGE("Pre-Assigned No.","No.");
    IF PurchCrMemoHdr.FINDFIRST THEN
      IF InstructionMgt.ShowConfirm(OpenPostedPurchCrMemoQst,InstructionMgt.ShowPostedConfirmationMessageCode) THEN
        PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHdr);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
        PAGE.RUN(PAGE::"Posted Debit Note",PurchCrMemoHdr);
    */
    //end;
}


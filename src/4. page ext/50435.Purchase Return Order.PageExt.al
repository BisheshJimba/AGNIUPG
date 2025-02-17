pageextension 50435 pageextension50435 extends "Purchase Return Order"
{
    //   20.11.2014 EB.P8 MERGE
    Editable = false;
    layout
    {
        modify(PurchLines)
        {
            Visible = NOT VehicleTradeDocument;
        }

        //Unsupported feature: Property Modification (SubPageLink) on "Control 21".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 3".


        //Unsupported feature: Property Deletion (UpdatePropagation) on "PurchLines(Control 46)".

        addafter("Control 6")
        {
            field("Posting Description"; Rec."Posting Description")
            {
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
        addafter(PurchLines)
        {
            part(PurchLinesVehicle; 25006494)
            {
                SubPageLink = Document No.=FIELD(No.);
                    UpdatePropagation = Both;
                    Visible = VehicleTradeDocument;
            }
            group("Letter of Credit")
            {
                Caption = 'Letter of Credit';
                field("Sys. LC No."; "Sys. LC No.")
                {
                }
                field("Bank LC No."; "Bank LC No.")
                {
                }
                field("LC Amend No."; "LC Amend No.")
                {
                    Importance = Promoted;
                }
            }
        }
        addafter("Control 139")
        {
            field("TDS Posting Group"; "TDS Posting Group")
            {
            }
        }
        addafter("Control 42")
        {
            field("Payment Terms Code"; Rec."Payment Terms Code")
            {
                ApplicationArea = Basic, Suite;
                Importance = Promoted;
                ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount on the purchase document.';
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 51".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 114".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 129".

        addfirst("Action 52")
        {
            action(CalculateTDS)
            {
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CalculateTDS(); //TDS2.00  //AGNI2017CU8
                end;
            }
        }
    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        DocumentProfileFilter: Text[250];
        VehAndSpareTrade: Boolean;


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
    //EDMS >>
    //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
    VehAndSpareTrade := ("Document Profile" = "Document Profile"::"Vehicles Trade") OR
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
    //For Agni
    IF UserMgt.DefaultResponsibility THEN
    "Responsibility Center" := UserMgt.GetPurchasesFilter
    ELSE
    "Accountability Center" := UserMgt.GetPurchasesFilter;
    //For Agni

    IF (NOT DocNoVisible) AND ("No." = '') THEN
      SetBuyFromVendorFromFilter;

    //EDMS >>
      CASE DocumentProfileFilter OF
        FORMAT("Document Profile"::"Vehicles Trade"): BEGIN
          "Document Profile" := "Document Profile"::"Vehicles Trade";
          VehicleTradeDocument := TRUE;
          VehAndSpareTrade := TRUE; //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
        END;
        FORMAT("Document Profile"::"Spare Parts Trade"): BEGIN
          "Document Profile" := "Document Profile"::"Spare Parts Trade";
          SparePartDocument := TRUE;
          VehAndSpareTrade := TRUE; //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
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
    IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
      FILTERGROUP(2);
      SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter);
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
    IF NOT ReturnOrderPurchaseHeader.GET("Document Type","No.") THEN BEGIN
      PurchCrMemoHdr.SETRANGE("No.","Last Posting No.");
      IF PurchCrMemoHdr.FINDFIRST THEN
        IF InstructionMgt.ShowConfirm(OpenPostedPurchaseReturnOrderQst,InstructionMgt.ShowPostedConfirmationMessageCode) THEN
          PAGE.RUN(PAGE::"Posted Purchase Credit Memo",PurchCrMemoHdr);
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4
          PAGE.RUN(PAGE::"Posted Debit Note",PurchCrMemoHdr);
    END;
    */
    //end;

    local procedure FilterOnRecord()
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


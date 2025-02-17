pageextension 50187 pageextension50187 extends "Purchase Quote"
{
    //   20.11.2014 EB.P8 MERGE
    Editable = false;
    PromotedActionCategories = 'New,Process,Report,Requisition';
    layout
    {
        modify(PurchLines)
        {
            Visible = NOT VehicleTradeDocument;
        }

        //Unsupported feature: Property Modification (SubPageLink) on "Control 13".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 5".

        addafter("Control 10")
        {
            field("Reason Code"; Rec."Reason Code")
            {
            }
        }
        addafter("Control 1102601000")
        {
            field("Accountability Center"; "Accountability Center")
            {
            }
        }
        addafter(PurchLines)
        {
            part(PurchLinesVehicle; 25006484)
            {
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 63".

        addafter("Action 7")
        {
            group(Print)
            {
                Caption = 'Print';
                Image = Print;
                action("<Action1101904032>")
                {
                    Caption = 'Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PurchaseLine: Record "39";
                        DocMgt: Codeunit "25006000";
                        DocReport: Record "25006011";
                    begin
                        PurchaseLine.RESET;
                        DocMgt.PrintCurrentDoc("Document Profile", 2, 0, DocReport);
                        DocMgt.SelectPurchHdrDocReport(DocReport, Rec, PurchaseLine, FALSE);
                    end;
                }
                action(Action1101904033)
                {
                    Caption = 'Email';
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PurchaseLine: Record "39";
                        DocMgt: Codeunit "25006000";
                        DocReport: Record "25006011";
                    begin
                        PurchaseLine.RESET;
                        DocMgt.PrintCurrentDoc("Document Profile", 2, 0, DocReport);
                        DocMgt.SelectPurchHdrDocReport(DocReport, Rec, PurchaseLine, TRUE);
                    end;
                }
            }
            separator()
            {
            }
            action(Import_Indent)
            {
                Caption = 'Import Indent';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
                    PurchHdr: Record "38";
                begin
                    //Check for approval entry.
                    /*PurchHdr.RESET;
                    PurchHdr.SETRANGE("Document Type","Document Type");
                    PurchHdr.SETRANGE("No.","No.");*/
                    //ImportIndent.SETTABLEVIEW(PurchHdr);
                    //ImportIndent.RUN;

                end;
            }
        }
    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        DocumentProfileFilter: Text[250];
        [InDataSet]
        ShowImportStrReq: Boolean;


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*
    SetControlAppearance;
     //EDMS >>
      VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
      SparePartDocument := "Document Profile" = "Document Profile"::"Spare Parts Trade";
    //EDMS >>

    {
    //Hiding Import Store Requisition. Sangam Shrestha on 30 Jan 2012.
    IF ("Document Profile" IN ["Document Profile"::"Vehicles Trade","Document Profile"::"Spare Parts Trade"]) THEN
      ShowImportStrReq := FALSE
    ELSE
      ShowImportStrReq := TRUE;
    }
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
    //"Responsibility Center" := UserMgt.GetPurchasesFilter;

    "Accountability Center" := UserMgt.GetPurchasesFilter();
    IF (NOT DocNoVisible) AND ("No." = '') THEN
      SetBuyFromVendorFromFilter;

    //EDMS >>
      CASE DocumentProfileFilter OF
        FORMAT("Document Profile"::"Vehicles Trade"): BEGIN
          "Document Profile" := "Document Profile"::"Vehicles Trade";
          VehicleTradeDocument := TRUE;
        END;
        FORMAT("Document Profile"::"Spare Parts Trade"): BEGIN
          "Document Profile" := "Document Profile"::"Spare Parts Trade";
          SparePartDocument := TRUE;
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
    FilterOnRecord;
    //EDMS >>
      FILTERGROUP(3);
      DocumentProfileFilter := GETFILTER("Document Profile");
      FILTERGROUP(0);
    //EDMS <<

    {
    //Hiding Import Store Requisition. Sangam Shrestha on 30 Jan 2012.
    IF ("Document Profile" IN ["Document Profile"::"Vehicles Trade","Document Profile"::"Spare Parts Trade"]) THEN
      ShowImportStrReq := FALSE
    ELSE
      ShowImportStrReq := TRUE;
    }
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


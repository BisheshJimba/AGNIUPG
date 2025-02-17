pageextension 50047 pageextension50047 extends "Posted Purchase Invoice"
{
    Editable = false;
    layout
    {
        modify(PurchInvLines)
        {
            Visible = NOT VehicleTradeDocument;
        }
        addafter("Control 81")
        {
            field("Reason Code"; Rec."Reason Code")
            {
            }
            field("Purch. VAT No."; Rec."Purch. VAT No.")
            {
            }
        }
        addafter("Control 14")
        {
            field("Purch. VAT No.2"; Rec."Purch. VAT No.")
            {
                Caption = 'Purch. VAT No.';
            }
        }
        addafter("Control 92")
        {
            field("Accountability Center"; Rec."Accountability Center")
            {
            }
        }
        addafter("Control 18")
        {
            field("Service Order No."; Rec."Service Order No.")
            {
            }
            field("Import Invoice No."; Rec."Import Invoice No.")
            {
            }
            field("Procument Memo No."; Rec."Procument Memo No.")
            {
            }
            field(Narration; Rec.Narration)
            {
            }
            group("Letter of Credit")
            {
                Caption = 'Letter of Credit';
                Visible = "Veh&SpareTrade";
                field("Sys. LC No."; Rec."Sys. LC No.")
                {
                }
                field("LC Amend No."; Rec."LC Amend No.")
                {
                }
            }
        }
        addafter(PurchInvLines)
        {
            part(PurchInvLinesVehicle; 25006512)
            {
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
        }
        addafter("Control 84")
        {
            field("TDS Posting Group"; Rec."TDS Posting Group")
            {
                Editable = false;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 55".



        //Unsupported feature: Code Modification on "CreateCreditMemo(Action 21).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CorrectPostedPurchInvoice.CreateCreditMemoCopyDocument(Rec,PurchaseHeader);
        PAGE.RUN(PAGE::"Purchase Credit Memo",PurchaseHeader);
        CurrPage.CLOSE;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        CorrectPostedPurchInvoice.CreateCreditMemoCopyDocument(Rec,PurchaseHeader);
        PAGE.RUN(PAGE::"Debit Memo",PurchaseHeader);
        CurrPage.CLOSE;
        */
        //end;
        addafter(IncomingDocAttachFile)
        {
            action("Procument Memo")
            {
                Image = PhysicalInventoryLedger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ProcumentMemo: Record "130415";
                begin
                    ProcumentMemo.GET(Rec."Procument Memo No.");
                    IF ProcumentMemo.Status <> ProcumentMemo.Status::Released THEN
                        ERROR('Document not realesed.');
                    PAGE.RUNMODAL(PAGE::"Posted Procurement Memos", ProcumentMemo);
                end;
            }
        }
    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        [InDataSet]
        "Veh&SpareTrade": Boolean;


    //Unsupported feature: Code Modification on "OnAfterGetCurrRecord".

    //trigger OnAfterGetCurrRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    HasIncomingDocument := IncomingDocument.PostedDocExists("No.","Posting Date");
    CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    HasIncomingDocument := IncomingDocument.PostedDocExists("No.","Posting Date");
    CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    //EDMS >>
    VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
    //EDMS >>
    */
    //end;


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*
    { below code not in this standard
    //EDMS >>
      VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
    //EDMS >>
    }
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


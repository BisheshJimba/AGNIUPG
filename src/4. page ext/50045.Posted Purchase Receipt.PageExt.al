pageextension 50045 pageextension50045 extends "Posted Purchase Receipt"
{
    Editable = false;
    layout
    {
        modify(PurchReceiptLines)
        {
            Visible = NOT VehicleTradeDocument;
        }

        //Unsupported feature: Property Deletion (PartType) on "PurchReceiptLines(Control 44)".

        addafter("Control 82")
        {
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
            }
        }
        addafter("Control 97")
        {
            field("Vendor Invoice No."; Rec."Vendor Invoice No.")
            {
            }
        }
        addafter("Control 10")
        {
            field("Accountability Center"; Rec."Accountability Center")
            {
            }
        }
        addafter("Control 80")
        {
            field("User ID"; Rec."User ID")
            {
            }
            field(Narration; Rec.Narration)
            {
            }
            group("Letter of Credit")
            {
                Caption = 'Letter of Credit';
                Visible = VehicleTradeDocument;
                field("Sys. LC No."; Rec."Sys. LC No.")
                {
                }
                field("LC Amend No."; Rec."LC Amend No.")
                {
                }
            }
        }
        addafter(PurchReceiptLines)
        {
            part(PurchReceiptLinesVehicle; 25006482)
            {
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 72".

        addfirst("Action 45")
        {
            action("<Action1102159009>")
            {
                Caption = '&Undo Receipt';

                trigger OnAction()
                begin
                    //CurrPage.PurchReceiptLines.FORM.UndoReceiptLine;
                end;
            }
        }
        addafter("Action 48")
        {
            action("Print Purchase Receipt")
            {
                Caption = 'Print Purchase Receipt';
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(PurchRcptHeader);
                    REPORT.RUN(50015, TRUE, TRUE, PurchRcptHeader);
                end;
            }
        }
    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        [InDataSet]
        "Veh&SpareTrade": Boolean;


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


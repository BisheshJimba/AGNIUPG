pageextension 50051 pageextension50051 extends "Posted Purchase Credit Memo"
{
    Editable = false;

    //Unsupported feature: Property Modification (Name) on ""Posted Purchase Credit Memo"(Page 140)".

    Caption = 'Posted Debit Note';
    layout
    {
        modify(PurchCrMemoLines)
        {
            Visible = NOT VehicleTradeDocument;
        }
        addafter("Control 14")
        {
            field("Purch. VAT No."; Rec."Purch. VAT No.")
            {
            }
        }
        addafter("Control 10")
        {
            field("Accountability Center"; Rec."Accountability Center")
            {
            }
        }
        addafter("Control 1")
        {
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
        addafter(PurchCrMemoLines)
        {
            part(PurchCrMemoLinesVehicle; 25006514)
            {
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
        }
        addafter("Control 66")
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 47".

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
    {// below code NOT in this version
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
}


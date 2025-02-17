pageextension 50320 pageextension50320 extends "Posted Transfer Shipment"
{
    Editable = Category4;
    Editable = true;
    layout
    {
        modify(TransferShipmentLines)
        {
            Visible = NOT VehicleTradeDocument;
        }
        addafter("Control 14")
        {
            field(Remarks; Rec.Remarks)
            {
            }
            field("Shipped By User"; Rec."Shipped By User")
            {
            }
            field("Document Date"; "Document Date")
            {
                Editable = false;
            }
            field("Total CBM"; "Total CBM")
            {
            }
        }
        addafter(TransferShipmentLines)
        {
            part(TransferShipmentLinesVehicle; 25006474)
            {
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
        }
        addafter("Control 1907468901")
        {
            group(Service)
            {
                field("Document Profile"; Rec."Document Profile")
                {
                }
                field("Source Type"; Rec."Source Type")
                {
                }
                field("Source Subtype"; Rec."Source Subtype")
                {
                }
                field("Source No."; Rec."Source No.")
                {
                }
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 57".


        //Unsupported feature: Property Modification (Image) on "Action 51".

        addafter("Action 52")
        {
            action("Veh.Shipment")
            {
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TransShptHeader.RESET;
                    TransShptHeader.SETRANGE("No.", Rec."No.");
                    REPORT.RUN(33020027, TRUE, TRUE, TransShptHeader);

                end;
            }
        }
    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        TransShptHeader: Record "5744";


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*
    //EDMS >>
      VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
    //EDMS >>
    */
    //end;
}


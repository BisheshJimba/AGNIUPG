pageextension 50322 pageextension50322 extends "Posted Transfer Receipt"
{
    Editable = Category4;
    Editable = true;
    layout
    {
        modify(TransferReceiptLines)
        {
            Visible = NOT VehicleTradeDocument;
        }
        addafter("Control 14")
        {
            field(Remarks; Rec.Remarks)
            {
            }
            field("Received By User"; Rec."Received By User")
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
        addafter(TransferReceiptLines)
        {
            part(TransferReceiptLinesVehicle; 25006475)
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
                    OptionCaption = ' ,,,Service';
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

    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;


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


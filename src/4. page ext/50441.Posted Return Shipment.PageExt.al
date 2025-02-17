pageextension 50441 pageextension50441 extends "Posted Return Shipment"
{
    layout
    {
        modify(ReturnShptLines)
        {
            Visible = NOT VehicleTradeDocument;
        }
        addafter(ReturnShptLines)
        {
            part(ReturnShptLinesVehicle; 25006534)
            {
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
            group("Letter of Credit")
            {
                Caption = 'Letter of Credit';
                Visible = VehAndSpareTrade;
                field("Sys. LC No."; "Sys. LC No.")
                {
                }
                field("LC Amend No."; "LC Amend No.")
                {
                }
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 47".


        //Unsupported feature: Property Modification (RunPageLink) on "CertificateOfSupplyDetails(Action 81)".

    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        VehAndSpareTrade: Boolean;


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*
    //EDMS >>
      VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
    //EDMS >>
    //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
    VehAndSpareTrade := ("Document Profile" = "Document Profile"::"Vehicles Trade") OR
                    ("Document Profile" = "Document Profile"::"Spare Parts Trade");
    //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
    */
    //end;
}


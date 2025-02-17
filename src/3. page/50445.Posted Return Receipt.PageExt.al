pageextension 50445 pageextension50445 extends "Posted Return Receipt"
{
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    Editable = Category4;
    layout
    {
        modify(ReturnRcptLines)
        {
            Visible = NOT VehicleTradeDocument;
        }
        addafter("Control 12")
        {
            field("Invertor Serial No."; "Invertor Serial No.")
            {
            }
        }
        addafter("Control 16")
        {
            field("Phone No."; "Phone No.")
            {
                Editable = false;
                Importance = Additional;
            }
            field("Mobile Phone No."; "Mobile Phone No.")
            {
                Editable = false;
                Importance = Additional;
            }
        }
        addafter(ReturnRcptLines)
        {
            part(ReturnRcptLinesVehicle; 25006545)
            {
                SubPageLink = Document No.=FIELD(No.);
                    Visible = VehicleTradeDocument;
            }
            group("Letter of Credit")
            {
                Caption = 'Letter of Credit';
                Visible = vehandSpareTrade;
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

        //Unsupported feature: Property Modification (RunPageLink) on "Action 78".


        //Unsupported feature: Property Modification (Image) on "Action 49".



        //Unsupported feature: Code Modification on "Action 49.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CurrPage.SETSELECTIONFILTER(ReturnRcptHeader);
        ReturnRcptHeader.PrintRecords(TRUE);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        CurrPage.SETSELECTIONFILTER(ReturnRcptHeader);
        ReturnRcptHeader.PrintRecords(TRUE);
        {
          ReturnRcptHeader.RESET;
          ReturnRcptHeader.SETRANGE("No.","No.");
          REPORT.RUN(33020200,TRUE,TRUE,ReturnRcptHeader);
          }
        */
        //end;
    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        vehandSpareTrade: Boolean;


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*
    //EDMS >>
      VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
    //EDMS >>
    //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
    vehandSpareTrade := ("Document Profile" = "Document Profile"::"Vehicles Trade") OR
                    ("Document Profile" = "Document Profile"::"Spare Parts Trade");
    //** SM 05/24/2013 to make the LC NO. field visible in both vehicle and spare PO****
    */
    //end;
}


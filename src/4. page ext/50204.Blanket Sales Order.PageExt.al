pageextension 50204 pageextension50204 extends "Blanket Sales Order"
{
    //   20.11.2014 EB.P8 MERGE
    layout
    {

        //Unsupported feature: Property Modification (SubPageLink) on "Control 13".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1906127307".

        addafter("Control 1907468901")
        {
            group(Vehicle)
            {
                Caption = 'Vehicle';
                Visible = SparePartDocument;
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 63".

    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        SparePartDocument: Boolean;
        DocumentProfileFilter: Text[250];


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetControlAppearance;
    UpdateShipToBillToGroupVisibility
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    SetControlAppearance;
    UpdateShipToBillToGroupVisibility;
    //EDMS >>
      VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
      SparePartDocument := "Document Profile" = "Document Profile"::"Spare Parts Trade";
    //EDMS >>
    */
    //end;


    //Unsupported feature: Code Modification on "OnNewRecord".

    //trigger OnNewRecord(BelowxRec: Boolean)
    //>>>> ORIGINAL CODE:
    //begin
    /*
    xRec.INIT;
    "Responsibility Center" := UserMgt.GetSalesFilter;
    IF (NOT DocNoVisible) AND ("No." = '') THEN
      SetSellToCustomerFromFilter;
    UpdateShipToBillToGroupVisibility;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5
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
    IF UserMgt.GetSalesFilter <> '' THEN BEGIN
      FILTERGROUP(2);
      SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
      FILTERGROUP(0);
    END;

    SetDocNoVisible;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*


    FilterOnRecord;
    SetDocNoVisible;

    //EDMS >>
      FILTERGROUP(3);
      DocumentProfileFilter := GETFILTER("Document Profile");
      FILTERGROUP(0);
    //EDMS <<
    */
    //end;

    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetSalesFilter();
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


pageextension 50240 pageextension50240 extends "Sales Quote Archive"
{
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    layout
    {
        modify(SalesLinesArchive)
        {

            //Unsupported feature: Property Modification (SubPageLink) on "SalesLinesArchive(Control 98)".

            Visible = NOT VehicleTradeDocument;
        }
        addafter("Control 32")
        {
            field("Vehicle Serial No."; "Vehicle Serial No.")
            {
                Visible = SparePartDocument;
            }
            field(VIN; VIN)
            {
                Visible = SparePartDocument;
            }
            field("Vehicle Registration No."; "Vehicle Registration No.")
            {
            }
            field("Phone No."; "Phone No.")
            {
                Importance = Additional;
            }
            field("Mobile Phone No."; "Mobile Phone No.")
            {
                Importance = Additional;
            }
        }
        addafter(SalesLinesArchive)
        {
            part(SalesLinesArchVeh; 25006551)
            {
                SubPageLink = Document No.=FIELD(No.),
                              Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                              Version No.=FIELD(Version No.);
                Visible = VehicleTradeDocument;
            }
        }
        addafter("Control 62")
        {
            field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
            {
                Visible = SparePartDocument;
            }
            field("Deal Type Code";"Deal Type Code")
            {
                Visible = SparePartDocument;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 117".

    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;
        [InDataSet]
        SparePartDocument: Boolean;


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
        /*
        VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
        SparePartDocument := "Document Profile" = "Document Profile"::"Spare Parts Trade";
        */
    //end;


    //Unsupported feature: Code Insertion on "OnOpenPage".

    //trigger OnOpenPage()
    //begin
        /*
        FilterOnRecord;  //AGNI2017CU8
        */
    //end;

    local procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetSalesFilter();
        IF RespCenterFilter <> '' THEN BEGIN
          FILTERGROUP(2);
            IF UserMgt.DefaultResponsibility THEN
              SETRANGE("Responsibility Center",RespCenterFilter)
          ELSE
              SETRANGE("Accountability Center",RespCenterFilter);
          FILTERGROUP(0);
        END
    end;
}


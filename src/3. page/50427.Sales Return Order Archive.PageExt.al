pageextension 50427 pageextension50427 extends "Sales Return Order Archive"
{
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    layout
    {
        modify(SalesLinesArchive)
        {

            //Unsupported feature: Property Modification (SubPageLink) on "SalesLinesArchive(Control 122)".

            Visible = NOT VehicleTradeDocument;
        }
        addafter("Control 32")
        {
            field("Invertor Serial No."; "Invertor Serial No.")
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
            part(SalesLinesArchiveVehicle; 25006554)
            {
                Visible = VehicleTradeDocument;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 140".

    }

    var
        [InDataSet]
        VehicleTradeDocument: Boolean;


    //Unsupported feature: Code Insertion on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //begin
    /*
    VehicleTradeDocument := "Document Profile" = "Document Profile"::"Vehicles Trade";
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
            Rec.FILTERGROUP(2);
            IF UserMgt.DefaultResponsibility THEN
                Rec.SETRANGE("Responsibility Center", RespCenterFilter)
            ELSE
                Rec.SETRANGE("Accountability Center", RespCenterFilter);
            Rec.FILTERGROUP(0);
        END;
    end;
}


pageextension 50438 pageextension50438 extends "Purchase Return Order Archive"
{
    layout
    {
        modify(PurchLinesArchive)
        {

            //Unsupported feature: Property Modification (SubPageLink) on "PurchLinesArchive(Control 115)".

            Visible = NOT VehicleTradeDocument;
        }
        addafter(PurchLinesArchive)
        {
            part(PurchLinesArchiveVehicle; 25006555)
            {
                Visible = VehicleTradeDocument;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 133".

    }

    var
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
    FilterOnRecord; //AGNI2017CU8
    */
    //end;

    local procedure FilterOnRecord()
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


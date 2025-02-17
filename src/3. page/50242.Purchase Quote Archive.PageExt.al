pageextension 50242 pageextension50242 extends "Purchase Quote Archive"
{
    layout
    {
        modify(PurchLinesArchive)
        {

            //Unsupported feature: Property Modification (SubPageLink) on "PurchLinesArchive(Control 93)".

            Visible = NOT VehicleTradeDocument;
        }
        addafter(PurchLinesArchive)
        {
            part(PurchLinesArchiveVeh; 25006552)
            {
                SubPageLink = Document No.=FIELD(No.),
                              Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                              Version No.=FIELD(Version No.);
                Visible = VehicleTradeDocument;
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 123".

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
        RespCenterFilter := UserMgt.GetPurchasesFilter();
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


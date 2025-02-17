pageextension 50566 pageextension50566 extends "Account Manager Activities"
{
    layout
    {
        addafter("Control 20")
        {
            field("Debit Note"; Rec."Debit Note")
            {
                DrillDownPageID = "Sales Invoice List-(Service)";
            }
            field("Finished Service Jobs"; "Finished Service Jobs")
            {
                DrillDownPageID = "Sales Invoice List-(Service)";
            }
        }
    }

    var
        UserSetup: Record "91";
        UserMgt: Codeunit "5700";


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    RESET;
    IF NOT GET THEN BEGIN
      INIT;
      INSERT;
    END;

    SETFILTER("Due Date Filter",'<=%1',WORKDATE);
    SETFILTER("Overdue Date Filter",'<%1',WORKDATE);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8
    //Agile
    // FilterOnRecord; //removed to show irrespective of responsibilty centers 01.07.2015 ---->Chandra
    //Agile
    */
    //end;

    local procedure FilterOnRecord()
    var
        UserSetup: Record "91";
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetSalesFilter();
        IF RespCenterFilter <> '' THEN BEGIN
            IF UserMgt.DefaultResponsibility THEN
                Rec.SETFILTER("Responsibility Center", RespCenterFilter)
            ELSE
                Rec.SETFILTER("Accountability Center", RespCenterFilter);
        END;
    end;
}


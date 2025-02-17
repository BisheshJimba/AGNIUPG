pageextension 50535 pageextension50535 extends "Config. Package Subform"
{
    actions
    {

        //Unsupported feature: Code Modification on "ExportToExcel(Action 21).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CurrPage.SETSELECTIONFILTER(ConfigPackageTable);
        IF CONFIRM(SelectionConfirmMessage,TRUE) THEN
          ConfigExcelExchange.ExportExcelFromTables(ConfigPackageTable);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        UserSetup.GET(USERID);
        IF NOT UserSetup."Can Edit Employee Card" THEN
          IF ("Table ID" = 5200) OR ("Table ID" = 33020361) OR ("Table ID" = 33020519) OR ("Table ID" = 33020520) OR ("Table ID" = 33020512) OR ("Table ID" = 33020513) THEN
            ERROR('You cannot export this data.');

        #1..3
        */
        //end;
    }

    var
        UserSetup: Record "91";

    var
        CanView: Boolean;
}


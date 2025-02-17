pageextension 50134 pageextension50134 extends "Check Credit Limit"
{
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 25".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 26".

    }
    procedure ServiceHeaderShowWarningEDMS(ServiceHeader: Record "25006145"): Boolean
    var
        ServiceSetup: Record "25006120";
    begin
        ServiceSetup.GET;
        IF ServiceSetup."Credit Warnings" =
           ServiceSetup."Credit Warnings"::"No Warning"
        THEN
            EXIT(FALSE);

        IF ServiceHeader."Currency Code" = '' THEN
            NewOrderAmountLCY := ServiceHeader."Amount Including VAT"
        ELSE
            NewOrderAmountLCY :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY(
                  WORKDATE, ServiceHeader."Currency Code",
                  ServiceHeader."Amount Including VAT", ServiceHeader."Currency Factor"));

        EXIT(ShowWarning(ServiceHeader."Bill-to Customer No.", NewOrderAmountLCY, 0, TRUE));
    end;
}


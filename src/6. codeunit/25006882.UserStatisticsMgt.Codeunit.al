codeunit 25006882 "User Statistics Mgt."
{

    trigger OnRun()
    begin
    end;

    [TryFunction]
    local procedure RegisterEventKPI(KPICode: Code[10]; KPIDescription: Text)
    var
        UserStatisticsKPI: Record "25006882";
        Number1: Decimal;
        UserSetup: Record "91";
    begin
        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserSetup."Register Statistics" THEN BEGIN
                Number1 := 0;
                IF UserStatisticsKPI.GET(TODAY, DELSTR(KPICode + '-' + USERID, 51)) THEN BEGIN
                    EVALUATE(Number1, UserStatisticsKPI."KPI Value");
                    Number1 += 1;
                    UserStatisticsKPI."KPI Value" := FORMAT(Number1);
                    // UserStatisticsKPI.MODIFY;
                END ELSE BEGIN
                    UserStatisticsKPI.INIT;
                    UserStatisticsKPI.Date := TODAY;
                    UserStatisticsKPI."Statistics KPI Code" := DELSTR(KPICode + '-' + USERID, 51);
                    UserStatisticsKPI.Description := KPIDescription;
                    UserStatisticsKPI."KPI Value" := FORMAT(1);
                    UserStatisticsKPI.INSERT;
                END;
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Page, 25006183, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageServiceOrderCardRegisterStatistic(var Rec: Record "25006145")
    var
        UserStatisticsKPI: Record "25006882";
    begin
        IF RegisterEventKPI('SORDC', 'Service Order Card Page') THEN;
    end;

    [EventSubscriber(ObjectType::Page, 21, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageCustomerCardRegisterStatistic(var Rec: Record "18")
    begin
        IF RegisterEventKPI('CUSTC', 'Customer Card Page') THEN;
    end;

    [EventSubscriber(ObjectType::Page, 22, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageCustomerListRegisterStatistic(var Rec: Record "18")
    begin
        IF RegisterEventKPI('CUSTL', 'Customer List Page') THEN;
    end;

    [EventSubscriber(ObjectType::Page, 25006032, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageVehicleCardRegisterStatistic(var Rec: Record "25006005")
    begin
        //IF RegisterEventKPI('VEHIC','Vehicle Card Page') THEN;
    end;

    [EventSubscriber(ObjectType::Page, 25006033, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageVehicleListRegisterStatistic(var Rec: Record "25006005")
    begin
        //IF RegisterEventKPI('VEHIL','Vehicle List Page') THEN;
    end;

    [EventSubscriber(ObjectType::Page, 25006899, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageBookingsRegisterStatistic(var Rec: Record "25006145")
    begin
        IF RegisterEventKPI('BOOKW', 'Booking Worksheet Page') THEN;
    end;

    [EventSubscriber(ObjectType::Page, 5050, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageContactCardRegisterStatistic(var Rec: Record "5050")
    begin
        IF RegisterEventKPI('CONTC', 'Contact Card Page') THEN;
    end;

    [EventSubscriber(ObjectType::Page, 30, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageItemCardRegisterStatistic(var Rec: Record "27")
    begin
        IF RegisterEventKPI('ITEMC', 'Item Card Page') THEN;
    end;

    [EventSubscriber(ObjectType::Page, 5725, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenNonstockCardRegisterStatistic(var Rec: Record "5718")
    begin
        IF RegisterEventKPI('NSTKC', 'Nonstock Card Page') THEN;
    end;

    [EventSubscriber(ObjectType::Page, 25006198, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageServiceQuoteCardRegisterStatistic(var Rec: Record "25006145")
    begin
        IF RegisterEventKPI('SQTEC', 'Service Quote Page') THEN;
    end;

    [EventSubscriber(ObjectType::Page, 41, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageSalesQuoteCardRegisterStatistic(var Rec: Record "36")
    begin
        IF RegisterEventKPI('SLQTC', 'Sales Quote Page') THEN;
    end;

    [EventSubscriber(ObjectType::Page, 42, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageSalesOrderCardRegisterStatistic(var Rec: Record "36")
    begin
        IF RegisterEventKPI('SLORC', 'Sales Order Page') THEN;
    end;

    [EventSubscriber(ObjectType::Page, 50, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPagePurchaseOrderCardRegisterStatistic(var Rec: Record "38")
    begin
        IF RegisterEventKPI('PRCOC', 'Purchase Order Page') THEN;
    end;

    [EventSubscriber(ObjectType::Page, 25006358, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageSchedulerRegisterStatistic(var Rec: Record "25006145")
    begin
        IF RegisterEventKPI('SCHED', 'Service Scheduler Page') THEN;
    end;

    [EventSubscriber(ObjectType::Page, 16, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageChartOfAccountsRegisterStatistic(var Rec: Record "15")
    begin
        IF RegisterEventKPI('CHOAC', 'Cart Of Accounts Page') THEN;
    end;

    [EventSubscriber(ObjectType::Page, 5601, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageFixedAssetListRegisterStatistic(var Rec: Record "5600")
    begin
        IF RegisterEventKPI('FXASL', 'Fixed Asset List Page') THEN;
    end;

    [EventSubscriber(ObjectType::Page, 104, 'OnOpenPageEvent', '', false, false)]
    local procedure OnOpenPageAccountScheduleRegisterStatistic(var Rec: Record "85")
    begin
        IF RegisterEventKPI('ACCSC', 'Account Schedule Page') THEN;
    end;
}


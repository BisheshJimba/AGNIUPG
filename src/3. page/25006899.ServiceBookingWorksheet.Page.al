page 25006899 "Service Booking Worksheet"
{
    DataCaptionExpression = PageCaption;
    PageType = Worksheet;
    PromotedActionCategories = 'Test1,Test2,Test3,Booking,Period';
    SourceTable = Table25006145;
    SourceTableView = WHERE(Document Type=CONST(Booking));

    layout
    {
        area(content)
        {
            group()
            {
                field(SelectedDate; SelectedDateTxt)
                {
                    AssistEdit = true;
                    Caption = 'Selected Date';
                    Editable = false;
                    Lookup = true;

                    trigger OnAssistEdit()
                    var
                        BookingCalendar: Page "25006897";
                    begin
                        BookingCalendar.SetSelectedDate(SelectedDate);
                        BookingCalendar.SetLocationCode(LocationCode);

                        IF BookingCalendar.RUNMODAL = ACTION::OK THEN BEGIN
                            SelectedDate := BookingCalendar.GetSelectedDate();
                            SelectedDateTxt := FORMAT(SelectedDate);
                            CurrPage.ServiceBookingChart.PAGE.SetSelectedDate(SelectedDate);
                            CurrPage.ServiceBookingChart.PAGE.SetLocationCode(LocationCode);
                            CurrPage.ServiceBookingChart.PAGE.UpdateChart;

                            FILTERGROUP(2);
                            SETFILTER("Requested Starting Date", '..%1', SelectedDate);
                            SETFILTER("Requested Finishing Date", '%1..', SelectedDate);
                            SETRANGE("Location Code", LocationCode);
                            FILTERGROUP(0);
                            CurrPage.UPDATE(FALSE);
                        END;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        BookingCalendar: Page "25006897";
                    begin
                        BookingCalendar.SetSelectedDate(SelectedDate);
                        BookingCalendar.SetLocationCode(LocationCode);

                        IF BookingCalendar.RUNMODAL = ACTION::OK THEN BEGIN
                            SelectedDate := BookingCalendar.GetSelectedDate();
                            SelectedDateTxt := FORMAT(SelectedDate);
                            CurrPage.ServiceBookingChart.PAGE.SetSelectedDate(SelectedDate);
                            CurrPage.ServiceBookingChart.PAGE.SetLocationCode(LocationCode);
                            CurrPage.ServiceBookingChart.PAGE.UpdateChart;

                            FILTERGROUP(2);
                            SETFILTER("Requested Starting Date", '..%1', SelectedDate);
                            SETFILTER("Requested Finishing Date", '%1..', SelectedDate);
                            SETRANGE("Location Code", LocationCode);
                            FILTERGROUP(0);
                            CurrPage.UPDATE(FALSE);
                        END;
                    end;
                }
                field(LocationCode; LocationCode)
                {
                    Caption = 'Location Code';

                    trigger OnAssistEdit()
                    var
                        SelectedLocation: Record "14";
                        ServiceBooking: Record "25006145";
                    begin
                        SelectedLocation.SETRANGE("Use As Service Location", TRUE);
                        IF LocationCode <> '' THEN
                            SelectedLocation.GET(LocationCode);

                        IF PAGE.RUNMODAL(PAGE::"Location List", SelectedLocation) = ACTION::LookupOK THEN
                            LocationCode := SelectedLocation.Code;

                        SetPageCaption;
                        FILTERGROUP(2);
                        SETFILTER("Requested Starting Date", '..%1', SelectedDate);
                        SETFILTER("Requested Finishing Date", '%1..', SelectedDate);
                        SETRANGE("Location Code", LocationCode);
                        FILTERGROUP(0);
                        CurrPage.UPDATE(FALSE);

                        CurrPage.ServiceBookingChart.PAGE.SetSelectedDate(SelectedDate);
                        CurrPage.ServiceBookingChart.PAGE.SetLocationCode(LocationCode);
                        CurrPage.ServiceBookingChart.PAGE.UpdateChart;
                    end;

                    trigger OnValidate()
                    begin
                        SetPageCaption;
                        FILTERGROUP(2);
                        SETFILTER("Requested Starting Date", '..%1', SelectedDate);
                        SETFILTER("Requested Finishing Date", '%1..', SelectedDate);
                        SETRANGE("Location Code", LocationCode);
                        FILTERGROUP(0);
                        CurrPage.UPDATE(FALSE);

                        CurrPage.ServiceBookingChart.PAGE.SetSelectedDate(SelectedDate);
                        CurrPage.ServiceBookingChart.PAGE.SetLocationCode(LocationCode);
                        CurrPage.ServiceBookingChart.PAGE.UpdateChart;
                    end;
                }
            }
            repeater()
            {
                field("Requested Starting Date"; "Requested Starting Date")
                {
                }
                field("Requested Starting Time"; "Requested Starting Time")
                {
                }
                field("Requested Finishing Date"; "Requested Finishing Date")
                {
                }
                field("Requested Finishing Time"; "Requested Finishing Time")
                {
                }
                field("Deal Type"; "Deal Type")
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Total Work (Hours)"; "Total Work (Hours)")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                }
                field("Work Status Code"; "Work Status Code")
                {
                    Visible = false;
                }
                field("Due Date"; "Due Date")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    Visible = false;
                }
                field("Service Person"; "Service Person")
                {
                }
                field("No."; "No.")
                {
                    Visible = false;
                }
                field("TCard Container Entry No."; "TCard Container Entry No.")
                {
                    Visible = false;
                }
                field("Booking Resource No."; "Booking Resource No.")
                {
                    Caption = 'Resource No.';
                }
            }
            group()
            {
                part(ServiceBookingChart; 25006898)
                {
                    UpdatePropagation = Both;
                }
            }
        }
        area(factboxes)
        {
            part(; 25006253)
            {
                SubPageLink = Document Type=FIELD(Document Type),
                              No.=FIELD(No.);
                Visible = true;
            }
            part("Vehicle Pictures";25006047)
            {
                Caption = 'Vehicle Pictures';
                SubPageLink = Source Type=CONST(25006005),
                              Source Subtype=CONST(0),
                              Source ID=FIELD(Vehicle Serial No.),
                              Source Ref. No.=CONST(0);
                SubPageView = SORTING(Source Type,Source Subtype,Source ID,Source Ref. No.,No.);
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Booking)
            {
                Caption = 'Booking';
                action(Refresh)
                {
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        CurrPage.ServiceBookingChart.PAGE.SetSelectedDate(SelectedDate);
                        CurrPage.ServiceBookingChart.PAGE.SetLocationCode(LocationCode);
                        CurrPage.ServiceBookingChart.PAGE.UpdateChart;
                    end;
                }
            }
            group(Period)
            {
                Caption = 'Period';
                action(Previous)
                {
                    Image = PreviousSet;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        SelectedDate := SelectedDate - 1;
                        SelectedDateTxt := FORMAT(SelectedDate);
                        FILTERGROUP(2);
                        SETFILTER("Requested Starting Date",'..%1',SelectedDate);
                        SETFILTER("Requested Finishing Date",'%1..',SelectedDate);
                        SETRANGE("Location Code",LocationCode);
                        FILTERGROUP(0);

                        CurrPage.ServiceBookingChart.PAGE.SetSelectedDate(SelectedDate);
                        CurrPage.ServiceBookingChart.PAGE.SetLocationCode(LocationCode);
                        CurrPage.ServiceBookingChart.PAGE.UpdateChart;
                    end;
                }
                action(Next)
                {
                    Image = NextSet;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        SelectedDate := SelectedDate + 1;
                        SelectedDateTxt := FORMAT(SelectedDate);
                        FILTERGROUP(2);
                        SETFILTER("Requested Starting Date",'..%1',SelectedDate);
                        SETFILTER("Requested Finishing Date",'%1..',SelectedDate);
                        SETRANGE("Location Code",LocationCode);
                        FILTERGROUP(0);

                        CurrPage.ServiceBookingChart.PAGE.SetSelectedDate(SelectedDate);
                        CurrPage.ServiceBookingChart.PAGE.SetLocationCode(LocationCode);
                        CurrPage.ServiceBookingChart.PAGE.UpdateChart;
                    end;
                }
            }
        }
        area(navigation)
        {
            group(Booking)
            {
                Caption = 'Booking';
                action("Booking Card")
                {
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page 25006890;
                                    RunPageLink = Document Type=FIELD(Document Type),
                                  No.=FIELD(No.);
                    RunPageMode = View;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        IF RecordModified = TRUE THEN BEGIN
          RecordModified := FALSE;
          CurrPage.ServiceBookingChart.PAGE.SetSelectedDate(SelectedDate);
          CurrPage.ServiceBookingChart.PAGE.SetLocationCode(LocationCode);
          CurrPage.ServiceBookingChart.PAGE.UpdateChart;
        END;
    end;

    trigger OnInit()
    begin
        LocationCode := BookingMgt.GetDefaultLocationCode;
        SelectedDate := WORKDATE;
        SelectedDateTxt := FORMAT(SelectedDate);
        SetPageCaption;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        RecordModified := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Requested Starting Date" := xRec.GETRANGEMAX("Requested Starting Date");
        "Requested Finishing Date" := xRec.GETRANGEMAX("Requested Starting Date");
        "Requested Starting Time" := TIME;
        "Requested Finishing Time" := TIME;
    end;

    trigger OnOpenPage()
    begin
        FILTERGROUP(2);
        SETFILTER("Requested Starting Date",'..%1',SelectedDate);
        SETFILTER("Requested Finishing Date",'%1..',SelectedDate);
        SETRANGE("Location Code",LocationCode);
        FILTERGROUP(0);
        CurrPage.UPDATE(FALSE);
    end;

    var
        LocationCode: Code[20];
        BookingDashboardLbl: Label 'Booking Dashboard';
        PageCaption: Text[255];
        BookingMgt: Codeunit "25006875";
        ChartIsReady: Boolean;
        BookingChartMgt: Codeunit "25006873";
        BusChartBuf: Record "485";
        SelectedDate: Date;
        SelectedDateTxt: Text[10];
        RecordModified: Boolean;

    local procedure SetPageCaption()
    var
        EditModeCaption: Text[20];
        Location: Record "14";
        PageCaptionSep: Text[3];
    begin
        IF LocationCode <> '' THEN
          PageCaptionSep := ' - '
        ELSE
          PageCaptionSep := '';

        IF Location.GET(LocationCode) THEN
            PageCaption := BookingDashboardLbl+PageCaptionSep+Location.Name
          ELSE
            PageCaption := BookingDashboardLbl+PageCaptionSep+LocationCode;
    end;

    [Scope('Internal')]
    procedure GetSelectedDate(): Date
    begin
        EXIT(SelectedDate);
    end;
}


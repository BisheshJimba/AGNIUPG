table 25006398 "Aftersales CRM Chart Setup"
{

    fields
    {
        field(1; "User ID"; Text[132])
        {
            Caption = 'User ID';
        }
        field(2; "Period Length"; Option)
        {
            Caption = 'Period Length';
            OptionCaption = 'Day,Week,Month,Quarter,Year';
            OptionMembers = Day,Week,Month,Quarter,Year;
        }
        field(3; "Show Orders"; Option)
        {
            Caption = 'Show Orders';
            OptionCaption = 'All Orders,Orders Until Today,Delayed Orders';
            OptionMembers = "All Orders","Orders Until Today","Delayed Orders";
        }
        field(4; "Use Work Date as Base"; Boolean)
        {
            Caption = 'Use Work Date as Base';
        }
        field(5; "Value to Calculate"; Option)
        {
            Caption = 'Value to Calculate';
            OptionCaption = 'Amount Excl. VAT,No. of Orders';
            OptionMembers = "Amount Excl. VAT","No. of Orders";
        }
        field(6; "Chart Type"; Option)
        {
            Caption = 'Chart Type';
            OptionCaption = 'Line,Step Line,Stacked Area (%),Stacked Column,Stacked Column (%)';
            OptionMembers = Line,"Step Line","Stacked Area (%)","Stacked Column","Stacked Column (%)";
        }
        field(7; "Latest Order Document Date"; Date)
        {
            AccessByPermission = TableData 110 = R;
            CalcFormula = Max("Posted Serv. Order Header"."Posting Date");
            Caption = 'Latest Order Document Date';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'Updated at %1.';

    [Scope('Internal')]
    procedure GetCurrentSelectionText(): Text[100]
    begin
        EXIT(FORMAT("Show Orders") + '|' +
          FORMAT("Period Length") + '|' +
          FORMAT("Value to Calculate") + '|. (' +
          STRSUBSTNO(Text001, TIME) + ')');
    end;

    [Scope('Internal')]
    procedure GetStartDate(): Date
    var
        StartDate: Date;
    begin
        IF "Use Work Date as Base" THEN
            StartDate := WORKDATE
        ELSE
            StartDate := TODAY;
        IF "Show Orders" = "Show Orders"::"All Orders" THEN BEGIN
            CALCFIELDS("Latest Order Document Date");
            IF "Latest Order Document Date" <> 0D THEN
                StartDate := "Latest Order Document Date";
        END;

        EXIT(StartDate);
    end;

    [Scope('Internal')]
    procedure GetChartType(): Integer
    var
        BusinessChartBuf: Record "485";
    begin
        CASE "Chart Type" OF
            "Chart Type"::Line:
                EXIT(BusinessChartBuf."Chart Type"::Line);
            "Chart Type"::"Step Line":
                EXIT(BusinessChartBuf."Chart Type"::StackedArea100);
            "Chart Type"::"Stacked Area (%)":
                EXIT(BusinessChartBuf."Chart Type"::StackedColumn);
            "Chart Type"::"Stacked Column":
                EXIT(BusinessChartBuf."Chart Type"::StackedColumn100);
        END;
    end;

    [Scope('Internal')]
    procedure SetPeriodLength(PeriodLength: Option)
    begin
        GET(USERID);
        "Period Length" := PeriodLength;
        MODIFY;
    end;

    [Scope('Internal')]
    procedure SetShowOrders(ShowOrders: Integer)
    begin
        GET(USERID);
        "Show Orders" := ShowOrders;
        MODIFY;
    end;

    [Scope('Internal')]
    procedure SetValueToCalcuate(ValueToCalc: Integer)
    begin
        GET(USERID);
        "Value to Calculate" := ValueToCalc;
        MODIFY;
    end;

    [Scope('Internal')]
    procedure SetChartType(ChartType: Integer)
    begin
        GET(USERID);
        "Chart Type" := ChartType;
        MODIFY;
    end;
}


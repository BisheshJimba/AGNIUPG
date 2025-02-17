table 25006200 "Service MTD Chart Setup"
{

    fields
    {
        field(10; "User ID"; Text[132])
        {
            Caption = 'User ID';
        }
        field(20; "Period Length"; Option)
        {
            Caption = 'Period Length';
            OptionCaption = 'Day,Week,Month,Quarter,Year';
            OptionMembers = Day,Week,Month,Quarter,Year;
        }
        field(30; "Use Work Date as Base"; Boolean)
        {
            Caption = 'Use Work Date as Base';
        }
        field(40; "Value to Calculate"; Option)
        {
            Caption = 'Value to Calculate';
            OptionCaption = 'Amount,Quantity,Percent';
            OptionMembers = Amount,Quantity,Percent;
        }
        field(50; "Chart Type"; Option)
        {
            Caption = 'Chart Type';
            OptionCaption = 'Line,Step Line,Column';
            OptionMembers = Line,"Step Line",Column;
        }
        field(60; Location; Code[10])
        {
            Caption = 'Location';
            TableRelation = Location;
        }
        field(70; "Service Advisor"; Code[10])
        {
            Caption = 'Service Advisor';
            TableRelation = Salesperson/Purchaser;
        }
        field(80;Resource;Code[20])
        {
            Caption = 'Resource';
        }
        field(90;"Group By";Option)
        {
            Caption = 'Group By';
            OptionCaption = 'Total,Location,Service Advisor,Resource';
            OptionMembers = Total,Location,"Service Advisor",Resource;
        }
        field(100;"Start Date";Date)
        {
            Caption = 'Start Date';
        }
        field(110;"End Date";Date)
        {
            Caption = 'End Date';
        }
    }

    keys
    {
        key(Key1;"User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        YearTxt: Label 'Year';
        QuarterTxt: Label 'Quarter';

    [Scope('Internal')]
    procedure GetCurrentSelectionText(): Text[100]
    var
        LocationTxt: Text;
        ServicePersonTxt: Text;
        ResourceTxt: Text;
    begin
        LocationTxt := '';
        IF GetLocation <> '' THEN
          LocationTxt := FORMAT(GetLocation) + ' | ';
        ServicePersonTxt := '';
        IF GetServicePerson <>'' THEN
          ServicePersonTxt := FORMAT(GetServicePerson) + ' | ';
        ResourceTxt := '';
        IF GetResource <> '' THEN
          ResourceTxt := FORMAT(GetResource) + ' | ';

        EXIT(LocationTxt +
          ServicePersonTxt +
          ResourceTxt +
          GetPeriodText);
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
            EXIT(BusinessChartBuf."Chart Type"::StepLine);
          "Chart Type"::Column:
            EXIT(BusinessChartBuf."Chart Type"::Column);
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

    [Scope('Internal')]
    procedure GetLocation(): Code[10]
    begin
        EXIT(Location);
    end;

    [Scope('Internal')]
    procedure GetServicePerson(): Code[10]
    begin
        EXIT("Service Advisor");
    end;

    [Scope('Internal')]
    procedure GetResource(): Code[20]
    begin
        EXIT(Resource);
    end;

    [Scope('Internal')]
    procedure GetStartDate(Period: Option " ",Next,Previos): Date
    var
        StartDate: Date;
    begin
        CASE Period OF
          Period::" ":
            StartDate := CurrDate;
          Period::Next:
            BEGIN
              StartDate := AdjustedStartDate(CALCDATE('<1'+GetPeriodLength+'>',"Start Date"));
            END;
          Period::Previos:
            BEGIN
              StartDate := AdjustedStartDate(CALCDATE('<-1'+GetPeriodLength+'>',"Start Date"));
            END;
        END;
        EXIT(StartDate);
    end;

    local procedure GetPeriodLength(): Text[1]
    begin
        CASE "Period Length" OF
          "Period Length"::Day:
            EXIT('D');
          "Period Length"::Week:
            EXIT('W');
          "Period Length"::Month:
            EXIT('M');
          "Period Length"::Quarter:
            EXIT('Q');
          "Period Length"::Year:
            EXIT('Y');
        END;
    end;

    local procedure CurrDate(): Date
    begin
        IF "Use Work Date as Base" THEN
          EXIT(WORKDATE)
        ELSE
          EXIT(TODAY);
    end;

    local procedure AdjustedStartDate(StartDatePar: Date): Date
    begin
        CASE "Period Length" OF
          "Period Length"::Day:
            EXIT(StartDatePar);
          "Period Length"::Week:
            BEGIN
              IF CALCDATE('<CW>',StartDatePar) > CurrDate THEN
                EXIT(CurrDate)
              ELSE
                EXIT(CALCDATE('<CW>',StartDatePar));
            END;
          "Period Length"::Month:
            BEGIN
              IF CALCDATE('<CM>',StartDatePar) > CurrDate THEN
                EXIT(CurrDate)
              ELSE
                EXIT(CALCDATE('<CM>',StartDatePar));
            END;
          "Period Length"::Quarter:
            BEGIN
              IF CALCDATE('<CQ>',StartDatePar) > CurrDate THEN
                EXIT(CurrDate)
              ELSE
                EXIT(CALCDATE('<CQ>',StartDatePar));
            END;
          "Period Length"::Year:
            BEGIN
              IF CALCDATE('<CY>',StartDatePar) > CurrDate THEN
                EXIT(CurrDate)
              ELSE
                EXIT(CALCDATE('<CY>',StartDatePar));
            END;
        END;
    end;

    local procedure GetPeriodText(): Text
    begin
        CASE "Period Length" OF
          "Period Length"::Day:
            EXIT(FORMAT("Start Date",0,' <Day> <Month Text> <Year4> '));
          "Period Length"::Week:
            EXIT(FORMAT("Start Date"-7,0,' <Day> <Month Text> <Year4> ') + FORMAT("Start Date",0,' - <Day> <Month Text> <Year4> '));
          "Period Length"::Month:
            EXIT(FORMAT("Start Date",0,' <Month Text> <Year4> '));
          "Period Length"::Quarter:
            EXIT(QuarterTxt + FORMAT("Start Date",0,' <Quarter> ') + YearTxt + FORMAT("Start Date",0,' <Year4>'));
          "Period Length"::Year:
            EXIT(YearTxt + FORMAT("Start Date",0,' <Year4>'));
        END;
    end;

    [Scope('Internal')]
    procedure GetEndDate(StartDate: Date): Date
    begin
        EXIT(CALCDATE('<C' + GetPeriodLength + '-1' + GetPeriodLength + '+1D>',StartDate));
    end;
}


table 25006203 "Res. Performance Chart Setup"
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
            OptionCaption = 'Amount,Quantity';
            OptionMembers = Amount,Quantity;
        }
        field(50; "Chart Type"; Option)
        {
            Caption = 'Chart Type';
            OptionCaption = 'Line,Step Line,Column,StackedColumn';
            OptionMembers = Line,"Step Line",Column,StackedColumn;
        }
        field(60; Location; Code[10])
        {
            Caption = 'Location';
            TableRelation = Location;
        }
        field(70; "Service Person"; Code[10])
        {
            Caption = 'Service Advisor';
            TableRelation = Salesperson/Purchaser;
        }
        field(80;"Resource No.";Code[20])
        {
        }
        field(90;"Start Date";Date)
        {
            Caption = 'Start Date';
        }
        field(100;"End Date";Date)
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
        Text001: Label 'Updated at %1.';

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
          FORMAT(GetStartDate(0)) + ' | ' +
          FORMAT("Period Length"));
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
          "Chart Type"::StackedColumn:
            EXIT(BusinessChartBuf."Chart Type"::StackedColumn);
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
        EXIT("Service Person");
    end;

    [Scope('Internal')]
    procedure GetResource(): Code[20]
    begin
        EXIT("Resource No.");
    end;

    local procedure CurrDate(): Date
    begin
        IF "Use Work Date as Base" THEN
          EXIT(WORKDATE)
        ELSE
          EXIT(TODAY);
    end;

    local procedure GetPeriodLength(): Text[1]
    begin
        CASE "Period Length" OF
          "Period Length"::Day:
            EXIT('W');
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

    [Scope('Internal')]
    procedure GetStartDate(Period: Option " ",Next,Previos): Date
    var
        StartDate: Date;
    begin
        CASE Period OF
          Period::" ":
            BEGIN
              StartDate := CurrDate;
              IF "Period Length" = "Period Length"::Day THEN
                StartDate := CALCDATE('<WD7>',CurrDate);
            END;
          Period::Next:
            BEGIN
              StartDate := CALCDATE('<1'+GetPeriodLength+'>',"Start Date");
            END;
          Period::Previos:
            BEGIN
              StartDate := CALCDATE('<-1'+GetPeriodLength+'>',"Start Date");
            END;
        END;
        EXIT(StartDate);
    end;
}


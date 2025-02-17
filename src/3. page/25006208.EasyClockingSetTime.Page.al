page 25006208 "Easy Clocking Set Time"
{
    Caption = 'Set Time';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = StandardDialog;
    SourceTable = Table2000000026;

    layout
    {
        area(content)
        {
            field(CustomDate; CustomDate)
            {
                Caption = 'Custom Date';
            }
            field(CustomTime; CustomTime)
            {
                Caption = 'Custom Time';
            }
        }
    }

    actions
    {
    }

    var
        CustomDate: Date;
        CustomTime: Time;

    [Scope('Internal')]
    procedure GetCustomDateTime(var CustomDateToGet: Date; var CustomTimeToGet: Time)
    begin
        CustomDateToGet := CustomDate;
        CustomTimeToGet := CustomTime;
    end;

    [Scope('Internal')]
    procedure SetCustomDateTime(CustomDateToSet: Date; CustomTimeToSet: Time)
    begin
        CustomDate := CustomDateToSet;
        CustomTime := CustomTimeToSet;
    end;
}


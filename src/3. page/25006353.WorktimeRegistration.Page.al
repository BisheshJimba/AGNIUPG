page 25006353 "Worktime Registration"
{
    Caption = 'Worktime Registration';
    PageType = Card;
    SourceTable = Table156;

    layout
    {
        area(content)
        {
            field("No."; "No.")
            {
                Caption = 'Resource No.';
                Editable = false;
            }
            field(Name; Name)
            {
                Editable = false;
            }
            field(DatetimeMgt.Datetime2Text(CurrDateTime);
                DatetimeMgt.Datetime2Text(CurrDateTime))
            {
                Caption = 'Date-Time';
            }
            field(Status; Status)
            {
                Caption = 'Operation';
                Editable = false;
            }
            field(SchedulePassword; SchedulePassword)
            {
                Caption = 'Password';
                ExtendedDatatype = Masked;
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN BEGIN
            ServSchedMgt.CompareSchedulePassword("No.", SchedulePassword);
            CASE Status OF
                Status::Start:
                    ServSchedMgt.ProcessStartWorkday("No.", CurrDateTime);
                Status::Finish:
                    ServSchedMgt.ProcessEndWorkday("No.", CurrDateTime);
            END;
        END;
    end;

    var
        ServSchedMgt: Codeunit "25006201";
        DatetimeMgt: Codeunit "25006012";
        ResourceNo: Code[20];
        SchedulePassword: Text[20];
        Status: Option Start,Finish;
        FinishStatus: Option Finished,"On Hold";
        CurrDateTime: Decimal;

    [Scope('Internal')]
    procedure SetParam(ResourceNo1: Code[20]; CurrDateTime1: Decimal; Status1: Option Start,"End")
    begin
        SETRANGE("No.", ResourceNo1);
        CurrDateTime := CurrDateTime1;
        Status := Status1;
    end;
}


page 25006562 "Power BI Dates"
{
    Caption = 'Power BI Dates';
    PageType = List;
    SourceTable = Table2000000007;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; "Period Start")
                {
                    Caption = 'Date';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        CurrDate: Date;
    begin
        SETRANGE("Period Type", "Period Type"::Date);
        IF UPPERCASE(COPYSTR(COMPANYNAME, 1, 6)) = 'CRONUS' THEN
            CurrDate := DMY2DATE(26, 1, 2017)
        ELSE
            CurrDate := TODAY();

        SETRANGE(Rec."Period Start", DMY2DATE(1, 1, DATE2DMY(CurrDate, 3) - 1), DMY2DATE(31, 12, DATE2DMY(CurrDate, 3)));
    end;
}


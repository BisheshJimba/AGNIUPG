page 25006296 "Service Mechanic Time Qty."
{

    layout
    {
        area(content)
        {
            group()
            {
                field(TimeQty; TimeQty)
                {
                    Caption = 'Enter Time Quantity';
                }
            }
        }
    }

    actions
    {
    }

    var
        TimeQty: Decimal;

    [Scope('Internal')]
    procedure GetTimeQty(): Decimal
    begin
        EXIT(TimeQty)
    end;
}


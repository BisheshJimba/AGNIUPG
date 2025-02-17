pageextension 50520 pageextension50520 extends "Trailing Sales Orders Chart"
{
    actions
    {
        modify(OrdersUntilToday)
        {
            ToolTip = 'View not fully posted sales orders with document dates up until today''sÙÙ date.';
        }
        modify(DelayedOrders)
        {
            ToolTip = 'View not fully posted sales orders with shipment dates that are before today''sÙÙ date.';
        }
    }
}


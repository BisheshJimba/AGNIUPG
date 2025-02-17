pageextension 50067 pageextension50067 extends "Sales Statistics"
{
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    layout
    {
        addafter(InvDiscountAmount)
        {
            field("Total Line Discount Amount"; "Total Line Discount Amount")
            {
            }
        }
    }

    var
        DiscAmount: Decimal;
        SalesLine5: Record "37";
}


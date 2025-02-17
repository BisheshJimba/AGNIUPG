page 33020224 "Coupon List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = Table33020177;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Coupon Code"; "Coupon Code")
                {
                }
                field("Registration Date"; "Registration Date")
                {
                }
                field("Petrol Pump Code"; "Petrol Pump Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}


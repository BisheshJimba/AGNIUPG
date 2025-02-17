page 33020219 "Vehicle Fuel Expense Lines"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = Table33020176;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Coupon Code"; "Coupon Code")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Make Code"; "Make Code")
                {
                    Visible = false;
                }
                field("Model Code"; "Model Code")
                {
                    Visible = false;
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("DRP No./ARE1 No."; "DRP No./ARE1 No.")
                {
                }
                field("Engine No."; "Engine No.")
                {
                    Visible = false;
                }
                field("Quantity (Ltr.)"; "Quantity (Ltr.)")
                {
                }
                field("Fuel Type"; "Fuel Type")
                {
                }
            }
        }
    }

    actions
    {
    }
}


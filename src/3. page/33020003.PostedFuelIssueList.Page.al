page 33020003 "Posted Fuel Issue List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33019967;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Coupon No."; "Issued Coupon No.")
                {
                    Caption = 'Coupon No.';
                }
                field("No."; "No.")
                {
                    Caption = 'System Entry No.';
                }
                field("VIN (Chasis No.)"; "VIN (Chasis No.)")
                {
                }
                field("Registration No."; "Registration No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}


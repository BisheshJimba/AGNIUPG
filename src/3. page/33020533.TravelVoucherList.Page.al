page 33020533 "Travel Voucher List"
{
    CardPageID = "Travel Voucher Page";
    PageType = List;
    SourceTable = Table33020426;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Travel Order Form No."; "Travel Order Form No.")
                {
                }
                field("Travelr's ID No."; "Travelr's ID No.")
                {
                }
                field("Traveler's Name"; "Traveler's Name")
                {
                }
                field(Designation; Designation)
                {
                    Visible = false;
                }
                field(Department; Department)
                {
                }
            }
        }
    }

    actions
    {
    }
}


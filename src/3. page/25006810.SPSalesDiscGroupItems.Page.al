page 25006810 "SP Sales Disc. Group Items"
{
    Caption = 'SP Sales Disc. Group Items';
    PageType = List;
    SourceTable = Table25006733;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Sales Disc. Group Code"; "Sales Disc. Group Code")
                {
                    Visible = false;
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field("Max. Discount %"; "Max. Discount %")
                {
                }
            }
        }
    }

    actions
    {
    }
}


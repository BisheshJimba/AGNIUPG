page 25006807 "General Stockkeeping Unit Card"
{
    Caption = 'General Stockkeeping Unit Card';
    PageType = Card;
    SourceTable = Table25006731;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Item Category Code"; "Item Category Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
                field("Special Equipment Code"; "Special Equipment Code")
                {
                }
                field("Put-away Template Code"; "Put-away Template Code")
                {
                }
                field("Phys Invt Counting Period Code"; "Phys Invt Counting Period Code")
                {
                }
                field("Last Counting Period Update"; "Last Counting Period Update")
                {
                }
                field("Next Counting Period"; "Next Counting Period")
                {
                }
                field("Use Cross-Docking"; "Use Cross-Docking")
                {
                }
            }
            group(Planning)
            {
                Caption = 'Planning';
                field("Replenishment System"; "Replenishment System")
                {
                }
                field("Reordering Policy"; "Reordering Policy")
                {
                }
                group(Purchase)
                {
                    Caption = 'Purchase';
                    field("Vendor No."; "Vendor No.")
                    {
                    }
                    field("Lead Time Calculation"; "Lead Time Calculation")
                    {
                    }
                }
                group(Transfer)
                {
                    Caption = 'Transfer';
                    field("Transfer-from Code"; "Transfer-from Code")
                    {
                    }
                }
            }
        }
    }

    actions
    {
    }
}


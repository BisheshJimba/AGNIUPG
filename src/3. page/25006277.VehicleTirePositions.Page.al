page 25006277 "Vehicle Tire Positions"
{
    Caption = 'Vehicle Tire Positions';
    PageType = List;
    SourceTable = Table25006179;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field(Available; Available)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Position")
            {
                Caption = '&Position';
                action("Tire &Entries")
                {
                    Caption = 'Tire &Entries';
                    Image = LedgerEntries;
                    RunObject = Page 25006269;
                    RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                  Vehicle Axle Code=FIELD(Axle Code),
                                  Tire Position Code=FIELD(Code);
                }
            }
        }
    }
}


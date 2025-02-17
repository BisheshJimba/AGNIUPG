page 33020113 "Scheme Vehicle Tracking"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = Table33019875;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field(Status; Status)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Family Details")
            {
                Caption = 'Family Details';
                Image = Detail;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 33020114;
                RunPageLink = Membership No.=FIELD(Vehicle Serial No.);
            }
        }
    }

    var
        [InDataSet]
        AmountEditable: Boolean;
}


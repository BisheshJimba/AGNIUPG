page 33019901 "Battery Warranty List"
{
    PageType = List;
    SourceTable = Table33019887;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Battery Type"; "Battery Type")
                {
                }
                field("Vehicle Type"; "Vehicle Type")
                {
                }
                field("Month From"; "Month From")
                {
                }
                field("Month To"; "Month To")
                {
                }
                field(Warranty; Warranty)
                {
                    Caption = 'Warranty Percent';
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
    }
}


page 25006285 "Vehicle Axle List"
{
    Caption = 'Vehicle Axle List';
    PageType = List;
    SourceTable = Table25006178;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
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


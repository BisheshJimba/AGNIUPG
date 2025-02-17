page 25006044 "Vehicle Interiors"
{
    Caption = 'Vehicle Interiors';
    PageType = List;
    PopulateAllFields = true;
    SourceTable = Table25006052;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Code; Code)
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}


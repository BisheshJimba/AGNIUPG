page 33020152 "Vehicle Interested Lists"
{
    PageType = List;
    SourceTable = Table33020151;
    SourceTableView = ORDER(Ascending)
                      WHERE(Used For=CONST(PVInfo));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Make; Make)
                {
                }
                field("Model No."; "Model No.")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Model Version Name"; "Model Version Name")
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


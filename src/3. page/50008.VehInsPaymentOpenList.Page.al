page 50008 "Veh. Ins. Payment Open List"
{
    CardPageID = "Vehicle Insurance Payment Card";
    PageType = List;
    SourceTable = Table33020169;
    SourceTableView = WHERE(Posted = FILTER(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Insurance Company Code"; "Insurance Company Code")
                {
                }
                field("Insurance Company Name"; "Insurance Company Name")
                {
                }
                field("Premium Amount"; "Premium Amount")
                {
                }
                field("Premium Amount Inc. VAT"; "Premium Amount Inc. VAT")
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


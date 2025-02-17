page 50009 "Posted Veh. Ins. Payment List"
{
    CardPageID = "Vehicle Insurance Payment Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020169;
    SourceTableView = WHERE(Posted = FILTER(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Insurance Company Code"; "Insurance Company Code")
                {
                }
                field("Insurance Company Name"; "Insurance Company Name")
                {
                }
                field(Description; Description)
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Premium Amount"; "Premium Amount")
                {
                }
                field("Premium Amount Inc. VAT"; "Premium Amount Inc. VAT")
                {
                }
                field(OrderCreated; OrderCreated)
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


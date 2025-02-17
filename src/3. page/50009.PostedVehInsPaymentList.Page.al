page 50009 "Posted Veh. Ins. Payment List"
{
    CardPageID = "Vehicle Insurance Payment Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = 33020169;
    SourceTableView = WHERE(Posted = FILTER(True));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Insurance Company Code"; Rec."Insurance Company Code")
                {
                }
                field("Insurance Company Name"; Rec."Insurance Company Name")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Premium Amount"; Rec."Premium Amount")
                {
                }
                field("Premium Amount Inc. VAT"; "Premium Amount Inc. VAT")
                {
                }
                field(OrderCreated; Rec.OrderCreated)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Notes; Notes)
            {
            }
        }
    }

    actions
    {
    }
}


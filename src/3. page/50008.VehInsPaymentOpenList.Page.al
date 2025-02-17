page 50008 "Veh. Ins. Payment Open List"
{
    CardPageID = "Vehicle Insurance Payment Card";
    PageType = List;
    SourceTable = "Ins. Payment Memo Header";
    SourceTableView = WHERE(Posted = FILTER(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Insurance Company Code"; Rec."Insurance Company Code")
                {
                }
                field("Insurance Company Name"; Rec."Insurance Company Name")
                {
                }
                field("Premium Amount"; Rec."Premium Amount")
                {
                }
                field("Premium Amount Inc. VAT"; "Premium Amount Inc. VAT")
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


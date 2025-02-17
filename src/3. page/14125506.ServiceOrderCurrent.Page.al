page 14125506 "Service Order Current"
{
    AutoSplitKey = true;
    Editable = false;
    PageType = ListPart;
    SourceTable = Table14125607;
    SourceTableView = WHERE(Past Invoice=CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                }
                field("Line Type"; "Line Type")
                {
                }
                field("No."; "No.")
                {
                }
                field(Descrption; Descrption)
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Qunatity; Qunatity)
                {
                }
                field("Line Amt. Inc VAT"; "Line Amt. Inc VAT")
                {
                }
            }
        }
    }

    actions
    {
    }
}


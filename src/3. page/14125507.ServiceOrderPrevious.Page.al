page 14125507 "Service Order Previous"
{
    AutoSplitKey = true;
    Editable = false;
    PageType = ListPart;
    SourceTable = Table14125607;
    SourceTableView = WHERE(Past Invoice=CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posted Service Order No."; "Posted Service Order No.")
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


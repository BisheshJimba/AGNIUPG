page 33020502 "Tax Setup Lines"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = Table33020506;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Start Amount"; "Start Amount")
                {
                }
                field("End Amount"; "End Amount")
                {
                }
                field("Tax Rate"; "Tax Rate")
                {
                }
            }
        }
    }

    actions
    {
    }
}


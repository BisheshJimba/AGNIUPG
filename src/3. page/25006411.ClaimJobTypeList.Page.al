page 25006411 "Claim Job Type List"
{
    Caption = 'Claim Job Type List';
    PageType = List;
    SourceTable = Table25006409;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field(Comment; Comment)
                {
                }
            }
        }
    }

    actions
    {
    }
}


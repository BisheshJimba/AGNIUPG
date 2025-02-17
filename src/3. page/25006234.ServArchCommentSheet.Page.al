page 25006234 "Serv. Arch. Comment Sheet"
{
    Caption = 'Comment Sheet';
    Editable = false;
    PageType = List;
    SourceTable = Table25006171;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Date; Date)
                {
                }
                field(Code; Code)
                {
                    Visible = false;
                }
                field(Comment; Comment)
                {
                }
                field("Comment Type Code"; "Comment Type Code")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}


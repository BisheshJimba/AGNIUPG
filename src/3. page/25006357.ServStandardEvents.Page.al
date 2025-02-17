page 25006357 "Serv. Standard Events"
{
    Caption = 'Service Standard Events';
    PageType = List;
    SourceTable = Table25006272;

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
                field("Description 2"; "Description 2")
                {
                    Visible = false;
                }
                field("Group Code"; "Group Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}


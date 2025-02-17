page 25006859 "Lost Sales Reasons"
{
    Caption = 'Lost Sales Reasons';
    PageType = List;
    SourceTable = Table25006748;

    layout
    {
        area(content)
        {
            repeater()
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
            }
        }
    }

    actions
    {
    }
}


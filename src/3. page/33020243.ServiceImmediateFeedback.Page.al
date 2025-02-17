page 33020243 "Service Immediate Feedback"
{
    PageType = List;
    SourceTable = Table33020243;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Question No."; "Question No.")
                {
                    Editable = false;
                }
                field(Question; Question)
                {
                    Enabled = false;
                }
                field("Filled By"; "Filled By")
                {
                }
                field(Answer; Answer)
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


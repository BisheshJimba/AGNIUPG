page 33019861 "Application Induct Checklist"
{
    PageType = ListPart;
    SourceTable = Table33020375;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Applicant No."; "Applicant No.")
                {
                }
                field(Checklist; Checklist)
                {
                }
                field(Submitted; Submitted)
                {
                }
                field("Submitted By"; "Submitted By")
                {
                    Editable = false;
                }
                field("Submitted Datetime"; "Submitted Datetime")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}


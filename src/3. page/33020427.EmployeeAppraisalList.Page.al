page 33020427 "Employee-Appraisal List"
{
    Editable = true;
    PageType = List;
    SourceTable = Table5200;
    SourceTableView = WHERE(Status = FILTER(Confirmed | Probation));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Full Name"; "Full Name")
                {
                    Editable = false;
                }
                field("Department Name"; "Department Name")
                {
                    Editable = false;
                }
                field("Branch Name"; "Branch Name")
                {
                    Editable = false;
                }
                field("First Appraisal ID"; "First Appraisal ID")
                {
                    Editable = true;
                    Enabled = true;
                }
                field("First Appraiser"; "First Appraiser")
                {
                }
                field("Second Appraisal ID"; "Second Appraisal ID")
                {
                }
                field("Second Appraiser"; "Second Appraiser")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ew)
            {
                Caption = 'ew';
            }
        }
    }
}


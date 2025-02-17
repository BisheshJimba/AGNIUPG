page 33019816 "NCHL-NPI Approval Workflows"
{
    CardPageID = "NCHL-NPI Approval Workflow";
    Editable = false;
    PageType = List;
    SourceTable = Table33019815;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Amount Filter"; "Amount Filter")
                {
                    Visible = false;
                }
                field("Source Code"; "Source Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}


page 33020454 "Posted Outsource Staff Lists"
{
    CardPageID = "Outsource Staff Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020404;
    SourceTableView = WHERE(Posted = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Name)
                {
                }
                field(Company; Company)
                {
                }
                field(Service; Service)
                {
                }
                field("Contract ID"; "Contract ID")
                {
                }
                field("AMN No."; "AMN No.")
                {
                }
                field("Effective Date"; "Effective Date")
                {
                }
                field(Premises; Premises)
                {
                }
                field("No."; "No.")
                {
                }
                field(Type; Type)
                {
                }
                field(Deployment; Deployment)
                {
                }
                field(Category; Category)
                {
                }
                field("Rate / Month"; "Rate / Month")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
    }
}


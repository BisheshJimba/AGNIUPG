page 33020453 "Outsource Staff Lists"
{
    CardPageID = "Outsource Staff Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020404;
    SourceTableView = WHERE(Posted = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Outsource No."; "Outsource No.")
                {
                }
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


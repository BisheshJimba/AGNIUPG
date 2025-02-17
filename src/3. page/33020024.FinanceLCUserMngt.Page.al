page 33020024 "Finance & LC User Mngt."
{
    PageType = List;
    SourceTable = Table91;
    SourceTableView = WHERE(User Department=CONST(Finance));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; "User ID")
                {
                }
                field("Default Location"; "Default Location")
                {
                }
                field("Default Responsibility Center"; "Default Responsibility Center")
                {
                }
                field("LC Approval Authority"; "LC Approval Authority")
                {
                }
                field("Approver ID"; "Approver ID")
                {
                }
                field(Substitute; Substitute)
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
            }
        }
    }

    actions
    {
    }
}


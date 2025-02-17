page 33019997 "Fuel & Courier User Mngt."
{
    PageType = List;
    SourceTable = Table91;
    SourceTableView = WHERE(User Department=CONST(Admin));

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
                field("Fuel Issue Limit"; "Fuel Issue Limit")
                {
                }
                field("Fuel Approval"; "Fuel Approval")
                {
                }
                field("Fuel Document Print Authority"; "Fuel Document Print Authority")
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


page 33020186 "Vehicle Division User Mngt"
{
    PageType = List;
    SourceTable = Table91;
    SourceTableView = WHERE(User Department=CONST(Vehicle));

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


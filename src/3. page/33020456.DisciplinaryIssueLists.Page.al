page 33020456 "Disciplinary Issue Lists"
{
    CardPageID = "Disciplinary Issue Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020405;
    SourceTableView = WHERE(Posted = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Code"; "Employee Code")
                {
                }
                field(Name; Name)
                {
                }
                field(Designation; Designation)
                {
                }
                field(Branch; Branch)
                {
                }
                field("Issue Reported Date (AD)"; "Issue Reported Date (AD)")
                {
                }
                field(Issue; Issue)
                {
                }
                field(Status; Status)
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


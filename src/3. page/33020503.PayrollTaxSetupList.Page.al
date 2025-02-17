page 33020503 "Payroll Tax Setup List"
{
    CardPageID = "Payroll Tax Setup";
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020505;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Effective from"; "Effective from")
                {
                }
                field("Effective to"; "Effective to")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            systempart(; Links)
            {
            }
        }
    }

    actions
    {
    }
}


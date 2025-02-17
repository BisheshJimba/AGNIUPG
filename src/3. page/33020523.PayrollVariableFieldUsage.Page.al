page 33020523 "Payroll Variable Field Usage"
{
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table33020517;
    SourceTableView = SORTING(Variable Field Code);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table No."; "Table No.")
                {
                }
                field("Field No."; "Field No.")
                {
                }
                field("Variable Field Code"; "Variable Field Code")
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


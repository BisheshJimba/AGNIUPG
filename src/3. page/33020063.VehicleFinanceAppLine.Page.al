page 33020063 "Vehicle Finance App. Line"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020074;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Installment No."; "Installment No.")
                {
                }
                field("EMI Mature Date"; "EMI Mature Date")
                {
                }
                field("Calculated Principal"; "Calculated Principal")
                {
                }
                field("Calculated Interest"; "Calculated Interest")
                {
                }
                field("EMI Amount"; "EMI Amount")
                {
                }
                field(Balance; Balance)
                {
                }
            }
        }
    }

    actions
    {
    }
}


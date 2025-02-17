page 33020020 "LC Bank Cr. Limit Details"
{
    PageType = List;
    SourceTable = Table33020019;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Utilized Amount"; "Utilized Amount")
                {
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                }
                field("Utilized Amount Amended"; "Utilized Amount Amended")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            systempart(; MyNotes)
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


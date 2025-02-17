page 33020070 "Loan Status Setup"
{
    PageType = List;
    SourceTable = Table33020067;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("From Days"; "From Days")
                {
                }
                field("To Days"; "To Days")
                {
                }
                field("Loan Status"; "Loan Status")
                {
                }
            }
        }
    }

    actions
    {
    }
}


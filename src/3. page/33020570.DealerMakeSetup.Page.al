page 33020570 "Dealer Make Setup"
{
    PageType = ListPart;
    SourceTable = Table33020429;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; "Customer No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}


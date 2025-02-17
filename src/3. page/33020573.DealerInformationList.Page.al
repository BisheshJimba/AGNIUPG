page 33020573 "Dealer Information List"
{
    CardPageID = "Dealer Information Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020428;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field(Active; Active)
                {
                }
                field("Activation Date"; "Activation Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}


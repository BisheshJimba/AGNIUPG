page 33020110 "Value Added Services"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = Table33019871;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
                field("Valid Quantity"; "Valid Quantity")
                {
                }
                field("Utilised Quantity"; "Utilised Quantity")
                {
                    Editable = false;
                }
                field("Balance Quantity"; "Valid Quantity" - "Utilised Quantity")
                {
                    Caption = 'Balance Quantity';
                }
            }
        }
    }

    actions
    {
    }
}


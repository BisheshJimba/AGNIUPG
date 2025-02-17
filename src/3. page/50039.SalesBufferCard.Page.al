page 50039 "Sales Buffer Card"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = Table50021;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Sales Order Created"; "Sales Order Created")
                {
                }
            }
            part(; 50041)
            {
                SubPageLink = Document No.=FIELD(No.);
            }
        }
    }

    actions
    {
    }
}


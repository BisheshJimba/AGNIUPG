page 33019831 "Spare Requisition Lines"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = Table33019832;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                    Editable = false;
                }
                field("No."; "No.")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field("Description 2"; "Description 2")
                {
                    Editable = false;
                    Importance = Additional;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field("Vendor No."; "Vendor No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Order Date"; "Order Date")
                {
                    Editable = false;
                }
                field("Due Date"; "Due Date")
                {
                    Editable = false;
                }
                field("Requester ID"; "Requester ID")
                {
                    Editable = false;
                    Importance = Additional;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    Editable = false;
                    Importance = Additional;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    Editable = false;
                    Importance = Additional;
                }
                field("Location Code"; "Location Code")
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                    Editable = true;
                }
                field("User ID"; "User ID")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}


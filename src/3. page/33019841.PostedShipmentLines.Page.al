page 33019841 "Posted Shipment Lines"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table5745;
    SourceTableView = WHERE(Quantity = FILTER(> 0));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; "Document No.")
                {
                }
                field("Transfer Order No."; "Transfer Order No.")
                {
                }
                field("Source No."; "Source No.")
                {
                    Caption = 'Service Order No';
                }
                field("Transfer-from Code"; "Transfer-from Code")
                {
                }
                field("Transfer-to Code"; "Transfer-to Code")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}


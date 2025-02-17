page 33020198 "Vehicle Dispatch History"
{
    CardPageID = "Vehicle Dispatch Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020171;
    SourceTableView = WHERE(Dispatched = FILTER(Yes),
                            Received = FILTER(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Transfer-from Code"; "Transfer-from Code")
                {
                }
                field("Transfer-to Code"; "Transfer-to Code")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Dispatched By"; "Dispatched By")
                {
                }
                field(Dispatched; Dispatched)
                {
                }
                field(Received; Received)
                {
                }
                field("Dispatched Date"; "Dispatched Date")
                {
                }
                field("Received Date"; "Received Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}


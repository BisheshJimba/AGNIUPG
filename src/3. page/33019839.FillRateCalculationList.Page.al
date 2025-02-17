page 33019839 "Fill Rate Calculation List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = Table33019839;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Order No."; "Order No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Ordered Qty."; "Ordered Qty.")
                {
                }
                field("Supply Qty."; "Supply Qty.")
                {
                }
                field("Order Date"; "Order Date")
                {
                }
                field("Invoice Date"; "Invoice Date")
                {
                }
                field("Invoice Gap"; "Invoice Gap")
                {
                }
                field(Rate; Rate)
                {
                }
                field("Item Value"; "Item Value")
                {
                }
                field("Vendor Order No."; "Vendor Order No.")
                {
                }
                field("Vendor Invoice No."; "Vendor Invoice No.")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        FillRateAnalysis: Report "33019834";
}


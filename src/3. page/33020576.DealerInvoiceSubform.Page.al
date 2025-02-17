page 33020576 "Dealer Invoice Subform"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = Table33020433;
    SourceTableView = WHERE(Row Type=CONST(Document Lines));

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
                field("Line Description"; "Line Description")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Item Category Code"; "Item Category Code")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Variant Code"; "Variant Code")
                {
                }
                field("Registration No."; "Registration No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}


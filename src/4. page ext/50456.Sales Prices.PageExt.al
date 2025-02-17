pageextension 50456 pageextension50456 extends "Sales Prices"
{
    Editable = true;
    Editable = true;
    layout
    {
        addafter("Control 30")
        {
            field("Ordering Price Type Code"; "Ordering Price Type Code")
            {
                Visible = true;
            }
            field("Location Code"; "Location Code")
            {
            }
        }
        addafter("Control 14")
        {
            field("Document Profile"; "Document Profile")
            {
            }
        }
        addafter("Control 12")
        {
            field("Vehicle Serial No."; "Vehicle Serial No.")
            {
            }
            field("Variable Field 25006800"; "Variable Field 25006800")
            {
            }
        }
        addafter("Control 2")
        {
            field("Actual Unit Price (NDP)"; "Actual Unit Price (NDP)")
            {
                Visible = false;
            }
            field("VAT%"; "VAT%")
            {
                Visible = false;
            }
            field("Profit %"; "Profit %")
            {
                Visible = false;
            }
            field("Unit Price including VAT"; "Unit Price including VAT")
            {
                Visible = false;
            }
            field("Dealer Discount Amount"; "Dealer Discount Amount")
            {
            }
        }
    }
}


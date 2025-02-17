page 25006531 "Vehicle Sales Prices"
{
    Caption = 'Vehicle Sales Prices';
    DelayedInsert = true;
    PageType = List;
    PopulateAllFields = true;
    SaveValues = true;
    SourceTable = Table7002;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Sales Type"; "Sales Type")
                {
                    OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign';
                }
                field("Sales Code"; "Sales Code")
                {
                    Editable = SalesCodeEditable;
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Item No."; "Item No.")
                {
                    Caption = 'Model Version No.';
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                    Visible = false;
                }
                field("VAT%"; "VAT%")
                {
                    Visible = false;
                }
                field("Minimum Quantity"; "Minimum Quantity")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Document Profile"; "Document Profile")
                {
                    OptionCaption = ' ,,Vehicles Trade';
                    Visible = false;
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Price Includes VAT"; "Price Includes VAT")
                {
                    Visible = false;
                }
                field("Allow Line Disc."; "Allow Line Disc.")
                {
                    Visible = false;
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    Visible = false;
                }
                field("VAT Bus. Posting Gr. (Price)"; "VAT Bus. Posting Gr. (Price)")
                {
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    Visible = false;
                }
                field("Variable Field 25006800"; "Variable Field 25006800")
                {
                }
                field("Dealer Discount Amount"; "Dealer Discount Amount")
                {
                }
                field("Unit Price including VAT"; "Unit Price including VAT")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        SalesCodeEditable := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Unit of Measure Code" := '';
        "Model Version No." := "Item No.";
        OnAfterGetCurrRecord;
    end;

    var
        [InDataSet]
        SalesCodeEditable: Boolean;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        SalesCodeEditable := "Sales Type" <> "Sales Type"::"All Customers"
    end;
}


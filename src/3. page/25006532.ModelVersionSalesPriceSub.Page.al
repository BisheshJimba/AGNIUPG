page 25006532 "Model Version Sales Price Sub."
{
    Caption = 'Model Version Sales Price Subform';
    DelayedInsert = true;
    PageType = ListPart;
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
                field("Currency Code"; "Currency Code")
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
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Visible = false;
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


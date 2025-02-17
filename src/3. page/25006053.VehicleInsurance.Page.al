page 25006053 "Vehicle Insurance"
{
    AutoSplitKey = true;
    Caption = 'Vehicle Insurances';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006033;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Cancelled; Cancelled)
                {
                    Visible = false;
                }
                field("Insured by Customer"; "Insured by Customer")
                {
                    Visible = false;
                }
                field("Insured by Veh. Finance Dept."; "Insured by Veh. Finance Dept.")
                {
                    Visible = false;
                }
                field("Cancellation Date"; "Cancellation Date")
                {
                    Visible = false;
                }
                field("Reason for Cancellation"; "Reason for Cancellation")
                {
                    Visible = false;
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Visible = false;
                }
                field(VIN; VIN)
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field(Type; Type)
                {
                }
                field("Ins. Company Name"; "Ins. Company Name")
                {
                    Caption = 'Insurance Company Name';
                }
                field("Ins. Company Code"; "Ins. Company Code")
                {
                    Caption = 'Insurance Company Code';
                }
                field("Insurance Policy No."; "Insurance Policy No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Customer Code"; "Customer Code")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Proforma Invoice No"; "Proforma Invoice No")
                {
                }
                field("Bill No."; "Bill No.")
                {
                }
                field("Bill Date"; "Bill Date")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Insured Value"; "Insured Value")
                {
                    Editable = false;
                }
                field("Insurance Basic"; "Insurance Basic")
                {
                }
                field("Other Insurance"; "Other Insurance")
                {
                }
                field("VAT(Insurance)"; "VAT(Insurance)")
                {
                }
                field("Ins. Prem Value (with VAT)"; "Ins. Prem Value (with VAT)")
                {
                }
                field("Ins. Payment Memo No."; "Ins. Payment Memo No.")
                {
                    Editable = false;
                }
                field("Cancelled Adjustment Memo No."; "Cancelled Adjustment Memo No.")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        IF CustomerFilter <> '' THEN
            "Customer Code" := CustomerFilter;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

        IF CustomerFilter <> '' THEN
            "Customer Code" := CustomerFilter;
    end;

    trigger OnOpenPage()
    begin
        FILTERGROUP(3);
        CustomerFilter := GETFILTER("Customer Code");
        FILTERGROUP(0);
    end;

    var
        CustomerFilter: Text[250];
}


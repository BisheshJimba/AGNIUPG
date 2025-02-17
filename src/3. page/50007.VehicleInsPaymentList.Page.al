page 50007 "Vehicle Ins. Payment List"
{
    PageType = ListPart;
    SourceTable = "Ins. Payment Memo Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Chasis No."; Rec."Chasis No.")
                {
                }
                field("Engine No."; Rec."Engine No.")
                {
                }
                field("DRP/ARE-1 No."; "DRP/ARE-1 No.")
                {
                }
                field(Model; Model)
                {
                }
                field("Model Description"; Rec."Model Description")
                {
                }
                field("Model Version"; Rec."Model Version")
                {
                }
                field("Model Version Desc."; Rec."Model Version Desc.")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field(Canceled; Canceled)
                {
                }
                field(Ton; Ton)
                {
                }
                field(CC; CC)
                {
                }
                field("Seat Capacity"; "Seat Capacity")
                {
                }
                field(Paid; Paid)
                {
                }
                field("Insurance Policy No."; "Insurance Policy No.")
                {
                }
                field("Payment Date"; "Payment Date")
                {
                }
                field("Paid by Check#"; "Paid by Check#")
                {
                }
                field(Cancelled; Cancelled)
                {
                }
                field("Cancellation Date"; "Cancellation Date")
                {
                }
                field("Ins. Company Code"; "Ins. Company Code")
                {
                }
                field("Bill No."; "Bill No.")
                {
                }
                field("Bill Date"; "Bill Date")
                {
                }
                field("Ins. Prem Value (with VAT)"; "Ins. Prem Value (with VAT)")
                {
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
                field("Proforma Invoice No"; "Proforma Invoice No")
                {
                }
                field(Description; Description)
                {
                }
                field("Customer Code"; "Customer Code")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field(Type; Type)
                {
                }
                field("Model Description2"; Rec."Model Description")
                {
                    Caption = 'Model Description';
                }
                field("Model Version Desc.2"; Rec."Model Version Desc.")
                {
                    Caption = 'Model Version Desc.';
                }
                field("Ins. Company Name"; "Ins. Company Name")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}


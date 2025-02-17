page 33020288 "Vehicle Insurance Card HP"
{
    AutoSplitKey = true;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table33020085;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Loan No."; "Loan No.")
                {
                    Editable = false;
                }
                field("Insurance Type"; "Insurance Type")
                {
                }
                field("Policy No."; "Policy No.")
                {
                }
                field("Start Date"; "Start Date")
                {
                }
                field("End Date"; "End Date")
                {
                }
                field("Insurance Company Code"; "Insurance Company Code")
                {
                }
                field("Insurance Company Name"; "Insurance Company Name")
                {
                }
                field("Insured Value"; "Insured Value")
                {
                }
                field("Ins. Prem Value (with VAT)"; "Ins. Prem Value (with VAT)")
                {
                }
                field("Bill No."; "Bill No.")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Editable = false;
                }
                field("VIN No."; "VIN No.")
                {
                    Editable = false;
                }
                field("Engine No."; "Engine No.")
                {
                    Editable = false;
                }
                field("Vehicle Reg. No."; "Vehicle Reg. No.")
                {
                    Editable = false;
                }
                field("Customer No."; "Customer No.")
                {
                    Editable = false;
                }
                field("Customer Name"; "Customer Name")
                {
                    Editable = false;
                }
                field("Customer Phone No."; "Customer Phone No.")
                {
                }
                field("Cust. Mobile Phone No."; "Cust. Mobile Phone No.")
                {
                    Editable = false;
                }
                field("Credit Officer"; "Credit Officer")
                {
                    Editable = false;
                }
                field("Credit Officer Name"; "Credit Officer Name")
                {
                    Editable = false;
                }
                field(Remarks; Remarks)
                {
                }
                field(Status; Status)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Send For Approval")
            {
                Enabled = IsVisible;
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsVisible;

                trigger OnAction()
                begin
                    CLEAR(VehicleInsMgt);
                    //VehicleInsMgt.SendForApproval(Rec);
                    VehicleInsMgt2.SendForApproval(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IsVisible := Status IN [Status::" ", Status::Open];
        IF NOT IsVisible THEN
            CurrPage.EDITABLE(FALSE);
    end;

    var
        VehicleInsMgt: Codeunit "50025";
        IsVisible: Boolean;
        VehicleInsMgt2: Codeunit "25006200";
}


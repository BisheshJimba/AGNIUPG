page 33020289 "Vehicle Insurance List HP"
{
    CardPageID = "Vehicle Insurance Card HP";
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table33020085;
    SourceTableView = WHERE(Status = FILTER(' ' | Open));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan No."; "Loan No.")
                {
                }
                field("Line No."; "Line No.")
                {
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
                }
                field("VIN No."; "VIN No.")
                {
                }
                field("Engine No."; "Engine No.")
                {
                }
                field("Vehicle Reg. No."; "Vehicle Reg. No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
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
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CLEAR(VehicleInsMgt);
                    VehicleInsMgt.SendForApproval(Rec);
                end;
            }
        }
    }

    var
        VehicleInsMgt: Codeunit "50025";
}


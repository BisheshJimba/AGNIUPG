page 33020292 "Approved Veh. Insurance List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020085;
    SourceTableView = WHERE(Status = FILTER(Approved));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan No."; "Loan No.")
                {
                    StyleExpr = StyleTxt;
                }
                field("Line No."; "Line No.")
                {
                    StyleExpr = StyleTxt;
                }
                field("Insurance Type"; "Insurance Type")
                {
                    StyleExpr = StyleTxt;
                }
                field("Policy No."; "Policy No.")
                {
                    StyleExpr = StyleTxt;
                }
                field("Start Date"; "Start Date")
                {
                    StyleExpr = StyleTxt;
                }
                field("End Date"; "End Date")
                {
                    StyleExpr = StyleTxt;
                }
                field("Insurance Company Code"; "Insurance Company Code")
                {
                    StyleExpr = StyleTxt;
                }
                field("Insurance Company Name"; "Insurance Company Name")
                {
                    StyleExpr = StyleTxt;
                }
                field("Insured Value"; "Insured Value")
                {
                    StyleExpr = StyleTxt;
                }
                field("Ins. Prem Value (with VAT)"; "Ins. Prem Value (with VAT)")
                {
                    StyleExpr = StyleTxt;
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    StyleExpr = StyleTxt;
                }
                field("VIN No."; "VIN No.")
                {
                    StyleExpr = StyleTxt;
                }
                field("Engine No."; "Engine No.")
                {
                    StyleExpr = StyleTxt;
                }
                field("Vehicle Reg. No."; "Vehicle Reg. No.")
                {
                    StyleExpr = StyleTxt;
                }
                field("Customer No."; "Customer No.")
                {
                    StyleExpr = StyleTxt;
                }
                field("Customer Name"; "Customer Name")
                {
                    StyleExpr = StyleTxt;
                }
                field("Customer Phone No."; "Customer Phone No.")
                {
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
                    StyleExpr = StyleTxt;
                }
                field("Request for Cancellation"; "Request for Cancellation")
                {
                    StyleExpr = StyleTxt;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Post)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CLEAR(VehicleInsMgt2);
                    VehicleInsMgt2.PostVehicleInsurance(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := SetStyle;
    end;

    var
        VehicleInsMgt: Codeunit "50025";
        StyleTxt: Text;
        VehicleInsMgt2: Codeunit "25006200";
}


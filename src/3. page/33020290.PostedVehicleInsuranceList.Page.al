page 33020290 "Posted Vehicle Insurance List "
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020085;
    SourceTableView = WHERE(Status = CONST(Posted));

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
                field("Cust. Mobile Phone No."; "Cust. Mobile Phone No.")
                {
                    Editable = false;
                }
                field("Credit Officer"; "Credit Officer")
                {
                }
                field("Credit Officer Name"; "Credit Officer Name")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field(Status; Status)
                {
                    StyleExpr = StyleTxt;
                }
                field(Approved; Approved)
                {
                    StyleExpr = StyleTxt;
                }
                field("Approved By"; "Approved By")
                {
                }
                field("Approved Date"; "Approved Date")
                {
                }
                field(Posted; Posted)
                {
                    StyleExpr = StyleTxt;
                }
                field("Posted By"; "Posted By")
                {
                }
                field("Posted Date"; "Posted Date")
                {
                }
                field(Cancel; Cancel)
                {
                    StyleExpr = StyleTxt;
                }
                field(Expired; Expired)
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Cancel Vehicle Insurance")
            {
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    VehicleInsMgt.CancleVehicleInsurance(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := SetStyle;
    end;

    var
        StyleTxt: Text;
        VehicleInsMgt: Codeunit "25006200";
}


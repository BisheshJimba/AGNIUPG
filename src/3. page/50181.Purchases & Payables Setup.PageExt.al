pageextension 50181 pageextension50181 extends "Purchases & Payables Setup"
{
    // 09.06.2014 Elva Baltic P1 #F0001 EDMS7.10
    //   * Added field:
    //     "Split Order By Price Type"
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 40".


        //Unsupported feature: Property Deletion (ToolTipML) on "Control 40".


        //Unsupported feature: Property Deletion (Importance) on "Control 40".

        addafter("Control 35")
        {
            field("Def. Ordering Price Type Code"; Rec."Def. Ordering Price Type Code")
            {
            }
            field("Post Reverse VAT On Prepmt."; Rec."Post Reverse VAT On Prepmt.")
            {
            }
            field("Split Order By Price Type"; Rec."Split Order By Price Type")
            {
            }
            field("Auto Apply Replacements"; Rec."Auto Apply Replacements")
            {
            }
            field("Show Description From"; Rec."Show Description From")
            {
            }
        }
        addafter("Control 40")
        {
            field("Item Charge Vat Book"; Rec."Item Charge Vat Book")
            {
            }
        }
        addfirst("Control 1904569201")
        {
            field("Requisition No."; Rec."Requisition No.")
            {
            }
            field("Summary No."; Rec."Summary No.")
            {
            }
        }
        addafter("Control 52")
        {
            field("Posted Prepmt. Cr. Memo Nos."; Rec."Posted Prepmt. Cr. Memo Nos.")
            {
            }
            field("Spare Req. No."; Rec."Spare Req. No.")
            {
            }
            field("Veh. Registration No. Series"; Rec."Veh. Registration No. Series")
            {
            }
            field("Import Purch. Order Nos."; Rec."Import Purch. Order Nos.")
            {
            }
            field("Memo Nos."; Rec."Memo Nos.")
            {
            }
            field("Sales Memo Nos"; Rec."Sales Memo Nos")
            {
            }
            group("General Procurement")
            {
                Caption = 'General Procurement';
                field("GPD Internal Customer"; Rec."GPD Internal Customer")
                {
                }
            }
            group("Fuel Issue")
            {
                Caption = 'Fuel Issue';
                field("Coupon Reg. No. Series"; Rec."Coupon Reg. No. Series")
                {
                }
                field("Veh. Fuel Expense No. Series"; Rec."Veh. Fuel Expense No. Series")
                {
                }
                field("New Vehicle Account (CVD)"; Rec."New Vehicle Account (CVD)")
                {
                }
                field("New Vehicle Account (PCD)"; Rec."New Vehicle Account (PCD)")
                {
                }
                field("Office Vehicle Account"; Rec."Office Vehicle Account")
                {
                }
                field("Employee as Facility Account"; Rec."Employee as Facility Account")
                {
                }
                field("Employee as Advance Account"; Rec."Employee as Advance Account")
                {
                }
                field("Generator Account"; Rec."Generator Account")
                {
                }
                field("Rented Vehicle Account"; Rec."Rented Vehicle Account")
                {
                }
            }
            group("Vehicle Registration")
            {
                Caption = 'Vehicle Registration';
                field("Chassis. Reg. Account (CV)"; Rec."Chassis. Reg. Account (CV)")
                {
                }
                field("Tax Account (CV)"; Rec."Tax Account (CV)")
                {
                }
                field("Chassis. Reg. Account  (PC)"; Rec."Chassis. Reg. Account  (PC)")
                {
                }
                field("Tax Account (PC)"; Rec."Tax Account (PC)")
                {
                }
            }
            group("IRD Report Setup")
            {
                Caption = 'IRD Report Setup';
                field("Purch. VAT No."; Rec."Purch. VAT No.")
                {
                }
                field("Posting Group"; Rec."Posting Group")
                {
                }
                field("Exempt Vendor No."; Rec."Exempt Vendor No.")
                {
                }
            }
            group("TDS Posting Set Up")
            {
                Caption = 'TDS Posting Set Up';
                field("TDS Posting Template Name"; Rec."TDS Posting Template Name")
                {
                }
                field("TDS Posting Batch Name"; Rec."TDS Posting Batch Name")
                {
                }
                field("TDS Posting Source Code"; Rec."TDS Posting Source Code")
                {
                }
            }
        }
        addafter("Control 21")
        {
            group(Vehicle)
            {
                Caption = 'Vehicle';
                field("Vehicle Purch. Order Grouping"; Rec."Vehicle Purch. Order Grouping")
                {
                }
            }
        }
        moveafter("Control 35"; "Control 40")
    }
}


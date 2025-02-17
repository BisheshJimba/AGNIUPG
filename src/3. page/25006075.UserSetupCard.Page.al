page 25006075 "User Setup Card"
{
    // 14.04.2016 EB.P30
    //   Added field: Register Statistics
    // 
    // 16.02.2015 EB.P7 #SingleInst.
    //   Removed "Profile ID" field
    // 
    // 21.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added field "Allow Cancel Service Reserv."
    // 
    // 11.02.2014 Elva Baltic P8 #xxx MMG7.00
    //   * Added fields:
    //     "Allow Block Customer"
    // 
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009
    // 
    // 19.03.2013 EDMS P8
    //   * Add fields

    Caption = 'User Setup Card';
    PageType = Card;
    SourceTable = Table91;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("User ID"; "User ID")
                {
                }
                field("Allow Posting From"; "Allow Posting From")
                {
                }
                field("Allow Posting To"; "Allow Posting To")
                {
                }
                field("Allow Posting Only Today"; "Allow Posting Only Today")
                {
                }
                field("Multisession Login"; "Multisession Login")
                {
                }
                field("Register Time"; "Register Time")
                {
                }
                field("Salespers./Purch. Code"; "Salespers./Purch. Code")
                {
                }
                field("Allow FA Posting From"; "Allow FA Posting From")
                {
                }
                field("Allow FA Posting To"; "Allow FA Posting To")
                {
                }
                field("SP Sales Disc. Group Code"; "SP Sales Disc. Group Code")
                {
                }
                field("Starting Form ID"; "Starting Form ID")
                {
                }
                field("Item Markup Restriction Group"; "Item Markup Restriction Group")
                {
                }
                field("Veh. Acc. Cycle Change Funct."; "Veh. Acc. Cycle Change Funct.")
                {
                }
                field("Allow Use Service Schedule"; "Allow Use Service Schedule")
                {
                }
                field("Resource No."; "Resource No.")
                {
                }
                field("Branch Code"; "Branch Code")
                {
                }
                field("Cancel Only Own Reservation"; "Cancel Only Own Reservation")
                {
                }
                field("SIE management"; "SIE management")
                {
                }
                field("Cust. Credit Control"; "Cust. Credit Control")
                {
                }
                field("Allow Block Customer"; "Allow Block Customer")
                {
                }
                field("Allow Cancel Service Reserv."; "Allow Cancel Service Reserv.")
                {
                }
                field("Register Statistics"; "Register Statistics")
                {
                }
                field("Can Edit Customer Card"; "Can Edit Customer Card")
                {
                }
                field("Can Edit Margin Interest Rate"; "Can Edit Margin Interest Rate")
                {
                }
                field("GL Account Department"; "GL Account Department")
                {
                }
                field("Can Edit Item Description"; "Can Edit Item Description")
                {
                }
                field("Can Print Tax Invoice"; "Can Print Tax Invoice")
                {
                }
            }
            group(Filters)
            {
                field("Sales Resp. Ctr. Filter"; "Sales Resp. Ctr. Filter")
                {
                }
                field("Purchase Resp. Ctr. Filter"; "Purchase Resp. Ctr. Filter")
                {
                }
                field("Service Resp. Ctr. Filter"; "Service Resp. Ctr. Filter")
                {
                }
                field("Service Resp. Ctr. Filter EDMS"; "Service Resp. Ctr. Filter EDMS")
                {
                }
            }
            group(Approval)
            {
                field("Sales Amount Approval Limit"; "Sales Amount Approval Limit")
                {
                }
                field("Unlimited Sales Approval"; "Unlimited Sales Approval")
                {
                }
                field("Veh. Sales Amount Appr. Limit"; "Veh. Sales Amount Appr. Limit")
                {
                }
                field("Unlimited Veh. Sales Approval"; "Unlimited Veh. Sales Approval")
                {
                }
                field("Spare Parts Sales Appr. Limit"; "Spare Parts Sales Appr. Limit")
                {
                }
                field("Unlimited Spare Parts Sales"; "Unlimited Spare Parts Sales")
                {
                }
                field("Veh. Service Approval Limit"; "Veh. Service Approval Limit")
                {
                }
                field("Unlimited Veh. Service Appr."; "Unlimited Veh. Service Appr.")
                {
                }
                field("Purchase Amount Approval Limit"; "Purchase Amount Approval Limit")
                {
                }
                field("Unlimited Purchase Approval"; "Unlimited Purchase Approval")
                {
                }
                field("Request Amount Approval Limit"; "Request Amount Approval Limit")
                {
                }
                field("Unlimited Request Approval"; "Unlimited Request Approval")
                {
                }
                field("Veh. Purch. Amount Appr. Limit"; "Veh. Purch. Amount Appr. Limit")
                {
                }
                field("Unlimited Veh. Purch. Approval"; "Unlimited Veh. Purch. Approval")
                {
                }
                field("Spare Parts Purch. Appr. Limit"; "Spare Parts Purch. Appr. Limit")
                {
                }
                field("Unlimited Spare Parts Purch."; "Unlimited Spare Parts Purch.")
                {
                }
                field("Approver ID"; "Approver ID")
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
                field(Substitute; Substitute)
                {
                }
                group(Additional)
                {
                }
                field("Schedule Add-In Log Path"; "Schedule Add-In Log Path")
                {
                }
                field("Schedule Add-In Log Active"; "Schedule Add-In Log Active")
                {
                }
                group("NCHL-NPI Approver User Change")
                {
                    field("Can Approve NCHL-NPI User"; "Can Approve NCHL-NPI User")
                    {
                    }
                }
            }
        }
    }

    actions
    {
    }
}


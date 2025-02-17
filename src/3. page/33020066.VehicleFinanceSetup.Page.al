page 33020066 "Vehicle Finance Setup"
{
    Caption = 'Hirepurchase Setup';
    PageType = Card;
    SourceTable = Table33020064;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Application Nos."; "Application Nos.")
                {
                }
                field("Loan Nos."; "Loan Nos.")
                {
                }
                field("Cash Receipt No."; "Cash Receipt No.")
                {
                }
                field("Penalty %"; "Penalty %")
                {
                }
                field("VF Journal Template Name"; "VF Journal Template Name")
                {
                }
                field("VB Journal Batch Name"; "VB Journal Batch Name")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("NRV Calculation Method"; "NRV Calculation Method")
                {
                }
                field("Check Application Status"; "Check Application Status")
                {
                }
                field("Policy Type"; "Policy Type")
                {
                }
                field("Delivery Order Nos."; "Delivery Order Nos.")
                {
                }
                field("Penalty % - Interest %"; "Penalty % - Interest %")
                {
                    Caption = 'Interest %';
                }
                field("Exposure Value"; "Exposure Value")
                {
                }
                field("Delivery Days"; "Delivery Days")
                {
                }
                field("Ins. Entry Before Expire Days"; "Ins. Entry Before Expire Days")
                {
                    Caption = 'Allow Insurance Entry Before Expire Days';
                }
                field("Veh. Ins.Journal Template Name"; "Veh. Ins.Journal Template Name")
                {
                }
                field("Veh. Ins. Journal Batch Name"; "Veh. Ins. Journal Batch Name")
                {
                }
                field("Ins. Interest Cal. Cutoff Date"; "Ins. Interest Cal. Cutoff Date")
                {
                }
                field("Probable Followup Days"; "Probable Followup Days")
                {
                }
                field("Allow Loan Disburse/Undisbursed"; "Loan Disbursed")
                {
                    ToolTip = 'the users selected can only have  the authority to untick and tick the loan disbursed';
                }
                field("Vendor Posting Group"; "Vendor Posting Group")
                {
                }
            }
            group("Posting Group")
            {
                field("Loan Control Account"; "Loan Control Account")
                {
                }
                field("Principal Posting Account"; "Principal Posting Account")
                {
                }
                field("Interest Posting Account"; "Interest Posting Account")
                {
                }
                field("Insurance Int. Posting Account"; "Insurance Int. Posting Account")
                {
                }
                field("CAD Interest Posting Account"; "CAD Interest Posting Account")
                {
                }
                field("Penalty Posting Account"; "Penalty Posting Account")
                {
                }
                field("Insurance Posting Account"; "Insurance Posting Account")
                {
                }
                field("Rebate Posting Account"; "Rebate Posting Account")
                {
                }
                field("Service Charges Account"; "Service Charges Account")
                {
                }
                field("Other Charges Account"; "Other Charges Account")
                {
                }
                field("Nominee Account Posting Group"; "Nominee Account Posting Group")
                {
                }
            }
            group("SMS Notification")
            {
                Caption = 'SMS Notification';
                field("Send EMI Due Reminder"; "Send EMI Due Reminder")
                {
                }
                field("EMI Due Reminder Prior to"; "EMI Due Reminder Prior to")
                {
                }
                field("EMI Maturity Start Day"; "EMI Maturity Start Day")
                {
                }
                field("Commission Income Account"; "Commission Income Account")
                {
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Nominee Account Nos."; "Nominee Account Nos.")
                {
                }
            }
            group("Master Companies")
            {
                Caption = 'Master Companies';
                field("Agni Inc Company Name"; "Agni Inc Company Name")
                {
                }
                field("Hire Purchase Company Name"; "Hire Purchase Company Name")
                {
                }
            }
            group("Insurance SMS Reminder")
            {
                field("Insurance First Reminder Days"; "Insurance First Reminder Days")
                {
                }
                field("Insurance Second Reminder Days"; "Insurance Second Reminder Days")
                {
                }
                field("Ins. Renew Policy Days"; "Ins. Renew Policy Days")
                {
                    ToolTip = 'Insurance policy renew submission days before insurance expiry date';
                }
                field("Insurance Email"; "Insurance Email")
                {
                }
            }
        }
    }

    actions
    {
    }
}


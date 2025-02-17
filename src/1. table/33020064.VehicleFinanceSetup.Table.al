table 33020064 "Vehicle Finance Setup"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Penalty %"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(3; "Loan Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(4; "Principal Posting Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(5; "Interest Posting Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(6; "Penalty Posting Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(7; "Insurance Posting Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(8; "Rebate Posting Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(9; "Service Charges Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(10; "Other Charges Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(11; "VF Journal Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Cash Receipts));
        }
        field(12; "VB Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE(Journal Template Name=FIELD(VF Journal Template Name),
                                                             Template Type=CONST(Cash Receipts));
        }
        field(13; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(14; "Application Nos."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(15; "NRV Calculation Method"; Option)
        {
            OptionMembers = Daily,Monthly,Yearly;
        }
        field(16; "Veh. Ins.Journal Template Name"; Code[10])
        {
            TableRelation = "Gen. Journal Template".Name WHERE(Type = CONST(Cash Receipts));
        }
        field(17; "Veh. Ins. Journal Batch Name"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE(Journal Template Name=FIELD(VF Journal Template Name),
                                                             Template Type=CONST(Cash Receipts));
        }
        field(50000; "Cash Receipt No."; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50001; "Loan Control Account"; Code[20])
        {
            TableRelation = "Bank Account".No.;
        }
        field(50002; "Check Application Status"; Boolean)
        {
        }
        field(50003; "EMI Due Reminder Prior to"; Integer)
        {
            Description = 'SMS Notification before EMI Due Reminder Prior to -- days';
        }
        field(50004; "Send EMI Due Reminder"; Boolean)
        {
        }
        field(50005; "Policy Type"; Option)
        {
            OptionCaption = 'Hire Purchase,Vehicle Finance';
            OptionMembers = "Hire Purchase","Vehicle Finance";
        }
        field(50006; "Commission Income Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50007; "Delivery Order Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50008; "Nominee Account Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50009; "Insurance Int. Posting Account"; Code[20])
        {
            Caption = 'Insurance Interest Posting Account';
            TableRelation = "G/L Account";
        }
        field(50010; "CAD Interest Posting Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50011; "Nominee Account Posting Group"; Code[10])
        {
            TableRelation = "Customer Posting Group";
        }
        field(50012; "EMI Maturity Start Day"; Integer)
        {
        }
        field(50013; "Penalty % - Interest %"; Decimal)
        {
        }
        field(50014; "Exposure Value"; Decimal)
        {
        }
        field(50015; "Delivery Days"; Integer)
        {
        }
        field(50016; "Ins. Entry Before Expire Days"; Integer)
        {
        }
        field(50017; "Ins. Interest Cal. Cutoff Date"; Date)
        {
        }
        field(50018; "Probable Followup Days"; Integer)
        {
        }
        field(50019; "Loan Disbursed"; Code[50])
        {
            Description = 'the users selected can only have  the authority to untick and tick the loan disbursed';
            TableRelation = "User Setup";
        }
        field(50020; "Agni Inc Company Name"; Text[30])
        {
        }
        field(50021; "Hire Purchase Company Name"; Text[30])
        {
        }
        field(50022; "Vendor Posting Group"; Code[20])
        {
            TableRelation = "Vendor Posting Group".Code;
        }
        field(50023; "Insurance First Reminder Days"; Integer)
        {
            Description = 'for sms insurance reminder sms';
        }
        field(50024; "Insurance Second Reminder Days"; Integer)
        {
            Description = 'for sms insurance reminder sms';
        }
        field(50025; "Ins. Renew Policy Days"; Integer)
        {
            Description = 'Insurance policy renew submission days before insurance expiry date';
        }
        field(50026; "Insurance Email"; Text[150])
        {
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


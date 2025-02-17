table 33020507 "Payroll General Setup"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*

    DataPerCompany = true;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Tax Ex. Amt. (%) on Retirement"; Decimal)
        {
        }
        field(3; "Tax Ex. Amt. not Exceeding"; Decimal)
        {
        }
        field(4; "Tax Ex. Insurance Amt."; Decimal)
        {
        }
        field(5; "Working Days in a Month"; Integer)
        {
        }
        field(6; "Salary Plan No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(7; "Payroll Fiscal Year Start Date"; Date)
        {
        }
        field(8; "Payroll Fiscal Year End Date"; Date)
        {
        }
        field(9; "Salary Plan Posting No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(10; "Posting Method"; Option)
        {
            OptionCaption = 'Dimension Wise,Employee Wise';
            OptionMembers = "Dimension Wise","Employee Wise";
        }
        field(11; "Income Tax Account 1"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(12; "Salary Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(13; "Income Tax Account 2"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(14; "Base Calender"; Code[10])
        {
            Description = 'AMS';
            TableRelation = "Base Calendar PRM";
        }
        field(15; "MPPD (Minutes)"; Decimal)
        {
            Description = 'AMS : Minimum Presence Required Per Day';
        }
        field(16; "MPPD Tolorence (ÙMinutes)"; Decimal)
        {
            Description = 'AMS';
        }
        field(17; "Ignore Odd Login Frequencies"; Boolean)
        {
            Description = 'AMS';
        }
        field(18; "Tax Calculation Type"; Option)
        {
            OptionCaption = 'Yearly,Monthly';
            OptionMembers = Yearly,Monthly;
        }
        field(19; "Leave Deduction Component"; Code[20])
        {
        }
        field(20; "Dearness Allowance Component"; Code[20])
        {
            TableRelation = "Payroll Component";
        }
        field(21; "Other Allowance Component"; Code[20])
        {
            TableRelation = "Payroll Component";
        }
        field(22; "PF Contribution Component"; Code[20])
        {
            TableRelation = "Payroll Component";
        }
        field(23; "PF Deduction Component"; Code[20])
        {
            TableRelation = "Payroll Component";
        }
        field(24; "Tax Ex. Amt. (%) on Donation"; Decimal)
        {
        }
        field(25; "Tax Ex. Amt. not Exeed on Don."; Decimal)
        {
            Description = 'Tax Ex. Amt. not Exeeding on Donation';
        }
        field(27; "TDS Group"; Code[20])
        {
            TableRelation = "TDS Posting Group".Code;
        }
        field(28; "Gratuity Expense A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(29; "Gratuity Payable A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(30; "Salary Statement File Path"; Text[50])
        {
        }
        field(31; "SSF Expense A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(32; "SSF Payable A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(33; "leave Encash Component"; Code[20])
        {
            TableRelation = "Payroll Component";
        }
        field(34; "Tax Ex. Amt. on Health Insur."; Decimal)
        {
            Description = 'Tax Ex. Amt. on Health Insurrance';
        }
        field(35; "Tax Ex. Amt on Building Insur."; Decimal)
        {
            Description = 'Tax Ex. Amt on Building Insurance';
        }
        field(36; "Tax Ex. Amt(%) Med. Tax Credit"; Decimal)
        {
            Description = 'Tax Ex. Amt(%) Medical Tax Credit';
        }
        field(37; "Tax Ex. Amt.  Med. Tax Credit"; Decimal)
        {
            Description = 'Tax Ex. Amt.  Medical Tax Credit';
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


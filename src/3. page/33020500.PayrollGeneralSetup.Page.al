page 33020500 "Payroll General Setup"
{
    PageType = Card;
    SourceTable = Table33020507;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Posting Method"; "Posting Method")
                {
                }
                field("Tax Calculation Type"; "Tax Calculation Type")
                {
                }
                field("Payroll Fiscal Year Start Date"; "Payroll Fiscal Year Start Date")
                {
                }
                field("Payroll Fiscal Year End Date"; "Payroll Fiscal Year End Date")
                {
                }
                field("Working Days in a Month"; "Working Days in a Month")
                {
                }
                field("Salary Statement File Path"; "Salary Statement File Path")
                {
                }
            }
            group("Posting Group")
            {
                field("Income Tax Account 1"; "Income Tax Account 1")
                {
                }
                field("Income Tax Account 2"; "Income Tax Account 2")
                {
                }
                field("Salary Account"; "Salary Account")
                {
                }
            }
            group(Gratuity)
            {
                Caption = 'Gratuity';
                field("Gratuity Expense A/c"; "Gratuity Expense A/c")
                {
                }
                field("Gratuity Payable A/c"; "Gratuity Payable A/c")
                {
                }
            }
            group(SSF)
            {
                Caption = 'SSF';
                field("SSF Expense A/c"; "SSF Expense A/c")
                {
                }
                field("SSF Payable A/c"; "SSF Payable A/c")
                {
                }
            }
            group(Tax)
            {
                group("Tax Exemption on Retirement fund")
                {
                    Caption = 'Tax Exemption on Retirement fund';
                    field("Tax Ex. Amt. (%) on Retirement"; "Tax Ex. Amt. (%) on Retirement")
                    {
                        Caption = 'Amount (%)';
                    }
                    field("Tax Ex. Amt. not Exceeding"; "Tax Ex. Amt. not Exceeding")
                    {
                        Caption = 'Amount Not Exceeding';
                    }
                }
                group("Tax Exemption on Insurance Policy")
                {
                    Caption = 'Tax Exemption on Insurance Policy';
                    field("Tax Ex. Insurance Amt."; "Tax Ex. Insurance Amt.")
                    {
                        Caption = 'Amount';
                    }
                }
                group("Tax Exemption on Donation")
                {
                    Caption = 'Tax Exemption on Donation';
                    field("Tax Ex. Amt. (%) on Donation"; "Tax Ex. Amt. (%) on Donation")
                    {
                        Caption = 'Amount (%)';
                    }
                    field("Tax Ex. Amt. not Exeed on Don."; "Tax Ex. Amt. not Exeed on Don.")
                    {
                        Caption = 'Amount Not Exceeding';
                    }
                }
                group("Tax Exemption on Health Insurance")
                {
                    Caption = 'Tax Exemption on Health Insurance';
                    field("Tax Ex. Amt. on Health Insur."; "Tax Ex. Amt. on Health Insur.")
                    {
                        Caption = 'Amount';
                    }
                }
                group("Tax Exemption on Personal Building Insurance")
                {
                    Caption = 'Tax Exemption on Personal Building Insurance';
                    field("Tax Ex. Amt on Building Insur."; "Tax Ex. Amt on Building Insur.")
                    {
                        Caption = 'Amount';
                    }
                }
                group("Medical Tax Credit")
                {
                    Caption = 'Medical Tax Credit';
                    field("Tax Ex. Amt(%) Med. Tax Credit"; "Tax Ex. Amt(%) Med. Tax Credit")
                    {
                        Caption = 'Amount (%)';
                    }
                    field("Tax Ex. Amt.  Med. Tax Credit"; "Tax Ex. Amt.  Med. Tax Credit")
                    {
                        Caption = 'Amount';
                    }
                }
            }
            group(Attendance)
            {
                Caption = 'Attendance';
                field("MPPD (Minutes)"; "MPPD (Minutes)")
                {
                }
                field("MPPD Tolorence (ÙMinutes)"; "MPPD Tolorence (ÙMinutes)")
                {
                }
                field("Base Calender"; "Base Calender")
                {
                }
                field("Ignore Odd Login Frequencies"; "Ignore Odd Login Frequencies")
                {
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Salary Plan No. Series"; "Salary Plan No. Series")
                {
                }
                field("Salary Plan Posting No. Series"; "Salary Plan Posting No. Series")
                {
                }
            }
            group("Specific Components")
            {
                field("Leave Deduction Component"; "Leave Deduction Component")
                {
                }
                field("Dearness Allowance Component"; "Dearness Allowance Component")
                {
                }
                field("Other Allowance Component"; "Other Allowance Component")
                {
                }
                field("PF Contribution Component"; "PF Contribution Component")
                {
                }
                field("PF Deduction Component"; "PF Deduction Component")
                {
                }
                field("leave Encash Component"; "leave Encash Component")
                {
                }
            }
        }
    }

    actions
    {
    }
}


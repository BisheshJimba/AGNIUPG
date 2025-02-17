page 33020527 "Salary Ledger Entries"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020520;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee Code"; "Employee Code")
                {
                }
                field("Salary From"; "Salary From")
                {
                }
                field("Salary To"; "Salary To")
                {
                }
                field("Fiscal Year From"; "Fiscal Year From")
                {
                }
                field("Fiscal Year To"; "Fiscal Year To")
                {
                }
                field("Basic Salary"; "Basic Salary")
                {
                }
                field("Total Benefits"; "Total Benefits")
                {
                }
                field("Total Deduction"; "Total Deduction")
                {
                }
                field("Tax Paid"; "Tax Paid")
                {
                }
                field("Tax Credit"; "Tax Credit")
                {
                }
                field("Total Employer Contribution"; "Total Employer Contribution")
                {
                }
                field(CIT; CIT)
                {
                }
                field("Tax Paid on First Account"; "Tax Paid on First Account")
                {
                    Visible = false;
                }
                field("Tax Paid on Second Account"; "Tax Paid on Second Account")
                {
                    Visible = false;
                }
                field("Last Slab (%)"; "Last Slab (%)")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}


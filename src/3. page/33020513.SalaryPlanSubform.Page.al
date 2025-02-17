page 33020513 "Salary Plan Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = Table33020511;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.")
                {
                }
                field("Employee No."; "Employee No.")
                {

                    trigger OnValidate()
                    begin
                        CALCFIELDS("Employee Name", "Job Title");
                        TotalAmountOfTaxPaidOnFirst := "Tax for Period"; //ratan
                    end;
                }
                field("Employee Name"; "Employee Name")
                {
                }
                field("Job Title"; "Job Title")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Basic with Grade"; "Basic with Grade")
                {
                }
                field("Variable Field 33020500"; "Variable Field 33020500")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Variable Field 33020501"; "Variable Field 33020501")
                {
                    Visible = false;
                }
                field("Variable Field 33020502"; "Variable Field 33020502")
                {
                    Visible = false;
                }
                field("Variable Field 33020503"; "Variable Field 33020503")
                {
                    Visible = false;
                }
                field("Variable Field 33020504"; "Variable Field 33020504")
                {
                    Visible = false;
                }
                field("Variable Field 33020505"; "Variable Field 33020505")
                {
                    Visible = false;
                }
                field("Variable Field 33020506"; "Variable Field 33020506")
                {
                    Visible = false;
                }
                field("Variable Field 33020507"; "Variable Field 33020507")
                {
                    Visible = false;
                }
                field("Variable Field 33020508"; "Variable Field 33020508")
                {
                    Visible = false;
                }
                field("Variable Field 33020509"; "Variable Field 33020509")
                {
                    Visible = false;
                }
                field("Variable Field 33020510"; "Variable Field 33020510")
                {
                    Visible = false;
                }
                field("Variable Field 33020511"; "Variable Field 33020511")
                {
                    Visible = false;
                }
                field("Variable Field 33020512"; "Variable Field 33020512")
                {
                    Visible = false;
                }
                field("Variable Field 33020513"; "Variable Field 33020513")
                {
                    Visible = false;
                }
                field("Variable Field 33020514"; "Variable Field 33020514")
                {
                    Visible = false;
                }
                field("Variable Field 33020515"; "Variable Field 33020515")
                {
                    Visible = false;
                }
                field("Variable Field 33020516"; "Variable Field 33020516")
                {
                    Visible = false;
                }
                field("Variable Field 33020517"; "Variable Field 33020517")
                {
                    Visible = false;
                }
                field("Variable Field 33020518"; "Variable Field 33020518")
                {
                    Visible = false;
                }
                field("Variable Field 33020519"; "Variable Field 33020519")
                {
                    Visible = false;
                }
                field("Non-Payment Adjustment"; "Non-Payment Adjustment")
                {
                }
                field("Variable Field 33020500_"; "Variable Field 33020500")
                {
                }
                field("Total Benefit"; "Total Benefit")
                {
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Total Deduction"; "Total Deduction")
                {
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Total Employer Contribution"; "Total Employer Contribution")
                {
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Taxable Income"; "Taxable Income")
                {
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Tax for Period"; "Tax for Period")
                {
                    Editable = false;
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Net Pay"; "Net Pay")
                {
                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Present Days"; "Present Days")
                {
                }
                field("Absent Days"; "Absent Days")
                {
                }
                field("Paid Days"; "Paid Days")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Tax Paid on First Account"; "Tax Paid on First Account")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Tax Paid on Second Account"; "Tax Paid on Second Account")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Gratuity; Gratuity)
                {
                }
                field(TotalAmountOfTaxPaidOnFirst; TotalAmountOfTaxPaidOnFirst)
                {
                    Caption = 'Total Amount Of Tax Paid On First';
                }
                field("SSF(1.67 %)"; "SSF(1.67 %)")
                {
                }
                field("Leave Encash Days"; "Leave Encash Days")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                action("<Action1904522204>")
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action("<Action1000000042>")
                {
                    Caption = 'Payroll Components';
                    Image = Components;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page 33020522;
                    RunPageLink = Employee No.=FIELD(Employee No.);
                    RunPageView = SORTING(Employee No.,Column No.);
                }
                action("Tax Ledger Entries")
                {
                    Caption = 'Tax Ledger Entries';
                    Image = LedgerEntries;
                    RunObject = Page 33020539;
                                    RunPageLink = Employee No.=FIELD(Employee No.),
                                  Document No.=FIELD(Document No.);
                }
            }
        }
    }

    var
        TotalAmountOfTaxPaidOnFirst: Decimal;
}


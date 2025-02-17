page 33020516 "Posted Salary Plan Subform"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = Table33020513;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; "Employee No.")
                {
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
                field("Basic Salary"; "Basic Salary")
                {
                }
                field("Net Pay"; "Net Pay")
                {
                }
                field("Taxable Income"; "Taxable Income")
                {
                }
                field("Monthly Tax"; "Monthly Tax")
                {
                }
                field("Present Days"; "Present Days")
                {
                }
                field("Absent Days"; "Absent Days")
                {
                }
                field("Total Benefit"; "Total Benefit")
                {
                }
                field("Total Deduction"; "Total Deduction")
                {
                }
                field("Total Employer Contribution"; "Total Employer Contribution")
                {
                }
                field("Variable Field 33020500"; "Variable Field 33020500")
                {
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
                field("Paid Days"; "Paid Days")
                {
                }
                field("Absent Days2"; "Absent Days")
                {
                    Caption = 'Absent Days';
                }
                field(Gratuity; Gratuity)
                {
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
            group("<Action1000000035>")
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
                action("<Action1000000043>")
                {
                    Caption = 'Tax Ledger Entries';
                    RunObject = Page 33020539;
                    RunPageLink = Employee No.=FIELD(Employee No.),
                                  Document No.=FIELD(Pre Assigned No.);
                }
                action(Email)
                {
                    Image = Email;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        EmailConfirmMsg: Label 'Do you want to email salary sheet?';
                        EmailSent: Label 'Emails Sent!!!';
                        PostPayroll: Codeunit "33020500";
                        payrollline: Record "33020513";
                    begin
                        payrollline.RESET;
                        CurrPage.SETSELECTIONFILTER(payrollline);
                        IF CONFIRM(EmailConfirmMsg,FALSE) THEN BEGIN
                          //payrollline.SETRANGE("Document No.","No.");
                          IF payrollline.FINDFIRST THEN REPEAT
                            PostPayroll.EmailSalarySheetAttachment(payrollline);
                          UNTIL payrollline.NEXT = 0;
                          MESSAGE(EmailSent);
                        END;
                    end;
                }
                action("Reverse Salary Line")
                {
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(PostedSalaryLine);
                        IF PostedSalaryLine.FINDFIRST THEN BEGIN
                           PayrollReverseMgt.ReversePostedSalaryIndividual(PostedSalaryLine);
                        END;
                    end;
                }
            }
        }
    }

    var
        PayrollReverseMgt: Codeunit "50008";
        PostedSalaryLine: Record "33020513";
}


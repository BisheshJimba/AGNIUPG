page 33020515 "Posted Salary Plan"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = Table33020512;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                }
                field("From Date"; "From Date")
                {
                    Editable = false;
                }
                field("To Date"; "To Date")
                {
                    Editable = false;
                }
                field("Nepali Month"; "Nepali Month")
                {
                    Editable = false;
                }
                field(Remarks; Remarks)
                {
                    Editable = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
            }
            part(; 33020516)
            {
                SubPageLink = Document No.=FIELD(No.);
            }
            group(Posting)
            {
                field("Journal Template Name"; "Journal Template Name")
                {
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            systempart(; Links)
            {
            }
        }
    }

    actions
    {
        area(reporting)
        {
            group("<Action1000000010>")
            {
                Caption = 'Print';
                action(PrintReport)
                {
                    Caption = '&Print';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PostedSalaryHeader: Record "33020512";
                    begin
                        CurrPage.SETSELECTIONFILTER(PostedSalaryHeader);
                        REPORT.RUNMODAL(33020502, TRUE, FALSE, PostedSalaryHeader);
                    end;
                }
                action(Reverse)
                {
                    Image = ReverseRegister;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        PayrollReverseMgt.ReversePostedSalaryTotal("No.", "Journal Template Name", "Journal Batch Name");
                    end;
                }
                action(Email)
                {
                    Image = Email;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        IF CONFIRM(EmailConfirmMsg, FALSE) THEN BEGIN
                            payrollline.RESET;
                            payrollline.SETRANGE("Document No.", "No.");
                            IF payrollline.FINDFIRST THEN
                                REPEAT
                                    PostPayroll.EmailSalarySheetAttachment(payrollline);
                                UNTIL payrollline.NEXT = 0;
                            MESSAGE(EmailSent);
                        END;
                    end;
                }
                action("Maual Reverse")
                {

                    trigger OnAction()
                    var
                        Reverse: Codeunit "50008";
                    begin
                        Reverse.updatePayroll(Rec."No.");
                        MESSAGE('updated.');
                    end;
                }
            }
        }
    }

    var
        PayrollReverseMgt: Codeunit "50008";
        PostPayroll: Codeunit "33020500";
        payrollline: Record "33020513";
        EmailConfirmMsg: Label 'Do you want to email salary sheet?';
        EmailSent: Label 'Emails Sent!!!';
}


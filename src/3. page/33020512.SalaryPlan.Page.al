page 33020512 "Salary Plan"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Credit Allocations';
    SourceTable = Table33020510;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE();
                    end;
                }
                field("From Date"; "From Date")
                {
                }
                field("From Date (B.S)"; "From Date (B.S)")
                {
                    Visible = false;
                }
                field("To Date"; "To Date")
                {
                }
                field("To Date (B.S)"; "To Date (B.S)")
                {
                    Visible = false;
                }
                field(Month; Month)
                {
                    Visible = false;
                }
                field("Nepali Month"; "Nepali Month")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Accountability Center"; "Accountability Center")
                {
                }
                field(Status; Status)
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Irregular Process"; "Irregular Process")
                {
                }
            }
            part(; 33020513)
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
        area(processing)
        {
            group("<Action1000000019>")
            {
                Caption = 'F&untions';
                action("Copy Document")
                {
                    Caption = 'Copy Document';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CopySalaryDoc.SetSalaryHeader(Rec);
                        CopySalaryDoc.RUNMODAL;
                        CLEAR(CopySalaryDoc);
                    end;
                }
                action("Import Employee")
                {
                    Caption = 'Import Employee';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;

                    trigger OnAction()
                    var
                        SalaryHeader: Record "33020510";
                    begin
                        CurrPage.SETSELECTIONFILTER(SalaryHeader);
                        REPORT.RUNMODAL(33020501, TRUE, FALSE, SalaryHeader);
                    end;
                }
                action("Assign Credit")
                {
                    Caption = 'Assign Credit';
                    Image = Allocations;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = false;
                    RunObject = Page 33020521;
                    RunPageLink = Salary Header No.=FIELD(No.);

                    trigger OnAction()
                    begin
                        //
                    end;
                }
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    begin
                        ReleasePayrollDocument.PerformManualRelease(Rec);
                    end;
                }
                action("Re&open")
                {
                    Caption = 'Re&open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "414";
                    begin
                        ReleasePayrollDocument.PerformManualReopen(Rec);
                    end;
                }
            }
            group("Retrieve Bonus")
            {
                Caption = 'Retrieve Bonus';
                action(Dashain)
                {
                    Caption = 'Get Dashain Bonus';

                    trigger OnAction()
                    begin
                        PayrollMgt.EvaluateIrregularComponents(Rec,'DASHIN');
                    end;
                }
                action(Medical)
                {
                    Caption = 'Get Medical Bonus';

                    trigger OnAction()
                    begin
                        PayrollMgt.EvaluateIrregularComponents(Rec,'MEDICAL');
                    end;
                }
                action(Welfare)
                {
                    Caption = 'Get Welfare Bonus';

                    trigger OnAction()
                    begin
                        PayrollMgt.EvaluateIrregularComponents(Rec,'WELFARE');
                    end;
                }
            }
            group("<Action73>")
            {
                Caption = 'P&osting';
                action("Test Report")
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    begin
                        //
                    end;
                }
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "38";
                    begin
                        CODEUNIT.RUN(CODEUNIT::"Payroll-Post (Yes/No)",Rec);
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Ellipsis = true;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "38";
                    begin
                        //
                    end;
                }
            }
        }
    }

    var
        CopySalaryDoc: Report "33020500";
                           ReleasePayrollDocument: Codeunit "33020502";
                           PayrollMgt: Codeunit "33020503";
}


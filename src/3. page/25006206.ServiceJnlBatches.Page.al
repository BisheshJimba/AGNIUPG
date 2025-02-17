page 25006206 "Service Jnl. Batches"
{
    Caption = 'Service Jnl. Batches';
    PageType = List;
    SourceTable = Table25006164;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Name; Name)
                {
                }
                field(Description; Description)
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field("Posting No. Series"; "Posting No. Series")
                {
                }
                field("Reason Code"; "Reason Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                action("<Action1101901000>")
                {
                    Caption = 'Test Report';
                    Image = TestReport;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ReportPrint.PrintServJnlBatch(Rec);
                    end;
                }
                action("P&ost")
                {
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit 25006109;
                    ShortCutKey = 'F11';
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print';
                    Enabled = false;
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+F11';
                    Visible = false;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetupNewBatch;
    end;

    var
        ReportPrint: Codeunit "228";
}


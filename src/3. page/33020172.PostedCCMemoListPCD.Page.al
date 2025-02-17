page 33020172 "Posted CC Memo List - PCD"
{
    CardPageID = "Posted CC Memo Card - PCD";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Documents';
    RefreshOnActivate = true;
    SourceTable = Table33020163;
    SourceTableView = WHERE(Vehicle Division=CONST(CVD),
                            Posted=CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Reference No."; "Reference No.")
                {
                }
                field("From Dept. Code"; "From Dept. Code")
                {
                }
                field("From Dept. Name"; "From Dept. Name")
                {
                }
                field("To Dept. Code"; "To Dept. Code")
                {
                }
                field("To Dept. Name"; "To Dept. Name")
                {
                }
                field("Memo Date"; "Memo Date")
                {
                }
                field("Memo Date (BS)"; "Memo Date (BS)")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1102159022>")
            {
                Caption = 'Document(s)';
                action(Print_CCMemo)
                {
                    Caption = '&Print Memo';
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        LclCCMemo: Record "33020163";
                    begin
                        //Setting filter and printing CC Memo.
                        LclCCMemo.RESET;
                        LclCCMemo.SETRANGE("Reference No.", "Reference No.");
                        REPORT.RUN(33020163, TRUE, TRUE, LclCCMemo);
                    end;
                }
            }
        }
    }
}


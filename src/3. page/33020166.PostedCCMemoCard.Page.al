page 33020166 "Posted CC Memo Card"
{
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Document';
    SourceTable = Table33020163;
    SourceTableView = WHERE(Posted = CONST(Yes));

    layout
    {
        area(content)
        {
            group(General)
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
            part(; 33020167)
            {
                SubPageLink = Reference No.=FIELD(Reference No.);
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


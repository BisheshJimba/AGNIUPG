page 33020176 "Posted Ins. Memo Card"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Document';
    SourceTable = Table33020165;
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
                field("Ins. Company Code"; "Ins. Company Code")
                {
                }
                field("Ins. Company Name"; "Ins. Company Name")
                {
                }
                field("Memo Date"; "Memo Date")
                {
                }
                field("Memo Date (BS)"; "Memo Date (BS)")
                {
                }
                field(Type; Type)
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Sales Bank LC No."; "Sales Bank LC No.")
                {
                }
                field("Version No."; "Version No.")
                {
                }
                field("Valid Period"; "Valid Period")
                {
                    Editable = false;
                }
            }
            part(; 33020177)
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
        area(processing)
        {
            group(Document)
            {
                action(PrintIncDoc)
                {
                    Caption = '&Print';
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //Setting filter and previewing report.
                        LclInsMemo.RESET;
                        LclInsMemo.SETRANGE("Reference No.", "Reference No.");
                        REPORT.RUN(33020164, TRUE, TRUE, LclInsMemo);
                    end;
                }
                action("<Action1000000008>")
                {
                    Caption = '&Marine Cargo Insurance';
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        LclInsMemo.RESET;
                        LclInsMemo.SETRANGE("Reference No.", "Reference No.");
                        REPORT.RUN(33020018, TRUE, TRUE, LclInsMemo);
                    end;
                }
            }
        }
    }

    var
        LclInsMemo: Record "33020165";
}


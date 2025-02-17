page 33020178 "Posted Ins. Memo List"
{
    CardPageID = "Posted Ins. Memo Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Document';
    RefreshOnActivate = true;
    SourceTable = Table33020165;
    SourceTableView = WHERE(Posted = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vehicle Division"; "Vehicle Division")
                {
                    Visible = false;
                }
                field("Memo Date (BS)"; "Memo Date (BS)")
                {
                }
                field("Reference No."; "Reference No.")
                {
                }
                field("Memo Date"; "Memo Date")
                {
                }
                field("Ins. Company Code"; "Ins. Company Code")
                {
                }
                field("Ins. Company Name"; "Ins. Company Name")
                {
                }
                field(Type; Type)
                {
                }
                field(Remarks; Remarks)
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
        area(creation)
        {
            group(Documents)
            {
                Caption = 'Document(s)';
                action(PrintIncDoc)
                {
                    Caption = '&Print';
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        LclInsMemo: Record "33020165";
                    begin
                        //Setting filter and previewing report.
                        LclInsMemo.RESET;
                        LclInsMemo.SETRANGE("Reference No.", "Reference No.");
                        REPORT.RUN(33020164, TRUE, TRUE, LclInsMemo);
                    end;
                }
                action("&Marine Cargo Insurance Memo")
                {
                    Caption = '&Marine Cargo Insurance Memo';
                    Image = PrintDocument;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Report 33020018;

                    trigger OnAction()
                    begin

                        LclInsMemo.RESET;
                        LclInsMemo.SETRANGE("Reference No.", "Reference No.");
                        REPORT.RUN(33020018, TRUE, TRUE, LclInsMemo);

                        //REPORT.RUN(33020018);
                        //REPORT.RUNMODAL(33020018);
                    end;
                }
            }
        }
    }

    var
        LclInsMemo: Record "33020165";
}


page 33020182 "Posted Ins. Memo List - PCD"
{
    CardPageID = "Posted Ins. Memo Card - PCD";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Document';
    RefreshOnActivate = true;
    SourceTable = Table33020165;
    SourceTableView = WHERE(Vehicle Division=CONST(CVD),
                            Posted=CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vehicle Division"; "Vehicle Division")
                {
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
            }
        }
    }
}


page 33019828 "Store Req. Summary History"
{
    Caption = 'Store Requisition Summary List';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Documents';
    RefreshOnActivate = true;
    SourceTable = Table33019812;
    SourceTableView = WHERE(Charge Bearer=CONST(Sender));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Category Code"; "Category Code")
                {
                }
                field("Summary Date"; "Summary Date")
                {
                }
                field("Summary Date (BS)"; "Summary Date (BS)")
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Issue_Items)
            {
                Caption = 'Issue Item(s)';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //Calling function to issue items.
                    GblProcStrIsueMngt.RUN(Rec);
                end;
            }
            separator()
            {
            }
            action("<Action1102159016>")
            {
                Caption = 'View Summary';
                Image = OpenWorksheet;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 33019813;
                RunPageLink = Integration Type=FIELD(Category Code);
                RunPageMode = View;
            }
        }
    }

    var
        GblProcStrIsueMngt: Codeunit "33019813";
}


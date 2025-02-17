page 33020257 "Work Order Register List (Int)"
{
    CardPageID = "Work Order Register";
    Editable = false;
    PageType = List;
    SourceTable = Table33020246;
    SourceTableView = WHERE(Internal Service=CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vendor No."; "Vendor No.")
                {
                }
                field("Vendor Name"; "Vendor Name")
                {
                }
                field(Location; Location)
                {
                }
                field("Work Order Subject"; "Work Order Subject")
                {
                }
                field("Item Type"; "Item Type")
                {
                }
                field("Work Order Type"; "Work Order Type")
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
        area(processing)
        {
            action("&Print")
            {
                Caption = '&Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(WorkOrderReg);
                    REPORT.RUNMODAL(33020243, TRUE, FALSE, WorkOrderReg);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        FILTERGROUP(3);
        SETRANGE("Internal Service", TRUE);
    end;

    trigger OnOpenPage()
    begin
        FILTERGROUP(3);
        SETRANGE("Internal Service", TRUE);
    end;

    var
        WorkOrderReg: Record "33020246";
}


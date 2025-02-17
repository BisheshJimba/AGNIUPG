page 33020249 "Work Order Register List"
{
    CardPageID = "Work Order Register";
    Editable = false;
    PageType = List;
    SourceTable = Table33020246;

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

    var
        WorkOrderReg: Record "33020246";
}


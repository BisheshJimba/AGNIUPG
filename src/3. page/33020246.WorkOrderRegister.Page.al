page 33020246 "Work Order Register"
{
    AutoSplitKey = true;
    PageType = Card;
    SourceTable = Table33020246;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Service Order No."; "Service Order No.")
                {
                }
                field("Vendor No."; "Vendor No.")
                {
                }
                field("Vendor Name"; "Vendor Name")
                {
                    Editable = false;
                }
                field(Location; Location)
                {
                }
                field("Item Type"; "Item Type")
                {
                }
                field("Work Order Type"; "Work Order Type")
                {
                }
            }
            group("Subject ")
            {
                Caption = 'Subject';
                field(Subject; "Work Order Subject")
                {
                }
            }
            group(Details)
            {
                field("Work Order Details"; WorkOrderDetails)
                {
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        SplitWorkOrderDetails(WorkOrderDetails, Rec);
                    end;
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
            action("Print Work Order")
            {
                Caption = '&Print';

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(WorkOrderReg);
                    REPORT.RUNMODAL(33020243, TRUE, FALSE, WorkOrderReg);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        WorkOrderDetails := GetWorkOrderDetails(Rec);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        SplitWorkOrderDetails(WorkOrderDetails, Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        BalkumariFilter := GETFILTER("Internal Service");
        IF BalkumariFilter = 'Yes' THEN
            "Internal Service" := TRUE;
    end;

    var
        WorkOrderDetails: Text[1000];
        WorkOrderReg: Record "33020246";
        BalkumariFilter: Text[30];
}


page 25006172 "Easy Time Wksh. Line Tasks"
{
    Caption = 'Service Order Lines';
    Editable = false;
    PageType = List;
    SourceTable = Table25006146;
    SourceTableView = WHERE(Type = CONST(Labor));

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Line No."; "Line No.")
                {
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field(Amount; Amount)
                {
                }
                field(Status; Status)
                {
                }
                field(Resources; Resources)
                {
                    Caption = 'Resource';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Start Task")
            {
                Image = "Action";
                RunPageMode = View;

                trigger OnAction()
                begin
                    ResourceTimeRegMgt.StartNewTaskFromLine(Rec, ResourceTimeRegMgt.GetCurrentUserResourceNo, WORKDATE, TIME, FALSE);
                    CurrPage.UPDATE;
                end;
            }
            action("Open Document")
            {
                Image = ViewDetails;
                RunObject = Page 25006183;
                RunPageLink = Document Type=FIELD(Document Type),
                              No.=FIELD(Document No.);
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        //
    end;

    trigger OnAfterGetRecord()
    begin
        Resources := GetResourceTextFieldValue;
    end;

    var
        Cust: Record "18";
        Resources: Text;
        ResourceTimeRegMgt: Codeunit "25006290";
}


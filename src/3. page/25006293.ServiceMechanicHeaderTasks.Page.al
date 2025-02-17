page 25006293 "Service Mechanic Header Tasks"
{
    Caption = 'Service Orders';
    Editable = false;
    PageType = ListPart;
    SourceTable = Table25006145;
    SourceTableView = SORTING(Document Type, Order Date)
                      ORDER(Descending)
                      WHERE(Document Type=CONST(Order));

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Vehicle Registration No."; "Vehicle Registration No.")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                }
                field(Resources; Resources)
                {
                    Caption = 'Resources';
                }
                field("Work Status Code"; "Work Status Code")
                {
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
                    ResourceTimeRegMgt.StartNewTaskFromHeader(Rec, ResourceTimeRegMgt.GetCurrentUserResourceNo, WORKDATE, TIME, FALSE);
                    CurrPage.UPDATE;
                end;
            }
            action("Start Travel Task")
            {
                Image = "Action";
                RunPageMode = View;

                trigger OnAction()
                begin
                    ResourceTimeRegMgt.StartNewTaskFromHeader(Rec, ResourceTimeRegMgt.GetCurrentUserResourceNo, WORKDATE, TIME, TRUE);
                    CurrPage.UPDATE;
                end;
            }
            action(Open)
            {
                Image = ViewDetails;
                RunObject = Page 25006183;
                RunPageLink = No.=FIELD(No.),
                              Document Type=FIELD(Document Type);
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
        ResourceTimeRegMgt: Codeunit "25006290";
        Resources: Text;
}


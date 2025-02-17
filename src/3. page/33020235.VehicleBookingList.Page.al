page 33020235 "Vehicle Booking List"
{
    Caption = 'Vehicle Booking List';
    CardPageID = "Service Order EDMS - Booking";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Vehicle Checklist';
    SourceTable = Table25006145;
    SourceTableView = SORTING(Document Type, No.)
                      ORDER(Descending)
                      WHERE(Document Type=FILTER(Order),
                            Work Status (System)=FILTER(Booking),
                            Job Closed=FILTER(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field("Booked By";"Booked By")
                {
                }
                field("Order Date";"Order Date")
                {
                    Caption = 'Date';
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    Visible = false;
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    Visible = false;
                }
                field("Booked on Date";"Booked on Date")
                {
                }
                field("Time Slot Booked";"Time Slot Booked")
                {
                }
                field("Vehicle Registration No.";"Vehicle Registration No.")
                {
                }
                field("Vehicle Serial No.";"Vehicle Serial No.")
                {
                }
                field("Model Code";"Model Code")
                {
                }
                field("Booked By ";"Booked By")
                {
                    Visible = false;
                }
                field("Arrival Date";"Arrival Date")
                {
                }
                field("Arrival Time";"Arrival Time")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action59>")
            {
                Caption = 'O&rder';
                action("<Action63>")
                {
                    Caption = '&Diagnosis';
                    Image = ViewComments;
                    RunObject = Page 25006187;
                                    RunPageLink = Type=FIELD(Document Type),
                                  No.=FIELD(No.);
                }
            }
        }
        area(processing)
        {
            group("<Action66>")
            {
                Caption = 'F&unctions';
                action("<Action1101904031>")
                {
                    Caption = 'Schedule';
                    Image = Allocations;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServiceSchedule: Page "25006358";
                    begin
                        ServiceSchedule.SetServiceHeader(Rec);
                        ServiceSchedule.RUN;
                    end;
                }
                action("<Action1102159007>")
                {
                    Caption = '&Diagnosis';
                    Image = Components;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page 25006187;
                                    RunPageLink = Type=FIELD(Document Type),
                                  No.=FIELD(No.);
                }
                action("<Action1102159008>")
                {
                    Caption = 'Inventory Checklists';
                    Image = PhysicalInventory;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page 25006010;
                                    RunPageLink = Vehicle Serial No.=FIELD(Vehicle Serial No.);
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        FilterOnRecord;
    end;

    var
        UserSetup: Record "91";
        ResponsiblityCenter: Code[20];
        Location: Code[10];

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        RespCenterFilter: Code[10];
    begin
        RespCenterFilter := UserMgt.GetServiceFilterEDMS();
        IF RespCenterFilter <> '' THEN BEGIN
          FILTERGROUP(2);
           IF UserMgt.DefaultResponsibility THEN
              SETRANGE("Responsibility Center",RespCenterFilter)
          ELSE
              SETRANGE("Accountability Center",RespCenterFilter);
          FILTERGROUP(0);
        END;
    end;
}


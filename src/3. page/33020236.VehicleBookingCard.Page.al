page 33020236 "Vehicle Booking Card"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Vehicle Checklist';
    SourceTable = Table33020236;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Date; Date)
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field(Contact; Contact)
                {
                }
                field("Vehicle Reg. No."; "Vehicle Reg. No.")
                {
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Time Slot Booked"; "Time Slot Booked")
                {
                }
                field("Booked on Date"; "Booked on Date")
                {
                }
                field("Job Description"; "Job Description")
                {
                }
                field("Booked By"; "Booked By")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    Visible = false;
                }
                field("Accountability Center"; "Accountability Center")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1102159023>")
            {
                Caption = 'F&unctions';
                action("<Action1102159024>")
                {
                    Caption = 'Create Job Card';
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        CreateJobCard;
                    end;
                }
                action(Schedule)
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
                        ServiceSchedule.RUN;
                    end;
                }
                action("<Action1102159028>")
                {
                    Caption = '&Process Checklists';
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

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        VehicleBooking: Record "33020236";
    begin
        VehicleBooking.RESET;
        VehicleBooking.SETFILTER(Date,'%1',WORKDATE);
        IF (VehicleBooking.FIND('+')) THEN
        BEGIN
         "Line No." := VehicleBooking."Line No." +1
        END
        ELSE
         "Line No." := 1;
    end;
}


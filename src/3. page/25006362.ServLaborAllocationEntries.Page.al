page 25006362 "Serv. Labor Allocation Entries"
{
    // 23.03.2010 EDMSB P2
    //   * Added menu item Allocation->Serv. Alloc. Application

    Caption = 'Service Resource Allocations';
    DataCaptionFields = "Source Type";
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = Table25006271;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Source Type"; "Source Type")
                {
                }
                field("Source Subtype"; "Source Subtype")
                {
                }
                field("Source ID"; "Source ID")
                {
                }
                field(GetCellDescription; GetCellDescription)
                {
                    Caption = 'Cell Description';
                }
                field(DateTimeMgt.Datetime2Text("Start Date-Time");
                    DateTimeMgt.Datetime2Text("Start Date-Time"))
                {
                    Caption = 'Starting Date-Time';
                }
                field(DateTimeMgt.Datetime2Text("End Date-Time");
                    DateTimeMgt.Datetime2Text("End Date-Time"))
                {
                    Caption = 'Ending Date-Time';
                }
                field("Reason Code"; "Reason Code")
                {
                    Visible = false;
                }
                field("Quantity (Hours)"; "Quantity (Hours)")
                {
                }
                field("Resource No."; "Resource No.")
                {
                }
                field(Status; Status)
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Entry No."; "Entry No.")
                {
                }
                field("Detail Entry No."; "Detail Entry No.")
                {
                }
                field(Travel; Travel)
                {
                }
                field("Total Time Spent Travel"; "Total Time Spent Travel")
                {
                }
                field("Start Date Time"; "Start Date Time")
                {
                }
                field("End Date Time"; "End Date Time")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Allocation)
            {
                Caption = 'Allocation';
                action("Show Document")
                {
                    Caption = 'Show Document';
                    Image = View;

                    trigger OnAction()
                    var
                        ServiceHdr: Record "25006145";
                    begin
                        ServiceHdr.RESET;
                        ServiceHdr.SETRANGE("Document Type", "Source Subtype");
                        ServiceHdr.SETRANGE("No.", "Source ID");
                        IF ServiceHdr.FINDFIRST THEN BEGIN
                            IF ServiceHdr."Document Type" = ServiceHdr."Document Type"::Quote THEN
                                PAGE.RUNMODAL(PAGE::"Service Quote EDMS", ServiceHdr);
                            IF ServiceHdr."Document Type" = ServiceHdr."Document Type"::Order THEN
                                PAGE.RUNMODAL(PAGE::"Service Order EDMS", ServiceHdr);
                        END;
                    end;
                }
                action("Show in Schedule")
                {
                    Caption = 'Show in Schedule';
                    Image = Planning;

                    trigger OnAction()
                    var
                        ServiceSchedule: Page "25006358";
                    begin
                        ServiceSchedule.SetAllocation(Rec);
                        ServiceSchedule.RUNMODAL;
                    end;
                }
                action("Serv. Alloc. Application")
                {
                    Caption = 'Serv. Alloc. Application';
                    Image = Resource;
                    RunObject = Page 25006374;
                    RunPageLink = Allocation Entry No.=FIELD(Entry No.);
                    RunPageView = SORTING(Allocation Entry No.,Document Type,Document No.,Document Line No.);
                }
            }
            group("&Functions")
            {
                Caption = '&Functions';
                action("<Action1190019>")
                {
                    Caption = 'Change End Date/Time';
                    Image = Edit;

                    trigger OnAction()
                    begin
                        ServiceScheduleMgt.ChangeFinishedAllocEnding(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        /*//<< MIN 4/28/2019
        IF ("Start Date Time" = 0DT) THEN
          "Start Date Time" := CREATEDATETIME(DateTimeMgt.Datetime2Date("Start Date-Time"),DateTimeMgt.Datetime2Time("Start Date-Time"));
        IF "End Date Time" = 0DT THEN
          "End Date Time" := CREATEDATETIME(DateTimeMgt.Datetime2Date("End Date-Time"),DateTimeMgt.Datetime2Time("End Date-Time"));
        MODIFY;
        */

    end;

    var
        DateTimeMgt: Codeunit "25006012";
        ServiceScheduleMgt: Codeunit "25006201";

    [Scope('Internal')]
    procedure GetCellDescription(): Text[250]
    begin
        EXIT(ServiceScheduleMgt.GetAllocRecDescr(Rec));
    end;
}


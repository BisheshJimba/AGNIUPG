page 33020358 "Leave Register Lines"
{
    Editable = false;
    PageType = List;
    SourceTable = Table33020343;
    SourceTableView = WHERE(Approved = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Employee No."; "Employee No.")
                {
                }
                field("Full Name"; "Full Name")
                {
                }
                field("Work Shift Code"; "Work Shift Code")
                {
                }
                field("Leave Description"; "Leave Description")
                {
                }
                field("Leave Start Date"; "Leave Start Date")
                {
                }
                field("Leave Start Time"; "Leave Start Time")
                {
                }
                field("Leave End Date"; "Leave End Date")
                {
                }
                field("Leave End Time"; "Leave End Time")
                {
                }
                field(Remarks; Remarks)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000001>")
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    LeaveRegister.RESET;
                    LeaveRegister.SETRANGE("Entry No.", "Entry No.");
                    LeaveRegister.SETRANGE("Employee No.", "Employee No.");
                    LeaveRegister.SETRANGE("Leave Type Code", "Leave Type Code");
                    LeaveRegister.SETRANGE("Request Date", "Request Date");
                    LeaveRegister.SETRANGE(Approved, TRUE);
                    IF LeaveRegister.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(33020324, TRUE, FALSE, LeaveRegister);
                    END ELSE BEGIN
                        MESSAGE('Your Leave Request has not been Approved');
                    END;
                end;
            }
        }
    }

    var
        LeaveRegister: Record "33020343";
}


page 33020356 "Leave App/Dis List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020346;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("Leave Type Code"; "Leave Type Code")
                {
                }
                field("Leave Description"; "Leave Description")
                {
                }
                field("Requested Leave Start Date"; "Requested Leave Start Date")
                {
                }
                field("Requested Leave End Date"; "Requested Leave End Date")
                {
                }
                field("Granted Leave Start Date"; "Granted Leave Start Date")
                {
                }
                field("Granted Leave End Date"; "Granted Leave End Date")
                {
                }
                field(Approved; Approved)
                {
                }
                field(Partial; Partial)
                {
                }
                field("Approved By"; "Approved By")
                {
                }
                field("Approved Date"; "Approved Date")
                {
                }
                field("Approval Remarks"; "Approval Remarks")
                {
                }
                field(Disapproved; Disapproved)
                {
                }
                field("Rejected By"; "Rejected By")
                {
                }
                field("Reject Date"; "Reject Date")
                {
                }
                field("Rejection Remarks"; "Rejection Remarks")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    LeaveRegister.RESET;
                    LeaveRegister.SETRANGE("Employee No.", "Employee No.");
                    LeaveRegister.SETRANGE("Leave Type Code", "Leave Type Code");
                    LeaveRegister.SETRANGE("Request Date", "Requested Leave Start Date");
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        /*
        //Applying URC.
        HRUP.GET(USERID);
        IF HRUP."Employee Filter" <> '' THEN BEGIN
          IF NOT HRUP."Super Permission" THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Employee No.",HRUP."Employee Filter");
            FILTERGROUP(0);
          END;
        END;
        */
        HRUP.GET(USERID);
        IF NOT HRUP."Aproval/Disaproval Auth. Leave" THEN
            ERROR(Text000);

    end;

    trigger OnOpenPage()
    begin
        /*
        //Applying URC.
        HRUP.GET(USERID);
        IF HRUP."Employee Filter" <> '' THEN BEGIN
          IF NOT HRUP."Super Permission" THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Employee No.",HRUP."Employee Filter");
            FILTERGROUP(0);
          END;
        END;
        */
        HRUP.GET(USERID);
        IF NOT HRUP."Aproval/Disaproval Auth. Leave" THEN
            ERROR(Text000);

    end;

    var
        HRUP: Record "33020304";
        Text000: Label 'Sorry, you donot have permission to use this Page! Please contact your system administrator.';
        LeaveRegister: Record "33020343";
}


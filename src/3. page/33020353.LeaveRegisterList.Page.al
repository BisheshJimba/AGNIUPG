page 33020353 "Leave Register List"
{
    CardPageID = "Leave Encash/WriteOff List";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020343;
    SourceTableView = WHERE(Type = FILTER(' ' | Leave));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("Full Name"; "Full Name")
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
                field("Request Date"; "Request Date")
                {
                }
                field("Leave Type Code"; "Leave Type Code")
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
                field("Earn Days"; "Earn Days")
                {
                }
                field("Used Days"; "Used Days")
                {
                }
                field("Balance Days"; "Balance Days")
                {
                }
                field("Fiscal Year"; "Fiscal Year")
                {
                }
                field("Approved By"; "Approved By")
                {
                }
                field("Approved Date"; "Approved Date")
                {
                }
                field("Rejected By"; "Rejected By")
                {
                }
                field("Reject Date"; "Reject Date")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Delete Leave Used")
            {
                Caption = 'Delete Leave Used';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    IF "Used Days" > 0 THEN BEGIN
                        HRPermission.GET(USERID);
                        IF HRPermission."Admin Permission" THEN BEGIN
                            ConfirmDelete := DIALOG.CONFIRM(text001, TRUE);
                            IF ConfirmDelete THEN BEGIN
                                LeaveRegister.RESET;
                                LeaveRegister.SETRANGE("Entry No.", "Entry No.");
                                LeaveRegister.SETRANGE("Employee No.", "Employee No.");
                                IF LeaveRegister.FINDFIRST THEN BEGIN
                                    UsedDays := LeaveRegister."Used Days";
                                    LeaveStart := LeaveRegister."Leave Start Date";
                                    LeaveType := LeaveRegister."Leave Type Code";
                                    EntryNo := LeaveRegister."Entry No.";
                                    AttStartDate := LeaveRegister."Leave Start Date";
                                    AttEndDate := LeaveRegister."Leave End Date";
                                    //delete;
                                END;

                                //Delete in Activity Log Table, IF Record Found
                                ActivityLog.RESET;
                                ActivityLog.SETRANGE("Employee No.", "Employee No.");
                                ActivityLog.SETRANGE("Start Date", "Leave Start Date");
                                ActivityLog.SETRANGE(Type, Type);
                                ActivityLog.SETRANGE("Start Time", "Leave Start Time");
                                ActivityLog.SETRANGE("End Date", "Leave End Date");
                                ActivityLog.SETRANGE("End Time", "Leave End Time");
                                ActivityLog.SETRANGE(Subtype, "Pay Type");
                                IF ActivityLog.FINDFIRST THEN BEGIN
                                    MESSAGE('Attendance Process has already been generated for Employee Code %1. Please process with attendance again'
                                      , "Employee No.");
                                    ActivityLog.DELETE;
                                END;

                                /* IF CONFIRM('Attendance has already been generated using this leave entry.Do you want to proceed anyway?',FALSE) THEN
                                 BEGIN
                                   AttLedgerEntry.RESET;
                                   AttLedgerEntry.SETRANGE("Employee No.","Employee No.");
                               //    MESSAGE(FORMAT(AttStartDate));
                                   REPEAT
                                     AttLedgerEntry.SETRANGE("Attendance Date",AttStartDate);
                                     IF AttLedgerEntry.FINDSET THEN REPEAT
                                       AttLedgerEntry.Invalid := TRUE;
                                       AttLedgerEntry."Register Description" := 'Leave Deleted';
                                       AttLedgerEntry.MODIFY;
                                     UNTIL AttLedgerEntry. NEXT = 0;
                                     AttStartDate := AttStartDate + 1;
                                   UNTIL (AttStartDate > AttEndDate);
                                 END
                                 ELSE
                                   ERROR('Process cancelled by user.');
                                 MESSAGE('Please Generate Attendance for Employee Code %1 for %2 to %3',"Employee No.","Leave Start Date","Leave End Date");
                               END; */

                                AttStartDate := "Leave Start Date";
                                AttEndDate := "Leave End Date";


                                //Update in Leave Account
                                LeaveAccount.RESET;
                                LeaveAccount.SETRANGE("Employee Code", "Employee No.");
                                LeaveAccount.SETRANGE("Leave Type", "Leave Type Code");
                                IF LeaveAccount.FINDFIRST THEN BEGIN
                                    LeaveAccount."Used Days" -= UsedDays;
                                    LeaveAccount."Balance Days" += UsedDays;
                                    LeaveAccount.MODIFY;
                                END;
                                //Delete Post Leave Request
                                PostLeave.RESET;
                                PostLeave.SETRANGE("Employee No.", "Employee No.");
                                PostLeave.SETRANGE("Leave Type Code", "Leave Type Code");
                                PostLeave.SETRANGE("Leave Start Date", "Leave Start Date");
                                PostLeave.SETRANGE("Leave End Date", "Leave End Date");
                                IF PostLeave.FINDFIRST THEN
                                    PostLeave.DELETE;


                                //Delete Leave Register
                                LeaveRegister1.RESET;
                                LeaveRegister1.SETRANGE("Entry No.", "Entry No.");
                                LeaveRegister1.SETRANGE("Employee No.", "Employee No.");
                                IF LeaveRegister1.FINDFIRST THEN
                                    LeaveRegister1.DELETEALL;
                                //Update Leave Register
                                LeaveRegister2.RESET;
                                LeaveRegister2.SETRANGE("Employee No.", "Employee No.");
                                LeaveRegister2.SETRANGE("Leave Type Code", "Leave Type Code");
                                LeaveRegister2.SETFILTER("Entry No.", '> %1', EntryNo);
                                IF LeaveRegister2.FINDFIRST THEN BEGIN
                                    REPEAT
                                        LeaveRegister2."Balance Days" -= UsedDays;
                                        LeaveRegister2.MODIFY;
                                    UNTIL LeaveRegister2.NEXT = 0;
                                END;



                            END;
                        END ELSE
                            ERROR(text002);
                    END;

                end;
            }
            action("Delete Leave Earned")
            {
                Caption = 'Delete Leave Earned';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    IF "Earn Days" > 0 THEN BEGIN
                        HRPermission.GET(USERID);
                        IF HRPermission."Admin Permission" THEN BEGIN
                            ConfirmDelete := DIALOG.CONFIRM(text001, TRUE);
                            IF ConfirmDelete THEN BEGIN
                                LeaveRegister.RESET;
                                LeaveRegister.SETRANGE("Entry No.", "Entry No.");
                                LeaveRegister.SETRANGE("Employee No.", "Employee No.");
                                IF LeaveRegister.FINDFIRST THEN BEGIN
                                    EarnDays := LeaveRegister."Earn Days";
                                    LeaveStart := LeaveRegister."Leave Start Date";
                                    LeaveType := LeaveRegister."Leave Type Code";
                                    EntryNo := LeaveRegister."Entry No.";
                                    //delete;
                                END;

                                //Update in Leave Account
                                LeaveAccount.RESET;
                                LeaveAccount.SETRANGE("Employee Code", "Employee No.");
                                LeaveAccount.SETRANGE("Leave Type", "Leave Type Code");
                                IF LeaveAccount.FINDFIRST THEN BEGIN
                                    LeaveAccount."Earned Days" -= EarnDays;
                                    LeaveAccount."Balance Days" -= EarnDays;
                                    LeaveAccount.MODIFY;
                                END;
                                //Delete Post Leave Request
                                PostLeave.RESET;
                                PostLeave.SETRANGE("Employee No.", "Employee No.");
                                PostLeave.SETRANGE("Leave Type Code", "Leave Type Code");
                                PostLeave.SETRANGE("Leave Start Date", "Leave Start Date");
                                PostLeave.SETRANGE("Leave End Date", "Leave End Date");
                                IF PostLeave.FINDFIRST THEN
                                    PostLeave.DELETEALL;

                                //Delete Leave Register
                                LeaveRegister1.RESET;
                                LeaveRegister1.SETRANGE("Entry No.", "Entry No.");
                                LeaveRegister1.SETRANGE("Employee No.", "Employee No.");
                                IF LeaveRegister1.FINDFIRST THEN
                                    LeaveRegister1.DELETEALL;
                                //Update Leave Register
                                LeaveRegister2.RESET;
                                LeaveRegister2.SETRANGE("Employee No.", "Employee No.");
                                LeaveRegister2.SETRANGE("Leave Type Code", "Leave Type Code");
                                LeaveRegister2.SETFILTER("Entry No.", '>%1', EntryNo);
                                IF LeaveRegister2.FINDFIRST THEN BEGIN
                                    REPEAT
                                        //MESSAGE(FORMAT(EntryNo));
                                        LeaveRegister2."Balance Days" -= EarnDays;
                                        LeaveRegister2.MODIFY;
                                    UNTIL LeaveRegister2.NEXT = 0;
                                END;

                            END;
                        END ELSE
                            ERROR(text002);
                    END;
                end;
            }
        }
    }

    var
        ConfirmDelete: Boolean;
        HRPermission: Record "33020304";
        UsedDays: Decimal;
        LeaveRegister: Record "33020343";
        LeaveStart: Date;
        LeaveType: Code[10];
        LeaveAccount: Record "33020370";
        LeaveRegister1: Record "33020343";
        LeaveRegister2: Record "33020343";
        EntryNo: Code[20];
        EarnDays: Decimal;
        ActivityLog: Record "33020551";
        PostLeave: Record "33020344";
        AttLedgerEntry: Record "33020556";
        AttStartDate: Date;
        AttEndDate: Date;
        text001: Label 'Do you want to delete this leave?';
        text002: Label 'You do not have permission to delete Leave. Please contact Administration for authority';
}


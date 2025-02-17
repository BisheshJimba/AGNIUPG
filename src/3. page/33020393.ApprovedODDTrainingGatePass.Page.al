page 33020393 "Approved ODD/Training/GatePass"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020423;
    SourceTableView = WHERE(Posted = CONST(Yes),
                            Approve = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Full Name"; "Full Name")
                {
                }
                field("Job Title"; "Job Title")
                {
                }
                field(Department; Department)
                {
                }
                field(Branch; Branch)
                {
                }
                field("Request Date (AD)"; "Request Date (AD)")
                {
                }
                field("Request Date (BS)"; "Request Date (BS)")
                {
                }
                field(Type; Type)
                {
                }
                field("Start Date"; "Start Date")
                {
                }
                field("Start Time"; "Start Time")
                {
                }
                field("End Date"; "End Date")
                {
                }
                field("End Time"; "End Time")
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
                    ODDRec.RESET;
                    ODDRec.SETRANGE("Entry No.", "Entry No.");
                    ODDRec.SETRANGE("Employee Code", "Employee Code");
                    IF ODDRec.FINDFIRST THEN BEGIN
                        IF ODDRec.Type = ODDRec.Type::Gatepass THEN BEGIN
                            REPORT.RUNMODAL(33020358, TRUE, FALSE, ODDRec);
                        END ELSE BEGIN
                            REPORT.RUNMODAL(33020357, TRUE, FALSE, ODDRec);
                        END;
                    END;
                end;
            }
            action("<Action1000000018>")
            {
                Caption = 'Delete Line';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Admin;

                trigger OnAction()
                begin
                    ConfirmPost := DIALOG.CONFIRM(Text001, TRUE);
                    IF ConfirmPost THEN BEGIN
                        ODDRec.RESET;
                        ODDRec.SETRANGE("Entry No.", "Entry No.");
                        ODDRec.SETRANGE("Employee Code", "Employee Code");
                        IF ODDRec.FINDFIRST THEN BEGIN
                            DocNo := ODDRec."Entry No.";
                        END;

                        LeaveRegister.RESET;
                        LeaveRegister.SETRANGE("External No", DocNo);
                        LeaveRegister.SETRANGE("Employee No.", "Employee Code");
                        IF LeaveRegister.FINDFIRST THEN
                            LeaveRegister.DELETEALL;

                        ActivityLog.RESET;
                        ActivityLog.SETRANGE("Start Date", "Start Date");
                        ActivityLog.SETRANGE("Start Time", "Start Time");
                        ActivityLog.SETRANGE("End Date", "End Date");
                        ActivityLog.SETRANGE("End Time", "End Time");
                        ActivityLog.SETRANGE(Type, Type);
                        ActivityLog.SETRANGE("Employee No.", "Employee Code");
                        IF ActivityLog.FINDFIRST THEN
                            ActivityLog.DELETEALL;

                        ODDRec.RESET;
                        ODDRec.SETRANGE("Entry No.", "Entry No.");
                        ODDRec.SETRANGE("Employee Code", "Employee Code");
                        IF ODDRec.FINDFIRST THEN
                            ODDRec.DELETE;
                    END;
                end;
            }
        }
    }

    var
        ODDRec: Record "33020423";
        [InDataSet]
        Visible: Boolean;
        [InDataSet]
        Admin: Boolean;
        DocNo: Code[20];
        LeaveRegister: Record "33020343";
        ActivityLog: Record "33020551";
        HRPermission: Record "33020304";
        ConfirmPost: Boolean;
        LeaveNo: Code[20];
        LeaveReg: Record "33020343";
        DeptCode: Code[10];
        EmployeeRec: Record "5200";
        Text001: Label 'Do you want to delete?';
        text002: Label 'No match found for UserID in Employee Card.';
}


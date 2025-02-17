page 33020430 "Leave Earn"
{
    PageType = Card;
    SourceTable = Table33020398;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Entry No."; "Entry No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Entry Date"; "Entry Date")
                {
                }
                field(NepaliDate; NepaliDate)
                {
                }
                field(Month; Month)
                {
                }
                field("Full Name"; "Full Name")
                {
                    Editable = false;
                }
                field("Emp. Designation"; "Emp. Designation")
                {
                    Editable = false;
                }
                field(Department; Department)
                {
                    Editable = false;
                }
                field(Branch; Branch)
                {
                    Editable = false;
                }
                field("Leave Code"; "Leave Code")
                {

                    trigger OnValidate()
                    begin
                        LeaveAcc.RESET;
                        LeaveAcc.SETRANGE(LeaveAcc."Employee Code", "Employee Code");
                        LeaveAcc.SETRANGE(LeaveAcc."Leave Type", "Leave Code");
                        IF LeaveAcc.FINDFIRST THEN BEGIN
                            OnHandLeave := LeaveAcc."Balance Days";
                        END ELSE BEGIN
                            OnHandLeave := 0.0;
                        END;
                    end;
                }
                field("Leave Description"; "Leave Description")
                {
                    Editable = false;
                }
                field("Earn Days"; "Earn Days")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field(OnHandLeave; OnHandLeave)
                {
                    Caption = 'Leave On Hand';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ConfirmPost := DIALOG.CONFIRM(text0002, TRUE);
                    IF ConfirmPost THEN BEGIN

                        LeaveEarn.SETRANGE(LeaveEarn."Entry No.", "Entry No.");
                        IF LeaveEarn.FINDFIRST THEN BEGIN
                            LeaveEarn.Posted := TRUE;
                            LeaveEarn."Posted Date" := TODAY;
                            LeaveEarn."Posted By" := USERID;
                            LeaveEarn.MODIFY;
                            //MESSAGE(text0001);
                        END;

                        //to update record in leave account
                        LeaveAcc.SETRANGE(LeaveAcc."Employee Code", "Employee Code");
                        LeaveAcc.SETRANGE(LeaveAcc."Leave Type", "Leave Code");
                        IF LeaveAcc.FINDFIRST THEN BEGIN
                            LeaveAcc."Earned Days" := LeaveAcc."Earned Days" + "Earn Days";
                            BalanceDays := LeaveAcc."Balance Days";
                            LeaveAcc."Balance Days" := LeaveAcc."Balance Days" + "Earn Days";
                            LeaveAcc.LastCalculatedDate := "Posted Date";
                            LeaveAcc.MODIFY;
                        END ELSE BEGIN
                            LeaveAcc.INIT;
                            LeaveAcc."Employee Code" := "Employee Code";
                            LeaveAcc."Employee Name" := "Full Name";
                            LeaveAcc."Leave Type" := "Leave Code";
                            LeaveAcc."Earned Days" := "Earn Days";
                            LeaveAcc.LastCalculatedDate := "Posted Date";
                            LeaveAcc."Balance Days" := "Earn Days";
                            LeaveAcc.INSERT;
                        END;

                        //Update record in Leave Register
                        LeaveRegister.INIT;
                        LeaveRegister."Employee No." := "Employee Code";
                        LeaveRegister."Full Name" := "Full Name";
                        LeaveRegister."Leave Start Date" := "Posted Date";
                        LeaveRegister."Leave End Date" := "Posted Date";
                        LeaveRegister."Work Shift Code" := "Work Shift Code";
                        LeaveRegister."Leave Type Code" := "Leave Code";
                        LeaveRegister."Leave Description" := "Leave Description";
                        LeaveRegister."Posting Date" := "Posted Date";
                        LeaveRegister."Posting Time" := "Posted Time";
                        LeaveRegister.Approved := TRUE;
                        LeaveRegister."Approved By" := USERID;
                        LeaveRegister."Approved Date" := "Posted Date";
                        LeaveRegister.Branch := Branch;
                        LeaveRegister.Department := Department;
                        LeaveRegister."Earn Days" := "Earn Days";
                        LeaveRegister."Balance Days" := BalanceDays + "Earn Days";
                        LeaveRegister."Request Date" := "Posted Date";
                        LeaveRegister."Request Time" := "Posted Time";
                        LeaveRegister."Pay Type" := "Pay Type";
                        //LeaveRegister."Leave Start Date" := "Posted Date";
                        //LeaveRegister."Leave End Date" := "Posted Date";
                        LeaveRegister."Leave Start Time" := "Posted Time";
                        LeaveRegister."Leave End Time" := "Posted Time";
                        LeaveRegister.Remarks := Remarks;
                        LeaveRegister.INSERT(TRUE);
                        MESSAGE(text0001);
                    END;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        HRPermission.GET(USERID);
        IF NOT HRPermission."Leave Earn" THEN
            ERROR(Text0003);

        "Entry Date" := TODAY;
    end;

    var
        LeaveEarn: Record "33020398";
        text0001: Label 'Leave Earn is posted successfully!';
        LeaveAcc: Record "33020370";
        OnHandLeave: Decimal;
        ConfirmPost: Boolean;
        text0002: Label 'Do you want to Post?';
        HRPermission: Record "33020304";
        Text0003: Label 'You do not have permission for Leave Earn in HR Permisssion Table';
        LeaveRegister: Record "33020343";
        EmpRec: Record "5200";
        BalanceDays: Decimal;
}


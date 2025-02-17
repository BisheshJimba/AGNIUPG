page 33020396 "Work Shift Card"
{
    PageType = Card;
    SourceTable = Table33020349;

    layout
    {
        area(content)
        {
            field("Entry No."; "Entry No.")
            {

                trigger OnAssistEdit()
                begin
                    IF AssistEdit THEN
                        CurrPage.UPDATE();
                end;
            }
            field("Employee Code"; "Employee Code")
            {
            }
            field("Employee Name"; "Employee Name")
            {
                Editable = false;
            }
            field("Changed Date"; "Changed Date")
            {
            }
            field("Shift Code"; "Shift Code")
            {
            }
            field(Shift; Shift)
            {
                Editable = false;
            }
            field("In Time"; "In Time")
            {
                Editable = false;
            }
            field("Out Time"; "Out Time")
            {
                Editable = false;
            }
            field("Lunch Start"; "Lunch Start")
            {
                Editable = false;
            }
            field("Lunch End"; "Lunch End")
            {
                Editable = false;
            }
            field("Work Hours"; "Work Hours")
            {
                Editable = false;
            }
            field("Lunch Minutes"; "Lunch Minutes")
            {
                Editable = false;
            }
            field(Remarks; Remarks)
            {
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
                    ConfirmPost := DIALOG.CONFIRM(text001, TRUE);
                    IF ConfirmPost THEN BEGIN
                        WorkShiftRec.RESET;
                        WorkShiftRec.SETRANGE("Entry No.", "Entry No.");
                        WorkShiftRec.SETRANGE("Employee Code", "Employee Code");
                        IF WorkShiftRec.FINDFIRST THEN BEGIN
                            WorkShiftRec.Post := TRUE;
                            WorkShiftRec."Posted By" := USERID;
                            WorkShiftRec."Posted Date" := TODAY;
                            WorkShiftRec.MODIFY;
                        END;

                        //Updating the workshift in Table- Employee
                        EmpRec.RESET;
                        EmpRec.SETRANGE("No.", "Employee Code");
                        IF EmpRec.FINDFIRST THEN BEGIN
                            EmpRec."Work Shift Code" := "Shift Code";
                            EmpRec."Work Shift Description" := Shift;
                            EmpRec.MODIFY;
                        END;
                    END;
                end;
            }
        }
    }

    var
        WorkShiftRec: Record "33020349";
        EmpRec: Record "5200";
        ConfirmPost: Boolean;
        text001: Label 'Do you want to Post?';
}


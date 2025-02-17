page 33020443 "Employee Activity History"
{
    Caption = 'Employee Activity History';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table33020401;
    SourceTableView = WHERE(Posted = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater()
            {
                field("To Manager ID"; "To Manager ID")
                {
                }
                field("Effective Date"; "Effective Date")
                {
                }
                field("To Branch"; "To Branch")
                {
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Employee Name"; "Employee Name")
                {
                }
                field("To Job Title"; "To Job Title")
                {
                }
                field("To Department"; "To Department")
                {
                }
                field("To Grade"; "To Grade")
                {
                }
                field(Activity; Activity)
                {
                }
                field("To Manager Name"; "To Manager Name")
                {
                }
                field("Basic Pay"; "Basic Pay")
                {
                }
                field("Dearness Allowance"; "Dearness Allowance")
                {
                }
                field("Other Allowance"; "Other Allowance")
                {
                }
                field(Total; Total)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000021>")
            {
                Caption = 'Un-Post Line';
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ConfirmPost := DIALOG.CONFIRM(text0002, TRUE);
                    IF ConfirmPost THEN BEGIN
                        ActivityRec.RESET;
                        ActivityRec.SETCURRENTKEY("Employee Code", "Effective Date");
                        ActivityRec.SETRANGE("Employee Code", "Employee Code");
                        ActivityRec.FINDLAST;
                        LastEntry := ActivityRec."Activity No.";
                        LineNo := EmployeeActivity."Line No.";
                        MESSAGE(FORMAT(LastEntry));

                        EmployeeActivity.RESET;
                        EmployeeActivity.SETRANGE("Activity No.", LastEntry);
                        EmployeeActivity.SETRANGE("Line No.", LineNo);
                        IF EmployeeActivity.FINDFIRST THEN BEGIN
                            EmployeeActivity.Posted := FALSE;
                            EmployeeActivity.MODIFY;
                        END;
                        MESSAGE(text0003);
                    END;
                end;
            }
        }
    }

    var
        EmpRec: Record "5200";
        EmpActivity: Record "33020401";
        Emp1Rec: Record "5200";
        ConfirmPost: Boolean;
        LastEntry: Code[20];
        LineNo: Integer;
        ActivityRec: Record "33020401";
        EmployeeActivity: Record "33020401";
        text0001: Label 'Do you want to Delete?';
        text0002: Label 'Do you want to Un-Post?';
        text0003: Label 'The Activity has been Un-Posted, Please check the Employee Activity List.';
}


page 33020370 "Leave Encash/WriteOff Card"
{
    CardPageID = "Leave Encash/WriteOff Card";
    DeleteAllowed = false;
    Editable = true;
    PageType = Card;
    SourceTable = Table33020362;

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
                field("Employee Name"; "Employee Name")
                {
                    Editable = false;
                }
                field(Designation; Designation)
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
                field("Requested Date (AD)"; "Requested Date (AD)")
                {
                    Editable = false;
                }
                field("Requested Date (BS)"; "Requested Date (BS)")
                {
                    Editable = false;
                }
                field(Type; Type)
                {
                }
                field("Leave Type"; "Leave Type")
                {

                    trigger OnValidate()
                    begin
                        LeaveType.RESET;
                        LeaveType.SETRANGE("Leave Type Code", "Leave Type");
                        IF LeaveType.FINDFIRST THEN BEGIN
                            IF LeaveType.Encashable = FALSE THEN
                                ERROR(Text005, "Leave Type");
                        END;

                        LeaveAccount.RESET;
                        LeaveAccount.SETRANGE("Employee Code", "Employee Code");
                        LeaveAccount.SETRANGE("Leave Type", "Leave Type");
                        IF LeaveAccount.FINDFIRST THEN BEGIN
                            "On Hand Days" := LeaveAccount."Balance Days";
                        END ELSE BEGIN
                            ERROR('You do not have record in Leave Account. Contact administrator');
                        END;
                    end;
                }
                field("On Hand Days"; "On Hand Days")
                {
                    Editable = false;
                }
                field("Consumed Days"; "Consumed Days")
                {

                    trigger OnValidate()
                    begin
                        LeaveType.SETRANGE("Leave Type Code", "Leave Type");
                        IF LeaveType.FIND('-') THEN BEGIN
                            IF ("Consumed Days" < LeaveType."Min. Balance Days for Encash") THEN
                                ERROR(Text001)
                            ELSE
                                IF ("Consumed Days" > LeaveType."Maximum Encashable Limit") THEN
                                    ERROR(Text002);
                        END;

                        IF ("Consumed Days" > "On Hand Days") THEN
                            ERROR(Text004);
                    end;
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
            action("Encash/Write-Off")
            {
                Image = WageLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    TESTFIELD("Consumed Days");

                    ConfirmPost := DIALOG.CONFIRM(Text003, TRUE);
                    IF ConfirmPost THEN BEGIN

                        Posted := TRUE;
                        "Posted Date" := TODAY;
                        "Posted By" := USERID;
                        MODIFY;


                        //Updatinge in Leave Account Table
                        LeaveAccount.SETRANGE("Employee Code", "Employee Code");
                        LeaveAccount.SETRANGE("Leave Type", "Leave Type");
                        IF LeaveAccount.FIND('-') THEN BEGIN
                            LeaveAccount."Balance Days" -= "Consumed Days";
                            LeaveAccount.LastCalculatedDate := TODAY;
                            IF Type = Type::Encash THEN BEGIN
                                LeaveAccount."Total Enchased Days" += "Consumed Days";
                            END;
                            IF Type = Type::WriteOff THEN BEGIN
                                LeaveAccount."Total WriteOff Days" += "Consumed Days";
                            END;
                            LeaveAccount.MODIFY;
                        END;

                        //Finding the balance days from Leave Register
                        LeaveRegister1.RESET;
                        LeaveRegister1.SETRANGE("Employee No.", "Employee Code");
                        LeaveRegister1.SETRANGE("Leave Type Code", "Leave Type");
                        IF LeaveRegister1.FINDLAST THEN BEGIN
                            balancedays := LeaveRegister1."Balance Days";
                        END;

                        //Inserting new line for Encashment/ WriteOff in Leave Register Table
                        CLEAR(LeaveRegister);
                        LeaveRegister.INIT;
                        LeaveRegister."Employee No." := "Employee Code";
                        EmpRec.RESET;
                        EmpRec.SETRANGE("No.", "Employee Code");
                        IF EmpRec.FINDFIRST THEN BEGIN
                            LeaveRegister."First Name" := EmpRec."First Name";
                            LeaveRegister."Middle Name" := EmpRec."Middle Name";
                            LeaveRegister."Last Name" := EmpRec."Last Name";
                            LeaveRegister."Work Shift Code" := EmpRec."Work Shift Code";
                            LeaveRegister.Branch := EmpRec."Branch Name";
                            LeaveRegister.Department := EmpRec."Department Name";
                            LeaveRegister."Job Title Code" := EmpRec."Job Title code";
                            LeaveRegister."Job Title" := EmpRec."Job Title";
                        END;
                        LeaveRegister."Leave Type Code" := "Leave Type";
                        LeaveRegister."Leave Start Date" := "Requested Date (AD)";
                        LeaveRegister."Leave Start Time" := "Requested Time";
                        LeaveRegister."Leave End Date" := "Requested Date (AD)";
                        LeaveRegister."Leave End Time" := "Requested Time";

                        LeaveRegister.Remarks := Remarks;
                        LeaveRegister.Approved := TRUE;
                        LeaveRegister."Approved By" := USERID;
                        LeaveRegister."Approved Date" := TODAY;
                        IF Type = Type::Encash THEN BEGIN
                            LeaveRegister."Enchase Days" := "Consumed Days";
                        END;
                        IF Type = Type::WriteOff THEN BEGIN
                            LeaveRegister."Write-off Days" := "Consumed Days";
                        END;
                        LeaveRegister."Balance Days" := balancedays - "Consumed Days";
                        LeaveRegister.INSERT(TRUE);
                        LeaveRegister.FINDLAST;
                        LeaveRegisterNo := LeaveRegister."Entry No.";
                        LeaveRegister.MODIFY;



                    END;
                end;
            }
        }
    }

    var
        LeaveType: Record "33020345";
        EmpRec: Record "5200";
        LeaveRegister: Record "33020343";
        LeaveAccount: Record "33020370";
        Text001: Label 'Earned Days is less than Minimum Encashable Days.';
        Text002: Label 'Requested Encashable Days exceeds Maximum Encashable Limit';
        GetFiscalYear: Record "33020302";
        ConfirmPost: Boolean;
        Text003: Label 'Do you want to Post?';
        Text004: Label 'You have less On hand Leave than you are consuming!';
        Confirm: Dialog;
        Text005: Label 'Leave type %1 is not Encashable/Writeoff!';
        balancedays: Decimal;
        LeaveRegisterNo: Code[20];
        LeaveRegister1: Record "33020343";
}


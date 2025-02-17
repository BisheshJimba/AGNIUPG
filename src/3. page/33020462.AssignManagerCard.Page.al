page 33020462 "Assign Manager Card"
{
    PageType = Card;
    SourceTable = Table33020408;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Assign No."; "Assign No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit() THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Department Code"; "Department Code")
                {
                }
                field("Department Name"; "Department Name")
                {
                }
                field(Designation; Designation)
                {

                    trigger OnValidate()
                    begin
                        MasterManagerRec.RESET;
                        MasterManagerRec.SETRANGE("Department Code", "Department Code");
                        MasterManagerRec.SETRANGE(Desgination, Designation);
                        IF MasterManagerRec.FINDFIRST THEN BEGIN
                            "Previous Manager Code" := MasterManagerRec."Manager ID";
                            "Previous Manager" := MasterManagerRec."Manager Name";
                        END;
                    end;
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Employee Name"; "Employee Name")
                {
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
                    TESTFIELD("Employee Code");
                    TESTFIELD("Department Code");
                    TESTFIELD(Designation);
                    ConfirmPost := DIALOG.CONFIRM(text0001, TRUE);
                    IF ConfirmPost THEN BEGIN
                        MasterManagerRec.RESET;
                        MasterManagerRec.SETRANGE("Department Code", "Department Code");
                        MasterManagerRec.SETRANGE(Desgination, Designation);
                        IF MasterManagerRec.FINDFIRST THEN BEGIN
                            MasterManagerRec."Manager ID" := "Employee Code";
                            MasterManagerRec."Manager Name" := "Employee Name";
                            "Assignment Posted" := TRUE;
                            "Assignment Date" := TODAY;
                            "Assignment Posted By" := USERID;
                            MasterManagerRec.MODIFY;

                            EmpRec.RESET;
                            EmpRec.SETRANGE("Manager Department Code", "Department Code");
                            EmpRec.SETRANGE("Manager's Designation", Designation);
                            IF EmpRec.FINDSET THEN BEGIN
                                REPEAT
                                    EmpActRec1.INIT;
                                    LineNo += 10000;
                                    EmpActRec1."Line No." := LineNo;
                                    EmpActRec1."From Branch Code" := EmpRec."Branch Code";
                                    EmpActRec1."From Branch" := EmpRec."Branch Name";
                                    EmpActRec1."To Branch Code" := EmpRec."Branch Code";
                                    EmpActRec1."To Branch" := EmpRec."Branch Name";
                                    EmpActRec1."Employee Code" := EmpRec."No.";
                                    EmpActRec1."Employee Name" := EmpRec."Full Name";
                                    EmpActRec1."From Job Title Code" := EmpRec."Job Title code";
                                    EmpActRec1."From Job Title" := EmpRec."Job Title";
                                    EmpActRec1."To Job Title Code" := EmpRec."Job Title code";
                                    EmpActRec1."To Job Title" := EmpRec."Job Title";
                                    EmpActRec1."From Department Code" := EmpRec."Department Code";
                                    EmpActRec1."From Department" := EmpRec."Department Name";
                                    EmpActRec1."To Department Code" := EmpRec."Department Code";
                                    EmpActRec1."To Department" := EmpRec."Department Name";
                                    EmpActRec1."From Grade" := EmpRec."Grade Code";
                                    EmpActRec1."To Grade" := EmpRec."Grade Code";
                                    //EmpActRec1."From Reporting Designation" := EmpRec."Manager's Designation"; //error in 2009
                                    //EmpActRec1."To Reporting Designation" := Designation;
                                    EmpActRec1."From Manager Name" := EmpRec.Manager;
                                    EmpActRec1."To Manager Name" := "Employee Name";
                                    //EmpActRec1."From Reporting Department" := EmpRec."Manager Department Code";
                                    //EmpActRec1."To Reporting Department" := "Department Code";
                                    EmpActRec1.INSERT(TRUE);
                                    EmpActRec1.FIND('+');
                                    EmpActNo := EmpActRec1."Activity No.";
                                UNTIL EmpRec.NEXT = 0;
                            END;
                        END;
                        MESSAGE(text0002);
                        IF MasterManagerRec.COUNT = 0 THEN
                            MESSAGE(text0003);

                    END;
                end;
            }
        }
    }

    var
        MasterManagerRec: Record "33020407";
        ConfirmPost: Boolean;
        text0001: Label 'Do you want to Post?';
        text0002: Label 'New Activity has been generated in Employee Activity. Manager has been Successfull Posted.';
        text0003: Label 'The Designation does not exit in Master of Managers. Entry new line from Master of Manager List.';
        EmpRec: Record "5200";
        EmpActNo: Code[20];
        EmpActRec: Record "33020401";
        EmpActRec1: Record "33020401";
        Text: Text[30];
        Position: Integer;
        Intext: Text[30];
        Int: Boolean;
        VarInteger: Integer;
        HRSetup: Record "5218";
        NoSeriesMngt: Codeunit "396";
        "Activity No.": Code[20];
        "No. Series": Code[10];
        LineNo: Integer;
}


page 33020389 "Promotion Card"
{
    PageType = Card;
    SourceTable = Table33020361;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Employee Code"; "Employee Code")
                {
                }
                field(Name; Name)
                {
                }
                field(Designation; Designation)
                {
                }
                field(Department; Department)
                {
                }
                field(Branch; Branch)
                {
                }
            }
            group("Appraisal Record")
            {
                field("Appraiser 1 Name"; "Appraiser 1 Name")
                {
                }
                field("Appraiser 2 Name"; "Appraiser 2 Name")
                {
                }
                field("Overall Rating"; "Overall Rating")
                {
                }
                field("Previous Appraisal Rating 1"; "PrevAppRating I")
                {
                }
                field("Previous Appraisal Rating 2"; "PrevAppRating II")
                {
                }
                field("Remarks II"; "Remarks II")
                {
                }
            }
            group(Administration)
            {
                field("<YearsWorked>"; YearsWorked)
                {
                    Caption = 'No. of Years Worked';
                }
                field("Highest Qualification"; Qualification)
                {
                }
                field("Previous Work Experience"; "Prev.Experience")
                {
                    Visible = false;
                }
                field("Last Promoted Date"; PromotedDate)
                {
                    Caption = 'Last Promoted Date';
                }
                field("Present Job Title"; JobTitle)
                {
                }
                field("New Job Title"; NewJobTitle)
                {
                    TableRelation = "Job Title".Description;
                }
                field("Present Grade"; PresentGrade)
                {
                }
                field("New Grade"; NewGrade)
                {
                    TableRelation = Grades."Grade Code";
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Approve)
            {
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ConfirmApprove := DIALOG.CONFIRM(Text002, FALSE);
                    IF ConfirmApprove THEN BEGIN
                        PromotionRec.INIT;
                        PromotionRec."Employee Code" := "Employee Code";
                        EmpRec.SETRANGE("No.", "Employee Code");
                        IF EmpRec.FIND('-') THEN BEGIN
                            PromotionRec."Employee Name" := EmpRec."Full Name";
                            PromotionRec."Current Grade" := EmpRec."Grade Code";
                            PromotionRec."Current Designation" := EmpRec."Job Title";
                        END;
                        PromotionRec."Promoted Grade" := NewGrade;
                        PromotionRec."Promoted Designation" := NewJobTitle;
                        PromotionRec."Approved By" := USERID;
                        PromotionRec."Approved Date" := TODAY;
                        PromotionRec.INSERT;

                        EmpRec.RESET;
                        EmpRec.SETRANGE("No.", "Employee Code");
                        IF EmpRec.FIND('-') THEN BEGIN
                            EmpRec."Grade Code" := NewGrade;
                            EmpRec."Job Title" := NewJobTitle;
                            EmpRec.MODIFY;
                        END;

                        //sm to update in appraisal table
                        Appraisal.SETRANGE("Employee Code", "Employee Code");
                        IF Appraisal.FIND('-') THEN BEGIN
                            Appraisal.Promotion := TRUE;
                            Appraisal.MODIFY;
                        END;

                    END ELSE BEGIN
                        MESSAGE(Text004, USERID);
                    END;
                end;
            }
            action(Disapprove)
            {
                Caption = 'Disapprove';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ConfirmDisapprove := DIALOG.CONFIRM(Text003, FALSE);
                    IF NOT ConfirmDisapprove THEN BEGIN
                        MESSAGE(Text004, USERID);
                    END;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        i: Integer;
    begin
        RESET;
        SETCURRENTKEY("Employee Code");
        i := 1;
        SETRANGE("Employee Code", "Employee Code");
        IF FIND('+') THEN BEGIN
            REPEAT
                IF i = 1 THEN BEGIN
                    "Overall Rating" := "Overall Rating";
                END
                ELSE
                    IF i = 2 THEN BEGIN
                        "PrevAppRating I" := Convert("Overall Rating");
                    END
                    ELSE
                        IF i = 3 THEN
                            "PrevAppRating II" := Convert("Overall Rating");
                i := i + 1;
            UNTIL NEXT(-1) = 0;
        END;

        EmpRec.SETRANGE("No.", "Employee Code");
        IF EmpRec.FIND('-') THEN
            YearsWorked := (TODAY - EmpRec."Employment Date") DIV 365;
        PresentGrade := EmpRec."Grade Code";
        JobTitle := EmpRec."Job Title";
        /*
        //Qualification of the Employee
        EmpQualification.SETRANGE("No.","Employee Code");
        IF EmpQualification.FIND('-') THEN BEGIN
            Qualification := EmpQualification.Description;
        END;
        */
        Education.SETRANGE(Education."Employee No.", "Employee Code");
        IF Education.FINDFIRST THEN BEGIN
            Qualification := Education.M_Faculty;
        END;
        //Previous Work Experience
        /*
        PrevWrkExp.SETRANGE(PrevWrkExp."No.","Employee Code");
        IF PrevWrkExp.FIND('-') THEN BEGIN
             REPEAT
                 "Prev.Experience" := "Prev.Experience" + PrevWrkExp."Years Worked";
             UNTIL PrevWrkExp.NEXT = 0;
        END;
        */
        PromotionRec.RESET;
        PromotionRec.SETRANGE(PromotionRec."Employee Code", "Employee Code");
        IF PromotionRec.FINDLAST THEN BEGIN
            PromotedDate := PromotionRec."Approved Date";
        END;

    end;

    var
        "PrevAppRating I": Text[30];
        "PrevAppRating II": Text[30];
        Appraisal: Record "33020361";
        PresentGrade: Code[10];
        NewGrade: Code[10];
        YearsWorked: Integer;
        Qualification: Text[100];
        EmpQualification: Record "5203";
        "Prev.Experience": Integer;
        PrevWrkExp: Record "33020333";
        EmpRec: Record "5200";
        JobTitle: Text[50];
        PromotionRec: Record "33020372";
        NewJobTitle: Text[80];
        Text002: Label 'Are you sure - Approve?';
        Text003: Label 'Are you sure - Disapprove?';
        Text004: Label 'Aborted by user - %1!';
        Text005: Label 'Promotion not approved or disapproved. Please verify!';
        ConfirmApprove: Boolean;
        ConfirmDisapprove: Boolean;
        Education: Record "33020383";
        PromotedDate: Date;

    [Scope('Internal')]
    procedure Convert(Rating: Integer): Text[30]
    begin
        IF Rating = 1 THEN
            EXIT('A')
        ELSE
            IF Rating = 2 THEN
                EXIT('B')
            ELSE
                IF Rating = 3 THEN
                    EXIT('C')
                ELSE
                    IF Rating = 4 THEN
                        EXIT('D');
    end;
}


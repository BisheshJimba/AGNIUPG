page 33020438 "Second Appraisal List"
{
    Editable = false;
    PageType = List;
    SourceTable = Table5200;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Full Name"; "Full Name")
                {
                }
                field("First Appraised"; "First Appraised")
                {
                }
                field("Second Appraised"; "Second Appraised")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Appraise)
            {
                Caption = 'Appraise';
                Promoted = true;
                RunPageMode = Edit;

                trigger OnAction()
                begin
                    //msg('123');

                    EmpAppraisal.SETRANGE(EmpAppraisal."Employee Code", "No.");
                    IF EmpAppraisal.FINDFIRST THEN BEGIN
                        IF EmpAppraisal.IsAppraised1 = FALSE THEN
                            ERROR(text0001)
                        ELSE
                            IF EmpAppraisal."Appraisal Type" = EmpAppraisal."Appraisal Type"::"Half-Annual" THEN
                                ERROR(text0002)
                            ELSE BEGIN
                                Calendar.SETRANGE(Calendar."English Date", TODAY);
                                IF Calendar.FIND('-') THEN
                                    "Fiscal Year" := Calendar."Fiscal Year";

                                EmpAppraisal.RESET;
                                EmpAppraisal.SETRANGE(EmpAppraisal."Employee Code", "No.");
                                IF EmpAppraisal.FINDFIRST THEN BEGIN
                                    EmpAppraisal.VALIDATE("Appraiser 2", SecondAppraisrID);
                                    EmpAppraisal.MODIFY;
                                END;

                                EmpAppraisal.RESET;
                                EmpAppraisal.SETRANGE(EmpAppraisal."Employee Code", "No.");
                                EmpAppraisal.SETRANGE(EmpAppraisal."Fiscal Year", "Fiscal Year");
                                AppraisalPage.SETTABLEVIEW(EmpAppraisal);
                                AppraisalPage.SETRECORD(EmpAppraisal);
                                AppraisalPage.RUN;

                            END;
                    END;
                end;
            }
            action("View 1st Appraisal")
            {
                Caption = 'View 1st Appraisal';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 33020434;
                RunPageLink = Employee Code=FIELD(No.),
                              Appraisal Type=CONST(Annual);

                trigger OnAction()
                begin
                    //msg('123');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
           /*   EmpRec.SETRANGE(EmpRec."User ID", USERID);
               IF EmpRec.FIND('-') THEN BEGIN
                  SecondAppraisrID := EmpRec."No.";
               END;
        
               SETRANGE("Second Appraisal ID",SecondAppraisrID);*/

    end;

    var
        EmpRec: Record "5200";
        SecondAppraisrID: Code[20];
        text0001: Label 'First Appraisal is not yet done for this employee.';
        EmpAppraisal: Record "33020361";
        "Fiscal Year": Code[10];
        AppraisalPage: Page "33020372";
                           Calendar: Record "33020302";
                           text0002: Label 'Half Annual Appraisel is only done. Annual Appraisal is not yet done!';
}


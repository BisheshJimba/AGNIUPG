page 33020482 "Apply for Internal Vacancy"
{
    PageType = List;
    SourceTable = Table33020415;
    SourceTableView = WHERE(Closed = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vacancy Code"; "Vacancy Code")
                {
                }
                field("For Job Title Code"; "For Job Title Code")
                {
                }
                field("For Job Title"; "For Job Title")
                {
                }
                field("Posted Date"; "Posted Date")
                {
                }
                field("Closed Date"; "Closed Date")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Apply)
            {
                Caption = 'Apply';
                Image = ApplyTemplate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF TODAY > "Closed Date" THEN
                        ERROR('This Vacancy is closed!');

                    IntAppRec.RESET;
                    IntAppRec.SETRANGE("Vacancy Code", "Vacancy Code");
                    IntAppRec.SETRANGE("Post Applied For", "For Job Title");
                    IntAppRec.SETRANGE("User ID", USERID);
                    IF IntAppRec.FINDFIRST THEN BEGIN
                        PageInternalApp.SETTABLEVIEW(IntAppRec);
                        PageInternalApp.SETRECORD(IntAppRec);
                        PageInternalApp.RUN;
                    END ELSE BEGIN
                        IntAppRec.INIT;
                        IntAppRec."Vacancy Code" := "Vacancy Code";
                        IntAppRec."Post Applied For" := "For Job Title";
                        IntAppRec."User ID" := USERID;
                        IntAppRec.INSERT(TRUE);
                        IntAppRec.MODIFY;

                        IntAppRec.FINDLAST;
                        "LastAppNo." := IntAppRec."Applicant No.";

                        IntAppRec.RESET;
                        IntAppRec.SETRANGE("Vacancy Code", "Vacancy Code");
                        IntAppRec.SETRANGE("Post Applied For", "For Job Title");
                        IntAppRec.SETRANGE("User ID", USERID);
                        PageInternalApp.SETTABLEVIEW(IntAppRec);
                        PageInternalApp.SETRECORD(IntAppRec);
                        PageInternalApp.RUN;
                    END;
                end;
            }
        }
    }

    var
        IntAppRec: Record "33020416";
        PageInternalApp: Page "33020481";
        "LastAppNo.": Code[20];
        IntVacRec: Record "33020415";
}


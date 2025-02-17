page 33020441 "Employee Activity List"
{
    Caption = 'Employee Activity List';
    CardPageID = "Employee Activity Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020401;
    SourceTableView = WHERE(Posted = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Activity No."; "Activity No.")
                {
                }
                field("Employee Name"; "Employee Name")
                {
                }
                field(Activity; Activity)
                {
                }
                field("Effective Date"; "Effective Date")
                {
                }
                field(Designation; Designation)
                {
                }
                field("From Branch"; "From Branch")
                {
                }
                field("To Branch"; "To Branch")
                {
                }
                field("To Job Title"; "To Job Title")
                {
                }
                field("From Job Title"; "From Job Title")
                {
                }
                field("To Job Title Code"; "To Job Title Code")
                {
                }
                field(Remark; Remark)
                {
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
            action("<Action1000000012>")
            {
                Caption = 'Appointment Letter';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ActivityRec.RESET;
                    ActivityRec.SETRANGE("Activity No.", "Activity No.");
                    ActivityRec.SETRANGE(Activity, Activity::Probation);
                    IF ActivityRec.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(33020350, TRUE, FALSE, ActivityRec);
                    END;
                end;
            }
            action("<Action1000000013>")
            {
                Caption = 'Probation Extension Letter';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ActivityRec.RESET;
                    ActivityRec.SETRANGE("Activity No.", "Activity No.");
                    ActivityRec.SETRANGE(Activity, Activity::"Probation Extension");
                    IF ActivityRec.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(33020351, TRUE, FALSE, ActivityRec);
                    END;
                end;
            }
            action("<Action1000000014>")
            {
                Caption = 'Confirmation Letter';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ActivityRec.RESET;
                    ActivityRec.SETRANGE("Activity No.", "Activity No.");
                    ActivityRec.SETRANGE(Activity, Activity::Confirmed);
                    IF ActivityRec.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(33020348, TRUE, FALSE, ActivityRec);
                    END;
                end;
            }
            action("<Action1000000015>")
            {
                Caption = 'Upgradation Letter';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    ActivityRec.RESET;
                    ActivityRec.SETRANGE("Activity No.", "Activity No.");
                    ActivityRec.SETRANGE(Activity, Activity::Upgradation);
                    IF ActivityRec.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(33020353, TRUE, FALSE, ActivityRec);
                    END;
                end;
            }
            action("Promotion Letter")
            {
                Caption = 'Promotion Letter';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ActivityRec.RESET;
                    //ActivityRec.SETRANGE("Activity No.","Activity No.");
                    ActivityRec.SETRANGE(Activity, Activity::Promotion);
                    IF ActivityRec.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(33020356, TRUE, FALSE, ActivityRec);
                    END;
                end;
            }
            action("<Action1000000020>")
            {
                Caption = 'Upgradation Letter';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ActivityRec.RESET;
                    ActivityRec.SETRANGE("Activity No.", "Activity No.");
                    ActivityRec.SETRANGE(Activity, Activity::Upgradation);
                    IF ActivityRec.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(33020354, TRUE, FALSE, ActivityRec);
                    END;
                end;
            }
            action("<Action1000000016>")
            {
                Caption = 'Transfer Letter';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ActivityRec.RESET;
                    ActivityRec.SETRANGE("Activity No.", "Activity No.");
                    IF (Activity = Activity::"Permanent Transfer") OR (Activity = Activity::"Temporary Transfer") THEN
                        IF ActivityRec.FINDFIRST THEN BEGIN
                            REPORT.RUNMODAL(33020349, TRUE, FALSE, ActivityRec);
                        END;
                end;
            }
            action("<Action1000000017>")
            {
                Caption = 'Short Experience Letter';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    ActivityRec.RESET;
                    ActivityRec.SETRANGE("Activity No.", "Activity No.");
                    IF ActivityRec.FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(33020347, TRUE, FALSE, ActivityRec);
                    END;
                end;
            }
            action("<Action1000000018>")
            {
                Caption = 'Resignation Acceptance Letter';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ActivityRec.RESET;
                    ActivityRec.SETRANGE("Activity No.", "Activity No.");
                    IF (Activity = Activity::Terminated) OR (Activity = Activity::Left) OR (Activity = Activity::Retired)
                    THEN
                        IF ActivityRec.FINDFIRST THEN BEGIN
                            REPORT.RUNMODAL(33020352, TRUE, FALSE, ActivityRec);
                        END;
                end;
            }
        }
    }

    var
        ActivityRec: Record "33020401";
        Grade: Record "33020324";
        Category: Text[30];
}


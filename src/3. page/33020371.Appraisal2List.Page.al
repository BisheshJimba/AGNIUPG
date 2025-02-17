page 33020371 "Appraisal 2 List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PopulateAllFields = true;
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
                field("Branch Code"; "Branch Code")
                {
                }
                field("Department Name"; "Department Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Do Second Appraisal")
            {
                Caption = 'Do Second Appraisal';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ProgressPage.SETTABLEVIEW(Rec);
                    ProgressPage.SETRECORD(Rec);
                    ProgressPage.RUN;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //Setting filter to list out Employee Codes under the Current UserID
        HRPermission.GET(USERID);
        IF NOT HRPermission."HR Admin" THEN BEGIN
            EmployeeRec.RESET;
            EmployeeRec.SETCURRENTKEY("User ID");
            EmployeeRec.SETRANGE("User ID", USERID);
            IF EmployeeRec.FINDFIRST THEN BEGIN
                SETRANGE("First Appraisal ID", EmployeeRec."No.");
            END;
        END;
    end;

    var
        Appr: Record "33020361";
        EmployeeRec: Record "5200";
        ManagerID: Code[10];
        SecondAppraiserID: Code[20];
        HRPermission: Record "33020304";
        ProgressPage: Page "33020304";
}


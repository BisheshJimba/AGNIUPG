page 33020306 "Employee- LeaveRestrict List"
{
    PageType = List;
    SourceTable = Table5200;
    SourceTableView = WHERE(Status = CONST(Confirmed),
                            Restrict Leave Earn=CONST(Yes));

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
                field("Job Title"; "Job Title")
                {
                }
                field("Branch Name"; "Branch Name")
                {
                }
                field("Department Name"; "Department Name")
                {
                }
                field("Grade Code"; "Grade Code")
                {
                }
                field(Status; Status)
                {
                }
                field("Manager ID"; "Manager ID")
                {
                }
                field(Manager; Manager)
                {
                }
                field("Restrict Leave Earn"; "Restrict Leave Earn")
                {
                }
                field("Leave Restrited Date"; "Leave Restrited Date")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        HRPermission.GET(USERID);
        IF NOT HRPermission."Admin Permission" THEN
            ERROR('You do not have Permission to Open this Page!');
    end;

    var
        HRPermission: Record "33020304";
}


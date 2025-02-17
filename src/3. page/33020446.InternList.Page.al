page 33020446 "Intern List"
{
    CardPageID = "Intern Card";
    PageType = List;
    SourceTable = Table33020402;
    SourceTableView = WHERE(Posted = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("First Name"; "First Name")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("College/ Institution Name"; "College/ Institution Name")
                {
                }
                field(Education; Education)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("Direct Supervisor"; "Direct Supervisor")
                {
                }
                field("Department Name"; "Department Name")
                {
                }
                field("Branch Name"; "Branch Name")
                {
                }
                field("Start Date"; "Start Date")
                {
                }
                field("Complete Date"; "Complete Date")
                {
                }
                field("Duration (Months)"; "Duration (Months)")
                {
                }
                field(Attendance; Attendance)
                {
                }
                field(IDate; IDate)
                {
                }
                field(Report; Report)
                {
                }
                field("Experience Letter"; "Experience Letter")
                {
                }
                field(Company; Company)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Print-Appointment Letter")
            {
                Caption = 'Print-Appointment Letter';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 33020346;

                trigger OnAction()
                var
                    InternR: Record "33020402";
                    Report1: Report "33020346";
                begin
                    //CurrPage.SETSELECTIONFILTER(InternR);
                    //REPORT.RUN(Report1,TRUE,FALSE,Internr);
                end;
            }
        }
    }
}


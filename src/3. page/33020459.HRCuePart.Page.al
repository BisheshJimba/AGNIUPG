page 33020459 "HR Cue Part"
{
    PageType = CardPart;
    SourceTable = Table33020406;

    layout
    {
        area(content)
        {
            cuegroup("Employee and Recuritment")
            {
                Caption = 'Employee and Recuritment';
                field("Employee - Confirmed"; "Employee - Confirmed")
                {
                }
                field("Employee - Probation"; "Employee - Probation")
                {
                }
                field("Employee Activity - Not Posted"; "Employee Activity - Not Posted")
                {
                    DrillDownPageID = "Employee Activity List";
                }
                field("Vacancy List"; "Vacancy List")
                {
                    DrillDownPageID = "Vacancy Lists";
                }
                field("Application List"; "Application List")
                {
                    DrillDownPageID = "Application New List";
                }
                field("Budget List"; "Budget List")
                {
                    DrillDownPageID = "Manpower Budget List New";
                }
            }
            cuegroup("Documents - Not Posted")
            {
                Caption = 'Documents - Not Posted';
                field("Intern List"; "Intern List")
                {
                    DrillDownPageID = "Intern List";
                }
                field("Trainee List"; "Trainee List")
                {
                    DrillDownPageID = "Trainee Lists";
                }
                field("Outsource Staff List"; "Outsource Staff List")
                {
                    DrillDownPageID = "Outsource Staff Lists";
                }
                field("Disciplinary Issue List"; "Disciplinary Issue List")
                {
                    DrillDownPageID = "Disciplinary Issue Lists";
                }
            }
            cuegroup(Leave)
            {
                Caption = 'Leave';
                field("Leave - Pending for Approval"; "Leave - Pending for Approval")
                {
                    DrillDownPageID = "Posted Leave Request Lines";
                }
                field("Leave - Approved List"; "Leave - Approved List")
                {
                    DrillDownPageID = "Leave App/Dis List";
                }
                field("Leave - Disapprove List"; "Leave - Disapprove List")
                {
                    DrillDownPageID = "Leave App/Dis List";
                }
                field("ODD - Approved List"; "ODD - Approved List")
                {
                    DrillDownPageID = "ODD/ Training/ Gatepass List";
                }
                field("ODD - Disapproved List"; "ODD - Disapproved List")
                {
                    DrillDownPageID = "ODD/ Training/ Gatepass List";
                }
                field("Training - Approved List"; "Training - Approved List")
                {
                    DrillDownPageID = "ODD/ Training/ Gatepass List";
                }
                field("Training - Disapproved List"; "Training - Disapproved List")
                {
                    DrillDownPageID = "ODD/ Training/ Gatepass List";
                }
                field("Gate Pass - Approved List"; "Gate Pass - Approved List")
                {
                    DrillDownPageID = "ODD/ Training/ Gatepass List";
                }
                field("Gate Pass - Disapproved List"; "Gate Pass - Disapproved List")
                {
                    DrillDownPageID = "ODD/ Training/ Gatepass List";
                }
            }
            cuegroup("Employee Requisition and Internal Vacancy")
            {
                Caption = 'Employee Requisition and Internal Vacancy';
                field("Employee Requisition List"; "Employee Requisition List")
                {
                    DrillDownPageID = "Employee Requisition List";
                }
                field("Approved Emp. Req. List"; "Approved Emp. Req. List")
                {
                    DrillDownPageID = "Approved Emp Req. Lists";
                }
                field("Not Approved Emp. Req. List"; "Not Approved Emp. Req. List")
                {
                    DrillDownPageID = "Not Approved Emp Req. Lists";
                }
                field("On Hold Emp. Req. List"; "On Hold Emp. Req. List")
                {
                    DrillDownPageID = "On Hold Emp Req. Lists";
                }
                field("Resubmit Emp. Req. List"; "Resubmit Emp. Req. List")
                {
                    DrillDownPageID = "Resubmit Emp Req. Lists";
                }
                field("Internal Vacancy - Open"; "Internal Vacancy - Open")
                {
                    DrillDownPageID = "Internal Vacancy List";
                }
                field("Internal Vacancy - Close"; "Internal Vacancy - Close")
                {
                    DrillDownPageID = "Internal Vacancy List";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;
    end;
}


page 33020395 "Posted ODD/ Training/ Gatepass"
{
    CardPageID = "PostODD/Training/Gatepass card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020423;
    SourceTableView = WHERE(Posted = CONST(Yes),
                            Approve = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field(Department; Department)
                {
                }
                field(ManagerID; ManagerID)
                {
                    Visible = true;
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Full Name"; "Full Name")
                {
                }
                field("Job Title"; "Job Title")
                {
                    Visible = false;
                }
                field(Branch; Branch)
                {
                }
                field("Request Date (AD)"; "Request Date (AD)")
                {
                }
                field("Request Date (BS)"; "Request Date (BS)")
                {
                }
                field(Type; Type)
                {
                }
                field("Start Date"; "Start Date")
                {
                }
                field("Start Time"; "Start Time")
                {
                }
                field("End Date"; "End Date")
                {
                }
                field("End Time"; "End Time")
                {
                }
                field("Manager Name"; "Manager Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}


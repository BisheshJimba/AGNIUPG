page 33020352 "Posted Leave Request Lines"
{
    CardPageID = "Posted Leave Request Card";
    PageType = List;
    SourceTable = Table33020344;
    SourceTableView = SORTING(Employee No., Leave Start Date)
                      ORDER(Ascending)
                      WHERE(Posted = CONST(Yes),
                            Approved = CONST(No),
                            Rejected = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No."; "Employee No.")
                {
                }
                field("Full Name"; "Full Name")
                {
                }
                field("Manager Name"; "Manager Name")
                {
                }
                field("Leave Type Code"; "Leave Type Code")
                {
                }
                field("Leave Description"; "Leave Description")
                {
                }
                field("Work Shift Description"; "Work Shift Description")
                {
                }
                field("Leave Start Date"; "Leave Start Date")
                {
                }
                field("Leave End Date"; "Leave End Date")
                {
                }
                field("Leave Start Time"; "Leave Start Time")
                {
                }
                field("Leave End Time"; "Leave End Time")
                {
                }
                field("Fiscal Year"; "Fiscal Year")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field(Approved; Approved)
                {
                }
                field("Approval Date"; "Approval Date")
                {
                }
                field("Approval Comment"; "Approval Comment")
                {
                }
                field(Rejected; Rejected)
                {
                }
                field("Reject Date"; "Reject Date")
                {
                }
                field("Rejection Remarks"; "Rejection Remarks")
                {
                }
            }
        }
    }

    actions
    {
    }
}


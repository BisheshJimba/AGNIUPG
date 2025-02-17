page 33020354 "Leave Encash/WriteOff List"
{
    CardPageID = "Leave Encash/WriteOff Card";
    PageType = List;
    SourceTable = Table33020362;
    SourceTableView = WHERE(Posted = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Requested Date (AD)"; "Requested Date (AD)")
                {
                }
                field("Requested Date (BS)"; "Requested Date (BS)")
                {
                }
                field(Type; Type)
                {
                }
                field("Requested Time"; "Requested Time")
                {
                }
                field("Requested UserID"; "Requested UserID")
                {
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Employee Name"; "Employee Name")
                {
                }
                field(Designation; Designation)
                {
                    Visible = false;
                }
                field(Department; Department)
                {
                }
                field(Branch; Branch)
                {
                }
                field("Leave Type"; "Leave Type")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Leave Description"; "Leave Description")
                {
                }
                field("On Hand Days"; "On Hand Days")
                {
                }
                field("Consumed Days"; "Consumed Days")
                {
                }
            }
        }
    }

    actions
    {
    }
}


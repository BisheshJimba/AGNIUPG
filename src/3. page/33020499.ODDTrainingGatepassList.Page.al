page 33020499 "ODD/ Training/ Gatepass List"
{
    CardPageID = "ODD/ Training/ Gatepass Card";
    PageType = List;
    SourceTable = Table33020423;
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
                field("Employee Code"; "Employee Code")
                {
                }
                field("Full Name"; "Full Name")
                {
                }
                field(Department; Department)
                {
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
            }
        }
    }

    actions
    {
    }
}


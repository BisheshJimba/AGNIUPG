page 33020538 "Travel Order Invalid List"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020425;
    SourceTableView = WHERE(Invalid = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Approved II Date"; "Approved II Date")
                {
                }
                field("Travel Order No."; "Travel Order No.")
                {
                }
                field("Travel Type"; "Travel Type")
                {
                }
                field("Traveler's ID"; "Traveler's ID")
                {
                }
                field("Traveler's Name"; "Traveler's Name")
                {
                }
                field(Designation; Designation)
                {
                }
                field(Department; Department)
                {
                }
                field("Travel Destination I"; "Travel Destination I")
                {
                }
                field("Travel Destination II"; "Travel Destination II")
                {
                }
                field("Travel Destination III"; "Travel Destination III")
                {
                }
                field("Depature Date (AD)"; "Depature Date (AD)")
                {
                }
                field("Depature Date (BS)"; "Depature Date (BS)")
                {
                }
                field("Arrival Date (AD)"; "Arrival Date (AD)")
                {
                }
                field("Arrival Date (BS)"; "Arrival Date (BS)")
                {
                }
                field("No. of Days"; "No. of Days")
                {
                }
                field("Mode Of Transportation"; "Mode Of Transportation")
                {
                }
                field("Bus Transportation"; "Bus Transportation")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field("Approved Type"; "Approved Type")
                {
                }
                field("Transportation/Ticket (Nrs.)"; "Transportation/Ticket (Nrs.)")
                {
                }
                field("Local Transportation (Nrs.)"; "Local Transportation (Nrs.)")
                {
                }
                field("TADA (Nrs.)"; "TADA (Nrs.)")
                {
                }
                field("Fuel (Nrs.)"; "Fuel (Nrs.)")
                {
                }
                field("Total (Nrs.)"; "Total (Nrs.)")
                {
                }
                field(ManagerID; ManagerID)
                {
                }
                field("Manager's Name"; "Manager's Name")
                {
                }
                field(Approved; Approved)
                {
                }
                field("Approved By"; "Approved By")
                {
                }
                field("Approved Date"; "Approved Date")
                {
                }
                field(Posted; Posted)
                {
                }
                field("Posted By"; "Posted By")
                {
                }
                field("Posted Date"; "Posted Date")
                {
                }
                field(Invalid; Invalid)
                {
                }
                field("Invalid By"; "Invalid By")
                {
                }
                field("Invalid Date"; "Invalid Date")
                {
                }
                field(Level; Level)
                {
                }
                field(Grade; Grade)
                {
                }
                field("Requested By"; "Requested By")
                {
                }
                field("Requested Date"; "Requested Date")
                {
                }
                field("Approved II"; "Approved II")
                {
                }
                field("Approved II By"; "Approved II By")
                {
                }
            }
        }
    }

    actions
    {
    }
}


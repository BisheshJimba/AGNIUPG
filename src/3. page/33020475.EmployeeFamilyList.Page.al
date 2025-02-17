page 33020475 "Employee Family List"
{
    CardPageID = "Employee Family Card";
    Editable = false;
    PageType = List;
    SourceTable = Table33020411;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Emp Family No."; "Emp Family No.")
                {
                }
                field("Employee Code"; "Employee Code")
                {
                }
                field("Employee Name"; "Employee Name")
                {
                }
                field(Name; Name)
                {
                }
                field(Posted; Posted)
                {
                }
                field("Posted Date"; "Posted Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}


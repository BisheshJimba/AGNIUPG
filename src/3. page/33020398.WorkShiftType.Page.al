page 33020398 "Work Shift Type"
{
    CardPageID = "Work Shift List";
    Editable = true;
    PageType = List;
    SourceTable = Table33020348;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("In Time"; "In Time")
                {
                }
                field("Out Time"; "Out Time")
                {
                }
                field("Work Hours"; "Work Hours")
                {
                }
                field("Lunch Start"; "Lunch Start")
                {
                }
                field("Lunch End"; "Lunch End")
                {
                }
                field("Lunch Minute"; "Lunch Minute")
                {
                }
                field(Blocked; Blocked)
                {
                }
            }
        }
    }

    actions
    {
    }
}


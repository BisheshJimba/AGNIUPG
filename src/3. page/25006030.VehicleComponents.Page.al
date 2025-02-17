page 25006030 "Vehicle Components"
{
    Caption = 'Vehicle Components';
    PageType = List;
    SourceTable = Table25006010;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Parent Vehicle Serial No."; "Parent Vehicle Serial No.")
                {
                    Visible = false;
                }
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Active; Active)
                {
                }
                field("Date Installed"; "Date Installed")
                {
                }
            }
        }
    }

    actions
    {
    }
}


page 33020529 "Travel Order Page List"
{
    CardPageID = "Travel Order Page";
    PageType = List;
    PromotedActionCategories = 'New';
    SourceTable = Table33020425;
    SourceTableView = SORTING(Travel Order No., Traveler's ID)
                      ORDER(Ascending)
                      WHERE(Posted = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                    Visible = false;
                }
                field(Department; Department)
                {
                }
            }
        }
    }

    actions
    {
    }
}


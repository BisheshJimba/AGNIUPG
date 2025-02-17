page 33020049 "Posted Outward Gate Entry List"
{
    Caption = 'Posted Outward Gate Entry List';
    CardPageID = "Posted Inward Gate Entry";
    PageType = List;
    SourceTable = Table33020038;
    SourceTableView = SORTING(Entry Type, No.)
                      ORDER(Ascending)
                      WHERE(Entry Type=FILTER(Outward));

    layout
    {
        area(content)
        {
            repeater()
            {
                Editable = false;
                field("Entry Type";"Entry Type")
                {
                }
                field("No.";"No.")
                {
                }
                field("Document Date";"Document Date")
                {
                }
                field("Document Time";"Document Time")
                {
                }
                field("Location Code (From)";"Location Code (From)")
                {
                }
                field(Description;Description)
                {
                }
                field("Item Description";"Item Description")
                {
                }
                field("LR/RR No.";"LR/RR No.")
                {
                }
                field("LR/RR Date";"LR/RR Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}


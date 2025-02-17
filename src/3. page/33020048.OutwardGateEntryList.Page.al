page 33020048 "Outward Gate Entry List"
{
    Caption = 'Outward Gate Entry List';
    CardPageID = "Outward Gate Entry";
    PageType = List;
    SourceTable = Table33020035;
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
                field("Location Code";"Location Code")
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


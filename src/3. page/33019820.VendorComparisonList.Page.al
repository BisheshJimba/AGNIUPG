page 33019820 "Vendor Comparison List"
{
    CardPageID = "NCHL-NPI App. User Groups";
    Editable = false;
    PageType = List;
    SourceTable = Table33019815;

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
                field("Amount Filter"; "Amount Filter")
                {
                }
            }
        }
    }

    actions
    {
    }
}


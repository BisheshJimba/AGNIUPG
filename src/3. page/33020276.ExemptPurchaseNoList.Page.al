page 33020276 "Exempt Purchase No. List"
{
    CardPageID = "Exempt Purchase Nos.";
    Editable = false;
    PageType = List;
    SourceTable = Table33020189;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Exempt No."; "Exempt No.")
                {
                }
                field(Description; Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}


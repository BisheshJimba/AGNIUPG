page 33020384 "Calendar Holidays List"
{
    CardPageID = "Calendar Holidays Card";
    PageType = List;
    SourceTable = Table33020371;
    SourceTableView = WHERE(Day Type=CONST(Paid Holiday));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Nepali Year"; "Nepali Year")
                {
                }
                field(Date; Date)
                {
                }
                field("Nepali Date"; "Nepali Date")
                {
                }
                field("Day Type"; "Day Type")
                {
                }
                field(Remarks; Remarks)
                {
                }
            }
        }
    }

    actions
    {
    }
}


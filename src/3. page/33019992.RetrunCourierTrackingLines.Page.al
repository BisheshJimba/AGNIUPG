page 33019992 "Retrun Courier Tracking Lines"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SaveValues = true;
    SourceTable = Table33019988;
    SourceTableView = ORDER(Ascending)
                      WHERE(Document Type=CONST(Return));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("POD No."; "POD No.")
                {
                }
                field("AWB No."; "AWB No.")
                {
                }
                field("Packet Type"; "Packet Type")
                {
                }
                field("Packet No."; "Packet No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Weight; Weight)
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Rate; Rate)
                {
                }
                field(Amount; Amount)
                {
                }
                field("Quantity To Return"; "Quantity To Return")
                {
                }
            }
        }
    }

    actions
    {
    }
}


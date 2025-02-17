page 33020571 "Dealer Integration Service"
{
    PageType = List;
    SourceTable = Table33020430;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Integration Type"; "Integration Type")
                {
                }
                field("Service Name"; "Service Name")
                {
                }
                field(Type; Type)
                {
                }
                field("Last Synchronization Date"; "Last Synchronization Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}


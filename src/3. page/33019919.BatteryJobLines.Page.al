page 33019919 "Battery Job Lines"
{
    PageType = ListPart;
    SourceTable = Table33019895;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Cell; Cell)
                {
                }
                field("Initial SG"; "Initial SG")
                {
                }
                field("Final SG"; "Final SG")
                {
                }
                field(Voltage; Voltage)
                {
                    Caption = 'Open Ckt. Voltage';
                }
                field("High Rate Disch."; "High Rate Disch.")
                {
                    Caption = 'High Rate Discharge Test Voltage';
                }
                field("Midtronic Test"; "Midtronic Test")
                {
                }
            }
        }
    }

    actions
    {
    }
}


page 33019886 "Job Card Lines"
{
    PageType = ListPart;
    SourceTable = Table33019885;

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


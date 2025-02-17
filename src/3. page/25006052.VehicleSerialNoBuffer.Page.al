page 25006052 "Vehicle Serial No. Buffer"
{
    Caption = 'Vehicle Serial No. Buffer';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006019;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Serial No."; "Serial No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Customer No."; "Customer No.")
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


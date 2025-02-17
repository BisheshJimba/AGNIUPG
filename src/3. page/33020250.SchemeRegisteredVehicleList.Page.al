page 33020250 "Scheme Registered Vehicle List"
{
    Editable = true;
    PageType = List;
    SourceTable = Table33020240;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Reference No."; "Reference No.")
                {
                    Caption = 'WMS Job No.';
                }
                field("Start Date"; "Start Date")
                {
                }
                field(Period; Period)
                {
                }
                field("Valid Until"; "Valid Until")
                {
                }
                field("Registered By"; "Registered By")
                {
                }
            }
        }
    }

    actions
    {
    }
}


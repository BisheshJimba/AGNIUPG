page 33020065 "Vehicle FactBox"
{
    Caption = 'Vehicle Details';
    PageType = CardPart;
    SourceTable = Table25006005;

    layout
    {
        area(content)
        {
            field("Serial No."; "Serial No.")
            {
                TableRelation = Vehicle."Serial No." WHERE(Serial No.=FIELD(Serial No.));
            }
            field(VIN; VIN)
            {
            }
            field("Make Code"; "Make Code")
            {
            }
            field("Model Code"; "Model Code")
            {
            }
            field("Model Version No."; "Model Version No.")
            {
            }
            field("Model Commercial Name"; "Model Commercial Name")
            {
            }
            field("Registration No."; "Registration No.")
            {
            }
            field("Status Code"; "Status Code")
            {
            }
        }
    }

    actions
    {
    }
}


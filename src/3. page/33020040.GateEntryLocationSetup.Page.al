page 33020040 "Gate Entry Location Setup"
{
    Caption = 'Gate Entry Location Setup';
    PageType = List;
    SourceTable = Table33020037;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Entry Type"; "Entry Type")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Posting No. Series"; "Posting No. Series")
                {
                }
            }
        }
    }

    actions
    {
    }
}


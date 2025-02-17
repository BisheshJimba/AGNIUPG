page 33020566 "Base Calendar Change List PRM"
{
    Caption = 'Base Calendar Change List';
    DataCaptionFields = "Base Calendar Code";
    Editable = false;
    PageType = List;
    SourceTable = Table33020561;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Base Calendar Code"; "Base Calendar Code")
                {
                    Visible = false;
                }
                field("Recurring System"; "Recurring System")
                {
                    Caption = 'Recurring System';
                }
                field(Date; Date)
                {
                }
                field(Day; Day)
                {
                }
                field(Description; Description)
                {
                }
                field(Nonworking; Nonworking)
                {
                    Caption = 'Nonworking';
                }
            }
        }
        area(factboxes)
        {
            systempart(; Links)
            {
                Visible = false;
            }
            systempart(; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}


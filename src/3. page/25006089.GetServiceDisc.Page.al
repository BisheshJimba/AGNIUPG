page 25006089 "Get Service Disc."
{
    // 21.11.2013 EDMS P8
    //   * added fields

    Caption = 'Get Service Disc.';
    Editable = false;
    PageType = List;
    SourceTable = Table25006057;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Sales Type"; "Sales Type")
                {
                }
                field("Sales Code"; "Sales Code")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                    Visible = false;
                }
                field(Type; Type)
                {
                }
                field(Code; Code)
                {
                }
                field("Minimum Quantity"; "Minimum Quantity")
                {
                }
                field("Line Discount %"; "Line Discount %")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("Make Code"; "Make Code")
                {
                    Visible = false;
                }
                field("Model Code"; "Model Code")
                {
                    Visible = false;
                }
                field("Model Version No."; "Model Version No.")
                {
                    Visible = false;
                }
                field("Vehicle Serial No."; "Vehicle Serial No.")
                {
                    Visible = false;
                }
                field("Labor Group Code"; "Labor Group Code")
                {
                    Visible = false;
                }
                field("Labor Subgroup Code"; "Labor Subgroup Code")
                {
                    Visible = false;
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


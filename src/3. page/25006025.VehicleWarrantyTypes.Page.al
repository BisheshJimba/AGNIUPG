page 25006025 "Vehicle Warranty Types"
{
    // 12.06.2007. EDMS P2
    //   * Created form

    Caption = 'Vehicle Warranty Types';
    PageType = List;
    SourceTable = Table25006035;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Code; Code)
                {
                }
                field(Name; Name)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
                field("Term Date Formula"; "Term Date Formula")
                {
                }
                field("Variable Field Run 1"; "Variable Field Run 1")
                {
                }
                field("Variable Field Run 2"; "Variable Field Run 2")
                {
                }
                field("Variable Field Run 3"; "Variable Field Run 3")
                {
                }
            }
        }
    }

    actions
    {
    }
}


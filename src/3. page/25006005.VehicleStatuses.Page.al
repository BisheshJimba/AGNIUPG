page 25006005 "Vehicle Statuses"
{
    Caption = 'Vehicle Statuses';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006021;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Vehicle Status Group Code"; "Vehicle Status Group Code")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Vehicle Status")
            {
                Caption = 'Vehicle Status';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page 540;
                    RunPageLink = Table ID=CONST(25006021),
                                  No.=FIELD(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                }
            }
        }
    }
}


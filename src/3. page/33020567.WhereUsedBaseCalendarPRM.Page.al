page 33020567 "Where-Used Base Calendar PRM"
{
    Caption = 'Where-Used Base Calendar';
    DataCaptionFields = "Base Calendar Code";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020562;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Source Type"; "Source Type")
                {
                    Caption = 'Source Type';
                }
                field("Source Code"; "Source Code")
                {
                    Caption = 'Source Code';
                }
                field("Additional Source Code"; "Additional Source Code")
                {
                    Caption = 'Additional Source Code';
                }
                field("Source Name"; "Source Name")
                {
                    Caption = 'Source Name';
                }
                field("Customized Changes Exist"; "Customized Changes Exist")
                {
                    Caption = 'Customized Changes Exist';
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


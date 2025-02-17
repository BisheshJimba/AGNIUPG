page 25006373 "Schedule Colors"
{
    Caption = 'Schedule Colors';
    PageType = List;
    SourceTable = Table25006281;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Source Type"; "Source Type")
                {
                }
                field("Source Subtype"; "Source Subtype")
                {
                }
                field("Work Status"; "Work Status")
                {
                }
                field(Status; Status)
                {
                }
                field("Font Color"; "Font Color")
                {
                }
                field("Font Bold"; "Font Bold")
                {
                }
                field("Background Color"; "Background Color")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ForeColorOnFormat;
    end;

    var
        [InDataSet]
        ForeColorEmphasize: Boolean;

    local procedure ForeColorOnFormat()
    begin
        ForeColorEmphasize := "Font Bold";
    end;
}


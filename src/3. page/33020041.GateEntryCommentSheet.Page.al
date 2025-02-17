page 33020041 "Gate Entry Comment Sheet"
{
    AutoSplitKey = true;
    Caption = 'Gate Entry Comment Sheet';
    DataCaptionFields = "Gate Entry Type", "No.";
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = Table33020042;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Date; Date)
                {
                }
                field(Comment; Comment)
                {
                }
                field(Code; Code)
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine;
    end;
}


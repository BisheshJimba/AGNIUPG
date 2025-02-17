page 33020208 "SP Target - Model Wise List"
{
    PageType = List;
    SourceTable = Table33020202;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Make; Make)
                {
                }
                field("Model No."; "Model No.")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Model Version Name"; "Model Version Name")
                {
                }
                field(Quantity; Quantity)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Pipeline Code" := xRec."Pipeline Code";
    end;
}


page 33020580 "Consumption Checklist"
{
    AutoSplitKey = true;
    MultipleNewLines = true;
    PageType = List;
    SaveValues = true;
    SourceTable = Table33020528;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Type"; "Item Type")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                }
                field(Rate; Rate)
                {
                }
                field(Amount; Amount)
                {
                    Editable = false;
                }
                field(Remarks; Remarks)
                {
                }
                field("Posted Job Card No."; "Posted Job Card No.")
                {
                    Editable = false;
                }
                field(Reversed; Reversed)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //PageEditable := "Posted Job Card No." = '';
    end;

    var
        [InDataSet]
        PageEditable: Boolean;
}


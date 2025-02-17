page 50027 "Item Substitution Entry (App)"
{
    Caption = 'Item Substitution Entry (App)';
    DataCaptionFields = "No.";
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = Table5715;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Substitute No."; "Substitute No.")
                {
                    ToolTip = 'Specifies the number of the item that can be used as a substitute in case the original item is unavailable.';
                }
                field(Description; Description)
                {
                    ToolTip = 'Specifies the description of the substitute item.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Condition")
            {
                Caption = '&Condition';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 5717;
                RunPageLink = Type = FIELD(Type),
                              No.=FIELD(No.),
                              Variant Code=FIELD(Variant Code),
                              Substitute Type=FIELD(Substitute Type),
                              Substitute No.=FIELD(Substitute No.),
                              Substitute Variant Code=FIELD(Substitute Variant Code);
            }
        }
    }
}


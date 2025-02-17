page 33020547 "Vehicle Order Promising (TO)"
{
    Editable = false;
    PageType = Card;
    SourceTable = Table5741;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        VehOrderPromising: Codeunit "25006324";
    begin
        IF CloseAction = ACTION::OK THEN
            VehOrderPromising.CreateReqLineTO(Rec);
    end;
}


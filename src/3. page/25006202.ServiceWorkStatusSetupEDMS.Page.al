page 25006202 "Service Work Status Setup EDMS"
{
    Caption = 'Service Work Status Setup';
    PageType = Card;
    SourceTable = Table25006166;

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
                field("Service Order Status"; "Service Order Status")
                {
                }
                field(Priority; Priority)
                {
                }
            }
        }
    }

    actions
    {
    }
}


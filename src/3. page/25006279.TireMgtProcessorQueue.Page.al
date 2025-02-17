page 25006279 "Tire Mgt. Processor Queue"
{
    Caption = 'Tire Mgt. Processor Queue';
    PageType = CardPart;
    SourceTable = Table25006186;

    layout
    {
        area(content)
        {
            cuegroup("In process")
            {
                Caption = 'In process';
                field("Service Lines Count"; "Service Lines Count")
                {
                }

                actions
                {
                    action("New Service Order")
                    {
                        Caption = 'New Service Order';
                        RunObject = Page 5900;
                        RunPageMode = Create;
                    }
                }
            }
            cuegroup("Posted info")
            {
                Caption = 'Posted info';
                field("Put on Tires Count"; "Put on Tires Count")
                {
                }

                actions
                {
                    action("New Tire")
                    {
                        Caption = 'New Tire';
                        RunObject = Page 25006267;
                        RunPageMode = Create;
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;
    end;
}


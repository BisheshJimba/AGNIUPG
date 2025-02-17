page 33020263 "Service Order (Display)"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = Table25006145;

    layout
    {
        area(content)
        {
            part(Invoicing; 33020264)
            {
                Caption = 'Invoicing';
            }
            part("Finished Orders"; 33020262)
            {
                Caption = 'Finished Orders';
                SubPageView = WHERE(Work Status Code=CONST(FINISHED));
            }
            part("In Process Orders"; 33020262)
            {
                Caption = 'In Process Orders';
                SubPageView = WHERE(Work Status Code=FILTER(IN PROCESS));
            }
            part(Pending;33020262)
            {
                Caption = 'Pending';
                SubPageView = WHERE(Work Status Code=FILTER(PENDING|ON HOLD|BOOKING));
            }
        }
    }

    actions
    {
    }
}


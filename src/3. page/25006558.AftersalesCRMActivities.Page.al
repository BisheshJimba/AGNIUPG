page 25006558 "Aftersales CRM Activities"
{
    PageType = CardPart;
    SourceTable = Table25006399;

    layout
    {
        area(content)
        {
            cuegroup("To-Does")
            {
                Caption = 'To-Does';
                field("Campaign Active"; "Campaign Active")
                {
                    DrillDownPageID = "Campaign List";
                }
                field("My To-do This Week"; "My To-do This Week")
                {
                    DrillDownPageID = "To-do List";
                }
                field("My To-do Next Week"; "My To-do Next Week")
                {
                    DrillDownPageID = "To-do List";
                }
                field("My To-do"; "My To-do")
                {
                    DrillDownPageID = "To-do List";
                    Visible = true;
                }
            }
            cuegroup("My Catalogs")
            {
                Caption = 'My Catalogs';
                field("My Segments"; "My Segments")
                {
                    DrillDownPageID = "Segment List";
                }
                field("My Contacts"; "My Contacts")
                {
                    DrillDownPageID = "Contact List";
                }
                field("My Customers"; "My Customers")
                {
                    DrillDownPageID = "Customer List";
                }
                field("My Contracts"; "My Contracts")
                {
                    DrillDownPageID = "Contract List EDMS";
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

        Rec.SETFILTER("Date Filter 1", FORMAT(CALCDATE('<-WD1>', WORKDATE)) + '..' + FORMAT(CALCDATE('<WD7>', WORKDATE)));
        Rec.SETFILTER("Date Filter 2", FORMAT(CALCDATE('<-WD1>', WORKDATE + 7)) + '..' + FORMAT(CALCDATE('<+WD7>', WORKDATE + 7)));
        IF UserSetup.GET(USERID) THEN
            Rec.SETFILTER("Salesperson Code", UserSetup."Salespers./Purch. Code");
    end;

    var
        UserSetup: Record "91";
}


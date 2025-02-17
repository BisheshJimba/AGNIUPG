page 33019829 "Store Requisition History"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Documents';
    RefreshOnActivate = true;
    SourceTable = Table33019810;
    SourceTableView = WHERE(Refresh Token Generated On=CONST(12/05/20 12:00 AM));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Primary Key"; "Primary Key")
                {
                }
                field("Base URL"; "Base URL")
                {
                }
                field("Username (Basic Auth.)"; "Username (Basic Auth.)")
                {
                }
                field("Password (Basic Auth.)"; "Password (Basic Auth.)")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("View Requisition")
            {
                Caption = 'View Requisition';
                Image = OpenWorksheet;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page 33019810;
                RunPageLink = Primary Key=FIELD(Primary Key);
                RunPageMode = View;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //Applying responsibility center.
        GblUserSetup.GET(USERID);
        IF GblUserSetup."Apply Rules" THEN BEGIN
          FILTERGROUP(2);
          SETFILTER("Password (User Auth.)",GblUserSetup."Default Responsibility Center");
          FILTERGROUP(0);
        END;
    end;

    var
        GblUserSetup: Record "91";
}


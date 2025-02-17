page 33019823 "Store Requisition Status"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Documents';
    RefreshOnActivate = true;
    SourceTable = Table33019810;
    SourceTableView = WHERE(Refresh Token Generated On=FILTER(<>0|<>5));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Primary Key";"Primary Key")
                {
                }
                field("Base URL";"Base URL")
                {
                }
                field("Username (Basic Auth.)";"Username (Basic Auth.)")
                {
                }
                field("Password (Basic Auth.)";"Password (Basic Auth.)")
                {
                }
                field("Refresh Token Generated On";"Refresh Token Generated On")
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


page 50043 "View Records"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table2000000001;
    SourceTableView = WHERE(Type = CONST(Table));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                }
                field(ID; ID)
                {
                }
                field(Name; Name)
                {
                }
                field(Modified; Modified)
                {
                }
                field(Date; Date)
                {
                }
                field(Time; Time)
                {
                }
                field(Compiled; Compiled)
                {
                }
                field("Version List"; "Version List")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Run")
            {
                Image = "Table";
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    UserSetup.GET(USERID);
                    IF (UserSetup."User ID" = 'AGNIGROUP\ADMINISTRATOR') OR (UserSetup."User ID" = 'AGNIGROUP\AGILE') OR (UserSetup."User ID" = 'AGNIGROUP\SHARMILA.THAPA') THEN BEGIN
                        HYPERLINK(GETURL(CLIENTTYPE::Current, COMPANYNAME, OBJECTTYPE::Table, ID));
                    END ELSE BEGIN
                        IF (ID = 5200) OR (ID = 33019826) OR (ID = 33020361) OR (ID = 33020519) OR (ID = 33020520) OR (ID = 33020512) OR (ID = 33020513) OR (ID = 33020304) THEN
                            ERROR('You cannot view this data.')
                        ELSE
                            HYPERLINK(GETURL(CLIENTTYPE::Current, COMPANYNAME, OBJECTTYPE::Table, ID));
                    END;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        /*IF USERID <> 'AGNIGROUP\AGILE' THEN
          ERROR('No Permission');*/

    end;

    var
        UserSetup: Record "91";
}


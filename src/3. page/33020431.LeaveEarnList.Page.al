page 33020431 "Leave Earn List"
{
    CardPageID = "Leave Earn";
    Editable = false;
    PageType = List;
    SourceTable = Table33020398;
    SourceTableView = WHERE(Posted = CONST(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Full Name"; "Full Name")
                {
                }
                field("Entry Date"; "Entry Date")
                {
                }
                field(Month; Month)
                {
                }
                field("Leave Description"; "Leave Description")
                {
                }
                field("Earn Days"; "Earn Days")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        HRPermission.GET(USERID);
        IF NOT HRPermission."HR Admin" THEN
            ERROR('You do not have a permision');
    end;

    var
        HRPermission: Record "33020304";
}


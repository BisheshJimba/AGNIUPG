page 33020311 "Set Open and Close Fiscal Date"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table33020302;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Nepali Year"; "Nepali Year")
                {
                }
                field("Nepali Month"; "Nepali Month")
                {
                }
                field("Nepali Date"; "Nepali Date")
                {
                }
                field("Fiscal Year"; "Fiscal Year")
                {
                }
                field("Open Date for Appraisal"; "Open Date for Appraisal")
                {
                }
                field("Close Date for Appraisal"; "Close Date for Appraisal")
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
            ERROR('You do not have permission to open this page. Contact your HR Department');
    end;

    var
        HRPermission: Record "33020304";
}


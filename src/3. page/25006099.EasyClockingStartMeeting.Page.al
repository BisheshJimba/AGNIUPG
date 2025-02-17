page 25006099 "Easy Clocking Start Meeting"
{
    Caption = 'Start Meeting';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = StandardDialog;
    SourceTable = Table2000000026;

    layout
    {
        area(content)
        {
            field(UserDescription; MeetingDescription)
            {
                Caption = 'Meeting Description';
            }
        }
    }

    actions
    {
    }

    var
        MeetingDescription: Text;

    [Scope('Internal')]
    procedure GetMeetingDescription(): Text
    begin
        EXIT(MeetingDescription);
    end;
}


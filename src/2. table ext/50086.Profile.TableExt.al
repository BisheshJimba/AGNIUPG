tableextension 50086 tableextension50086 extends "Profile"
{
    fields
    {
        field(50000; "Company Name"; Text[30])
        {
            TableRelation = Company;
        }
    }

    procedure FilterProfile()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.GET(USERID);
        IF (UserSetup."Profile Change Authority" = UserSetup."Profile Change Authority"::Limited)
         OR (UserSetup."Profile Change Authority" = UserSetup."Profile Change Authority"::Standard)
        THEN BEGIN
            FILTERGROUP(2);
            SETFILTER("Profile ID", UserSetup."User Profile Filter");
            FILTERGROUP(0);
        END
        ELSE
            IF UserSetup."Profile Change Authority" = UserSetup."Profile Change Authority"::" " THEN
                ERROR(NoPermission);

        SETRANGE("Company Name", COMPANYNAME);
    end;

    var
        NoPermission: Label 'You have no authority to view Profiles.';
}


codeunit 25006002 UserProfileManagement
{
    // 07.05.2014 Elva Baltic P8 #xxx MMG7.00
    //   * Correct use of UserSetup."Profile ID"


    trigger OnRun()
    begin
    end;

    var
        SingleInstanceMgt: Codeunit "25006001";

    [Scope('Internal')]
    procedure CurrProfileID() RetValue: Code[30]
    var
        UserPersonalization: Record "2000000073";
        SIDConversion: Record "2000000055";
        User: Record "2000000120";
        UserSetup: Record "91";
    begin
        User.RESET;
        User.SETRANGE("User Name", UPPERCASE(USERID));
        IF User.FINDFIRST THEN BEGIN
            UserPersonalization.RESET;
            UserPersonalization.SETRANGE("User SID", User."User Security ID"); //30.10.2012 EDMS
            IF UserPersonalization.FINDFIRST THEN
                EXIT(UserPersonalization."Profile ID");
        END ELSE
            EXIT(GetDefaultUserProfile);
    end;

    [Scope('Internal')]
    procedure CurrBranchNo() RetValue: Code[30]
    var
        UserSetup: Record "91";
        User: Record "2000000120";
    begin
        User.RESET;
        User.SETRANGE("User Name", UPPERCASE(USERID));
        IF User.FINDFIRST THEN BEGIN
            UserSetup.GET(USERID);
            EXIT(UserSetup."Branch Code");
        END;
    end;

    [Scope('Internal')]
    procedure InitUserProfileSetup("Profile": Record "2000000072")
    var
        BranchProfileSetup: Record "25006067";
    begin
        BranchProfileSetup.RESET;
        IF NOT BranchProfileSetup.GET(Profile."Profile ID") THEN BEGIN
            BranchProfileSetup.INIT;
            BranchProfileSetup."Profile ID" := Profile."Profile ID";
            BranchProfileSetup.Description := Profile.Description;
            BranchProfileSetup.INSERT(TRUE);
        END;
        COMMIT;
    end;

    local procedure GetDefaultUserProfile(): Code[30]
    var
        "Profile": Record "2000000072";
    begin
        Profile.SETRANGE("Default Role Center", TRUE);
        IF Profile.FINDFIRST THEN
            EXIT(Profile."Profile ID");
    end;

    [Scope('Internal')]
    procedure GetUserFullName(UserID: Code[50]): Text[80]
    var
        Users: Record "2000000120";
    begin
        Users.SETRANGE(Users."User Name", UserID);
        IF Users.FINDFIRST THEN
            EXIT(Users."Full Name");
    end;

    [Scope('Internal')]
    procedure GetUserSID(CurrUserID: Code[50]): Code[119]
    var
        UserPersonalization: Record "2000000073";
        SIDConversion: Record "2000000055";
    begin
        IF ISSERVICETIER THEN BEGIN
            /*
              SIDConversion.SETCURRENTKEY(ID);
              SIDConversion.ID := CurrUserID;
              IF SIDConversion.FIND THEN
                EXIT(SIDConversion.SID);
            */

            UserPersonalization.RESET;
            UserPersonalization.SETRANGE("User ID", CurrUserID);
            IF UserPersonalization.FINDFIRST THEN
                EXIT(UserPersonalization."User SID");
            /*
              UserPersonalization.RESET;
              UserPersonalization.SETRANGE("User SID",SIDConversion.SID);
              UserPersonalization.FINDFIRST;
              EXIT(UserPersonalization."User ID");
            */
        END;

    end;
}


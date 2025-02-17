tableextension 50087 tableextension50087 extends "User Personalization"
{
    fields
    {

        //Unsupported feature: Code Insertion on ""Profile ID"(Field 9)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //var
        //ValidProfile: Boolean;
        //Text000: Label 'You do not have Permission Setup for %1 Profile.';
        //web: Boolean;
        //begin
        /*
        ValidProfile := FALSE;

        IF (CURRENTCLIENTTYPE = CLIENTTYPE::Web) OR (CURRENTCLIENTTYPE = CLIENTTYPE::Phone) OR (CURRENTCLIENTTYPE = CLIENTTYPE::Tablet) THEN
         EXIT;

        UserSetup.GET(USERID);
        IF (UserSetup."Profile Change Authority" <> UserSetup."Profile Change Authority"::" ") THEN BEGIN
          UserProfileSetup.RESET;
          IF UserSetup."Profile Change Authority" <> UserSetup."Profile Change Authority"::Admin THEN
            UserProfileSetup.SETFILTER("Profile ID",UserSetup."User Profile Filter");
          IF UserProfileSetup.FINDSET THEN REPEAT
            IF (NOT ValidProfile) AND (UserProfileSetup."Profile ID"="Profile ID") THEN
              ValidProfile := TRUE;
          UNTIL UserProfileSetup.NEXT=0;
          IF NOT ValidProfile THEN
            ERROR(Text000,"Profile ID")
          ELSE BEGIN
            UserProfileSetup.GET("Profile ID");
            GLSetup.GET;
            UserProfileSetup.TESTFIELD("Default Location Code");
            IF NOT GLSetup."Use Accountability Center" THEN
              UserProfileSetup.TESTFIELD("Default Responsibility Center")
            ELSE
              UserProfileSetup.TESTFIELD("Default Accountability Center");
            //UserSetup2.GET(DELSTR(Rec."User ID",1,STRLEN(DELSTR(Rec."User ID",STRPOS(Rec."User ID",'\')))+1));
            UserSetup2.GET(Rec."User ID");
            UserSetup2."Sales Resp. Ctr. Filter" := UserProfileSetup."Default Responsibility Center";
            UserSetup2."Purchase Resp. Ctr. Filter" := UserProfileSetup."Default Responsibility Center";
            UserSetup2."Service Resp. Ctr. Filter EDMS" := UserProfileSetup."Default Responsibility Center";
            UserSetup2."Service Resp. Ctr. Filter" := UserProfileSetup."Default Responsibility Center";
            UserSetup2."Default Responsibility Center" := UserProfileSetup."Default Responsibility Center";
            UserSetup2."Default User Profile Code" := UserProfileSetup."Profile ID";
            UserSetup2."Default Location" := UserProfileSetup."Default Location Code";
            UserSetup2."Default Accountability Center" := UserProfileSetup."Default Accountability Center";
            UserSetup2."Shortcut Dimension 1 Code" := UserProfileSetup."Shortcut Dimension 1 Code";
            UserSetup2."Shortcut Dimension 2 Code" := UserProfileSetup."Shortcut Dimension 2 Code";
            UserSetup2.MODIFY;
            IF "User SID" = UserProfileMgt.GetUserSID(USERID) THEN
              ChangeMyCompany;
          END;
        END
        ELSE
          ERROR(Text000);
        */
        //end;
    }

    procedure UserListFilter()
    begin
        UserSetup.GET(USERID);
        IF (UserSetup."Profile Change Authority" = UserSetup."Profile Change Authority"::" ") OR
           (UserSetup."Profile Change Authority" = UserSetup."Profile Change Authority"::Limited) THEN BEGIN
            FILTERGROUP(2);
            SETFILTER("User SID", UserProfileMgt.GetUserSID(USERID));
            FILTERGROUP(0);
        END
        ELSE
            IF (UserSetup."Profile Change Authority" = UserSetup."Profile Change Authority"::Standard) THEN BEGIN
                FILTERGROUP(2);
                SETFILTER("Profile ID", UserSetup."User Profile Filter");
                FILTERGROUP(0);
            END;
    end;

    procedure ChangeMyCompany()
    var
        ChangeCompanyWshShell: Automation;
        CompanyTo: Text[30];
        TempCompany: Text[30];
        CompanyRec: Record Company;
        i: Integer;
        j: Integer;
        MSG: Text[30];
    begin
        //IF ISCLEAR(ChangeCompanyWshShell) THEN;
        //CREATE(ChangeCompanyWshShell,TRUE,TRUE);

        CompanyTo := COMPANYNAME;
        CompanyRec.RESET;
        CompanyRec.SETFILTER(Name, '<>%1', CompanyTo);
        IF CompanyRec.FINDFIRST THEN
            TempCompany := CompanyRec.Name;
        IF CompanyRec.COUNT = 0 THEN BEGIN
            IF ISCLEAR(ChangeCompanyWshShell) THEN;
            CREATE(ChangeCompanyWshShell, TRUE, TRUE);
            i := 0;
            j := 48;
            MSG := 'MS Dynamics NAV';
            ChangeCompanyWshShell.Popup('You have changed your Profile ID. Please restart the application.', i, MSG, j);
            // ChangeCompanyWshShell.SendKeys('{ENTER}');
            // ChangeCompanyWshShell.SendKeys('{ESCAPE}');
            // ChangeCompanyWshShell.SendKeys('{ESCAPE}');
            //  ChangeCompanyWshShell.SendKeys('%{F4}');
            //  ChangeCompanyWshShell.Run('Microsoft.Dynamics.Nav.Client.exe');
        END
        ELSE BEGIN
            IF ISCLEAR(ChangeCompanyWshShell) THEN;
            CREATE(ChangeCompanyWshShell, TRUE, TRUE);
            ChangeCompanyWshShell.SendKeys('{ESCAPE}');
            ChangeCompanyWshShell.SendKeys('{ESCAPE}');
            ChangeCompanyWshShell.SendKeys('^o');
            ChangeCompanyWshShell.SendKeys(TempCompany);
            ChangeCompanyWshShell.SendKeys('{ENTER}');
            ChangeCompanyWshShell.SendKeys('{ENTER}');
            ChangeCompanyWshShell.SendKeys('^o');
            ChangeCompanyWshShell.SendKeys(CompanyTo);
            ChangeCompanyWshShell.SendKeys('{ENTER}');
            ChangeCompanyWshShell.SendKeys('{ENTER}');
        END;
    end;

    var
        UserSetup: Record "User Setup";
        UserProfileSetup: Record "User Profile Setup";
        Text000: Label 'You don''t have authority to change Profile.';
        UserSetup2: Record "User Setup";
        UserProfileMgt: Codeunit UserProfileManagement;
        GLSetup: Record "General Ledger Setup";
}


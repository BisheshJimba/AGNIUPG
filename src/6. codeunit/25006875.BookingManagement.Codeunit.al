codeunit 25006875 "Booking Management"
{

    trigger OnRun()
    begin
    end;

    var
        LocationCode: Code[20];

    [Scope('Internal')]
    procedure GetDefaultLocationCode(): Code[20]
    var
        ServiceSetup: Record "25006120";
        UserProfile: Record "25006067";
        ServiceLocation: Code[20];
        UserProfileMgt: Codeunit "25006002";
    begin
        ServiceSetup.GET;
        IF UserProfile.GET(UserProfileMgt.CurrProfileID) THEN BEGIN
            IF UserProfile.GET(UserProfile."Spec. Service User Profile") THEN BEGIN
                ServiceLocation := UserProfile."Def. Service Location Code";
                IF ServiceLocation = '' THEN
                    ServiceLocation := ServiceSetup."Def. Service Location Code";
            END ELSE BEGIN
                ServiceLocation := UserProfile."Def. Service Location Code";
                IF ServiceLocation = '' THEN
                    ServiceLocation := ServiceSetup."Def. Service Location Code";
            END;
        END ELSE
            ServiceLocation := ServiceSetup."Def. Service Location Code";
        EXIT(ServiceLocation);
    end;

    [Scope('Internal')]
    procedure SetLocationCode(LocationCodeToSet: Code[20])
    begin
        LocationCode := LocationCodeToSet;
    end;
}


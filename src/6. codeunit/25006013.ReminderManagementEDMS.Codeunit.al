codeunit 25006013 "Reminder Management EDMS"
{

    trigger OnRun()
    var
        LicensePermission: Record "2000000043";
    begin
        IF NOT UserSetup.GET(USERID) THEN EXIT;

        //Check for SIE
        IF UserSetup."SIE management" THEN BEGIN
            LicensePermission.SETRANGE("Object Type", LicensePermission."Object Type"::Codeunit);
            LicensePermission.SETRANGE("Object Number", CODEUNIT::"SIE Management");
            LicensePermission.SETFILTER("Execute Permission", '<>%1', LicensePermission."Execute Permission"::" ");
            IF NOT LicensePermission.ISEMPTY THEN
                SIEMgt.CheckReminders
        END
    end;

    var
        UserSetup: Record "91";
        SIEMgt: Codeunit "25006700";
}


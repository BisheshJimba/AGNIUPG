codeunit 25006700 "SIE Management"
{
    // 29.12.2014 EDMS P11
    //   Changed version of Timer variable from 7.0.0.0 to 8.0.0.0
    // 
    // 13.11.2007 P3
    //   * Disabled timer stop to retry attempts every 3 minutes

    SingleInstance = true;

    trigger OnRun()
    begin
        SIESetup.GET;
        LogFileName := GetLogFileName();
        BringSystemMsg(Text002);

        CLEAR(Timer);
        Timer := Timer.Timer();
        Timer.Interval(SIESetup."Synch. Interval (sec)" * 1000);
        Timer.Start();
    end;

    var
        SpecInvtEquip: Record "25006700";
        SIESetup: Record "25006701";
        RunTimeParams: Record "25006705" temporary;
        SIEXMLExch: Codeunit "25006701";
        Text001: Label 'This SIE Entry is not active. Are you sure you want to synchronize?';
        Text002: Label 'SIE inside NAS has started!';
        DocumentManagementDMS: Codeunit "25006000";
        PingCounter: Integer;
        LogFileName: Text[1024];
        Timer: DotNet Timer;

    [Scope('Internal')]
    procedure SIESinhronize(SpecInvtEquip: Record "25006700")
    begin
        IF NOT SpecInvtEquip.Active THEN BEGIN
            IF GUIALLOWED THEN
                IF NOT DIALOG.CONFIRM(Text001, TRUE) THEN
                    EXIT
                ELSE BEGIN
                    BringSystemMsg(Text001);
                    EXIT;
                END;
        END;
        RunTimeParams."DSN Name" := SpecInvtEquip."DSN Name";
        RunTimeParams."Run Mode" := RunTimeParams."Run Mode"::Synchronize;
        RunTimeParams.Direction := RunTimeParams.Direction::Export;
        RunTimeParams."SIE No." := SpecInvtEquip."No.";
        CODEUNIT.RUN(SpecInvtEquip."Control Unit", RunTimeParams);
        SIEXMLExch.RUN;
    end;

    [Scope('Internal')]
    procedure LookUpSIEObject(var SIEObject: Record "25006707"; SIENo: Code[10]; codNo: Code[20]): Boolean
    var
        SIEObjectList: Page "25006756";
    begin
        CLEAR(SIEObjectList);
        IF codNo <> '' THEN
            IF SIEObject.GET(codNo) THEN
                SIEObjectList.SETRECORD(SIEObject);
        SIEObjectList.SETTABLEVIEW(SIEObject);
        SIEObjectList.LOOKUPMODE(TRUE);
        IF SIEObjectList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            SIEObjectList.GETRECORD(SIEObject);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure SIEValidateField(var JnlLine: Record "25006702"; FldNo: Integer)
    begin
        SpecInvtEquip.RESET;
        SpecInvtEquip.GET(JnlLine."SIE No.");
        //COMMENT1
        JnlLine."To Validate Field" := FldNo;
        JnlLine."To Validate Field" := FldNo;
        JnlLine."To Validate Field" := FldNo;
        CODEUNIT.RUN(SpecInvtEquip."Posting Unit", JnlLine);
    end;

    [Scope('Internal')]
    procedure SIEPostJnl(var SIEJnlLine: Record "25006702")
    begin
        SpecInvtEquip.RESET;
        SpecInvtEquip.GET(SIEJnlLine."SIE No.");
        SIEJnlLine.SETRANGE("SIE No.", SIEJnlLine."SIE No.");
        CODEUNIT.RUN(SpecInvtEquip."Posting Unit", SIEJnlLine);
    end;

    [Scope('Internal')]
    procedure CheckReminders()
    var
        UserSetup: Record "91";
    begin
        IF NOT UserSetup.GET(USERID) OR NOT UserSetup."SIE management" THEN EXIT;
        SpecInvtEquip.RESET;
        SpecInvtEquip.SETRANGE(Active, TRUE);
        IF SpecInvtEquip.FINDFIRST THEN
            REPEAT
                IF (SpecInvtEquip."Check 1" AND (SpecInvtEquip."Check 1 Show Reminder" = SpecInvtEquip."Check 1 Show Reminder"::Checked)) OR
                   (NOT SpecInvtEquip."Check 1" AND (SpecInvtEquip."Check 1 Show Reminder" = SpecInvtEquip."Check 1 Show Reminder"::Unchecked))
                THEN
                    IF GUIALLOWED THEN
                        BringSystemMsg(SpecInvtEquip."Check 1 Reminder Msg");
            UNTIL SpecInvtEquip.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetLogFileName(): Text[1024]
    begin
        SIESetup.GET;
        IF SIESetup."Processing Log Active" THEN
            EXIT(SIESetup."Processing Log Path" + 'SIEmgtLogFile.log')
        ELSE
            EXIT('');
    end;

    [Scope('Internal')]
    procedure BringSystemMsg(TextPar: Text[1024])
    var
        BText: BigText;
    begin
        IF SIESetup."Processing Log Active" THEN BEGIN
            BText.ADDTEXT('Log at ' + FORMAT(TIME()) + ' ');
            BText.ADDTEXT(' ' + TextPar);
            DocumentManagementDMS.WriteBigTextToFile(BText, LogFileName);
        END ELSE
            MESSAGE(TextPar);

        EXIT;
    end;

    trigger Timer::Elapsed(sender: Variant; e: DotNet EventArgs)
    begin
    end;

    trigger Timer::ExceptionOccurred(sender: Variant; e: DotNet ExceptionOccurredEventArgs)
    begin
    end;
}


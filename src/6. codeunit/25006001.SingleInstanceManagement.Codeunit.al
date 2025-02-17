codeunit 25006001 SingleInstanceManagement
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified SetUserProfile, removed User Profile Setup variable
    // 
    // 12.06.2015 EB.P7 #Scheduler 3.0
    //   CurrentUserID global variable added
    //   Functions SetCurrentUserId, GetCurrentUserId,
    //     SetCurrentPeriod,GetCurrentPeriod, SetCurrentDate, GetCurrentDate added
    // 
    // 06.05.2014 Elva Baltic P8 #F037 MMG7.00
    //   * Changes in SetUserProfile

    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        bDocItemStatFrmOpen: Boolean;
        codDocItemStatItemNo: Code[20];
        UserProfileID: Code[30];
        CurrentUserID: Code[50];
        CurrentPeriod: Option "None",Day,Week;
        CurrentDate: Date;
        OwnOptionTemp: Record "25006372" temporary;
        ManufacturerOptionTemp: Record "25006370" temporary;
        ServiceHeaderTemp: Record "25006145" temporary;
        GlobalEntryNo: Integer;
        DateFilter: Date;
        LineResources: Text[250];
        MustQuestForProfile: Boolean;
        UserProfileMgt: Codeunit "25006002";
        PageHasToRefresh: Boolean;

    [Scope('Internal')]
    procedure SetDocItemStatFrmOpen(bNewValue: Boolean)
    begin
        bDocItemStatFrmOpen := bNewValue;
    end;

    [Scope('Internal')]
    procedure GetDoctItemStatFrmOpen(): Boolean
    begin
        EXIT(bDocItemStatFrmOpen);
    end;

    [Scope('Internal')]
    procedure SetUserProfile(NewValue: Code[30]; RunModeFlags: Integer)
    var
        User: Record "2000000120";
        UserSetup: Record "91";
        UserPersonalization: Record "2000000073";
        StatusArray: array[10] of Integer;
    begin
        // RunModeFlags = 11, what statuses are taken in account readen from right to left (store value to UserSetup, store value to UserPersonalization)
        AdjustFlagsToArray(RunModeFlags, StatusArray);
        UserProfileID := NewValue;
        //06.05.2014 Elva Baltic P8 #F037 MMG7.00 >>
        IF IsIntInArrayTen(0, StatusArray) THEN
            IF UserSetup.GET(USERID) THEN
                IF UserSetup."Default User Profile Code" = '' THEN BEGIN
                    UserSetup."Default User Profile Code" := UserProfileID;
                    UserSetup.MODIFY;
                END;
        IF IsIntInArrayTen(1, StatusArray) THEN BEGIN
            User.RESET;
            User.SETRANGE("User Name", UPPERCASE(USERID));
            IF User.FINDFIRST THEN
                IF UserPersonalization.GET(User."User Security ID") THEN
                    IF UserPersonalization."Profile ID" = '' THEN BEGIN
                        UserPersonalization."Profile ID" := UserProfileID;
                        UserPersonalization.MODIFY;
                    END;
        END;
        //06.05.2014 Elva Baltic P8 #F037 MMG7.00 <<
    end;

    [Scope('Internal')]
    procedure GetUserProfile(): Code[30]
    begin
        EXIT(UserProfileMgt.CurrProfileID);
    end;

    [Scope('Internal')]
    procedure SetDocItemStatItemNo(bNewValue: Code[20])
    begin
        codDocItemStatItemNo := bNewValue;
    end;

    [Scope('Internal')]
    procedure GetDoctItemStatItemNo(): Code[20]
    begin
        EXIT(codDocItemStatItemNo);
    end;

    [Scope('Internal')]
    procedure SetOwnOption(var OwnOption1: Record "25006372")
    begin
        OwnOptionTemp.RESET;
        OwnOptionTemp.DELETEALL;
        IF OwnOption1.FINDFIRST THEN
            REPEAT
                OwnOptionTemp := OwnOption1;
                OwnOptionTemp.INSERT
            UNTIL OwnOption1.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetOwnOption(var OwnOption: Record "25006372")
    begin
        IF OwnOptionTemp.FINDFIRST THEN
            REPEAT
                OwnOption := OwnOptionTemp;
                OwnOption.INSERT
            UNTIL OwnOptionTemp.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SetManufacturerOption(var ManufacturerOption1: Record "25006370")
    begin
        ManufacturerOptionTemp.RESET;
        ManufacturerOptionTemp.DELETEALL;
        IF ManufacturerOption1.FINDFIRST THEN
            REPEAT
                ManufacturerOptionTemp := ManufacturerOption1;
                ManufacturerOptionTemp.INSERT;
            UNTIL ManufacturerOption1.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetManufacturerOption(var ManufacturerOption: Record "25006370")
    begin
        IF ManufacturerOptionTemp.FINDFIRST THEN
            REPEAT
                ManufacturerOption := ManufacturerOptionTemp;
                ManufacturerOption.INSERT;
            UNTIL ManufacturerOptionTemp.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SetCurrAllocation(EntryNo: Integer)
    begin
        GlobalEntryNo := EntryNo;
    end;

    [Scope('Internal')]
    procedure ClearCurrAllocation()
    begin
        GlobalEntryNo := 0;
    end;

    [Scope('Internal')]
    procedure GetAllocationEntryNo(): Integer
    begin
        EXIT(GlobalEntryNo);
    end;

    [Scope('Internal')]
    procedure SetDateFilter(DateFilter1: Date)
    begin
        DateFilter := DateFilter1;
    end;

    [Scope('Internal')]
    procedure GetDateFilter(): Date
    begin
        EXIT(DateFilter)
    end;

    [Scope('Internal')]
    procedure SetServiceHeader(var ServiceHeader1: Record "25006145")
    begin
        ServiceHeaderTemp.RESET;
        ServiceHeaderTemp.DELETEALL;
        ServiceHeaderTemp := ServiceHeader1;
        ServiceHeaderTemp.INSERT;
    end;

    [Scope('Internal')]
    procedure GetServiceHeader(var ServiceHeader: Record "25006145"): Boolean
    var
        FindRec: Boolean;
    begin
        FindRec := FALSE;
        IF ServiceHeaderTemp.FINDFIRST THEN
            IF ServiceHeader.GET(ServiceHeaderTemp."Document Type", ServiceHeaderTemp."No.") THEN
                FindRec := TRUE;
        EXIT(FindRec)
    end;

    [Scope('Internal')]
    procedure SetLineResources(LineResourcesPar: Text[250])
    begin
        LineResources := LineResourcesPar;
    end;

    [Scope('Internal')]
    procedure GetLineResources(): Text[250]
    begin
        EXIT(LineResources);
    end;

    [Scope('Internal')]
    procedure SetMustQuestForProfile(Value: Boolean)
    begin
        MustQuestForProfile := Value;
    end;

    [Scope('Internal')]
    procedure GetMustQuestForProfile(): Boolean
    begin
        EXIT(MustQuestForProfile);
    end;

    [Scope('Internal')]
    procedure SetCurrentUserId(UserIdToSet: Code[50])
    begin
        CurrentUserID := UserIdToSet;
    end;

    [Scope('Internal')]
    procedure GetCurrentUserId(): Code[50]
    begin
        IF CurrentUserID = '' THEN
            SetCurrentUserId(USERID);
        EXIT(CurrentUserID);
    end;

    [Scope('Internal')]
    procedure SetCurrentPeriod(Period: Option "None",Day,Week)
    begin
        CurrentPeriod := Period;
    end;

    [Scope('Internal')]
    procedure GetCurrentPeriod(): Integer
    begin
        EXIT(CurrentPeriod);
    end;

    [Scope('Internal')]
    procedure SetCurrentDate(CurrDate: Date)
    begin
        CurrentDate := CurrDate;
    end;

    [Scope('Internal')]
    procedure GetCurrentDate(): Date
    begin
        IF CurrentDate = 0D THEN
            SetCurrentDate(WORKDATE);
        EXIT(CurrentDate);
    end;

    [Scope('Internal')]
    procedure SetPageHasToRefresh(HasToRefresh: Boolean)
    begin
        PageHasToRefresh := HasToRefresh;
    end;

    [Scope('Internal')]
    procedure GetPageHasToRefresh(): Boolean
    begin
        EXIT(PageHasToRefresh);
    end;

    [Scope('Internal')]
    procedure "--SMALL TECHN--"()
    begin
    end;

    [Scope('Internal')]
    procedure CutNextDigit(var Flags: Integer) RetValue: Integer
    begin
        RetValue := Flags MOD 10;
        Flags := Flags DIV 10;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure AdjustFlagsToArray(Flags: Integer; var ArrayDMS: array[10] of Integer)
    var
        i: Integer;
    begin
        FOR i := 1 TO 10 DO BEGIN
            IF (CutNextDigit(Flags) > 0) THEN
                ArrayDMS[i] := i - 1
            ELSE
                ArrayDMS[i] := -1;
        END;
    end;

    [Scope('Internal')]
    procedure IsIntInArrayTen(CheckValue: Integer; var ArrayDMS: array[10] of Integer) RetValue: Boolean
    var
        i: Integer;
    begin
        FOR i := 1 TO 10 DO BEGIN
            IF (CheckValue = ArrayDMS[i]) THEN
                RetValue := TRUE;
        END;

        EXIT(RetValue);
    end;
}


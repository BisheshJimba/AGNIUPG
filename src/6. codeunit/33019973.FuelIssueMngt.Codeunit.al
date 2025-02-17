codeunit 33019973 "Fuel Issue Mngt."
{

    trigger OnRun()
    begin
    end;

    var
        GlobalStartDate: Date;
        GlobalEndDate: Date;

    [Scope('Internal')]
    procedure calcStaffFuelUsage(PrmStaffNo: Code[20]; PrmIssueDate: Date; PrmType: Option " ",Vehicle,Motorcycle; PrmFuelLtr: Decimal)
    var
        LocalEmployee: Record "5200";
        LocalFuelRules: Record "33020300";
        Text33019961: Label 'Please check - Staff No. - %1, has crossed allowed fuel limit.';
        LocalFuelLedg: Record "33019965";
    begin
        //Retriving month start and end date according to nepali month.
        getDateFormula(PrmIssueDate);

        LocalEmployee.GET(PrmStaffNo);

        IF PrmType = PrmType::Vehicle THEN BEGIN
            LocalFuelRules.RESET;
            LocalFuelRules.SETRANGE(Code, LocalEmployee."Grade Code");
            LocalFuelRules.SETFILTER(Type, 'Vehicle');
            IF LocalFuelRules.FIND('-') THEN BEGIN
                IF NOT LocalFuelRules."No. Limit" THEN BEGIN
                    IF (PrmFuelLtr + getFuelConsumption(PrmStaffNo)) > LocalFuelRules."Fuel (Litre)" THEN
                        ERROR(Text33019961, PrmStaffNo);
                END;
            END;
        END ELSE
            IF PrmType = PrmType::Motorcycle THEN BEGIN
                LocalFuelRules.RESET;
                LocalFuelRules.SETRANGE(Code, LocalEmployee."Grade Code");
                LocalFuelRules.SETFILTER(Type, 'Motorcycle');
                IF LocalFuelRules.FIND('-') THEN BEGIN
                    IF NOT LocalFuelRules."No. Limit" THEN BEGIN
                        IF (PrmFuelLtr + getFuelConsumption(PrmStaffNo)) > LocalFuelRules."Fuel (Litre)" THEN
                            ERROR(Text33019961, PrmStaffNo);
                    END;
                END;
            END;
    end;

    [Scope('Internal')]
    procedure getDateFormula(PrmIssueDate: Date)
    var
        LocalCalender: Record "33020302";
        LocalCalender2: Record "33020302";
        LocalCalender3: Record "33020302";
        LocalNepMth: Option " ",Baisakh,Jestha,Asar,Shrawn,Bhadra,Ashoj,Kartik,Mangsir,Poush,Margh,Falgun,Chaitra;
        LocalNepYr: Integer;
    begin
        LocalCalender.RESET;
        LocalCalender.SETRANGE("English Date", PrmIssueDate);
        IF LocalCalender.FIND('-') THEN BEGIN
            LocalNepMth := LocalCalender."Nepali Month";
            LocalNepYr := LocalCalender."Nepali Year";
            //Retriving Start Date.
            LocalCalender2.RESET;
            LocalCalender2.SETRANGE("Nepali Year", LocalNepYr);
            LocalCalender2.SETRANGE("Nepali Month", LocalNepMth);
            IF LocalCalender2.FIND('-') THEN
                GlobalStartDate := LocalCalender2."English Date";

            //Retriving End Date.
            LocalCalender3.RESET;
            LocalCalender3.SETRANGE("Nepali Year", LocalNepYr);
            LocalCalender3.SETRANGE("Nepali Month", LocalNepMth);
            IF LocalCalender3.FIND('+') THEN
                GlobalEndDate := LocalCalender3."English Date";
        END;
    end;

    [Scope('Internal')]
    procedure getFuelConsumption(PrmStaffNo: Code[20]): Decimal
    var
        LocalFuelLedg: Record "33019965";
        LocalConsFuel: Decimal;
    begin
        LocalFuelLedg.RESET;
        LocalFuelLedg.SETRANGE("Staff No.", PrmStaffNo);
        LocalFuelLedg.SETFILTER("Posting Date", '%1..%2', GlobalStartDate, GlobalEndDate);
        IF LocalFuelLedg.FIND('-') THEN BEGIN
            REPEAT
                LocalConsFuel += LocalFuelLedg.Quantity;
            UNTIL LocalFuelLedg.NEXT = 0;
        END;

        EXIT(LocalConsFuel);
    end;

    [Scope('Internal')]
    procedure voidIssuedCoupon()
    var
        LocalVoidFuelIssue: Record "33019985";
        LocalFuelLedgEntry: Record "33019965";
        LocalPostedFuelIssue: Record "33019967";
        LclUserSetup: Record "91";
        Text33019961: Label 'Coupon(s) cancelled successfully.';
    begin
        LclUserSetup.GET(USERID);
        LocalVoidFuelIssue.RESET;
        LocalVoidFuelIssue.SETRANGE("Responsibility Center", LclUserSetup."Default Location");
        LocalVoidFuelIssue.SETRANGE(Void, TRUE);
        IF LocalVoidFuelIssue.FIND('-') THEN BEGIN
            REPEAT
                LocalFuelLedgEntry.RESET;
                LocalFuelLedgEntry.SETRANGE("Document Type", LocalVoidFuelIssue.Type);
                LocalFuelLedgEntry.SETRANGE("Document No.", LocalVoidFuelIssue."Coupon No.");
                IF LocalFuelLedgEntry.FIND('-') THEN BEGIN
                    LocalFuelLedgEntry.Void := TRUE;
                    LocalFuelLedgEntry.MODIFY;
                END;
                LocalPostedFuelIssue.RESET;
                LocalPostedFuelIssue.SETRANGE("Document Type", LocalVoidFuelIssue.Type);
                LocalPostedFuelIssue.SETRANGE("No.", LocalVoidFuelIssue."Coupon No.");
                IF LocalPostedFuelIssue.FIND('-') THEN BEGIN
                    //LocalPostedFuelIssue."Department Name" := TRUE;
                    LocalPostedFuelIssue.MODIFY;
                END;
                deleteAfterVoid(LocalVoidFuelIssue.Type, LocalVoidFuelIssue."Coupon No.", LocalVoidFuelIssue."Responsibility Center");
            UNTIL LocalVoidFuelIssue.NEXT = 0;
            MESSAGE(Text33019961);
        END;
    end;

    [Scope('Internal')]
    procedure deleteAfterVoid(PrmType: Option Coupon,Stock,Cash; PrmCouponNo: Code[20]; PrmResCenter: Code[10])
    var
        LocalVoidFuelIssue: Record "33019985";
    begin
        LocalVoidFuelIssue.RESET;
        LocalVoidFuelIssue.SETRANGE(Type, PrmType);
        LocalVoidFuelIssue.SETRANGE("Coupon No.", PrmCouponNo);
        LocalVoidFuelIssue.SETRANGE("Responsibility Center", PrmResCenter);
        IF LocalVoidFuelIssue.FIND('-') THEN
            LocalVoidFuelIssue.DELETEALL;
    end;
}


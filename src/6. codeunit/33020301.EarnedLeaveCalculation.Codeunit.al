codeunit 33020301 "Earned Leave Calculation"
{

    trigger OnRun()
    begin
        UpdateLeaveAcc;
        MESSAGE('success...');
    end;

    [Scope('Internal')]
    procedure CalculateEarnDays(Month: Integer; Year: Integer; EmpCode: Code[10]; LeaveType: Code[20]): Decimal
    var
        LeaveTypeRec: Record "33020345";
        LeaveAccount: Record "33020370";
        EarnedDays: Integer;
        EarnDaysPerMnth: Decimal;
        CalculationInt: Integer;
        LeaveReg: Record "33020343";
        LastCalculateDate: Date;
        Calendar: Record "33020302";
        FiscalYear: Code[10];
        "Total Leave Taken": Decimal;
        FiscalYrStrtDate: Date;
    begin


        LeaveAccount.SETRANGE("Employee Code", EmpCode);
        LeaveAccount.SETRANGE("Leave Type", LeaveType);
        IF LeaveAccount.FIND('-') THEN BEGIN
            LastCalculateDate := LeaveAccount.LastCalculatedDate;

            IF (DATE2DMY(LastCalculateDate, 2) <> DATE2DMY(TODAY, 2)) THEN BEGIN
                CalculationInt := (DATE2DMY(TODAY, 2) - 1) - DATE2DMY(LastCalculateDate, 2);
                IF (CalculationInt < 0) THEN
                    CalculationInt := CalculationInt + 12;
                LeaveTypeRec.SETRANGE("Leave Type Code", LeaveType);
                IF LeaveTypeRec.FIND('-') THEN BEGIN
                    IF (LeaveTypeRec."Earned Per Month" = TRUE) THEN BEGIN
                        EarnedDays := LeaveAccount."Earned Days" + (CalculationInt * (LeaveTypeRec."Days Earned Per Year"
                          DIV 12)
  );
                        LeaveAccount."Earned Days" := EarnedDays;
                        LeaveAccount.LastCalculatedDate := TODAY;
                        LeaveAccount.MODIFY;
                    END
                    ELSE
                        IF (LeaveTypeRec."Earned Per Month" = FALSE) THEN BEGIN
                            EarnedDays := LeaveAccount."Earned Days" + (CalculationInt * (LeaveTypeRec."Days Earned Per Year"));
                            LeaveAccount."Earned Days" := EarnedDays;
                            LeaveAccount.LastCalculatedDate := TODAY;
                            LeaveAccount.MODIFY;
                        END
                END
            END
        END
        ELSE BEGIN
            //If no record found in 'Leave Account' Table
            Calendar.SETRANGE("English Date", TODAY);

            IF Calendar.FIND('-') THEN BEGIN
                FiscalYear := Calendar."Fiscal Year";
            END;

            CalculationInt := 0;

            Calendar.RESET;
            Calendar.SETRANGE("Fiscal Year", FiscalYear);
            IF Calendar.FIND('-') THEN BEGIN
                FiscalYrStrtDate := Calendar."English Date";
                // MESSAGE(FORMAT(FiscalYrStrtDate));
                CalculationInt := (DATE2DMY(TODAY, 2) - 1) - (DATE2DMY(FiscalYrStrtDate, 2));
                IF (CalculationInt < 0) THEN
                    CalculationInt := CalculationInt + 12;

                // MESSAGE(FORMAT(CalculationInt));
            END;

            EarnedDays := 0;
            LeaveTypeRec.SETRANGE("Leave Type Code", LeaveType);
            IF LeaveTypeRec.FIND('-') THEN BEGIN
                EarnedDays := (CalculationInt * (LeaveTypeRec."Days Earned Per Year" DIV 12));
            END;

            LeaveReg.SETRANGE("Employee No.", EmpCode);
            LeaveReg.SETRANGE("Fiscal Year", FiscalYear);
            LeaveReg.SETRANGE("Leave Type Code", LeaveType);
            IF LeaveReg.FIND('-') THEN BEGIN
                REPEAT
                    "Total Leave Taken" := "Total Leave Taken" + LeaveReg."Used Days";
                UNTIL LeaveReg.NEXT = 0;

                LeaveAccount.INIT;
                LeaveAccount."Employee Code" := EmpCode;
                LeaveAccount."Leave Type" := LeaveType;
                LeaveAccount.LastCalculatedDate := TODAY;
                LeaveAccount."Total Leaves" := "Total Leave Taken";
                LeaveAccount."Earned Days" := EarnedDays - "Total Leave Taken";
                LeaveAccount.INSERT;
            END
            //If No record found in 'Leave Register' Table
            ELSE BEGIN
                LeaveAccount.INIT;
                LeaveAccount."Employee Code" := EmpCode;
                LeaveAccount."Leave Type" := LeaveType;
                LeaveAccount.LastCalculatedDate := TODAY;
                LeaveAccount."Total Leaves" := 0;
                LeaveAccount."Earned Days" := EarnedDays;
                LeaveAccount.INSERT;
                //  MESSAGE(FORMAT(EarnedDays));
            END
        END;

        EXIT(LeaveAccount."Earned Days");
    end;

    [Scope('Internal')]
    procedure EarnLeaveAtYearEnd("Employee Code": Code[10]; "Fiscal Year": Code[10]; "Leave Type": Code[20])
    var
        LeaveReg: Record "33020343";
        LeaveAcc: Record "33020370";
        LeaveTyp: Record "33020345";
        "Total Leave Taken": Decimal;
        "Earned Days": Decimal;
        LastCalculateDate: Date;
        CalculationInt: Integer;
    begin
        LeaveReg.SETRANGE("Employee No.", "Employee Code");
        LeaveReg.SETRANGE("Fiscal Year", "Fiscal Year");
        LeaveReg.SETRANGE("Leave Type Code", "Leave Type");
        IF LeaveReg.FIND('-') THEN BEGIN
            REPEAT
                "Total Leave Taken" := "Total Leave Taken" + LeaveReg."Used Days";
            UNTIL LeaveReg.NEXT = 0;

            LeaveAcc.SETRANGE("Employee Code", "Employee Code");
            LeaveAcc.SETRANGE("Leave Type", "Leave Type");
            IF LeaveAcc.FIND('-') THEN BEGIN
                LastCalculateDate := LeaveAcc.LastCalculatedDate;
                IF (DATE2DMY(LastCalculateDate, 2) < DATE2DMY(TODAY, 2)) THEN BEGIN
                    CalculationInt := DATE2DMY(TODAY, 2) - DATE2DMY(LastCalculateDate, 2);

                    LeaveTyp.SETRANGE("Leave Type Code", "Leave Type");
                    IF LeaveTyp.FIND('-') THEN BEGIN
                        "Earned Days" := LeaveAcc."Earned Days" + (CalculationInt * (LeaveTyp."Days Earned Per Year" DIV 12));
                        // LeaveAcc."No. of Days Earned" := CalculationInt * (LeaveTyp."Days Earned Per Year"/12);
                    END
                END;
                LeaveAcc."Total Leaves" := "Total Leave Taken";
                LeaveAcc.LastCalculatedDate := TODAY;
                LeaveAcc.MODIFY;
            END;

        END
        ELSE BEGIN
            LeaveAcc.INIT;
            LeaveAcc."Employee Code" := "Employee Code";
            LeaveAcc."Leave Type" := "Leave Type";
            LeaveAcc.LastCalculatedDate := TODAY;
            LeaveAcc.CALCFIELDS("Total Leaves");

            LeaveTyp.SETRANGE("Leave Type Code", "Leave Type");
            IF LeaveTyp.FIND('-') THEN BEGIN
                LeaveAcc."Earned Days" := LeaveTyp."Days Earned Per Year";
            END;
            LeaveAcc.INSERT;
        END;
    end;

    [Scope('Internal')]
    procedure EarnLeaveAtMonthEnd("Employee Code": Code[10]; "Fiscal Year": Code[10]; "Leave Type": Code[20])
    var
        LeaveReg: Record "33020343";
        LeaveAcc: Record "33020370";
        LeaveTyp: Record "33020345";
    begin
        LeaveReg.SETRANGE("Employee No.", "Employee Code");
        LeaveReg.SETRANGE("Fiscal Year", "Fiscal Year");
        LeaveReg.SETRANGE("Leave Type Code", "Leave Type");
        REPEAT
            LeaveAcc.SETRANGE("Employee Code", "Employee Code");
            LeaveAcc.SETRANGE("Leave Type", "Leave Type");
            IF LeaveAcc.FIND('-') THEN BEGIN
                LeaveAcc.CALCFIELDS("Total Leaves");//Calculates leaves till now (should filter leaves of the fiscal year only)

                LeaveTyp.SETRANGE("Leave Type Code", "Leave Type");
                IF LeaveTyp.FIND('-') THEN BEGIN
                    LeaveAcc."Earned Days" := LeaveTyp."Days Earned Per Year" - LeaveAcc."Total Leaves";
                END;
            END;
        UNTIL LeaveReg.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure NonEarnableLeaveCalculation(EmpCode: Code[10]; LeaveType: Code[20]): Integer
    var
        LeaveTypeRec: Record "33020345";
        LeaveAccount: Record "33020370";
        LeaveReg: Record "33020343";
        NumOfTimes: Integer;
    begin

        LeaveAccount.SETRANGE("Employee Code", EmpCode);
        LeaveAccount.SETRANGE("Leave Type", LeaveType);
        IF LeaveAccount.FIND('-') THEN BEGIN
            NumOfTimes := LeaveAccount."Used Days";
            MESSAGE(FORMAT(NumOfTimes));
        END
        ELSE BEGIN
            LeaveReg.SETRANGE("Employee No.", EmpCode);
            LeaveReg.SETRANGE("Leave Type Code", LeaveType);
            NumOfTimes := LeaveReg.COUNT;

            LeaveAccount.INIT;
            LeaveAccount."Employee Code" := EmpCode;
            LeaveAccount."Leave Type" := LeaveType;
            LeaveAccount.LastCalculatedDate := TODAY;
            LeaveAccount."Used Days" := NumOfTimes;
            LeaveAccount.INSERT;
        END;
        EXIT(NumOfTimes);
    end;

    local procedure "--TemporaryCode--"()
    begin
    end;

    [Scope('Internal')]
    procedure UpdateLeaveTypeInAllLeaveRelatedTables(SelectedCompany: Record "2000000006")
    var
        Companies: Record "2000000006";
        LeaveType: Record "33020345";
        LeaveRequest: Record "33020342";
        LeaveReg: Record "33020343";
        PosedLeaveRequest: Record "33020344";
        LeaveApprovedDisapproved: Record "33020346";
        LeaveEncashment: Record "33020362";
        LeaveAcc: Record "33020370";
        LeaveEarn: Record "33020398";
    begin
        //Rename leave type code CL to HL in all company after then run this function
        Companies.RESET;
        //Companies.SETRANGE(Name,'Agni Moto Inc Pvt. Ltd.');
        Companies.SETRANGE(Name, SelectedCompany.Name);
        IF Companies.FINDFIRST THEN
            REPEAT
                LeaveType.RESET;
                LeaveType.CHANGECOMPANY(Companies.Name);
                LeaveType.SETRANGE("Leave Type Code", 'HL');
                IF LeaveType.FINDFIRST THEN BEGIN
                    LeaveType.INIT;
                    LeaveType.Description := 'Home Leave';
                    LeaveType."Days Earned Per Year" := 18;
                    LeaveType."Earnable Per Year" := TRUE;
                    LeaveType."Maximum Allowable Limit" := 18;
                    LeaveType."Pay Type" := LeaveType."Pay Type"::Paid;
                    LeaveType.MODIFY;
                END ELSE
                    ERROR('Leave type with code HL not found in master');

                LeaveType.RESET;
                LeaveType.CHANGECOMPANY(Companies.Name);
                LeaveType.SETFILTER("Leave Type Code", '%1|%2', 'SC', 'SL');
                IF LeaveType.FINDFIRST THEN
                    REPEAT
                        IF LeaveType."Leave Type Code" = 'SC' THEN BEGIN
                            LeaveType."Days Earned Per Year" := 12;
                            LeaveType."Maximum Allowable Limit" := 12;
                        END ELSE
                            IF LeaveType."Leave Type Code" = 'SL' THEN BEGIN
                                LeaveType."Days Earned Per Year" := 4;
                                LeaveType."Maximum Allowable Limit" := 4;
                            END;
                        LeaveType.MODIFY;
                    UNTIL LeaveType.NEXT = 0;
                LeaveAcc.RESET;
                LeaveAcc.CHANGECOMPANY(Companies.Name);
                LeaveAcc.SETFILTER("Leave Type", '%1|%2|%3', 'HL', 'SL', 'SC');
                IF LeaveAcc.FINDFIRST THEN
                    REPEAT
                        IF LeaveAcc."Leave Type" = 'HL' THEN BEGIN
                            LeaveAcc."Balance Days" := 18;
                            LeaveAcc.MODIFY;
                        END ELSE
                            IF LeaveAcc."Leave Type" = 'SL' THEN BEGIN
                                LeaveAcc."Balance Days" := 4;
                                LeaveAcc.MODIFY;
                            END ELSE
                                IF LeaveAcc."Leave Type" = 'SC' THEN BEGIN
                                    LeaveAcc."Balance Days" := 12;
                                    LeaveAcc.MODIFY;
                                END;
                    UNTIL LeaveAcc.NEXT = 0;

                LeaveReg.RESET;
                LeaveReg.CHANGECOMPANY(Companies.Name);
                //LeaveReg.SETFILTER("Leave Type Code",'%1|%2|%3','HL','SL','SC');
                LeaveReg.SETFILTER("Leave Type Code", 'HL');
                LeaveReg.SETFILTER(Remarks, 'AUTO INSERTED');
                IF LeaveReg.FINDFIRST THEN
                    REPEAT
                        //IF LeaveReg."Leave Type Code" = 'HL' THEN BEGIN
                        /*IF LeaveReg."Earn Days" >= 18 THEN BEGIN
                          LeaveReg."Earn Days" := 18;
                          LeaveReg.MODIFY;
                        END;*/
                        IF (LeaveReg."Earn Days" = 22) AND (LeaveReg."Balance Days" <= 18) THEN BEGIN
                            LeaveReg."Temp. Earn Days" := 4;
                            LeaveReg.MODIFY;
                        END;
                        IF (LeaveReg."Balance Days" > 18) AND (LeaveReg."Balance Days" < 22) THEN BEGIN
                            LeaveReg."Temp. Earn Days 2" := (LeaveReg."Earn Days" - LeaveReg."Balance Days");
                            LeaveReg.MODIFY;
                        END;
                        IF LeaveReg."Leave Type Code" = 'SL' THEN BEGIN
                            LeaveReg."Balance Days" := 4;
                            LeaveReg.MODIFY;
                        END;
                        IF LeaveReg."Leave Type Code" = 'SC' THEN BEGIN
                            LeaveReg."Balance Days" := 12;
                            LeaveReg.MODIFY;
                        END;
                    UNTIL LeaveReg.NEXT = 0;

                LeaveRequest.RESET;
                LeaveRequest.CHANGECOMPANY(Companies.Name);
                LeaveRequest.SETRANGE("Leave Type Code", 'CL');
                IF LeaveRequest.FINDFIRST THEN
                    REPEAT
                        LeaveRequest."Leave Type Code" := 'HL';
                        LeaveRequest.MODIFY;
                    UNTIL LeaveRequest.NEXT = 0;

                PosedLeaveRequest.RESET;
                PosedLeaveRequest.CHANGECOMPANY(Companies.Name);
                PosedLeaveRequest.SETRANGE("Leave Type Code", 'CL');
                IF PosedLeaveRequest.FINDFIRST THEN
                    REPEAT
                        IF PosedLeaveRequest."Leave Type Code" = 'CL' THEN BEGIN
                            PosedLeaveRequest."Leave Type Code" := 'HL';
                            PosedLeaveRequest.MODIFY;
                        END;
                    UNTIL PosedLeaveRequest.NEXT = 0;

                LeaveApprovedDisapproved.RESET;
                LeaveApprovedDisapproved.CHANGECOMPANY(Companies.Name);
                LeaveApprovedDisapproved.SETRANGE("Leave Type Code", 'CL');
                IF LeaveApprovedDisapproved.FINDFIRST THEN
                    REPEAT
                        LeaveApprovedDisapproved."Leave Type Code" := 'HL';
                        LeaveApprovedDisapproved.MODIFY;
                    UNTIL LeaveApprovedDisapproved.NEXT = 0;

                LeaveEncashment.RESET;
                LeaveEncashment.CHANGECOMPANY(Companies.Name);
                LeaveEncashment.SETRANGE("Leave Type", 'CL');
                IF LeaveEncashment.FINDFIRST THEN
                    REPEAT
                        LeaveEncashment."Leave Type" := 'HL';
                        LeaveEncashment.MODIFY;
                    UNTIL LeaveEncashment.NEXT = 0;

                LeaveEarn.RESET;
                LeaveEarn.CHANGECOMPANY(Companies.Name);
                LeaveEarn.SETRANGE("Leave Code", 'CL');
                IF LeaveEarn.FINDFIRST THEN
                    REPEAT
                        LeaveEarn."Leave Code" := 'HL';
                        LeaveEarn.MODIFY;
                    UNTIL LeaveEarn.NEXT = 0;

            UNTIL Companies.NEXT = 0;

    end;

    local procedure UpdateLeaveAcc()
    var
        LeaveAcc: Record "33020370";
        Employee: Record "5200";
        LeaveRegister: Record "33020343";
    begin
        Employee.RESET;
        //Employee.SETFILTER("No.",'EMP69-00143');
        //Employee.SETFILTER(Status,'<>%1',Employee.Status::Left);
        //Employee.SETRANGE("No.",'EMP71-00032');
        IF Employee.FINDFIRST THEN
            REPEAT
                LeaveRegister.RESET;
                LeaveRegister.SETRANGE("Employee No.", Employee."No.");
                LeaveRegister.SETFILTER("Request Date", '>%1', 071618D);
                //LeaveRegister.SETFILTER("Leave Type Code",'HL');
                LeaveRegister.SETFILTER("Leave Type Code", 'SL');
                //LeaveRegister.SETFILTER("Fiscal Year",'<>%1','');
                IF LeaveRegister.FINDLAST THEN BEGIN
                    LeaveAcc.RESET;
                    LeaveAcc.SETRANGE("Employee Code", Employee."No.");
                    LeaveAcc.SETFILTER("Leave Type", LeaveRegister."Leave Type Code");
                    IF LeaveAcc.FINDFIRST THEN BEGIN
                        LeaveAcc."Balance Days" := LeaveRegister."Balance Days";
                        //IF LeaveRegister."Balance Days" <> 0 THEN
                        //ERROR('Employee No : %1, balance days : %2',Employee."No.",FORMAT(LeaveAcc."Balance Days"));
                        LeaveAcc.MODIFY;
                    END;
                END;
                LeaveRegister.RESET;
                LeaveRegister.SETRANGE("Employee No.", Employee."No.");
                LeaveRegister.SETFILTER("Request Date", '>%1', 071618D);
                LeaveRegister.SETFILTER("Leave Type Code", 'HL');
                //LeaveRegister.SETFILTER("Fiscal Year",'<>%1','');
                IF LeaveRegister.FINDLAST THEN BEGIN
                    LeaveAcc.RESET;
                    LeaveAcc.SETRANGE("Employee Code", Employee."No.");
                    LeaveAcc.SETFILTER("Leave Type", LeaveRegister."Leave Type Code");
                    IF LeaveAcc.FINDFIRST THEN BEGIN
                        LeaveAcc."Balance Days" := LeaveRegister."Balance Days";
                        //IF LeaveRegister."Balance Days" <> 0 THEN
                        //ERROR('Employee No : %1, balance days : %2',Employee."No.",FORMAT(LeaveAcc."Balance Days"));
                        LeaveAcc.MODIFY;
                    END;
                END;
                LeaveRegister.RESET;
                LeaveRegister.SETRANGE("Employee No.", Employee."No.");
                LeaveRegister.SETFILTER("Request Date", '>%1', 071618D);
                LeaveRegister.SETFILTER("Leave Type Code", 'SC');
                //LeaveRegister.SETFILTER("Fiscal Year",'<>%1','');
                IF LeaveRegister.FINDLAST THEN BEGIN
                    LeaveAcc.RESET;
                    LeaveAcc.SETRANGE("Employee Code", Employee."No.");
                    LeaveAcc.SETFILTER("Leave Type", LeaveRegister."Leave Type Code");
                    IF LeaveAcc.FINDFIRST THEN BEGIN
                        LeaveAcc."Balance Days" := LeaveRegister."Balance Days";
                        //ERROR(FORMAT(LeaveAcc."Balance Days"));
                        //IF LeaveRegister."Balance Days" <> 0 THEN
                        //ERROR('Employee No : %1, balance days : %2',Employee."No.",FORMAT(LeaveAcc."Balance Days"));
                        LeaveAcc.MODIFY;
                    END;
                END;
            UNTIL Employee.NEXT = 0;
    end;
}


codeunit 33020163 "Veh. Tran. - Check Document"
{

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure checkInsMemo(PrmInsMemoHdr: Record "33020165")
    var
        LclInsMemoHdr: Record "33020165";
        LclInsMemoLine: Record "33020166";
    begin
        //Checking Insurance Document before posting.
        LclInsMemoHdr.RESET;
        LclInsMemoHdr.SETRANGE("Vehicle Division", PrmInsMemoHdr."Vehicle Division");
        LclInsMemoHdr.SETRANGE("Reference No.", PrmInsMemoHdr."Reference No.");
        IF LclInsMemoHdr.FIND('-') THEN BEGIN
            LclInsMemoHdr.TESTFIELD("Ins. Company Code");
            LclInsMemoLine.RESET;
            LclInsMemoLine.SETRANGE("Reference No.", LclInsMemoHdr."Reference No.");
            IF LclInsMemoLine.FIND('-') THEN BEGIN
                REPEAT
                    LclInsMemoLine.CALCFIELDS("Chasis No.");
                    LclInsMemoLine.TESTFIELD("Chasis No.");
                    LclInsMemoLine.TESTFIELD("Engine No.");
                    LclInsMemoLine.TESTFIELD(Model);
                    LclInsMemoLine.TESTFIELD("Model Version");
                    LclInsMemoLine.TESTFIELD(Amount);
                UNTIL LclInsMemoLine.NEXT = 0;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure checkCCMemo(PrmCCMemoHdr: Record "33020163")
    var
        LclCCMemoHdr: Record "33020163";
        LclCCMemoLine: Record "33020164";
        lVechicle: Record "25006005";
    begin
        //Checking Custom Clearance Document before posting.
        LclCCMemoHdr.RESET;
        LclCCMemoHdr.SETRANGE("Vehicle Division", PrmCCMemoHdr."Vehicle Division");
        LclCCMemoHdr.SETRANGE("Reference No.", PrmCCMemoHdr."Reference No.");
        IF LclCCMemoHdr.FIND('-') THEN BEGIN
            LclCCMemoHdr.TESTFIELD("From Dept. Code");
            LclCCMemoHdr.TESTFIELD("To Dept. Code");
            LclCCMemoLine.RESET;
            LclCCMemoLine.SETRANGE("Reference No.", LclCCMemoHdr."Reference No.");
            IF LclCCMemoLine.FIND('-') THEN BEGIN
                REPEAT
                    LclCCMemoLine.CALCFIELDS("Chasis No.");
                    LclCCMemoLine.TESTFIELD("Chasis No.");
                    LclCCMemoLine.TESTFIELD("Engine No.");
                    //LclCCMemoLine.TESTFIELD("To Branch");   SM 30-06-2013 commented as inapplicable at Agni
                    LclCCMemoLine.TESTFIELD(Model);
                    LclCCMemoLine.TESTFIELD("Model Version");
                    LclCCMemoLine.TESTFIELD("C & F Date");
                    //Commented for Agni as no ins. memo no. is generated while custom clearance SM 26-06-2013
                    /*
                    LclCCMemoLine.CALCFIELDS("INS Memo No.");
                    LclCCMemoLine.TESTFIELD("INS Memo No.");
                    LclCCMemoLine.TESTFIELD("PP No.");
                    LclCCMemoLine.TESTFIELD("PP Date");
                    */
                    //Update  Vehicle PP No , PP Date & Namsari Date in the Vehicle master
                    lVechicle.GET(LclCCMemoLine."Vehicle Serial No.");// Vehicel must be exists on the Vehicle card
                    lVechicle."PP No." := LclCCMemoLine."PP No.";
                    //MESSAGE(LclCCMemoLine."PP No.",lVechicle."PP No.",LclCCMemoLine."Vehicle Serial No.");
                    lVechicle."PP Date" := LclCCMemoLine."PP Date";
                    lVechicle.MODIFY;
                UNTIL LclCCMemoLine.NEXT = 0;
            END;
        END;

    end;

    [Scope('Internal')]
    procedure checkInsMemoNoCC(PrmCCMemoNo: Code[20]): Boolean
    var
        LclCCMemo: Record "33020163";
        LclCCMemoLine: Record "33020164";
    begin
        //Checking Insurance Memo No. in CC Memo. If Ins. Memo no. is not found then system will not allow to print the document.
        LclCCMemoLine.RESET;
        LclCCMemoLine.SETRANGE("Reference No.", PrmCCMemoNo);
        IF LclCCMemoLine.FIND('-') THEN BEGIN
            LclCCMemoLine.CALCFIELDS("INS Memo No.");
            IF (LclCCMemoLine."INS Memo No." <> '') THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        END;
    end;

    [Scope('Internal')]
    procedure checkCCnPPNoTransLine(PrmTransHdr: Record "5740")
    var
        LclTransLine: Record "5741";
        Text33020163: Label 'Custom Clearance Memo and Pragyapan Patra No. cannot be blank on lines. Please provide the values and then post. \Or contact your system administrator for further assistance.';
    begin
        //Checking CC Memo No. and PP No. while transferring vehicle from Raxaul to BRJ or other warehouses.
        LclTransLine.RESET;
        LclTransLine.SETRANGE("Document No.", PrmTransHdr."No.");
        IF LclTransLine.FIND('-') THEN BEGIN
            REPEAT
                IF (LclTransLine."CC Memo No." = '') AND (LclTransLine."PP No." = '') THEN
                    ERROR(Text33020163);
            UNTIL LclTransLine.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure checkInsVehicle(PrmInsMemo: Record "33020165")
    var
        LclVehicle: Record "25006005";
        LclVehicleIns: Record "25006033";
        LclInsMemoLine: Record "33020166";
        Text33020164: Label 'Vehicle Insurance information for vehicle with Chassis No. - %1, doesnot exist. Please fill in Insurance details. \ Or contact your system administrator.';
        Text33020165: Label 'Please check the starting date of Insurance. It cannot be earlier then the memo date.';
    begin
        //Checking for Insurance entry in vehicle insurance table for that vehicle before posting Insurance Memo.
        LclInsMemoLine.RESET;
        LclInsMemoLine.SETRANGE("Reference No.", PrmInsMemo."Reference No.");
        IF LclInsMemoLine.FIND('-') THEN BEGIN
            REPEAT
                LclVehicle.RESET;
                LclVehicle.SETRANGE(VIN, LclInsMemoLine."Chasis No.");
                IF LclVehicle.FIND('-') THEN BEGIN
                    LclVehicleIns.RESET;
                    LclVehicleIns.SETRANGE("Vehicle Serial No.", LclVehicle."Serial No.");
                    IF LclVehicleIns.FIND('+') THEN BEGIN
                        IF (PrmInsMemo."Memo Date" > LclVehicleIns."Starting Date") THEN
                            ERROR(Text33020165);
                    END ELSE
                        ERROR(Text33020164, LclInsMemoLine."Chasis No.");
                END;
            UNTIL LclInsMemoLine.NEXT = 0;
        END;
    end;
}


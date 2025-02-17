codeunit 25006303 VehicleAccountingCycleMgt
{
    // 30.04.2014 Elva Baltic P8 #F058 MMG7.00
    //   * ADDED PERMISSIONS
    // 
    // 31.07.2007. EDMS P2
    //   * Added functions
    //       ChangeCycleInItemLedgerEntry
    //       ChangeCycleInGLEntry
    //       ChangeCycleInPIL
    //       ChangeCycleInPCL
    //       ChangeCycleInSIL
    //       ChangeCycleInSCL
    //       ChangeCycleInSSL
    //       ChangeCycleInPRL
    //       ChangeFunctionIsAllowed

    Permissions = TableData 17 = rimd,
                  TableData 32 = rimd;

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure GetNewCycleNo(): Code[20]
    var
        recInventorySetup: Record "313";
        codSerialNos: Code[20];
        cuNoSeriesMgt: Codeunit "396";
        codNewNo: Code[20];
    begin
        recInventorySetup.GET;
        IF recInventorySetup."Vehicle Acc. Cycle Nos." = '' THEN
            EXIT('');

        codSerialNos := recInventorySetup."Vehicle Acc. Cycle Nos.";
        cuNoSeriesMgt.InitSeries(codSerialNos, codSerialNos, WORKDATE, codNewNo, codSerialNos);
        EXIT(codNewNo);
    end;

    [Scope('Internal')]
    procedure CheckCycleRelation(codSerialNo: Code[20]; codCycleNo: Code[20])
    var
        recVehAccCycle: Record "25006024";
    begin
        IF codCycleNo = '' THEN
            EXIT;
        recVehAccCycle.RESET;
        recVehAccCycle.GET(codCycleNo);
        recVehAccCycle.TESTFIELD("Vehicle Serial No.", codSerialNo);
    end;

    [Scope('Internal')]
    procedure GetDefaultCycle(codSerialNo: Code[20]; codCycleNo: Code[20]): Code[20]
    var
        recVehAccCycle: Record "25006024";
    begin
        IF codCycleNo = '' THEN
            EXIT('');

        IF codSerialNo = '' THEN
            EXIT('');

        recVehAccCycle.RESET;
        recVehAccCycle.SETCURRENTKEY("Vehicle Serial No.");
        recVehAccCycle.SETRANGE("Vehicle Serial No.", codSerialNo);
        recVehAccCycle.SETRANGE(Default, TRUE);
        IF recVehAccCycle.FINDFIRST THEN
            EXIT(recVehAccCycle."No.")
        ELSE
            EXIT('');
    end;

    [Scope('Internal')]
    procedure CreateNewCycle_User(var VehAccCycle: Record "25006024")
    var
        VehAccCycle2: Record "25006024";
    begin
        IF VehAccCycle."Vehicle Serial No." = '' THEN
            EXIT;

        VehAccCycle2.INIT;
        VehAccCycle2."No." := GetNewCycleNo;
        VehAccCycle2."Vehicle Serial No." := VehAccCycle."Vehicle Serial No.";
        VehAccCycle2.INSERT;

        IF VehAccCycle."No." = '' THEN
            SetAsDefault(VehAccCycle2);

        IF VehAccCycle.GET(VehAccCycle2."No.") THEN;
    end;

    [Scope('Internal')]
    procedure SetAsDefault(VehAccCycle: Record "25006024")
    var
        VehAccCycle2: Record "25006024";
    begin
        VehAccCycle.TESTFIELD("No.");
        VehAccCycle.TESTFIELD("Vehicle Serial No.");
        VehAccCycle2.LOCKTABLE;
        VehAccCycle2.SETCURRENTKEY("Vehicle Serial No.");
        VehAccCycle2.SETRANGE("Vehicle Serial No.", VehAccCycle."Vehicle Serial No.");
        IF VehAccCycle2.FINDFIRST THEN
            REPEAT
                IF VehAccCycle2.Default THEN BEGIN
                    VehAccCycle2.Default := FALSE;
                    VehAccCycle2.MODIFY;
                END;
            UNTIL VehAccCycle2.NEXT = 0;

        VehAccCycle2.GET(VehAccCycle."No.");
        VehAccCycle2.Default := TRUE;
        VehAccCycle2.MODIFY;
    end;

    [Scope('Internal')]
    procedure ChangeCycleInItemLedgerEntry(SourceILE: Record "32")
    var
        ILE: Record "32";
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ChangeCycle: Page "25006459";
    begin
        ChangeFunctionIsAllowed;
        SourceILE.TESTFIELD("Entry No.");
        ILE.RESET;
        ILE.GET(SourceILE."Entry No.");

        CLEAR(ChangeCycle);

        ChangeCycle.SetData(FORMAT(DATABASE::"Item Ledger Entry"),
          FORMAT(ILE."Entry No."),
          '',
           '',
          SourceILE."Serial No.",
          SourceILE."Vehicle Accounting Cycle No.");

        ChangeCycle.LOOKUPMODE(TRUE);
        IF ChangeCycle.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ChangeCycle.GetData(SerialNo, CurrCycle, NewCycle);
            IF CurrCycle <> NewCycle THEN BEGIN
                ILE.VALIDATE("Vehicle Accounting Cycle No.", NewCycle);
                ILE.MODIFY;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ChangeCycleInGLEntry(SourceGLE: Record "17")
    var
        GLE: Record "17";
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ChangeCycle: Page "25006459";
    begin
        ChangeFunctionIsAllowed;
        SourceGLE.TESTFIELD("Entry No.");
        GLE.RESET;
        GLE.GET(SourceGLE."Entry No.");

        CLEAR(ChangeCycle);

        ChangeCycle.SetData(FORMAT(DATABASE::"G/L Entry"),
         FORMAT(GLE."Entry No."),
         '',
         '',
         SourceGLE."Vehicle Serial No.",
         SourceGLE."Vehicle Accounting Cycle No.");

        ChangeCycle.LOOKUPMODE(TRUE);
        IF ChangeCycle.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ChangeCycle.GetData(SerialNo, CurrCycle, NewCycle);
            IF CurrCycle <> NewCycle THEN BEGIN
                GLE.VALIDATE("Vehicle Accounting Cycle No.", NewCycle);
                GLE.MODIFY;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ChangeCycleInPIL(SourcePIL: Record "123")
    var
        PIL: Record "123";
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ChangeCycle: Page "25006459";
    begin
        ChangeFunctionIsAllowed;
        SourcePIL.TESTFIELD("Document No.");
        SourcePIL.TESTFIELD("Line No.");
        PIL.RESET;
        PIL.GET(SourcePIL."Document No.", SourcePIL."Line No.");

        CLEAR(ChangeCycle);

        ChangeCycle.SetData(FORMAT(DATABASE::"Purch. Inv. Line"),
         FORMAT(PIL."Document No."),
         FORMAT(PIL."Line No."),
         '',
         SourcePIL."Vehicle Serial No.",
         SourcePIL."Vehicle Accounting Cycle No.");

        ChangeCycle.LOOKUPMODE(TRUE);
        IF ChangeCycle.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ChangeCycle.GetData(SerialNo, CurrCycle, NewCycle);
            IF CurrCycle <> NewCycle THEN BEGIN
                PIL.VALIDATE("Vehicle Accounting Cycle No.", NewCycle);
                PIL.MODIFY;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ChangeCycleInPCL(SourcePCL: Record "125")
    var
        PCL: Record "125";
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ChangeCycle: Page "25006459";
    begin
        ChangeFunctionIsAllowed;
        SourcePCL.TESTFIELD("Document No.");
        SourcePCL.TESTFIELD("Line No.");
        PCL.RESET;
        PCL.GET(SourcePCL."Document No.", SourcePCL."Line No.");

        CLEAR(ChangeCycle);

        ChangeCycle.SetData(FORMAT(DATABASE::"Purch. Cr. Memo Line"),
         FORMAT(PCL."Document No."),
         FORMAT(PCL."Line No."),
         '',
         SourcePCL."Vehicle Serial No.",
         SourcePCL."Vehicle Accounting Cycle No.");

        ChangeCycle.LOOKUPMODE(TRUE);
        IF ChangeCycle.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ChangeCycle.GetData(SerialNo, CurrCycle, NewCycle);
            IF CurrCycle <> NewCycle THEN BEGIN
                PCL.VALIDATE("Vehicle Accounting Cycle No.", NewCycle);
                PCL.MODIFY;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ChangeCycleInSIL(SourceSIL: Record "113")
    var
        SIL: Record "113";
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ChangeCycle: Page "25006459";
    begin
        ChangeFunctionIsAllowed;
        SourceSIL.TESTFIELD("Document No.");
        SourceSIL.TESTFIELD("Line No.");
        SIL.RESET;
        SIL.GET(SourceSIL."Document No.", SourceSIL."Line No.");

        CLEAR(ChangeCycle);

        ChangeCycle.SetData(FORMAT(DATABASE::"Sales Invoice Line"),
         FORMAT(SIL."Document No."),
         FORMAT(SIL."Line No."),
         '',
         SourceSIL."Vehicle Serial No.",
         SourceSIL."Vehicle Accounting Cycle No.");

        ChangeCycle.LOOKUPMODE(TRUE);
        IF ChangeCycle.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ChangeCycle.GetData(SerialNo, CurrCycle, NewCycle);
            IF CurrCycle <> NewCycle THEN BEGIN
                SIL.VALIDATE("Vehicle Accounting Cycle No.", NewCycle);
                SIL.MODIFY;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ChangeCycleInSCL(SourceSCL: Record "115")
    var
        SCL: Record "115";
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ChangeCycle: Page "25006459";
    begin
        ChangeFunctionIsAllowed;
        SourceSCL.TESTFIELD("Document No.");
        SourceSCL.TESTFIELD("Line No.");
        SCL.RESET;
        SCL.GET(SourceSCL."Document No.", SourceSCL."Line No.");

        CLEAR(ChangeCycle);

        ChangeCycle.SetData(FORMAT(DATABASE::"Sales Cr.Memo Line"),
         FORMAT(SCL."Document No."),
         FORMAT(SCL."Line No."),
         '',
         SourceSCL."Vehicle Serial No.",
         SourceSCL."Vehicle Accounting Cycle No.");

        ChangeCycle.LOOKUPMODE(TRUE);
        IF ChangeCycle.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ChangeCycle.GetData(SerialNo, CurrCycle, NewCycle);
            IF CurrCycle <> NewCycle THEN BEGIN
                SCL.VALIDATE("Vehicle Accounting Cycle No.", NewCycle);
                SCL.MODIFY;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ChangeCycleInSSL(SourceSSL: Record "111")
    var
        SSL: Record "111";
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ChangeCycle: Page "25006459";
    begin
        ChangeFunctionIsAllowed;
        SourceSSL.TESTFIELD("Document No.");
        SourceSSL.TESTFIELD("Line No.");
        SSL.RESET;
        SSL.GET(SourceSSL."Document No.", SourceSSL."Line No.");

        CLEAR(ChangeCycle);

        ChangeCycle.SetData(FORMAT(DATABASE::"Sales Shipment Line"),
         FORMAT(SSL."Document No."),
         FORMAT(SSL."Line No."),
         '',
         SourceSSL."Vehicle Serial No.",
         SourceSSL."Vehicle Accounting Cycle No.");

        ChangeCycle.LOOKUPMODE(TRUE);
        IF ChangeCycle.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ChangeCycle.GetData(SerialNo, CurrCycle, NewCycle);
            IF CurrCycle <> NewCycle THEN BEGIN
                SSL.VALIDATE("Vehicle Accounting Cycle No.", NewCycle);
                SSL.MODIFY;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ChangeCycleInPRL(SourcePRL: Record "121")
    var
        PRL: Record "121";
        SerialNo: Code[20];
        CurrCycle: Code[20];
        NewCycle: Code[20];
        ChangeCycle: Page "25006459";
    begin
        ChangeFunctionIsAllowed;
        SourcePRL.TESTFIELD("Document No.");
        SourcePRL.TESTFIELD("Line No.");
        PRL.RESET;
        PRL.GET(SourcePRL."Document No.", SourcePRL."Line No.");

        CLEAR(ChangeCycle);

        ChangeCycle.SetData(FORMAT(DATABASE::"Purch. Rcpt. Line"),
         FORMAT(PRL."Document No."),
         FORMAT(PRL."Line No."),
         '',
         SourcePRL."Vehicle Serial No.",
         SourcePRL."Vehicle Accounting Cycle No.");

        ChangeCycle.LOOKUPMODE(TRUE);
        IF ChangeCycle.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ChangeCycle.GetData(SerialNo, CurrCycle, NewCycle);
            IF CurrCycle <> NewCycle THEN BEGIN
                PRL.VALIDATE("Vehicle Accounting Cycle No.", NewCycle);
                PRL.MODIFY;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ChangeFunctionIsAllowed()
    var
        UserSetup: Record "91";
        Text001: Label 'You non''t have permission to run this function';
    begin
        UserSetup.RESET;
        UserSetup.GET(USERID);
        IF NOT UserSetup."Veh. Acc. Cycle Change Funct." THEN
            ERROR(Text001);
    end;
}


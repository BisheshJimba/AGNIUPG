codeunit 25006107 "Serv. Jnl.-Post Line"
{
    // 28.05.2015 EB.P30 #T030
    //   Modified procedure:
    //     FillDetServLE
    // 
    // 12.05.2015 EB.P30 #T030
    //   Modified procedure:
    //     FillDetServLE
    // 
    // 02.04.2013 EDMS P8
    //   * Fix for AdjustServPlanStageRuns
    // 
    // 27.02.2013 EDMS P8
    //   * Implement new dimension set
    // 
    // 2012.09.15 EDMS P8
    //   * Add support for fields: "Minutes Per UoM", "Quantity (Hours)"
    // 
    // 2012.07.31 EDMS P8
    //   * use of new fields: 'Variable Field Run 2', 'Variable Field Run 3', 'Document Line No.'
    //   * new function AdjustServPlanStageRuns
    // 
    // 2012.04.17 EDMS P8
    //   * Implemet use of "Det. Serv. Ledger Entry EDMS" table
    // 
    // 2012.03.07 EDMS P8
    //   * Implement Tire Management
    // 
    // 05.03.2008. EDMS P2
    //   * Added code Code

    Permissions = TableData 25006167 = imd,
                  TableData 5934 = imd;
    TableNo = 25006165;

    trigger OnRun()
    begin
        GetGLSetup;

        RunWithCheck(Rec);
    end;

    var
        GLSetup: Record "98";
        ServJnlLine: Record "25006165";
        ServLedgEntry: Record "25006167";
        Veh: Record "25006005";
        ServReg: Record "25006168";
        GenPostingSetup: Record "252";
        ServJnlCheckLine: Codeunit "25006106";
        NextEntryNo: Integer;
        GLSetupRead: Boolean;
        Text001: Label 'Would you like to recalculate expected dates in plan?';

    [Scope('Internal')]
    procedure GetServReg(var NewServReg: Record "25006168")
    begin
        NewServReg := ServReg;
    end;

    [Scope('Internal')]
    procedure RunWithCheck(var ServJnlLine2: Record "25006165")
    begin
        ServJnlLine.COPY(ServJnlLine2);

        Code;
        ServJnlLine2 := ServJnlLine;
    end;

    local procedure "Code"()
    var
        ServiceLabor: Record "25006121";
        VehicleServicePlan: Record "25006126";
        ServicePlanDocumentLink: Record "25006157";
        ServicePlanManagement: Codeunit "25006103";
        VehicleServicePlanStageTmp: Record "25006132" temporary;
    begin
        IF EmptyLine AND (ServJnlLine."Entry Type" <> ServJnlLine."Entry Type"::Info) THEN
            EXIT;

        //30.10.2012 EDMS >>
        ServJnlCheckLine.RunCheck(ServJnlLine);
        //30.10.2012 EDMS <<
        IF NextEntryNo = 0 THEN BEGIN
            ServLedgEntry.LOCKTABLE;
            IF ServLedgEntry.FINDLAST THEN
                NextEntryNo := ServLedgEntry."Entry No.";
            NextEntryNo := NextEntryNo + 1;
        END;

        IF "Document Date" = 0D THEN
            "Document Date" := ServJnlLine."Posting Date";

        InsertServReg(NextEntryNo);

        Veh.GET(ServJnlLine."Vehicle Serial No.");
        Veh.TESTFIELD(Blocked, FALSE);

        IF (GenPostingSetup."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group") OR
           (GenPostingSetup."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group")
        THEN
            GenPostingSetup.GET("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");


        ServLedgEntry.INIT;
        ServLedgEntry."Entry Type" := ServJnlLine."Entry Type";
        ServLedgEntry."Document Type" := ServJnlLine."Document Type";
        ServLedgEntry."Document No." := ServJnlLine."Document No.";
        ServLedgEntry."Pre-Assigned No." := ServJnlLine."Pre-Assigned No.";
        ServLedgEntry."External Document No." := "External Document No.";
        ServLedgEntry."Posting Date" := ServJnlLine."Posting Date";
        ServLedgEntry."Document Date" := "Document Date";
        ServLedgEntry."Vehicle Serial No." := ServJnlLine."Vehicle Serial No.";
        ServLedgEntry."Make Code" := ServJnlLine."Make Code";
        ServLedgEntry."Model Code" := ServJnlLine."Model Code";
        ServLedgEntry."Model Version No." := "Model Version No.";
        ServLedgEntry."Vehicle Accounting Cycle No." := ServJnlLine."Vehicle Accounting Cycle No.";
        ServLedgEntry.Description := Description;
        ServLedgEntry."Customer No." := "Customer No.";
        ServLedgEntry."Bill-to Customer No." := "Bill-to Customer No.";
        //24.02.2012 Sipradi-YS BEGIN
        ServLedgEntry."Job Type" := "Job Type";
        ServLedgEntry."Is Booked" := "Is Booked";
        ServLedgEntry."Responsibility Center" := "Responsibility Center";
        ServLedgEntry."Accountability Center" := "Accountability Center";
        //24.02.2012 Sipradi-YS END

        //**SM 14-08-2013 for service reminder
        ServLedgEntry."Next Service Date" := "Next Service Date";
        //**SM 14-08-2013 for service reminder

        //Agile CPJB 24/05/2016
        ServLedgEntry."Job Category" := "Job Category";
        ServLedgEntry."Service Type" := "Service Type";
        ServLedgEntry."Job Type (Service Header)" := "Job Type (Service Header)";
        //Agile CPJB 24/05/2016

        //SS1.00
        ServLedgEntry."Scheme Code" := "Scheme Code";
        ServLedgEntry."Membership No." := "Membership No.";
        //SS1.00

        ServLedgEntry."Delay Reason Code" := "Delay Reason Code"; //PSF
        ServLedgEntry."RV RR Code" := "RV RR Code";
        ServLedgEntry."Quality Control" := "Quality Control";
        ServLedgEntry."Floor Control" := "Floor Control";
        ServLedgEntry."Revisit Repair Reason" := "Revisit Repair Reason";
        ServLedgEntry."Resources PSF" := "Resources PSF";

        ServLedgEntry."Job No." := "Job No.";
        ServLedgEntry."Unit of Measure Code" := "Unit of Measure Code";
        ServLedgEntry.Quantity := Quantity;
        ServLedgEntry."Minutes Per UoM" := "Minutes Per UoM";
        ServLedgEntry."Quantity (Hours)" := "Quantity (Hours)";

        ServLedgEntry."Unit Cost" := "Unit Cost";
        ServLedgEntry."Total Cost" := "Total Cost";
        ServLedgEntry."Unit Price" := "Unit Price";
        ServLedgEntry.Amount := Amount;
        ServLedgEntry."Amount Including VAT" := "Amount Including VAT";
        ServLedgEntry."Amount (LCY)" := "Amount (LCY)";
        ServLedgEntry."Amount Including VAT (LCY)" := "Amount Including VAT (LCY)";
        ServLedgEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
        ServLedgEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
        ServLedgEntry."Dimension Set ID" := "Dimension Set ID";
        ServLedgEntry."Source Code" := "Source Code";
        ServLedgEntry."Warranty Claim No." := "Warranty Claim No.";
        ServLedgEntry.Chargeable := Chargeable;
        ServLedgEntry."Journal Batch Name" := ServJnlLine."Journal Batch Name";
        ServLedgEntry."Reason Code" := "Reason Code";
        ServLedgEntry."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
        ServLedgEntry."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
        ServLedgEntry."No. Series" := "Posting No. Series";
        ServLedgEntry.Type := Type;
        ServLedgEntry."No." := "No.";
        ServLedgEntry."Customer No." := "Customer No.";
        ServLedgEntry."Bill-to Customer No." := "Bill-to Customer No.";
        ServLedgEntry."Currency Code" := "Currency Code";
        ServLedgEntry."Location Code" := "Location Code";
        ServLedgEntry."Discount %" := "Discount %";
        ServLedgEntry."Line Discount Amount" := "Line Discount Amount";
        ServLedgEntry."Inv. Discount Amount" := "Inv. Discount Amount";
        ServLedgEntry."Line Discount Amount (LCY)" := "Line Discount Amount (LCY)";
        ServLedgEntry."Inv. Discount Amount (LCY)" := "Inv. Discount Amount (LCY)";
        ServLedgEntry."Service Receiver" := "Service Receiver";
        ServLedgEntry."Service Order Type" := "Service Order Type";
        ServLedgEntry."Service Order No." := "Service Order No.";
        ServLedgEntry."Cust. Ledger Entry No." := "Cust. Ledger Entry No.";
        ServLedgEntry."Payment Method Code" := "Payment Method Code";

        // 2012.07.31 EDMS P8 >>
        ServLedgEntry."Document Line No." := "Document Line No.";
        ServLedgEntry."Plan No." := "Plan No.";
        ServLedgEntry."Plan Stage Recurrence" := "Plan Stage Recurrence";
        ServLedgEntry."Plan Stage Code" := "Plan Stage Code";
        // 2012.07.31 EDMS P8 <<

        //05.03.2008. EDMS P2 >>
        ServLedgEntry."Package No." := "Package No.";
        ServLedgEntry."Package Version No." := "Package Version No.";
        ServLedgEntry."Package Version Spec. Line No." := "Package Version Spec. Line No.";
        //05.03.2008. EDMS P2 <<

        ServLedgEntry."Service Address Code" := "Service Address Code";
        ServLedgEntry."Service Address" := "Service Address";

        ServLedgEntry."Deal Type Code" := "Deal Type Code";

        FillServLedgerVariableFields(ServLedgEntry, ServJnlLine);
        ServLedgEntry.Kilometrage := Kilometrage;

        Veh.CALCFIELDS("Parent Component");
        ServLedgEntry."Parent Vehicle Serial No." := Veh."Parent Component";

        ServLedgEntry."Standard Time" := "Standard Time";
        ServLedgEntry."Campaign No." := "Campaign No.";
        IF Type = Type::Labor THEN BEGIN
            IF ServiceLabor.GET("No.") THEN BEGIN
                ServLedgEntry."Labor Group Code" := ServiceLabor."Group Code";
                ServLedgEntry."Labor Subgroup Code" := ServiceLabor."Subgroup Code";
            END;
        END;

        GetGLSetup;

        "Total Cost" := ROUND("Total Cost");
        Amount := ROUND(Amount);
        IF ServLedgEntry."Entry Type" = ServLedgEntry."Entry Type"::Sale THEN BEGIN
            Chargeable := TRUE;
            Quantity := -Quantity;
            "Total Cost" := -"Total Cost";
            Amount := -Amount;
        END;

        IF Description = Veh."Model Commercial Name" THEN
            Description := '';
        "User ID" := USERID;
        ServLedgEntry."Entry No." := NextEntryNo;

        ServLedgEntry.INSERT;

        IF (ServLedgEntry."Document Type" IN [ServLedgEntry."Document Type"::Order,
            ServLedgEntry."Document Type"::"Return Order"]) THEN BEGIN

            ServicePlanDocumentLink.RESET;
            ServicePlanDocumentLink.SETCURRENTKEY("Document Type", "Document No.");
            CASE ServLedgEntry."Document Type" OF
                ServLedgEntry."Document Type"::Order:
                    ServicePlanDocumentLink.SETRANGE("Document Type", ServicePlanDocumentLink."Document Type"::"Posted Order");
                ServLedgEntry."Document Type"::"Return Order":
                    ServicePlanDocumentLink.SETRANGE("Document Type", ServicePlanDocumentLink."Document Type"::"Posted Return Order");
            END;
            ServicePlanDocumentLink.SETRANGE("Document No.", ServLedgEntry."Document No.");
            VehicleServicePlanStageTmp.INIT;
            IF ServicePlanDocumentLink.FINDFIRST THEN
                REPEAT
                    VehicleServicePlan.GET(ServJnlLine."Vehicle Serial No.", ServicePlanDocumentLink."Serv. Plan No.");
                    ServicePlanManagement.PostServPlanStage(ServJnlLine."Vehicle Serial No.", ServicePlanDocumentLink."Serv. Plan No.",
                      ServicePlanDocumentLink."Plan Stage Recurrence", ServicePlanDocumentLink."Serv. Plan Stage Code", ServLedgEntry);

                    ServicePlanManagement.PlanRecurringByTemplate(VehicleServicePlan, 0);

                    IF NOT ((VehicleServicePlanStageTmp."Vehicle Serial No." = ServJnlLine."Vehicle Serial No.") AND
                        (VehicleServicePlanStageTmp."Plan No." = ServicePlanDocumentLink."Serv. Plan No.") AND
                        (VehicleServicePlanStageTmp.Recurrence = ServicePlanDocumentLink."Plan Stage Recurrence") AND
                        (VehicleServicePlanStageTmp.Code = ServicePlanDocumentLink."Serv. Plan Stage Code")) THEN BEGIN
                        AdjustServPlanStageRuns(ServJnlLine."Vehicle Serial No.", ServicePlanDocumentLink."Serv. Plan No.",
                          ServicePlanDocumentLink."Plan Stage Recurrence", ServicePlanDocumentLink."Serv. Plan Stage Code",
                          ServLedgEntry.Kilometrage, ServLedgEntry."Variable Field Run 2",
                          ServLedgEntry."Variable Field Run 3", FALSE, FALSE);

                        ServicePlanManagement.CalcExpectedServiceDate(ServJnlLine."Vehicle Serial No.", ServicePlanDocumentLink."Serv. Plan No.", 1);
                        VehicleServicePlanStageTmp."Vehicle Serial No." := ServJnlLine."Vehicle Serial No.";
                        VehicleServicePlanStageTmp."Plan No." := ServicePlanDocumentLink."Serv. Plan No.";
                        VehicleServicePlanStageTmp.Recurrence := ServicePlanDocumentLink."Plan Stage Recurrence";
                        VehicleServicePlanStageTmp.Code := ServicePlanDocumentLink."Serv. Plan Stage Code";
                    END;
                UNTIL ServicePlanDocumentLink.NEXT = 0;
        END;  //02.04.2013 EDMS P8

        //2012.06.12 EDMS P8 >>
        FillDetServLE(ServLedgEntry, ServJnlLine);
        //2012.06.12 EDMS P8 <<


        // 29.09.2011 EDMS P8 >>
        InsertTireEntryAdv(ServJnlLine);
        // 29.09.2011 EDMS P8 <<

        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
            GLSetup.GET;
        GLSetupRead := TRUE;
    end;

    [Scope('Internal')]
    procedure UpdateCustLedgNo(CustEntryNo: Integer; DocType: Integer; DocNo: Code[20]; PostDate: Date)
    begin
        ServLedgEntry.SETCURRENTKEY("Document Type", "Document No.", "Posting Date");
        ServLedgEntry.SETRANGE("Document Type", DocType);
        ServLedgEntry.SETRANGE("Document No.", DocNo);
        ServLedgEntry.SETRANGE("Posting Date", PostDate);
        ServLedgEntry.MODIFYALL("Cust. Ledger Entry No.", CustEntryNo);
        ServLedgEntry.RESET
    end;

    [Scope('Internal')]
    procedure FillServLedgerVariableFields(var ServLedgerEntry: Record "25006167"; ServJournalLine: Record "25006165")
    var
        VariableFieldUsage: Record "25006006";
        VariableFieldUsage2: Record "25006006";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        RecordRef.OPEN(DATABASE::"Serv. Journal Line");
        RecordRef.GETTABLE(ServJournalLine);
        RecordRef2.OPEN(DATABASE::"Service Ledger Entry EDMS");
        RecordRef2.GETTABLE(ServLedgerEntry);

        VariableFieldUsage.RESET;
        VariableFieldUsage.SETRANGE("Table No.", DATABASE::"Serv. Journal Line");
        IF VariableFieldUsage.FINDFIRST THEN
            REPEAT
                VariableFieldUsage2.RESET;
                VariableFieldUsage2.SETRANGE("Table No.", DATABASE::"Service Ledger Entry EDMS");
                VariableFieldUsage2.SETRANGE("Variable Field Code", VariableFieldUsage."Variable Field Code");
                IF VariableFieldUsage2.FINDFIRST THEN BEGIN
                    FieldRef := RecordRef.FIELD(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.FIELD(VariableFieldUsage2."Field No.");
                    FieldRef2.VALUE(FieldRef.VALUE);
                END;
            UNTIL VariableFieldUsage.NEXT = 0;
        RecordRef2.SETTABLE(ServLedgerEntry);
    end;

    local procedure InsertServReg(LedgEntryNo: Integer)
    begin
        IF NOT (ServReg.FINDLAST AND (ServReg."To Entry No." = 0)) THEN BEGIN
            //  IF ServReg."No." = 0 THEN BEGIN
            ServReg.LOCKTABLE;
            IF ServReg.FINDLAST THEN
                ServReg."No." := ServReg."No." + 1
            ELSE
                ServReg."No." := 1;

            ServReg.INIT;
            ServReg."No." := ServReg."No.";
            ServReg."From Entry No." := LedgEntryNo;
            ServReg."To Entry No." := LedgEntryNo;
            ServReg."Creation Date" := TODAY;
            ServReg."Creation Time" := TIME;
            ServReg."Source Code" := "Source Code";
            ServReg."Journal Batch Name" := ServJnlLine."Journal Batch Name";
            ServReg."User ID" := USERID;
            ServReg.INSERT;
        END ELSE BEGIN
            IF ((LedgEntryNo < ServReg."From Entry No.") AND (LedgEntryNo <> 0)) OR
               ((ServReg."From Entry No." = 0) AND (LedgEntryNo > 0))
            THEN
                ServReg."From Entry No." := LedgEntryNo;
            IF LedgEntryNo > ServReg."To Entry No." THEN
                ServReg."To Entry No." := LedgEntryNo;

            ServReg.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure InsertTireEntry(ServJournalLine: Record "25006165")
    var
        TireEntry: Record "25006181";
        TireEntry2: Record "25006181";
        TextPlaceBusy: Label 'That Tire placement is already used.';
        TextTireBusy: Label 'That Tire is already used.';
        TireManagement: Codeunit "25006125";
        EntryNo: Integer;
        TireManagementSetup: Record "25006182";
        VehicleTirePosition: Record "25006179";
        TextFillFields: Label 'For %1 to be posted in %2 must be filled all fields: %3';
        TireKilometers: Decimal;
    begin
        //2012.03.07 EDMS P8 >>
        IF (ServJournalLine."Tire Code" = '') AND (ServJournalLine."Vehicle Axle Code" = '') AND
            (ServJournalLine."Tire Position Code" = '') THEN
            EXIT; // this is case then SERVICE ORDER post is going - after order is going to be posted invoice

        IF (ServJournalLine."Tire Code" = '') OR (ServJournalLine."Vehicle Axle Code" = '') OR
            (ServJournalLine."Tire Position Code" = '') THEN
            ERROR(TextFillFields, TireEntry.TABLECAPTION, ServJournalLine.TABLECAPTION,
              ServJournalLine.FIELDCAPTION("Vehicle Axle Code") + ',' + ServJournalLine.FIELDCAPTION("Tire Position Code") + ',' +
              ServJournalLine.FIELDCAPTION("Tire Code"));

        TireEntry.INIT;
        TireEntry."Service Ledger Entry No." := ServLedgEntry."Entry No.";
        TireEntry."Document No." := ServLedgEntry."Document No.";
        TireEntry."Posting Date" := ServLedgEntry."Posting Date";
        TireEntry."Vehicle Serial No." := ServJournalLine."Vehicle Serial No.";
        TireEntry."Vehicle Axle Code" := ServJournalLine."Vehicle Axle Code";
        TireEntry."Tire Position Code" := ServJournalLine."Tire Position Code";
        TireEntry."Tire Code" := ServJournalLine."Tire Code";
        TireEntry."Entry Type" := ServJournalLine."Tire Operation Type" - 1;
        TireEntry."Variable Field Run 1" := ServJournalLine.Kilometrage;

        TireEntry.TESTFIELD("Vehicle Serial No.");
        TireEntry.TESTFIELD("Vehicle Axle Code");
        TireEntry.TESTFIELD("Tire Code");
        IF ServJournalLine."Tire Operation Type" = ServJournalLine."Tire Operation Type"::"Put on" THEN BEGIN
            VehicleTirePosition.GET(TireEntry."Vehicle Serial No.", TireEntry."Vehicle Axle Code", TireEntry."Tire Position Code");
            VehicleTirePosition.CALCFIELDS(Available);
            IF NOT VehicleTirePosition.Available THEN
                ERROR(TextPlaceBusy);
        END;
        TireManagementSetup.GET;
        IF TireManagementSetup."Check Tire Unique" THEN
            IF TireEntry."Entry Type" = TireEntry."Entry Type"::"Put on" THEN
                IF (TireEntry."Tire Code" <> '') THEN BEGIN
                    TireEntry2.RESET;
                    TireEntry2.SETRANGE("Tire Code", TireEntry."Tire Code");
                    TireEntry2.SETRANGE(Open, TRUE);
                    TireEntry2.SETFILTER("Entry No.", '<>%1', TireEntry."Entry No.");
                    IF TireEntry2.FINDFIRST THEN
                        ERROR(TextTireBusy);
                END;
        IF TireEntry."Posting Date" = 0D THEN
            TireEntry."Posting Date" := WORKDATE;
        IF TireEntry."Entry Type" = TireEntry."Entry Type"::"Take off" THEN
            TireEntry.Open := FALSE
        ELSE
            TireEntry.Open := TRUE;
        IF TireEntry."Entry Type" <> TireEntry."Entry Type"::"Put on" THEN BEGIN
            // THen it supposed to be Tire take off and lets find last puton of that Tire on the possition
            TireEntry2.RESET;
            TireEntry2.SETRANGE("Vehicle Serial No.", TireEntry."Vehicle Serial No.");
            TireEntry2.SETRANGE("Vehicle Axle Code", TireEntry."Vehicle Axle Code");
            TireEntry2.SETRANGE("Tire Position Code", TireEntry."Tire Position Code");
            TireEntry2.SETRANGE("Tire Code", TireEntry."Tire Code");
            TireEntry2.SETRANGE("Entry Type", TireEntry."Entry Type"::"Put on");
            IF TireEntry2.FINDLAST THEN BEGIN
                TireEntry."Tire Kilometers" := TireEntry."Variable Field Run 1" - TireEntry2."Variable Field Run 1";
                TireKilometers := TireEntry."Tire Kilometers";
            END;
        END;

        TireManagement.CloseOpenedEntries(TireEntry);
        TireEntry.LOCKTABLE;
        TireEntry."Entry No." := TireManagement.GetNextTireEntryPrimaryNo;
        TireEntry.INSERT(TRUE);
        EntryNo := TireEntry."Entry No.";

        // adjust "Service Register EDMS"
        IF ServReg."From Tire Entry No." = 0 THEN
            ServReg."From Tire Entry No." := EntryNo;
        ServReg."To Tire Entry No." := EntryNo;
        ServReg.MODIFY;

        //2012.03.07 EDMS P8 <<
    end;

    [Scope('Internal')]
    procedure InsertTireEntryAdv(ServJournalLine: Record "25006165")
    var
        TextPlaceBusy: Label 'That Tire placement is already used.';
        TextTireBusy: Label 'That Tire is already used.';
        TextFillFields: Label 'For %1 to be posted in %2 must be filled all fields: %3';
        TireManagement: Codeunit "25006125";
        TireManagementSetup: Record "25006182";
        VehicleAxleCode: Code[20];
        TirePositionCode: Code[20];
        TireCode: Code[20];
        VehicleAxleCode2: Code[20];
        TirePositionCode2: Code[20];
        TireCode2: Code[20];
    begin
        //2012.03.07 EDMS P8 >>
        IF ServJournalLine."Tire Operation Type" = ServJournalLine."Tire Operation Type"::"Position Change" THEN BEGIN
            ServJournalLine.TESTFIELD("Vehicle Serial No.");
            ServJournalLine.TESTFIELD("Vehicle Axle Code");
            ServJournalLine.TESTFIELD("Tire Position Code");
            ServJournalLine.TESTFIELD("New Vehicle Axle Code");
            ServJournalLine.TESTFIELD("New Tire Position Code");

            VehicleAxleCode := "Vehicle Axle Code";
            TirePositionCode := "Tire Position Code";
            TireCode := TireManagement.GetTireOfPosition(ServJournalLine."Vehicle Serial No.", "Vehicle Axle Code", "Tire Position Code");
            IF TireCode = '' THEN
                TireCode := "Tire Code";
            VehicleAxleCode2 := "New Vehicle Axle Code";
            TirePositionCode2 := "New Tire Position Code";
            TireManagementSetup.GET;
            IF TireManagementSetup."Check Tire Unique" THEN BEGIN
                TireCode2 := TireManagement.GetTireOfPosition(ServJournalLine."Vehicle Serial No.", "New Vehicle Axle Code", "New Tire Position Code");
            END ELSE BEGIN
                TireCode2 := TireCode;
            END;

            "Tire Operation Type" := "Tire Operation Type"::"Take off";
            "Tire Code" := TireCode;
            InsertTireEntry(ServJournalLine);

            "Tire Operation Type" := "Tire Operation Type"::"Take off";
            "Vehicle Axle Code" := VehicleAxleCode2;
            "Tire Position Code" := TirePositionCode2;
            "Tire Code" := TireCode2;
            InsertTireEntry(ServJournalLine);

            "Tire Operation Type" := "Tire Operation Type"::"Put on";
            "Vehicle Axle Code" := VehicleAxleCode;
            "Tire Position Code" := TirePositionCode;
            "Tire Code" := TireCode2;
            InsertTireEntry(ServJournalLine);

            "Tire Operation Type" := "Tire Operation Type"::"Put on";
            "Vehicle Axle Code" := VehicleAxleCode2;
            "Tire Position Code" := TirePositionCode2;
            "Tire Code" := TireCode;
            InsertTireEntry(ServJournalLine);
        END ELSE
            InsertTireEntry(ServJournalLine);

        //2012.03.07 EDMS P8 <<
    end;

    [Scope('Internal')]
    procedure FillDetServLE(ServLedgerEntry: Record "25006167"; ServJournalLine: Record "25006165")
    var
        DetServJournalLine: Record "25006187";
        DetServLedgerEntryEDMS: Record "25006188";
        EntryNo: Integer;
    begin
        //IF ServLedgerEntry."Entry Type" <> ServLedgerEntry."Entry Type"::Usage THEN
        //EXIT;
        DetServJournalLine.RESET;
        DetServJournalLine.SETRANGE("Journal Template Name", ServJournalLine."Journal Template Name");
        DetServJournalLine.SETRANGE("Journal Batch Name", ServJournalLine."Journal Batch Name");
        DetServJournalLine.SETRANGE("Journal Line No.", ServJournalLine."Line No.");
        DetServLedgerEntryEDMS.RESET;
        EntryNo := 0;
        IF DetServLedgerEntryEDMS.FINDLAST THEN
            EntryNo := DetServLedgerEntryEDMS."Entry No.";
        IF DetServJournalLine.FINDFIRST THEN
            REPEAT
                DetServLedgerEntryEDMS.INIT;
                EntryNo += 1;
                DetServLedgerEntryEDMS."Entry No." := EntryNo;
                DetServLedgerEntryEDMS."Service Ledger Entry No." := ServLedgerEntry."Entry No.";
                ;
                DetServLedgerEntryEDMS."Document Type" := ServLedgerEntry."Document Type";
                DetServLedgerEntryEDMS."Document No." := ServLedgerEntry."Document No.";
                DetServLedgerEntryEDMS."Posting Date" := ServLedgerEntry."Posting Date";
                DetServLedgerEntryEDMS."Resource No." := DetServJournalLine."Resource No.";
                DetServLedgerEntryEDMS."Unit Cost" := DetServJournalLine."Unit Cost";                            //12.05.2015 EB.P30 #T030
                                                                                                                 //28.05.2015 EB.P30 #T030 >>
                IF (ServLedgerEntry."Document Type" = ServLedgerEntry."Document Type"::Invoice) OR
                   (ServLedgerEntry."Document Type" = ServLedgerEntry."Document Type"::"Return Order") THEN BEGIN
                    DetServLedgerEntryEDMS."Finished Quantity (Hours)" := -DetServJournalLine."Finished Quantity (Hours)";
                    DetServLedgerEntryEDMS."Cost Amount" := -DetServJournalLine."Cost Amount";
                    DetServLedgerEntryEDMS."Quantity (Hours)" := -DetServJournalLine."Quantity (Hours)";
                END ELSE BEGIN
                    DetServLedgerEntryEDMS."Finished Quantity (Hours)" := DetServJournalLine."Finished Quantity (Hours)";
                    DetServLedgerEntryEDMS."Cost Amount" := DetServJournalLine."Cost Amount";
                    DetServLedgerEntryEDMS."Quantity (Hours)" := DetServJournalLine."Quantity (Hours)";
                END;
                //28.05.2015 EB.P30 #T030 <<
                DetServLedgerEntryEDMS.INSERT;
            UNTIL DetServJournalLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure AdjustServPlanStageRuns(VehSerNo: Code[20]; PlanNo: Code[20]; Recurrence: Integer; PlanStageCode: Code[20]; Run1: Decimal; Run2: Decimal; Run3: Decimal; DoChangeCurrRec: Boolean; DoChangeInitial: Boolean) RetValue: Integer
    var
        VehicleServicePlanStage: Record "25006132";
        VehicleServicePlan: Record "25006126";
        DoCalcRun: Boolean;
        FixValueRun1: Decimal;
        FixValueRun2: Decimal;
        FixValueRun3: Decimal;
        CalcExpectedServiceDates: Report "25006133";
    begin
        IF PlanStageCode = '' THEN
            EXIT(1);
        IF VehicleServicePlan.GET(VehSerNo, PlanNo) THEN
            IF NOT VehicleServicePlan.Adjust THEN
                EXIT(2);
        IF VehicleServicePlanStage.GET(VehSerNo, PlanNo, Recurrence, PlanStageCode) THEN BEGIN
            DoCalcRun := TRUE;
            IF Run1 > 0 THEN
                FixValueRun1 := Run1 - VehicleServicePlanStage."VF Initial Run 1";
            IF Run2 > 0 THEN
                FixValueRun2 := Run2 - VehicleServicePlanStage."VF Initial Run 2";
            IF Run3 > 0 THEN
                FixValueRun3 := Run3 - VehicleServicePlanStage."VF Initial Run 3";
            IF DoChangeCurrRec THEN BEGIN  //02.04.2013 EDMS P8
                VehicleServicePlanStage.Kilometrage := Run1;
                VehicleServicePlanStage."Variable Field Run 2" := Run2;
                VehicleServicePlanStage."Variable Field Run 3" := Run3;
                VehicleServicePlanStage.MODIFY;
            END;
        END;
        VehicleServicePlanStage.SETRANGE("Vehicle Serial No.", VehSerNo);
        VehicleServicePlanStage.SETRANGE("Plan No.", PlanNo);
        VehicleServicePlanStage.SETRANGE(Status, VehicleServicePlanStage.Status::Pending);
        IF VehicleServicePlanStage.FINDFIRST THEN
            REPEAT
                IF DoCalcRun THEN
                    IF (((VehicleServicePlanStage.Code = PlanStageCode) AND (VehicleServicePlanStage.Recurrence = Recurrence) AND
                         DoChangeCurrRec) OR
                        (VehicleServicePlanStage.Code <> PlanStageCode) OR (VehicleServicePlanStage.Recurrence <> Recurrence)) THEN BEGIN
                        IF (Run1 > 0) AND (VehicleServicePlanStage."VF Initial Run 1" > 0) THEN BEGIN
                            VehicleServicePlanStage.Kilometrage := VehicleServicePlanStage."VF Initial Run 1" + FixValueRun1;
                            IF DoChangeInitial THEN  //02.04.2013 EDMS P8
                                VehicleServicePlanStage."VF Initial Run 1" := VehicleServicePlanStage.Kilometrage;
                        END;
                        IF (Run2 > 0) AND (VehicleServicePlanStage."VF Initial Run 2" > 0) THEN BEGIN
                            VehicleServicePlanStage."Variable Field Run 2" := VehicleServicePlanStage."VF Initial Run 2" + FixValueRun2;
                            IF DoChangeInitial THEN  //02.04.2013 EDMS P8
                                VehicleServicePlanStage."VF Initial Run 2" := VehicleServicePlanStage."Variable Field Run 2";
                        END;
                        IF (Run3 > 0) AND (VehicleServicePlanStage."VF Initial Run 3" > 0) THEN BEGIN
                            VehicleServicePlanStage."Variable Field Run 3" := VehicleServicePlanStage."VF Initial Run 3" + FixValueRun3;
                            IF DoChangeInitial THEN  //02.04.2013 EDMS P8
                                VehicleServicePlanStage."VF Initial Run 3" := VehicleServicePlanStage."Variable Field Run 3";
                        END;
                        VehicleServicePlanStage.MODIFY;
                    END;
            UNTIL VehicleServicePlanStage.NEXT = 0;
        // 2012.08.14 EDMS P8 >>
        // COMMENTED for future
        /*
        IF CONFIRM(Text001, TRUE) THEN BEGIN
          CalcExpectedServiceDates.SETTABLEVIEW(VehicleServicePlanStage);
          CalcExpectedServiceDates.RUN;
        END;
        */
        // 2012.08.14 EDMS P8 <<
        EXIT(0);

    end;
}


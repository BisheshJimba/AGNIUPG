codeunit 25006003 LookUpManagement
{
    // 02.03.2015 EDMS P21
    //   Modified local variable in procedure:
    //     LookUpNonstockItemByItem
    // 
    // 13.02.2015 EDMS P21
    //   Modified procedure:
    //     VariableFieldObjectNoList
    // 
    // 14.05.2014 Elva Baltic P8 #F036.2 MMG7.00
    //   * Fix to show correct lookup pages from vehicle card
    // 
    // 14.05.2014 Elva Baltic P21 #S0103 MMG7.00
    //   Added function:
    //     LookUpResource
    // 
    // 13.05.2014 Elva Baltic P21 #S0102 MMG7.00
    //   Modified function:
    //     LookUpObject
    // 
    // 01.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Fix Error in function:
    //     LookUpLaborStandardTime
    // 
    // 01.07.2013 EDMS P8
    //   * fix
    // 
    // 10.05.2008. EDMS P2
    //   * Created function LookUpReport
    // 
    // 20.12.2007 EDMS P5
    //   * Created function LookUpExtService


    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure LookUpVehicleAMT(var recVehicle: Record "25006005"; codSerialNo: Code[20]): Boolean
    var
        frmVehicleList: Page "25006033";
    begin
        CLEAR(frmVehicleList);
        IF codSerialNo <> '' THEN
            IF recVehicle.GET(codSerialNo) THEN
                frmVehicleList.SETRECORD(recVehicle);
        frmVehicleList.SETTABLEVIEW(recVehicle);
        frmVehicleList.LOOKUPMODE(TRUE);
        IF frmVehicleList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            frmVehicleList.GETRECORD(recVehicle);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpStandardText(var recStandardText: Record "7"; codCode: Code[20]): Boolean
    var
        frmStandardTextCodes: Page "8";
    begin
        CLEAR(frmStandardTextCodes);
        IF codCode <> '' THEN
            IF recStandardText.GET(codCode) THEN
                frmStandardTextCodes.SETRECORD(recStandardText);
        frmStandardTextCodes.SETTABLEVIEW(recStandardText);
        frmStandardTextCodes.LOOKUPMODE(TRUE);
        IF frmStandardTextCodes.RUNMODAL = ACTION::LookupOK THEN BEGIN
            frmStandardTextCodes.GETRECORD(recStandardText);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpModelVersion(var recItem: Record "27"; No: Code[20]; codMakeCode: Code[20]; codModelCode: Code[20]): Boolean
    var
        frmModelVersions: Page "25006054";
        ModelVersionListPage: Page "25006054";
    begin
        CLEAR(frmModelVersions);
        CLEAR(ModelVersionListPage);
        recItem.SETCURRENTKEY("Item Type", "Make Code");
        recItem.SETRANGE("Item Type", recItem."Item Type"::"Model Version");
        IF codMakeCode <> '' THEN
            recItem.SETRANGE("Make Code", codMakeCode);
        IF codModelCode <> '' THEN
            recItem.SETRANGE("Model Code", codModelCode);
        IF No <> '' THEN
            IF recItem.GET(No) THEN
                ModelVersionListPage.SETRECORD(recItem);


        ModelVersionListPage.SETTABLEVIEW(recItem);
        ModelVersionListPage.LOOKUPMODE(TRUE);
        IF ModelVersionListPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ModelVersionListPage.GETRECORD(recItem);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpItemREZ(var recItem: Record "27"; No: Code[20]): Boolean
    var
        ItemList: Page "31";
    begin
        CLEAR(ItemList);
        recItem.SETCURRENTKEY("Item Type");
        recItem.SETRANGE("Item Type", recItem."Item Type"::Item);
        recItem.SETFILTER("Gen. Prod. Posting Group", '<>%1', 'SUNDRYASST');
        IF No <> '' THEN
            IF recItem.GET(No) THEN
                ItemList.SETRECORD(recItem);
        ItemList.SETTABLEVIEW(recItem);
        //recItem.CLEARMARKS;
        //recItem.MARKEDONLY(FALSE);

        ItemList.LOOKUPMODE(TRUE);
        IF ItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ItemList.GETRECORD(recItem);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpItem(var recItem: Record "27"; No: Code[20]): Boolean
    var
        frmItemList: Page "31";
    begin
        CLEAR(frmItemList);
        IF No <> '' THEN
            IF recItem.GET(No) THEN
                frmItemList.SETRECORD(recItem);
        frmItemList.SETTABLEVIEW(recItem);
        frmItemList.LOOKUPMODE(TRUE);
        IF frmItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            frmItemList.GETRECORD(recItem);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpGLAccount(var recGLAccount: Record "15"; No: Code[20]): Boolean
    var
        frmGLAccountList: Page "18";
    begin
        CLEAR(frmGLAccountList);
        IF No <> '' THEN
            IF recGLAccount.GET(No) THEN
                frmGLAccountList.SETRECORD(recGLAccount);
        frmGLAccountList.SETTABLEVIEW(recGLAccount);
        frmGLAccountList.LOOKUPMODE(TRUE);
        IF frmGLAccountList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            frmGLAccountList.GETRECORD(recGLAccount);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpFixedAsset(var recFixedAsset: Record "5600"; No: Code[20]): Boolean
    var
        frmFAList: Page "5601";
    begin
        CLEAR(frmFAList);
        IF No <> '' THEN
            IF recFixedAsset.GET(No) THEN
                frmFAList.SETRECORD(recFixedAsset);
        frmFAList.SETTABLEVIEW(recFixedAsset);
        frmFAList.LOOKUPMODE(TRUE);
        IF frmFAList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            frmFAList.GETRECORD(recFixedAsset);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpChargeItem_Purch(var recChargeItem: Record "5800"; No: Code[20]): Boolean
    var
        frmItemCharges: Page "5800";
    begin
        CLEAR(frmItemCharges);
        IF No <> '' THEN
            IF recChargeItem.GET(No) THEN
                frmItemCharges.SETRECORD(recChargeItem);
        frmItemCharges.SETTABLEVIEW(recChargeItem);
        frmItemCharges.LOOKUPMODE(TRUE);
        IF frmItemCharges.RUNMODAL = ACTION::LookupOK THEN BEGIN
            frmItemCharges.GETRECORD(recChargeItem);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpItemCharges_Sale(var recChargeItem: Record "5800"; No: Code[20]): Boolean
    var
        frmItemCharges: Page "5800";
    begin
        CLEAR(frmItemCharges);
        IF No <> '' THEN
            IF recChargeItem.GET(No) THEN
                frmItemCharges.SETRECORD(recChargeItem);
        frmItemCharges.SETTABLEVIEW(recChargeItem);
        frmItemCharges.LOOKUPMODE(TRUE);
        IF frmItemCharges.RUNMODAL = ACTION::LookupOK THEN BEGIN
            frmItemCharges.GETRECORD(recChargeItem);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpNonstockItem(var recNonstockItem: Record "5718"; No: Code[20]): Boolean
    var
        frmNonstockItemList: Page "5726";
    begin
        CLEAR(frmNonstockItemList);
        IF No <> '' THEN
            IF recNonstockItem.GET(No) THEN
                frmNonstockItemList.SETRECORD(recNonstockItem);
        frmNonstockItemList.SETTABLEVIEW(recNonstockItem);
        frmNonstockItemList.LOOKUPMODE(TRUE);
        IF frmNonstockItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            frmNonstockItemList.GETRECORD(recNonstockItem);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpNonstockItemByItem(var NonstockItem: Record "5718"; codItemNo: Code[20]): Boolean
    var
        frmNonstockItemList: Page "5726";
        NonstockItem2: Record "5718";
    begin
        CLEAR(frmNonstockItemList);
        IF codItemNo <> '' THEN BEGIN
            NonstockItem2.RESET;
            NonstockItem2.SETCURRENTKEY("Item No.");
            NonstockItem2.SETRANGE("Item No.", codItemNo);
            IF NonstockItem2.FINDFIRST THEN BEGIN
                NonstockItem.SETCURRENTKEY("Entry No.");
                IF NonstockItem.GET(NonstockItem2."Entry No.") THEN
                    frmNonstockItemList.SETRECORD(NonstockItem);
            END;
        END;
        frmNonstockItemList.SETTABLEVIEW(NonstockItem);
        frmNonstockItemList.LOOKUPMODE(TRUE);
        IF frmNonstockItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            frmNonstockItemList.GETRECORD(NonstockItem);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpItemDiscountGroup(var recItemDiscGroup: Record "341"; codCode: Code[20]): Boolean
    var
        frmItemDiscGroup: Page "513";
    begin
        CLEAR(frmItemDiscGroup);
        IF codCode <> '' THEN
            IF recItemDiscGroup.GET(codCode) THEN
                frmItemDiscGroup.SETRECORD(recItemDiscGroup);
        frmItemDiscGroup.SETTABLEVIEW(recItemDiscGroup);
        frmItemDiscGroup.LOOKUPMODE(TRUE);
        IF frmItemDiscGroup.RUNMODAL = ACTION::LookupOK THEN BEGIN
            frmItemDiscGroup.GETRECORD(recItemDiscGroup);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpVehicleAccCycle(var recVehAccCycle: Record "25006024"; codSerialNo: Code[20]; codAccCycle: Code[20]): Boolean
    var
        frmVehAccCycle: Page "25006009";
    begin
        CLEAR(frmVehAccCycle);
        IF (codAccCycle <> '') THEN
            IF recVehAccCycle.GET(codAccCycle) THEN
                frmVehAccCycle.SETRECORD(recVehAccCycle);

        IF codSerialNo <> '' THEN BEGIN
            recVehAccCycle.SETCURRENTKEY("Vehicle Serial No.");
            recVehAccCycle.SETRANGE("Vehicle Serial No.", codSerialNo);
        END;

        frmVehAccCycle.SETTABLEVIEW(recVehAccCycle);
        frmVehAccCycle.LOOKUPMODE(TRUE);
        IF frmVehAccCycle.RUNMODAL = ACTION::LookupOK THEN BEGIN
            frmVehAccCycle.GETRECORD(recVehAccCycle);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpVariableField(var VFOption: Record "25006007"; TableNo: Integer; FieldNo: Integer; MakeCode: Code[20]; VFValue: Code[20]): Boolean
    var
        VFOptions: Page "25006007";
        VFUsage: Record "25006006";
        VFCode: Code[10];
        VF: Record "25006002";
    begin
        VFUsage.RESET;

        IF VFUsage.GET(TableNo, FieldNo) THEN
            VFCode := VFUsage."Variable Field Code"
        ELSE
            EXIT(FALSE);

        VF.RESET;
        VF.GET(VFCode);
        IF VF."Make Dependent Lookup" THEN
            VFOption.SETRANGE("Make Code", MakeCode);
        VFOption.SETRANGE("Variable Field Code", VFCode);

        CLEAR(VFOptions);
        VFOptions.SETRECORD(VFOption);
        VFOptions.SETTABLEVIEW(VFOption);
        VFOptions.LOOKUPMODE(TRUE);
        IF VFOptions.RUNMODAL = ACTION::LookupOK THEN BEGIN
            VFOptions.GETRECORD(VFOption);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpExternalService(var recExternalService: Record "25006133"; codCode: Code[20]): Boolean
    var
        frmExternalServices: Page "25006174";
    begin
        CLEAR(frmExternalServices);
        IF codCode <> '' THEN
            IF recExternalService.GET(codCode) THEN
                frmExternalServices.SETRECORD(recExternalService);
        frmExternalServices.SETTABLEVIEW(recExternalService);
        frmExternalServices.LOOKUPMODE(TRUE);
        IF frmExternalServices.RUNMODAL = ACTION::LookupOK THEN BEGIN
            frmExternalServices.GETRECORD(recExternalService);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpLabor(var recServLabor: Record "25006121"; codCode: Code[20]): Boolean
    var
        frmServiceLabor: Page "25006152";
    begin
        CLEAR(frmServiceLabor);
        IF codCode <> '' THEN
            IF recServLabor.GET(codCode) THEN
                frmServiceLabor.SETRECORD(recServLabor);
        frmServiceLabor.SETTABLEVIEW(recServLabor);
        frmServiceLabor.LOOKUPMODE(TRUE);
        IF frmServiceLabor.RUNMODAL = ACTION::LookupOK THEN BEGIN
            frmServiceLabor.GETRECORD(recServLabor);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpLaborStandardTime(var recServLaborST: Record "25006122"; codMakeCode: Code[20]; codLaborCode: Code[20]; intLineNo: Integer): Boolean
    var
        frmServiceLaborST: Page "25006153";
    begin
        CLEAR(frmServiceLaborST);
        IF intLineNo <> 0 THEN
            // IF recServLaborST.GET(codMakeCode,codLaborCode,intLineNo) THEN       // 01.04.2014 Elva Baltic P21
            IF recServLaborST.GET(codLaborCode, intLineNo) THEN                      // 01.04.2014 Elva Baltic P21
                frmServiceLaborST.SETRECORD(recServLaborST);
        frmServiceLaborST.SETTABLEVIEW(recServLaborST);
        frmServiceLaborST.LOOKUPMODE(TRUE);
        IF frmServiceLaborST.RUNMODAL = ACTION::LookupOK THEN BEGIN
            frmServiceLaborST.GETRECORD(recServLaborST);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpVehBodyColor(var VehBodyColor: Record "25006032"; codCode: Code[20]): Boolean
    var
        VehBodyColors: Page "25006018";
    begin
        CLEAR(VehBodyColors);
        IF codCode <> '' THEN
            IF VehBodyColor.GET(codCode) THEN
                VehBodyColors.SETRECORD(VehBodyColor);
        VehBodyColors.SETTABLEVIEW(VehBodyColor);
        VehBodyColors.LOOKUPMODE(TRUE);
        IF VehBodyColors.RUNMODAL = ACTION::LookupOK THEN BEGIN
            VehBodyColors.GETRECORD(VehBodyColor);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpVehInterior(var VehInterior: Record "25006052"; codCode: Code[20]): Boolean
    var
        VehInteriors: Page "25006044";
    begin
        CLEAR(VehInteriors);
        IF codCode <> '' THEN
            IF VehInterior.GET(codCode) THEN
                VehInteriors.SETRECORD(VehInterior);
        VehInteriors.SETTABLEVIEW(VehInterior);
        VehInteriors.LOOKUPMODE(TRUE);
        IF VehInteriors.RUNMODAL = ACTION::LookupOK THEN BEGIN
            VehInteriors.GETRECORD(VehInterior);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpExtService(var ExternalService: Record "25006133"; No: Code[20]): Boolean
    var
        ExtServiceList: Page "25006174";
    begin
        CLEAR(ExtServiceList);
        IF No <> '' THEN
            IF ExternalService.GET(No) THEN
                ExtServiceList.SETRECORD(ExternalService);
        ExtServiceList.SETTABLEVIEW(ExternalService);
        ExtServiceList.LOOKUPMODE(TRUE);
        IF ExtServiceList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ExtServiceList.GETRECORD(ExternalService);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpServLineGroup(var ServiceLine: Record "25006146"; var GroupID: Integer): Boolean
    var
        GroupingServiceLine: Record "25006146" temporary;
        LookupServiceLine: Record "25006146" temporary;
    begin
        ServiceLine.SETRANGE(Group, TRUE);
        IF ServiceLine.FINDFIRST THEN
            REPEAT
                LookupServiceLine := ServiceLine;
                LookupServiceLine.INSERT;
            UNTIL ServiceLine.NEXT = 0;
        IF LookupServiceLine.FINDFIRST THEN
            IF PAGE.RUNMODAL(PAGE::"Service Lines - Groups", LookupServiceLine) = ACTION::LookupOK THEN
                GroupID := LookupServiceLine."Line No.";
    end;

    [Scope('Internal')]
    procedure LookUpServPackSpecGroup(var PackVersionSpec: Record "25006136"; var GroupID: Integer): Boolean
    var
        LookupPackVersionSpec: Record "25006136" temporary;
    begin
        PackVersionSpec.SETRANGE(Group, TRUE);
        IF PackVersionSpec.FINDFIRST THEN
            REPEAT
                LookupPackVersionSpec := PackVersionSpec;
                LookupPackVersionSpec.INSERT;
            UNTIL PackVersionSpec.NEXT = 0;
        IF LookupPackVersionSpec.FINDFIRST THEN
            IF PAGE.RUNMODAL(PAGE::"Serv. Pack. Vers. Spec.-Groups", LookupPackVersionSpec) = ACTION::LookupOK THEN
                GroupID := LookupPackVersionSpec."Line No.";
    end;

    [Scope('Internal')]
    procedure LookUpServLineAllocationEntry(ServiceLine: Record "25006146")
    var
        LaborAllocationEntry: Record "25006271";
        LaborAllocApplication: Record "25006277";
    begin
        LaborAllocationEntry.RESET;
        LaborAllocationEntry.CLEARMARKS;
        LaborAllocApplication.RESET;
        LaborAllocApplication.SETRANGE("Document Type", ServiceLine."Document Type");
        LaborAllocApplication.SETRANGE("Document No.", ServiceLine."Document No.");
        LaborAllocApplication.SETRANGE("Document Line No.", ServiceLine."Line No.");

        IF LaborAllocApplication.FINDFIRST THEN
            REPEAT
                LaborAllocationEntry.GET(LaborAllocApplication."Allocation Entry No.");
                LaborAllocationEntry.MARK(TRUE);
            UNTIL LaborAllocApplication.NEXT = 0;

        LaborAllocationEntry.MARKEDONLY(TRUE);
        PAGE.RUNMODAL(PAGE::"Serv. Labor Allocation Entries", LaborAllocationEntry);
    end;

    [Scope('Internal')]
    procedure LookUpObject(var SourceType: Integer)
    var
        "Object": Record "2000000001";
        Objects: Page "358";
    begin
        // 13.05.2014 Elva Baltic P21 #S0102 MMG7.00 >>
        Object.RESET;
        Object.SETRANGE(Type, Object.Type::TableData);
        Object.SETRANGE("Company Name", COMPANYNAME);
        IF SourceType <> 0 THEN
            IF Object.GET(Object.Type::TableData, COMPANYNAME, SourceType) THEN
                Objects.SETRECORD(Object);
        Objects.SETTABLEVIEW(Object);
        // 13.05.2014 Elva Baltic P21 #S0102 MMG7.00 <<
        Objects.LOOKUPMODE(TRUE);
        IF Objects.RUNMODAL = ACTION::LookupOK THEN BEGIN
            Objects.GETRECORD(Object);
            SourceType := Object.ID;
        END
    end;

    [Scope('Internal')]
    procedure LookUpReport(var ReportID: Integer)
    var
        "Object": Record "2000000001";
        Objects: Page "358";
    begin
        Object.RESET;
        Object.SETRANGE(Type, Object.Type::Report);

        Objects.LOOKUPMODE(TRUE);
        Objects.SETTABLEVIEW(Object);
        IF Objects.RUNMODAL = ACTION::LookupOK THEN BEGIN
            Objects.GETRECORD(Object);
            ReportID := Object.ID;
        END
    end;

    [Scope('Internal')]
    procedure LookUpField(SourceType: Integer; var SourceRef: Integer)
    var
        "Field": Record "2000000041";
        "Fields": Page "25006031";
    begin
        Field.SETRANGE(TableNo, SourceType);
        IF SourceRef <> 0 THEN
            IF Field.GET(SourceType, SourceRef) THEN
                Fields.SETRECORD(Field);
        Fields.SETTABLEVIEW(Field);
        Fields.LOOKUPMODE(TRUE);
        IF Fields.RUNMODAL = ACTION::LookupOK THEN BEGIN
            Fields.GETRECORD(Field);
            SourceRef := Field."No.";
        END;
    end;

    [Scope('Internal')]
    procedure LookUpVariableUsageObject(var ObjectID: Integer)
    var
        TempObject: Record "2000000001" temporary;
        TempField: Record "2000000041" temporary;
        WhatToFind: Option "Object","Field";
    begin
        TempObject.RESET;
        TempObject.DELETEALL;

        WhatToFind := WhatToFind::Object;
        VariableFieldObjectNoList(TempObject, TempField, WhatToFind);

        IF PAGE.RUNMODAL(PAGE::Objects, TempObject) = ACTION::LookupOK THEN
            ObjectID := TempObject.ID;
    end;

    [Scope('Internal')]
    procedure LookUpVariableUsageField(var FieldID: Integer; TableID: Integer)
    var
        TempObject: Record "2000000001" temporary;
        TempField: Record "2000000041" temporary;
        "Object": Record "2000000001";
        WhatToFind: Option "Object","Field";
    begin
        TempField.RESET;
        TempField.DELETEALL;

        Object.SETRANGE(Type, Object.Type::Table);
        Object.SETRANGE(ID, TableID);
        IF Object.FINDFIRST THEN
            TempObject := Object;

        WhatToFind := WhatToFind::Field;
        VariableFieldObjectNoList(TempObject, TempField, WhatToFind);

        IF PAGE.RUNMODAL(PAGE::"Fields EDMS", TempField) = ACTION::LookupOK THEN
            FieldID := TempField."No.";
    end;

    [Scope('Internal')]
    procedure VariableFieldObjectNoList(var TempObject: Record "2000000001" temporary; var TempField: Record "2000000041" temporary; WhatToFind: Option "Object","Field")
    var
        "Object": Record "2000000001";
        "Field": Record "2000000041";
        NumberOfObjects: Integer;
        NumberOfFields: Integer;
        TableIDArray: array[50] of Integer;
        FieldIDArray: array[50, 33] of Integer;
        Index: Integer;
        TableIndex: Integer;
    begin
        NumberOfObjects := 50;
        NumberOfFields := 33;
        CLEAR(TableIDArray);

        TableIDArray[1] := DATABASE::"Sales Header";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 1, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 1, 3, 25006995, 1, 4);
        END;

        TableIDArray[2] := DATABASE::"Sales Line";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 2, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 2, 1, 25006389, 1, 4);
            FillFieldIDArray(FieldIDArray, 2, 2, 25006996, 1, 5);  //01.07.2013 EDMS P8
        END;

        TableIDArray[3] := DATABASE::Vehicle;
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 3, 26, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 3, 3, 330, 1, 27);  //01.07.2013 EDMS P8
        END;

        TableIDArray[4] := DATABASE::"VIN Decoding";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 4, 16, 25006800, 1, 1);

        TableIDArray[5] := DATABASE::"Model Version Specification";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 5, 21, 25006800, 1, 1);

        TableIDArray[6] := DATABASE::"Vehicle Warranty";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 6, 10, 25006800, 1, 1);

        TableIDArray[7] := DATABASE::"Service Labor";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 7, 3, 25006800, 1, 1);

        TableIDArray[8] := DATABASE::"Service Labor Standard Time";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 8, 6, 25006800, 1, 1);

        TableIDArray[9] := DATABASE::"Service Price";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 9, 1, 25006800, 1, 1);

        TableIDArray[10] := DATABASE::"SIE Journal Line";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 10, 33, 30, 10, 1);

        TableIDArray[11] := DATABASE::"Damage Part Type";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 11, 3, 25006800, 1, 1);

        TableIDArray[12] := DATABASE::"Service Labor Text";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 12, 2, 25006800, 1, 1);

        TableIDArray[13] := DATABASE::"Service Line EDMS";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 13, 3, 25006800, 1, 1);

        TableIDArray[14] := DATABASE::"Posted Serv. Order Line";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 14, 3, 25006800, 1, 1);

        TableIDArray[15] := DATABASE::"Posted Serv. Return Order Line";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 15, 3, 25006800, 1, 1);

        TableIDArray[16] := DATABASE::"Sales Invoice Header";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 16, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 16, 3, 25006995, 1, 4);
        END;

        TableIDArray[17] := DATABASE::"Sales Cr.Memo Header";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 17, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 17, 3, 25006995, 1, 4);
        END;

        TableIDArray[18] := DATABASE::"Service Header EDMS";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 18, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 18, 1, 25006180, 1, 4);
            FillFieldIDArray(FieldIDArray, 18, 2, 25006255, 5, 5);  //01.07.2013 EDMS P8
        END;

        TableIDArray[19] := DATABASE::"Posted Serv. Order Header";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 19, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 19, 1, 25006180, 1, 4);
            FillFieldIDArray(FieldIDArray, 19, 2, 25006255, 5, 5);
        END;

        TableIDArray[20] := DATABASE::"Posted Serv. Ret. Order Header";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 20, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 20, 1, 25006180, 1, 4);
            FillFieldIDArray(FieldIDArray, 20, 2, 25006255, 5, 5);
        END;

        TableIDArray[21] := DATABASE::"Serv. Journal Line";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 21, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 21, 3, 570, 10, 4);
        END;

        TableIDArray[22] := DATABASE::"Service Ledger Entry EDMS";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 22, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 22, 3, 570, 10, 4);
        END;

        TableIDArray[23] := DATABASE::"Service Package Version Line";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 23, 3, 25006800, 1, 1);

        TableIDArray[24] := DATABASE::"Service Package Version";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 24, 3, 70, 1, 1);
            FillFieldIDArray(FieldIDArray, 24, 5, 25006800, 1, 4);
        END;

        TableIDArray[25] := DATABASE::"Sales Price";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 25, 1, 25006800, 1, 1);

        TableIDArray[26] := DATABASE::"Sales Header Archive";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 26, 6, 25006800, 1, 1);

        TableIDArray[27] := DATABASE::"Service Header Archive";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 27, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 18, 1, 25006180, 1, 4);
            FillFieldIDArray(FieldIDArray, 18, 2, 25006255, 5, 5);
        END;

        TableIDArray[28] := DATABASE::"Transfer Line";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 28, 1, 25006390, 1, 1);
            FillFieldIDArray(FieldIDArray, 28, 2, 25006996, 1, 2);
        END;

        TableIDArray[29] := DATABASE::"Vehicle Service Plan Stage";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 29, 1, 36, 1, 1);
            FillFieldIDArray(FieldIDArray, 29, 5, 250, 10, 2);
        END;

        TableIDArray[30] := DATABASE::"Sales Shipment Line";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 30, 1, 25006389, 1, 1);
            FillFieldIDArray(FieldIDArray, 30, 2, 25006996, 1, 2);
        END;

        TableIDArray[31] := DATABASE::"Sales Invoice Line";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 31, 1, 25006389, 1, 1);
            FillFieldIDArray(FieldIDArray, 31, 2, 25006996, 1, 2);
        END;

        TableIDArray[32] := DATABASE::"Sales Cr.Memo Line";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 32, 1, 25006389, 1, 1);
            FillFieldIDArray(FieldIDArray, 32, 2, 25006996, 1, 2);
        END;

        TableIDArray[33] := DATABASE::"Sales Line Archive";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 33, 1, 25006389, 1, 1);
            FillFieldIDArray(FieldIDArray, 33, 2, 25006996, 1, 2);
        END;

        TableIDArray[34] := DATABASE::"Transfer Shipment Line";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 34, 1, 25006390, 1, 1);
            FillFieldIDArray(FieldIDArray, 34, 2, 25006996, 1, 2);  //01.07.2013 EDMS P8
        END;

        TableIDArray[35] := DATABASE::"Vehicle Service Plan";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 35, 1, 161, 1, 1);
            FillFieldIDArray(FieldIDArray, 35, 2, 170, 10, 2);
        END;

        TableIDArray[36] := DATABASE::"Service Splitting Line";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 36, 3, 25006800, 1, 1);
        END;

        TableIDArray[37] := DATABASE::"Service Plan Template Stage";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 37, 1, 36, 1, 1);
            FillFieldIDArray(FieldIDArray, 37, 2, 250, 10, 2);
        END;

        TableIDArray[38] := DATABASE::Tire;
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 38, 1, 30, 1, 1);
        END;

        TableIDArray[39] := DATABASE::"Tire Entry";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 39, 3, 90, 1, 1);
        END;

        // 13.02.2015 EDMS P21 >>
        TableIDArray[40] := DATABASE::"Vehicle Warranty Usage";
        IF WhatToFind = WhatToFind::Field THEN BEGIN
            FillFieldIDArray(FieldIDArray, 40, 3, 40, 1, 1);
        END;
        // 13.02.2015 EDMS P21 <<

        IF WhatToFind = WhatToFind::Object THEN BEGIN
            Object.SETRANGE(Type, Object.Type::Table);
            FOR Index := 1 TO NumberOfObjects DO BEGIN
                Object.SETRANGE(Object.ID, TableIDArray[Index]);
                IF Object.FINDFIRST THEN BEGIN
                    TempObject := Object;
                    TempObject.INSERT;
                END;
            END;
        END ELSE BEGIN
            TableIndex := 0;
            FOR Index := 1 TO NumberOfObjects DO
                IF TableIDArray[Index] = TempObject.ID THEN
                    TableIndex := Index;
            IF TableIndex = 0 THEN
                EXIT;
            Field.SETRANGE(TableNo, TempObject.ID);
            FOR Index := 1 TO NumberOfFields DO BEGIN
                IF (FieldIDArray[TableIndex] [Index] <> 0) THEN BEGIN
                    Field.SETRANGE("No.", FieldIDArray[TableIndex] [Index]);
                    IF Field.FINDFIRST THEN BEGIN
                        TempField := Field;
                        TempField.INSERT;
                    END;
                END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure FillFieldIDArray(var FieldIDArray: array[50, 33] of Integer; TableID: Integer; FieldQty: Integer; StartNumber: Integer; FieldStep: Integer; StartNrInArray: Integer)
    var
        i: Integer;
        j: Integer;
    begin
        IF StartNrInArray < 1 THEN
            StartNrInArray := 1;
        j := 0;
        FOR i := StartNrInArray TO (FieldQty + StartNrInArray - 1) DO BEGIN
            FieldIDArray[TableID] [i] := StartNumber + j * FieldStep;
            j += 1;
        END;
    end;

    [Scope('Internal')]
    procedure ShowSalesDocOfVehicle(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; VehicleSerialNo: Code[20])
    var
        SalesHeader: Record "36";
        SalesLine: Record "37";
    begin
        SalesHeader.RESET;
        SalesHeader.SETRANGE("Document Profile", SalesHeader."Document Profile"::"Vehicles Trade");

        SalesLine.RESET;
        SalesLine.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
        SalesLine.SETRANGE("Document Type", DocumentType);
        SalesLine.SETRANGE("Document Profile", SalesLine."Document Profile"::"Vehicles Trade");
        IF SalesLine.FIND('-') THEN
            REPEAT
                IF SalesLine."Line Type" = SalesLine."Line Type"::Vehicle THEN BEGIN
                    IF SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.") THEN
                        SalesHeader.MARK := TRUE;
                END;
            UNTIL SalesLine.NEXT = 0;

        SalesHeader.MARKEDONLY(TRUE);
        IF SalesHeader.COUNT = 1 THEN BEGIN
            CASE DocumentType OF  //14.05.2014 Elva Baltic P8 #F036.2 MMG7.00
                                  //Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                SalesHeader."Document Type"::Quote:
                    IF PAGE.RUNMODAL(PAGE::"Sales Quote", SalesHeader) = ACTION::None THEN
                        ;
                SalesHeader."Document Type"::Order:
                    IF PAGE.RUNMODAL(PAGE::"Sales Order", SalesHeader) = ACTION::None THEN
                        ;
                SalesHeader."Document Type"::Invoice:
                    IF PAGE.RUNMODAL(PAGE::"Sales Invoice", SalesHeader) = ACTION::None THEN
                        ;
            END;
        END ELSE BEGIN
            CASE DocumentType OF  //14.05.2014 Elva Baltic P8 #F036.2 MMG7.00
                                  //Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                SalesHeader."Document Type"::Quote:
                    IF PAGE.RUNMODAL(PAGE::"Sales Quotes (Veh.)", SalesHeader) = ACTION::None THEN
                        ;
                SalesHeader."Document Type"::Order:
                    IF PAGE.RUNMODAL(PAGE::"Sales Order List (Veh.)", SalesHeader) = ACTION::None THEN
                        ;
                SalesHeader."Document Type"::Invoice:
                    IF PAGE.RUNMODAL(PAGE::"Sales Invoice List (Veh.)", SalesHeader) = ACTION::None THEN
                        ;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ShowSPartsSalesDocOfVehicle(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; VehicleSerialNo: Code[20])
    var
        SalesHeader: Record "36";
        SalesLine: Record "37";
    begin
        SalesHeader.RESET;
        SalesHeader.SETRANGE("Document Profile", "Document Profile"::"Spare Parts Trade");
        SalesHeader.SETRANGE("Document Type", DocumentType);  //14.05.2014 Elva Baltic P8 #F036.2 MMG7.00
        SalesHeader.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
        IF SalesHeader.COUNT = 1 THEN BEGIN
            CASE DocumentType OF  //14.05.2014 Elva Baltic P8 #F036.2 MMG7.00
                                  //Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                SalesHeader."Document Type"::Quote:
                    IF PAGE.RUNMODAL(PAGE::"Sales Quote", SalesHeader) = ACTION::None THEN
                        ;
                SalesHeader."Document Type"::Order:
                    IF PAGE.RUNMODAL(PAGE::"Sales Order", SalesHeader) = ACTION::None THEN
                        ;
                SalesHeader."Document Type"::Invoice:
                    IF PAGE.RUNMODAL(PAGE::"Sales Invoice", SalesHeader) = ACTION::None THEN
                        ;
            END;
        END ELSE BEGIN
            CASE DocumentType OF  //14.05.2014 Elva Baltic P8 #F036.2 MMG7.00
                                  //Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                SalesHeader."Document Type"::Quote:
                    IF PAGE.RUNMODAL(PAGE::"Sales Quotes (SP)", SalesHeader) = ACTION::None THEN
                        ;
                SalesHeader."Document Type"::Order:
                    IF PAGE.RUNMODAL(PAGE::"Sales Order List (SP)", SalesHeader) = ACTION::None THEN
                        ;
                SalesHeader."Document Type"::Invoice:
                    IF PAGE.RUNMODAL(PAGE::"Sales Invoice List SP", SalesHeader) = ACTION::None THEN
                        ;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ShowPostedSalesDocOfVehicle(DocumentType: Option Invoice,"Credit Memo",Shipment,"Return Receipt"; VehicleSerialNo: Code[20])
    var
        SalesInvoiceHeader: Record "112";
        SalesInvoiceLine: Record "113";
        SalesCrMemoHeader: Record "114";
        SalesCrMemoLine: Record "115";
        SalesShipmentHeader: Record "110";
        SalesShipmentLine: Record "111";
        ReturnReceiptHeader: Record "6660";
        ReturnReceiptLine: Record "6661";
    begin
        CASE DocumentType OF
            DocumentType::Invoice:
                BEGIN
                    SalesInvoiceHeader.RESET;
                    SalesInvoiceHeader.SETRANGE("Document Profile", SalesInvoiceHeader."Document Profile"::"Vehicles Trade");

                    SalesInvoiceLine.RESET;
                    SalesInvoiceLine.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    SalesInvoiceLine.SETRANGE("Document Profile", SalesInvoiceLine."Document Profile"::"Vehicles Trade");
                    IF SalesInvoiceLine.FINDFIRST THEN
                        REPEAT
                            IF SalesInvoiceLine."Line Type" = SalesInvoiceLine."Line Type"::Vehicle THEN BEGIN
                                IF SalesInvoiceHeader.GET(SalesInvoiceLine."Document No.") THEN
                                    SalesInvoiceHeader.MARK := TRUE;
                            END;
                        UNTIL SalesInvoiceLine.NEXT = 0;

                    SalesInvoiceHeader.MARKEDONLY(TRUE);
                    IF SalesInvoiceHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Sales Invoice", SalesInvoiceHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Sales Invoices (Veh.)", SalesInvoiceHeader) = ACTION::None THEN;
                END;
            DocumentType::"Credit Memo":
                BEGIN
                    SalesCrMemoHeader.RESET;
                    SalesCrMemoHeader.SETRANGE("Document Profile", SalesCrMemoHeader."Document Profile"::"Vehicles Trade");

                    SalesCrMemoLine.RESET;
                    SalesCrMemoLine.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    SalesCrMemoLine.SETRANGE("Document Profile", SalesCrMemoLine."Document Profile"::"Vehicles Trade");
                    IF SalesCrMemoLine.FINDFIRST THEN
                        REPEAT
                            IF SalesCrMemoLine."Line Type" = SalesCrMemoLine."Line Type"::Vehicle THEN BEGIN
                                IF SalesCrMemoHeader.GET(SalesCrMemoLine."Document No.") THEN
                                    SalesCrMemoHeader.MARK := TRUE;
                            END;
                        UNTIL SalesCrMemoLine.NEXT = 0;

                    SalesCrMemoHeader.MARKEDONLY(TRUE);
                    IF SalesCrMemoHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Credit Note", SalesCrMemoHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Sales Cr. Memos (Veh.)", SalesCrMemoHeader) = ACTION::None THEN;
                END;
            DocumentType::Shipment:
                BEGIN
                    SalesShipmentHeader.RESET;
                    SalesShipmentHeader.SETRANGE("Document Profile", SalesShipmentHeader."Document Profile"::"Vehicles Trade");

                    SalesShipmentLine.RESET;
                    SalesShipmentLine.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    SalesShipmentLine.SETRANGE("Document Profile", SalesShipmentLine."Document Profile"::"Vehicles Trade");
                    IF SalesShipmentLine.FINDFIRST THEN
                        REPEAT
                            IF SalesShipmentLine."Line Type" = SalesShipmentLine."Line Type"::Vehicle THEN BEGIN
                                IF SalesShipmentHeader.GET(SalesShipmentLine."Document No.") THEN
                                    SalesShipmentHeader.MARK := TRUE;
                            END;
                        UNTIL SalesShipmentLine.NEXT = 0;

                    SalesShipmentHeader.MARKEDONLY(TRUE);
                    IF SalesShipmentHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Sales Shipment", SalesShipmentHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Sales Shipments (Veh.)", SalesShipmentHeader) = ACTION::None THEN;
                END;
            DocumentType::"Return Receipt":
                BEGIN
                    ReturnReceiptHeader.RESET;
                    ReturnReceiptHeader.SETRANGE("Document Profile", "Document Profile"::"Vehicles Trade");

                    ReturnReceiptLine.RESET;
                    ReturnReceiptLine.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    ReturnReceiptLine.SETRANGE("Document Profile", ReturnReceiptLine."Document Profile"::"Vehicles Trade");
                    IF ReturnReceiptLine.FINDFIRST THEN
                        REPEAT
                            IF ReturnReceiptLine."Line Type" = ReturnReceiptLine."Line Type"::Vehicle THEN BEGIN
                                IF ReturnReceiptHeader.GET(ReturnReceiptLine."Document No.") THEN
                                    ReturnReceiptHeader.MARK := TRUE;
                            END;
                        UNTIL ReturnReceiptLine.NEXT = 0;

                    ReturnReceiptHeader.MARKEDONLY(TRUE);
                    IF ReturnReceiptHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Return Receipt", ReturnReceiptHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Return Receipts (Veh.)", ReturnReceiptHeader) = ACTION::None THEN;
                END;
        END;
    end;

    [Scope('Internal')]
    procedure ShowSPartsPostedSalesDocOfVehicle(DocumentType: Option Invoice,"Credit Memo",Shipment,"Return Receipt"; VehicleSerialNo: Code[20])
    var
        SalesInvoiceHeader: Record "112";
        SalesInvoiceLine: Record "113";
        SalesCrMemoHeader: Record "114";
        SalesCrMemoLine: Record "115";
        SalesShipmentHeader: Record "110";
        SalesShipmentLine: Record "111";
        ReturnReceiptHeader: Record "6660";
        ReturnReceiptLine: Record "6661";
    begin
        CASE DocumentType OF
            DocumentType::Invoice:
                BEGIN
                    SalesInvoiceHeader.RESET;
                    SalesInvoiceHeader.SETRANGE("Document Profile", SalesInvoiceHeader."Document Profile"::"Spare Parts Trade");
                    SalesInvoiceHeader.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    IF SalesInvoiceHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Sales Invoice", SalesInvoiceHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Sales Invoices SP", SalesInvoiceHeader) = ACTION::None THEN;
                END;
            DocumentType::"Credit Memo":
                BEGIN
                    SalesCrMemoHeader.RESET;
                    SalesCrMemoHeader.SETRANGE("Document Profile", SalesCrMemoHeader."Document Profile"::"Spare Parts Trade");
                    SalesCrMemoHeader.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    IF SalesCrMemoHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Credit Note", SalesCrMemoHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Sales Credit Memos SP", SalesCrMemoHeader) = ACTION::None THEN;
                END;
            DocumentType::Shipment:
                BEGIN
                    SalesShipmentHeader.RESET;
                    SalesShipmentHeader.SETRANGE("Document Profile", SalesShipmentHeader."Document Profile"::"Spare Parts Trade");
                    SalesShipmentHeader.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    IF SalesShipmentHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Sales Shipment", SalesShipmentHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Sales Shipments SP", SalesShipmentHeader) = ACTION::None THEN;
                END;
            DocumentType::"Return Receipt":
                BEGIN
                    ReturnReceiptHeader.RESET;
                    ReturnReceiptHeader.SETRANGE("Document Profile", "Document Profile"::"Spare Parts Trade");
                    ReturnReceiptHeader.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    IF ReturnReceiptHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Return Receipt", ReturnReceiptHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Return Receipts SP", ReturnReceiptHeader) = ACTION::None THEN;
                END;
        END;
    end;

    [Scope('Internal')]
    procedure ShowPurchaseDocOfVehicle(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; VehicleSerialNo: Code[20])
    var
        PurchaseHeader: Record "38";
        PurchaseLine: Record "39";
    begin
        PurchaseHeader.RESET;
        PurchaseHeader.SETRANGE("Document Profile", PurchaseHeader."Document Profile"::"Vehicles Trade");
        PurchaseHeader.SETRANGE("Document Type", DocumentType);  //14.05.2014 Elva Baltic P8 #F036.2 MMG7.00

        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
        PurchaseLine.SETRANGE("Document Type", DocumentType);
        PurchaseLine.SETRANGE("Document Profile", PurchaseLine."Document Profile"::"Vehicles Trade");
        IF PurchaseLine.FIND('-') THEN
            REPEAT
                IF PurchaseLine."Line Type" = PurchaseLine."Line Type"::Vehicle THEN BEGIN
                    IF PurchaseHeader.GET(PurchaseLine."Document Type", PurchaseLine."Document No.") THEN
                        PurchaseHeader.MARK := TRUE;
                END;
            UNTIL PurchaseLine.NEXT = 0;

        PurchaseHeader.MARKEDONLY(TRUE);
        IF PurchaseHeader.COUNT = 1 THEN BEGIN
            CASE DocumentType OF  //14.05.2014 Elva Baltic P8 #F036.2 MMG7.00
                                  //Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                PurchaseHeader."Document Type"::Quote:
                    IF PAGE.RUNMODAL(PAGE::"Purchase Quote", PurchaseHeader) = ACTION::None THEN
                        ;
                PurchaseHeader."Document Type"::Order:
                    IF PAGE.RUNMODAL(PAGE::"Purchase Order", PurchaseHeader) = ACTION::None THEN
                        ;
                PurchaseHeader."Document Type"::Invoice:
                    IF PAGE.RUNMODAL(PAGE::"Purchase Invoice", PurchaseHeader) = ACTION::None THEN
                        ;
            END;
        END ELSE BEGIN
            CASE DocumentType OF  //14.05.2014 Elva Baltic P8 #F036.2 MMG7.00
                                  //Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                PurchaseHeader."Document Type"::Quote:
                    IF PAGE.RUNMODAL(PAGE::"Purchase Quotes (Veh.)", PurchaseHeader) = ACTION::None THEN
                        ;
                PurchaseHeader."Document Type"::Order:
                    IF PAGE.RUNMODAL(PAGE::"Purchase Order List (Veh.)", PurchaseHeader) = ACTION::None THEN
                        ;
                PurchaseHeader."Document Type"::Invoice:
                    IF PAGE.RUNMODAL(PAGE::"Purchase Invoices (Veh.)", PurchaseHeader) = ACTION::None THEN
                        ;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ShowPostedPurchaseDocOfVehicle(DocumentType: Option Invoice,"Credit Memo","Return Shipment",Receipt; VehicleSerialNo: Code[20])
    var
        PurchInvHeader: Record "122";
        PurchInvLine: Record "123";
        PurchCrMemoHdr: Record "124";
        PurchCrMemoLine: Record "125";
        ReturnShipmentHeader: Record "6650";
        ReturnShipmentLine: Record "6651";
        PurchRcptHeader: Record "120";
        PurchRcptLine: Record "121";
    begin
        CASE DocumentType OF
            DocumentType::Invoice:
                BEGIN
                    PurchInvHeader.RESET;
                    PurchInvHeader.SETRANGE("Document Profile", PurchInvHeader."Document Profile"::"Vehicles Trade");

                    PurchInvLine.RESET;
                    PurchInvLine.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    PurchInvLine.SETRANGE("Document Profile", PurchInvHeader."Document Profile"::"Vehicles Trade");
                    IF PurchInvLine.FINDFIRST THEN
                        REPEAT
                            IF PurchInvLine."Line Type" = PurchInvLine."Line Type"::Vehicle THEN BEGIN
                                IF PurchInvHeader.GET(PurchInvLine."Document No.") THEN
                                    PurchInvHeader.MARK := TRUE;
                            END;
                        UNTIL PurchInvLine.NEXT = 0;

                    PurchInvHeader.MARKEDONLY(TRUE);
                    IF PurchInvHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Purchase Invoice", PurchInvHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Purch. Invoices (Veh.)", PurchInvHeader) = ACTION::None THEN;
                END;
            DocumentType::"Credit Memo":
                BEGIN
                    PurchCrMemoHdr.RESET;
                    PurchCrMemoHdr.SETRANGE("Document Profile", PurchCrMemoHdr."Document Profile"::"Vehicles Trade");

                    PurchCrMemoLine.RESET;
                    PurchCrMemoLine.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    PurchCrMemoLine.SETRANGE("Document Profile", PurchCrMemoHdr."Document Profile"::"Vehicles Trade");
                    IF PurchCrMemoLine.FINDFIRST THEN
                        REPEAT
                            IF PurchCrMemoLine."Line Type" = PurchCrMemoLine."Line Type"::Vehicle THEN BEGIN
                                IF PurchCrMemoHdr.GET(PurchCrMemoLine."Document No.") THEN
                                    PurchCrMemoHdr.MARK := TRUE;
                            END;
                        UNTIL PurchCrMemoLine.NEXT = 0;

                    PurchCrMemoHdr.MARKEDONLY(TRUE);
                    IF PurchCrMemoHdr.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Debit Note", PurchCrMemoHdr) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Purch. Cr. Memos (Veh.)", PurchCrMemoHdr) = ACTION::None THEN;
                END;
            DocumentType::"Return Shipment":
                BEGIN
                    ReturnShipmentHeader.RESET;
                    ReturnShipmentHeader.SETRANGE("Document Profile", "Document Profile"::"Vehicles Trade");

                    ReturnShipmentLine.RESET;
                    ReturnShipmentLine.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    ReturnShipmentLine.SETRANGE("Document Profile", "Document Profile"::"Vehicles Trade");
                    IF ReturnShipmentLine.FINDFIRST THEN
                        REPEAT
                            IF ReturnShipmentLine."Line Type" = ReturnShipmentLine."Line Type"::Vehicle THEN BEGIN
                                IF ReturnShipmentHeader.GET(ReturnShipmentLine."Document No.") THEN
                                    ReturnShipmentHeader.MARK := TRUE;
                            END;
                        UNTIL ReturnShipmentLine.NEXT = 0;

                    ReturnShipmentHeader.MARKEDONLY(TRUE);
                    IF ReturnShipmentHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Return Shipment", ReturnShipmentHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Return Shipments (Veh.)", ReturnShipmentHeader) = ACTION::None THEN;
                END;
            DocumentType::Receipt:
                BEGIN
                    PurchRcptHeader.RESET;
                    PurchRcptHeader.SETRANGE("Document Profile", PurchRcptHeader."Document Profile"::"Vehicles Trade");

                    PurchRcptLine.RESET;
                    PurchRcptLine.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    PurchRcptLine.SETRANGE("Document Profile", PurchRcptHeader."Document Profile"::"Vehicles Trade");
                    IF PurchRcptLine.FINDFIRST THEN
                        REPEAT
                            IF PurchRcptLine."Line Type" = PurchRcptLine."Line Type"::Vehicle THEN BEGIN
                                IF PurchRcptHeader.GET(PurchRcptLine."Document No.") THEN
                                    PurchRcptHeader.MARK := TRUE;
                            END;
                        UNTIL PurchRcptLine.NEXT = 0;

                    PurchRcptHeader.MARKEDONLY(TRUE);
                    IF PurchRcptHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Purchase Receipt", PurchRcptHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Purch. Receipts (Veh.)", PurchRcptHeader) = ACTION::None THEN;
                END;
        END;
    end;

    [Scope('Internal')]
    procedure ShowSPartsPostedPurchaseDocOfVehicle(DocumentType: Option Invoice,"Credit Memo","Return Shipment",Receipt; VehicleSerialNo: Code[20])
    var
        PurchInvHeader: Record "122";
        PurchCrMemoHdr: Record "124";
        ReturnShipmentHeader: Record "6650";
        PurchRcptHeader: Record "120";
    begin
        /*
        CASE DocumentType OF
          DocumentType::Invoice:
            WITH PurchInvHeader DO BEGIN
              RESET;
              SETRANGE("Document Profile", "Document Profile"::"Spare Parts Trade");
              SETRANGE("Vehicle Serial No.", VehicleSerialNo);
              IF COUNT = 1 THEN BEGIN
                IF PAGE.RUNMODAL(PAGE::"Posted Purchase Invoice", PurchInvHeader) = ACTION::None THEN;
              END ELSE
                IF PAGE.RUNMODAL(PAGE::"Posted Purchase Invoices SP", PurchInvHeader) = ACTION::None THEN;
            END;
          DocumentType::"Credit Memo":
            WITH PurchCrMemoHdr DO BEGIN
              RESET;
              SETRANGE("Document Profile", "Document Profile"::"Spare Parts Trade");
              SETRANGE("Vehicle Serial No.", VehicleSerialNo);
              IF COUNT = 1 THEN BEGIN
                IF PAGE.RUNMODAL(PAGE::"Posted Purchase Cr. Memo", PurchCrMemoHdr) = ACTION::None THEN;
              END ELSE
                IF PAGE.RUNMODAL(PAGE::"Posted Purchase Cr. Memos SP", PurchCrMemoHdr) = ACTION::None THEN;
            END;
          DocumentType::"Return Shipment":
            WITH ReturnShipmentHeader DO BEGIN
              RESET;
              SETRANGE("Document Profile", "Document Profile"::"Spare Parts Trade");
              SETRANGE("Vehicle Serial No.", VehicleSerialNo);
              IF COUNT = 1 THEN BEGIN
                IF PAGE.RUNMODAL(PAGE::"Posted Return Shipment", ReturnShipmentHeader) = ACTION::None THEN;
              END ELSE
                IF PAGE.RUNMODAL(PAGE::"Posted Return Shipments SP", ReturnShipmentHeader) = ACTION::None THEN;
            END;
          DocumentType::Receipt:
            WITH PurchRcptHeader DO BEGIN
              RESET;
              SETRANGE("Document Profile", "Document Profile"::"Spare Parts Trade");
              SETRANGE("Vehicle Serial No.", VehicleSerialNo);
              IF COUNT = 1 THEN BEGIN
                IF PAGE.RUNMODAL(PAGE::"Posted Purchase Receipt", PurchRcptHeader) = ACTION::None THEN;
              END ELSE
                IF PAGE.RUNMODAL(PAGE::"Posted Purchase Receipts SP", PurchRcptHeader) = ACTION::None THEN;
            END;
        END;
        */

    end;

    [Scope('Internal')]
    procedure ShowServiceDocOfVehicle(DocumentType: Option Quote,"Order","Return Order",Invoice; VehicleSerialNo: Code[20])
    var
        SalesHeader: Record "36";
        ServiceHeader: Record "25006145";
    begin
        IF DocumentType = DocumentType::Invoice THEN BEGIN
            SalesHeader.RESET;
            SalesHeader.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
            SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Invoice);
            SalesHeader.SETRANGE("Document Profile", "Document Profile"::Service);
            IF SalesHeader.COUNT = 1 THEN BEGIN
                IF PAGE.RUNMODAL(PAGE::"Sales Invoice", SalesHeader) = ACTION::None THEN;
            END ELSE BEGIN
                IF PAGE.RUNMODAL(PAGE::"Sales Invoice List (Service)", SalesHeader) = ACTION::None THEN;
            END;
        END ELSE BEGIN
            ServiceHeader.RESET;
            ServiceHeader.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
            ServiceHeader.SETRANGE("Document Type", DocumentType);
            IF ServiceHeader.COUNT = 1 THEN BEGIN
                CASE ServiceHeader."Document Type" OF
                    //Quote,Order,Return Order
                    ServiceHeader."Document Type"::Quote:
                        IF PAGE.RUNMODAL(PAGE::"Service Quote EDMS", ServiceHeader) = ACTION::None THEN
                            ;
                    ServiceHeader."Document Type"::Order:
                        IF PAGE.RUNMODAL(PAGE::"Service Order EDMS", ServiceHeader) = ACTION::None THEN
                            ;
                END;
            END ELSE BEGIN
                CASE ServiceHeader."Document Type" OF
                    //Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                    ServiceHeader."Document Type"::Quote:
                        IF PAGE.RUNMODAL(PAGE::"Service Quotes EDMS", ServiceHeader) = ACTION::None THEN
                            ;
                    ServiceHeader."Document Type"::Order:
                        IF PAGE.RUNMODAL(PAGE::"Service Orders EDMS", ServiceHeader) = ACTION::None THEN
                            ;
                END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ShowPostedServiceDocOfVehicle(DocumentType: Option "Order",Invoice,"Credit Memo","Return Order","Transfer Shipment","Transfer Receipt"; VehicleSerialNo: Code[20])
    var
        SalesInvoiceHeader: Record "112";
        SalesInvoiceLine: Record "113";
        PostedServOrderHeader: Record "25006149";
        PostedServOrderLine: Record "25006150";
        SalesCrMemoHeader: Record "114";
        SalesCrMemoLine: Record "115";
        PostedServRetOrderHeader: Record "25006154";
        TransferShipmentHeader: Record "5744";
        TransferShipmentLine: Record "5745";
        TransferReceiptHeader: Record "5746";
        TransferReceiptLine: Record "5747";
    begin
        CASE DocumentType OF
            DocumentType::Order:
                BEGIN
                    PostedServOrderHeader.RESET;
                    PostedServOrderHeader.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    IF PostedServOrderHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Service Order EDMS", PostedServOrderHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Service Orders EDMS", PostedServOrderHeader) = ACTION::None THEN;
                END;
            DocumentType::Invoice:
                BEGIN
                    SalesInvoiceHeader.RESET;
                    SalesInvoiceHeader.SETRANGE("Document Profile", SalesInvoiceHeader."Document Profile"::Service);
                    SalesInvoiceHeader.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    IF SalesInvoiceHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Sales Invoice", SalesInvoiceHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Sales Invoices (Serv.)", SalesInvoiceHeader) = ACTION::None THEN;
                END;
            DocumentType::"Credit Memo":
                BEGIN
                    SalesCrMemoHeader.RESET;
                    SalesCrMemoHeader.SETRANGE("Document Profile", SalesCrMemoHeader."Document Profile"::Service);
                    SalesCrMemoHeader.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    IF SalesCrMemoHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Credit Note", SalesCrMemoHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Sales Cr.Memos (Serv.)", SalesCrMemoHeader) = ACTION::None THEN;
                END;
            DocumentType::"Return Order":
                BEGIN
                    PostedServRetOrderHeader.RESET;
                    PostedServRetOrderHeader.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    IF PostedServRetOrderHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Service Ret.Order EDMS", PostedServRetOrderHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Service Ret.Orders EDMS", PostedServRetOrderHeader) = ACTION::None THEN;
                END;
            DocumentType::"Transfer Shipment":
                BEGIN
                    TransferShipmentHeader.RESET;
                    TransferShipmentHeader.SETRANGE("Document Profile", TransferShipmentHeader."Document Profile"::Service);

                    TransferShipmentLine.RESET;
                    TransferShipmentLine.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    TransferShipmentLine.SETRANGE("Document Profile", TransferShipmentLine."Document Profile"::Service);
                    IF TransferShipmentLine.FINDFIRST THEN
                        REPEAT
                            IF TransferShipmentHeader.GET(TransferShipmentLine."Document No.") THEN
                                TransferShipmentHeader.MARK := TRUE;
                        UNTIL TransferShipmentLine.NEXT = 0;

                    TransferShipmentHeader.MARKEDONLY(TRUE);
                    IF TransferShipmentHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Transfer Shipment", TransferShipmentHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Transf. Shpmnts (Serv.)", TransferShipmentHeader) = ACTION::None THEN;
                END;
            DocumentType::"Transfer Receipt":
                BEGIN
                    TransferReceiptHeader.RESET;
                    TransferReceiptHeader.SETRANGE("Document Profile", TransferReceiptHeader."Document Profile"::Service);

                    TransferReceiptLine.RESET;
                    TransferReceiptLine.SETRANGE("Vehicle Serial No.", VehicleSerialNo);
                    TransferReceiptLine.SETRANGE("Document Profile", TransferShipmentLine."Document Profile"::Service);
                    IF TransferReceiptLine.FINDFIRST THEN
                        REPEAT
                            IF TransferReceiptHeader.GET(TransferReceiptLine."Document No.") THEN
                                TransferReceiptHeader.MARK := TRUE;
                        UNTIL TransferReceiptLine.NEXT = 0;

                    TransferReceiptHeader.MARKEDONLY(TRUE);
                    IF TransferReceiptHeader.COUNT = 1 THEN BEGIN
                        IF PAGE.RUNMODAL(PAGE::"Posted Transfer Receipt", TransferReceiptHeader) = ACTION::None THEN;
                    END ELSE
                        IF PAGE.RUNMODAL(PAGE::"Posted Transf. Rcpts (Serv.)", TransferReceiptHeader) = ACTION::None THEN;
                END;
        END;
    end;

    [Scope('Internal')]
    procedure LookUpResource(var Resource: Record "156"; No: Code[20]): Boolean
    var
        ResourceList: Page "77";
    begin
        CLEAR(ResourceList);
        IF No <> '' THEN
            IF Resource.GET(No) THEN
                ResourceList.SETRECORD(Resource);
        ResourceList.SETTABLEVIEW(Resource);
        ResourceList.LOOKUPMODE(TRUE);
        IF ResourceList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ResourceList.GETRECORD(Resource);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpItemREZ2(var recItem: Record "27"; No: Code[20]): Boolean
    var
        ItemList: Page "31";
    begin
        CLEAR(ItemList);
        recItem.SETCURRENTKEY("Item Type");
        recItem.SETRANGE("Item Type", recItem."Item Type"::Item);
        IF No <> '' THEN
            IF recItem.GET(No) THEN
                ItemList.SETRECORD(recItem);
        ItemList.SETTABLEVIEW(recItem);
        ItemList.LOOKUPMODE(TRUE);
        IF ItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ItemList.GETRECORD(recItem);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpBatteryItems(var Item: Record "27"; PartNo: Code[20]): Boolean
    var
        PageBatteryList: Page "33019913";
    begin
        CLEAR(PageBatteryList);
        IF PartNo <> '' THEN
            IF Item.GET(PartNo) THEN
                PageBatteryList.SETRECORD(Item);
        PageBatteryList.SETTABLEVIEW(Item);
        PageBatteryList.LOOKUPMODE(TRUE);
        IF PageBatteryList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            PageBatteryList.GETRECORD(Item);
            EXIT(TRUE);
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpBatteryCustomers(var Customer: Record "18"; "No.": Code[20]): Boolean
    var
        PageBatteryCustomerList: Page "33019916";
    begin
        CLEAR(PageBatteryCustomerList);
        IF "No." <> '' THEN
            IF Customer.GET("No.") THEN
                PageBatteryCustomerList.SETRECORD(Customer);
        PageBatteryCustomerList.SETTABLEVIEW(Customer);
        PageBatteryCustomerList.LOOKUPMODE(TRUE);
        IF PageBatteryCustomerList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            PageBatteryCustomerList.GETRECORD(Customer);
            EXIT(TRUE);
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpShipToAddress(var recShipToaddress: Record "222"; CustNo: Code[20]): Boolean
    var
        ShipToAddress: Record "222";
        ShipToAddressPage: Page "301";
    begin
        CLEAR(ShipToAddressPage);
        recShipToaddress.SETRANGE("Customer No.", CustNo);
        IF recShipToaddress.FINDFIRST THEN BEGIN
            ShipToAddressPage.SETTABLEVIEW(recShipToaddress);
            ShipToAddressPage.LOOKUPMODE(TRUE);
            IF ShipToAddressPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
                ShipToAddressPage.GETRECORD(recShipToaddress);
                EXIT(TRUE)
            END;
        END;
        EXIT(FALSE)
    end;
}


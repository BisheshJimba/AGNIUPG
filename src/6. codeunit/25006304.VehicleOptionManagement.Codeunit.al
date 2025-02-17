codeunit 25006304 VehicleOptionManagement
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified UseAssemblyFunctionality(), Usert Profile Setup to Branch Profile Setup
    // 
    // 31.05.2013 Elva Baltic P15
    //   * Added Function ModifVehColorUpholstByAssembly
    // 
    // 11.04.2013 EDMS P8
    //   * changes due to new field in T25006374
    // 
    // 02.12.2011. EDMS P8
    //   * Added functions
    //             CreatePDIdocFromAssemblyLine
    //             CreatePDIdocFromAssemblyServic
    // 
    // 27.08.2008. EDMS P2
    //   * Added functions
    //             PasteOwnOption
    //             PasteManufacturerOption


    trigger OnRun()
    begin
    end;

    var
        InventorySetup: Record "313";

    [Scope('Internal')]
    procedure FillVehAssembly(SerialNo: Code[20]; AssemblyID: Code[20]; MakeCode: Code[20]; ModelCode: Code[20]; ModelVersionNo: Code[20])
    var
        VehicleAssemby: Record "25006380";
        LineNo: Integer;
        ManOptinon: Record "25006370";
        VehOptLedger: Record "25006388";
    begin
        VehicleAssemby.SETRANGE("Serial No.", SerialNo);
        VehicleAssemby.SETRANGE("Assembly ID", AssemblyID);
        IF NOT VehicleAssemby.FINDFIRST THEN BEGIN
            IF VehicleOptionsExists(SerialNo) THEN BEGIN
                VehicleAssemby.INIT;
                VehicleAssemby."Serial No." := SerialNo;
                VehicleAssemby."Assembly ID" := AssemblyID;
                VehicleAssemby."Make Code" := MakeCode;
                VehicleAssemby."Model Code" := ModelCode;
                VehicleAssemby."Model Version No." := ModelVersionNo;
                SyncVehAssembly(VehicleAssemby);
            END ELSE BEGIN
                VehicleAssemby.INIT;
                VehicleAssemby."Serial No." := SerialNo;
                VehicleAssemby."Assembly ID" := AssemblyID;
                LineNo += 10000;
                VehicleAssemby."Line No." := LineNo;
                VehicleAssemby."Make Code" := MakeCode;
                VehicleAssemby."Model Code" := ModelCode;
                VehicleAssemby."Model Version No." := ModelVersionNo;
                VehicleAssemby.VALIDATE("Option Type", VehicleAssemby."Option Type"::"Vehicle Base");
                IF VehicleAssemby.INSERT(TRUE) THEN;

                ManOptinon.SETRANGE("Make Code", MakeCode);
                ManOptinon.SETRANGE("Model Code", ModelCode);
                ManOptinon.SETRANGE("Model Version No.", ModelVersionNo);
                ManOptinon.SETRANGE(Standard, TRUE);

                IF ManOptinon.FINDSET THEN
                    REPEAT
                        VehicleAssemby.INIT;
                        VehicleAssemby."Serial No." := SerialNo;
                        VehicleAssemby."Assembly ID" := AssemblyID;
                        LineNo += 10000;
                        VehicleAssemby."Line No." := LineNo;
                        VehicleAssemby."Option Type" := VehicleAssemby."Option Type"::"Manufacturer Option";
                        VehicleAssemby."Make Code" := MakeCode;
                        VehicleAssemby."Model Code" := ModelCode;
                        VehicleAssemby."Model Version No." := ModelVersionNo;
                        VehicleAssemby.VALIDATE("Option Subtype", ManOptinon.Type);
                        VehicleAssemby.VALIDATE("Option Code", ManOptinon."Option Code");
                        VehicleAssemby.Standard := TRUE;
                        IF VehicleAssemby.INSERT(TRUE) THEN;
                    UNTIL ManOptinon.NEXT = 0;
                COMMIT;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure VehicleOptionsExists(SerialNo: Code[20]): Boolean
    var
        VehOptLedger: Record "25006388";
    begin
        VehOptLedger.RESET;
        VehOptLedger.SETCURRENTKEY("Vehicle Serial No.");
        VehOptLedger.SETRANGE("Vehicle Serial No.", SerialNo);
        VehOptLedger.SETRANGE(Open, TRUE);
        EXIT(VehOptLedger.FINDSET)
    end;

    [Scope('Internal')]
    procedure PostVehOptPurchLine(var PurchHeader: Record "38"; var PurchLine: Record "39")
    var
        VehOptLedger: Record "25006388";
        VehOptJnlLine: Record "25006387";
        VehOptJnlPostLine: Codeunit "25006307";
        CrMemo: Boolean;
        VehAssembly: Record "25006380";
    begin
        PurchLine.TESTFIELD("Vehicle Serial No.");
        PurchLine.TESTFIELD("Vehicle Assembly ID");

        CrMemo := PurchLine."Document Type" = PurchLine."Document Type"::"Credit Memo";

        IF CrMemo THEN BEGIN
            VehOptLedger.RESET;
            VehOptLedger.SETRANGE("Vehicle Serial No.", PurchLine."Vehicle Serial No.");
            VehOptLedger.SETRANGE("Entry Type", VehOptLedger."Entry Type"::"Put On");
            VehOptLedger.SETRANGE(Open, TRUE);
            VehOptLedger.SETRANGE(Correction, FALSE);
            VehOptLedger.SETFILTER("Option Type", '%1|%2|%3', VehOptLedger."Option Type"::"Manufacturer Option",
              VehOptLedger."Option Type"::"Vehicle Base", VehOptLedger."Option Type"::"Own Option");
            IF VehOptLedger.FINDSET THEN
                REPEAT
                    VehOptJnlLine.RESET;
                    VehOptJnlLine.INIT;
                    VehOptJnlLine.VALIDATE("Posting Date", PurchHeader."Posting Date");
                    VehOptJnlLine.VALIDATE("Document No.", PurchLine."Document No.");
                    VehOptJnlLine.VALIDATE("Entry Type", VehOptJnlLine."Entry Type"::Assemble);
                    VehOptJnlLine.VALIDATE(Correction, TRUE);
                    VehOptJnlLine.VALIDATE("Vehicle Serial No.", PurchLine."Vehicle Serial No.");
                    VehOptJnlLine.VIN := PurchLine.VIN;
                    VehOptJnlLine.VALIDATE("Make Code", VehOptLedger."Make Code");
                    VehOptJnlLine.VALIDATE("Model Code", VehOptLedger."Model Code");
                    VehOptJnlLine.VALIDATE("Model Version No.", VehOptLedger."Model Version No.");
                    VehOptJnlLine.VALIDATE("Option Type", VehOptLedger."Option Type");
                    VehOptJnlLine.VALIDATE("Option Subtype", VehOptLedger."Option Subtype");
                    VehOptJnlLine.VALIDATE("Option Code", VehOptLedger."Option Code");
                    VehOptJnlLine.VALIDATE("Applies-to Entry", VehOptLedger."Entry No.");
                    VehOptJnlLine."Assembly ID" := PurchLine."Vehicle Assembly ID";
                    VehOptJnlPostLine.RUN(VehOptJnlLine);
                UNTIL VehOptLedger.NEXT = 0;
        END ELSE BEGIN //Not CrMemo
            VehAssembly.RESET;
            VehAssembly.SETRANGE("Serial No.", PurchLine."Vehicle Serial No.");
            VehAssembly.SETRANGE("Assembly ID", PurchLine."Vehicle Assembly ID");
            IF VehAssembly.FINDSET THEN
                REPEAT
                    VehOptJnlLine.RESET;
                    VehOptJnlLine.INIT;
                    VehOptJnlLine.VALIDATE("Posting Date", PurchHeader."Posting Date");
                    VehOptJnlLine.VALIDATE("Document No.", PurchLine."Document No.");
                    VehOptJnlLine.VALIDATE("Entry Type", VehOptJnlLine."Entry Type"::Assemble);
                    VehOptJnlLine.VALIDATE(Correction, FALSE);
                    VehOptJnlLine.VALIDATE("Vehicle Serial No.", PurchLine."Vehicle Serial No.");
                    VehOptJnlLine.VIN := PurchLine.VIN;
                    VehOptJnlLine.VALIDATE("Make Code", VehAssembly."Make Code");
                    VehOptJnlLine.VALIDATE("Model Code", VehAssembly."Model Code");
                    VehOptJnlLine.VALIDATE("Model Version No.", VehAssembly."Model Version No.");
                    VehOptJnlLine.VALIDATE("Option Type", VehAssembly."Option Type");
                    VehOptJnlLine.VALIDATE("Option Subtype", VehAssembly."Option Subtype");
                    VehOptJnlLine.VALIDATE("Option Code", VehAssembly."Option Code");
                    VehOptJnlLine."Assembly ID" := PurchLine."Vehicle Assembly ID";
                    VehOptJnlPostLine.RUN(VehOptJnlLine);
                UNTIL VehAssembly.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure SyncVehAssembly(var VehAssembly: Record "25006380")
    var
        VehAssembly1: Record "25006380";
        VehOptLedger: Record "25006388";
        LineNo: Integer;
    begin
        //Sinhronizëjam A/M komplektë³anas d/l ar eso³o komplektâciju (grâmatâ)

        VehAssembly.TESTFIELD("Serial No.");
        VehAssembly.TESTFIELD("Assembly ID");

        VehAssembly1.LOCKTABLE;
        VehAssembly1.RESET;
        VehAssembly1.SETRANGE("Serial No.", VehAssembly."Serial No.");
        VehAssembly1.SETRANGE("Assembly ID", VehAssembly."Assembly ID");

        //Ieg¸stam pëdëjâs rindas Nr.
        LineNo := 0;
        IF VehAssembly1.FINDLAST THEN
            LineNo := VehAssembly1."Line No.";

        //Saliekam visiem ierakstiem atzîmes
        IF VehAssembly1.FINDSET THEN
            REPEAT
                VehAssembly1.MARK := TRUE;
            UNTIL VehAssembly1.NEXT = 0;

        VehOptLedger.LOCKTABLE;
        VehOptLedger.RESET;
        VehOptLedger.SETCURRENTKEY("Vehicle Serial No.");
        VehOptLedger.SETRANGE("Vehicle Serial No.", VehAssembly."Serial No.");
        VehOptLedger.SETRANGE("Entry Type", VehOptLedger."Entry Type"::"Put On");
        VehOptLedger.SETRANGE(Open, TRUE);
        VehOptLedger.SETRANGE(Correction, FALSE);
        IF VehOptLedger.FINDSET THEN
            REPEAT
                VehAssembly1.SETRANGE("Option Subtype", VehOptLedger."Option Subtype");
                VehAssembly1.SETRANGE("Option Type", VehOptLedger."Option Type");
                VehAssembly1.SETRANGE("Option Code");
                IF VehOptLedger."Option Code" <> '' THEN
                    VehAssembly1.SETRANGE("Option Code", VehOptLedger."Option Code");
                IF VehAssembly1.FINDFIRST THEN BEGIN
                    VehAssembly1.Posted := TRUE;
                    VehAssembly1."Cost Amount" := VehOptLedger."Cost Amount (LCY)";
                    VehAssembly1.MODIFY;
                    VehAssembly1.MARK := FALSE;
                END
                ELSE BEGIN
                    LineNo := LineNo + 10000;
                    VehAssembly1.INIT;
                    VehAssembly1."Serial No." := VehOptLedger."Vehicle Serial No.";
                    VehAssembly1."Make Code" := VehOptLedger."Make Code";
                    VehAssembly1."Model Code" := VehOptLedger."Model Code";
                    VehAssembly1."Model Version No." := VehOptLedger."Model Version No.";
                    VehAssembly1."Assembly ID" := VehAssembly."Assembly ID";
                    VehAssembly1."Line No." := LineNo;
                    VehAssembly1.VALIDATE("Option Type", VehOptLedger."Option Type");
                    VehAssembly1.VALIDATE("Option Subtype", VehOptLedger."Option Subtype");
                    IF VehOptLedger."Option Code" <> '' THEN
                        VehAssembly1.VALIDATE("Option Code", VehOptLedger."Option Code");
                    VehAssembly1."Cost Amount" := VehOptLedger."Cost Amount (LCY)";
                    VehAssembly1.Posted := TRUE;
                    IF VehAssembly1.INSERT THEN;
                END;
            UNTIL VehOptLedger.NEXT = 0;

        //Visiem atzîmëtajiem ierakstiem saliekam pazîme -> Posted=False
        VehAssembly1.SETRANGE("Option Type");
        VehAssembly1.SETRANGE("Option Subtype");
        VehAssembly1.SETRANGE("Option Code");
        VehAssembly1.MARKEDONLY(TRUE);
        IF VehAssembly1.FINDSET THEN
            REPEAT
                VehAssembly1.Posted := FALSE;
                VehAssembly1.MODIFY;
            UNTIL VehAssembly1.NEXT = 0;

        //NoÕemam visas atzîmes
        VehAssembly1.CLEARMARKS;
    end;

    [Scope('Internal')]
    procedure PutOnOption(VehAssembly: Record "25006380")
    var
        VehOptJnlLine: Record "25006387";
        VehOptJnlPostLine: Codeunit "25006307";
        NoSeriesMgt: Codeunit "396";
    begin
        InventorySetup.GET;
        InventorySetup.TESTFIELD("Vehicle Assembly Document Nos.");

        VehAssembly.TESTFIELD("Serial No.");
        VehAssembly.TESTFIELD("Assembly ID");

        VehOptJnlLine.RESET;
        VehOptJnlLine.INIT;
        VehOptJnlLine.VALIDATE("Posting Date", WORKDATE);
        CLEAR(NoSeriesMgt);
        VehOptJnlLine.VALIDATE("Document No.", NoSeriesMgt.TryGetNextNo(InventorySetup."Vehicle Assembly Document Nos.",
                               VehOptJnlLine."Posting Date"));
        VehOptJnlLine.VALIDATE("Entry Type", VehOptJnlLine."Entry Type"::Assemble);
        VehOptJnlLine.VALIDATE(Correction, FALSE);
        VehOptJnlLine.VALIDATE("Vehicle Serial No.", VehAssembly."Serial No.");
        VehOptJnlLine.VALIDATE("Make Code", VehAssembly."Make Code");
        VehOptJnlLine.VALIDATE("Model Code", VehAssembly."Model Code");
        VehOptJnlLine.VALIDATE("Model Version No.", VehAssembly."Model Version No.");
        VehOptJnlLine.VALIDATE("Option Type", VehAssembly."Option Type");
        VehOptJnlLine.VALIDATE("Option Subtype", VehAssembly."Option Subtype");
        VehOptJnlLine.VALIDATE("Option Code", VehAssembly."Option Code");
        VehOptJnlLine.VALIDATE("Cost Amount (LCY)", VehAssembly."Cost Amount");
        VehOptJnlLine."Assembly ID" := VehAssembly."Assembly ID";
        VehOptJnlPostLine.RUN(VehOptJnlLine);

        VehAssembly.Posted := TRUE;
        VehAssembly.MODIFY;
    end;

    [Scope('Internal')]
    procedure DeleteVehAssembly(SerialNo: Code[20]; AssemblyID: Code[20])
    var
        VehAssembly: Record "25006380";
    begin
        VehAssembly.RESET;
        VehAssembly.SETRANGE("Serial No.", SerialNo);
        VehAssembly.SETRANGE("Assembly ID", AssemblyID);
        VehAssembly.DELETEALL;
    end;

    [Scope('Internal')]
    procedure IsCompletelyAssembly(SerialNo: Code[20]; AssemblyID: Code[20])
    var
        VehAssembly: Record "25006380";
    begin
        VehAssembly.RESET;
        VehAssembly.SETRANGE("Serial No.", SerialNo);
        VehAssembly.SETRANGE("Assembly ID", AssemblyID);
    end;

    [Scope('Internal')]
    procedure UseAssemblyFunctionality(): Boolean
    var
        VehOptSetup: Record "25006389";
        Workplace: Record "25006067";
        UserProfileMgt: Codeunit "25006002";
    begin
        IF UserProfileMgt.CurrProfileID = '' THEN
            EXIT(FALSE);
        IF NOT VehOptSetup.GET THEN
            EXIT(FALSE);

        Workplace.GET(UserProfileMgt.CurrProfileID);
        IF Workplace."Don't Use Vehicle Assembly" THEN
            EXIT(FALSE)
        ELSE BEGIN
            EXIT(VehOptSetup."Functionality Activated");
        END;
    end;

    [Scope('Internal')]
    procedure GetOptionText(VehicleAssembly: Record "25006380"; LanguageCode: Code[10]): Text[250]
    var
        OptionTransl: Record "25006375";
    begin
        IF LanguageCode = '' THEN
            EXIT(VehicleAssembly.Description);
        OptionTransl.RESET;
        OptionTransl.SETRANGE("Make Code", VehicleAssembly."Make Code");
        OptionTransl.SETRANGE("Model Code", VehicleAssembly."Model Code");
        OptionTransl.SETRANGE("Model Version No.", VehicleAssembly."Model Version No.");
        OptionTransl.SETRANGE("Option Type", VehicleAssembly."Option Type");
        OptionTransl.SETRANGE("Option Subtype", VehicleAssembly."Option Subtype");
        OptionTransl.SETRANGE("Option Code", VehicleAssembly."Option Code");
        OptionTransl.SETRANGE("Language Code", LanguageCode);
        IF OptionTransl.FINDFIRST THEN
            EXIT(OptionTransl.Description)
        ELSE
            EXIT(VehicleAssembly.Description)
    end;

    [Scope('Internal')]
    procedure PasteOwnOption(var OwnOption: Record "25006372"; MakeCode: Code[20]; ModelCode: Code[20])
    var
        OwnOptionNew: Record "25006372";
        OptionSalesPrice: Record "25006382";
        OptionSaleDiscount: Record "25006376";
        OptionSalesPriceNew: Record "25006382";
        OptionSaleDiscountNew: Record "25006376";
    begin
        IF OwnOption.FINDFIRST THEN
            REPEAT
                IF NOT OwnOptionNew.GET(MakeCode, ModelCode, OwnOption."Option Code") THEN BEGIN
                    OwnOptionNew.INIT;
                    OwnOptionNew := OwnOption;
                    OwnOptionNew."Make Code" := MakeCode;
                    OwnOptionNew."Model Code" := ModelCode;
                    OwnOptionNew.INSERT;

                    OptionSalesPrice.RESET;
                    OptionSalesPrice.SETRANGE("Make Code", OwnOption."Make Code");
                    OptionSalesPrice.SETRANGE("Model Code", OwnOption."Model Code");
                    OptionSalesPrice.SETRANGE("Option Type", OptionSalesPrice."Option Type"::"Own Option");
                    OptionSalesPrice.SETRANGE("Option Code", OwnOption."Option Code");
                    IF OptionSalesPrice.FINDFIRST THEN
                        REPEAT
                            OptionSalesPriceNew.INIT;
                            OptionSalesPriceNew := OptionSalesPrice;
                            OptionSalesPriceNew."Make Code" := MakeCode;
                            OptionSalesPriceNew."Model Code" := ModelCode;
                            OptionSalesPriceNew."Model Version No." := '';
                            OptionSalesPriceNew.INSERT;
                        UNTIL OptionSalesPrice.NEXT = 0;

                    OptionSaleDiscount.RESET;
                    OptionSaleDiscount.SETRANGE("Make Code", OwnOption."Make Code");
                    OptionSaleDiscount.SETRANGE("Model Code", OwnOption."Model Code");
                    OptionSaleDiscount.SETRANGE("Option Type", OptionSaleDiscount."Option Type"::"Own Option");
                    OptionSaleDiscount.SETRANGE("Option Code", OwnOption."Option Code");
                    IF OptionSaleDiscount.FINDFIRST THEN
                        REPEAT
                            OptionSaleDiscountNew.INIT;
                            OptionSaleDiscountNew := OptionSaleDiscount;
                            OptionSaleDiscountNew."Make Code" := MakeCode;
                            OptionSaleDiscountNew."Model Code" := ModelCode;
                            OptionSaleDiscountNew."Model Version No." := '';
                            OptionSaleDiscountNew.INSERT;
                        UNTIL OptionSaleDiscount.NEXT = 0;
                END;
            UNTIL OwnOption.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure PasteManufacturerOption(var ManufacturerOption: Record "25006370"; MakeCode: Code[20]; ModelCode: Code[20]; ModelVersionNo: Code[20])
    var
        ManufacturerOptionNew: Record "25006370";
        OptionSalesPrice: Record "25006382";
        OptionSaleDiscount: Record "25006376";
        OptionSalesPriceNew: Record "25006382";
        OptionSaleDiscountNew: Record "25006376";
    begin
        IF ManufacturerOption.FINDFIRST THEN
            REPEAT
                IF NOT ManufacturerOptionNew.GET(MakeCode, ModelCode, ModelVersionNo, ManufacturerOption.Type, ManufacturerOption."Option Code") THEN BEGIN
                    ManufacturerOptionNew.INIT;
                    ManufacturerOptionNew := ManufacturerOption;
                    ManufacturerOptionNew."Make Code" := MakeCode;
                    ManufacturerOptionNew."Model Code" := ModelCode;
                    ManufacturerOptionNew."Model Version No." := ModelVersionNo;
                    ManufacturerOptionNew.INSERT;

                    OptionSalesPrice.RESET;
                    OptionSalesPrice.SETRANGE("Make Code", ManufacturerOption."Make Code");
                    OptionSalesPrice.SETRANGE("Model Code", ManufacturerOption."Model Code");
                    OptionSalesPrice.SETRANGE("Model Version No.", ManufacturerOption."Model Version No.");
                    OptionSalesPrice.SETRANGE("Option Type", OptionSalesPrice."Option Type"::"Manufacturer Option");
                    OptionSalesPrice.SETRANGE("Option Subtype", ManufacturerOption.Type);
                    OptionSalesPrice.SETRANGE("Option Code", ManufacturerOption."Option Code");
                    IF OptionSalesPrice.FINDFIRST THEN
                        REPEAT
                            OptionSalesPriceNew.INIT;
                            OptionSalesPriceNew := OptionSalesPrice;
                            OptionSalesPriceNew."Make Code" := MakeCode;
                            OptionSalesPriceNew."Model Code" := ModelCode;
                            OptionSalesPriceNew."Model Version No." := ModelVersionNo;
                            OptionSalesPriceNew.INSERT;
                        UNTIL OptionSalesPrice.NEXT = 0;

                    OptionSaleDiscount.RESET;
                    OptionSaleDiscount.SETRANGE("Make Code", ManufacturerOption."Make Code");
                    OptionSaleDiscount.SETRANGE("Model Code", ManufacturerOption."Model Code");
                    OptionSaleDiscount.SETRANGE("Model Version No.", ManufacturerOption."Model Version No.");
                    OptionSaleDiscount.SETRANGE("Option Type", OptionSaleDiscount."Option Type"::"Manufacturer Option");
                    OptionSaleDiscount.SETRANGE("Option Subtype", ManufacturerOption.Type);
                    OptionSaleDiscount.SETRANGE("Option Code", ManufacturerOption."Option Code");
                    IF OptionSaleDiscount.FINDFIRST THEN
                        REPEAT
                            OptionSaleDiscountNew.INIT;
                            OptionSaleDiscountNew := OptionSaleDiscount;
                            OptionSaleDiscountNew."Make Code" := MakeCode;
                            OptionSaleDiscountNew."Model Code" := ModelCode;
                            OptionSaleDiscountNew."Model Version No." := ModelVersionNo;
                            OptionSaleDiscountNew.INSERT;
                        UNTIL OptionSaleDiscount.NEXT = 0;
                END;
            UNTIL ManufacturerOption.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CreatePDIdocFromAssemblyLine(var VehicleAssembly: Record "25006380")
    var
        SalesLine: Record "37";
        SalesHeader: Record "36";
        VehicleAssemblyHeader: Record "25006381";
        VehicleAssemblyLineTmp: Record "25006380" temporary;
        ManOption: Record "25006370";
        InvSetup: Record "313";
        NoSeriesMgt: Codeunit "396";
        CurrencyDate: Date;
        VehPriceMgt: Codeunit "25006301";
        ServiceHeaderTmp: Record "25006145" temporary;
        Customer: Record "18";
        OwnOption: Record "25006372";
        ServicePackage: Record "25006134";
        ServicePackageVersion: Record "25006135";
        Text1001: Label 'PDI service document is not created - was not selected Own Option line';
        Text1002: Label 'Is created %2 in %1.';
        Text1003: Label 'Is auto-created by function from %1.';
        Text1004: Label 'Is not able to find %1 with %2.';
        PDIcreateConfirmPage: Page "25006266";
        VehSerNo: Code[20];
        VehAssemID: Code[20];
        Text1005: Label 'In selected range there are no %3 lines.';
        Text1006: Label 'In selected range there are only %1 records with %2.';
        FormRetResult: Action;
        SerialFilterStr: Text[100];
        AssemblyIDFilterStr: Text[100];
        LineNoFilterStr: Text[100];
        CreatePDIDocByAssembly: Report "25006141";
    begin
        IF NOT VehicleAssembly.FINDFIRST THEN
            ERROR(Text1001);

        VehSerNo := VehicleAssembly."Serial No.";
        VehAssemID := VehicleAssembly."Assembly ID";
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE("Line Type", "Line Type"::Vehicle);
        SalesLine.SETRANGE("Vehicle Serial No.", VehSerNo);
        SalesLine.SETRANGE("Vehicle Assembly ID", VehAssemID);
        IF SalesLine.FINDFIRST THEN
            SalesHeader.GET(SalesLine."Document Type"::Order, SalesLine."Document No.");
        VehicleAssembly.SETRANGE("Serial No.", VehSerNo);
        VehicleAssembly.SETRANGE("Assembly ID", VehAssemID);
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesHeader.SETRANGE("No.", SalesHeader."No.");
        CreatePDIDocByAssembly.SETTABLEVIEW(SalesHeader);
        CreatePDIDocByAssembly.SETTABLEVIEW(VehicleAssembly);
        CreatePDIDocByAssembly.RUN;
    end;

    [Scope('Internal')]
    procedure CreatePDIdocFromAssemblyL_old(var VehicleAssembly: Record "25006380")
    var
        SalesLine: Record "37";
        SalesHeader: Record "36";
        VehicleAssemblyHeader: Record "25006381";
        VehicleAssemblyLineTmp: Record "25006380" temporary;
        ManOption: Record "25006370";
        InvSetup: Record "313";
        NoSeriesMgt: Codeunit "396";
        CurrencyDate: Date;
        VehPriceMgt: Codeunit "25006301";
        ServiceHeaderTmp: Record "25006145" temporary;
        Customer: Record "18";
        OwnOption: Record "25006372";
        ServicePackage: Record "25006134";
        ServicePackageVersion: Record "25006135";
        Text1001: Label 'PDI service document is not created - was not selected Own Option line';
        Text1002: Label 'Is created %2 in %1.';
        Text1003: Label 'Is auto-created by function from %1.';
        Text1004: Label 'Is not able to find %1 with %2.';
        PDIcreateConfirmPage: Page "25006266";
        VehSerNo: Code[20];
        VehAssemID: Code[20];
        Text1005: Label 'In selected range there are no %3 lines.';
        Text1006: Label 'In selected range there are only %1 records with %2.';
        FormRetResult: Action;
        SerialFilterStr: Text[100];
        AssemblyIDFilterStr: Text[100];
        LineNoFilterStr: Text[100];
    begin
        // it supposed to be called with CurrPage.SETSELECTIONFILTER(VehicleAssembly) execute before
        IF NOT VehicleAssembly.FINDFIRST THEN
            ERROR(Text1001);
        // HERE WE fill TEMP table to have stored situation with marked records
        VehicleAssemblyLineTmp.RESET;
        VehicleAssemblyLineTmp.DELETEALL;
        REPEAT
            VehicleAssemblyLineTmp := VehicleAssembly;
            VehicleAssemblyLineTmp.INSERT;
        UNTIL VehicleAssembly.NEXT = 0;

        VehicleAssemblyLineTmp.SETRANGE("Option Type", VehicleAssembly."Option Type"::"Own Option");
        IF NOT VehicleAssemblyLineTmp.FINDFIRST THEN
            ERROR(Text1005, VehicleAssembly.TABLECAPTION, VehicleAssembly.FIELDCAPTION("Option Type"),
              GetOptionCaption);
        VehicleAssemblyLineTmp.SETRANGE("PDI Created", FALSE);
        IF NOT VehicleAssemblyLineTmp.FINDFIRST THEN
            ERROR(Text1006, VehicleAssembly.TABLECAPTION, VehicleAssembly.FIELDCAPTION("PDI Created"));
        //it removes 'marked only'
        VehicleAssembly.SETRANGE("Option Type", VehicleAssembly."Option Type"::"Own Option");
        //set new marks to normal table
        //Serial No.,Assembly ID,Line No.
        SerialFilterStr := '';
        AssemblyIDFilterStr := '';
        LineNoFilterStr := '';
        REPEAT
            IF SerialFilterStr <> '' THEN
                SerialFilterStr += '|';
            SerialFilterStr += '''' + VehicleAssemblyLineTmp."Serial No." + '''';
            IF AssemblyIDFilterStr <> '' THEN
                AssemblyIDFilterStr += '|';
            AssemblyIDFilterStr += '''' + VehicleAssemblyLineTmp."Assembly ID" + '''';
            IF LineNoFilterStr <> '' THEN
                LineNoFilterStr += '|';
            LineNoFilterStr += FORMAT(VehicleAssemblyLineTmp."Line No.");
        UNTIL VehicleAssemblyLineTmp.NEXT = 0;
        VehicleAssembly.SETFILTER("Serial No.", SerialFilterStr);
        VehicleAssembly.SETFILTER("Assembly ID", AssemblyIDFilterStr);
        VehicleAssembly.SETFILTER("Line No.", LineNoFilterStr);

        VehSerNo := VehicleAssembly."Serial No.";
        VehAssemID := VehicleAssembly."Assembly ID";
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SETRANGE("Line Type", "Line Type"::Vehicle);
        SalesLine.SETRANGE("Vehicle Serial No.", VehSerNo);
        SalesLine.SETRANGE("Vehicle Assembly ID", VehAssemID);
        IF NOT SalesLine.FINDFIRST THEN BEGIN
            MESSAGE(Text1001);
            EXIT;
        END;
        //it works only for first line of range, so means that supposed that order is one for certain vehicle
        Customer.RESET;
        Customer.SETRANGE(Internal, TRUE);
        IF NOT Customer.FINDFIRST THEN BEGIN
            ERROR(Text1004, Customer.TABLECAPTION, Customer.FIELDCAPTION(Internal));
        END ELSE BEGIN
            IF Customer.COUNT > 1 THEN BEGIN
                IF NOT (PAGE.RUNMODAL(PAGE::"Customer List", Customer) = ACTION::LookupOK) THEN
                    EXIT;
            END;
        END;
        IF VehicleAssembly.FINDFIRST THEN BEGIN
            WITH ServiceHeaderTmp DO BEGIN
                ServiceHeaderTmp.INIT;
                SetHideValidationDialog(TRUE);
                SetNotFindVehicle;
                ServiceHeaderTmp.VALIDATE("Document Type", ServiceHeaderTmp."Document Type"::Order);
                ServiceHeaderTmp.INSERT(TRUE);
                ServiceHeaderTmp.VALIDATE(Description, STRSUBSTNO(Text1003, SalesLine."Document No."));
                ServiceHeaderTmp.VALIDATE("Order Date", WORKDATE);
                ServiceHeaderTmp.VALIDATE("Planned Service Date", WORKDATE);
                SetSkipVehicleChoose(TRUE);
                IF SalesHeader.GET(SalesHeader."Document Type"::Order, SalesLine."Document No.") THEN
                    ServiceHeaderTmp.VALIDATE("Sell-to Customer No.", SalesHeader."Sell-to Customer No.")
                ELSE
                    ServiceHeaderTmp.VALIDATE("Sell-to Customer No.", Customer."No.");
                ServiceHeaderTmp.VALIDATE("Bill-to Customer No.", Customer."No.");
                ServiceHeaderTmp.VALIDATE("Vehicle Serial No.", VehicleAssembly."Serial No.");
                ServiceHeaderTmp.VALIDATE(Kilometrage, SalesLine.Kilometrage);
                ServiceHeaderTmp.MODIFY(TRUE);
            END;
            COMMIT;
            WITH PDIcreateConfirmPage DO BEGIN
                SetServiceHeaderTmp(ServiceHeaderTmp);
                SetVehicleAssembly(VehicleAssembly);
                PDIcreateConfirmPage.SETRECORD(ServiceHeaderTmp);
                FormRetResult := PDIcreateConfirmPage.RUNMODAL;
                IF (FormRetResult = ACTION::LookupOK) OR (FormRetResult = ACTION::OK) THEN BEGIN
                    GetServiceHeaderTmp(ServiceHeaderTmp);
                    CreatePDIdocFromAssemblyServic(VehicleAssembly, ServiceHeaderTmp);
                END;
            END;
        END ELSE BEGIN
            MESSAGE(Text1005, VehicleAssembly.TABLECAPTION, VehicleAssembly.FIELDCAPTION("Option Type"),
              GetOptionCaption);
        END;
    end;

    [Scope('Internal')]
    procedure CreatePDIdocFromAssemblyServic(var VehicleAssembly: Record "25006380"; ServiceHeaderTmp: Record "25006145" temporary)
    var
        SalesLine: Record "37";
        VehicleAssemblyHeader: Record "25006381";
        ManOption: Record "25006370";
        InvSetup: Record "313";
        NoSeriesMgt: Codeunit "396";
        CurrencyDate: Date;
        VehPriceMgt: Codeunit "25006301";
        ServiceHeader: Record "25006145";
        Customer: Record "18";
        OwnOption: Record "25006372";
        ServicePackage: Record "25006134";
        ServicePackageVersion: Record "25006135";
        Text1001: Label 'PDI service document is not created - not found PDI options.';
        Text1002: Label '%1 %2 is created.';
        Text1003: Label 'Is auto-created by function from %1.';
        Text1004: Label 'Is not able to find %1 with %2.';
        DocDate: Date;
        DocNo: Code[20];
    begin
        // it supposed to be called with CurrPage.SETSELECTIONFILTER(VehicleAssembly) execute before
        IF VehicleAssembly.FINDFIRST THEN BEGIN
            // create service header
            ServiceHeader.INIT;
            ServiceHeader.VALIDATE("Document Type", ServiceHeader."Document Type"::Order);
            ServiceHeader.INSERT(TRUE);
            DocNo := ServiceHeader."No.";
            ServiceHeader.TRANSFERFIELDS(ServiceHeaderTmp);
            ServiceHeader."No." := DocNo;
            ServiceHeader.MODIFY(TRUE);
            COMMIT;
            // fill by service lines
            ServicePackageVersion.RESET;
            REPEAT
                AddPDItoServDoc(VehicleAssembly, ServiceHeader);
            UNTIL VehicleAssembly.NEXT = 0;
            MESSAGE(Text1002, ServiceHeader.TABLECAPTION + ' ' + FORMAT(ServiceHeader."Document Type"), ServiceHeader."No.");
        END ELSE
            MESSAGE(Text1001);
    end;

    [Scope('Internal')]
    procedure GetOptionCaption(): Text[30]
    var
        VehicleAssemblyL: Record "25006380";
        FieldRef: FieldRef;
        RecordRef: RecordRef;
        OptionCaption: Text[30];
        OptionCaptionList: Text[250];
        Position: Integer;
    begin
        VehicleAssemblyL."Option Type" := VehicleAssemblyL."Option Type"::"Own Option";
        RecordRef.OPEN(DATABASE::"Vehicle Assembly Line");
        RecordRef.GETTABLE(VehicleAssemblyL);
        FieldRef := RecordRef.FIELD(VehicleAssemblyL.FIELDNO("Option Type"));
        OptionCaptionList := FieldRef.OPTIONCAPTION;
        IF VehicleAssemblyL."Option Type" > 0 THEN
            REPEAT
                Position := STRPOS(OptionCaptionList, ',');
                IF Position > 0 THEN
                    OptionCaptionList := COPYSTR(OptionCaptionList, Position + 1, STRLEN(OptionCaptionList) - Position);
                VehicleAssemblyL."Option Type" -= 1;
            UNTIL VehicleAssemblyL."Option Type" = 0;
        Position := STRPOS(OptionCaptionList, ',');
        IF Position = 0 THEN
            Position := STRLEN(OptionCaptionList);
        OptionCaption := COPYSTR(OptionCaptionList, 1, Position - 1);
        EXIT(OptionCaption);
    end;

    [Scope('Internal')]
    procedure AddPDItoServDoc(VehicleAssembly: Record "25006380"; var ServiceHeaderPar: Record "25006145")
    var
        OwnOption: Record "25006372";
        ServicePackage: Record "25006134";
        ServicePackageVersion: Record "25006135";
    begin
        ServicePackageVersion.RESET;
        IF VehicleAssembly."Option Code" <> '' THEN
            IF OwnOption.GET(VehicleAssembly."Make Code", VehicleAssembly."Model Code", VehicleAssembly."Option Code") THEN
                IF OwnOption."Package No." <> '' THEN
                    IF ServicePackage.GET(OwnOption."Package No.") THEN BEGIN
                        ServicePackageVersion.SETRANGE("Package No.", OwnOption."Package No.");
                        ServiceHeaderPar.InsertLookupSPVersion(ServicePackageVersion);
                        VehicleAssembly."PDI Created" := TRUE;
                        VehicleAssembly.MODIFY;
                    END;
    end;

    [Scope('Internal')]
    procedure CreateServDocFromVehTrade(var ServiceHeaderPar: Record "25006145"; SalesLinePar: Record "37"; OrderDate: Date; PlannedServiceDate: Date; CustomerNoSellTo: Code[20]; CustomerNoBillTo: Code[20]): Code[20]
    var
        SalesLine: Record "37";
        VehicleAssemblyHeader: Record "25006381";
        ManOption: Record "25006370";
        InvSetup: Record "313";
        NoSeriesMgt: Codeunit "396";
        CurrencyDate: Date;
        VehPriceMgt: Codeunit "25006301";
        ServiceHeader: Record "25006145";
        Customer: Record "18";
        OwnOption: Record "25006372";
        ServicePackage: Record "25006134";
        ServicePackageVersion: Record "25006135";
        Text1001: Label 'PDI service document is not created - not found PDI options.';
        Text1002: Label '%1 %2 is created.';
        Text1003: Label 'Is auto-created by function from %1.';
        Text1004: Label 'Is not able to find %1 with %2.';
        DocDate: Date;
        DocNo: Code[20];
    begin
        ServiceHeaderPar.INIT;
        SetHideValidationDialog(TRUE);
        SetNotFindVehicle;
        ServiceHeaderPar.VALIDATE("Document Type", ServiceHeaderPar."Document Type"::Order);
        ServiceHeaderPar.INSERT(TRUE);
        ServiceHeaderPar.VALIDATE(Description, STRSUBSTNO(Text1003, SalesLinePar."Document No."));
        ServiceHeaderPar.VALIDATE("Order Date", OrderDate);
        ServiceHeaderPar.VALIDATE("Planned Service Date", PlannedServiceDate);
        SetSkipVehicleChoose(TRUE);
        ServiceHeaderPar.VALIDATE("Sell-to Customer No.", CustomerNoSellTo);
        ServiceHeaderPar.VALIDATE("Bill-to Customer No.", CustomerNoBillTo);
        ServiceHeaderPar.VALIDATE("Vehicle Serial No.", SalesLinePar."Vehicle Serial No.");
        ServiceHeaderPar.VALIDATE(Kilometrage, SalesLinePar.Kilometrage);
        ServiceHeaderPar.MODIFY(TRUE);
        EXIT(ServiceHeaderPar."No.");
    end;

    [Scope('Internal')]
    procedure GetVehColorUpholstFromAssemblyLine(VehSerialNoPar: Code[20]; VehAssemblyIDPar: Code[20]; var ColorAssmbl: Code[20]; var UpholsteryAssmbl: Code[20])
    var
        VehAssemblyLine: Record "25006380";
    begin
        VehAssemblyLine.RESET;
        VehAssemblyLine.SETRANGE("Serial No.", VehSerialNoPar);
        VehAssemblyLine.SETRANGE("Assembly ID", VehAssemblyIDPar);
        VehAssemblyLine.SETRANGE("Option Type", VehAssemblyLine."Option Type"::"Manufacturer Option");
        // Color
        VehAssemblyLine.SETRANGE("Option Subtype", VehAssemblyLine."Option Subtype"::Color);
        IF VehAssemblyLine.FINDFIRST THEN
            ColorAssmbl := VehAssemblyLine."Option Code";
        VehAssemblyLine.SETRANGE("Option Subtype");

        // Upholstery
        VehAssemblyLine.SETRANGE("Option Subtype", VehAssemblyLine."Option Subtype"::Upholstery);
        IF VehAssemblyLine.FINDFIRST THEN
            UpholsteryAssmbl := VehAssemblyLine."Option Code";
    end;
}


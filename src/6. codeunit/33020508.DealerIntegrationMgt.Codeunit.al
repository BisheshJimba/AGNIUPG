codeunit 33020508 "Dealer Integration Mgt."
{
    TableNo = 33020428;

    trigger OnRun()
    begin
        CLEARALL;
        DealerInformation := Rec;
        SetIntegrationType(DealerInformation."Integration Type");
        Synchronize(BuildDealerSOAPServiceURL(DealerInformation));
        Rec := DealerInformation;
        COMMIT;
    end;

    var
        DealerInformation: Record "33020428";
        IntegrationSetup: Record "33020427";
        DealerIntegrationServices: Record "33020430";
        IntegrationType: Option Make,Model,"Model Version",Item,"Item Price","Model Version Price",Vehicle,"Inv. Posting Group","Gen. Prod. Posting Group","VAT Prod. Posting Group","Item Tracking Code","Unit of Measure","Customer Price Group","Chart of Accounts",Resources,"Resource Price","Item Variants","Dealer Invoice Header","Dealer Invoice Lines","Dealer Cr.Memo Header","Dealer Cr.Memo Lines","Item Ledger Entry","Dealer Contact","Dealer Customer",,,,,,,,,,,,,,,,,,,,,,,,,,"Sales Header","Sales Line","Item Substitution","Customer Ledger";
        ProgressWindow: Dialog;
        TotalCount: Integer;
        Text001: Label 'Syncing #1############ of #2############\Table #3##############';
        TotalSubCount: Integer;
        ProgressWindow2: Dialog;
        PrimaryKey: array[3] of Code[50];
        Text002: Label 'Syncing Table #1##############';
        GblSalesInvHdr: Record "112";
        FilteredItem: Record "27";
        FilterItem: Boolean;
        DealerMake: Code[20];
        Makes: Text;
        ItemSubstitution: Record "5715";
        CustomerLedger: Record "21";

    [Scope('Internal')]
    procedure GetIntegrationSetup()
    begin
        IntegrationSetup.GET;
        IntegrationSetup.TESTFIELD("Base URL");
        IntegrationSetup.TESTFIELD(Port);
        IntegrationSetup.TESTFIELD("Service Instance");
        IntegrationSetup.TESTFIELD(Username);
        IntegrationSetup.TESTFIELD(Password);
    end;

    [Scope('Internal')]
    procedure BuildDealerSOAPServiceURL(DealerInformation: Record "33020428") SOAPURL: Text[250]
    var
        COLON: Label ':';
        WebServiceLabel: Label 'WS';
        Separator: Label '/';
        ServiceSeparator: Label '?';
        TenantSeparator: Label 'tenant=';
    begin
        GetIntegrationSetup;
        DealerIntegrationServices.GET(IntegrationType);
        SOAPURL := IntegrationSetup."Base URL" + COLON + FORMAT(IntegrationSetup.Port) + Separator
                 + IntegrationSetup."Service Instance" + Separator
                 + WebServiceLabel + Separator
                 + DealerInformation."Company Name" + Separator
                 + FORMAT(DealerIntegrationServices.Type) + Separator
                 + DealerIntegrationServices."Service Name" + ServiceSeparator
                 + TenantSeparator + DealerInformation."Tenant ID";
        EXIT(SOAPURL);
    end;

    [Scope('Internal')]
    procedure SetIntegrationType(NewIntegrationType: Option Make,Model,"Model Version",Item,"Item Price","Model Version Price",Vehicle,"Inv. Posting Group","Gen. Prod. Posting Group","VAT Prod. Posting Group","Item Tracking Code","Unit of Measure","Customer Price Group","Chart of Accounts",Resources,"Resource Price","Item Variants","Dealer Invoice Header","Dealer Invoice Lines","Dealer Cr.Memo Header","Dealer Cr.Memo Lines","Item Ledger Entry","Dealer Contact","Dealer Customer",,,,,,,,,,,,,,,,,,,,,,,,,,"Sales Header","Sales Line","Item Substitution","Customer Ledger")
    begin
        IntegrationType := NewIntegrationType;
    end;

    [Scope('Internal')]
    procedure CreateSynchronizationLog(DealerInformation: Record "33020428"; IntegrationType: Option Make,Model,"Model Version",Item,"Item Price","Model Version Price",Vehicle,"Inv. Posting Group","Gen. Prod. Posting Group","VAT Prod. Posting Group","Item Tracking Code","Unit of Measure","Customer Price Group","Chart of Accounts",Resources,"Resource Price","Item Variants"; MessageText: Text)
    var
        DealerIntegrationLog: Record "33020431";
        LastEntryNo: Integer;
        TableID: Integer;
        PrimaryCode: array[3] of Code[50];
    begin
        DealerIntegrationLog.RESET;
        IF DealerIntegrationLog.FINDLAST THEN
            LastEntryNo := DealerIntegrationLog."Entry No.";
        CLEAR(DealerIntegrationLog);
        DealerIntegrationLog.INIT;
        DealerIntegrationLog."Entry No." := LastEntryNo + 1;
        DealerIntegrationLog."Dealer Code" := DealerInformation."Customer No.";
        DealerIntegrationLog."Tenant ID" := DealerInformation."Tenant ID";
        DealerIntegrationLog.Message := COPYSTR(MessageText, 1, 250);
        DealerIntegrationLog.Date := TODAY;
        DealerIntegrationLog.Time := TIME;
        DealerIntegrationLog."Integration Type" := IntegrationType;
        DealerIntegrationLog."Table ID" := TableID;
        DealerIntegrationLog."Primay Key 1 Code" := PrimaryCode[1];
        DealerIntegrationLog."Primay Key 2 Code" := PrimaryCode[2];
        DealerIntegrationLog.INSERT;
    end;

    [Scope('Internal')]
    procedure Synchronize(SOAPURL: Text[250])
    begin
        CASE IntegrationType OF
            IntegrationType::Make:
                BEGIN
                    SynchronizeMake(SOAPURL);
                END;
            IntegrationType::Model:
                BEGIN
                    SynchronizeModel(SOAPURL);
                END;
            IntegrationType::"Model Version":
                BEGIN
                    SynchronizeModelVersion(SOAPURL);
                END;
            IntegrationType::Item:
                BEGIN
                    SynchronizeItem(SOAPURL);
                END;
            IntegrationType::"Item Price":
                BEGIN
                    SynchronizeItemPrice(SOAPURL);
                END;
            IntegrationType::"Model Version Price":
                BEGIN
                    SynchronizeModelVersionPrice(SOAPURL);
                END;
            IntegrationType::Vehicle:
                BEGIN
                    SynchronizeVehicle(SOAPURL);
                END;
            IntegrationType::"Inv. Posting Group":
                BEGIN
                    SynchronizeInvPostingGroup(SOAPURL);
                END;
            IntegrationType::"Gen. Prod. Posting Group":
                BEGIN
                    SynchronizeGenProdPostingGroup(SOAPURL);
                END;
            IntegrationType::"VAT Prod. Posting Group":
                BEGIN
                    SynchronizeVATProdPostingGroup(SOAPURL);
                END;
            IntegrationType::"Item Tracking Code":
                BEGIN
                    SynchronizeItemTrackingCode(SOAPURL);
                END;
            IntegrationType::"Unit of Measure":
                BEGIN
                    SynchronizeUnitOfMeasure(SOAPURL);
                END;
            IntegrationType::"Customer Price Group":
                BEGIN
                    SynchronizeCustomerPriceGroup(SOAPURL);
                END;
            IntegrationType::"Chart of Accounts":
                BEGIN
                    SynchronizeChartOfAccounts(SOAPURL);
                END;
            IntegrationType::Resources:
                BEGIN
                    SynchronizeResource(SOAPURL);
                END;
            IntegrationType::"Resource Price":
                BEGIN
                    SynchronizeResourcePrice(SOAPURL);
                END;
            IntegrationType::"Dealer Invoice Header":
                BEGIN
                    SynchronizeDealerInvoiceHeader(SOAPURL);
                END;
            IntegrationType::"Dealer Invoice Lines":
                BEGIN
                    SynchronizeDealerInvoiceLine(SOAPURL);
                END;
            IntegrationType::"Dealer Cr.Memo Header":
                BEGIN
                    SynchronizeDealerCrMemoHeader(SOAPURL);
                END;
            IntegrationType::"Dealer Cr.Memo Lines":
                BEGIN
                    SynchronizeDealerCrMemoLine(SOAPURL);
                END;
            IntegrationType::"Item Ledger Entry":
                BEGIN
                    SynchronizeDealerItemLedgerEntry(SOAPURL);
                END;
            IntegrationType::"Dealer Contact":
                BEGIN
                    SynchronizeDealerContact(SOAPURL);
                END;
            IntegrationType::"Dealer Customer":
                BEGIN
                    SynchronizeDealerCustomer(SOAPURL);
                END;
            IntegrationType::"Sales Header":
                BEGIN
                    SynchronizeSalesInvoice(SOAPURL);
                END;
            IntegrationType::"Item Substitution":
                BEGIN
                    SynchronizeItemSubstitution(SOAPURL);
                END;
            IntegrationType::"Customer Ledger":
                BEGIN
                    SynchronizeCustomerLedger(SOAPURL);
                END;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeMake(SOAPURL: Text[250])
    var
        Make: Record "25006000";
        DealerMakeSetup: Record "33020429";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        DealerMake := '';
        Makes := '';
        CONNECT(SOAPURL);
        DealerMakeSetup.RESET;
        DealerMakeSetup.SETRANGE("Customer No.", DealerInformation."Customer No.");
        //DealerMakeSetup.SETRANGE("Make Code",'M-ELECTRIC');//Min
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text001);
            ProgressWindow.UPDATE(3, DealerMakeSetup.TABLENAME);
            ProgressWindow.UPDATE(2, DealerMakeSetup.COUNT);
            TotalCount := 0;
        END;

        IF DealerMakeSetup.FINDFIRST THEN
            REPEAT
                IF NOT JobQueueActive THEN BEGIN
                    TotalCount += 1;
                    ProgressWindow.UPDATE(1, TotalCount);
                END;
                IF Make.GET(DealerMakeSetup."Make Code") THEN BEGIN
                    COMMIT;
                    CLEAR(DealerSynchronization);
                    DealerSynchronization.Initialize(DealerIntegrationService);
                    DealerSynchronization.SetMake(Make);
                    IF NOT DealerSynchronization.RUN THEN
                        CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
                END;
            UNTIL DealerMakeSetup.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeModel(SOAPURL: Text[250])
    var
        Model: Record "25006001";
        DealerMakeSetup: Record "33020429";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        DealerMakeSetup.RESET;
        DealerMakeSetup.SETRANGE("Customer No.", DealerInformation."Customer No.");
        //DealerMakeSetup.SETRANGE("Model Code",'E-AUTO TREO');//Min
        IF DealerMakeSetup.FINDFIRST THEN
            REPEAT
                Model.RESET;
                Model.SETRANGE("Make Code", DealerMakeSetup."Make Code");
                IF NOT JobQueueActive THEN BEGIN
                    ProgressWindow.OPEN(Text001);
                    ProgressWindow.UPDATE(3, Model.TABLENAME);
                    ProgressWindow.UPDATE(2, Model.COUNT);
                    TotalCount := 0;
                END;
                IF Model.FINDSET THEN
                    REPEAT
                        IF NOT JobQueueActive THEN BEGIN
                            TotalCount += 1;
                            ProgressWindow.UPDATE(1, TotalCount);
                        END;
                        COMMIT;
                        CLEAR(DealerSynchronization);
                        DealerSynchronization.Initialize(DealerIntegrationService);
                        DealerSynchronization.SetModel(Model);
                        IF NOT DealerSynchronization.RUN THEN
                            CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
                    UNTIL Model.NEXT = 0;
            UNTIL DealerMakeSetup.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeModelVersion(SOAPURL: Text[250])
    var
        ModelVersion: Record "27";
        DealerMakeSetup: Record "33020429";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
        DealerIntegrationService2: Codeunit "33020507";
        DealerSynchronization2: Codeunit "33020509";
        ModelVersionPrice: Record "7002";
        DealerInformation2: Record "33020428" temporary;
        TempIntegrationType: Option Make,Model,"Model Version",Item,"Item Price","Model Version Price",Vehicle,"Inv. Posting Group","Gen. Prod. Posting Group","VAT Prod. Posting Group","Item Tracking Code","Unit of Measure","Customer Price Group","Chart of Accounts",Resources,"Resource Price","Item Variants";
        LastSyncDate: Date;
        "--ItemVariants": Integer;
        DealerIntegrationService3: Codeunit "33020507";
        DealerSynchronization3: Codeunit "33020509";
        DealerInformation3: Record "33020428" temporary;
        TempIntegrationType3: Option Make,Model,"Model Version",Item,"Item Price","Model Version Price",Vehicle,"Inv. Posting Group","Gen. Prod. Posting Group","VAT Prod. Posting Group","Item Tracking Code","Unit of Measure","Customer Price Group","Chart of Accounts",Resources,"Resource Price","Item Variants";
        ItemVariant: Record "5401";
    begin
        DealerInformation2 := DealerInformation;
        DealerInformation2."Integration Type" := DealerInformation2."Integration Type"::"Model Version Price";

        DealerInformation3 := DealerInformation;
        DealerInformation3."Integration Type" := DealerInformation3."Integration Type"::"Item Variants";

        LastSyncDate := GetLastSyncDateFromIntegrationService(IntegrationType::"Model Version");
        IF LastSyncDate <> 0D THEN
            LastSyncDate -= 1;

        TempIntegrationType := IntegrationType;

        IntegrationType := IntegrationType::"Model Version Price";
        CLEAR(DealerIntegrationService2);
        DealerIntegrationService2.CONNECT(BuildDealerSOAPServiceURL(DealerInformation2));

        IntegrationType := IntegrationType::"Item Variants";
        CLEAR(DealerIntegrationService3);
        DealerIntegrationService3.CONNECT(BuildDealerSOAPServiceURL(DealerInformation3));

        IntegrationType := TempIntegrationType;
        CONNECT(SOAPURL);
        DealerMakeSetup.RESET;
        DealerMakeSetup.SETRANGE("Customer No.", DealerInformation."Customer No.");
        IF DealerMakeSetup.FINDFIRST THEN
            REPEAT
                ModelVersion.RESET;
                ModelVersion.SETCURRENTKEY("Item Type");
                ModelVersion.SETRANGE("Item Type", ModelVersion."Item Type"::"Model Version");
                ModelVersion.SETRANGE("Make Code", DealerMakeSetup."Make Code");
                //ModelVersion.SETRANGE("Model Code",'E-AUTO TREO'); //Min
                IF LastSyncDate <> 0D THEN
                    ModelVersion.SETFILTER("Modification Date", '>=%1', LastSyncDate);
                IF NOT JobQueueActive THEN BEGIN
                    ProgressWindow.OPEN(Text001);
                    ProgressWindow.UPDATE(3, ModelVersion.TABLENAME);
                    ProgressWindow.UPDATE(2, ModelVersion.COUNT);
                    TotalCount := 0;
                END;
                IF ModelVersion.FINDSET THEN
                    REPEAT
                        IF NOT JobQueueActive THEN BEGIN
                            TotalCount += 1;
                            ProgressWindow.UPDATE(1, TotalCount);
                        END;
                        COMMIT;
                        CLEAR(DealerSynchronization);
                        DealerSynchronization.Initialize(DealerIntegrationService);
                        DealerSynchronization.SetModelVersion(ModelVersion);
                        IF NOT DealerSynchronization.RUN THEN
                            CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);

                        ModelVersionPrice.RESET;
                        ModelVersionPrice.SETRANGE("Item No.", ModelVersion."No.");
                        ModelVersionPrice.SETFILTER("Sales Type", '%1', ModelVersionPrice."Sales Type"::"Customer Price Group");
                        IF ModelVersionPrice.FINDLAST THEN BEGIN
                            COMMIT;
                            CLEAR(DealerSynchronization2);
                            DealerSynchronization2.Initialize(DealerIntegrationService2);
                            DealerSynchronization2.SetModelVersionPrice(ModelVersionPrice);
                            IF NOT DealerSynchronization2.RUN THEN
                                CreateSynchronizationLog(DealerInformation2, IntegrationType::"Model Version Price", GETLASTERRORTEXT);
                        END;

                        ModelVersionPrice.RESET;
                        ModelVersionPrice.SETRANGE("Item No.", ModelVersion."No.");
                        ModelVersionPrice.SETFILTER("Sales Type", '%1', ModelVersionPrice."Sales Type"::"All Customers");
                        IF ModelVersionPrice.FINDLAST THEN BEGIN
                            COMMIT;
                            CLEAR(DealerSynchronization2);
                            DealerSynchronization2.Initialize(DealerIntegrationService2);
                            DealerSynchronization2.SetModelVersionPrice(ModelVersionPrice);
                            IF NOT DealerSynchronization2.RUN THEN
                                CreateSynchronizationLog(DealerInformation2, IntegrationType::"Model Version Price", GETLASTERRORTEXT);
                        END;

                        ItemVariant.RESET;
                        ItemVariant.SETRANGE("Item No.", ModelVersion."No.");
                        IF ItemVariant.FINDFIRST THEN
                            REPEAT
                                COMMIT;
                                CLEAR(DealerSynchronization3);
                                DealerSynchronization3.Initialize(DealerIntegrationService3);
                                DealerSynchronization3.SetItemVariants(ItemVariant);
                                IF NOT DealerSynchronization3.RUN THEN
                                    CreateSynchronizationLog(DealerInformation3, IntegrationType::"Item Variants", GETLASTERRORTEXT);
                            UNTIL ItemVariant.NEXT = 0;

                    UNTIL ModelVersion.NEXT = 0;
                ;
            UNTIL DealerMakeSetup.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeModelVersionPrice(SOAPURL: Text[250])
    var
        DealerMakeSetup: Record "33020429";
        ModelVersionPrice: Record "7002";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        DealerMakeSetup.RESET;
        DealerMakeSetup.SETRANGE("Customer No.", DealerInformation."Customer No.");
        //DealerMakeSetup.SETRANGE("Model Code",'E-AUTO TREO'); //Min
        IF DealerMakeSetup.FINDFIRST THEN
            REPEAT
                ModelVersionPrice.RESET;
                ModelVersionPrice.SETRANGE("Make Code", DealerMakeSetup."Make Code");
                IF NOT JobQueueActive THEN BEGIN
                    ProgressWindow.OPEN(Text001);
                    ProgressWindow.UPDATE(3, ModelVersionPrice.TABLENAME);
                    ProgressWindow.UPDATE(2, ModelVersionPrice.COUNT);
                    TotalCount := 0;
                END;
                IF ModelVersionPrice.FINDSET THEN
                    REPEAT
                        IF NOT JobQueueActive THEN BEGIN
                            TotalCount += 1;
                            ProgressWindow.UPDATE(1, TotalCount);
                        END;
                        COMMIT;
                        CLEAR(DealerSynchronization);
                        DealerSynchronization.Initialize(DealerIntegrationService);
                        DealerSynchronization.SetModelVersionPrice(ModelVersionPrice);
                        IF NOT DealerSynchronization.RUN THEN
                            CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
                    UNTIL ModelVersionPrice.NEXT = 0;
                ;
            UNTIL DealerMakeSetup.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeItem(SOAPURL: Text[250])
    var
        Item: Record "27";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
        DealerIntegrationService2: Codeunit "33020507";
        DealerSynchronization2: Codeunit "33020509";
        ItemPrice: Record "7002";
        CustomerPriceGroup: Record "6";
        DealerInformation2: Record "33020428" temporary;
        TempIntegrationType: Option Make,Model,"Model Version",Item,"Item Price","Model Version Price",Vehicle,"Inv. Posting Group","Gen. Prod. Posting Group","VAT Prod. Posting Group","Item Tracking Code","Unit of Measure";
        LastSyncDate: Date;
        ItemVariant: Record "5401";
        DealerIntegrationService3: Codeunit "33020507";
        DealerSynchronization3: Codeunit "33020509";
        DealerInformation3: Record "33020428";
    begin
        DealerInformation2 := DealerInformation;
        DealerInformation2."Integration Type" := DealerInformation2."Integration Type"::"Item Price";

        DealerInformation3 := DealerInformation;   //Sameer
        DealerInformation3."Integration Type" := DealerInformation3."Integration Type"::"Item Variants";

        LastSyncDate := GetLastSyncDateFromIntegrationService(IntegrationType::Item);
        IF LastSyncDate <> 0D THEN
            LastSyncDate -= 1;

        TempIntegrationType := IntegrationType;
        IntegrationType := IntegrationType::"Item Price";

        CLEAR(DealerIntegrationService2);
        DealerIntegrationService2.CONNECT(BuildDealerSOAPServiceURL(DealerInformation2));

        //Sameer
        IntegrationType := IntegrationType::"Item Variants";
        CLEAR(DealerIntegrationService3);
        DealerIntegrationService3.CONNECT(BuildDealerSOAPServiceURL(DealerInformation3));
        //

        IntegrationType := TempIntegrationType;
        CONNECT(SOAPURL);
        Item.RESET;
        Item.SETCURRENTKEY("Item Type");
        Item.SETRANGE("Item Type", Item."Item Type"::Item);
        //Item.SETRANGE(Blocked,TRUE); //Min
        //Item.SETFILTER("Modification Date",'%1',0D);
        IF LastSyncDate <> 0D THEN
            Item.SETFILTER("Modification Date", '>=%1', LastSyncDate);
        IF FilterItem THEN
            Item.SETRANGE("No.", FilteredItem."No.");  //ratan 1.8.2021
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text001);
            ProgressWindow.UPDATE(3, Item.TABLENAME);
            ProgressWindow.UPDATE(2, Item.COUNT);
            TotalCount := 0;
        END;
        IF Item.FINDSET THEN
            REPEAT
                IF NOT JobQueueActive THEN BEGIN
                    TotalCount += 1;
                    ProgressWindow.UPDATE(1, TotalCount);
                END;
                COMMIT;
                CLEAR(DealerSynchronization);
                DealerSynchronization.Initialize(DealerIntegrationService);
                DealerSynchronization.SetItem(Item);
                IF NOT DealerSynchronization.RUN THEN
                    CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);

                ItemPrice.RESET;
                ItemPrice.SETRANGE("Item No.", Item."No.");
                ItemPrice.SETRANGE("Sales Type", ItemPrice."Sales Type"::"All Customers");
                IF ItemPrice.FINDSET THEN BEGIN
                    REPEAT
                        COMMIT;
                        CLEAR(DealerSynchronization2);
                        DealerSynchronization2.Initialize(DealerIntegrationService2);
                        DealerSynchronization2.SetItemPrice(ItemPrice);
                        IF NOT DealerSynchronization2.RUN THEN
                            CreateSynchronizationLog(DealerInformation2, IntegrationType::"Item Price", GETLASTERRORTEXT);
                    UNTIL ItemPrice.NEXT = 0;
                END;

                CustomerPriceGroup.RESET;
                IF CustomerPriceGroup.FINDFIRST THEN
                    REPEAT
                        ItemPrice.RESET;
                        ItemPrice.SETRANGE("Item No.", Item."No.");
                        ItemPrice.SETRANGE("Sales Type", ItemPrice."Sales Type"::"Customer Price Group");
                        ItemPrice.SETRANGE("Sales Code", CustomerPriceGroup.Code);
                        IF ItemPrice.FINDSET THEN BEGIN
                            COMMIT;
                            CLEAR(DealerSynchronization2);
                            DealerSynchronization2.Initialize(DealerIntegrationService2);
                            REPEAT
                                DealerSynchronization2.SetItemPrice(ItemPrice);
                                IF NOT DealerSynchronization2.RUN THEN
                                    CreateSynchronizationLog(DealerInformation2, IntegrationType::"Item Price", GETLASTERRORTEXT);
                            UNTIL ItemPrice.NEXT = 0;
                        END;
                    UNTIL CustomerPriceGroup.NEXT = 0;

                //Sameer Bhujel --10/09/20
                ItemVariant.RESET;
                ItemVariant.SETRANGE("Item No.", Item."No.");
                IF ItemVariant.FINDFIRST THEN
                    REPEAT
                        COMMIT;
                        CLEAR(DealerSynchronization3);
                        DealerSynchronization3.Initialize(DealerIntegrationService3);
                        DealerSynchronization3.SetItemVariants(ItemVariant);
                        IF NOT DealerSynchronization3.RUN THEN
                            CreateSynchronizationLog(DealerInformation3, IntegrationType::"Item Variants", GETLASTERRORTEXT);
                    UNTIL ItemVariant.NEXT = 0;
            //
            UNTIL Item.NEXT = 0;
        ;
    end;

    [Scope('Internal')]
    procedure SynchronizeItemPrice(SOAPURL: Text[250])
    var
        ItemPrice: Record "7002";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        ItemPrice.RESET;
        ItemPrice.SETRANGE("Make Code", '');
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text001);
            ProgressWindow.UPDATE(3, ItemPrice.TABLENAME);
            ProgressWindow.UPDATE(2, ItemPrice.COUNT);
            TotalCount := 0;
        END;
        IF ItemPrice.FINDSET THEN
            REPEAT
                IF NOT JobQueueActive THEN BEGIN
                    TotalCount += 1;
                    ProgressWindow.UPDATE(1, TotalCount);
                END;
                COMMIT;
                CLEAR(DealerSynchronization);
                DealerSynchronization.Initialize(DealerIntegrationService);
                DealerSynchronization.SetItemPrice(ItemPrice);
                IF NOT DealerSynchronization.RUN THEN
                    CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
            UNTIL ItemPrice.NEXT = 0;
        ;
    end;

    [Scope('Internal')]
    procedure SynchronizeVehicle(SOAPURL: Text[250])
    var
        DealerMakeSetup: Record "33020429";
        Vehicle: Record "25006005";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
        LastSyncDate: Date;
    begin
        LastSyncDate := GetLastSyncDateFromIntegrationService(IntegrationType::Vehicle);
        IF LastSyncDate <> 0D THEN
            LastSyncDate -= 1;

        CONNECT(SOAPURL);
        DealerMakeSetup.RESET;
        DealerMakeSetup.SETRANGE("Customer No.", DealerInformation."Customer No.");

        IF DealerMakeSetup.FINDFIRST THEN
            REPEAT
                Vehicle.RESET;
                Vehicle.SETRANGE("Make Code", DealerMakeSetup."Make Code");
                //Vehicle.SETRANGE("Model Code",'E-AUTO TREO');//Min
                // Vehicle.SETRANGE("Serial No.",'MA1RU4TBKP3K93505');//Agni INC UPG
                IF LastSyncDate <> 0D THEN
                    Vehicle.SETFILTER("Last Date Modified", '>=%1', LastSyncDate);

                IF NOT JobQueueActive THEN BEGIN
                    ProgressWindow.OPEN(Text001);
                    ProgressWindow.UPDATE(3, Vehicle.TABLENAME);
                    ProgressWindow.UPDATE(2, Vehicle.COUNT);
                    TotalCount := 0;
                END;

                //Vehicle.SETRANGE("Serial No.",'VH-00248287');//Agni INC UPG
                IF Vehicle.FINDSET THEN
                    REPEAT
                        IF NOT JobQueueActive THEN BEGIN
                            TotalCount += 1;
                            ProgressWindow.UPDATE(1, TotalCount);
                        END;
                        COMMIT;
                        CLEAR(DealerSynchronization);
                        DealerSynchronization.Initialize(DealerIntegrationService);
                        DealerSynchronization.SetVehicle(Vehicle);
                        IF NOT DealerSynchronization.RUN THEN
                            CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
                    UNTIL Vehicle.NEXT = 0;
                ;
            UNTIL DealerMakeSetup.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeInvPostingGroup(SOAPURL: Text[250])
    var
        InventoryPostingGroup: Record "94";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        InventoryPostingGroup.RESET;
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text001);
            ProgressWindow.UPDATE(3, InventoryPostingGroup.TABLENAME);
            ProgressWindow.UPDATE(2, InventoryPostingGroup.COUNT);
            TotalCount := 0;
        END;
        IF InventoryPostingGroup.FINDSET THEN
            REPEAT
                IF NOT JobQueueActive THEN BEGIN
                    TotalCount += 1;
                    ProgressWindow.UPDATE(1, TotalCount);
                END;
                COMMIT;
                CLEAR(DealerSynchronization);
                DealerSynchronization.Initialize(DealerIntegrationService);
                DealerSynchronization.SetInventoryPostingGroup(InventoryPostingGroup);
                IF NOT DealerSynchronization.RUN THEN
                    CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
            UNTIL InventoryPostingGroup.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeGenProdPostingGroup(SOAPURL: Text[250])
    var
        GenProdPostingGroup: Record "251";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        GenProdPostingGroup.RESET;
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text001);
            ProgressWindow.UPDATE(3, GenProdPostingGroup.TABLENAME);
            ProgressWindow.UPDATE(2, GenProdPostingGroup.COUNT);
            TotalCount := 0;
        END;
        IF GenProdPostingGroup.FINDSET THEN
            REPEAT
                IF NOT JobQueueActive THEN BEGIN
                    TotalCount += 1;
                    ProgressWindow.UPDATE(1, TotalCount);
                END;
                COMMIT;
                CLEAR(DealerSynchronization);
                DealerSynchronization.Initialize(DealerIntegrationService);
                DealerSynchronization.SetGenProductPostingGroup(GenProdPostingGroup);
                IF NOT DealerSynchronization.RUN THEN
                    CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
            UNTIL GenProdPostingGroup.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeVATProdPostingGroup(SOAPURL: Text[250])
    var
        VATProductPostingGroup: Record "324";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        VATProductPostingGroup.RESET;
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text001);
            ProgressWindow.UPDATE(3, VATProductPostingGroup.TABLENAME);
            ProgressWindow.UPDATE(2, VATProductPostingGroup.COUNT);
            TotalCount := 0;
        END;
        IF VATProductPostingGroup.FINDSET THEN
            REPEAT
                IF NOT JobQueueActive THEN BEGIN
                    TotalCount += 1;
                    ProgressWindow.UPDATE(1, TotalCount);
                END;
                COMMIT;
                CLEAR(DealerSynchronization);
                DealerSynchronization.Initialize(DealerIntegrationService);
                DealerSynchronization.SetVATProductPostingGroup(VATProductPostingGroup);
                IF NOT DealerSynchronization.RUN THEN
                    CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
            UNTIL VATProductPostingGroup.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeUnitOfMeasure(SOAPURL: Text[250])
    var
        UnitofMeasure: Record "204";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        UnitofMeasure.RESET;
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text001);
            ProgressWindow.UPDATE(3, UnitofMeasure.TABLENAME);
            ProgressWindow.UPDATE(2, UnitofMeasure.COUNT);
            TotalCount := 0;
        END;
        IF UnitofMeasure.FINDSET THEN
            REPEAT
                IF NOT JobQueueActive THEN BEGIN
                    TotalCount += 1;
                    ProgressWindow.UPDATE(1, TotalCount);
                END;
                COMMIT;
                CLEAR(DealerSynchronization);
                DealerSynchronization.Initialize(DealerIntegrationService);
                DealerSynchronization.SetUnitofMeasure(UnitofMeasure);
                IF NOT DealerSynchronization.RUN THEN
                    CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
            UNTIL UnitofMeasure.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeItemTrackingCode(SOAPURL: Text[250])
    var
        ItemTrackingCode: Record "6502";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        ItemTrackingCode.RESET;
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text001);
            ProgressWindow.UPDATE(3, ItemTrackingCode.TABLENAME);
            ProgressWindow.UPDATE(2, ItemTrackingCode.COUNT);
            TotalCount := 0;
        END;
        IF ItemTrackingCode.FINDSET THEN
            REPEAT
                IF NOT JobQueueActive THEN BEGIN
                    TotalCount += 1;
                    ProgressWindow.UPDATE(1, TotalCount);
                END;
                COMMIT;
                CLEAR(DealerSynchronization);
                DealerSynchronization.Initialize(DealerIntegrationService);
                DealerSynchronization.SetItemTrackingCode(ItemTrackingCode);
                IF NOT DealerSynchronization.RUN THEN
                    CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
            UNTIL ItemTrackingCode.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeCustomerPriceGroup(SOAPURL: Text[250])
    var
        CustomerPriceGroup: Record "6";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        CustomerPriceGroup.RESET;
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text001);
            ProgressWindow.UPDATE(3, CustomerPriceGroup.TABLENAME);
            ProgressWindow.UPDATE(2, CustomerPriceGroup.COUNT);
            TotalCount := 0;
        END;
        IF CustomerPriceGroup.FINDSET THEN
            REPEAT
                IF NOT JobQueueActive THEN BEGIN
                    TotalCount += 1;
                    ProgressWindow.UPDATE(1, TotalCount);
                END;
                COMMIT;
                CLEAR(DealerSynchronization);
                DealerSynchronization.Initialize(DealerIntegrationService);
                DealerSynchronization.SetCustomerPriceGroup(CustomerPriceGroup);
                IF NOT DealerSynchronization.RUN THEN
                    CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
            UNTIL CustomerPriceGroup.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeChartOfAccounts(SOAPURL: Text[250])
    var
        GLAccount: Record "15";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        GLAccount.RESET;
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text001);
            ProgressWindow.UPDATE(3, GLAccount.TABLENAME);
            ProgressWindow.UPDATE(2, GLAccount.COUNT);
            TotalCount := 0;
        END;
        IF GLAccount.FINDFIRST THEN
            REPEAT
                IF NOT JobQueueActive THEN BEGIN
                    TotalCount += 1;
                    ProgressWindow.UPDATE(1, TotalCount);
                END;
                COMMIT;
                CLEAR(DealerSynchronization);
                DealerSynchronization.Initialize(DealerIntegrationService);
                DealerSynchronization.SetChartOfAccounts(GLAccount);
                IF NOT DealerSynchronization.RUN THEN
                    CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
            UNTIL GLAccount.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeResource(SOAPURL: Text[250])
    var
        Resource: Record "25006121";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
        DealerIntegrationService2: Codeunit "33020507";
        DealerSynchronization2: Codeunit "33020509";
        ResourcePrice: Record "25006121";
        CustomerPriceGroup: Record "6";
        DealerInformation2: Record "33020428" temporary;
        TempIntegrationType: Option Make,Model,"Model Version",Item,"Item Price","Model Version Price",Vehicle,"Inv. Posting Group","Gen. Prod. Posting Group","VAT Prod. Posting Group","Item Tracking Code","Unit of Measure","Customer Price Group","Chart of Accounts",Resources,"Resource Price";
        LastSyncDate: Date;
    begin
        DealerInformation2 := DealerInformation;
        DealerInformation2."Integration Type" := DealerInformation2."Integration Type"::"Resource Price";

        //LastSyncDate := GetLastSyncDateFromIntegrationService(IntegrationType::Resources);
        IF LastSyncDate <> 0D THEN
            LastSyncDate -= 1;

        TempIntegrationType := IntegrationType;
        IntegrationType := IntegrationType::"Resource Price";

        CLEAR(DealerIntegrationService2);
        DealerIntegrationService2.CONNECT(BuildDealerSOAPServiceURL(DealerInformation2));

        IntegrationType := TempIntegrationType;
        CONNECT(SOAPURL);
        Resource.RESET;
        //Resource.SETRANGE(Type,Resource.Type::Person);
        //Resource.SETRANGE("Sub Type",Resource."Sub Type"::Labor);
        IF LastSyncDate <> 0D THEN
            Resource.SETFILTER("Last Date Modified", '>=%1', LastSyncDate);
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text001);
            ProgressWindow.UPDATE(3, Resource.TABLENAME);
            ProgressWindow.UPDATE(2, Resource.COUNT);
            TotalCount := 0;
        END;
        IF Resource.FINDSET THEN
            REPEAT
                IF NOT JobQueueActive THEN BEGIN
                    TotalCount += 1;
                    ProgressWindow.UPDATE(1, TotalCount);
                END;
                COMMIT;
                CLEAR(DealerSynchronization);
                DealerSynchronization.Initialize(DealerIntegrationService);
                DealerSynchronization.SetResources(Resource);
                IF NOT DealerSynchronization.RUN THEN
                    CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);

                ResourcePrice.RESET;
                ResourcePrice.SETRANGE("No.", Resource."No.");
                IF ResourcePrice.FINDFIRST THEN
                    REPEAT
                        COMMIT;
                        CLEAR(DealerSynchronization2);
                        DealerSynchronization2.Initialize(DealerIntegrationService2);
                        DealerSynchronization2.SetResourcesPrice(ResourcePrice);
                        IF NOT DealerSynchronization2.RUN THEN
                            CreateSynchronizationLog(DealerInformation2, IntegrationType::"Resource Price", GETLASTERRORTEXT);
                    UNTIL ResourcePrice.NEXT = 0;

            UNTIL Resource.NEXT = 0;
        ;
    end;

    [Scope('Internal')]
    procedure SynchronizeResourcePrice(SOAPURL: Text[250])
    var
        ResourcePrice: Record "25006121";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        ResourcePrice.RESET;
        //ResourcePrice.SETRANGE(Type,ResourcePrice.Type::Resource); Commented in Agni
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text001);
            ProgressWindow.UPDATE(3, ResourcePrice.TABLENAME);
            ProgressWindow.UPDATE(2, ResourcePrice.COUNT);
            TotalCount := 0;
        END;
        IF ResourcePrice.FINDSET THEN
            REPEAT
                IF NOT JobQueueActive THEN BEGIN
                    TotalCount += 1;
                    ProgressWindow.UPDATE(1, TotalCount);
                END;
                COMMIT;
                CLEAR(DealerSynchronization);
                DealerSynchronization.Initialize(DealerIntegrationService);
                DealerSynchronization.SetResourcesPrice(ResourcePrice);
                IF NOT DealerSynchronization.RUN THEN
                    CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
            UNTIL ResourcePrice.NEXT = 0;
        ;
    end;

    [Scope('Internal')]
    procedure SynchronizeDealerInvoiceHeader(SOAPURL: Text[250])
    var
        DealerInvoices: Record "33020433";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text002);
            ProgressWindow.UPDATE(1, DealerInvoices.TABLENAME);
        END;
        COMMIT;
        CLEAR(DealerSynchronization);
        DealerSynchronization.Initialize(DealerIntegrationService);
        DealerSynchronization.SetDealerInformation(DealerInformation);
        DealerSynchronization.SetDealerInvoiceHeader;
        IF NOT DealerSynchronization.RUN THEN
            CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
    end;

    [Scope('Internal')]
    procedure SynchronizeDealerInvoiceLine(SOAPURL: Text[250])
    var
        DealerInvoices: Record "33020433";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text002);
            ProgressWindow.UPDATE(1, DealerInvoices.TABLENAME);
        END;
        COMMIT;
        CLEAR(DealerSynchronization);
        DealerSynchronization.Initialize(DealerIntegrationService);
        DealerSynchronization.SetDealerInformation(DealerInformation);
        DealerSynchronization.SetDealerInvoiceLine;
        IF NOT DealerSynchronization.RUN THEN
            CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
    end;

    [Scope('Internal')]
    procedure SynchronizeDealerCrMemoHeader(SOAPURL: Text[250])
    var
        DealerCrMemos: Record "33020433";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text002);
            ProgressWindow.UPDATE(1, DealerCrMemos.TABLENAME);
        END;
        COMMIT;
        CLEAR(DealerSynchronization);
        DealerSynchronization.Initialize(DealerIntegrationService);
        DealerSynchronization.SetDealerInformation(DealerInformation);
        DealerSynchronization.SetDealerCrMemoHeader;
        IF NOT DealerSynchronization.RUN THEN
            CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
    end;

    [Scope('Internal')]
    procedure SynchronizeDealerCrMemoLine(SOAPURL: Text[250])
    var
        DealerCrMemos: Record "33020433";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text002);
            ProgressWindow.UPDATE(1, DealerCrMemos.TABLENAME);
        END;
        COMMIT;
        CLEAR(DealerSynchronization);
        DealerSynchronization.Initialize(DealerIntegrationService);
        DealerSynchronization.SetDealerInformation(DealerInformation);
        DealerSynchronization.SetDealerCrMemoLine;
        IF NOT DealerSynchronization.RUN THEN
            CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
    end;

    [Scope('Internal')]
    procedure SynchronizeDealerItemLedgerEntry(SOAPURL: Text[250])
    var
        DealerItemLedgerEntry: Record "33020434";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text002);
            ProgressWindow.UPDATE(1, DealerItemLedgerEntry.TABLENAME);
        END;
        COMMIT;
        CLEAR(DealerSynchronization);
        DealerSynchronization.Initialize(DealerIntegrationService);
        DealerSynchronization.SetDealerInformation(DealerInformation);
        DealerSynchronization.SetDealerItemLedgerEntry;
        IF NOT DealerSynchronization.RUN THEN
            CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
    end;

    [Scope('Internal')]
    procedure SynchronizeDealerContact(SOAPURL: Text[250])
    var
        DealerContact: Record "33020435";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text002);
            ProgressWindow.UPDATE(1, DealerContact.TABLENAME);
        END;
        COMMIT;
        CLEAR(DealerSynchronization);
        DealerSynchronization.Initialize(DealerIntegrationService);
        DealerSynchronization.SetDealerInformation(DealerInformation);
        DealerSynchronization.SetDealerContact;
        IF NOT DealerSynchronization.RUN THEN
            CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
    end;

    [Scope('Internal')]
    procedure SynchronizeDealerCustomer(SOAPURL: Text[250])
    var
        DealerCustomer: Record "33020436";
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        IF NOT JobQueueActive THEN BEGIN
            ProgressWindow.OPEN(Text002);
            ProgressWindow.UPDATE(1, DealerCustomer.TABLENAME);
        END;
        COMMIT;
        CLEAR(DealerSynchronization);
        DealerSynchronization.Initialize(DealerIntegrationService);
        DealerSynchronization.SetDealerInformation(DealerInformation);
        DealerSynchronization.SetDealerCustomer;
        IF NOT DealerSynchronization.RUN THEN
            CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
    end;

    [Scope('Internal')]
    procedure JobQueueActive(): Boolean
    begin
        EXIT(NOT GUIALLOWED);
    end;

    [Scope('Internal')]
    procedure UpdateLastModificationDate(ItemNo: Code[20])
    var
        Item: Record "27";
    begin
        Item.RESET;
        Item.SETRANGE("No.", ItemNo);
        IF Item.FINDFIRST THEN BEGIN
            Item."Last Date Modified" := TODAY;
            Item."Modification Date" := TODAY;
            Item.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateLastResourceModificationDate(ResourceNo: Code[20])
    var
        Resource: Record "156";
    begin
        Resource.RESET;
        Resource.SETRANGE("No.", ResourceNo);
        IF Resource.FINDFIRST THEN BEGIN
            Resource."Last Date Modified" := TODAY;
            Resource.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure GetLastSyncDateFromIntegrationService(IntegrationType: Option): Date
    var
        DealerIntegrationService: Record "33020430";
    begin
        DealerIntegrationService.GET(IntegrationType);
        IF DealerIntegrationService."Last Synchronization Date" = 0D THEN
            EXIT(TODAY);
        EXIT(DealerIntegrationService."Last Synchronization Date" - 5);
    end;

    [Scope('Internal')]
    procedure UpdateLastSyncDateOnIntegrationService(IntegrationType: Option)
    var
        DealerIntegrationService: Record "33020430";
    begin
        DealerIntegrationService.GET(IntegrationType);
        DealerIntegrationService."Last Synchronization Date" := TODAY;
        DealerIntegrationService.MODIFY;
    end;

    [Scope('Internal')]
    procedure BuildPrimaryKeyParameters()
    begin
    end;

    local procedure "----AD1.00---"()
    begin
    end;

    [Scope('Internal')]
    procedure SynchronizeSalesInvoice(SOAPURL: Text[250])
    var
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        COMMIT;
        CLEAR(DealerSynchronization);
        DealerSynchronization.Initialize(DealerIntegrationService);
        DealerSynchronization.SetSalesInvoiceHeader(GblSalesInvHdr);
        IF NOT DealerSynchronization.RUN THEN
            CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
    end;

    [Scope('Internal')]
    procedure SetSalesInvoice(SalesInvHdr: Record "112")
    begin
        CLEAR(GblSalesInvHdr);
        GblSalesInvHdr := SalesInvHdr;
    end;

    [Scope('Internal')]
    procedure SetItem(var NewItem: Record "27")
    begin
        FilteredItem := NewItem;
        FilterItem := TRUE;
    end;

    [Scope('Internal')]
    procedure SynchronizeItemSubstitution(SOAPURL: Text[250])
    var
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        COMMIT;
        CLEAR(DealerSynchronization);
        ItemSubstitution.RESET;
        ItemSubstitution.SETFILTER("Substitute No.", '<>%1', '');
        IF ItemSubstitution.FINDSET THEN
            REPEAT
                DealerSynchronization.Initialize(DealerIntegrationService);
                DealerSynchronization.SetItemSubstitution(ItemSubstitution);
                IF NOT DealerSynchronization.RUN THEN
                    CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
            UNTIL ItemSubstitution.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeCustomerLedger(SOAPURL: Text[250])
    var
        DealerIntegrationService: Codeunit "33020507";
        DealerSynchronization: Codeunit "33020509";
    begin
        CONNECT(SOAPURL);
        COMMIT;
        CLEAR(DealerSynchronization);
        CustomerLedger.RESET;
        CustomerLedger.SETFILTER("Entry No.", '<>%1', 0);
        //CustomerLedger.SETFILTER("Entry No.",'22020');
        IF CustomerLedger.FINDSET THEN
            REPEAT
                DealerSynchronization.Initialize(DealerIntegrationService);
                DealerSynchronization.SetCustomerLedger(CustomerLedger);
                IF NOT DealerSynchronization.RUN THEN
                    CreateSynchronizationLog(DealerInformation, IntegrationType, GETLASTERRORTEXT);
            UNTIL CustomerLedger.NEXT = 0;
    end;
}


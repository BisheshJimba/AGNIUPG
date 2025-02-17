codeunit 33020509 "Dealer Synchronization"
{
    Permissions = TableData 112 = rm,
                  TableData 472 = rimd;

    trigger OnRun()
    begin
        Synchronize;
    end;

    var
        DealerIntegrationService: Codeunit "33020507";
        Make: Record "25006000";
        Model: Record "25006001";
        ModelVersion: Record "27";
        Item: Record "27";
        Vehicle: Record "25006005";
        ItemSalesPrice: Record "7002";
        ModelVersionPrice: Record "7002";
        DealerIntegrationSetup: Record "33020427";
        InventoryPostingGroup: Record "94";
        GenProductPostingGroup: Record "251";
        VATProductPostingGroup: Record "324";
        ItemTrackingCode: Record "6502";
        UnitofMeasure: Record "204";
        CustomerPriceGroup: Record "6";
        ChartOfAccounts: Record "15";
        Resource: Record "25006121";
        ResourcePrice: Record "25006121";
        ItemVariants: Record "5401";
        IntegrationType: Option Make,Model,"Model Version",Item,"Item Price","Model Version Price",Vehicle,"Inv. Posting Group","Gen. Prod. Posting Group","VAT Prod. Posting Group","Item Tracking Code","Unit of Measure","Customer Price Group","Chart of Accounts",Resources,"Resource Price","Item Variants","Dealer Invoice Header","Dealer Invoice Lines","Dealer Cr.Memo Header","Dealer Cr.Memo Lines","Item Ledger Entry","Dealer Contact","Dealer Customer",,,,,,,,,,,,,,,,,,,,,,,,,,"Sales Header","Sales Line","Item Substitution","Customer Ledger";
        Text000: Label 'Sales Invoice %1';
        DealerInformation: Record "33020428";
        SalesInvHdr: Record "112";
        ItemSubstitution: Record "5715";
        CustomerLedger: Record "21";
        DocumentType: Integer;
        CompName: Integer;

    [Scope('Internal')]
    procedure Initialize(var NewDealerIntegrationService: Codeunit "33020507")
    begin
        DealerIntegrationService := NewDealerIntegrationService;
    end;

    [Scope('Internal')]
    procedure SetMake(NewMake: Record "25006000")
    begin
        Make := NewMake;
        IntegrationType := IntegrationType::Make
    end;

    [Scope('Internal')]
    procedure SetModel(NewModel: Record "25006001")
    begin
        Model := NewModel;
        IntegrationType := IntegrationType::Model
    end;

    [Scope('Internal')]
    procedure SetModelVersion(NewModelVersion: Record "27")
    begin
        ModelVersion := NewModelVersion;
        IntegrationType := IntegrationType::"Model Version"
    end;

    [Scope('Internal')]
    procedure SetItem(NewItem: Record "27")
    begin
        Item := NewItem;
        IntegrationType := IntegrationType::Item
    end;

    [Scope('Internal')]
    procedure SetItemPrice(NewItemPrice: Record "7002")
    begin
        ItemSalesPrice := NewItemPrice;
        IntegrationType := IntegrationType::"Item Price";
    end;

    [Scope('Internal')]
    procedure SetVehicle(NewVehicle: Record "25006005")
    begin
        Vehicle := NewVehicle;
        IntegrationType := IntegrationType::Vehicle;
    end;

    [Scope('Internal')]
    procedure SetModelVersionPrice(NewModelVersionPrice: Record "7002")
    begin
        ModelVersionPrice := NewModelVersionPrice;
        IntegrationType := IntegrationType::"Model Version Price";
    end;

    [Scope('Internal')]
    procedure SetInventoryPostingGroup(NewInventoryPostingGroup: Record "94")
    begin
        InventoryPostingGroup := NewInventoryPostingGroup;
        IntegrationType := IntegrationType::"Inv. Posting Group"
    end;

    [Scope('Internal')]
    procedure SetGenProductPostingGroup(NewGenProductPostingGroup: Record "251")
    begin
        GenProductPostingGroup := NewGenProductPostingGroup;
        IntegrationType := IntegrationType::"Gen. Prod. Posting Group"
    end;

    [Scope('Internal')]
    procedure SetVATProductPostingGroup(NewVATProductPostingGroup: Record "324")
    begin
        VATProductPostingGroup := NewVATProductPostingGroup;
        IntegrationType := IntegrationType::"VAT Prod. Posting Group"
    end;

    [Scope('Internal')]
    procedure SetItemTrackingCode(NewSetItemTrackingCode: Record "6502")
    begin
        ItemTrackingCode := NewSetItemTrackingCode;
        IntegrationType := IntegrationType::"Item Tracking Code";
    end;

    [Scope('Internal')]
    procedure SetUnitofMeasure(NewUnitofMeasure: Record "204")
    begin
        UnitofMeasure := NewUnitofMeasure;
        IntegrationType := IntegrationType::"Unit of Measure"
    end;

    [Scope('Internal')]
    procedure SetCustomerPriceGroup(NewCustomerPriceGroup: Record "6")
    begin
        CustomerPriceGroup := NewCustomerPriceGroup;
        IntegrationType := IntegrationType::"Customer Price Group"
    end;

    [Scope('Internal')]
    procedure SetChartOfAccounts(NewChartOfAccount: Record "15")
    begin
        ChartOfAccounts := NewChartOfAccount;
        IntegrationType := IntegrationType::"Chart of Accounts"
    end;

    [Scope('Internal')]
    procedure SetResources(NewResource: Record "25006121")
    begin
        Resource := NewResource;
        IntegrationType := IntegrationType::Resources
    end;

    [Scope('Internal')]
    procedure SetResourcesPrice(NewResourcePrice: Record "25006121")
    begin
        ResourcePrice := NewResourcePrice;
        IntegrationType := IntegrationType::"Resource Price"
    end;

    [Scope('Internal')]
    procedure SetItemVariants(NewItemVariants: Record "5401")
    begin
        ItemVariants := NewItemVariants;
        IntegrationType := IntegrationType::"Item Variants"
    end;

    [Scope('Internal')]
    procedure SetDealerInvoiceHeader()
    begin
        IntegrationType := IntegrationType::"Dealer Invoice Header";
    end;

    [Scope('Internal')]
    procedure SetDealerInvoiceLine()
    begin
        IntegrationType := IntegrationType::"Dealer Invoice Lines";
    end;

    [Scope('Internal')]
    procedure SetDealerCrMemoHeader()
    begin
        IntegrationType := IntegrationType::"Dealer Cr.Memo Header";
    end;

    [Scope('Internal')]
    procedure SetDealerCrMemoLine()
    begin
        IntegrationType := IntegrationType::"Dealer Cr.Memo Lines";
    end;

    [Scope('Internal')]
    procedure SetDealerItemLedgerEntry()
    begin
        IntegrationType := IntegrationType::"Item Ledger Entry";
    end;

    [Scope('Internal')]
    procedure SetDealerContact()
    begin
        IntegrationType := IntegrationType::"Dealer Contact";
    end;

    [Scope('Internal')]
    procedure SetDealerCustomer()
    begin
        IntegrationType := IntegrationType::"Dealer Customer";
    end;

    [Scope('Internal')]
    procedure SetDealerInformation(_DealerInformation: Record "33020428")
    begin
        DealerInformation := _DealerInformation;
    end;

    [Scope('Internal')]
    procedure EnqueueSalesDoc(var DocNo: Code[20])
    var
        DealerIntegrationSetup: Record "33020427";
        JobQueueEntry: Record "472";
        DealerInformation: Record "33020428";
        SalesInvoiceHeader: Record "112";
        Customer: Record "18";
        RecRef: RecordRef;
        JobQueueTxt: Label 'JOBQUEUE';
    begin
        SalesInvoiceHeader.GET(DocNo);
        Customer.GET(SalesInvoiceHeader."Bill-to Customer No.");
        IF Customer."E-Mail" = '' THEN
            EXIT;
        IF NOT DealerInformation.GET(SalesInvoiceHeader."Bill-to Customer No.") THEN
            EXIT;
        IF NOT DealerIntegrationSetup.READPERMISSION THEN
            EXIT;

        IF DealerIntegrationSetup.GET THEN BEGIN
            IF NOT DealerIntegrationSetup."Sync Sales Data To Dealer" THEN
                EXIT;

            SalesInvoiceHeader."Sync Status" := SalesInvoiceHeader."Sync Status"::"Scheduled for Sync";
            SalesInvoiceHeader."Sync Queue Entry ID" := CREATEGUID;
            SalesInvoiceHeader.MODIFY;

            RecRef.GETTABLE(SalesInvoiceHeader);
            JobQueueEntry.ID := SalesInvoiceHeader."Sync Queue Entry ID";
            JobQueueEntry."Object Type to Run" := JobQueueEntry."Object Type to Run"::Codeunit;
            JobQueueEntry."Object ID to Run" := CODEUNIT::"Dealer Purchase Integration";
            JobQueueEntry."Record ID to Process" := RecRef.RECORDID;
            JobQueueEntry."Job Queue Category Code" := '';
            JobQueueEntry."Parameter String" := JobQueueTxt;
            JobQueueEntry."Timeout (sec.)" := 7200;
            JobQueueEntry."Run in User Session" := FALSE;
            JobQueueEntry.Priority := 1000;
            JobQueueEntry.Description :=
              COPYSTR(STRSUBSTNO(Text000, SalesInvoiceHeader."No."), 1, MAXSTRLEN(JobQueueEntry.Description));
            JobQueueEntry."Notify On Success" := FALSE;
            JobQueueEntry."User ID" := DealerIntegrationSetup."Elevated Privileges";
            JobQueueEntry."Earliest Start Date/Time" := CURRENTDATETIME;
            CODEUNIT.RUN(CODEUNIT::"Job Queue - Enqueue", JobQueueEntry);
            MESSAGE('Email Sent Successfully.');
        END;
    end;

    [TryFunction]
    [Scope('Internal')]
    procedure SendSalesDoc(var SalesInvoiceHeader: Record "112")
    begin
        SalesInvoiceHeader.SendRecords;
    end;

    [Scope('Internal')]
    procedure Synchronize()
    begin
        DealerIntegrationSetup.GET;
        CASE IntegrationType OF
            IntegrationType::Make:
                SynchronizeMake;
            IntegrationType::Model:
                SynchronizeModel;
            IntegrationType::"Model Version":
                SynchronizeModelVersion;
            IntegrationType::Item:
                SynchronizeItem;
            IntegrationType::"Item Price":
                SynchronizeItemPrice;
            IntegrationType::"Model Version Price":
                SynchronizeModelVersionPrice;
            IntegrationType::Vehicle:
                SynchronizeVehicle;
            IntegrationType::"Inv. Posting Group":
                SynchronizeInvPostingGroup;
            IntegrationType::"Gen. Prod. Posting Group":
                SynchronizeGenProdPostingGroup;
            IntegrationType::"VAT Prod. Posting Group":
                SynchronizeVATProdPostingGroup;
            IntegrationType::"Item Tracking Code":
                SynchronizeItemTrackingCode;
            IntegrationType::"Unit of Measure":
                SynchronizeUnitOfMeasure;
            IntegrationType::"Customer Price Group":
                SynchronizeCustomerPriceGroup;
            IntegrationType::"Chart of Accounts":
                SynchronizeChartOfAccounts;
            IntegrationType::Resources:
                SynchronizeResources;
            IntegrationType::"Resource Price":
                SynchronizeResourcesPrice;
            IntegrationType::"Item Variants":
                SynchronizeItemVariants;
            IntegrationType::"Dealer Invoice Header":
                SynchronizeDealerInvoiceHeader;
            IntegrationType::"Dealer Invoice Lines":
                SynchronizeDealerInvoiceLine;
            IntegrationType::"Dealer Cr.Memo Header":
                SynchronizeDealerCrMemoHeader;
            IntegrationType::"Dealer Cr.Memo Lines":
                SynchronizeDealerCrMemoLine;
            IntegrationType::"Item Ledger Entry":
                SynchronizeDealerItemLedgerEntry;
            IntegrationType::"Sales Header":
                SynchronizeSalesInvoice;
            IntegrationType::"Item Substitution":
                SynchronizeItemSubstitution;//aakrista 3/10/2022
            IntegrationType::"Customer Ledger":
                SynchronizeCustomerLedger;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeMake()
    begin
        INIT;
        SETFILTER('Code', '''' + Make.Code + '''');
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            SETVALUE('Code', Make.Code);
            SETVALUE('Description', Make.Name);
            CREATE;
        END ELSE BEGIN
            SETVALUE('Description', Make.Name);
            UPDATE;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeModel()
    begin
        INIT;
        SETFILTER('Item_Category_Code', '''' + Model."Make Code" + '''');
        SETFILTER('Code', '''' + Model.Code + '''');
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            SETVALUE('Item_Category_Code', Model."Make Code");
            SETVALUE('Code', Model.Code);
            SETVALUE('Description', Model."Commercial Name");
            CREATE;
        END ELSE BEGIN
            SETVALUE('Description', Model."Commercial Name");
            UPDATE;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeModelVersion()
    begin
        INIT;
        SETFILTER('No', '''' + ModelVersion."No." + '''');
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            SETVALUE('No', ModelVersion."No.");
            SETVALUE('Item_Category_Code', ModelVersion."Make Code");
            SETVALUE('Product_Group_Code', ModelVersion."Model Code");
            SETVALUE('Description', ModelVersion.Description);
            SETVALUE('Item_Type', 2);
            SETVALUE('Item_Tracking_Code', ModelVersion."Item Tracking Code");
            SETVALUE('Inventory_Posting_Group', ModelVersion."Inventory Posting Group");
            SETVALUE('Gen_Prod_Posting_Group', ModelVersion."Gen. Prod. Posting Group");
            SETVALUE('VAT_Prod_Posting_Group', ModelVersion."VAT Prod. Posting Group");
            CREATE;
            SETVALUE('Costing_Method', 2);
            SETVALUE('Base_Unit_of_Measure', ModelVersion."Base Unit of Measure");
            SETVALUE('Sales_Unit_of_Measure', ModelVersion."Sales Unit of Measure");
            SETVALUE('Purch_Unit_of_Measure', ModelVersion."Purch. Unit of Measure");
            /*
            SETVALUE('First_Service_Claim_Amount',ModelVersion."1st Service Claim Amount");
            SETVALUE('Second_Service_Claim_Amount',ModelVersion."2nd Service Claim Amount");
            SETVALUE('Third_Service_Claim_Amount',ModelVersion."3rd Service Claim Amount");
            SETVALUE('Fourth_Service_Claim_Amount',ModelVersion."4th Service Claim Amount");
            SETVALUE('Additional_Service_Amount',ModelVersion."Additional Service Amount");
            SETVALUE('PDI_Claim_Amount',ModelVersion."PDI Claim Amount");
            */
            UPDATE;
        END ELSE BEGIN
            SETVALUE('Item_Category_Code', ModelVersion."Make Code");
            SETVALUE('Product_Group_Code', ModelVersion."Model Code");
            SETVALUE('Description', ModelVersion.Description);
            SETVALUE('Item_Type', 2);
            SETVALUE('Item_Tracking_Code', ModelVersion."Item Tracking Code");
            UPDATE;
            SETVALUE('Costing_Method', 2);
            SETVALUE('Inventory_Posting_Group', ModelVersion."Inventory Posting Group");
            SETVALUE('Gen_Prod_Posting_Group', ModelVersion."Gen. Prod. Posting Group");
            SETVALUE('VAT_Prod_Posting_Group', ModelVersion."VAT Prod. Posting Group");
            SETVALUE('Base_Unit_of_Measure', ModelVersion."Base Unit of Measure");
            SETVALUE('Sales_Unit_of_Measure', ModelVersion."Sales Unit of Measure");
            SETVALUE('Purch_Unit_of_Measure', ModelVersion."Purch. Unit of Measure");
            /*
            SETVALUE('First_Service_Claim_Amount',ModelVersion."1st Service Claim Amount");
            SETVALUE('Second_Service_Claim_Amount',ModelVersion."2nd Service Claim Amount");
            SETVALUE('Third_Service_Claim_Amount',ModelVersion."3rd Service Claim Amount");
            SETVALUE('Fourth_Service_Claim_Amount',ModelVersion."4th Service Claim Amount");
            SETVALUE('Additional_Service_Amount',ModelVersion."Additional Service Amount");
            SETVALUE('PDI_Claim_Amount',ModelVersion."PDI Claim Amount");
            */
            UPDATE;
        END;

    end;

    [Scope('Internal')]
    procedure SynchronizeItem()
    var
        ABC: Integer;
    begin
        INIT;
        SETFILTER('No', '''' + Item."No." + '''');
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            SETVALUE('No', Item."No.");
            SETVALUE('Description', Item.Description);
            SETVALUE('Item_Type', 1);
            SETVALUE('Inventory_Posting_Group', Item."Inventory Posting Group");
            SETVALUE('Gen_Prod_Posting_Group', Item."Gen. Prod. Posting Group");
            SETVALUE('VAT_Prod_Posting_Group', Item."VAT Prod. Posting Group");
            CASE Item.ABC OF
                Item.ABC::" ":
                    BEGIN
                        ABC := 0;
                    END;
                Item.ABC::A:
                    BEGIN
                        ABC := 1;
                    END;
                Item.ABC::B:
                    BEGIN
                        ABC := 2;
                    END;
                Item.ABC::C:
                    BEGIN
                        ABC := 3;
                    END;
                Item.ABC::D:
                    BEGIN
                        ABC := 4;
                    END;
                Item.ABC::E:
                    BEGIN
                        ABC := 5;
                    END;
            END;
            SETVALUE('ABC', ABC); //Min 6.13.2020
            IF Item.Type = Item.Type::Service THEN
                SETVALUE('Type', 1);
            CREATE;
            SETVALUE('Costing_Method', 0);
            SETVALUE('Base_Unit_of_Measure', Item."Base Unit of Measure");
            SETVALUE('Sales_Unit_of_Measure', Item."Sales Unit of Measure");
            SETVALUE('Purch_Unit_of_Measure', Item."Purch. Unit of Measure");
            SETVALUE('Blocked', Item.Blocked);
            UPDATE;
        END ELSE BEGIN
            SETVALUE('Description', Item.Description);
            SETVALUE('Item_Type', 1);
            SETVALUE('Costing_Method', 0);
            SETVALUE('Inventory_Posting_Group', Item."Inventory Posting Group");
            SETVALUE('Gen_Prod_Posting_Group', Item."Gen. Prod. Posting Group");
            SETVALUE('VAT_Prod_Posting_Group', Item."VAT Prod. Posting Group");
            CASE Item.ABC OF
                Item.ABC::" ":
                    BEGIN
                        ABC := 0;
                    END;
                Item.ABC::A:
                    BEGIN
                        ABC := 1;
                    END;
                Item.ABC::B:
                    BEGIN
                        ABC := 2;
                    END;
                Item.ABC::C:
                    BEGIN
                        ABC := 3;
                    END;
                Item.ABC::D:
                    BEGIN
                        ABC := 4;
                    END;
                Item.ABC::E:
                    BEGIN
                        ABC := 5;
                    END;
            END;
            SETVALUE('ABC', ABC); //Min 6.13.2020
            IF Item.Type = Item.Type::Service THEN
                SETVALUE('Type', 1);
            SETVALUE('Base_Unit_of_Measure', Item."Base Unit of Measure");
            SETVALUE('Sales_Unit_of_Measure', Item."Sales Unit of Measure");
            SETVALUE('Purch_Unit_of_Measure', Item."Purch. Unit of Measure");
            SETVALUE('Blocked', Item.Blocked);
            UPDATE;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeItemPrice()
    var
        StartingDate: Date;
        PriceInclVAT: Boolean;
        EndingDate: Date;
        SalesType: Integer;
    begin
        SalesType := 0;
        IF ItemSalesPrice."Sales Type" = ItemSalesPrice."Sales Type"::"Customer Price Group" THEN
            SalesType := 1
        ELSE
            IF ItemSalesPrice."Sales Type" = ItemSalesPrice."Sales Type"::"All Customers" THEN
                SalesType := 2;

        IF (ItemSalesPrice."Item No." = '') OR (SalesType = 0) THEN
            EXIT;
        EVALUATE(StartingDate, FORMAT(ItemSalesPrice."Starting Date"));
        EVALUATE(EndingDate, FORMAT(ItemSalesPrice."Ending Date"));
        EVALUATE(PriceInclVAT, FORMAT(ItemSalesPrice."Price Includes VAT"));


        INIT;
        SETFILTER('Item_No', '''' + ItemSalesPrice."Item No." + '''');
        SETFILTER('Sales_Type', FORMAT(SalesType));
        SETFILTER('Sales_Code', ItemSalesPrice."Sales Code");
        IF ItemSalesPrice."Starting Date" = 0D THEN
            SETFILTER('Starting_Date', FORMAT(ItemSalesPrice."Starting Date"))
        ELSE
            SETFILTER('Starting_Date', FORMAT(ItemSalesPrice."Starting Date"));

        SETFILTER('Currency_Code', ItemSalesPrice."Currency Code");
        SETFILTER('Variant_Code', '''' + ItemSalesPrice."Variant Code" + '''');
        SETFILTER('Unit_of_Measure_Code', '''' + ItemSalesPrice."Unit of Measure Code" + '''');
        SETFILTER('Minimum_Quantity', FORMAT(ItemSalesPrice."Minimum Quantity"));
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            SETVALUE('Item_No', ItemSalesPrice."Item No.");
            SETVALUE('Sales_Type', SalesType);
            IF ItemSalesPrice."Sales Code" <> '' THEN
                SETVALUE('Sales_Code', ItemSalesPrice."Sales Code");
            IF ItemSalesPrice."Starting Date" = 0D THEN
                SETVALUE('Starting_Date', ItemSalesPrice."Starting Date")
            ELSE
                SETVALUE('Starting_Date', ItemSalesPrice."Starting Date" + 1);
            IF ItemSalesPrice."Currency Code" <> '' THEN
                SETVALUE('Currency_Code', ItemSalesPrice."Currency Code");
            IF ItemSalesPrice."Variant Code" <> '' THEN
                SETVALUE('Variant_Code', ItemSalesPrice."Variant Code");
            IF ItemSalesPrice."Unit of Measure Code" <> '' THEN
                SETVALUE('Unit_of_Measure_Code', ItemSalesPrice."Unit of Measure Code");
            IF ItemSalesPrice."Minimum Quantity" <> 0 THEN
                SETVALUE('Minimum_Quantity', FORMAT(ItemSalesPrice."Minimum Quantity"));
            SETVALUE('Unit_Price', FORMAT(ItemSalesPrice."Unit Price"));
            EVALUATE(PriceInclVAT, FORMAT(ItemSalesPrice."Price Includes VAT"));
            SETVALUE('Price_Includes_VAT', PriceInclVAT);
            IF ItemSalesPrice."Ending Date" = 0D THEN
                SETVALUE('Ending_Date', ItemSalesPrice."Ending Date")
            ELSE
                SETVALUE('Ending_Date', ItemSalesPrice."Ending Date" + 1);

            CREATE;
        END ELSE BEGIN
            SETVALUE('Unit_Price', FORMAT(ItemSalesPrice."Unit Price"));
            EVALUATE(PriceInclVAT, FORMAT(ItemSalesPrice."Price Includes VAT"));
            SETVALUE('Price_Includes_VAT', PriceInclVAT);
            IF ItemSalesPrice."Ending Date" = 0D THEN
                SETVALUE('Ending_Date', ItemSalesPrice."Ending Date")
            ELSE
                SETVALUE('Ending_Date', ItemSalesPrice."Ending Date" + 1);

            UPDATE;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeModelVersionPrice()
    var
        StartingDate: Date;
        PriceInclVAT: Boolean;
        EndingDate: Date;
        SalesType: Integer;
    begin
        SalesType := 0;
        IF ModelVersionPrice."Sales Type" = ModelVersionPrice."Sales Type"::"Customer Price Group" THEN
            SalesType := 1
        ELSE
            IF ModelVersionPrice."Sales Type" = ModelVersionPrice."Sales Type"::"All Customers" THEN
                SalesType := 2;

        IF (ModelVersionPrice."Item No." = '') OR (SalesType = 0) THEN
            EXIT;

        EVALUATE(StartingDate, FORMAT(ModelVersionPrice."Starting Date"));
        EVALUATE(EndingDate, FORMAT(ModelVersionPrice."Ending Date"));
        EVALUATE(PriceInclVAT, FORMAT(ModelVersionPrice."Price Includes VAT"));

        INIT;
        SETFILTER('Item_No', '''' + ModelVersionPrice."Item No." + '''');
        SETFILTER('Sales_Type', FORMAT(SalesType));
        SETFILTER('Sales_Code', '''' + ModelVersionPrice."Sales Code" + '''');
        IF ModelVersionPrice."Starting Date" = 0D THEN
            SETFILTER('Starting_Date', FORMAT(ModelVersionPrice."Starting Date"))
        ELSE
            SETFILTER('Starting_Date', FORMAT(ModelVersionPrice."Starting Date"));
        SETFILTER('Currency_Code', ModelVersionPrice."Currency Code");
        SETFILTER('Variant_Code', '''' + ModelVersionPrice."Variant Code" + '''');
        SETFILTER('Unit_of_Measure_Code', '''' + ModelVersionPrice."Unit of Measure Code" + '''');
        SETFILTER('Minimum_Quantity', FORMAT(ModelVersionPrice."Minimum Quantity"));
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            SETVALUE('Item_No', ModelVersionPrice."Item No.");
            SETVALUE('Sales_Type', SalesType);
            IF ModelVersionPrice."Sales Code" <> '' THEN
                SETVALUE('Sales_Code', ModelVersionPrice."Sales Code");
            IF ModelVersionPrice."Starting Date" = 0D THEN
                SETVALUE('Starting_Date', ModelVersionPrice."Starting Date")
            ELSE
                SETVALUE('Starting_Date', ModelVersionPrice."Starting Date" + 1);
            IF ModelVersionPrice."Currency Code" <> '' THEN
                SETVALUE('Currency_Code', ModelVersionPrice."Currency Code");
            IF ModelVersionPrice."Variant Code" <> '' THEN
                SETVALUE('Variant_Code', ModelVersionPrice."Variant Code");
            IF ModelVersionPrice."Unit of Measure Code" <> '' THEN
                SETVALUE('Unit_of_Measure_Code', ModelVersionPrice."Unit of Measure Code");
            IF ModelVersionPrice."Minimum Quantity" <> 0 THEN
                SETVALUE('Minimum_Quantity', FORMAT(ModelVersionPrice."Minimum Quantity"));
            SETVALUE('Unit_Price', FORMAT(ModelVersionPrice."Unit Price"));
            EVALUATE(PriceInclVAT, FORMAT(ModelVersionPrice."Price Includes VAT"));
            SETVALUE('Price_Includes_VAT', PriceInclVAT);
            IF ModelVersionPrice."Ending Date" = 0D THEN
                SETVALUE('Ending_Date', ModelVersionPrice."Ending Date")
            ELSE
                SETVALUE('Ending_Date', ModelVersionPrice."Ending Date" + 1);
            CREATE;
        END ELSE BEGIN
            SETVALUE('Unit_Price', FORMAT(ModelVersionPrice."Unit Price"));
            EVALUATE(PriceInclVAT, FORMAT(ModelVersionPrice."Price Includes VAT"));
            SETVALUE('Price_Includes_VAT', PriceInclVAT);
            IF ModelVersionPrice."Ending Date" = 0D THEN
                SETVALUE('Ending_Date', ModelVersionPrice."Ending Date")
            ELSE
                SETVALUE('Ending_Date', ModelVersionPrice."Ending Date" + 1);
            UPDATE;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeVehicle()
    var
        Model: Record "25006001";
    begin
        IF (Vehicle.VIN = '') OR (Vehicle."Model Version No." = '') THEN
            EXIT;
        INIT;
        SETFILTER('Item_No', '''' + Vehicle."Model Version No." + '''');
        //SETFILTER('Variant_Code',Vehicle."Variant Code");
        SETFILTER('Serial_No', Vehicle.VIN);
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            SETVALUE('Serial_No', Vehicle.VIN);
            SETVALUE('VIN', Vehicle.VIN);
            SETVALUE('Principal_Serial_No', Vehicle.VIN);
            SETVALUE('Make_Code', Vehicle."Make Code");
            SETVALUE('Model_Code', Vehicle."Model Code");
            SETVALUE('Item_No', Vehicle."Model Version No.");
            SETVALUE('Sales_Date', Vehicle."Sales Date"); //Min
            IF Model.GET(Vehicle."Make Code", Vehicle."Model Code") THEN
                SETVALUE('Model_Commercial_Name', Model."Commercial Name");
            SETVALUE('Registration_No', Vehicle."Registration No.");
            SETVALUE('Engine_No', Vehicle."Engine No.");
            Vehicle.CALCFIELDS("Variant Code");
            IF Vehicle."Variant Code" <> '' THEN BEGIN
                SETVALUE('Variant_Code', Vehicle."Variant Code")
            END ELSE
                SETVALUE('Variant_Code', Vehicle."VC No.");
            IF (Vehicle."Model Version No." <> '') AND (Vehicle.VIN <> '') THEN
                CREATE;
        END ELSE BEGIN
            SETVALUE('VIN', Vehicle.VIN);
            SETVALUE('Principal_Serial_No', Vehicle.VIN);
            SETVALUE('Make_Code', Vehicle."Make Code");
            SETVALUE('Model_Code', Vehicle."Model Code");
            IF Model.GET(Vehicle."Make Code", Vehicle."Model Code") THEN
                SETVALUE('Model_Commercial_Name', Model."Commercial Name");
            SETVALUE('Registration_No', Vehicle."Registration No.");
            SETVALUE('Engine_No', Vehicle."Engine No.");
            SETVALUE('Sales_Date', Vehicle."Sales Date"); //Min
            Vehicle.CALCFIELDS("Variant Code");
            IF Vehicle."Variant Code" <> '' THEN BEGIN
                SETVALUE('Variant_Code', Vehicle."Variant Code");
            END ELSE
                SETVALUE('Variant_Code', Vehicle."VC No.");
            UPDATE;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeInvPostingGroup()
    begin
        INIT;
        SETFILTER('Code', '''' + InventoryPostingGroup.Code + '''');
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            SETVALUE('Code', InventoryPostingGroup.Code);
            SETVALUE('Description', InventoryPostingGroup.Description);
            CREATE;
        END ELSE BEGIN
            SETVALUE('Description', InventoryPostingGroup.Description);
            UPDATE;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeGenProdPostingGroup()
    begin
        INIT;
        SETFILTER('Code', '''' + GenProductPostingGroup.Code + '''');
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            SETVALUE('Code', GenProductPostingGroup.Code);
            SETVALUE('Description', GenProductPostingGroup.Description);
            CREATE;
        END ELSE BEGIN
            SETVALUE('Description', GenProductPostingGroup.Description);
            UPDATE;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeVATProdPostingGroup()
    begin
        INIT;
        SETFILTER('Code', '''' + VATProductPostingGroup.Code + '''');
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            SETVALUE('Code', VATProductPostingGroup.Code);
            SETVALUE('Description', VATProductPostingGroup.Description);
            CREATE;
        END ELSE BEGIN
            SETVALUE('Description', VATProductPostingGroup.Description);
            UPDATE;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeUnitOfMeasure()
    begin
        INIT;
        SETFILTER('Code', '''' + UnitofMeasure.Code + '''');
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            SETVALUE('Code', UnitofMeasure.Code);
            SETVALUE('Description', UnitofMeasure.Description);
            CREATE;
        END ELSE BEGIN
            SETVALUE('Description', UnitofMeasure.Description);
            UPDATE;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeItemTrackingCode()
    begin
        INIT;
        SETFILTER('Code', '''' + ItemTrackingCode.Code + '''');
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            SETVALUE('Code', ItemTrackingCode.Code);
            SETVALUE('Description', ItemTrackingCode.Description);
            SETVALUE('SN_Specific_Tracking', ItemTrackingCode."SN Specific Tracking");
            SETVALUE('Lot_Specific_Tracking', ItemTrackingCode."Lot Specific Tracking");
            CREATE;
        END ELSE BEGIN
            SETVALUE('Description', ItemTrackingCode.Description);
            SETVALUE('SN_Specific_Tracking', ItemTrackingCode."SN Specific Tracking");
            SETVALUE('Lot_Specific_Tracking', ItemTrackingCode."Lot Specific Tracking");
            UPDATE;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeCustomerPriceGroup()
    begin
        INIT;
        SETFILTER('Code', '''' + CustomerPriceGroup.Code + '''');
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            SETVALUE('Code', CustomerPriceGroup.Code);
            SETVALUE('Description', CustomerPriceGroup.Description);
            CREATE;
        END ELSE BEGIN
            SETVALUE('Description', CustomerPriceGroup.Description);
            UPDATE;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeChartOfAccounts()
    var
        DirectPosting: Boolean;
        IncomeBalance: Integer;
        AccountType: Integer;
    begin
        INIT;
        SETFILTER('No', ChartOfAccounts."No.");
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            EVALUATE(DirectPosting, FORMAT(ChartOfAccounts."Direct Posting"));
            IF ChartOfAccounts."Income/Balance" = ChartOfAccounts."Income/Balance"::"Income Statement" THEN
                IncomeBalance := 0
            ELSE
                IF ChartOfAccounts."Income/Balance" = ChartOfAccounts."Income/Balance"::"Balance Sheet" THEN
                    IncomeBalance := 1;

            CASE ChartOfAccounts."Account Type" OF
                ChartOfAccounts."Account Type"::Posting:
                    BEGIN
                        AccountType := 0;
                    END;
                ChartOfAccounts."Account Type"::Heading:
                    BEGIN
                        AccountType := 1;
                    END;
                ChartOfAccounts."Account Type"::Total:
                    BEGIN
                        AccountType := 2;
                    END;
                ChartOfAccounts."Account Type"::"Begin-Total":
                    BEGIN
                        AccountType := 3;
                    END;
                ChartOfAccounts."Account Type"::"End-Total":
                    BEGIN
                        AccountType := 4;
                    END;
            END;

            SETVALUE('No', ChartOfAccounts."No.");
            SETVALUE('Name', ChartOfAccounts.Name);
            SETVALUE('Income_Balance', IncomeBalance);
            SETVALUE('Direct_Posting', DirectPosting);
            SETVALUE('Account_Type', AccountType);

            CREATE;
        END ELSE BEGIN
            EVALUATE(DirectPosting, FORMAT(ChartOfAccounts."Direct Posting"));
            IF ChartOfAccounts."Income/Balance" = ChartOfAccounts."Income/Balance"::"Income Statement" THEN
                IncomeBalance := 0
            ELSE
                IF ChartOfAccounts."Income/Balance" = ChartOfAccounts."Income/Balance"::"Balance Sheet" THEN
                    IncomeBalance := 1;

            CASE ChartOfAccounts."Account Type" OF
                ChartOfAccounts."Account Type"::Posting:
                    BEGIN
                        AccountType := 0;
                    END;
                ChartOfAccounts."Account Type"::Heading:
                    BEGIN
                        AccountType := 1;
                    END;
                ChartOfAccounts."Account Type"::Total:
                    BEGIN
                        AccountType := 2;
                    END;
                ChartOfAccounts."Account Type"::"Begin-Total":
                    BEGIN
                        AccountType := 3;
                    END;
                ChartOfAccounts."Account Type"::"End-Total":
                    BEGIN
                        AccountType := 4;
                    END;
            END;

            SETVALUE('Name', ChartOfAccounts.Name);
            SETVALUE('Income_Balance', FORMAT(ChartOfAccounts."Income/Balance"));
            SETVALUE('Direct_Posting', DirectPosting);
            SETVALUE('Account_Type', FORMAT(ChartOfAccounts."Account Type"));
            UPDATE;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeResources()
    begin
        INIT;
        SETFILTER('No', '''' + Resource."No." + '''');
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            SETVALUE('No', Resource."No.");
            SETVALUE('Name', Resource.Description);
            SETVALUE('Gen_Prod_Posting_Group', Resource."Gen. Prod. Posting Group");
            SETVALUE('VAT_Prod_Posting_Group', Resource."VAT Prod. Posting Group");
            CREATE;
            SETVALUE('Base_Unit_of_Measure', Resource."Base Unit of Measure");
            UPDATE;
        END ELSE BEGIN
            SETVALUE('Name', Resource.Description);
            SETVALUE('Base_Unit_of_Measure', Resource."Base Unit of Measure");
            SETVALUE('Gen_Prod_Posting_Group', Resource."Gen. Prod. Posting Group");
            SETVALUE('VAT_Prod_Posting_Group', Resource."VAT Prod. Posting Group");
            UPDATE;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeResourcesPrice()
    var
        ModelVersion: Record "27";
        Model: Record "25006001";
    begin
        /*
****Commented as resource price and resource is not used in Agni****

IF ModelVersion.GET(ResourcePrice."Model Version Code") THEN BEGIN
  IF ModelVersion."Model Code" <> '' THEN BEGIN
    Model.RESET;
    Model.SETRANGE(Code,ModelVersion."Model Code");
    IF NOT Model.FINDFIRST THEN BEGIN
      IF ResourcePrice."Model Code" <> '' THEN BEGIN
        Model.SETRANGE(Code,ResourcePrice."Model Code");
        IF Model.FINDFIRST THEN;
      END;
    END;
  END ELSE BEGIN
    IF ResourcePrice."Model Code" <> '' THEN BEGIN
      Model.RESET;
      Model.SETRANGE(Code,ResourcePrice."Model Code");
      IF Model.FINDFIRST THEN;
    END;
  END;
END ELSE BEGIN
  IF ResourcePrice."Model Code" <> '' THEN BEGIN
    Model.RESET;
    Model.SETRANGE(Code,ResourcePrice."Model Code");
    IF Model.FINDFIRST THEN;
  END;
END;
INIT;
SETFILTER('Make_Code',''''+Model."Make Code"+'''');
SETFILTER('Model_Code',''''+Model.Code+'''');
SETFILTER('Model_Version_No',''''+ResourcePrice."Model Version Code"+'''');
SETFILTER('Type',FORMAT(0));
SETFILTER('Code',''''+ResourcePrice.Code+'''');
IF NOT READMULTIPLE THEN BEGIN
  INIT;
  IF Model."Make Code" <> '' THEN
    SETVALUE('Make_Code',Model."Make Code");
  IF Model.Code <> '' THEN
    SETVALUE('Model_Code',Model.Code);
  IF ResourcePrice."Model Version Code" <> '' THEN
    SETVALUE('Model_Version_No',ResourcePrice."Model Version Code");
  SETVALUE('Type',0);
  SETVALUE('Code',ResourcePrice.Code);
  SETVALUE('Unit_Price',ResourcePrice."Unit Price");
  CREATE;
END ELSE BEGIN
  SETVALUE('Unit_Price',ResourcePrice."Unit Price");
  UPDATE;
END;
*/
        IF ModelVersion.GET(ResourcePrice."Model Version No.") THEN BEGIN
            IF ModelVersion."Model Code" <> '' THEN BEGIN
                Model.RESET;
                Model.SETRANGE(Code, ModelVersion."Model Code");
                IF NOT Model.FINDFIRST THEN BEGIN
                    IF Resource."Model Code" <> '' THEN BEGIN
                        Model.SETRANGE(Code, ResourcePrice."Model Code");
                        IF Model.FINDFIRST THEN;
                    END;
                END;
            END ELSE BEGIN
                IF Resource."Model Code" <> '' THEN BEGIN
                    Model.RESET;
                    Model.SETRANGE(Code, ResourcePrice."Model Code");
                    IF Model.FINDFIRST THEN;
                END;
            END;
        END ELSE BEGIN
            IF Resource."Model Code" <> '' THEN BEGIN
                Model.RESET;
                Model.SETRANGE(Code, ResourcePrice."Model Code");
                IF Model.FINDFIRST THEN;
            END;
        END;
        INIT;
        SETFILTER('Make_Code', '''' + Model."Make Code" + '''');
        SETFILTER('Model_Code', '''' + Model.Code + '''');
        SETFILTER('Model_Version_No', '''' + ResourcePrice."Model Version No." + '''');
        SETFILTER('Type', FORMAT(0));
        SETFILTER('Code', '''' + ResourcePrice."No." + '''');
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            IF Model."Make Code" <> '' THEN
                SETVALUE('Make_Code', Model."Make Code");
            IF Model.Code <> '' THEN
                SETVALUE('Model_Code', Model.Code);
            IF Resource."Model Version No." <> '' THEN
                SETVALUE('Model_Version_No', ResourcePrice."Model Version No.");
            SETVALUE('Type', 0);
            SETVALUE('Code', ResourcePrice."No.");
            SETVALUE('Unit_Price', ResourcePrice."Unit Price");
            CREATE;
        END ELSE BEGIN
            SETVALUE('Unit_Price', ResourcePrice."Unit Price");
            UPDATE;
        END;

    end;

    [Scope('Internal')]
    procedure SynchronizeItemVariants()
    begin
        INIT;
        SETFILTER('Item_No', '''' + ItemVariants."Item No." + '''');
        SETFILTER('Code', '''' + ItemVariants.Code + '''');
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            SETVALUE('Item_No', ItemVariants."Item No.");
            SETVALUE('Code', ItemVariants.Code);
            SETVALUE('Description', ItemVariants.Description);
            SETVALUE('Description_2', ItemVariants."Description 2");
            CREATE;
        END ELSE BEGIN
            SETVALUE('Description', ItemVariants.Description);
            SETVALUE('Description_2', ItemVariants."Description 2");
            UPDATE;
        END;
    end;

    [Scope('Internal')]
    procedure SynchronizeDealerInvoiceHeader()
    var
        DealerInvoiceHeader: Record "33020433";
        WebDate: DateTime;
    begin
        INIT;
        IF READMULTIPLE THEN
            REPEAT
                DealerInvoiceHeader.INIT;
                DealerInvoiceHeader."Row Type" := DealerInvoiceHeader."Row Type"::"Document Header";
                DealerInvoiceHeader."Dealer Code" := DealerInformation."Customer No.";
                DealerInvoiceHeader."Document Type" := DealerInvoiceHeader."Document Type"::"Sales Invoice";
                DealerInvoiceHeader."Document No." := DealerIntegrationService.GETVALUE('No');
                DealerInvoiceHeader."Bill-to Customer Code" := DealerIntegrationService.GETVALUE('Bill_to_Customer_No');
                DealerInvoiceHeader."Bill-to Customer Name" := DealerIntegrationService.GETVALUE('Bill_to_Name');
                DealerInvoiceHeader."Sell-to Customer Code" := DealerIntegrationService.GETVALUE('Sell_to_Customer_No');
                DealerInvoiceHeader."Sell-To Customer Name" := DealerIntegrationService.GETVALUE('Sell_to_Customer_Name');
                DealerInvoiceHeader."Customer Address" := DealerIntegrationService.GETVALUE('Address');
                DealerInvoiceHeader."Customer Phone No." := DealerIntegrationService.GETVALUE('Phone_No');
                DealerInvoiceHeader."HMI Coupon No." := DealerIntegrationService.GETVALUE('HMI_Coupon_No');
                DealerInvoiceHeader."STC Coupon No." := DealerIntegrationService.GETVALUE('STC_Coupon_No');
                DealerInvoiceHeader."Scratch Coupon No." := DealerIntegrationService.GETVALUE('Scratch_Coupon_No');
                EVALUATE(DealerInvoiceHeader."Scratch Coupon Disc. Amount", DealerIntegrationService.GETVALUE('Scratch_Coupon_Disc_Amount'));
                CASE DealerIntegrationService.GETVALUE('Document_Profile') OF
                    '_blank_':
                        DealerInvoiceHeader."Document Profile" := DealerInvoiceHeader."Document Profile"::" ";
                    'Spare_Parts_Trade':
                        DealerInvoiceHeader."Document Profile" := DealerInvoiceHeader."Document Profile"::"Spare Parts Trade";
                    'Vehicles_Trade':
                        DealerInvoiceHeader."Document Profile" := DealerInvoiceHeader."Document Profile"::"Vehicles Trade";
                    ELSE
                        EVALUATE(DealerInvoiceHeader."Document Profile", DealerIntegrationService.GETVALUE('Document_Profile'));
                END;
                WebDate := 0DT;
                EVALUATE(WebDate, DealerIntegrationService.GETVALUE('Posting_Date'));
                IF WebDate <> 0DT THEN
                    DealerInvoiceHeader."Posting Date" := DT2DATE(WebDate) + 1;

                DealerInvoiceHeader.INSERT;

            UNTIL NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeDealerInvoiceLine()
    var
        DealerInvoiceHeader: Record "33020433";
        DealerInvoiceLine: Record "33020433";
        WebDate: DateTime;
    begin
        INIT;
        IF READMULTIPLE THEN
            REPEAT
                DealerInvoiceLine.INIT;
                DealerInvoiceLine."Row Type" := DealerInvoiceLine."Row Type"::"Document Lines";
                DealerInvoiceLine."Dealer Code" := DealerInformation."Customer No.";
                DealerInvoiceLine."Document Type" := DealerInvoiceLine."Document Type"::"Sales Invoice";
                DealerInvoiceLine."Document No." := DealerIntegrationService.GETVALUE('Document_No');
                EVALUATE(DealerInvoiceLine."Line No.", DealerIntegrationService.GETVALUE('Line_No'));

                CASE DealerIntegrationService.GETVALUE('Type') OF
                    '_blank_':
                        DealerInvoiceLine.Type := DealerInvoiceLine.Type::" ";
                    'G_L_Account':
                        DealerInvoiceLine.Type := DealerInvoiceLine.Type::"G/L Account";
                    ELSE
                        EVALUATE(DealerInvoiceLine.Type, DealerIntegrationService.GETVALUE('Type'));
                END;

                DealerInvoiceLine."No." := DealerIntegrationService.GETVALUE('No');
                DealerInvoiceLine."Line Description" := DealerIntegrationService.GETVALUE('Description');
                EVALUATE(DealerInvoiceLine.Quantity, DealerIntegrationService.GETVALUE('Quantity'));
                EVALUATE(DealerInvoiceLine."Unit Price", DealerIntegrationService.GETVALUE('Unit_Price'));
                EVALUATE(DealerInvoiceLine."Line Discount Amount", DealerIntegrationService.GETVALUE('Line_Discount_Amount'));
                EVALUATE(DealerInvoiceLine.Amount, DealerIntegrationService.GETVALUE('Amount'));
                EVALUATE(DealerInvoiceLine."Amount Including VAT", DealerIntegrationService.GETVALUE('Amount_Including_VAT'));
                EVALUATE(DealerInvoiceLine."Inv. Discount Amount", DealerIntegrationService.GETVALUE('Inv_Discount_Amount'));
                DealerInvoiceLine."Unit of Measure Code" := DealerIntegrationService.GETVALUE('Unit_of_Measure_Code');
                DealerInvoiceLine."Item Category Code" := DealerIntegrationService.GETVALUE('Item_Category_Code');
                DealerInvoiceLine."Make Code" := DealerIntegrationService.GETVALUE('Make_Code');
                DealerInvoiceLine."Model Code" := DealerIntegrationService.GETVALUE('Model_Code');
                DealerInvoiceLine."Model Version No." := DealerIntegrationService.GETVALUE('Model_Version_No');
                DealerInvoiceLine."Vehicle Serial No." := DealerIntegrationService.GETVALUE('Vehicle_Serial_No');
                DealerInvoiceLine."Variant Code" := DealerIntegrationService.GETVALUE('VariantCode');
                DealerInvoiceLine."Registration No." := DealerIntegrationService.GETVALUE('RegistrationNo');
                DealerInvoiceLine.INSERT;

                DealerInvoiceHeader.RESET;
                DealerInvoiceHeader.SETRANGE("Row Type", DealerInvoiceHeader."Row Type"::"Document Header");
                DealerInvoiceHeader.SETRANGE("Dealer Code", DealerInvoiceLine."Dealer Code");
                DealerInvoiceHeader.SETRANGE("Document Type", DealerInvoiceHeader."Document Type"::"Sales Invoice");
                DealerInvoiceHeader.SETRANGE("Document No.", DealerInvoiceLine."Document No.");
                DealerInvoiceHeader.SETRANGE("Line No.", 0);
                IF DealerInvoiceHeader.FINDFIRST THEN BEGIN
                    DealerInvoiceLine."Bill-to Customer Code" := DealerInvoiceHeader."Bill-to Customer Code";
                    DealerInvoiceLine."Bill-to Customer Name" := DealerInvoiceHeader."Bill-to Customer Name";
                    DealerInvoiceLine."Sell-to Customer Code" := DealerInvoiceHeader."Sell-to Customer Code";
                    DealerInvoiceLine."Sell-To Customer Name" := DealerInvoiceHeader."Sell-To Customer Name";
                    DealerInvoiceLine."Customer Address" := DealerInvoiceHeader."Customer Address";
                    DealerInvoiceLine."Customer Phone No." := DealerInvoiceHeader."Customer Phone No.";
                    DealerInvoiceLine."Document Profile" := DealerInvoiceHeader."Document Profile";
                    DealerInvoiceLine."Posting Date" := DealerInvoiceHeader."Posting Date";
                    DealerInvoiceLine.MODIFY;
                    IF DealerInvoiceHeader."Document Profile" = DealerInvoiceHeader."Document Profile"::"Vehicles Trade" THEN BEGIN
                        IF DealerInvoiceLine."Vehicle Serial No." <> '' THEN BEGIN
                            DealerInvoiceHeader."Make Code" := DealerInvoiceLine."Make Code";
                            DealerInvoiceHeader."Model Code" := DealerInvoiceLine."Model Code";
                            DealerInvoiceHeader."Model Version No." := DealerInvoiceLine."Model Version No.";
                            DealerInvoiceHeader."Vehicle Serial No." := DealerInvoiceLine."Vehicle Serial No.";
                            DealerInvoiceHeader."Variant Code" := DealerInvoiceLine."Variant Code";
                            DealerInvoiceHeader."Registration No." := DealerInvoiceLine."Registration No.";
                            DealerInvoiceHeader.MODIFY;
                        END;
                    END;
                END;
            UNTIL NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeDealerCrMemoHeader()
    var
        DealerCrMemoHeader: Record "33020433";
        WebDate: DateTime;
    begin
        INIT;
        IF READMULTIPLE THEN
            REPEAT
                DealerCrMemoHeader.INIT;
                DealerCrMemoHeader."Row Type" := DealerCrMemoHeader."Row Type"::"Document Header";
                DealerCrMemoHeader."Dealer Code" := DealerInformation."Customer No.";
                DealerCrMemoHeader."Document Type" := DealerCrMemoHeader."Document Type"::"Sales Credit Memo";
                DealerCrMemoHeader."Document No." := DealerIntegrationService.GETVALUE('No');
                DealerCrMemoHeader."Bill-to Customer Code" := DealerIntegrationService.GETVALUE('Bill_to_Customer_No');
                DealerCrMemoHeader."Bill-to Customer Name" := DealerIntegrationService.GETVALUE('Bill_to_Name');
                DealerCrMemoHeader."Sell-to Customer Code" := DealerIntegrationService.GETVALUE('Sell_to_Customer_No');
                DealerCrMemoHeader."Sell-To Customer Name" := DealerIntegrationService.GETVALUE('Sell_to_Customer_Name');
                DealerCrMemoHeader."Customer Address" := DealerIntegrationService.GETVALUE('Address');
                DealerCrMemoHeader."Customer Phone No." := DealerIntegrationService.GETVALUE('Phone_No');
                DealerCrMemoHeader."HMI Coupon No." := DealerIntegrationService.GETVALUE('HMI_Coupon_No');
                DealerCrMemoHeader."STC Coupon No." := DealerIntegrationService.GETVALUE('STC_Coupon_No');
                DealerCrMemoHeader."Scratch Coupon No." := DealerIntegrationService.GETVALUE('Scratch_Coupon_No');
                EVALUATE(DealerCrMemoHeader."Scratch Coupon Disc. Amount", DealerIntegrationService.GETVALUE('Scratch_Coupon_Disc_Amount'));
                CASE DealerIntegrationService.GETVALUE('Document_Profile') OF
                    '_blank_':
                        DealerCrMemoHeader."Document Profile" := DealerCrMemoHeader."Document Profile"::" ";
                    'Spare_Parts_Trade':
                        DealerCrMemoHeader."Document Profile" := DealerCrMemoHeader."Document Profile"::"Spare Parts Trade";
                    'Vehicles_Trade':
                        DealerCrMemoHeader."Document Profile" := DealerCrMemoHeader."Document Profile"::"Vehicles Trade";
                    ELSE
                        EVALUATE(DealerCrMemoHeader."Document Profile", DealerIntegrationService.GETVALUE('Document_Profile'));
                END;
                WebDate := 0DT;
                EVALUATE(WebDate, DealerIntegrationService.GETVALUE('Posting_Date'));
                IF WebDate <> 0DT THEN
                    DealerCrMemoHeader."Posting Date" := DT2DATE(WebDate) + 1;

                DealerCrMemoHeader.INSERT;

            UNTIL NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeDealerCrMemoLine()
    var
        DealerCrMemoHeader: Record "33020433";
        DealerCrMemoLine: Record "33020433";
        WebDate: DateTime;
    begin
        INIT;
        IF READMULTIPLE THEN
            REPEAT
                DealerCrMemoLine.INIT;
                DealerCrMemoLine."Row Type" := DealerCrMemoLine."Row Type"::"Document Lines";
                DealerCrMemoLine."Dealer Code" := DealerInformation."Customer No.";
                DealerCrMemoLine."Document Type" := DealerCrMemoLine."Document Type"::"Sales Credit Memo";
                DealerCrMemoLine."Document No." := DealerIntegrationService.GETVALUE('Document_No');
                EVALUATE(DealerCrMemoLine."Line No.", DealerIntegrationService.GETVALUE('Line_No'));

                CASE DealerIntegrationService.GETVALUE('Type') OF
                    '_blank_':
                        DealerCrMemoLine.Type := DealerCrMemoLine.Type::" ";
                    'G_L_Account':
                        DealerCrMemoLine.Type := DealerCrMemoLine.Type::"G/L Account";
                    ELSE
                        EVALUATE(DealerCrMemoLine.Type, DealerIntegrationService.GETVALUE('Type'));
                END;

                DealerCrMemoLine."No." := DealerIntegrationService.GETVALUE('No');
                DealerCrMemoLine."Line Description" := DealerIntegrationService.GETVALUE('Description');
                EVALUATE(DealerCrMemoLine.Quantity, DealerIntegrationService.GETVALUE('Quantity'));
                EVALUATE(DealerCrMemoLine."Unit Price", DealerIntegrationService.GETVALUE('Unit_Price'));
                EVALUATE(DealerCrMemoLine."Line Discount Amount", DealerIntegrationService.GETVALUE('Line_Discount_Amount'));
                EVALUATE(DealerCrMemoLine.Amount, DealerIntegrationService.GETVALUE('Amount'));
                EVALUATE(DealerCrMemoLine."Amount Including VAT", DealerIntegrationService.GETVALUE('Amount_Including_VAT'));
                EVALUATE(DealerCrMemoLine."Inv. Discount Amount", DealerIntegrationService.GETVALUE('Inv_Discount_Amount'));
                DealerCrMemoLine."Unit of Measure Code" := DealerIntegrationService.GETVALUE('Unit_of_Measure_Code');
                DealerCrMemoLine."Item Category Code" := DealerIntegrationService.GETVALUE('Item_Category_Code');
                DealerCrMemoLine."Make Code" := DealerIntegrationService.GETVALUE('Make_Code');
                DealerCrMemoLine."Model Code" := DealerIntegrationService.GETVALUE('Model_Code');
                DealerCrMemoLine."Model Version No." := DealerIntegrationService.GETVALUE('Model_Version_No');
                DealerCrMemoLine."Vehicle Serial No." := DealerIntegrationService.GETVALUE('Vehicle_Serial_No');
                DealerCrMemoLine."Variant Code" := DealerIntegrationService.GETVALUE('VariantCode');
                DealerCrMemoLine."Registration No." := DealerIntegrationService.GETVALUE('RegistrationNo');
                DealerCrMemoLine.INSERT;

                DealerCrMemoHeader.RESET;
                DealerCrMemoHeader.SETRANGE("Document Type", DealerCrMemoHeader."Document Type"::"Sales Credit Memo");
                DealerCrMemoHeader.SETRANGE("Document No.", DealerCrMemoLine."Document No.");
                DealerCrMemoHeader.SETRANGE("Line No.", 0);
                IF DealerCrMemoHeader.FINDFIRST THEN BEGIN
                    DealerCrMemoLine."Bill-to Customer Code" := DealerCrMemoHeader."Bill-to Customer Code";
                    DealerCrMemoHeader.SETRANGE("Row Type", DealerCrMemoHeader."Row Type"::"Document Header");
                    DealerCrMemoHeader.SETRANGE("Dealer Code", DealerCrMemoLine."Dealer Code");
                    DealerCrMemoLine."Bill-to Customer Name" := DealerCrMemoHeader."Bill-to Customer Name";
                    DealerCrMemoLine."Sell-to Customer Code" := DealerCrMemoHeader."Sell-to Customer Code";
                    DealerCrMemoLine."Sell-To Customer Name" := DealerCrMemoHeader."Sell-To Customer Name";
                    DealerCrMemoLine."Customer Address" := DealerCrMemoHeader."Customer Address";
                    DealerCrMemoLine."Customer Phone No." := DealerCrMemoHeader."Customer Phone No.";
                    DealerCrMemoLine."Document Profile" := DealerCrMemoHeader."Document Profile";
                    DealerCrMemoLine."Posting Date" := DealerCrMemoHeader."Posting Date";
                    DealerCrMemoLine.MODIFY;
                    IF DealerCrMemoHeader."Document Profile" = DealerCrMemoHeader."Document Profile"::"Vehicles Trade" THEN BEGIN
                        IF DealerCrMemoLine."Vehicle Serial No." <> '' THEN BEGIN
                            DealerCrMemoHeader."Make Code" := DealerCrMemoLine."Make Code";
                            DealerCrMemoHeader."Model Code" := DealerCrMemoLine."Model Code";
                            DealerCrMemoHeader."Model Version No." := DealerCrMemoLine."Model Version No.";
                            DealerCrMemoHeader."Vehicle Serial No." := DealerCrMemoLine."Vehicle Serial No.";
                            DealerCrMemoHeader."Variant Code" := DealerCrMemoLine."Variant Code";
                            DealerCrMemoHeader."Registration No." := DealerCrMemoLine."Registration No.";
                            DealerCrMemoHeader.MODIFY;
                        END;
                    END;
                END;

            UNTIL NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeDealerItemLedgerEntry()
    var
        WebDate: DateTime;
        DealerItemLedgEntry: Record "33020434";
    begin
        INIT;
        IF READMULTIPLE THEN
            REPEAT
                DealerItemLedgEntry.INIT;
                DealerItemLedgEntry."Dealer Code" := DealerInformation."Customer No.";
                EVALUATE(DealerItemLedgEntry."Entry No.", GETVALUE('Entry_No'));
                DealerItemLedgEntry."Item No." := GETVALUE('Item_No');

                WebDate := 0DT;
                EVALUATE(WebDate, GETVALUE('Posting_Date'));
                IF WebDate <> 0DT THEN
                    DealerItemLedgEntry."Posting Date" := DT2DATE(WebDate) + 1;

                CASE GETVALUE('Entry_Type') OF
                    'Purchase':
                        DealerItemLedgEntry."Entry Type" := DealerItemLedgEntry."Entry Type"::Purchase;
                    'Sale':
                        DealerItemLedgEntry."Entry Type" := DealerItemLedgEntry."Entry Type"::Sale;
                    'Positive_Adjmt':
                        DealerItemLedgEntry."Entry Type" := DealerItemLedgEntry."Entry Type"::"Positive Adjmt.";
                    'Negative_Adjmt':
                        DealerItemLedgEntry."Entry Type" := DealerItemLedgEntry."Entry Type"::"Negative Adjmt.";
                    'Transfer':
                        DealerItemLedgEntry."Entry Type" := DealerItemLedgEntry."Entry Type"::Transfer;
                    'Consumption':
                        DealerItemLedgEntry."Entry Type" := DealerItemLedgEntry."Entry Type"::Consumption;
                    'Output':
                        DealerItemLedgEntry."Entry Type" := DealerItemLedgEntry."Entry Type"::Output;
                    '_blank_':
                        DealerItemLedgEntry."Entry Type" := DealerItemLedgEntry."Entry Type"::" ";
                    'Transfer':
                        DealerItemLedgEntry."Entry Type" := DealerItemLedgEntry."Entry Type"::Transfer;
                    'Assembly_Consumption':
                        DealerItemLedgEntry."Entry Type" := DealerItemLedgEntry."Entry Type"::"Assembly Consumption";
                    'Assembly_Output':
                        DealerItemLedgEntry."Entry Type" := DealerItemLedgEntry."Entry Type"::"Assembly Output";
                    ELSE
                        EVALUATE(DealerItemLedgEntry."Entry Type", GETVALUE('Entry_Type'));
                END;

                DealerItemLedgEntry."Document No." := GETVALUE('Document_No');
                DealerItemLedgEntry.Description := GETVALUE('Description');
                EVALUATE(DealerItemLedgEntry.Quantity, GETVALUE('Quantity'));
                //EVALUATE(DealerItemLedgEntry."Remaining Quantity",GETVALUE('Remaining Quantity'));
                //EVALUATE(DealerItemLedgEntry."Invoiced Quantity",GETVALUE('Invoiced Quantity'));

                CASE GETVALUE('Document_Type') OF
                    '_blank_':
                        DealerItemLedgEntry."Document Type" := DealerItemLedgEntry."Document Type"::" ";
                    'Sales_Shipment':
                        DealerItemLedgEntry."Document Type" := DealerItemLedgEntry."Document Type"::"Sales Shipment";
                    'Sales_Invoice':
                        DealerItemLedgEntry."Document Type" := DealerItemLedgEntry."Document Type"::"Sales Invoice";
                    'Sales_Return_Receipt':
                        DealerItemLedgEntry."Document Type" := DealerItemLedgEntry."Document Type"::"Sales Return Receipt";
                    'Sales Credit Memo':
                        DealerItemLedgEntry."Document Type" := DealerItemLedgEntry."Document Type"::"Sales Credit Memo";
                    'Purchase_Receipt':
                        DealerItemLedgEntry."Document Type" := DealerItemLedgEntry."Document Type"::"Purchase Receipt";
                    'Purchase_Invoice':
                        DealerItemLedgEntry."Document Type" := DealerItemLedgEntry."Document Type"::"Purchase Invoice";
                    'Purchase_Return_Shipment':
                        DealerItemLedgEntry."Document Type" := DealerItemLedgEntry."Document Type"::"Purchase Return Shipment";
                    'Purchase_Credit_Memo':
                        DealerItemLedgEntry."Document Type" := DealerItemLedgEntry."Document Type"::"Purchase Credit Memo";
                    'Transfer_Shipment':
                        DealerItemLedgEntry."Document Type" := DealerItemLedgEntry."Document Type"::"Transfer Shipment";
                    'Transfer_Receipt':
                        DealerItemLedgEntry."Document Type" := DealerItemLedgEntry."Document Type"::"Transfer Receipt";
                    'Service_Shipment':
                        DealerItemLedgEntry."Document Type" := DealerItemLedgEntry."Document Type"::"Service Shipment";
                    'Service_Invoice':
                        DealerItemLedgEntry."Document Type" := DealerItemLedgEntry."Document Type"::"Service Invoice";
                    'Service_Credit_Memo':
                        DealerItemLedgEntry."Document Type" := DealerItemLedgEntry."Document Type"::"Service Credit Memo";
                    'Posted_Assembly':
                        DealerItemLedgEntry."Document Type" := DealerItemLedgEntry."Document Type"::"Posted Assembly";
                END;
                DealerItemLedgEntry.INSERT;
            UNTIL NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeDealerContact()
    var
        WebDate: DateTime;
        DealerContact: Record "33020435";
    begin
        INIT;
        IF READMULTIPLE THEN
            REPEAT
                DealerContact.INIT;
                DealerContact."Dealer Code" := DealerInformation."Customer No.";
                DealerContact."Prospect No." := GETVALUE('Prospect_No');
                DealerContact."Contact Name" := GETVALUE('Contact_Name');
                DealerContact."Make Code" := GETVALUE('Make_Code');
                DealerContact."Model Code" := GETVALUE('Model_Code');
                DealerContact."Model Version Code" := GETVALUE('Model_Version_Code');
                DealerContact."Preferred Color" := GETVALUE('Preferred_Color');
                EVALUATE(DealerContact.Status, GETVALUE('Status'));
                WebDate := 0DT;
                EVALUATE(WebDate, GETVALUE('Prospect_Date'));
                IF WebDate <> 0DT THEN
                    DealerContact."Prospect Date" := DT2DATE(WebDate) + 1;
                WebDate := 0DT;
                EVALUATE(WebDate, GETVALUE('Creation_Date'));
                IF WebDate <> 0DT THEN
                    DealerContact."Creation Date" := DT2DATE(WebDate) + 1;
                DealerContact.INSERT;
            UNTIL NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SynchronizeDealerCustomer()
    var
        WebDate: DateTime;
        DealerCustomer: Record "33020436";
    begin
        INIT;
        IF READMULTIPLE THEN
            REPEAT
                DealerCustomer.INIT;
                DealerCustomer."Dealer Code" := DealerInformation."Customer No.";
                DealerCustomer."No." := GETVALUE('No');
                DealerCustomer.Name := GETVALUE('Name');
                DealerCustomer."Name 2" := GETVALUE('Name_2');
                DealerCustomer.Address := GETVALUE('Address');
                DealerCustomer."Address 2" := GETVALUE('Address_2');
                DealerCustomer.City := GETVALUE('City');
                DealerCustomer."Phone No." := GETVALUE('Phone_No');
                DealerCustomer."E-Mail" := GETVALUE('E_Mail');
                DealerCustomer.INSERT;
            UNTIL NEXT = 0;
    end;

    local procedure "----AD1.00---"()
    begin
    end;

    [Scope('Internal')]
    procedure SetSalesInvoiceHeader(NewSalesInvoiceHdr: Record "112")
    begin
        SalesInvHdr := NewSalesInvoiceHdr;
        IntegrationType := IntegrationType::"Sales Header";
    end;

    [Scope('Internal')]
    procedure SynchronizeSalesInvoice()
    var
        SalesInvLine: Record "113";
    begin
        /*
INIT;
SETFILTER('Code',''''+InventoryPostingGroup.Code+'''');
IF NOT READMULTIPLE THEN BEGIN
  INIT;
  SETVALUE('Code',InventoryPostingGroup.Code);
  SETVALUE('Description',InventoryPostingGroup.Description);
  CREATE;
END ELSE BEGIN
  SETVALUE('Description',InventoryPostingGroup.Description);
  UPDATE;
END;
*/
        SalesInvLine.RESET;
        SalesInvLine.SETRANGE("Document No.", SalesInvHdr."No.");
        IF SalesInvLine.FINDSET THEN
            REPEAT
                SETFILTER('Document_No', SalesInvLine."Dealer PO No.");
                SETFILTER('Line_No', FORMAT(SalesInvLine."Dealer Line No."));
                IF READMULTIPLE THEN BEGIN
                    SETVALUE('Qty_to_Receive', FORMAT(SalesInvLine.Quantity));
                    SETVALUE('Direct_Unit_Cost', FORMAT(SalesInvLine."Unit Price"));
                    SETVALUE('Line_Discount_Amount', FORMAT(SalesInvLine."Line Discount Amount"));
                    UPDATE;
                END;
            UNTIL SalesInvLine.NEXT = 0;

    end;

    [Scope('Internal')]
    procedure SetItemSubstitution(ItemSubstitution: Record "5715")
    begin
        //;lgItemSubstitution := NewItemSubstitutions;
        IntegrationType := IntegrationType::"Item Substitution";
    end;

    [Scope('Internal')]
    procedure SynchronizeItemSubstitution()
    begin
        INIT;
        SETFILTER('Substitute_No', '''' + ItemSubstitution."Substitute No." + '''');
        //SETFILTER('Code',''''+ItemVariants.Code+'''');
        IF NOT READMULTIPLE THEN BEGIN
            INIT;
            SETVALUE('No', ItemSubstitution."No.");
            SETVALUE('Substitute_No', ItemSubstitution."Substitute No.");
            SETVALUE('Interchangeable', ItemSubstitution.Interchangeable);
            SETVALUE('Condition', ItemSubstitution.Condition);
            CREATE;
        END;
    end;

    [Scope('Internal')]
    procedure SetCustomerLedger(NewCustomerLedger: Record "21")
    begin
        CustomerLedger := NewCustomerLedger;
        IntegrationType := IntegrationType::"Customer Ledger";
    end;

    [Scope('Internal')]
    procedure SynchronizeCustomerLedger()
    var
        ComapnyInfo: Record "79";
    begin
        INIT;
        CustomerLedger.CALCFIELDS("Debit Amount (LCY)", "Credit Amount (LCY)", "Amount (LCY)");
        SETFILTER('Entry_No', '''' + FORMAT(CustomerLedger."Entry No.") + '''');
        IF DealerInformation.GET(CustomerLedger."Customer No.") THEN BEGIN
            DealerInformation.CALCFIELDS("Customer Name");
            IF DealerInformation.Active THEN BEGIN
                IF NOT READMULTIPLE THEN BEGIN
                    INIT;
                    SETVALUE('Entry_No', CustomerLedger."Entry No.");
                    SETVALUE('Posting_Date', CustomerLedger."Posting Date");
                    CASE CustomerLedger."Document Type" OF
                        CustomerLedger."Document Type"::" ":
                            BEGIN
                                DocumentType := 0;
                            END;
                        CustomerLedger."Document Type"::"Credit Memo":
                            BEGIN
                                DocumentType := 1;
                            END;
                        CustomerLedger."Document Type"::"Finance Charge Memo":
                            BEGIN
                                DocumentType := 2;
                            END;
                        CustomerLedger."Document Type"::Invoice:
                            BEGIN
                                DocumentType := 3;
                            END;
                        CustomerLedger."Document Type"::Payment:
                            BEGIN
                                DocumentType := 4;
                            END;
                        CustomerLedger."Document Type"::Refund:
                            BEGIN
                                DocumentType := 5;
                            END;
                        CustomerLedger."Document Type"::Reminder:
                            BEGIN
                                DocumentType := 6;
                            END;
                    END;
                    SETVALUE('Document_Type', DocumentType);
                    SETVALUE('Document_No', CustomerLedger."Document No.");
                    SETVALUE('Customer_No', CustomerLedger."Customer No.");
                    SETVALUE('Debit_Amount_LCY', FORMAT(CustomerLedger."Debit Amount (LCY)"));
                    SETVALUE('Credit_Amount_LCY', FORMAT(CustomerLedger."Credit Amount (LCY)"));
                    SETVALUE('Amount_LCY', FORMAT(CustomerLedger."Amount (LCY)"));
                    SETVALUE('Due_Date', CustomerLedger."Due Date");
                    SETVALUE('Description', CustomerLedger.Description);
                    SETVALUE('Tenant_ID', DealerInformation."Tenant ID");
                    SETVALUE('Company_Name', DealerInformation."Customer Name");
                    ComapnyInfo.GET;
                    SETVALUE('From_Company', ComapnyInfo.Name);
                    IF ComapnyInfo."Balaju Auto Works" THEN
                        CompName := 1
                    ELSE
                        CompName := 2;
                    SETVALUE('Company', CompName);
                    CREATE;
                END ELSE BEGIN
                    SETVALUE('Document_No', CustomerLedger."Document No.");
                    SETVALUE('Customer_No', CustomerLedger."Customer No.");
                    CASE CustomerLedger."Document Type" OF
                        CustomerLedger."Document Type"::" ":
                            BEGIN
                                DocumentType := 0;
                            END;
                        CustomerLedger."Document Type"::Payment:
                            BEGIN
                                DocumentType := 1;
                            END;
                        CustomerLedger."Document Type"::Invoice:
                            BEGIN
                                DocumentType := 2;
                            END;
                        CustomerLedger."Document Type"::"Credit Memo":
                            BEGIN
                                DocumentType := 3;
                            END;
                        CustomerLedger."Document Type"::"Finance Charge Memo":
                            BEGIN
                                DocumentType := 4;
                            END;
                        CustomerLedger."Document Type"::Reminder:
                            BEGIN
                                DocumentType := 5;
                            END;
                        CustomerLedger."Document Type"::Refund:
                            BEGIN
                                DocumentType := 6;
                            END;
                    END;
                    SETVALUE('Document_Type', DocumentType);
                    SETVALUE('Debit_Amount_LCY', FORMAT(CustomerLedger."Debit Amount (LCY)"));
                    SETVALUE('Credit_Amount_LCY', FORMAT(CustomerLedger."Credit Amount (LCY)"));
                    SETVALUE('Amount_LCY', FORMAT(CustomerLedger."Amount (LCY)"));
                    SETVALUE('Due_Date', CustomerLedger."Due Date");
                    SETVALUE('Description', CustomerLedger.Description);
                    SETVALUE('Tenant_ID', DealerInformation."Tenant ID");
                    SETVALUE('Company_Name', DealerInformation."Customer Name");
                    ComapnyInfo.GET;
                    SETVALUE('From_Company', ComapnyInfo.Name);
                    IF ComapnyInfo."Balaju Auto Works" THEN
                        CompName := 1
                    ELSE
                        CompName := 2;
                    SETVALUE('Company', CompName);
                    UPDATE;
                END;
            END;
        END;
    end;
}


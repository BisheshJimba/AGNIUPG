codeunit 50014 "System Mgt."
{
    // Table Distribution
    // f  IRD Module (50000 - 50009) 10
    //   Financial Management (50010 - 50019) 10 FNM
    //   Sales & Marketing (50020 - 50049) 30 SMK
    //   Warehouse (50050 - 50059) 10 WHS
    //   Service (50060 - 50089) 30 SRV
    //   Vehicle Logistic (50090 - 50109) 20 VLG
    //   Purchase (50110 - 50124) 15 PRC
    //   Administration (50125 - 50129) 5 ADM
    // 
    // Page Distribution
    //   IRD Module (50000 - 50009) 10
    //   Financial Management (50010 - 50029) 20
    //   Sales & Marketing (50030 - 50059) 30
    //   Warehouse (50060 - 50079) 20
    //   Service (50080 - 50129) 50
    //   Vehicle Logistic (50130 - 50159) 30
    //   Purchase (50160 - 50189) 30
    //   Administration (50190 - 50199) 10
    // 
    // Report/XMLPort/Query Distribution
    //   IRD Module (50000 - 50024) 25
    //   Financial Management (50025 - 50034) 10
    //   Sales & Marketing (50035 - 50049) 15
    //   Warehouse (50050 - 50059) 10
    //   Service (50060 - 50079) 20
    //   Vehicle Logistic (50080 - 50089) 10
    //   Purchase (50090 - 50099) 10
    //   Administration  0
    // 
    // Codeunit Distribution
    //   IRD Module (50000 - 50001) 2
    //   Financial Management (50002 - 50003) 2
    //   Sales & Marketing (50004 - 50005) 2
    //   Warehouse (50006 - 50007) 2
    //   Service (50008 - 50009) 2
    //   Vehicle Logistic (50010 - 50011) 2
    //   Purchase (50012 - 50013) 2
    //   Administration (50014 - 50019) 6

    Permissions = TableData 50132 = rimd;

    trigger OnRun()
    begin
    end;

    var
        ResponsibilityCenter: Record "5714";
        Text000: Label 'You are not authorised to transfer from %1.';
        Text007: Label 'You cannot change %1 because there are one or more %2 for this %3.';
        Text008: Label 'You cannot receive the Serial No. %1 because sales/transfer/adjustment entries are done.';
        Text009: Label 'You cannot receive the Serial No. %1 because there are outstanding service orders/quotes attached to it.';
        Text010: Label 'You cannot receive the Serial No. %1 because Service ledger entries exists.';
        Text50000: Label 'Engine No :';
        Text50001: Label 'Registration No :';
        Text50002: Label 'Variant Code :';
        DocNo: Code[20];
        GLSetup: Record "98";
        MessageType: Option " ","Service Estimation","Service Invoice","Service Reminder","Service Booking","Vehicle Inward","Vehicle Booking","Sales Invoicing","Down Payment","DO realization final billing","Cash Invoice","Credit Invoice","Cash Collection","Customer Consent";
        FollowupDetails: Record "33020086";
        "---------------For Perprctual-----------------": Integer;
        ProgressWindow: Dialog;
        InvSetup: Record "313";
        UserSetup: Record "91";
        SKU: Record "5700";
        MaxIteration: Integer;
        IterationNo: Integer;
        MaxItem: Integer;
        "-----------for perpectual-----": Label '------------------------------------------------';
        TextP000: Label 'You have already done the perpetual verification for today.';
        TextP001: Label 'Creating Lines  @1@@@@@@@@@@@@@';
        TextP002: Label 'There is nothing to post.';
        TextP003: Label 'Perpetual has already been posted for Location %1 for %2.';
        Items: Record "27";
        TextP004: Label 'Perpetual has already been posted for date %1.';

    [Scope('Internal')]
    procedure CreateVehicle(ItemNo: Code[20]; SerialNo: Code[20]; VariantCode: Code[10])
    var
        ServiceItem: Record "5940";
        Item: Record "27";
        ItemLedgEntry: Record "32";
        ServItemLine: Record "5901";
        ServLedgEntry: Record "5907";
        ServiceOrders: Record "5900";
        ServiceOrderType: Record "5903";
        UserSetup: Record "91";
        Text50000: Label 'Operation Halted.';
        Text50001: Label 'You cannot receive the Serial No. %1 because Service ledger entries exists.Do you want to continue anyway?';
        Text50002: Label 'You cannot receive the Serial No. %1 because there are outstanding service orders/quotes attached to it. Do you want to continue anyway?';
        RequestReturnToGlobalUser: Boolean;
    begin
        UserSetup.GET(USERID);
        RequestReturnToGlobalUser := FALSE;   //Boolean to know if the user has global right to
        //return vehicle irrespective of service order type(types other than PDI)
        IF NOT ServiceItem.GET(SerialNo) THEN BEGIN
            Item.GET(ItemNo);
            Item.TESTFIELD("Make Code");
            Item.TESTFIELD("Model Code");
            //Item.CALCFIELDS(Specifications);
            //Item.CALCFIELDS("Build Specifications");
            CLEAR(ServiceItem);
            ServiceItem.INIT;
            ServiceItem.VALIDATE("No.", SerialNo);
            ServiceItem.INSERT(TRUE);
            ServiceItem.VALIDATE("Serial No.", SerialNo);
            //ServiceItem.VALIDATE("Make Code",Item."Make Code");
            //ServiceItem.VALIDATE("Model Code",Item."Model Code");
            ServiceItem.VALIDATE("Item No.", ItemNo);
            //ServiceItem.Specifications := Item.Specifications;
            //ServiceItem."Body Builded Specifications" := Item."Build Specifications";
            ServiceItem.VALIDATE("Service Item Group Code", Item."Service Item Group");
            ServiceItem.VALIDATE("Variant Code", VariantCode);
            ServiceItem.MODIFY(TRUE);
        END
        ELSE BEGIN
            //Agile RD july 28 2016  //sales return of vehicle was resulting in errror consulted from @yuran
            //  ItemLedgEntry.RESET;
            //  ItemLedgEntry.SETCURRENTKEY("Serial No.");
            //  ItemLedgEntry.SETRANGE("Serial No.",SerialNo);
            //  ItemLedgEntry.SETFILTER("Entry Type",'<>%1',ItemLedgEntry."Entry Type"::Purchase);
            //  IF NOT ItemLedgEntry.ISEMPTY THEN
            //    ERROR(Text008,SerialNo);
            //Agile RD july 28 2016
            ServItemLine.RESET;
            ServItemLine.SETCURRENTKEY("Service Item No.");
            ServItemLine.SETRANGE("Service Item No.", SerialNo);
            ServItemLine.SETRANGE(ServItemLine."Document Type", ServItemLine."Document Type"::Order);
            IF ServItemLine.FINDFIRST THEN
                REPEAT
                    ServiceOrders.RESET;
                    ServiceOrders.SETRANGE(ServiceOrders."No.", ServItemLine."Document No.");
                    //ServiceOrders.SETRANGE(ServiceOrders."Closed Without Service",FALSE);
                    IF ServiceOrders.FINDFIRST THEN BEGIN
                        ServiceOrderType.RESET;
                        ServiceOrderType.GET(ServiceOrders."Service Order Type");
                        /*IF NOT ServiceOrderType."Is PDI JOB" THEN BEGIN  //By passing the control if only PDI JOb has been created AGILE RD 13032017
                            IF NOT UserSetup."Allow Sales Return Of Non PDI" THEN
                              ERROR(Text009,SerialNo)
                            ELSE BEGIN
                               RequestReturnToGlobalUser := TRUE//ERROR(Text50000);
                            END;
                        END;*/
                    END;
                UNTIL ServItemLine.NEXT = 0;
            IF RequestReturnToGlobalUser THEN
                IF CONFIRM(Text50002, FALSE, SerialNo) <> TRUE THEN
                    ERROR(Text50000);
            ServLedgEntry.RESET;
            ServLedgEntry.SETCURRENTKEY(
              "Service Item No. (Serviced)", "Entry Type", "Moved from Prepaid Acc.",
              Type, "Posting Date", Open);
            ServLedgEntry.SETRANGE("Service Item No. (Serviced)", SerialNo);
            IF ServLedgEntry.FINDFIRST THEN BEGIN
                REPEAT
                    ServiceOrderType.RESET;
                    IF ServLedgEntry."Service Order Type" <> '' THEN BEGIN
                        ServiceOrderType.GET(ServLedgEntry."Service Order Type");
                        /*IF NOT ServiceOrderType."Is PDI JOB" THEN  BEGIN    //By passing the control if only PDI JOb has been created  AGILE RD 13032017
                          IF NOT UserSetup."Allow Sales Return Of Non PDI" THEN
                            ERROR(Text010,SerialNo)
                          ELSE BEGIN
                            RequestReturnToGlobalUser := TRUE;
                          END;
                        END;*/
                    END;
                UNTIL ServLedgEntry.NEXT = 0;

                IF RequestReturnToGlobalUser THEN
                    IF CONFIRM(Text50001, FALSE, SerialNo) <> TRUE THEN
                        ERROR(Text50000);
            END;
            Item.GET(ItemNo);
            Item.TESTFIELD("Make Code");
            Item.TESTFIELD("Model Code");
            //Item.CALCFIELDS(Specifications);
            //Item.CALCFIELDS("Build Specifications");
            ServiceItem.RESET;
            ServiceItem.SETRANGE("No.", SerialNo);
            IF ServiceItem.FINDFIRST THEN BEGIN
                //ServiceItem.VALIDATE("Make Code",Item."Make Code");
                //ServiceItem.VALIDATE("Model Code",Item."Model Code");
                ServiceItem.VALIDATE("Item No.", ItemNo);
                ServiceItem.VALIDATE("Serial No.", SerialNo);
                //ServiceItem.Specifications := Item.Specifications;
                //ServiceItem."Body Builded Specifications" := Item."Build Specifications";
                ServiceItem.VALIDATE("Service Item Group Code", Item."Service Item Group");
                ServiceItem.VALIDATE("Variant Code", VariantCode);
                ServiceItem.MODIFY(TRUE);
            END;
        END;

    end;

    [Scope('Internal')]
    procedure GetRespCenterWiseNoSeries("Document Profile": Option Purchase,Sales,Transfer,Service; "Document Type": Option Quote,"Blanket Order","Order","Return Order",Invoice,"Posted Invoice","Credit Memo","Posted Credit Memo","Posted Shipment","Posted Receipt","Posted Prepmt. Inv.","Posted Prepmt. Cr. Memo","Posted Return Receipt","Posted Return Shipment",Booking,"Posted Order","Posted Debit Note",Requisition,Services,"Posted Credit Note"; RespCenterCode: Code[10]): Code[10]
    var
        RespCenter: Record "5714";
    begin
        IF RespCenter.GET(RespCenterCode) THEN BEGIN
            CASE "Document Profile" OF
                "Document Profile"::Purchase:
                    BEGIN
                        CASE "Document Type" OF
                            "Document Type"::Quote:
                                EXIT(RespCenter."Purch. Quote Nos.");
                            "Document Type"::"Blanket Order":
                                EXIT(RespCenter."Purch. Blanket Order Nos.");
                            "Document Type"::Order:
                                EXIT(RespCenter."Purch. Order Nos.");
                            "Document Type"::"Return Order":
                                EXIT(RespCenter."Purch. Return Order Nos.");
                            "Document Type"::Invoice:
                                EXIT(RespCenter."Purch. Invoice Nos.");
                            "Document Type"::"Posted Invoice":
                                EXIT(RespCenter."Purch. Posted Invoice Nos.");
                            "Document Type"::"Credit Memo":
                                EXIT(RespCenter."Purch. Credit Memo Nos.");
                            "Document Type"::"Posted Credit Memo":
                                EXIT(RespCenter."Purch. Posted Credit Memo Nos.");
                            "Document Type"::"Posted Receipt":
                                EXIT(RespCenter."Purch. Posted Receipt Nos.");
                            "Document Type"::"Posted Return Shipment":
                                EXIT(RespCenter."Purch. Ptd. Return Shpt. Nos.");
                            "Document Type"::"Posted Prepmt. Inv.":
                                EXIT(RespCenter."Purch. Posted Prept. Inv. Nos.");
                            "Document Type"::"Posted Prepmt. Cr. Memo":
                                EXIT(RespCenter."Purch. Ptd. Prept. Cr. M. Nos.");
                        END;
                    END;
                "Document Profile"::Sales:
                    BEGIN
                        CASE "Document Type" OF
                            "Document Type"::Quote:
                                EXIT(RespCenter."Sales Quote Nos.");
                            "Document Type"::"Blanket Order":
                                EXIT(RespCenter."Sales Blanket Order Nos.");
                            "Document Type"::Order:
                                EXIT(RespCenter."Sales Order Nos.");
                            "Document Type"::"Return Order":
                                EXIT(RespCenter."Sales Return Order Nos.");
                            "Document Type"::Invoice:
                                EXIT(RespCenter."Sales Invoice Nos.");
                            "Document Type"::"Posted Invoice":
                                EXIT(RespCenter."Sales Posted Invoice Nos.");
                            "Document Type"::"Credit Memo":
                                EXIT(RespCenter."Sales Credit Memo Nos.");
                            "Document Type"::"Posted Credit Memo":
                                EXIT(RespCenter."Sales Posted Credit Memo Nos.");
                            "Document Type"::"Posted Shipment":
                                EXIT(RespCenter."Sales Posted Shipment Nos.");
                            "Document Type"::"Posted Return Receipt":
                                EXIT(RespCenter."Sales Ptd. Return Receipt Nos.");
                            "Document Type"::"Posted Prepmt. Inv.":
                                EXIT(RespCenter."Sales Posted Prepmt. Inv. Nos.");
                            "Document Type"::"Posted Prepmt. Cr. Memo":
                                EXIT(RespCenter."Sales Ptd. Prept. Cr. M. Nos.");
                        END;

                    END;
                "Document Profile"::Service:
                    BEGIN
                        CASE "Document Type" OF
                        /*"Document Type"::Quote:
                           EXIT(RespCenter."Service Quote Nos.");*/
                        /*"Document Type"::Order:
                           EXIT(RespCenter."Service Order Nos.");*/
                        /*"Document Type"::Invoice:
                           EXIT(RespCenter."Service Invoice Nos.");*/
                        /*"Document Type"::"Posted Invoice":
                           EXIT(RespCenter."Posted Service Invoice Nos.");*/
                        /*"Document Type"::"Credit Memo":
                           EXIT(RespCenter."Service Credit Memo Nos.");*/
                        /*"Document Type"::"Posted Credit Memo":
                           EXIT(RespCenter."Posted Serv. Credit Memo Nos.");*/
                        /*"Document Type"::"Posted Shipment":
                           EXIT(RespCenter."Posted Service Shipment Nos.");*/
                        END;
                    END;
                "Document Profile"::Transfer:
                    BEGIN
                        CASE "Document Type" OF
                            "Document Type"::Order:
                                EXIT(RespCenter."Trans. Order Nos.");
                            "Document Type"::"Posted Receipt":
                                EXIT(RespCenter."Posted Transfer Rcpt. Nos.");
                            "Document Type"::"Posted Shipment":
                                EXIT(RespCenter."Posted Transfer Shpt. Nos.");
                        END;
                    END;
            END;
        END;

    end;

    [Scope('Internal')]
    procedure GetNoSeriesFromRespCenter(): Boolean
    var
        CompanyInfo: Record "79";
    begin
        CompanyInfo.GET;
        EXIT(CompanyInfo."Activate Local Resp. Center");
    end;

    [Scope('Internal')]
    procedure InitCustomFieldsOnTransferHeader(var Rec: Record "5740"; var xRec: Record "5740"; CurrFieldNo: Integer)
    var
        UserSetup: Record "91";
    begin
        IF CurrFieldNo = 2 THEN BEGIN
            UserSetup.GET(USERID);
            IF NOT Rec."Is Requisition Order" THEN BEGIN//pram
                IF Rec."Transfer-from Code" <> UserSetup."Default Location Code" THEN
                    ERROR(Text000, Rec."Transfer-from Code");
            END;
        END;
        Rec."Location Filters" := Rec."Transfer-from Code" + ',' + Rec."Transfer-to Code";
    end;

    [Scope('Internal')]
    procedure TestNoSeriesFromRespCenter("Document Profile": Option Purchase,Sales,Transfer,Service; "Document Type": Option Quote,"Blanket Order","Order","Return Order",Invoice,"Posted Invoice","Credit Memo","Posted Credit Memo","Posted Shipment","Posted Receipt","Posted Prepmt. Inv.","Posted Prepmt. Cr. Memo","Posted Return Receipt","Posted Return Shipment",Booking,"Posted Order","Posted Debit Note",Requisition,Services,"Posted Credit Note"; RespCenterCode: Code[10])
    var
        RespCenter: Record "5714";
    begin
        IF RespCenter.GET(RespCenterCode) THEN BEGIN
            CASE "Document Profile" OF
                "Document Profile"::Purchase:
                    BEGIN
                        CASE "Document Type" OF
                            "Document Type"::Quote:
                                RespCenter.TESTFIELD("Purch. Quote Nos.");
                            "Document Type"::"Blanket Order":
                                RespCenter.TESTFIELD("Purch. Blanket Order Nos.");
                            "Document Type"::Order:
                                RespCenter.TESTFIELD("Purch. Order Nos.");
                            "Document Type"::"Return Order":
                                RespCenter.TESTFIELD("Purch. Return Order Nos.");
                            "Document Type"::Invoice:
                                RespCenter.TESTFIELD("Purch. Invoice Nos.");
                            "Document Type"::"Posted Invoice":
                                RespCenter.TESTFIELD("Purch. Posted Invoice Nos.");
                            "Document Type"::"Credit Memo":
                                RespCenter.TESTFIELD("Purch. Credit Memo Nos.");
                            "Document Type"::"Posted Credit Memo":
                                RespCenter.TESTFIELD("Purch. Posted Credit Memo Nos.");
                            "Document Type"::"Posted Receipt":
                                RespCenter.TESTFIELD("Purch. Posted Receipt Nos.");
                            "Document Type"::"Posted Return Shipment":
                                RespCenter.TESTFIELD("Purch. Ptd. Return Shpt. Nos.");
                            "Document Type"::"Posted Prepmt. Inv.":
                                RespCenter.TESTFIELD("Purch. Posted Prept. Inv. Nos.");
                            "Document Type"::"Posted Prepmt. Cr. Memo":
                                RespCenter.TESTFIELD("Purch. Ptd. Prept. Cr. M. Nos.");
                        END;
                    END;
                "Document Profile"::Sales:
                    BEGIN
                        CASE "Document Type" OF
                            "Document Type"::Quote:
                                RespCenter.TESTFIELD("Sales Quote Nos.");
                            "Document Type"::"Blanket Order":
                                RespCenter.TESTFIELD("Sales Blanket Order Nos.");
                            "Document Type"::Order:
                                RespCenter.TESTFIELD("Sales Order Nos.");
                            "Document Type"::"Return Order":
                                RespCenter.TESTFIELD("Sales Return Order Nos.");
                            "Document Type"::Invoice:
                                RespCenter.TESTFIELD("Sales Invoice Nos.");
                            "Document Type"::"Posted Invoice":
                                RespCenter.TESTFIELD("Sales Posted Invoice Nos.");
                            "Document Type"::"Credit Memo":
                                RespCenter.TESTFIELD("Sales Credit Memo Nos.");
                            "Document Type"::"Posted Credit Memo":
                                RespCenter.TESTFIELD("Sales Posted Credit Memo Nos.");
                            "Document Type"::"Posted Shipment":
                                RespCenter.TESTFIELD("Sales Posted Shipment Nos.");
                            "Document Type"::"Posted Return Receipt":
                                RespCenter.TESTFIELD("Sales Ptd. Return Receipt Nos.");
                            "Document Type"::"Posted Prepmt. Inv.":
                                RespCenter.TESTFIELD("Sales Posted Prepmt. Inv. Nos.");
                            "Document Type"::"Posted Prepmt. Cr. Memo":
                                RespCenter.TESTFIELD("Sales Ptd. Prept. Cr. M. Nos.");
                        END;
                    END;
                "Document Profile"::Service:
                    BEGIN
                        CASE "Document Type" OF
                            "Document Type"::Quote:
                                RespCenter.TESTFIELD("Service Quote Nos.");
                            "Document Type"::Order:
                                RespCenter.TESTFIELD("Service Order Nos.");
                            "Document Type"::Invoice:
                                RespCenter.TESTFIELD("Service Invoice Nos.");
                            "Document Type"::"Posted Invoice":
                                RespCenter.TESTFIELD("Posted Service Invoice Nos.");
                            "Document Type"::"Credit Memo":
                                RespCenter.TESTFIELD("Service Credit Memo Nos.");
                            "Document Type"::"Posted Credit Memo":
                                RespCenter.TESTFIELD("Posted Serv. Credit Memo Nos.");
                            "Document Type"::"Posted Shipment":
                                RespCenter.TESTFIELD("Posted Service Shipment Nos.");
                        END;
                    END;
                "Document Profile"::Transfer:
                    BEGIN
                        CASE "Document Type" OF
                            "Document Type"::Order:
                                RespCenter.TESTFIELD("Trans. Order Nos.");
                            "Document Type"::"Posted Receipt":
                                RespCenter.TESTFIELD("Posted Transfer Rcpt. Nos.");
                            "Document Type"::"Posted Shipment":
                                RespCenter.TESTFIELD("Posted Transfer Shpt. Nos.");
                        END;
                    END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure GetUserRespCenter(): Code[10]
    var
        UserSetup: Record "91";
    begin
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Default Responsibility Center");
        EXIT(UserSetup."Default Responsibility Center");
    end;

    [Scope('Internal')]
    procedure GetUserRespCenterFilter() RespCenterFilter: Text
    var
        UserSetup: Record "91";
        UserRespCenter: Record "50125";
    begin
        UserSetup.GET(USERID);
        IF UserSetup."Default Responsibility Center" <> '' THEN
            RespCenterFilter := UserSetup."Default Responsibility Center";
        UserRespCenter.RESET;
        UserRespCenter.SETRANGE("User ID", USERID);
        IF UserRespCenter.FINDSET THEN
            REPEAT
                IF UserRespCenter."Responsibility Center" <> '' THEN BEGIN
                    IF RespCenterFilter <> '' THEN BEGIN
                        RespCenterFilter += '|' + UserRespCenter."Responsibility Center"
                    END
                    ELSE
                        RespCenterFilter += UserRespCenter."Responsibility Center"
                END;
            UNTIL UserRespCenter.NEXT = 0;
        EXIT(RespCenterFilter);
    end;

    [Scope('Internal')]
    procedure GetExternalServiceNos(var Item: Record "27")
    var
        ServiceMgtSetup: Record "5911";
        NoSeriesMgt: Codeunit "396";
    begin
        IF Item."No." = '' THEN BEGIN
            ServiceMgtSetup.GET;
            ServiceMgtSetup.TESTFIELD("External Service Nos.");
            NoSeriesMgt.InitSeries(ServiceMgtSetup."External Service Nos.", Item."No. Series", 0D, Item."No.", Item."No. Series");
        END;
    end;

    [Scope('Internal')]
    procedure LookUpItem(var recItem: Record "27"; No: Code[20]): Boolean
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
    procedure LookUpModelVersion(var recItem: Record "27"; No: Code[20]): Boolean
    var
        ModelVersionList: Page "50088";
    begin
        CLEAR(ModelVersionList);
        recItem.SETCURRENTKEY("Item Type");
        recItem.SETRANGE("Item Type", recItem."Item Type"::"Model Version");
        IF No <> '' THEN
            IF recItem.GET(No) THEN
                ModelVersionList.SETRECORD(recItem);
        ModelVersionList.SETTABLEVIEW(recItem);
        ModelVersionList.LOOKUPMODE(TRUE);
        IF ModelVersionList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ModelVersionList.GETRECORD(recItem);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure LookUpModelVersionWithFilter(var recItem: Record "27"; No: Code[20]; MakeCode: Code[20]; ModelCode: Code[20]): Boolean
    var
        ModelVersions: Page "31";
        ModelVersionListPage: Page "50088";
    begin
        CLEAR(ModelVersions);
        CLEAR(ModelVersionListPage);
        recItem.SETCURRENTKEY("Item Type", "Make Code");
        recItem.SETRANGE("Item Type", recItem."Item Type"::"Model Version");
        IF MakeCode <> '' THEN
            recItem.SETRANGE("Make Code", MakeCode);
        IF ModelCode <> '' THEN
            recItem.SETRANGE("Model Code", ModelCode);
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
    procedure LookupSerialNo(var ServiceItem: Record "5940"; MakeCode: Code[20]; ModelCode: Code[20]; ModelVersionCode: Code[20]): Boolean
    var
        ServiceItemList: Page "5981";
    begin
        CLEAR(ServiceItemList);
        ServiceItem.RESET;
        ServiceItem.SETRANGE("Make Code", MakeCode);
        ServiceItem.SETRANGE("Model Code", ModelCode);
        ServiceItem.SETRANGE("Item No.", ModelVersionCode);
        ServiceItem.SETFILTER(Inventory, '>%1', 0);
        ServiceItem.SETRANGE("Master Block", FALSE); //pram
        ServiceItemList.SETTABLEVIEW(ServiceItem);
        ServiceItemList.LOOKUPMODE(TRUE);
        IF ServiceItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            ServiceItemList.GETRECORD(ServiceItem);
            EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure TestManualExternalServiceNos(var Item: Record "27")
    var
        ServiceMgtSetup: Record "5911";
        NoSeriesMgt: Codeunit "396";
    begin
        ServiceMgtSetup.GET;
        NoSeriesMgt.TestManual(ServiceMgtSetup."External Service Nos.");
        Item."No. Series" := '';
    end;

    [Scope('Internal')]
    procedure AssistEditExternalService(var Rec: Record "27"; var xRec: Record "27"): Boolean
    var
        ServiceMgtSetup: Record "5911";
        NoSeriesMgt: Codeunit "396";
    begin
        ServiceMgtSetup.GET;
        ServiceMgtSetup.TESTFIELD("External Service Nos.");
        IF NoSeriesMgt.SelectSeries(ServiceMgtSetup."External Service Nos.", xRec."No. Series", Rec."No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(Rec."No.");
            EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure IsWarrantyApprovalsWorkflowEnabled(var ServiceLine: Record "5902"): Boolean
    var
        WorkflowManagement: Codeunit "1501";
        WorkflowEventHandling: Codeunit "1520";
        ManageTV: Codeunit "50018";
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ServiceLine, ManageTV.OnServiceSendForApprovalCode));
    end;

    [IntegrationEvent(false, false)]
    [Scope('Internal')]
    procedure OnServicePostCheckRestriction(var ServiceHeader: Record "5900")
    begin
    end;

    [IntegrationEvent(false, false)]
    [Scope('Internal')]
    procedure OnServicePostBeforeInsertServLedgEntry(var ServiceLedgerEntry: Record "5907"; var ServiceItemLine: Record "5901"; var ServiceLine: Record "5902"; var ServiceHeader: Record "5900")
    begin
    end;

    [Scope('Internal')]
    procedure TestLedgerEntryExist(MasterTableID: Integer; LedgEntryTableID: Integer; CurrentFieldName: Text[250]; PrimaryKey1: Code[20]; PrimaryKey2: Code[20])
    var
        Item: Record "27";
        Vendor: Record "23";
        Customer: Record "18";
        FixedAsset: Record "5600";
        GLAccount: Record "15";
        BankAccount: Record "270";
        Resource: Record "156";
        Location: Record "14";
        InventoryPostingSetup: Record "5813";
        GenPostingSetup: Record "252";
        VATPostingSetup: Record "325";
        CustomerPostingGroup: Record "92";
        VendorPostingGroup: Record "93";
        BankAccountPostingGroup: Record "277";
        FAPostingGroup: Record "5606";
        ItemLedgEntry: Record "32";
        VendorLedgEntry: Record "25";
        CustomerLedgEntry: Record "21";
        FALedgEntry: Record "5601";
        GLEntry: Record "17";
        BankAccLedgEntry: Record "271";
        ResLedgEntry: Record "203";
        ValueEntry: Record "5802";
        VATEntry: Record "254";
        UserSetup: Record "91";
    begin
        CASE MasterTableID OF
            DATABASE::Item:
                BEGIN
                    IF LedgEntryTableID = DATABASE::"Item Ledger Entry" THEN BEGIN
                        ItemLedgEntry.SETCURRENTKEY("Item No.");
                        ItemLedgEntry.SETRANGE("Item No.", PrimaryKey1);
                        IF NOT ItemLedgEntry.ISEMPTY THEN
                            ERROR(
                              Text007,
                              CurrentFieldName, ItemLedgEntry.TABLECAPTION, Item.TABLECAPTION);
                    END;
                END;
            DATABASE::Vendor:
                BEGIN
                    UserSetup.RESET;
                    UserSetup.GET(USERID);
                    IF NOT UserSetup."Allow Posting Group Update" THEN BEGIN
                        IF LedgEntryTableID = DATABASE::"Vendor Ledger Entry" THEN BEGIN
                            VendorLedgEntry.SETCURRENTKEY("Vendor No.");
                            VendorLedgEntry.SETRANGE("Vendor No.", PrimaryKey1);
                            IF NOT VendorLedgEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, VendorLedgEntry.TABLECAPTION, Vendor.TABLECAPTION);
                        END;
                    END
                END;
            DATABASE::Customer:
                BEGIN
                    IF LedgEntryTableID = DATABASE::"Cust. Ledger Entry" THEN BEGIN
                        CustomerLedgEntry.SETCURRENTKEY("Customer No.");
                        CustomerLedgEntry.SETRANGE("Customer No.", PrimaryKey1);
                        IF NOT CustomerLedgEntry.ISEMPTY THEN
                            ERROR(
                              Text007,
                              CurrentFieldName, CustomerLedgEntry.TABLECAPTION, Customer.TABLECAPTION);
                    END;
                END;
            DATABASE::"Fixed Asset":
                BEGIN
                    IF LedgEntryTableID = DATABASE::"FA Ledger Entry" THEN BEGIN
                        FALedgEntry.SETCURRENTKEY("FA No.");
                        FALedgEntry.SETRANGE("FA No.", PrimaryKey1);
                        IF NOT FALedgEntry.ISEMPTY THEN
                            ERROR(
                              Text007,
                              CurrentFieldName, FALedgEntry.TABLECAPTION, FixedAsset.TABLECAPTION);
                    END;
                END;
            DATABASE::"G/L Account":
                BEGIN
                    IF LedgEntryTableID = DATABASE::"G/L Entry" THEN BEGIN
                        GLEntry.SETCURRENTKEY("G/L Account No.");
                        GLEntry.SETRANGE("G/L Account No.", PrimaryKey1);
                        /*IF NOT GLEntry.ISEMPTY THEN
                          ERROR(Text007,CurrentFieldName,GLEntry.TABLECAPTION,GLAccount.TABLECAPTION);*/
                    END;
                END;
            DATABASE::"Bank Account":
                BEGIN
                    IF LedgEntryTableID = DATABASE::"Bank Account Ledger Entry" THEN BEGIN
                        BankAccLedgEntry.SETCURRENTKEY("Bank Account No.");
                        BankAccLedgEntry.SETRANGE("Bank Account No.", PrimaryKey1);
                        /* IF NOT BankAccLedgEntry.ISEMPTY THEN
                           ERROR(
                             Text007,
                             CurrentFieldName,BankAccLedgEntry.TABLECAPTION,BankAccount.TABLECAPTION);*/
                    END;
                END;
            DATABASE::Resource:
                BEGIN
                    IF LedgEntryTableID = DATABASE::"Res. Ledger Entry" THEN BEGIN
                        ResLedgEntry.SETCURRENTKEY("Resource No.");
                        ResLedgEntry.SETRANGE("Resource No.", PrimaryKey1);
                        IF NOT ResLedgEntry.ISEMPTY THEN
                            ERROR(
                              Text007,
                              CurrentFieldName, ResLedgEntry.TABLECAPTION, Resource.TABLECAPTION);
                    END;
                END;
            DATABASE::Location:
                BEGIN
                    IF LedgEntryTableID = DATABASE::"Item Ledger Entry" THEN BEGIN
                        ItemLedgEntry.SETCURRENTKEY("Location Code");
                        ItemLedgEntry.SETRANGE("Location Code", PrimaryKey1);
                        IF NOT ItemLedgEntry.ISEMPTY THEN
                            ERROR(
                              Text007,
                              CurrentFieldName, ItemLedgEntry.TABLECAPTION, Location.TABLECAPTION);
                    END;
                END;
            DATABASE::"Inventory Posting Setup":
                BEGIN
                    IF LedgEntryTableID = DATABASE::"Value Entry" THEN BEGIN
                        ValueEntry.SETCURRENTKEY("Location Code");
                        ValueEntry.SETRANGE("Location Code", PrimaryKey1);
                        ValueEntry.SETRANGE("Inventory Posting Group", PrimaryKey2);
                        IF NOT ValueEntry.ISEMPTY THEN
                            ERROR(
                              Text007,
                              CurrentFieldName, ValueEntry.TABLECAPTION, InventoryPostingSetup.TABLECAPTION);
                    END;
                END;
            DATABASE::"General Posting Setup":
                BEGIN
                    IF LedgEntryTableID = DATABASE::"Value Entry" THEN BEGIN
                        ValueEntry.SETRANGE("Gen. Bus. Posting Group", PrimaryKey1);
                        ValueEntry.SETRANGE("Gen. Prod. Posting Group", PrimaryKey2);
                        //      IF NOT ValueEntry.ISEMPTY THEN
                        //        ERROR(
                        //          Text007,
                        //          CurrentFieldName,ValueEntry.TABLECAPTION,GenPostingSetup.TABLECAPTION);
                    END;
                END;
            DATABASE::"VAT Posting Setup":
                BEGIN
                    IF LedgEntryTableID = DATABASE::"VAT Entry" THEN BEGIN
                        VATEntry.SETRANGE("VAT Bus. Posting Group", PrimaryKey1);
                        VATEntry.SETRANGE("VAT Prod. Posting Group", PrimaryKey2);
                        IF NOT VATEntry.ISEMPTY THEN
                            ERROR(
                              Text007,
                              CurrentFieldName, VATEntry.TABLECAPTION, VATPostingSetup.TABLECAPTION);
                    END;
                END;
            DATABASE::"Customer Posting Group":
                BEGIN
                    UserSetup.RESET;
                    UserSetup.GET(USERID);
                    IF NOT UserSetup."Allow Posting Group Update" THEN BEGIN
                        IF LedgEntryTableID = DATABASE::"Cust. Ledger Entry" THEN BEGIN
                            CustomerLedgEntry.SETRANGE("Customer Posting Group", PrimaryKey1);
                            IF NOT CustomerLedgEntry.ISEMPTY THEN
                                ERROR(
                                  Text007,
                                  CurrentFieldName, CustomerLedgEntry.TABLECAPTION, CustomerPostingGroup.TABLECAPTION);
                        END;
                    END;
                END;
            DATABASE::"Vendor Posting Group":
                BEGIN
                    IF LedgEntryTableID = DATABASE::"Vendor Ledger Entry" THEN BEGIN
                        VendorLedgEntry.SETRANGE("Vendor Posting Group", PrimaryKey1);
                        IF NOT VendorLedgEntry.ISEMPTY THEN
                            ERROR(
                              Text007,
                              CurrentFieldName, VendorLedgEntry.TABLECAPTION, VendorPostingGroup.TABLECAPTION);
                    END;
                END;
            DATABASE::"Bank Account Posting Group":
                BEGIN
                    IF LedgEntryTableID = DATABASE::"Bank Account Ledger Entry" THEN BEGIN
                        BankAccLedgEntry.SETRANGE("Bank Acc. Posting Group", PrimaryKey1);
                        IF NOT BankAccLedgEntry.ISEMPTY THEN
                            ERROR(
                              Text007,
                              CurrentFieldName, BankAccLedgEntry.TABLECAPTION, BankAccountPostingGroup.TABLECAPTION);
                    END;
                END;
            DATABASE::"FA Posting Group":
                BEGIN
                    IF LedgEntryTableID = DATABASE::"FA Ledger Entry" THEN BEGIN
                        FALedgEntry.SETRANGE("FA Posting Group", PrimaryKey1);
                        IF NOT FALedgEntry.ISEMPTY THEN
                            ERROR(
                              Text007,
                              CurrentFieldName, FALedgEntry.TABLECAPTION, FAPostingGroup.TABLECAPTION);
                    END;
                END;
        END;

    end;

    [Scope('Internal')]
    procedure Binding()
    begin
    end;

    [Scope('Internal')]
    procedure GetRespCenterWiseNoSeriesMemo("Document Profile": Option Purchase,Sales,Transfer,Service; "Document Type": Option Quote,"Blanket Order","Order","Return Order",Invoice,"Posted Invoice","Credit Memo","Posted Credit Memo","Posted Shipment","Posted Receipt","Posted Prepmt. Inv.","Posted Prepmt. Cr. Memo","Posted Return Receipt","Posted Return Shipment",Booking,"Posted Order","Posted Debit Note",Requisition,Services,"Posted Credit Note"; RespCenterCode: Code[10]; "Memo Type": Option " ","Insurance Memo","Custom Clearance Memo","Registration Memo"): Code[10]
    var
        RespCenter: Record "5714";
    begin
        IF RespCenter.GET(RespCenterCode) THEN BEGIN
            CASE "Document Profile" OF
                "Document Profile"::Purchase:
                    BEGIN
                        CASE "Document Type" OF
                            "Document Type"::"Blanket Order":
                                CASE "Memo Type" OF
                                    "Memo Type"::"Insurance Memo":
                                        EXIT(RespCenter."Insurance Memo Nos.");
                                    "Memo Type"::"Custom Clearance Memo":
                                        EXIT(RespCenter."Custom Clearance Memo Nos.");
                                    "Memo Type"::"Registration Memo":
                                        EXIT(RespCenter."Registration Memo Nos.");
                                    "Memo Type"::" ":
                                        EXIT(RespCenter."Purch. Blanket Order Nos.");
                                END;
                        END;
                    END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure TestMemoNoSeriesFromRespCenter("Document Profile": Option Purchase; "Document Type": Option " ","Blanket Order"; RespCenterCode: Code[10]; "Memo Type": Option " ","Insurance Memo","Custom Clearance Memo","Registration Memo")
    var
        RespCenter: Record "5714";
    begin
        IF RespCenter.GET(RespCenterCode) THEN BEGIN
            CASE "Document Profile" OF
                "Document Profile"::Purchase:
                    BEGIN
                        CASE "Document Type" OF
                            "Document Type"::"Blanket Order":
                                CASE "Memo Type" OF
                                    "Memo Type"::"Insurance Memo":
                                        RespCenter.TESTFIELD("Insurance Memo Nos.");
                                    "Memo Type"::"Custom Clearance Memo":
                                        RespCenter.TESTFIELD("Custom Clearance Memo Nos.");
                                    "Memo Type"::"Registration Memo":
                                        RespCenter.TESTFIELD("Registration Memo Nos.");
                                    "Memo Type"::" ":
                                        RespCenter.TESTFIELD("Purch. Blanket Order Nos.");
                                END;
                        END;
                    END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure GetSpecificationFromSalesLine(SalesLine: Record "37") SalesLineDescription: Text
    var
        ItemVariant: Record "5401";
        ModelVersion: Record "27";
        ServiceItem: Record "5940";
        ReservationEntry: Record "337";
        TrackingSpecBuffer: Record "336" temporary;
        ItemTrackingDocMgt: Codeunit "6503";
        Specification: BigText;
        TrackingSpecCount: Integer;
        InStr: InStream;
        CR: Char;
        LF: Char;
        SpecificationTxt: Label 'SPECIFICATION :';
        VINTxt: Label 'VIN :';
        VinNo: Code[20];
    begin
        CR := 13;
        LF := 10;

        SalesLineDescription := SalesLine.Description;
        IF "Line Type" = "Line Type"::Vehicle THEN BEGIN
            SalesLineDescription := SalesLine.FIELDCAPTION("Make Code") + ' : ' + "Make Code" + FORMAT(CR) + FORMAT(LF);
            SalesLineDescription += SalesLine.FIELDCAPTION("Model Code") + ' : ' + "Model Code" + FORMAT(CR) + FORMAT(LF);

            CASE SalesLine."Document Type" OF
                SalesLine."Document Type"::Quote:
                    ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer,
                      SalesLine."Document No.", DATABASE::"Sales Header", 0);
                SalesLine."Document Type"::Order:
                    ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer,
                      SalesLine."Document No.", DATABASE::"Sales Header", 1);
            END;

            TrackingSpecBuffer.RESET;
            TrackingSpecBuffer.SETCURRENTKEY("Source ID", "Source Type", "Source Subtype", "Source Batch Name",
              "Source Prod. Order Line", "Source Ref. No.");
            TrackingSpecBuffer.SETRANGE("Source Ref. No.", SalesLine."Line No.");
            IF TrackingSpecBuffer.FINDFIRST THEN
                REPEAT
                    SalesLineDescription += VINTxt + ' ' + TrackingSpecBuffer."Serial No." + FORMAT(CR) + FORMAT(LF);
                    VinNo := TrackingSpecBuffer."Serial No."; //Agile RD August 8 2016
                UNTIL TrackingSpecBuffer.NEXT = 0;

            //Agile RD August 8 2016
            ServiceItem.RESET;
            ServiceItem.SETRANGE(ServiceItem."No.", VinNo);
            IF ServiceItem.FINDFIRST THEN
                REPEAT
                    IF ServiceItem."Engine No." <> '' THEN
                        SalesLineDescription += Text50000 + ' ' + ServiceItem."Engine No." + FORMAT(CR) + FORMAT(LF);
                    IF ServiceItem."Registration No." <> '' THEN
                        SalesLineDescription += Text50001 + ' ' + ServiceItem."Registration No." + FORMAT(CR) + FORMAT(LF);
                    IF ServiceItem."Variant Code" <> '' THEN
                        SalesLineDescription += Text50002 + ' ' + ServiceItem."Variant Code" + FORMAT(CR) + FORMAT(LF);
                UNTIL ServiceItem.NEXT = 0;
            //Agile RD August 8 2016
            IF SalesLine."Variant Code" = '' THEN BEGIN
                IF ModelVersion.GET("Model Version No.") THEN BEGIN
                    CLEAR(Specification);

                    ServiceItem.RESET;
                    ServiceItem.GET(VinNo);
                    IF NOT ServiceItem."Body Builded" THEN BEGIN
                        ModelVersion.CALCFIELDS(Specifications);
                        ModelVersion.Specifications.CREATEINSTREAM(InStr);
                        Specification.READ(InStr);
                    END ELSE BEGIN      //Agile RD March 3 2017 >>
                        ModelVersion.CALCFIELDS(ModelVersion."Build Specifications");
                        ModelVersion."Build Specifications".CREATEINSTREAM(InStr);
                        Specification.READ(InStr);
                    END;      //Agile RD March 3 2017 <<

                    SalesLineDescription += FORMAT(CR) + FORMAT(LF) + SpecificationTxt + FORMAT(CR) + FORMAT(LF) + FORMAT(Specification) + FORMAT(CR) + FORMAT(LF);
                END;
            END
            ELSE BEGIN
                IF ItemVariant.GET("Model Version No.", SalesLine."Variant Code") THEN BEGIN
                    CLEAR(Specification);
                    ItemVariant.CALCFIELDS(Specifications);
                    ItemVariant.Specifications.CREATEINSTREAM(InStr);
                    Specification.READ(InStr);
                    SalesLineDescription += FORMAT(CR) + FORMAT(LF) + SpecificationTxt + FORMAT(CR) + FORMAT(LF) + FORMAT(Specification) + FORMAT(CR) + FORMAT(LF);
                END;
            END;
        END;
        EXIT(SalesLineDescription);
    end;

    [Scope('Internal')]
    procedure GetSpecificationFromSalesInvoiceLine(SalesInvoiceLine: Record "113") SalesLineDescription: Text
    var
        ItemVariant: Record "5401";
        ModelVersion: Record "27";
        ServiceItem: Record "5940";
        TrackingSpecBuffer: Record "336" temporary;
        ItemTrackingDocMgt: Codeunit "6503";
        Specification: BigText;
        InStr: InStream;
        CR: Char;
        LF: Char;
        SpecificationTxt: Label 'SPECIFICATION :';
        VINTxt: Label 'VIN :';
        VinNo: Code[20];
    begin
        CR := 13;
        LF := 10;

        SalesLineDescription := SalesInvoiceLine.Description;
        IF SalesInvoiceLine."Line Type" = SalesInvoiceLine."Line Type"::Vehicle THEN BEGIN
            SalesLineDescription := SalesInvoiceLine.FIELDCAPTION("Make Code") + ' : ' + SalesInvoiceLine."Make Code" + FORMAT(CR) + FORMAT(LF);
            SalesLineDescription += SalesInvoiceLine.FIELDCAPTION("Model Code") + ' : ' + SalesInvoiceLine."Model Code" + FORMAT(CR) + FORMAT(LF);

            ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer,
                SalesInvoiceLine."Document No.", DATABASE::"Sales Invoice Header", 0);
            TrackingSpecBuffer.RESET;
            TrackingSpecBuffer.SETCURRENTKEY("Source ID", "Source Type", "Source Subtype", "Source Batch Name",
              "Source Prod. Order Line", "Source Ref. No.");
            TrackingSpecBuffer.SETRANGE("Source Ref. No.", SalesInvoiceLine."Line No.");
            IF TrackingSpecBuffer.FINDFIRST THEN
                REPEAT
                    SalesLineDescription += VINTxt + ' ' + TrackingSpecBuffer."Serial No." + FORMAT(CR) + FORMAT(LF);
                    VinNo := TrackingSpecBuffer."Serial No."; //Agile RD August 8 2016
                UNTIL TrackingSpecBuffer.NEXT = 0;
            IF VinNo = '' THEN BEGIN
                VinNo := "Serial No."; //Agile RD December 6 2016
                SalesLineDescription += VINTxt + ' ' + "Serial No." + FORMAT(CR) + FORMAT(LF);
            END;
            //Agile RD August 8 2016
            ServiceItem.RESET;
            ServiceItem.SETRANGE(ServiceItem."No.", VinNo);
            IF ServiceItem.FINDFIRST THEN
                REPEAT
                    IF ServiceItem."Engine No." <> '' THEN
                        SalesLineDescription += Text50000 + ' ' + ServiceItem."Engine No." + FORMAT(CR) + FORMAT(LF);
                    IF ServiceItem."Registration No." <> '' THEN
                        SalesLineDescription += Text50001 + ' ' + ServiceItem."Registration No." + FORMAT(CR) + FORMAT(LF);
                    IF ServiceItem."Variant Code" <> '' THEN
                        SalesLineDescription += Text50002 + ' ' + ServiceItem."Variant Code" + FORMAT(CR) + FORMAT(LF);
                UNTIL ServiceItem.NEXT = 0;
            //Agile RD August 8 2016

            IF SalesInvoiceLine."Variant Code" = '' THEN BEGIN
                IF ModelVersion.GET(SalesInvoiceLine."Model Version No.") THEN BEGIN
                    CLEAR(Specification);

                    ServiceItem.RESET;
                    ServiceItem.GET(VinNo);
                    IF NOT ServiceItem."Body Builded" THEN BEGIN
                        ModelVersion.CALCFIELDS(Specifications);
                        ModelVersion.Specifications.CREATEINSTREAM(InStr);
                        Specification.READ(InStr);
                    END ELSE BEGIN      //Agile RD March 3 2017 >>
                        ModelVersion.CALCFIELDS(ModelVersion."Build Specifications");
                        ModelVersion."Build Specifications".CREATEINSTREAM(InStr);
                        Specification.READ(InStr);
                    END;      //Agile RD March 3 2017 <<

                    SalesLineDescription += FORMAT(CR) + FORMAT(LF) + SpecificationTxt + FORMAT(CR) + FORMAT(LF) + FORMAT(Specification) + FORMAT(CR) + FORMAT(LF);
                END;
            END
            ELSE BEGIN
                IF ItemVariant.GET(SalesInvoiceLine."Model Version No.", SalesInvoiceLine."Variant Code") THEN BEGIN
                    CLEAR(Specification);
                    ItemVariant.CALCFIELDS(Specifications);
                    ItemVariant.Specifications.CREATEINSTREAM(InStr);
                    Specification.READ(InStr);
                    SalesLineDescription += FORMAT(CR) + FORMAT(LF) + SpecificationTxt + FORMAT(CR) + FORMAT(LF) + FORMAT(Specification) + FORMAT(CR) + FORMAT(LF);
                END;
            END;
        END;
        EXIT(SalesLineDescription);
    end;

    [Scope('Internal')]
    procedure GetSpecificationFromSalesShptLine(SalesShipmentLine: Record "111") SalesLineDescription: Text
    var
        ItemVariant: Record "5401";
        ModelVersion: Record "27";
        ServiceItem: Record "5940";
        TrackingSpecBuffer: Record "336" temporary;
        ItemTrackingDocMgt: Codeunit "6503";
        Specification: BigText;
        InStr: InStream;
        CR: Char;
        LF: Char;
        SpecificationTxt: Label 'SPECIFICATION :';
        VINTxt: Label 'VIN :';
    begin
        CR := 13;
        LF := 10;

        SalesLineDescription := SalesShipmentLine.Description;
        IF SalesShipmentLine."Line Type" = SalesShipmentLine."Line Type"::Vehicle THEN BEGIN
            SalesLineDescription := SalesShipmentLine.FIELDCAPTION("Make Code") + ' : ' + SalesShipmentLine."Make Code" + FORMAT(CR) + FORMAT(LF);
            SalesLineDescription += SalesShipmentLine.FIELDCAPTION("Model Code") + ' : ' + SalesShipmentLine."Model Code" + FORMAT(CR) + FORMAT(LF);

            ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer,
                SalesShipmentLine."Document No.", DATABASE::"Sales Shipment Header", 0);
            TrackingSpecBuffer.RESET;
            TrackingSpecBuffer.SETCURRENTKEY("Source ID", "Source Type", "Source Subtype", "Source Batch Name",
              "Source Prod. Order Line", "Source Ref. No.");
            TrackingSpecBuffer.SETRANGE("Source Ref. No.", SalesShipmentLine."Line No.");
            IF TrackingSpecBuffer.FINDFIRST THEN
                REPEAT
                    SalesLineDescription += VINTxt + ' ' + TrackingSpecBuffer."Serial No." + FORMAT(CR) + FORMAT(LF)
UNTIL TrackingSpecBuffer.NEXT = 0;

            IF SalesShipmentLine."Variant Code" = '' THEN BEGIN
                IF ModelVersion.GET(SalesShipmentLine."Model Version No.") THEN BEGIN
                    CLEAR(Specification);
                    ModelVersion.CALCFIELDS(Specifications);
                    ModelVersion.Specifications.CREATEINSTREAM(InStr);
                    Specification.READ(InStr);
                    SalesLineDescription += FORMAT(CR) + FORMAT(LF) + SpecificationTxt + FORMAT(CR) + FORMAT(LF) + FORMAT(Specification) + FORMAT(CR) + FORMAT(LF);
                END;
            END
            ELSE BEGIN
                IF ItemVariant.GET(SalesShipmentLine."Model Version No.", SalesShipmentLine."Variant Code") THEN BEGIN
                    CLEAR(Specification);
                    ItemVariant.CALCFIELDS(Specifications);
                    ItemVariant.Specifications.CREATEINSTREAM(InStr);
                    Specification.READ(InStr);
                    SalesLineDescription += FORMAT(CR) + FORMAT(LF) + SpecificationTxt + FORMAT(CR) + FORMAT(LF) + FORMAT(Specification) + FORMAT(CR) + FORMAT(LF);
                END;
            END;
        END;
        EXIT(SalesLineDescription);
    end;

    [Scope('Internal')]
    procedure CheckAnyServiceItemBlockeBeforeSales(CustomerNo: Code[20]; DocumentNo: Code[20]; warning: Boolean): Boolean
    var
        ServiceItem: Record "5940";
        BloackedVehicleLog: Record "50070";
        UserSetup: Record "91";
        blocked: Boolean;
        ErrMsgServItemBlocked: Label 'Service Item No. %1 associated with Customer No. %2 is blocked. User will not be able to create sales lines. Therefore, Please contact recovery team for further action.';
    begin
        //Restricting the Customers who are associated with blocked customers
        IF CustomerNo = '' THEN
            EXIT(FALSE);
        UserSetup.GET(USERID);
        blocked := FALSE;
        ServiceItem.RESET;
        ServiceItem.SETRANGE(ServiceItem.Blocked, TRUE);
        ServiceItem.SETRANGE(ServiceItem."Customer No.", CustomerNo);
        IF ServiceItem.FINDFIRST THEN BEGIN
            BloackedVehicleLog.RESET;
            BloackedVehicleLog.INIT;
            BloackedVehicleLog."Entry No." := BloackedVehicleLog.GetEntryNo;
            BloackedVehicleLog."Service Item No." := ServiceItem."No.";
            BloackedVehicleLog."Customer No." := CustomerNo;
            BloackedVehicleLog.Date := TODAY;
            BloackedVehicleLog.Time := TIME;
            BloackedVehicleLog."Document Type" := BloackedVehicleLog."Document Type"::Sales;
            BloackedVehicleLog."Document No." := DocumentNo;
            BloackedVehicleLog."User ID" := USERID;
            BloackedVehicleLog."Location Code" := UserSetup."Default Location Code";
            BloackedVehicleLog.Branch := UserSetup."Default Responsibility Center";
            BloackedVehicleLog.INSERT;
            COMMIT;   //Since bill to customer is not validated any where in sales post
                      //Commit will not affect the posting
            IF warning THEN BEGIN
                MESSAGE(ErrMsgServItemBlocked, ServiceItem."No.", CustomerNo);
            END ELSE
                ERROR(ErrMsgServItemBlocked, ServiceItem."No.", CustomerNo);
            blocked := TRUE;

        END;
        IF blocked THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure WarningOrError(Warning: Boolean; ServiceItemNo: Code[20]; CustomerNo: Code[20])
    var
        ErrMsgServItemBlocked: Label 'Service Item No. %1 associated with Customer No. %2 is blocked. User will not be able to create sales lines. Therefore, Please contact recovery team for further action.';
    begin
        IF Warning THEN
            MESSAGE(ErrMsgServItemBlocked, ServiceItemNo, CustomerNo)
        ELSE
            ERROR(ErrMsgServItemBlocked, ServiceItemNo, CustomerNo);
    end;

    local procedure "---IME---"()
    begin
    end;

    [Scope('Internal')]
    procedure CreateGatePassOnSalesInvoice(SalesInvHeader: Record "112"): Code[20]
    var
        GatePass: Record "50004";
        UserSetup: Record "91";
        GatePass2: Record "50004";
    begin
        UserSetup.GET(USERID);

        GatePass2.RESET;
        GatePass2.SETRANGE(GatePass2."External Document No.", SalesInvHeader."No.");
        GatePass2.SETRANGE(GatePass2."Source Type", GatePass2."Source Type"::"Sales Invoice");
        GatePass2.SETRANGE(GatePass2."Gate Pass For", GatePass2."Gate Pass For"::"Sales Invoice");
        IF GatePass2.ISEMPTY THEN BEGIN
            IF SalesInvHeader."Document Profile" = SalesInvHeader."Document Profile"::"Vehicles Trade" THEN BEGIN
                GatePass."Document Type" := GatePass."Document Type"::"Vehicle Dispatch";
                GatePass.Location := UserSetup."Default Location Code";
                GatePass."External Document No." := SalesInvHeader."No.";
                GatePass.VALIDATE("VIN No.", SalesInvHeader."Serial No.");
                "Source Type" := GatePass."Source Type"::"Sales Invoice";
                "Gate Pass For" := GatePass."Gate Pass For"::"Sales Invoice";
                Automatic := TRUE;
                GatePass.INSERT(TRUE);
                DocNo := GatePass."Document No";
                COMMIT;
                //MESSAGE('Gate pass: %1 created',GatePass."Document No");
            END ELSE BEGIN
                GatePass."Document Type" := GatePass."Document Type"::Spares;
                GatePass.Location := UserSetup."Default Location Code";
                GatePass."External Document No." := SalesInvHeader."No.";
                GatePass.Type := GatePass.Type::"Non-Returnable";
                "Source Type" := GatePass."Source Type"::"Sales Invoice";
                "Gate Pass For" := GatePass."Gate Pass For"::"Sales Invoice";
                Automatic := TRUE;
                GatePass.INSERT(TRUE);
                DocNo := GatePass."Document No";
                COMMIT;
                //MESSAGE('Gate pass: %1 created',GatePass."Document No");
            END;
        END ELSE BEGIN
            IF GatePass2.FINDFIRST THEN
                DocNo := GatePass2."Document No";
        END;
        GatePass2.RESET;
        GatePass2.SETRANGE(GatePass2."Document No", DocNo);
        IF GatePass2.FINDFIRST THEN
            REPORT.RUN(50046, TRUE, FALSE, GatePass2);
    end;

    [Scope('Internal')]
    procedure CreateGatePassOnTransferShpt(TransferShptHeader: Record "5744"): Code[20]
    var
        GatePass: Record "50004";
        UserSetup: Record "91";
        GatePass2: Record "50004";
    begin
        UserSetup.GET(USERID);
        GatePass2.RESET;
        GatePass2.SETRANGE(GatePass2."Document Type", GatePass2."Document Type"::Spares);
        GatePass2.SETRANGE(GatePass2."External Document No.", TransferShptHeader."No.");
        GatePass2.SETRANGE(GatePass2."Source Type", GatePass2."Source Type"::"Transfer Shipment");
        GatePass2.SETRANGE(GatePass2."Gate Pass For", GatePass2."Gate Pass For"::"Transfer Shipment");
        IF GatePass2.ISEMPTY THEN BEGIN
            GatePass."Document Type" := GatePass."Document Type"::Spares;
            GatePass.Location := UserSetup."Default Location Code";
            GatePass."External Document No." := TransferShptHeader."No.";
            "Source Type" := GatePass."Source Type"::"Transfer Shipment";
            "Gate Pass For" := GatePass."Gate Pass For"::"Transfer Shipment";
            Automatic := TRUE;
            GatePass.INSERT(TRUE);
            DocNo := GatePass."Document No";
            COMMIT;
            //MESSAGE('Gate pass: %1 created',GatePass."Document No");
        END ELSE BEGIN
            IF GatePass2.FINDFIRST THEN
                DocNo := GatePass2."Document No";
        END;
        GatePass2.SETRANGE(GatePass2."Document No", DocNo);

        IF GatePass2.FINDFIRST THEN
            REPORT.RUN(50046, TRUE, FALSE, GatePass2);
    end;

    local procedure "--IME Recovery--"()
    begin
    end;

    [Scope('Internal')]
    procedure CreateRecoveryDocumentOnSalesInvoice(SalesInvHeader: Record "112")
    var
        RecoveryHeader: Record "50099";
        ServiceItem: Record "5940";
        RecoveryHeader2: Record "50099";
        SalesInvoiceLine: Record "113";
        SalesPeople: Record "13";
        SysMgt: Codeunit "50014";
        MemoHdr: Record "50101";
    begin
        //Sulav added so that during sales post related memo will be linked with recovery document
        IF SalesInvHeader."Memo No." <> '' THEN
            GetMemoHdrFromSalesInvoice(SalesInvHeader, MemoHdr);

        RecoveryHeader2.RESET;
        RecoveryHeader2.SETRANGE(RecoveryHeader2."Customer No.", SalesInvHeader."Bill-to Customer No.");
        RecoveryHeader2.SETRANGE(RecoveryHeader2."Vehicle No.", SalesInvHeader."Serial No.");
        IF NOT RecoveryHeader2.FINDFIRST THEN BEGIN
            RecoveryHeader.RESET;
            RecoveryHeader.INIT;
            RecoveryHeader.VALIDATE(RecoveryHeader."Customer No.", SalesInvHeader."Bill-to Customer No.");
            RecoveryHeader.VALIDATE(RecoveryHeader."Invoice Date", SalesInvHeader."Posting Date");
            RecoveryHeader.VALIDATE(RecoveryHeader."Invoice No.", SalesInvHeader."No.");
            RecoveryHeader.VALIDATE(RecoveryHeader.AutoCreated, TRUE);
            RecoveryHeader.VALIDATE(RecoveryHeader."Sales Person Code", SalesInvHeader."Salesperson Code");
            SalesPeople.RESET;
            IF SalesInvHeader."Salesperson Code" <> '' THEN BEGIN
                SalesPeople.GET(SalesInvHeader."Salesperson Code");
                RecoveryHeader.VALIDATE(RecoveryHeader."Recovery Hub", SalesPeople."Recovery Hub");
            END;
            RecoveryHeader.VALIDATE(RecoveryHeader."Financer Code", SalesInvHeader."Financed By No.");
            RecoveryHeader.VALIDATE(RecoveryHeader."Vehicle No.", SalesInvHeader."Serial No.");
            RecoveryHeader.VALIDATE(RecoveryHeader."Shortcut Dimension 1 Code", SalesInvHeader."Shortcut Dimension 1 Code");
            RecoveryHeader.VALIDATE(RecoveryHeader."Finance %", 70); //Fixed for all company User will Change if needed
            SalesInvHeader.CALCFIELDS(SalesInvHeader."Amount Including VAT");
            //RecoveryHeader.VALIDATE("Actual Delivery Date",SalesInvHeader
            SalesInvoiceLine.RESET;
            SalesInvoiceLine.SETRANGE(SalesInvoiceLine."Document No.", SalesInvHeader."No.");
            IF SalesInvoiceLine.FINDFIRST THEN BEGIN
                RecoveryHeader.VALIDATE(RecoveryHeader."Actual Delivery Date", SalesInvoiceLine."Actual Delivery Date");
                RecoveryHeader.VALIDATE(RecoveryHeader."Make Code", SalesInvoiceLine."Make Code");
            END;
            ServiceItem.GET(SalesInvHeader."Serial No.");
            RecoveryHeader.VALIDATE(RecoveryHeader."Model Version No.", ServiceItem."Item No.");
            RecoveryHeader.VALIDATE(RecoveryHeader."Invoice Amount", SalesInvHeader."Amount Including VAT");
            RecoveryHeader.VALIDATE(RecoveryHeader."Due Date", SalesInvHeader."Due Date");
            //SRT >>
            IF MemoHdr."DO Status" = MemoHdr."DO Status"::"DO Received" THEN BEGIN
                RecoveryHeader."DO in Hand Received Date" := MemoHdr."DO in Hand Received Date";
                RecoveryHeader."Recovery Status" := RecoveryHeader."Recovery Status"::"OT Pending";
                RecoveryHeader."DO Status" := RecoveryHeader."DO Status"::"Do Received";
                RecoveryHeader."DO AMT" := MemoHdr."DO Amount";
            END;
            //SRT <<
            RecoveryHeader.INSERT(TRUE);
        END
        ELSE BEGIN //pram
            RecoveryHeader2.VALIDATE("Customer No.", SalesInvHeader."Bill-to Customer No.");
            RecoveryHeader2.VALIDATE("Invoice Date", SalesInvHeader."Posting Date");
            RecoveryHeader2.VALIDATE("Invoice No.", SalesInvHeader."No.");
            IF SalesPeople.GET(SalesInvHeader."Salesperson Code") THEN
                RecoveryHeader2.VALIDATE("Recovery Hub", SalesPeople."Recovery Hub");
            RecoveryHeader2.VALIDATE("Sales Person Code", SalesInvHeader."Salesperson Code");
            RecoveryHeader2.VALIDATE("Financer Code", SalesInvHeader."Financed By No.");
            RecoveryHeader2.VALIDATE("Shortcut Dimension 1 Code", SalesInvHeader."Shortcut Dimension 1 Code");

            //RecoveryHeader2.VALIDATE("Finance %",70); //Fixed for all company User will Change if needed

            SalesInvHeader.CALCFIELDS(SalesInvHeader."Amount Including VAT");
            RecoveryHeader2.VALIDATE("Invoice Amount", SalesInvHeader."Amount Including VAT");
            RecoveryHeader2.VALIDATE("Due Date", SalesInvHeader."Due Date");
            //SRT >>
            IF MemoHdr."DO Status" = MemoHdr."DO Status"::"DO Received" THEN BEGIN
                RecoveryHeader2."DO in Hand Received Date" := MemoHdr."DO in Hand Received Date";
                RecoveryHeader2."Recovery Status" := RecoveryHeader2."Recovery Status"::"OT Pending";
                RecoveryHeader2."DO Status" := RecoveryHeader."DO Status"::"Do Received";
                RecoveryHeader2."DO AMT" := MemoHdr."DO Amount";
            END;
            //SRT <<
            RecoveryHeader2.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure GetRecoveryApplication(var RecLines: Record "50100")
    var
        RecoveryLines: Record "50100";
        CLEPage: Page "25";
        CLE: Record "21";
        SourceCodeSetup: Record "242";
        ErrApp: Label 'No Ledgers found for application';
        ChosenCLE: Record "21";
        ErrCount: Label 'Kindly Select a single line for recovery application';
        RecoveryHeader: Record "50099";
        ErrApplied: Label 'Chosen Ledger Entry Has already been applied to Document No. %1';
        AlreadyAppliedAmount: Decimal;
        ErrApplicableAmountExcced: Label 'Document No. %1 is no more applicable.';
        CLE2: Record "21";
        ApplicableChosenCLETotalAmount: Decimal;
    begin

        //SourceCodeSetup.GET;
        RecoveryHeader.GET(RecLines."Document No");
        //CLE.SETRANGE(CLE."Source Code",SourceCodeSetup."Cash Receipt Journal");
        CLE.SETRANGE(CLE."Customer No.", RecoveryHeader."Customer No.");
        //CLE.SETRANGE(CLE.Reversed,FALSE);
        CLE.SETFILTER(CLE.Amount, '<%1', 0);
        IF CLE.FINDSET THEN BEGIN
            CLEPage.SETRECORD(CLE);
            CLEPage.SETTABLEVIEW(CLE);
            CLEPage.LOOKUPMODE(TRUE);
            IF CLEPage.RUNMODAL = ACTION::LookupOK THEN BEGIN
                CLEPage.GETRECORD(ChosenCLE);

                //Because Sometimes multiple Customer ledger entry with same document number of same customer are also to be considered
                ApplicableChosenCLETotalAmount := 0;
                CLE2.RESET;
                CLE2.SETRANGE(CLE2."Document No.", ChosenCLE."Document No.");
                CLE2.SETRANGE(CLE2."Customer No.", RecoveryHeader."Customer No.");
                CLE2.SETAUTOCALCFIELDS(CLE2.Amount);
                IF CLE2.FINDFIRST THEN
                    REPEAT
                        ApplicableChosenCLETotalAmount += CLE2.Amount;
                    UNTIL CLE2.NEXT = 0;

                //checking if document applicable;
                CLEAR(AlreadyAppliedAmount);
                RecoveryLines.SETAUTOCALCFIELDS(RecoveryLines."Customer No");
                RecoveryLines.SETRANGE(RecoveryLines."Customer No", ChosenCLE."Customer No.");
                RecoveryLines.SETRANGE(RecoveryLines."Cash Receipt No.", ChosenCLE."Document No.");
                IF RecoveryLines.FINDFIRST THEN
                    REPEAT
                        RecoveryHeader.RESET;
                        RecoveryHeader.SETRANGE(RecoveryHeader."No.", RecoveryLines."Document No");
                        IF RecoveryHeader.FINDFIRST THEN
                            IF NOT RecoveryHeader.Cancelled THEN    //Agile RD 17.12.3 Ignoring cancelled Recoveries
                                AlreadyAppliedAmount += RecoveryLines."Effective Amount";
                    //ERROR(ErrApplied,RecoveryLines."Document No");
                    UNTIL RecoveryLines.NEXT = 0;
                //IF AlreadyAppliedAmount >= ABS(ChosenCLE.Amount) THEN
                IF AlreadyAppliedAmount >= ABS(ApplicableChosenCLETotalAmount) THEN
                    ERROR(ErrApplicableAmountExcced, ChosenCLE."Document No.");

                //checking if document applicable;
                RecLines."Cash Receipt Amount" := ChosenCLE.Amount;
                RecLines."Cash Receipt No." := ChosenCLE."Document No.";
                RecLines."Receipt Voucher Posting Date" := ChosenCLE."Posting Date";
                RecLines.MODIFY;
            END
        END ELSE BEGIN
            ERROR(ErrApp);
        END;
    end;

    [Scope('Internal')]
    procedure CheckInvoiceAmountVsRecovery(RecoveryHeader: Record "50099")
    var
        RecoveryLines: Record "50100";
        RecoveredAmount: Decimal;
        ErrRecoveryAmount: Label 'Recovered Amount %1 is less than Invoice Amount %2';
    begin
        RecoveredAmount := 0;
        RecoveryLines.SETRANGE(RecoveryLines."Document No", RecoveryHeader."No.");
        RecoveryLines.SETRANGE(RecoveryLines."Line Type", RecoveryLines."Line Type"::"Recovery Lines");
        IF RecoveryLines.FINDFIRST THEN
            REPEAT
                // IF RecoveryLines.Type IN [RecoveryLines.Type::"Down Payment",RecoveryLines.Type::Commission] THEN
                RecoveredAmount -= RecoveryLines."Effective Amount";
            UNTIL RecoveryLines.NEXT = 0;
        IF ABS(RecoveredAmount) < RecoveryHeader."Invoice Amount" THEN
            ERROR(ErrRecoveryAmount, RecoveredAmount, RecoveryHeader."Invoice Amount");
    end;

    [Scope('Internal')]
    procedure CheckApplicableAmount()
    begin
    end;

    local procedure "--LocalPartsPriceManagement--"()
    begin
    end;

    [Scope('Internal')]
    procedure GetAppropriatePrice(ItemNo: Code[20]; Posting: Boolean): Decimal
    var
        Item: Record "27";
        ILE: Record "32";
        AccountingPeriod: Record "50";
        StartingDate: Date;
        EndingDate: Date;
        SalesSetup: Record "311";
        CostPerUnit: Decimal;
        CalculatedPrice: Decimal;
        ProductGrp: Record "5723";
        TotalQty: Decimal;
        TotalCostPerUnit: Decimal;
        ValueEntries: Record "5802";
    begin
        CLEAR(CostPerUnit);
        Item.RESET;
        Item.GET(ItemNo);
        /*
        AccountingPeriod.SETFILTER(AccountingPeriod."Starting Date",'<=%1',TODAY);
        AccountingPeriod.SETRANGE(AccountingPeriod."New Fiscal Year",TRUE);
        AccountingPeriod.SETASCENDING(AccountingPeriod."Starting Date",FALSE);
        IF AccountingPeriod.FINDFIRST THEN
          StartingDate := AccountingPeriod."Starting Date";
        EndingDate := TODAY;
        */
        CostPerUnit := Item."Unit Cost";
        //Returning Price with Margin for Local Parts
        //Returning Highest Price if not Local Parts
        IF NOT Posting THEN BEGIN
            IF Item."Product Group Code" <> '' THEN BEGIN
                ProductGrp.RESET;
                ProductGrp.SETRANGE(ProductGrp.Code, Item."Product Group Code");
                IF ProductGrp.FINDFIRST THEN
                    IF ProductGrp."Local Parts" THEN BEGIN
                        SalesSetup.RESET;
                        SalesSetup.GET;
                        /*
                          ILE.RESET;
                          ILE.SETAUTOCALCFIELDS(ILE."Cost Per Unit");
                          //ILE.SETFILTER(ILE."Posting Date",'%1..%2',StartingDate,EndingDate);
                          ILE.SETFILTER(ILE."Entry Type",'%1|%2',ILE."Entry Type"::Purchase,ILE."Entry Type"::"Positive Adjmt.");
                          ILE.SETFILTER(ILE."Item No.",'=%1',ItemNo);
                          ILE.CALCFIELDS(ILE."Cost Per Unit");
                          IF ILE.FINDFIRST THEN
                            REPEAT
                              IF ILE."Cost Per Unit" > CostPerUnit THEN BEGIN
                                CostPerUnit := ILE."Cost Per Unit";
                              END;
                            UNTIL ILE.NEXT = 0;
                          */
                        ValueEntries.RESET;
                        //ILE.SETFILTER(ILE."Posting Date",'%1..%2',StartingDate,EndingDate);
                        ValueEntries.SETFILTER(ValueEntries."Item Ledger Entry Type", '%1|%2', ValueEntries."Item Ledger Entry Type"::Purchase, ValueEntries."Item Ledger Entry Type"::"Positive Adjmt.");
                        ValueEntries.SETFILTER(ValueEntries."Document Type", '%1|%2|%3', ValueEntries."Document Type"::"Purchase Invoice", ValueEntries."Document Type"::"Purchase Receipt", ValueEntries."Document Type"::" ");
                        ValueEntries.SETFILTER(ValueEntries."Item No.", '=%1', ItemNo);
                        IF ValueEntries.FINDFIRST THEN
                            REPEAT
                                IF ValueEntries."Cost per Unit" > CostPerUnit THEN BEGIN
                                    CostPerUnit := ValueEntries."Cost per Unit";
                                END;
                            UNTIL ValueEntries.NEXT = 0;
                        CalculatedPrice := CostPerUnit * (1 + (SalesSetup."Local Parts Margin Percentage" / 100))
                    END ELSE
                        CalculatedPrice := CostPerUnit;
            END ELSE
                CalculatedPrice := CostPerUnit;
        END ELSE
            CalculatedPrice := CostPerUnit;
        EXIT(CalculatedPrice);

    end;

    [Scope('Internal')]
    procedure IsServiceCreditSalesApprovalsWorkflowEnabled(var ServiceHeader: Record "5900"): Boolean
    var
        WorkflowManagement: Codeunit "1501";
        WorkflowEventHandling: Codeunit "1520";
        ManageTV: Codeunit "50018";
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ServiceHeader, ManageTV.OnServiceDocSendForApprovalCode));
    end;

    [Scope('Internal')]
    procedure IsMemoHeaderApprovalsWorkflowEnabled(var MemoHeader: Record "50101"): Boolean
    var
        WorkflowManagement: Codeunit "1501";
        WorkflowEventHandling: Codeunit "1520";
        ManageTV: Codeunit "50018";
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(MemoHeader, ManageTV.OnMemoHeaderSendForApprovalCode));
    end;

    local procedure "--SalesBillingMemo--"()
    begin
    end;

    [Scope('Internal')]
    procedure PostSalesBillingMemo(SalesInvHdr: Record "112")
    var
        MemoHdr: Record "50101";
        MemoLine: Record "50102";
        Opportunity: Record "5092";
        OpportunityEntry: Record "5093";
    begin
        MemoHdr.RESET;
        MemoHdr.SETRANGE("Document Type", "Memo Type");
        MemoHdr.SETRANGE(SalesInvHdr."No.", "Memo No.");
        IF MemoHdr.FINDFIRST THEN BEGIN
            MemoHdr."Posted Date" := SalesInvHdr."Posting Date";
            MemoHdr."Document Posted" := TRUE;
            MemoHdr."Memo Status" := MemoHdr."Memo Status"::Completed;
            MemoHdr."Memo Stage" := MemoHdr."Memo Stage"::"5. Billing Done";
            MemoHdr."Posted By" := USERID;
            MemoHdr."Invoice Date" := SalesInvHdr."Posting Date";
            MemoHdr."Invoice No." := SalesInvHdr."No.";
            MemoHdr.MODIFY;

            //pram 9.17.2019
            IF Opportunity.GET(SalesInvHdr."Opportunity No.") THEN BEGIN
                Opportunity.ChangeActivetoFalse(Opportunity."No.");

                OpportunityEntry.RESET;
                OpportunityEntry.INIT;
                OpportunityEntry."Entry No." := Opportunity.GetNextOppEntryNo(Opportunity."No.");
                OpportunityEntry."Opportunity No." := Opportunity."No.";
                OpportunityEntry."Action Taken" := OpportunityEntry."Action Taken"::Next;
                OpportunityEntry."Sales Cycle Code" := Opportunity."Sales Cycle Code";
                OpportunityEntry."Sales Cycle Stage" := 9;
                OpportunityEntry."Date of Change" := TODAY;
                //OpportunityEntry."Estimated Value (LCY)" := Rec."Estimated Value (LCY)";
                OpportunityEntry."Sales Cycle Stage Description" := Opportunity.GetSalesCycleStageDescription(Opportunity."Sales Cycle Code", 9);
                OpportunityEntry.Active := TRUE;
                //OpportunityEntry."Estimated Close Date" := EstimatedCloseDate;
                //OpportunityEntry."Estimated Value (LCY)" := EstimatedValueLCY;
                //OpportunityEntry."Chances of Success %" := ChanceofSuccess;
                Opportunity.UpdateEstimates(OpportunityEntry."Sales Cycle Code", OpportunityEntry."Sales Cycle Stage", OpportunityEntry);

                OpportunityEntry.INSERT;
            END;
            //CreateSalesFollowUpDetails(MemoHdr,SalesInvHdr);  //ratan 11/7/19
        END;
    end;

    [Scope('Internal')]
    procedure CancelMemo(MemoHdr: Record "50101")
    var
        MemoLine: Record "50102";
    begin
        IF NOT CONFIRM('Do you want to cancel %1 memo no. %2?', FALSE, "Document Type", "No.") THEN
            EXIT;
        IF Cancelled THEN BEGIN
            MESSAGE('%1 memo %2 has already been cancelled.', "Document Type", "No.");
            EXIT;
        END;
        TESTFIELD("Cancelled Reason Code");
        TESTFIELD("Cancelled Reason Description");
        Cancelled := TRUE;
        "Cancelled By" := USERID;
        IF "Document Type" = "Document Type"::"Billing Memo" THEN
            "Sales Memo Type" := "Sales Memo Type"::Cancellation;
        MODIFY;
        /* //ratan update the followup on cancel as well 11.8.19
         FollowupDetails.RESET;
         FollowupDetails.SETRANGE("No.",MemoHdr."Cancelled Invoice No.");
         IF FollowupDetails.FINDFIRST THEN BEGIN
           FollowupDetails."Sales Memo Type" := FollowupDetails."Sales Memo Type"::Cancellation;
           FollowupDetails.MODIFY;
           END;*/

    end;

    [Scope('Internal')]
    procedure SendApproverEmail(var ApprovalEntry2: Record "454")
    var
        ApprovalEntry: Record "454";
        RecRef: RecordRef;
        TargetRecRef: RecordRef;
        MemoHeader: Record "50101";
        WorkflowUserGroupMember: Record "1541";
        Employee: Record "5200";
        WorkflowStepArgument: Record "1523";
        MailMgmt: Codeunit "50002";
        Msg: Text;
        ToID: Text;
        CcID: Text;
        LastUserId: Text;
        EmailBodyText: Text;
        i: Integer;
    begin
        CASE ApprovalEntry2."Table ID" OF
            50101://add other table with commas
                BEGIN
                END;
            ELSE
                EXIT;
        END;

        EmailBodyText := STRSUBSTNO('Document No. %1 status:', ApprovalEntry2."Document No.");

        EmailBodyText += '<table border="1">';
        EmailBodyText += '<tr>';
        EmailBodyText += STRSUBSTNO('<th>%1</th>', 'SN.');
        EmailBodyText += STRSUBSTNO('<th>%1</th>', 'Sender ID');
        EmailBodyText += STRSUBSTNO('<th>%1</th>', 'Approver ID');
        EmailBodyText += STRSUBSTNO('<th>%1</th>', 'Status');
        EmailBodyText += STRSUBSTNO('<th>%1</th>', 'Date Time');
        EmailBodyText += '</tr>';
        //emailbodytext += FORMAT(i) + '. ' + FORMAT(memoline."Service Item No.");


        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Record ID to Approve", ApprovalEntry2."Record ID to Approve");
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
        IF ApprovalEntry.FINDLAST THEN BEGIN
            Employee.RESET;
            Employee.SETFILTER("NAV Login ID", '<>%1&%2', '', ApprovalEntry."Sender ID");
            Employee.SETFILTER(Employee."E-Mail (Office)", '<>%1', '');
            IF Employee.FINDFIRST THEN
                ToID := Employee."E-Mail (Office)";
        END;


        ApprovalEntry.RESET;
        ApprovalEntry.SETCURRENTKEY("Approver ID");
        ApprovalEntry.SETRANGE("Record ID to Approve", ApprovalEntry2."Record ID to Approve");
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
        IF ApprovalEntry.FINDFIRST THEN
            REPEAT
                IF LastUserId <> ApprovalEntry."Approver ID" THEN BEGIN
                    LastUserId := ApprovalEntry."Approver ID";
                    Employee.RESET;
                    Employee.SETFILTER("NAV Login ID", '<>%1&%2', '', LastUserId);
                    Employee.SETFILTER(Employee."E-Mail (Office)", '<>%1', '');
                    IF Employee.FINDFIRST THEN
                        REPEAT
                            IF CcID = '' THEN
                                CcID := Employee."E-Mail (Office)"
                            ELSE
                                CcID += ';' + Employee."E-Mail (Office)";
                        UNTIL Employee.NEXT = 0;
                END;
            UNTIL ApprovalEntry.NEXT = 0;

        IF ToID = '' THEN BEGIN
            ToID := CcID;
            CcID := '';
        END;


        i := 0;
        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Record ID to Approve", ApprovalEntry2."Record ID to Approve");
        IF ApprovalEntry.FINDFIRST THEN
            REPEAT
                i += 1;
                EmailBodyText += '<tr>';
                EmailBodyText += STRSUBSTNO('<td>%1</td>', i);
                EmailBodyText += STRSUBSTNO('<td>%1</td>', ApprovalEntry."Sender ID");
                EmailBodyText += STRSUBSTNO('<td>%1</td>', ApprovalEntry."Approver ID");
                EmailBodyText += STRSUBSTNO('<td>%1</td>', ApprovalEntry.Status);
                //IF ApprovalEntry.Status <> ApprovalEntry.Status::Approved
                EmailBodyText += STRSUBSTNO('<td>%1</td>', ApprovalEntry."Last Date-Time Modified");
                EmailBodyText += '</tr>';

            UNTIL ApprovalEntry.NEXT = 0;

        EmailBodyText += '</table>';

        CLEAR(MailMgmt);
        MailMgmt.SendMail(FALSE, ToID, 'Document Approval Status', EmailBodyText, CcID, FALSE);
    end;

    [Scope('Internal')]
    procedure CheckCustomerCreditLimit(SalesHdr: Record "36")
    var
        Customer: Record "18";
    begin
        IF SalesHdr."Document Type" IN [SalesHdr."Document Type"::Order, SalesHdr."Document Type"::Invoice] THEN BEGIN
            /*TESTFIELD("Payment Type");
            IF "Payment Type" = "Payment Type"::Cash THEN
              TESTFIELD("Payment Method Code")
            ELSE IF "Payment Type" = "Payment Type"::Credit THEN
              TESTFIELD("Payment Method Code",'');*/

            IF Customer.GET(SalesHdr."Bill-to Customer No.") THEN BEGIN
                IF Customer."Skip Credit Limit Workflow" THEN
                    EXIT;
                IF Customer."Credit Limit (LCY)" > 0 THEN BEGIN
                    Customer.CALCFIELDS("Balance (LCY)");
                    SalesHdr.CALCFIELDS("Amount Including VAT");
                    IF (Customer."Balance (LCY)" + SalesHdr."Amount Including VAT") > Customer."Credit Limit (LCY)" THEN
                        ERROR('Credit limit exceeded for customer %1.\Unable to post the document.\Please contact accounts department.', Customer.Name);
                END;
            END;
        END;

    end;

    [Scope('Internal')]
    procedure CreatePurchaseOrder(PurchConsignment: Record "50094"): Boolean
    var
        PurchaseHeader: Record "38";
        Text101: Label 'Purchase Order %1 has been created.';
        Text102: Label 'Purchase Orders exist for Purchase Consignment No. %1. Do you to create new Purchase Order?';
    begin
        PurchaseHeader.RESET;
        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
        PurchaseHeader.INSERT(TRUE);
        PurchaseHeader."Purchase Consignment No." := PurchConsignment."No.";
        PurchaseHeader.MODIFY(TRUE);
        MESSAGE(Text101, PurchaseHeader."No.");
    end;

    [Scope('Internal')]
    procedure CreatePurchaseInvoice(PurchConsignment: Record "50094"): Boolean
    var
        PurchaseHeader: Record "38";
        Text101: Label 'Purchase Invoice %1 has been created.';
    begin
        PurchaseHeader.RESET;
        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
        PurchaseHeader.INSERT(TRUE);
        PurchaseHeader."Purchase Consignment No." := PurchConsignment."No.";
        PurchaseHeader.MODIFY(TRUE);
        MESSAGE(Text101, PurchaseHeader."No.");
    end;

    [Scope('Internal')]
    procedure CreatePurchaseCreditMemo(PurchConsignment: Record "50094"): Boolean
    var
        PurchaseHeader: Record "38";
        Text101: Label 'Purchase Credit Memo %1 has been created.';
        Text102: Label 'Purchase Credit Memo exist for Purchase Consignment No. %1. Do you want to create new Purchase Credit Memo?';
    begin
        PurchaseHeader.RESET;
        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Credit Memo";
        PurchaseHeader.INSERT(TRUE);
        PurchaseHeader."Purchase Consignment No." := PurchConsignment."No.";
        PurchaseHeader.MODIFY(TRUE);
        MESSAGE(Text101, PurchaseHeader."No.");
    end;

    [Scope('Internal')]
    procedure CreatePurchaseReturnOrder(PurchConsignment: Record "50094"): Boolean
    var
        PurchaseHeader: Record "38";
        Text101: Label 'Purchase Credit Memo %1 has been created.';
        Text102: Label 'Purchase Credit Memo exist for Purchase Consignment No. %1. Do you want to create new Purchase Credit Memo?';
    begin
        PurchaseHeader.RESET;
        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Return Order";
        PurchaseHeader.INSERT(TRUE);
        PurchaseHeader."Purchase Consignment No." := PurchConsignment."No.";
        PurchaseHeader.MODIFY(TRUE);
        MESSAGE(Text101, PurchaseHeader."No.");
    end;

    [Scope('Internal')]
    procedure UpdateReceivedQtyinReserved(ServiceLine: Record "5902")
    var
        ItemLedgerEntryRec: Record "32";
        ReservationEntryRec: Record "337";
        ReservationEntryRec2: Record "337";
    begin
        ReservationEntryRec.RESET;
        ReservationEntryRec.SETRANGE("Source ID", ServiceLine."Document No.");
        ReservationEntryRec.SETRANGE("Source Ref. No.", ServiceLine."Line No.");
        ReservationEntryRec.SETRANGE("Source Type", 5902);
        ReservationEntryRec.SETRANGE("Source Subtype", 1);
        ReservationEntryRec.SETRANGE("Reservation Status", ReservationEntryRec."Reservation Status"::Reservation);
        IF ReservationEntryRec.FINDFIRST THEN BEGIN
            ReservationEntryRec2.RESET;
            ReservationEntryRec2.SETRANGE("Entry No.", ReservationEntryRec."Entry No.");
            ReservationEntryRec2.SETRANGE("Source Type", 32);
            ReservationEntryRec2.SETRANGE("Source Subtype", 0);
            IF ReservationEntryRec2.FINDFIRST THEN
                REPEAT
                    ItemLedgerEntryRec.RESET;
                    ItemLedgerEntryRec.SETRANGE("Entry No.", ReservationEntryRec2."Source Ref. No.");
                    IF ItemLedgerEntryRec.FINDFIRST THEN BEGIN
                        ItemLedgerEntryRec."Service Order No." := ServiceLine."Document No.";
                        ItemLedgerEntryRec."Service Order Line No" := ServiceLine."Line No.";
                        ItemLedgerEntryRec.MODIFY;
                    END;
                UNTIL ReservationEntryRec2.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure GetMemoHdrFromSalesInvoice(SalesInvHdr: Record "112"; var MemoHdr: Record "50101")
    begin
        IF MemoHdr.GET("Memo Type", "Memo No.") THEN;
    end;

    local procedure "---BudgetMgmt---"()
    begin
    end;

    [Scope('Internal')]
    procedure CheckPurchaseBudget(var __PurchaseHeader: Record "38")
    var
        PurchLine: Record "39";
        GLBudgetEntry: Record "96";
        Dimension: Record "348";
        DimensionSetEntry: Record "480";
        GLAccount: Code[20];
        GenPostingSetup: Record "252";
        GenLedgerSetup: Record "98";
        GLBudgetRec: Record "95";
        PurchaseHeader: Record "38";
        PurchaseLine: Record "39";
        RequisitionLineReleasedAmount: Decimal;
        TotalBudget: Decimal;
        ConsumedAmount: Decimal;
        GLEntry: Record "17";
        GLPostingSetup: Record "252";
        PurchLine2: Record "39";
        FAPostingGroup: Record "5606";
        FA: Record "5600";
    begin
        //TESTFIELD(Status, Status::Released);
        GLSetup.GET;

        PurchLine.RESET;
        PurchLine.SETRANGE("Document No.", __PurchaseHeader."No.");
        PurchLine.SETRANGE("Document Type", __PurchaseHeader."Document Type");
        //PurchLine.SETFILTER(Type, '%1|%2', PurchLine.Type::"G/L Account", PurchLine.Type::Item);
        IF PurchLine.FINDFIRST THEN
            REPEAT
                CASE PurchLine.Type OF
                    PurchLine.Type::"G/L Account":
                        PurchLine."G/L Account No." := PurchLine."No.";
                    PurchLine.Type::Item:
                        BEGIN
                            IF GLPostingSetup.GET(PurchLine."Gen. Bus. Posting Group", PurchLine."Gen. Prod. Posting Group") THEN
                                PurchLine."G/L Account No." := GLPostingSetup."Purch. Account";
                        END;
                    PurchLine.Type::"Fixed Asset":
                        BEGIN
                            FA.GET(PurchaseLine."No.");
                            FAPostingGroup.GET(FA."FA Posting Group");
                            PurchLine."G/L Account No." := FAPostingGroup."Acquisition Cost Account";
                        END;
                END;
                PurchLine.MODIFY;
                CLEAR(RequisitionLineReleasedAmount);
                CLEAR(ConsumedAmount);
                CLEAR(TotalBudget);
                GLBudgetRec.RESET;
                GLBudgetRec.SETRANGE(Blocked, FALSE);
                GLBudgetRec.SETFILTER("Start Date", '<=%1', __PurchaseHeader."Order Date");
                GLBudgetRec.SETFILTER("End Date", '>=%1', __PurchaseHeader."Order Date");
                //GLBudgetRec.SETFILTER("G/L Account Filter", PurchLine."G/L Account No.");
                IF GLBudgetRec.FINDFIRST THEN
                    REPEAT
                        PurchLine2.RESET;
                        PurchLine2.SETRANGE("Document Type", PurchLine."Document Type");
                        PurchLine2.SETRANGE("Document No.", PurchLine."Document No.");
                        PurchLine2.SETRANGE("Line No.", PurchLine."Line No.");
                        PurchLine2.SETFILTER("G/L Account No.", GLBudgetRec."G/L Account Filter");
                        IF PurchLine2.FINDFIRST THEN BEGIN
                            CheckBudgetDimension(PurchLine."Dimension Set ID", GLBudgetRec."Shortcut Dimension 1 Code", PurchLine."No.");
                            CheckBudgetDimension(PurchLine."Dimension Set ID", GLBudgetRec."Shortcut Dimension 2 Code", PurchLine."No.");
                            CheckBudgetDimension(PurchLine."Dimension Set ID", GLBudgetRec."Budget Dimension 1 Code", PurchLine."No.");
                            CheckBudgetDimension(PurchLine."Dimension Set ID", GLBudgetRec."Budget Dimension 2 Code", PurchLine."No.");
                            CheckBudgetDimension(PurchLine."Dimension Set ID", GLBudgetRec."Budget Dimension 3 Code", PurchLine."No.");
                            CheckBudgetDimension(PurchLine."Dimension Set ID", GLBudgetRec."Budget Dimension 4 Code", PurchLine."No.");

                            //get gl budget amount
                            GLBudgetEntry.RESET;
                            GLBudgetEntry.SETRANGE("Budget Name", GLBudgetRec.Name);
                            GLBudgetEntry.SETRANGE("G/L Account No.", PurchLine."G/L Account No.");
                            IF GLBudgetRec."Shortcut Dimension 1 Code" <> '' THEN
                                GLBudgetEntry.SETFILTER("Global Dimension 1 Code", PurchLine."Shortcut Dimension 1 Code");
                            IF GLBudgetRec."Shortcut Dimension 2 Code" <> '' THEN
                                GLBudgetEntry.SETFILTER("Global Dimension 2 Code", PurchLine."Shortcut Dimension 2 Code");
                            IF GLBudgetRec."Budget Dimension 1 Code" <> '' THEN
                                GLBudgetEntry.SETFILTER("Budget Dimension 1 Code",
                                        GetBudgetDimensionValue(PurchLine."Dimension Set ID", GLBudgetRec."Budget Dimension 1 Code"));
                            IF GLBudgetRec."Budget Dimension 2 Code" <> '' THEN
                                GLBudgetEntry.SETFILTER("Budget Dimension 2 Code",
                                      GetBudgetDimensionValue(PurchLine."Dimension Set ID", GLBudgetRec."Budget Dimension 2 Code"));
                            IF GLBudgetRec."Budget Dimension 3 Code" <> '' THEN
                                GLBudgetEntry.SETFILTER("Budget Dimension 3 Code",
                                      GetBudgetDimensionValue(PurchLine."Dimension Set ID", GLBudgetRec."Budget Dimension 3 Code"));
                            IF GLBudgetRec."Budget Dimension 4 Code" <> '' THEN
                                GLBudgetEntry.SETFILTER("Budget Dimension 4 Code",
                                      GetBudgetDimensionValue(PurchLine."Dimension Set ID", GLBudgetRec."Budget Dimension 4 Code"));

                            GLBudgetEntry.CALCSUMS(Amount);
                            TotalBudget += GLBudgetEntry.Amount;

                            //check in requisition lines
                            PurchaseHeader.RESET;
                            PurchaseHeader.SETFILTER("Document Type", '<>%1', PurchaseHeader."Document Type"::Quote);
                            //PurchaseHeader.SETRANGE(Status, PurchaseHeader.Status::Released);
                            PurchaseHeader.SETRANGE("Order Date", GLBudgetRec."Start Date", GLBudgetRec."End Date");
                            IF PurchaseHeader.FINDFIRST THEN
                                REPEAT
                                    PurchaseLine.RESET;
                                    PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
                                    PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
                                    PurchaseLine.SETRANGE("G/L Account No.", PurchLine."G/L Account No.");

                                    IF GLBudgetRec."Shortcut Dimension 1 Code" <> '' THEN
                                        PurchaseLine.SETFILTER("Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 1 Code");
                                    IF GLBudgetRec."Shortcut Dimension 2 Code" <> '' THEN
                                        PurchaseLine.SETFILTER("Shortcut Dimension 2 Code", PurchLine."Shortcut Dimension 2 Code");
                                    IF HasDimensionFilter(GLSetup."Shortcut Dimension 3 Code", GLBudgetRec) THEN
                                        PurchaseLine.SETFILTER("Shortcut Dimension 3 Code", PurchLine."Shortcut Dimension 3 Code");
                                    IF HasDimensionFilter(GLSetup."Shortcut Dimension 4 Code", GLBudgetRec) THEN
                                        PurchaseLine.SETFILTER("Shortcut Dimension 4 Code", PurchLine."Shortcut Dimension 4 Code");
                                    IF HasDimensionFilter(GLSetup."Shortcut Dimension 5 Code", GLBudgetRec) THEN
                                        PurchaseLine.SETFILTER("Shortcut Dimension 5 Code", PurchLine."Shortcut Dimension 5 Code");
                                    IF HasDimensionFilter(GLSetup."Shortcut Dimension 6 Code", GLBudgetRec) THEN
                                        PurchaseLine.SETFILTER("Shortcut Dimension 6 Code", PurchLine."Shortcut Dimension 6 Code");
                                    IF HasDimensionFilter(GLSetup."Shortcut Dimension 7 Code", GLBudgetRec) THEN
                                        PurchaseLine.SETFILTER("Shortcut Dimension 7 Code", PurchLine."Shortcut Dimension 7 Code");
                                    IF HasDimensionFilter(GLSetup."Shortcut Dimension 8 Code", GLBudgetRec) THEN
                                        PurchaseLine.SETFILTER("Shortcut Dimension 8 Code", PurchLine."Shortcut Dimension 8 Code");

                                    PurchaseLine.CALCSUMS("Amount Including VAT");
                                    RequisitionLineReleasedAmount += PurchaseLine."Amount Including VAT";

                                UNTIL PurchaseHeader.NEXT = 0;

                            //check in g/l entry
                            GLEntry.RESET;
                            GLEntry.SETRANGE("G/L Account No.", PurchLine."G/L Account No.");
                            GLEntry.SETRANGE("Posting Date", GLBudgetRec."Start Date", GLBudgetRec."End Date");
                            IF GLBudgetRec."Shortcut Dimension 1 Code" <> '' THEN
                                GLEntry.SETFILTER("Global Dimension 1 Code", PurchLine."Shortcut Dimension 1 Code");
                            IF GLBudgetRec."Shortcut Dimension 2 Code" <> '' THEN
                                GLEntry.SETFILTER("Global Dimension 2 Code", PurchLine."Shortcut Dimension 2 Code");
                            IF HasDimensionFilter(GLSetup."Shortcut Dimension 3 Code", GLBudgetRec) THEN
                                GLEntry.SETFILTER("Shortcut Dimension 3 Code", PurchLine."Shortcut Dimension 3 Code");
                            IF HasDimensionFilter(GLSetup."Shortcut Dimension 4 Code", GLBudgetRec) THEN
                                GLEntry.SETFILTER("Shortcut Dimension 4 Code", PurchLine."Shortcut Dimension 4 Code");
                            IF HasDimensionFilter(GLSetup."Shortcut Dimension 5 Code", GLBudgetRec) THEN
                                GLEntry.SETFILTER("Shortcut Dimension 5 Code", PurchLine."Shortcut Dimension 5 Code");
                            IF HasDimensionFilter(GLSetup."Shortcut Dimension 6 Code", GLBudgetRec) THEN
                                GLEntry.SETFILTER("Shortcut Dimension 6 Code", PurchLine."Shortcut Dimension 6 Code");
                            IF HasDimensionFilter(GLSetup."Shortcut Dimension 7 Code", GLBudgetRec) THEN
                                GLEntry.SETFILTER("Shortcut Dimension 7 Code", PurchLine."Shortcut Dimension 7 Code");
                            IF HasDimensionFilter(GLSetup."Shortcut Dimension 8 Code", GLBudgetRec) THEN
                                GLEntry.SETFILTER("Shortcut Dimension 8 Code", PurchLine."Shortcut Dimension 8 Code");

                            GLEntry.CALCSUMS(Amount);
                            ConsumedAmount += GLEntry.Amount;
                        END;
                    UNTIL GLBudgetRec.NEXT = 0;

                PurchLine."Total Budget" := TotalBudget;
                PurchLine."Utilized Budget" := ConsumedAmount + RequisitionLineReleasedAmount;
                PurchLine."Available Budget" := TotalBudget - RequisitionLineReleasedAmount - ConsumedAmount;
                PurchLine."Posted Amount" := ConsumedAmount;
                PurchLine."Unposted Amount" := RequisitionLineReleasedAmount;
                PurchLine.MODIFY;

            UNTIL PurchLine.NEXT = 0;
    end;

    local procedure CheckBudgetDimension(DimensionSetId: Integer; DimensionCode: Code[20]; No: Code[20])
    var
        DimensionSetEntry: Record "480";
    begin
        IF DimensionCode <> '' THEN BEGIN
            DimensionSetEntry.RESET;
            DimensionSetEntry.SETRANGE("Dimension Set ID", DimensionSetId);
            DimensionSetEntry.SETRANGE("Dimension Code", DimensionCode);
            IF NOT DimensionSetEntry.FINDFIRST THEN
                ERROR('Please insert %1 code for %2', DimensionCode, No);
        END;
    end;

    local procedure GetBudgetDimensionValue(DimensionSetId: Integer; DimensionCode: Code[20]): Code[20]
    var
        DimensionSetEntry: Record "480";
    begin
        DimensionSetEntry.RESET;
        DimensionSetEntry.SETRANGE("Dimension Set ID", DimensionSetId);
        DimensionSetEntry.SETRANGE("Dimension Code", DimensionCode);
        IF DimensionSetEntry.FINDFIRST THEN
            EXIT(DimensionSetEntry."Dimension Value Code");
    end;

    local procedure GetGlDimensionValue(DimensionSetId: Integer; DimensionCode: Code[20]): Code[20]
    var
        DimensionSetEntry: Record "480";
    begin
        DimensionSetEntry.RESET;
        DimensionSetEntry.SETRANGE("Dimension Set ID", DimensionSetId);
        DimensionSetEntry.SETRANGE("Dimension Code", DimensionCode);
        IF DimensionSetEntry.FINDFIRST THEN
            EXIT(DimensionSetEntry."Dimension Value Code");
    end;

    local procedure HasDimensionFilter(DimensionCode: Code[20]; GLBudgetRec: Record "95"): Boolean
    begin
        IF (GLBudgetRec."Budget Dimension 1 Code" = DimensionCode) OR
          (GLBudgetRec."Budget Dimension 2 Code" = DimensionCode) OR
          (GLBudgetRec."Budget Dimension 3 Code" = DimensionCode) OR
          (GLBudgetRec."Budget Dimension 4 Code" = DimensionCode) THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    local procedure "--SMS--"()
    begin
    end;

    [Scope('Internal')]
    procedure SendSMS(PhoneNo: Text; MessageText: Text; var MessageID: Text[250]; ScheduleDateTime: DateTime) ReturnValue: Boolean
    var
        SMSSetup: Record "50006";
        stringContent: DotNet StringContent;
        httpUtility: DotNet HttpUtility;
        encoding: DotNet Encoding;
        result: DotNet String;
        resultParts: DotNet Array;
        separator: DotNet String;
        HttpResponseMessage: DotNet HttpResponseMessage;
        JsonConvert: DotNet JsonConvert;
        null: DotNet Object;
        Window: Dialog;
        data: Text;
        statusCode: Text;
        statusText: Text;
        ResponseCode: Code[10];
        "-------": Integer;
        Parameters: DotNet Dictionary_Of_T_U;
        RESTWSManagement: Codeunit "60000";
        JArray: DotNet JArray;
        JObject: DotNet JObject;
        JToken: DotNet JToken;
        result1: Text;
        JsonHelperFunctions: Codeunit "60001";
        json: Text;
        HeaderContent: Text;
        HeaderContents: DotNet StringContent;
        Text000: Label 'Sending SMS...';
    begin
        SMSSetup.GET;
        SMSSetup.TESTFIELD("User Name");
        SMSSetup.TESTFIELD(Password);
        //SMSSetup.TESTFIELD("Password Key");
        SMSSetup.TESTFIELD("SMS Text Length");

        IF GUIALLOWED THEN
            Window.OPEN(Text000);

        /*data := 'token=' + SMSSetup.Token;
        data += '&username=' +  SMSSetup."User Name";
        data += '&password=' + SMSSetup.Password ;//SMSSetup.GetPassword;
        data += '&from=' + SMSSetup.Identity;
        data += '&to='+ PhoneNo;
        data += '&text='+COPYSTR(MessageText,1,SMSSetup."SMS Text Length");
        */
        data := STRSUBSTNO(
                      //'{"auth_token":"%1","from":"%2","to":"%3","text":"%4"}',
                      '{"Msisdn":"%1", "Name":"%2","SmsMessage":"%3","ScheduleDate":"%4","UserId":"%5"}',
                        PhoneNo,
                        'name',
                        COPYSTR(MessageText, 1, SMSSetup."SMS Text Length"),
                        FORMAT(ScheduleDateTime),
                        //SMSSetup."SMS Authentication Token",
                        //SMSSetup.Identity,
                        '1001'
                        );

        stringContent := stringContent.StringContent(data, encoding.UTF8, 'application/json'); //'application/x-www-form-urlencoded');


        Parameters := Parameters.Dictionary();
        Parameters.Add('baseurl', SMSSetup."Base URL");
        Parameters.Add('path', SMSSetup.Method);
        Parameters.Add('restmethod', 'POST');
        //Parameters.Add('accept','application/json');
        Parameters.Add('username', SMSSetup."User Name");
        Parameters.Add('password', SMSSetup.Password);
        Parameters.Add('httpcontent', stringContent);
        Parameters.Add('module', SMSSetup.Identity);
        //Parameters.Add('module', 'SXBn');
        Parameters.Add('content-type', 'application/json');


        /*
        ReturnValue := CallRESTWebService(
                                                SMSSetup."Base URL" ,
                                                SMSSetup.Method,
                                                FORMAT(SMSSetup.RESTMethod),
                                                stringContent,
                                                HttpResponseMessage);
        */

        ReturnValue := CallRESTWebServiceFkingHeader(Parameters, HttpResponseMessage);
        IF GUIALLOWED THEN
            Window.CLOSE;

        IF NOT ReturnValue THEN
            EXIT;

        result := HttpResponseMessage.Content.ReadAsStringAsync.Result;

        IF FORMAT(result) <> '' THEN BEGIN
            IF GUIALLOWED THEN
                MessageID := FORMAT(result);

            IF STRPOS(FORMAT(result), 'Success') > 0 THEN
                EXIT(TRUE);
        END;

        EXIT(FALSE);

        /*
        separator := ',';
        resultParts := result.Split(separator.ToCharArray());
        statusCode := resultParts.GetValue(0);
        statusText := resultParts.GetValue(1);
        //MESSAGE('Response %1',resultParts.GetValue(3));
        MessageID := DELSTR(FORMAT(resultParts.GetValue(3)),1,17);
        
        //ResponseCode := DELSTR(statusText,1,12);
        
        ResponseCode := MessageID;
        //MESSAGE('Response Code %1',ResponseCode);
        
        IF NOT (ResponseCode = '200') THEN BEGIN
          EXIT(FALSE);
        END
        ELSE BEGIN
          EXIT(TRUE);
        END;
        */

    end;

    [TryFunction]
    [Scope('Internal')]
    procedure CallRESTWebService(BaseUrl: Text; Method: Text; RestMethod: Text; var HttpContent: DotNet HttpContent; var HttpResponseMessage: DotNet HttpResponseMessage)
    var
        HttpClient: DotNet HttpClient;
        Uri: DotNet Uri;
    begin
        HttpClient := HttpClient.HttpClient();
        HttpClient.BaseAddress := Uri.Uri(BaseUrl);

        CASE RestMethod OF
            'GET':
                HttpResponseMessage := HttpClient.GetAsync(Method).Result;
            'POST':
                HttpResponseMessage := HttpClient.PostAsync(Method, HttpContent).Result;
            'PUT':
                HttpResponseMessage := HttpClient.PutAsync(Method, HttpContent).Result;
            'DELETE':
                HttpResponseMessage := HttpClient.DeleteAsync(Method).Result;
        END;

        HttpResponseMessage.EnsureSuccessStatusCode();
    end;

    [Scope('Internal')]
    procedure CallRESTWebServiceFkingHeader(var Parameters: DotNet Dictionary_Of_T_U; var HttpResponseMessage: DotNet HttpResponseMessage): Boolean
    var
        HttpContent: DotNet HttpContent;
        HttpClient: DotNet HttpClient;
        AuthHeaderValue: DotNet AuthenticationHeaderValue;
        EntityTagHeaderValue: DotNet EntityTagHeaderValue;
        Uri: DotNet Uri;
        bytes: DotNet Array;
        Encoding: DotNet Encoding;
        Convert: DotNet Convert;
        HttpRequestMessage: DotNet HttpRequestMessage;
        HttpMethod: DotNet HttpMethod;
    begin
        HttpClient := HttpClient.HttpClient();
        HttpClient.BaseAddress := Uri.Uri(FORMAT(Parameters.Item('baseurl')));

        HttpRequestMessage :=
          HttpRequestMessage.HttpRequestMessage(HttpMethod.HttpMethod(UPPERCASE(FORMAT(Parameters.Item('restmethod')))),
                                                FORMAT(Parameters.Item('path')));
        ;

        IF Parameters.ContainsKey('accept') THEN
            HttpRequestMessage.Headers.Add('Accept', FORMAT(Parameters.Item('accept')));

        IF Parameters.ContainsKey('module') THEN
            //HttpRequestMessage.Headers.IfMatch.Add(Parameters.Item('etag'));
            HttpRequestMessage.Headers.Add('module', FORMAT(Parameters.Item('module')));
        /*
      IF Parameters.ContainsKey('content-type') THEN
        HttpRequestMessage.Headers.Add('content-type', FORMAT(Parameters.Item('content-type')));
        */


        IF Parameters.ContainsKey('username') THEN BEGIN
            bytes := Encoding.ASCII.GetBytes(STRSUBSTNO('%1:%2', FORMAT(Parameters.Item('username')), FORMAT(Parameters.Item('password'))));
            AuthHeaderValue := AuthHeaderValue.AuthenticationHeaderValue('Basic', Convert.ToBase64String(bytes));
            HttpRequestMessage.Headers.Authorization := AuthHeaderValue;
        END;


        IF Parameters.ContainsKey('httpcontent') THEN
            HttpRequestMessage.Content := Parameters.Item('httpcontent');

        HttpResponseMessage := HttpClient.SendAsync(HttpRequestMessage).Result;
        EXIT(HttpResponseMessage.IsSuccessStatusCode);

    end;

    [Scope('Internal')]
    procedure SendVehicleBookingSMS(GenJnlLine: Record "81")
    var
        SMSTemplate: Record "50008";
        SMSWebService: Codeunit "50033";
        MessageID: Text;
        Location: Record "14";
        MessageText: Text;
        Cust: Record "18";
        GenLedgSetup: Record "98";
    begin
        //SRT June 29th 2019 >>
        GenLedgSetup.GET;
        IF NOT GenLedgSetup."Enable SMS Module" THEN
            EXIT;

        SMSTemplate.RESET;
        IF "Payment Type" = 'BOKING RCP' THEN BEGIN
            SMSTemplate.SETRANGE("Document Profile", SMSTemplate."Document Profile"::"Vehicles Trade");
            SMSTemplate.SETRANGE(Type, SMSTemplate.Type::"Vehicle Booking");
        END ELSE
            IF "Payment Type" = 'DP RCPT' THEN BEGIN
                SMSTemplate.SETRANGE("Document Profile", SMSTemplate."Document Profile"::"Vehicles Trade");
                SMSTemplate.SETRANGE(Type, SMSTemplate.Type::"Down Payment");
            END ELSE
                IF "Payment Type" = 'DO RCPT' THEN BEGIN
                    SMSTemplate.SETRANGE("Document Profile", SMSTemplate."Document Profile"::"Vehicles Trade");
                    SMSTemplate.SETRANGE(Type, SMSTemplate.Type::"DO realization final billing");
                END ELSE
                    IF "Payment Type" = 'CUSTOMER' THEN BEGIN
                        SMSTemplate.SETRANGE("Document Profile", SMSTemplate."Document Profile"::"Vehicles Trade");
                        SMSTemplate.SETRANGE(Type, SMSTemplate.Type::"Cash Collection");
                    END;
        IF NOT SMSTemplate.FINDFIRST THEN
            ERROR('SMS Template for %1 must be set in SMS Template', SMSTemplate.Type);


        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN BEGIN
            IF Cust.GET(GenJnlLine."Account No.") THEN BEGIN
                Cust.CALCFIELDS("Balance (LCY)");
                Cust.TESTFIELD("Mobile No.");

                IF "Payment Type" = 'BOKING RCP' THEN
                    MessageText := STRSUBSTNO(SMSTemplate."Message Text", Cust.Name, ABS(GenJnlLine.Amount), GenJnlLine."Document No.", GenJnlLine."Posting Date")
                ELSE
                    IF "Payment Type" = 'DP RCPT' THEN
                        MessageText := STRSUBSTNO(SMSTemplate."Message Text", Cust.Name, ABS(GenJnlLine.Amount), Cust."Balance (LCY)", GenJnlLine."Document No.", GenJnlLine."Posting Date")
                    ELSE
                        IF "Payment Type" = 'DO RCPT' THEN
                            MessageText := STRSUBSTNO(SMSTemplate."Message Text", Cust.Name, ABS(GenJnlLine.Amount), Cust."Balance (LCY)", GenJnlLine."Document No.", GenJnlLine."Posting Date")
                        ELSE
                            IF "Payment Type" = 'CUSTOMER' THEN
                                MessageText := STRSUBSTNO(SMSTemplate."Message Text", Cust.Name, ABS(GenJnlLine.Amount), ABS(GenJnlLine.Amount), GenJnlLine."Document No.", GenJnlLine."Posting Date", Cust."Balance (LCY)");

                IF SendSMS(FORMAT(Cust."Mobile No."), MessageText, MessageID, CREATEDATETIME(TODAY, TIME + 10000)) THEN BEGIN
                    IF "Payment Type" = 'BOKING RCP' THEN
                        InsertSMSDetails(FORMAT(Cust."Mobile No."), MessageText, GenJnlLine."Document No.", MessageType::"Vehicle Booking")
                    ELSE
                        IF "Payment Type" = 'DP RCPT' THEN
                            InsertSMSDetails(FORMAT(Cust."Mobile No."), MessageText, GenJnlLine."Document No.", MessageType::"Down Payment")
                        ELSE
                            IF "Payment Type" = 'DO RCPT' THEN
                                InsertSMSDetails(FORMAT(Cust."Mobile No."), MessageText, GenJnlLine."Document No.", MessageType::"DO realization final billing")
                            ELSE
                                IF "Payment Type" = 'CUSTOMER' THEN
                                    InsertSMSDetails(FORMAT(Cust."Mobile No."), MessageText, GenJnlLine."Document No.", MessageType::"Cash Collection");
                END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure SendSMSForVehicleSalesInvoice(SalesInvoiceHeader: Record "112")
    var
        SMSTemplate: Record "50008";
        SMSWebService: Codeunit "50033";
        Cust: Record "18";
        MessageID: Text;
        MessageText: Text;
        GenLedgSetup: Record "98";
    begin
        //SRT June 29th 2019 >>
        IF SalesInvoiceHeader."Document Profile" <> SalesInvoiceHeader."Document Profile"::"Vehicles Trade" THEN
            EXIT;
        GenLedgSetup.GET;
        IF NOT GenLedgSetup."Enable SMS Module" THEN
            EXIT;

        SMSTemplate.RESET;
        SMSTemplate.SETRANGE("Document Profile", SMSTemplate."Document Profile"::"Vehicles Trade");
        SMSTemplate.SETRANGE(Type, SMSTemplate.Type::"Sales Invoicing");
        IF NOT SMSTemplate.FINDFIRST THEN
            ERROR('SMS Template for %1 must be set in SMS Template', SMSTemplate.Type);

        Cust.GET(SalesInvoiceHeader."Sell-to Customer No.");
        Cust.TESTFIELD("Mobile No.");
        SalesInvoiceHeader.CALCFIELDS("Amount Including VAT");
        SalesInvoiceHeader.CALCFIELDS("Remaining Amount");
        SalesInvoiceHeader.CALCFIELDS("Model Version");
        MessageText := STRSUBSTNO(SMSTemplate."Message Text", Cust.Name, FORMAT(SalesInvoiceHeader."Amount Including VAT"), "Model Version", SalesInvoiceHeader."No.", SalesInvoiceHeader."Posting Date");
        IF SendSMS(FORMAT(Cust."Mobile No."), MessageText, MessageID, CREATEDATETIME(TODAY, TIME + 10000)) THEN BEGIN

            InsertSMSDetails(FORMAT(Cust."Mobile No."), MessageText, SalesInvoiceHeader."No.", MessageType::"Sales Invoicing");
        END;
    end;

    [Scope('Internal')]
    procedure SendSMSForServiceInvoice(ServiceHeader: Record "5900")
    var
        SMSTemplate: Record "50008";
        SMSWebService: Codeunit "50033";
        Cust: Record "18";
        MessageID: Text;
        MessageText: Text;
        RemainingAmount: Decimal;
        CustLedgEntry: Record "21";
        ServiceLine: Record "5902";
        AmountInclVAT: Decimal;
        WorkType: Record "200";
        GenLedgSetup: Record "98";
    begin
        //SRT June 29th 2019 >>
        IF ServiceHeader."Document Type" = ServiceHeader."Document Type"::"Credit Memo" THEN
            EXIT;
        GenLedgSetup.GET;
        IF NOT GenLedgSetup."Enable SMS Module" THEN
            EXIT;

        SMSTemplate.RESET;
        SMSTemplate.SETRANGE("Document Profile", SMSTemplate."Document Profile"::Service);
        IF ServiceHeader."Payment Method Code" <> '' THEN
            SMSTemplate.SETRANGE(Type, SMSTemplate.Type::"Cash Invoice")
        ELSE
            SMSTemplate.SETRANGE(Type, SMSTemplate.Type::"Credit Invoice");
        IF NOT SMSTemplate.FINDFIRST THEN
            ERROR('SMS Template for %1 must be set in SMS Template', SMSTemplate.Type);

        Cust.GET(ServiceHeader."Bill-to Customer No.");
        Cust.TESTFIELD("Mobile No.");
        AmountInclVAT := 0;
        ServiceLine.RESET;
        ServiceLine.SETRANGE(ServiceLine."Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE(ServiceLine."Document No.", ServiceHeader."No.");
        IF ServiceLine.FINDFIRST THEN
            REPEAT
                WorkType.GET(ServiceLine."Work Type Code");
                IF WorkType."Bill-to Customer No." = '' THEN
                    AmountInclVAT += ServiceLine."Amount Including VAT";
            UNTIL ServiceLine.NEXT = 0;
        RemainingAmount := 0;
        IF ServiceHeader."Payment Method Code" = '' THEN BEGIN
            CustLedgEntry.RESET;
            CustLedgEntry.SETRANGE(CustLedgEntry."Document No.", ServiceHeader."Posting No.");
            IF CustLedgEntry.FINDFIRST THEN BEGIN
                CustLedgEntry.CALCFIELDS(CustLedgEntry."Remaining Amount");
                RemainingAmount := CustLedgEntry."Remaining Amount";
            END;
        END;
        MessageText := STRSUBSTNO(SMSTemplate."Message Text", Cust.Name, "Registration No.", FORMAT(AmountInclVAT), ServiceHeader."No.", ServiceHeader."Posting Date", RemainingAmount);
        IF SendSMS(FORMAT(Cust."Mobile No."), MessageText, MessageID, CREATEDATETIME(TODAY, TIME + 10000)) THEN BEGIN
            IF ServiceHeader."Payment Method Code" = '' THEN
                InsertSMSDetails(FORMAT(Cust."Mobile No."), MessageText, ServiceHeader."No.", MessageType::"Credit Invoice")
            ELSE
                InsertSMSDetails(FORMAT(Cust."Mobile No."), MessageText, ServiceHeader."No.", MessageType::"Cash Invoice");

        END;
    end;

    local procedure InsertSMSDetails(MobileNumber: Text[20]; MessageText: Text; DocumentNo: Code[20]; MessageType: Option " ","Service Estimation","Service Invoice","Service Reminder","Service Booking","Vehicle Inward","Vehicle Booking","Sales Invoicing","Down Payment","DO realization final billing","Cash Invoice","Credit Invoice","Cash Collection","Customer Consent")
    var
        EntryNo: Integer;
        SMSDetail: Record "50007";
    begin
        //SRT June 29th 2019 >>
        EntryNo := 0;
        SMSDetail.RESET;
        IF SMSDetail.FINDLAST THEN
            EntryNo := SMSDetail."Entry No." + 1
        ELSE
            EntryNo := 1;

        SMSDetail.INIT;
        SMSDetail."Entry No." := EntryNo;
        SMSDetail."Mobile Number" := MobileNumber;
        SMSDetail."Creation Date" := CURRENTDATETIME;
        SMSDetail."Message Type" := MessageType;
        SMSDetail."Message Text" := MessageText;
        SMSDetail.Status := SMSDetail.Status::Processed;
        SMSDetail."Document No." := DocumentNo;
        SMSDetail."Last Modified Date" := CURRENTDATETIME;
        SMSDetail.INSERT;
    end;

    [Scope('Internal')]
    procedure ValidateMobileNo(MobileNo: Code[50]; FieldCaption: Text[30]; RecID: Code[20])
    var
        ServSetup: Record "5911";
        Length: Integer;
        Sequence: Code[250];
        SequenceRule: Code[10];
        TotalRules: Integer;
        RuleFinished: Boolean;
        i: Integer;
        ValidNumber: Boolean;
    begin
        IF MobileNo <> '' THEN BEGIN
            IF STRLEN(MobileNo) = 10 THEN BEGIN
                Length := 1;
                REPEAT
                    IF MobileNo[Length] IN ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'] THEN BEGIN
                    END
                    ELSE
                        ERROR('%1 should only consists of numeric combination for Record %2.', FieldCaption, RecID);
                    Length += 1;
                UNTIL Length > 10;

                ServSetup.GET;
                Sequence := ServSetup."Valid Mobile Nos. Format";
                //--Finding Total Rules
                IF Sequence <> '' THEN BEGIN
                    REPEAT
                        IF STRPOS(Sequence, ',') > 0 THEN BEGIN
                            Sequence := DELSTR(Sequence, 1, STRPOS(Sequence, ','));
                            TotalRules += 1;
                        END
                        ELSE
                            RuleFinished := TRUE;
                    UNTIL RuleFinished = TRUE;
                END;
                //--Loop through Rules
                Sequence := ServSetup."Valid Mobile Nos. Format";
                ValidNumber := FALSE;
                FOR i := 1 TO TotalRules + 1 DO BEGIN
                    IF COPYSTR(MobileNo, 1, STRLEN(SELECTSTR(i, Sequence))) = (SELECTSTR(i, Sequence)) THEN
                        ValidNumber := TRUE;
                END;
                IF NOT ValidNumber THEN
                    ERROR('%1 is not valid for record %2', FieldCaption, RecID);
            END
            ELSE
                ERROR('%1 must have 10 numeric characters for %2', FieldCaption, RecID);
        END;
    end;

    [Scope('Internal')]
    procedure CreateSalesFollowUpDetails(MemoHeader: Record "50101"; SalesInvHeader: Record "112")
    var
        FollowUpDetails: Record "50033";
        CustPhoneNo: Text;
        Cust: Record "18";
    begin
        CLEAR(FollowUpDetails);
        FollowUpDetails.RESET;
        FollowUpDetails.SETRANGE("No.", MemoHeader."No.");
        IF NOT FollowUpDetails.FINDFIRST THEN BEGIN
            CLEAR(FollowUpDetails);
            FollowUpDetails.INIT;
            FollowUpDetails.Type := FollowUpDetails.Type::Sales;
            FollowUpDetails."No." := MemoHeader."No.";
            FollowUpDetails."Sales Memo Type" := MemoHeader."Sales Memo Type";
            FollowUpDetails."Follow Up Type" := FollowUpDetails."Follow Up Type"::"Post Sales Feedback";
            FollowUpDetails.INSERT(TRUE);
            InsertIntoSalesFollowup(FollowUpDetails, SalesInvHeader, MemoHeader);
            FollowUpDetails.MODIFY(TRUE);
            // MESSAGE('follow up created');
        END
        ELSE BEGIN
            IF MemoHeader."Sales Memo Type" = MemoHeader."Sales Memo Type"::Cancellation THEN BEGIN
                CLEAR(FollowUpDetails);
                FollowUpDetails.RESET;
                FollowUpDetails.SETRANGE("No.", MemoHeader."Cancelled Invoice No.");
                IF FollowUpDetails.FINDFIRST THEN BEGIN
                    FollowUpDetails."Sales Memo Type" := FollowUpDetails."Sales Memo Type"::Cancellation;
                    FollowUpDetails.MODIFY(TRUE);
                END;
            END
            ELSE BEGIN
                InsertIntoSalesFollowup(FollowUpDetails, SalesInvHeader, MemoHeader);
                FollowUpDetails.MODIFY(TRUE);
            END;
        END;
    end;

    local procedure InsertIntoSalesFollowup(var FollowUpDetails: Record "50033"; var SalesInvHeader: Record "112"; var MemoHeader: Record "50101")
    var
        SalesInvLine: Record "113";
        Customer: Record "18";
    begin
        //Customer Information
        FollowUpDetails."Sell-to Customer No." := SalesInvHeader."Sell-to Customer No.";
        FollowUpDetails."Sell-to Customer Name" := SalesInvHeader."Sell-to Customer Name";
        FollowUpDetails."Sell-to Address" := SalesInvHeader."Sell-to Address";
        IF Customer.GET(SalesInvHeader."Sell-to Customer No.") THEN
            FollowUpDetails."Mobile No. for SMS" := Customer."Mobile No.";

        //Item Information
        SalesInvLine.RESET;
        SalesInvLine.SETRANGE("Document No.", SalesInvHeader."No.");
        IF SalesInvLine.FINDFIRST THEN BEGIN
            FollowUpDetails."Make Code" := SalesInvLine."Make Code";
            FollowUpDetails."Model Code" := SalesInvLine."Model Code";
            FollowUpDetails."Model Version No." := SalesInvLine."Model Version No.";
            FollowUpDetails."Service Item No." := SalesInvLine."Serial No.";
            FollowUpDetails.MRP := SalesInvHeader.Amount;
            FollowUpDetails."Final Price" := SalesInvHeader."Amount Including VAT";
            ;
            /*FollowUpDetails."DO Amount" := "DO Amount";
            FollowUpDetails."DO Satus" := "DO Status";
            FollowUpDetails."Down Payment" := "Down Payment";
            FollowUpDetails."Salesperson Code" := "Salesperson Code";
            FollowUpDetails.Discount := Discount;
            FollowUpDetails."Bank Name" := "Bank Name";*/
            FollowUpDetails."Shortcut Dimension 2 Code" := SalesInvHeader."Shortcut Dimension 2 Code";
            FollowUpDetails."Sales Invoice No." := SalesInvHeader."No.";
        END;
        //posting information
        FollowUpDetails."Posting Date" := SalesInvHeader."Posting Date";
        FollowUpDetails."Sales Memo Type" := MemoHeader."Sales Memo Type";
        //FollowUpDetails."Order Date" := "Memo Approved Date";

    end;

    [Scope('Internal')]
    procedure IsVehicleRepairTrackerApprovalsWorkflowEnabled(var VehicleRepairTracker: Record "50129"): Boolean
    var
        WorkflowManagement: Codeunit "1501";
        WorkflowEventHandling: Codeunit "1520";
        ManageTV: Codeunit "50018";
    begin
        //EXIT(WorkflowManagement.CanExecuteWorkflow(VehicleRepairTracker,ManageTV.OnVehicleRepairTrackerSendForApprovalCode));
    end;

    local procedure "--------------------For Perpectual Inv--------------"()
    begin
    end;

    [Scope('Internal')]
    procedure VerifyEntry()
    var
        LineCount: Integer;
        PerpLog: Record "50135";
        SKURec: Record "5700";
        RecSKU: Record "5700";
        Item: Record "27";
        Item1: Record "27";
    begin
        PerpLog.RESET;
        PerpLog.SETCURRENTKEY("User ID", Date);
        PerpLog.SETRANGE("User ID", PerpHeader."Assigned User ID");
        PerpLog.SETRANGE(Date, PerpHeader."Posting Date");
        PerpLog.SETRANGE("Location Code", PerpHeader."Location Code");
        IF PerpLog.FINDFIRST THEN
            ERROR(TextP000);

        PostedPerpHdr.RESET;
        PostedPerpHdr.SETRANGE("Location Code", PerpHeader."Location Code");
        PostedPerpHdr.SETRANGE("Posting Date", PerpHeader."Posting Date");
        IF PostedPerpHdr.FINDFIRST THEN
            ERROR(TextP003, PerpHeader."Location Code", PerpHeader."Posting Date");

        PerpLine.RESET;
        PerpLine.SETRANGE("Document No.", PerpHeader."No.");
        IF PerpLine.FINDSET THEN
            PerpLine.DELETEALL;

        //If number of data in item is less than in Inventory Setup; First select all the items as Not Periodically Counted
        InvSetup.GET;
        InvSetup.TESTFIELD("No. of Items to count");
        InvSetup.TESTFIELD("Minimum Cost");
        MaxItem := InvSetup."No. of Items to count";

        /*Item1.RESET;
        Item1.SETRANGE(Blocked,FALSE);
        Item1.SETRANGE("Periodically Counted",FALSE);
        Item1.SETFILTER("Unit Cost",'>%1',InvSetup."Minimum Cost");
        Item1.SETFILTER("Location Filter",PerpHeader."Location Code");
        IF Item1.FINDFIRST THEN REPEAT
          Item1.CALCFIELDS(Inventory);
          IF ((Item1.Inventory > 0) AND (Item1."Item Type" = Item1."Item Type"::Item)) THEN BEGIN
            LineCount += 1;
          END;
        UNTIL (Item1.NEXT = 0) OR (LineCount = MaxItem);*/


        SKU.RESET;
        SKU.SETCURRENTKEY("Location Code", "Periodically Counted", "Perpetual Value", "Perpetual Rate");
        SKU.ASCENDING(FALSE);
        SKU.SETRANGE("Location Code", PerpHeader."Location Code");
        SKU.SETRANGE("Periodically Counted", FALSE);
        SKU.SETFILTER("Perpetual Rate", '>%1', InvSetup."Minimum Cost");
        IF SKU.FINDFIRST THEN
            REPEAT
                Item.GET(SKU."Item No.");
                //SKU.CALCFIELDS(Inventory);
                //IF ((SKU.Inventory > 0) AND (Item."Item Type" = Item."Item Type" :: Item))THEN BEGIN
                IF Item."Item Type" = Item."Item Type"::Item THEN BEGIN
                    LineCount += 1;
                END;
            UNTIL (SKU.NEXT = 0) OR (LineCount = MaxItem);

    end;

    [Scope('Internal')]
    procedure PopulateItems()
    var
        Item: Record "27";
        TotalItem: Integer;
        SKU: Record "5700";
        RecSKU: Record "5700";
        NoOfRecords: Integer;
        LineCount: Integer;
        LineNo: Integer;
    begin
        LineCount := 0;
        InvSetup.GET;
        /*
        Items.RESET;
        Items.SETRANGE(Blocked,FALSE);
        Items.SETRANGE("Periodically Counted",FALSE);
        Items.SETFILTER("Unit Cost",'>%1',InvSetup."Minimum Cost");
        Items.SETRANGE("Item Type",Items."Item Type"::Item);
        Items.SETFILTER("Location Filter",PerpHeader."Location Code");
        IF Items.FINDFIRST THEN BEGIN
          REPEAT
            LineCount += 1;
            LineNo += 1000;
            CLEAR(PerpLine);
            PerpLine.INIT;
            PerpLine."Document No." := PerpHeader."No.";
            PerpLine."Line No." := LineNo;
            PerpLine."Item No." := Items."No.";
            PerpLine."Item Description" := Items.Description;
            PerpLine."Location Code" := PerpHeader."Location Code";
            PerpLine."Working Date" := PerpHeader."Document Date";
            PerpLine."User ID" := PerpHeader."Assigned User ID";
            Items.CALCFIELDS(Inventory);
            IF Items.Inventory > 0 THEN
              PerpLine.INSERT
            ELSE
              LineCount -= 1;
           UNTIL (Items.NEXT = 0) OR (LineCount = MaxItem);
        
        END;
        */


        SKU.RESET;
        SKU.SETCURRENTKEY("Location Code", "Periodically Counted", "Perpetual Value", "Perpetual Rate");
        SKU.ASCENDING(FALSE);
        SKU.SETRANGE("Location Code", PerpHeader."Location Code");
        SKU.SETRANGE("Periodically Counted", FALSE);
        SKU.SETFILTER("Perpetual Rate", '>%1', InvSetup."Minimum Cost");
        IF SKU.FINDFIRST THEN BEGIN
            REPEAT
                LineCount += 1;
                LineNo += 10000;
                CLEAR(PerpLine);
                PerpLine.INIT;
                PerpLine."Document No." := PerpHeader."No.";
                PerpLine."Line No." := LineNo;
                PerpLine."Item No." := SKU."Item No.";
                Item.GET(SKU."Item No.");
                //SKU.CALCFIELDS(Inventory);
                PerpLine."Item Description" := Item.Description;
                PerpLine."Location Code" := PerpHeader."Location Code";
                //PerpLine."System Calculated Qty." := SKU.Inventory; while freeze inventory calculate garne re

                PerpLine."Working Date" := PerpHeader."Document Date";
                PerpLine."User ID" := PerpHeader."Assigned User ID";
                //IF ((SKU.Inventory > 0) AND (Item."Item Type" = Item."Item Type" :: Item)) THEN
                IF Item."Item Type" = Item."Item Type"::Item THEN
                    PerpLine.INSERT(TRUE)
                ELSE
                    LineCount -= 1;
            UNTIL (SKU.NEXT = 0) OR (LineCount = MaxItem);
        END;

    end;

    [Scope('Internal')]
    procedure PostPerpentual(var RecPerpHeader: Record "50131")
    var
        PstdPerpHeader: Record "50133";
        PstdPerpLine: Record "50134";
        RecPerpLine: Record "50132";
        Item: Record "27";
        PerpetualLog: Record "50135";
    begin
        CLEARALL;
        TESTFIELD("Journal Template Name");
        TESTFIELD("Journal Batch Name");
        TESTFIELD("Location Code");
        TESTFIELD("Assigned User ID");
        TESTFIELD("Responsibility Center");
        IF "No. Printed" < 2 THEN
            TESTFIELD("No. Printed", 2);
        TESTFIELD(Printed);
        TESTFIELD(Freeze);
        IF RECORDLEVELLOCKING THEN BEGIN
            RecPerpHeader.LOCKTABLE;
            RecPerpLine.LOCKTABLE;
        END;
        PstdPerpHeader.INIT;
        PstdPerpHeader.TRANSFERFIELDS(RecPerpHeader);
        PstdPerpHeader."Posted By" := USERID;
        PstdPerpHeader.INSERT;
        PstdPerpHeader.COPYLINKS(RecPerpHeader);
        RecPerpLine.RESET;
        RecPerpLine.SETRANGE("Document No.", "No.");
        IF RecPerpLine.FINDSET THEN BEGIN
            REPEAT
                IF (RecPerpLine."Phys. Qty." - RecPerpLine."System Calculated Qty.") <> 0 THEN
                    RecPerpLine.TESTFIELD(RecPerpLine.Remarks);
                PstdPerpLine.INIT;
                PstdPerpLine.TRANSFERFIELDS(RecPerpLine);
                PstdPerpLine.INSERT;
                /*Item.RESET;
                Item.SETRANGE("No.",RecPerpLine."Item No.");
                Item.SETFILTER(Item."Location Filter",RecPerpLine."Location Code");
                IF Item.FINDFIRST THEN BEGIN
                  Item.CALCFIELDS(Inventory);
                  PstdPerpLine."System Calculated Qty." := Item.Inventory;
                  PstdPerpLine.MODIFY;
                  Item."Periodically Counted" := TRUE;
                  Item.MODIFY;
                END;*/

                SKU.RESET;
                SKU.SETCURRENTKEY("Location Code", "Item No.");
                SKU.SETRANGE("Location Code", RecPerpLine."Location Code");
                SKU.SETRANGE("Item No.", RecPerpLine."Item No.");
                IF SKU.FINDFIRST THEN BEGIN
                    //SRT Jan 31st 2020 >>     re-calculating inventory while posting
                    SKU.CALCFIELDS(Inventory);
                    PstdPerpLine."System Calculated Qty." := SKU.Inventory;
                    PstdPerpLine.MODIFY;
                    //SRT Jan 31st 2020 <<
                    SKU."Periodically Counted" := TRUE;
                    SKU.MODIFY;
                END;
            UNTIL RecPerpLine.NEXT = 0;
            //Insert in perpetual log
            IF NOT PerpetualLog.GET(RecPerpHeader."No.") THEN BEGIN
                PerpetualLog.INIT;
                PerpetualLog."Document No." := RecPerpHeader."No.";
                PerpetualLog."User ID" := USERID;
                PerpetualLog.Time := TIME;
                PerpetualLog.Date := RecPerpHeader."Posting Date";
                PerpetualLog.Verified := TRUE;
                PerpetualLog."Location Code" := PerpetualLog."Location Code";
                PerpetualLog.INSERT;
            END;
        END
        ELSE
            ERROR(TextP002);

        IF HASLINKS THEN DELETELINKS;
        DELETE;
        IF RecPerpLine.FINDFIRST THEN
            REPEAT
                IF RecPerpLine.HASLINKS THEN
                    RecPerpLine.DELETELINKS;
            UNTIL RecPerpLine.NEXT = 0;
        RecPerpLine.DELETEALL;

    end;

    [Scope('Internal')]
    procedure InitilizePerpectual(var PerpectualInvheader: Record "50131")
    begin
        CLEARALL;
        TESTFIELD("No.");
        TESTFIELD("Posting Date");
        TESTFIELD("Document Date");
        TESTFIELD(Printed, FALSE);
        TESTFIELD(Freeze, FALSE);
        PerpHeader.COPY(PerpectualInvheader);
        VerifyEntry;
        PopulateItems;
        MESSAGE('Sucess...');
    end;

    [Scope('Internal')]
    procedure FreezePopulatedItems(PerpInvHeader: Record "50131")
    var
        Item: Record "27";
        TotalItem: Integer;
        NoOfRecords: Integer;
        LineCount: Integer;
        LineNo: Integer;
        PopulatedPerpLine: Record "50132";
    begin
        TESTFIELD("No. Printed");
        PerpLine.RESET;
        PerpLine.SETRANGE(PerpLine."Document No.", "No.");
        PerpLine.SETFILTER(PerpLine."Item No.", '<>%1', '');
        IF PerpLine.FINDFIRST THEN
            REPEAT
                /*Item.RESET;
                Item.SETRANGE(Item."No.",PerpLine."Item No.");
                Item.SETFILTER(Item."Location Filter",PerpLine."Location Code");
                IF Item.FINDFIRST THEN BEGIN
                  Item.CALCFIELDS(Item.Inventory);
                  PerpLine."System Calculated Qty." := Item.Inventory;
                  PerpLine.MODIFY;
                END;*/

                SKU.RESET;
                //SKU.SETCURRENTKEY("Location Code","Periodically Counted","Perpetual Value","Perpetual Rate");
                //SKU.ASCENDING(FALSE);
                SKU.SETRANGE("Item No.", PerpLine."Item No.");
                SKU.SETRANGE("Location Code", PerpLine."Location Code");
                //SKU.SETRANGE("Periodically Counted",FALSE);
                //SKU.SETFILTER("Perpetual Rate",'>%1',InvSetup."Minimum Cost");
                IF SKU.FINDFIRST THEN BEGIN
                    SKU.CALCFIELDS(Inventory);
                    PerpLine."System Calculated Qty." := SKU.Inventory;
                    PerpLine.MODIFY;
                END;
            UNTIL PerpLine.NEXT = 0;
        Freeze := TRUE;
        MODIFY;

    end;

    local procedure "-------------end perp-----------"()
    begin
    end;

    [Scope('Internal')]
    procedure FilterLocations(): Code[20]
    var
        UserSetup: Record "91";
    begin
        UserSetup.GET(USERID);
        IF NOT UserSetup."Can View OverAll Requisition" THEN
            EXIT(UserSetup."Default Location Code")
        ELSE
            EXIT('*');
    end;
}


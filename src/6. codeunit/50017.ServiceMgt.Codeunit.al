codeunit 50017 "Service Mgt."
{
    Permissions = TableData 32 = rm,
                  TableData 50034 = rimd;

    trigger OnRun()
    begin
    end;

    var
        ErrOrderAllocationExists: Label 'Delete Service Order Allocation entries before deleting service line.';
        PurchOrderCreatedMsg: Label 'Purchase Order for External Service has been created.%1Purchase Order No:%1%2';
        PurchOrderExistsErr: Label 'Purchase Order %1 has already been created for Service Line No. %2. Do you still want to proceed?';
        ExtServiceAlreadyPurchErr: Label '%1 quantity of External Service %2 on Line No %3 has already been purchased.%4%4Purchase Receipt Document No :%6%4Do you still want to proceed?';
        LF: Char;
        CR: Char;
        ExtServiceNotPurchErr: Label 'External Service %1 on Line No %2 has not been purchased.';
        NoKilometrageOrHourReading: Label 'Please enter the Kilometrage or Hour Reading for the vehicle in service item line.';
        TransferOrderCreated: Label 'Transfer Order %1 created for Service Order %2.';
        DocNo: Code[20];
        "//Agile_SM 20 Sep 2017 Reservation Mgt": Integer;
        QtyTransfered: Decimal;
        ReservationMgt: Codeunit "99000845";
        ServLine_GblItemLedgEntryNo: Text;
        Resource: Record "156";
        Text001: Label 'Do you want to convert this booking to Service Order?';
        Text002: Label 'Do you want to cancel this booking?';
        MessageType: Option " ","Service Estimation","Service Invoice","Service Reminder","Service Booking","Vehicle Inward","Vehicle Booking","Sales Invoicing","Down Payment","DO realization final billing","Cash Invoice","Credit Invoice","Cash Collection","Customer Consent";
        CustomerVoiceErr: Label 'Customer Voice not found';
        MessageText001: Label 'The service booking has been confirmed already.';
        ServiceCommentLine: Record "5906";
        SMSDetails: Record "50007";
        SMSMessageStatus: Option New,Processed,Failed;

    [Scope('Internal')]
    procedure AllocateResource(ServiceLine: Record "5902")
    var
        ServOrderAlloc: Record "5950";
        ResAlloc: Page "6005";
    begin
        ServiceLine.TESTFIELD("Document No.");
        ServiceLine.TESTFIELD("Line No.");
        ServiceLine.TESTFIELD("Line Type", "Line Type"::"2");
        ServiceLine.TESTFIELD(Type, ServiceLine.Type::Resource);
        ServiceLine.TESTFIELD("No.");
        ServOrderAlloc.RESET;
        ServOrderAlloc.SETCURRENTKEY("Document Type", "Document No.", "Service Item Line No.");
        ServOrderAlloc.FILTERGROUP(2);
        ServOrderAlloc.SETRANGE("Document Type", ServiceLine."Document Type");
        ServOrderAlloc.SETRANGE("Document No.", ServiceLine."Document No.");
        ServOrderAlloc.SETRANGE("Service Item Line No.", ServiceLine."Service Item Line No.");
        ServOrderAlloc.SETRANGE("Service Line No.", ServiceLine."Line No.");
        ServOrderAlloc.FILTERGROUP(0);
        IF ServOrderAlloc.FINDFIRST THEN;
        CLEAR(ResAlloc);
        ResAlloc.SETRECORD(ServOrderAlloc);
        ResAlloc.SETTABLEVIEW(ServOrderAlloc);
        ResAlloc.SETRECORD(ServOrderAlloc);
        ResAlloc.RUN;
    end;

    [Scope('Internal')]
    procedure CalcLastVisitKilometrage(VIN: Code[20]): Decimal
    var
        ServiceLedgerEntry: Record "5907";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Service Item No. (Serviced)", "Entry Type", "Posting Date");
        ServiceLedgerEntry.SETRANGE("Service Item No. (Serviced)", VIN);
        ServiceLedgerEntry.SETRANGE("Entry Type", ServiceLedgerEntry."Entry Type"::Usage);
        IF ServiceLedgerEntry.FINDLAST THEN
            EXIT(ServiceLedgerEntry.Kilometrage)
        ELSE
            EXIT(0);
    end;

    [Scope('Internal')]
    procedure CalcLastVisitHourReading(VIN: Code[20]): Decimal
    var
        ServiceLedgerEntry: Record "5907";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Service Item No. (Serviced)", "Entry Type", "Posting Date");
        ServiceLedgerEntry.SETRANGE("Service Item No. (Serviced)", VIN);
        ServiceLedgerEntry.SETRANGE("Entry Type", ServiceLedgerEntry."Entry Type"::Usage);
        IF ServiceLedgerEntry.FINDLAST THEN
            EXIT(ServiceLedgerEntry."Hour Reading")
        ELSE
            EXIT(0);
    end;

    [Scope('Internal')]
    procedure CalcLastVisitDate(VehSerialNo: Code[20]): Date
    var
        ServiceLedgerEntry: Record "5907";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Service Item No. (Serviced)", "Entry Type", "Posting Date");
        ServiceLedgerEntry.SETRANGE("Service Item No. (Serviced)", VehSerialNo);
        ServiceLedgerEntry.SETRANGE("Entry Type", ServiceLedgerEntry."Entry Type"::Usage);
        IF ServiceLedgerEntry.FINDLAST THEN
            EXIT(ServiceLedgerEntry."Posting Date")
        ELSE
            EXIT(0D);
    end;

    [Scope('Internal')]
    procedure CalcVehSalesDate(VehSerialNo: Code[20]): Date
    var
        Vehicle: Record "5940";
    begin
        Vehicle.RESET;
        IF Vehicle.GET(VehSerialNo) THEN
            EXIT(Vehicle."Sales Date");
    end;

    [Scope('Internal')]
    procedure CheckServOrderAllocation(ServiceLine: Record "5902")
    var
        ServOrderAlloc: Record "5950";
    begin
        ServOrderAlloc.RESET;
        ServOrderAlloc.SETCURRENTKEY("Document Type", "Document No.", "Service Item Line No.");
        ServOrderAlloc.SETRANGE("Document Type", ServiceLine."Document Type");
        ServOrderAlloc.SETRANGE("Document No.", ServiceLine."Document No.");
        ServOrderAlloc.SETRANGE("Service Item Line No.", ServiceLine."Service Item Line No.");
        ServOrderAlloc.SETRANGE("Service Line No.", ServiceLine."Line No.");
        IF ServOrderAlloc.FINDFIRST THEN
            ERROR(ErrOrderAllocationExists);
    end;

    [Scope('Internal')]
    procedure CheckIfOrderStatusIsBooking(DocumentType: Option; DocumentNo: Code[20]): Boolean
    var
        ServiceHeader: Record "5900";
    begin
        ServiceHeader.GET(DocumentType, DocumentNo);
        EXIT(ServiceHeader.Status = ServiceHeader.Status::"8");
    end;

    [Scope('Internal')]
    procedure GetVehicleDocCount(RecServiceItemLine: Record "5901"; DocType: Option Quote,"Order","Return Order",Complaint): Integer
    var
        ServiceItemLine: Record "5901";
        ComplaintHeader: Record "50065";
    begin
        IF RecServiceItemLine."Service Item No." = '' THEN
            EXIT(0);

        IF DocType = DocType::Complaint THEN BEGIN
            ComplaintHeader.RESET;
            ComplaintHeader.SETCURRENTKEY(VIN);
            ComplaintHeader.SETRANGE(VIN, RecServiceItemLine."Service Item No.");
            ComplaintHeader.SETRANGE(ComplaintHeader."Responsibility Center", RecServiceItemLine."Responsibility Center");//Agile RD SEP 15 2016
            EXIT(ComplaintHeader.COUNT);
        END
        ELSE BEGIN
            ServiceItemLine.RESET;
            ServiceItemLine.SETRANGE("Service Item No.", RecServiceItemLine."Service Item No.");
            ServiceItemLine.SETRANGE("Document Type", DocType);
            EXIT(ServiceItemLine.COUNT);
        END;
    end;

    [Scope('Internal')]
    procedure LookupLastServiceOrder(VehSerialNo: Code[20])
    var
        Vehicle: Record "5940";
        ServiceLedgerEntry: Record "5907";
    begin
        ServiceLedgerEntry.RESET;
        ServiceLedgerEntry.SETCURRENTKEY("Service Item No. (Serviced)", "Entry Type", "Posting Date");
        ServiceLedgerEntry.SETRANGE("Service Item No. (Serviced)", VehSerialNo);
        ServiceLedgerEntry.SETRANGE("Entry Type", ServiceLedgerEntry."Entry Type"::Usage);
        IF ServiceLedgerEntry.FINDLAST THEN
            ServiceLedgerEntry.SETRANGE("Document No.", ServiceLedgerEntry."Document No.");
        PAGE.RUNMODAL(PAGE::"Service Ledger Entries", ServiceLedgerEntry);
    end;

    [Scope('Internal')]
    procedure LookupVehicle(SerialNo: Code[20])
    var
        Vehicle: Record "5940";
    begin
        IF Vehicle.GET(SerialNo) THEN
            PAGE.RUNMODAL(PAGE::"Service Item Card", Vehicle);
    end;

    [Scope('Internal')]
    procedure LookupVehicleDoc(ServiceItemLine: Record "5901"; DocType: Option Quote,"Order","Return Order",Complaint)
    var
        ComplaintHeader: Record "50065";
        ServiceHeader: Record "5900";
    begin
        IF ServiceItemLine."Service Item No." = '' THEN
            EXIT;

        IF DocType = DocType::Complaint THEN BEGIN
            ComplaintHeader.RESET;
            ComplaintHeader.SETRANGE(ComplaintHeader."Responsibility Center", ServiceItemLine."Responsibility Center");//Agile RD SEP 15 2016
            ComplaintHeader.SETRANGE(VIN, ServiceItemLine."Service Item No.");
            IF ComplaintHeader.COUNT = 1 THEN
                PAGE.RUNMODAL(PAGE::Page50084, ComplaintHeader)
            ELSE
                PAGE.RUNMODAL(PAGE::Page50083, ComplaintHeader);
        END
        ELSE BEGIN
            ServiceItemLine.RESET;
            ServiceItemLine.SETRANGE("Service Item No.", ServiceItemLine."Service Item No.");
            ServiceItemLine.SETRANGE("Document Type", DocType);
            IF ServiceItemLine.COUNT = 1 THEN BEGIN
                ServiceHeader.GET(ServiceItemLine."Document Type", ServiceItemLine."Document No.");
                CASE DocType OF
                    DocType::Quote:
                        PAGE.RUNMODAL(PAGE::"Service Quote", ServiceHeader);
                    DocType::Order:
                        PAGE.RUNMODAL(PAGE::"Service Order", ServiceHeader);
                END
            END ELSE BEGIN
                CASE DocType OF
                    DocType::Quote:
                        PAGE.RUNMODAL(PAGE::"Service Quotes", ServiceItemLine);
                    DocType::Order:
                        PAGE.RUNMODAL(PAGE::"Service Tasks", ServiceItemLine);
                END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ValidServiceApprovalLine(ServiceLine: Record "5902"): Boolean
    var
        WorkType: Record "200";
        SkipPrice: Boolean;
    begin
        ServiceLine.TESTFIELD("Work Type Code");
        ServiceLine.TESTFIELD(Quantity);
        //pram 07 18 2018
        SkipPrice := FALSE;
        IF ServiceLine.Type = ServiceLine.Type::Resource THEN
            IF Resource.GET(ServiceLine."No.") THEN
                SkipPrice := Resource."Can Post Zero Price";
        IF NOT SkipPrice THEN
            ServiceLine.TESTFIELD("Unit Price");
        //end;

        ServiceLine.TESTFIELD("Unit of Measure Code");
        WorkType.GET(ServiceLine."Work Type Code");
        IF WorkType."Approval Required" THEN
            EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure ChangeRepairStatusAllowed(RecentRepairStatusCode: Code[20]; ChangeOption: Option Pending,"In Process",Finished,"On Hold"): Boolean
    var
        RepairStatus: Record "5927";
    begin
        IF RepairStatus.GET(RecentRepairStatusCode) THEN BEGIN
            CASE ChangeOption OF
                ChangeOption::Pending:
                    EXIT(RepairStatus."Pending Status Allowed");
                ChangeOption::"In Process":
                    EXIT(RepairStatus."In Process Status Allowed");
                ChangeOption::Finished:
                    EXIT(RepairStatus."Finished Status Allowed");
                ChangeOption::"On Hold":
                    EXIT(RepairStatus."On Hold Status Allowed");
            END;
        END;
    end;

    [Scope('Internal')]
    procedure CreateExtPurchaseOrder(var ServiceLine: Record "5902")
    var
        PurchaseLine: Record "39";
        Vendor: Record "23" temporary;
        DocumentNo: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LastLineNo: Integer;
        POCreated: Boolean;
        QtyRcvd: Decimal;
        PurchRcptDocNos: Text;
        PurchOrderNos: Text;
        SkipLine: Boolean;
    begin
        ServiceLine.SETRANGE("Line Type", ServiceLine."Line Type"::"4");
        IF ServiceLine.FINDFIRST THEN
            REPEAT
                SkipLine := FALSE;
                ServiceLine.TESTFIELD("Ext. Service Vendor No.");
                ServiceLine.TESTFIELD(Quantity);
                Vendor.INIT;
                Vendor."No." := ServiceLine."Ext. Service Vendor No.";
                PurchaseLine.RESET;
                PurchaseLine.SETRANGE("Service Document No.", ServiceLine."Document No.");
                PurchaseLine.SETRANGE("Serv. Doc. Line No.", ServiceLine."Line No.");
                IF PurchaseLine.FINDFIRST THEN
                    IF NOT CONFIRM(PurchOrderExistsErr, FALSE, PurchaseLine."Document No.", ServiceLine."Line No.") THEN
                        SkipLine := TRUE;
                CR := 13;
                LF := 10;
                IF NOT SkipLine THEN
                    IF ExternalServiceIsPurchased(ServiceLine, QtyRcvd, PurchRcptDocNos) THEN
                        IF NOT CONFIRM(ExtServiceAlreadyPurchErr, FALSE, QtyRcvd, ServiceLine."No.", ServiceLine."Line No.", FORMAT(CR) + FORMAT(LF), FORMAT(CR) + FORMAT(LF), PurchRcptDocNos) THEN
                            SkipLine := TRUE;
                IF NOT SkipLine THEN
                    IF Vendor.INSERT THEN;
            UNTIL ServiceLine.NEXT = 0;

        Vendor.RESET;
        IF Vendor.FINDFIRST THEN BEGIN
            REPEAT
                POCreated := CreatePurchHeader(Vendor."No.", DocType::Order, ServiceLine."Document No.", DocumentNo);
                PurchOrderNos += DocumentNo + FORMAT(CR) + FORMAT(LF);
                LastLineNo := 1000;
                ServiceLine.SETRANGE("Ext. Service Vendor No.", Vendor."No.");
                IF ServiceLine.FINDSET THEN
                    REPEAT
                        IF ServiceLine."Line Type" = ServiceLine."Line Type"::"4" THEN BEGIN
                            CLEAR(PurchaseLine);
                            PurchaseLine.INIT;
                            PurchaseLine.VALIDATE("Document Type", DocType::Order);
                            PurchaseLine.VALIDATE("Document Profile", PurchaseLine."Document Profile"::"3");
                            PurchaseLine.VALIDATE("Document No.", DocumentNo);
                            PurchaseLine."Line No." := LastLineNo;
                            PurchaseLine.VALIDATE(Type, PurchaseLine.Type::Item);
                            PurchaseLine.VALIDATE("Service Document No.", ServiceLine."Document No."); //pram
                            PurchaseLine.VALIDATE("Serv. Doc. Line No.", ServiceLine."Line No.");
                            PurchaseLine.INSERT(TRUE);

                            PurchaseLine.VALIDATE("No.", ServiceLine."No.");
                            PurchaseLine.VALIDATE(Description, ServiceLine.Description);
                            PurchaseLine.VALIDATE(Quantity, ServiceLine.Quantity);
                            PurchaseLine.MODIFY;
                            LastLineNo += 10000;
                        END;
                    UNTIL ServiceLine.NEXT = 0;
            UNTIL Vendor.NEXT = 0;
        END;

        IF POCreated THEN
            MESSAGE(PurchOrderCreatedMsg, FORMAT(CR) + FORMAT(LF), PurchOrderNos);
    end;

    local procedure CreatePurchHeader(VendorNo: Code[20]; DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; ServiceOrderNo: Code[20]; var DocNo: Code[20]): Boolean
    var
        PurchaseHeader: Record "38";
    begin
        CLEAR(PurchaseHeader);
        PurchaseHeader.INIT;
        PurchaseHeader.VALIDATE("Document Type", DocType);
        PurchaseHeader.VALIDATE("Document Profile", PurchaseHeader."Document Profile"::"3");
        PurchaseHeader.INSERT(TRUE);
        PurchaseHeader.VALIDATE("Buy-from Vendor No.", VendorNo);
        PurchaseHeader."Service Order No" := ServiceOrderNo;
        PurchaseHeader.MODIFY(TRUE);
        DocNo := PurchaseHeader."No.";
        EXIT(TRUE);
    end;

    local procedure GetPurchRcptDocNos(var ItemLedgerEntry: Record "32") DocumentNos: Text
    begin
        REPEAT
            DocumentNos += ItemLedgerEntry."Document No." + FORMAT(CR) + FORMAT(LF);
        UNTIL ItemLedgerEntry.NEXT = 0;
        EXIT(DocumentNos);
    end;

    [Scope('Internal')]
    procedure ExternalServiceIsPurchased(ServiceLine: Record "5902"; var QtyRcvd: Decimal; var PurchRcptDocNos: Text): Boolean
    var
        ItemLedgerEntry: Record "32";
    begin
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Order Type", "Order No.", "Order Line No.", "Entry Type");
        ItemLedgerEntry.SETRANGE("Order Type", ItemLedgerEntry."Order Type"::Service);
        ItemLedgerEntry.SETRANGE("Order No.", ServiceLine."Document No.");
        //ItemLedgerEntry.SETRANGE("Order Line No.",ServiceLine."Line No.");
        ItemLedgerEntry.SETRANGE("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
        ItemLedgerEntry.SETRANGE("Document Type", ItemLedgerEntry."Document Type"::"Purchase Receipt");
        ItemLedgerEntry.SETRANGE("Item No.", ServiceLine."No.");
        ItemLedgerEntry.SETRANGE("Source Type", ItemLedgerEntry."Source Type"::Vendor);
        ItemLedgerEntry.SETRANGE("Source No.", ServiceLine."Ext. Service Vendor No.");
        ItemLedgerEntry.CALCSUMS(Quantity);
        QtyRcvd := ItemLedgerEntry.Quantity;
        IF (QtyRcvd >= ServiceLine.Quantity) THEN BEGIN
            PurchRcptDocNos := GetPurchRcptDocNos(ItemLedgerEntry);
            EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure CheckServiceCreditMemo(ServiceHeader: Record "5900")
    begin
    end;

    [Scope('Internal')]
    procedure CheckServiceOrder(ServiceHeader: Record "5900")
    var
        ServSetup: Record "5911";
        ServiceLine: Record "5902";
        ServiceItemLine: Record "5901";
        SystemMgt: Codeunit "50014";
        ServiceMgt: Codeunit "50017";
        ApprovalRequired: Boolean;
        RecordRestrictionMgt: Codeunit "1550";
        QtyRcvd: Decimal;
        PurchRcptDocNos: Text;
        WorkType: Record "200";
    begin

        ServSetup.GET;
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        IF ServiceLine.FINDSET THEN
            REPEAT
                IF ServSetup."Work Type Code Mandatory" THEN
                    ServiceLine.TESTFIELD("Work Type Code");
                IF ServiceLine.Type <> ServiceLine.Type::" " THEN BEGIN
                    ServiceLine.TESTFIELD(Quantity);
                END;
                IF WorkType.GET(ServiceLine."Work Type Code") THEN
                    IF WorkType."Approval Required" THEN
                        RecordRestrictionMgt.CheckRecordHasUsageRestrictions(ServiceLine.RECORDID);
                /* //pram
                IF SystemMgt.IsWarrantyApprovalsWorkflowEnabled(ServiceLine) THEN
                  IF ServiceMgt.ValidServiceApprovalLine(ServiceLine) THEN
                    ServiceLine.TESTFIELD("Approval Status",ServiceLine."Approval Status"::Approved);
                 */

                IF WorkType.GET(ServiceLine."Work Type Code") THEN BEGIN
                    IF WorkType."Approval Required" THEN
                        IF ServiceMgt.ValidServiceApprovalLine(ServiceLine) THEN
                            ServiceLine.TESTFIELD("Approval Status", ServiceLine."Approval Status"::"2");
                END;
                //<<pram
                IF ServiceLine."Line Type" = ServiceLine."Line Type"::"4" THEN
                    IF NOT ServiceMgt.ExternalServiceIsPurchased(ServiceLine, QtyRcvd, PurchRcptDocNos) THEN
                        ERROR(ExtServiceNotPurchErr, ServiceLine."No.", ServiceLine."Line No.");
            UNTIL ServiceLine.NEXT = 0;

        ServiceItemLine.RESET;
        ServiceItemLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceItemLine.SETRANGE("Document No.", ServiceHeader."No.");
        IF ServiceItemLine.FINDFIRST THEN
            REPEAT
                IF (ServiceItemLine.Kilometrage = 0) AND (ServiceItemLine."Hour Reading" = 0) THEN
                    ERROR(NoKilometrageOrHourReading);
            UNTIL ServiceItemLine.NEXT = 0;

    end;

    [Scope('Internal')]
    procedure CreateTransferOrderFromServiceLines(_ServiceLine: Record "5902")
    var
        ServiceLine: Record "5902";
        QtyBase: Decimal;
        TransferHeaderCreated: Boolean;
        TransferOrderNo: Code[20];
        TypeOfTransferText: Label 'Inbound,Outbound,Cancel';
        FromLocation: Code[10];
        ToLocation: Code[10];
        TypeOfTransfer: Integer;
        LastTransferLineNo: Integer;
        UserSetUp: Record "91";
        TransferOrder: Record "5740";
        ServiceSetup: Record "5911";
    begin
        TypeOfTransfer := STRMENU(TypeOfTransferText, 3);
        IF TypeOfTransfer = 3 THEN
            EXIT;


        IF TypeOfTransfer = 1 THEN BEGIN
            UserSetUp.GET(USERID);
            //  IF NOT TransferDocumentExists2(_ServiceLine."Document No.",GetStoreLocation(UserSetUp."Default Location Code"), //Agile RD DEC 23 2016
            //                                UserSetUp."Default Location Code") THEN BEGIN
            IF NOT TransferHeaderCreated THEN BEGIN
                TransferOrderNo := CreateTransferHeader(_ServiceLine."Document No.", GetStoreLocation(UserSetUp."User Department"),
                                   UserSetUp."User Department");
                TransferHeaderCreated := TRUE;
                MESSAGE(TransferOrderCreated, TransferOrderNo, _ServiceLine."Document No.");
            END;
            //END;  //Agile RD DEC 23 2016  (To allow Multiple Transfer orders to be created)
        END;
        ServiceSetup.GET;
        IF TypeOfTransfer = 2 THEN BEGIN
            ServiceLine.RESET;
            ServiceLine.SETRANGE("Document Type", _ServiceLine."Document Type");
            ServiceLine.SETRANGE("Document No.", _ServiceLine."Document No.");
            ServiceLine.SETRANGE(Type, _ServiceLine.Type::Item);
            ServiceLine.SETAUTOCALCFIELDS("Reserved Quantity");
            //IME.RD
            ServiceLine.SETAUTOCALCFIELDS("Received Quantity");
            //IME.RD
            IF ServiceLine.FINDSET THEN
                REPEAT
                    //  IF TypeOfTransfer = 1 THEN BEGIN
                    //    QtyBase := ServiceLine.Quantity - ServiceLine."Reserved Quantity";
                    //    FromLocation := GetStoreLocation(ServiceLine."Location Code");
                    //    ToLocation := ServiceLine."Location Code";
                    //  END
                    //  ELSE
                    // IF TypeOfTransfer = 2 THEN BEGIN
                    //QtyBase := ServiceLine.Quantity - ServiceLine."Reserved Quantity";
                    //IME.RD
                    IF ServiceSetup."Enable Reservation Module" THEN
                        QtyBase := ServiceLine."Qty. to Return" //ServiceLine."Received Quantity" - ServiceLine.Quantity; //Agile_SM 20 Sep 2017 Reservation Mgt
                    ELSE
                        QtyBase := ServiceLine."Received Quantity" - ServiceLine.Quantity;
                    //QtyBase := ServiceLine."Requisition Quantity";  //only test to be removed
                    //IME
                    FromLocation := ServiceLine."Location Code";
                    ToLocation := GetStoreLocation(ServiceLine."Location Code");
                    // END;
                    IF (QtyBase > 0) AND (NOT TransferDocumentExists(ServiceLine."Document No.", ServiceLine."Line No.", ServiceLine."No.", QtyBase, FromLocation, ToLocation)) THEN BEGIN
                        IF NOT TransferHeaderCreated THEN BEGIN
                            TransferOrderNo := CreateTransferHeader(ServiceLine."Document No.", FromLocation, ToLocation);
                            TransferHeaderCreated := TRUE;
                            //Agile RD 06032017
                            TransferOrder.SETRANGE(TransferOrder."No.", TransferOrderNo);
                            IF TransferOrder.FINDFIRST THEN BEGIN
                                TransferOrder."Service Requisition Sent" := TRUE;
                                TransferOrder.MODIFY;
                            END;
                            //Agile RD 06032017
                        END;
                        LastTransferLineNo := CreateTransferLine(TransferOrderNo, LastTransferLineNo,
                                                QtyBase, TypeOfTransfer, ServiceLine);
                        LastTransferLineNo += 10000;
                    END;
                UNTIL ServiceLine.NEXT = 0;

            IF LastTransferLineNo > 0 THEN
                MESSAGE(TransferOrderCreated, TransferOrderNo, ServiceLine."Document No.");
        END;
    end;

    local procedure CreateTransferHeader(DocumentNo: Code[20]; FromLocation: Code[10]; ToLocation: Code[10]): Code[20]
    var
        TransferHeader: Record "5740";
        Location: Record "14";
        ServiceSetup: Record "5911";
    begin
        TransferHeader.INIT;
        TransferHeader.INSERT(TRUE);
        TransferHeader.VALIDATE("Transfer-from Code", FromLocation);
        TransferHeader.VALIDATE("Transfer-to Code", ToLocation);
        TransferHeader.VALIDATE(TransferHeader."In-Transit Code", 'INTRANSIT');
        TransferHeader.Tender := TRUE;
        TransferHeader."Service Order No." := DocumentNo;
        //SRT May 28th 2019 >>
        IF NOT ServiceSetup."IMEA Service Setup" THEN BEGIN
            TransferHeader."Service Requisition Sent" := TRUE;
            TransferHeader."Is Requisition Order" := TRUE;
            TransferHeader."Transfer Type" := TransferHeader."Transfer Type"::"6";
            TransferHeader."Requisition Date" := TODAY; //pram
        END;
        //SRT May 28th 2019 <<
        TransferHeader.MODIFY(TRUE);
        EXIT(TransferHeader."No.");
    end;

    local procedure CreateTransferLine(TransferOrderNo: Code[20]; LastTransferLineNo: Integer; Quantity: Decimal; TypeOfTransfer: Integer; ServiceLine: Record "5902"): Integer
    var
        TransferLine: Record "5741";
        Reservation: Page "498";
        EntryNo: Integer;
        RecServiceSetup: Record "5911";
        Item: Record "27";
        TransHeader: Record "5740";
        ServSetup: Record "5911";
    begin
        CLEAR(TransferLine);
        /*TransferLine.INIT;
        TransferLine."Document No." := TransferOrderNo;
        TransferLine."Line No." := LastTransferLineNo + 1000;
        TransferLine.VALIDATE(TransferLine."Shipment Date",TODAY);//Agile RD 17.12.04
        TransferLine.VALIDATE("Item No.",ServiceLine."No.");
        IF TypeOfTransfer = 2 THEN
          TransferLine.VALIDATE(Quantity,Quantity);*/
        //TransferLine.VALIDATE("Unit of Measure Code",ServiceLine."Unit of Measure Code");


        IF TypeOfTransfer = 1 THEN BEGIN
            ServSetup.GET;
            IF NOT ServSetup."IMEA Service Setup" THEN BEGIN
                ServiceLine.TESTFIELD("Requisition Quantity");
                ServiceLine.TESTFIELD("Requisition Description");
            END;
            TransferLine.INIT;
            TransferLine."Document No." := TransferOrderNo;
            TransferLine."Line No." := LastTransferLineNo + 1000;
            TransferLine.VALIDATE(TransferLine."Shipment Date", TODAY);//Agile RD 17.12.04
            TransferLine.VALIDATE("Item No.", ServiceLine."No.");
            TransferLine."Reserved From Service" := TRUE;
            TransferLine."Requisition Quantity" := ServiceLine."Requisition Quantity";  //SRT May 14th 2019
            TransferLine."Quantity Requested" := ServiceLine."Requisition Quantity";
            TransferLine."Requisition Description" := ServiceLine."Requisition Description";
            TransferLine."Quantity Requested" := ServiceLine."Requisition Quantity";
            TransferLine."Is Requisition Order" := TRUE;
            TransferLine."Item Requisition Sent" := TRUE;
            TransferLine."Confirmed By" := TRUE;
            TransferLine.VALIDATE(Quantity, ServiceLine."Requisition Quantity");
            TransHeader.GET(TransferOrderNo);
            Item.RESET;
            Item.SETRANGE("No.", ServiceLine."No.");
            Item.SETFILTER("Location Filter", TransHeader."Transfer-from Code");
            IF Item.FINDFIRST THEN BEGIN
                Item.CALCFIELDS(Inventory);
                IF TransferLine."Requisition Quantity" > Item.Inventory THEN
                    TransferLine."Qty. Not in Inventory" := TransferLine."Requisition Quantity" - Item.Inventory
                ELSE
                    TransferLine."Qty. Not in Inventory" := 0;
            END;
            TransferLine."Service Order No." := ServiceLine."Document No.";
            TransferLine."Service Order Line No" := ServiceLine."Line No.";
            TransferLine.INSERT(TRUE);
        END;

        //Agile_SM 20 Sep 2017 Reservation Mgt
        IF TypeOfTransfer = 2 THEN BEGIN
            RecServiceSetup.GET;
            IF RecServiceSetup."Enable Reservation Module" THEN BEGIN
                //Changing reservations in 4 steps
                //Step 1: Saving the initial Quantity Transfered
                ServiceLine.CALCFIELDS("Reserved Quantity");
                QtyTransfered := ServiceLine."Reserved Quantity";
                //Step 2: Canceling all Service Line reservations to Item Ledger Entries (Transfered Qty.)
                ReservationMgt.CancelServLineRresILE(ServiceLine, ServLine_GblItemLedgEntryNo);
                //Step 3: Reserving Service Line to ILE (decreased by Qty.to Return)
                ServiceLine.AutoReserveToILE(QtyTransfered - ServiceLine."Qty. to Return", ServLine_GblItemLedgEntryNo);
                //Step 4: Auto-Reserve return Transfer Line (Outb.) to Item Ledger Entry
                //SRT Sept 1st 2019 >>
                TransferLine.INIT;
                TransferLine."Document No." := TransferOrderNo;
                TransferLine."Line No." := LastTransferLineNo + 1000;
                TransferLine.VALIDATE(TransferLine."Shipment Date", TODAY);//Agile RD 17.12.04
                TransferLine.VALIDATE("Item No.", ServiceLine."No.");
                IF TypeOfTransfer = 2 THEN
                    TransferLine.VALIDATE(Quantity, ServiceLine."Qty. to Return");
                TransferLine."Service Order Line No" := ServiceLine."Line No."; //to check SRT
                TransferLine.INSERT(TRUE);
                //SRT Sept 1st 2019 <<
                TransferLine.AutoReserveSilent(0, ServLine_GblItemLedgEntryNo); //0=Outbound
                ServiceLine.VALIDATE(Quantity, ABS(ServiceLine.Quantity - ServiceLine."Qty. to Return"));
                ServiceLine."Qty. to Return" := 0;
                ServiceLine.MODIFY(TRUE);
            END;
        END;
        //Agile_SM 20 Sep 2017 Reservation Mgt

        /*IF TypeOfTransfer = 1 THEN BEGIN
          CLEAR(Reservation);
          Reservation.SetTransLine(TransferLine,0); //0 means Outbound
          Reservation.AutoReserve;
        END;*/
        EXIT(LastTransferLineNo);

    end;

    local procedure GetStoreLocation(ServiceLocation: Code[10]): Code[10]
    var
        Location: Record "14";
    begin
        Location.GET(ServiceLocation);
        Location.TESTFIELD("Admin/Procurement", TRUE);
        Location.TESTFIELD("Default Price Group");
        EXIT(Location."Default Price Group");
    end;

    local procedure TransferDocumentExists(ServiceOrderNo: Code[20]; ServiceOrderLineNo: Integer; ItemNo: Code[20]; QtyBase: Decimal; FromLocation: Code[10]; ToLocation: Code[10]): Boolean
    var
        TransferLine: Record "5741";
    begin
        TransferLine.RESET;
        TransferLine.SETCURRENTKEY("Reserved From Service", "Service Order Line No");
        TransferLine.SETRANGE("Service Order No.", ServiceOrderNo);
        TransferLine.SETRANGE("Service Order Line No", ServiceOrderLineNo);
        TransferLine.SETRANGE("Item No.", ItemNo);
        TransferLine.SETRANGE("Transfer-from Code", FromLocation);
        TransferLine.SETRANGE("Transfer-to Code", ToLocation);
        TransferLine.SETRANGE("Derived From Line No.", 0);
        TransferLine.SETRANGE(TransferLine."Posted Transfer Order", FALSE);  //Agile RD 17.10.15
        IF TransferLine.FINDFIRST THEN BEGIN
            IF TransferLine.Quantity >= QtyBase THEN
                EXIT(TRUE);
        END;
        EXIT(FALSE);
    end;

    local procedure TransferDocumentExists2(ServiceOrderNo: Code[20]; FromLocation: Code[10]; ToLocation: Code[10]): Boolean
    var
        TransferHeader: Record "5740";
    begin
        TransferHeader.RESET;
        TransferHeader.SETCURRENTKEY("Service Order No.");
        TransferHeader.SETRANGE("Service Order No.", ServiceOrderNo);
        TransferHeader.SETRANGE("Transfer-from Code", FromLocation);
        TransferHeader.SETRANGE("Transfer-to Code", ToLocation);
        IF TransferHeader.FINDFIRST THEN BEGIN
            EXIT(TRUE);
        END;
        EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure Binding()
    begin
    end;

    [Scope('Internal')]
    procedure GetNoOfPostedServiceInvoices(DocNo: Code[20]): Integer
    var
        ServiceInvHeader: Record "5992";
    begin
        //JCB
        ServiceInvHeader.RESET;
        ServiceInvHeader.SETCURRENTKEY("Complaint No");
        ServiceInvHeader.SETRANGE("Complaint No", DocNo);
        EXIT(ServiceInvHeader.COUNT);
    end;

    [Scope('Internal')]
    procedure GetNoOfPostedServiceShipments(DocNo: Code[20]): Integer
    var
        ServiceShptHeader: Record "5990";
    begin
        //JCB
        ServiceShptHeader.RESET;
        ServiceShptHeader.SETCURRENTKEY("Complaint No");
        ServiceShptHeader.SETRANGE("Complaint No", DocNo);
        EXIT(ServiceShptHeader.COUNT);
    end;

    [Scope('Internal')]
    procedure GetNoOfPendingServiceOrders(DocNo: Code[20]): Integer
    var
        ServiceHeader: Record "5900";
    begin
        //JCB
        ServiceHeader.RESET;
        ServiceHeader.SETCURRENTKEY("Complaint No.");
        ServiceHeader.SETRANGE("Complaint No.", DocNo);
        EXIT(ServiceHeader.COUNT);
    end;

    [Scope('Internal')]
    procedure LookupPostedServiceInvoices(DocNo: Code[20])
    var
        ServiceInvheader: Record "5992";
    begin
        //JCB
        ServiceInvheader.RESET;
        ServiceInvheader.SETCURRENTKEY("Complaint No");
        ServiceInvheader.SETRANGE("Complaint No", DocNo);
        PAGE.RUNMODAL(PAGE::"Posted Service Invoices", ServiceInvheader);
    end;

    [Scope('Internal')]
    procedure LookupPostedServiceShipments(DocNo: Code[20])
    var
        ServiceShptHeader: Record "5990";
    begin
        //JCB
        ServiceShptHeader.RESET;
        ServiceShptHeader.SETCURRENTKEY("Complaint No");
        ServiceShptHeader.SETRANGE("Complaint No", DocNo);
        PAGE.RUNMODAL(PAGE::"Posted Service Shipments", ServiceShptHeader);
    end;

    [Scope('Internal')]
    procedure LookupPendingServiceOrders(DocNo: Code[20])
    var
        ServiceHeader: Record "5900";
    begin
        //JCB
        ServiceHeader.RESET;
        ServiceHeader.SETCURRENTKEY("Complaint No.");
        ServiceHeader.SETRANGE("Complaint No.", DocNo);
        PAGE.RUNMODAL(PAGE::"Service Orders", ServiceHeader);
    end;

    [Scope('Internal')]
    procedure UpdateKilometerAge(VIN: Code[20]; Kilometerage: Decimal)
    var
        ServiceItem: Record "5940";
    begin
        ServiceItem.RESET;
        ServiceItem.GET(VIN);
        ServiceItem.Kilometerage := Kilometerage;
        ServiceItem.MODIFY;
    end;

    [Scope('Internal')]
    procedure UpdateHourReading(VIN: Code[20]; HourReading: Decimal)
    var
        ServiceItem: Record "5940";
    begin
        ServiceItem.RESET;
        ServiceItem.GET(VIN);
        ServiceItem."Hour Reading" := HourReading;
        ServiceItem.MODIFY;
    end;

    local procedure "----IME Complaint---------"()
    begin
    end;

    [Scope('Internal')]
    procedure GetFirstServiceItemNo(ServiceHeader: Record "5900"): Code[20]
    var
        ServiceItemLine: Record "5901";
    begin
        ServiceItemLine.RESET;
        ServiceItemLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceItemLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceItemLine.FINDFIRST;
        EXIT(ServiceItemLine."Service Item No.");
    end;

    [Scope('Internal')]
    procedure LabourAssignment(ServiceHeader: Record "5900")
    var
        "---Complaint----": Integer;
        ComplaintHeader: Record "50065";
        ComplaintLabor: Record "50069";
        ServiceLines: Record "5902";
        ServMgmt: Codeunit "50017";
        ServiceLine: Record "5902";
        LineNo: Integer;
        ServiceOrderAllocation: Record "5950";
    begin
        ComplaintHeader.RESET;
        ComplaintHeader.SETRANGE(ComplaintHeader."Document No.", ServiceHeader."Complaint No.");
        IF ComplaintHeader.FINDFIRST THEN BEGIN
            ComplaintLabor.RESET;
            ComplaintLabor.SETRANGE(ComplaintLabor."Complaint No.", ComplaintHeader."Document No.");
            IF ComplaintLabor.FINDFIRST THEN BEGIN
                ServiceLine.RESET;
                ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
                ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
                IF ServiceLine.FINDLAST THEN
                    LineNo := ServiceLine."Line No." + 10000
                ELSE
                    LineNo := 10000;
                REPEAT
                    CLEAR(ServiceLines);
                    ServiceLines.INIT;
                    ServiceLines."Document Type" := ServiceHeader."Document Type";
                    ServiceLines."Document No." := ServiceHeader."No.";
                    ServiceLines."Line No." := LineNo;
                    ServiceLines.VALIDATE("Service Item No.", ServMgmt.GetFirstServiceItemNo(ServiceHeader));
                    ServiceLines.VALIDATE("Line Type", ServiceLines."Line Type"::"2");
                    ServiceLines.Type := ServiceLines.Type::Resource;
                    ServiceLines.VALIDATE("No.", ComplaintLabor."Labor No.");
                    ServiceLines.VALIDATE(Quantity, 1);
                    ServiceLines.INSERT;

                    //        ServiceOrderAllocation.RESET;
                    //        ServiceOrderAllocation.INIT;
                    //          ServiceOrderAllocation."Document No." := ServiceHeader."No.";
                    //          ServiceOrderAllocation."Document Type" := ServiceHeader."Document Type";
                    //        ServiceOrderAllocation."Service Line No." := ServiceLines."Line No.";
                    //        ServiceOrderAllocation."Service Item Serial No." := ServiceLines."Service Item Serial No.";
                    //        ServiceOrderAllocation."Service Item Line No." := ServiceLines."Service Item Line No.";
                    //        ServiceOrderAllocation."Service Item Description" := ServiceLines."Service Item Line Description";
                    //        ServiceOrderAllocation.VALIDATE(ServiceOrderAllocation."Allocated Hours",ComplaintLabor."Allocation Hrs");
                    //        ServiceOrderAllocation.VALIDATE(ServiceOrderAllocation."Allocation Date",ComplaintLabor."Allocation Date");
                    //        ServiceOrderAllocation.VALIDATE(ServiceOrderAllocation."Resource No.",ComplaintLabor."Technician Code");
                    //        ServiceOrderAllocation.INSERT;
                    //


                    LineNo += 10000;
                UNTIL ComplaintLabor.NEXT = 0;
            END;
        END;
    end;

    local procedure "--Requisition Control---"()
    begin
    end;

    [Scope('Internal')]
    procedure IsServiceTransferInbound(TransferHeader: Record "5740"): Boolean
    var
        Location: Record "14";
    begin
        Location.GET(TransferHeader."Transfer-to Code");
        IF Location."Admin/Procurement" THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    local procedure IsService()
    begin
    end;

    [Scope('Internal')]
    procedure GetTransferHeaderUsingTransferLineFilters(TransferLine: Record "5741"; var TransferHeader: Record "5740")
    begin
        TransferHeader.RESET;
        //TransferHeader.SETFILTER(TransferHeader."No.",TransferLine.GETFILTER(TransferLine."Document No."));
        TransferHeader.SETFILTER(TransferHeader."No.", TransferLine."Document No.");
        TransferHeader.FINDFIRST;
    end;

    [Scope('Internal')]
    procedure IsServiceItemBlocked(Serviceitemno: Code[20]; DocumentNo: Code[20]; DocumentType: Option Sales,Service,Complaint): Boolean
    var
        ServiceItem: Record "5940";
        Err: Label 'You cannot select the service item %1 because it has been blocked for reason %2. Please contact recovery team or system administrator.';
        BloackedVehicleLog: Record "50070";
        UserSetup: Record "91";
        blocked: Boolean;
    begin
        //Blocking the posting/Finishing of blocked service item
        UserSetup.GET(USERID);
        blocked := FALSE;
        IF Serviceitemno <> '' THEN BEGIN
            ServiceItem.GET(Serviceitemno);
            IF ServiceItem.Blocked THEN BEGIN
                BloackedVehicleLog.RESET;
                BloackedVehicleLog.INIT;
                BloackedVehicleLog."Entry No." := BloackedVehicleLog.GetEntryNo;
                BloackedVehicleLog."Service Item No." := ServiceItem."No.";
                BloackedVehicleLog."Customer No." := ServiceItem."Customer No.";
                BloackedVehicleLog.Date := TODAY;
                BloackedVehicleLog.Time := TIME;
                BloackedVehicleLog."Document Type" := DocumentType;
                BloackedVehicleLog."Document No." := DocumentNo;
                BloackedVehicleLog."User ID" := USERID;
                BloackedVehicleLog."Location Code" := UserSetup."User Department";
                BloackedVehicleLog.Branch := UserSetup."Default Responsibility Center";
                BloackedVehicleLog.INSERT;
                blocked := TRUE;
                COMMIT;     //Since VIn in not validated anywhere when the sales post is run
                            //Thus it should not effect posting
                ERROR(Err, ServiceItem."No.", ServiceItem."Reason To Block/Unblock");
            END;
        END;
        EXIT(blocked);
    end;

    local procedure "--GATEPASS--"()
    begin
    end;

    [Scope('Internal')]
    procedure CreateGatePassOnServiceInvoice(ServiceInvHeader: Record "5992"): Code[20]
    var
        GatePass: Record "50004";
        UserSetup: Record "91";
        GatePass2: Record "50004";
    begin
        UserSetup.GET(USERID);
        GatePass2.RESET;
        GatePass2.SETRANGE(GatePass2."Document Type", GatePass2."Document Type"::"Spare Parts Trade");
        GatePass2.SETRANGE(GatePass2.Description, ServiceInvHeader."No.");
        GatePass2.SETRANGE(GatePass2."Issued Date (BS)", GatePass2."Issued Date (BS)"::"2");
        GatePass2.SETRANGE(GatePass2.Destination, GatePass2.Destination::"4");
        IF GatePass2.ISEMPTY THEN BEGIN
            GatePass.INIT;
            GatePass."Document Type" := GatePass."Document Type"::"Spare Parts Trade";
            GatePass.Location := UserSetup."User Department";
            GatePass.Description := ServiceInvHeader."No.";
            GatePass.VALIDATE(Remarks, ServiceInvHeader."Service Item No.");
            GatePass."Issued Date (BS)" := GatePass."Issued Date (BS)"::"2";
            GatePass.Destination := GatePass.Destination::"4";
            GatePass."No. of Print" := TRUE;
            GatePass.INSERT(TRUE);
            DocNo := GatePass."Document No";
            COMMIT;
            //MESSAGE('Gate pass: %1 created',GatePass."Document No");
        END ELSE BEGIN
            IF GatePass2.FINDFIRST THEN BEGIN
                DocNo := GatePass2."Document No";
                IF GatePass2.Remarks = '' THEN BEGIN
                    GatePass2.VALIDATE(Remarks, ServiceInvHeader."Service Item No.");
                    GatePass2.MODIFY;
                    COMMIT;
                END;
            END;
        END;
        GatePass2.SETRANGE(GatePass2."Document No", DocNo);
        IF GatePass2.FINDFIRST THEN
            REPORT.RUN(50046, TRUE, FALSE, GatePass2);
    end;

    [Scope('Internal')]
    procedure PostService(var SalesHeader: Record "36"; Printreport: Boolean)
    var
        SalesHeaderArchive: Record "5107";
        ArchiveManagement: Codeunit "5063";
        InvoiceSplitted: Boolean;
    begin
        //  ValidationCheckOnServicePostDMS;
        /*
        SalesHeaderArchive.RESET;
        SalesHeaderArchive.SETRANGE("No.",SalesHeader."No.");
        SalesHeaderArchive.DELETEALL(TRUE);


        CLEAR(ArchiveManagement);
        ArchiveManagement.InitPostedServiceOrder;
        ArchiveManagement.ArchSalesDocumentNoConfirm(SalesHeader);
        COMMIT;
        */
        InvoiceSplitted := SplitInvoice(SalesHeader);
        IF InvoiceSplitted THEN BEGIN
            IF Printreport THEN BEGIN
                //      REPORT.RUN(REPORT::"Service - Order",FALSE,FALSE,SalesHeader);
            END;
            SalesHeader.DELETE(TRUE);
        END;

    end;

    [Scope('Internal')]
    procedure SplitInvoice(var SalesHeader: Record "36") InvoiceSplitted: Boolean
    var
        BillToCustomer: array[1000] of Code[20];
        LineJobType: array[1000] of Code[20];
        InvoiceCount: Integer;
        i: Integer;
        NoOfDocuments: Integer;
        Text000: Label 'Invoice creation failed for Order %1.';
    begin
        IF TRUE THEN BEGIN
            // IF SalesHeader."Document Profile" = SalesHeader."Document Profile"::Service THEN BEGIN
            GetInvoiceCountByJobType(SalesHeader, BillToCustomer, LineJobType, InvoiceCount);
            FOR i := 1 TO InvoiceCount DO BEGIN
                IF CreateSalesInvoiceFromService(SalesHeader, BillToCustomer[i], LineJobType[i]) THEN
                    NoOfDocuments += 1;
            END;
            IF NoOfDocuments = InvoiceCount THEN
                InvoiceSplitted := TRUE
            ELSE
                ERROR(Text000, SalesHeader."No.");
        END;
        EXIT(InvoiceSplitted);
    end;

    local procedure GetInvoiceCountByJobType(SalesHeader: Record "36"; var BillToCustomer: array[1000] of Code[20]; var LineJobType: array[1000] of Code[20]; var InvoiceCount: Integer)
    var
        SalesLine: Record "37";
        i: Integer;
        j: Integer;
        k: Integer;
        DuplicateBillToCustomer: Boolean;
        JobType: Record "200";
    begin
        IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice] THEN BEGIN
            k := 1;
            SalesLine.RESET;
            SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
            SalesLine.SETRANGE("Document No.", SalesHeader."No.");
            SalesLine.SETFILTER("Qty. to Invoice", '<>0');
            SalesLine.SETCURRENTKEY(SalesLine."Work Type Code");
            IF SalesLine.FINDSET THEN
                REPEAT
                    i += 1;
                    DuplicateBillToCustomer := FALSE;
                    IF i > 1 THEN
                        FOR j := i - 1 DOWNTO 1 DO BEGIN
                            IF (BillToCustomer[j] = SalesLine."Bill-to Customer No.") AND (LineJobType[j] = SalesLine."Work Type Code") THEN BEGIN
                                DuplicateBillToCustomer := TRUE;
                            END;
                        END;
                    IF NOT DuplicateBillToCustomer THEN BEGIN
                        //JobType.GET(JobType.Type::Line,SalesLine."Job Type");
                        JobType.GET(SalesLine."Work Type Code");
                        IF NOT JobType."Invoice not applicable" THEN BEGIN
                            BillToCustomer[k] := SalesLine."Bill-to Customer No.";
                            LineJobType[k] := SalesLine."Work Type Code";
                            InvoiceCount += 1;
                            k += 1;
                        END;
                    END
                UNTIL SalesLine.NEXT = 0;
        END;
    end;

    local procedure CreateSalesInvoiceFromService(FromSalesHeader: Record "36"; BillToCustomer: Code[20]; LineJobType: Code[20]) DocumentCreated: Boolean
    var
        ToSalesHeader: Record "36";
        ToSalesLine: Record "37";
        FromSalesLine: Record "37";
        JobType: Record "200";
        Customer: Record "18";
        TempToSalesHeader: Record "36" temporary;
    begin
        Customer.GET(BillToCustomer);
        CLEAR(ToSalesHeader);
        ToSalesHeader.INIT;

        // pram >>
        FromSalesLine.RESET;
        FromSalesLine.SETRANGE("Document Type", FromSalesHeader."Document Type");
        FromSalesLine.SETRANGE("Document No.", FromSalesHeader."No.");
        FromSalesLine.SETRANGE("Bill-to Customer No.", BillToCustomer);
        FromSalesLine.SETRANGE("Work Type Code", LineJobType);
        IF FromSalesLine.FINDSET THEN BEGIN
            //JobType.GET(JobType.Type::Line,FromSalesLine."Job Type");
            JobType.GET(FromSalesLine."Work Type Code");
            //IF JobType."Only Ship" THEN
            ToSalesHeader."Document Type" := FromSalesHeader."Document Type"::Order
            //  ELSE
            //    ToSalesHeader."Document Type" := FromSalesHeader."Document Type"::Invoice;
        END;
        // pram <<


        ToSalesHeader.INSERT(TRUE);
        TempToSalesHeader.COPY(ToSalesHeader);

        ToSalesHeader.TRANSFERFIELDS(FromSalesHeader, FALSE);
        //ToSalesHeader."Line Job Type" := LineJobType;  //DLR2017CU5   Rethink
        ToSalesHeader.Status := ToSalesHeader.Status::Open;
        ToSalesHeader.SetHideValidationDialog(TRUE);
        ToSalesHeader.VALIDATE("Bill-to Customer No.", BillToCustomer);
        ToSalesHeader.VALIDATE("Shortcut Dimension 1 Code", FromSalesHeader."Shortcut Dimension 1 Code");//RD
        ToSalesHeader.VALIDATE("Shortcut Dimension 2 Code", FromSalesHeader."Shortcut Dimension 2 Code");//RD
        ToSalesHeader."Dimension Set ID" := FromSalesHeader."Dimension Set ID";//RD

        IF ToSalesHeader."Sell-to Customer No." <> ToSalesHeader."Bill-to Customer No." THEN BEGIN
            //ToSalesHeader."Payment Type" := ToSalesHeader."Payment Type"::" ";
            ToSalesHeader."Payment Method Code" := '';
        END ELSE BEGIN
            //ToSalesHeader."Payment Type" := FromSalesHeader."Payment Type";
            ToSalesHeader.VALIDATE("Payment Method Code", FromSalesHeader."Payment Method Code");
        END;

        // ToSalesHeader.VALIDATE("Service Order No.",FromSalesHeader."No.");

        ToSalesHeader."Salesperson Code" := FromSalesHeader."Salesperson Code";

        ToSalesHeader.MODIFY(TRUE);

        FromSalesLine.RESET;
        FromSalesLine.SETRANGE("Document Type", FromSalesHeader."Document Type");
        FromSalesLine.SETRANGE("Document No.", FromSalesHeader."No.");
        FromSalesLine.SETRANGE("Bill-to Customer No.", BillToCustomer);
        FromSalesLine.SETRANGE("Work Type Code", LineJobType);
        IF FromSalesLine.FINDSET THEN
            REPEAT
                //  JobType.GET(JobType.Type::Line,FromSalesLine."Job Type");
                JobType.GET(FromSalesLine."Work Type Code");
                IF NOT JobType."Invoice not applicable" THEN BEGIN
                    CLEAR(ToSalesLine);
                    ToSalesLine.INIT;
                    ToSalesLine.VALIDATE("Document Type", ToSalesHeader."Document Type");
                    ToSalesLine.VALIDATE("Document No.", ToSalesHeader."No.");
                    ToSalesLine.VALIDATE("Line No.", FromSalesLine."Line No.");
                    //pram
                    ToSalesLine.TRANSFERFIELDS(FromSalesLine, FALSE);
                    ToSalesLine.INSERT(TRUE);
                    ToSalesLine.MODIFY(TRUE);
                    DocumentCreated := TRUE;
                END;
            UNTIL FromSalesLine.NEXT = 0;

        ToSalesHeader.Status := ToSalesHeader.Status::Released;
        ToSalesHeader.MODIFY;

        /*
IF JobType.GET(ToSalesLine."Work Type Code") THEN //pram

   IF JobType."Only Ship" THEN BEGIN
    Invoice := FALSE;
    Ship := TRUE;
    END
  ELSE
  */
        ToSalesHeader.Ship := TRUE;
        ToSalesHeader.Invoice := TRUE;
        ToSalesHeader."Print Posted Documents" := FALSE;
        ToSalesHeader.MODIFY;

        CODEUNIT.RUN(CODEUNIT::"Sales-Post", ToSalesHeader);
        EXIT(DocumentCreated);

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
    procedure CreateExtPurchaseOrder2(var SalesLine: Record "37")
    var
        PurchaseLine: Record "39";
        Vendor: Record "23" temporary;
        DocumentNo: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LastLineNo: Integer;
        POCreated: Boolean;
        QtyRcvd: Decimal;
        PurchRcptDocNos: Text;
        PurchOrderNos: Text;
        SkipLine: Boolean;
        LastVendor: Code[20];
    begin
        CLEAR(DocumentNo);
        CLEAR(LastVendor);
        SalesLine.SETCURRENTKEY(SalesLine."Ext. Service Vendor No.");
        SalesLine.SETRANGE(LineType, SalesLine.LineType::"6");
        SalesLine.SETRANGE(SalesLine."Ext. PO No.", '');

        IF SalesLine.FINDFIRST THEN
            REPEAT
                SalesLine.TESTFIELD("Ext. Service Vendor No.");
                SalesLine.TESTFIELD(Quantity);
                IF LastVendor <> SalesLine."Ext. Service Vendor No." THEN BEGIN
                    LastVendor := SalesLine."Ext. Service Vendor No.";
                    CreatePurchHeader(LastVendor, DocType::Order, SalesLine."Document No.", DocumentNo);
                    LastLineNo := 10000;
                    POCreated := TRUE;
                    PurchOrderNos += DocumentNo;
                END;
                CLEAR(PurchaseLine);
                PurchaseLine.INIT;
                PurchaseLine.VALIDATE("Document Type", PurchaseLine."Document Type"::Order);
                PurchaseLine.VALIDATE("Document Profile", PurchaseLine."Document Profile"::"3");
                PurchaseLine.VALIDATE("Document No.", DocumentNo);
                PurchaseLine."Line No." := LastLineNo;
                PurchaseLine.VALIDATE(Type, PurchaseLine.Type::Item);
                PurchaseLine.VALIDATE("Is Service Sales Order", TRUE);
                PurchaseLine.VALIDATE("Service Document No.", SalesLine."Document No."); //pram
                PurchaseLine.VALIDATE("Serv. Doc. Line No.", SalesLine."Line No.");
                PurchaseLine.INSERT(TRUE);

                PurchaseLine.VALIDATE("No.", SalesLine."No.");
                PurchaseLine.VALIDATE(Description, SalesLine.Description);
                PurchaseLine.VALIDATE(Quantity, SalesLine.Quantity);
                PurchaseLine.MODIFY;
                LastLineNo += 10000;
                SalesLine."Ext. PO No." := DocumentNo;
                SalesLine.MODIFY;
            UNTIL SalesLine.NEXT = 0;

        IF POCreated THEN
            MESSAGE('Purchase Order has been created.\%1', PurchOrderNos);
    end;

    [Scope('Internal')]
    procedure CreatePurchaseInvoiceFromCC(var _MemoHdr: Record "50101")
    var
        PurchaseHeader: Record "38";
        PurchaseLine: Record "39";
        Vendor: Record "23";
        ItemCharge: Record "5800";
        MemoLine: Record "50102";
    begin
        IF _MemoHdr."PO Created No." <> '' THEN
            IF NOT CONFIRM('Document No. %1 has already been created.\Do you want to recreate?', FALSE, _MemoHdr."PO Created No.") THEN
                EXIT;

        CLEAR(PurchaseHeader);
        PurchaseHeader.INIT;
        PurchaseHeader.VALIDATE("Document Type", PurchaseHeader."Document Type"::Invoice);
        PurchaseHeader.INSERT(TRUE);
        IF Vendor.GET('V-001373') THEN
            PurchaseHeader.VALIDATE("Buy-from Vendor No.", Vendor."No.")
        ELSE
            EXIT;
        PurchaseHeader."Memo No." := _MemoHdr."No.";
        PurchaseHeader."Memo Type" := _MemoHdr."Document Type";
        PurchaseHeader.MODIFY(TRUE);

        _MemoHdr."PO Created No." := PurchaseHeader."No.";
        _MemoHdr.MODIFY;

        MemoLine.RESET;
        MemoLine.SETRANGE("Document Type", _MemoHdr."Document Type");
        MemoLine.SETRANGE("Document No.", _MemoHdr."No.");
        MemoLine.SETFILTER("Custom Duty", '<>%1', 0);
        IF MemoLine.FINDFIRST THEN;

        CLEAR(PurchaseLine);
        PurchaseLine.INIT;
        PurchaseLine.VALIDATE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.VALIDATE("Document No.", PurchaseHeader."No.");
        PurchaseLine."Line No." := 10000;
        PurchaseLine.VALIDATE(Type, PurchaseLine.Type::"Charge (Item)");
        IF ItemCharge.GET('CUS-IMPORT DUTY') THEN BEGIN
            PurchaseLine.VALIDATE("No.", ItemCharge."No.");
            PurchaseLine.VALIDATE(Quantity, 1);
            PurchaseLine.VALIDATE("Direct Unit Cost", MemoLine."Custom Duty");
        END;
        PurchaseLine.INSERT(TRUE);

        MESSAGE('%1 %2 has been created.', PurchaseHeader."Document Type", PurchaseHeader."No.");
    end;

    [Scope('Internal')]
    procedure CreatePurchaseInvoiceFromReg(var _MemoHdr: Record "50101")
    var
        PurchaseHeader: Record "38";
        PurchaseLine: Record "39";
        Vendor: Record "23";
        ItemCharge: Record "5800";
        MemoLine: Record "50102";
    begin
        IF _MemoHdr."PO Created No." <> '' THEN
            IF NOT CONFIRM('Document No. %1 has already been created.\Do you want to recreate?', FALSE, _MemoHdr."PO Created No.") THEN
                EXIT;

        CLEAR(PurchaseHeader);
        PurchaseHeader.INIT;
        PurchaseHeader.VALIDATE("Document Type", PurchaseHeader."Document Type"::Invoice);
        PurchaseHeader.INSERT(TRUE);
        IF Vendor.GET('V-001373') THEN
            PurchaseHeader.VALIDATE("Buy-from Vendor No.", Vendor."No.")
        ELSE
            EXIT;
        PurchaseHeader."Memo No." := _MemoHdr."No.";
        PurchaseHeader."Memo Type" := _MemoHdr."Document Type";
        PurchaseHeader.MODIFY(TRUE);

        _MemoHdr."PO Created No." := PurchaseHeader."No.";
        _MemoHdr.MODIFY;

        MemoLine.RESET;
        MemoLine.SETRANGE("Document Type", _MemoHdr."Document Type");
        MemoLine.SETRANGE("Document No.", _MemoHdr."No.");
        MemoLine.SETFILTER("Registration Fee", '<>%1', 0);
        IF MemoLine.FINDFIRST THEN;

        CLEAR(PurchaseLine);
        PurchaseLine.INIT;
        PurchaseLine.VALIDATE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.VALIDATE("Document No.", PurchaseHeader."No.");
        PurchaseLine."Line No." := 10000;
        PurchaseLine.VALIDATE(Type, PurchaseLine.Type::"Charge (Item)");
        IF ItemCharge.GET('REGISTRATION CHARGE') THEN BEGIN
            PurchaseLine.VALIDATE("No.", ItemCharge."No.");
            PurchaseLine.VALIDATE(Quantity, 1);
            PurchaseLine.VALIDATE("Direct Unit Cost", MemoLine."Registration Fee");
        END;
        PurchaseLine.INSERT(TRUE);

        MESSAGE('%1 %2 has been created.', PurchaseHeader."Document Type", PurchaseHeader."No.");
    end;

    local procedure "--ServiceBooking to ServiceOrder Changes"()
    begin
    end;

    [Scope('Internal')]
    procedure ConvertBookingtoOrder(ServiceHeader: Record "5900")
    var
        ServiceLine: Record "5902";
        ServiceItemLine: Record "5901";
        ServiceCommentLine: Record "5906";
        ModelVersion: Record "27";
    begin
        ServiceHeader.TESTFIELD("Service Item No.");
        ServiceHeader.TESTFIELD("Registration No.");
        ServiceHeader.TESTFIELD("Booking Date");
        ServiceHeader.TESTFIELD("Booking Time");
        ServiceHeader.TESTFIELD("Driver's Phone No.");
        ServiceHeader.TESTFIELD("Driver Name");
        ServiceHeader.TESTFIELD(Name);
        ModelVersion.GET("Model Version No.");
        IF ModelVersion."Margin Percentage" THEN
            ServiceHeader.TESTFIELD(Kilometrage);
        IF ModelVersion."MOQ (Dealer)" THEN
            ServiceHeader.TESTFIELD("Hour Reading");
        ServiceHeader.TESTFIELD("Vehicle Inward Date Time"); //will be updated once vehicle inward report is run for service orde
        ServiceHeader.TESTFIELD("Gate Entry Date");
        ServiceHeader.TESTFIELD("Gate Entry Time");
        ServiceHeader.TESTFIELD("Service Order Type");
        ServiceHeader.TESTFIELD("Failure Date");
        ServiceHeader.TESTFIELD("TA Handover Date Time");
        ServiceHeader.TESTFIELD("Customer No.");
        ServiceHeader.TESTFIELD("Technical Advisor");
        ServiceHeader.TESTFIELD("Mobile No. for SMS");
        ServiceHeader.TESTFIELD("Purpose of Visit");
        IF ServiceHeader."Salesperson Code" = '' THEN
            ERROR('Service Advisor must have a value.');
        //TA handover date time should be greater than vehicle Inward date time.
        IF ("TA Handover Date Time" < "Vehicle Inward Date Time") AND ("TA Handover Date Time" > CURRENTDATETIME) THEN
            ERROR('TA handover date time should be greater than Vehicle Inward Date time');

        CheckInventoryCheckList(ServiceHeader);  //to rethink this logic
        ServiceCommentLine.RESET;
        ServiceCommentLine.SETRANGE(Type, ServiceCommentLine.Type::General);
        ServiceCommentLine.SETRANGE("Table Subtype", ServiceCommentLine."Table Subtype"::"1");
        ServiceCommentLine.SETRANGE("No.", ServiceHeader."No.");
        ServiceCommentLine.SETRANGE(ServiceCommentLine."Table Name", ServiceCommentLine."Table Name"::"Service Header");
        IF NOT ServiceCommentLine.FINDFIRST THEN
            ERROR('Customer Voice does not exist');

        /*SMSDetails.RESET;
        SMSDetails.SETRANGE("Document No.","No.");
        SMSDetails.SETRANGE("Mobile Number","Mobile No. for SMS");
        IF NOT SMSDetails.FINDFIRST THEN
          ERROR('Booking must be done in order to create the Order');*/ //RL 7/9/19

        IF CONFIRM(Text001, FALSE) THEN BEGIN
            ServiceHeader.Status := ServiceHeader.Status::Pending;
            ServiceHeader."Order Date" := TODAY;
            ServiceHeader."Order Time" := TIME;
            ServiceHeader.MODIFY;
            ServiceItemLine.RESET;
            ServiceItemLine.SETRANGE("Document Type", ServiceHeader."Document Type");
            ServiceItemLine.SETRANGE("Document No.", ServiceHeader."No.");
            ServiceItemLine.SETRANGE("Service Item No.", "Service Item No.");
            IF ServiceItemLine.FINDFIRST THEN BEGIN
                ServiceItemLine."Starting Date" := TODAY;
                ServiceItemLine."Starting Time" := TIME;
                ServiceItemLine.MODIFY;
            END;
            MESSAGE('Service Booking %1 has been converted to Order.', ServiceHeader."No.");
        END;

    end;

    [Scope('Internal')]
    procedure CancelServiceBooking(ServiceHeader: Record "5900")
    var
        ServiceLine: Record "5902";
        ServiceItemLine: Record "5901";
        GatePassHdr: Record "50004";
        RepairStatusCode: Record "5927";
        FinishedErr: Label 'The Service Order: %1 has already been finished. Hence, it cannot be closed.';
    begin

        ServiceItemLine.SETRANGE("Document No.", ServiceHeader."No.");
        IF ServiceItemLine.FINDFIRST THEN
            REPEAT
                RepairStatusCode.GET(ServiceItemLine."Repair Status Code");
                IF RepairStatusCode.Finished THEN
                    ERROR(FinishedErr, ServiceHeader."No.");
            UNTIL ServiceItemLine.NEXT = 0;
        ServiceHeader.TESTFIELD("Cancellation Reason Code");
        ServiceHeader.TESTFIELD(Remarks);
        IF CONFIRM(Text002, FALSE) THEN BEGIN
            IF ServiceHeader.Status <> ServiceHeader.Status::"9" THEN BEGIN
                ServiceHeader.Status := ServiceHeader.Status::"9";
                //VALIDATE("Closed Without Service",TRUE);
                "Closed Without Service" := TRUE;
                ServiceHeader.MODIFY;
                GatePassHdr.RESET;
                GatePassHdr.INIT;
                GatePassHdr."Document No" := '';
                GatePassHdr."Document Type" := GatePassHdr."Document Type"::"Spare Parts Trade";
                GatePassHdr."Issued Date (BS)" := GatePassHdr."Issued Date (BS)"::"1";
                GatePassHdr.VALIDATE(Remarks, "Service Item No.");
                GatePassHdr.VALIDATE("Issued Date", GatePassHdr."Issued Date"::"0");
                GatePassHdr.Printed := Remarks;
                GatePassHdr."Old Ext Document Type" := TRUE;
                GatePassHdr."Responsibility Center" := TODAY;
                GatePassHdr.Type := TODAY;
                GatePassHdr."External Document Type" := USERID;
                GatePassHdr.Description := ServiceHeader."No.";
                GatePassHdr.Location := ServiceHeader."Location Code";
                GatePassHdr."No. Series" := ServiceHeader."Responsibility Center";
                GatePassHdr.Destination := GatePassHdr.Destination::"3";  //closed job = canceled job
                GatePassHdr."No. of Print" := TRUE;
                GatePassHdr."Vehicle Registration No." := "Driver Name";
                GatePassHdr.VALIDATE(Kilometer, ServiceHeader."Customer No.");
                GatePassHdr."Is Service Cancelled" := TRUE;
                GatePassHdr.INSERT(TRUE);
                COMMIT;

                MESSAGE('Service Booking %1 has been cancelled.', ServiceHeader."No.");
                GatePassHdr.RESET;
                GatePassHdr.SETCURRENTKEY(Description);
                GatePassHdr.SETRANGE(Description, ServiceHeader."No.");
                IF GatePassHdr.FINDFIRST THEN
                    REPORT.RUN(50046, TRUE, FALSE, GatePassHdr);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure CancelVehicleInward(ServiceHeader: Record "5900")
    var
        ServiceLine: Record "5902";
        ServiceItemLine: Record "5901";
        GatePassHdr: Record "50004";
    begin
        //TESTFIELD("Vehicle Inward Date Time",0DT);
        ServiceHeader.TESTFIELD("Cancellation Reason Code");
        ServiceHeader.TESTFIELD(Remarks);
        IF CONFIRM(Text002, FALSE) THEN BEGIN
            IF ServiceHeader.Status <> ServiceHeader.Status::"10" THEN BEGIN
                ServiceHeader.Status := ServiceHeader.Status::"10";
                ServiceHeader.MODIFY;
            END;
            GatePassHdr.RESET;
            GatePassHdr.SETRANGE("Document Type", ServiceHeader."Document Type");
            GatePassHdr.SETRANGE("Document No", ServiceHeader."No.");
            IF GatePassHdr.FINDFIRST THEN
                REPORT.RUN(50046, TRUE, FALSE, GatePassHdr);     //RL to print gatepass after cancellation
        END;
    end;

    [Scope('Internal')]
    procedure PerformVehicleInward(ServiceHeader: Record "5900")
    var
        ServiceLine: Record "5902";
        ServiceItemLine: Record "5901";
        ServHdr: Record "5900";
        ServiceItem: Record "5940";
        ModelVersion: Record "27";
        VehicleInward: Report "50078";
    begin
        ServiceHeader.TESTFIELD("Confirmation Status", "Confirmation Status"::"1"); //SRT August 25th 2019
                                                                                    //CheckInventoryCheckList(ServiceHeader); not needed re ahile
        ServiceHeader.TESTFIELD("Mobile No. for SMS");
        ModelVersion.GET("Model Version No.");
        IF ModelVersion."Margin Percentage" THEN
            ServiceHeader.TESTFIELD(Kilometrage);
        IF ModelVersion."MOQ (Dealer)" THEN
            ServiceHeader.TESTFIELD("Hour Reading");
        ServiceHeader.TESTFIELD("Driver Name");
        ServiceHeader.TESTFIELD("Driver's Phone No.");
        ServiceHeader.TESTFIELD("Gate Entry Date");
        ServiceHeader.TESTFIELD("Gate Entry Time");
        /*ServHdr.RESET;
        ServHdr.SETRANGE("Document Type","Document Type");
        ServHdr.SETRANGE("No.","No.");
        IF ServHdr.FINDFIRST THEN
          REPORT.RUN(50101,TRUE,FALSE,ServHdr);*/
        //>>ratan 8/30
        ServiceItem.RESET;
        ServiceItem.SETRANGE("No.", ServiceHeader."Service Item No.");
        IF ServiceItem.FINDFIRST THEN BEGIN
            CLEAR(VehicleInward);
            VehicleInward.SETTABLEVIEW(ServiceItem);
            VehicleInward.SetServiceDocumentNo(ServiceHeader."No.");
            VehicleInward.RUN;
            //REPORT.RUN(50078,TRUE,FALSE,ServiceItem);
        END;
        //<< ratan

    end;

    [Scope('Internal')]
    procedure CheckServicePostRestrictions(ServiceHeader: Record "5900")
    begin
        ServiceHeader.TESTFIELD("Next Service Date");
        ServiceHeader.TESTFIELD(Status, ServiceHeader.Status::Finished);
    end;

    [Scope('Internal')]
    procedure CreateFollowUpDetails(ServiceHeader: Record "5900")
    var
        Cust: Record "18";
        CustPhoneNo: Text[250];
        Vehicle: Record "5940";
        ServiceComment: Record "5906";
        ServFollowUpDetails: Record "50033";
        ServiceSetup: Record "5911";
    begin
        IF ServiceHeader."Document Type" = ServiceHeader."Document Type"::"Credit Memo" THEN
            EXIT;
        IF (ServiceHeader."Service Order Type" = 'PDI') OR (ServiceHeader."Service Order Type" = 'PDM') THEN   //ratan 11/5/19
            EXIT;
        ServiceSetup.GET;
        ServFollowUpDetails.RESET;
        ServFollowUpDetails.SETRANGE(ServiceHeader."No.", ServiceHeader."No.");
        IF NOT ServFollowUpDetails.FINDFIRST THEN BEGIN
            ServFollowUpDetails.INIT;
            ServFollowUpDetails.TRANSFERFIELDS(ServiceHeader);
            ServFollowUpDetails.Type := ServFollowUpDetails.Type::"0";
            IF "Next Service Date" = 0D THEN
                ServFollowUpDetails."Scheduled Date" := CALCDATE(ServiceSetup."Post Service Due Days", ServiceHeader."Posting Date")
            ELSE
                ServFollowUpDetails."Scheduled Date" := "Next Service Date";
            ServFollowUpDetails."Scheduled Time" := TIME + (ServiceSetup."Post Service Due Hrs" * 3600000);
            ServFollowUpDetails."Follow Up Type" := ServFollowUpDetails."Follow Up Type"::"1";
            ServFollowUpDetails."Call Status" := ServFollowUpDetails."Call Status"::"0";
            ServFollowUpDetails."Probable Follow Up Date" := CALCDATE(ServiceSetup."Post Service Due Days", ServiceHeader."Posting Date");
            IF Cust.GET(ServiceHeader."Bill-to Customer No.") THEN BEGIN
                CustPhoneNo := Cust."Citizenship Issued District";
                ServFollowUpDetails."Contact Phone No." := STRSUBSTNO(CustPhoneNo);
                ServFollowUpDetails."Contact Phone No." := ServiceHeader."Mobile No. for SMS";
            END;
            IF Vehicle.GET(ServiceHeader."Service Item No.") THEN
                ServFollowUpDetails."Driver's Phone No." := Vehicle."Operator/Driver's Phone No.";

            ServFollowUpDetails.INSERT;
        END ELSE BEGIN
            ServFollowUpDetails.TRANSFERFIELDS(ServiceHeader);
            ServFollowUpDetails.Type := ServFollowUpDetails.Type::"0";
            IF "Next Service Date" = 0D THEN
                ServFollowUpDetails."Scheduled Date" := CALCDATE(ServiceSetup."Post Service Due Days", ServiceHeader."Posting Date")
            ELSE
                ServFollowUpDetails."Scheduled Date" := "Next Service Date";
            ServFollowUpDetails."Scheduled Time" := TIME + (ServiceSetup."Post Service Due Hrs" * 3600000);
            ServFollowUpDetails."Follow Up Type" := ServFollowUpDetails."Follow Up Type"::"1";
            ServFollowUpDetails."Call Status" := ServFollowUpDetails."Call Status"::"0";
            IF Cust.GET(ServiceHeader."Bill-to Customer No.") THEN BEGIN
                CustPhoneNo := Cust."Citizenship Issued District";
                ServFollowUpDetails."Contact Phone No." := STRSUBSTNO(CustPhoneNo);
                ServFollowUpDetails."Contact Phone No." := ServiceHeader."Mobile No. for SMS";
            END;
            IF Vehicle.GET(ServiceHeader."Service Item No.") THEN
                ServFollowUpDetails."Driver's Phone No." := Vehicle."Operator/Driver's Phone No.";
            ServFollowUpDetails.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure MarkPerviousServiceupInvalide(ServiceHeader: Record "5900")
    var
        ServiceFollowup: Record "50033";
    begin
        ServiceFollowup.RESET;
        ServiceFollowup.SETRANGE("Service Item No.", ServiceHeader."Service Item No.");
        ServiceFollowup.SETRANGE("Follow Up Type", ServiceFollowup."Follow Up Type"::"2");
        ServiceFollowup.SETRANGE("Invalid Serivce Followup", FALSE);
        IF ServiceFollowup.FINDFIRST THEN
            REPEAT
                ServiceFollowup."Invalid Serivce Followup" := TRUE;
                ServiceFollowup.MODIFY;
            UNTIL ServiceFollowup.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure ServiceRemindr(ServiceHdr: Record "5900")
    var
        PostServHdr: Record "5900";
        FirstKM: Integer;
        LastKM: Integer;
        AvgKMperDay: Decimal;
        FirstPostingDate: Date;
        LastPostingDate: Date;
        ServRemindr: Record "50034";
        VehWarrantyUsg: Record "50037";
        AvgDays: Integer;
        Contact: Record "5050";
        Vehicle: Record "5940";
        ServRemindr1: Record "50034";
        ServiceCommLineEDMS: Record "5906";
        ServiceLine: Record "5902";
        JobsDone: Text;
    begin
        //IF (ServiceHdr."Service Order Type" = 'FREE SERVICE') OR (ServiceHdr."Service Order Type" = 'PAID SERVICES')THEN BEGIN
        IF ServiceHdr."Document Type" = ServiceHdr."Document Type"::"Credit Memo" THEN
            EXIT;
        PostServHdr.RESET;
        PostServHdr.SETCURRENTKEY("Posting Date");
        PostServHdr.SETRANGE("Service Item No.", ServiceHdr."Service Item No.");
        PostServHdr.SETRANGE(PostServHdr."Posted Service", TRUE);
        IF PostServHdr.FINDFIRST THEN BEGIN
            FirstKM := PostServHdr.Kilometrage;
            FirstPostingDate := PostServHdr."Posting Date";
        END;

        PostServHdr.RESET;
        PostServHdr.SETCURRENTKEY("Posting Date");
        PostServHdr.SETRANGE("Service Item No.", ServiceHdr."Service Item No.");
        PostServHdr.SETRANGE("Posted Service", TRUE);
        IF PostServHdr.FINDLAST THEN BEGIN
            LastKM := PostServHdr.Kilometrage;
            LastPostingDate := PostServHdr."Posting Date";
        END;

        Contact.GET(ServiceHdr."Bill-to Contact No.");
        Vehicle.GET(ServiceHdr."Service Item No.");

        /*VehWarrantyUsg.RESET;
        VehWarrantyUsg.SETRANGE("Make Code",ServiceHdr."Make Code");
        VehWarrantyUsg.SETRANGE("Model Code",ServiceHdr."Model Code");
        VehWarrantyUsg.SETRANGE("Model Version No.",ServiceHdr."Model Version No.");
        IF VehWarrantyUsg.FINDFIRST THEN;

        {IF VehWarrantyUsg."Service Frequency KM" = 0 THEN
          MESSAGE('Service Frequency KM is blank in Vehicle Warranty Usage Table!');
        IF VehWarrantyUsg."Service Frequency Days" = 0 THEN
          MESSAGE('Service Frequency Days is blank in Vehicle Warranty Usage Table!');}

        IF (VehWarrantyUsg."Service Frequency KM" >0) AND (VehWarrantyUsg."Service Frequency Days" > 0) THEN BEGIN
          IF LastPostingDate <> FirstPostingDate THEN BEGIN
            ServRemindr.RESET;
            ServRemindr.SETRANGE("Vehicle Serial No.",ServiceHdr."Service Item No.");
            IF ServRemindr.FINDFIRST THEN BEGIN
              ServRemindr."Average KM per day" := ROUND(((LastKM-FirstKM)/(LastPostingDate-FirstPostingDate)),0.01,'=');
              IF ServRemindr."Average KM per day" > 0 THEN
              AvgDays := ROUND((VehWarrantyUsg."Service Frequency KM"/ServRemindr."Average KM per day"),1,'=');

              ServRemindr."Probable Next Service Date" := ServiceHdr."Posting Date" + AvgDays;
              IF (ServiceHdr."Posting Date" + VehWarrantyUsg."Service Frequency Days") < ServRemindr."Probable Next Service Date" THEN
                ServRemindr."Probable Next Service Date" := ServiceHdr."Posting Date" + VehWarrantyUsg."Service Frequency Days";
              ServRemindr."Next Service KM" := ServiceHdr.Kilometrage + VehWarrantyUsg."Service Frequency KM";
              IF ServRemindr."Probable Next Service Date" = 0D THEN
                ServRemindr."Probable Next Service Date" := ServiceHdr."Next Service Date";
              ServRemindr."Last Visit Location" :=  ServiceHdr."Location Code";
              ServRemindr."Last Service Order No." := ServiceHdr."No.";
              ServRemindr."Mobile No. for SMS" := ServiceHdr."Mobile No. for SMS";
              ServRemindr."Contact Phone No." := Contact."Phone No.";
              ServRemindr."Driver Contact No." := ServiceHdr."Driver's Phone No.";
              ServRemindr."Customer No." := ServiceHdr."Bill-to Customer No.";
              ServRemindr."Cusotmer Name" := ServiceHdr."Bill-to Name";
              ServRemindr."Cusotmer Address" := ServiceHdr."Bill-to Address";
              ServRemindr."Contact No." := ServiceHdr."Bill-to Contact No.";
              ServRemindr.VIN := Vehicle."Serial No.";
              ServRemindr."Make Code" := Vehicle."Make Code";
              ServRemindr."Model Code" := Vehicle."Model Code";
              ServRemindr."Model Version No." := Vehicle."Item No.";
              ServRemindr."Vehicle Registartion No." := Vehicle."Registration No.";
              ServRemindr.Status := ServRemindr.Status::Open;  // dec 26, 2014
              //ZM Nov 23 2017 >>
              ServRemindr."Last Visited Date" := ServiceHdr."Posting Date";
              ServRemindr."Last Visit KM/Hour Meter" := ServiceHdr.Kilometrage;
              IF ServRemindr."Last Visit KM/Hour Meter" = 0 THEN
                ServRemindr."Last Visit KM/Hour Meter" := ServiceHdr."Hour Reading";
              //ZM Nov 23 2017 <<
              ServRemindr.MODIFY;
            END ELSE BEGIN

              ServRemindr1.INIT;
              ServRemindr1.VALIDATE("Vehicle Serial No.",ServiceHdr."Service Item No.");
              ServRemindr1."Probable Next Service Date" := ServiceHdr."Posting Date" + VehWarrantyUsg."Service Frequency Days";
              ServRemindr1."Next Service KM" := ServiceHdr.Kilometrage + VehWarrantyUsg."Service Frequency KM";
              ServRemindr1."Last Visit Location" := ServiceHdr."Location Code";
              ServRemindr1."Last Service Order No." := ServiceHdr."No.";
              IF (LastPostingDate-FirstPostingDate) <> 0 THEN
              ServRemindr1."Mobile No. for SMS" := ServiceHdr."Mobile No. for SMS";
              ServRemindr1."Contact Phone No." := Contact."Phone No.";
              ServRemindr1."Driver Contact No." := ServiceHdr."Driver's Phone No.";
              ServRemindr1."Customer No." := ServiceHdr."Bill-to Customer No.";
              ServRemindr1."Cusotmer Name" := ServiceHdr."Bill-to Name";
              ServRemindr."Cusotmer Address" := ServiceHdr."Bill-to Address";
              ServRemindr1."Contact No." := ServiceHdr."Bill-to Contact No.";
              //ZM Nov 23 2017 >>
              ServRemindr."Last Visited Date" := ServiceHdr."Posting Date";
              ServRemindr."Last Visit KM/Hour Meter" := ServiceHdr.Kilometrage;
              IF ServRemindr."Last Visit KM/Hour Meter" = 0 THEN
                ServRemindr."Last Visit KM/Hour Meter" := ServiceHdr."Hour Reading";
              //ZM Nov 23 2017 <<

              ServRemindr1.INSERT;

            END;
          END ELSE BEGIN
            ServRemindr.RESET;
            ServRemindr.SETRANGE("Vehicle Serial No.",ServiceHdr."Service Item No.");
            IF ServRemindr.FINDFIRST THEN BEGIN
              IF (ServiceHdr."Posting Date" + VehWarrantyUsg."Service Frequency Days") < ServRemindr."Probable Next Service Date" THEN
                ServRemindr."Probable Next Service Date" := ServiceHdr."Posting Date" + VehWarrantyUsg."Service Frequency Days";

              IF (LastPostingDate-FirstPostingDate) <> 0 THEN
              ServRemindr."Average KM per day" := ROUND(((LastKM-FirstKM)/(LastPostingDate-FirstPostingDate)),0.01,'=');

              IF ServRemindr."Average KM per day" > 0 THEN
              AvgDays := ROUND((VehWarrantyUsg."Service Frequency KM"/ServRemindr."Average KM per day"),1,'=');

              ServRemindr."Probable Next Service Date" := ServiceHdr."Posting Date" + AvgDays;

              ServRemindr."Next Service KM" := ServiceHdr.Kilometrage + VehWarrantyUsg."Service Frequency KM";
              ServRemindr."Last Visit Location" :=  ServiceHdr."Location Code";
              ServRemindr."Last Service Order No." := ServiceHdr."No.";
              ServRemindr."Mobile No. for SMS" := ServiceHdr."Mobile No. for SMS";
              ServRemindr."Contact Phone No." := Contact."Phone No.";
              ServRemindr."Driver Contact No." := ServiceHdr."Driver Name";
              ServRemindr."Customer No." := ServiceHdr."Bill-to Customer No.";
              ServRemindr."Cusotmer Name" := ServiceHdr."Bill-to Name";
              ServRemindr."Cusotmer Address" := ServiceHdr."Bill-to Address";
              ServRemindr."Contact No." := ServiceHdr."Bill-to Contact No.";
              ServRemindr.VIN := ServiceHdr."Service Item No.";
              ServRemindr."Make Code" := Vehicle."Make Code";
              ServRemindr."Model Code" := Vehicle."Model Code";
              ServRemindr."Model Version No." := Vehicle."Item No.";
              ServRemindr."Vehicle Registartion No." := Vehicle."Registration No.";
              ServRemindr.Status := ServRemindr.Status::Open;  // dec 26, 2014
              //ZM Nov 23 2017 >>
              ServRemindr."Last Visited Date" := ServiceHdr."Posting Date";
              ServRemindr."Last Visit KM/Hour Meter" := ServiceHdr.Kilometrage;
              IF ServRemindr."Last Visit KM/Hour Meter" = 0 THEN
                ServRemindr."Last Visit KM/Hour Meter" := ServiceHdr."Hour Reading";
              //ZM Nov 23 2017 <<

              ServRemindr.MODIFY;
            END ELSE BEGIN
            ServRemindr1.INIT;
            ServRemindr1.VALIDATE("Vehicle Serial No.",ServiceHdr."Service Item No.");
            ServRemindr1."Probable Next Service Date" := ServiceHdr."Posting Date" + VehWarrantyUsg."Service Frequency Days";
            ServRemindr1."Next Service KM" := ServiceHdr.Kilometrage + VehWarrantyUsg."Service Frequency KM";
            ServRemindr1."Last Visit Location" := ServiceHdr."Location Code";
            ServRemindr1."Last Service Order No." := ServiceHdr."No.";
            ServRemindr1."Mobile No. for SMS" := ServiceHdr."Mobile No. for SMS";
            ServRemindr1."Contact Phone No." := Contact."Phone No.";
            ServRemindr1."Driver Contact No." := ServiceHdr."Driver's Phone No.";
            ServRemindr1."Customer No." := ServiceHdr."Bill-to Customer No.";
            ServRemindr1."Cusotmer Name" := ServiceHdr."Bill-to Name";
            ServRemindr."Cusotmer Address" := ServiceHdr."Bill-to Address";
            ServRemindr1."Contact No." := ServiceHdr."Bill-to Contact No.";
            ServRemindr1.VIN := ServiceHdr."Service Item No.";
            ServRemindr1."Make Code" := Vehicle."Make Code";
            ServRemindr1."Model Code" := Vehicle."Model Code";
            ServRemindr1."Model Version No." := Vehicle."Item No.";
            ServRemindr1."Vehicle Registartion No." := Vehicle."Registration No.";
            //ZM Nov 23 2017 >>
            ServRemindr1."Last Visited Date" := ServiceHdr."Posting Date";
            ServRemindr1."Last Visit KM/Hour Meter" := ServiceHdr.Kilometrage;
            IF ServRemindr1."Last Visit KM/Hour Meter" = 0 THEN
              ServRemindr1."Last Visit KM/Hour Meter" := ServiceHdr."Hour Reading";
            //ZM Nov 23 2017 <<

            ServRemindr1.INSERT;
            END;
          END;
        END;
        */

        //ratan
        ServRemindr.RESET;
        ServRemindr.SETRANGE("Vehicle Serial No.", ServiceHdr."Service Item No.");
        IF ServRemindr.FINDFIRST THEN BEGIN
            IF (ServiceHdr."Posting Date" + VehWarrantyUsg."Service Frequency Days") < ServRemindr."Probable Next Service Date" THEN
                ServRemindr."Probable Next Service Date" := ServiceHdr."Posting Date" + VehWarrantyUsg."Service Frequency Days";

            IF (LastPostingDate - FirstPostingDate) <> 0 THEN
                ServRemindr."Average KM per day" := ROUND(((LastKM - FirstKM) / (LastPostingDate - FirstPostingDate)), 0.01, '=');

            IF ServRemindr."Average KM per day" > 0 THEN
                AvgDays := ROUND((VehWarrantyUsg."Service Frequency KM" / ServRemindr."Average KM per day"), 1, '=');

            //ServRemindr."Probable Next Service Date" := ServiceHdr."Posting Date" + AvgDays;  // original code commrnted by ratan
            ServRemindr."Probable Next Service Date" := ServiceHdr."Next Service Date";
            ServRemindr."Next Service KM" := ServiceHdr.Kilometrage + VehWarrantyUsg."Service Frequency KM";
            ServRemindr."Last Visit Location" := ServiceHdr."Location Code";
            ServRemindr."Last Service Order No." := ServiceHdr."No.";
            ServRemindr."Mobile No. for SMS" := ServiceHdr."Mobile No. for SMS";
            ServRemindr."Contact Phone No." := Contact."Phone No.";
            ServRemindr."Driver Contact No." := ServiceHdr."Driver Name";
            ServRemindr."Customer No." := ServiceHdr."Bill-to Customer No.";
            ServRemindr."Cusotmer Name" := ServiceHdr."Bill-to Name";
            ServRemindr."Cusotmer Address" := ServiceHdr."Bill-to Address";
            ServRemindr."Contact No." := ServiceHdr."Bill-to Contact No.";
            ServRemindr.VIN := ServiceHdr."Service Item No.";
            ServRemindr."Make Code" := Vehicle."Make Code";
            ServRemindr."Model Code" := Vehicle."Model Code";
            ServRemindr."Model Version No." := Vehicle."Item No.";
            ServRemindr."Vehicle Registartion No." := Vehicle."Registration No.";
            ServRemindr.Status := ServRemindr.Status::"0";  // dec 26, 2014
                                                            //ZM Nov 23 2017 >>
            ServRemindr."Last Visited Date" := ServiceHdr."Posting Date";
            ServRemindr."Last Visit KM/Hour Meter" := ServiceHdr.Kilometrage;
            IF ServRemindr."Last Visit KM/Hour Meter" = 0 THEN
                ServRemindr."Last Visit KM/Hour Meter" := ServiceHdr."Hour Reading";
            //ZM Nov 23 2017 <<

            ServRemindr.MODIFY;
        END ELSE BEGIN
            ServRemindr1.INIT;
            ServRemindr1.VALIDATE("Vehicle Serial No.", ServiceHdr."Service Item No.");
            //ServRemindr1."Probable Next Service Date" := ServiceHdr."Posting Date" + VehWarrantyUsg."Service Frequency Days";
            ServRemindr."Probable Next Service Date" := ServiceHdr."Next Service Date";
            ServRemindr1."Next Service KM" := ServiceHdr.Kilometrage + VehWarrantyUsg."Service Frequency KM";
            ServRemindr1."Last Visit Location" := ServiceHdr."Location Code";
            ServRemindr1."Last Service Order No." := ServiceHdr."No.";
            ServRemindr1."Mobile No. for SMS" := ServiceHdr."Mobile No. for SMS";
            ServRemindr1."Contact Phone No." := Contact."Phone No.";
            ServRemindr1."Driver Contact No." := ServiceHdr."Driver's Phone No.";
            ServRemindr1."Customer No." := ServiceHdr."Bill-to Customer No.";
            ServRemindr1."Cusotmer Name" := ServiceHdr."Bill-to Name";
            ServRemindr."Cusotmer Address" := ServiceHdr."Bill-to Address";
            ServRemindr1."Contact No." := ServiceHdr."Bill-to Contact No.";
            ServRemindr1.VIN := ServiceHdr."Service Item No.";
            ServRemindr1."Make Code" := Vehicle."Make Code";
            ServRemindr1."Model Code" := Vehicle."Model Code";
            ServRemindr1."Model Version No." := Vehicle."Item No.";
            ServRemindr1."Vehicle Registartion No." := Vehicle."Registration No.";
            //ZM Nov 23 2017 >>
            ServRemindr1."Last Visited Date" := ServiceHdr."Posting Date";
            ServRemindr1."Last Visit KM/Hour Meter" := ServiceHdr.Kilometrage;
            IF ServRemindr1."Last Visit KM/Hour Meter" = 0 THEN
                ServRemindr1."Last Visit KM/Hour Meter" := ServiceHdr."Hour Reading";
            //ZM Nov 23 2017 <<

            ServRemindr1.INSERT(TRUE);
            MESSAGE('inserted');
        END;



        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document No.", ServiceHdr."No.");
        ServiceLine.SETRANGE("Line Type", ServiceLine."Line Type"::"2");
        IF ServiceLine.FINDSET THEN
            REPEAT
                IF STRLEN(JobsDone) < 250 THEN
                    JobsDone += DELSTR(ServiceLine.Description, 1, 250);
            UNTIL ServiceLine.NEXT = 0;

    end;

    [Scope('Internal')]
    procedure CreateSatisfactionFeedBack(ServiceHeader: Record "5900")
    var
        ServiceFeedback: Record "50062";
        FeedbackQuestion: Record "50063";
        PostedServHeader: Record "5900";
        SalesInvoice: Record "5992";
        DocumentNo: Code[20];
    begin
        IF ServiceHeader."Document Type" = ServiceHeader."Document Type"::"Credit Memo" THEN
            EXIT;

        //ISF Question Type
        ServiceFeedback.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceFeedback.SETRANGE(ServiceFeedback."Question Type", ServiceFeedback."Question Type"::"1");
        IF NOT ServiceFeedback.FINDFIRST THEN BEGIN
            FeedbackQuestion.RESET;
            FeedbackQuestion.SETRANGE(Type, FeedbackQuestion.Type::"0");
            FeedbackQuestion.SETRANGE("Question Type", FeedbackQuestion."Question Type"::"1");
            IF FeedbackQuestion.FINDFIRST THEN BEGIN
                REPEAT
                    ServiceFeedback.INIT;
                    ServiceFeedback."Document No." := ServiceHeader."No.";
                    ServiceFeedback.Type := ServiceFeedback.Type::"0";
                    ServiceFeedback."Question Code" := FeedbackQuestion.Code;
                    ServiceFeedback."Question Type" := FeedbackQuestion."Question Type"::"1";
                    ServiceFeedback.Question := FeedbackQuestion.Question;
                    ServiceFeedback."Order No." := PostedServHeader."No.";
                    ServiceFeedback."Location Code" := PostedServHeader."Location Code";
                    ServiceFeedback."Invoice Posting Date" := PostedServHeader."Posting Date";
                    ServiceFeedback."Question No." := FeedbackQuestion."Question No.";
                    ServiceFeedback.INSERT;
                UNTIL FeedbackQuestion.NEXT = 0;
            END;
        END;

        //PSF Question Type
        ServiceFeedback.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceFeedback.SETRANGE(ServiceFeedback."Question Type", ServiceFeedback."Question Type"::"2");
        IF NOT ServiceFeedback.FINDFIRST THEN BEGIN
            FeedbackQuestion.RESET;
            FeedbackQuestion.SETRANGE(Type, FeedbackQuestion.Type::"0");
            FeedbackQuestion.SETRANGE("Question Type", FeedbackQuestion."Question Type"::"2");
            IF FeedbackQuestion.FINDFIRST THEN BEGIN
                REPEAT
                    ServiceFeedback.INIT;
                    ServiceFeedback."Document No." := ServiceHeader."No.";
                    ServiceFeedback.Type := ServiceFeedback.Type::"0";
                    ServiceFeedback."Question Code" := FeedbackQuestion.Code;
                    ServiceFeedback."Question Type" := FeedbackQuestion."Question Type"::"2";
                    ServiceFeedback.Question := FeedbackQuestion.Question;
                    ServiceFeedback."Order No." := PostedServHeader."No.";
                    ServiceFeedback."Location Code" := PostedServHeader."Location Code";
                    ServiceFeedback."Invoice Posting Date" := PostedServHeader."Posting Date";
                    ServiceFeedback."Question No." := FeedbackQuestion."Question No.";
                    ServiceFeedback.INSERT;
                UNTIL FeedbackQuestion.NEXT = 0;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateVehicleInformation(ServiceHeader: Record "5900")
    var
        ServiceItem: Record "5940";
    begin
        ServiceItem.GET("Service Item No.");
        ServiceItem."Operator/Driver's Name" := "Driver Name";
        ServiceItem."Operator/Driver's Phone No." := "Driver's Phone No.";
        ServiceItem.Kilometerage := Kilometrage;
        ServiceItem."Hour Reading" := "Hour Reading";
        ServiceItem."Last Service Date" := ServiceHeader."Posting Date";
        ServiceItem.MODIFY;
    end;

    [Scope('Internal')]
    procedure SendServiceBookingSMS(ServiceHeader: Record "5900")
    var
        SMSWebService: Codeunit "50014";
        MessageID: Text;
        SMSTemplate: Record "50008";
        Location: Record "14";
    begin
        IF NOT CONFIRM('Do you want to confirm?', FALSE) THEN
            EXIT;

        ServiceHeader.TESTFIELD("Mobile No. for SMS");
        //TESTFIELD("Bill-to Customer No.");
        ServiceHeader.TESTFIELD(Name);
        ServiceHeader.TESTFIELD("Booking Date");
        ServiceHeader.TESTFIELD("Booking Time");
        ServiceHeader.TESTFIELD("Booking Through");
        ServiceHeader.TESTFIELD("Registration No.");
        ServiceHeader.TESTFIELD("Purpose of Visit");
        // >> RL 7/9/19  mandatory The registration no. and customer voice
        IF "Confirmation Status" = "Confirmation Status"::"1" THEN BEGIN
            MESSAGE(MessageText001);
            EXIT;
        END;
        //<< RL
        "Confirmation Status" := "Confirmation Status"::"1";      //ratan
        ServiceHeader.MODIFY;
        /*SMSTemplate.RESET;   //code commented as now sms is not required
        SMSTemplate.SETRANGE("Document Profile",SMSTemplate."Document Profile"::Service);
        SMSTemplate.SETRANGE(Type,SMSTemplate.Type::"Service Booking");
        IF NOT SMSTemplate.FINDFIRST THEN
          ERROR('SMS Template for service booking must be set in SMS Template');

        Location.GET("Location Code");
        IF SMSWebService.SendSMS(FORMAT("Mobile No. for SMS"),
                                STRSUBSTNO(SMSTemplate."Message Text",Name,"Registration No.","Booking Date",Location.Name,"No.","Service Booking By"),MessageID,CREATEDATETIME(TODAY, TIME+10000)) THEN BEGIN

          InsertSMSDetails(FORMAT("Mobile No. for SMS"),
                           STRSUBSTNO(SMSTemplate."Message Text",Name,"Registration No.","Booking Date",Location.Name,"No.","Booked By"),"No.",MessageType::"Service Booking",SMSMessageStatus::Processed);
          "Confirmation Status" := "Confirmation Status"::Confirmed;      //ratan
            MODIFY;
        END ELSE BEGIN
          InsertSMSDetails(FORMAT("Mobile No. for SMS"),
                           STRSUBSTNO(SMSTemplate."Message Text",Name,"Registration No.","Booking Date",Location.Name,"No.","Booked By"),"No.",MessageType::"Service Booking",SMSMessageStatus::Failed);
        END;*/

    end;

    [Scope('Internal')]
    procedure SendVehicleInwardSMS(ServiceHeader: Record "5900")
    var
        SMSWebService: Codeunit "50014";
        MessageID: Text;
        SMSTemplate: Record "50008";
        Location: Record "14";
    begin
        /*IF NOT CONFIRM('Do you want to send vehicle inward SMS?',FALSE) THEN
  EXIT;*/
        ServiceHeader.TESTFIELD("Mobile No. for SMS");
        ServiceHeader.TESTFIELD("Bill-to Customer No.");
        ServiceHeader.TESTFIELD("Vehicle Inward Date Time");

        SMSTemplate.RESET;
        SMSTemplate.SETRANGE(CharA, SMSTemplate.CharA::"3");
        SMSTemplate.SETRANGE(CharB, SMSTemplate.CharB::"5");
        IF NOT SMSTemplate.FINDFIRST THEN
            ERROR('SMS Template for service booking must be set in SMS Template');

        Location.GET(ServiceHeader."Location Code");
        IF SMSWebService.SendSMS("Mobile No. for SMS",
                                STRSUBSTNO(SMSTemplate.Value, ServiceHeader."Bill-to Name", "Registration No.", Location.Name, "Booking Date"), MessageID, CREATEDATETIME(TODAY, TIME + 10000)) THEN BEGIN

            /* InsertSMSDetails("Mobile No. for SMS",
                              STRSUBSTNO(SMSTemplate."Message Text","Bill-to Name","No.","Order Date","Order Time",Location.Name),"No.",MessageType::"Vehicle Inward",SMSMessageStatus::Processed);
         *///original text format ratan
            InsertSMSDetails("Mobile No. for SMS",
                             STRSUBSTNO(SMSTemplate.Value, ServiceHeader."Bill-to Name", ServiceHeader."No.", Location.Name, "Vehicle Inward Date Time"), ServiceHeader."No.", MessageType::"Vehicle Inward", SMSMessageStatus::Processed);
        END ELSE
            InsertSMSDetails("Mobile No. for SMS",
                             STRSUBSTNO(SMSTemplate.Value, ServiceHeader."Bill-to Name", ServiceHeader."No.", ServiceHeader."Order Date", ServiceHeader."Order Time", Location.Name), ServiceHeader."No.", MessageType::"Vehicle Inward", SMSMessageStatus::Failed);

    end;

    [Scope('Internal')]
    procedure CreateTransferOrderFromServiceLines_UnderConstruction_SRT(_ServiceLine: Record "5902")
    var
        ServiceLine: Record "5902";
        QtyBase: Decimal;
        TransferHeaderCreated: Boolean;
        TransferOrderNo: Code[20];
        TypeOfTransferText: Label 'Inbound,Outbound,Cancel';
        FromLocation: Code[10];
        ToLocation: Code[10];
        TypeOfTransfer: Integer;
        LastTransferLineNo: Integer;
        UserSetUp: Record "91";
        TransferOrder: Record "5740";
        ServiceSetup: Record "5911";
        TransferLine: Record "5741";
        LineNo: Integer;
    begin
        _ServiceLine.TESTFIELD("Requisition Quantity");  //SRT
        _ServiceLine.TESTFIELD("Requisition Description");
        _ServiceLine.TESTFIELD("Work Type Code");
        TypeOfTransfer := STRMENU(TypeOfTransferText, 3);

        IF TypeOfTransfer = 3 THEN
            EXIT;

        IF TypeOfTransfer = 1 THEN BEGIN
            UserSetUp.GET(USERID);
            IF NOT TransferHeaderCreated THEN BEGIN
                TransferOrderNo := CreateTransferHeader(_ServiceLine."Document No.", GetStoreLocation(UserSetUp."User Department"),
                                    UserSetUp."User Department");
                TransferHeaderCreated := TRUE;
                MESSAGE(TransferOrderCreated, TransferOrderNo, _ServiceLine."Document No.");
            END;

            //SRT May 14th 2019 >>
            IF TransferHeaderCreated THEN BEGIN
                TransferOrder.RESET;
                TransferOrder.SETRANGE("No.", TransferOrderNo);
                IF TransferOrder.FINDFIRST THEN BEGIN
                    TransferLine.RESET;
                    TransferLine.SETRANGE(TransferLine."Document No.", TransferOrder."No.");
                    IF TransferLine.FINDLAST THEN
                        LineNo := TransferLine."Line No." + 1000
                    ELSE
                        LineNo := 1000;

                    LineNo := CreateTransferLine(TransferOrder."No.", LineNo,
                                            _ServiceLine."Requisition Quantity", TypeOfTransfer, _ServiceLine);
                END;
            END;
            //SRT May 14th 2019 <<
        END;
        ServiceSetup.GET;
        IF TypeOfTransfer = 2 THEN BEGIN
            ServiceLine.RESET;
            ServiceLine.SETRANGE("Document Type", _ServiceLine."Document Type");
            ServiceLine.SETRANGE("Document No.", _ServiceLine."Document No.");
            ServiceLine.SETRANGE(Type, _ServiceLine.Type::Item);
            ServiceLine.SETRANGE("No.", _ServiceLine."No.");
            ServiceLine.SETAUTOCALCFIELDS("Reserved Quantity");
            //IME.RD
            ServiceLine.SETAUTOCALCFIELDS("Received Quantity");
            //IME.RD
            IF ServiceLine.FINDSET THEN
                REPEAT
                    //  IF TypeOfTransfer = 1 THEN BEGIN
                    //    QtyBase := ServiceLine.Quantity - ServiceLine."Reserved Quantity";
                    //    FromLocation := GetStoreLocation(ServiceLine."Location Code");
                    //    ToLocation := ServiceLine."Location Code";
                    //  END
                    //  ELSE
                    // IF TypeOfTransfer = 2 THEN BEGIN
                    //QtyBase := ServiceLine.Quantity - ServiceLine."Reserved Quantity";
                    //IME.RD
                    IF ServiceSetup."Enable Reservation Module" THEN
                        QtyBase := ServiceLine."Qty. to Return" //ServiceLine."Received Quantity" - ServiceLine.Quantity; //Agile_SM 20 Sep 2017 Reservation Mgt
                    ELSE
                        QtyBase := ServiceLine."Received Quantity" - ServiceLine.Quantity;
                    //IME
                    QtyBase := ServiceLine."Requisition Quantity";  //to remove later
                    FromLocation := ServiceLine."Location Code";
                    ToLocation := GetStoreLocation(ServiceLine."Location Code");
                    // END;
                    IF (QtyBase > 0) AND (NOT TransferDocumentExists(ServiceLine."Document No.", ServiceLine."Line No.", ServiceLine."No.", QtyBase, FromLocation, ToLocation)) THEN BEGIN
                        IF NOT TransferHeaderCreated THEN BEGIN
                            TransferOrderNo := CreateTransferHeader(ServiceLine."Document No.", FromLocation, ToLocation);
                            TransferHeaderCreated := TRUE;
                            //Agile RD 06032017
                            TransferOrder.RESET; //SRT May 14th 2019
                            TransferOrder.SETRANGE(TransferOrder."No.", TransferOrderNo);
                            IF TransferOrder.FINDFIRST THEN BEGIN
                                TransferOrder."Service Requisition Sent" := TRUE;
                                TransferOrder.MODIFY;
                            END;
                            //Agile RD 06032017
                        END;
                        LastTransferLineNo := CreateTransferLine(TransferOrderNo, LastTransferLineNo,
                                                QtyBase, TypeOfTransfer, ServiceLine);
                        LastTransferLineNo += 10000;
                    END;
                UNTIL ServiceLine.NEXT = 0;

            IF LastTransferLineNo > 0 THEN
                MESSAGE(TransferOrderCreated, TransferOrderNo, ServiceLine."Document No.");
        END;
    end;

    [Scope('Internal')]
    procedure CreateTransferOrderFromServiceHeaderLines(ServiceHeader: Record "5900")
    var
        _ServiceLine: Record "5902";
        ServiceLine: Record "5902";
        QtyBase: Decimal;
        TransferHeaderCreated: Boolean;
        TransferOrderNo: Code[20];
        FromLocation: Code[10];
        ToLocation: Code[10];
        TypeOfTransfer: Integer;
        LastTransferLineNo: Integer;
        UserSetUp: Record "91";
        TransferOrder: Record "5740";
        ServiceSetup: Record "5911";
        TransferLine: Record "5741";
        LineNo: Integer;
        TypeOfTransferText: Label 'Inbound,Outbound,Cancel';
    begin
        TypeOfTransfer := STRMENU(TypeOfTransferText, 3);
        IF TypeOfTransfer = 3 THEN
            EXIT;
        IF TypeOfTransfer = 1 THEN BEGIN
            ServiceLine.RESET;
            ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
            ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
            ServiceLine.SETRANGE("Line Type", ServiceLine."Line Type"::"1");
            IF NOT ServiceLine.FINDFIRST THEN
                ERROR('Service Line does not exist fo Service Order No. %1', ServiceHeader."No.");

            UserSetUp.GET(USERID);
            IF NOT TransferHeaderCreated THEN BEGIN
                TransferOrderNo := CreateTransferHeader(ServiceHeader."No.", GetStoreLocation(UserSetUp."User Department"),
                                    UserSetUp."User Department");
                TransferHeaderCreated := TRUE;
                MESSAGE(TransferOrderCreated, TransferOrderNo, ServiceHeader."No.");
            END;

            //SRT May 14th 2019 >>
            IF TransferHeaderCreated THEN BEGIN
                TransferOrder.RESET;
                TransferOrder.SETRANGE("No.", TransferOrderNo);
                IF TransferOrder.FINDFIRST THEN BEGIN
                    ServiceLine.RESET;
                    ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
                    ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
                    ServiceLine.SETRANGE("Line Type", ServiceLine.Type::Item); //pram 8 23 2019
                    ServiceLine.SETFILTER("Transfer Order No.", '%1', '');
                    IF ServiceLine.FINDFIRST THEN
                        REPEAT
                            TransferLine.RESET;
                            TransferLine.SETRANGE(TransferLine."Document No.", TransferOrder."No.");
                            IF TransferLine.FINDLAST THEN
                                LineNo := TransferLine."Line No." + 1000
                            ELSE
                                LineNo := 1000;

                            LineNo := CreateTransferLine(TransferOrder."No.", LineNo,
                                                    ServiceLine."Requisition Quantity", TypeOfTransfer, ServiceLine);
                            ServiceLine."Transfer Order No." := TransferOrder."No.";
                            ServiceLine."Transfer Order Line No." := LineNo;
                            ServiceLine.MODIFY;
                        UNTIL ServiceLine.NEXT = 0;
                END;
            END;
            //SRT May 14th 2019 <<
        END;
        ServiceSetup.GET;
        IF TypeOfTransfer = 2 THEN BEGIN
            ServiceLine.RESET;
            /*ServiceLine.SETRANGE("Document Type",_ServiceLine."Document Type");
            ServiceLine.SETRANGE("Document No.",_ServiceLine."Document No.");
            ServiceLine.SETRANGE(Type,_ServiceLine.Type::Item);
            ServiceLine.SETRANGE("No.",_ServiceLine."No.");*/
            //SRT Sept 1st 2019 >>
            ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
            ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
            ServiceLine.SETRANGE(ServiceLine.Type, ServiceLine."Line Type"::"1");
            ServiceLine.SETFILTER("Qty. to Return", '<>0');
            //SRT Sept 1st 2019 <<
            ServiceLine.SETAUTOCALCFIELDS("Reserved Quantity");
            //IME.RD
            ServiceLine.SETAUTOCALCFIELDS("Received Quantity");
            //IME.RD
            IF ServiceLine.FINDSET THEN
                REPEAT
                    //  IF TypeOfTransfer = 1 THEN BEGIN
                    //    QtyBase := ServiceLine.Quantity - ServiceLine."Reserved Quantity";
                    //    FromLocation := GetStoreLocation(ServiceLine."Location Code");
                    //    ToLocation := ServiceLine."Location Code";
                    //  END
                    //  ELSE
                    // IF TypeOfTransfer = 2 THEN BEGIN
                    //QtyBase := ServiceLine.Quantity - ServiceLine."Reserved Quantity";
                    //IME.RD
                    IF ServiceSetup."Enable Reservation Module" THEN
                        QtyBase := ServiceLine."Qty. to Return" //ServiceLine."Received Quantity" - ServiceLine.Quantity; //Agile_SM 20 Sep 2017 Reservation Mgt
                    ELSE
                        QtyBase := ServiceLine."Received Quantity" - ServiceLine.Quantity;
                    //IME
                    //QtyBase := ServiceLine."Requisition Quantity";  //to remove later
                    FromLocation := ServiceLine."Location Code";
                    ToLocation := GetStoreLocation(ServiceLine."Location Code");
                    // END;
                    IF (QtyBase > 0) AND (NOT TransferDocumentExists(ServiceLine."Document No.", ServiceLine."Line No.", ServiceLine."No.", QtyBase, FromLocation, ToLocation)) THEN BEGIN
                        IF NOT TransferHeaderCreated THEN BEGIN
                            TransferOrderNo := CreateTransferHeader(ServiceLine."Document No.", FromLocation, ToLocation);
                            TransferHeaderCreated := TRUE;

                            //Agile RD 06032017
                            TransferOrder.RESET; //SRT May 14th 2019
                            TransferOrder.SETRANGE(TransferOrder."No.", TransferOrderNo);
                            IF TransferOrder.FINDFIRST THEN BEGIN
                                TransferOrder."Service Requisition Sent" := TRUE;
                                TransferOrder."Is Serv. Outbound Document" := TRUE; //SRT Sept 2nd 2019
                                TransferOrder.MODIFY;
                            END;
                            //Agile RD 06032017
                        END;
                        LastTransferLineNo := CreateTransferLine(TransferOrderNo, LastTransferLineNo,
                                                QtyBase, TypeOfTransfer, ServiceLine);
                        LastTransferLineNo += 10000;
                    END;
                UNTIL ServiceLine.NEXT = 0;

            IF LastTransferLineNo > 0 THEN
                MESSAGE(TransferOrderCreated, TransferOrderNo, ServiceLine."Document No.");
        END;

    end;

    [Scope('Internal')]
    procedure CreateServiceBookingFromServiceReminder(ServiceReminder: Record "50034")
    var
        ServiceHeader: Record "5900";
        ServiceLine: Record "5902";
        ServiceItemLine: Record "5901";
    begin
        IF NOT CONFIRM('Do you want to create service booking for vehicle %1?', FALSE, VIN) THEN
            EXIT;
        ServiceHeader.RESET;
        ServiceHeader.INIT;
        ServiceHeader."No." := '';
        ServiceHeader.VALIDATE("Document Type", ServiceHeader."Document Type"::Order);
        ServiceHeader."Is Booked" := TRUE;
        ServiceHeader.VALIDATE(Status, ServiceHeader.Status::"8");
        ServiceHeader.INSERT(TRUE);

        ServiceHeader.VALIDATE(ServiceHeader."Service Item No.", VIN);
        ServiceHeader."Booking Date" := TODAY;
        ServiceHeader."Booking Time" := TIME;
        ServiceHeader."Booked By" := USERID;
        ServiceHeader."Booking Through" := ServiceHeader."Booking Through"::"4";
        ServiceHeader.MODIFY;

        IF NOT CONFIRM('Service booking for vehicle %1 has been created successfully.\Do you want to open the document?', FALSE, "Vehicle Registartion No.") THEN
            EXIT;
        PAGE.RUN(50090, ServiceHeader);
    end;

    local procedure InsertSMSDetails(MobileNumber: Text[20]; MessageText: Text; DocumentNo: Code[20]; MessageType: Option " ","Service Estimation","Service Invoice","Service Reminder","Service Booking","Vehicle Inward"; Status: Option New,Processed,Failed)
    var
        EntryNo: Integer;
        SMSDetail: Record "50007";
    begin
        EntryNo := 0;
        SMSDetail.RESET;
        IF SMSDetail.FINDLAST THEN
            EntryNo := SMSDetail."Customer No." + 1
        ELSE
            EntryNo := 1;

        SMSDetail.INIT;
        SMSDetail."Customer No." := EntryNo;
        SMSDetail."Responsibility Center" := MobileNumber;
        SMSDetail."Credit Limit (LCY)" := CURRENTDATETIME;
        SMSDetail."Created By" := MessageType;
        SMSDetail."Last Modified By" := MessageText;
        SMSDetail."Created Date" := Status;
        SMSDetail.Reason := DocumentNo;
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
    procedure ReturnableGatePassFromExternalServicePO(PurchHdr: Record "38")
    var
        GatePass2: Record "50004";
        ServiceHeader: Record "5900";
        ServiceLine: Record "5902";
        UserSetup: Record "91";
    begin
        IF "Service Order No" = '' THEN
            EXIT;

        ServiceHeader.RESET;
        ServiceHeader.SETRANGE(ServiceHeader."Document Type", ServiceHeader."Document Type"::Order);
        ServiceHeader.SETRANGE("No.", "Service Order No");
        ServiceHeader.FINDFIRST;

        GatePass2.RESET;
        GatePass2.SETRANGE(GatePass2."Document Type", GatePass2."Document Type"::"Spare Parts Trade");
        GatePass2.SETRANGE(GatePass2.Description, PurchHdr."No.");
        GatePass2.SETRANGE(GatePass2."Issued Date (BS)", GatePass2."Issued Date (BS)"::"1");
        GatePass2.SETRANGE(GatePass2.Destination, GatePass2.Destination::"2");
        IF GatePass2.ISEMPTY THEN BEGIN
            GatePass2.INIT;
            GatePass2."Document Type" := GatePass2."Document Type"::"Spare Parts Trade";
            GatePass2.Location := UserSetup."User Department";
            GatePass2.Description := PurchHdr."No.";
            GatePass2.VALIDATE(Remarks, ServiceHeader."Service Item No.");
            GatePass2."Issued Date (BS)" := GatePass2."Issued Date (BS)"::"1";
            GatePass2.Destination := GatePass2.Destination::"2";
            GatePass2."Vehicle Registration No." := ServiceHeader."Driver Name";
            GatePass2."Issued Date" := GatePass2."Issued Date"::"1";
            GatePass2."No. of Print" := TRUE;
            GatePass2.INSERT(TRUE);
            DocNo := GatePass2."Document No";
            COMMIT;
        END ELSE BEGIN
            IF GatePass2.FINDFIRST THEN BEGIN
                DocNo := GatePass2."Document No";
                IF GatePass2.Remarks = '' THEN BEGIN
                    GatePass2.VALIDATE(Remarks, ServiceHeader."Service Item No.");
                    GatePass2."Vehicle Registration No." := ServiceHeader."Driver Name";
                    GatePass2.MODIFY;
                    COMMIT;
                END;
            END;
        END;
        GatePass2.GET(DocNo);
        REPORT.RUN(50075, TRUE, FALSE, GatePass2);
    end;

    [Scope('Internal')]
    procedure CheckROTExistForUniqueJob(ServiceHeader: Record "5900")
    var
        ServiceLine: Record "5902";
        ServiceLine1: Record "5902";
        CurrentJob: Code[10];
        PreviousJob: Code[10];
    begin
        ServiceLine.RESET;
        //ServiceLine.SETCURRENTKEY(ServiceLine."Line Type",ServiceLine."No.",ServiceLine."Work Type Code");
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETRANGE("Service Item No.", "Service Item No.");
        ServiceLine.SETFILTER("Line No.", '<>%1', 0);
        IF ServiceLine.FINDFIRST THEN
            REPEAT
                CurrentJob := ServiceLine."Work Type Code";
                IF CurrentJob <> PreviousJob THEN BEGIN
                    ServiceLine1.RESET;
                    ServiceLine1.SETRANGE("Document Type", ServiceHeader."Document Type");
                    ServiceLine1.SETRANGE("Document No.", ServiceHeader."No.");
                    ServiceLine1.SETRANGE("Work Type Code", CurrentJob);
                    ServiceLine1.SETRANGE("Line Type", ServiceLine1."Line Type"::"2");
                    IF NOT ServiceLine1.FINDFIRST THEN
                        ERROR('ROT does not exist for work type %1', CurrentJob);
                END;
                PreviousJob := CurrentJob;
            UNTIL ServiceLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure SendCustomerConsentedSMS(ServiceHeader: Record "5900")
    var
        ServiceLine: Record "5902";
        SMSTemplate: Record "50008";
        CostEstimation: Decimal;
        TimeEstimation: Duration;
        SMSWebService: Codeunit "50014";
        MessageID: Text;
        Location: Record "14";
        MessageText: Text;
    begin
        ServiceHeader.TESTFIELD("Customer Consent Taken");
        ServiceHeader.TESTFIELD("Consent Taken DateTime");

        ServiceLine.RESET;
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETRANGE("Service Item No.", "Service Item No.");
        IF ServiceLine.FINDSET THEN BEGIN
            ServiceLine.CALCSUMS(ServiceLine."Amount Including VAT");
            ServiceLine.CALCSUMS(ServiceLine."Standard Time (Hours)");
            CostEstimation := ServiceLine."Amount Including VAT";
            EVALUATE(TimeEstimation, FORMAT(ServiceLine."Standard Time (Hours)"));
        END;

        SMSTemplate.RESET;
        SMSTemplate.SETRANGE(CharA, SMSTemplate.CharA::"3");
        SMSTemplate.SETRANGE(CharB, SMSTemplate.CharB::"13");
        IF NOT SMSTemplate.FINDFIRST THEN
            ERROR('SMS Template for service vehicle inward must be set in SMS Template');

        Location.GET(ServiceHeader."Location Code");
        /*  IF SMSWebService.SendSMS(FORMAT("Mobile No. for SMS"),
                                  STRSUBSTNO(SMSTemplate."Message Text","Bill-to Name","Registration No.","Booking Date",Location.Name,CostEstimation,TimeEstimation),MessageID,CREATEDATETIME(TODAY, TIME+10000)) THEN BEGIN
         //original code commented ratan>>
          IF SMSWebService.SendSMS(FORMAT("Mobile No. for SMS"),
                                  STRSUBSTNO(SMSTemplate."Message Text","Bill-to Name","Registration No.","Booking Date",Location.Name,CostEstimation),MessageID,CREATEDATETIME(TODAY, TIME+10000)) THEN BEGIN


            InsertSMSDetails(FORMAT("Mobile No. for SMS"),
                             STRSUBSTNO(SMSTemplate."Message Text","Bill-to Name","Registration No.","Booking Date",Location.Name,CostEstimation,TimeEstimation),"No.",MessageType::"Customer Consent",SMSMessageStatus::Processed);
          END ELSE BEGIN
            InsertSMSDetails(FORMAT("Mobile No. for SMS"),
                             STRSUBSTNO(SMSTemplate."Message Text","Bill-to Name","Registration No.","Booking Date",Location.Name,CostEstimation,TimeEstimation),"No.",MessageType::"Customer Consent",SMSMessageStatus::Failed)
          END;*/

        //ratan testing>>

        SMSWebService.SendSMS(FORMAT("Mobile No. for SMS"),
                                STRSUBSTNO(SMSTemplate.Value, ServiceHeader."Bill-to Name", "Registration No.", "Booking Date", Location.Name, CostEstimation), MessageID, CREATEDATETIME(TODAY, TIME + 10000));


        InsertSMSDetails(FORMAT("Mobile No. for SMS"),
                           STRSUBSTNO(SMSTemplate.Value, ServiceHeader."Bill-to Name", "Registration No.", "Booking Date", Location.Name, CostEstimation, TimeEstimation), ServiceHeader."No.", MessageType::"Customer Consent", SMSMessageStatus::Processed);
        /*END ELSE BEGIN
          InsertSMSDetails(FORMAT("Mobile No. for SMS"),
                           STRSUBSTNO(SMSTemplate."Message Text","Bill-to Name","Registration No.","Booking Date",Location.Name,CostEstimation,TimeEstimation),"No.",MessageType::"Customer Consent",SMSMessageStatus::Failed)
        END;*/
        //<<testing

    end;

    [Scope('Internal')]
    procedure InventoryCheckList(ServiceHeader: Record "5900")
    var
        ServiceItemLine: Record "5901";
    begin
        //SRT August 26th 2019
        ServiceItemLine.RESET;
        ServiceItemLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceItemLine.SETRANGE(ServiceItemLine."Document No.", ServiceHeader."No.");
        IF NOT ServiceItemLine.FINDFIRST THEN BEGIN
            ServiceItemLine.INIT;
            ServiceItemLine."Document Type" := ServiceHeader."Document Type";
            ServiceItemLine."Document No." := ServiceHeader."No.";
            ServiceItemLine.VALIDATE("Service Item No.", "Service Item No.");
            ServiceItemLine.INSERT(TRUE);
            ServiceItemLine.ShowComments(3);
        END ELSE BEGIN
            ServiceItemLine.ShowComments(3);
        END;
    end;

    [Scope('Internal')]
    procedure CheckInventoryCheckList(ServiceHeader: Record "5900")
    var
        ServCommentLine: Record "5906";
        ServiceItemLine: Record "5901";
    begin
        ServiceItemLine.RESET;
        ServiceItemLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceItemLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceItemLine.SETRANGE("Service Item No.", "Service Item No.");
        IF ServiceItemLine.FINDFIRST THEN BEGIN
            ServCommentLine.RESET;
            ServCommentLine.SETRANGE("Table Name", ServCommentLine."Table Name"::"Service Header");
            ServCommentLine.SETRANGE("Table Subtype", ServiceHeader."Document Type");
            ServCommentLine.SETRANGE("No.", ServiceHeader."No.");
            ServCommentLine.SETRANGE(Type, ServCommentLine.Type::Accessory);
            ServCommentLine.SETRANGE("Table Line No.", ServiceItemLine."Line No.");
            IF NOT ServCommentLine.FINDFIRST THEN
                ERROR('Inventory Check List does not exist for service document %1', ServiceHeader."No.");
        END;
    end;

    [Scope('Internal')]
    procedure CreateServiceLineFromTransferLineForOldJobCard(TransferHeader: Record "5740")
    var
        TransferLine: Record "5741";
        ServiceLine: Record "5902";
        ServiceHeader: Record "5900";
        LineNo: Integer;
        ServiceLineCreated: Boolean;
        ServiceSetup: Record "5911";
    begin
        //this function to be used for the old job card whose service lines has not been created from its corresponding transfer order document
        ServiceSetup.GET;
        IF ServiceSetup."IMEA Service Setup" THEN
            EXIT;
        IF "Service Order No." = '' THEN
            EXIT;

        ServiceHeader.GET(ServiceHeader."Document Type"::Order, TransferHeader."Service Order No.");
        ServiceLineCreated := FALSE;
        TransferLine.RESET;
        TransferLine.SETRANGE(TransferLine."Document No.", TransferHeader."No.");
        TransferLine.SETFILTER("Item No.", '<>%1', '');
        IF TransferLine.FINDFIRST THEN
            REPEAT
                ServiceLine.RESET;
                ServiceLine.SETRANGE(ServiceLine."Document No.", TransferHeader."Service Order No.");
                IF ServiceLine.FINDLAST THEN
                    LineNo := ServiceLine."Line No." + 1000
                ELSE
                    LineNo := 1000;

                ServiceLine.RESET;
                ServiceLine.SETCURRENTKEY("Transfer Order No.", "Transfer Order Line No.");
                ServiceLine.SETRANGE(ServiceLine."Transfer Order No.", TransferLine."Document No.");
                ServiceLine.SETRANGE(ServiceLine."Transfer Order Line No.", TransferLine."Line No.");
                IF NOT ServiceLine.FINDFIRST THEN BEGIN
                    ServiceLine.INIT;
                    ServiceLine."Document Type" := ServiceHeader."Document Type";
                    ServiceLine."Document No." := ServiceHeader."No.";
                    ServiceLine."Line No." := LineNo;
                    ServiceLine.INSERT(TRUE);
                    ServiceLine.VALIDATE(ServiceLine."Line Type", ServiceLine."Line Type"::"1");
                    ServiceLine.VALIDATE(ServiceLine."No.", TransferLine."Item No.");
                    IF TransferLine."Quantity Shipped" <> 0 THEN
                        ServiceLine.VALIDATE(ServiceLine.Quantity, TransferLine."Quantity Shipped")
                    ELSE
                        ServiceLine.VALIDATE(ServiceLine.Quantity, TransferLine."Qty. to Ship");
                    ServiceLine."Requisition Quantity" := ServiceLine.Quantity;
                    ServiceLine."Requisition Description" := 'Old job card Req. Line';
                    ServiceLine."Transfer Order No." := TransferLine."Document No.";
                    ServiceLine."Transfer Order Line No." := TransferLine."Line No.";
                    ServiceLine.MODIFY;
                    ServiceLineCreated := TRUE;
                    TransferLine."Service Order No." := ServiceLine."Document No.";
                    TransferLine."Service Order Line No" := ServiceLine."Line No.";
                    TransferLine.MODIFY;
                END ELSE BEGIN
                    ServiceLine.VALIDATE(ServiceLine.Quantity, TransferLine."Qty. to Ship");
                    ServiceLine."Requisition Quantity" := ServiceLine.Quantity;
                    ServiceLine."Requisition Description" := 'Old job card Req. Line';
                    ServiceLine."Transfer Order No." := TransferLine."Document No.";
                    ServiceLine."Transfer Order Line No." := TransferLine."Line No.";
                    ServiceLine.MODIFY;
                END;
            UNTIL TransferLine.NEXT = 0;
        IF ServiceLineCreated THEN
            MESSAGE('Service line has been created for transfer order no. %1 to its service order no. %2', TransferHeader."No.", ServiceHeader."No.");
    end;

    [Scope('Internal')]
    procedure ISWarrentyJobs(ServiceHeader: Record "5900"): Boolean
    var
        ServiceLine1: Record "5902";
    begin
        ServiceLine1.RESET;
        ServiceLine1.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine1.SETRANGE("Line Type", ServiceLine1."Line Type"::"1");
        ServiceLine1.SETRANGE("Work Type Code", 'WARRANTY');
        IF ServiceLine1.FINDFIRST THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;
}


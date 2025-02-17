codeunit 50009 "Vehicle Allotment Mgt."
{

    trigger OnRun()
    begin
        //UpdateVehiclePurchaseInvDate;
        //DelVehicles;
        SalesSetup.GET;

        DispatchBuffer.RESET;
        DispatchBuffer.SETRANGE("Vehicle Created", FALSE);
        IF DispatchBuffer.FINDSET THEN
            REPEAT
                LcDetails.RESET;
                LcDetails.SETRANGE("LC\DO No.", DispatchBuffer."LC No.");
                LcDetails.SETRANGE(Released, TRUE);
                LcDetails.SETRANGE(Closed, FALSE);
                IF LcDetails.FINDFIRST THEN
                    CreateVehicle(DispatchBuffer);
            UNTIL DispatchBuffer.NEXT = 0;

        VehicleDeallotment;

        InsertComfirmedDetails;

        VehicleAllotFromStock;

        MESSAGE('Task Complete!!!');

        //UpdateVehicleReceived
    end;

    var
        DispatchBuffer: Record "50009";
        LcDetails: Record "33020012";
        SalesSetup: Record "311";
        Vehicle: Record "25006005";
        Text000: Label 'Dispatch Posting';
        Text001: ;
        VehicleAlloted: Boolean;

    [Scope('Internal')]
    procedure CreateVehicle(Dispatch_Buffer: Record "50009")
    var
        PurchLine: Record "39";
        Vehicle: Record "25006005";
        PurchHdr: Record "38";
        SalesLine: Record "37";
        TransLine: Record "5741";
        TransHdr: Record "5740";
    begin
        Dispatch_Buffer.TESTFIELD(VIN);
        Dispatch_Buffer.TESTFIELD("Engine No.");

        IF (Dispatch_Buffer.VIN <> '') AND (Dispatch_Buffer."Engine No." <> '') THEN BEGIN
            PurchHdr.RESET;
            PurchHdr.SETRANGE("Bank LC No.", Dispatch_Buffer."LC No.");
            IF PurchHdr.FINDSET THEN BEGIN
                PurchLine.RESET;
                PurchLine.SETRANGE("Document No.", PurchHdr."No.");
                PurchLine.SETRANGE("Dispatch Updated", FALSE);
                PurchLine.SETRANGE("Model Version No.", Dispatch_Buffer."Model Version No.");
                PurchLine.SETRANGE("Variant Code", Dispatch_Buffer."Variant Code");
                IF PurchLine.FINDFIRST THEN BEGIN
                    Vehicle.RESET;
                    Vehicle.SETRANGE("Serial No.", PurchLine."Vehicle Serial No.");
                    IF NOT Vehicle.FINDFIRST THEN BEGIN
                        Vehicle.INIT;
                        Vehicle.VALIDATE("Serial No.", PurchLine."Vehicle Serial No.");
                        Vehicle.VALIDATE(VIN, Dispatch_Buffer.VIN);
                        Vehicle.VALIDATE("Make Code", PurchLine."Make Code");
                        Vehicle.VALIDATE("Model Code", PurchLine."Model Code");
                        Vehicle.VALIDATE("Model Version No.", PurchLine."Model Version No.");
                        Vehicle.VALIDATE("Status Code", 'NEW');
                        Vehicle.VALIDATE("VC No.", Dispatch_Buffer."Variant Code");
                        Vehicle.VALIDATE("Engine No.", Dispatch_Buffer."Engine No.");
                        Vehicle."Production Year" := Dispatch_Buffer."Production Year";
                        Vehicle.INSERT(TRUE);

                        PurchLine."Vehicle Status Code" := 'NEW';
                        PurchLine."Dispatch Updated" := TRUE;
                        PurchLine.MODIFY;

                        Dispatch_Buffer."Vehicle Serial No." := PurchLine."Vehicle Serial No.";
                        Dispatch_Buffer."Vehicle Created" := TRUE;
                        Dispatch_Buffer.MODIFY;
                    END ELSE BEGIN
                        Vehicle.VALIDATE("Serial No.", PurchLine."Vehicle Serial No.");
                        Vehicle.VALIDATE(VIN, Dispatch_Buffer.VIN);
                        Vehicle.VALIDATE("Make Code", PurchLine."Make Code");
                        Vehicle.VALIDATE("Model Code", PurchLine."Model Code");
                        Vehicle.VALIDATE("Model Version No.", PurchLine."Model Version No.");
                        Vehicle.VALIDATE("Status Code", 'NEW');
                        Vehicle.VALIDATE("VC No.", Dispatch_Buffer."Variant Code");
                        Vehicle.VALIDATE("Engine No.", Dispatch_Buffer."Engine No.");
                        Vehicle."Production Year" := Dispatch_Buffer."Production Year";
                        Vehicle.MODIFY(TRUE);

                        PurchLine."Vehicle Status Code" := 'NEW';
                        PurchLine."Dispatch Updated" := TRUE;
                        PurchLine.MODIFY;

                        Dispatch_Buffer."Vehicle Serial No." := PurchLine."Vehicle Serial No.";
                        Dispatch_Buffer."Vehicle Created" := TRUE;
                        Dispatch_Buffer.MODIFY;

                    END;
                END;
            END;
            /*
           //remove vehicle serial no. from sales and transfer lines which are used for order promising
           SalesLine.RESET;
           SalesLine.CALCFIELDS(VIN);
           SalesLine.SETRANGE(VIN,Dispatch_Buffer.VIN);
           SalesLine.SETRANGE("System Allotment",FALSE);
           IF NOT SalesLine.FINDFIRST THEN BEGIN
             TransLine.RESET;
             TransLine.CALCFIELDS(VIN);
             TransLine.SETRANGE(VIN,Dispatch_Buffer.VIN);
             IF TransLine.FINDFIRST THEN BEGIN
              TransHdr.GET(TransLine."Document No.");
              Reopen(TransHdr);

              TransLine.VALIDATE("Vehicle Serial No.",'');
              TransLine.MODIFY;
             END;
           END ELSE BEGIN
             SalesLine.VALIDATE("Vehicle Serial No.",'');
             SalesLine.MODIFY;
           END;
           */
        END;

    end;

    [Scope('Internal')]
    procedure VehicleAllotFromDispatchBuffer(Dispatch_Buffer: Record "50009")
    var
        SalesHdr: Record "36";
        SalesLine: Record "37";
        Vehicle: Record "25006005";
        DeleteSalesLine: Record "37";
        AllotmentHistory: Record "33020331";
        EntryNo: Integer;
        Model_Version: Record "27";
    begin
        Model_Version.GET(Dispatch_Buffer."Model Version No.");

        SalesLine.RESET;
        SalesLine.SETCURRENTKEY("Confirmed Date", "Confirmed Time");
        SalesLine.SETRANGE("Document Profile", SalesHdr."Document Profile"::"Vehicles Trade");
        SalesLine.SETRANGE("Document Type", SalesHdr."Document Type"::Order);
        SalesLine.SETRANGE("System Allotment", FALSE);
        SalesLine.SETRANGE("Model Version No.", Dispatch_Buffer."Model Version No.");
        //salesline.setfilter("VIN",'<>%1','');
        SalesLine.SETFILTER("Confirmed Date", '<>%1', 0D);
        SalesLine.SETFILTER("Confirmed Time", '<>%1', 0T);
        IF SalesLine.FINDFIRST THEN BEGIN
            SalesHdr.RESET;
            SalesHdr.SETRANGE("No.", SalesLine."Document No.");
            SalesHdr.SETFILTER("Sys. LC No.", '<>%1', '');
            IF SalesHdr.FINDFIRST THEN BEGIN
                DeleteSalesLine.RESET;
                DeleteSalesLine.SETRANGE("Vehicle Serial No.", Dispatch_Buffer."Vehicle Serial No.");
                IF DeleteSalesLine.FINDFIRST THEN BEGIN
                    DeleteSalesLine.VALIDATE("Vehicle Serial No.", '');
                    DeleteSalesLine.MODIFY;
                END;

                SalesLine.VALIDATE("Vehicle Serial No.", Dispatch_Buffer."Vehicle Serial No.");
                //SalesLine."Allotment Due Date" := TODAY + Model_Version."Vehicle Allocation Due Date"; commented due to no field
                SalesLine."Allotment Date" := TODAY;
                SalesLine."Allotment Time" := TIME;
                SalesLine."System Allotment" := TRUE;
                SalesLine.MODIFY;

                Dispatch_Buffer."VIN Allocated" := TRUE;
                Dispatch_Buffer."Allocated Document No." := SalesHdr."No.";
                Dispatch_Buffer.MODIFY;

                AllotmentHistory.RESET;
                IF AllotmentHistory.FINDLAST THEN
                    EntryNo := AllotmentHistory."Entry No." + 1
                ELSE
                    EntryNo := 1;

                CLEAR(AllotmentHistory);
                AllotmentHistory.INIT;
                AllotmentHistory."Entry No." := EntryNo;
                AllotmentHistory.Type := AllotmentHistory.Type::Allotment;
                AllotmentHistory."Vehicle Serial No." := Dispatch_Buffer."Vehicle Serial No.";
                AllotmentHistory.VIN := Dispatch_Buffer.VIN;
                AllotmentHistory."Model Version No." := Dispatch_Buffer."Model Version No.";
                AllotmentHistory.Date := TODAY;
                AllotmentHistory.Time := TIME;
                AllotmentHistory."Document No." := SalesLine."Document No.";
                AllotmentHistory.INSERT(TRUE);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure VehicleDeallotment()
    var
        SalesHdr: Record "36";
        SalesLine: Record "37";
        Vehicle: Record "25006005";
        DeleteSalesLine: Record "37";
        DelDispatchBuffer: Record "50009";
        AllotmentHistory: Record "33020331";
        EntryNo: Integer;
        TransLine: Record "5741";
        TransHdr: Record "5740";
    begin
        SalesLine.RESET;
        SalesLine.SETRANGE("System Allotment", TRUE);
        SalesLine.SETFILTER("Allotment Due Date", '<%1', TODAY);
        IF SalesLine.FINDFIRST THEN
            REPEAT
                IF SalesLine."Allotment Due Date" <> 0D THEN BEGIN
                    DelDispatchBuffer.RESET;
                    DelDispatchBuffer.SETRANGE("Vehicle Serial No.", SalesLine."Vehicle Serial No.");
                    IF DelDispatchBuffer.FINDSET THEN BEGIN
                        DelDispatchBuffer."VIN Allocated" := FALSE;
                        DelDispatchBuffer."Allocated Document No." := '';
                        DelDispatchBuffer.MODIFY;
                    END;

                    SalesLine.VALIDATE("Vehicle Serial No.", '');
                    SalesLine."Allotment Date" := 0D;
                    SalesLine."Allotment Time" := 0T;
                    SalesLine."System Allotment" := FALSE;
                    SalesLine."Allotment Due Date" := 0D;
                    SalesLine.MODIFY;

                    AllotmentHistory.RESET;
                    IF AllotmentHistory.FINDLAST THEN
                        EntryNo := AllotmentHistory."Entry No." + 1
                    ELSE
                        EntryNo := 1;

                    CLEAR(AllotmentHistory);
                    AllotmentHistory.INIT;
                    AllotmentHistory."Entry No." := EntryNo;
                    AllotmentHistory.Type := AllotmentHistory.Type::Deallotment;
                    AllotmentHistory."Vehicle Serial No." := DelDispatchBuffer."Vehicle Serial No.";
                    AllotmentHistory.VIN := DelDispatchBuffer.VIN;
                    AllotmentHistory."Model Version No." := DelDispatchBuffer."Model Version No.";
                    AllotmentHistory.Date := TODAY;
                    AllotmentHistory.Time := TIME;
                    AllotmentHistory."Document No." := SalesLine."Document No.";
                    AllotmentHistory.Link := AllotmentHistory.Link::"Sales Order";
                    AllotmentHistory.INSERT(TRUE);
                END;
            UNTIL SalesLine.NEXT = 0;

        TransLine.RESET;
        TransLine.SETRANGE("System Allotment", TRUE);
        TransLine.SETFILTER("Allotment Due Date", '<%1', TODAY);
        IF TransLine.FINDFIRST THEN
            REPEAT
                IF TransLine."Allotment Due Date" <> 0D THEN BEGIN
                    TransHdr.GET(TransLine."Document No.");
                    Reopen(TransHdr);

                    DelDispatchBuffer.RESET;
                    DelDispatchBuffer.SETRANGE("Vehicle Serial No.", TransLine."Vehicle Serial No.");
                    IF DelDispatchBuffer.FINDSET THEN BEGIN
                        DelDispatchBuffer."VIN Allocated" := FALSE;
                        DelDispatchBuffer."Allocated Document No." := '';
                        DelDispatchBuffer.MODIFY;
                    END;

                    TransLine.VALIDATE("Vehicle Serial No.", '');
                    TransLine."Allotment Date" := 0D;
                    TransLine."Allotment Time" := 0T;
                    TransLine."System Allotment" := FALSE;
                    TransLine."Allotment Due Date" := 0D;
                    TransLine.MODIFY;

                    AllotmentHistory.RESET;
                    IF AllotmentHistory.FINDLAST THEN
                        EntryNo := AllotmentHistory."Entry No." + 1
                    ELSE
                        EntryNo := 1;

                    CLEAR(AllotmentHistory);
                    AllotmentHistory.INIT;
                    AllotmentHistory."Entry No." := EntryNo;
                    AllotmentHistory.Type := AllotmentHistory.Type::Deallotment;
                    AllotmentHistory."Vehicle Serial No." := DelDispatchBuffer."Vehicle Serial No.";
                    AllotmentHistory.VIN := DelDispatchBuffer.VIN;
                    AllotmentHistory."Model Version No." := DelDispatchBuffer."Model Version No.";
                    AllotmentHistory.Date := TODAY;
                    AllotmentHistory.Time := TIME;
                    AllotmentHistory."Document No." := TransLine."Document No.";
                    AllotmentHistory.Link := AllotmentHistory.Link::"Transfer Order";
                    AllotmentHistory.INSERT(TRUE);
                END;
            UNTIL TransLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure CreateSalesOrders(Salesbuffer: Record "50021")
    var
        SalesHdr: Record "36";
        SalesLine: Record "37";
    begin
        //IF NOT Salesbuffer."Sales Order Created" THEN BEGIN
        SalesHdr.INIT;
        SalesHdr.VALIDATE("Document Type", SalesHdr."Document Type"::Order);
        SalesHdr.VALIDATE("Posting Date", Salesbuffer."Posting Date");
        SalesHdr.INSERT(TRUE);

        SalesHdr.VALIDATE("Document Profile", SalesHdr."Document Profile"::"Vehicles Trade");
        SalesHdr.VALIDATE("Sell-to Customer No.", Salesbuffer."Customer No.");
        SalesHdr.VALIDATE("Shipment Date", Salesbuffer."Posting Date");
        SalesHdr.MODIFY;

        /*SalesLinebuffer.RESET;
        SalesLinebuffer.SETRANGE("Document No.",Salesbuffer."No.");
        IF SalesLinebuffer.FINDFIRST THEN REPEAT
          SalesLine.INIT;
          SalesLine.VALIDATE("Document Type",SalesLine."Document Type"::Order);
          SalesLine.VALIDATE("Document No.",SalesHdr."No.");
          SalesLine.VALIDATE(Type,SalesLine.Type::Item);
          SalesLine.VALIDATE("Line Type",SalesLine."Line Type"::Vehicle);
          SalesLine."Line No." := SalesLinebuffer."Line No.";
          SalesLine."Shipment Date" := Salesbuffer."Posting Date";
          SalesLine.VALIDATE("Document Profile",SalesHdr."Document Profile"::"Vehicles Trade");
          SalesLine.VALIDATE("Make Code",SalesLinebuffer."Make Code");
          SalesLine.VALIDATE("Model Code",SalesLinebuffer."Model Code");
          SalesLine.VALIDATE("Model Version No.",SalesLinebuffer."Model Version No.");
          SalesLine.VALIDATE(Quantity,SalesLinebuffer.Quantity);
          SalesLine.INSERT(TRUE);
        UNTIL SalesLinebuffer.NEXT = 0;

        Salesbuffer."Sales Order Created" :=  TRUE;
        Salesbuffer.MODIFY;*/
        //END;

    end;

    [Scope('Internal')]
    procedure VehicleAllotFromStock()
    var
        Vehicle: Record "25006005";
        Dispatch_Buf: Record "50009";
        ConfirmedDetail: Record "33020524";
        SalesLine: Record "37";
        TransLine: Record "5741";
        AllotmentHistory: Record "33020331";
        EntryNo: Integer;
        PreviousSalesLine: Record "37";
        PreviouseTransLine: Record "5741";
        SalesHdr: Record "36";
        LC_Detail: Record "33020012";
        Customer: Record "18";
        salesReceivableSetup: Record "311";
        TransHdr: Record "5740";
    begin
        salesReceivableSetup.GET;
        SalesSetup.GET;

        ConfirmedDetail.RESET;
        ConfirmedDetail.SETCURRENTKEY("Confirmed Date", "Confirmed Time");
        IF ConfirmedDetail.FINDSET THEN BEGIN
            REPEAT
                VehicleAlloted := FALSE;
                Vehicle.RESET;
                Vehicle.SETCURRENTKEY("Purchase Invoice Date (Real)");
                Vehicle.CALCFIELDS(Inventory);
                Vehicle.CALCFIELDS("Variant Code");
                Vehicle.CALCFIELDS("Current Location of Vehicle");
                Vehicle.SETRANGE("Model Version No.", ConfirmedDetail."Model Version No.");
                Vehicle.SETRANGE("Variant Code", ConfirmedDetail."Variant Code");
                Vehicle.SETRANGE("Status Code", 'NEW');
                Vehicle.SETFILTER(Inventory, '>%1', 0);
                Vehicle.SETRANGE("Current Location of Vehicle", ConfirmedDetail."Location Code");
                //Vehicle.SETFILTER("Purchase Invoice Date (Real)",'<>%1',0D);
                IF Vehicle.FINDSET THEN BEGIN
                    REPEAT
                        IF Vehicle."Purchase Invoice Date (Real)" <> 0D THEN BEGIN
                            PreviousSalesLine.RESET;
                            PreviousSalesLine.CALCFIELDS(VIN);
                            PreviousSalesLine.SETRANGE(VIN, Vehicle.VIN);
                            PreviousSalesLine.SETRANGE("System Allotment", TRUE);
                            IF NOT PreviousSalesLine.FINDFIRST THEN BEGIN
                                PreviouseTransLine.RESET;
                                PreviouseTransLine.CALCFIELDS(VIN);
                                PreviouseTransLine.SETRANGE(VIN, Vehicle.VIN);
                                PreviouseTransLine.SETRANGE("System Allotment", TRUE);
                                IF NOT PreviouseTransLine.FINDSET THEN BEGIN
                                    IF SalesLine.GET(SalesLine."Document Type"::Order, ConfirmedDetail."Document No.", ConfirmedDetail."Line No.") THEN BEGIN
                                        SalesLine.CALCFIELDS(VIN);
                                        IF SalesLine.VIN = '' THEN BEGIN
                                            Vehicle.CALCFIELDS("Variant Code");
                                            //SalesHdr.GET(SalesLine."Document Type",SalesLine."Document No.");
                                            //LC_Detail.GET(SalesHdr."Sys. LC No.");
                                            //Customer.GET(LC_Detail."Issued To/Received From");
                                            IF Customer."Is Dealer" THEN
                                                SalesLine."Allotment Due Date" := TODAY + salesReceivableSetup."LC Validity Days"
                                            ELSE
                                                SalesLine."Allotment Due Date" := TODAY + salesReceivableSetup."DO Validity Days";

                                            SalesLine.VALIDATE("Vehicle Serial No.", Vehicle."Serial No.");
                                            SalesLine.VALIDATE("Variant Code", Vehicle."Variant Code");
                                            //
                                            SalesLine."Allotment Date" := TODAY;
                                            SalesLine."Allotment Time" := TIME;
                                            SalesLine."System Allotment" := TRUE;
                                            SalesLine.MODIFY;

                                            IF DispatchBuffer.GET(Vehicle.VIN) THEN BEGIN
                                                DispatchBuffer."VIN Allocated" := TRUE;
                                                DispatchBuffer."Allocated Document No." := SalesLine."Document No.";
                                                DispatchBuffer.MODIFY;
                                            END;


                                            AllotmentHistory.RESET;
                                            IF AllotmentHistory.FINDLAST THEN
                                                EntryNo := AllotmentHistory."Entry No." + 1
                                            ELSE
                                                EntryNo := 1;

                                            CLEAR(AllotmentHistory);
                                            AllotmentHistory.INIT;
                                            AllotmentHistory."Entry No." := EntryNo;
                                            AllotmentHistory.Type := AllotmentHistory.Type::Allotment;
                                            AllotmentHistory."Vehicle Serial No." := Vehicle."Serial No.";
                                            AllotmentHistory.VIN := Vehicle.VIN;
                                            AllotmentHistory."Model Version No." := Vehicle."Model Version No.";
                                            AllotmentHistory.Date := TODAY;
                                            AllotmentHistory.Time := TIME;
                                            AllotmentHistory."Document No." := SalesLine."Document No.";
                                            AllotmentHistory.Link := AllotmentHistory.Link::"Sales Order";
                                            AllotmentHistory.INSERT(TRUE);
                                            VehicleAlloted := TRUE;
                                        END;
                                        /*
                                        END ELSE IF TransLine.GET(ConfirmedDetail."Document No.",ConfirmedDetail."Line No.") THEN BEGIN
                                         TransLine.CALCFIELDS(VIN);
                                         IF TransLine.VIN = '' THEN BEGIN
                                          TransHdr.GET(TransLine."Document No.");
                                          IF TransHdr.Tender THEN
                                            TransLine."Allotment Due Date" := TODAY + salesReceivableSetup."Tender Validity Days"
                                          ELSE
                                            TransLine."Allotment Due Date" := TODAY + salesReceivableSetup."DO Validity Days";
                                          TransLine.VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
                                          TransLine.VALIDATE("Variant Code",Vehicle."Variant code");
                                          //
                                          TransLine."Allotment Date" := TODAY;
                                          TransLine."Allotment Time" := TIME;
                                          TransLine."System Allotment" := TRUE;
                                          TransLine.MODIFY;

                                          IF DispatchBuffer.GET(Vehicle.VIN) THEN BEGIN
                                            DispatchBuffer."VIN Allocated" := TRUE;
                                            DispatchBuffer."Allocated Document No." := TransLine."Document No.";
                                            DispatchBuffer.MODIFY;
                                          END;

                                          AllotmentHistory.RESET;
                                          IF AllotmentHistory.FINDLAST THEN
                                             EntryNo := AllotmentHistory."Entry No." + 1
                                          ELSE
                                             EntryNo := 1;

                                          CLEAR(AllotmentHistory);
                                          AllotmentHistory.INIT;
                                          AllotmentHistory."Entry No." := EntryNo;
                                          AllotmentHistory.Type := AllotmentHistory.Type::Allotment;
                                          AllotmentHistory."Vehicle Serial No." := Vehicle."Serial No.";
                                          AllotmentHistory.VIN := Vehicle.VIN;
                                          AllotmentHistory."Model Version No." := Vehicle."Model Version No.";
                                          AllotmentHistory.Date := TODAY;
                                          AllotmentHistory.Time := TIME;
                                          AllotmentHistory."Document No." := TransLine."Document No.";
                                          AllotmentHistory.Link := AllotmentHistory.Link::"Transfer Order";
                                          AllotmentHistory.INSERT(TRUE);
                                         END;
                                         */
                                    END;
                                END;
                            END;

                        END;
                    UNTIL Vehicle.NEXT = 0;
                END;

                //END ELSE BEGIN
                IF NOT VehicleAlloted THEN BEGIN

                    Vehicle.RESET;
                    Vehicle.SETCURRENTKEY("Purchase Invoice Date (Real)");
                    Vehicle.CALCFIELDS(Inventory);
                    Vehicle.CALCFIELDS("Variant Code");
                    Vehicle.CALCFIELDS("Current Location of Vehicle");
                    Vehicle.SETRANGE("Model Version No.", ConfirmedDetail."Model Version No.");
                    Vehicle.SETRANGE("Variant Code", ConfirmedDetail."Variant Code");
                    Vehicle.SETRANGE("Status Code", 'NEW');
                    Vehicle.SETFILTER(Inventory, '>%1', 0);
                    Vehicle.SETRANGE("Current Location of Vehicle", SalesSetup."Agni Corporate Location");
                    //Vehicle.SETFILTER("Purchase Invoice Date (Real)",'<>%1',0D);
                    IF Vehicle.FINDSET THEN BEGIN
                        REPEAT
                            IF Vehicle."Purchase Invoice Date (Real)" <> 0D THEN BEGIN
                                PreviousSalesLine.RESET;
                                PreviousSalesLine.CALCFIELDS(VIN);
                                PreviousSalesLine.SETRANGE(VIN, Vehicle.VIN);
                                PreviousSalesLine.SETRANGE("System Allotment", TRUE);
                                IF NOT PreviousSalesLine.FINDFIRST THEN BEGIN
                                    PreviouseTransLine.RESET;
                                    PreviouseTransLine.CALCFIELDS(VIN);
                                    PreviouseTransLine.SETRANGE(VIN, Vehicle.VIN);
                                    PreviouseTransLine.SETRANGE("System Allotment", TRUE);
                                    IF NOT PreviouseTransLine.FINDSET THEN BEGIN

                                        IF SalesLine.GET(SalesLine."Document Type"::Order, ConfirmedDetail."Document No.", ConfirmedDetail."Line No.") THEN BEGIN
                                            SalesLine.CALCFIELDS(VIN);
                                            IF SalesLine.VIN = '' THEN BEGIN
                                                Vehicle.CALCFIELDS("Variant Code");
                                                SalesLine.VALIDATE("Vehicle Serial No.", Vehicle."Serial No.");
                                                SalesLine.VALIDATE("Variant Code", Vehicle."Variant Code");
                                                //SalesLine."Allotment Due Date" := TODAY + Model_Version."Vehicle Allocation Due Date"; commented due to no field
                                                SalesLine."Allotment Date" := TODAY;
                                                SalesLine."Allotment Time" := TIME;
                                                SalesLine."System Allotment" := TRUE;
                                                SalesLine.MODIFY;

                                                IF DispatchBuffer.GET(Vehicle.VIN) THEN BEGIN
                                                    DispatchBuffer."VIN Allocated" := TRUE;
                                                    DispatchBuffer."Allocated Document No." := SalesLine."Document No.";
                                                    DispatchBuffer.MODIFY;
                                                END;

                                                AllotmentHistory.RESET;
                                                IF AllotmentHistory.FINDLAST THEN
                                                    EntryNo := AllotmentHistory."Entry No." + 1
                                                ELSE
                                                    EntryNo := 1;

                                                CLEAR(AllotmentHistory);
                                                AllotmentHistory.INIT;
                                                AllotmentHistory."Entry No." := EntryNo;
                                                AllotmentHistory.Type := AllotmentHistory.Type::Allotment;
                                                AllotmentHistory."Vehicle Serial No." := Vehicle."Serial No.";
                                                AllotmentHistory.VIN := Vehicle.VIN;
                                                AllotmentHistory."Model Version No." := Vehicle."Model Version No.";
                                                AllotmentHistory.Date := TODAY;
                                                AllotmentHistory.Time := TIME;
                                                AllotmentHistory."Document No." := SalesLine."Document No.";
                                                AllotmentHistory.Link := AllotmentHistory.Link::"Sales Order";
                                                AllotmentHistory.INSERT(TRUE);
                                            END;
                                        END ELSE
                                            IF TransLine.GET(ConfirmedDetail."Document No.", ConfirmedDetail."Line No.") THEN BEGIN
                                                TransLine.CALCFIELDS(VIN);
                                                Vehicle.CALCFIELDS("Variant Code");
                                                IF TransLine.VIN = '' THEN BEGIN
                                                    TransLine.VALIDATE("Vehicle Serial No.", Vehicle."Serial No.");
                                                    TransLine.VALIDATE("Variant Code", Vehicle."Variant Code");
                                                    //SalesLine."Allotment Due Date" := TODAY + Model_Version."Vehicle Allocation Due Date"; commented due to no field
                                                    TransLine."Allotment Date" := TODAY;
                                                    TransLine."Allotment Time" := TIME;
                                                    TransLine."System Allotment" := TRUE;
                                                    TransLine.MODIFY;

                                                    IF DispatchBuffer.GET(Vehicle.VIN) THEN BEGIN
                                                        DispatchBuffer."VIN Allocated" := TRUE;
                                                        DispatchBuffer."Allocated Document No." := TransLine."Document No.";
                                                        DispatchBuffer.MODIFY;
                                                    END;

                                                    AllotmentHistory.RESET;
                                                    IF AllotmentHistory.FINDLAST THEN
                                                        EntryNo := AllotmentHistory."Entry No." + 1
                                                    ELSE
                                                        EntryNo := 1;

                                                    CLEAR(AllotmentHistory);
                                                    AllotmentHistory.INIT;
                                                    AllotmentHistory."Entry No." := EntryNo;
                                                    AllotmentHistory.Type := AllotmentHistory.Type::Allotment;
                                                    AllotmentHistory."Vehicle Serial No." := Vehicle."Serial No.";
                                                    AllotmentHistory.VIN := Vehicle.VIN;
                                                    AllotmentHistory."Model Version No." := Vehicle."Model Version No.";
                                                    AllotmentHistory.Date := TODAY;
                                                    AllotmentHistory.Time := TIME;
                                                    AllotmentHistory."Document No." := TransLine."Document No.";
                                                    AllotmentHistory.Link := AllotmentHistory.Link::"Transfer Order";
                                                    AllotmentHistory.INSERT(TRUE);
                                                END;
                                            END;
                                    END;
                                END;
                            END;
                        UNTIL Vehicle.NEXT = 0;
                    END;
                END;
            UNTIL ConfirmedDetail.NEXT = 0;
        END;

    end;

    [Scope('Internal')]
    procedure InsertComfirmedDetails()
    var
        SalesLine: Record "37";
        TransferLine: Record "5741";
        ConfirmedDetail: Record "33020524";
        TransHdr: Record "5740";
        SalesHdr: Record "36";
    begin
        CLEAR(SalesLine);
        CLEAR(TransferLine);
        ConfirmedDetail.DELETEALL;

        SalesLine.RESET;
        SalesLine.SETFILTER("Confirmed Date", '<>%1', 0D);
        SalesLine.SETFILTER("Confirmed Time", '<>%1', 0T);
        SalesLine.SETRANGE("System Allotment", FALSE);
        SalesLine.SETRANGE("Quantity Shipped", 0);
        IF SalesLine.FINDSET THEN
            REPEAT
                SalesLine.CALCFIELDS(VIN);
                IF SalesLine.VIN = '' THEN BEGIN
                    SalesHdr.GET(SalesHdr."Document Type"::Order, SalesLine."Document No.");

                    ConfirmedDetail.INIT;
                    ConfirmedDetail."Document Type" := ConfirmedDetail."Document Type"::"Sales Order";
                    ConfirmedDetail."Document No." := SalesLine."Document No.";
                    ConfirmedDetail."Line No." := SalesLine."Line No.";
                    ConfirmedDetail."Confirmed Date" := SalesLine."Confirmed Date";
                    ConfirmedDetail."Confirmed Time" := SalesLine."Confirmed Time";
                    ConfirmedDetail."Model Version No." := SalesLine."Model Version No.";
                    ConfirmedDetail."Location Code" := SalesLine."Location Code";
                    ConfirmedDetail."Variant Code" := SalesLine."Variant Code";
                    ConfirmedDetail."Document Date" := SalesHdr."Order Date";
                    ConfirmedDetail.INSERT(TRUE);
                END;
            UNTIL SalesLine.NEXT = 0;

        TransferLine.RESET;
        TransferLine.SETFILTER("Confirmed Date", '<>%1', 0D);
        TransferLine.SETFILTER("Confirmed Time", '<>%1', 0T);
        TransferLine.SETRANGE("System Allotment", FALSE);
        TransferLine.SETRANGE("Quantity Shipped", 0);
        IF TransferLine.FINDSET THEN
            REPEAT
                TransferLine.CALCFIELDS(VIN);
                IF TransferLine.VIN = '' THEN BEGIN
                    TransHdr.GET(TransferLine."Document No.");
                    Reopen(TransHdr);
                    ConfirmedDetail.INIT;
                    ConfirmedDetail."Document Type" := ConfirmedDetail."Document Type"::"Transfer Order";
                    ConfirmedDetail."Document No." := TransferLine."Document No.";
                    ConfirmedDetail."Line No." := TransferLine."Line No.";
                    ConfirmedDetail."Confirmed Date" := TransferLine."Confirmed Date";
                    ConfirmedDetail."Confirmed Time" := TransferLine."Confirmed Time";
                    ConfirmedDetail."Model Version No." := TransferLine."Model Version No.";
                    ConfirmedDetail."Location Code" := TransferLine."Transfer-to Code";
                    ConfirmedDetail."Variant Code" := TransferLine."Variant Code";
                    ConfirmedDetail."Document Date" := TransferLine."Shipment Date";
                    ConfirmedDetail.INSERT(TRUE);
                END;
            UNTIL TransferLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure UpdateVehiclePurchaseInvDate()
    begin
        Vehicle.RESET;
        Vehicle.SETRANGE("Purchase Invoice Date (Real)", 0D);
        IF Vehicle.FINDSET THEN
            REPEAT
                Vehicle.CALCFIELDS("Purchase Invoice Date");
                Vehicle."Purchase Invoice Date (Real)" := Vehicle."Purchase Invoice Date";
                Vehicle.MODIFY(TRUE);
            UNTIL Vehicle.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure Reopen(var TransHeader: Record "5740")
    begin
        IF TransHeader.Status = TransHeader.Status::Open THEN
            EXIT;
        TransHeader.VALIDATE(Status, TransHeader.Status::Open);
        TransHeader.MODIFY;
        COMMIT;
    end;

    [Scope('Internal')]
    procedure DelVehicles()
    begin
        Vehicle.RESET;
        Vehicle.SETFILTER("Serial No.", 'VH-00076228');
        IF Vehicle.FINDSET THEN BEGIN
            REPEAT
                Vehicle.DELETE;
            UNTIL Vehicle.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure CreateDispatchJournals(Dispatch_Buffer: Record "50009"; Reverse: Boolean)
    var
        GenJnlLine: Record "81";
        SalesSetup: Record "311";
    begin
        SalesSetup.GET;
        SalesSetup.TESTFIELD("Purchase Account");
        SalesSetup.TESTFIELD("LC Vendor A/c");

        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := SalesSetup."Dispatch Template Name";
        GenJnlLine."Journal Batch Name" := SalesSetup."Dispatch Batch Name";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine.VALIDATE("Account No.", SalesSetup."Purchase Account");
        GenJnlLine.VALIDATE("Posting Date", TODAY);
        GenJnlLine."Document No." := '';
        GenJnlLine.Description := Text000;
        GenJnlLine.VALIDATE(Amount, DispatchBuffer."Gross Invoice" + DispatchBuffer."Freight Amount");
        GenJnlLine.VIN := DispatchBuffer.VIN;
        GenJnlLine."Vehicle Serial No." := DispatchBuffer."Vehicle Serial No.";
        GenJnlLine.INSERT(TRUE);

        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := SalesSetup."Dispatch Template Name";
        GenJnlLine."Journal Batch Name" := SalesSetup."Dispatch Batch Name";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine.VALIDATE("Account No.", SalesSetup."Purchase Account");
        GenJnlLine.VALIDATE("Posting Date", TODAY);
        GenJnlLine."Document No." := '';
        GenJnlLine.Description := Text000;
        GenJnlLine.VALIDATE(Amount, -(DispatchBuffer."Gross Invoice" + DispatchBuffer."Freight Amount"));
        GenJnlLine.VIN := DispatchBuffer.VIN;
        GenJnlLine."Vehicle Serial No." := DispatchBuffer."Vehicle Serial No.";
        GenJnlLine.INSERT(TRUE);
    end;

    [Scope('Internal')]
    procedure DeleteConfirmedTransferLines()
    begin
    end;

    [Scope('Internal')]
    procedure UPdateTenderInTOLines()
    var
        TransHdr: Record "5740";
        TransLine: Record "5741";
    begin
        TransHdr.RESET;
        TransHdr.SETRANGE(Tender, TRUE);
        IF TransHdr.FINDSET THEN
            REPEAT
                TransLine.RESET;
                TransLine.SETRANGE("Document No.", TransHdr."No.");
                IF TransLine.FINDSET THEN
                    REPEAT
                        TransLine.Tender := TRUE;
                        TransLine.MODIFY(TRUE);
                    UNTIL TransLine.NEXT = 0;
            UNTIL TransHdr.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure UpdateVehicleReceived()
    var
        DispatchBuffer: Record "50009";
        PurchRcptLine: Record "121";
        ModifiedCount: Integer;
    begin
        ModifiedCount := 0;

        DispatchBuffer.RESET;
        DispatchBuffer.SETRANGE("Vehicle Received", FALSE);
        IF DispatchBuffer.FINDSET THEN
            REPEAT
                PurchRcptLine.RESET;
                PurchRcptLine.SETRANGE("Document Profile", PurchRcptLine."Document Profile"::"Vehicles Trade");
                PurchRcptLine.SETRANGE("Vehicle Serial No.", DispatchBuffer."Vehicle Serial No.");
                IF PurchRcptLine.FINDFIRST THEN BEGIN
                    DispatchBuffer."Vehicle Received" := TRUE;
                    DispatchBuffer.MODIFY;
                    ModifiedCount += 1;
                END;
            UNTIL DispatchBuffer.NEXT = 0;
        MESSAGE('%1 records modified!!!!', ModifiedCount);
    end;
}


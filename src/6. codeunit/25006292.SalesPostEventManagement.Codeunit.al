codeunit 25006292 "Sales Post Event Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text102: Label 'Can''t find corresponding Item Ledger Entry to include sales amount.';
        Text103: Label 'Can''t find corresponding Value Entry to include sales amount.';
        Text101: Label 'Service Purchase Order was created but not posted.';

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterPostSalesDoc', '', false, false)]
    local procedure UpdateOnAfterPostSalesDoc(var SalesHeader: Record "36"; var GenJnlPostLine: Codeunit "12"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    begin
        UpdateVehicleInHeader(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostCommitSalesDoc', '', false, false)]
    local procedure UpdateOnBeforePostCommitSalesDoc(var Sender: Codeunit "80"; var SalesHeader: Record "36"; var GenJnlPostLine: Codeunit "12"; PreviewMode: Boolean; ModifyHeader: Boolean)
    var
        SalesSetup: Record "311";
        PostPurchInvc: Boolean;
        ChApplyToDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"Transfer Receipt","Return Shipment","Sales Shipment","Return Receipt";
        ChApplyToDocNo: Code[20];
        ChApplyToLineNo: Integer;
        ChApplyToItemNo: Code[20];
        Vehicle: Record "25006005";
        VehicleContact: Record "25006013";
        SalesLine: Record "37";
        PurchInvcHeader: Record "38";
        VehContactBusinessRelation: Record "5054";
        GenJnlLineDocNo: Code[20];
        GenJnlLineExtDocNo: Code[35];
        GenJnlLineDocType: Integer;
        SrcCode: Code[10];
        Currency: Record "4";
        TempSalesLineGlobal: Record "37";
        UserProfileMgt: Codeunit "25006002";
        UserProfile: Record "25006067";
        ServiceTransferMgt: Codeunit "25006010";
        ServiceSetupEDMS: Record "25006120";
        PurchPost: Codeunit "90";
    begin
        /*
        UpdateVehicelSerialNo(SalesHeader);
        UpdateVehicelServicePlan(SalesHeader);
        
        IF SalesHeader."Document Profile" = SalesHeader."Document Profile"::Service THEN BEGIN
          SalesHeader.TESTFIELD("Job Type");
          IF SalesSetup."Payment Method Mandatory" THEN
            SalesHeader.TESTFIELD("Payment Method Code");
          IF SalesHeader."Vehicle Item Charge No." <> '' THEN BEGIN
            PostPurchInvc := FindItemEntryForApplyCh(SalesHeader."Vehicle Serial No.",SalesHeader."Vehicle Accounting Cycle No.",
                ChApplyToDocType,ChApplyToDocNo,ChApplyToLineNo,ChApplyToItemNo);
            SalesHeader.TESTFIELD("Model Version No.")
          END;
        END;
        
        IF SalesHeader."Document Profile" = SalesHeader."Document Profile"::"Vehicles Trade" THEN
          BEGIN
          SalesLine.RESET;
          SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
          SalesLine.SETRANGE("Document No.", SalesHeader."No.");
          IF SalesLine.FINDFIRST THEN
            REPEAT
              IF (SalesLine."Line Type" = SalesLine."Line Type"::Vehicle) AND (SalesLine."Vehicle Serial No." <> '') THEN
                BEGIN
                IF Vehicle.GET(SalesLine."Vehicle Serial No.") THEN
                  BEGIN
                    VehContactBusinessRelation.RESET;
                    VehContactBusinessRelation.SETRANGE("Link to Table",VehContactBusinessRelation."Link to Table"::Customer);
                    VehContactBusinessRelation.SETRANGE("Business Relation Code",'CUST');
                    VehContactBusinessRelation.SETRANGE("No.",SalesHeader."Sell-to Customer No.");
                    IF VehContactBusinessRelation.FINDFIRST THEN BEGIN
                    VehicleContact.INIT;
                    VehicleContact.VALIDATE("Vehicle Serial No.", SalesLine."Vehicle Serial No.");
                    VehicleContact.VALIDATE("Contact No.", VehContactBusinessRelation."Contact No.");
                    IF SalesSetup."Def.Vehicle-Contact Rel." <> '' THEN
                      VehicleContact.VALIDATE("Relationship Code", SalesSetup."Def.Vehicle-Contact Rel.");
                    IF VehicleContact.INSERT(TRUE) THEN;
                  END;
                  END;
                END;
            UNTIL SalesLine.NEXT = 0;
          END;
        
          //EDMS1.0.00 >> //EDMS Upgrade 2017
          SalesHeader.CALCFIELDS(Amount);
            IF (SalesHeader."Document Profile" = SalesHeader."Document Profile"::Service) AND
              (SalesHeader."Vehicle Item Charge No." <> '') AND (SalesHeader.Amount <> 0) THEN
                CreatePurchInvcHeader(SalesHeader,PurchInvcHeader,GenJnlLineDocNo);
          //EDMS1.0.00 >>
        
          SalesLine.RESET;
          SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
          SalesLine.SETRANGE("Document No.", SalesHeader."No.");
          IF SalesLine.FINDFIRST THEN
            REPEAT
              TestSalesLine(SalesLine);
        
              CASE SalesLine.Type OF
                SalesLine.Type::"External Service":
                  OnPostExternalService(SalesHeader,SalesLine,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode);
              END;
        
              IF SalesLine."Include In Veh. Sales Amt." THEN
                IncludeInVehSalesAmt(SalesLine);
        
              CreatePurchInvcLine(PurchInvcHeader,SalesHeader,SalesLine,ChApplyToDocType,ChApplyToDocNo,ChApplyToLineNo,ChApplyToItemNo,PostPurchInvc,Currency);
              TempSalesLineGlobal := SalesLine; //AGNI UPG
              CreateServJnlLine(SalesHeader,SalesLine,TempSalesLineGlobal,GenJnlLineDocNo,GenJnlLineDocType,GenJnlLineExtDocNo,SrcCode);
              IF SalesHeader.Invoice THEN
                IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order,SalesHeader."Document Type"::Invoice] THEN BEGIN
                  VehicleSetSalesDate(SalesHeader, SalesLine);
                END;
        
            UNTIL SalesLine.NEXT = 0;
        
        
        
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        IF SalesLine.FINDFIRST THEN
          REPEAT
            IF (SalesLine."Document Profile" = SalesLine."Document Profile"::"Vehicles Trade") AND
                (SalesLine."Line Type" = SalesLine."Line Type"::Vehicle) AND
                (SalesLine."Document Type" <> SalesLine."Document Type"::"Credit Memo") THEN
              IF Vehicle.GET(SalesLine."Vehicle Serial No.") THEN
                IF UserProfileMgt.CurrProfileID <> '' THEN
                  IF UserProfile.GET(UserProfileMgt.CurrProfileID) THEN BEGIN
                    //Vehicle.VALIDATE("Status Code",UserProfile."Default Vehicle Sales Status");
                    //Vehicle.MODIFY(TRUE);
                  END;
          UNTIL SalesLine.NEXT = 0;
        
        DeleteVehReservEntries(SalesHeader);
        
        
        //Processing Transfer Order
        IF (SalesHeader."Document Profile" = SalesHeader."Document Profile"::Service) AND
          (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo") THEN BEGIN
          ServiceSetupEDMS.GET;
          CASE ServiceSetupEDMS."Transfer On Return" OF
            ServiceSetupEDMS."Transfer On Return"::"Create Transfer Order":
              ServiceTransferMgt.CreateAutoReturnTransferOrder(SalesHeader,FALSE);
            ServiceSetupEDMS."Transfer On Return"::"Create&Post Transfer Order":
              ServiceTransferMgt.CreateAutoReturnTransferOrder(SalesHeader,TRUE);
          END;
        END;
        
        //Processing Linked Purchse INvoice
        IF PurchInvcHeader."No."<>'' THEN BEGIN
          IF PostPurchInvc THEN BEGIN
            CODEUNIT.RUN(CODEUNIT::"Release Purchase Document",PurchInvcHeader);
            PurchPost.RUN(PurchInvcHeader);
          END ELSE MESSAGE(Text101)
        END;
        */

    end;

    [Scope('Internal')]
    procedure UpdateVehicelServicePlan(var SalesHeader: Record "36")
    var
        VehicleServicePlan: Record "25006126";
        cuVehSN: Codeunit "25006006";
    begin
        IF SalesHeader."Document Profile" <> SalesHeader."Document Profile"::"Vehicles Trade" THEN
            EXIT;
        VehicleServicePlan.SETRANGE("Vehicle Serial No.", SalesHeader."Vehicle Serial No.");
        IF VehicleServicePlan.FINDFIRST THEN
            REPEAT
                IF (VehicleServicePlan."Start Date" = 0D) OR (VehicleServicePlan."Start Variable Field Run 1" = 0) THEN BEGIN
                    IF (VehicleServicePlan."Start Date" = 0D) THEN
                        VehicleServicePlan.VALIDATE("Start Date", SalesHeader."Posting Date");
                    IF VehicleServicePlan."Start Variable Field Run 1" = 0 THEN
                        VehicleServicePlan.VALIDATE("Start Variable Field Run 1", SalesHeader.Kilometrage);
                    VehicleServicePlan.MODIFY(TRUE);
                END;
            UNTIL VehicleServicePlan.NEXT = 0;
        EXIT;
    end;

    [Scope('Internal')]
    procedure UpdateVehicelSerialNo(var recSalesHeader: Record "36")
    var
        recSalesLine: Record "37";
        cuVehSN: Codeunit "25006006";
    begin
        IF recSalesHeader."Document Profile" <> recSalesHeader."Document Profile"::"Vehicles Trade" THEN
            EXIT;
        CLEAR(cuVehSN);
        recSalesLine.RESET;
        recSalesLine.SETRANGE("Document Type", recSalesHeader."Document Type");
        recSalesLine.SETRANGE("Document No.", recSalesHeader."No.");
        IF recSalesLine.FIND('-') THEN
            REPEAT
                IF "Line Type" = "Line Type"::Vehicle THEN BEGIN
                    recSalesLine.TESTFIELD("Vehicle Serial No.");

                    //Agile CP 30 Dec 2016 (return skipped as apply from entry no does not pass in item entry application)
                    IF recSalesLine."Document Type" IN [recSalesLine."Document Type"::"Return Order", recSalesLine."Document Type"::"Credit Memo"] THEN
                        EXIT;
                    //Agile CP 30 Dec 2016

                    cuVehSN.fDeleteSalesLineTracking(recSalesLine);
                    cuVehSN.fCreateSalesLineTracking(recSalesLine);
                END;
            UNTIL recSalesLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure FindItemEntryForApplyCh(VehSerialNo: Code[20]; VehAccCycleNo: Code[20]; var AplDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"Transfer Receipt","Return Shipment","Sales Shipment","Return Receipt"; var AplDocNo: Code[20]; var AplLineNo: Integer; var AplItemNo: Code[20]): Boolean
    var
        TRRcptLine: Record "5747";
        PurchRcptLine: Record "121";
    begin
        PurchRcptLine.RESET;
        PurchRcptLine.SETCURRENTKEY(Type, "Line Type", "Vehicle Serial No.", "Vehicle Accounting Cycle No.");
        PurchRcptLine.SETRANGE(Type, PurchRcptLine.Type::Item);
        PurchRcptLine.SETRANGE("Line Type", PurchRcptLine."Line Type"::Vehicle);
        PurchRcptLine.SETRANGE("Vehicle Serial No.", VehSerialNo);
        PurchRcptLine.SETRANGE("Vehicle Accounting Cycle No.", VehAccCycleNo);
        IF PurchRcptLine.FINDLAST THEN BEGIN
            AplDocType := AplDocType::Receipt;
            AplDocNo := PurchRcptLine."Document No.";
            AplLineNo := PurchRcptLine."Line No.";
            AplItemNo := PurchRcptLine."No.";
            EXIT(TRUE)
        END;
        TRRcptLine.RESET;
        TRRcptLine.SETCURRENTKEY("Vehicle Serial No.", "Vehicle Accounting Cycle No.", "Receipt Date");
        TRRcptLine.SETRANGE("Vehicle Serial No.", VehSerialNo);
        TRRcptLine.SETRANGE("Vehicle Accounting Cycle No.", VehAccCycleNo);
        IF TRRcptLine.FINDFIRST THEN BEGIN
            AplDocType := AplDocType::"Transfer Receipt";
            AplDocNo := TRRcptLine."Document No.";
            AplLineNo := TRRcptLine."Line No.";
            AplItemNo := TRRcptLine."Item No.";
            EXIT(TRUE)
        END ELSE
            EXIT(FALSE)
    end;

    [Scope('Internal')]
    procedure CreatePurchInvcHeader(SalesHeader: Record "36"; var PurchInvcHdr: Record "38"; GenJnlLineDocNoPubGlobal: Code[20])
    var
        SalesLine3: Record "37";
        Customer: Record "18";
        PurchSetup: Record "312";
        PostPurchInvHdr: Record "122";
        NoSeriesMgt: Codeunit "396";
        GenJnlLineDocNo: Code[20];
    begin
        IF SalesHeader."Vehicle Item Charge No." = '' THEN EXIT;

        Customer.GET(SalesHeader."Sell-to Customer No.");
        IF Customer."Corresponding Vendor No." = '' THEN BEGIN
            Customer.GET(SalesHeader."Bill-to Customer No.");
            Customer.TESTFIELD("Corresponding Vendor No.")
        END;

        PurchInvcHdr.INIT;
        PurchInvcHdr."Document Type" := SalesHeader."Document Type";
        PurchInvcHdr.INSERT(TRUE);

        PurchInvcHdr.TESTFIELD("Posting No. Series");
        PurchInvcHdr."Posting No." := NoSeriesMgt.GetNextNo(PurchInvcHdr."Posting No. Series", PurchInvcHdr."Posting Date", TRUE);
        "Auto Created Doc" := TRUE;
        CASE PurchInvcHdr."Document Type" OF
            PurchInvcHdr."Document Type"::Invoice:
                PurchInvcHdr."Vendor Invoice No." := GenJnlLineDocNoPubGlobal;
            PurchInvcHdr."Document Type"::"Credit Memo":
                BEGIN
                    PurchInvcHdr."Vendor Cr. Memo No." := GenJnlLineDocNoPubGlobal;
                    PurchInvcHdr."Applies-to Doc. Type" := PurchInvcHdr."Applies-to Doc. Type"::Invoice;
                    PostPurchInvHdr.SETCURRENTKEY("Vendor Invoice No.", "Posting Date");
                    PostPurchInvHdr.SETRANGE("Vendor Invoice No.", SalesHeader."Applies-to Doc. No.");
                    IF PostPurchInvHdr.FINDFIRST THEN
                        PurchInvcHdr."Applies-to Doc. No." := PostPurchInvHdr."No."
                END
        END;
        PurchInvcHdr."Posting Date" := SalesHeader."Posting Date";
        PurchInvcHdr."Document Date" := SalesHeader."Document Date";
        "Document Profile" := "Document Profile"::Service;

        PurchInvcHdr.VALIDATE("Location Code", SalesHeader."Location Code");
        PurchInvcHdr.VALIDATE("Payment Method Code", SalesHeader."Payment Method Code");
        PurchInvcHdr.VALIDATE("Buy-from Vendor No.", Customer."Corresponding Vendor No.");
        PurchInvcHdr."Prices Including VAT" := SalesHeader."Prices Including VAT";

        "Vehicle Serial No." := SalesHeader."Vehicle Serial No.";
        "Vehicle Accounting Cycle No." := SalesHeader."Vehicle Accounting Cycle No.";
        PurchInvcHdr."Location Code" := SalesHeader."Location Code";
        // 10.03.2015 EDMS P21 >>
        IF Customer."Item Charge Invoice Deal Type" <> '' THEN
            PurchInvcHdr.VALIDATE("Deal Type Code", Customer."Item Charge Invoice Deal Type");
        // VALIDATE("Dimension Set ID", SalesHeader."Dimension Set ID");  //03.11.2014 EB.P8 #Exxx EDMS
        // 10.03.2015 EDMS P21 <<
        PurchInvcHdr.MODIFY;
    end;

    [Scope('Internal')]
    procedure CreatePurchInvcLine(var PurchInvcHeader: Record "38"; var SalesHeader: Record "36"; var SalesLine: Record "37"; ChApplyToDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"Transfer Receipt","Return Shipment","Sales Shipment","Return Receipt"; ChApplyToDocNo: Code[20]; ChApplyToLineNo: Integer; ChApplyToItemNo: Code[20]; PostPurchInvc: Boolean; Currency: Record "4")
    var
        PurchInvcLine: Record "39";
        ItemCharge: Record "5800";
    begin
        IF (PurchInvcHeader."No." <> '') AND
          ((SalesLine.Type = SalesLine.Type::Item) OR (SalesLine.Type = SalesLine.Type::"G/L Account") OR
            (SalesLine.Type = SalesLine.Type::"External Service") AND (SalesLine."Line Amount" <> 0))
        THEN BEGIN
            PurchInvcLine.INIT;
            PurchInvcLine.VALIDATE("Document Type", PurchInvcHeader."Document Type");
            PurchInvcLine.VALIDATE("Document No.", PurchInvcHeader."No.");
            PurchInvcLine."Line No." := SalesLine."Line No.";
            "Document Profile" := PurchInvcHeader."Document Profile";
            PurchInvcLine.VALIDATE("Line Type", "Line Type"::"Charge (Item)");
            PurchInvcLine.VALIDATE("No.", SalesHeader."Vehicle Item Charge No.");
            ItemCharge.GET(SalesHeader."Vehicle Item Charge No.");
            PurchInvcLine.VALIDATE("Posting Group", ItemCharge."Inventory Posting Group");
            PurchInvcLine.VALIDATE(Quantity, SalesLine.Quantity);
            PurchInvcLine.VALIDATE("Buy-from Vendor No.", PurchInvcHeader."Buy-from Vendor No.");
            PurchInvcLine.VALIDATE("Direct Unit Cost", SalesLine."Unit Price");
            PurchInvcLine.VALIDATE("Line Discount %", SalesLine."Line Discount %");
            PurchInvcLine."System-Created Entry" := TRUE;
            "Deal Type Code" := SalesLine."Deal Type Code";
            PurchInvcLine.VALIDATE("Vehicle Serial No.", SalesHeader."Vehicle Serial No.");
            PurchInvcLine.Description := SalesLine.Description;
            PurchInvcLine."Location Code" := PurchInvcHeader."Location Code";
            PurchInvcLine.VALIDATE("Dimension Set ID", SalesLine."Dimension Set ID");  //10.05.2014 EB.P8 EDMS
            PurchInvcLine.VALIDATE("Unit of Measure Code", SalesLine."Unit of Measure Code");
            PurchInvcLine.INSERT(TRUE);
            CreateItemChargeAssgnt(PurchInvcHeader, PurchInvcLine, ChApplyToDocType, ChApplyToDocNo,
              ChApplyToLineNo, ChApplyToItemNo, PostPurchInvc, Currency);
        END;
    end;

    [Scope('Internal')]
    procedure TestSalesLine(var SalesLine: Record "37")
    var
        SalesLineVehReserve: Codeunit "25006317";
    begin
        //26.02.2008 EDMS P1 // EDMS Upagrade 2017
        IF SalesLine."Line Type" = SalesLine."Line Type"::Vehicle THEN
            SalesLineVehReserve.CheckReservation(SalesLine);
    end;

    [Scope('Internal')]
    procedure OnPostSalesLine(var SalesLine: Record "37")
    begin
    end;

    [Scope('Internal')]
    procedure OnPostExternalService(var SalesHeader: Record "36"; var SalesLine: Record "37"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[20]; SrcCode: Code[20])
    var
        ExtServiceJnlLine: Record "25006143";
        ExtServiceJnlPostLine: Codeunit "25006111";
    begin
        IF (SalesLine."Qty. to Invoice" <> 0) AND (SalesLine."Line Discount %" <> 100) THEN BEGIN
            ExtServiceJnlLine.INIT;
            ExtServiceJnlLine."Posting Date" := SalesHeader."Posting Date";
            ExtServiceJnlLine."Entry Type" := ExtServiceJnlLine."Entry Type"::Sale;
            ExtServiceJnlLine."Reason Code" := SalesHeader."Reason Code";
            ExtServiceJnlLine."Ext. Service No." := SalesLine."No.";
            ExtServiceJnlLine."Ext. Service Tracking No." := SalesLine."External Serv. Tracking No.";
            ExtServiceJnlLine.Description := SalesLine.Description;
            ExtServiceJnlLine."Source Type" := ExtServiceJnlLine."Source Type"::Customer;
            ExtServiceJnlLine."Source No." := SalesLine."Sell-to Customer No.";
            ExtServiceJnlLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
            ExtServiceJnlLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
            ExtServiceJnlLine."Location Code" := SalesLine."Location Code";
            ExtServiceJnlLine."Document No." := GenJnlLineDocNo;
            ExtServiceJnlLine."External Document No." := GenJnlLineExtDocNo;
            ExtServiceJnlLine.Quantity := SalesLine."Qty. to Invoice";
            ExtServiceJnlLine.Amount := SalesLine.Amount;
            ExtServiceJnlLine."Source Code" := SrcCode;
            ExtServiceJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
            ExtServiceJnlPostLine.RunWithCheck(ExtServiceJnlLine);
        END;
    end;

    [Scope('Internal')]
    procedure IncludeInVehSalesAmt(SalesLine: Record "37")
    var
        ItemLedgEntry: Record "32";
        OrigValueEntry: Record "5802";
        ItemJnlLine: Record "83";
        InvtAdj: Codeunit "5895";
        SalesSetup: Record "311";
        ItemJnlPostLine: Codeunit "22";
    begin
        ItemLedgEntry.RESET;
        ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Sale);
        ItemLedgEntry.SETRANGE("Document Profile", ItemLedgEntry."Document Profile"::"Vehicles Trade");
        ItemLedgEntry.SETRANGE("Serial No.", SalesLine."Vehicle Serial No.");
        ItemLedgEntry.SETRANGE("Vehicle Accounting Cycle No.", SalesLine."Vehicle Accounting Cycle No.");
        IF NOT ItemLedgEntry.FINDFIRST THEN ERROR(Text102);
        OrigValueEntry.RESET;
        OrigValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
        OrigValueEntry.SETRANGE("Entry Type", OrigValueEntry."Entry Type"::"Direct Cost");
        OrigValueEntry.SETRANGE(Adjustment, FALSE);
        IF NOT OrigValueEntry.FINDFIRST THEN ERROR(Text103);

        SalesSetup.TESTFIELD("Vehicle Sales Item Charge");
        SalesLine.TESTFIELD("Vehicle Serial No.");
        ItemJnlLine.INIT;
        InvtAdj.SetProperties(FALSE, TRUE);
        ItemJnlLine."Item Charge No." := SalesSetup."Vehicle Sales Item Charge";
        ItemJnlLine."Item No." := OrigValueEntry."Item No.";
        ItemJnlLine."Location Code" := OrigValueEntry."Location Code";
        ItemJnlLine."Variant Code" := OrigValueEntry."Variant Code";
        ItemJnlLine."Vehicle Serial No." := SalesLine."Vehicle Serial No.";
        ItemJnlLine."Posting Date" := WORKDATE;
        ItemJnlLine."Entry Type" := OrigValueEntry."Item Ledger Entry Type";
        ItemJnlLine."Document No." := OrigValueEntry."Document No.";
        ItemJnlLine."Source Code" := OrigValueEntry."Source Code";
        ItemJnlLine."Inventory Posting Group" := OrigValueEntry."Inventory Posting Group";
        ItemJnlLine."Gen. Bus. Posting Group" := OrigValueEntry."Gen. Bus. Posting Group";
        ItemJnlLine."Gen. Prod. Posting Group" := OrigValueEntry."Gen. Prod. Posting Group";
        IF ItemJnlLine."Value Entry Type" = ItemJnlLine."Value Entry Type"::"Direct Cost" THEN
            ItemJnlLine."Item Shpt. Entry No." := OrigValueEntry."Item Ledger Entry No.";

        ItemJnlLine."Applies-to Entry" := OrigValueEntry."Item Ledger Entry No.";
        ItemJnlLine.Amount := -SalesLine."Line Amount";

        ItemJnlLine."Shortcut Dimension 1 Code" := OrigValueEntry."Global Dimension 1 Code";
        ItemJnlLine."Shortcut Dimension 2 Code" := OrigValueEntry."Global Dimension 2 Code";
        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
    end;

    [Scope('Internal')]
    procedure CreateItemChargeAssgnt(PurchHeader: Record "38"; PurchLine: Record "39"; AplDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"Transfer Receipt","Return Shipment","Sales Shipment","Return Receipt"; AplDocNo: Code[20]; AplLineNo: Integer; AplItemNo: Code[20]; InsertAssgnt: Boolean; var Currency: Record "4")
    var
        ItemChargeAssgntPurch: Record "5805";
        ShipmentMethod: Record "10";
        AssignItemChargePurch: Codeunit "5805";
        NextNo: Integer;
    begin
        //Assign Item Charge
        ItemChargeAssgntPurch.RESET;
        ItemChargeAssgntPurch."Document Type" := PurchLine."Document Type";
        ItemChargeAssgntPurch."Document No." := PurchLine."Document No.";
        ItemChargeAssgntPurch."Document Line No." := PurchLine."Line No.";
        ItemChargeAssgntPurch."Item Charge No." := PurchLine."No.";
        ItemChargeAssgntPurch.VALIDATE("Vehicle-Serial No.", "Vehicle Serial No.");  //03.11.2014 EB.P8 #Exxx EDMS
                                                                                     //11.06.2015 EB.P30 #T036 >>
                                                                                     //IF ("Inv. Discount Amount" = 0) AND (NOT PurchHeader."Prices Including VAT") THEN
                                                                                     //  ItemChargeAssgntPurch."Unit Cost" := "Unit Cost"
                                                                                     //ELSE
        IF PurchHeader."Prices Including VAT" THEN
            ItemChargeAssgntPurch."Unit Cost" :=
              ROUND(
                (PurchLine."Line Amount" - PurchLine."Inv. Discount Amount") / PurchLine.Quantity / (1 + PurchLine."VAT %" / 100),
                 Currency."Unit-Amount Rounding Precision")
        ELSE
            ItemChargeAssgntPurch."Unit Cost" :=
              ROUND(
                (PurchLine."Line Amount" - PurchLine."Inv. Discount Amount") / PurchLine.Quantity,
                 Currency."Unit-Amount Rounding Precision");
        //11.06.2015 EB.P30 #T036 <<
        NextNo := PurchLine."Line No." - 10000;
        IF InsertAssgnt THEN BEGIN
            //20.08.2013 EDMS P8 >>
            IF PurchHeader."Shipment Method Code" <> '' THEN
                ShipmentMethod.GET(PurchHeader."Shipment Method Code");
            //20.08.2013 EDMS P8 <<

            AssignItemChargePurch.InsertItemChargeAssgnt(
              ItemChargeAssgntPurch, AplDocType,
              AplDocNo, AplLineNo, AplItemNo, PurchLine.Description, NextNo);
            AssignItemChargePurch.SuggestAssgnt2(PurchLine, PurchLine.Quantity, ItemChargeAssgntPurch."Amount to Assign", 1);
            CLEAR(AssignItemChargePurch);
        END;
    end;

    [Scope('Internal')]
    procedure CreateServJnlLine(var SalesHeader: Record "36"; var SalesLine: Record "37"; var TempSalesLine: Record "37"; GenJnlLineDocNo: Code[20]; GenJnlLineDocType: Integer; GenJnlLineExtDocNo: Code[20]; SrcCode: Code[10])
    var
        ServJnlLine: Record "25006165";
        ServJnlPostLine: Codeunit "25006107";
        PostedServOrderLineEDMS: Record "25006150";
        PostedReturnServOrderLineEDMS: Record "25006155";
        ServicePostEDMS: Codeunit "25006101";
    begin
        //10.05.2014 EB.P8 EDMS >>
        IF (SalesHeader."Document Profile" = SalesHeader."Document Profile"::Service) AND IsServiceLine(TempSalesLine) THEN BEGIN
            ServJnlLine.INIT;
            ServJnlLine."Posting Date" := SalesHeader."Posting Date";
            ServJnlLine."Document Date" := SalesHeader."Document Date";
            ServJnlLine."Document Type" := TempSalesLine."Document Type";

            ServJnlLine."Vehicle Serial No." := SalesHeader."Vehicle Serial No.";
            ServJnlLine."Make Code" := SalesHeader."Make Code";
            ServJnlLine."Model Code" := SalesHeader."Model Code";
            ServJnlLine."Model Version No." := SalesHeader."Model Version No.";
            ServJnlLine."Vehicle Accounting Cycle No." := SalesHeader."Vehicle Accounting Cycle No.";
            ServJnlLine."Accountability Center" := "Accountability Center"; //UPG
            ServJnlLine."Responsibility Center" := TempSalesLine."Responsibility Center";
            ServJnlLine.Description := TempSalesLine.Description;
            ServJnlLine."Description 2" := TempSalesLine."Description 2"; //UPG
            ServJnlLine."Job No." := TempSalesLine."Job No.";
            ServJnlLine."Unit of Measure Code" := TempSalesLine."Unit of Measure Code";
            ServJnlLine."Shortcut Dimension 1 Code" := TempSalesLine."Shortcut Dimension 1 Code";
            ServJnlLine."Shortcut Dimension 2 Code" := TempSalesLine."Shortcut Dimension 2 Code";
            ServJnlLine."Dimension Set ID" := TempSalesLine."Dimension Set ID";
            ServJnlLine."Gen. Bus. Posting Group" := TempSalesLine."Gen. Bus. Posting Group";
            ServJnlLine."Gen. Prod. Posting Group" := TempSalesLine."Gen. Prod. Posting Group";
            ServJnlLine."Entry Type" := ServJnlLine."Entry Type"::Sale;
            ServJnlLine."Pre-Assigned No." := TempSalesLine."Document No.";
            ServJnlLine."Document No." := GenJnlLineDocNo;
            ServJnlLine."Document Line No." := TempSalesLine."Line No.";                                              // 10.05.2014 Elva Baltic P21
            ServJnlLine."Service Order No." := "Service Order No. EDMS";
            ServJnlLine."Warranty Claim No." := SalesHeader."Warranty Claim No.";
            ServJnlLine."External Document No." := GenJnlLineExtDocNo;
            ServJnlLine."Unit Cost" := TempSalesLine."Unit Cost (LCY)";
            IF NOT SalesHeader."Prices Including VAT" THEN BEGIN
                ServJnlLine."Line Discount Amount" := TempSalesLine."Line Discount Amount";
                ServJnlLine."Inv. Discount Amount" := TempSalesLine."Inv. Discount Amount";
                ServJnlLine."Unit Price" := TempSalesLine."Unit Price";
                ServJnlLine."Line Discount Amount (LCY)" := SalesLine."Line Discount Amount";
                ServJnlLine."Inv. Discount Amount (LCY)" := SalesLine."Inv. Discount Amount";
            END ELSE BEGIN
                ServJnlLine."Line Discount Amount" := ROUND(TempSalesLine."Line Discount Amount" / (1 + SalesLine."VAT %" / 100));
                ServJnlLine."Inv. Discount Amount" := ROUND(TempSalesLine."Inv. Discount Amount" / (1 + SalesLine."VAT %" / 100));
                ServJnlLine."Unit Price" := ROUND(SalesLine."Unit Price" / (1 + SalesLine."VAT %" / 100));
                ServJnlLine."Line Discount Amount (LCY)" := ROUND(SalesLine."Line Discount Amount" / (1 + SalesLine."VAT %" / 100));
                ServJnlLine."Inv. Discount Amount (LCY)" := ROUND(SalesLine."Inv. Discount Amount" / (1 + SalesLine."VAT %" / 100));
            END;
            IF TempSalesLine."Document Type" = TempSalesLine."Document Type"::Invoice THEN BEGIN
                ServJnlLine.Amount := -TempSalesLine.Amount;
                ServJnlLine."Amount Including VAT" := -TempSalesLine."Amount Including VAT";
                ServJnlLine."Amount (LCY)" := -TempSalesLine.Amount; //SalesLine.Amount; //Sales Line Amount is transferred to amount in LCY
                ServJnlLine."Amount Including VAT (LCY)" := -TempSalesLine."Amount Including VAT";//SalesLine."Amount Including VAT";
                ServJnlLine."Line Discount Amount" := -ServJnlLine."Line Discount Amount";
                ServJnlLine."Inv. Discount Amount" := -ServJnlLine."Inv. Discount Amount";
                ServJnlLine.Quantity := TempSalesLine."Qty. to Invoice";
                ServJnlLine."Total Cost" := TempSalesLine."Unit Cost (LCY)" * ServJnlLine.Quantity;
                //12.05.2015 EB.P30 #T030 >>
                IF PostedServOrderLineEDMS.GET("Service Order No. EDMS", TempSalesLine."Service Order Line No. EDMS") THEN
                    ServJnlLine."Quantity (Hours)" := -PostedServOrderLineEDMS."Quantity (Hours)";
                //12.05.2015 EB.P30 #T030 <<
            END ELSE BEGIN
                ServJnlLine.Amount := TempSalesLine.Amount;
                ServJnlLine."Amount Including VAT" := TempSalesLine."Amount Including VAT";
                ServJnlLine."Amount (LCY)" := SalesLine.Amount; //Sales Line Amount is transferred to amount in LCY
                ServJnlLine."Amount Including VAT (LCY)" := SalesLine."Amount Including VAT";
                ServJnlLine.Quantity := -TempSalesLine."Return Qty. to Receive"; //"Qty. to Invoice";
                ServJnlLine."Total Cost" := -TempSalesLine."Unit Cost (LCY)" * ServJnlLine.Quantity;
                IF SalesHeader.Invoice THEN //>> MIN 10/4/2019 -- for sales return at invoice
                    ServJnlLine.Quantity := -TempSalesLine."Qty. to Invoice";
                //12.05.2015 EB.P30 #T030 >>
                IF PostedReturnServOrderLineEDMS.GET("Service Order No. EDMS", TempSalesLine."Service Order Line No. EDMS") THEN
                    ServJnlLine."Quantity (Hours)" := PostedReturnServOrderLineEDMS."Quantity (Hours)";
                //12.05.2015 EB.P30 #T030 <<
            END;
            ServJnlLine."Currency Code" := TempSalesLine."Currency Code";
            ServJnlLine."Source Code" := SrcCode;
            ServJnlLine.Type := "Line Type";
            //MESSAGE('Line type: '+ FORMAT("Line Type"));
            //MESSAGE('Jnl Type: '+FORMAT(ServJnlLine.Type));
            IF SalesLine.Type = TempSalesLine.Type::"G/L Account" THEN BEGIN
                IF "Order Line Type No." = '' THEN
                    ServJnlLine."No." := TempSalesLine."No."
                ELSE
                    ServJnlLine."No." := "Order Line Type No.";
            END ELSE
                ServJnlLine."No." := TempSalesLine."No.";

            ServJnlLine."Customer No." := TempSalesLine."Sell-to Customer No.";
            ServJnlLine."Bill-to Customer No." := TempSalesLine."Bill-to Customer No.";
            ServJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
            ServJnlLine."Location Code" := TempSalesLine."Location Code";
            ServJnlLine."Discount %" := TempSalesLine."Line Discount %";
            ServJnlLine."Payment Method Code" := SalesHeader."Payment Method Code";


            //SS1.00
            ServJnlLine."Scheme Code" := SalesHeader."Scheme Code";
            ServJnlLine."Membership No." := SalesHeader."Membership No.";
            //SS1.00
            //02.25.2012 Sipradi-YS BEGIN
            ServJnlLine."Job Type" := "Job Type";
            //02.25.2012 Sipradi-YS END

            //Agile CPJB 24/05/2016
            ServJnlLine."Job Category" := SalesHeader."Job Category";
            ServJnlLine."Service Type" := SalesHeader."Service Type";
            ServJnlLine."Job Type (Service Header)" := SalesHeader."Job Type (Before Posting)";
            //Agile CPJB 24/05/2016

            ServJnlLine."Variable Field Run 2" := SalesHeader."Variable Field Run 2";
            ServJnlLine."Variable Field Run 3" := SalesHeader."Variable Field Run 3";
            ServJnlLine."Package No." := "Package No.";
            ServJnlLine."Package Version No." := "Package Version No.";
            ServJnlLine."Package Version Spec. Line No." := "Package Version Spec. Line No.";
            ServJnlLine."Deal Type Code" := "Deal Type Code";
            ServJnlLine."Standard Time" := "Standard Time";
            ServJnlLine."Campaign No." := "Campaign No.";
            //30.07.2015 EB.P30 #T045 >>
            ServJnlLine."Service Receiver" := SalesHeader."Salesperson Code";
            //30.07.2015 EB.P30 #T045 <<
            FillServJournalVariableFields(ServJnlLine, TempSalesLine);
            ServJnlLine.Kilometrage := SalesHeader.Kilometrage;
            ServJnlLine."Service Order No." := SalesHeader."Service Document No.";
            //28.05.2015 EB.P30 #T030 >>
            //20.07.2016 EB.P7 #AMStoDMS Address >>
            ServJnlLine."Service Address Code" := SalesHeader."Ship-to Code";
            ServJnlLine."Service Address" := SalesHeader."Ship-to Address";
            //20.07.2016 EB.P7 #AMStoDMS Address <<
            IF ServJnlLine."Document Type" = ServJnlLine."Document Type"::Invoice THEN
                ServicePostEDMS.FillDetServJnlByResource(ServJnlLine, 1,
                  ServJnlLine."Service Order No.", TempSalesLine."Service Order Line No. EDMS", '111')  //08.04.2013 EDMS P8
            ELSE
                ServicePostEDMS.FillDetServJnlByResource(ServJnlLine, 2,
                  ServJnlLine."Service Order No.", TempSalesLine."Service Order Line No. EDMS", '111');  //08.04.2013 EDMS P8
                                                                                                         //28.05.2015 EB.P30 #T030 <<

            ServJnlPostLine.RunWithCheck(ServJnlLine);//30.10.2012 EDMS
            UpdatePostedServHeader(SalesHeader."Service Document No."); //Sipradi-YS 10.17.2012

        END;
        //10.05.2014 EB.P8 EDMS <<
        //EDMS1.0.00 <<

        ServicePostEDMS.ClearDetServJnlOfLine(ServJnlLine); //20.03.2013 EDMS
    end;

    [Scope('Internal')]
    procedure IsServiceLine(var SalesLine: Record "37"): Boolean
    var
        GLAccount: Record "15";
    begin
        //03.11.2014 EB.P8 #Exxx EDMS
        //Function to detect whether this sales line must got Service Ledger Entries
        IF SalesLine."Line Type" = SalesLine."Line Type"::" " THEN
            EXIT(FALSE);
        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure FillServJournalVariableFields(var ServJournalLine: Record "25006165"; SalesLine: Record "37")
    var
        VariableFieldUsage: Record "25006006";
        VariableFieldUsage2: Record "25006006";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        RecordRef.OPEN(DATABASE::"Sales Line");
        RecordRef.GETTABLE(SalesLine);
        RecordRef2.OPEN(DATABASE::"Serv. Journal Line");
        RecordRef2.GETTABLE(ServJournalLine);

        VariableFieldUsage.RESET;
        VariableFieldUsage.SETRANGE("Table No.", DATABASE::"Sales Line");
        IF VariableFieldUsage.FINDFIRST THEN
            REPEAT
                VariableFieldUsage2.RESET;
                VariableFieldUsage2.SETRANGE("Table No.", DATABASE::"Serv. Journal Line");
                VariableFieldUsage2.SETRANGE("Variable Field Code", VariableFieldUsage."Variable Field Code");
                IF VariableFieldUsage2.FINDFIRST THEN BEGIN
                    FieldRef := RecordRef.FIELD(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.FIELD(VariableFieldUsage2."Field No.");
                    FieldRef2.VALUE(FieldRef.VALUE);
                END;
            UNTIL VariableFieldUsage.NEXT = 0;
        RecordRef2.SETTABLE(ServJournalLine);
    end;

    [Scope('Internal')]
    procedure VehicleSetSalesDate(SalesHeaderPar: Record "36"; SalesLinePar: Record "37")
    var
        VehicleLoc: Record "25006005";
    begin
        IF SalesLinePar.FINDFIRST THEN
            REPEAT
                IF VehicleLoc.GET(SalesLinePar."Vehicle Serial No.") THEN
                    IF VehicleLoc."Sales Date" = 0D THEN BEGIN
                        VehicleLoc.VALIDATE("Sales Date", SalesHeaderPar."Document Date");
                        VehicleLoc.MODIFY(TRUE);
                    END;
            UNTIL SalesLinePar.NEXT = 0;
    end;

    local procedure UpdateVehicleInHeader(var SalesHeader: Record "36")
    var
        SalesLine: Record "37";
        SalesLineTmp: Record "37" temporary;
        isFound: Boolean;
    begin
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
        SalesLine.SETFILTER("Vehicle Serial No.", '<>%1', '');

        IF SalesLine.FINDFIRST THEN BEGIN
            SalesLineTmp.INIT;
            SalesLineTmp.TRANSFERFIELDS(SalesLine);
            REPEAT
                IF SalesLine."Vehicle Serial No." <> SalesLineTmp."Vehicle Serial No." THEN
                    isFound := TRUE;
            UNTIL SalesLine.NEXT = 0;
            IF isFound THEN BEGIN
                SalesHeader.VIN := '';
                SalesHeader."Vehicle Serial No." := '';
                SalesHeader."Vehicle Accounting Cycle No." := '';
            END ELSE BEGIN
                SalesHeader.VIN := SalesLineTmp.VIN;
                SalesHeader."Vehicle Serial No." := SalesLineTmp."Vehicle Serial No.";
                SalesHeader."Vehicle Accounting Cycle No." := SalesLineTmp."Vehicle Accounting Cycle No.";
            END;
            SalesHeader.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure DeleteVehReservEntries(SalesHeader: Record "36")
    var
        ReservEntry: Record "25006392";
        ReservMgt: Codeunit "25006300";
        SalesLine: Record "37";
    begin
        ReservEntry.SETCURRENTKEY(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name");
        ReservEntry.SETRANGE("Source ID", SalesHeader."No.");
        ReservEntry.SETRANGE("Source Type", DATABASE::"Sales Line");
        ReservEntry.SETRANGE("Source Subtype", SalesHeader."Document Type");
        ReservEntry.SETRANGE("Source Batch Name", '');
        IF ReservEntry.ISEMPTY THEN
            EXIT;

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
        SalesLine.SETRANGE("Document No.", SalesHeader."No.");

        IF SalesLine.FINDSET THEN
            REPEAT
                IF (SalesLine.Quantity <> 0) AND
                   (SalesLine.Type = SalesLine.Type::Item) AND
                   (SalesLine."Line Type" = SalesLine."Line Type"::Vehicle)
                THEN BEGIN
                    ReservMgt.SetSalesLine(SalesLine);
                    ReservMgt.DeleteReservEntries(TRUE);
                END;
            UNTIL SalesLine.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure UpdatePostedServHeader(DocNo: Code[20])
    var
        PostedServHeader: Record "25006149";
    begin
        PostedServHeader.RESET;
        PostedServHeader.SETCURRENTKEY("Order No.");
        PostedServHeader.SETRANGE("Order No.", DocNo);
        IF PostedServHeader.FINDFIRST THEN BEGIN
            PostedServHeader."Is Invoiced" := TRUE;
            PostedServHeader.MODIFY;
        END;
    end;
}


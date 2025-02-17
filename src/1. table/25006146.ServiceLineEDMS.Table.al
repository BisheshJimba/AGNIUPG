table 25006146 "Service Line EDMS"
{
    // 05.07.2016 EB.P7 #PAR28
    //   "No." OnLookup() trigger code moved to page
    //   "No." OnValidate trigger modified
    // 
    // 30.05.2016 EB.P7 #PAR28
    //   Added field:
    //     25006998Has Replacement
    // 
    // 12.05.2016 EB.P30 GH
    //   Modified procedure:
    //     UpdateAmounts
    // 
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified ItemAvailability(), Usert Profile Setup to Branch Profile Setup
    // 
    // 12.05.2015 EB.P30 #T030
    //   Added fields:
    //     "Res. Cost Amount Finished"
    //     "Res. Cost Amount Remaining"
    //     "Res. Cost Amount Total"
    // 
    // 16.03.2015 EDMS P21
    //   Modified triggers:
    //     No. - OnValidate
    // 
    // 10.03.2015 EDMS P21
    //   Modified procedures:
    //     CreateDim
    //     CallCreateDim
    //   Modified trigger:
    //     Location Code - OnValidate
    // 
    // 25.02.2015 EDMS P21
    //   Modified TableRelation property for field:
    //     5407 "Unit of Measure Code"
    //   Modified trigger:
    //     Standard Time - OnValidate
    // 
    // 26.01.2015 EB.P7 E0060 MMG7.00
    //   Modified "VAT Prod Posting Group" field tirgger
    // 
    // 12.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified trigger:
    //     OnDelete()     (For Return Order need to Delete Allocation too)
    // 
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified trigger:
    //     No. - OnValidate()
    // 
    // 14.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified procedure:
    //     TestStatusOpen
    //   Modified triggers:
    //     OnDelete()
    //     Location Code - OnValidate()
    //     Gen. Prod. Posting Group - OnValidate()
    //     Variant Code - OnValidate()
    //     Unit of Measure Code - OnValidate()
    //     Model Code - OnValidate()
    //     Make Code - OnValidate()
    //     VIN - OnValidate()
    // 
    // 04.04.2014 Elva Baltic P15 # MMG7.00
    //  * Added Description filling with the "Service Labor Translation".Description
    // 
    // 03.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     Quantity - OnValidate()
    // 
    // 01.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     No. - OnValidate()
    // 
    // 31.03.2014 Elva Baltic P18 MMG7.00
    //   Added Functions
    //     LookupShortcutDimCode()
    //     ShowShortcutDimCode()
    //   Corrected Function "ValidateShortcutDimCode()"
    // 
    // 31.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     5811 Appl.-from Item Entry
    //   Added function:
    //     CheckApplFromItemLedgEntry
    //   Modified function:
    //     SelectItemEntry
    // 
    // 28.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added function:
    //     DeleteAssignedTransfLine
    // 
    // 19.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added function:
    //     ItemIsMaterial
    //   Added Code to function:
    //      GetReservationColor
    // 
    // 11.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added functions:
    //     GetReservationColor
    //     FilterTransferRes
    // 
    // 25.10.2013 EDMS P8
    //   * Added use of new Vehicle dimetnsion

    Caption = 'Service Line EDMS';
    DrillDownPageID = 25006076;
    LookupPageID = 25006076;
    PasteIsValid = false;
    Permissions = TableData 33020238 = rimd;

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Return Order,Booking';
            OptionMembers = Quote,"Order","Return Order",Booking;
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Service Header EDMS".No. WHERE(Document Type=FIELD(Document Type));
        }
        field(4;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(5;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Labor,External Service';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service";

            trigger OnValidate()
            var
                ServiceHeader: Record "25006145";
                recMarkup: Record "25006741";
                recItemDisc: Record "7004";
                recLabTransl: Record "25006127";
                recItemTransl: Record "30";
            begin
                CanChangeExtService;
                TestStatusOpen;

                GetServiceHeader;

                TESTFIELD("Prepmt. Amt. Inv.",0);  //08-05-2007 EDMS P3 PREPMT

                IF Type <> xRec.Type THEN BEGIN
                  IF Quantity <> 0 THEN BEGIN
                    CALCFIELDS("Reserved Qty. (Base)");
                    TESTFIELD("Reserved Qty. (Base)",0);
                    ReserveServiceLine.VerifyChange(Rec,xRec);
                  END;
                END;

                TempServLine := Rec;
                INIT;
                Type := TempServLine.Type;
                "System-Created Entry" := TempServLine."System-Created Entry";
                "Make Code" := TempServLine."Make Code";
                Group := TempServLine.Group;
                "Group ID" := TempServLine."Group ID";
                VIN := TempServLine.VIN;
            end;
        }
        field(6;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type=CONST(" ")) "Standard Text"
                            ELSE IF (Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST(Labor)) "Service Labor"
                            ELSE IF (Type=CONST(External Service)) "External Service";

            trigger OnLookup()
            var
                Item: Record "27";
                Labor: Record "25006121";
                ExternalService: Record "25006133";
                GLAccount: Record "15";
                ServiceHeader: Record "25006145";
                StandardText: Record "7";
                ModelFilter: Text[1024];
                ItemVehicleModel: Record "25006755";
                ModelWiseItem: Boolean;
            begin
                
                ServiceHeader.GET("Document Type","Document No.");
                
                CASE Type OF
                 Type::" ":
                  BEGIN
                   StandardText.RESET;
                   IF LookUpMgt.LookUpStandardText(StandardText,"No.") THEN
                    VALIDATE("No.",StandardText.Code);
                  END;
                
                 Type::"G/L Account":
                  BEGIN
                   GLAccount.RESET;
                   IF LookUpMgt.LookUpGLAccount(GLAccount,"No.") THEN
                    VALIDATE("No.",GLAccount."No.");
                  END;
                
                 Type::Item:
                  BEGIN
                
                   Item.RESET;
                   //Sipradi-YS * Code to filter spare model wise.
                   Item.SETFILTER("Model Filter 1",'%1','*'+ServiceHeader."Model Code"+'*');
                   /*
                   ModelWiseItem := FALSE;
                   ItemVehicleModel.RESET;
                   ItemVehicleModel.SETCURRENTKEY(Type,"Make Code","Model No.");
                   ItemVehicleModel.SETRANGE(Type,ItemVehicleModel.Type::Item);
                   ItemVehicleModel.SETRANGE("Make Code",ServiceHeader."Make Code");
                   //ItemVehicleModel.SETRANGE("Model No.",ServiceHeader."Model Code");
                   IF ItemVehicleModel.FINDSET THEN BEGIN
                    REPEAT
                     IF Item.GET(ItemVehicleModel."No.") THEN BEGIN
                      Item.MARK(TRUE);
                      ModelWiseItem := TRUE;
                     END;
                    UNTIL ItemVehicleModel.NEXT=0;
                   END;
                   IF ModelWiseItem THEN
                     Item.MARKEDONLY(TRUE);
                   */
                   //Sipradi-YS End
                   IF LookUpMgt.LookUpItemREZ(Item,"No.") THEN
                    VALIDATE("No.",Item."No.");
                   END;
                
                 Type::Labor:
                  BEGIN
                   Labor.RESET;
                   Labor.SETCURRENTKEY("Make Code");
                   Labor.SETFILTER("Make Code",'%1|''''',ServiceHeader."Make Code");
                   Labor.SETFILTER("Model Code",'%1|''''',ServiceHeader."Model Code");// Sipradi-YS * Filtering V.Model Labors Only
                   //Labor.SETFILTER("Model Version No.",'%1''''',ServiceHeader."Model Version No.");//Agni SM
                   //Labor.SETFILTER("No.",'<>%1','BSL*');
                   Labor.SETRANGE(Blocked,FALSE);
                   IF LookUpMgt.LookUpLabor(Labor,"No.") THEN
                    VALIDATE("No.",Labor."No.");
                  END;
                
                //****SM filtering ext. service as per acc. center
                 Type::"External Service":
                  BEGIN
                    ExternalService.RESET;
                    IF (ServiceHeader."Accountability Center" = 'BID') OR (ServiceHeader."Accountability Center" = 'BRR') THEN
                       ExternalService.SETRANGE("Accountability Center",'BID')
                    ELSE BEGIN
                       ExternalService.SETRANGE("Accountability Center",ServiceHeader."Accountability Center");
                    END;
                    IF LookUpMgt.LookUpExternalService(ExternalService,"No.") THEN
                     VALIDATE("No.",ExternalService."No.");
                   END;
                END;
                //****SM filtering ext. service as per acc. center

            end;

            trigger OnValidate()
            var
                Markup: Record "25006741";
                ItemDisc: Record "7004";
                LabTransl: Record "25006127";
                ItemTransl: Record "30";
                VariableFieldUsage: Record "25006006";
                NewItemNo: Code[20];
                PrepaymentMgt: Codeunit "441";
                ItemSubstSync: Codeunit "25006513";
            begin
                CanChangeExtService;
                ValidateLocalParts;
                TESTFIELD("Warranty Approved",FALSE);
                TestStatusOpen;
                GetServiceHeader;
                FindSameItemOnJob;
                IF (xRec."No." <> "No.") AND (Quantity <> 0) THEN BEGIN
                  CALCFIELDS("Reserved Qty. (Base)");
                  TESTFIELD("Reserved Qty. (Base)",0);
                END;
                
                NewItemNo := "No.";
                "No." := xRec."No.";
                TESTFIELD("Prepmt. Amt. Inv.",0); //08-05-2007 EDMS P3 PREPMT
                
                "No." := NewItemNo;
                
                TempServLine := Rec;
                INIT;
                Type := TempServLine.Type;
                "No." := TempServLine."No.";
                
                "Make Code" := TempServLine."Make Code";
                Group := TempServLine.Group;
                "Group ID" := TempServLine."Group ID";
                VIN := TempServLine.VIN;
                "Package No." := TempServLine."Package No.";
                "Package Version No." := TempServLine."Package Version No.";
                "Package Version Spec. Line No." := TempServLine."Package Version Spec. Line No.";
                "Contract No." := TempServLine."Contract No.";
                "System-Created Entry" := TempServLine."System-Created Entry";
                "Standard Time" := TempServLine."Standard Time";                                      // 01.04.2014 Elva Baltic P21
                "Standard Time Line No." := TempServLine."Standard Time Line No.";                    // 01.04.2014 Elva Baltic P21
                
                IF "No." = '' THEN EXIT;
                
                "Line Discount %" := TempServLine."Line Discount %";
                
                "Gen. Bus. Posting Group" := ServiceHeader."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := ServiceHeader."VAT Bus. Posting Group";
                "Location Code" := ServiceHeader."Location Code";
                //"Planned Service Date" := ServiceHeader."Planned Service Date";
                "Planned Service Date" := TODAY;
                
                "Tax Area Code" := ServiceHeader."Tax Area Code";
                "Tax Liable" := ServiceHeader."Tax Liable";
                //08-05-2007 EDMS P3 PREPMT >>
                IF NOT "System-Created Entry" AND ("Document Type" = "Document Type"::Order)  AND (Type <> Type::" ") THEN
                  "Prepayment %" := ServiceHeader."Prepayment %";
                "Prepayment Tax Area Code" := ServiceHeader."Tax Area Code";
                "Prepayment Tax Liable" := ServiceHeader."Tax Liable";
                //08-05-2007 EDMS P3 PREPMT <<
                
                "Responsibility Center" := ServiceHeader."Responsibility Center";
                "Accountability Center" := ServiceHeader."Accountability Center";
                IF ServiceHeader."Document Type" = ServiceHeader."Document Type"::Quote THEN BEGIN
                  IF (ServiceHeader."Sell-to Customer No." = '') AND
                     (ServiceHeader."Sell-to Customer Template Code" = '')
                  THEN
                    ERROR(
                      Text031,
                      ServiceHeader.FIELDCAPTION("Sell-to Customer No."),
                      ServiceHeader.FIELDCAPTION("Sell-to Customer Template Code"));
                  IF (ServiceHeader."Bill-to Customer No." = '') AND
                     (ServiceHeader."Bill-to Customer Template Code" = '')
                  THEN
                    ERROR(
                      Text031,
                      ServiceHeader.FIELDCAPTION("Bill-to Customer No."),
                      ServiceHeader.FIELDCAPTION("Bill-to Customer Template Code"));
                END ELSE
                  ServiceHeader.TESTFIELD("Sell-to Customer No.");
                
                
                "Sell-to Customer No.":=ServiceHeader."Sell-to Customer No.";
                "Bill-to Customer No.":=ServiceHeader."Bill-to Customer No.";
                
                "Customer Price Group" := ServiceHeader."Customer Price Group";
                "Customer Disc. Group" := ServiceHeader."Customer Disc. Group";
                "Allow Line Disc." := ServiceHeader."Allow Line Disc.";
                "Currency Code" := ServiceHeader."Currency Code";
                "Vehicle Serial No." := ServiceHeader."Vehicle Serial No.";
                "Make Code" := ServiceHeader."Make Code";                                         // 16.03.2015 EDMS P21
                "Vehicle Accounting Cycle No." := ServiceHeader."Vehicle Accounting Cycle No.";   // 16.03.2015 EDMS P21
                "Job Category" :=  ServiceHeader."Job Category"; //Agile CPJB 24May2016
                "Contract No." := ServiceHeader."Contract No.";                                   // 15.04.2014 Elva Baltic P21
                
                CASE Type OF
                 Type::" ":
                  BEGIN
                   StdTxt.GET("No.");
                   Description := StdTxt.Description;
                  END;
                
                 Type::"G/L Account":
                  BEGIN
                   GLAcc.GET("No.");
                   GLAcc.CheckGLAcc;
                   GLAcc.TESTFIELD("Direct Posting",TRUE);
                   Description := GLAcc.Name;
                
                   "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                   "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
                  END;
                
                 Type::Item:
                  BEGIN
                   GetItem;
                   Item.TESTFIELD(Blocked,FALSE);
                   Item.TESTFIELD("Inventory Posting Group");
                   Item.TESTFIELD("Gen. Prod. Posting Group");
                   IF ItemTransl.GET("No.","Variant Code",ServiceHeader."Language Code") THEN
                    BEGIN
                     Description := ItemTransl.Description;
                     "Description 2" := ItemTransl."Description 2";
                    END
                   ELSE
                    BEGIN
                     Description := Item.Description;
                     "Description 2" := Item."Description 2";
                    END;
                
                   GetUnitCost;
                   "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                   "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
                
                   "Item Category Code" := Item."Item Category Code";
                   "Product Group Code" := Item."Product Group Code";
                   "Product Subgroup Code" := Item."Product Subgroup Code";
                   Nonstock := Item."Created From Nonstock Item";
                   "Unit of Measure Code" := Item."Sales Unit of Measure";
                   "Profit %" := Item."Profit %";
                 InventorySet.GET;
                      "HS Code" := COPYSTR(Item."Tariff No.", 1, InventorySet."HS Code Prefix Length");
                
                   //PrepaymentMgt.SetServPrepaymentPct(Rec,ServiceHeader."Posting Date");
                
                   ServiceSetup.GET;
                   "Ordering Price Type Code" := ServiceSetup."Def. Ordering Price Type Code";
                
                   IF ServiceHeader."Language Code" <> '' THEN
                     GetItemTranslation;
                
                   //06.02.2009 Elva DMS P1 >>
                    IF ServiceSetup."Item No. Replacement Warnings" THEN
                     IF Item."Item Type" = Item."Item Type"::Item THEN
                      ItemSubstitutionMgt.CheckReplacements("No.");
                   //06.02.2009 Elva DMS P1 <<
                
                   ServiceHeader.TESTFIELD("Order Date");
                   IF ServiceSetup."Cust. Price Group Mandatory" THEN
                     ServiceHeader.TESTFIELD("Customer Price Group");
                   //22.03.2014 Elva Baltic P1 #RX MMG7.00 - commented>>
                   //IF ServiceSetup."Payment Method Mandatory" THEN
                   //  ServiceHeader.TESTFIELD("Payment Method Code");
                   //22.03.2014 Elva Baltic P1 #RX MMG7.00 <<
                   IF ServiceSetup."Make and Model Mandatory" THEN
                     ServiceHeader.TESTFIELD(ServiceHeader."Make Code");
                
                   IF Item.Reserve = Item.Reserve::Optional THEN
                     Reserve := ServiceHeader.Reserve
                   ELSE
                     Reserve := Item.Reserve;
                
                  END;
                
                 Type::Labor:
                  BEGIN
                   Labor.GET("No.");
                   Labor.TESTFIELD(Blocked,FALSE);
                   Labor.TESTFIELD("Gen. Prod. Posting Group");
                   Labor.TESTFIELD("VAT Prod. Posting Group");
                   "Unit Cost" := Labor."Unit Cost";
                   "Unit Cost (LCY)" := Labor."Unit Cost";
                   Description := Labor.Description;
                   "Description 2" := Labor."Description 2";
                
                   // 04.04.2014 Elva Baltic P15 # MMG7.00 >>
                   ////18.02.2010 EDMSB P2>>
                   ////Get description from Service Labor Text
                   //GetDescriptionFromLaborText("No.", ServiceHeader."Vehicle Serial No.");
                   ////18.02.2010 EDMSB P2 <<
                   /*
                   IF LabTransl.GET("No.",ServiceHeader."Language Code") THEN BEGIN
                     Description := LabTransl.Description;
                     "Description 2" := LabTransl."Description 2";
                   END ELSE BEGIN
                     ServiceSetup.GET;
                     ServiceSetup.TESTFIELD("Def. Translation Language Code");
                     IF LabTransl.GET("No.", ServiceSetup."Def. Translation Language Code") THEN BEGIN
                       Description :=  LabTransl.Description;
                       "Description 2" := LabTransl."Description 2";
                     END;
                   END;
                   */
                   // 04.04.2014 Elva Baltic P15 # MMG7.00 <<
                
                   "Unit of Measure Code" := Labor."Unit of Measure Code";
                   "Gen. Prod. Posting Group" := Labor."Gen. Prod. Posting Group";
                   "VAT Prod. Posting Group" := Labor."VAT Prod. Posting Group";
                
                   //Finding standard time
                   IF NOT(Recreate) AND ("Package No." = '') AND ("Standard Time" = 0) THEN
                    GetStandardTime;
                
                   //29.08.2007. EDMS P2 >>
                   ServiceSetup.GET;
                   IF NOT ServiceSetup."Quantity Equals Standard Time" THEN
                     VALIDATE(Quantity, 1);
                   //29.08.2007. EDMS P2 <<
                  END;
                
                 Type::"External Service":
                  BEGIN
                   ExtServ.GET("No.");
                   ExtServ.TESTFIELD(Blocked,FALSE);
                   ExtServ.TESTFIELD("Gen. Prod. Posting Group");
                   ExtServ.TESTFIELD("VAT Prod. Posting Group");
                   ExtServ.TESTFIELD("Internal Service",FALSE);
                   Description := ExtServ.Description;
                   "Description 2" := ExtServ."Description 2";
                   "Unit of Measure Code" := ExtServ."Unit of Measure Code";
                   "Gen. Prod. Posting Group" := ExtServ."Gen. Prod. Posting Group";
                   "VAT Prod. Posting Group" := ExtServ."VAT Prod. Posting Group";
                
                   //03.07.2008. EDMS P2 >>
                   "Unit of Measure Code" := ExtServ."Unit of Measure Code";
                   //03.07.2008. EDMS P2 >>
                
                  END;
                END;
                
                VALIDATE("Prepayment %");  //08-05-2007 EDMS P3 PREPMT
                
                IF Type <> Type::" " THEN BEGIN
                  VALIDATE("VAT Prod. Posting Group");
                  VALIDATE("Unit of Measure Code");
                  IF NOT CheckNonBillableCustomer THEN
                    UpdateUnitPrice(FIELDNO("No."));
                END;
                
                IF "No." <> xRec."No." THEN BEGIN
                  IF Type = Type::Item THEN
                    IF (Quantity <> 0) AND ItemExists(xRec."No.") THEN BEGIN
                      ReserveServiceLine.VerifyChange(Rec,xRec);
                    END;
                END;
                
                CallCreateDim;
                
                GetVehicleVariableFields(ServiceHeader."Vehicle Serial No.");
                
                VALIDATE("Unit of Measure Code");
                
                //prabesh
                IF "No." <> '' THEN
                  schemeDiscount(Rec);

            end;
        }
        field(7;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));

            trigger OnValidate()
            var
                codNewLocationCode: Code[20];
            begin
                TestStatusOpen;                                                                  // 14.04.2014 Elva Baltic P21
                IF "Location Code" <> xRec."Location Code" THEN BEGIN //10.05.2008. EDMS P2
                  codNewLocationCode := "Location Code";
                  "Location Code" := xRec."Location Code";
                  "Location Code" := codNewLocationCode;
                  IF Quantity <> 0 THEN BEGIN
                    ReserveServiceLine.VerifyChange(Rec,xRec);
                  END;
                END;

                IF Type = Type::Item THEN
                  GetUnitCost;

                CallCreateDim;     // 10.03.2015 EDMS P21
            end;
        }
        field(10;"Shipment Date";Date)
        {
            Caption = 'Shipment Date';

            trigger OnValidate()
            var
                CheckDateConflict: Codeunit "99000815";
            begin
                TestStatusOpen;
                //IF CurrFieldNo <> 0 THEN
                  //AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);

                IF "Shipment Date" <> 0D THEN BEGIN
                  IF Reserve <> Reserve::Always THEN
                    IF CurrFieldNo IN [
                                       FIELDNO("Planned Shipment Date"),
                                       FIELDNO("Planned Delivery Date"),
                                       FIELDNO("Shipment Date"),
                                       FIELDNO("Shipping Time"),
                                       FIELDNO("Requested Delivery Date")]
                    THEN
                      CheckItemAvailable(FIELDNO("Shipment Date"));

                  IF ("Shipment Date" < WORKDATE) AND (Type <> Type::" ") THEN
                    IF NOT (HideValidationDialog OR HasBeenShown) AND GUIALLOWED THEN BEGIN
                      MESSAGE(
                        Text014,
                        FIELDCAPTION("Shipment Date"),"Shipment Date",WORKDATE);
                      HasBeenShown := TRUE;
                    END;
                END;

                IF (xRec."Shipment Date" <> "Shipment Date") AND
                   (Quantity <> 0) AND
                   (Reserve <> Reserve::Never) AND
                   NOT StatusCheckSuspended
                THEN
                  CheckDateConflict.ServicLineEDMSCheck(Rec,CurrFieldNo <> 0);

                IF "Shipment Date" <> 0D THEN BEGIN
                  IF NOT PlannedShipmentDateCalculated THEN
                    "Planned Shipment Date" :=
                      CalendarMgmt.CalcDateBOC(
                        FORMAT(
                          '<0D>'),
                        "Shipment Date",
                        CalChange."Source Type"::"Shipping Agent",
                        "Shipping Agent Code",
                        "Shipping Agent Service Code",
                        CalChange."Source Type"::Location,
                        "Location Code",
                        '',
                        TRUE);
                  IF NOT PlannedDeliveryDateCalculated THEN
                    "Planned Delivery Date" :=
                      CalendarMgmt.CalcDateBOC(
                        FORMAT("Shipping Time"),
                        "Planned Shipment Date",
                        CalChange."Source Type"::Customer,
                        "Sell-to Customer No.",
                        '',
                        CalChange."Source Type"::"Shipping Agent",
                        "Shipping Agent Code",
                        "Shipping Agent Service Code",
                        TRUE);
                END;
            end;
        }
        field(11;Description;Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                IF "No." = '' THEN
                 Type := Type::" ";

                IF Type = Type::Item THEN BEGIN
                  IF xRec.Description <> '' THEN
                    ERROR('You cannot change description manually.');
                  END;
            end;
        }
        field(12;"Description 2";Text[50])
        {
            Caption = 'Description 2';
        }
        field(13;"Unit of Measure";Text[10])
        {
            Caption = 'Unit of Measure';

            trigger OnValidate()
            begin
                IF Type = Type::Item THEN
                 IF (xRec."Unit of Measure Code" <> "Unit of Measure Code") AND (Quantity <> 0) THEN
                  //WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
            end;
        }
        field(15;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            var
                TransferLine: Record "5741";
                ItemSubstSync: Codeunit "25006513";
            begin
                ItemSubstSync.ReplaceServiceLineItemNo(Rec);

                TestStatusOpen;
                TESTFIELD("Warranty Approved",FALSE);
                // 03.04.2014 Elva Baltic P21 >>
                IF (Type = Type::Item) AND (Quantity < xRec.Quantity) AND ItemExists("No.") THEN BEGIN
                  IF (Quantity < CalcTransferedQuantity) THEN
                    ERROR(Text125);
                  CALCFIELDS("Reserved Qty. (Base)");
                  IF (Quantity < "Reserved Qty. (Base)") THEN BEGIN
                    ServiceTransferMgt.FindTransferLine(Rec, TransferLine);
                    ERROR(Text126, TransferLine."Document No.");
                  END;
                END;
                // 03.04.2014 Elva Baltic P21 <<

                "Quantity (Base)" := CalcBaseQty(Quantity);


                //Agile_SM 20 Sep 2017 Reservation Mgt
                IF NOT ChangedbySystem THEN BEGIN
                  IF Quantity < xRec.Quantity THEN BEGIN
                    NegReservEntry.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype");
                    NegReservEntry.RESET;
                    NegReservEntry.SETRANGE("Item No.","No.");
                    NegReservEntry.SETRANGE("Source ID","Document No.");
                    NegReservEntry.SETRANGE("Source Ref. No.","Line No.");
                    NegReservEntry.SETRANGE("Source Type",DATABASE::"Service Line");
                    NegReservEntry.SETRANGE("Source Subtype","Document Type");
                    NegReservEntry.SETRANGE(Positive,FALSE);
                    IF NegReservEntry.FINDFIRST THEN REPEAT
                      ReservEntry.RESET;
                      ReservEntry.SETRANGE("Entry No.",NegReservEntry."Entry No.");
                      ReservEntry.SETRANGE(Positive,TRUE);
                      IF ReservEntry.FINDFIRST THEN
                        ERROR(ReservedFromItemLedgEntryErr,"No.");
                    UNTIL NegReservEntry.NEXT = 0;
                  END;
                END;
                //Agile_SM 20 Sep 2017 Reservation Mgt

                CheckSPackage(FIELDNO(Quantity), 0); //02.01.2008 EDMS P3

                IF Type <> Type::" " THEN
                 TESTFIELD("No.");

                IF Reserve <> Reserve::Always THEN
                  CheckItemAvailable(FIELDNO(Quantity));
                IF NOT CheckNonBillableCustomer THEN BEGIN
                  UpdateUnitPrice(FIELDNO(Quantity));
                  UpdateAmounts;
                END;

                IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") THEN
                  InitOutstanding;

                IF Type = Type::Item THEN BEGIN
                  IF NOT CheckNonBillableCustomer THEN
                    UpdateUnitPrice(FIELDNO(Quantity));
                  IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") THEN
                    ReserveServiceLine.VerifyQuantity(Rec,xRec);
                END;

                UpdateQtyHours(FIELDNO(Quantity));

                //SS1.00
                IF ("Document Type" = "Document Type"::Order) OR ("Document Type" = "Document Type"::"Return Order") THEN
                BEGIN
                  //TESTFIELD("Job Type");
                  ServSchemeLine.RESET;
                  ServSchemeLine.SETRANGE(Code,ServiceHeader."Scheme Code");
                  ServSchemeLine.SETRANGE(Type,Type);
                  IF ServSchemeLine.FINDFIRST THEN BEGIN
                     "Membership No." := ServiceHeader."Membership No.";
                     "Scheme Code" := ServiceHeader."Scheme Code";
                     JobTypeMaster.RESET;
                     JobTypeMaster.SETRANGE("No.","Job Type");
                     JobTypeMaster.SETRANGE(Scheme,FALSE);
                     IF JobTypeMaster.FINDFIRST THEN BEGIN
                        VALIDATE("Line Discount %",ServSchemeLine."Discount %");
                     END;
                     MODIFY;
                  END;
                END;
                //SS1.00
            end;
        }
        field(16;"Outstanding Quantity";Decimal)
        {
            Caption = 'Outstanding Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(22;"Unit Price";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
            Caption = 'Unit Price';

            trigger OnValidate()
            var
                Customer: Record "18";
            begin
                TestStatusOpen;
                //IF NOT CheckFixedPrice THEN BEGIN // Sipradi-YS * Code to check fixed Price
                //IF not (CheckNonBillableCustomer) then begin
                CheckSPackage(FIELDNO("Unit Price"), 0); //02.01.2008 EDMS P3
                //end;
                //END;
                VALIDATE("Line Discount %");

                ValidateAmountSanjivani(ServiceHeader);
                Customer.GET("Bill-to Customer No.");
                IF (Customer."Non-Billable") AND ("Unit Price" >0) AND (Type <> Type :: Item) THEN // SM 05/12/2013
                  ERROR(NoValidUnitPrice,"Bill-to Customer No.");


                //IF (CheckNonBillableCustomer) AND (xRec."Unit Price" >0) THEN
                  //ERROR(NoValidUnitPrice,"Bill-to Customer No.");
            end;
        }
        field(23;"Unit Cost (LCY)";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost (LCY)';
            Editable = false;
        }
        field(25;"VAT %";Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(27;"Line Discount %";Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            var
                ServiceHeader: Record "25006145";
            begin
                TestStatusOpen;

                CheckSPackage(FIELDNO("Line Discount %"), 0); //02.01.2008 EDMS P3

                "Line Discount Amount" :=
                  ROUND(
                    ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") *
                    "Line Discount %" / 100,Currency."Amount Rounding Precision");
                "Inv. Discount Amount" := 0;
                "Inv. Disc. Amount to Invoice" := 0;
                UpdateAmounts;
            end;
        }
        field(28;"Line Discount Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Line Discount Amount';

            trigger OnValidate()
            var
                ServiceHeader: Record "25006145";
                decAmount: Decimal;
            begin
                TestStatusOpen;

                CheckSPackage(FIELDNO("Line Discount Amount"), 0); //02.01.2008 EDMS P3

                TESTFIELD(Quantity);
                IF ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") <> 0 THEN
                  "Line Discount %" :=
                    ROUND(
                     "Line Discount Amount" / ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") * 100,
                      0.00001)
                ELSE
                  "Line Discount %" := 0;
                "Inv. Discount Amount" := 0;
                "Inv. Disc. Amount to Invoice" := 0;
                UpdateAmounts;
            end;
        }
        field(29;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;

            trigger OnValidate()
            begin
                TestStatusOpen;
                Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                IF "VAT Calculation Type" IN ["VAT Calculation Type"::"Normal VAT","VAT Calculation Type"::"Reverse Charge VAT"] THEN
                 "Amount Including VAT" := ROUND(Amount + Amount * "VAT %" / 100,Currency."Amount Rounding Precision");
            end;
        }
        field(30;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;

            trigger OnValidate()
            begin
                TestStatusOpen;

                "Amount Including VAT" := ROUND("Amount Including VAT",Currency."Amount Rounding Precision");
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Normal VAT",
                  "VAT Calculation Type"::"Reverse Charge VAT":
                    BEGIN
                      Amount :=
                        ROUND(
                          "Amount Including VAT" /
                          (1 + (1 - ServiceHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                          Currency."Amount Rounding Precision");
                      "VAT Base Amount" :=
                        ROUND(Amount * (1 - ServiceHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                    END;
                  "VAT Calculation Type"::"Full VAT":
                    BEGIN
                      Amount := 0;
                      "VAT Base Amount" := 0;
                    END;
                  "VAT Calculation Type"::"Sales Tax":
                    BEGIN
                      ServiceHeader.TESTFIELD("VAT Base Discount %",0);
                      Amount :=
                        SalesTaxCalculate.ReverseCalculateTax(
                          "Tax Area Code","Tax Group Code","Tax Liable",ServiceHeader."Posting Date",
                          "Amount Including VAT","Quantity (Base)",ServiceHeader."Currency Factor");
                      IF Amount <> 0 THEN
                        "VAT %" :=
                          ROUND(100 * ("Amount Including VAT" - Amount) / Amount,0.00001)
                      ELSE
                        "VAT %" := 0;
                      Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                      "VAT Base Amount" := Amount;
                    END;
                END;
            end;
        }
        field(32;"Allow Invoice Disc.";Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;

            trigger OnValidate()
            begin
                TestStatusOpen;
                IF ("Allow Invoice Disc." <> xRec."Allow Invoice Disc.") AND
                   (NOT "Allow Invoice Disc.")
                THEN BEGIN
                  "Inv. Discount Amount" := 0;
                  "Inv. Disc. Amount to Invoice" := 0;
                  UpdateAmounts;
                END;
            end;
        }
        field(38;"Appl.-to Item Entry";Integer)
        {
            Caption = 'Appl.-to Item Entry';

            trigger OnLookup()
            begin
                SelectItemEntry(FIELDNO("Appl.-to Item Entry"));
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "32";
            begin
                IF "Appl.-to Item Entry" <> 0 THEN BEGIN
                  TESTFIELD(Type,Type::Item);
                  TESTFIELD(Quantity);
                  ItemLedgEntry.GET("Appl.-to Item Entry");
                  ItemLedgEntry.TESTFIELD(Positive,TRUE);
                  ItemLedgEntry.TESTFIELD(Open,TRUE);
                  VALIDATE("Unit Cost (LCY)",CalcUnitCost(ItemLedgEntry));

                  "Location Code" := ItemLedgEntry."Location Code";
                END;
            end;
        }
        field(40;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate()
            begin
                TestStatusOpen;
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(41;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate()
            begin
                TestStatusOpen;
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(42;"Customer Price Group";Code[10])
        {
            Caption = 'Customer Price Group';
            Editable = true;
            TableRelation = "Customer Price Group";
        }
        field(67;"Profit %";Decimal)
        {
            Caption = 'Profit %';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(68;"Bill-to Customer No.";Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer.No.;

            trigger OnValidate()
            begin
                //Sipradi-YS 7.11.2012 Code Added to Check Non-Billable Customer
                //CheckNonBillableCustomer;
                //Quantity := 0;
            end;
        }
        field(69;"Inv. Discount Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Discount Amount';
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Quantity);
                CalcInvDiscToInvoice;
                UpdateAmounts;
            end;
        }
        field(71;"Purchase Order No.";Code[20])
        {
            Caption = 'Purchase Order No.';
            Editable = false;
            TableRelation = IF (Drop Shipment=CONST(Yes)) "Purchase Header".No. WHERE (Document Type=CONST(Order));
        }
        field(72;"Purch. Order Line No.";Integer)
        {
            Caption = 'Purch. Order Line No.';
            Editable = false;
            TableRelation = IF (Drop Shipment=CONST(Yes)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                            Document No.=FIELD(Purchase Order No.));
        }
        field(73;"Drop Shipment";Boolean)
        {
            Caption = 'Drop Shipment';
            Editable = true;
        }
        field(74;"Gen. Bus. Posting Group";Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(75;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                TestStatusOpen;                                                                  // 14.04.2014 Elva Baltic P21
            end;
        }
        field(77;"VAT Calculation Type";Option)
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(80;"Attached to Line No.";Integer)
        {
            Caption = 'Attached to Line No.';
            Editable = false;
            TableRelation = "Service Line EDMS"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                                  Document No.=FIELD(Document No.));
        }
        field(85;"Tax Area Code";Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(86;"Tax Liable";Boolean)
        {
            Caption = 'Tax Liable';

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(87;"Tax Group Code";Code[10])
        {
            Caption = 'Tax Group Code';
            TableRelation = "Tax Group";

            trigger OnValidate()
            begin
                TestStatusOpen;
                UpdateAmounts;
            end;
        }
        field(89;"VAT Bus. Posting Group";Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                TestStatusOpen;
                VALIDATE("VAT Prod. Posting Group");
            end;
        }
        field(90;"VAT Prod. Posting Group";Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            var
                ServiceHeader: Record "25006145";
            begin
                TestStatusOpen;
                GetServiceHeader;
                VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
                "VAT Difference" := 0;
                "VAT %" := VATPostingSetup."VAT %";
                "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                "VAT Identifier" := VATPostingSetup."VAT Identifier";
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Reverse Charge VAT",
                  "VAT Calculation Type"::"Sales Tax":
                    "VAT %" := 0;
                  "VAT Calculation Type"::"Full VAT":
                    BEGIN
                      TESTFIELD(Type,Type::"G/L Account");
                      VATPostingSetup.TESTFIELD("Sales VAT Account");
                      TESTFIELD("No.",VATPostingSetup."Sales VAT Account");
                    END;
                END;

                IF ServiceHeader."Prices Including VAT" AND (Type IN [Type::Item]) THEN
                  "Unit Price" :=
                    ROUND(
                      "Unit Price" * (100 + "VAT %") / (100 + xRec."VAT %"),
                      Currency."Unit-Amount Rounding Precision");

                //26.01.2015 EB.P7 E0060 MMG7.00 >>
                VALIDATE("Unit Price");
                //26.01.2015 EB.P7 E0060 MMG7.00 <<
                VALIDATE("Prepayment %");
            end;
        }
        field(91;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(95;"Reserved Quantity";Decimal)
        {
            CalcFormula = -Sum("Reservation Entry".Quantity WHERE (Source ID=FIELD(Document No.),
                                                                   Source Ref. No.=FIELD(Line No.),
                                                                   Source Type=CONST(25006146),
                                                                   Source Subtype=FIELD(Document Type),
                                                                   Reservation Status=CONST(Reservation)));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(96;Reserve;Option)
        {
            Caption = 'Reserve';
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;

            trigger OnValidate()
            begin
                IF Reserve <> Reserve::Never THEN BEGIN
                  TESTFIELD(Type,Type::Item);
                  TESTFIELD("No.");
                END;
                CALCFIELDS("Reserved Qty. (Base)");
                IF (Reserve = Reserve::Never) AND ("Reserved Qty. (Base)" > 0) THEN
                  TESTFIELD("Reserved Qty. (Base)",0);

                IF xRec.Reserve = Reserve::Always THEN BEGIN
                  GetItem;
                  IF Item.Reserve = Item.Reserve::Always THEN
                    TESTFIELD(Reserve,Reserve::Always);
                END;
            end;
        }
        field(99;"VAT Base Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Base Amount';
            Editable = false;
        }
        field(100;"Unit Cost";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            Editable = false;
        }
        field(101;"System-Created Entry";Boolean)
        {
            Caption = 'System-Created Entry';
            Editable = false;
        }
        field(103;"Line Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Line Amount"));
            Caption = 'Line Amount';

            trigger OnValidate()
            var
                ServHeader: Record "25006145";
            begin
                TESTFIELD(Type);
                TESTFIELD(Quantity);
                TESTFIELD("Unit Price");
                GetServiceHeader;

                "Line Amount" := ROUND("Line Amount",Currency."Amount Rounding Precision");
                VALIDATE(
                  "Line Discount Amount",ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - "Line Amount");
            end;
        }
        field(104;"VAT Difference";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'VAT Difference';
            Editable = false;
        }
        field(105;"Inv. Disc. Amount to Invoice";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Inv. Disc. Amount to Invoice';
            Editable = false;
        }
        field(106;"VAT Identifier";Code[10])
        {
            Caption = 'VAT Identifier';
            Editable = false;
        }
        field(109;"Prepayment %";Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            var
                GenPostingSetup: Record "252";
                GLAcc: Record "15";
                GenLedgSetup: Record "98";
            begin
                IF "Prepayment %" <> 0 THEN BEGIN
                  TESTFIELD("Document Type","Document Type"::Order);
                  TESTFIELD(Type);
                  TESTFIELD("No.");
                  GenLedgSetup.GET;
                  GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
                  IF GenPostingSetup."Service Prepayments Account" <> '' THEN BEGIN
                    IF GenLedgSetup."Calc.Prepmt.VAT by Line PostGr" THEN
                      VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group")
                    ELSE BEGIN
                      GLAcc.GET(GenPostingSetup."Service Prepayments Account");
                      VATPostingSetup.GET("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");
                    END
                  END ELSE BEGIN
                    CLEAR(VATPostingSetup);
                    ERROR(Text104,GenPostingSetup.FIELDCAPTION("Service Prepayments Account"),
                     GenPostingSetup.TABLECAPTION,"Gen. Bus. Posting Group","Gen. Prod. Posting Group");
                  END;
                  "Prepayment VAT %" := VATPostingSetup."VAT %";
                  "Prepmt. VAT Calc. Type" := VATPostingSetup."VAT Calculation Type";
                  "Prepayment VAT Identifier" := VATPostingSetup."VAT Identifier";
                  CASE "Prepmt. VAT Calc. Type" OF
                    "VAT Calculation Type"::"Reverse Charge VAT",
                    "VAT Calculation Type"::"Sales Tax":
                      "Prepayment VAT %" := 0;
                    "VAT Calculation Type"::"Full VAT":
                      FIELDERROR("Prepmt. VAT Calc. Type",STRSUBSTNO(Text041,"Prepmt. VAT Calc. Type"));
                  END;
                  "Prepayment Tax Group Code" := GLAcc."Tax Group Code";
                END;

                TestStatusOpen;

                IF Type <> Type::" " THEN
                  UpdateAmounts;
            end;
        }
        field(110;"Prepmt. Line Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt. Line Amount"));
            Caption = 'Prepmt. Line Amount';
            Description = 'total amount that should be in "Prepmt. Amt. Inv." after post';
            MinValue = 0;

            trigger OnValidate()
            begin
                TestStatusOpen;
                TESTFIELD("Line Amount");
                IF "Prepmt. Line Amount" < "Prepmt. Amt. Inv." THEN
                  FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text044,"Prepmt. Amt. Inv."));
                IF "Prepmt. Line Amount" > "Line Amount" THEN
                  FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text043,"Line Amount"));
                VALIDATE("Prepayment %",ROUND("Prepmt. Line Amount" * 100 / "Line Amount",0.00001));
            end;
        }
        field(111;"Prepmt. Amt. Inv.";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt. Amt. Inv."));
            Caption = 'Prepmt. Amt. Inv.';
            Description = 'total amount invoiced already by prepayments';
            Editable = false;
        }
        field(112;"Prepmt. Amt. Incl. VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. Amt. Incl. VAT';
            Description = 'total amount invoiced already by prepayments. Actually name should be "Prepmt. Amt. Inv. Incl. VAT" but it left due to T37 analogue';
            Editable = false;
        }
        field(113;"Prepayment Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepayment Amount';
            Description = 'used in post process, after pont means last prepayment amount';
            Editable = false;
        }
        field(114;"Prepmt. VAT Base Amt.";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepmt. VAT Base Amt.';
            Editable = false;
        }
        field(115;"Prepayment VAT %";Decimal)
        {
            Caption = 'Prepayment VAT %';
            DecimalPlaces = 0:5;
            Editable = false;
            MinValue = 0;
        }
        field(116;"Prepmt. VAT Calc. Type";Option)
        {
            Caption = 'Prepmt. VAT Calc. Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(117;"Prepayment VAT Identifier";Code[10])
        {
            Caption = 'Prepayment VAT Identifier';
            Editable = false;
        }
        field(118;"Prepayment Tax Area Code";Code[20])
        {
            Caption = 'Prepayment Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(119;"Prepayment Tax Liable";Boolean)
        {
            Caption = 'Prepayment Tax Liable';

            trigger OnValidate()
            begin
                UpdateAmounts;
            end;
        }
        field(120;"Prepayment Tax Group Code";Code[10])
        {
            Caption = 'Prepayment Tax Group Code';
            TableRelation = "Tax Group";

            trigger OnValidate()
            begin
                TestStatusOpen;
                UpdateAmounts;
            end;
        }
        field(121;"Prepmt Amt to Deduct";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt Amt to Deduct"));
            Caption = 'Prepmt Amt to Deduct';
            Description = 'amount that should substituted from "Line Amount" for next payment';
            MinValue = 0;

            trigger OnValidate()
            var
                ApplMgt: Codeunit "1";
            begin
                IF "Prepmt Amt to Deduct" > "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" THEN
                  FIELDERROR(
                    "Prepmt Amt to Deduct",
                    STRSUBSTNO(Text045,"Prepmt. Amt. Inv." - "Prepmt Amt Deducted"));
            end;
        }
        field(122;"Prepmt Amt Deducted";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt Amt Deducted"));
            Caption = 'Prepmt Amt Deducted';
            Description = 'it is used for rule: "Prepmt Amt to Deduct" = "Prepmt. Amt. Inv." - "Prepmt Amt Deducted"';
            Editable = false;
        }
        field(123;"Prepayment Line";Boolean)
        {
            Caption = 'Prepayment Line';
            Editable = false;
        }
        field(124;"Prepayment Amount Incl. VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Prepayment Amount Incl. VAT';
            Description = 'used in post process,  side by side with "Prepayment Amount".';
            Editable = false;
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(5402;"Variant Code";Code[20])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));

            trigger OnValidate()
            begin
                IF "Variant Code" <> '' THEN                                                // 14.04.2014 Elva Baltic P21
                  TESTFIELD(Type,Type::Item);                                               // 14.04.2014 Elva Baltic P21
                TestStatusOpen;                                                             // 14.04.2014 Elva Baltic P21
            end;
        }
        field(5403;"Bin Code";Code[20])
        {
            Caption = 'Bin Code';
        }
        field(5404;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            Editable = false;
            InitValue = 1;
        }
        field(5405;Planned;Boolean)
        {
            Caption = 'Planned';
            Editable = false;
        }
        field(5407;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure".Code;

            trigger OnValidate()
            var
                UnitOfMeasureTranslation: Record "5402";
                ResUnitofMeasure: Record "205";
            begin
                TestStatusOpen;                                                             // 14.04.2014 Elva Baltic P21

                IF Type IN [Type::Item, Type::Labor] THEN
                  UpdateUnitPrice(FIELDNO("Unit of Measure Code"));

                UpdateQtyHours(FIELDNO("Unit of Measure Code"));

                IF "Unit of Measure Code" = '' THEN
                   "Unit of Measure" := ''
                 ELSE BEGIN
                   IF NOT UnitOfMeasure.GET("Unit of Measure Code") THEN
                     UnitOfMeasure.INIT;
                   "Unit of Measure" := UnitOfMeasure.Description;
                   GetServiceHeader;
                   IF ServiceHeader."Language Code" <> '' THEN BEGIN
                     UnitOfMeasureTranslation.SETRANGE(Code,"Unit of Measure Code");
                     UnitOfMeasureTranslation.SETRANGE("Language Code",ServiceHeader."Language Code");
                     IF UnitOfMeasureTranslation.FINDFIRST THEN
                       "Unit of Measure" := UnitOfMeasureTranslation.Description;
                   END;
                 END;
            end;
        }
        field(5415;"Quantity (Base)";Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                TESTFIELD("Qty. per Unit of Measure",1);
                VALIDATE(Quantity,"Quantity (Base)");
                UpdateUnitPrice(FIELDNO("Quantity (Base)"));
            end;
        }
        field(5416;"Outstanding Qty. (Base)";Decimal)
        {
            Caption = 'Outstanding Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5495;"Reserved Qty. (Base)";Decimal)
        {
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Source ID=FIELD(Document No.),
                                                                            Source Ref. No.=FIELD(Line No.),
                                                                            Source Type=CONST(25006146),
                                                                            Source Subtype=FIELD(Document Type),
                                                                            Reservation Status=CONST(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                TESTFIELD("Qty. per Unit of Measure");
                CALCFIELDS("Reserved Quantity");
                Planned := "Reserved Quantity" = "Outstanding Quantity";
            end;
        }
        field(5700;"Responsibility Center";Code[10])
        {
            Caption = 'Responsibility Center';
            Editable = false;
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                CallCreateDim;
            end;
        }
        field(5706;"Unit of Measure (Cross Ref.)";Code[10])
        {
            Caption = 'Unit of Measure (Cross Ref.)';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.));
        }
        field(5709;"Item Category Code";Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(5710;Nonstock;Boolean)
        {
            Caption = 'Nonstock';
            Editable = false;
        }
        field(5711;"Purchasing Code";Code[10])
        {
            Caption = 'Purchasing Code';
            TableRelation = Purchasing;

            trigger OnValidate()
            begin
                TestStatusOpen;
                TESTFIELD(Type,Type::Item);
                CheckAssocPurchOrder(FIELDCAPTION(Type));
                
                IF PurchasingCode.GET("Purchasing Code") THEN BEGIN
                  "Drop Shipment" := PurchasingCode."Drop Shipment";
                  "Special Order" := PurchasingCode."Special Order";
                  IF "Drop Shipment" OR "Special Order" THEN BEGIN
                    Reserve := Reserve::Never;
                    VALIDATE(Quantity,Quantity);
                    IF "Drop Shipment" THEN BEGIN
                      //EVALUATE("Outbound Whse. Handling Time",'<0D>');
                      EVALUATE("Shipping Time",'<0D>');
                      UpdateDates;
                      "Bin Code" := '';
                    END;
                  END;
                END ELSE BEGIN
                  "Drop Shipment" := FALSE;
                  "Special Order" := FALSE;
                
                  GetItem;
                  IF Item.Reserve = Item.Reserve::Optional THEN BEGIN
                    GetServiceHeader;
                    Reserve := ServiceHeader.Reserve;
                  END ELSE
                    Reserve := Item.Reserve;
                END;
                
                IF ("Purchasing Code" <> xRec."Purchasing Code") AND
                   (NOT "Drop Shipment") AND
                   ("Drop Shipment" <> xRec."Drop Shipment")
                THEN BEGIN
                  /*
                  IF "Location Code" = '' THEN BEGIN
                    IF InvtSetup.GET THEN
                      "Outbound Whse. Handling Time" := InvtSetup."Outbound Whse. Handling Time";
                  END ELSE
                    IF Location.GET("Location Code") THEN
                      "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
                  */
                  IF ShippingAgentServices.GET("Shipping Agent Code","Shipping Agent Service Code") THEN
                    "Shipping Time" := ShippingAgentServices."Shipping Time"
                  ELSE BEGIN
                    GetServiceHeader;
                    "Shipping Time" := ServiceHeader."Shipping Time";
                  END;
                  UpdateDates;
                END;

            end;
        }
        field(5712;"Product Group Code";Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
        }
        field(5713;"Special Order";Boolean)
        {
            Caption = 'Special Order';
            Editable = false;
        }
        field(5714;"Special Order Purchase No.";Code[20])
        {
            Caption = 'Special Order Purchase No.';
            TableRelation = IF (Special Order=CONST(Yes)) "Purchase Header".No. WHERE (Document Type=CONST(Order));
        }
        field(5715;"Special Order Purch. Line No.";Integer)
        {
            Caption = 'Special Order Purch. Line No.';
            TableRelation = IF (Special Order=CONST(Yes)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                            Document No.=FIELD(Special Order Purchase No.));
        }
        field(5790;"Requested Delivery Date";Date)
        {
            Caption = 'Requested Delivery Date';

            trigger OnValidate()
            begin
                TestStatusOpen;
                IF ("Requested Delivery Date" <> xRec."Requested Delivery Date") AND
                   ("Promised Delivery Date" <> 0D)
                THEN
                  ERROR(
                    Text028,
                    FIELDCAPTION("Requested Delivery Date"),
                    FIELDCAPTION("Promised Delivery Date"));

                IF "Requested Delivery Date" <> 0D THEN
                  VALIDATE("Planned Delivery Date","Requested Delivery Date")
                ELSE BEGIN
                  GetServiceHeader;
                  VALIDATE("Shipment Date",ServiceHeader."Shipment Date");
                END;
            end;
        }
        field(5791;"Promised Delivery Date";Date)
        {
            Caption = 'Promised Delivery Date';

            trigger OnValidate()
            begin
                TestStatusOpen;
                IF "Promised Delivery Date" <> 0D THEN
                  VALIDATE("Planned Delivery Date","Promised Delivery Date")
                ELSE
                  VALIDATE("Requested Delivery Date");
            end;
        }
        field(5792;"Shipping Time";DateFormula)
        {
            Caption = 'Shipping Time';

            trigger OnValidate()
            begin
                TestStatusOpen;
                UpdateDates;
            end;
        }
        field(5794;"Planned Delivery Date";Date)
        {
            Caption = 'Planned Delivery Date';

            trigger OnValidate()
            begin
                TestStatusOpen;
                IF "Planned Delivery Date" <> 0D THEN BEGIN
                  PlannedDeliveryDateCalculated := TRUE;

                  IF FORMAT("Shipping Time") <> '' THEN
                    VALIDATE(
                      "Planned Shipment Date",
                      CalendarMgmt.CalcDateBOC2(
                        FORMAT("Shipping Time"),
                        "Planned Delivery Date",
                        CalChange."Source Type"::"Shipping Agent",
                        "Shipping Agent Code",
                        "Shipping Agent Service Code",
                        CalChange."Source Type"::Customer,
                        "Sell-to Customer No.",
                        '',
                        TRUE))
                  ELSE
                    VALIDATE(
                      "Planned Shipment Date",
                      CalendarMgmt.CalcDateBOC(
                        FORMAT(''),
                        "Planned Delivery Date",
                        CalChange."Source Type"::"Shipping Agent",
                        "Shipping Agent Code",
                        "Shipping Agent Service Code",
                        CalChange."Source Type"::Customer,
                        "Sell-to Customer No.",
                        '',
                        TRUE));

                  IF "Planned Shipment Date" > "Planned Delivery Date" THEN
                    "Planned Delivery Date" := "Planned Shipment Date";
                END;
            end;
        }
        field(5795;"Planned Shipment Date";Date)
        {
            Caption = 'Planned Shipment Date';

            trigger OnValidate()
            begin
                TestStatusOpen;
                IF "Planned Shipment Date" <> 0D THEN BEGIN
                  PlannedShipmentDateCalculated := TRUE;
                /*
                  IF FORMAT("Outbound Whse. Handling Time") <> '' THEN
                    VALIDATE(
                      "Shipment Date",
                      CalendarMgmt.CalcDateBOC2(
                        FORMAT("Outbound Whse. Handling Time"),
                        "Planned Shipment Date",
                        CalChange."Source Type"::Location,
                        "Location Code",
                        '',
                        CalChange."Source Type"::"Shipping Agent",
                        "Shipping Agent Code",
                        "Shipping Agent Service Code",
                        FALSE))
                  ELSE
                */
                    VALIDATE(
                      "Shipment Date",
                      CalendarMgmt.CalcDateBOC(
                        FORMAT(FORMAT('')),
                        "Planned Shipment Date",
                        CalChange."Source Type"::Location,
                        "Location Code",
                        '',
                        CalChange."Source Type"::"Shipping Agent",
                        "Shipping Agent Code",
                        "Shipping Agent Service Code",
                        FALSE));
                END;

            end;
        }
        field(5796;"Shipping Agent Code";Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                TestStatusOpen;
                IF "Shipping Agent Code" <> xRec."Shipping Agent Code" THEN
                  VALIDATE("Shipping Agent Service Code",'');
            end;
        }
        field(5797;"Shipping Agent Service Code";Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code WHERE (Shipping Agent Code=FIELD(Shipping Agent Code));

            trigger OnValidate()
            begin
                TestStatusOpen;
                IF "Shipping Agent Service Code" <> xRec."Shipping Agent Service Code" THEN
                  EVALUATE("Shipping Time",'<>');

                IF "Drop Shipment" THEN BEGIN
                  EVALUATE("Shipping Time",'<0D>');
                  UpdateDates;
                END ELSE BEGIN
                  IF ShippingAgentServices.GET("Shipping Agent Code","Shipping Agent Service Code") THEN
                    "Shipping Time" := ShippingAgentServices."Shipping Time"
                  ELSE BEGIN
                    GetServiceHeader;
                    "Shipping Time" := ServiceHeader."Shipping Time";
                  END;
                END;

                IF ShippingAgentServices."Shipping Time" <> xRec."Shipping Time" THEN
                  VALIDATE("Shipping Time","Shipping Time");
            end;
        }
        field(5811;"Appl.-from Item Entry";Integer)
        {
            Caption = 'Appl.-from Item Entry';
            MinValue = 0;

            trigger OnLookup()
            begin
                SelectItemEntry(FIELDNO("Appl.-from Item Entry"));
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "32";
            begin
                IF "Appl.-from Item Entry" <> 0 THEN BEGIN
                  CheckApplFromItemLedgEntry(ItemLedgEntry);
                  VALIDATE("Unit Cost (LCY)",CalcUnitCost(ItemLedgEntry));
                END;
            end;
        }
        field(5917;"Qty. to Consume";Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. to Consume';
            DecimalPlaces = 0:5;
        }
        field(5918;"Quantity Consumed";Decimal)
        {
            Caption = 'Quantity Consumed';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5919;"Qty. to Consume (Base)";Decimal)
        {
            BlankZero = true;
            Caption = 'Qty. to Consume (Base)';
            DecimalPlaces = 0:5;
        }
        field(5920;"Qty. Consumed (Base)";Decimal)
        {
            Caption = 'Qty. Consumed (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(7001;"Allow Line Disc.";Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(7002;"Customer Disc. Group";Code[10])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(50000;"Ext-Serv. PO Created";Boolean)
        {
        }
        field(50008;"Local Parts";Boolean)
        {
        }
        field(60000;"External No.";Code[20])
        {
            Caption = 'External No.';
        }
        field(60100;Group;Boolean)
        {
            Caption = 'Group';
        }
        field(60110;"Group ID";Integer)
        {
            Caption = 'Group ID';
            TableRelation = "Service Line EDMS"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                                  Document No.=FIELD(Document No.),
                                                                  Group=CONST(Yes));

            trigger OnLookup()
            var
                ServLine: Record "25006146";
            begin
                IF Group THEN
                  EXIT;

                ServLine.RESET;
                ServLine.SETRANGE("Document Type", "Document Type");
                ServLine.SETRANGE("Document No.", "Document No.");

                IF LookUpMgt.LookUpServLineGroup(ServLine,"Group ID") THEN
                 VALIDATE("Group ID");
                CALCFIELDS("Group Description");
            end;

            trigger OnValidate()
            begin
                CALCFIELDS("Group Description");
            end;
        }
        field(60120;"Group Description";Text[30])
        {
            CalcFormula = Lookup("Service Line EDMS".Description WHERE (Document Type=FIELD(Document Type),
                                                                        Document No.=FIELD(Document No.),
                                                                        Line No.=FIELD(Group ID)));
            Caption = 'Group Description';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                ServLine: Record "25006146";
            begin
                IF Group THEN
                  EXIT;

                ServLine.RESET;
                ServLine.SETRANGE("Document Type", "Document Type");
                ServLine.SETRANGE("Document No.", "Document No.");

                IF LookUpMgt.LookUpServLineGroup(ServLine,"Group ID") THEN
                 VALIDATE("Group ID");

                CALCFIELDS("Group Description");
            end;
        }
        field(70003;"Item Movement Code";Option)
        {
            CalcFormula = Lookup(Item."Item Movement Category" WHERE (No.=FIELD(No.)));
            FieldClass = FlowField;
            OptionMembers = " ",EF,MF,RF,NPA;
        }
        field(90000;"Posting Date";Date)
        {
            CalcFormula = Lookup("Service Header EDMS"."Posting Date" WHERE (Document Type=FIELD(Document Type),
                                                                             No.=FIELD(Document No.)));
            Caption = 'Posting Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90200;"Planned Service Date";Date)
        {
            Caption = 'Planned Service Date';
        }
        field(25006001;"Deal Type Code";Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006005;"Minutes Per UoM";Decimal)
        {
            Caption = 'Minutes Per UoM';

            trigger OnValidate()
            begin
                UpdateQtyHours(0);
            end;
        }
        field(25006006;"Quantity (Hours)";Decimal)
        {
            Caption = 'Quantity (Hours)';

            trigger OnValidate()
            begin
                UpdateQtyHours(FIELDNO("Quantity (Hours)"));
            end;
        }
        field(25006010;"Symptom Code";Code[20])
        {
            Caption = 'Symptom Code';
            TableRelation = "Symptom Code EDMS".Code WHERE (Make Code=FIELD(Make Code));
        }
        field(25006014;"Product Subgroup Code";Code[10])
        {
            Caption = 'Product Subgroup Code';
            TableRelation = "Product Subgroup".Code WHERE (Item Category Code=FIELD(Item Category Code),
                                                           Product Group Code=FIELD(Product Group Code));
        }
        field(25006015;Prepayment;Boolean)
        {
            Caption = 'Prepayment';
        }
        field(25006030;"Campaign No.";Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(25006100;"Vehicle Axle Code";Code[10])
        {
            Caption = 'Vehicle Axle Code';
            TableRelation = "Vehicle Axle".Code WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.));
        }
        field(25006110;"Tire Position Code";Code[10])
        {
            Caption = 'Tire Position Code';
            TableRelation = "Vehicle Tire Position".Code WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                                                Axle Code=FIELD(Vehicle Axle Code));
        }
        field(25006120;"Tire Code";Code[20])
        {
            Caption = 'Tire Code';
            TableRelation = Tire.Code;

            trigger OnLookup()
            var
                TireManagementSetup: Record "25006182";
            begin
                IF "Tire Operation Type" <> "Tire Operation Type"::" " THEN BEGIN
                  Tire.RESET;
                  IF "Tire Operation Type" IN ["Tire Operation Type"::"Take off", "Tire Operation Type"::"Position Change"] THEN BEGIN
                    Tire.SETRANGE("Current Vehicle Serial No.", "Vehicle Serial No.");
                  END ELSE BEGIN
                    TireManagementSetup.GET;
                    // that part is commented for operation of tire exchange on the same platform
                    IF TireManagementSetup."Check Tire Unique" THEN BEGIN
                      Tire.SETRANGE(Available, TRUE);
                    END;
                  END;

                  IF PAGE.RUNMODAL(0,Tire) = ACTION::LookupOK THEN
                    "Tire Code" := Tire.Code;
                END;
            end;
        }
        field(25006125;"Tire Operation Type";Option)
        {
            Caption = 'Tire Operation Type';
            OptionCaption = ' ,Put on,Take off,Position Change';
            OptionMembers = " ","Put on","Take off","Position Change";
        }
        field(25006126;"New Vehicle Axle Code";Code[10])
        {
            Caption = 'New Vehicle Axle Code';
            TableRelation = "Vehicle Axle".Code WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.));
        }
        field(25006127;"New Tire Position Code";Code[10])
        {
            Caption = 'New Tire Position Code';
            TableRelation = "Vehicle Tire Position".Code WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                                                Axle Code=FIELD(Vehicle Axle Code));
        }
        field(25006130;"External Serv. Tracking No.";Code[20])
        {
            Caption = 'External Serv. Tracking No.';
            TableRelation = IF (Type=FILTER(External Service)) "External Serv. Tracking No."."External Serv. Tracking No." WHERE (External Service No.=FIELD(No.));
        }
        field(25006140;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Editable = false;
            FieldClass = Normal;
            TableRelation = Vehicle;
        }
        field(25006142;"Qty. to Return";Decimal)
        {
            Caption = 'Qty. to Return';
            DecimalPlaces = 0:5;
        }
        field(25006150;"Standard Time";Decimal)
        {
            BlankZero = true;
            Caption = 'Standard Time (Hours)';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                // 25.02.2015 EDMS P21 >>
                UnitOfMeasure.GET("Unit of Measure Code");
                IF UnitOfMeasure."Minutes Per UoM" = 0 THEN
                  ERROR(STRSUBSTNO(Text127, UnitOfMeasure.FIELDCAPTION("Minutes Per UoM"), FIELDCAPTION("Unit of Measure Code"), "Unit of Measure Code"));
                // 25.02.2015 EDMS P21 <<

                VALIDATE(Quantity,"Standard Time");
                //08.04.2014 Elva Baltic P1 #RX MMG7.00 >>
                UpdateUnitPrice(FIELDNO("Standard Time"));
                //08.04.2014 Elva Baltic P1 #RX MMG7.00 <<
            end;
        }
        field(25006160;"Standard Time Line No.";Integer)
        {
            BlankZero = true;
            Caption = 'Standard Time Line No.';
            Editable = false;
        }
        field(25006170;"Vehicle Registration No.";Code[30])
        {
            CalcFormula = Lookup("Service Header EDMS"."Vehicle Registration No." WHERE (Document Type=FIELD(Document Type),
                                                                                         No.=FIELD(Document No.)));
            Caption = 'Vehicle Registration No.';
            FieldClass = FlowField;
        }
        field(25006190;"Model Code";Code[20])
        {
            CalcFormula = Lookup("Service Header EDMS"."Model Code" WHERE (Document Type=FIELD(Document Type),
                                                                           No.=FIELD(Document No.)));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Model.Code;

            trigger OnValidate()
            begin
                TestStatusOpen;                                                             // 14.04.2014 Elva Baltic P21
            end;
        }
        field(25006210;"Package No.";Code[20])
        {
            Caption = 'Package No.';
            Editable = true;
            TableRelation = "Service Package".No.;
        }
        field(25006220;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            begin
                TestStatusOpen;                                                             // 14.04.2014 Elva Baltic P21
            end;
        }
        field(25006250;"Service Work Shift Code";Code[10])
        {
            Caption = 'Service Work Shift Code';
            TableRelation = Table0;
        }
        field(25006300;"Package Version No.";Integer)
        {
            Caption = 'Package Version No.';
            Editable = true;
            TableRelation = "Service Package Version"."Version No." WHERE (Package No.=FIELD(Package No.));
        }
        field(25006310;"Package Version Spec. Line No.";Integer)
        {
            Caption = 'Package Version Spec. Line No.';
            Editable = true;
            NotBlank = true;
            TableRelation = "Service Package Version Line"."Line No." WHERE (Package No.=FIELD(Package No.),
                                                                             Version No.=FIELD(Package Version No.));

            trigger OnValidate()
            begin
                UpdateUnitPrice(FIELDNO("Package Version Spec. Line No."));
            end;
        }
        field(25006373;VIN;Code[20])
        {
            CalcFormula = Lookup("Service Header EDMS".VIN WHERE (Document Type=FIELD(Document Type),
                                                                  No.=FIELD(Document No.)));
            Caption = 'VIN';
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                TestStatusOpen;                                                             // 14.04.2014 Elva Baltic P21
            end;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(25006600;"Sell-to Customer Bill %";Decimal)
        {
            Caption = 'Sell-to Customer Bill %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(25006610;"Sell-to Customer Bill Amount";Decimal)
        {
            Caption = 'Sell-to Customer Bill Amount';
        }
        field(25006700;"Ordering Price Type Code";Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";

            trigger OnValidate()
            begin
                UpdateUnitPrice(FIELDNO("Ordering Price Type Code"));
            end;
        }
        field(25006800;"Variable Field 25006800";Code[20])
        {
            CaptionClass = '7,25006146,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Service Line EDMS",FIELDNO("Variable Field 25006800"),
                  '',"Variable Field 25006800") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006800",VFOptions.Code);
                 END;
            end;
        }
        field(25006801;"Variable Field 25006801";Code[20])
        {
            CaptionClass = '7,25006146,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Service Line EDMS",FIELDNO("Variable Field 25006801"),
                  '',"Variable Field 25006801") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006801",VFOptions.Code);
                 END;
            end;
        }
        field(25006802;"Variable Field 25006802";Code[20])
        {
            CaptionClass = '7,25006146,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Service Line EDMS",FIELDNO("Variable Field 25006802"),
                  '',"Variable Field 25006802") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006802",VFOptions.Code);
                 END;
            end;
        }
        field(25006998;"Has Replacement";Boolean)
        {
            Caption = 'Has Replacement';
        }
        field(25007110;"Contract No.";Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No." WHERE (Bill-to Customer No.=FIELD(Bill-to Customer No.));
        }
        field(25007120;"Resource No.";Code[20])
        {
            Caption = 'Resource No.';
            Description = 'Deprecated Field, do not use this field';
            TableRelation = Resource WHERE (Is Bay=CONST(No));

            trigger OnValidate()
            var
                recServHeader: Record "25006145";
                recResource: Record "156";
            begin
            end;
        }
        field(25007150;"Job No.";Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job.No. WHERE (Bill-to Customer No.=FIELD(Bill-to Customer No.));
        }
        field(25007180;Split;Boolean)
        {
            Caption = 'Split';
        }
        field(25007190;Status;Code[10])
        {
            Caption = 'Status';
            TableRelation = "Service Work Status EDMS";

            trigger OnValidate()
            var
                ServiceHdrLoc: Record "25006145";
                ServiceLineTemp: Record "25006146" temporary;
                ServiceLine: Record "25006146";
            begin
                ServiceScheduleSetup.GET;
                IF ServiceScheduleSetup."Control Document Statuses" AND (CurrFieldNo = FIELDNO(Status)) THEN
                  ERROR(Text103);

                IF Status <> xRec.Status THEN BEGIN
                  ServiceLineTemp.RESET;
                  ServiceLineTemp.DELETEALL;

                  ServiceLine.RESET;
                  ServiceLine.SETRANGE("Document Type","Document Type");
                  ServiceLine.SETRANGE("Document No.","Document No.");
                  IF ServiceLine.FINDFIRST THEN
                    REPEAT
                      ServiceLineTemp.INIT;
                      ServiceLineTemp := ServiceLine;
                      ServiceLineTemp.INSERT;
                    UNTIL ServiceLine.NEXT = 0;


                  //Updating service line status in temp variable
                  ServiceLineTemp.GET("Document Type","Document No.","Line No.");
                  ServiceLineTemp.Status := Status;
                  ServiceLineTemp.MODIFY(TRUE);

                  ServiceHdrLoc.GET("Document Type", "Document No.");
                  ServScheduleMgt.ChangeServiceHeaderStatusOld(ServiceHdrLoc,ServiceLineTemp);
                END;
            end;
        }
        field(25007195;"BOM Item No.";Code[20])
        {
            Caption = 'BOM Item No.';
            TableRelation = Item;
        }
        field(25007200;"Finished Quantity (Hours)";Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum("Serv. Labor Alloc. Application"."Finished Quantity (Hours)" WHERE (Document Type=FIELD(Document Type),
                                                                                                  Document No.=FIELD(Document No.),
                                                                                                  Document Line No.=FIELD(Line No.)));
            Caption = 'Finished Quantity (Hours)';
            Description = 'Service Schedule';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007210;"Remaining Quantity (Hours)";Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum("Serv. Labor Alloc. Application"."Remaining Quantity (Hours)" WHERE (Document Type=FIELD(Document Type),
                                                                                                   Document No.=FIELD(Document No.),
                                                                                                   Document Line No.=FIELD(Line No.)));
            Caption = 'Remaining Quantity (Hours)';
            Description = 'Service Schedule';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007220;"Sell-to Customer Name";Text[50])
        {
            CalcFormula = Lookup("Service Header EDMS"."Sell-to Customer Name" WHERE (Sell-to Customer No.=FIELD(Sell-to Customer No.)));
            Caption = 'Sell-to Customer Name';
            FieldClass = FlowField;
        }
        field(25007230;"Bill-to Name";Text[50])
        {
            CalcFormula = Lookup("Service Header EDMS"."Bill-to Name" WHERE (Bill-to Customer No.=FIELD(Bill-to Customer No.)));
            Caption = 'Bill-to Name';
            FieldClass = FlowField;
        }
        field(25007240;"Plan No.";Code[10])
        {
            Caption = 'Plan No.';
            TableRelation = "Vehicle Service Plan".No. WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.));
        }
        field(25007245;"Plan Stage Recurrence";Integer)
        {
            Caption = 'Plan Stage Recurrence';
        }
        field(25007250;"Plan Stage Code";Code[10])
        {
            Caption = 'Plan Stage Code';
            TableRelation = "Vehicle Service Plan Stage".Code WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.),
                                                                     Plan No.=FIELD(Plan No.));
        }
        field(25007260;"Res. Cost Amount Finished";Decimal)
        {
            CalcFormula = Sum("Serv. Labor Alloc. Application"."Finished Cost Amount" WHERE (Document Type=FIELD(Document Type),
                                                                                             Document No.=FIELD(Document No.),
                                                                                             Document Line No.=FIELD(Line No.)));
            Caption = 'Resource Cost Amount Finished';
            FieldClass = FlowField;
        }
        field(25007270;"Res. Cost Amount Remaining";Decimal)
        {
            CalcFormula = Sum("Serv. Labor Alloc. Application"."Remaining Cost Amount" WHERE (Document Type=FIELD(Document Type),
                                                                                              Document No.=FIELD(Document No.),
                                                                                              Document Line No.=FIELD(Line No.)));
            Caption = 'Resource Cost Amount Remaining';
            FieldClass = FlowField;
        }
        field(25007280;"Res. Cost Amount Total";Decimal)
        {
            CalcFormula = Sum("Serv. Labor Alloc. Application"."Cost Amount" WHERE (Document Type=FIELD(Document Type),
                                                                                    Document No.=FIELD(Document No.),
                                                                                    Document Line No.=FIELD(Line No.)));
            Caption = 'Resource Cost Amount Total';
            FieldClass = FlowField;
        }
        field(25007281;"Requested Item No.";Code[20])
        {
            Caption = 'Requested Item No.';
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
        field(33020234;"Job Category";Option)
        {
            OptionCaption = ' ,Under Warranty,Post Warranty,Accidental Repair,PDI';
            OptionMembers = " ","Under Warranty","Post Warranty","Accidental Repair",PDI;
        }
        field(33020235;"Job Type";Code[20])
        {
            Description = 'Relation to master table Job Type Master';
            TableRelation = IF (Job Category=CONST(Under Warranty)) "Job Type Master".No. WHERE (Type=FILTER(Job),
                                                                                                 Under Warranty=CONST(Yes))
                                                                                                 ELSE IF (Job Category=CONST(Post Warranty)) "Job Type Master".No. WHERE (Type=FILTER(Job),
                                                                                                                                                                          Post Warranty=CONST(Yes))
                                                                                                                                                                          ELSE IF (Job Category=CONST(Accidental Repair)) "Job Type Master".No. WHERE (Type=FILTER(Job),
                                                                                                                                                                                                                                                       Accidental Repair=CONST(Yes))
                                                                                                                                                                                                                                                       ELSE IF (Job Category=CONST(PDI)) "Job Type Master".No. WHERE (Type=FILTER(Job),
                                                                                                                                                                                                                                                                                                                      PDI=CONST(Yes));

            trigger OnValidate()
            var
                VehicleWarranty: Record "25006036";
                ServiceHeader1: Record "25006145";
                Nowarranty: Label 'There is no any warranty for %1.';
                ServMgtSetup: Record "25006120";
                JobMaster: Record "33020235";
                NewBillTo: Code[20];
                SchemeRegisteredVeh: Record "33020240";
                ExpSanWarranty: Label 'Sanjivani Warranty is Expired for Vehicle %1.';
                NoSanWarranty: Label 'Vehicle %1 has not been yet registered for Sanjivani.';
                SanjivaniError: Label 'Job Type must be SANJIVANI in Service Header.';
                WarrantyUsage: Record "25006038";
                DateFormulas: DateFormula;
            begin
                //Sipradi-YS Begin
                ValidateLocalParts;
                TESTFIELD("Warranty Approved",FALSE);
                TESTFIELD("No.");
                TESTFIELD("Document No.");
                IF ("Document Type" <> ServiceHeader1."Document Type") OR ("Document No." <> ServiceHeader1."No.") THEN
                  ServiceHeader1.GET("Document Type","Document No.");
                IF "Job Type" = 'SANJIVANI' THEN BEGIN
                  IF (ServiceHeader1."Job Type" <> 'SANJIVANI') THEN
                    ERROR(SanjivaniError);
                END;
                
                "Need Approval" := FALSE;
                NewBillTo :=  ServiceHeader1."Bill-to Customer No.";
                JobMaster.RESET;
                JobMaster.SETRANGE(Type,JobMaster.Type::Job);
                IF JobMaster.FINDFIRST THEN BEGIN
                  REPEAT
                    IF (JobMaster."Shortcut Dimension 2 Code" <> '')  AND ("Job Type" = JobMaster."No.") THEN
                      VALIDATE("Shortcut Dimension 2 Code",JobMaster."Shortcut Dimension 2 Code");
                    IF ("Job Type" = JobMaster."No.") AND (JobMaster."Needs Warranty Approval" = TRUE) AND
                        NOT (JobMaster."Needs Approval")  THEN BEGIN         //SM for the approval of other Job Type @Agni
                      IF "Job Type" = 'SANJIVANI WARRANTY' THEN BEGIN
                        SchemeRegisteredVeh.RESET;
                        SchemeRegisteredVeh.SETRANGE("VIN Code",ServiceHeader1.VIN);
                        SchemeRegisteredVeh.SETRANGE("Scheme Type",SchemeRegisteredVeh."Scheme Type"::SANJIVANI);
                        IF SchemeRegisteredVeh.FINDFIRST THEN BEGIN
                          IF SchemeRegisteredVeh."Valid Until" >= TODAY THEN BEGIN
                            NewBillTo :=JobMaster."Bill to Customer";
                            "Need Approval" := TRUE;
                          END
                          ELSE
                            ERROR(ExpSanWarranty,ServiceHeader1."Vehicle Registration No.");
                        END
                        ELSE
                          ERROR(NoSanWarranty,ServiceHeader1."Vehicle Registration No.");
                
                      END
                      ELSE BEGIN
                      /*********************************** Checking Warranty Usage **************************/
                        VehicleWarranty.RESET;
                        VehicleWarranty.SETRANGE("Vehicle Serial No.",ServiceHeader1."Vehicle Serial No.");
                        VehicleWarranty.SETRANGE(Status,VehicleWarranty.Status::Active);
                        IF VehicleWarranty.FIND('-') THEN BEGIN
                            IF (VehicleWarranty."Term Date Formula"=DateFormulas) AND
                                (VehicleWarranty."Kilometrage Limit"=0) THEN
                                  ERROR('Either Kilometrage Limit or Term Date Formula has to be set in Vehicle Warranty.');
                            NewBillTo :=JobMaster."Bill to Customer";
                            "Need Approval" := TRUE;
                        END
                        ELSE
                          ERROR(Nowarranty,ServiceHeader1."Vehicle Registration No.");
                      /********************************* END of Checking Warranty Usage *******************/
                      END;
                    END
                    ELSE IF ("Job Type" = JobMaster."No.") AND (JobMaster."Bill to Customer" <> '') THEN BEGIN
                      NewBillTo :=JobMaster."Bill to Customer";
                      IF (JobMaster."Needs Warranty Approval") AND (JobMaster."Needs Approval") THEN //SM for the approval of other Job Type @Agni
                        "Need Approval" := TRUE;
                    END;
                  UNTIL JobMaster.NEXT=0;
                END;
                 VALIDATE("Bill-to Customer No.",NewBillTo);
                
                /*IF "Job Type" = ServMgtSetup."Warranty Job Type Code" THEN BEGIN
                    VehicleWarranty.RESET;
                    VehicleWarranty.SETRANGE("Vehicle Serial No.",ServiceHeader1."Vehicle Serial No.");
                    VehicleWarranty.SETRANGE(Status,VehicleWarranty.Status::Active);
                    IF VehicleWarranty.FIND('-') THEN BEGIN
                      JobMaster.RESET;
                      JobMaster.SETRANGE("No.",ServMgtSetup."Warranty Job Type Code");
                      IF JobMaster.FINDFIRST THEN BEGIN
                      "Bill-to Customer No." :=JobMaster."Bill to Customer";
                      END;
                    END
                    ELSE
                      ERROR(Nowarranty,ServiceHeader1."Vehicle Registration No.");
                END
                ELSE IF "Job Type" = ServMgtSetup."Free Job Type Code" THEN BEGIN
                      JobMaster.GET(ServMgtSetup."Free Job Type Code");
                      "Bill-to Customer No." :=JobMaster."Bill to Customer";
                END
                ELSE   "Bill-to Customer No." := ServiceHeader1."Bill-to Customer No.";
                */
                //Sipradi-YS End
                IF "Job Type" = 'SANJIVANI' THEN
                  ValidateAmountSanjivani(ServiceHeader1);
                IF xRec."Job Type" <> Rec."Job Type" THEN
                  VALIDATE(Quantity,Quantity);
                
                //SS1.00
                CALCFIELDS(VIN);
                JobTypeMaster.RESET;
                JobTypeMaster.SETRANGE("No.","Job Type");
                JobTypeMaster.SETRANGE(Scheme,TRUE);
                IF JobTypeMaster.FINDFIRST THEN BEGIN
                   TESTFIELD("Membership No.");
                   SchemeVehTracking.RESET;
                   SchemeVehTracking.SETRANGE(VIN,VIN);
                   SchemeVehTracking.SETRANGE(Status,SchemeVehTracking.Status::Primary);
                   IF SchemeVehTracking.FINDFIRST THEN BEGIN
                      ValueAddServ.RESET;
                      ValueAddServ.SETRANGE("Membership Card No.","Membership No.");
                      ValueAddServ.SETRANGE("No.","No.");
                      IF ValueAddServ.FINDFIRST THEN BEGIN
                         ValueAddServ.CALCFIELDS("Utilised Quantity");
                         IF ValueAddServ."Valid Quantity" = ValueAddServ."Utilised Quantity" THEN
                            ERROR('No more Value Added Services are provided under this scheme.');
                      END;
                   END ELSE
                      ERROR('The Vehicle with VIN No. %1 is not primary vehicle in respective scheme. Please verify.',VIN);
                END;
                //SS1.00

            end;
        }
        field(33020236;"Warranty Approved";Boolean)
        {
            Editable = true;

            trigger OnValidate()
            begin
                IF "Warranty Approved" = TRUE THEN
                  "Approved Date" := WORKDATE
                ELSE
                  "Approved Date" := 0D;
            end;
        }
        field(33020237;"Approved Date";Date)
        {
        }
        field(33020238;"Customer Verified";Boolean)
        {
        }
        field(33020239;"External Service Purchased";Boolean)
        {
        }
        field(33020240;"Need Approval";Boolean)
        {
        }
        field(33020241;"Warranty Code";Code[10])
        {
            TableRelation = "Customer Complain Master";
        }
        field(33020242;"Warranty Description";Text[100])
        {
            CalcFormula = Lookup("Customer Complain Master".Description WHERE (No.=FIELD(Warranty Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020243;"Warranty Claim No.";Code[20])
        {
        }
        field(33020244;"Warranty Status";Option)
        {
            CalcFormula = Lookup("Warranty Register".Status WHERE (Claim No.=FIELD(Warranty Claim No.)));
            Editable = true;
            FieldClass = FlowField;
            OptionCaption = ' ,Pending,Approved,Rejected';
            OptionMembers = " ",Pending,Approved,Rejected;
        }
        field(33020245;"Package Total Amount";Decimal)
        {
            CalcFormula = Sum("Service Line EDMS"."Line Amount" WHERE (Document Type=FIELD(Document Type),
                                                                       Document No.=FIELD(Document No.),
                                                                       Job Type=CONST(SANJIVANI)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020246;"Work Order Registered";Boolean)
        {
        }
        field(33020247;"Washing Labor";Boolean)
        {
            CalcFormula = Lookup("Service Labor".Washing/Greasing/Polishing WHERE (No.=FIELD(No.)));
            FieldClass = FlowField;
        }
        field(33020248;"No. of Shipped Items";Decimal)
        {
            Editable = false;
        }
        field(33020249;"No. of Received Items";Decimal)
        {
            Editable = false;
        }
        field(33020250;"Total Qty.";Decimal)
        {
            CalcFormula = Sum("Service Line EDMS".Quantity WHERE (Document Type=FIELD(Document Type),
                                                                  Document No.=FIELD(Document No.),
                                                                  Type=FIELD(Type),
                                                                  No.=FIELD(No.)));
            Description = '//Temporary use to calculate total for each item';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020251;"Approval Reason";Text[250])
        {
        }
        field(33020252;"Scheme Code";Code[20])
        {
            Editable = false;
            TableRelation = "Service Scheme Header";
        }
        field(33020253;"Membership No.";Code[20])
        {
            Editable = false;
            TableRelation = "Membership Details";
        }
        field(33020254;Resources;Code[250])
        {
        }
        field(33020260;"HS Code";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Line No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
            SumIndexFields = Amount,"Amount Including VAT";
        }
        key(Key2;Type,"No.")
        {
        }
        key(Key3;Type,"No.","Variant Code","Location Code","Document Type","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Planned Service Date")
        {
            SumIndexFields = Quantity;
        }
        key(Key4;"Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Planned Service Date")
        {
            SumIndexFields = "Outstanding Qty. (Base)";
        }
        key(Key5;Type)
        {
        }
        key(Key6;"Warranty Claim No.")
        {
            SumIndexFields = Amount,"Amount Including VAT";
        }
        key(Key7;"Document Type","Document No.","Bill-to Customer No.")
        {
            SumIndexFields = Amount,"Amount Including VAT";
        }
        key(Key8;"Document Type","Document No.","Job Type")
        {
            SumIndexFields = "Line Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CapableToPromise: Codeunit "99000886";
        ServiceHeader: Record "25006145";
        recSalesLine: Record "37";
        recSalesHeader: Record "36";
        recServOrderAlloc: Record "25006277";
        recResourceAlloc: Record "25006271";
        SIEAssgnt: Record "25006706";
        ItemJnlLine: Record "83";
        WarrantyRegister: Record "33020238";
        WarrAppLine: Record "33020237";
    begin
        IF NOT ServiceHeader.GET("Document Type","Document No.") THEN
          EXIT;

        TestStatusOpen;                                                                  // 14.04.2014 Elva Baltic P21

        IF Type = Type::Item THEN
         BEGIN
          //11-06-2007 EDMS P3 SIE
          IF "Line No." <> 0 THEN
            WITH SIEAssgnt DO BEGIN
              RESET;
              SETCURRENTKEY("Applies-to Type","Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
              SETRANGE("Applies-to Type",DATABASE::"Service Line EDMS");
              SETRANGE("Applies-to Doc. Type","Document Type");
              SETRANGE("Applies-to Doc. No.","Document No.");
              SETRANGE("Applies-to Doc. Line No.",xRec."Line No.");
              DELETEALL
            END
         END;

        IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
          ReserveServiceLine.DeleteLine(Rec);
          CALCFIELDS("Reserved Qty. (Base)");
          TESTFIELD("Reserved Qty. (Base)",0);
        END;

        CheckSPackage(FIELDNO("Unit Price"), 1); //20.02.2012 EDMS P8

        TESTFIELD("Prepmt. Amt. Inv.",0);   //08-05-2007 EDMS P3 PREPMT

        IF (NOT Recreate) AND
           // ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) AND                    // 12.05.2014 Elva Baltic P21
           (Type = Type::Labor)
        THEN BEGIN
          ServScheduleMgt.DontModifySalesLine(TRUE);
          ServScheduleMgt.DeleteAllocationFromServLines(Rec);
          DeleteResourcesOfLine;
        END;

        //09.04.2014 Elva Baltic P1 #RX MMG7.00 >>
        //Commented because this is not letting to change bill-to customer
        //NonstockItemMgt.DelNonStockServEDMS(Rec);
        //09.04.2014 Elva Baltic P1 #RX MMG7.00 <<


        //Sipradi-YS ***9.9.2012*** BEGIN

        //******DELETING APPROVED WARRANTY*********
        IF "Warranty Approved" THEN BEGIN
        UserSetup.GET(USERID);
        IF UserSetup."Warranty Approver" THEN BEGIN
          IF CONFIRM(Text000,FALSE,FORMAT(Type),"No.") THEN BEGIN
            WarrantyRegister.RESET;
            WarrantyRegister.SETCURRENTKEY("Serv. Order No.");
            WarrantyRegister.SETRANGE("Serv. Order No.","Document No.");
            IF Type = Type::Item THEN BEGIN
              WarrantyRegister.SETRANGE("Item No.","No.");
              IF WarrantyRegister.FINDFIRST THEN
                WarrantyRegister.DELETE;
            END
            ELSE IF Type = Type::Labor THEN BEGIN
              WarrantyRegister.SETRANGE("Labor Code (System)","No.");
              IF WarrantyRegister.FINDFIRST THEN
                WarrantyRegister.DELETE;
            END;
          END
          ELSE
            ERROR(Text001);
        END
        ELSE
          ERROR(Text002);
        END;

        //*******DELETING PENDING WARRANTY*********
        IF "Warranty Claim No." <> '' THEN BEGIN
          WarrAppLine.RESET;
          WarrAppLine.SETCURRENTKEY("Serv. Order No.");
          WarrAppLine.SETRANGE("Serv. Order No.","Document No.");
          IF Type = Type::Item THEN BEGIN
            WarrAppLine.SETRANGE("Item No.","No.");
            IF WarrAppLine.FINDFIRST THEN
              WarrAppLine.DELETE;
          END
          ELSE IF Type = Type::Labor THEN BEGIN
            WarrAppLine.SETRANGE("Labor Code (System)","No.");
            IF WarrAppLine.FINDFIRST THEN
              WarrAppLine.DELETE;
          END;
        END;
        //Sipradi-YS ***9.9.2012*** END
    end;

    trigger OnInsert()
    var
        ServiceHeader: Record "25006145";
    begin

        IF "Document Type" = "Document Type"::Order THEN
          ServiceStepsChecking.CheckSteps("Document No.",Steps::CheckDiagnosis);
        TestStatusOpen;

        IF (("Document Type" = "Document Type"::Quote)) AND
            ("No." <> '')
          THEN BEGIN
          IF ((Type = Type::Item) OR (Type = Type::Labor)) AND  (Quantity <= 0) THEN
            ERROR(QtyError);
        END;
        IF Quantity <> 0 THEN
         ReserveServiceLine.VerifyQuantity(Rec,xRec);
        LOCKTABLE;
        ServiceHeader."No." := '';
    end;

    trigger OnModify()
    begin
        IF ((Quantity <> 0) OR (xRec.Quantity <> 0)) AND ItemExists(xRec."No.") THEN
          ReserveServiceLine.VerifyChange(Rec,xRec);

        IF "Document Type" = "Document Type"::Quote THEN BEGIN
          IF ((Type = Type::Item) OR (Type = Type::Labor)) AND  (Quantity <= 0) THEN
            ERROR(QtyError);
        END;
    end;

    var
        UserSetup: Record "91";
        GLAcc: Record "15";
        Currency: Record "4";
        StdTxt: Record "7";
        UnitOfMeasure: Record "204";
        Resource: Record "156";
        PurchasingCode: Record "5721";
        SalesTaxCalculate: Codeunit "398";
        VATPostingSetup: Record "325";
        UOMMgt: Codeunit "5402";
        DimMgt: Codeunit "408";
        ServScheduleMgt: Codeunit "25006201";
        SalesPrice: Record "7002";
        ExtServ: Record "25006133";
        Item: Record "27";
        Location: Record "14";
        ShortcutDimCode: array [8] of Code[20];
        Text028: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text000: Label 'You cannot delete the order line because it is associated with purchase order %1 line %2.';
        Text001: Label 'You cannot rename a %1.';
        Text002: Label 'You cannot change %1 because the order line is associated with purchase order %2 line %3.';
        Text012: Label 'Change %1 from %2 to %3?';
        Text014: Label '%1 %2 is before work date %3';
        tcSER001: Label 'You must set payment type dimension';
        tcSER002: Label 'Standard times are not set for labor %1';
        Labor: Record "25006121";
        TempServLine: Record "25006146";
        ExchRate: Record "330";
        Recreate: Boolean;
        tcRD001: Label 'Item sales amount cannot be less then cost amount';
        tcSER005: Label 'Resource %1 %2 has lower skill level than it''s required for labor %3 %4.';
        CreateInv: Codeunit "25006101";
        ReleaseSalesDoc: Codeunit "414";
        tcSER006: Label 'Can''t delete order line, because mechanic %1 have not finished allocation %2';
        LookUpMgt: Codeunit "25006003";
        SingleInstanceMgt: Codeunit "25006001";
        ServiceSetup: Record "25006120";
        ServiceScheduleSetup: Record "25006286";
        Text029: Label 'must be positive';
        Text030: Label 'must be negative';
        Text031: Label 'You must either specify %1 or %2.';
        Text041: Label 'You must cancel the existing approval for this document to be able to change the %1 field.';
        Text043: Label 'cannot be %1';
        Text044: Label 'cannot be less than %1';
        Text045: Label 'cannot be more than %1';
        Text047: Label 'must be positive when %1 is not 0';
        HideValidationDialog: Boolean;
        ServiceHeader: Record "25006145";
        Text048: Label 'Cannnot put-in/take-out item with sie assignments. Use SIE assignments.';
        Text120: Label 'Can not transfer if invoice exists!';
        EDMS001: Label 'Do you want to delete unfinished works for this order in service scheduler?';
        Text100: Label 'There is nothing to transfer!';
        PriceCalcMgt: Codeunit "7000";
        Text101: Label 'This line is assigned to a service package. If you change this field you''ll lose all special prices and discounts for this package. Are you sure?';
        LicensePermission: Record "2000000043";
        Text102: Label '%1 cannot be greater than %2';
        Text103: Label 'You cannot change Service Line Status.';
        HasBeenShown: Boolean;
        Text104: Label '%1 isn''t set in table %2 for combination %3 and %4.';
        Reservation: Page "498";
                         ReservEngineMgt: Codeunit "99000831";
                         ReservEntry: Record "337";
                         ReserveServiceLine: Codeunit "25006121";
                         ReservMgt: Codeunit "99000845";
                         FullAutoReservation: Boolean;
                         Text011: Label 'Automatic reservation is not possible.\Reserve items manually?';
        StatusCheckSuspended: Boolean;
        ItemSubstitutionMgt: Codeunit "5701";
        NonstockItemMgt: Codeunit "5703";
        VFMgt: Codeunit "25006004";
        Tire: Record "25006180";
        Text105: Label 'This line is assigned to a service package. If you delete this line you''ll lose all special prices and discounts for this package. Are you sure?';
        PlannedShipmentDateCalculated: Boolean;
        PlannedDeliveryDateCalculated: Boolean;
        AddOnIntegrMgt: Codeunit "5403";
        CalendarMgmt: Codeunit "7600";
        CalChange: Record "7602";
        ShippingAgentServices: Record "5790";
        ResourceTextFieldValue: Text[250];
        ResourceTextFieldModified: Boolean;
        ServiceLinePrevParcedRsc: Record "25006146" temporary;
        ServLaborApplicationGlobTmp: Record "25006277" temporary;
        Text121: Label 'There prepayment part of Sell-To is bigger than amount of total document split.';
        Text122: Label 'There prepayment part of Bill-To is bigger than amount of total document split.';
        ServiceTransferMgt: Codeunit "25006010";
        Text123: Label 'Do you wish to delete assigned Transfer Line %1 %2, %3 %4?';
        Text124: Label 'You can''t delete Service Line if exist assigned Transfer Line!';
        Text040: Label 'You must use form %1 to enter %2, if item tracking is used.';
        Text039: Label '%1 units for %2 %3 have already been returned. Therefore, only %4 units can be returned.';
        Text046: Label 'You cannot return more than the %1 units that you have shipped for %2 %3.';
        Text125: Label 'Quantity can''t be less than Transfered Quantity!';
        Text126: Label 'Quantity can''t be changed if exist Transfer Order No.%1! First change Quantity in Transfer Order.';
        Text127: Label '%1 cannot be zero for %2 %3';
        ServiceStepsChecking: Codeunit "33020236";
        Steps: Option CheckBay,CheckChecklist,CheckDiagnosis;
        JobTypeMaster: Record "33020235";
        ServiceHeaderEDMS: Record "25006145";
        FixedPrice: Boolean;
        ServSchemeLine: Record "33019862";
        ValueAddServ: Record "33019871";
        SchemeVehTracking: Record "33019875";
        QtyError: Label 'Quantity Cannot be 0.';
        NoValidUnitPrice: Label 'You Cannot Enter Unit Price for Non-Billable Customer %1.';
        NegReservEntry: Record "337";
        ChangedbySystem: Boolean;
        ReservedFromItemLedgEntryErr: Label 'You cannot change the quantity of item %1 which are reserved. Please use qty. to return for returning the item.';
        ServiceSchemeHeader: Record "33019873";
        InventorySet: Record "313";

    local procedure GetItem()
    begin
        TESTFIELD("No.");
        IF "No." <> Item."No." THEN
          Item.GET("No.");
    end;

    local procedure GetServiceHeader()
    begin
        TESTFIELD("Document No.");
        IF ("Document Type" <> ServiceHeader."Document Type") OR ("Document No." <> ServiceHeader."No.") THEN BEGIN
          ServiceHeader.GET("Document Type","Document No.");

          IF(ServiceHeader."Document Type" <> ServiceHeader."Document Type"::Quote) AND (ServiceHeader."Quote No." = '') THEN BEGIN
            ServiceHeader.TESTFIELD("Job Type");
            ServiceHeader.TESTFIELD("Promised Delivery Date");
          END;
          IF ServiceSetup."Check Kilometrage on Release" THEN
            ServiceHeader.TESTFIELD(Kilometrage);

          IF ServiceHeader."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
          ELSE BEGIN
            ServiceHeader.TESTFIELD("Currency Factor");
            Currency.GET(ServiceHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
          END;
        END;
    end;

    local procedure GetUnitCost()
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        GetItem;
        "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
          VALIDATE("Unit Cost (LCY)",Item."Unit Cost" * "Qty. per Unit of Measure");
    end;

    local procedure TestStatusOpen()
    begin
        GetServiceHeader;
        IF NOT "System-Created Entry" THEN
          IF Type <> Type::" " THEN
            ServiceHeader.TESTFIELD(Status,ServiceHeader.Status::Open);
    end;

    [Scope('Internal')]
    procedure GetItemTranslation()
    var
        ItemTranslation: Record "30";
    begin
        GetServiceHeader;
        IF ItemTranslation.GET("No.","Variant Code",ServiceHeader."Language Code") THEN BEGIN
          Description := ItemTranslation.Description;
          "Description 2" := ItemTranslation."Description 2";
        END;
    end;

    [Scope('Internal')]
    procedure UpdateAmounts()
    begin
        GetServiceHeader;
        IF "Line Amount" <> xRec."Line Amount" THEN
          "VAT Difference" := 0;
        IF "Line Amount" <> ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - "Line Discount Amount" THEN BEGIN
          "Line Amount" := ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - "Line Discount Amount";
          "VAT Difference" := 0;
        END;

        //27.01.2010 EDMSB P2 >>
        IF  ((CurrFieldNo = FIELDNO("Line Discount %")) OR (CurrFieldNo = FIELDNO("Line Discount Amount"))) THEN
          CheckDiscount;
        //27.01.2010 EDMSB P2 <<

        // IF ServiceHeader.Status = ServiceHeader.Status::Released THEN  // 12.05.2016 EB.P30 GH
          UpdateVATAmounts;
        //08-05-2007 EDMS P3 PREPMT >>
        IF "Prepayment %" <> 0 THEN BEGIN
          IF Quantity < 0 THEN
            FIELDERROR(Quantity,STRSUBSTNO(Text047,FIELDCAPTION("Prepayment %")));
          IF "Unit Price" < 0 THEN
            FIELDERROR("Unit Price",STRSUBSTNO(Text047,FIELDCAPTION("Prepayment %")));
        END;
        "Prepmt. Line Amount" := ROUND("Line Amount" * "Prepayment %" / 100,Currency."Amount Rounding Precision");
        IF "Prepmt. Line Amount" < "Prepmt. Amt. Inv." THEN
          FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text044,"Prepmt. Amt. Inv."));
        //08-05-2007 EDMS P3 PREPMT <<

        InitOutstandingAmount;

        //23.10.2007. EDMS P2 >>
        ApplyMarkupRestrictions(0)
        //23.10.2007. EDMS P2 <<
    end;

    [Scope('Internal')]
    procedure UpdateVATAmounts()
    var
        ServLine2: Record "25006146";
        TotalLineAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalQuantityBase: Decimal;
        TotalInvDiscAmount: Decimal;
    begin

        ServLine2.SETRANGE("Document Type","Document Type");
        ServLine2.SETRANGE("Document No.","Document No.");
        ServLine2.SETFILTER("Line No.",'<>%1',"Line No.");
        IF "Line Amount" = 0 THEN
          IF xRec."Line Amount" >= 0 THEN
            ServLine2.SETFILTER(Amount,'>%1',0)
          ELSE
            ServLine2.SETFILTER(Amount,'<%1',0)
        ELSE
          IF "Line Amount" > 0 THEN
            ServLine2.SETFILTER(Amount,'>%1',0)
          ELSE
            ServLine2.SETFILTER(Amount,'<%1',0);
        ServLine2.SETRANGE("VAT Identifier","VAT Identifier");
        ServLine2.SETRANGE("Tax Group Code","Tax Group Code");

        IF "Line Amount" = "Inv. Discount Amount" THEN BEGIN
          Amount := 0;
          "VAT Base Amount" := 0;
          "Amount Including VAT" := 0;
          IF "Line No." <> 0 THEN
            IF MODIFY THEN
              IF ServLine2.FINDLAST THEN BEGIN
                ServLine2.UpdateAmounts;
                ServLine2.MODIFY;
              END;
        END ELSE BEGIN
          TotalLineAmount := 0;
          TotalInvDiscAmount := 0;
          TotalAmount := 0;
          TotalAmountInclVAT := 0;
          TotalQuantityBase := 0;
            IF ("VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax") OR
             (("VAT Calculation Type" IN
             ["VAT Calculation Type"::"Normal VAT","VAT Calculation Type"::"Reverse Charge VAT"]) AND ("VAT %" <> 0))
          THEN BEGIN
            IF ServLine2.FINDSET THEN
              REPEAT
                TotalLineAmount := TotalLineAmount + ServLine2."Line Amount";
                TotalInvDiscAmount := TotalInvDiscAmount + ServLine2."Inv. Discount Amount";
                TotalAmount := TotalAmount + ServLine2.Amount;
                TotalAmountInclVAT := TotalAmountInclVAT + ServLine2."Amount Including VAT";
                TotalQuantityBase := TotalQuantityBase + ServLine2."Quantity (Base)";
              UNTIL ServLine2.NEXT = 0;
          END;

          IF ServiceHeader."Prices Including VAT" THEN
            CASE "VAT Calculation Type" OF
              "VAT Calculation Type"::"Normal VAT",
              "VAT Calculation Type"::"Reverse Charge VAT":
                BEGIN
                  Amount :=
                    ROUND(
                      (TotalLineAmount  - TotalInvDiscAmount + "Line Amount" - "Inv. Discount Amount") / (1 + "VAT %" / 100),
                      Currency."Amount Rounding Precision") -
                    TotalAmount;
                  "VAT Base Amount" :=
                    ROUND(
                      Amount * (1 - ServiceHeader."VAT Base Discount %" / 100),
                      Currency."Amount Rounding Precision");
                  "Amount Including VAT" :=
                    TotalLineAmount + "Line Amount" +
                    ROUND(
                      (TotalAmount + Amount) * (ServiceHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                      Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
                    TotalAmountInclVAT;
                END;
              "VAT Calculation Type"::"Full VAT":
                BEGIN
                  Amount := 0;
                  "VAT Base Amount" := 0;
                END;
              "VAT Calculation Type"::"Sales Tax":
                BEGIN
                  ServiceHeader.TESTFIELD("VAT Base Discount %",0);
                  Amount :=
                    SalesTaxCalculate.ReverseCalculateTax(
                      "Tax Area Code","Tax Group Code","Tax Liable",ServiceHeader."Posting Date",
                      TotalAmountInclVAT + "Amount Including VAT",TotalQuantityBase + "Quantity (Base)",
                      ServiceHeader."Currency Factor") -
                    TotalAmount;
                  IF Amount <> 0 THEN
                    "VAT %" :=
                      ROUND(100 * ("Amount Including VAT" - Amount) / Amount,0.00001)
                  ELSE
                    "VAT %" := 0;
                  Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                  "VAT Base Amount" := Amount;
                END;
            END
          ELSE
            CASE "VAT Calculation Type" OF
              "VAT Calculation Type"::"Normal VAT",
              "VAT Calculation Type"::"Reverse Charge VAT":
                BEGIN
                  Amount := ROUND("Line Amount" - "Inv. Discount Amount",Currency."Amount Rounding Precision");
                  "VAT Base Amount" :=
                     ROUND(Amount * (1 - ServiceHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                  "Amount Including VAT" :=
                    TotalAmount + Amount +
                    ROUND(
                      (TotalAmount + Amount) * (1 - ServiceHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                      Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
                    TotalAmountInclVAT;
                END;
              "VAT Calculation Type"::"Full VAT":
                BEGIN
                  Amount := 0;
                  "VAT Base Amount" := 0;
                  "Amount Including VAT" := "Line Amount" - "Inv. Discount Amount";
                END;
              "VAT Calculation Type"::"Sales Tax":
                BEGIN
                  Amount := ROUND("Line Amount" - "Inv. Discount Amount",Currency."Amount Rounding Precision");
                  "VAT Base Amount" := Amount;
                  "Amount Including VAT" :=
                    TotalAmount + Amount +
                    ROUND(
                      SalesTaxCalculate.CalculateTax(
                        "Tax Area Code","Tax Group Code","Tax Liable",ServiceHeader."Posting Date",
                        (TotalAmount + Amount),(TotalQuantityBase + "Quantity (Base)"),
                        ServiceHeader."Currency Factor"),Currency."Amount Rounding Precision") -
                    TotalAmountInclVAT;
                  IF "VAT Base Amount" <> 0 THEN
                    "VAT %" :=
                      ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
                  ELSE
                    "VAT %" := 0;
                END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ShowNonstock()
    var
        NonstockItem: Record "5718";
        ItemCategory: Record "5722";
    begin
        //Upgrade 2017 >>
        // TESTFIELD(Type,Type::Item);
        // TESTFIELD("No.",'');
        // IF PAGE.RUNMODAL(PAGE::"Nonstock Item List",NonstockItem) = ACTION::LookupOK THEN BEGIN
        //  NonstockItem.TESTFIELD("Item Category Code");
        //
        //  ItemCategory.GET(NonstockItem."Item Category Code");
        //  ItemCategory.TESTFIELD("Def. Gen. Prod. Posting Group");
        //  ItemCategory.TESTFIELD("Def. Inventory Posting Group");
        //
        //  IF NonstockItem."Item No." = '' THEN
        //   BEGIN
        //    NonstockItemMgt.NonstockAutoItem(NonstockItem);
        //    NonstockItem.GET(NonstockItem."Entry No.");
        //    VALIDATE("No.", NonstockItem."Item No.");
        //   END
        //  ELSE
        //   BEGIN
        //    VALIDATE("No.", NonstockItem."Item No.");
        //   END;
        // END;
        //Upgrade 2017 <<
    end;

    local procedure GetDefaultBin()
    var
        WMSManagement: Codeunit "7302";
        WorkplaceMgt: Codeunit "25006002";
    begin
        IF NOT (Type IN [Type::Item,Type::"5"]) THEN
          EXIT;

        IF (Quantity * xRec.Quantity > 0) AND
           ("No." = xRec."No.") AND
           ("Location Code" = xRec."Location Code") AND
           ("Variant Code" = xRec."Variant Code")
        THEN
          EXIT;

        "Bin Code" := '';

        IF ("Location Code" <> '') AND ("No." <> '') THEN BEGIN
          GetLocation("Location Code");
          IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN
            WMSManagement.GetDefaultBin("No.","Variant Code","Location Code","Bin Code");
        END;
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
        IF LocationCode = '' THEN
          CLEAR(Location)
        ELSE
          IF Location.Code <> LocationCode THEN
            Location.GET(LocationCode);
    end;

    [Scope('Internal')]
    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Document Type","Document No.","Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;

    [Scope('Internal')]
    procedure CreateDim(Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20];Type3: Integer;No3: Code[20];Type4: Integer;No4: Code[20];Type5: Integer;No5: Code[20])
    var
        SourceCodeSetup: Record "242";
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;  //25.10.2013 EDMS P8
        No[4] := No4;
        // 10.03.2015 EDMS P21 >>
        TableID[5] := Type5;
        No[5] := No5;
        // 10.03.2015 EDMS P21 <<

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        GetServiceHeader;
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID,No,SourceCodeSetup."Service Management EDMS",
                             "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",
                              ServiceHeader."Dimension Set ID",DATABASE::Customer);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;

    [Scope('Internal')]
    procedure ShowCard()
    var
        Item: Record "27";
        Labor: Record "25006121";
        External: Record "25006133";
        GLAccount: Record "15";
    begin
        TESTFIELD("No.");
        CASE Type OF
         Type::"G/L Account":
          BEGIN
           GLAccount.GET("No.");
           PAGE.RUNMODAL(PAGE::"G/L Account Card",GLAccount);
          END;
         Type::Item,Type::"5":
          BEGIN
           Item.GET("No.");
           PAGE.RUNMODAL(PAGE::"Item Card",Item);
          END;
         Type::Labor:
          BEGIN
           Labor.GET("No.");
           PAGE.RUNMODAL(PAGE::"Service Labor Card",Labor);
          END;
         Type::"External Service":
          BEGIN
           External.GET("No.");
           PAGE.RUNMODAL(PAGE::"External Service Card",External);
          END;
        END;
    end;

    [Scope('Internal')]
    procedure GetStandardTime()
    var
        ServiceLaborStandardTime: Record "25006122";
        ServiceHeaderLocal: Record "25006145";
        Vehicle: Record "25006005";
        RecordRef1: RecordRef;
        RecordRef2: RecordRef;
        FieldRef1: FieldRef;
        FieldRef2: FieldRef;
        VFUsage1: Record "25006006";
        VFUsage2: Record "25006006";
        VariableField: Record "25006002";
    begin
        ServiceHeaderLocal.RESET;
        ServiceHeaderLocal.GET("Document Type","Document No.");
        Vehicle.RESET;
        IF NOT Vehicle.GET(ServiceHeaderLocal."Vehicle Serial No.") THEN
          EXIT;

        ServiceLaborStandardTime.SETFILTER("Labor No.","No.");
        IF  ServiceLaborStandardTime.ISEMPTY THEN
          EXIT;

        ServiceLaborStandardTime.SETFILTER("Make Code", '''''|%1', "Make Code");
        ServiceLaborStandardTime.SETFILTER("Model Code", '''''|%1', Vehicle."Model Code");

        ServiceLaborStandardTime.SETFILTER("Prod. Year From",'..%1',Vehicle."Production Year");
        ServiceLaborStandardTime.SETFILTER("Prod. Year To",'''''|%1..',Vehicle."Production Year");

        RecordRef2.OPEN(DATABASE::Vehicle);
        RecordRef2.GETTABLE(Vehicle);

        RecordRef1.OPEN(DATABASE::"Service Labor Standard Time");

        VFUsage1.RESET;
        VFUsage1.SETRANGE("Table No.",DATABASE::"Service Labor Standard Time");
        IF VFUsage1.FINDFIRST THEN
          REPEAT
            VFUsage2.RESET;
            VFUsage2.SETCURRENTKEY("Variable Field Code");
            VFUsage2.SETRANGE("Table No.",DATABASE::Vehicle);
            VFUsage2.SETRANGE("Variable Field Code",VFUsage1."Variable Field Code");
            IF VFUsage2.FINDFIRST THEN BEGIN
              VariableField.GET(VFUsage1."Variable Field Code");
              IF VariableField."Use In Filtering" THEN BEGIN
                FieldRef1 := RecordRef2.FIELD(VFUsage2."Field No.");
                RecordRef1.SETVIEW(ServiceLaborStandardTime.GETVIEW);
                FieldRef2 := RecordRef1.FIELD(VFUsage1."Field No.");
                FieldRef2.SETFILTER('''''|%1',FORMAT(FieldRef1.VALUE));
                ServiceLaborStandardTime.SETVIEW(RecordRef1.GETVIEW);
             END;
           END;
          UNTIL VFUsage1.NEXT = 0;

        IF ServiceLaborStandardTime.COUNT > 1 THEN BEGIN
          IF LookUpMgt.LookUpLaborStandardTime(ServiceLaborStandardTime,"Make Code","No.","Standard Time Line No.") THEN BEGIN
            "Standard Time Line No." :=ServiceLaborStandardTime."Line No.";
            VALIDATE("Standard Time",ServiceLaborStandardTime."Standard Time (Hours)");
            VALIDATE("Description 2",ServiceLaborStandardTime.Description);
          END;
        END ELSE BEGIN
          IF ServiceLaborStandardTime.FINDFIRST THEN BEGIN
            "Standard Time Line No." :=ServiceLaborStandardTime."Line No.";
            VALIDATE("Standard Time",ServiceLaborStandardTime."Standard Time (Hours)");
            VALIDATE("Description 2",ServiceLaborStandardTime.Description);
          END;
        END;
    end;

    [Scope('Internal')]
    procedure CallCreateDim()
    begin
        CreateDim(
          DATABASE::"Responsibility Center","Responsibility Center",
          DimMgt.TypeToTableID5(Type),"No.",
          DATABASE::Resource,'',
          DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
          DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
          );
    end;

    [Scope('Internal')]
    procedure SetRecreate(NewRecreate: Boolean)
    begin
        Recreate := NewRecreate
    end;

    [Scope('Internal')]
    procedure GetDescrLang()
    var
        ServiceHeader: Record "25006145";
    begin
        ServiceHeader.GET("Document Type","Document No.");
        IF ServiceHeader."Language Code" = '' THEN EXIT;
    end;

    [Scope('Internal')]
    procedure ShowResEntry()
    var
        ResEntry: Record "337";
    begin
        IF Type <> Type::Item THEN EXIT;
        ResEntry.SETCURRENTKEY("Reservation Status", "Item No.", "Variant Code", "Location Code");
        ResEntry.SETRANGE("Reservation Status", ResEntry."Reservation Status"::Reservation);
        ResEntry.SETRANGE("Item No.", "No.");
        PAGE.RUNMODAL(PAGE::"Reservation Entries",ResEntry);
    end;

    local procedure UpdateUnitPrice(CalledByFieldNo: Integer)
    begin
        IF (CalledByFieldNo <> CurrFieldNo) AND (CurrFieldNo <> 0) THEN
          EXIT;

        GetServiceHeader;
        CASE Type OF
          Type::Item:
            BEGIN
              TESTFIELD("Qty. per Unit of Measure");
            END;
          Type::"External Service",Type::Labor:
           BEGIN

           END;
        END;

        IF Type IN [Type::Item, Type::Labor, Type::"External Service"] THEN BEGIN
          CLEAR(PriceCalcMgt);
          PriceCalcMgt.FindDMSServLineLineDisc(ServiceHeader,Rec);
          PriceCalcMgt.FindDMSServLinePrice(ServiceHeader,Rec,CalledByFieldNo);
        END;
        VALIDATE("Unit Price");
    end;

    local procedure UpdateQtyHours(CalledByFieldNo: Integer)
    begin
        IF CalledByFieldNo = 0 THEN
          CalledByFieldNo := CurrFieldNo;

        CASE Type OF
          Type::Item:
            BEGIN
              EXIT;
            END;
          Type::Labor:
           BEGIN
            CASE CalledByFieldNo OF
              FIELDNO("Unit of Measure Code"), FIELDNO(Quantity), FIELDNO("Minutes Per UoM"), FIELDNO("No."):
                BEGIN
                  IF CalledByFieldNo IN [FIELDNO("Unit of Measure Code"), FIELDNO("No.")] THEN BEGIN
                    IF UnitOfMeasure.GET("Unit of Measure Code") THEN
                      "Minutes Per UoM" := UnitOfMeasure."Minutes Per UoM";
                  END;
                  "Quantity (Hours)" := (Quantity * "Minutes Per UoM")/60;
                END;
              FIELDNO("Quantity (Hours)"):
                BEGIN
                  IF Quantity = 0 THEN BEGIN
                    IF "Minutes Per UoM" > 0 THEN
                      Quantity := ("Quantity (Hours)" * 60/"Minutes Per UoM")
                    ELSE
                      Quantity := "Quantity (Hours)";
                  END;
                END;
            END;
           END;
        END;
    end;

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    var
        ServPricesIncVar: Integer;
        ServHeader: Record "25006145";
    begin
        IF NOT ServHeader.GET("Document Type","Document No.") THEN BEGIN
          ServHeader."No." := '';
          ServHeader.INIT;
        END;
        IF ServHeader."Prices Including VAT" THEN
          ServPricesIncVar := 1
        ELSE
          ServPricesIncVar := 0;
        CLEAR(ServHeader);
        EXIT('2,'+FORMAT(ServPricesIncVar)+',' + GetFieldCaption(FieldNumber));
    end;

    local procedure GetFieldCaption(FieldNumber: Integer): Text[100]
    var
        "Field": Record "2000000041";
    begin
        Field.GET(DATABASE::"Service Line EDMS",FieldNumber);
        EXIT(Field."Field Caption");
    end;

    [Scope('Internal')]
    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    [Scope('Internal')]
    procedure SetServHeader(NewServHeader: Record "25006145")
    begin
        ServiceHeader := NewServHeader;

        IF ServiceHeader."Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE BEGIN
          ServiceHeader.TESTFIELD("Currency Factor");
          Currency.GET(ServiceHeader."Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
    end;

    [Scope('Internal')]
    procedure CalcVATAmounts()
    var
        ServLine2: Record "25006146";
    begin
        IF ServiceHeader.Status <> ServiceHeader.Status::Released THEN EXIT;
        SETRANGE("Document Type",ServiceHeader."Document Type");
        SETRANGE("Document No.",ServiceHeader."No.");
        IF FINDFIRST THEN
        REPEAT
         UpdateVATAmounts;
         MODIFY
        UNTIL NEXT = 0;
    end;

    [Scope('Internal')]
    procedure ShowSIEAssgnt()
    var
        SIEAssgnt: Record "25006706";
        SIEAssgntsForm: Page "25006757";
    begin
        IF "Line No." = 0 THEN EXIT;
        GET("Document Type","Document No.","Line No.");
        TESTFIELD("No.");
        TESTFIELD(Type,Type::Item);

        CLEAR(SIEAssgnt);
        SIEAssgnt."Applies-to Type" := DATABASE::"Service Line EDMS";
        SIEAssgnt."Applies-to Doc. Type" := "Document Type";
        SIEAssgnt."Applies-to Doc. No." := "Document No.";
        SIEAssgnt."Applies-to Doc. Line No." := "Line No.";
        SIEAssgnt."Item No." := "No.";

        SIEAssgntsForm.Initialize(SIEAssgnt);
        SIEAssgntsForm.RUNMODAL;
    end;

    local procedure CalcUnitCost(ItemLedgEntry: Record "32"): Decimal
    var
        ValueEntry: Record "5802";
        UnitCost: Decimal;
    begin
        WITH ValueEntry DO BEGIN
          SETCURRENTKEY("Item Ledger Entry No.");
          SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
          CALCSUMS("Cost Amount (Actual)","Cost Amount (Expected)");
          UnitCost :=
            ("Cost Amount (Expected)" + "Cost Amount (Actual)") / ItemLedgEntry.Quantity;
        END;

        EXIT(ABS(UnitCost * "Qty. per Unit of Measure"));
    end;

    local procedure SelectItemEntry(CurrentFieldNo: Integer)
    var
        ItemLedgEntry: Record "32";
        ServLine3: Record "25006146";
    begin
        ItemLedgEntry.SETRANGE("Item No.","No.");
        ItemLedgEntry.SETRANGE(Correction,FALSE);
        IF "Location Code" <> '' THEN
          ItemLedgEntry.SETRANGE("Location Code","Location Code");

        IF CurrentFieldNo = FIELDNO("Appl.-to Item Entry") THEN BEGIN
          ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
          ItemLedgEntry.SETRANGE(Positive,TRUE);
          ItemLedgEntry.SETRANGE(Open,TRUE);
        END ELSE BEGIN
          ItemLedgEntry.SETCURRENTKEY("Item No.",Positive);
          ItemLedgEntry.SETRANGE(Positive,FALSE);
        END;
        IF PAGE.RUNMODAL(PAGE::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK THEN BEGIN
          ServLine3 := Rec;
          IF CurrentFieldNo = FIELDNO("Appl.-to Item Entry") THEN
            ServLine3.VALIDATE("Appl.-to Item Entry",ItemLedgEntry."Entry No.")
          ELSE                                                                                               // 31.03.2014 Elva Baltic P21
            ServLine3.VALIDATE("Appl.-from Item Entry",ItemLedgEntry."Entry No.");                           // 31.03.2014 Elva Baltic P21

          Rec := ServLine3;
        END;
    end;

    [Scope('Internal')]
    procedure NoAssistEdit()
    var
        NonstockItem: Record "5718";
        NonstockItemMgt: Codeunit "5703";
    begin
        //EDMS
        IF Type = Type::Item THEN
         BEGIN
          NonstockItem.RESET;
          IF LookUpMgt.LookUpNonstockItem(NonstockItem,"No.") THEN
           BEGIN
            IF NonstockItem."Item No." = '' THEN
             BEGIN
              NonstockItemMgt.NonstockAutoItem(NonstockItem);
              NonstockItem.GET(NonstockItem."Entry No.");
              VALIDATE("No.", NonstockItem."Item No.");
             END
            ELSE
             BEGIN
              VALIDATE("No.", NonstockItem."Item No.");
             END;
           END;
         END;
    end;

    [Scope('Internal')]
    procedure TransferLinePrepayment()
    var
        PrepMgt: Codeunit "441";
    begin
        TESTFIELD("Document No.");
        TESTFIELD("No.");
        TESTFIELD("Prepmt. Line Amount");
        PrepMgt.ServTranfLinePrep(Rec);
    end;

    [Scope('Internal')]
    procedure ApplyMarkupRestrictions(ActionType: Integer)
    var
        CurrencyExch: Record "330";
        LineSalesPrice: Decimal;
        LineCost: Decimal;
        Item: Record "27";
        LineMarkupPercent: Decimal;
        UserSetup: Record "91";
        ItemMarkupRestriction: Record "25006762";
        TextPercent: Label '%';
        TextMarkupRestriced: Label 'Item No. %1 must have at least %2 %3 markup.';
        ItemMarkupRestrictionGroup: Record "25006761";
        ItemLedgEntry: Record "32";
        ReservationEntry: Record "337";
        ReservationEntry2: Record "337";
        ItemCost2: Decimal;
    begin
        //ActioType = 0 => Value validation
        //ActioType = 1 => Document Release

        IF (Type <> Type::Item) OR ("Quantity (Base)" = 0) THEN
         EXIT;

        IF "No." = '' THEN
         EXIT;

        ServiceHeader.GET("Document Type","Document No.");

        IF UserSetup.GET(USERID) THEN BEGIN
          IF UserSetup."Item Markup Restriction Group" = '' THEN
            EXIT;
        END ELSE
         EXIT;

        ItemMarkupRestriction.RESET;
        ItemMarkupRestriction.SETFILTER("Group Code",'%1|''''',UserSetup."Item Markup Restriction Group");
        ItemMarkupRestriction.SETFILTER("Customer Price Group",'%1|''''',"Customer Price Group");
        ItemMarkupRestriction.SETFILTER("Item Category Code",'%1|''''',"Item Category Code");
        IF NOT ItemMarkupRestriction.FINDFIRST THEN
         EXIT;

        //22.10.2007. EDMS P2 >>
        ItemMarkupRestrictionGroup.GET(ItemMarkupRestriction."Group Code");
        //22.10.2007. EDMS P2 <<

        LineCost := 0;

        CASE ItemMarkupRestriction.Base OF
         ItemMarkupRestriction.Base::"Unit Cost":
          BEGIN
           //02.07.2008. EMDS P2 >>
           IF "Appl.-to Item Entry" <> 0 THEN BEGIN
             ItemLedgEntry.GET("Appl.-to Item Entry");
             ItemLedgEntry.CALCFIELDS("Cost Amount (Actual)");
             LineCost := ItemLedgEntry."Cost Amount (Actual)" / ItemLedgEntry.Quantity;
           END ELSE BEGIN
             IF Item.GET("No.") THEN
               LineCost := Item."Unit Cost";
           END;
          //02.07.2008. EDMS P2 <<

          IF "Currency Code" <> '' THEN
           LineSalesPrice := "Line Amount" / ServiceHeader."Currency Factor" / "Quantity (Base)"
          ELSE
           LineSalesPrice := "Line Amount" / "Quantity (Base)";

          END;
        END;

        LineCost := ROUND(LineCost, 0.01, '<');
        IF LineCost = 0 THEN
         EXIT;

          //Calculating Sales Price
         IF ServiceHeader."Prices Including VAT" THEN
          LineSalesPrice := ROUND(LineSalesPrice / (1 + "VAT %" / 100),0.00001);

         //AprÙÙinam uzcenojumu
         LineMarkupPercent:= 0;
         IF LineCost <> 0 THEN
          LineMarkupPercent := (LineSalesPrice - LineCost)/LineCost*100;

         CASE ActionType OF
          0: //validation
           BEGIN
            IF LineMarkupPercent < ItemMarkupRestriction."Min. Markup %" THEN
             MESSAGE(TextMarkupRestriced,"No.",ItemMarkupRestriction."Min. Markup %",TextPercent);
           END;
          1: //release
           BEGIN
            IF LineMarkupPercent < ItemMarkupRestriction."Min. Markup %" THEN
             //22.10.2007. EDMS P2 >>
             IF ItemMarkupRestrictionGroup."Notification Type" = ItemMarkupRestrictionGroup."Notification Type"::Error THEN
               ERROR(TextMarkupRestriced,"No.",ItemMarkupRestriction."Min. Markup %",TextPercent)
             ELSE
               MESSAGE(TextMarkupRestriced,"No.",ItemMarkupRestriction."Min. Markup %",TextPercent);
             //22.10.2007. EDMS P2 <<
           END;
         END;
    end;

    [Scope('Internal')]
    procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TESTFIELD("Qty. per Unit of Measure");
        EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    end;

    [Scope('Internal')]
    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    var
        Item: Record "27";
        ServiceHeader: Record "25006145";
        UserProfile: Record "25006067";
        SingleInstanceMgt: Codeunit "25006001";
        LocationCode: Code[20];
        ItemAvailByDate: Page "157";
                             ItemAvailByVar: Page "5414";
                             ItemAvailByLoc: Page "492";
                             UserProfileMgt: Codeunit "25006002";
    begin
        ServiceHeader.GET("Document Type", "Document No.");

        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        Item.RESET;
        Item.GET("No.");
        Item.SETRANGE("No.","No.");
        Item.SETRANGE("Date Filter",0D, ServiceHeader."Document Date");

        //24.02.2010 EDMSB P2 >>
        LocationCode := "Location Code";
        IF UserProfile.GET(UserProfileMgt.CurrProfileID) AND (UserProfile."Def. Spare Part Location Code" <> '') THEN
          LocationCode := UserProfile."Def. Spare Part Location Code";
        //24.02.2010 EDMSB P2 <<

        CASE AvailabilityType OF
          AvailabilityType::Date:
            BEGIN
              Item.SETRANGE("Variant Filter","Variant Code");
              Item.SETRANGE("Location Filter",LocationCode);
              CLEAR(ItemAvailByDate);
              ItemAvailByDate.LOOKUPMODE(TRUE);
              ItemAvailByDate.SETRECORD(Item);
              ItemAvailByDate.SETTABLEVIEW(Item);
              IF ItemAvailByDate.RUNMODAL = ACTION::LookupOK THEN
                IF ServiceHeader."Document Date" <> ItemAvailByDate.GetLastDate THEN
                  IF CONFIRM(
                       Text012,TRUE,ServiceHeader.FIELDCAPTION("Document Date"),ServiceHeader."Document Date",
                       ItemAvailByDate.GetLastDate)
                  THEN BEGIN
                    IF CurrFieldNo <> 0 THEN
                      xRec := Rec;
                    //serviceheader.VALIDATE("document Date",ItemAvailByDate.GetLastDate);
                  END;
            END;
          AvailabilityType::Variant:
            BEGIN
              Item.SETRANGE("Location Filter",LocationCode);
              CLEAR(ItemAvailByVar);
              ItemAvailByVar.LOOKUPMODE(TRUE);
              ItemAvailByVar.SETRECORD(Item);
              ItemAvailByVar.SETTABLEVIEW(Item);
              IF ItemAvailByVar.RUNMODAL = ACTION::LookupOK THEN
                IF "Variant Code" <> ItemAvailByVar.GetLastVariant THEN
                  IF CONFIRM(
                       Text012,TRUE,FIELDCAPTION("Variant Code"),"Variant Code",
                       ItemAvailByVar.GetLastVariant)
                  THEN BEGIN
                    IF CurrFieldNo = 0 THEN
                      xRec := Rec;
                    //VALIDATE("Variant Code",ItemAvailByVar.GetLastVariant);
                  END;
            END;
          AvailabilityType::Location:
            BEGIN
              Item.SETRANGE("Variant Filter","Variant Code");
              CLEAR(ItemAvailByLoc);
              ItemAvailByLoc.LOOKUPMODE(TRUE);
              ItemAvailByLoc.SETRECORD(Item);
              ItemAvailByLoc.SETTABLEVIEW(Item);
              IF ItemAvailByLoc.RUNMODAL = ACTION::LookupOK THEN
                IF "Location Code" <> ItemAvailByLoc.GetLastLocation THEN
                  IF CONFIRM(
                       Text012,TRUE,FIELDCAPTION("Location Code"),"Location Code",
                       ItemAvailByLoc.GetLastLocation)
                  THEN BEGIN
                    IF CurrFieldNo = 0 THEN
                      xRec := Rec;
                    //VALIDATE("Location Code",ItemAvailByLoc.GetLastLocation);
                  END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ShowItemSub()
    var
        ItemSubstitutionMgt: Codeunit "5701";
        TransferExtendedText: Codeunit "378";
    begin
        TestStatusOpen;
        ItemSubstitutionMgt.ItemSubstGetService(Rec);
        IF TransferExtendedText.ServCheckIfAnyExtTextEDMS(Rec,TRUE) THEN
          TransferExtendedText.InsertServExtTextEDMS(Rec);
    end;

    [Scope('Internal')]
    procedure CheckSPackage(ChangedField: Integer;RunMode: Integer)
    var
        ServLine: Record "25006146";
        ServicePackage: Record "25006134";
        ConfirmText: Text[250];
    begin
        //RunMode = 0, evaluated at line modify, 1 - deletion of line process;
        ServiceSetup.GET;
        IF NOT ServiceSetup."Control Package Consistency" THEN
         EXIT;

        //IF ("Package No." <> '') AND (CurrFieldNo = ChangedField) AND (CurrFieldNo <> 0) THEN BEGIN
        IF ("Package No." <> '') AND ((CurrFieldNo = ChangedField) OR (RunMode = 1)) THEN BEGIN
          ServicePackage.GET("Package No.");
          IF NOT ServicePackage."Fixed Prices and Discounts" THEN
            EXIT;
          CASE RunMode OF
            0: BEGIN
              ConfirmText := Text101;
            END;
            1: BEGIN
              ConfirmText := Text105;
            END;
          END;
          IF CONFIRM(ConfirmText,TRUE) THEN BEGIN
            ServLine.SETRANGE("Document Type","Document Type");
            ServLine.SETRANGE("Document No.","Document No.");
            ServLine.SETRANGE("Package No.","Package No.");
            ServLine.SETRANGE("Package Version No.","Package Version No.");
            ServLine.SETFILTER("Line No.",'<>%1',"Line No.");
            IF ServLine.FINDSET THEN
             REPEAT
              ServLine."Package No." := '';
              ServLine."Package Version No." := 0;
              ServLine."Package Version Spec. Line No." := 0;
              ServLine.VALIDATE("Package Version Spec. Line No.");
              ServLine.MODIFY
             UNTIL ServLine.NEXT = 0;
            "Package No." := '';
            "Package Version No." := 0;
            "Package Version Spec. Line No." := 0;
            MODIFY;
            VALIDATE("Package Version Spec. Line No.");
          END ELSE ERROR('');
        END;
    end;

    [Scope('Internal')]
    procedure CalcVATAmountLines(QtyType: Option General,Invoicing,Shipping;var ServiceHeader: Record "25006145";var ServiceLine: Record "25006146";var VATAmountLine: Record "290")
    var
        PrevVatAmountLine: Record "290";
        Currency: Record "4";
        SalesTaxCalculate: Codeunit "398";
        QtyFactor: Decimal;
        SalesSetup: Record "311";
        ServiceLine2: Record "25006146";
        RoundingLineInserted: Boolean;
        TotalVATAmount: Decimal;
    begin
        IF ServiceHeader."Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE
          Currency.GET(ServiceHeader."Currency Code");

        VATAmountLine.DELETEALL;

        WITH ServiceLine DO BEGIN
          SETRANGE("Document Type",ServiceHeader."Document Type");
          SETRANGE("Document No.",ServiceHeader."No.");
          SETFILTER(Type,'>0');
          SETFILTER(Quantity,'<>0');
          SETRANGE("Prepayment Line",FALSE);
          ServiceSetup.GET;
          IF SalesSetup."Invoice Rounding" THEN BEGIN
            ServiceLine2.COPYFILTERS(ServiceLine);
            RoundingLineInserted := ServiceLine.COUNT <> ServiceLine2.COUNT;
          END;
          SETRANGE("Prepayment Line");
          IF FINDSET THEN
            REPEAT
              IF "VAT Calculation Type" IN
                 ["VAT Calculation Type"::"Reverse Charge VAT","VAT Calculation Type"::"Sales Tax"]
              THEN
                "VAT %" := 0;
              IF NOT VATAmountLine.GET(
                "VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0)
              THEN BEGIN
                VATAmountLine.INIT;
                VATAmountLine."VAT Identifier" := "VAT Identifier";
                VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                VATAmountLine."Tax Group Code" := "Tax Group Code";
                VATAmountLine."VAT %" := "VAT %";
                VATAmountLine.Modified := TRUE;
                VATAmountLine.Positive := "Line Amount" >= 0;
                VATAmountLine.INSERT;
              END;
              CASE QtyType OF
                QtyType::General :
                  BEGIN
                    VATAmountLine.Quantity := VATAmountLine.Quantity + "Quantity (Base)";
                    VATAmountLine."Line Amount" := VATAmountLine."Line Amount" + "Line Amount";
                    IF "Allow Invoice Disc." THEN
                      VATAmountLine."Inv. Disc. Base Amount" :=
                        VATAmountLine."Inv. Disc. Base Amount" + "Line Amount";
                      VATAmountLine."Invoice Discount Amount" :=
                        VATAmountLine."Invoice Discount Amount" + "Inv. Discount Amount";
                    VATAmountLine."VAT Difference" := VATAmountLine."VAT Difference" + "VAT Difference";

                    IF "Prepayment Line" THEN
                      VATAmountLine."Includes Prepayment" := TRUE;  //08-05-2007 EDMS P3 PREPMT

                    VATAmountLine.MODIFY;
                  END;
                QtyType::Invoicing :
                  BEGIN
                    CASE TRUE OF
                      ("Document Type" IN ["Document Type"::Order]) AND
                      ServiceHeader.Invoice:
                        BEGIN
                            QtyFactor := Quantity / Quantity;
                            VATAmountLine.Quantity := VATAmountLine.Quantity + "Quantity (Base)";
                        END;
                      ("Document Type" IN ["Document Type"::"Return Order"]) AND
                      ServiceHeader.Invoice:
                        BEGIN
                          QtyFactor := Quantity / Quantity;
                          VATAmountLine.Quantity :=
                            VATAmountLine.Quantity + Quantity;
                        END;
                    ELSE
                      BEGIN
                        QtyFactor := Quantity / Quantity;
                        VATAmountLine.Quantity := VATAmountLine.Quantity + Quantity;
                      END;
                    END;
                    VATAmountLine."Line Amount" :=
                      VATAmountLine."Line Amount" +
                      ROUND("Line Amount" * QtyFactor,Currency."Amount Rounding Precision");
                    IF "Allow Invoice Disc." THEN
                      VATAmountLine."Inv. Disc. Base Amount" :=
                        VATAmountLine."Inv. Disc. Base Amount" +
                        ROUND("Line Amount" * QtyFactor,Currency."Amount Rounding Precision");
                    VATAmountLine."Invoice Discount Amount" :=
                      VATAmountLine."Invoice Discount Amount" +
                      ROUND("Inv. Discount Amount" * QtyFactor,Currency."Amount Rounding Precision");
                    VATAmountLine."VAT Difference" := VATAmountLine."VAT Difference" + "VAT Difference";

                    IF "Prepayment Line" THEN
                      VATAmountLine."Includes Prepayment" := TRUE;  //08-05-2007 EDMS P3 PREPMT

                    VATAmountLine.MODIFY;
                  END;
              END;
              IF RoundingLineInserted THEN
                TotalVATAmount := TotalVATAmount + "Amount Including VAT" - Amount + "VAT Difference";
            UNTIL NEXT = 0;
          SETRANGE(Type);
          SETRANGE(Quantity);
        END;

        WITH VATAmountLine DO
          IF FINDSET THEN
            REPEAT
              IF (PrevVatAmountLine."VAT Identifier" <> VATAmountLine."VAT Identifier") OR
                 (PrevVatAmountLine."VAT Calculation Type" <> VATAmountLine."VAT Calculation Type") OR
                 (PrevVatAmountLine."Tax Group Code" <> VATAmountLine."Tax Group Code") OR
                 (PrevVatAmountLine."Use Tax" <> VATAmountLine."Use Tax")
              THEN
                PrevVatAmountLine.INIT;
              IF ServiceHeader."Prices Including VAT" THEN BEGIN
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Normal VAT",
                  "VAT Calculation Type"::"Reverse Charge VAT":
                    BEGIN
                      "VAT Base" :=
                        ROUND(
                          ("Line Amount" - "Invoice Discount Amount") / (1 + "VAT %" / 100),
                          Currency."Amount Rounding Precision") - "VAT Difference";
                      "VAT Amount" :=
                        "VAT Difference" +
                        ROUND(
                          PrevVatAmountLine."VAT Amount" +
                          ("Line Amount" - "Invoice Discount Amount" - "VAT Base" - "VAT Difference") *
                          (1 - ServiceHeader."VAT Base Discount %" / 100),
                          Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                      "Amount Including VAT" := "VAT Base" + "VAT Amount";
                      IF Positive THEN
                        PrevVatAmountLine.INIT
                      ELSE BEGIN
                        PrevVatAmountLine := VATAmountLine;
                        PrevVatAmountLine."VAT Amount" :=
                          ("Line Amount" - "Invoice Discount Amount" - "VAT Base" - "VAT Difference") *
                          (1 - ServiceHeader."VAT Base Discount %" / 100);
                        PrevVatAmountLine."VAT Amount" :=
                          PrevVatAmountLine."VAT Amount" -
                          ROUND(PrevVatAmountLine."VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                      END;
                    END;
                  "VAT Calculation Type"::"Full VAT":
                    BEGIN
                      "VAT Base" := 0;
                      "VAT Amount" := "VAT Difference" + "Line Amount" - "Invoice Discount Amount";
                      "Amount Including VAT" := "VAT Amount";
                    END;
                  "VAT Calculation Type"::"Sales Tax":
                    BEGIN
                      "Amount Including VAT" := "Line Amount" - "Invoice Discount Amount";
                      "VAT Base" :=
                        ROUND(
                          SalesTaxCalculate.ReverseCalculateTax(
                            ServiceHeader."Tax Area Code","Tax Group Code",ServiceHeader."Tax Liable",
                            ServiceHeader."Posting Date","Amount Including VAT",Quantity,ServiceHeader."Currency Factor"),
                          Currency."Amount Rounding Precision");
                      "VAT Amount" := "VAT Difference" + "Amount Including VAT" - "VAT Base";
                      IF "VAT Base" = 0 THEN
                        "VAT %" := 0
                      ELSE
                        "VAT %" := ROUND(100 * "VAT Amount" / "VAT Base",0.00001);
                    END;
                END;
              END ELSE BEGIN
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Normal VAT",
                  "VAT Calculation Type"::"Reverse Charge VAT":
                    BEGIN
                      "VAT Base" := "Line Amount" - "Invoice Discount Amount";
                      "VAT Amount" :=
                        "VAT Difference" +
                        ROUND(
                          PrevVatAmountLine."VAT Amount" +
                          "VAT Base" * "VAT %" / 100 * (1 - ServiceHeader."VAT Base Discount %" / 100),
                          Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                      "Amount Including VAT" := "Line Amount" - "Invoice Discount Amount" + "VAT Amount";
                      IF Positive THEN
                        PrevVatAmountLine.INIT
                      ELSE BEGIN
                        PrevVatAmountLine := VATAmountLine;
                        PrevVatAmountLine."VAT Amount" :=
                          "VAT Base" * "VAT %" / 100 * (1 - ServiceHeader."VAT Base Discount %" / 100);
                        PrevVatAmountLine."VAT Amount" :=
                          PrevVatAmountLine."VAT Amount" -
                          ROUND(PrevVatAmountLine."VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                      END;
                    END;
                  "VAT Calculation Type"::"Full VAT":
                    BEGIN
                      "VAT Base" := 0;
                      "VAT Amount" := "VAT Difference" + "Line Amount" - "Invoice Discount Amount";
                      "Amount Including VAT" := "VAT Amount";
                    END;
                  "VAT Calculation Type"::"Sales Tax":
                    BEGIN
                      "VAT Base" := "Line Amount" - "Invoice Discount Amount";
                      "VAT Amount" :=
                        SalesTaxCalculate.CalculateTax(
                          ServiceHeader."Tax Area Code","Tax Group Code",ServiceHeader."Tax Liable",
                          ServiceHeader."Posting Date","VAT Base",Quantity,ServiceHeader."Currency Factor");
                      IF "VAT Base" = 0 THEN
                        "VAT %" := 0
                      ELSE
                        "VAT %" := ROUND(100 * "VAT Amount" / "VAT Base",0.00001);
                      "VAT Amount" :=
                        "VAT Difference" +
                        ROUND("VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                      "Amount Including VAT" := "VAT Base" + "VAT Amount";
                    END;
                END;
              END;
              IF RoundingLineInserted THEN
                TotalVATAmount := TotalVATAmount - "VAT Amount";
              "Calculated VAT Amount" := "VAT Amount" - "VAT Difference";
              MODIFY;
            UNTIL NEXT = 0;

        IF RoundingLineInserted AND (TotalVATAmount <> 0) THEN
          IF VATAmountLine.GET(ServiceLine."VAT Identifier",ServiceLine."VAT Calculation Type",
               ServiceLine."Tax Group Code",FALSE,ServiceLine."Line Amount" >= 0)
          THEN BEGIN
            VATAmountLine."VAT Amount" := VATAmountLine."VAT Amount" + TotalVATAmount;
            VATAmountLine."Amount Including VAT" := VATAmountLine."Amount Including VAT" + TotalVATAmount;
            VATAmountLine."Calculated VAT Amount" := VATAmountLine."Calculated VAT Amount" + TotalVATAmount;
            VATAmountLine.MODIFY;
          END;
    end;

    local procedure GetAbsMin(QtyToHandle: Decimal;QtyHandled: Decimal): Decimal
    begin
        IF ABS(QtyHandled) < ABS(QtyToHandle) THEN
          EXIT(QtyHandled)
        ELSE
          EXIT(QtyToHandle);
    end;

    [Scope('Internal')]
    procedure SetHasBeenShown()
    begin
        HasBeenShown := TRUE;
    end;

    [Scope('Internal')]
    procedure UpdateVATOnLines(QtyType: Option General,Invoicing,Shipping;var ServiceHeader: Record "25006145";var ServiceLine: Record "25006146";var VATAmountLine: Record "290")
    var
        TempVATAmountLineRemainder: Record "290" temporary;
        Currency: Record "4";
        RecRef: RecordRef;
        xRecRef: RecordRef;
        ChangeLogMgt: Codeunit "423";
        NewAmount: Decimal;
        NewAmountIncludingVAT: Decimal;
        NewVATBaseAmount: Decimal;
        VATAmount: Decimal;
        VATDifference: Decimal;
        InvDiscAmount: Decimal;
        LineAmountToInvoice: Decimal;
    begin
        IF QtyType = QtyType::Shipping THEN
          EXIT;
        IF ServiceHeader."Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE
          Currency.GET(ServiceHeader."Currency Code");

        TempVATAmountLineRemainder.DELETEALL;

        WITH ServiceLine DO BEGIN
          SETRANGE("Document Type",ServiceHeader."Document Type");
          SETRANGE("Document No.",ServiceHeader."No.");
          SETFILTER(Type,'>0');
          SETFILTER(Quantity,'<>0');
          LOCKTABLE;
          IF FINDSET THEN
            REPEAT
              VATAmountLine.GET("VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0);
              IF VATAmountLine.Modified THEN BEGIN
                xRecRef.GETTABLE(ServiceLine);
                IF NOT TempVATAmountLineRemainder.GET(
                  "VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0)
                THEN BEGIN
                  TempVATAmountLineRemainder := VATAmountLine;
                  TempVATAmountLineRemainder.INIT;
                  TempVATAmountLineRemainder.INSERT;
                END;

                IF QtyType = QtyType::General THEN
                  LineAmountToInvoice := "Line Amount"
                ELSE
                  LineAmountToInvoice :=
                    ROUND("Line Amount" * Quantity / Quantity,Currency."Amount Rounding Precision");

                IF "Allow Invoice Disc." THEN BEGIN
                  IF VATAmountLine."Inv. Disc. Base Amount" = 0 THEN
                    InvDiscAmount := 0
                  ELSE BEGIN
                    TempVATAmountLineRemainder."Invoice Discount Amount" :=
                      TempVATAmountLineRemainder."Invoice Discount Amount" +
                      VATAmountLine."Invoice Discount Amount" * LineAmountToInvoice /
                      VATAmountLine."Inv. Disc. Base Amount";
                    InvDiscAmount :=
                      ROUND(
                        TempVATAmountLineRemainder."Invoice Discount Amount",Currency."Amount Rounding Precision");
                    TempVATAmountLineRemainder."Invoice Discount Amount" :=
                      TempVATAmountLineRemainder."Invoice Discount Amount" - InvDiscAmount;
                  END;
                  IF QtyType = QtyType::General THEN BEGIN
                    "Inv. Discount Amount" := InvDiscAmount;
                    CalcInvDiscToInvoice;
                  END ELSE
                    "Inv. Disc. Amount to Invoice" := InvDiscAmount;
                END ELSE
                  InvDiscAmount := 0;

                IF QtyType = QtyType::General THEN
                  IF ServiceHeader."Prices Including VAT" THEN BEGIN
                    IF (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount" = 0) OR
                       ("Line Amount" = 0)
                    THEN BEGIN
                      VATAmount := 0;
                      NewAmountIncludingVAT := 0;
                    END ELSE BEGIN
                      VATAmount :=
                        TempVATAmountLineRemainder."VAT Amount" +
                        VATAmountLine."VAT Amount" *
                        ("Line Amount" - "Inv. Discount Amount") /
                        (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                      NewAmountIncludingVAT :=
                        TempVATAmountLineRemainder."Amount Including VAT" +
                        VATAmountLine."Amount Including VAT" *
                        ("Line Amount" - "Inv. Discount Amount") /
                        (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                    END;
                    NewAmount :=
                      ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision") -
                      ROUND(VATAmount,Currency."Amount Rounding Precision");
                    NewVATBaseAmount :=
                      ROUND(
                        NewAmount * (1 - ServiceHeader."VAT Base Discount %" / 100),
                        Currency."Amount Rounding Precision");
                  END ELSE BEGIN
                    IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN BEGIN
                      VATAmount := "Line Amount" - "Inv. Discount Amount";
                      NewAmount := 0;
                      NewVATBaseAmount := 0;
                    END ELSE BEGIN
                      NewAmount := "Line Amount" - "Inv. Discount Amount";
                      NewVATBaseAmount :=
                        ROUND(
                          NewAmount * (1 - ServiceHeader."VAT Base Discount %" / 100),
                          Currency."Amount Rounding Precision");
                      IF VATAmountLine."VAT Base" = 0 THEN
                        VATAmount := 0
                      ELSE
                        VATAmount :=
                          TempVATAmountLineRemainder."VAT Amount" +
                          VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base";
                    END;
                    NewAmountIncludingVAT := NewAmount + ROUND(VATAmount,Currency."Amount Rounding Precision");
                  END
                ELSE BEGIN
                  IF (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount") = 0 THEN
                    VATDifference := 0
                  ELSE
                    VATDifference :=
                      TempVATAmountLineRemainder."VAT Difference" +
                      VATAmountLine."VAT Difference" * (LineAmountToInvoice - InvDiscAmount) /
                      (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                  IF LineAmountToInvoice = 0 THEN
                    "VAT Difference" := 0
                  ELSE
                    "VAT Difference" := ROUND(VATDifference,Currency."Amount Rounding Precision");
                END;
                IF (QtyType = QtyType::General) AND (ServiceHeader.Status = ServiceHeader.Status::Released) THEN BEGIN
                  Amount := NewAmount;
                  "Amount Including VAT" := ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision");
                  "VAT Base Amount" := NewVATBaseAmount;
                END;
                ServiceLine.InitOutstanding;
                MODIFY;
                RecRef.GETTABLE(ServiceLine);

                ChangeLogMgt.LogModification(RecRef);//30.10.2012 EDMS

                TempVATAmountLineRemainder."Amount Including VAT" :=
                  NewAmountIncludingVAT - ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision");
                TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
                TempVATAmountLineRemainder."VAT Difference" := VATDifference - "VAT Difference";
                TempVATAmountLineRemainder.MODIFY;
              END;
            UNTIL NEXT = 0;
          SETRANGE(Type);
          SETRANGE(Quantity);
        END;
    end;

    local procedure CalcInvDiscToInvoice()
    var
        OldInvDiscAmtToInv: Decimal;
    begin
        GetServiceHeader;
        OldInvDiscAmtToInv := "Inv. Disc. Amount to Invoice";
        IF Quantity = 0 THEN
          VALIDATE("Inv. Disc. Amount to Invoice",0)
        ELSE
          VALIDATE(
            "Inv. Disc. Amount to Invoice",
            ROUND(
              "Inv. Discount Amount",
              Currency."Amount Rounding Precision"));

        IF OldInvDiscAmtToInv <> "Inv. Disc. Amount to Invoice" THEN BEGIN
          IF ServiceHeader.Status = ServiceHeader.Status::Released THEN
            "Amount Including VAT" := "Amount Including VAT" - "VAT Difference";
          "VAT Difference" := 0;
        END;
    end;

    [Scope('Internal')]
    procedure InitOutstanding()
    begin
        IF "Document Type" IN ["Document Type"::"Return Order"] THEN BEGIN
          "Outstanding Quantity" := Quantity;
          "Outstanding Qty. (Base)" := "Quantity (Base)";
        END ELSE BEGIN
          "Outstanding Quantity" := Quantity;
          "Outstanding Qty. (Base)" := "Quantity (Base)";
        END;
        CALCFIELDS("Reserved Quantity");
        Planned := "Reserved Quantity" = "Outstanding Quantity";

        InitOutstandingAmount;
    end;

    [Scope('Internal')]
    procedure InitOutstandingAmount()
    var
        AmountInclVAT: Decimal;
    begin
        IF Quantity <> 0 THEN BEGIN
          GetServiceHeader;
          IF ServiceHeader.Status = ServiceHeader.Status::Released THEN
            AmountInclVAT := "Amount Including VAT"
          ELSE
            IF ServiceHeader."Prices Including VAT" THEN
              AmountInclVAT := "Line Amount"
            ELSE
              IF "VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax" THEN
                AmountInclVAT :=
                  "Line Amount"  - "Inv. Discount Amount" +
                  ROUND(
                    SalesTaxCalculate.CalculateTax(
                      "Tax Area Code","Tax Group Code","Tax Liable",ServiceHeader."Posting Date",
                      "Line Amount" - "Inv. Discount Amount","Quantity (Base)",ServiceHeader."Currency Factor"),
                    Currency."Amount Rounding Precision")
              ELSE
                AmountInclVAT :=
                  ROUND(
                    ("Line Amount" - "Inv. Discount Amount") *
                    (1 + "VAT %" / 100 * (1 - ServiceHeader."VAT Base Discount %" / 100)),
                    Currency."Amount Rounding Precision");
        END;
    end;

    [Scope('Internal')]
    procedure ShowReservation()
    var
        Reservation: Page "498";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        TESTFIELD(Reserve);
        CLEAR(Reservation);
        Reservation.SetServiceLineEDMS(Rec);
        Reservation.RUNMODAL;
    end;

    [Scope('Internal')]
    procedure ShowReservationEntries(Modal: Boolean)
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
        ReserveServiceLine.FilterReservFor(ReservEntry,Rec);
        IF Modal THEN
          PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
        ELSE
          PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    end;

    [Scope('Internal')]
    procedure AutoReserve()
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");

        IF ReserveServiceLine.ReservQuantity(Rec) <> 0 THEN BEGIN
          ReservMgt.SetServLineEDMS(Rec);
          ReservMgt.AutoReserve(FullAutoReservation,'',"Planned Service Date",ReserveServiceLine.ReservQuantity(Rec),
          0); //30.10.2012 EDMS
          FIND;
          IF NOT FullAutoReservation THEN BEGIN
            COMMIT;
            IF CONFIRM(Text011,TRUE) THEN BEGIN
              ShowReservation;
              FIND;
            END;
          END;
        END;
    end;

    [Scope('Internal')]
    procedure ItemExists(ItemNo: Code[20]): Boolean
    var
        Item2: Record "27";
    begin
        IF Type = Type::Item THEN
          IF NOT Item2.GET(ItemNo) THEN
            EXIT(FALSE);
        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure OpenItemTrackingLines()
    var
        Job: Record "167";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        TESTFIELD("Quantity (Base)");
        ReserveServiceLine.CallItemTracking(Rec);
    end;

    [Scope('Internal')]
    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.IsVFActive(DATABASE::"Service Line EDMS",intFieldNo));
    end;

    [Scope('Internal')]
    procedure CheckDiscount()
    var
        SalesDiscount: Record "25006733";
    begin
        IF NOT(Type IN [Type::Item, Type::Labor]) THEN
          EXIT;

        IF UserSetup.GET(USERID) THEN BEGIN
          IF UserSetup."SP Sales Disc. Group Code" <> ''  THEN BEGIN
            SalesDiscount.RESET;
            SalesDiscount.SETRANGE("Sales Disc. Group Code", UserSetup."SP Sales Disc. Group Code");
            IF Type = Type::Labor THEN BEGIN
              SalesDiscount.SETRANGE(Type, SalesDiscount.Type::Labor);
              SalesDiscount.SETFILTER("No.", '%1|%2', '', "No.");
            END;
            IF Type = Type::Item THEN BEGIN
              SalesDiscount.SETRANGE(Type, SalesDiscount.Type::"Item Category");
              SalesDiscount.SETFILTER("No.", '%1|%2', '', "Item Category Code");
            END;
            IF SalesDiscount.FINDLAST THEN
              IF "Line Discount %" > SalesDiscount."Max. Discount %" THEN
                ERROR(Text102,FIELDCAPTION("Line Discount %"),SalesDiscount."Max. Discount %");
          END;
        END;
    end;

    [Scope('Internal')]
    procedure GetDescriptionFromLaborText(LaborNo: Code[20];VehicleSerialNo: Code[20])
    var
        VariableFieldUsage: Record "25006006";
        ServLaborText: Record "25006175";
        VehicleLoc: Record "25006005";
        VariableValue: Text[30];
    begin
        ServLaborText.RESET;
        ServLaborText.SETRANGE("Service Labor No.", LaborNo);

        IF NOT VehicleLoc.GET(VehicleSerialNo) THEN
          EXIT;

        VariableFieldUsage.RESET;
        VariableFieldUsage.SETRANGE("Table No.", DATABASE::"Service Labor Text");
        VariableFieldUsage.SETRANGE("Field No.", 25006800);
        IF VariableFieldUsage.FINDFIRST THEN BEGIN
          VariableValue := GetVariableValue(VehicleLoc, VariableFieldUsage."Variable Field Code");
          IF VariableValue <> '' THEN
            ServLaborText.SETRANGE("Variable Field 25006800", VariableValue);
        END;

        VariableFieldUsage.SETRANGE("Field No.", 25006801);
        IF VariableFieldUsage.FINDFIRST THEN BEGIN
          VariableValue := GetVariableValue(VehicleLoc, VariableFieldUsage."Variable Field Code");
          IF VariableValue <> '' THEN
            ServLaborText.SETRANGE("Variable Field 25006801", VariableValue);
        END;

        IF ServLaborText.FINDFIRST THEN BEGIN
          Description := ServLaborText.Description;
          "Description 2" := ServLaborText."Description 2";
        END;
    end;

    [Scope('Internal')]
    procedure GetVehicleVariableFields(VehicleSerialNo: Code[20])
    var
        VariableFieldUsage: Record "25006006";
        VariableFieldUsage2: Record "25006006";
        VehicleLoc: Record "25006005";
        RecordRef: RecordRef;
        FieldRef: FieldRef;
        VariableValue: Text[30];
    begin
        IF NOT VehicleLoc.GET(VehicleSerialNo) THEN
          EXIT;
        VariableFieldUsage.RESET;
        VariableFieldUsage.SETRANGE("Table No.", DATABASE::"Service Line EDMS");
        IF VariableFieldUsage.FINDFIRST THEN BEGIN
          REPEAT
            VariableValue := GetVariableValue(VehicleLoc, VariableFieldUsage."Variable Field Code");
            IF VariableValue <> '' THEN BEGIN
              CASE VariableFieldUsage."Field No." OF
                25006800: "Variable Field 25006800" := VariableValue;
                25006801: "Variable Field 25006801" := VariableValue;
                25006802: "Variable Field 25006802" := VariableValue;
              END;
            END;
          UNTIL VariableFieldUsage.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure GetVariableValue(Vehicle: Record "25006005";"Field": Text[30]) FieldValue: Text[30]
    var
        RecordRef1: RecordRef;
        FieldRef1: FieldRef;
        VariableFieldUsage: Record "25006006";
    begin
        FieldValue := '';

        IF Field = '' THEN
          EXIT;

        RecordRef1.OPEN(DATABASE::Vehicle);
        RecordRef1.GETTABLE(Vehicle);
        VariableFieldUsage.RESET;
        VariableFieldUsage.SETCURRENTKEY("Variable Field Code");
        VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
        VariableFieldUsage.SETRANGE("Variable Field Code",Field);

        IF VariableFieldUsage.FINDFIRST THEN
         BEGIN
          FieldRef1 := RecordRef1.FIELD(VariableFieldUsage."Field No.");
          FieldValue := FieldRef1.VALUE;
         END;
        RecordRef1.SETTABLE(Vehicle);
    end;

    [Scope('Internal')]
    procedure FullyReservedToInventory(): Boolean
    var
        ReservEntry: Record "337";
        ReservEntry2: Record "337";
    begin
        IF Quantity = 0 THEN
          EXIT(FALSE);

        CALCFIELDS("Reserved Quantity");
        IF "Reserved Quantity" <> Quantity THEN
          EXIT(FALSE);

        ReservEntry.RESET;
        ReservEntry.SETCURRENTKEY("Source ID", "Source Ref. No.", "Source Type");
        ReservEntry.SETRANGE("Source ID", "Document No.");
        ReservEntry.SETRANGE("Source Ref. No.", "Line No.");
        ReservEntry.SETRANGE("Source Type", DATABASE::"Service Line EDMS");
        ReservEntry.SETRANGE("Source Subtype", "Document Type");
        IF ReservEntry.FINDFIRST THEN
          REPEAT
            IF NOT ReservEntry2.GET(ReservEntry."Entry No.", NOT ReservEntry.Positive) THEN
              EXIT(FALSE);
            IF ReservEntry2."Source Type" <> DATABASE::"Item Ledger Entry" THEN
              EXIT(FALSE);
          UNTIL ReservEntry.NEXT = 0;

        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure RegLostSales()
    var
        LostSalesRegItem: Page "25006860";
    begin
        CLEAR(LostSalesRegItem);
        IF Type = Type::Item THEN
         LostSalesRegItem.SetItem("No.");
        LostSalesRegItem.SetCustomer("Sell-to Customer No.");
        LostSalesRegItem.RUN;
    end;

    [Scope('Internal')]
    procedure MoveLines(var ServiceLineRec: Record "25006146")
    var
        EDMS001: Label '%1 lines will be processed.\Do you want to proceed?';
    begin
        TestStatusOpen;
        IF ServiceLineRec.COUNT = 0 THEN
          EXIT;

        IF CONFIRM(EDMS001,FALSE,ServiceLineRec.COUNT) THEN
         REPORT.RUNMODAL(REPORT::"Service Order-Move Line",TRUE,FALSE,ServiceLineRec);
    end;

    [Scope('Internal')]
    procedure SplitLine(var ServiceLine: Record "25006146")
    begin
        TestStatusOpen;
        REPORT.RUNMODAL(REPORT::"Split Service Line",TRUE,FALSE,ServiceLine);
    end;

    [Scope('Internal')]
    procedure CalcTransferedQuantity() TransfQty: Decimal
    var
        ResEntry: Record "337";
    begin
        FilterTransferedResEntries(ResEntry);
        IF ResEntry.FINDFIRST THEN REPEAT
          TransfQty += -ResEntry.Quantity;
        UNTIL ResEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure ShowTransferedQuantity()
    var
        ResEntry: Record "337";
    begin
        FilterTransferedResEntries(ResEntry);
        IF PAGE.RUNMODAL(PAGE::"Reservation Entries",ResEntry) = ACTION::OK THEN;
    end;

    [Scope('Internal')]
    procedure FilterTransferedResEntries(var ResEntryNegative: Record "337")
    var
        ResEntryPositive: Record "337";
    begin
        ResEntryNegative.RESET;
        ResEntryNegative.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype");
        ResEntryNegative.SETRANGE("Source ID","Document No.");
        ResEntryNegative.SETRANGE("Source Ref. No.","Line No.");
        ResEntryNegative.SETRANGE("Source Type",DATABASE::"Service Line EDMS");
        ResEntryNegative.SETRANGE("Source Subtype","Document Type");
        IF ResEntryNegative.FINDFIRST THEN REPEAT
          IF ResEntryPositive.GET(ResEntryNegative."Entry No.",TRUE) THEN
            IF ResEntryPositive."Source Type" = DATABASE::"Item Ledger Entry" THEN
              ResEntryNegative.MARK(TRUE);
        UNTIL ResEntryNegative.NEXT = 0;
        ResEntryNegative.MARKEDONLY(TRUE);
    end;

    [Scope('Internal')]
    procedure FilterOutboundTransferRes(var FilteredResEntry: Record "337")
    var
        ResEntryPositive: Record "337";
        ResEntryNegative: Record "337";
        ResEntryTransferOutg: Record "337";
    begin
        ResEntryNegative.RESET;
        ResEntryNegative.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype");
        ResEntryNegative.SETRANGE("Source ID","Document No.");
        ResEntryNegative.SETRANGE("Source Ref. No.","Line No.");
        ResEntryNegative.SETRANGE("Source Type",DATABASE::"Service Line EDMS");
        ResEntryNegative.SETRANGE("Source Subtype","Document Type");
        IF ResEntryNegative.FINDFIRST THEN REPEAT
          IF ResEntryPositive.GET(ResEntryNegative."Entry No.",TRUE) THEN
            IF ResEntryPositive."Source Type" = DATABASE::"Transfer Line" THEN BEGIN
              ResEntryTransferOutg.RESET;
              ResEntryTransferOutg.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype");
              ResEntryTransferOutg.SETRANGE("Source ID",ResEntryPositive."Source ID");
              ResEntryTransferOutg.SETRANGE("Source Ref. No.",ResEntryPositive."Source Ref. No.");
              ResEntryTransferOutg.SETRANGE("Source Type",ResEntryPositive."Source Type");
              ResEntryTransferOutg.SETRANGE("Source Subtype",0);
              ResEntryTransferOutg.SETRANGE("Reservation Status",ResEntryTransferOutg."Reservation Status"::Reservation);
              IF ResEntryTransferOutg.FINDFIRST THEN REPEAT
                FilteredResEntry.GET(ResEntryTransferOutg."Entry No.",ResEntryTransferOutg.Positive);
                FilteredResEntry.MARK(TRUE);
              UNTIL ResEntryTransferOutg.NEXT = 0;
            END;
        UNTIL ResEntryNegative.NEXT = 0;
        FilteredResEntry.MARKEDONLY(TRUE)
    end;

    [Scope('Internal')]
    procedure ShowOutboundTransferRes()
    var
        ResEntry: Record "337";
    begin
        FilterOutboundTransferRes(ResEntry);
        IF PAGE.RUNMODAL(PAGE::"Reservation Entries",ResEntry) = ACTION::OK THEN;
    end;

    [Scope('Internal')]
    procedure CalcOutboundTransferRes() TransfQty: Decimal
    var
        ResEntry: Record "337";
    begin
        FilterOutboundTransferRes(ResEntry);
        IF ResEntry.FINDFIRST THEN REPEAT
          TransfQty += -ResEntry.Quantity;
        UNTIL ResEntry.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure AutoReserveToILE(QtyToReserve: Decimal)
    begin
        //EDMS function
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");

        IF QtyToReserve <> 0 THEN BEGIN
          ReservMgt.SetServLineEDMS(Rec);
          ReservMgt.SetSpecSummEntryNo(1); //Limitation to Item Ledger Entries only
          ReservMgt.AutoReserve(FullAutoReservation,'', Rec."Planned Service Date",QtyToReserve,
          QtyToReserve);//30.10.2012 EDMS
          FIND;
        END;
    end;

    [Scope('Internal')]
    procedure CheckReservationCancelation()
    var
        ServiceSetup: Record "25006120";
        Text001: Label 'Deletion of Service Line will cancel exiting reservations. Do you want to proceed?';
        Text002: Label 'Service Line deletion is interrupted';
        TransferedQty: Decimal;
        Text003: Label 'You cannot delete a Service Line where Transferred Quantity is not 0';
    begin
        TransferedQty := CalcTransferedQuantity;
        IF TransferedQty = 0 THEN
          EXIT;
        ServiceSetup.GET;
        CASE ServiceSetup."Check Transfered Qty.On Delete" OF
          ServiceSetup."Check Transfered Qty.On Delete"::No:
            EXIT;
          ServiceSetup."Check Transfered Qty.On Delete"::Confirm:
            IF NOT CONFIRM(Text001,FALSE) THEN
              ERROR(Text002);
          ServiceSetup."Check Transfered Qty.On Delete"::Restrict:
           ERROR(Text003);
        END;
    end;

    [Scope('Internal')]
    procedure GetTimeQty() RetValue: Decimal
    begin
        //returns hours
        IF "Quantity (Hours)" > 0 THEN
          RetValue := "Quantity (Hours)"
        ELSE BEGIN
        END;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure SetTimeQty(Qty: Decimal;ValidatePar: Boolean;RecalcMainQty: Boolean) RetValue: Integer
    begin
        //returns STATUS: 0 means OK
        IF "Minutes Per UoM" = 0 THEN BEGIN
          Quantity := Qty;
          IF ValidatePar THEN
            VALIDATE(Quantity);
        END ELSE BEGIN
          "Quantity (Hours)" := Qty;
          IF ValidatePar THEN BEGIN
            IF RecalcMainQty THEN
              Quantity := 0;
            VALIDATE("Quantity (Hours)");
          END;
        END;
        EXIT(0);
    end;

    [Scope('Internal')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        //31.03.2014 Elva Baltic P18 MMG7.00 >>
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
        //31.03.2014 Elva Baltic P18 MMG7.00 <<
    end;

    [Scope('Internal')]
    procedure CheckAssocPurchOrder(TheFieldCaption: Text[250])
    begin
        IF TheFieldCaption = '' THEN BEGIN // If line is being deleted
          IF "Purch. Order Line No." <> 0 THEN
            ERROR(
              Text000,
              "Purchase Order No.",
              "Purch. Order Line No.");
          IF "Special Order Purch. Line No." <> 0 THEN
            ERROR(
              Text000,
              "Special Order Purchase No.",
              "Special Order Purch. Line No.");
        END;
        IF "Purch. Order Line No." <> 0 THEN
          ERROR(
            Text002,
            TheFieldCaption,
            "Purchase Order No.",
            "Purch. Order Line No.");
        IF "Special Order Purch. Line No." <> 0 THEN
          ERROR(
            Text002,
            TheFieldCaption,
            "Special Order Purchase No.",
            "Special Order Purch. Line No.");
    end;

    [Scope('Internal')]
    procedure UpdateDates()
    begin
        IF CurrFieldNo = 0 THEN BEGIN
          PlannedShipmentDateCalculated := FALSE;
          PlannedDeliveryDateCalculated := FALSE;
        END;
        IF "Promised Delivery Date" <> 0D THEN
          VALIDATE("Promised Delivery Date")
        ELSE
          IF "Requested Delivery Date" <> 0D THEN
            VALIDATE("Requested Delivery Date")
          ELSE BEGIN
            VALIDATE("Shipment Date");
            VALIDATE("Planned Delivery Date");
          END;
    end;

    [Scope('Internal')]
    procedure RowID1(): Text[250]
    var
        ItemTrackingMgt: Codeunit "6500";
    begin
        EXIT(ItemTrackingMgt.ComposeRowID(DATABASE::"Service Line EDMS","Document Type",
            "Document No.",'',0,"Line No."));
    end;

    local procedure CheckItemAvailable(CalledByFieldNo: Integer)
    begin
    end;

    [Scope('Internal')]
    procedure "--SERVICE RESOURCES--"()
    begin
    end;

    [Scope('Internal')]
    procedure SetResourceTextFieldValue(TextValue: Text)
    begin
        IF NOT ResourceTextFieldModified THEN
          ResourceTextFieldModified := (ResourceTextFieldValue <> TextValue);
        ResourceTextFieldValue := TextValue;
        SaveRelatedResourcesToDB(0);
    end;

    [Scope('Internal')]
    procedure GetResourceTextFieldValue(): Text
    var
        NewValueFromDB: Text;
    begin
        //ServiceScheduleMgt.SetRelatedResources("Document Type", "Document No.", Type, "Line No.", Resources, 0);
        //Resources := ServiceScheduleMgt.GetRelatedResources("Document Type", "Document No.", Type, "Line No.", 0);
        IF (ServiceLinePrevParcedRsc."Line No." <> "Line No.") OR (ServiceLinePrevParcedRsc."Document Type" <> "Document Type") OR
            (ServiceLinePrevParcedRsc."Document No." <> "Document No.") THEN BEGIN
          ResourceTextFieldModified := FALSE;
          ServiceLinePrevParcedRsc.TRANSFERFIELDS(Rec);
          NewValueFromDB := GetRelatedResourcesFromDB(0);
          IF "Line No." > 0 THEN
            ResourceTextFieldValue := NewValueFromDB
          ELSE BEGIN
            IF ResourceTextFieldValue = '' THEN
              ResourceTextFieldValue := NewValueFromDB;
          END;

        END;
        EXIT(ResourceTextFieldValue);
    end;

    [Scope('Internal')]
    procedure GetRelatedResourcesFromDB(RunMode: Integer) RetValue: Text
    var
        ServLaborApplication: Record "25006277";
        ServiceLine: Record "25006146";
        isItDocAllocation: Boolean;
        StatusArray: array [10] of Integer;
        isTempTableUse: Boolean;
    begin
        RetValue := '';
        IF (Type = Type::Labor) AND ("Line No." > 0) THEN BEGIN
          ServLaborApplicationGlobTmp.RESET;
          ServLaborApplicationGlobTmp.DELETEALL;
          ServLaborApplication.RESET;
          ServLaborApplication.SETRANGE("Document Type", "Document Type");
          ServLaborApplication.SETRANGE("Document No.", "Document No.");
          ServLaborApplication.SETRANGE("Document Line No.", "Line No.");
          IF ServLaborApplication.FINDFIRST THEN BEGIN
            REPEAT
              ServLaborApplicationGlobTmp.SETRANGE("Resource No.", ServLaborApplication."Resource No.");
              IF NOT ServLaborApplicationGlobTmp.FINDLAST THEN BEGIN
                IF (STRLEN(RetValue)+ STRLEN(ServLaborApplication."Resource No."+',') <= MAXSTRLEN(RetValue)) THEN
                  RetValue += ServLaborApplication."Resource No."+',';
                ServLaborApplicationGlobTmp.INIT;
                ServLaborApplicationGlobTmp.TRANSFERFIELDS(ServLaborApplication);
                ServLaborApplicationGlobTmp.INSERT;
              END;
            UNTIL ServLaborApplication.NEXT = 0;
            IF STRLEN(RetValue) > 1 THEN
              RetValue := COPYSTR(RetValue, 1, STRLEN(RetValue)-1);
          END;
        END;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure SetRelatedResources(RecourcesTextSource: Text;RunMode: Integer) ResourcesCount: Integer
    var
        ServLaborApplication: Record "25006277";
        Posit: Integer;
        ServiceSetup: Record "25006120";
        ResourceToAdd: Text[30];
        Resource: Record "156";
        RecourcesText: Text;
        RecourcesTextToModify: Text;
        AllocEntryNo: Integer;
        isItDocAllocation: Boolean;
        divResult: Integer;
        isItAllowedMessage: Boolean;
        ServiceLine: Record "25006146";
        StatusArray: array [10] of Integer;
        LineNo: Integer;
    begin
        //RunMode = 0 - normal; 1 - no messages; second digit (tens) - is it document allocation
        // THAT FUNCTION SAVE IT ONLY INTO TEMPORARY TABLE
        // for now it stores only resources uniquely (one certain resource - one line)
        ServiceSetup.GET;
        AdjustFlagsToArray(RunMode, StatusArray);
        isItAllowedMessage := (StatusArray[1] = 1);
        isItDocAllocation := (StatusArray[2] = 1);

        RecourcesText := RecourcesTextSource;
        ResourcesCount := 0;
        IF (Type = Type::Labor) THEN BEGIN
          //Allocation Entry No.,Document Type,Document No.,Line No.
          ServLaborApplicationGlobTmp.RESET;
          ServLaborApplicationGlobTmp.DELETEALL;
          REPEAT
            Posit := STRPOS(RecourcesText, ',');
            IF Posit > 0 THEN BEGIN
              ResourceToAdd := COPYSTR(RecourcesText, 1, Posit - 1);
              RecourcesText := COPYSTR(RecourcesText, Posit + 1, STRLEN(RecourcesText)-Posit);
            END ELSE BEGIN
              ResourceToAdd := RecourcesText;
              RecourcesText := '';
            END;
            IF Resource.GET(ResourceToAdd) THEN BEGIN
              ServLaborApplicationGlobTmp.SETRANGE("Resource No.", ResourceToAdd);
              IF NOT ServLaborApplicationGlobTmp.FINDLAST THEN BEGIN
                Resource.TESTFIELD(Blocked, FALSE);
                LineNo := 0;
                ServLaborApplicationGlobTmp.RESET;
                IF ServLaborApplicationGlobTmp.FINDLAST THEN
                  LineNo := ServLaborApplicationGlobTmp."Line No.";
                ServLaborApplicationGlobTmp.INIT;
                ServLaborApplicationGlobTmp."Allocation Entry No." := 0;
                ServLaborApplicationGlobTmp."Document Type" := "Document Type";
                ServLaborApplicationGlobTmp."Document No." := "Document No.";
                ServLaborApplicationGlobTmp."Document Line No." := "Line No.";
                ServLaborApplicationGlobTmp."Resource No." := ResourceToAdd;
                ServLaborApplicationGlobTmp."Line No." := LineNo + 10000;
                ServLaborApplicationGlobTmp.INSERT;
              END;
            END;
          UNTIL RecourcesText = '';
          ServLaborApplicationGlobTmp.SETRANGE("Resource No.");
        END;
        EXIT(ServLaborApplicationGlobTmp.COUNT);
    end;

    [Scope('Internal')]
    procedure SaveRelatedResourcesToDB(RunMode: Integer) ResourcesCount: Integer
    var
        ServLaborApplication: Record "25006277";
        ServLaborAllocationEntryLoc: Record "25006271";
        ServiceScheduleMgt: Codeunit "25006201";
        Posit: Integer;
        ServiceSetup: Record "25006120";
        ResourceToAdd: Text[30];
        Resource: Record "156";
        RecourcesTextToModify: Text;
        AllocEntryNo: Integer;
        isItDocAllocation: Boolean;
        divResult: Integer;
        isItAllowedMessage: Boolean;
        ServiceLine: Record "25006146";
        isFound: Boolean;
    begin
        //RunMode = 0 - normal; 1 - no messages; second digit (tens) - is it document allocation
        ResourcesCount := 0;
        IF (Type = Type::Labor) AND (ResourceTextFieldModified) AND ("Line No." > 0) THEN BEGIN

          SetRelatedResources(ResourceTextFieldValue, 0);

          ServLaborApplication.RESET;
          ServLaborApplication.SETRANGE("Document Type", "Document Type");
          ServLaborApplication.SETRANGE("Document No.", "Document No.");
          IF ServLaborApplicationGlobTmp.FINDFIRST THEN BEGIN
            REPEAT
              IF Resource.GET(ServLaborApplicationGlobTmp."Resource No.") THEN BEGIN
                ServLaborApplication.SETRANGE("Document Line No.", "Line No.");
                ServLaborApplication.SETRANGE("Resource No.", ServLaborApplicationGlobTmp."Resource No.");
                isFound := ServLaborApplication.FINDLAST;
                IF NOT isFound THEN BEGIN
                  Resource.TESTFIELD(Blocked, FALSE);

                  ServLaborApplication.INIT;
                  ServLaborApplication."Allocation Entry No." := 0;
                  ServLaborApplication."Document Type" := "Document Type";
                  ServLaborApplication."Document No." := "Document No.";
                  ServLaborApplication."Document Line No." := "Line No.";
                  ServLaborApplication."Resource No." := ServLaborApplicationGlobTmp."Resource No.";
                  ServLaborApplication.INSERT(TRUE);
                END;
              END;
            UNTIL ServLaborApplicationGlobTmp.NEXT = 0;
          END;
          ServLaborApplication.SETRANGE("Document Line No.", "Line No.");
          ServLaborApplication.SETRANGE("Resource No.");
          ServLaborApplicationGlobTmp.RESET;
          // here get remove unneed records
          IF ServLaborApplication.FINDFIRST THEN
            REPEAT
              ServLaborApplicationGlobTmp.SETRANGE("Resource No.", ServLaborApplication."Resource No.");
              IF NOT ServLaborApplicationGlobTmp.FINDLAST THEN
                IF NOT ServLaborAllocationEntryLoc.GET(ServLaborApplication."Allocation Entry No.") THEN BEGIN
                  ServLaborApplication.DELETE(TRUE);
                  IF ServLaborApplication.FINDFIRST THEN;
                END ELSE BEGIN
                  // MESSAGE('IT is not allowed to delete allocated records');
              END;
            UNTIL ServLaborApplication.NEXT = 0;
          IF ServLaborApplication.FINDFIRST THEN BEGIN
            ServLaborApplicationGlobTmp.SETRANGE("Resource No.", ServLaborApplication."Resource No.");
            IF NOT ServLaborApplicationGlobTmp.FINDLAST THEN
              IF NOT ServLaborAllocationEntryLoc.GET(ServLaborApplication."Allocation Entry No.") THEN
                ServLaborApplication.DELETE(TRUE);
          END;

          //ServiceScheduleMgt.RemoveDuplicates(ServLaborApplication);

        END;
        CLEAR(ResourceTextFieldModified);
        CLEAR(ServiceLinePrevParcedRsc);
        EXIT(ServLaborApplication.COUNT);
    end;

    [Scope('Internal')]
    procedure RelatedResourcesList(RelatedResources: Text)
    var
        ServLaborAllocApplication: Record "25006277";
    begin
        COMMIT;
        ServLaborAllocApplication.RESET;
        ServLaborAllocApplication.SETRANGE("Document Type", "Document Type");
        ServLaborAllocApplication.SETRANGE("Document No.", "Document No.");
        ServLaborAllocApplication.SETRANGE("Document Line No.", "Line No.");
        IF (Type = Type::Labor) AND ("Line No." > 0) THEN
          PAGE.RUNMODAL(PAGE::"Service Line Resources", ServLaborAllocApplication);
        RelatedResources := GetRelatedResourcesFromDB(0);
        SetResourceTextFieldValue(RelatedResources);
    end;

    [Scope('Internal')]
    procedure DeleteResourcesOfLine()
    var
        ServLaborAllocApplication: Record "25006277";
    begin
        ServLaborAllocApplication.RESET;
        ServLaborAllocApplication.SETRANGE("Document Type", "Document Type");
        ServLaborAllocApplication.SETRANGE("Document No.", "Document No.");
        ServLaborAllocApplication.SETRANGE("Document Line No.", "Line No.");
        IF "Line No." > 0 THEN
          ServLaborAllocApplication.DELETEALL(TRUE);
    end;

    [Scope('Internal')]
    procedure "--SMALL TECHN--"()
    begin
    end;

    [Scope('Internal')]
    procedure CutNextDigit(var Flags: Integer) RetValue: Integer
    begin
        RetValue := Flags MOD 10;
        Flags := Flags DIV 10;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure AdjustFlagsToArray(Flags: Integer;var ArrayEDMS: array [10] of Integer)
    var
        i: Integer;
    begin
        FOR i := 1 TO 10 DO BEGIN
          IF (CutNextDigit(Flags) > 0) THEN
            ArrayEDMS[i] := i-1
          ELSE
            ArrayEDMS[i] := -1;
        END;
    end;

    [Scope('Internal')]
    procedure IsIntInArrayTen(CheckValue: Integer;var ArrayEDMS: array [10] of Integer) RetValue: Boolean
    var
        i: Integer;
    begin
        FOR i := 1 TO 10 DO BEGIN
          IF (CheckValue = ArrayEDMS[i]) THEN
            RetValue := TRUE;
        END;

        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure GetReservationColor(): Text[20]
    var
        ResEntry: Record "337";
    begin
        // 19.03.2014 Elva Baltic P21 >>
        IF (Type <> Type::Item) OR ("No." = '') THEN
          EXIT('None');

        IF CalcTransferedQuantity = Quantity THEN
          EXIT('None');
        // 19.03.2014 Elva Baltic P21 <<

        FilterTransferRes(ResEntry);

        IF ResEntry.ISEMPTY THEN
          EXIT('Unfavorable');

        ResEntry.SETRANGE("Source Type", 246);
        IF ResEntry.FINDFIRST THEN
          EXIT('StandardAccent');

        ResEntry.SETFILTER("Source Type", '%1|%2', 39, 5741);
        IF ResEntry.FINDFIRST THEN
          EXIT('Ambiguous');

        ResEntry.SETRANGE("Source Type", 32);
        IF ResEntry.FINDFIRST THEN
          EXIT('Favorable');
    end;

    [Scope('Internal')]
    procedure FilterTransferRes(var FilteredResEntry: Record "337")
    var
        ResEntryPositive: Record "337";
        ResEntryNegative: Record "337";
        ResEntryTransferOutg: Record "337";
    begin
        ResEntryNegative.RESET;
        ResEntryNegative.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype");
        ResEntryNegative.SETRANGE("Source ID","Document No.");
        ResEntryNegative.SETRANGE("Source Ref. No.","Line No.");
        ResEntryNegative.SETRANGE("Source Type",DATABASE::"Service Line EDMS");
        ResEntryNegative.SETRANGE("Source Subtype","Document Type");
        IF ResEntryNegative.FINDFIRST THEN REPEAT
          IF ResEntryPositive.GET(ResEntryNegative."Entry No.",TRUE) THEN
            IF ResEntryPositive."Source Type" = DATABASE::"Transfer Line" THEN BEGIN
              ResEntryTransferOutg.RESET;
              ResEntryTransferOutg.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype");
              ResEntryTransferOutg.SETRANGE("Source ID",ResEntryPositive."Source ID");
              ResEntryTransferOutg.SETRANGE("Source Ref. No.",ResEntryPositive."Source Ref. No.");
              ResEntryTransferOutg.SETRANGE("Source Type",ResEntryPositive."Source Type");
              ResEntryTransferOutg.SETRANGE("Source Subtype",0);
              ResEntryTransferOutg.SETRANGE("Reservation Status",ResEntryTransferOutg."Reservation Status"::Reservation);
              IF ResEntryTransferOutg.FINDFIRST THEN REPEAT
                FilteredResEntry.GET(ResEntryTransferOutg."Entry No.",TRUE);
                FilteredResEntry.MARK(TRUE);
              UNTIL ResEntryTransferOutg.NEXT = 0;
            END;
        UNTIL ResEntryNegative.NEXT = 0;
        FilteredResEntry.MARKEDONLY(TRUE)
    end;

    [Scope('Internal')]
    procedure DeleteAssignedTransfLine()
    var
        TransferLine: Record "5741";
    begin
        IF ServiceTransferMgt.FindTransferLine(Rec, TransferLine) THEN BEGIN
          IF CONFIRM(Text123, FALSE, TransferLine.FIELDCAPTION("Document No."), TransferLine."Document No.",
                     TransferLine.FIELDCAPTION("Line No."), TransferLine."Line No.") THEN
            ServiceTransferMgt.DeleteTransferLine(Rec)
          ELSE
            ERROR(Text124);
        END;
    end;

    local procedure CheckApplFromItemLedgEntry(var ItemLedgEntry: Record "32")
    var
        ItemTrackingLines: Page "6510";
                               QtyBase: Decimal;
                               QtyNotReturned: Decimal;
                               QtyReturned: Decimal;
    begin
        IF "Appl.-from Item Entry" = 0 THEN
          EXIT;
        
        // IF "Shipment No." <> '' THEN
        //   EXIT;
        
        TESTFIELD(Type,Type::Item);
        TESTFIELD(Quantity);
        IF "Document Type" IN ["Document Type"::"Return Order"] THEN BEGIN
          IF Quantity < 0 THEN
            FIELDERROR(Quantity,Text029);
        END ELSE BEGIN
          IF Quantity > 0 THEN
            FIELDERROR(Quantity,Text030);
        END;
        
        ItemLedgEntry.GET("Appl.-from Item Entry");
        ItemLedgEntry.TESTFIELD(Positive,FALSE);
        ItemLedgEntry.TESTFIELD("Item No.","No.");
        ItemLedgEntry.TESTFIELD("Variant Code","Variant Code");
        // IF NOT (("Line Type" = "Line Type"::Vehicle) AND (Quantity = 1)) THEN //29.08.2013 EDMS P8
        IF (ItemLedgEntry."Lot No." <> '') OR (ItemLedgEntry."Serial No." <> '') THEN
          ERROR(Text040,ItemTrackingLines.CAPTION,FIELDCAPTION("Appl.-from Item Entry"));
        
        CASE TRUE OF
          CurrFieldNo = FIELDNO(Quantity):
            QtyBase := "Quantity (Base)";
          /*
          "Document Type" IN ["Document Type"::"Return Order"]:
            QtyBase := "Return Qty. to Receive (Base)"
          ELSE
            QtyBase := "Qty. to Ship (Base)";
          */
        END;
        
        IF ABS(QtyBase) > -ItemLedgEntry.Quantity THEN
          ERROR(
            Text046,
            -ItemLedgEntry.Quantity,ItemLedgEntry.FIELDCAPTION("Document No."),
            ItemLedgEntry."Document No.");
        
        IF ABS(QtyBase) > -ItemLedgEntry."Shipped Qty. Not Returned" THEN BEGIN
          IF "Qty. per Unit of Measure" = 0 THEN BEGIN
            QtyNotReturned := ItemLedgEntry."Shipped Qty. Not Returned";
            QtyReturned := ItemLedgEntry.Quantity - ItemLedgEntry."Shipped Qty. Not Returned";
          END ELSE BEGIN
            QtyNotReturned :=
              ROUND(ItemLedgEntry."Shipped Qty. Not Returned" / "Qty. per Unit of Measure",0.00001);
            QtyReturned :=
              ROUND(
                (ItemLedgEntry.Quantity - ItemLedgEntry."Shipped Qty. Not Returned") /
                "Qty. per Unit of Measure",0.00001);
          END;
          ERROR(
            Text039,
            -QtyReturned,ItemLedgEntry.FIELDCAPTION("Document No."),
            ItemLedgEntry."Document No.",-QtyNotReturned);
        END;

    end;

    [Scope('Internal')]
    procedure LookupShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        //31.03.2014 Elva Baltic P18 MMG7.00 >>
        DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
        //31.03.2014 Elva Baltic P18 MMG7.00 <<
    end;

    [Scope('Internal')]
    procedure ShowShortcutDimCode(var ShortcutDimCode: array [8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;

    [Scope('Internal')]
    procedure CheckFixedPrice(): Boolean
    begin
        FixedPrice := FALSE;
        ServiceHeaderEDMS.RESET;
        ServiceHeaderEDMS.SETRANGE("Document Type",ServiceHeaderEDMS."Document Type"::Order);
        ServiceHeaderEDMS.SETRANGE("No.","Document No.");
        IF ServiceHeaderEDMS.FINDFIRST THEN BEGIN
          JobTypeMaster.RESET;
          JobTypeMaster.SETRANGE(Type,JobTypeMaster.Type::Service);
          JobTypeMaster.SETRANGE("No.",ServiceHeaderEDMS."Job Type");
          IF JobTypeMaster.FINDFIRST THEN
            FixedPrice := JobTypeMaster."Fixed Price";
        END;
        EXIT(FixedPrice);
    end;

    [Scope('Internal')]
    procedure ValidateAmountSanjivani(ServiceHeader: Record "25006145")
    var
        ServicePackage: Record "25006134";
        ErrText000: Label 'Total Line Amount cannot Exceed %1 for Sanjivani Package %2.';
    begin
        IF (Rec."Job Type" = 'SANJIVANI') AND (ServiceHeader."Job Type" = 'SANJIVANI')THEN BEGIN
          ServicePackage.RESET;
          IF ServicePackage.GET(ServiceHeader."Package No.") THEN BEGIN
            CALCFIELDS("Package Total Amount");
            IF ("Package Total Amount"+"Line Amount") >
            (ServicePackage."Total Amount (Sanjivani)"+ServicePackage."Limit Amount (Sanjivani)")
         THEN
              ERROR(ErrText000,ServicePackage."Total Amount (Sanjivani)"+ServicePackage."Limit Amount (Sanjivani)",
              ServiceHeader."Package No.");
          END;
        END;
    end;

    [Scope('Internal')]
    procedure CheckNonBillableCustomer(): Boolean
    var
        Customer: Record "18";
    begin
        IF Type <> Type::" " THEN BEGIN
          Customer.GET("Bill-to Customer No.");
          IF Customer."Non-Billable" THEN
            IF  Type <> Type :: Item THEN
            VALIDATE("Unit Price",0)
            ELSE
             VALIDATE("Unit Price","Unit Cost (LCY)") // SM 05/12/2013
          ELSE BEGIN
          END;
        END;
        EXIT(Customer."Non-Billable");
    end;

    [Scope('Internal')]
    procedure ValidateLocalParts()
    var
        Item: Record "27";
        ServMgtSetup: Record "25006120";
        JobTypeMaster: Record "33020235";
        NoLocalParts: Label 'You cannot Issue Local Parts for Warranty.';
    begin
        ServMgtSetup.GET;
        IF NOT ServMgtSetup."Allow Local Parts For Warranty" THEN BEGIN
          IF ("Job Type" <> '') AND (Type = Type::Item) AND ("No." <> '') AND ("Job Type" <> 'SANJIVANI WARRANTY')
          THEN BEGIN
            JobTypeMaster.RESET;
            JobTypeMaster.SETRANGE(Type,JobTypeMaster.Type::Job);
            JobTypeMaster.SETRANGE("No.","Job Type");
            JobTypeMaster.SETRANGE("Needs Warranty Approval",TRUE);
            IF  JobTypeMaster.FINDFIRST THEN BEGIN
              Item.GET("No.");
              IF Item."Gen. Prod. Posting Group" <> 'LUBE' THEN BEGIN
                IF STRPOS("No.",'L-') = 1 THEN BEGIN
                  ERROR(NoLocalParts);
                END;
                IF STRPOS("No.",'LU-') = 1 THEN BEGIN
                  ERROR(NoLocalParts);
                END;
                IF STRPOS("No.",'M-') = 1 THEN BEGIN
                  ERROR(NoLocalParts);
                END;
                IF STRPOS("No.",'Z-') = 1 THEN BEGIN
                  ERROR(NoLocalParts);
                END;
              END;
            END;
          END;
        END;
    end;

    [Scope('Internal')]
    procedure ChangeQtyPrice(): Boolean
    var
        CanChangeQty: Boolean;
        CanChangePrice: Boolean;
        CannotChangeQty: Label 'You cannot Change Qty. field in Service Order %1.';
        CannotChangePrice: Label 'You cannot Change Price in Service Order %1.';
    begin
        //** to make the unit price editable for the type G/L Account** SM 05/22/2013

        CanChangePrice := FALSE;
        IF ("Document Type" = "Document Type"::Quote) OR ("Document Type" = "Document Type"::Order)THEN BEGIN
          IF (Type = Type::Labor) OR (Type = Type::"External Service") OR (Type = Type::"G/L Account") THEN BEGIN  //SM **
            CanChangePrice := TRUE;
          END;
        END;
        IF (NOT CanChangePrice) AND (Rec."Unit Price"<>xRec."Unit Price") THEN
          ERROR(CannotChangePrice,"Document No.");
    end;

    [Scope('Internal')]
    procedure RestrictMultipleItemIssue()
    var
        RestrictItem: Record "33020256";
        ServLedgerEntries: Record "25006167";
    begin
        ServiceHeader.GET("Document Type","Document No.");
        ServLedgerEntries.RESET;
        //ServLedgerEntries.setrange("Vehicle Serial No."
        ServLedgerEntries.SETRANGE("Entry Type",ServLedgerEntries."Entry Type"::Usage);
    end;

    [Scope('Internal')]
    procedure FindSameItemOnJob()
    var
        ServLine: Record "25006146";
        Text000: Label '%2, %1 has already been used in this Job. Do you want to continue?';
        Text001: Label 'Process Cancelled by User.';
    begin
        ServLine.RESET;
        ServLine.SETRANGE("Document Type",ServLine."Document Type"::Order);
        ServLine.SETRANGE("Document No.",ServiceHeader."No.");
        ServLine.SETRANGE(Type,Type);
        ServLine.SETRANGE("No.","No.");
        IF ServLine.FINDFIRST THEN BEGIN
          IF CONFIRM(Text000,TRUE,"No.",FORMAT(Type)) THEN BEGIN END
          ELSE
            ERROR(Text001);
        END;
    end;

    [Scope('Internal')]
    procedure CanChangeExtService(): Boolean
    var
        CanChangeLine: Boolean;
        CannotChangeLine: Label 'You cannot Change External Service after it has been purchased.';
    begin
        CanChangeLine := TRUE;
        IF ("Document Type" = "Document Type"::Order)THEN BEGIN
            IF (xRec.Type = Type::"External Service") AND (xRec."External Service Purchased") THEN BEGIN
                CanChangeLine := FALSE;
          END;
        END;
        IF (NOT CanChangeLine) THEN
          ERROR(CannotChangeLine,"Document No.");
    end;

    [Scope('Internal')]
    procedure SetChangebySystem()
    begin
        ChangedbySystem := TRUE;
    end;

    local procedure schemeDiscount(var ServLine: Record "25006146")
    var
        ServHdrP: Record "25006145";
        ServSchemeLine: Record "33019862";
        ServSchLine2: Record "33019805";
        ServSchemeLine1: Record "33019862";
    begin
        ServHdrP.GET(ServLine."Document Type",ServLine."Document No.");
        ServLine.TESTFIELD("Gen. Prod. Posting Group");
        ServSchemeLine.RESET;
        ServSchemeLine.SETRANGE(Code,ServHdrP."Scheme Code");
        ServSchemeLine.SETRANGE(Type,ServLine.Type);
        ServSchemeLine.SETRANGE("General Product Posting Group",ServLine."Gen. Prod. Posting Group");
        IF ServSchemeLine.FINDFIRST THEN BEGIN
          ServSchLine2.RESET;
          ServSchLine2.SETRANGE(Code,ServSchemeLine.Code);
          ServSchLine2.SETRANGE(Type,ServSchemeLine.Type);
          IF ServSchLine2.FINDSET THEN
            REPEAT
              IF ServSchLine2."General Product Posting Group" <> ServLine."Gen. Prod. Posting Group" THEN
                ServLine.VALIDATE("Line Discount %",ServSchemeLine."Discount %")
              ELSE
                ServLine.VALIDATE("Line Discount %",0);
            UNTIL ServSchLine2.NEXT = 0;
        END ELSE BEGIN
          ServSchemeLine1.RESET;
          ServSchemeLine1.SETRANGE(Code,ServHdrP."Scheme Code");
          ServSchemeLine1.SETRANGE(Type,ServLine.Type);
          ServSchemeLine1.SETFILTER("General Product Posting Group",''); //review as required
          IF ServSchemeLine1.FINDFIRST THEN BEGIN
            ServSchLine2.RESET;
            ServSchLine2.SETRANGE(Code,ServSchemeLine1.Code);
            ServSchLine2.SETRANGE(Type,ServSchemeLine1.Type);
            IF ServSchLine2.FINDSET THEN
              REPEAT
                IF ServSchLine2."General Product Posting Group" <> ServLine."Gen. Prod. Posting Group" THEN
                  ServLine.VALIDATE("Line Discount %",ServSchemeLine1."Discount %")
                ELSE
                  ServLine.VALIDATE("Line Discount %",0);
              UNTIL ServSchLine2.NEXT = 0;
            END;
        END;
    end;
}


tableextension 50177 tableextension50177 extends "Purchase Line"
{
    // 06.10.2016 EB.P7 #PAR28
    //   Modified Trigger Quantity OnValidate
    // 
    // 07.06.2016 EB.P30 EDMS
    //   Added Key:
    //     "Document Type,Document No.,Shipment Package No."
    // 
    // 30.05.2016 EB.P7 #PAR28
    //   Added field:
    //     25006998Has Replacement
    // 
    // 20.05.2016 EB.P30 EDMS
    //   Added field:
    //     " Shipment Package No."
    // 
    // 12.04.2016 EB.P7 field 90 trigger fix
    //   Field trigger reverted to standard.
    // 
    // 16.03.2016 EB.P7 Branch Setup
    //   Modified No.-OnValidate, Usert Profile Setup to Branch Profile Setup
    // 
    // 12.06.2015 EB.P30 #T042
    //   Modified function:
    //     CreateDim
    //   Modified CreateDim calls because of added parameter
    //   Modified trigger:
    //     Dela Type - OnValidate
    // 
    // 15.04.2015 EB.P7 #Merge
    //   Modified UpdatePrepmtSetupFields() merged with edms functionality.
    // 
    // 10.03.2015 EDMS P21
    //   Modified procedure:
    //     CreateDim
    //   Modified CreateDim calls because of added parameter
    //   Modified trigger:
    //     Location Code - OnValidate
    // 
    // 29.04.2014 Elva Baltic P8 #F037 MMG7.00
    //   * Use of Def. Status from profile
    // 
    // 04.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     No. - OnValidate()
    // 
    // 02.04.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Added Replacement Creation in case of changed "No."(OnModify trigger)
    // 
    // 28.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added function:
    //     GetReservForInfo
    // 
    // 26.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     50020 Item No. Changed
    //   Added code to:
    //     No. - OnValidate()
    // 
    // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00
    //   Added Code To "Vehicle Serial No. - OnValidate()"
    // 
    // 12.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Changed "Planning Flexibility" field InitValue property to None
    // 
    // 25.10.2013 EDMS P8
    //   * Added use of Vehicle default dimension
    // 
    // 18.01.2013 EDMS P8
    //   * Added fields: Special Order Service No., Special Order Service Line No.
    // 
    // 08.01.2013 EDMS P8
    //   * VALIDATION OF quantity
    // 
    // 16.11.2011 EDMS P8
    //   * add function UpdateDatesEDMS
    // 
    // 01.09.2008. EDMS P2
    //   * Added field "Link Trade-In Entry"
    // 
    // 20.08.2008. EDMS P2
    //   * Added code fNoAssistEdit
    // 
    // 18.06.2008. EDMS P2
    //   * Changed field "Vehicle Body Color Code" Table Relation property
    //   * Added code Vehicle Serial No. - OnValidate
    // 
    // 09.05.2008. EDMS P2
    //   * Added code Quantity - OnValidate (check for Vehicle qty not more than 1)
    // 
    // 07.05.2008. EDMS P2
    //   * Delete code No. - OnLookup
    //        //EDMS1.0.00 >>
    //        fNoLookup;
    //        //EDMS1.0.00 <<
    // 
    // 28.12.2007 EDMS P5
    //         * Changed property "OptionString" for field "Type"
    //           from " ,G/L Account,Item,,Fixed Asset,Charge (Item)"
    //           to   " ,G/L Account,Item,,Fixed Asset,Charge (Item),,External Service"
    // 
    //         * Changed property "TableRelation" for field "No."
    //           from "IF (Type=CONST(" ")) "Standard Text"
    //                 ELSE IF (Type=CONST(G/L Account)) "G/L Account"
    //                 ELSE IF (Type=CONST(Item)) Item
    //                 ELSE IF (Type=CONST(3)) Resource
    //                 ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
    //                 ELSE IF (Type=CONST("Charge (Item)")) "Item Charge"
    //           to "IF (Type=CONST(" ")) "Standard Text"
    //               ELSE IF (Type=CONST(G/L Account)) "G/L Account"
    //               ELSE IF (Type=CONST(Item)) Item
    //               ELSE IF (Type=CONST(3)) Resource
    //               ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
    //               ELSE IF (Type=CONST("Charge (Item)")) "Item Charge"
    //               ELSE IF (Type=CONST(External Service)) "External Service EDMS""
    // 
    //         * Added code to OnValidate trigger of "No." field
    // 
    //         * Added new field
    //           25006130 "Ext. Service Tracking No."
    // 
    // 26.09.2007. EDMS P2
    //   * Added field Qty. on Back Order
    // 
    // 20.07.2007. EDMS P2
    //   * Added new key "Order Date"
    fields
    {

        //Unsupported feature: Property Modification (Editable) on ""Buy-from Vendor No."(Field 2)".

        modify(Type)
        {
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item),,External Service';

            //Unsupported feature: Property Modification (OptionString) on "Type(Field 5)".

        }
        modify("No.")
        {
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST(G/L Account),
                                     System-Created Entry=CONST(No)) "G/L Account" WHERE (Direct Posting=CONST(Yes),
                                                                                          Account Type=CONST(Posting),
                                                                                          Blocked=CONST(No))
                                                                                          ELSE IF (Type=CONST(G/L Account),
                                                                                                   System-Created Entry=CONST(No)) "G/L Account"
                                                                                                   ELSE IF (Type=CONST(Item),
                                                                                                            Line Type=FILTER(<>Vehicle)) Item WHERE (Item Type=FILTER(' '|Item))
                                                                                                            ELSE IF (Type=CONST(Item),
                                                                                                                     Line Type=CONST(Vehicle)) Item WHERE (Item Type=CONST(Model Version))
                                                                                                                     ELSE IF (Type=CONST(3)) Resource
                                                                                                                     ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                                                     ELSE IF (Type=CONST("Charge (Item)")) "Item Charge"
                                                                                                                     ELSE IF (Type=CONST(External Service)) "External Service";
        }
        modify("Posting Group")
        {
            TableRelation = IF (Type=CONST(Item)) "Inventory Posting Group"
                            ELSE IF (Type=CONST(Fixed Asset)) "FA Posting Group";
        }
        modify(Description)
        {
            TableRelation = IF (Type=CONST(" ")) "Standard Text"
                            ELSE IF (Type=CONST(G/L Account),
                                     System-Created Entry=CONST(No)) "G/L Account" WHERE (Direct Posting=CONST(Yes),
                                                                                          Account Type=CONST(Posting),
                                                                                          Blocked=CONST(No))
                                                                                          ELSE IF (Type=CONST(G/L Account),
                                                                                                   System-Created Entry=CONST(Yes)) "G/L Account"
                                                                                                   ELSE IF (Type=CONST(Item)) Item
                                                                                                   ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                                   ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
        }
        modify("Sales Order Line No.")
        {
            TableRelation = IF (Drop Shipment=CONST(Yes)) "Sales Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                         Document No.=FIELD(Sales Order No.));
        }
        modify("Attached to Line No.")
        {
            TableRelation = "Purchase Line"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                              Document No.=FIELD(Document No.));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity"(Field 95)".

        modify("Blanket Order Line No.")
        {
            TableRelation = "Purchase Line"."Line No." WHERE (Document Type=CONST(Blanket Order),
                                                              Document No.=FIELD(Blanket Order No.));
        }
        modify("Variant Code")
        {

            //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

            Caption = 'VC No.';
        }
        modify("Bin Code")
        {
            TableRelation = IF (Document Type=FILTER(Order|Invoice),
                                Quantity=FILTER(<0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                     Item No.=FIELD(No.),
                                                                                     Variant Code=FIELD(Variant Code))
                                                                                     ELSE IF (Document Type=FILTER(Return Order|Credit Memo),
                                                                                              Quantity=FILTER(>=0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                    Item No.=FIELD(No.),
                                                                                                                                                    Variant Code=FIELD(Variant Code))
                                                                                                                                                    ELSE Bin.Code WHERE (Location Code=FIELD(Location Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. (Base)"(Field 5495)".

        modify("Special Order Sales Line No.")
        {
            TableRelation = IF (Special Order=CONST(Yes)) "Sales Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                         Document No.=FIELD(Special Order Sales No.));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Whse. Outstanding Qty. (Base)"(Field 5750)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. to Assign"(Field 5801)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. Assigned"(Field 5802)".

        modify("Operation No.")
        {
            TableRelation = "Prod. Order Routing Line"."Operation No." WHERE (Status=CONST(Released),
                                                                              Prod. Order No.=FIELD(Prod. Order No.),
                                                                              Routing No.=FIELD(Routing No.));
        }
        modify("Prod. Order Line No.")
        {
            TableRelation = "Prod. Order Line"."Line No." WHERE (Status=FILTER(Released..),
                                                                 Prod. Order No.=FIELD(Prod. Order No.));
        }


        //Unsupported feature: Code Modification on "Type(Field 5).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            GetPurchHeader;
            TestStatusOpen;

            TESTFIELD("Qty. Rcd. Not Invoiced",0);
            TESTFIELD("Quantity Received",0);
            #6..53
            "System-Created Entry" := TempPurchLine."System-Created Entry";
            VALIDATE("FA Posting Type");

            IF Type = Type::Item THEN
              "Allow Item Charge Assignment" := TRUE
            ELSE
              "Allow Item Charge Assignment" := FALSE;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            GetPurchHeader;
            TestStatusOpen;
            TestOrderType;
            #3..56
            //EDMS1.0.00 >>
             "Document Profile" := TempPurchLine."Document Profile";
            //EDMS1.0.00 <<

            #57..60
            */
        //end;


        //Unsupported feature: Code Modification on ""No."(Field 6).OnValidate".

        //trigger "(Field 6)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            "No." := TypeHelper.FindNoFromTypedValue(Type,"No.",NOT "System-Created Entry");

            TestStatusOpen;
            TESTFIELD("Qty. Rcd. Not Invoiced",0);
            TESTFIELD("Quantity Received",0);
            #6..25

            IF "No." <> xRec."No." THEN BEGIN
              IF (Quantity <> 0) AND ItemExists(xRec."No.") THEN BEGIN
                ReservePurchLine.VerifyChange(Rec,xRec);
                CALCFIELDS("Reserved Qty. (Base)");
                TESTFIELD("Reserved Qty. (Base)",0);
                IF Type = Type::Item THEN
                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
              END;
            #35..42
              "Recalculate Invoice Disc." := TRUE;
            Type := TempPurchLine.Type;
            "No." := TempPurchLine."No.";
            IF "No." = '' THEN
              EXIT;
            IF Type <> Type::" " THEN BEGIN
            #49..74
              "Prepayment %" := PurchHeader."Prepayment %";
            "Prepayment Tax Area Code" := PurchHeader."Tax Area Code";
            "Prepayment Tax Liable" := PurchHeader."Tax Liable";
            "Responsibility Center" := PurchHeader."Responsibility Center";

            "Requested Receipt Date" := PurchHeader."Requested Receipt Date";
            "Promised Receipt Date" := PurchHeader."Promised Receipt Date";
            "Inbound Whse. Handling Time" := PurchHeader."Inbound Whse. Handling Time";
            "Order Date" := PurchHeader."Order Date";
            UpdateLeadTimeFields;
            UpdateDates;

            #87..110
                  GetGLSetup;
                  Item.TESTFIELD(Blocked,FALSE);
                  Item.TESTFIELD("Gen. Prod. Posting Group");
                  IF Item.Type = Item.Type::Inventory THEN BEGIN
                    Item.TESTFIELD("Inventory Posting Group");
                    "Posting Group" := Item."Inventory Posting Group";
            #117..127
                  Nonstock := Item."Created From Nonstock Item";
                  "Item Category Code" := Item."Item Category Code";
                  "Product Group Code" := Item."Product Group Code";
                  "Allow Item Charge Assignment" := TRUE;
                  PrepmtMgt.SetPurchPrepaymentPct(Rec,PurchHeader."Posting Date");

            #134..174
                  Description := ItemCharge.Description;
                  "Gen. Prod. Posting Group" := ItemCharge."Gen. Prod. Posting Group";
                  "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
                  "Tax Group Code" := ItemCharge."Tax Group Code";
                  "Allow Invoice Disc." := FALSE;
                  "Allow Item Charge Assignment" := FALSE;
                  "Indirect Cost %" := 0;
                  "Overhead Rate" := 0;
                END;
            END;

            IF NOT (Type IN [Type::" ",Type::"Fixed Asset"]) THEN
            #187..189

            IF Type <> Type::" " THEN BEGIN
              Quantity := xRec.Quantity;
              VALIDATE("Unit of Measure Code");
              IF Quantity <> 0 THEN BEGIN
                InitOutstanding;
            #196..209
              END;
            END;

            IF NOT ISTEMPORARY THEN
              CreateDim(
                DimMgt.TypeToTableID3(Type),"No.",
                DATABASE::Job,"Job No.",
                DATABASE::"Responsibility Center","Responsibility Center",
                DATABASE::"Work Center","Work Center No.");

            PurchHeader.GET("Document Type","Document No.");
            UpdateItemReference;
            #222..224
            IF JobTaskIsSet THEN BEGIN
              CreateTempJobJnlLine(TRUE);
              UpdateJobPrices;
            END
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            CALCFIELDS("Account Name");
            "No." := TypeHelper.FindNoFromTypedValue(Type,"No.",NOT "System-Created Entry");
            #3..28
                // 26.03.2014 Elva Baltic P21 >>
                CALCFIELDS("Reserved Qty. (Base)");
                IF ("Reserved Qty. (Base)" <> 0) AND ("No." <> '') THEN BEGIN                 // 04.04.2014 Elva Baltic P21
                  ReservePurchLine.UpdateReservAfterItemNoChange(Rec,xRec,TempReservEntry);
                  "Item No. Changed" := TRUE;
                END;
                // 26.03.2014 Elva Baltic P21 <<

            #29..31

                IF "Item No. Changed" THEN                                                    // 26.03.2014 Elva Baltic P21
                  ReservePurchLine.CopyReservEntryFromTemp(Rec,TempReservEntry);              // 26.03.2014 Elva Baltic P21

            #32..45

            "Item No. Changed" := TempPurchLine."Item No. Changed";                            // 26.03.2014 Elva Baltic P21
            //EDMS1.0.00 >>
             "Line Type" := TempPurchLine."Line Type";
             "Document Profile" := TempPurchLine."Document Profile";
             "Make Code" := TempPurchLine."Make Code";
             "Model Code" := TempPurchLine."Model Code";
             "Model Version No." := TempPurchLine."Model Version No.";
             "Line Type" := TempPurchLine."Line Type";
             "Deal Type Code" := TempPurchLine."Deal Type Code";
             "Vehicle Serial No." := TempPurchLine."Vehicle Serial No.";
             "Vehicle Accounting Cycle No." := TempPurchLine."Vehicle Accounting Cycle No.";
             "Vehicle Status Code" := TempPurchLine."Vehicle Status Code";
            //16.03 2016 EB.P7 Branch Setup >>
            {
            IF "Vehicle Status Code" = '' THEN
              IF UserProfileMgt.CurrProfileID <> '' THEN
                IF UserProfile.GET(UserProfileMgt.CurrProfileID) THEN
                  IF UserProfile."Default Vehicle Purch. Status" <> '' THEN
                    VALIDATE("Vehicle Status Code", UserProfile."Default Vehicle Purch. Status");
            }
            //16.03 2016 EB.P7 Branch Setup <<

             "External Serv. Tracking No." := TempPurchLine."External Serv. Tracking No.";

              IF "Line Type" = "Line Type"::Vehicle THEN
               IF "No." = '' THEN
                BEGIN
                 "Model Version No." := '';
                 "Vehicle Serial No." := '';
                END;
            //EDMS1.0.00 <<

            #46..77

            IF UserMgt.DefaultResponsibility THEN
              "Responsibility Center" := PurchHeader."Responsibility Center"
            ELSE
              "Accountability Center" := PurchHeader."Accountability Center";
            #79..83
            "Vendor Order No." := PurchHeader."Vendor Order No."; //26.02.2008 EDMS P1

            #84..113
                  Item.TESTFIELD("Is NLS",FALSE);
                  Item.TESTFIELD("Purchase Type",PurchHeader."Order Type");
            #114..130
                  ABC := Item.ABC; //Min 5.29.2020
            #131..177
                  "Posting Group" := ItemCharge."Inventory Posting Group"; //EDMS
            #178..183

              //21.12.2007 EDMS P5 >>
              Type::"External Service":
               BEGIN
                 ExternalService.GET("No.");
                 Description := ExternalService.Description;
                 "Gen. Prod. Posting Group" := ExternalService."Gen. Prod. Posting Group";
                 "VAT Prod. Posting Group" := ExternalService."VAT Prod. Posting Group";
               END;
             //21.12.2007 EDMS P5 <<

            #184..192

              //EDMS1.0.00 >>
               IF "Line Type" = "Line Type"::Vehicle THEN
                 Quantity := 1;
              //EDMS1.0.00 <<

            #193..212
            IF NOT ISTEMPORARY THEN BEGIN
              //EDMS1.0.00 >>
            IF UserMgt.DefaultResponsibility THEN
              CreateDim(
                DimMgt.TypeToTableID3(Type),"No.",
                //DATABASE::Job,"Job No.", //DMS
                DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
                DATABASE::"Responsibility Center","Responsibility Center",
                DATABASE::"Work Center","Work Center No.",
                DATABASE::Make,"Make Code",
                DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                DATABASE::Location,"Location Code",      // 10.03.2015 EDMS P21
                DATABASE::"Deal Type","Deal Type Code"   // 12.05.2015 EB.P30
                ) //DMS
            ELSE
              CreateDim(
                DimMgt.TypeToTableID3(Type),"No.",
                //DATABASE::Job,"Job No.", //DMS
                DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
                DATABASE::"Accountability Center","Accountability Center",
                DATABASE::"Work Center","Work Center No.",
                DATABASE::Make,"Make Code",
                DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                DATABASE::Location,"Location Code",      // 10.03.2015 EDMS P21
                DATABASE::"Deal Type","Deal Type Code"   // 12.05.2015 EB.P30
                );
              //EDMS1.0.00 <<
            END;
            //EDMS1.0.00 >>
             IF "Line Type" = "Line Type"::Vehicle THEN
              BEGIN
               IF "Vehicle Serial No." = '' THEN
                fNewSerialNo;
               IF "No." <> "Model Version No." THEN BEGIN
                "Model Version No." := "No.";
                "Make Code" := Item."Make Code";
                "Model Code" := Item."Model Code"
               END
              END;
            //EDMS1.0.00 <<
            #219..227
            END;


            {
            //Agile6.1.0>>
            //Calling function in Codeunit::33019810 - CheckVndLevelPrchLine to check for Vendor-Item Levels.
            //If is not of L1 then throws message.
            IF (Type = Type::Item) THEN BEGIN
              IF NOT ("Document Profile" IN ["Document Profile"::"Spare Parts Trade","Document Profile"::"Vehicles Trade",
                      "Document Profile"::Service]) THEN
                LclPrcDocMngt.checkVndItemLvlPrchLine("Buy-from Vendor No.","No.");
            END;
            //Agile6.1.0<<
            }
              //EDMS1.0.00 >>
               IF "Line Type" = "Line Type"::Vehicle THEN BEGIN
                 Quantity := 1;
                 "Qty. to Invoice":=0;
                 "Qty. to Receive":=0;
              END;
              //EDMS1.0.00 <<

            //TDS2.00
            PurchHeader.RESET;
            PurchHeader.SETRANGE("No.","Document No.");
            PurchHeader.FINDFIRST;

            IF PurchHeader."TDS Posting Group" <> '' THEN
              VALIDATE("TDS Group",PurchHeader."TDS Posting Group");
            //TDS2.00
            */
        //end;


        //Unsupported feature: Code Modification on ""Location Code"(Field 7).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestStatusOpen;

            IF "Location Code" <> '' THEN
            #4..52

            IF "Document Type" = "Document Type"::"Return Order" THEN
              ValidateReturnReasonCode(FIELDNO("Location Code"));
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..55

            // 10.03.2015 EDMS P21 >>
            CreateDim(
              DimMgt.TypeToTableID3(Type),"No.",
              DATABASE::"Vehicle Status","Vehicle Status Code",
              DATABASE::"Responsibility Center","Responsibility Center",
              DATABASE::Location,"Location Code",
              DATABASE::"Work Center","Work Center No.",
              DATABASE::Make,"Make Code",
              DATABASE::Vehicle,"Vehicle Serial No.",
              DATABASE::"Deal Type","Deal Type Code" // 12.05.2015 EB.P30
              );
            // 10.03.2015 EDMS P21 <<
            */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on "Quantity(Field 15).OnValidate".

        //trigger (Variable: ItemSubstSync)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on "Quantity(Field 15).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestStatusOpen;

            IF "Drop Shipment" AND ("Document Type" <> "Document Type"::Invoice) THEN
              ERROR(
            #5..71

            UpdatePrePaymentAmounts;

            IF "Job Planning Line No." <> 0 THEN
              VALIDATE("Job Planning Line No.");

            #78..80
            END;

            CheckWMS;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            CALCFIELDS("Account Name");
            TestStatusOpen;
            ItemSubstSync.ReplacePurchaseLineItemNo(Rec);

            //09.05.2008. EDMS P2 >>
            IF ("Line Type" = "Line Type"::Vehicle) AND (Quantity > 1) THEN
              TESTFIELD(Quantity, 1);
            //09.05.2008. EDMS P2 <<
            #2..74

            //TDS2.00
            ClearTDSFields;
            //"TDS Group" := '';
            //PurchHeader.CalculateTDS;
            //TDS2.00

            #75..83
                                                                            //Agni Incorporate UPG
            IF Type = Type::Item THEN BEGIN
              IF Quantity <> 0 THEN BEGIN
                Itm.GET("No.");
                CBM := Quantity * Itm.CBM;
                END
                ELSE
                CBM := 0;
              END;
              //Agni Incorporate UPG
            */
        //end;


        //Unsupported feature: Code Modification on ""Qty. to Invoice"(Field 17).OnValidate".

        //trigger  to Invoice"(Field 17)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "Qty. to Invoice" = MaxQtyToInvoice THEN
              InitQtyToInvoice
            ELSE
            #4..13
            CalcInvDiscToInvoice;
            CalcPrepaymentToDeduct;

            IF "Job Planning Line No." <> 0 THEN
              VALIDATE("Job Planning Line No.");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..16

            //temporary fix to process vehicle purchase
            IF "Line Type" = "Line Type"::Vehicle THEN BEGIN
              IF ("Qty. to Invoice"=1) AND ("Quantity Invoiced" = 0) THEN BEGIN
                "Qty. to Invoice (Base)" := 1;
                "Qty. Rcd. Not Invoiced (Base)" := 1;
                "Qty. Invoiced (Base)" := 0;
              END;
            END;


            //TDS2.00
            ClearTDSFields;
            //"TDS Group" := '';
            //PurchHeader.CalculateTDS;
            //TDS2.00

            IF "Job Planning Line No." <> 0 THEN
              VALIDATE("Job Planning Line No.");
            */
        //end;


        //Unsupported feature: Code Modification on ""Qty. to Receive"(Field 18).OnValidate".

        //trigger  to Receive"(Field 18)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            GetLocation("Location Code");
            IF (CurrFieldNo <> 0) AND
               (Type = Type::Item) AND
            #4..33
            IF (CurrFieldNo <> 0) AND (Type = Type::Item) AND ("Qty. to Receive" < 0) THEN
              CheckApplToItemLedgEntry;

            IF "Job Planning Line No." <> 0 THEN
              VALIDATE("Job Planning Line No.");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..36

            //temporary fix to process vehicle purchase
            IF "Line Type" = "Line Type"::Vehicle THEN BEGIN
              IF ("Qty. to Receive"=1) AND ("Quantity Received" = 0) THEN BEGIN
                "Outstanding Qty. (Base)" := 1;
                "Qty. to Receive (Base)" := 1;
                "Qty. to Invoice (Base)" := 0;
                "Qty. Rcd. Not Invoiced (Base)" := 0;
                "Qty. Received (Base)" := 0;
              END;
            END;

            IF "Job Planning Line No." <> 0 THEN
              VALIDATE("Job Planning Line No.");
            */
        //end;


        //Unsupported feature: Code Modification on ""Direct Unit Cost"(Field 22).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            VALIDATE("Line Discount %");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            VALIDATE("Line Discount %");

            //TDS2.00
            ClearTDSFields;
            //"TDS Group" := '';
            //PurchHeader.CalculateTDS;
            //TDS2.00
            */
        //end;


        //Unsupported feature: Code Modification on ""Line Discount %"(Field 27).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestStatusOpen;
            GetPurchHeader;
            "Line Discount Amount" :=
              ROUND(
                ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") *
            #6..8
            "Inv. Disc. Amount to Invoice" := 0;
            UpdateAmounts;
            UpdateUnitCost;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            TestStatusOpen;
            GetPurchHeader;

            IF "Document Profile" = "Document Profile"::"Spare Parts Trade" THEN
              IF (PurchHeader."Order Type" = PurchHeader."Order Type"::"Local") AND ("Line Discount %" <> 0) THEN
                ERROR(CannotGetDiscountOnVOR);
            #3..11
            */
        //end;


        //Unsupported feature: Code Modification on ""Line Discount Amount"(Field 28).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            GetPurchHeader;
            "Line Discount Amount" := ROUND("Line Discount Amount",Currency."Amount Rounding Precision");
            TestStatusOpen;
            TESTFIELD(Quantity);
            IF xRec."Line Discount Amount" <> "Line Discount Amount" THEN
              IF ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") <> 0 THEN
                "Line Discount %" :=
            #8..14
            "Inv. Disc. Amount to Invoice" := 0;
            UpdateAmounts;
            UpdateUnitCost;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..4

            IF "Document Profile" = "Document Profile"::"Spare Parts Trade" THEN
              IF (PurchHeader."Order Type" = PurchHeader."Order Type"::"Local") AND ("Line Discount Amount" <> 0) THEN
                ERROR(CannotGetDiscountOnVOR);
            #5..17
            */
        //end;


        //Unsupported feature: Code Modification on ""Job No."(Field 45).OnValidate".

        //trigger "(Field 45)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TESTFIELD("Drop Shipment",FALSE);
            TESTFIELD("Special Order",FALSE);
            TESTFIELD("Receipt No.",'');
            #4..12
            END;

            IF "Job No." = '' THEN BEGIN
              CreateDim(
                DATABASE::Job,"Job No.",
                DimMgt.TypeToTableID3(Type),"No.",
                DATABASE::"Responsibility Center","Responsibility Center",
                DATABASE::"Work Center","Work Center No.");
              EXIT;
            END;

            IF NOT (Type IN [Type::Item,Type::"G/L Account"]) THEN
              FIELDERROR("Job No.",STRSUBSTNO(Text012,FIELDCAPTION(Type),Type));
            Job.GET("Job No.");
            Job.TestBlocked;
            "Job Currency Code" := Job."Currency Code";

            CreateDim(
              DATABASE::Job,"Job No.",
              DimMgt.TypeToTableID3(Type),"No.",
              DATABASE::"Responsibility Center","Responsibility Center",
              DATABASE::"Work Center","Work Center No.");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..15
              IF UserMgt.DefaultResponsibility THEN
                CreateDim(
                  //DATABASE::Job,"Job No.",
                  DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
                  DimMgt.TypeToTableID3(Type),"No.",
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::"Work Center","Work Center No.",
                  DATABASE::Make,"Make Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::Location,"Location Code",     // 10.03.2015 EDMS P21
                  DATABASE::"Deal Type","Deal Type Code"  // 12.05.2015 EB.P30
                  ) //DMS
              ELSE
                 CreateDim(
                  //DATABASE::Job,"Job No.",
                  DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
                  DimMgt.TypeToTableID3(Type),"No.",
                  DATABASE::"Accountability Center","Accountability Center",
                  DATABASE::"Work Center","Work Center No.",
                  DATABASE::Make,"Make Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::Location,"Location Code",     // 10.03.2015 EDMS P21
                  DATABASE::"Deal Type","Deal Type Code"  // 12.05.2015 EB.P30
                  );
            #21..28
            IF UserMgt.DefaultResponsibility THEN
              CreateDim(
                //DATABASE::Job,"Job No.",
                DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
                DimMgt.TypeToTableID3(Type),"No.",
                DATABASE::"Responsibility Center","Responsibility Center",
                DATABASE::"Work Center","Work Center No.",
                DATABASE::Make,"Make Code",
                DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                DATABASE::Location,"Location Code",     // 10.03.2015 EDMS P21
                DATABASE::"Deal Type","Deal Type Code"  // 12.05.2015 EB.P30
                ) //DMS
            ELSE
                CreateDim(
                //DATABASE::Job,"Job No.",
                DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
                DimMgt.TypeToTableID3(Type),"No.",
                DATABASE::"Accountability Center","Accountability Center",
                DATABASE::"Work Center","Work Center No.",
                DATABASE::Make,"Make Code",
                DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                DATABASE::Location,"Location Code",     // 10.03.2015 EDMS P21
                DATABASE::"Deal Type","Deal Type Code"  // 12.05.2015 EB.P30
                );
            */
        //end;


        //Unsupported feature: Code Modification on ""VAT Prod. Posting Group"(Field 90).OnValidate".

        //trigger  Posting Group"(Field 90)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestStatusOpen;
            VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
            "VAT Difference" := 0;
            #4..14
                  TESTFIELD("No.",VATPostingSetup."Purchase VAT Account");
                END;
            END;
            IF PurchHeader."Prices Including VAT" AND (Type = Type::Item) THEN
              "Direct Unit Cost" :=
                ROUND(
                  "Direct Unit Cost" * (100 + "VAT %") / (100 + xRec."VAT %"),
                  Currency."Unit-Amount Rounding Precision");
            UpdateAmounts;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..17
            "Localized VAT Identifier" := VATPostingSetup."Localized VAT Identifier"; //aakrista
            #18..23
            */
        //end;


        //Unsupported feature: Code Insertion on ""Unit Cost"(Field 100)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            MESSAGE('Here');
            */
        //end;


        //Unsupported feature: Code Modification on ""Job Task No."(Field 1001).OnValidate".

        //trigger "(Field 1001)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TESTFIELD("Receipt No.",'');

            IF "Job Task No." <> xRec."Job Task No." THEN BEGIN
            #4..13
                DimMgt.TypeToTableID3(Type),"No.",
                DATABASE::Job,"Job No.",
                DATABASE::"Responsibility Center","Responsibility Center",
                DATABASE::"Work Center","Work Center No.");
              EXIT;
            END;

            #21..23
              UpdateJobPrices;
            END;
            UpdateDimensionsFromJobTask;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..16
                DATABASE::"Work Center","Work Center No.",
                DATABASE::Make,"Make Code",
                DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                DATABASE::Location,"Location Code",      // 10.03.2015 EDMS P21
                DATABASE::"Deal Type","Deal Type Code"   // 12.05.2015 EB.P30
                );
            #18..26
            */
        //end;


        //Unsupported feature: Code Modification on ""Responsibility Center"(Field 5700).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            CreateDim(
              DATABASE::"Responsibility Center","Responsibility Center",
              DimMgt.TypeToTableID3(Type),"No.",
              DATABASE::Job,"Job No.",
              DATABASE::"Work Center","Work Center No.");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            //EDMS1.0.00 >>
            #1..3
              //DATABASE::Job,"Job No.", //DMS
              DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
              DATABASE::"Work Center","Work Center No.",
              DATABASE::Make,"Make Code",
              DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
              DATABASE::Location,"Location Code",     // 10.03.2015 EDMS P21
              DATABASE::"Deal Type","Deal Type Code"  // 12.05.2015 EB.P30
              ); //DMS
            //EDMS1.0.00 <<
            */
        //end;


        //Unsupported feature: Code Modification on ""Order Date"(Field 5795).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestStatusOpen;
            IF (CurrFieldNo <> 0) AND
               ("Document Type" = "Document Type"::Order) AND
            #4..20
                  CalChange."Source Type"::Location,"Location Code",'',FALSE)
            ELSE
              "Expected Receipt Date" := "Planned Receipt Date";

            IF NOT TrackingBlocked THEN
              CheckDateConflict.PurchLineCheck(Rec,CurrFieldNo <> 0);
            CheckReservationDateConflict(FIELDNO("Order Date"));
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..23
            //16.11.2011 EDMS P8 >>
            UpdateDatesEDMS;
            //16.11.2011 EDMS P8 <<
            #25..27
            */
        //end;


        //Unsupported feature: Code Modification on ""Work Center No."(Field 99000752).OnValidate".

        //trigger "(Field 99000752)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF Type = Type::"Charge (Item)" THEN
              TESTFIELD("Work Center No.",'');
            IF "Work Center No." = '' THEN
            #4..12
            "Overhead Rate" := WorkCenter."Overhead Rate";
            VALIDATE("Indirect Cost %",WorkCenter."Indirect Cost %");

            CreateDim(
              DATABASE::"Work Center","Work Center No.",
              DimMgt.TypeToTableID3(Type),"No.",
              DATABASE::Job,"Job No.",
              DATABASE::"Responsibility Center","Responsibility Center");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..15
            //EDMS1.0.00 >>
            IF UserMgt.DefaultResponsibility THEN
              CreateDim(
                DATABASE::"Work Center","Work Center No.",
                DimMgt.TypeToTableID3(Type),"No.",
                //DATABASE::Job,"Job No.", //DMS
                DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
                DATABASE::"Responsibility Center","Responsibility Center",
                DATABASE::Make,"Make Code",
                DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                DATABASE::Location,"Location Code",     // 10.03.2015 EDMS P21
                DATABASE::"Deal Type","Deal Type Code"  // 12.05.2015 EB.P30
                ) //DMS
            ELSE
              CreateDim(
              DATABASE::"Work Center","Work Center No.",
              DimMgt.TypeToTableID3(Type),"No.",
              //DATABASE::Job,"Job No.", //DMS
              DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
              DATABASE::"Accountability Center","Accountability Center",
              DATABASE::Make,"Make Code",
              DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
              DATABASE::Location,"Location Code",     // 10.03.2015 EDMS P21
              DATABASE::"Deal Type","Deal Type Code"  // 12.05.2015 EB.P30
              );
            //EDMS1.0.00 <<
            */
        //end;
        field(50000;"Requistion No.";Code[20])
        {
        }
        field(50001;"VIN - COGS";Code[20])
        {

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
                frmVehicleList: Page "25006033";
            begin
                recVehicle.RESET;
                IF LookUpMgt.LookUpVehicleAMT(recVehicle,"Vehicle Serial No.") THEN
                 BEGIN
                  //VALIDATE("Vehicle Serial No.",recVehicle."Serial No.");
                  "VIN - COGS" := recVehicle.VIN;
                 END;
            end;
        }
        field(50053;"Commercial Invoice No.";Code[20])
        {
            Description = 'to add in vechile create';

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
            begin
            end;
        }
        field(50054;"Production Years";Code[4])
        {
            Description = 'to add in vechile create';

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
            begin
            end;

            trigger OnValidate()
            var
                recVehicle: Record "25006005";
            begin
            end;
        }
        field(50097;"COGS Type";Option)
        {
            Description = 'Used for Alternative of way of Item Charge';
            OptionCaption = ' ,ACCESSORIES-CV,ACCESSORIES-PC,BANK CHARGE-CV,BANK CHARGE-PC,BATTERY-CV,BATTERY-PC,BODY BUILDING-CV,BODY BUILDING-PC,CHASSIS REGISTR-CV,CHASSIS REGISTR-PC,CLEARING & FORW-CV,CLEARING & FORW-PC,CUSTOM DUTY-CV,CUSTOM DUTY-PC,DENT / PENT-CV,DENT / PENT-PC,DRIVER-CV,DRIVER-PC,FOREIGN CHARGE-CV,FOREIGN CHARGE-PC,FUEL & OIL-CV,FUEL & OIL-PC,INSURANCE MANAG-CV,INSURANCE MANAG-PC,INSURANCE-CV,INSURANCE-PC,,L/C & BANK CHAR-CV,L/C & BANK CHAR-PC,LUBRICANTS-CV,LUBRICANTS-PC,NEW CHASSIS REP-CV,NEW CHASSIS REP-PC,PARKING CHARGE-CV,PARKING CHARGE-PC,PRAGYANPAN-CV,PRAGYANPAN-PC,SERVICE CHARGE-CV,SERVICE CHARGE-PC,SPARES-CV,SPARES-PC,TRANSPORTATION-CV,TRANSPORTATION-PC,VEHICLE LOGISTI-CV,VEHICLE LOGISTI-PC,VEHICLE TAX-CV,VEHICLE TAX-PC';
            OptionMembers = " ","ACCESSORIES-CV","ACCESSORIES-PC","BANK CHARGE-CV","BANK CHARGE-PC","BATTERY-CV","BATTERY-PC","BODY BUILDING-CV","BODY BUILDING-PC","CHASSIS REGISTR-CV","CHASSIS REGISTR-PC","CLEARING & FORW-CV","CLEARING & FORW-PC","CUSTOM DUTY-CV","CUSTOM DUTY-PC","DENT / PENT-CV","DENT / PENT-PC","DRIVER-CV","DRIVER-PC","FOREIGN CHARGE-CV","FOREIGN CHARGE-PC","FUEL & OIL-CV","FUEL & OIL-PC","INSURANCE MANAG-CV","INSURANCE MANAG-PC","INSURANCE-CV","INSURANCE-PC",,"L/C & BANK CHAR-CV","L/C & BANK CHAR-PC","LUBRICANTS-CV","LUBRICANTS-PC","NEW CHASSIS REP-CV","NEW CHASSIS REP-PC","PARKING CHARGE-CV","PARKING CHARGE-PC","PRAGYANPAN-CV","PRAGYANPAN-PC","SERVICE CHARGE-CV","SERVICE CHARGE-PC","SPARES-CV","SPARES-PC","TRANSPORTATION-CV","TRANSPORTATION-PC","VEHICLE LOGISTI-CV","VEHICLE LOGISTI-PC","VEHICLE TAX-CV","VEHICLE TAX-PC";
        }
        field(50098;"Document Class";Option)
        {
            Caption = 'Document Class';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Assets';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Assets";
        }
        field(50099;"Document Subclass";Code[20])
        {
            Caption = 'Document Subclass';
            TableRelation = IF (Document Class=CONST(Customer)) Customer
                            ELSE IF (Document Class=CONST(Vendor)) Vendor
                            ELSE IF (Document Class=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Document Class=CONST(Fixed Assets)) "Fixed Asset";
        }
        field(59000;"TDS Group";Code[20])
        {
            TableRelation = "TDS Posting Group";

            trigger OnValidate()
            begin
                //ClearTDSFields; //TDS2.00
                IF "TDS Group" = '' THEN BEGIN
                  "TDS%" := 0;
                  "TDS Type" := "TDS Type"::" ";
                  "TDS Amount" := 0;
                  "TDS Base Amount" := 0;
                END ELSE BEGIN
                  TDSPostingGroup.RESET;
                  TDSPostingGroup.SETRANGE(Code,"TDS Group");
                  IF TDSPostingGroup.FINDFIRST THEN BEGIN
                    TDSPostingGroup.TESTFIELD("TDS%");
                    TDSPostingGroup.TESTFIELD("GL Account No.");
                    "TDS Type" := "TDS Type"::"Purchase TDS";
                    "TDS%" := TDSPostingGroup."TDS%";
                  END;
                END;
            end;
        }
        field(59001;"TDS%";Decimal)
        {
            Editable = false;
        }
        field(59002;"TDS Type";Option)
        {
            Editable = false;
            OptionCaption = ' ,Purchase TDS,Sales TDS';
            OptionMembers = " ","Purchase TDS","Sales TDS";
        }
        field(59003;"TDS Amount";Decimal)
        {
            Editable = false;
        }
        field(59004;"TDS Base Amount";Decimal)
        {
            Editable = false;
        }
        field(59005;ABC;Option)
        {
            Editable = false;
            OptionCaption = ' ,A,B,C,D,E';
            OptionMembers = " ",A,B,C,D,E;
        }
        field(59006;"Cost Type";Option)
        {
            OptionCaption = ' ,Fixed Cost,Variable Cost';
            OptionMembers = " ","Fixed Cost","Variable Cost";
        }
        field(70000;"Package No.";Code[20])
        {
            Description = 'QR19.00';
        }
        field(25006000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001;"Deal Type Code";Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";

            trigger OnValidate()
            begin
                TestStatusOpen;
                //12.06.2015 EB.P30 >>
                CreateDim(
                  DimMgt.TypeToTableID3(Type),"No.",
                  DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::"Work Center","Work Center No.",
                  DATABASE::Make,"Make Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::Location,"Location Code",      // 10.03.2015 EDMS P21
                  DATABASE::"Deal Type","Deal Type Code"   // 12.05.2015 EB.P30
                  ); //DMS
                //12.06.2015 EB.P30 <<
            end;
        }
        field(25006006;"Vendor Order No.";Code[20])
        {
            Caption = 'Vendor Order No.';

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(25006010;"Reservation Entry No.";Integer)
        {
            BlankZero = true;
            CalcFormula = Lookup("Reservation Entry"."Entry No." WHERE (Source Type=CONST(39),
                                                                        Source Subtype=FIELD(Document Type),
                                                                        Source ID=FIELD(Document No.),
                                                                        Source Ref. No.=FIELD(Line No.),
                                                                        Reservation Status=CONST(Reservation)));
            Caption = 'Reservation Entry No.';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006011;"Reservation Source Type";Integer)
        {
            BlankZero = true;
            CalcFormula = Lookup("Reservation Entry"."Source Type" WHERE (Entry No.=FIELD(Reservation Entry No.),
                                                                          Positive=CONST(No)));
            Caption = 'Reservation Source Type';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006012;"Reservation Source Subtype";Option)
        {
            BlankZero = true;
            CalcFormula = Lookup("Reservation Entry"."Source Subtype" WHERE (Entry No.=FIELD(Reservation Entry No.),
                                                                             Positive=CONST(No)));
            Caption = 'Reservation Source Subtype';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(25006013;"Reservation Source ID";Code[20])
        {
            CalcFormula = Lookup("Reservation Entry"."Source ID" WHERE (Entry No.=FIELD(Reservation Entry No.),
                                                                        Positive=CONST(No)));
            Caption = 'Reservation Source ID';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006014;"Reservation Source Ref. No.";Integer)
        {
            BlankZero = true;
            CalcFormula = Lookup("Reservation Entry"."Source Ref. No." WHERE (Entry No.=FIELD(Reservation Entry No.),
                                                                              Positive=CONST(No)));
            Caption = 'Reservation Source Ref. No.';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006015;"Reservation VIN";Code[20])
        {
            CalcFormula = Lookup("Sales Line".VIN WHERE (Document Type=FIELD(Reservation Source Subtype),
                                                         Document No.=FIELD(Reservation Source ID),
                                                         Line No.=FIELD(Reservation Source Ref. No.)));
            Caption = 'Reservation VIN';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006016;"Reservation Customer No.";Code[20])
        {
            CalcFormula = Lookup("Sales Line"."Sell-to Customer No." WHERE (Document Type=FIELD(Reservation Source Subtype),
                                                                            Document No.=FIELD(Reservation Source ID),
                                                                            Line No.=FIELD(Reservation Source Ref. No.)));
            Caption = 'Reservation Customer No.';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006100;"Special Order Service No.";Code[20])
        {
            Caption = 'Special Order Service No.';
            Description = 'P15';
            Editable = false;
            TableRelation = "Service Header EDMS".No. WHERE (Document Type=CONST(Order));

            trigger OnValidate()
            var
                ApprAllowed: Boolean;
            begin
                IF (xRec."Special Order Service No." <> "Special Order Service No.") AND (Quantity <> 0) THEN
                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
            end;
        }
        field(25006101;"Special Order Service Line No.";Integer)
        {
            Caption = 'Sales Order Line No.';
            Editable = false;

            trigger OnValidate()
            var
                ApprAllowed: Boolean;
            begin
                IF (xRec."Special Order Service Line No." <> "Special Order Service Line No.") AND (Quantity <> 0) THEN
                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
            end;
        }
        field(25006130;"External Serv. Tracking No.";Code[20])
        {
            Caption = 'External Serv. Tracking No.';
            TableRelation = IF (Type=FILTER(External Service)) "External Serv. Tracking No."."External Serv. Tracking No." WHERE (External Service No.=FIELD(No.));
        }
        field(25006170;"Vehicle Registration No.";Code[30])
        {
            Caption = 'Vehicle Registration No.';

            trigger OnLookup()
            begin
                OnLookupVehicleRegistrationNo;
            end;

            trigger OnValidate()
            begin
                IF "Vehicle Registration No." = '' THEN BEGIN
                  VALIDATE("Vehicle Serial No.",'');
                  EXIT;
                END;
            end;
        }
        field(25006310;"Link Trade-In Entry";Integer)
        {
            Caption = 'Link Trade-In Entry';
        }
        field(25006370;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            var
                recModel: Record "25006001";
            begin
                TestStatusOpen;

                //EDMS
                IF UserMgt.DefaultResponsibility THEN
                  CreateDim(
                    DATABASE::"Responsibility Center","Responsibility Center",
                    DimMgt.TypeToTableID3(Type),"No.",
                    //DATABASE::Job,"Job No.",
                    DATABASE::"Vehicle Status","Vehicle Status Code",
                    DATABASE::"Work Center","Work Center No.",
                    DATABASE::Make,"Make Code",
                    DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                    DATABASE::Location,"Location Code",     // 10.03.2015 EDMS P21
                    DATABASE::"Deal Type","Deal Type Code"  // 12.05.2015 EB.P30
                    )
                ELSE
                  CreateDim(
                  DATABASE::"Accountability Center","Accountability Center",
                  DimMgt.TypeToTableID3(Type),"No.",
                  //DATABASE::Job,"Job No.",
                  DATABASE::"Vehicle Status","Vehicle Status Code",
                  DATABASE::"Work Center","Work Center No.",
                  DATABASE::Make,"Make Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::Location,"Location Code",     // 10.03.2015 EDMS P21
                  DATABASE::"Deal Type","Deal Type Code"  // 12.05.2015 EB.P30
                  );

                IF "Make Code" <> xRec."Make Code" THEN
                 BEGIN
                  VALIDATE("Model Code",'');
                 END;
            end;
        }
        field(25006371;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));

            trigger OnValidate()
            begin
                TestStatusOpen;

                IF "Model Code" <> xRec."Model Code" THEN
                 BEGIN
                  VALIDATE("Model Version No.",'');
                 END;
            end;
        }
        field(25006372;"Line Type";Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,Vehicle,,,Charge (Item),G/L Account';
            OptionMembers = " ",Vehicle,,Item,"Charge (Item)","G/L Account";

            trigger OnValidate()
            var
                DocMgtDMS: Codeunit "25006000";
                Opt: Integer;
            begin
                TestStatusOpen;

                Opt := "Line Type";
                DocMgtDMS.PL_SetType_LineType(Rec);
                "Line Type" := Opt;
            end;
        }
        field(25006373;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
                frmVehicleList: Page "25006033";
            begin
                recVehicle.RESET;
                IF LookUpMgt.LookUpVehicleAMT(recVehicle,"Vehicle Serial No.") THEN
                 BEGIN
                  VALIDATE("Vehicle Serial No.",recVehicle."Serial No.");
                  VIN := recVehicle.VIN;
                 END;
            end;

            trigger OnValidate()
            var
                recVehicle: Record "25006005";
            begin
                TestStatusOpen;
            end;
        }
        field(25006374;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=CONST(Model Version));

            trigger OnLookup()
            var
                recItem: Record "27";
            begin
                recItem.RESET;
                IF LookUpMgt.LookUpModelVersion(recItem,"No.","Make Code","Model Code") THEN
                 VALIDATE("Model Version No.",recItem."No.");
            end;

            trigger OnValidate()
            begin
                TestStatusOpen;

                IF "Line Type" = "Line Type":: Vehicle THEN BEGIN
                  IF "Model Version No." <> '' THEN
                  VALIDATE("No.","Model Version No.")
                  ELSE
                    VALIDATE("No.",Item."No.");
                  //08.01.2013 EDMS P8 >>
                  CurrFieldNo := FIELDNO(Quantity);
                  IF Type = Type::Item THEN
                    IF "No." <> '' THEN
                      UpdateDirectUnitCost(FIELDNO(Quantity))
                  //08.01.2013 EDMS P8 <<
                END;
            end;
        }
        field(25006375;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
            begin
                recVehicle.RESET;
                IF LookUpMgt.LookUpVehicleAMT(recVehicle,"Vehicle Serial No.") THEN
                 BEGIN
                  VALIDATE("Vehicle Serial No.",recVehicle."Serial No.");
                  VIN := recVehicle.VIN;
                 END;
            end;

            trigger OnValidate()
            var
                recReservationEntry: Record "337";
                iEntryNo: Integer;
                frmItemTrackingLines: Page "6510";
                                          cPurchLineReserve: Codeunit "99000834";
                                          recVehicle: Record "25006005";
                                          codSerialNoPre: Code[20];
                                          codDefCycle: Code[20];
                                          cuVehSN: Codeunit "25006006";
                                          TextAssignNewCycle: Label 'Do you want to assign new %1?';
                VehAccCycleMgt: Codeunit "25006303";
                VheAccCycle: Record "25006024";
                vehi: Record "33019823";
            begin
                TestStatusOpen;
                GetPurchHeader;

                IF "Vehicle Serial No." = '' THEN
                 BEGIN
                  VIN := '';
                  "Vehicle Accounting Cycle No." := '';
                  "Vehicle Registration No." := '';
                 END
                ELSE
                 BEGIN
                  recVehicle.RESET;
                  IF recVehicle.GET("Vehicle Serial No.") THEN
                   BEGIN
                    codSerialNoPre := "Vehicle Serial No.";
                    VALIDATE("Make Code",recVehicle."Make Code");
                    VALIDATE("Model Code",recVehicle."Model Code");
                    VALIDATE("Model Version No.",recVehicle."Model Version No.");
                    //VALIDATE("Variant Code",recVehicle."VC No.");
                    VIN := recVehicle.VIN;
                    "Vehicle Serial No." := codSerialNoPre;
                    IF vehi.GET("Vehicle Serial No.") THEN;
                    vehi.CALCFIELDS("Default Vehicle Acc. Cycle No.");

                    "Vehicle Registration No." := recVehicle."Registration No.";

                    //13.05.2008. EDMS P2 >>
                    "Vehicle Status Code" := recVehicle."Status Code";
                    //13.05.2008. EDMS P2 <<

                    //18.06.2008. EDMS P2 >>
                    "Vehicle Body Color Code" := recVehicle."Body Color Code";
                    "Vehicle Interior Code" := recVehicle."Interior Code";
                    //18.06.2008. EDMS P2 <<

                    IF vehi."Default Vehicle Acc. Cycle No." <> '' THEN
                     IF (PurchHeader."Document Profile" <> PurchHeader."Document Profile"::Service) AND
                        ("Line Type" = "Line Type"::Vehicle) AND (NOT DontPromptVehCycle) //10.03.2008. EDMS P2
                     THEN
                      IF CONFIRM(TextAssignNewCycle,FALSE,FIELDCAPTION("Vehicle Accounting Cycle No.")) THEN
                       BEGIN
                        VheAccCycle.RESET;
                        IF VheAccCycle.GET(vehi."Default Vehicle Acc. Cycle No.") THEN
                         BEGIN
                          CLEAR(VehAccCycleMgt);
                          VehAccCycleMgt.CreateNewCycle_User(VheAccCycle);
                          VehAccCycleMgt.SetAsDefault(VheAccCycle);
                          vehi.CALCFIELDS("Default Vehicle Acc. Cycle No.");
                         END;
                       END;
                    VALIDATE("Vehicle Accounting Cycle No.",vehi."Default Vehicle Acc. Cycle No.");
                   END
                  ELSE
                   BEGIN
                    VIN := '';
                    codDefCycle := VehAccCycle.GetDefaultCycle("Vehicle Serial No.","Vehicle Accounting Cycle No.");
                    IF codDefCycle = '' THEN
                     fNewAccCycleNo
                    ELSE
                     VALIDATE("Vehicle Accounting Cycle No.",codDefCycle);
                   END;
                 END;

                // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00 >>
                CreateDim(
                  DimMgt.TypeToTableID3(Type),"No.",
                  DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::"Work Center","Work Center No.",
                  DATABASE::Make,"Make Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::Location,"Location Code",     // 10.03.2015 EDMS P21
                  DATABASE::"Deal Type","Deal Type Code"  // 12.05.2015 EB.P30
                  ); //DMS
                // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00 <<
            end;
        }
        field(25006376;"Vehicle Assembly ID";Code[20])
        {
            Caption = 'Vehicle Assembly ID';

            trigger OnValidate()
            var
                recVehAssembly: Record "25006380";
                tcAMT001: Label 'Vehicle assembly list %1 is not empty.';
            begin
                TestStatusOpen;
                TESTFIELD("Vehicle Serial No.");
                IF (xRec."Vehicle Assembly ID" <> '') AND (xRec."Vehicle Assembly ID" <> Rec."Vehicle Assembly ID") THEN
                 BEGIN
                  recVehAssembly.RESET;
                  recVehAssembly.SETRANGE("Serial No.",xRec."Vehicle Serial No.");
                  recVehAssembly.SETRANGE("Assembly ID",xRec."Vehicle Assembly ID");
                  IF NOT recVehAssembly.ISEMPTY THEN
                   ERROR(tcAMT001,xRec."Vehicle Assembly ID");
                 END;
            end;
        }
        field(25006378;"Vehicle Exists";Boolean)
        {
            CalcFormula = Exist(Vehicle WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Vehicle Exists';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle".No. WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.));
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                recVehAccCycle: Record "25006024";
            begin
                recVehAccCycle.RESET;
                IF LookUpMgt.LookUpVehicleAccCycle(recVehAccCycle,"Vehicle Serial No.","Vehicle Accounting Cycle No.") THEN
                 VALIDATE("Vehicle Accounting Cycle No.",recVehAccCycle."No.");
            end;

            trigger OnValidate()
            begin
                TestStatusOpen;
                VehAccCycle.CheckCycleRelation("Vehicle Serial No.","Vehicle Accounting Cycle No.");
            end;
        }
        field(25006380;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;

            trigger OnValidate()
            var
                recDimValue: Record "349";
            begin
                TestStatusOpen;
                //EDMS
                IF UserMgt.DefaultResponsibility THEN
                  CreateDim(
                    DimMgt.TypeToTableID3(Type),"No.",
                    //DATABASE::Job,"Job No.",
                    DATABASE::"Vehicle Status","Vehicle Status Code",
                    DATABASE::"Responsibility Center","Responsibility Center",
                    DATABASE::"Work Center","Work Center No.",
                    DATABASE::Make,"Make Code",
                    DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                    DATABASE::Location,"Location Code",     // 10.03.2015 EDMS P21
                    DATABASE::"Deal Type","Deal Type Code"  // 12.05.2015 EB.P30
                    )
                ELSE
                  CreateDim(
                  DimMgt.TypeToTableID3(Type),"No.",
                  //DATABASE::Job,"Job No.",
                  DATABASE::"Vehicle Status","Vehicle Status Code",
                  DATABASE::"Accountability Center","Accountability Center",
                  DATABASE::"Work Center","Work Center No.",
                  DATABASE::Make,"Make Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::Location,"Location Code",     // 10.03.2015 EDMS P21
                  DATABASE::"Deal Type","Deal Type Code"  // 12.05.2015 EB.P30
                  );
            end;
        }
        field(25006382;Reserved;Boolean)
        {
            CalcFormula = Exist("Vehicle Reservation Entry" WHERE (Source Type=CONST(39),
                                                                   Source Subtype=FIELD(Document Type),
                                                                   Source ID=FIELD(Document No.),
                                                                   Source Ref. No.=FIELD(Line No.)));
            Caption = 'Reserved';
            Description = 'Only for Vehicles';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006386;"Vehicle Body Color Code";Code[10])
        {
            Caption = 'Vehicle Body Color Code';
            TableRelation = "Body Color".Code;
        }
        field(25006388;"Vehicle Interior Code";Code[10])
        {
            Caption = 'Vehicle Interior Code';
            TableRelation = "Vehicle Interior";
        }
        field(25006389;"Requested Item No.";Code[20])
        {
            Caption = 'Requested Item No.';
        }
        field(25006700;"Ordering Price Type Code";Code[20])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";

            trigger OnValidate()
            begin
                TestStatusOpen;
                UpdateDirectUnitCost(FIELDNO("Ordering Price Type Code"));
                UpdateLeadTimeFields;
                UpdateDates;
            end;
        }
        field(25006710;"Qty. on Back Order";Decimal)
        {
            Caption = 'Qty. on Back Order';
        }
        field(25006720;"Back Order Date";Date)
        {
            Caption = 'Back Order Date';
        }
        field(25006730;"Item No. Changed";Boolean)
        {
            Caption = 'Item No. Changed';
        }
        field(25006740;"Shipment Package No.";Code[20])
        {
            Caption = 'Shipment Package No.';
        }
        field(25006998;"Has Replacement";Boolean)
        {
            Caption = 'Has Replacement';
        }
        field(33019810;"Summary No.";Code[20])
        {
            Description = 'Store Requisition Summary No.';
        }
        field(33019831;"Dispatch Updated";Boolean)
        {
        }
        field(33019832;"Vendor Invoice No.";Code[20])
        {
            Caption = 'Vendor Invoice No.';
        }
        field(33019833;"Issue No.";Code[20])
        {
            Description = '//Used for Fuel Expense';
            TableRelation = "Vehicle Fuel Exp. Line"."Document No";
        }
        field(33019834;"Issue Line No.";Integer)
        {
            Description = '//Used for Fuel Expense';
            TableRelation = "Vehicle Fuel Exp. Line"."Line No.";
        }
        field(33019869;"Import Purch. Order";Boolean)
        {
        }
        field(33019961;"Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020011;"Sys. LC No.";Code[20])
        {
            CalcFormula = Lookup("Purchase Header"."Sys. LC No." WHERE (Document Type=FIELD(Document Type),
                                                                        No.=FIELD(Document No.)));
            Caption = 'LC No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020012;"Bank LC No.";Code[20])
        {
            CalcFormula = Lookup("Purchase Header"."Bank LC No." WHERE (Document Type=FIELD(Document Type),
                                                                        No.=FIELD(Document No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020013;"LC Amend No.";Code[20])
        {
            CalcFormula = Lookup("Purchase Header"."LC Amend No." WHERE (Document Type=FIELD(Document Type),
                                                                         No.=FIELD(Document No.)));
            FieldClass = FlowField;
        }
        field(33020014;"Account Name";Text[50])
        {
            CalcFormula = Lookup("G/L Account".Name WHERE (No.=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020015;"PI/ARE Code";Code[20])
        {
            TableRelation = "LC Value Allotment"."PI Code" WHERE (LC Code=FIELD(Sys. LC No.));

            trigger OnLookup()
            var
                RecLCValueAllotment: Record "33020024";
                LCValueEntries: Record "33020023";
                ItemCharge: Record "5800";
                ItemChargeValue: Decimal;
                LCDetails: Record "33020012";
            begin
                CALCFIELDS("Sys. LC No.");
                RecLCValueAllotment.RESET;
                RecLCValueAllotment.SETRANGE(RecLCValueAllotment."LC Code","Sys. LC No.");

                LCDetails.RESET;
                LCDetails.SETRANGE("No.","Sys. LC No.");
                TESTFIELD(Type,Type::"Charge (Item)");

                ItemCharge.RESET;
                ItemCharge.SETRANGE("No.","No.");
                IF ItemCharge.FINDFIRST THEN BEGIN
                  IF ItemCharge."Link To Register Type" <> ItemCharge."Link To Register Type"::" " THEN BEGIN
                    IF ItemCharge."Link To Register Type" = ItemCharge."Link To Register Type"::Insurance THEN BEGIN
                      LCDetails.SETFILTER("Allotment Type",'%1',LCDetails."Allotment Type"::Insurance);
                      //RecLCValueAllotment.SETRANGE(Type,RecLCValueAllotment.Type::" ");
                    END
                    ELSE IF ItemCharge."Link To Register Type" = ItemCharge."Link To Register Type"::"Letter of Credit" THEN BEGIN
                      LCDetails.SETFILTER("Allotment Type",'%1',LCDetails."Allotment Type"::"Letter of Credit");
                      //RecLCValueAllotment.SETRANGE(Type,RecLCValueAllotment.Type::Insurance);
                    END;

                    IF LCDetails.FINDFIRST THEN BEGIN
                      IF LookUpAllotment(RecLCValueAllotment,"Sys. LC No.") THEN BEGIN
                          VALIDATE("PI/ARE Code",RecLCValueAllotment."PI Code");
                          LCDetails.CALCFIELDS("Total LC Allotment","Total LC Charge");
                          ItemChargeValue := (RecLCValueAllotment."Value (LCY)"/LCDetails."LC Value (LCY)")*LCDetails."Total LC Charge";
                          VALIDATE("Direct Unit Cost",ItemChargeValue);
                      END;
                    END;
                  END;
                END;
            end;

            trigger OnValidate()
            var
                ItemChargeValue: Decimal;
                LCDetails: Record "33020012";
                RecLCValueAllotment: Record "33020024";
                Text001: Label 'You cannot enter invalid PI/ARE Code.';
            begin
                IF "PI/ARE Code" = '' THEN
                  VALIDATE("Direct Unit Cost",0)
                ELSE BEGIN
                /*
                  CALCFIELDS("Sys. LC No.");
                  RecLCValueAllotment.RESET;
                  RecLCValueAllotment.SETRANGE(RecLCValueAllotment."LC Code","Sys. LC No.");
                
                  LCDetails.RESET;
                  LCDetails.SETRANGE("No.","Sys. LC No.");
                  TESTFIELD(Type,Type::"Charge (Item)");
                
                  ItemCharge.RESET;
                  ItemCharge.SETRANGE("No.","No.");
                  IF ItemCharge.FINDFIRST THEN BEGIN
                    if ItemCharge."Link To Register Type" <> ItemCharge."Link To Register Type"::" " then begin
                      IF ItemCharge."Link To Register Type" = ItemCharge."Link To Register Type"::Insurance THEN begin
                        LCDetails.setrange("Allotment Type",LCDetails."Allotment Type"::Insurance);
                        RecLCValueAllotment.setrange(Type,RecLCValueAllotment.Type::Insurance);
                      end
                      ELSE IF ItemCharge."Link To Register Type" = ItemCharge."Link To Register Type"::Insurance THEN begin
                        LCDetails.setrange("Allotment Type",LCDetails."Allotment Type"::"Letter of Credit");
                        RecLCValueAllotment.setrange(Type,RecLCValueAllotment.Type::Letter);
                      end;
                      IF (LCDetails.FINDFIRST) AND (RecLCValueAllotment.findfirst) THEN BEGIN
                            LCDetails.CALCFIELDS("Total LC Allotment","Total LC Charge");
                            ItemChargeValue := (RecLCValueAllotment."Value (LCY)"/LCDetails."LC Value (LCY)")*LCDetails."Total LC Charge";
                            VALIDATE("Direct Unit Cost",ItemChargeValue);
                      end
                      else
                        error(Text001);
                    end;
                  END;
                  */
                END;

            end;
        }
        field(33020235;"Service Order No.";Code[20])
        {
            Description = '//Used for Ext. Service';
        }
        field(33020236;"Service Order Line No.";Integer)
        {
            Description = '//Used for Ext. Service';
        }
        field(33020237;"Customer No.";Code[20])
        {
            Description = 'For Vehicle Reservation functionality @Agni';
            TableRelation = Customer;
        }
        field(33020238;"Engine No.";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Engine No." WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Description = 'Retrieved from the CreateVehicle Function as per Agni''s requirement';
            FieldClass = FlowField;
        }
        field(33020600;"See Reserve Entries";Boolean)
        {
            CalcFormula = Exist("Vehicle Accounting Cycle" WHERE (No.=FIELD(Vehicle Accounting Cycle No.),
                                                                  Vehicle Serial No.=FIELD(Vehicle Serial No.)));
            Description = 'To look up (vehicle reserve entries) vehicle accounting cycle page';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020601;"Returned Document No.";Code[20])
        {
        }
        field(99000760;"Tax Purchase Type";Option)
        {
            OptionCaption = ' ,ServicePurchaseCapital,ServicePurchaseOthers,GoodPurchaseCapital,GoodPurchaseOthers';
            OptionMembers = " ",ServicePurchaseCapital,ServicePurchaseOthers,GoodPurchaseCapital,GoodPurchaseOthers;
        }
        field(99000761;"Port Code";Code[20])
        {
            TableRelation = "Port Master";
        }
        field(99000762;"Localized VAT Identifier";Option)
        {
            Description = 'VAT1.00';
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";
        }
        field(99000763;CBM;Decimal)
        {
            DecimalPlaces = 0:6;

            trigger OnValidate()
            var
                Itm: Record "27";
            begin
                IF Type = Type::Item THEN BEGIN
                  IF Quantity <> 0 THEN BEGIN
                    Itm.GET("No.");
                    CBM := Quantity * Itm.CBM;
                    END;
                  END;
            end;
        }
    }
    keys
    {

        //Unsupported feature: Property Modification (SumIndexFields) on ""Document Type,Document No.,Line No."(Key)".

        key(Key1;"Document Profile")
        {
        }
        key(Key2;Type,"Line Type","Vehicle Serial No.","Vehicle Accounting Cycle No.")
        {
        }
        key(Key3;"Order Date")
        {
        }
        key(Key4;"Vehicle Serial No.","Vehicle Assembly ID")
        {
        }
        key(Key5;"Document Type","Document No.","Shipment Package No.")
        {
        }
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        TestStatusOpen;
        IF NOT StatusCheckSuspended AND (PurchHeader.Status = PurchHeader.Status::Released) AND
           (Type IN [Type::"G/L Account",Type::"Charge (Item)"])
        THEN
          VALIDATE(Quantity,0);

        IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
          ReservePurchLine.DeleteLine(Rec);
          IF "Receipt No." = '' THEN
            TESTFIELD("Qty. Rcd. Not Invoiced",0);
          IF "Return Shipment No." = '' THEN
        #12..88
          DeferralUtilities.DeferralCodeOnDelete(
            DeferralUtilities.GetPurchDeferralDocType,'','',
            "Document Type","Document No.","Line No.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..8
          //26.02.2008 EDMS P1 >>
           IF "Line Type" = "Line Type"::Vehicle THEN
             VehReservePurchLine.DeleteLine(Rec);
          //26.02.2008 EDMS P1 <<
        #9..91
        */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        TestStatusOpen;
        IF Quantity <> 0 THEN
          ReservePurchLine.VerifyQuantity(Rec,xRec);

        LOCKTABLE;
        PurchHeader."No." := '';
        IF ("Deferral Code" <> '') AND (GetDeferralAmount <> 0) THEN
          UpdateDeferralAmounts;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..8


        //**SM 06/10/2013 added code to pass the document profile from header to lines
        PurchHeader.RESET;
        PurchHeader.SETRANGE("No.","Document No.");
        IF PurchHeader.FINDFIRST THEN BEGIN
           "Document Profile" := PurchHeader."Document Profile";
        END;

        "Vehicle Status Code" := 'NEW';
        */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnModify".

    //trigger (Variable: Item1)()
    //Parameters and return type have not been exported.
    //begin
        /*
        */
    //end;


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF ("Document Type" = "Document Type"::"Blanket Order") AND
           ((Type <> xRec.Type) OR ("No." <> xRec."No."))
        THEN BEGIN
        #4..13

        IF ((Quantity <> 0) OR (xRec.Quantity <> 0)) AND ItemExists(xRec."No.") THEN
          ReservePurchLine.VerifyChange(Rec,xRec);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..16

        //02.04.2014 Elva Baltic P15 #F124 MMG7.00 >>
        IF (Type = Type::Item) AND (xRec."No."<>"No.") AND (xRec."No." <> '') AND ("No." <> '')
          AND ("Document Profile" <> "Document Profile"::"Vehicles Trade") THEN BEGIN
          IF Item1.GET(xRec."No.") AND Item2.GET(Rec."No.") THEN BEGIN
            IF Item1."Created From Nonstock Item" AND Item2."Created From Nonstock Item" THEN BEGIN
              No1 := Item1.GetSourceNonstockEntryNo();
              No2 := Item2.GetSourceNonstockEntryNo();
              IF (No1 <> '') AND (No2 <> '') THEN BEGIN
                IF NOT ItemSubstitution.GET(ItemSubstitution.Type::"Nonstock Item", No1, "Variant Code",
                                            ItemSubstitution.Type::"Nonstock Item", No2, "Variant Code") THEN BEGIN
                  IF CONFIRM(Text055,TRUE,xRec."No.","No.") THEN BEGIN
                   IF ItemSubstitution.CreateReplacement(ItemSubstitution.Type::"Nonstock Item", No1, xRec."Variant Code",
                                                         ItemSubstitution.Type::"Nonstock Item", No2, Rec."Variant Code", TRUE) THEN
                      MESSAGE(Text056, No1, No2);
                  END;
                END;
              END;
            END;
          END;
        END;
        //02.04.2014 Elva Baltic P15 #F124 MMG7.00 <<
        */
    //end;


    //Unsupported feature: Code Modification on "OnRename".

    //trigger OnRename()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        ERROR(Text000,TABLECAPTION);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        //ERROR(Text000,TABLECAPTION);
        */
    //end;


    //Unsupported feature: Code Modification on "GetPurchHeader(PROCEDURE 1)".

    //procedure GetPurchHeader();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        TESTFIELD("Document No.");
        IF ("Document Type" <> PurchHeader."Document Type") OR ("Document No." <> PurchHeader."No.") THEN BEGIN
          PurchHeader.GET("Document Type","Document No.");
          IF PurchHeader."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
          ELSE BEGIN
            PurchHeader.TESTFIELD("Currency Factor");
            Currency.GET(PurchHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
          END;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..3
          //IF PurchHeader."Document Profile" = PurchHeader."Document Profile"::"Spare Parts Trade" THEN;
           // PurchHeader.TESTFIELD("Order Type");
        #4..11
        */
    //end;


    //Unsupported feature: Code Modification on "UpdateDirectUnitCost(PROCEDURE 2)".

    //procedure UpdateDirectUnitCost();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF (CurrFieldNo <> 0) AND ("Prod. Order No." <> '') THEN
          UpdateAmounts;

        #4..11
          PurchPriceCalcMgt.FindPurchLineLineDisc(PurchHeader,Rec);
          VALIDATE("Direct Unit Cost");

          IF CalledByFieldNo IN [FIELDNO("No."),FIELDNO("Variant Code"),FIELDNO("Location Code")] THEN
            UpdateItemReference;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..14
          //***SM 01 Sept 2014 to make direct unit cost zero for vehicles trade
          IF (Type = Type::Item) AND ("Line Type" = "Line Type"::Vehicle) THEN BEGIN
              VALIDATE("Direct Unit Cost",0);
          END;
          //***SM 01 Sept 2014 to make direct unit cost zero for vehicles trade

        #15..17
        */
    //end;


    //Unsupported feature: Code Modification on "UpdateUnitCost(PROCEDURE 5)".

    //procedure UpdateUnitCost();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        GetPurchHeader;
        GetGLSetup;
        IF Quantity = 0 THEN
          DiscountAmountPerQty := 0
        ELSE
          DiscountAmountPerQty :=
            ROUND(("Line Discount Amount" + "Inv. Discount Amount") / Quantity,
              GLSetup."Unit-Amount Rounding Precision");

        IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN
          "Unit Cost" := 0
        ELSE
          IF PurchHeader."Prices Including VAT" THEN
            "Unit Cost" :=
              ("Direct Unit Cost" - DiscountAmountPerQty) * (1 + "Indirect Cost %" / 100) / (1 + "VAT %" / 100) +
        #16..49
          TempJobJnlLine.VALIDATE("Unit Cost (LCY)","Unit Cost (LCY)");
          UpdateJobPrices;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..8
        {
        //Agni UPG 2009<<
        #10..12
        //Agni UPG 2009<<
        }
        #13..52
        */
    //end;

    //Unsupported feature: Variable Insertion (Variable: GenLedgSetup) (VariableCollection) on "UpdatePrepmtSetupFields(PROCEDURE 102)".



    //Unsupported feature: Code Modification on "UpdatePrepmtSetupFields(PROCEDURE 102)".

    //procedure UpdatePrepmtSetupFields();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF ("Prepayment %" <> 0) AND (Type <> Type::" ") THEN BEGIN
          TESTFIELD("Document Type","Document Type"::Order);
          TESTFIELD("No.");
          GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
          IF GenPostingSetup."Purch. Prepayments Account" <> '' THEN BEGIN
            GLAcc.GET(GenPostingSetup."Purch. Prepayments Account");
            VATPostingSetup.GET("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");
            VATPostingSetup.TESTFIELD("VAT Calculation Type","VAT Calculation Type");
          END ELSE
            CLEAR(VATPostingSetup);
          "Prepayment VAT %" := VATPostingSetup."VAT %";
        #12..16
            "Prepayment VAT %" := 0;
          "Prepayment Tax Group Code" := GLAcc."Tax Group Code";
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..3
          GenLedgSetup.GET; //20.03.2013 EDMS
          GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
          GenPostingSetup.TESTFIELD("Purch. Prepayments Account"); //20.03.2013 EDMS

          IF GenPostingSetup."Purch. Prepayments Account" <> '' THEN BEGIN
          //20.03.2013 EDMS >>
            IF GenLedgSetup."Calc.Prepmt.VAT by Line PostGr" THEN
              VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group")
            ELSE BEGIN
          //20.03.2013 EDMS <<
        #6..8
            END //20.03.2013 EDMS
        #9..19
        */
    //end;

    //Unsupported feature: Parameter Insertion (Parameter: Type5) (ParameterCollection) on "CreateDim(PROCEDURE 26)".


    //Unsupported feature: Parameter Insertion (Parameter: No5) (ParameterCollection) on "CreateDim(PROCEDURE 26)".


    //Unsupported feature: Parameter Insertion (Parameter: Type6) (ParameterCollection) on "CreateDim(PROCEDURE 26)".


    //Unsupported feature: Parameter Insertion (Parameter: No6) (ParameterCollection) on "CreateDim(PROCEDURE 26)".


    //Unsupported feature: Parameter Insertion (Parameter: Type7) (ParameterCollection) on "CreateDim(PROCEDURE 26)".


    //Unsupported feature: Parameter Insertion (Parameter: No7) (ParameterCollection) on "CreateDim(PROCEDURE 26)".


    //Unsupported feature: Parameter Insertion (Parameter: Type8) (ParameterCollection) on "CreateDim(PROCEDURE 26)".


    //Unsupported feature: Parameter Insertion (Parameter: No8) (ParameterCollection) on "CreateDim(PROCEDURE 26)".



    //Unsupported feature: Code Modification on "CreateDim(PROCEDURE 26)".

    //procedure CreateDim();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        #4..6
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        GetPurchHeader;
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID,No,SourceCodeSetup.Purchases,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",
            PurchHeader."Dimension Set ID",DATABASE::Vendor);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..9

        //EDMS1.0.00 >>
        TableID[5] := Type5;
        No[5] := No5;
        TableID[6] := Type6;  //25.10.2013 EDMS P8
        No[6] := No6;
        //EDMS1.0.00 <<
        // 10.03.2015 EDMS P21 >>
        TableID[7] := Type7;
        No[7] := No7;
        // 10.03.2015 EDMS P21 <<
        // 12.06.2015 EDMS P30 >>
        TableID[8] := Type8;
        No[8] := No8;
        // 12.06.2015 EDMS P30 <<

        #10..17
        */
    //end;

    //Unsupported feature: Variable Insertion (Variable: OrderingPriceType) (VariableCollection) on "UpdateLeadTimeFields(PROCEDURE 11)".



    //Unsupported feature: Code Modification on "UpdateLeadTimeFields(PROCEDURE 11)".

    //procedure UpdateLeadTimeFields();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF Type = Type::Item THEN BEGIN
          GetPurchHeader;

          EVALUATE("Lead Time Calculation",
            LeadTimeMgt.PurchaseLeadTime(
              "No.","Location Code","Variant Code",
              "Buy-from Vendor No."));
          IF FORMAT("Lead Time Calculation") = '' THEN
            "Lead Time Calculation" := PurchHeader."Lead Time Calculation";
          EVALUATE("Safety Lead Time",LeadTimeMgt.SafetyLeadTime("No.","Location Code","Variant Code"));
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..3
          //20.03.2013 EDMS >>
          IF ("Ordering Price Type Code" <> '') AND OrderingPriceType.GET("Ordering Price Type Code") THEN
             "Lead Time Calculation" := OrderingPriceType."Inbound Time"
          ELSE
            EVALUATE("Lead Time Calculation",
              LeadTimeMgt.PurchaseLeadTime(
              "No.","Location Code","Variant Code",
              "Buy-from Vendor No."));
          //20.03.2013 EDMS <<

        #4..11
        */
    //end;

    procedure fNewSerialNo()
    var
        recInvSetup: Record "313";
        cuNoSeriesMgt: Codeunit "396";
        codSerialNo: Code[20];
        cuVehSerialNoMgt: Codeunit "25006006";
    begin
        //DMS
        IF "Line Type" <> "Line Type"::Vehicle THEN
         EXIT;
        codSerialNo := cuVehSerialNoMgt.fGetNewNo;
        VALIDATE("Vehicle Serial No.",codSerialNo);
    end;

    procedure fNewAccCycleNo()
    var
        recInvSetup: Record "313";
        cuNoSeriesMgt: Codeunit "396";
        codCycleNo: Code[20];
        recVehAccCycle: Record "25006024";
    begin
        //DMS
        IF "Line Type" <> "Line Type"::Vehicle THEN
         EXIT;

        TESTFIELD("Vehicle Serial No.");

        codCycleNo := VehAccCycle.GetNewCycleNo;

        recVehAccCycle.INIT;
         recVehAccCycle."No." := codCycleNo;
         recVehAccCycle.VALIDATE("Vehicle Serial No.","Vehicle Serial No.");
         recVehAccCycle.VALIDATE(Default,TRUE);
        recVehAccCycle.INSERT(TRUE);

        VALIDATE("Vehicle Accounting Cycle No.",codCycleNo);
    end;

    procedure NewVehAssemblyNo()
    var
        InvSetup: Record "313";
        NoSeriesMgt: Codeunit "396";
        AssemblyNo: Code[20];
    begin
        //DMS
         IF "Line Type" = "Line Type"::Vehicle THEN
          BEGIN
           InvSetup.GET;
           InvSetup.TESTFIELD("Vehicle Assembly Nos."); //16.11.2007 P3
           NoSeriesMgt.InitSeries(InvSetup."Vehicle Assembly Nos.",InvSetup."Vehicle Assembly Nos.",
              WORKDATE,AssemblyNo,InvSetup."Vehicle Assembly Nos.");
           VALIDATE("Vehicle Assembly ID",AssemblyNo);
          END;
    end;

    procedure NoLookup()
    var
        recItem: Record "27";
        recItemCharge: Record "5800";
        recGLAccount: Record "15";
        recFixedAsset: Record "5600";
        recStandardText: Record "7";
    begin
         CASE "Document Profile" OF
          "Document Profile"::"Vehicles Trade":
           BEGIN
            CASE "Line Type" OF
             "Line Type"::" ":
              BEGIN
               recStandardText.RESET;
               IF LookUpMgt.LookUpStandardText(recStandardText,"No.") THEN
                 VALIDATE("No.",recStandardText.Code);
              END;
             "Line Type"::Vehicle:
              BEGIN
               recItem.RESET;
               IF LookUpMgt.LookUpModelVersion(recItem,"No.","Make Code","Model Code") THEN
                VALIDATE("Model Version No.",recItem."No.");
              END;
             "Line Type"::Item:
              BEGIN
               recItem.RESET;
               IF LookUpMgt.LookUpItemREZ(recItem,"No.") THEN
                VALIDATE("No.",recItem."No.");
              END;
             "Line Type"::"Charge (Item)":
              BEGIN
               recItemCharge.RESET;
               IF LookUpMgt.LookUpChargeItem_Purch(recItemCharge,"No.") THEN
                VALIDATE("No.",recItemCharge."No.");
              END;

             //21.12.2007 EDMS P5 >>
              Type::"External Service": BEGIN
               ExternalService.RESET;
               IF LookUpMgt.LookUpExtService(ExternalService,"No.") THEN
                VALIDATE("No.",ExternalService."No.");
              END;
             //21.12.2007 EDMS P5 <<

             "Line Type"::"G/L Account":
              BEGIN
               recGLAccount.RESET;
               IF LookUpMgt.LookUpGLAccount(recGLAccount,"No.") THEN
                VALIDATE("No.",recGLAccount."No.");
              END;
            END;
           END;
          "Document Profile"::"Spare Parts Trade":
           BEGIN
            CASE Type OF
             Type::" ":
              BEGIN
               recStandardText.RESET;
               IF LookUpMgt.LookUpStandardText(recStandardText,"No.") THEN
                VALIDATE("No.",recStandardText.Code);
              END;
             Type::"G/L Account":
              BEGIN
               recGLAccount.RESET;
               IF LookUpMgt.LookUpGLAccount(recGLAccount,"No.") THEN
                VALIDATE("No.",recGLAccount."No.");
              END;
             Type::Item:
              BEGIN
               recItem.RESET;
               IF LookUpMgt.LookUpItemREZ(recItem,"No.") THEN
                VALIDATE("No.",recItem."No.");
              END;
             Type::"Fixed Asset":
              BEGIN
               recFixedAsset.RESET;
               IF LookUpMgt.LookUpFixedAsset(recFixedAsset,"No.") THEN
                VALIDATE("No.",recFixedAsset."No.");
              END;
             Type::"Charge (Item)":
              BEGIN
               recItemCharge.RESET;
               IF LookUpMgt.LookUpChargeItem_Purch(recItemCharge,"No.") THEN
                VALIDATE("No.",recItemCharge."No.");
              END;

             //21.12.2007 EDMS P5 >>
              Type::"External Service": BEGIN
               ExternalService.RESET;
               IF LookUpMgt.LookUpExtService(ExternalService,"No.") THEN
                VALIDATE("No.",ExternalService."No.");
              END;
             //21.12.2007 EDMS P5 <<

            END;
           END;
          ELSE
           BEGIN
            CASE Type OF
             Type::" ":
              BEGIN
               recStandardText.RESET;
               IF LookUpMgt.LookUpStandardText(recStandardText,"No.") THEN
                VALIDATE("No.",recStandardText.Code);
              END;
             Type::"G/L Account":
              BEGIN
               recGLAccount.RESET;
               IF LookUpMgt.LookUpGLAccount(recGLAccount,"No.") THEN
                VALIDATE("No.",recGLAccount."No.");
              END;
             Type::Item:
              BEGIN
               recItem.RESET;
               IF LookUpMgt.LookUpItem(recItem,"No.") THEN
                VALIDATE("No.",recItem."No.");
              END;
             Type::"Fixed Asset":
              BEGIN
               recFixedAsset.RESET;
               IF LookUpMgt.LookUpFixedAsset(recFixedAsset,"No.") THEN
                VALIDATE("No.",recFixedAsset."No.");
              END;
             Type::"Charge (Item)":
              BEGIN
               recItemCharge.RESET;
               IF LookUpMgt.LookUpChargeItem_Purch(recItemCharge,"No.") THEN
                VALIDATE("No.",recItemCharge."No.");
              END;

             //21.12.2007 EDMS P5 >>
              Type::"External Service": BEGIN
               ExternalService.RESET;
               IF LookUpMgt.LookUpExtService(ExternalService,"No.") THEN
                VALIDATE("No.",ExternalService."No.");
              END;
             //21.12.2007 EDMS P5 <<

            END;
           END;
         END
    end;

    procedure CreateVehicle()
    var
        VINInput: Page "25006493";
                      Vehicle: Record "25006005";
                      NewVIN: Code[20];
                      Vehicle2: Record "25006005";
                      SalesLine: Record "37";
                      tcAMT001: Label 'VIN %1 already exists.';
        NewEngineNo: Code[20];
        NewARENo: Code[20];
        NewProductionYear: Code[4];
        NewCommercialInvoiceNo: Code[20];
        PurchLine: Record "39";
    begin
        TESTFIELD("Make Code");
        TESTFIELD("Model Code");
        TESTFIELD("Model Version No.");
        TESTFIELD("Vehicle Serial No.");
        CALCFIELDS("Vehicle Exists");
        TESTFIELD("Vehicle Exists",FALSE);
        //TESTFIELD("Variant Code");    // removed for Agni 28.04.2013
        
        CLEAR(VINInput);
        VINInput.fSetData("Make Code","Model Code","Model Version No.",
          "Vehicle Serial No.","Vehicle Body Color Code","Vehicle Interior Code");
        
        IF VINInput.RUNMODAL <> ACTION::OK THEN
         EXIT;
        
        
        NewVIN := VINInput.fGetNewVin;
        
        NewProductionYear := VINInput.fGetNewProductionYear;
        NewCommercialInvoiceNo := VINInput.fGetNewCommercialInvoiceNo;
        
        "Production Years" := NewProductionYear;
        "Commercial Invoice No." := NewCommercialInvoiceNo;
        
        //***SM to get the Engine No. & ARE No. from Create Vehicle-interactive page.
        NewEngineNo :=  VINInput.fGetNewEngineNo;
        //***SM to get the Engine No. & ARE No. from Create Vehicle-interactive page.
        IF (NewVIN = '') OR (NewEngineNo = '') THEN
         EXIT;
        
        
        Vehicle.RESET;
        Vehicle.SETRANGE(VIN,NewVIN); //Suman Maharjan 24/04/2013 to check duplicate VIN
        IF NOT Vehicle.FINDFIRST THEN BEGIN
         Vehicle.INIT;
         Vehicle.VALIDATE("Serial No.","Vehicle Serial No.");
         Vehicle.VALIDATE(VIN,NewVIN);
         //**SM to insert Engine No. and ARE No. in Vehicle Card from create Veh. Interactive Page
         Vehicle.VALIDATE("Engine No.",NewEngineNo);
         //**SM to insert Engine No. and ARE No. in Vehicle Card from create Veh. Interactive Page
         Vehicle.VALIDATE("Make Code","Make Code");
         Vehicle.VALIDATE("Model Code","Model Code");
         Vehicle.VALIDATE("Model Version No.","Model Version No.");
         Vehicle.VALIDATE("Status Code","Vehicle Status Code");
         Vehicle.VALIDATE("Body Color Code","Vehicle Body Color Code");
         Vehicle.VALIDATE("Interior Code","Vehicle Interior Code");
         Vehicle.VALIDATE("Production Years",NewProductionYear);
         Vehicle.VALIDATE("Commercial Invoice No.",NewCommercialInvoiceNo);
         Vehicle.INSERT(TRUE);
         /*
         PurchLine.RESET;
         PurchLine.SETRANGE(VIN,NewVIN);
         IF PurchLine.FINDFIRST THEN BEGIN
           PurchLine."Production Year" := NewProductionYear;
           PurchLine."Commercial Invoice No." := NewCommercialInvoiceNo;
           PurchLine.MODIFY;
           END;
           */
        END ELSE
          MESSAGE('VIN already exists');

    end;

    procedure VehicleAssembly()
    var
        iLineNo: Integer;
        recVehicleAssemby: Record "25006380";
        frmVehAssemblyWorksheet: Page "25006490";
                                     recInvSetup: Record "313";
                                     cuNoSeriesMgt: Codeunit "396";
                                     VehOptMgt: Codeunit "25006304";
    begin
        IF "Line Type" <> "Line Type"::Vehicle THEN
         EXIT;

        TESTFIELD("No.");
        TESTFIELD("Vehicle Serial No.");

        TESTFIELD("Make Code");
        TESTFIELD("Model Code");
        TESTFIELD("Model Version No.");

        IF "Vehicle Assembly ID" = '' THEN BEGIN
         NewVehAssemblyNo;
         MODIFY;
        END;

        VehPriceMgt.ChkAssemblyHdrPurchLine(Rec);
        VehOptMgt.FillVehAssembly("Vehicle Serial No.","Vehicle Assembly ID","Make Code","Model Code","Model Version No.");


        recVehicleAssemby.SETRANGE("Assembly ID","Vehicle Assembly ID");
        recVehicleAssemby.SETRANGE("Make Code","Make Code");
        recVehicleAssemby.SETRANGE("Model Code","Model Code");
        recVehicleAssemby.SETRANGE("Model Version No.","Model Version No.");
        recVehicleAssemby.SETRANGE("Serial No.","Vehicle Serial No.");

        CLEAR(frmVehAssemblyWorksheet);
        frmVehAssemblyWorksheet.SETTABLEVIEW(recVehicleAssemby);
        frmVehAssemblyWorksheet.RUN;
    end;

    procedure NoAssistEdit()
    var
        NonstockItem: Record "5718";
        NonstockItemMgt: Codeunit "5703";
    begin
        IF Type = Type::Item THEN
         BEGIN

          //20.08.2008. EDMS P2 >>
          CurrFieldNo := FIELDNO("No.");
          //20.08.2008. EDMS P2 <<

          NonstockItem.RESET;
          IF LookUpMgt.LookUpNonstockItemByItem(NonstockItem,"No.") THEN
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

    procedure ApplyVehAssemblyToSales()
    var
        SalesLine: Record "37";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("Line Type","Line Type"::Vehicle);

        SalesLine.RESET;
        SalesLine.SETCURRENTKEY("Document Profile");
        SalesLine.SETRANGE("Document Profile", SalesLine."Document Profile"::"Vehicles Trade");

        IF "Make Code" <> '' THEN
         SalesLine.SETRANGE("Make Code","Make Code");
        IF "Model Code" <> '' THEN
         SalesLine.SETRANGE("Model Code","Model Code");
        IF "Model Version No." <> '' THEN
         SalesLine.SETRANGE("Model Version No.","Model Version No.");

        IF "Vehicle Assembly ID" <> '' THEN
         SalesLine.SETFILTER("Vehicle Assembly ID",'<>''''');


        IF PAGE.RUNMODAL(PAGE::"Apply Purchase to Sales Line", SalesLine) = ACTION::LookupOK THEN
         BEGIN
          IF "Make Code" = '' THEN
           VALIDATE("Make Code", SalesLine."Make Code");
          IF "Model Code" = '' THEN
           VALIDATE("Model Code", SalesLine."Model Code");
          IF "Model Version No." = '' THEN
           VALIDATE("Model Version No.", SalesLine."Model Version No.");

          VALIDATE("Vehicle Serial No.", SalesLine."Vehicle Serial No.");

          VALIDATE("Vehicle Assembly ID", SalesLine."Vehicle Assembly ID");
         END;
    end;

    procedure ShowReservation()
    var
        Reservation: Page "498";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("Prod. Order No.",'');
        TESTFIELD("No.");
        CLEAR(Reservation);
        Reservation.SetPurchLine(Rec);
        Reservation.RUNMODAL;
    end;

    procedure ShowReservationEntries(Modal: Boolean)
    var
        ReservEntry: Record "337";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
        ReservePurchLine.FilterReservFor(ReservEntry,Rec);
        IF Modal THEN
          PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
        ELSE
          PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    end;

    procedure UpdateInvoiceOnPurchOrder()
    begin
        IF "Document Type" = "Document Type"::Order THEN BEGIN
          GetPurchHeader;
          IF ("Quantity Received" > 0) AND ("Quantity Invoiced" > 0) AND NOT PurchHeader.Invoice THEN BEGIN
            PurchHeader.Invoice := TRUE;
            PurchHeader.MODIFY;
          END;
        END;
    end;

    procedure ShowVehReservation()
    var
        VehReservation: Page "25006529";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("Prod. Order No.",'');
        TESTFIELD("No.");
        CLEAR(VehReservation);
        VehReservation.SetPurchLine(Rec);
        VehReservation.RUNMODAL;
    end;

    procedure ShowVehReservationEntries(Modal: Boolean)
    var
        VehReservEngineMgt: Codeunit "25006300";
        VehReservEntry: Record "25006392";
        VehReservePurchLine: Codeunit "25006319";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        VehReservePurchLine.FilterReservFor(VehReservEntry,Rec);
        IF Modal THEN
          PAGE.RUNMODAL(PAGE::"Vehicle Reservation Entries",VehReservEntry)
        ELSE
          PAGE.RUN(PAGE::"Vehicle Reservation Entries",VehReservEntry);
    end;

    procedure SetNotPromptVehCycle()
    begin
        DontPromptVehCycle := TRUE;
    end;

    procedure UpdateDatesEDMS()
    var
        OrderingPriceType: Record "25006763";
    begin
        //16.11.2011 EDMS P8 >>
        IF "Expected Receipt Date" <> 0D THEN
          IF OrderingPriceType.GET("Ordering Price Type Code") THEN
            IF FORMAT(OrderingPriceType."Inbound Time") <> '' THEN
              "Expected Receipt Date" := CALCDATE(OrderingPriceType."Inbound Time", "Expected Receipt Date");
    end;

    procedure GetReservForInfo(ReturnValue: Option CustomerNo,VIN,DealType,CustomerName,OrderingPriceType): Text[50]
    begin
        EXIT(ReservEngineMgt.GetReservInfoForFactBox(ReturnValue, "Document No.", "Line No.", DATABASE::"Purchase Line", "Document Type", 0, ''));
    end;

    procedure OnLookupVehicleRegistrationNo()
    var
        Vehicle: Record "25006005";
    begin
        IF "Vehicle Registration No." <> '' THEN BEGIN
          Vehicle.RESET;
          Vehicle.SETCURRENTKEY("Registration No.");
          Vehicle.SETRANGE("Registration No.","Vehicle Registration No.");
          IF Vehicle.FINDFIRST THEN;
          Vehicle.SETRANGE("Registration No.");
        END;

        IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
         VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
    end;

    procedure UpdateUnitPrice2()
    begin
        UpdateDirectUnitCost(0);
        UpdateAmounts;
    end;

    procedure LookUpAllotment(var recAllotment: Record "33020024";LCCode: Code[20]): Boolean
    var
        LCValueAllotmentList: Page "33020026";
    begin
        CLEAR(LCValueAllotmentList);
        IF LCCode <> '' THEN
         IF recAllotment.GET(LCCode) THEN
           LCValueAllotmentList.SETRECORD(recAllotment);
        LCValueAllotmentList.SETTABLEVIEW(recAllotment);
        LCValueAllotmentList.LOOKUPMODE(TRUE);
        LCValueAllotmentList.EDITABLE(FALSE);
        IF LCValueAllotmentList.RUNMODAL = ACTION::LookupOK THEN
         BEGIN
          LCValueAllotmentList.GETRECORD(recAllotment);
          EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;

    procedure ClearTDSFields()
    begin
        IF "TDS Group" = '' THEN BEGIN
        //TDS2.00
        "TDS%" := 0;
        "TDS Type" := "TDS Type"::" ";
        "TDS Amount" := 0;
        "TDS Base Amount" := 0;
        //COMMIT; Commented on 08 DEC 2016

        //TDS2.00
        END ELSE BEGIN
        //TDS2.00
        PurchHeader.RESET;
        PurchHeader.SETRANGE("No.","Document No.");
        PurchHeader.FINDFIRST;

        VendRec.RESET;
        VendRec.SETRANGE("No.",PurchHeader."Pay-to Vendor No.");
        IF VendRec.FINDFIRST THEN BEGIN
           IF VendRec."TDS Posting Group" <> '' THEN
            "TDS Group" := VendRec."TDS Posting Group";
           //"Document Class" := "Document Class"::Vendor;
           //"Document Subclass" := PurchHeader."Pay-to Vendor No.";
        END;
        //TDS2.00
        //TDS2.00

        TDSPostingGroup.RESET;
        TDSPostingGroup.SETRANGE(Code,"TDS Group");
        IF TDSPostingGroup.FINDFIRST THEN BEGIN
          TDSPostingGroup.TESTFIELD("TDS%");
          TDSPostingGroup.TESTFIELD("GL Account No.");
          "TDS Type" := "TDS Type"::"Purchase TDS";
          "TDS%" := TDSPostingGroup."TDS%";
        END;
        //TDS2.00
        END;
    end;

    local procedure TestOrderType()
    begin
        IF (PurchHeader."Document Profile" = PurchHeader."Document Profile"::"Spare Parts Trade") THEN
          PurchHeader.TESTFIELD("Order Type");
    end;

    local procedure "--QR19.00--"()
    begin
    end;

    procedure OpenQRSpecificationLines()
    var
        QRSpecifications: Page "50001";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD(Quantity);
        GetPurchHeader;

        CLEAR(QRSpecifications);
        QRSpecifications.SetSource(DATABASE::"Purchase Line","Document Type","Document No.","Line No.","No.",
          "Unit of Measure Code","Qty. per Unit of Measure","Location Code","Expected Receipt Date",PurchHeader."Lot No. Prefix");
        QRSpecifications.SetTotalQuantity(Quantity);
        QRSpecifications.RUN;
    end;

    var
        ICPartner: Record "413";
        ItemCrossReference: Record "5717";

    var
        TempReservEntry: Record "337" temporary;

    var
        ItemSubstSync: Codeunit "25006513";
        Itm: Record "27";

    var
        Item1: Record "27";
        Item2: Record "27";
        NonstockItem1: Record "5718";
        NonstockItem2: Record "5718";
        ItemSubstitution: Record "5715";
        No1: Code[20];
        No2: Code[20];

    var
        UserProfile: Record "25006067";

    var
        LookUpMgt: Codeunit "25006003";
        SingleInstanceMgt: Codeunit "25006001";
        VehAccCycle: Codeunit "25006303";

    var
        Text26500: Label 'You must check field %1 in %2 to be able to change the %3 field manually.';
        TextItemDisallowedToPurchase: Label 'Item %1 not allowed to purchase in location %2. Line No. %3.';
        VehPriceMgt: Codeunit "25006301";
        ExternalService: Record "25006133";
        VehReservePurchLine: Codeunit "25006319";
        DontPromptVehCycle: Boolean;
        Text055: Label 'Do you want to make a number replacement?\%1 -> %2';
        Text056: Label 'Replacement created \ %1 - %2';
        Text105: Label 'There is no vehicle with Registration No. %1';
        UserProfileMgt: Codeunit "25006002";
        AccCenter: Record "33019846";
        UserMgt: Codeunit "5700";
        TDSPostingGroup: Record "33019849";
        VendRec: Record "23";
        CannotGetDiscountOnVOR: Label 'You cannot have Discount on VOR Purchase Order Type.';
}


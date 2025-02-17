tableextension 50167 tableextension50167 extends "Sales Line"
{
    // 05.07.2016 EB.P7 #PAR28
    //   "No." OnLookup() trigger code moved to page
    //   "No." OnValidate trigger modified
    // 
    // 11.05.2016 EB.P7 #PAR28
    //   Field "Has Replacement" added
    // 
    // 16.03 2016 EB.P7 Branch Setup
    //   Modified CheckVehicleDiscount function, Usert Profile Setup to Branch Profile Setup
    //   Modified No. - OnValidate Usert Profile Setup to Branch Profile Setup
    //   Modified Vehicle Serial No. - OnValidate Usert Profile Setup to Branch Profile Setup
    // 
    // 25.01.2016 EB.P30 #T031
    //   Modified field "Vehicle Body Color Code" lenght to 20 characters
    // 
    // 15.05.2015 EB.P7 #Merge
    //   Modified function UpdatePrepmtSetupFields() merged edms functionality
    // 
    // 10.03.2015 EDMS P21
    //   Modified procedure:
    //     CreateDim
    //   Modified CreateDim calls because of added parameter
    //   Modified trigger:
    //     Location Code - OnValidate
    // 
    // 14.05.2014 Elva Baltic P21 #S0103 MMG7.00
    //   Added code to:
    //     No. - OnLookup()
    // 
    // 29.04.2014 Elva Baltic P8 #F037 MMG7.00
    //   * Use of Def. Status from profile
    // 
    // 27.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Added functions GetReservationColor, FilterSalesLineRes
    // 
    // 17.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     Contract No.
    // 
    // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00
    //   Added COde To "Vehicle Serial No. - OnValidate()"
    // 
    // 25.10.2013 EDMS P8
    //   * Added use of Vehicle default dimension
    // 
    // 29.08.2013 EDMS P8
    //   * small fix
    // 
    // 03.06.2013 Elva Baltic P15
    //   * If Vehicle is in Vehicle.Inventory UnitCost is got from ILE Open Entry, otherwise, as it was before, from Item
    //   * Added Function: GetVehUnitCost
    // 
    // 23.01.2013 EDMS P8
    //   * small fix to update VIN in lines at insert
    // 
    // 2012.07.31 EDMS P8
    //   * added fields: Variable Field Run 2, Variable Field Run 3
    //   * renamed field Kilometrage to 'Variable Field Run 1' and type to decimal
    // 
    // 2012.04.12 EDMS P8
    //   * removed fields "Resource No."(25006050) and "Mechanics No."
    // 
    // 20.08.2008. EDMS P2
    //   * Added code NoAssistEdit
    // 
    // 02.07.2008. EDMS P2
    //   * Added code ApplyAmrkupRestrictions
    // 
    // 10.06.2008. EDMS P2
    //   * Changed code fVehApplyToPurch
    // 
    // 10.05.2008. EDMS P2
    //   * Added code Location Code - OnValidate
    // 
    // 09.05.2008. EDMS P2
    //   * Added code Quantity - OnValidate (check for Vehicle qty not more than 1)
    // 
    // 08.04.2008. EDMS P2
    //   * Changed code OnDelete
    // 
    // 07.03.2008. EDMS P2
    //   * Added code No. - OnValidate
    // 
    // 28.12.2007 EDMS P5
    //         * Changed property "OptionString" for field "Type"
    //           from  ",G/L Account,Item,Resource,Fixed Asset,Charge (Item)"
    //           to " ,G/L Account,Item,Resource,Fixed Asset,Charge (Item),,External Service"
    // 
    //         * Changed property "TableRelation" for field "No."
    //           from "IF (Type=CONST(" ")) "Standard Text"
    //               ELSE IF (Type=CONST(G/L Account)) "G/L Account"
    //               ELSE IF (Type=CONST(Item)) Item
    //               ELSE IF (Type=CONST(Resource)) Resource
    //               ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
    //               ELSE IF (Type=CONST("Charge (Item)")) "Item Charge""
    //           to "IF (Type=CONST(" ")) "Standard Text"
    //               ELSE IF (Type=CONST(G/L Account)) "G/L Account"
    //               ELSE IF (Type=CONST(Item)) Item
    //               ELSE IF (Type=CONST(Resource)) Resource
    //               ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
    //               ELSE IF (Type=CONST("Charge (Item)")) "Item Charge"
    //               ELSE IF (Type=CONST(External Service)) "External Service EDMS""
    // 
    //         * Added new field
    //           25006130 "Ext. Service Tracking No."
    // 
    // 03.10.2007. EDMS P2
    //    * Added code OnDelete
    // 
    // 10.09.2007 EDMS P3
    //   * Added 2 procedures: ShowTransferTakeOut and ShowTransferPutIn
    // 
    // 31.08.2007. EDMS P2
    //   * Added code in trigger "Vehicle Serial No. - OnValidate()"
    // 
    // 17-07-2007 EDMS P3
    //   * Added field "Include In Vehicle Sls Amt" to control creation of value entry for this line to impact
    //     overall sales amt. sum on vehicle
    // 
    // 05.06.2007. EDMS P2
    //   * Created function VehChecklistItem
    // 
    // //09-02-2007 EDMS P3
    // Added field 25006377 - EDMS No. (also in posted line)
    // 
    // EBLV7.00.00
    fields
    {
        modify(Type)
        {
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item),,External Service';

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
                                                                                                   System-Created Entry=CONST(Yes)) "G/L Account"
                                                                                                   ELSE IF (Type=CONST(Item),
                                                                                                            Line Type=CONST(Vehicle)) Item WHERE (Item Type=CONST(Model Version))
                                                                                                            ELSE IF (Type=CONST(Item),
                                                                                                                     Line Type=FILTER(<>Vehicle)) Item WHERE (Item Type=FILTER(' '|Item))
                                                                                                                     ELSE IF (Type=CONST(Resource)) Resource
                                                                                                                     ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                                                     ELSE IF (Type=CONST("Charge (Item)")) "Item Charge"
                                                                                                                     ELSE IF (Type=CONST(External Service)) "External Service";
        }

        //Unsupported feature: Property Insertion (Editable) on ""Location Code"(Field 7)".

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
                                                                                                   ELSE IF (Type=CONST(Resource)) Resource
                                                                                                   ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                                   ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
        }

        //Unsupported feature: Property Modification (Editable) on ""Customer Price Group"(Field 42)".

        modify("Quantity Shipped")
        {
            Caption = '';
        }

        //Unsupported feature: Property Modification (Editable) on ""Bill-to Customer No."(Field 68)".

        modify("Purch. Order Line No.")
        {
            TableRelation = IF (Drop Shipment=CONST(Yes)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                            Document No.=FIELD(Purchase Order No.));
        }
        modify("Attached to Line No.")
        {
            TableRelation = "Sales Line"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                           Document No.=FIELD(Document No.));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity"(Field 95)".

        modify("Blanket Order Line No.")
        {
            TableRelation = "Sales Line"."Line No." WHERE (Document Type=CONST(Blanket Order),
                                                           Document No.=FIELD(Blanket Order No.));
        }

        //Unsupported feature: Property Insertion (Editable) on ""Line Amount"(Field 103)".


        //Unsupported feature: Property Modification (CalcFormula) on ""ATO Whse. Outstanding Qty."(Field 902)".


        //Unsupported feature: Property Modification (CalcFormula) on ""ATO Whse. Outstd. Qty. (Base)"(Field 903)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Posting Date"(Field 1300)".


        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

        modify("Bin Code")
        {
            TableRelation = IF (Document Type=FILTER(Order|Invoice),
                                Quantity=FILTER(>=0),
                                Qty. to Asm. to Order (Base)=CONST(0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                       Item No.=FIELD(No.),
                                                                                                       Variant Code=FIELD(Variant Code))
                                                                                                       ELSE IF (Document Type=FILTER(Return Order|Credit Memo),
                                                                                                                Quantity=FILTER(<0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                     Item No.=FIELD(No.),
                                                                                                                                                                     Variant Code=FIELD(Variant Code))
                                                                                                                                                                     ELSE Bin.Code WHERE (Location Code=FIELD(Location Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. (Base)"(Field 5495)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Substitution Available"(Field 5702)".

        modify("Special Order Purch. Line No.")
        {
            TableRelation = IF (Special Order=CONST(Yes)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                            Document No.=FIELD(Special Order Purchase No.));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Whse. Outstanding Qty."(Field 5749)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Whse. Outstanding Qty. (Base)"(Field 5750)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. to Assign"(Field 5801)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. Assigned"(Field 5802)".



        //Unsupported feature: Code Modification on "Type(Field 5).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestJobPlanningLine;
            TestStatusOpen;
            GetSalesHeader;
            #4..48
            "System-Created Entry" := TempSalesLine."System-Created Entry";
            "Currency Code" := SalesHeader."Currency Code";

            IF Type = Type::Item THEN
              "Allow Item Charge Assignment" := TRUE
            ELSE
            #55..58
              IF SalesHeader.WhseShpmntConflict("Document Type","Document No.",SalesHeader."Shipping Advice") THEN
                ERROR(Text052,SalesHeader."Shipping Advice");
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..51
            //EDMS >>
             "Document Profile" := TempSalesLine."Document Profile";
             "Line Type" := TempSalesLine."Line Type" ;
            //EDMS <<

            #52..61
            */
        //end;


        //Unsupported feature: Code Modification on ""No."(Field 6).OnValidate".

        //trigger "(Field 6)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            "No." := TypeHelper.FindNoFromTypedValue(Type,"No.",NOT "System-Created Entry");

            TestJobPlanningLine;
            #4..7
              TESTFIELD("Qty. to Asm. to Order (Base)",0);
              CALCFIELDS("Reserved Qty. (Base)");
              TESTFIELD("Reserved Qty. (Base)",0);
              IF Type = Type::Item THEN
                WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
            END;

            TESTFIELD("Qty. Shipped Not Invoiced",0);
            TESTFIELD("Quantity Shipped",0);
            TESTFIELD("Shipment No.",'');
            #18..32
              "Recalculate Invoice Disc." := TRUE;
            Type := TempSalesLine.Type;
            "No." := TempSalesLine."No.";
            IF "No." = '' THEN
              EXIT;
            IF Type <> Type::" " THEN
              Quantity := TempSalesLine.Quantity;

            "System-Created Entry" := TempSalesLine."System-Created Entry";
            GetSalesHeader;
            InitHeaderDefaults(SalesHeader);
            #44..71
                  IF NOT "System-Created Entry" THEN
                    GLAcc.TESTFIELD("Direct Posting",TRUE);
                  Description := GLAcc.Name;
                  "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                  "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
                  "Tax Group Code" := GLAcc."Tax Group Code";
                  "Allow Invoice Disc." := FALSE;
                  "Allow Item Charge Assignment" := FALSE;
            #80..99
                  "Product Group Code" := Item."Product Group Code";
                  Nonstock := Item."Created From Nonstock Item";
                  "Profit %" := Item."Profit %";
                  "Allow Item Charge Assignment" := TRUE;
                  PrepaymentMgt.SetSalesPrepaymentPct(Rec,SalesHeader."Posting Date");

            #106..110
                  ELSE
                    Reserve := Item.Reserve;

                  "Unit of Measure Code" := Item."Sales Unit of Measure";
                  InitDeferralCode;
                  SetDefaultItemQuantity;
                END;
              Type::Resource:
                BEGIN
            #120..137
                  FixedAsset.TESTFIELD(Blocked,FALSE);
                  GetFAPostingGroup;
                  Description := FixedAsset.Description;
                  "Description 2" := FixedAsset."Description 2";
                  "Allow Invoice Disc." := FALSE;
                  "Allow Item Charge Assignment" := FALSE;
                END;
              Type::"Charge (Item)":
                BEGIN
            #147..151
                  "Allow Invoice Disc." := FALSE;
                  "Allow Item Charge Assignment" := FALSE;
                END;
            END;

            IF NOT (Type IN [Type::" ",Type::"Fixed Asset"]) THEN
            #158..169
                InitQtyToAsm;
                UpdateWithWarehouseShip;
              END;
              UpdateUnitPrice(FIELDNO("No."));
            END;

            IF NOT ISTEMPORARY THEN
              CreateDim(
                DimMgt.TypeToTableID3(Type),"No.",
                DATABASE::Job,"Job No.",
                DATABASE::"Responsibility Center","Responsibility Center");

            IF "No." <> xRec."No." THEN BEGIN
              IF Type = Type::Item THEN
                IF (Quantity <> 0) AND ItemExists(xRec."No.") THEN BEGIN
                  ReserveSalesLine.VerifyChange(Rec,xRec);
                  WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                END;
              GetDefaultBin;
            #189..192
            END;

            UpdateItemCrossRef;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..10
              IF Type = Type::Item THEN BEGIN
                WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                IF "Line Type" = "Line Type"::Vehicle THEN //24.02.2008 EDMS P1
                 VehReserveSalesLine.VerifyChange(Rec,xRec); //24.02.2008 EDMS P1
              END;
            END;
            #15..35

            //EDMS >>
            "Vehicle Assembly ID" := TempSalesLine."Vehicle Assembly ID";
             "Document Profile" := TempSalesLine."Document Profile";
             "Vehicle Status Code" := TempSalesLine."Vehicle Status Code";
            //16.03.2016 EB.P7 #Branch Profile >>
            {
            IF "Vehicle Status Code" = '' THEN
              IF UserProfileMgt.CurrProfileID <> '' THEN
                IF UserProfile.GET(UserProfileMgt.CurrProfileID) THEN
                  IF UserProfile."Default Vehicle Sales Status" <> '' THEN
                    VALIDATE("Vehicle Status Code", UserProfile."Default Vehicle Sales Status");
            }
             //16.03.2016 EB.P7 #Branch Profile <<
             "Make Code" := TempSalesLine."Make Code";
             "Model Code" := TempSalesLine."Model Code";
             "Model Version No." := TempSalesLine."Model Version No.";
             "Line Type" := TempSalesLine."Line Type";
             "Service Order Line No. EDMS" := TempSalesLine."Service Order Line No. EDMS";
             "Order Line Type No." := TempSalesLine."Order Line Type No.";
             "Deal Type Code" := TempSalesLine."Deal Type Code";
             "Real Time" := TempSalesLine."Real Time";
             "Vehicle Serial No." := TempSalesLine."Vehicle Serial No.";
             "Vehicle Accounting Cycle No." := TempSalesLine."Vehicle Accounting Cycle No.";
             Group := TempSalesLine.Group;
             "Group ID" := TempSalesLine."Group ID";
             "Package No." := TempSalesLine."Package No.";
             "Package Version No." := TempSalesLine."Package Version No.";
             "Package Version Spec. Line No." := TempSalesLine."Package Version Spec. Line No.";
             "External Serv. Tracking No." := TempSalesLine."External Serv. Tracking No.";

             "Confirmed Date" := TempSalesLine."Confirmed Date";
             "Confirmed Time" := TempSalesLine."Confirmed Time";
            // "Variant Code" := TempSalesLine."Variant Code";

            //EDMS <<
            "Contract No." := TempSalesLine."Contract No.";                                     // 17.04.2014 Elva Baltic P21

            #36..40
            //EDMS >>
             IF "Line Type" = "Line Type"::Vehicle THEN
              Quantity := 1;
            //EDMS <<

            #41..74

                  //EDMS >>
                  CASE "Line Type" OF
                    "Line Type"::Labor:
                     BEGIN
                      recDMSLabor.GET("Order Line Type No.");
                      "Gen. Prod. Posting Group" := recDMSLabor."Gen. Prod. Posting Group";
                      "VAT Prod. Posting Group" := recDMSLabor."VAT Prod. Posting Group";
                     END;
                    "Line Type"::"Ext. Service":
                     BEGIN
                      recDMSExternal.GET("Order Line Type No.");
                      "Gen. Prod. Posting Group" := recDMSExternal."Gen. Prod. Posting Group";
                      "VAT Prod. Posting Group" := recDMSExternal."VAT Prod. Posting Group";
                     END;
                    ELSE
                     BEGIN
                  //EDMS <<

                  "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                  "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";

                  //EDMS >>
                     END;
                  END;
                  //EDMS <<

            #77..102
                  ABC := Item.ABC; //Min 3.2.2020
                   InventorySetup.GET;
                  "HS Code" := COPYSTR(Item."Tariff No.", 1, InventorySetup."HS Code Prefix Length");; //prabesh for hs code
            #103..113
                  //EDMS >>
                   IF "Line Type" = "Line Type"::Vehicle THEN
                    Reserve := Reserve::Optional;
                  //EDMS <<

            #114..116
                  //EDMS >>
                   SalesSetup.GET;
                   "Ordering Price Type Code" := SalesSetup."Def. Ordering Price Type Code";

                  IF SalesSetup."Item No. Replacement Warnings" THEN
                   IF Item."Item Type" = Item."Item Type"::Item THEN
                    ItemSubstitutionMgt.CheckReplacements("No.");
                  //EDMS <<
            #117..140

                  IF STRLEN(FixedAsset."Description 2") > 50 THEN
                    "Description 2" := COPYSTR(FixedAsset."Description 2",1,50)
                  ELSE
                    "Description 2" := FixedAsset."Description 2";

                  "Allow Invoice Disc." := FALSE;
                  "Allow Item Charge Assignment" := FALSE;
                  InventorySetup.GET;
                  "HS Code" := COPYSTR(FixedAsset."Tariff No.", 1, InventorySetup."HS Code Prefix Length"); //prabesh for hs code
            #144..154

              //14.12.2007 EDMS P5 >>
               Type::"External Service":
                BEGIN
                  ExternalService.GET("No.");
                  Description := ExternalService.Description;
                  "Gen. Prod. Posting Group" := ExternalService."Gen. Prod. Posting Group";
                  "VAT Prod. Posting Group" := ExternalService."VAT Prod. Posting Group";
                  "Unit of Measure Code" := ExternalService."Unit of Measure Code";
                END;
              //14.12.2007 EDMS P5 <<

            #155..172
              IF NOT CheckNonBillableCustomer THEN
                UpdateUnitPrice(FIELDNO("No."));
            END;

            IF NOT ISTEMPORARY THEN BEGIN

            GLSetup.GET;
            IF NOT GLSetup."Use Accountability Center" THEN
                CreateDim(
                  DimMgt.TypeToTableID3(Type),"No.",
              //  DATABASE::Job,"Job No.",
                DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
                DATABASE::"Responsibility Center","Responsibility Center",
                DATABASE::"Deal Type","Deal Type Code", //DMS
                DATABASE::Make,"Make Code", //DMS
                DATABASE::"Payment Method","Payment Method Code", //DMS
                DATABASE::Vehicle,"Vehicle Serial No.", //DMS
                DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                )
              ELSE
                CreateDim(
                  DimMgt.TypeToTableID3(Type),"No.",
              //  DATABASE::Job,"Job No.",
                DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
                DATABASE::"Accountability Center","Accountability Center",
                DATABASE::"Deal Type","Deal Type Code", //DMS
                DATABASE::Make,"Make Code", //DMS
                DATABASE::"Payment Method","Payment Method Code", //DMS
                DATABASE::Vehicle,"Vehicle Serial No.", //DMS
                DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                );
            END;
            #181..185
                  IF "Line Type" = "Line Type"::Vehicle THEN //24.02.2008 EDMS P1
                   VehReserveSalesLine.VerifyChange(Rec,xRec); //24.02.2008 EDMS P1
            #186..195
            //EDMS >>
            IF "Line Type" = "Line Type"::Vehicle THEN BEGIN
              IF "Vehicle Serial No." = '' THEN
                NewSerialNo;
              IF "No." <> "Model Version No." THEN BEGIN
                "Model Version No." := "No.";
                "Make Code" := Item."Make Code";
                "Model Code" := Item."Model Code"
              END
            END;
            //EDMS <<

            //CBM
            {IF Type = Type::Item THEN BEGIN
             CBM := 1;
             Itm.GET("No.");
             IF Rec.Quantity <> 0 THEN BEGIN
              ItmAttVal.RESET;
              ItmAttVal.SETRANGE("Table ID",DATABASE::Item);
              ItmAttVal.SETRANGE("No.","No.");
              IF ItmAttVal.FINDSET THEN REPEAT
               ItmVal.GET(ItmAttVal."Item Attribute ID");
               IF ItmVal."Value Type" <> ItmVal."Value Type"::" " THEN BEGIN
                 ItmAVal.GET(ItmAttVal."Item Attribute ID",ItmAttVal."Item Attribute Value ID");
                 EVALUATE(Dec,ItmAVal.Value);
                 CBM := CBM * Dec;
                END;
              UNTIL ItmAttVal.NEXT = 0;
              CBM := CBM * Quantity;
             END ELSE
              CBM := 0;
            END;
            }
            //New way
            IF Type = Type::Item THEN BEGIN
             Item.GET("No.");
             IF Rec.Quantity <> 0 THEN
              CBM := Item.CBM * Rec.Quantity
              ELSE
              CBM := 0;
            END;
            //CBM
            */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Location Code"(Field 7).OnValidate".

        //trigger (Variable: NewLocationCode)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on ""Location Code"(Field 7).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestJobPlanningLine;
            TestStatusOpen;
            CheckAssocPurchOrder(FIELDCAPTION("Location Code"));
            IF "Location Code" <> '' THEN
              IF IsServiceItem THEN
                Item.TESTFIELD(Type,Item.Type::Inventory);
            IF xRec."Location Code" <> "Location Code" THEN BEGIN
              IF NOT FullQtyIsForAsmToOrder THEN BEGIN
                CALCFIELDS("Reserved Qty. (Base)");
                TESTFIELD("Reserved Qty. (Base)","Qty. to Asm. to Order (Base)");
              END;
              TESTFIELD("Qty. Shipped Not Invoiced",0);
              TESTFIELD("Shipment No.",'');
              TESTFIELD("Return Qty. Rcd. Not Invd.",0);
            #15..49
                  UpdateWithWarehouseShip;
                IF NOT FullReservedQtyIsForAsmToOrder THEN
                  ReserveSalesLine.VerifyChange(Rec,xRec);
                WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
              END;
            END;
            #56..62

            IF "Document Type" = "Document Type"::"Return Order" THEN
              ValidateReturnReasonCode(FIELDNO("Location Code"));
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..3

            //Location Should not be Raxol in sales>>
            IF lSalesReceiveableSetup.GET THEN
              IF "Location Code"=lSalesReceiveableSetup."Custom Application Location 1" THEN
                ERROR('Sales is not allowed from Location : '+lSalesReceiveableSetup."Custom Application Location 1");
            //Location Should not be Raxol in sales<<

            #4..11

              //10.05.2008. EDMS P2 >>
              NewLocationCode := "Location Code";
              "Location Code" := xRec."Location Code";
              "Location Code" := NewLocationCode;
              //10.05.2008. EDMS P2 <<

              //15.02.2008. EDMS P2 >>
              IF ("Document Profile" = "Document Profile"::"Vehicles Trade") AND ("Line Type" = "Line Type"::Vehicle) THEN
                DeleteVehItemTrackingLine(xRec."Location Code");
              //15.02.2008. EDMS P2 <<

            #12..52

                IF "Line Type" = "Line Type"::Vehicle THEN //24.02.2008 EDMS P1
                 VehReserveSalesLine.VerifyChange(Rec,xRec); //24.02.2008 EDMS P1

            #53..65

            // 10.03.2015 EDMS P21 >>
            CreateDim(
              DimMgt.TypeToTableID3(Type),"No.",
              DATABASE::"Responsibility Center","Responsibility Center",
              DATABASE::Location,"Location Code",
              DATABASE::"Vehicle Status","Vehicle Status Code",
              DATABASE::"Deal Type","Deal Type Code",
              DATABASE::Make,"Make Code",
              DATABASE::"Payment Method","Payment Method Code",
              DATABASE::Vehicle,"Vehicle Serial No."
              );
            // 10.03.2015 EDMS P21 <<
            */
        //end;


        //Unsupported feature: Code Modification on ""Shipment Date"(Field 10).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestStatusOpen;
            WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
            IF CurrFieldNo <> 0 THEN
            #4..12
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

            AutoAsmToOrder;
            #27..33
              "Planned Shipment Date" := CalcPlannedShptDate(FIELDNO("Shipment Date"));
            IF NOT PlannedDeliveryDateCalculated THEN
              "Planned Delivery Date" := CalcPlannedDeliveryDate(FIELDNO("Shipment Date"));
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..15
              {    //SM1.00
            #17..23
              }
            #24..36
            */
        //end;


        //Unsupported feature: Code Modification on "Description(Field 11).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF Type = Type::" " THEN
              EXIT;

            CASE Type OF
              Type::Item:
                BEGIN
            #7..43
                    VALIDATE("No.",COPYSTR(ReturnValue,1,MAXSTRLEN("No.")));
                  END;
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..3
            IF Type = Type::Item THEN BEGIN //31
              IF xRec.Description <> '' THEN
                ERROR('You cannot change description manually.');
              END;

            #4..46
            */
        //end;


        //Unsupported feature: Code Modification on "Quantity(Field 15).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestJobPlanningLine;
            TestStatusOpen;

            CheckAssocPurchOrder(FIELDCAPTION(Quantity));

            IF "Shipment No." <> '' THEN
            #7..54
              InitItemAppl(FALSE);

            IF Type = Type::Item THEN BEGIN
              UpdateUnitPrice(FIELDNO(Quantity));
              IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") THEN BEGIN
                ReserveSalesLine.VerifyQuantity(Rec,xRec);
                IF NOT "Drop Shipment" THEN
            #62..86
            CheckWMS;

            UpdatePlanned;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            ItemSubstSync.ReplaceSalesLineItemNo(Rec);

            #1..3
            //09.05.2008. EDMS P2 >>
            IF "Document Type" <> "Document Type"::Quote THEN // yuran@agni 23-july 2013
              IF ("Line Type" = "Line Type"::Vehicle) AND (Quantity > 1) THEN
                TESTFIELD(Quantity, 1);
            //09.05.2008. EDMS P2 <<

            #4..57
             IF NOT CheckNonBillableCustomer THEN
                UpdateUnitPrice(FIELDNO(Quantity));
            #59..89

            //CBM
            {IF Type = Type::Item THEN BEGIN
             CBM := 1;
             Itm.GET("No.");
             IF Rec.Quantity <> 0 THEN BEGIN
              ItmAttVal.RESET;
              ItmAttVal.SETRANGE("Table ID",DATABASE::Item);
              ItmAttVal.SETRANGE("No.","No.");
              IF ItmAttVal.FINDSET THEN REPEAT
               ItmVal.GET(ItmAttVal."Item Attribute ID");
               IF ItmVal."Value Type" <> ItmVal."Value Type"::" " THEN BEGIN
                 ItmAVal.GET(ItmAttVal."Item Attribute ID",ItmAttVal."Item Attribute Value ID");
                 EVALUATE(Dec,ItmAVal.Value);
                 CBM := CBM * Dec;
                END;
              UNTIL ItmAttVal.NEXT = 0;
              CBM := CBM * Quantity;
             END ELSE
             CBM := 0;
            END;
            }

            IF Type = Type::Item THEN BEGIN
             Item.GET("No.");
             IF Rec.Quantity <> 0 THEN
              CBM := Item.CBM * Rec.Quantity
              ELSE
              CBM := 0;
            END;
            //CBM
            */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Unit Price"(Field 22).OnValidate".

        //trigger (Variable: Customer)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on ""Unit Price"(Field 22).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestJobPlanningLine;
            TestStatusOpen;
            VALIDATE("Line Discount %");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..3

            IF "Sell-to Customer No." <> '' THEN BEGIN
              IF Type <> Type::" " THEN BEGIN
                Customer.GET("Bill-to Customer No.");
                IF (Customer."Non-Billable") AND ("Unit Price" >0) AND (Type <> Type :: Item) THEN  //SM 05/12/2013
                  "Unit Price" := 0;
              END;
            END;
            */
        //end;


        //Unsupported feature: Code Modification on ""Inv. Discount Amount"(Field 69).OnValidate".

        //trigger  Discount Amount"(Field 69)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            CalcInvDiscToInvoice;
            UpdateAmounts;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            //***SM 29-07-2013 to check the max vehicle discount as per user
            VehMaxSalesDiscCheck;

            CalcInvDiscToInvoice;
            UpdateAmounts;
            */
        //end;


        //Unsupported feature: Code Modification on ""Purchase Order No."(Field 71).OnValidate".

        //trigger "(Field 71)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF (xRec."Purchase Order No." <> "Purchase Order No.") AND (Quantity <> 0) THEN BEGIN
              ReserveSalesLine.VerifyChange(Rec,xRec);
              WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            IF (xRec."Purchase Order No." <> "Purchase Order No.") AND (Quantity <> 0) THEN BEGIN
              ReserveSalesLine.VerifyChange(Rec,xRec);
              IF "Line Type" = "Line Type"::Vehicle THEN //24.02.2008 EDMS P1
               VehReserveSalesLine.VerifyChange(Rec,xRec); //24.02.2008 EDMS P1
              WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
            END;
            */
        //end;


        //Unsupported feature: Code Modification on ""Purch. Order Line No."(Field 72).OnValidate".

        //trigger  Order Line No()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF (xRec."Purch. Order Line No." <> "Purch. Order Line No.") AND (Quantity <> 0) THEN BEGIN
              ReserveSalesLine.VerifyChange(Rec,xRec);
              WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            IF (xRec."Purch. Order Line No." <> "Purch. Order Line No.") AND (Quantity <> 0) THEN BEGIN
              ReserveSalesLine.VerifyChange(Rec,xRec);
              IF "Line Type" = "Line Type"::Vehicle THEN //24.02.2008 EDMS P1
               VehReserveSalesLine.VerifyChange(Rec,xRec); //24.02.2008 EDMS P1
              WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
            END;
            */
        //end;


        //Unsupported feature: Code Modification on ""Drop Shipment"(Field 73).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TESTFIELD("Document Type","Document Type"::Order);
            TESTFIELD(Type,Type::Item);
            TESTFIELD("Quantity Shipped",0);
            #4..36
              WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
              IF NOT FullReservedQtyIsForAsmToOrder THEN
                ReserveSalesLine.VerifyChange(Rec,xRec);
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..39

              IF "Line Type" = "Line Type"::Vehicle THEN //24.02.2008 EDMS P1
               VehReserveSalesLine.VerifyChange(Rec,xRec); //24.02.2008 EDMS P1

            END;
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
            #4..20
                ROUND(
                  "Unit Price" * (100 + "VAT %") / (100 + xRec."VAT %"),
                  Currency."Unit-Amount Rounding Precision");
            UpdateAmounts;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..23

            //UpdateAmounts;   //20.03.2013 EDMS
            VALIDATE("Prepayment %");     //29-05-2007 EDMS P3 PREPMT
            */
        //end;


        //Unsupported feature: Code Modification on ""Job Contract Entry No."(Field 1002).OnValidate".

        //trigger "(Field 1002)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
            JobPlanningLine.SETRANGE("Job Contract Entry No.","Job Contract Entry No.");
            JobPlanningLine.FINDFIRST;
            CreateDim(
              DimMgt.TypeToTableID3(Type),"No.",
              DATABASE::Job,JobPlanningLine."Job No.",
              DATABASE::"Responsibility Center","Responsibility Center");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..3


            GLSetup.GET;
            IF NOT GLSetup."Use Accountability Center" THEN
              CreateDim(
                DimMgt.TypeToTableID3(Type),"No.",
               // DATABASE::Job,JobPlanningLine."Job No.", //DMS
                DATABASE::"Responsibility Center","Responsibility Center",
                DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
                DATABASE::"Deal Type","Deal Type Code", //DMS
                DATABASE::Make,"Make Code", //DMS
                DATABASE::"Payment Method","Payment Method Code", //DMS
                DATABASE::Vehicle,"Vehicle Serial No.", //DMS
                DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                )
            ELSE
              CreateDim(
                DimMgt.TypeToTableID3(Type),"No.",
               // DATABASE::Job,JobPlanningLine."Job No.", //DMS
                DATABASE::"Accountability Center","Accountability Center",
                DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
                DATABASE::"Deal Type","Deal Type Code", //DMS
                DATABASE::Make,"Make Code", //DMS
                DATABASE::"Payment Method","Payment Method Code", //DMS
                DATABASE::Vehicle,"Vehicle Serial No.", //DMS
                DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                );
            */
        //end;


        //Unsupported feature: Code Modification on ""Variant Code"(Field 5402).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestJobPlanningLine;
            IF "Variant Code" <> '' THEN
              TESTFIELD(Type,Type::Item);
            #4..25
            IF (xRec."Variant Code" <> "Variant Code") AND (Quantity <> 0) THEN BEGIN
              IF NOT FullReservedQtyIsForAsmToOrder THEN
                ReserveSalesLine.VerifyChange(Rec,xRec);
              WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
            END;

            UpdateItemCrossRef;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..28

              IF "Line Type" = "Line Type"::Vehicle THEN //24.02.2008 EDMS P1
               VehReserveSalesLine.VerifyChange(Rec,xRec); //24.02.2008 EDMS P1

            #29..32
            */
        //end;


        //Unsupported feature: Code Modification on ""Unit of Measure Code"(Field 5407).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TestJobPlanningLine;
            TestStatusOpen;
            TESTFIELD("Quantity Shipped",0);
            #4..56
                "Qty. per Unit of Measure" := 1;
            END;
            VALIDATE(Quantity);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..59
            IF Type = Type::Item THEN
              CheckItemAvailable(FIELDNO("Unit of Measure Code"));
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
              DATABASE::Job,"Job No.");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..3
              //DATABASE::Job,"Job No.", //DMS
              DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
              DATABASE::"Deal Type","Deal Type Code", //DMS
              DATABASE::Make,"Make Code", //DMS
              DATABASE::"Payment Method","Payment Method Code", //DMS
              DATABASE::Vehicle,"Vehicle Serial No.", //DMS
              DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
              );
            */
        //end;
        field(50000;"VIN-COGS";Code[20])
        {
        }
        field(50008;"Local Parts";Boolean)
        {
        }
        field(50009;"Prospect Line No.";Integer)
        {
            Description = 'CNY.CRM Pipeline Management Details for the Prospect';
        }
        field(60000;"Allotment Date";Date)
        {
        }
        field(60001;"Allotment Time";Time)
        {
        }
        field(60002;"System Allotment";Boolean)
        {
        }
        field(60003;"Confirmed Time";Time)
        {
        }
        field(60004;"Allotment Due Date";Date)
        {
        }
        field(60005;"Confirmed Date";Date)
        {
        }
        field(60006;ABC;Option)
        {
            Editable = false;
            OptionCaption = ' ,A,B,C,D,E';
            OptionMembers = " ",A,B,C,D,E;
        }
        field(70000;"Dealer PO No.";Code[20])
        {
            Description = 'For Dealer Portal';
        }
        field(70001;"Dealer Tenant ID";Code[30])
        {
            Description = 'For Dealer Portal';
        }
        field(70002;"Dealer Line No.";Integer)
        {
            Description = 'For Dealer Portal';
        }
        field(70003;"Item Movement Code";Option)
        {
            CalcFormula = Lookup(Item."Item Movement Category" WHERE (No.=FIELD(No.)));
            FieldClass = FlowField;
            OptionMembers = " ",EF,MF,RF,NPA;
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
                //21.12.2004 EDMS P1

                GLSetup.GET;
                IF NOT GLSetup."Use Accountability Center" THEN
                  CreateDim(
                    DATABASE::"Responsibility Center","Responsibility Center",
                    DimMgt.TypeToTableID3(Type),"No.",
                    //DATABASE::Job,"Job No.",
                    DATABASE::"Vehicle Status","Vehicle Status Code",
                    DATABASE::"Deal Type","Deal Type Code",
                    DATABASE::Make,"Make Code",
                    DATABASE::"Payment Method","Payment Method Code",
                    DATABASE::Vehicle,"Vehicle Serial No.", //DMS
                    DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                    )
                ELSE
                  CreateDim(
                    DATABASE::"Accountability Center","Accountability Center",
                    DimMgt.TypeToTableID3(Type),"No.",
                    //DATABASE::Job,"Job No.",
                    DATABASE::"Vehicle Status","Vehicle Status Code",
                    DATABASE::"Deal Type","Deal Type Code",
                    DATABASE::Make,"Make Code",
                    DATABASE::"Payment Method","Payment Method Code",
                    DATABASE::Vehicle,"Vehicle Serial No.", //DMS
                    DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                    );
            end;
        }
        field(25006002;"Payment Method Code";Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";

            trigger OnValidate()
            begin

                GLSetup.GET;
                IF NOT GLSetup."Use Accountability Center" THEN
                  CreateDim(
                    DATABASE::"Responsibility Center","Responsibility Center",
                    DimMgt.TypeToTableID3(Type),"No.",
                    //DATABASE::Job,"Job No.",
                    DATABASE::"Vehicle Status","Vehicle Status Code",
                    DATABASE::"Deal Type","Deal Type Code",
                    DATABASE::Make,"Make Code",
                    DATABASE::"Payment Method","Payment Method Code",
                    DATABASE::Vehicle,"Vehicle Serial No.", //DMS
                    DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                    )
                ELSE
                  CreateDim(
                  DATABASE::"Accountability Center","Accountability Center",
                  DimMgt.TypeToTableID3(Type),"No.",
                  //DATABASE::Job,"Job No.",
                  DATABASE::"Vehicle Status","Vehicle Status Code",
                  DATABASE::"Deal Type","Deal Type Code",
                  DATABASE::Make,"Make Code",
                  DATABASE::"Payment Method","Payment Method Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //DMS
                  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                  );
            end;
        }
        field(25006006;Group;Boolean)
        {
            Caption = 'Group';
        }
        field(25006007;"Group ID";Integer)
        {
            Caption = 'Group ID';
            TableRelation = "Sales Line"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                           Document No.=FIELD(Document No.),
                                                           Group=CONST(Yes));
        }
        field(25006008;"Group Description";Text[30])
        {
            CalcFormula = Lookup("Sales Line".Description WHERE (Document Type=FIELD(Document Type),
                                                                 Document No.=FIELD(Document No.),
                                                                 Line No.=FIELD(Group ID)));
            Caption = 'Group Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006010;"Item No. for Print";Code[20])
        {
            Caption = 'Item No. for Print';
            TableRelation = Item;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                recItem: Record "27";
            begin
                IF "Item No. for Print" <> '' THEN
                 BEGIN
                  IF recItem.GET("Item No. for Print") THEN
                    "Item Description for Print" := recItem.Description;
                 END
                ELSE
                 "Item Description for Print" := '';
            end;
        }
        field(25006020;"Item Description for Print";Text[30])
        {
            Caption = 'Item Description for Print';
        }
        field(25006030;"Campaign No.";Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(25006050;"Resource No. (Serv.)";Code[20])
        {
            Caption = 'Resource No. (Serv.)';
            TableRelation = Resource;
        }
        field(25006060;"Standard Time";Decimal)
        {
            BlankZero = true;
            Caption = 'Standard Time';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(25006120;"Part %";Decimal)
        {
            Caption = 'Part %';
            Description = 'Serviss';
        }
        field(25006130;"External Serv. Tracking No.";Code[20])
        {
            Caption = 'External Serv. Tracking No.';
            TableRelation = IF (Type=FILTER(External Service)) "External Serv. Tracking No."."External Serv. Tracking No." WHERE (External Service No.=FIELD(No.));
        }
        field(25006135;"Service Order No. EDMS";Code[20])
        {
            Caption = 'Service Order No. EDMS';
            Description = 'Only Service';
        }
        field(25006137;"Service Order Line No. EDMS";Integer)
        {
            Caption = 'Service Order Line No. EDMS';
            Description = 'Only Service';
        }
        field(25006140;"Order Line Type No.";Code[20])
        {
            Caption = 'Order Line Type No.';
            Description = 'Only Service';
            TableRelation = IF (Line Type=CONST(" ")) "Standard Text"
                            ELSE IF (Line Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Line Type=CONST(Item)) Item
                            ELSE IF (Line Type=CONST(Labor)) "Service Labor"
                            ELSE IF (Line Type=CONST(Ext. Service)) "External Service";
        }
        field(25006150;"Customer Notification Date";Date)
        {
            Caption = 'Customer Notification Date';
        }
        field(25006155;"Real Time";Decimal)
        {
            BlankZero = true;
            Caption = 'Real Time';
            Description = 'Only Service';
        }
        field(25006170;"Vehicle Registration No.";Code[30])
        {
            Caption = 'Vehicle Registration No.';

            trigger OnLookup()
            begin
                OnLookupVehicleRegistrationNo;
            end;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
            begin
                IF "Vehicle Registration No." = '' THEN BEGIN
                  VALIDATE("Vehicle Serial No.",'');
                  EXIT;
                END;

                Vehicle.RESET;
                Vehicle.SETCURRENTKEY("Registration No.");
                Vehicle.SETRANGE("Registration No.","Vehicle Registration No.");
                IF Vehicle.FINDFIRST THEN BEGIN
                  IF "Vehicle Serial No." <> Vehicle."Serial No." THEN
                    VALIDATE("Vehicle Serial No.",Vehicle."Serial No.")
                END ELSE
                  MESSAGE(STRSUBSTNO(Text105, "Vehicle Registration No."), '');
            end;
        }
        field(25006171;"Sell-to Customer Name";Text[50])
        {
            CalcFormula = Lookup("Sales Header"."Sell-to Customer Name" WHERE (Document Type=FIELD(Document Type),
                                                                               No.=FIELD(Document No.)));
            Caption = 'Sell-to Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006180;"Sell-to Contact Phone No.";Text[50])
        {
            CalcFormula = Lookup("Sales Header"."Sell-to Contact" WHERE (Document Type=FIELD(Document Type),
                                                                         No.=FIELD(Document No.)));
            Caption = 'Sell-to Contact Phone No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006190;"Mechanic No.";Code[20])
        {
            Caption = 'Mechanic No.';
            Description = 'Only Service';
            TableRelation = Resource;
        }
        field(25006210;"Package No.";Code[20])
        {
            Caption = 'Package No.';
            Editable = true;
            TableRelation = "Service Package".No.;
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
        }
        field(25006370;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            begin
                TestStatusOpen;

                GLSetup.GET;
                IF NOT GLSetup."Use Accountability Center" THEN
                  CreateDim(
                    DATABASE::"Responsibility Center","Responsibility Center",
                    DimMgt.TypeToTableID3(Type),"No.",
                    //DATABASE::Job,"Job No."
                    DATABASE::"Vehicle Status","Vehicle Status Code",
                    DATABASE::"Deal Type","Deal Type Code",
                    DATABASE::Make,"Make Code",
                    DATABASE::"Payment Method","Payment Method Code",
                    DATABASE::Vehicle,"Vehicle Serial No.", //DMS
                    DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                    )
                ELSE
                  CreateDim(
                    DATABASE::"Accountability Center","Accountability Center",
                    DimMgt.TypeToTableID3(Type),"No.",
                    //DATABASE::Job,"Job No."
                    DATABASE::"Vehicle Status","Vehicle Status Code",
                    DATABASE::"Deal Type","Deal Type Code",
                    DATABASE::Make,"Make Code",
                    DATABASE::"Payment Method","Payment Method Code",
                    DATABASE::Vehicle,"Vehicle Serial No.", //DMS
                    DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                    );

                IF ("Make Code" <> xRec."Make Code") AND ("Model Code" <> '') THEN
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
            var
                recVehicle: Record "25006005";
                recItem: Record "27";
            begin
                TestStatusOpen;

                IF ("Model Code" <> xRec."Model Code") AND ("Model Version No." <> '') THEN
                 BEGIN
                  VALIDATE("Model Version No.",'');
                 END;
            end;
        }
        field(25006372;"Line Type";Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,G/L Account,Item,Labor,Ext. Service,Materials,Vehicle,Own Option,Charge (Item),Fixed Asset';
            OptionMembers = " ","G/L Account",Item,Labor,"Ext. Service",Materials,Vehicle,"Own Option","Charge (Item)","Fixed Asset";

            trigger OnValidate()
            var
                cuDocMgtDMS: Codeunit "25006000";
            begin
                IF "Dealer Tenant ID" = '' THEN //Agni Incorporate UPG
                                                                                  cuDocMgtDMS.SL_SetType_LineType(Rec);
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
                Vehicle: Record "25006005";
            begin
                Vehicle.RESET;
                IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
                 BEGIN
                  VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
                  CALCFIELDS(VIN);
                 END;
            end;

            trigger OnValidate()
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

                IF "Line Type" = "Line Type"::Vehicle THEN BEGIN
                  IF "Model Version No." = '' THEN BEGIN
                    VALIDATE("No.","Model Version No.");
                    VIN := '';
                    "Vehicle Serial No." := '';
                    "Vehicle Accounting Cycle No." := '';
                  END ELSE
                    VALIDATE("No.","Model Version No.");
                  UpdateUnitPrice(FIELDNO("Model Version No."));
                END;

                //***SM 25-06-2013 For customer allocation
                IF "Line Type" = "Line Type"::Vehicle THEN
                   AllocateCustomer;
            end;
        }
        field(25006375;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Editable = false;

            trigger OnLookup()
            var
                Vehicle: Record "25006005";
            begin
                Vehicle.RESET;
                Vehicle.SETRANGE(Vehicle."Status Code",'NEW');
                IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN BEGIN
                  VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
                  VIN := Vehicle.VIN;
                END;
            end;

            trigger OnValidate()
            var
                ReservationEntry: Record "337";
                SalesLine: Record "37";
                EntryNo: Integer;
                frmItemTrackingLines: Page "6510";
                                          SalesLineReserve: Codeunit "99000832";
                                          Vehicle: Record "25006005";
                                          SerialNoPre: Code[20];
                                          DefCycle: Code[20];
                                          VehAccCycleMgt: Codeunit "25006303";
                                          VehSerialNo: Code[20];
                                          Vehi: Record "33019823";
            begin
                TestStatusOpen;
                
                IF ("Vehicle Serial No." <> '') AND ("Line Type" = "Line Type"::" ") AND
                   ("Document Profile" = "Document Profile"::"Vehicles Trade")
                THEN BEGIN
                  VehSerialNo := "Vehicle Serial No.";
                  VALIDATE("Line Type", "Line Type"::Vehicle);
                
                 // VALIDATE("Vehicle Serial No.", VehSerialNo); //bug do not write that kind of code
                END;
                
                /*
                IF ("Vehicle Serial No." <> '') AND ("Line Type" = "Line Type"::Vehicle) THEN BEGIN
                  SalesLine.RESET;
                  SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
                  SalesLine.SETCURRENTKEY(Type, "Line Type", "Vehicle Serial No.");
                  SalesLine.SETRANGE("Vehicle Serial No.", "Vehicle Serial No.");
                  SalesLine.SETRANGE("Line Type", SalesLine."Line Type"::Vehicle);
                  IF SalesLine.FINDFIRST THEN
                    MESSAGE(STRSUBSTNO(EDMS001, "Vehicle Serial No.", SalesLine."Document No."));
                END;
                */
                
                IF "Vehicle Serial No." = '' THEN BEGIN
                  VIN := '';
                  "Vehicle Accounting Cycle No." := '';
                  "Vehicle Registration No." := '';
                
                END ELSE BEGIN
                  Vehicle.RESET;
                  Vehicle.SETCURRENTKEY("Serial No.");
                  Vehicle.SETRANGE("Serial No.","Vehicle Serial No.");
                  IF Vehicle.FINDFIRST THEN BEGIN
                
                    //---surya -- block VIN having status code as Used in vehicle sales order >>
                    IF (SalesLine."Document Type" = SalesLine."Document Type"::Order) AND
                    (SalesLine."Document Profile" = SalesLine."Document Profile"::"Vehicles Trade") THEN BEGIN
                      Vehicle.TESTFIELD("Status Code",'NEW');
                      SalesLine3.SETRANGE("Vehicle Serial No.",SalesLine."Vehicle Serial No.");
                      SalesLine3.SETRANGE("Document Profile",SalesLine3."Document Profile"::"Vehicles Trade");
                      //IF SalesLine3.FINDFIRST THEN
                        //ERROR('VIN already exist in Sales Order no. %1.',SalesLine3."Document No.");
                    END;
                    //---- <<
                
                    SerialNoPre := "Vehicle Serial No.";
                    "Make Code" := Vehicle."Make Code";
                    "Model Code" := Vehicle."Model Code";
                    VALIDATE("Model Version No.",Vehicle."Model Version No."); //bug
                    "Model Version No." := Vehicle."Model Version No.";
                    CALCFIELDS(VIN);
                
                    "Vehicle Registration No." := Vehicle."Registration No.";
                
                    "Vehicle Body Color Code" := Vehicle."Body Color Code";
                    "Vehicle Interior Code" := Vehicle."Interior Code";
                    //16.03.2016 EB.P7 #Branch Profile >>
                    /*
                    IF UserProfileMgt.CurrProfileID <> '' THEN
                      IF UserProfile.GET(UserProfileMgt.CurrProfileID) THEN
                        IF UserProfile."Default Vehicle Sales Status" <> '' THEN
                          "Vehicle Status Code" := UserProfile."Default Vehicle Sales Status";
                    */
                    IF "Vehicle Status Code" = '' THEN
                      "Vehicle Status Code" := Vehicle."Status Code";
                    //"Variant Code" := Vehicle."VC No.";
                    "Vehicle Serial No." := SerialNoPre;
                    VALIDATE("Vehicle Status Code");
                    //16.03.2016 EB.P7 #Branch Profile <<
                
                IF Vehi.GET("Vehicle Serial No.") THEN; //V2
                
                
                    LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
                    LicensePermission.SETRANGE("Object Number",CODEUNIT::VehicleAccountingCycleMgt);
                    LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
                    IF NOT LicensePermission.ISEMPTY THEN BEGIN
                      Vehi.CALCFIELDS("Default Vehicle Acc. Cycle No.");
                      VALIDATE("Vehicle Accounting Cycle No.",Vehi."Default Vehicle Acc. Cycle No.");
                    END;
                
                  END ELSE BEGIN
                    VIN := '';
                
                    LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
                    LicensePermission.SETRANGE("Object Number",CODEUNIT::VehicleAccountingCycleMgt);
                    LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
                    IF NOT LicensePermission.ISEMPTY THEN BEGIN
                      DefCycle := VehAccCycleMgt.GetDefaultCycle("Vehicle Serial No.","Vehicle Accounting Cycle No.");
                      IF DefCycle = '' THEN
                       NewAccCycleNo
                      ELSE
                       VALIDATE("Vehicle Accounting Cycle No.",DefCycle);
                    END;
                
                  END;
                  //09.04.2014 Elva Baltic P1 #RX MMG7.00 >>
                  IF Type <> Type::" " THEN
                  //09.04.2014 Elva Baltic P1 #RX MMG7.00 <<
                  UpdateUnitPrice(FIELDNO("Vehicle Serial No."));
                END;
                
                IF "Vehicle Serial No." <> xRec."Vehicle Serial No." THEN
                  "Vehicle Assembly ID" := '';
                
                
                /*
                //Suman Maharjan 25/04/2013 to compare customer in vehicle card and sales line
                VehRec.RESET;
                CALCFIELDS(VIN);
                VehRec.SETRANGE(VIN,VIN);
                IF VehRec.FINDFIRST THEN BEGIN
                  IF VehRec."Customer No." <> '' THEN BEGIN
                    IF VehRec."Customer No." <> "Sell-to Customer No." THEN
                      ERROR(CustomerError);
                  END;
                END;
                //Suman Maharjan 25/04/2013 to compare customer in vehicle card and sales line
                */
                // BEGIN **Sipradi-YS** Checking Inventory of Vehicle on Sales Return (This code has been written on posting routine)
                //  IF ("Document Type" = "Document Type"::"Return Order") AND
                //    (Type = Type::Item) AND
                //    ("Document Profile" = "Document Profile"::"Vehicles Trade") THEN
                //      CheckVehicleInventory("Vehicle Serial No.");
                // END **Sipradi-YS** Checking Inventory of Vehicle on Sales Return
                
                // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00 >>
                GLSetup.GET;
                IF NOT GLSetup."Use Accountability Center" THEN
                  CreateDim(
                    DimMgt.TypeToTableID3(Type),"No.",
                   // DATABASE::Job,JobPlanningLine."Job No.", //DMS
                    DATABASE::"Responsibility Center","Responsibility Center",
                    DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
                    DATABASE::"Deal Type","Deal Type Code", //DMS
                    DATABASE::Make,"Make Code", //DMS
                    DATABASE::"Payment Method","Payment Method Code", //DMS
                    DATABASE::Vehicle,"Vehicle Serial No.", //DMS
                    DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                    )
                ELSE
                  CreateDim(
                    DimMgt.TypeToTableID3(Type),"No.",
                   // DATABASE::Job,JobPlanningLine."Job No.", //DMS
                    DATABASE::"Accountability Center","Accountability Center",
                    DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
                    DATABASE::"Deal Type","Deal Type Code", //DMS
                    DATABASE::Make,"Make Code", //DMS
                    DATABASE::"Payment Method","Payment Method Code", //DMS
                    DATABASE::Vehicle,"Vehicle Serial No.", //DMS
                    DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                    );
                // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00 <<

            end;
        }
        field(25006376;"Vehicle Assembly ID";Code[20])
        {
            Caption = 'Vehicle Assembly ID';

            trigger OnValidate()
            var
                VehAssembly: Record "25006380";
                tcAMT001: Label 'Vehicle assembly list %1 is not empty.';
            begin
                TestStatusOpen;

                TESTFIELD("Vehicle Serial No.");

                IF (xRec."Vehicle Assembly ID" <> '') AND (xRec."Vehicle Assembly ID" <> Rec."Vehicle Assembly ID")
                 AND (xRec."Line No." = Rec."Line No.") THEN
                 BEGIN
                  VehAssembly.RESET;
                  VehAssembly.SETRANGE("Serial No.",xRec."Vehicle Serial No.");
                  VehAssembly.SETRANGE("Assembly ID",xRec."Vehicle Assembly ID");
                  IF NOT VehAssembly.ISEMPTY THEN
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
            TableRelation = "Vehicle Accounting Cycle".No.;

            trigger OnLookup()
            var
                recVehAccCycle: Record "25006024";
            begin
                recVehAccCycle.RESET;
                IF LookUpMgt.LookUpVehicleAccCycle(recVehAccCycle,"Vehicle Serial No.","Vehicle Accounting Cycle No.") THEN
                 VALIDATE("Vehicle Accounting Cycle No.",recVehAccCycle."No.");
            end;

            trigger OnValidate()
            var
                cuVehAccCycle: Codeunit "25006303";
            begin
                LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
                LicensePermission.SETRANGE("Object Number",CODEUNIT::VehicleAccountingCycleMgt);
                LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
                IF NOT LicensePermission.ISEMPTY THEN BEGIN
                  TestStatusOpen;
                  cuVehAccCycle.CheckCycleRelation("Vehicle Serial No.","Vehicle Accounting Cycle No.");
                END;
            end;
        }
        field(25006380;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;

            trigger OnValidate()
            begin
                TestStatusOpen;
                //21.12.2004 EDMS P1

                GLSetup.GET;
                IF NOT GLSetup."Use Accountability Center" THEN
                  CreateDim(
                    DimMgt.TypeToTableID3(Type),"No.",
                    //DATABASE::Job,"Job No.",
                    DATABASE::"Vehicle Status","Vehicle Status Code",
                    DATABASE::"Responsibility Center","Responsibility Center",
                    DATABASE::"Deal Type","Deal Type Code",
                    DATABASE::Make,"Make Code",
                    DATABASE::"Payment Method","Payment Method Code",
                    DATABASE::Vehicle,"Vehicle Serial No.", //DMS
                    DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21 //Agni Incorporate UPG
                    )
                ELSE
                  CreateDim(
                  DimMgt.TypeToTableID3(Type),"No.",
                  //DATABASE::Job,"Job No.",
                  DATABASE::"Vehicle Status","Vehicle Status Code",
                  DATABASE::"Accountability Center","Accountability Center",
                  DATABASE::"Deal Type","Deal Type Code",
                  DATABASE::Make,"Make Code",
                  DATABASE::"Payment Method","Payment Method Code",
                  DATABASE::Vehicle,"Vehicle Serial No.", //DMS
                  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21 //Agni Incorporate UPG
                  );
            end;
        }
        field(25006382;Reserved;Boolean)
        {
            CalcFormula = Exist("Vehicle Reservation Entry" WHERE (Source Type=CONST(37),
                                                                   Source Subtype=FIELD(Document Type),
                                                                   Source ID=FIELD(Document No.),
                                                                   Source Ref. No.=FIELD(Line No.)));
            Caption = 'Reserved';
            Description = 'Only for Vehicles';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006386;"Vehicle Body Color Code";Code[20])
        {
            Caption = 'Vehicle Body Color Code';
            TableRelation = "Body Color".Code;
        }
        field(25006388;"Vehicle Interior Code";Code[10])
        {
            Caption = 'Vehicle Interior Code';
            TableRelation = "Vehicle Interior";
        }
        field(25006389;Kilometrage;Integer)
        {
        }
        field(25006390;"Vehicle Trade-In Line";Boolean)
        {
            Caption = 'Vehicle Trade-In Line';
        }
        field(25006391;"Applies-to Veh. Serial No.";Code[20])
        {
            Caption = 'Applies-to Veh. Serial No.';
        }
        field(25006392;"Applies-to Veh. Cycle No.";Code[20])
        {
            Caption = 'Applies-to Veh. Cycle No.';
        }
        field(25006578;"Include In Veh. Sales Amt.";Boolean)
        {
            Caption = 'Include In Veh. Sales Amt.';
        }
        field(25006680;"Contract No.";Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";

            trigger OnLookup()
            var
                Customer: Record "18";
                ContractTemp: Record "25006016" temporary;
            begin
            end;
        }
        field(25006700;"Ordering Price Type Code";Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";

            trigger OnValidate()
            var
                OrderingPriceType: Record "25006763";
            begin
                UpdateUnitPrice(FIELDNO("Ordering Price Type Code"));

                IF OrderingPriceType.GET("Ordering Price Type Code") THEN
                  VALIDATE("Shipping Time", OrderingPriceType."Outbound Time")
                ELSE
                  VALIDATE("Shipping Time", SalesHeader."Shipping Time");
            end;
        }
        field(25006730;"Print in Order";Boolean)
        {
            Caption = 'Print in Order';
        }
        field(25006740;"Backorder Date";Date)
        {
            Caption = 'Backorder Date';
        }
        field(25006800;"Variable Field 25006800";Code[20])
        {
            CaptionClass = '7,37,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Sales Line",FIELDNO("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006800",VFOptions.Code);
                 END;
            end;
        }
        field(25006801;"Variable Field 25006801";Code[20])
        {
            CaptionClass = '7,37,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Sales Line",FIELDNO("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006801",VFOptions.Code);
                 END;
            end;
        }
        field(25006802;"Variable Field 25006802";Code[20])
        {
            CaptionClass = '7,37,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Sales Line",FIELDNO("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006802",VFOptions.Code);
                 END;
            end;
        }
        field(25006996;"Variable Field Run 2";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,37,25006996';
        }
        field(25006997;"Variable Field Run 3";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,37,25006997';
        }
        field(25006998;"Has Replacement";Boolean)
        {
            Caption = 'Has Replacement';
        }
        field(25006999;"Requested Item No.";Code[20])
        {
            Caption = 'Requested Item No.';
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";

            trigger OnValidate()
            begin
                CreateDim(
                  DATABASE::"Accountability Center","Accountability Center",
                  DimMgt.TypeToTableID3(Type),"No.",
                  //DATABASE::Job,"Job No.", //DMS
                  DATABASE::"Vehicle Status","Vehicle Status Code", //DMS
                  DATABASE::"Deal Type","Deal Type Code", //DMS
                  DATABASE::Make,"Make Code", //DMS
                  DATABASE::"Payment Method","Payment Method Code", //DMS
                  DATABASE::Vehicle,"Vehicle Serial No.", //DMS
                  DATABASE::Location,"Location Code"      // 10.03.2015 EDMS P21
                  );
            end;
        }
        field(33020235;"Job Type";Code[20])
        {
            TableRelation = "Job Type Master".No. WHERE (Type=CONST(Job));
        }
        field(33020236;"Warranty Approved";Boolean)
        {
        }
        field(33020237;"Approved Date";Date)
        {
        }
        field(33020238;Inventory;Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE (Item No.=FIELD(No.),
                                                                  Location Code=FIELD(Location Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020252;"Scheme Code";Code[20])
        {
            TableRelation = "Service Scheme Header";
        }
        field(33020253;"Membership No.";Code[20])
        {
            TableRelation = "Membership Details";
        }
        field(33020260;"Booked Date";Date)
        {
        }
        field(33020600;"See Reserve Entries";Boolean)
        {
            CalcFormula = Exist("Vehicle Accounting Cycle" WHERE (No.=FIELD(Vehicle Accounting Cycle No.),
                                                                  Vehicle Serial No.=FIELD(Vehicle Serial No.)));
            Description = 'To look up (vehicle reserve entries) vehicle accounting cycle page';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020601;"Sell-to Customer Name 2";Text[70])
        {
            Description = 'Only used for Vehicle Reserve Entries (Vehicle Accounting Cycle)';
        }
        field(33020602;"Board Minute Code";Code[20])
        {
            TableRelation = "Board Minute Master";
        }
        field(33020603;"Returned Invoice No.";Code[20])
        {
        }
        field(33020604;"Item Allocated";Decimal)
        {
            CalcFormula = Sum("Tracking Specification"."Quantity (Base)" WHERE (Source ID=FIELD(Document No.),
                                                                                Item No.=FIELD(No.),
                                                                                Bin Code=FIELD(Bin Code),
                                                                                Source Ref. No.=FIELD(Line No.)));
            FieldClass = FlowField;
        }
        field(33020605;"Forward Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020606;"Forward Location Code";Code[10])
        {
            TableRelation = Location WHERE (WareHouse=CONST(Yes));

            trigger OnValidate()
            begin
                //Min 6.5.2020
                IF "Forward Location Code" <> '' THEN BEGIN
                  Item.RESET;
                  Item.SETRANGE("No.","No.");
                  Item.SETRANGE("Location Filter","Forward Location Code");
                  Item.SETAUTOCALCFIELDS(Inventory);
                  IF Item.FINDFIRST THEN BEGIN
                    IF Item.Inventory < Quantity THEN
                      ERROR(ItemError,"No.","Forward Location Code");
                  END;
                END;
                IF Location.GET("Forward Location Code") THEN
                  "Forward Accountability Center" := Location."Accountability Center";
            end;
        }
        field(33020607;"Quote Forwarded";Boolean)
        {
            Description = 'true if the line is forwarded';
        }
        field(33020608;CBM;Decimal)
        {
            DecimalPlaces = 10:10;
        }
        field(33020620;"HS Code";Code[20])
        {
        }
    }
    keys
    {

        //Unsupported feature: Property Modification (SumIndexFields) on ""Document Type,Document No.,Line No."(Key)".


        //Unsupported feature: Property Modification (SumIndexFields) on ""Document Type,Type,No.,Variant Code,Drop Shipment,Location Code,Shipment Date"(Key)".

        key(Key1;"Document Profile")
        {
        }
        key(Key2;Type,"Line Type","Vehicle Serial No.","Vehicle Accounting Cycle No.")
        {
        }
        key(Key3;"Vehicle Serial No.","Vehicle Assembly ID")
        {
        }
        key(Key4;"Shipment Date","Confirmed Time")
        {
        }
    }


    //Unsupported feature: Code Insertion (VariableCollection) on "OnDelete".

    //trigger (Variable: ItemJnlLine)()
    //Parameters and return type have not been exported.
    //begin
        /*
        */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnDelete".

    //trigger (Variable: DealApplEntry)()
    //Parameters and return type have not been exported.
    //begin
        /*
        */
    //end;


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        TestStatusOpen;
        IF NOT StatusCheckSuspended AND (SalesHeader.Status = SalesHeader.Status::Released) AND
           (Type IN [Type::"G/L Account",Type::"Charge (Item)",Type::Resource])
        THEN
          VALIDATE(Quantity,0);

        IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
          ReserveSalesLine.DeleteLine(Rec);
          CALCFIELDS("Reserved Qty. (Base)");
          TESTFIELD("Reserved Qty. (Base)",0);
          IF "Shipment No." = '' THEN
        #12..37
        IF Type = Type::"Charge (Item)" THEN
          DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");

        CapableToPromise.RemoveReqLines("Document No.","Line No.",0,FALSE);

        IF "Line No." <> 0 THEN BEGIN
          SalesLine2.RESET;
        #45..69
          DeferralUtilities.DeferralCodeOnDelete(
            DeferralUtilities.GetSalesDeferralDocType,'','',
            "Document Type","Document No.","Line No.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        //IF "Dealer PO No." <> '' THEN
        //  ERROR(DealerDelErr);

        #1..8
          //26.02.2008 EDMS P1 >>
           IF "Line Type" = "Line Type"::Vehicle THEN
             VehReserveSalesLine.DeleteLine(Rec);
          //26.02.2008 EDMS P1 <<
        #9..40
        //CapableToPromise.RemoveReqLines("Document No.","Line No.",0,FALSE); //25.08.08 EDMS P1
        CapableToPromise.RemoveReqLines(DATABASE::"Sales Line","Document No.","Line No.",0,FALSE); //25.08.08 EDMS P1
        #42..72
        //EDMS P3>>
        DealApplType.SETRANGE("System Type",DealApplType."System Type"::Leasing);
        IF DealApplType.FINDFIRST THEN
          IF DealApplEntry.GET(DealApplType."No.",0,"Document Type","Document No.","Line No.") THEN
            IF CONFIRM(Text103,FALSE) THEN
              DealApplEntry.DELETE;
        //EDMS P3<<

        UserSetup.GET(USERID);
        IF NOT UserSetup."Vehicle Allotment Modify" THEN
          IF "System Allotment" THEN
            ERROR(AllotedSalesLineErr);
        */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnInsert".

    //trigger (Variable: SalesHeader2)()
    //Parameters and return type have not been exported.
    //begin
        /*
        */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        TestStatusOpen;
        IF Quantity <> 0 THEN
          ReserveSalesLine.VerifyQuantity(Rec,xRec);
        LOCKTABLE;
        SalesHeader."No." := '';
        IF Type = Type::Item THEN
          IF SalesHeader.InventoryPickConflict("Document Type","Document No.",SalesHeader."Shipping Advice") THEN
            ERROR(Text056,SalesHeader."Shipping Advice");
        IF ("Deferral Code" <> '') AND (GetDeferralAmount <> 0) THEN
          UpdateDeferralAmounts;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..3

        //27.07.2007 EDMS P1 >>
         //IF "Document Profile" <> "Document Profile"::"Vehicles Trade" THEN
           //VALIDATE("Vehicle Serial No.",SalesHeader."Vehicle Serial No."); //23.01.2013 EDMS P8
        //27.07.2007 EDMS P1 <<

        #4..10
        */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnModify".

    //trigger (Variable: DealApplEntry)()
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
        #4..11
            UNTIL SalesLine2.NEXT = 0;
        END;

        IF ((Quantity <> 0) OR (xRec.Quantity <> 0)) AND ItemExists(xRec."No.") AND NOT FullReservedQtyIsForAsmToOrder THEN
          ReserveSalesLine.VerifyChange(Rec,xRec);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        UserSetup.GET(USERID);
        IF NOT UserSetup."Vehicle Allotment Modify" THEN
          IF "System Allotment" THEN
            ERROR(AllotedSalesLineErr);

        #1..14
        IF ((Quantity <> 0) OR (xRec.Quantity <> 0)) AND ItemExists(xRec."No.") AND NOT FullReservedQtyIsForAsmToOrder THEN BEGIN
          ReserveSalesLine.VerifyChange(Rec,xRec);
          IF "Line Type" = "Line Type"::Vehicle THEN //24.02.2008 EDMS P1
           VehReserveSalesLine.VerifyChange(Rec,xRec); //24.02.2008 EDMS P1
        END;

        //EDMS P3 >>
        DealApplType.SETRANGE("System Type",DealApplType."System Type"::Leasing);
        IF DealApplType.FINDFIRST THEN
          IF DealApplEntry.GET(DealApplType."No.",0,"Document Type","Document No.","Line No.") THEN
            IF CONFIRM(Text103,FALSE) THEN
              DealApplEntry.DELETE;
        //EDMS P3 <<
        //Agni Incorporate UPG
        IF Type= Type::Item THEN BEGIN
         Item.GET("No.");
         IF Rec.Quantity <> 0 THEN
          CBM := Item.CBM * Rec.Quantity
          ELSE
          CBM := 0;
         END;
         //Agni Incorporate UPG
        */
    //end;


    //Unsupported feature: Code Modification on "OnRename".

    //trigger OnRename()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        ERROR(Text001,TABLECAPTION);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        //ERROR(Text001,TABLECAPTION);
        */
    //end;


    //Unsupported feature: Code Modification on "UpdateUnitPrice(PROCEDURE 2)".

    //procedure UpdateUnitPrice();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF (CalledByFieldNo <> CurrFieldNo) AND (CurrFieldNo <> 0) THEN
          EXIT;

        GetSalesHeader;
        TESTFIELD("Qty. per Unit of Measure");

        CASE Type OF
          Type::Item,Type::Resource:
            BEGIN
              PriceCalcMgt.FindSalesLineLineDisc(SalesHeader,Rec);
              PriceCalcMgt.FindSalesLinePrice(SalesHeader,Rec,CalledByFieldNo);
            END;
        END;
        VALIDATE("Unit Price");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..7
          Type::Item,Type::Resource,Type::"External Service": //07.03.2008. EDMS P2 added  Type::"External Service"
        #9..12
          //20.03.2013 EDMS >>
          Type::"Charge (Item)":
            UpdateItemChargeAssgnt;
          //20.03.2013 EDMS <<

        END;
        VALIDATE("Unit Price");
        */
    //end;


    //Unsupported feature: Code Modification on "UpdatePrepmtSetupFields(PROCEDURE 102)".

    //procedure UpdatePrepmtSetupFields();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF ("Prepayment %" <> 0) AND (Type <> Type::" ") THEN BEGIN
          TESTFIELD("Document Type","Document Type"::Order);
          TESTFIELD("No.");
          IF CurrFieldNo = FIELDNO("Prepayment %") THEN
            IF "System-Created Entry" THEN
              FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text045,0));
          IF "System-Created Entry" THEN
            "Prepayment %" := 0;
          GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
          IF GenPostingSetup."Sales Prepayments Account" <> '' THEN BEGIN
            GLAcc.GET(GenPostingSetup."Sales Prepayments Account");
            VATPostingSetup.GET("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");
            VATPostingSetup.TESTFIELD("VAT Calculation Type","VAT Calculation Type");
          END ELSE
            CLEAR(VATPostingSetup);
          "Prepayment VAT %" := VATPostingSetup."VAT %";
        #17..21
            "Prepayment VAT %" := 0;
          "Prepayment Tax Group Code" := GLAcc."Tax Group Code";
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..3
          GLSetup.GET; //EDMS
        #4..10
            IF GLSetup."Calc.Prepmt.VAT by Line PostGr" THEN //EDMS
              VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group") //EDMS
            ELSE BEGIN
              GLAcc.GET(GenPostingSetup."Sales Prepayments Account");
              VATPostingSetup.GET("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");
              VATPostingSetup.TESTFIELD("VAT Calculation Type","VAT Calculation Type");
            END;
        #14..24
        */
    //end;


    //Unsupported feature: Code Modification on "UpdateAmounts(PROCEDURE 3)".

    //procedure UpdateAmounts();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF CurrFieldNo <> FIELDNO("Allow Invoice Disc.") THEN
          TESTFIELD(Type);
        GetSalesHeader;
        VATBaseAmount := "VAT Base Amount";
        "Recalculate Invoice Disc." := TRUE;

        #7..49
                ("Qty. per Unit of Measure" <> xRec."Qty. per Unit of Measure")) AND // ...continued condition
           ("Document Type" <= "Document Type"::Invoice) AND
           (("Outstanding Amount" + "Shipped Not Invoiced") > 0) AND
           (CurrFieldNo <> FIELDNO("Blanket Order No."))
        THEN
          CustCheckCreditLimit.SalesLineCheck(Rec);

        #57..64
          UpdateDeferralAmounts;
          LineAmountChanged := FALSE;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..3

        //02.01.08 EDMS P1
         IF "Line Type" = "Line Type"::Vehicle THEN
          CheckVehicleDiscount;

        //27.01.2010. EDMS P2 >>
        IF ("Document Profile" IN ["Document Profile"::"Spare Parts Trade", "Document Profile"::Service]) AND
           ((CurrFieldNo = FIELDNO("Line Discount %")) OR (CurrFieldNo = FIELDNO("Line Discount Amount")))
        THEN
          IF Type IN [Type::Item] THEN
            CheckDiscount;
        //27.01.2010. EDMS P2 >>
        #4..52
           (CurrFieldNo <> FIELDNO("Blanket Order No.")) AND
           ("Line Type" <> "Line Type"::Vehicle) //EDMS
        #54..67

        //09.10.2007 EDMS R.Dilson >>
         ApplyMarkupRestrictions(0)
        //09.10.2007 EDMS R.Dilson <<
        */
    //end;


    //Unsupported feature: Code Modification on "CheckItemAvailable(PROCEDURE 4)".

    //procedure CheckItemAvailable();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF Reserve = Reserve::Always THEN
          EXIT;

        IF "Shipment Date" = 0D THEN BEGIN
          GetSalesHeader;
          IF SalesHeader."Shipment Date" <> 0D THEN
        #7..18
          IF ItemCheckAvail.SalesLineCheck(Rec) THEN
            ItemCheckAvail.RaiseUpdateInterruptedError;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..3
        //10.07.2007 EDMS P1 >>
         IF "Line Type" = "Line Type"::Vehicle THEN
          EXIT;
        //10.07.2007 EDMS P1 <<

        #4..21
        */
    //end;

    //Unsupported feature: Parameter Insertion (Parameter: Type4) (ParameterCollection) on "CreateDim(PROCEDURE 26)".


    //Unsupported feature: Parameter Insertion (Parameter: No4) (ParameterCollection) on "CreateDim(PROCEDURE 26)".


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
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        GetSalesHeader;
        #11..14
            SalesHeader."Dimension Set ID",DATABASE::Customer);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        ATOLink.UpdateAsmDimFromSalesLine(Rec);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..7

        //EDMS1.0.00 >>
        TableID[4] := Type4;
        No[4] := No4;
        TableID[5] := Type5;
        No[5] := No5;
        TableID[6] := Type6;
        No[6] := No6;
        TableID[7] := Type7;  //25.10.2013 EDMS P8
        No[7] := No7;
        //EDMS1.0.00 <<
        // 10.03.2015 EDMS P21 >>
        TableID[8] := Type8;
        No[8] := No8;
        // 10.03.2015 EDMS P21 <<

        #8..17
        */
    //end;

    //Unsupported feature: Variable Insertion (Variable: ActualUnitCost) (VariableCollection) on "GetUnitCost(PROCEDURE 5808)".


    //Unsupported feature: Variable Insertion (Variable: Vehicle) (VariableCollection) on "GetUnitCost(PROCEDURE 5808)".



    //Unsupported feature: Code Modification on "GetUnitCost(PROCEDURE 5808)".

    //procedure GetUnitCost();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        GetItem;
        "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
        IF GetSKU THEN
          VALIDATE("Unit Cost (LCY)",SKU."Unit Cost" * "Qty. per Unit of Measure")
        ELSE
          VALIDATE("Unit Cost (LCY)",Item."Unit Cost" * "Qty. per Unit of Measure");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..6
        ELSE BEGIN
          //03.06.2013 Elva Baltic P15 >>
          ActualUnitCost := Item."Unit Cost";   //Unit Cost - by default
          Vehicle.RESET;
          IF ("Line Type" = "Line Type"::Vehicle) AND ("Vehicle Serial No." <> '') THEN
            IF Vehicle.GET("Vehicle Serial No.") THEN BEGIN
              Vehicle.CALCFIELDS(Inventory);
              IF Vehicle.Inventory > 0 THEN
                ActualUnitCost := GetVehUnitCost_ILE;        // if there are Open ILE record
            END;

          VALIDATE("Unit Cost (LCY)",ActualUnitCost * "Qty. per Unit of Measure");
        END
        //03.06.2013 Elva Baltic P15 <<
        */
    //end;

    //Unsupported feature: Variable Insertion (Variable: QtyBase) (VariableCollection) on "CheckApplFromItemLedgEntry(PROCEDURE 157)".



    //Unsupported feature: Code Modification on "CheckApplFromItemLedgEntry(PROCEDURE 157)".

    //procedure CheckApplFromItemLedgEntry();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF "Appl.-from Item Entry" = 0 THEN
          EXIT;

        IF "Shipment No." <> '' THEN
          EXIT;

        TESTFIELD(Type,Type::Item);
        TESTFIELD(Quantity);
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
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
        IF ItemLedgEntry.TrackingExists THEN
          ERROR(Text040,ItemTrackingLines.CAPTION,FIELDCAPTION("Appl.-from Item Entry"));

        IF ABS("Quantity (Base)") > -ItemLedgEntry.Quantity THEN
          ERROR(
            Text046,
            -ItemLedgEntry.Quantity,ItemLedgEntry.FIELDCAPTION("Document No."),
            ItemLedgEntry."Document No.");

        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          IF ABS("Outstanding Qty. (Base)") > -ItemLedgEntry."Shipped Qty. Not Returned" THEN BEGIN
            QtyNotReturned := ItemLedgEntry."Shipped Qty. Not Returned";
            QtyReturned := ItemLedgEntry.Quantity - ItemLedgEntry."Shipped Qty. Not Returned";
            IF "Qty. per Unit of Measure" <> 0 THEN BEGIN
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
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..20
        IF NOT (("Line Type" = "Line Type"::Vehicle) AND (Quantity = 1)) THEN //29.08.2013 EDMS P8
        IF ItemLedgEntry.TrackingExists THEN
            ERROR(Text040,ItemTrackingLines.CAPTION,FIELDCAPTION("Appl.-from Item Entry"));

        CASE TRUE OF
          CurrFieldNo = FIELDNO(Quantity):
            QtyBase := "Quantity (Base)";
          "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]:
            QtyBase := "Return Qty. to Receive (Base)"
          ELSE
            QtyBase := "Qty. to Ship (Base)";
        END;

        IF ABS(QtyBase) > -ItemLedgEntry.Quantity THEN
        #25..30
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
        */
    //end;


    //Unsupported feature: Code Modification on "CalcPrepaymentToDeduct(PROCEDURE 63)".

    //procedure CalcPrepaymentToDeduct();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF ("Qty. to Invoice" <> 0) AND ("Prepmt. Amt. Inv." <> 0) THEN BEGIN
          GetSalesHeader;
          IF ("Prepayment %" = 100) AND NOT IsFinalInvoice THEN
        #4..7
                ("Prepmt. Amt. Inv." - "Prepmt Amt Deducted") *
                "Qty. to Invoice" / (Quantity - "Quantity Invoiced"),Currency."Amount Rounding Precision")
        END ELSE
          "Prepmt Amt to Deduct" := 0
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*

        //02.01.08 EDMS P1 >>
         IF "Line Type" = "Line Type"::Vehicle THEN
          CheckVehicleDiscount;
        //02.01.08 EDMS P1 <<

        //27.01.2010. EDMS P2 >>
        IF ("Document Profile" IN ["Document Profile"::"Spare Parts Trade", "Document Profile"::Service]) AND
           ((CurrFieldNo = FIELDNO("Line Discount %")) OR (CurrFieldNo = FIELDNO("Line Discount Amount")))
        THEN
          IF Type IN [Type::Item] THEN
            CheckDiscount;
        //27.01.2010. EDMS P2 >>

        #1..10
          "Prepmt Amt to Deduct" := 0;

        //09.10.2007 EDMS R.Dilson >>
         ApplyMarkupRestrictions(0)
        //09.10.2007 EDMS R.Dilson <<
        */
    //end;


    //Unsupported feature: Code Modification on "FindLinesWithItemToPlan(PROCEDURE 66)".

    //procedure FindLinesWithItemToPlan();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        FilterLinesWithItemToPlan(Item,DocumentType);
        EXIT(FIND('-'));
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        FilterLinesWithItemToPlan(Item,DocumentType);
        EXIT(NOT ISEMPTY);
        */
    //end;


    //Unsupported feature: Code Modification on "InitHeaderDefaults(PROCEDURE 107)".

    //procedure InitHeaderDefaults();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Quote THEN BEGIN
          IF (SalesHeader."Sell-to Customer No." = '') AND
             (SalesHeader."Sell-to Customer Template Code" = '')
        #4..16
          SalesHeader.TESTFIELD("Sell-to Customer No.");

        "Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
        "Currency Code" := SalesHeader."Currency Code";
        IF NOT IsServiceItem THEN
          "Location Code" := SalesHeader."Location Code";
        #23..30
        "Exit Point" := SalesHeader."Exit Point";
        Area := SalesHeader.Area;
        "Transaction Specification" := SalesHeader."Transaction Specification";
        "Tax Area Code" := SalesHeader."Tax Area Code";
        "Tax Liable" := SalesHeader."Tax Liable";
        IF NOT "System-Created Entry" AND ("Document Type" = "Document Type"::Order) AND (Type <> Type::" ") THEN
          "Prepayment %" := SalesHeader."Prepayment %";
        "Prepayment Tax Area Code" := SalesHeader."Tax Area Code";
        "Prepayment Tax Liable" := SalesHeader."Tax Liable";
        "Responsibility Center" := SalesHeader."Responsibility Center";

        "Shipping Agent Code" := SalesHeader."Shipping Agent Code";
        "Shipping Agent Service Code" := SalesHeader."Shipping Agent Service Code";
        "Outbound Whse. Handling Time" := SalesHeader."Outbound Whse. Handling Time";
        "Shipping Time" := SalesHeader."Shipping Time";
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..19
        "Sell-to Customer Name 2" := SalesHeader."Sell-to Customer Name"; //chandra 06.09.2013
        #20..33
          "Contract No." := SalesHeader."Contract No.";                                     // 17.04.2014 Elva Baltic P21
        VALIDATE("Booked Date",SalesHeader."Booked Date"); //SM to pass Booked date to Sales line
        "Confirmed Time" := SalesHeader."Confirmed Time";

          //EDMS >>
           IF "Document Profile" <> "Document Profile"::"Vehicles Trade" THEN
            BEGIN
             VALIDATE("Vehicle Serial No.",SalesHeader."Vehicle Serial No.");
             VALIDATE("Deal Type Code",SalesHeader."Deal Type Code");
            END;
           VALIDATE("Payment Method Code",SalesHeader."Payment Method Code");
          //EDMS <<
        #34..40
        "Accountability Center" := SalesHeader."Accountability Center";
        #41..45
        */
    //end;

    procedure AutoReserveVehicle()
    var
        QtyToReserve: Decimal;
        QtyToReservebase: Decimal;
    begin
        TESTFIELD("Line Type","Line Type"::Vehicle);
        TESTFIELD("Vehicle Serial No.");

        IF VehReserveSalesLine.ReservQuantity(Rec) <> 0 THEN BEGIN
          VehReservMgt.SetSalesLine(Rec);
          TESTFIELD("Shipment Date");

        // 26.10.2012 EDMS >>
          ReserveSalesLine.ReservQuantity(Rec,QtyToReserve,QtyToReservebase);
          VehReservMgt.AutoReserve(FullAutoReservation,'',QtyToReserve);
        // 26.10.2012 EDMS <<

          FIND;
          IF NOT FullAutoReservation THEN BEGIN
            COMMIT;
            IF CONFIRM(Text104,TRUE) THEN BEGIN
              ShowVehReservation;
              FIND;
            END;
          END;
        END;
    end;

    procedure NewSerialNo()
    var
        InvSetup: Record "313";
        NoSeriesMgt: Codeunit "396";
        SerialNo: Code[20];
    begin
        //EDMS
        IF "Line Type" = "Line Type"::Vehicle THEN BEGIN
         InvSetup.GET;
         InvSetup.TESTFIELD("Vehicle Serial No. Nos.");
         NoSeriesMgt.InitSeries(InvSetup."Vehicle Serial No. Nos.",InvSetup."Vehicle Serial No. Nos.",
            WORKDATE,SerialNo,InvSetup."Vehicle Serial No. Nos.");
         VALIDATE("Vehicle Serial No.",SerialNo);
        END;
    end;

    procedure NewVehAssemblyNo()
    var
        InvSetup: Record "313";
        NoSeriesMgt: Codeunit "396";
        AssemblyNo: Code[20];
    begin
        IF "Line Type" = "Line Type"::Vehicle THEN BEGIN
           InvSetup.GET;
           InvSetup.TESTFIELD("Vehicle Assembly Nos.");
           NoSeriesMgt.InitSeries(InvSetup."Vehicle Assembly Nos.",InvSetup."Vehicle Assembly Nos.",
              WORKDATE,AssemblyNo,InvSetup."Vehicle Assembly Nos.");
           VALIDATE("Vehicle Assembly ID",AssemblyNo);
           MODIFY;
        END;
    end;

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

    procedure UpdateUnitPrice2()
    begin
        UpdateUnitPrice(0);
        UpdateAmounts;
    end;

    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
          GLSetup.GET;
        GLSetupRead := TRUE;
    end;

    procedure NoLookup()
    var
        recItem: Record "27";
        recItemCharge: Record "5800";
        recGLAccount: Record "15";
        recFixedAsset: Record "5600";
        recStandardText: Record "7";
    begin
        //DMS
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
             "Line Type"::"Charge (Item)":
              BEGIN
               recItemCharge.RESET;
               IF LookUpMgt.LookUpItemCharges_Sale(recItemCharge,"No.") THEN
                VALIDATE("No.",recItemCharge."No.");
              END;
             "Line Type"::"G/L Account":
              BEGIN
               recGLAccount.RESET;
               IF LookUpMgt.LookUpGLAccount(recGLAccount,"No.") THEN
                VALIDATE("No.", recGLAccount."No.");
              END;
             "Line Type"::Item:
              BEGIN
               recItem.RESET;
               IF LookUpMgt.LookUpModelVersion(recItem,"No.","Make Code","Model Code") THEN
                VALIDATE("No.",recItem."No.");
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
                VALIDATE("No.", recGLAccount."No.");
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
               IF LookUpMgt.LookUpItemCharges_Sale(recItemCharge,"No.") THEN
                VALIDATE("No.",recItemCharge."No.");
              END;
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
                VALIDATE("No.", recGLAccount."No.");
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
               IF LookUpMgt.LookUpItemCharges_Sale(recItemCharge,"No.") THEN
                VALIDATE("No.",recItemCharge."No.");
              END;
            END;
           END;
         END
    end;

    procedure NewAccCycleNo()
    var
        recInvSetup: Record "313";
        cuNoSeriesMgt: Codeunit "396";
        codCycleNo: Code[20];
        recVehAccCycle: Record "25006024";
        cuVehAccCycle: Codeunit "25006303";
    begin
        //DMS
        IF "Line Type" <> "Line Type"::Vehicle THEN
         EXIT;

        TESTFIELD("Vehicle Serial No.");

        codCycleNo := cuVehAccCycle.GetNewCycleNo;

        recVehAccCycle.INIT;
         recVehAccCycle."No." := codCycleNo;
         recVehAccCycle.VALIDATE("Vehicle Serial No.","Vehicle Serial No.");
         recVehAccCycle.VALIDATE(Default,TRUE);
        recVehAccCycle.INSERT(TRUE);

        VALIDATE("Vehicle Accounting Cycle No.",codCycleNo);
    end;

    procedure VehicleAssembly()
    var
        VehicleAssemby: Record "25006380";
        VehAssemblyWorksheet: Page "25006490";
                                  InvSetup: Record "313";
                                  NoSeriesMgt: Codeunit "396";
                                  VehOptMgt: Codeunit "25006304";
                                  SalesHeader: Record "36";
                                  CurrencyDate: Date;
    begin
        IF "Line Type" <> "Line Type"::Vehicle THEN
         EXIT;

        TESTFIELD("No.");
        TESTFIELD("Vehicle Serial No.");
        TESTFIELD("Make Code");
        TESTFIELD("Model Code");
        TESTFIELD("Model Version No.");

        IF "Vehicle Assembly ID" = '' THEN
          NewVehAssemblyNo;

        VehPriceMgt.ChkAssemblyHdrSalesLine(Rec,FALSE);
        VehOptMgt.FillVehAssembly("Vehicle Serial No.","Vehicle Assembly ID",
          "Make Code","Model Code","Model Version No.");

        GetSalesHeader;

        COMMIT;

         VehicleAssemby.SETRANGE("Assembly ID","Vehicle Assembly ID");
         VehicleAssemby.SETRANGE("Make Code","Make Code");
         VehicleAssemby.SETRANGE("Model Code","Model Code");
         VehicleAssemby.SETRANGE("Model Version No.","Model Version No.");
         VehicleAssemby.SETRANGE("Serial No.","Vehicle Serial No.");

         CLEAR(VehAssemblyWorksheet);

         IF SalesHeader."Document Type" = SalesHeader."Document Type"::Quote THEN
           CurrencyDate := SalesHeader."Document Date"
         ELSE
           CurrencyDate := SalesHeader."Posting Date";

         VehAssemblyWorksheet.SetFCY(SalesHeader."Currency Code",CurrencyDate,SalesHeader."Currency Factor");
         VehAssemblyWorksheet.SETTABLEVIEW(VehicleAssemby);
         VehAssemblyWorksheet.LOOKUPMODE(TRUE);
         VehAssemblyWorksheet.RUNMODAL;
    end;

    procedure VehApplyToPurch()
    var
        recPurchLine: Record "39";
        recSalesLine: Record "37";
    begin
        TestStatusOpen;
        TESTFIELD("Line Type","Line Type"::Vehicle);

        recPurchLine.RESET;
        recPurchLine.SETCURRENTKEY("Document Profile");
        recPurchLine.SETRANGE("Document Profile",recPurchLine."Document Profile"::"Vehicles Trade");
        recPurchLine.SETRANGE("Line Type",recPurchLine."Line Type"::Vehicle);

        IF "Make Code" <> '' THEN
         recPurchLine.SETRANGE("Make Code","Make Code");
        IF "Model Code" <> '' THEN
         recPurchLine.SETRANGE("Model Code","Model Code");
        IF "Model Version No." <> '' THEN
         recPurchLine.SETRANGE("Model Version No.","Model Version No.");

        IF VIN <> '' THEN
         recPurchLine.SETRANGE("Vehicle Serial No.","Vehicle Serial No.");

        IF "Vehicle Assembly ID" <> '' THEN
         recPurchLine.SETFILTER("Vehicle Assembly ID",'<>''''');


        IF PAGE.RUNMODAL(PAGE::"Apply Sales to Purchase Line",recPurchLine) = ACTION::LookupOK THEN
         BEGIN
          //10.06.2008. EDMS P2 >>
          IF "Vehicle Serial No." = '' THEN
            VALIDATE("Vehicle Serial No.",recPurchLine."Vehicle Serial No.");
          IF "Make Code" = '' THEN
            VALIDATE("Make Code",recPurchLine."Make Code");
          IF "Model Code" = '' THEN
            VALIDATE("Model Code",recPurchLine."Model Code");
          IF "Model Version No." = '' THEN
            VALIDATE("Model Version No.",recPurchLine."Model Version No.");

          VALIDATE("Vehicle Accounting Cycle No.",recPurchLine."Vehicle Accounting Cycle No.");
          //10.06.2008. EDMS P2 <<

           VALIDATE("Vehicle Assembly ID",recPurchLine."Vehicle Assembly ID");
         END;
    end;

    procedure GetStat(): Text[30]
    var
        recResEntry: Record "337";
        recResEntry2: Record "337";
        recResEntry3: Record "337";
        InStock: Decimal;
    begin
        IF Quantity = 0 THEN EXIT;
        CALCFIELDS("Reserved Quantity");
        IF "Reserved Quantity" = 0 THEN
         EXIT(tcSER001);
        recResEntry.RESET;
        recResEntry.SETCURRENTKEY
        ("Item No.","Source Type","Source Subtype","Reservation Status","Location Code","Variant Code","Shipment Date",
         "Expected Receipt Date","Serial No.","Lot No.");
        recResEntry.SETRANGE("Source Type", DATABASE::"Sales Line");
        recResEntry.SETRANGE("Source Subtype", "Document Type");
        recResEntry.SETRANGE("Source ID", "Document No.");
        recResEntry.SETRANGE("Source Ref. No.", "Line No.");
        recResEntry.SETRANGE("Reservation Status", recResEntry."Reservation Status"::Reservation);

        IF NOT recResEntry.ISEMPTY THEN BEGIN
          recResEntry.RESET;
          recResEntry.SETRANGE(Positive,TRUE);
          recResEntry.SETRANGE("Entry No.",recResEntry."Entry No.");
          IF recResEntry.FINDFIRST THEN BEGIN
            IF "Reserved Quantity" = recResEntry.Quantity THEN BEGIN
              CASE recResEntry."Source Type" OF
                DATABASE::"Requisition Line":EXIT(tcSER002);
                DATABASE::"Purchase Line": EXIT(tcSER003);
                DATABASE::"Item Ledger Entry": IF "Customer Notification Date" = 0D THEN
                    EXIT(tcSER004)
                   ELSE
                    EXIT(tcSER005);
              END;
            END ELSE BEGIN
              InStock := 0;
              //30.10.2007. EDMS P2 >>
              recResEntry3.RESET;
              recResEntry3.SETCURRENTKEY
               ("Item No.","Source Type","Source Subtype","Reservation Status","Location Code","Variant Code","Shipment Date",
               "Expected Receipt Date","Serial No.","Lot No.");
              recResEntry3.SETRANGE("Source Type", 37);
              recResEntry3.SETRANGE("Source Subtype", "Document Type");
              recResEntry3.SETRANGE("Source ID", "Document No.");
              recResEntry3.SETRANGE("Source Ref. No.", "Line No.");
              recResEntry3.SETRANGE("Reservation Status", recResEntry."Reservation Status"::Reservation);
              IF recResEntry3.FINDSET THEN
                REPEAT
                  IF recResEntry2.GET(recResEntry3."Entry No.", TRUE) AND
                     (recResEntry2."Source Type" = DATABASE::"Item Ledger Entry" )
                  THEN
                      InStock += recResEntry2.Quantity;
                UNTIL recResEntry3.NEXT=0;

              IF InStock = "Reserved Quantity" THEN BEGIN
               //30.10.2007. EDMS P2 <<
                IF "Customer Notification Date" = 0D THEN
                  EXIT(tcSER004)
                ELSE
                  EXIT(tcSER005);
              END ELSE
                IF InStock = 0 THEN
                  EXIT(tcSER003)
                ELSE
                  EXIT(tcSER006);
            END;
          END;
        END;
    end;

    procedure VehTradeIn()
    var
        VehTradeInMgt: Codeunit "25006314";
    begin
        VehTradeInMgt.ApplyTradeIn(Rec)
    end;

    procedure NoAssistEdit()
    var
        NonstockItem: Record "5718";
        NonstockItemMgt: Codeunit "5703";
    begin
        //EDMS
        IF Type = Type::Item THEN
         BEGIN

          //20.08.2008. EDMS P2 >>
          CurrFieldNo := FIELDNO("No.");
          //20.08.2008. EDMS P2 <<

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

        IF "Document Profile" = "Document Profile"::"Vehicles Trade" THEN
         EXIT;

        IF "No." = '' THEN
         EXIT;

        SalesHeader.GET("Document Type","Document No.");

        UserSetup.GET(USERID);
        IF UserSetup."Item Markup Restriction Group" = '' THEN
         EXIT;

        ItemMarkupRestriction.RESET;
        ItemMarkupRestriction.SETFILTER("Group Code",'%1|''''',UserSetup."Item Markup Restriction Group");
        ItemMarkupRestriction.SETFILTER("Customer Price Group",'%1|''''',"Customer Price Group");
        ItemMarkupRestriction.SETFILTER("Item Category Code",'%1|''''',"Item Category Code");
        IF  ItemMarkupRestriction.ISEMPTY THEN
         EXIT;



        LineCost := 0;

        CASE ItemMarkupRestriction.Base OF
         ItemMarkupRestriction.Base::"Unit Cost":
          BEGIN

           //02.07.2008. EDMS P2 >>
           IF "Appl.-to Item Entry" <> 0 THEN BEGIN
             ItemLedgEntry.GET("Appl.-to Item Entry");
             ItemLedgEntry.CALCFIELDS("Cost Amount (Actual)");
             LineCost := ItemLedgEntry."Cost Amount (Actual)" / ItemLedgEntry.Quantity;
           END ELSE BEGIN
             CALCFIELDS("Reserved Quantity");
             IF "Reserved Quantity" <> 0 THEN BEGIN
               ReservationEntry.RESET;
               ReservationEntry.SETCURRENTKEY("Source ID", "Source Ref. No.");
               ReservationEntry.SETRANGE("Source ID", "Document No.");
               ReservationEntry.SETRANGE("Source Ref. No.", "Line No.");
               ReservationEntry.SETRANGE("Source Type", DATABASE::"Sales Line");
               ItemCost2 := 0;
               IF ReservationEntry.FINDFIRST THEN
                 REPEAT
                   ReservationEntry2.GET(ReservationEntry."Entry No.", NOT ReservationEntry.Positive);
                   IF ReservationEntry2."Source Type" = DATABASE::"Item Ledger Entry" THEN BEGIN
                     ItemLedgEntry.GET(ReservationEntry2."Source Ref. No.");
                     ItemLedgEntry.CALCFIELDS("Cost Amount (Actual)");
                     IF ItemCost2 <  ItemLedgEntry."Cost Amount (Actual)" / ItemLedgEntry.Quantity THEN
                       ItemCost2 := ItemLedgEntry."Cost Amount (Actual)" / ItemLedgEntry.Quantity;
                   END;
                 UNTIL ReservationEntry.NEXT = 0;
               LineCost := ItemCost2;
             END;
             IF Item.GET("No.") AND (LineCost = 0) THEN
               LineCost := Item."Unit Cost";
           END;
          //28.02.2008. EDMS P2 <<

          IF "Currency Code" <> '' THEN
           LineSalesPrice := "Line Amount" / SalesHeader."Currency Factor" / "Quantity (Base)"
          ELSE
           LineSalesPrice := "Line Amount" / "Quantity (Base)";

          END;
        END;

        LineCost := ROUND(LineCost, 0.01, '<');
        IF LineCost = 0 THEN
         EXIT;

          //Calculating Sales Price
        IF SalesHeader."Prices Including VAT" THEN
          LineSalesPrice := ROUND(LineSalesPrice / (1 + "VAT %" / 100),0.00001);

         //Apr??inam uzcenojumu
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
             MESSAGE(TextMarkupRestriced,"No.",ItemMarkupRestriction."Min. Markup %",TextPercent);
           END;
         END;
    end;

    procedure CheckVehicleDiscount()
    var
        SingleInstanceMgt: Codeunit "25006001";
        UserProfile: Record "25006067";
        UserProfileMgt: Codeunit "25006002";
    begin
        UserProfile.RESET;
        IF UserProfile.GET(UserProfileMgt.CurrProfileID) THEN
         IF UserProfile."Vehicle Sales Disc. Check" THEN
          IF "Line Discount %" > UserProfile."Vehicle Max Sales Disc.%" THEN
           ERROR(Text102,FIELDCAPTION("Line Discount %"),UserProfile."Vehicle Max Sales Disc.%");
    end;

    procedure ApplyDealDocuments()
    var
        DealDocApplication: Page "25006084";
    begin
        //EDMS P3
        DealDocApplication.SetApplication(1,0,"Document Type","Document No.","Line No.");

        DealDocApplication.RUNMODAL
    end;

    procedure AutoReserve2()
    var
        QtyToReserve: Decimal;
        QtyToReserveBase: Decimal;
        ReservMgt: Codeunit "99000845";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");

        // 26.10.2012 EDMS >>
        ReserveSalesLine.ReservQuantity(Rec,QtyToReserve,QtyToReserveBase);

        IF (QtyToReserve <> 0) THEN BEGIN
        // 26.10.2012 EDMS <<

         ReservMgt.SetSalesLine(Rec);
         TESTFIELD("Shipment Date");

        // 26.10.2012 EDMS >>
         ReserveSalesLine.ReservQuantity(Rec,QtyToReserve,QtyToReserveBase);
         ReservMgt.AutoReserve(FullAutoReservation,'',"Shipment Date",QtyToReserve,QtyToReserveBase);
        // 26.10.2012 EDMS <<

         FIND;
        END;
    end;

    procedure DeleteVehItemTrackingLine(LocationCode: Code[20])
    var
        ReservationEntry: Record "337";
    begin
        ReservationEntry.RESET;
        ReservationEntry.SETCURRENTKEY("Item No.", "Variant Code", "Location Code");
        ReservationEntry.SETRANGE("Item No.", "No.");
        ReservationEntry.SETRANGE("Reservation Status", ReservationEntry."Reservation Status"::Surplus);
        ReservationEntry.SETRANGE("Location Code", LocationCode);
        ReservationEntry.SETRANGE("Source Type", DATABASE::"Sales Line");
        ReservationEntry.SETRANGE("Source ID", "Document No.");
        ReservationEntry.SETRANGE("Source Ref. No.", "Line No.");
        ReservationEntry.SETRANGE("Serial No.", "Vehicle Serial No.");
        IF ReservationEntry.FINDFIRST THEN
          ReservationEntry.DELETE(TRUE);
    end;

    procedure AutoReserveSilent()
    var
        QtyToReserve: Decimal;
        QtyToReserveBase: Decimal;
        ReservMgt: Codeunit "99000845";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");

        // 26.10.2012 EDMS >>
        ReserveSalesLine.ReservQuantity(Rec,QtyToReserve,QtyToReserveBase);

        IF (QtyToReserve <> 0) THEN BEGIN
        // 26.10.2012 EDMS <<
          ReservMgt.SetSalesLine(Rec);
          TESTFIELD("Shipment Date");
        // 26.10.2012 EDMS >>
          ReservMgt.AutoReserve(FullAutoReservation,'',"Shipment Date",QtyToReserve,QtyToReserveBase);
        // 26.10.2012 EDMS <<
          FIND;
        END;
    end;

    procedure ShowVehReservation()
    var
        VehReservation: Page "25006529";
    begin
        TESTFIELD("Line Type","Line Type"::Vehicle);
        TESTFIELD("No.");
        //TESTFIELD(Reserve);
        CLEAR(VehReservation);
        VehReservation.SetSalesLine(Rec);
        VehReservation.RUNMODAL;
    end;

    procedure ShowVehReservationEntries(Modal: Boolean)
    var
        VehReservEngineMgt: Codeunit "25006316";
        VehReserveSalesLine: Codeunit "25006317";
        VehReservEntry: Record "25006392";
    begin
        TESTFIELD("Line Type","Line Type"::Vehicle);
        TESTFIELD("No.");
        VehReservEngineMgt.InitFilterAndSortingLookupFor(VehReservEntry);
        VehReserveSalesLine.FilterReservFor(VehReservEntry,Rec);
        IF Modal THEN
          PAGE.RUNMODAL(PAGE::"Vehicle Reservation Entries",VehReservEntry)
        ELSE
          PAGE.RUN(PAGE::"Vehicle Reservation Entries",VehReservEntry);
    end;

    procedure CheckDiscount()
    var
        SalesDiscount: Record "25006733";
    begin
        IF NOT(Type IN [Type::Item]) THEN
          EXIT;

        IF UserSetup.GET(USERID) THEN BEGIN
          IF UserSetup."SP Sales Disc. Group Code" <> ''  THEN BEGIN
            SalesDiscount.RESET;
            SalesDiscount.SETRANGE("Sales Disc. Group Code", UserSetup."SP Sales Disc. Group Code");
            SalesDiscount.SETRANGE(Type, SalesDiscount.Type::"Item Category");
            SalesDiscount.SETFILTER("No.", '%1|%2', '', "Item Category Code");
            IF SalesDiscount.FINDLAST THEN
              IF "Line Discount %" > SalesDiscount."Max. Discount %" THEN
                ERROR(Text102,FIELDCAPTION("Line Discount %"),SalesDiscount."Max. Discount %");
          END;
        END;
    end;

    procedure TransferLinePrepayment()
    var
        PrepMgt: Codeunit "441";
    begin
        TESTFIELD("Document No.");
        TESTFIELD("No.");
        TESTFIELD("Prepmt. Line Amount");
        PrepMgt.SalesTranfLinePrep(Rec);
    end;

    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.IsVFActive(DATABASE::"Sales Line",intFieldNo));
    end;

    procedure MoveLines(var SalesLineRec: Record "37")
    var
        EDMS001: Label '%1 lines will be processed.\Do you want to proceed?';
    begin
        TestStatusOpen;
        IF SalesLineRec.COUNT = 0 THEN
          EXIT;

        IF CONFIRM(EDMS001,FALSE,SalesLineRec.COUNT) THEN
         REPORT.RUNMODAL(REPORT::"Sales Order-Transfer Line",TRUE,FALSE,SalesLineRec);
    end;

    procedure GetVehUnitCost_ILE(): Decimal
    var
        ItemLedgerEntry: Record "32";
    begin
        //03.06.2013 Elva Baltic P15
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Item No.", Item."No.");
        ItemLedgerEntry.SETRANGE("Serial No.","Vehicle Serial No." );
        ItemLedgerEntry.SETRANGE(Open,TRUE);
        IF ItemLedgerEntry.FINDFIRST THEN BEGIN
          ItemLedgerEntry.CALCFIELDS("Cost Amount (Actual)");
          EXIT(ItemLedgerEntry."Cost Amount (Actual)");
        END ELSE
          EXIT(0);
    end;

    procedure GetReservationColor(): Text[20]
    var
        ResEntry: Record "337";
    begin
        //28.03.2014 Elva Baltic P1 #RX MMG7.00

        FilterSalesLineRes(ResEntry);

        IF ResEntry.ISEMPTY THEN
          EXIT('None');

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

    procedure FilterSalesLineRes(var FilteredResEntry: Record "337")
    var
        ResEntryNegative: Record "337";
        ResEntryTransferOutg: Record "337";
    begin
        //27.03.2014 Elva Baltic P1 #RX MMG7.00

        ResEntryNegative.RESET;
        ResEntryNegative.SETCURRENTKEY("Source ID","Source Ref. No.","Source Type","Source Subtype");
        ResEntryNegative.SETRANGE("Source ID","Document No.");
        ResEntryNegative.SETRANGE("Source Ref. No.","Line No.");
        ResEntryNegative.SETRANGE("Source Type",DATABASE::"Sales Line");
        ResEntryNegative.SETRANGE("Source Subtype",1);
        ResEntryNegative.SETRANGE("Reservation Status",ResEntryNegative."Reservation Status"::Reservation);
        IF ResEntryNegative.FINDFIRST THEN
          REPEAT
            FilteredResEntry.GET(ResEntryNegative."Entry No.",TRUE);
            FilteredResEntry.MARK(TRUE);
          UNTIL ResEntryNegative.NEXT = 0;
        FilteredResEntry.MARKEDONLY(TRUE)
    end;

    procedure CreateVehicle()
    var
        VINInput: Page "25006493";
                      Vehicle: Record "25006005";
                      NewVIN: Code[20];
                      Vehicle2: Record "25006005";
                      SalesLine: Record "37";
                      tcAMT001: Label 'VIN %1 already exists.';
    begin
        TESTFIELD("Make Code");
        TESTFIELD("Model Code");
        TESTFIELD("Model Version No.");
        TESTFIELD("Vehicle Serial No.");
        CALCFIELDS("Vehicle Exists");
        TESTFIELD("Vehicle Exists",FALSE);

        CLEAR(VINInput);
        VINInput.fSetData("Make Code","Model Code","Model Version No.",
          "Vehicle Serial No.","Vehicle Body Color Code","Vehicle Interior Code");
        IF VINInput.RUNMODAL <> ACTION::OK THEN
         EXIT;


        NewVIN := VINInput.fGetNewVin;
        //IF NewVIN = '' THEN
        // EXIT;

        Vehicle.RESET;

        Vehicle.INIT;
         Vehicle.VALIDATE("Serial No.","Vehicle Serial No.");
         Vehicle.VALIDATE(VIN,NewVIN);
         Vehicle.VALIDATE("Make Code","Make Code");
         Vehicle.VALIDATE("Model Code","Model Code");
         Vehicle.VALIDATE("Model Version No.","Model Version No.");
         Vehicle.VALIDATE("Status Code","Vehicle Status Code");
         Vehicle.VALIDATE("Body Color Code","Vehicle Body Color Code");
         Vehicle.VALIDATE("Interior Code","Vehicle Interior Code");
        Vehicle.INSERT(TRUE);
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

        IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN //Agni Incorporate UPG
         VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
    end;

    procedure DoNotAllowDeletionServiceLines()
    begin
    end;

    procedure CheckNonBillableCustomer(): Boolean
    var
        Customer: Record "18";
    begin
        IF "Sell-to Customer No." <> '' THEN BEGIN
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
        END;
    end;

    procedure ChangeQtyPrice(): Boolean
    var
        CanChangeQty: Boolean;
        CanChangePrice: Boolean;
        CannotChangeQty: Label 'You cannot Change Qty. field in Invoice %1.';
        CannotChangePrice: Label 'You cannot Change Price in Invoice %1.';
        UserSetup: Record "91";
    begin
        UserSetup.GET(USERID);
        CanChangeQty := TRUE;
        CanChangePrice := FALSE;
        IF UserSetup."Allow Correcting Serv-Inv" THEN
          CanChangePrice := TRUE;
        IF ("Document Type" = "Document Type"::Invoice) OR ("Document Type" = "Document Type"::Order)THEN BEGIN
          CanChangeQty := FALSE;
          IF Type IN [Type::"G/L Account",Type::"External Service"] THEN BEGIN
            CanChangeQty := TRUE;
            CanChangePrice := TRUE;
          END;
        END;
        IF (NOT CanChangeQty) AND (Rec.Quantity<>xRec.Quantity) THEN
          IF (NOT UserSetup."Allow Correcting Serv-Inv") THEN
            ERROR(CannotChangeQty,"Document No.")
          ELSE BEGIN
            IF Type = Type::Item THEN BEGIN
              IF Rec.Quantity > xRec.Quantity THEN
                MESSAGE('Make Sure you have transfered required Qty. to Service.')
              ELSE IF xRec.Quantity > Quantity THEN
                MESSAGE('Please transfer %1 Qty. of Item %2 to Store.',xRec.Quantity-Rec.Quantity,"No.");
            END;
          END;
        IF (NOT CanChangePrice) AND (Rec."Unit Price"<>xRec."Unit Price") THEN
          ERROR(CannotChangePrice,"Document No.");
    end;

    procedure CheckVehicleInventory(VehSerialNo: Code[20])
    var
        Vehicle: Record "25006005";
        Text000: Label 'Vehicle %1 is already on Inventory.';
    begin
        Vehicle.RESET;
        Vehicle.SETRANGE("Serial No.",VehSerialNo);
        IF Vehicle.FINDFIRST THEN BEGIN
          Vehicle.CALCFIELDS(Inventory);
          IF Vehicle.Inventory >=1 THEN
            ERROR(Text000,Vehicle.VIN);
        END;
    end;

    procedure VehMaxSalesDiscCheck()
    var
        MaxDiscountError: Label 'The maximum discount you can offer is %1. Please contact the authorized person for the related discount amount.';
    begin

        IF ("Document Profile" = "Document Profile"::"Vehicles Trade") AND (COMPANYNAME = 'Agni Incorporated Pvt. Ltd.') THEN BEGIN
            Customer.RESET;
            Customer.SETRANGE("No.","Sell-to Customer No.");
            IF Customer.FINDFIRST THEN BEGIN
               IF Customer."Is Dealer" = FALSE THEN BEGIN
                  SalesHeader2.RESET;
                  SalesHeader2.SETRANGE("No.","Document No.");
                  IF SalesHeader2.FINDFIRST THEN BEGIN
                      SalesHeader2.TESTFIELD("Posting Date");
                      MaxVehDiscount.RESET;
                      UserSetup.GET(USERID);
                      MaxVehDiscount.SETRANGE("User ID",USERID);
                      MaxVehDiscount.SETFILTER("Model Version Filter",'%1','*'+"Model Version No."+'*');
                      MaxVehDiscount.SETFILTER("Starting Date",'<=%1',SalesHeader2."Posting Date");
                      IF MaxVehDiscount.FINDLAST THEN BEGIN
                         MaxVehDiscountMaster.RESET;
                         MaxVehDiscountMaster.SETRANGE("User ID",USERID);
                         MaxVehDiscountMaster.SETFILTER("Model Version Filter",'%1','*'+"Model Version No."+'*');
                         MaxVehDiscountMaster.SETRANGE(Blocked,FALSE);
                         IF MaxVehDiscountMaster.FINDFIRST THEN BEGIN
                               IF "Inv. Discount Amount" > MaxVehDiscount."Max. Discount Amount" THEN
                               ERROR(
                                     MaxDiscountError,
                                         MaxVehDiscount."Max. Discount Amount");
                         END ELSE
                             ERROR('The Discount Limit has been blocked!!!');
                      END ELSE
                          ERROR('The Discount Limit has been blocked!!!');
                  END;
               END;
            END;
        END;
    end;

    procedure AllocateCustomer()
    var
        CustAllocationSales: Record "33019860";
        Customer: Record "18";
        Item: Record "27";
    begin
        //*** SM 25/06/2013 To flow the data to customer allocation table.
        IF "Document Profile" = "Document Profile"::"Vehicles Trade" THEN BEGIN
          CustAllocationSales.INIT;
          CustAllocationSales."Sales Order No." := "Document No.";
          CustAllocationSales."Customer No." := "Sell-to Customer No.";
          CustAllocationSales."Model Version No." := "Model Version No.";
          CustAllocationSales."Booked Date" := "Booked Date";
          CustAllocationSales.INSERT(TRUE);
        END;
    end;

    local procedure "--QR19.00--"()
    begin
    end;

    procedure IsQRCodeMandatory(): Boolean
    var
        QRMgt: Codeunit "50006";
    begin
        GetSalesHeader;
        CLEAR(QRMgt);
        EXIT(QRMgt.IsQRCodeMandatory(SalesHeader."Location Code"));
    end;

    local procedure InvDiscountAmountEditable()
    var
        SalesShipmentHdr: Record "110";
    begin
        SalesShipmentHdr.RESET;
        SalesShipmentHdr.SETRANGE("Order No.", "Document No.");
        IF SalesShipmentHdr.FINDSET THEN BEGIN
          IF "Document Profile" = "Document Profile"::"Vehicles Trade" THEN
            ShipmentControl := TRUE;
        END;
    end;

    var
        SalesSetup: Record "311";
        ItemSubstSync: Codeunit "25006513";
        Itm: Record "27";
        ItmAttVal: Record "7505";
        ItmVal: Record "7500";
        ItmAVal: Record "7501";
        Dec: Decimal;

    var
        NewLocationCode: Code[20];
        lSalesReceiveableSetup: Record "311";

    var
        ItemSubstSync: Codeunit "25006513";
        Itm: Record "27";
        ItmAttVal: Record "7505";
        ItmVal: Record "7500";
        ItmAVal: Record "7501";
        Dec: Decimal;

    var
        Customer: Record "18";

    var
        ItemJnlLine: Record "83";

    var
        DealApplEntry: Record "25006053";
        DealApplType: Record "25006055";

    var
        SalesHeader2: Record "36";

    var
        DealApplEntry: Record "25006053";
        DealApplType: Record "25006055";

    var
        UserSetup: Record "91";

    var
        GLSetup: Record "98";
        UserProfile: Record "25006067";

    var
        SingleInstanceMgt: Codeunit "25006001";

    var
        LookUpMgt: Codeunit "25006003";
        recDMSLabor: Record "25006121";
        recDMSExternal: Record "25006133";
        tcSER001: Label 'Customer''s Request';
        tcSER002: Label 'Requisition Worksheet';
        tcSER003: Label 'Purchase Order';
        tcSER004: Label 'In Stock';
        tcSER005: Label 'In Stock - Informed';
        tcSER006: Label 'Partly in Stock';
        EDMS001: Label 'Vehicle %1 exist in other sales order.';
        VehPriceMgt: Codeunit "25006301";
        Text102: Label '%1 cannot be greater than %2.';
        ExternalService: Record "25006133";
        LicensePermission: Record "2000000043";
        Text103: Label 'There are linked deal documents. All links will be deleted. Are you sure you want to change this line?';
        VehReserveSalesLine: Codeunit "25006317";
        VehReservMgt: Codeunit "25006300";
        Text104: Label 'Automatic reservation is not possible.\Reserve vehicle manually?';
        VFMgt: Codeunit "25006004";
        Text26500: Label 'You must check field %1 in %2 to be able to change the %3 field manually.';
        GLSetupRead: Boolean;
        Text105: Label 'There is no vehicle with Registration No. %1';
        UserProfileMgt: Codeunit "25006002";
        SalesLine3: Record "37";
        VehRec: Record "25006005";
        Customer: Record "18";
        MaxVehDiscount: Record "33019861";
        SalesHeader2: Record "36";
        MaxVehDiscountMaster: Record "33019869";
        NoValidUnitPrice: Label 'You Cannot Enter Unit Price for Non-Billable Customer %1.';
        CustomerError: Label 'Customer No. in Vehicle Card is different from Sell-to Customer No. Please Change the Vehicle Booking.';
        AllotedSalesLineErr: Label 'You cannot delete or modify the sales line as vehicle is alloted by the system.';
        DealerDelErr: Label 'You cannot delete the Sales lines created from Dealer Portal.';
        ItemError: Label 'The Inventory of Item No. %1 is not in Availabel in Location %2.';
        Vehicle: Record "25006005";
        ShipmentControl: Boolean;
        InventorySetup: Record "313";
}


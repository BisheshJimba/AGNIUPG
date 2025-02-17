tableextension 50124 tableextension50124 extends Item
{
    // 05.06.2015 EB.P21 #T0047
    //   Modified function:
    //     FillItemGroupDefDim
    // 
    // 19.11.2014 EB.P8 EDMS
    //   Hotfix in GetSalesQty for multilanguage
    // 
    // 22.05.2014 EDMS P8
    //   * MERGE with last changes
    // 
    // 15.04.2013 EDMS P8
    //   * Removed ISSERVICETIER
    // 
    // 04.02.2013 EDMS P8
    //   * LOOKUP for fld "Qty. on Service Order EDMS"
    // 
    // 27.01.2010 EDMS P2
    //   * Added field "Item Price Group", "Item Category Code"-OnValidate
    // 
    // 22.10.2008. EDMS P2
    //   * Added code "Item Category Code - OnValidate()"
    // 
    // 09.07.08 EDMS P1 - EDMS Service Management integration
    //   * Added fields "Qty. on Service Order EDMS" and "Res. Qty. on Serv. Orders EDMS"
    // 
    // 03.09.2007. EDMS P2
    //   * Added code "Item Category Code - OnValidate()"
    // 
    // 05.07.2007. EDMS P2
    //   * Added function FillItemGroupDefDim
    //   * Added new code on triger Item Category Code - On Validate
    // 
    // 10.05.2007 EDMS P2
    //   * Added code to trigger "Product Subgroup Code" - OnValidate
    //   * Added code to trigger "Item Category Code" - OnValidate
    //   * Added code to trigger "Product Group Code" - OnValidate
    fields
    {

        //Unsupported feature: Property Insertion (Editable) on ""Unit Price"(Field 18)".


        //Unsupported feature: Property Insertion (MaxValue) on ""Profit %"(Field 20)".


        //Unsupported feature: Property Insertion (Editable) on ""Profit %"(Field 20)".


        //Unsupported feature: Property Modification (Editable) on ""Cost is Adjusted"(Field 29)".


        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 53)".


        //Unsupported feature: Property Modification (CalcFormula) on "Inventory(Field 68)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Net Invoiced Qty."(Field 69)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Net Change"(Field 70)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Purchases (Qty.)"(Field 71)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Sales (Qty.)"(Field 72)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Positive Adjmt. (Qty.)"(Field 73)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Negative Adjmt. (Qty.)"(Field 74)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Purchases (LCY)"(Field 77)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Sales (LCY)"(Field 78)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Positive Adjmt. (LCY)"(Field 79)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Negative Adjmt. (LCY)"(Field 80)".


        //Unsupported feature: Property Modification (CalcFormula) on ""COGS (LCY)"(Field 83)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Purch. Order"(Field 84)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Sales Order"(Field 85)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Transferred (Qty.)"(Field 93)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Transferred (LCY)"(Field 94)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. on Inventory"(Field 101)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. on Purch. Orders"(Field 102)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. on Sales Orders"(Field 103)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Res. Qty. on Outbound Transfer"(Field 107)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Res. Qty. on Inbound Transfer"(Field 108)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Res. Qty. on Sales Returns"(Field 109)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Res. Qty. on Purch. Returns"(Field 110)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Cost of Open Production Orders"(Field 200)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Res. Qty. on Assembly Order"(Field 929)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Res. Qty. on  Asm. Comp."(Field 930)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Assembly Order"(Field 977)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Asm. Component"(Field 978)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Job Order"(Field 1001)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Res. Qty. on Job Order"(Field 1002)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Scheduled Receipt (Qty.)"(Field 5420)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Scheduled Need (Qty.)"(Field 5421)".


        //Unsupported feature: Property Modification (Data type) on ""Variant Filter"(Field 5424)".

        modify("Sales Unit of Measure")
        {
            TableRelation = IF (No.=FILTER(<>'')) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }
        modify("Purch. Unit of Measure")
        {
            TableRelation = IF (No.=FILTER(<>'')) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. on Prod. Order"(Field 5429)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Res. Qty. on Prod. Order Comp."(Field 5430)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Res. Qty. on Req. Line"(Field 5431)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Planning Transfer Ship. (Qty)."(Field 5449)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Planning Worksheet (Qty.)"(Field 5450)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Substitutes Exist"(Field 5706)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. in Transit"(Field 5707)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Trans. Ord. Receipt (Qty.)"(Field 5708)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Trans. Ord. Shipment (Qty.)"(Field 5709)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. Assigned to ship"(Field 5776)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. Picked"(Field 5777)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Service Order"(Field 5901)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Res. Qty. on Service Orders"(Field 5902)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Purch. Return"(Field 6650)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Sales Return"(Field 6660)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Substitutes"(Field 7171)".

        modify("Put-away Unit of Measure Code")
        {
            TableRelation = IF (No.=FILTER(<>'')) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Last Phys. Invt. Date"(Field 7383)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Planning Issues (Qty.)"(Field 99000761)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Planning Receipt (Qty.)"(Field 99000762)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Planned Order Receipt (Qty.)"(Field 99000765)".


        //Unsupported feature: Property Modification (CalcFormula) on ""FP Order Receipt (Qty.)"(Field 99000766)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Rel. Order Receipt (Qty.)"(Field 99000767)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Planning Release (Qty.)"(Field 99000768)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Planned Order Release (Qty.)"(Field 99000769)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Purch. Req. Receipt (Qty.)"(Field 99000770)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Purch. Req. Release (Qty.)"(Field 99000771)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Prod. Forecast Quantity (Base)"(Field 99000774)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Prod. Order"(Field 99000777)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Qty. on Component Lines"(Field 99000778)".



        //Unsupported feature: Code Modification on ""Base Unit of Measure"(Field 8).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "Base Unit of Measure" <> xRec."Base Unit of Measure" THEN BEGIN
              TestNoOpenEntriesExist(FIELDCAPTION("Base Unit of Measure"));

            #4..17
                END;
              END;
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..20

            //Sipradi-YS 8.16.2012
            VALIDATE("Sales Unit of Measure","Base Unit of Measure");
            VALIDATE("Purch. Unit of Measure","Base Unit of Measure");
            //Sipradi-YS END
            */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Inventory Posting Group"(Field 11).OnValidate".

        //trigger (Variable: InvPostingGrp)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on ""Inventory Posting Group"(Field 11).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "Inventory Posting Group" <> '' THEN
              TESTFIELD(Type,Type::Inventory);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            IF "Inventory Posting Group" <> '' THEN BEGIN
              TESTFIELD(Type,Type::Inventory);
            END;
            //***SM to control the entry of item with blank unit of measure
            TESTFIELD("Base Unit of Measure");

            //Agni UPG 2009 >>
            //TestNoEntriesExist("Inventory Posting Group");
            //Agni UPG 2009 <<
            */
        //end;


        //Unsupported feature: Code Modification on ""Costing Method"(Field 21).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "Costing Method" = xRec."Costing Method" THEN
              EXIT;

            #4..16
            END;

            TestNoEntriesExist(FIELDCAPTION("Costing Method"));

            ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Costing Method"));
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..19
            //EDMS >>
            IF NOT NewEntry THEN
            //EDMS >>
              ItemCostMgt.UpdateUnitCost(Rec,'','',0,0,FALSE,FALSE,TRUE,FIELDNO("Costing Method"));
            */
        //end;


        //Unsupported feature: Code Insertion on ""Tariff No."(Field 47)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            IF "Tariff No." <> '' THEN
              IF NOT TariffNumber.GET("Tariff No.") THEN
                  ERROR('The HS Code does not exist.')
            */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Gen. Prod. Posting Group"(Field 91).OnValidate".

        //trigger (Variable: ItemLedgEntry)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on ""Gen. Prod. Posting Group"(Field 91).OnValidate".

        //trigger  Prod()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" THEN BEGIN
              IF CurrFieldNo <> 0 THEN
                IF ProdOrderExist THEN
            #4..12
              IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") THEN
                VALIDATE("VAT Prod. Posting Group",GenProdPostingGrp."Def. VAT Prod. Posting Group");
            END;

            VALIDATE("Price/Profit Calculation");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            //***SM to control the entry of item with blank unit of measure
            TESTFIELD("Base Unit of Measure");

            #1..15
            //Agni UPG 2009 >>
            // TestNoEntriesExist(FIELDCAPTION("Gen. Prod. Posting Group"));
            VALIDATE("Inventory Posting Group",GenProdPostingGrp."Def. Inventory Posting Group");
            //Agni UPG 2009 <<

            VALIDATE("Price/Profit Calculation");
            */
        //end;


        //Unsupported feature: Code Modification on ""VAT Prod. Posting Group"(Field 99).OnValidate".

        //trigger  Posting Group"(Field 99)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            VALIDATE("Price/Profit Calculation");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            //***SM to control the entry of item with blank unit of measure
            TESTFIELD("Base Unit of Measure");

            VALIDATE("Price/Profit Calculation");
            */
        //end;


        //Unsupported feature: Code Modification on ""Item Category Code"(Field 5702).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            ItemAttributeManagement.InheritAttributesFromItemCategory(Rec,"Item Category Code",xRec."Item Category Code");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            ItemAttributeManagement.InheritAttributesFromItemCategory(Rec,"Item Category Code",xRec."Item Category Code");
            //Upgrade 2017 >>
            IF ("Item Category Code" <> xRec."Item Category Code") OR NewEntry THEN BEGIN
              IF ItemCategory.GET("Item Category Code") THEN BEGIN
                //EDMS >>
                VALIDATE(Reserve, ItemCategory.Reserve);
                VALIDATE("Item Tracking Code", ItemCategory."Item Tracking Code");
                //EDMS <<
              END;
              // 10.05.2007 EDMS P2 >>
              IF NOT ProductSubgrp.GET("Item Category Code","Product Group Code", "Product Subgroup Code") THEN
                VALIDATE("Product Subgroup Code",'')
              ELSE
                VALIDATE("Product Subgroup Code");
              // 10.05.2007 EDMS P2 <<
            END;
            //Upgrade 2017 <<
            */
        //end;


        //Unsupported feature: Code Insertion on ""Product Group Code"(Field 5704)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //var
            //ProductSubgrp: Record "25006746";
        //begin
            /*
            */
        //end;
        field(50000;"Item For";Option)
        {
            Caption = 'Item For';
            OptionCaption = ' ,GPD,SPD,VHD,BTD,LBD,CVD,PCD';
            OptionMembers = " ",GPD,SPD,VHD,BTD,LBD,CVD,PCD;
        }
        field(50001;Ton;Decimal)
        {
            Description = 'Fo Model Version';
        }
        field(50002;CC;Integer)
        {
            Description = 'Fo Model Version';
        }
        field(50003;"Seat Capacity";Integer)
        {
            Description = 'Fo Model Version';
        }
        field(50004;"Bin Code";Code[20])
        {
            CalcFormula = Lookup("Bin Content"."Bin Code" WHERE (Item No.=FIELD(No.),
                                                                 Location Code=FIELD(Location Filter)));
            FieldClass = FlowField;
        }
        field(50005;"Average Issue";Decimal)
        {
            CalcFormula = Lookup("Stockkeeping Unit"."Average Issue Per Month" WHERE (Item No.=FIELD(No.),
                                                                                      Location Code=FIELD(Location Filter)));
            FieldClass = FlowField;
        }
        field(50006;"Scrap Amount";Decimal)
        {
        }
        field(50007;"Invoiced Inventory Value";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE (Item No.=FIELD(No.),
                                                                          Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                          Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                          Location Code=FIELD(Location Filter),
                                                                          Drop Shipment=FIELD(Drop Shipment Filter),
                                                                          Variant Code=FIELD(Variant Filter),
                                                                          Posting Date=FIELD(Date Filter)));
            Caption = 'Invoiced Inventory Value';
            Description = 'Calculated  (for Jet reports - inventory turnover ratio) by chandra 05.07.2014';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008;"Received Inventory Value";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Cost Amount (Expected)" WHERE (Item No.=FIELD(No.),
                                                                            Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                            Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Drop Shipment=FIELD(Drop Shipment Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Posting Date=FIELD(Date Filter)));
            Caption = 'Received Inventory Value';
            Description = 'Calculated  (for Jet reports - inventory turnover ratio) by chandra 05.07.2014';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009;ABC;Option)
        {
            OptionCaption = ' ,A,B,C,D,E';
            OptionMembers = " ",A,B,C,D,E;
        }
        field(50010;"Margin Percentage";Decimal)
        {
        }
        field(50011;"MOQ (Dealer)";Integer)
        {
        }
        field(60000;"Qty. In Transfer Order";Integer)
        {
            CalcFormula = Count("Transfer Line" WHERE (Model Version No.=FIELD(No.),
                                                       Transfer-to Code=FIELD(Location Filter),
                                                       Allotment Date=FIELD(Date Filter),
                                                       Tender=CONST(No),
                                                       Transfer-from Code=CONST(AGNI-CORP),
                                                       Qty. Received (Base)=CONST(0)));
            FieldClass = FlowField;
        }
        field(60001;"Qty. In Tender";Integer)
        {
            CalcFormula = Count("Transfer Line" WHERE (Model Version No.=FIELD(No.),
                                                       Transfer-to Code=FIELD(Location Filter),
                                                       Allotment Date=FIELD(Date Filter),
                                                       Tender=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(60002;"Qty. in SO";Integer)
        {
            CalcFormula = Count("Sales Line" WHERE (Document Type=CONST(Order),
                                                    Document Profile=CONST(Vehicles Trade),
                                                    Model Version No.=FIELD(No.),
                                                    Location Code=FIELD(Location Filter),
                                                    Shipment Date=FIELD(Date Filter)));
            FieldClass = FlowField;
        }
        field(60100;"Item Movement Category";Option)
        {
            OptionCaption = ' ,EF,MF,RF,NPA';
            OptionMembers = " ",EF,MF,RF,NPA;
        }
        field(70000;"Skip in Vehicle Order Report";Boolean)
        {
        }
        field(70001;"Supplier Code";Code[10])
        {
            Description = 'QR19.00';
            TableRelation = Supplier;
        }
        field(25006370;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            Description = 'Only for Vehicle Trade';
            TableRelation = Make;
        }
        field(25006371;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            Description = 'Only for Vehicle Trade';
            TableRelation = Model.Code;
        }
        field(25006670;"Item Type";Option)
        {
            Caption = 'Item Type';
            OptionCaption = ' ,Item,Model Version';
            OptionMembers = " ",Item,"Model Version";
        }
        field(25006671;"Replacement Status";Option)
        {
            Caption = 'Replacement Status';
            OptionCaption = ' ,Is Being Replaced,Replaced';
            OptionMembers = " ",Replaced;
        }
        field(25006672;"Product Subgroup Code";Code[10])
        {
            Caption = 'Product Subgroup Code';
            TableRelation = "Product Subgroup".Code WHERE (Item Category Code=FIELD(Item Category Code),
                                                           Product Group Code=FIELD(Product Group Code));
        }
        field(25006673;"Replacements Exist";Boolean)
        {
            CalcFormula = Exist("Item Substitution" WHERE (Type=CONST(Nonstock Item),
                                                           No.=FIELD(No.),
                                                           Entry Type=CONST(Replacement)));
            Caption = 'Replacements Exist';
            Description = 'P15';
            FieldClass = FlowField;
        }
        field(25006676;"Qty. on Service Order EDMS";Decimal)
        {
            CalcFormula = Sum("Service Line EDMS".Quantity WHERE (Document Type=CONST(Order),
                                                                  Type=CONST(Item),
                                                                  No.=FIELD(No.),
                                                                  Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                  Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                  Location Code=FIELD(Location Filter),
                                                                  Variant Code=FIELD(Variant Filter)));
            Caption = 'Qty. on Service Order EDMS';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                ServiceLine: Record "25006146";
                ServiceLinesPrep: Page "25006191";
                                      ServiceLinesPrepPage: Page "25006165";
            begin
                //04.02.2013 EDMS P8 >>
                ServiceLine.RESET;
                ServiceLine.SETRANGE("Document Type", ServiceLine."Document Type"::Order);
                ServiceLine.SETRANGE(Type, ServiceLine.Type::Item);
                ServiceLine.SETRANGE("No.", "No.");
                ServiceLine.SETFILTER("Shortcut Dimension 1 Code", "Global Dimension 1 Filter");
                ServiceLine.SETFILTER("Shortcut Dimension 2 Code", "Global Dimension 2 Filter");
                ServiceLine.SETFILTER("Location Code", "Location Filter");
                ServiceLine.SETFILTER("Variant Code", "Variant Filter");
                PAGE.RUNMODAL(PAGE::"Service Lines Prep EDMS", ServiceLine);  //15.04.2013 EDMS P8
                //04.02.2013 EDMS P8 <<
            end;
        }
        field(25006678;"Res. Qty. on Serv. Orders EDMS";Decimal)
        {
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(No.),
                                                                            Source Type=CONST(25006146),
                                                                            Source Subtype=CONST(1),
                                                                            Reservation Status=CONST(Reservation),
                                                                            Location Code=FIELD(Location Filter),
                                                                            Variant Code=FIELD(Variant Filter),
                                                                            Shipment Date=FIELD(Date Filter)));
            Caption = 'Res. Qty. on Serv. Orders EDMS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006680;"Seasonal Factor Code";Code[10])
        {
            Caption = 'Seasonal Factor Code';
            TableRelation = "Seasonal Factor";
        }
        field(25006690;"Exchange Unit";Boolean)
        {
            Caption = 'Exchange Unit';

            trigger OnValidate()
            var
                recNonstockItem: Record "5718";
            begin
            end;
        }
        field(25006900;"Item Price Group Code";Code[10])
        {
            Caption = 'Item Price Group Code';
            TableRelation = "Item Price Group";
        }
        field(33019831;"Item Class";Option)
        {
            OptionCaption = ' ,A,B,C';
            OptionMembers = " ",A,B,C;
        }
        field(33019832;"Is NLS";Boolean)
        {
        }
        field(33019833;"Model Filter 1";Code[250])
        {
            Editable = false;
        }
        field(33019834;"Model Filter 2";Code[250])
        {
            Editable = false;
        }
        field(33019835;"Customer Price Group";Code[10])
        {
            Editable = true;
            FieldClass = FlowFilter;
            TableRelation = "Customer Price Group";
        }
        field(33019836;"Unit Sales Price with VAT";Decimal)
        {
            AutoFormatType = 2;
            CalcFormula = Lookup("Sales Price"."Unit Price" WHERE (Item No.=FIELD(No.),
                                                                   Sales Code=FIELD(Customer Price Group)));
            Caption = 'Unit Sales Price with VAT';
            Editable = false;
            FieldClass = FlowField;
            MinValue = 0;
        }
        field(33019837;"Max Unit Price";Decimal)
        {
            CalcFormula = Max("Sales Price"."Unit Price" WHERE (Item No.=FIELD(No.),
                                                                Sales Code=FIELD(Customer Price Group)));
            Description = 'Calculated from Sales price table (for Jet reports) by chandra 30.09.2013';
            FieldClass = FlowField;
        }
        field(33019884;"NDP Rate";Decimal)
        {
        }
        field(33019885;"Scrap No.";Code[20])
        {
            TableRelation = Item.No. WHERE (Item For=CONST(BTD));
        }
        field(33019886;IsScrap;Boolean)
        {
        }
        field(33019887;"Ampere Per Hour";Decimal)
        {
        }
        field(33019888;"Multiple Price Group (MPG)";Code[10])
        {
            TableRelation = "Multiple Price Group (NDP)";
        }
        field(33019889;"Modification Date";Date)
        {
        }
        field(33019890;"Purchase Type";Option)
        {
            OptionCaption = ' ,Local,VOR,Import';
            OptionMembers = " ","Local",VOR,Import;
        }
        field(99008501;"Local Parts";Boolean)
        {
        }
        field(99008502;Saved;Boolean)
        {
        }
        field(99008503;"Model No";Code[30])
        {
            Caption = 'Model No';
            Description = 'Only for Vehicle Trade';
        }
        field(99008504;"ABC-FMS";Option)
        {
            OptionCaption = ' ,FA,FB,FC,MA,MB,MC,SA,SB,SC,NN';
            OptionMembers = " ",FA,FB,FC,MA,MB,MC,SA,SB,SC,NN;
        }
        field(99008505;"Movement Code (MC)";Code[10])
        {
        }
        field(99008506;"Inventory Holding Period (Day)";Integer)
        {
        }
        field(99008507;"Item Status";Code[20])
        {
            TableRelation = Status;

            trigger OnValidate()
            begin
                StatusVar.RESET;
                StatusVar.SETRANGE("Status Code",Rec."Item Status");
                IF StatusVar.FINDFIRST THEN
                   "Status Description" := StatusVar."Status Description";
            end;
        }
        field(99008508;"Status Description";Text[30])
        {
        }
        field(99008509;CBM;Decimal)
        {
            DecimalPlaces = 0:6;
        }
        field(99008510;NPA;Boolean)
        {
        }
    }
    keys
    {
        key(Key1;"Item Type")
        {
        }
        key(Key2;"Item Type","Make Code","Model Code")
        {
        }
    }


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF "No." = '' THEN BEGIN
          GetInvtSetup;
          InvtSetup.TESTFIELD("Item Nos.");
        #4..6
        DimMgt.UpdateDefaultDim(
          DATABASE::Item,"No.",
          "Global Dimension 1 Code","Global Dimension 2 Code");

        SetLastDateTimeModified;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        //EDMS1.0.00 >>
        IF "Item Type" <> "Item Type"::"Model Version" THEN
        //EDMS1.0.00 <<
        #1..9
        SetLastDateTimeModified;
        */
    //end;


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SetLastDateTimeModified;
        PlanningAssignment.ItemChange(Rec,xRec);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        SetLastDateTimeModified;
        PlanningAssignment.ItemChange(Rec,xRec);
        IF Saved THEN BEGIN
          UserSetup.GET(USERID); //MIN 5/2/2019
          IF NOT UserSetup."Can Edit Item Card" THEN
           ERROR(NoModifyPermissionErr);
        END;
        */
    //end;


    //Unsupported feature: Code Modification on "OnRename".

    //trigger OnRename()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SalesLine.RenameNo(SalesLine.Type::Item,xRec."No.","No.");
        PurchLine.RenameNo(PurchLine.Type::Item,xRec."No.","No.");
        ApprovalsMgmt.RenameApprovalEntries(xRec.RECORDID,RECORDID);
        ItemAttributeValueMapping.RenameItemAttributeValueMapping(xRec."No.","No.");
        SetLastDateTimeModified;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..5
        //AGILE SRT Jan 27th 2019>>
        CheckILE;
        //AGILE SRT Jan 27th 2019 <<
        */
    //end;


    //Unsupported feature: Code Modification on "SetLastDateTimeModified(PROCEDURE 16)".

    //procedure SetLastDateTimeModified();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        Now := DateFilterCalc.ConvertToUtcDateTime(CURRENTDATETIME);
        "Last Date Modified" := DT2DATE(Now);
        "Last Time Modified" := DT2TIME(Now);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..3
        "Modification Date" := TODAY; //Min
        */
    //end;

    procedure CalcServiceReturnEDMS(): Decimal
    var
        ServiceLine: Record "25006146";
    begin
        ServiceLine.SETCURRENTKEY("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Planned Service Date");
        ServiceLine.SETRANGE("Document Type",ServiceLine."Document Type"::"Return Order");
        ServiceLine.SETRANGE(Type,ServiceLine.Type::Item);
        ServiceLine.SETRANGE("No.","No.");
        ServiceLine.SETFILTER("Location Code",GETFILTER("Location Filter"));
        ServiceLine.SETFILTER("Drop Shipment",GETFILTER("Drop Shipment Filter"));
        ServiceLine.SETFILTER("Variant Code",GETFILTER("Variant Filter"));
        ServiceLine.SETRANGE("Planned Service Date",GETRANGEMIN("Date Filter"),GETRANGEMAX("Date Filter"));
        ServiceLine.CALCSUMS("Outstanding Qty. (Base)");
        EXIT(ServiceLine."Outstanding Qty. (Base)");
    end;

    procedure ShowItemVehicleModels()
    var
        ItemVehicleModel: Record "25006755";
    begin
        ItemVehicleModel.SETRANGE(Type,ItemVehicleModel.Type::Item);
        ItemVehicleModel.SETRANGE("No.","No.");
        IF (NOT ItemVehicleModel.FINDFIRST) AND "Created From Nonstock Item" THEN
         BEGIN
          ItemVehicleModel.RESET;
          NonstockItem.SETRANGE("Item No.","No.");
          IF NonstockItem.FINDFIRST THEN
           BEGIN
            ItemVehicleModel.SETRANGE(Type,ItemVehicleModel.Type::"Nonstock Item");
            ItemVehicleModel.SETRANGE("No.",NonstockItem."Entry No.");
           END;
         END;
        PAGE.RUN(PAGE::"Item Vehicle Models",ItemVehicleModel);
    end;

    procedure GetSalesQty(Criteria: Decimal): Decimal
    var
        datStartingDate: Date;
        datEndingDate: Date;
    begin
        datStartingDate := DMY2DATE(1);
        //19.11.2014 EB.P8 EDMS >>
        //datEndingDate := CALCDATE('-1D',CALCDATE('+1M',datStartingDate));
        datEndingDate := CALCDATE('<-1D>',CALCDATE('<+1M>',datStartingDate));
        IF Criteria <> 0 THEN BEGIN
          datStartingDate := CALCDATE('<'+FORMAT(Criteria)+'M>',datStartingDate);
          datEndingDate := CALCDATE('<'+FORMAT(Criteria)+'M>',datEndingDate);
        END;
        //19.11.2014 EB.P8 EDMS >>

        // 01.04.2014 Elva Baltic P21 >>
        // SETRANGE("Date Filter",datStartingDate,datEndingDate);
        RESET;
        SETFILTER("Date Filter", '%1..%2',datStartingDate,datEndingDate);
        // 01.04.2014 Elva Baltic P21 <<

        CALCFIELDS("Sales (Qty.)");
        EXIT("Sales (Qty.)");
    end;

    procedure GetSourceNonstockEntryNo() RetVal: Code[20]
    var
        NonstockItem: Record "5718";
    begin
        IF NOT "Created From Nonstock Item" THEN
          EXIT(RetVal);

        NonstockItem.SETRANGE("Item No.", "No.");
        IF NonstockItem.FINDFIRST THEN
          RetVal := NonstockItem."Entry No.";

        EXIT(RetVal);
    end;

    procedure FillItemCategoryDim()
    var
        DefaultDim: Record "352";
        NewDefDim: Record "352";
    begin
        // 31.03.2014 Elva Baltic P18 MMG7.00 >>
        IF "Item Category Code" = '' THEN
          EXIT;

        DefaultDim.RESET;
        DefaultDim.SETRANGE("Table ID",DATABASE::"Item Category");
        DefaultDim.SETRANGE("No.","Item Category Code");
        IF DefaultDim.FIND('-') THEN
          REPEAT
            //14.04.2014 Elva Baltic P1 #RX MMG7.00 >>
            NewDefDim.RESET;
            NewDefDim.SETRANGE("Table ID",DATABASE::Item);
            NewDefDim.SETRANGE("No.","No.");
            NewDefDim.SETRANGE("Dimension Code",DefaultDim."Dimension Code");
            IF NewDefDim.FINDFIRST THEN
              NewDefDim.DELETE(TRUE);
            NewDefDim.RESET;
            //14.04.2014 Elva Baltic P1 #RX MMG7.00 <<
            NewDefDim.INIT;
            NewDefDim.TRANSFERFIELDS(DefaultDim);
            NewDefDim."Table ID" := DATABASE::Item;
            NewDefDim."No." := "No.";
            NewDefDim.INSERT(TRUE);
          UNTIL DefaultDim.NEXT =0 ;
        // 31.03.2014 Elva Baltic P18 MMG7.00 <<
    end;

    procedure NonstockRepleacementExists(ItemNoPar: Code[20]) RetVal: Boolean
    var
        Item1: Record "27";
        ItemSubst1: Record "5715";
        NonstockEntryNo: Code[20];
    begin
        IF NOT Item1.GET(ItemNoPar) THEN
          EXIT(RetVal);

        NonstockEntryNo := Item1.GetSourceNonstockEntryNo();
        IF NonstockEntryNo <> '' THEN BEGIN
          ItemSubst1.RESET;
          ItemSubst1.SETRANGE(Type, ItemSubst1.Type::"Nonstock Item");
          ItemSubst1.SETRANGE("No.", NonstockEntryNo);  //try to find by "No."
          //ItemSubst1.SETRANGE("Variant Code", '');
          // 30.06.2014 Elva Baltic P15 #F124 MMG7.00 >>
          IF ItemSubst1.FINDFIRST THEN
            RetVal := TRUE
          ELSE
            ItemSubst1.SETRANGE("No.");
            ItemSubst1.SETRANGE("Substitute No.", NonstockEntryNo); //try to find by "Substitute No."
            //ItemSubst1.SETRANGE("Variant Code", '');
            IF ItemSubst1.FINDFIRST THEN
              RetVal := TRUE;
          // 30.06.2014 Elva Baltic P15 #F124 MMG7.00 <<
        END;
    end;

    procedure SetNewEntryVariable(IsNew: Boolean)
    begin
        NewEntry := IsNew;
    end;

    local procedure "--AGILE SRT--"()
    begin
    end;

    local procedure CheckILE()
    var
        ILE: Record "32";
    begin
        IF "No." <> xRec."No." THEN BEGIN
          ILE.RESET;
          ILE.SETRANGE("Item No.",xRec."No.");
          IF ILE.FINDFIRST THEN
            ERROR('%1 exists for item %2. You cannot modify the %3.',ILE.TABLECAPTION,xRec."No.",FIELDCAPTION("No."));
        END;
    end;

    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".


    //Unsupported feature: Property Modification (Length) on "ItemSKUGet(PROCEDURE 11).VariantCode(Parameter 1002)".


    //Unsupported feature: Property Deletion (LookupPageID).


    var
        InvPostingGrp: Record "94";

    var
        ItemLedgEntry: Record "32";

    var
        ProductSubgroup: Record "25006746";
        ItemCategory: Record "5722";
        ProductSubgrp: Record "25006746";

    var
        NewEntry: Boolean;

    var
        NoModifyPermissionErr: Label 'You do not have permission to modify item card.';
        UserSetup: Record "91";
        StatusVar: Record "14125603";
        TariffNumber: Record "260";
}


table 33019832 "Spare Req. Line Archive"
{
    Caption = 'Spare Req. Line Archive';

    fields
    {
        field(1; "Worksheet Template Name"; Code[10])
        {
            Caption = 'Worksheet Template Name';
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item';
            OptionMembers = " ","G/L Account",Item;
        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST(3)) Resource;
        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(7; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(9; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(10; "Direct Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
        }
        field(12; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(13; "Requester ID"; Code[50])
        {
            Caption = 'Requester ID';
            TableRelation = "User Setup";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "418";
            begin
            end;

            trigger OnValidate()
            var
                LoginMgt: Codeunit "418";
            begin
            end;
        }
        field(14; Confirmed; Boolean)
        {
            Caption = 'Confirmed';
        }
        field(15; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(16; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(17; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE(Use As In-Transit=CONST(No));

            trigger OnValidate()
            var
                ApprAllowed: Boolean;
            begin
            end;
        }
        field(18; "Recurring Method"; Option)
        {
            BlankZero = true;
            Caption = 'Recurring Method';
            OptionCaption = ',Fixed,Variable';
            OptionMembers = ,"Fixed",Variable;
        }
        field(19; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(20; "Recurring Frequency"; DateFormula)
        {
            Caption = 'Recurring Frequency';
        }
        field(21; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(22; "Vendor Item No."; Text[20])
        {
            Caption = 'Vendor Item No.';
        }
        field(23; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Editable = false;
            TableRelation = "Sales Header".No. WHERE(Document Type=CONST(Order));

            trigger OnValidate()
            var
                ApprAllowed: Boolean;
            begin
            end;
        }
        field(24; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            Editable = false;

            trigger OnValidate()
            var
                ApprAllowed: Boolean;
            begin
            end;
        }
        field(25; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;

            trigger OnValidate()
            var
                ApprAllowed: Boolean;
            begin
            end;
        }
        field(26; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            Editable = false;
            TableRelation = "Ship-to Address".Code WHERE(Customer No.=FIELD(Sell-to Customer No.));
        }
        field(28;"Order Address Code";Code[10])
        {
            Caption = 'Order Address Code';
            TableRelation = "Order Address".Code WHERE (Vendor No.=FIELD(Vendor No.));
        }
        field(29;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(30;"Currency Factor";Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0:15;
            MinValue = 0;
        }
        field(31;"Reserved Quantity";Decimal)
        {
            CalcFormula = Sum("Reservation Entry".Quantity WHERE (Source ID=FIELD(Worksheet Template Name),
                                                                  Source Ref. No.=FIELD(Line No.),
                                                                  Source Type=CONST(246),
                                                                  Source Subtype=CONST(0),
                                                                  Source Batch Name=FIELD(Journal Batch Name),
                                                                  Source Prod. Order Line=CONST(0),
                                                                  Reservation Status=CONST(Reservation)));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5401;"Prod. Order No.";Code[20])
        {
            Caption = 'Prod. Order No.';
            Editable = false;
            TableRelation = "Production Order".No. WHERE (Status=CONST(Released));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5402;"Variant Code";Code[20])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));

            trigger OnValidate()
            var
                ApprAllowed: Boolean;
            begin
            end;
        }
        field(5403;"Bin Code";Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code WHERE (Location Code=FIELD(Location Code),
                                            Item Filter=FIELD(No.),
                                            Variant Filter=FIELD(Variant Code));

            trigger OnValidate()
            var
                ApprAllowed: Boolean;
            begin
            end;
        }
        field(5404;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            Editable = false;
            InitValue = 1;
        }
        field(5407;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }
        field(5408;"Quantity (Base)";Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0:5;
        }
        field(5431;"Reserved Qty. (Base)";Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Source ID=FIELD(Worksheet Template Name),
                                                                           Source Ref. No.=FIELD(Line No.),
                                                                           Source Type=CONST(246),
                                                                           Source Subtype=CONST(0),
                                                                           Source Batch Name=FIELD(Journal Batch Name),
                                                                           Source Prod. Order Line=CONST(0),
                                                                           Reservation Status=CONST(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5520;"Demand Type";Integer)
        {
            Caption = 'Demand Type';
            Editable = false;
            TableRelation = Object.ID WHERE (Type=CONST(Table));
        }
        field(5521;"Demand Subtype";Option)
        {
            Caption = 'Demand Subtype';
            Editable = false;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9";
        }
        field(5522;"Demand Order No.";Code[20])
        {
            Caption = 'Demand Order No.';
            Editable = false;
        }
        field(5525;"Demand Line No.";Integer)
        {
            Caption = 'Demand Line No.';
            Editable = false;
        }
        field(5526;"Demand Ref. No.";Integer)
        {
            Caption = 'Demand Ref. No.';
            Editable = false;
        }
        field(5530;"Demand Date";Date)
        {
            Caption = 'Demand Date';
            Editable = false;
        }
        field(5532;"Demand Quantity";Decimal)
        {
            Caption = 'Demand Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5533;"Demand Quantity (Base)";Decimal)
        {
            Caption = 'Demand Quantity (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5538;"Needed Quantity";Decimal)
        {
            BlankZero = true;
            Caption = 'Needed Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5539;"Needed Quantity (Base)";Decimal)
        {
            BlankZero = true;
            Caption = 'Needed Quantity (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5540;Reserve;Boolean)
        {
            Caption = 'Reserve';
        }
        field(5541;"Qty. per UOM (Demand)";Decimal)
        {
            Caption = 'Qty. per UOM (Demand)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5542;"Unit Of Measure Code (Demand)";Code[10])
        {
            Caption = 'Unit Of Measure Code (Demand)';
            Editable = false;
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.));
        }
        field(5552;"Supply From";Code[20])
        {
            Caption = 'Supply From';
            TableRelation = IF (Replenishment System=CONST(Purchase)) Vendor
                            ELSE IF (Replenishment System=CONST(Transfer)) Location WHERE (Use As In-Transit=CONST(No));
        }
        field(5553;"Original Item No.";Code[20])
        {
            Caption = 'Original Item No.';
            Editable = false;
            TableRelation = Item;
        }
        field(5554;"Original Variant Code";Code[10])
        {
            Caption = 'Original Variant Code';
            Editable = false;
            TableRelation = "Item Variant".Code WHERE (Item No.=FIELD(Original Item No.));
        }
        field(5560;Level;Integer)
        {
            Caption = 'Level';
            Editable = false;
        }
        field(5563;"Demand Qty. Available";Decimal)
        {
            Caption = 'Demand Qty. Available';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5590;"User ID";Code[20])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = Table2000000002;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(5701;"Item Category Code";Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = IF (Type=CONST(Item)) "Item Category";
        }
        field(5702;Nonstock;Boolean)
        {
            Caption = 'Nonstock';
        }
        field(5703;"Purchasing Code";Code[10])
        {
            Caption = 'Purchasing Code';
            TableRelation = Purchasing;
        }
        field(5705;"Product Group Code";Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
        }
        field(5706;"Transfer-from Code";Code[10])
        {
            Caption = 'Transfer-from Code';
            Editable = false;
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));
        }
        field(5707;"Transfer Shipment Date";Date)
        {
            Caption = 'Transfer Shipment Date';
            Editable = false;
        }
        field(7002;"Line Discount %";Decimal)
        {
            Caption = 'Line Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(25006000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001;"Deal Type Code";Code[10])
        {
            Caption = 'Deal Type Code';
            Editable = true;
            TableRelation = "Deal Type";
        }
        field(25006008;"Order Promising Type";Option)
        {
            Caption = 'Order Promising Type';
            OptionCaption = ' ,Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Prod. Order Line,Prod. Order Component,Planning Line,Planning Component,Transfer,Service Order,Service Order EDMS';
            OptionMembers = " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry","Prod. Order Line","Prod. Order Component","Planning Line","Planning Component",Transfer,"Service Order","Service Order EDMS";
        }
        field(25006010;"Reservation Entry No.";Integer)
        {
            BlankZero = true;
            CalcFormula = Lookup("Reservation Entry"."Entry No." WHERE (Reservation Status=CONST(Reservation),
                                                                        Source Type=CONST(246),
                                                                        Source Subtype=CONST(0),
                                                                        Source ID=FIELD(Worksheet Template Name),
                                                                        Source Batch Name=FIELD(Journal Batch Name),
                                                                        Source Prod. Order Line=CONST(0),
                                                                        Source Ref. No.=FIELD(Line No.)));
            Caption = 'Reservation Entry No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006011;"Reservation Source Type";Integer)
        {
            BlankZero = true;
            CalcFormula = Lookup("Reservation Entry"."Source Type" WHERE (Entry No.=FIELD(Reservation Entry No.),
                                                                          Positive=CONST(No)));
            Caption = 'Reservation Source Type';
            Description = 'Negative Entry';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006012;"Reservation Source Subtype";Option)
        {
            BlankZero = true;
            CalcFormula = Lookup("Reservation Entry"."Source Subtype" WHERE (Entry No.=FIELD(Reservation Entry No.),
                                                                             Positive=CONST(No)));
            Caption = 'Reservation Source Subtype';
            Description = 'Negative Entry';
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
            Description = 'Negative Entry';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006014;"Reservation Source Ref. No.";Integer)
        {
            BlankZero = true;
            CalcFormula = Lookup("Reservation Entry"."Source Ref. No." WHERE (Entry No.=FIELD(Reservation Entry No.),
                                                                              Positive=CONST(No)));
            Caption = 'Reservation Source Ref. No.';
            Description = 'Negative Entry';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006015;"Reservation VIN";Code[20])
        {
            CalcFormula = Lookup("Sales Line".VIN WHERE (Document Type=FIELD(Reservation Source Subtype),
                                                         Document No.=FIELD(Reservation Source ID),
                                                         Line No.=FIELD(Reservation Source Ref. No.)));
            Caption = 'Reservation VIN';
            Description = 'Negative Entry';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006016;"Reservation Customer No.";Code[20])
        {
            CalcFormula = Lookup("Sales Line"."Sell-to Customer No." WHERE (Document Type=FIELD(Reservation Source Subtype),
                                                                            Document No.=FIELD(Reservation Source ID),
                                                                            Line No.=FIELD(Reservation Source Ref. No.)));
            Caption = 'Reservation Customer No.';
            Description = 'Negative Entry';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006370;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            var
                recVehicle: Record "25006005";
                recModel: Record "25006001";
            begin
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
            end;

            trigger OnValidate()
            var
                recSalesLine: Record "37";
                tcAMT001: Label 'This VIN is being used in %1! Are you shore that you want to use exactly this VIN?';
                recVehicle: Record "25006005";
                tcAMT002: Label 'Serial No. in Vehicle table differs from Serial No. in Sales Line!';
                tcAMT003: Label 'VIN %1 is used in more than one Sales Order in the same time!';
                recReservationEntry: Record "337";
                recReservationEntry2: Record "337";
                tcAMT004: Label 'Vehicle is already reserved to customer No. %1!';
            begin
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
            end;

            trigger OnValidate()
            var
                recVehicle: Record "25006005";
            begin
            end;
        }
        field(25006375;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
            begin
            end;

            trigger OnValidate()
            var
                recReservationEntry: Record "337";
                SalesLine: Record "37";
                iEntryNo: Integer;
                cSalesLineReserve: Codeunit "99000832";
                recVehicle: Record "25006005";
                codSerialNoPre: Code[20];
                codDefCycle: Code[20];
                cuVehAccCycle: Codeunit "25006303";
            begin
            end;
        }
        field(25006376;"Vehicle Assembly ID";Code[20])
        {
            Caption = 'Vehicle Assembly ID';

            trigger OnValidate()
            var
                tcAMT001: Label 'Vehicle assembly list %1 is not empty!';
            begin
            end;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle".No.;

            trigger OnLookup()
            var
                VehAccCycle: Record "25006024";
                LookUpMgt: Codeunit "25006003";
            begin
            end;

            trigger OnValidate()
            var
                VehAccCycle: Codeunit "25006303";
            begin
            end;
        }
        field(25006382;Reserved;Boolean)
        {
            CalcFormula = Exist("Vehicle Reservation Entry" WHERE (Source Type=CONST(246),
                                                                   Source ID=FIELD(Worksheet Template Name),
                                                                   Source Ref. No.=FIELD(Line No.),
                                                                   Source Subtype=CONST(0),
                                                                   Source Batch Name=FIELD(Journal Batch Name)));
            Caption = 'Reserved';
            Description = 'Only for Vehicles';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006670;"Qty in Sales Quotes";Decimal)
        {
            CalcFormula = Sum("Sales Line".Quantity WHERE (Type=CONST(Item),
                                                           Document Type=CONST(Quote),
                                                           No.=FIELD(No.)));
            Caption = 'Qty in Sales Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006700;"Ordering Price Type";Option)
        {
            Caption = 'Ordering Price Type';
            OptionCaption = 'Stock,Urgent';
            OptionMembers = Stock,Urgent;
        }
        field(33019831;Status;Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Transfered,Cancelled';
            OptionMembers = Open,Transfered,Cancelled;

            trigger OnValidate()
            var
                SpareReqHeader: Record "33019831";
                SpareReqLine: Record "33019832";
                OpenStatus: Boolean;
            begin
                MODIFY(TRUE);
                SpareReqHeader.RESET;
                SpareReqHeader.SETCURRENTKEY("No.");
                SpareReqHeader.SETRANGE("No.","Archive Header No.");
                OpenStatus := FALSE;
                IF SpareReqHeader.FIND('-') THEN BEGIN
                  SpareReqLine.RESET;
                  SpareReqLine.SETCURRENTKEY("Archive Header No.");
                  SpareReqLine.SETRANGE("Archive Header No.","Archive Header No.");
                  IF SpareReqLine.FIND('-') THEN BEGIN
                    REPEAT
                     IF SpareReqLine.Status = SpareReqLine.Status::Open THEN
                      OpenStatus := TRUE;
                    UNTIL SpareReqLine.NEXT=0;
                  END;
                  IF OpenStatus=FALSE THEN BEGIN
                    SpareReqHeader.Status := SpareReqHeader.Status::Close;
                    SpareReqHeader.MODIFY;
                  END;
                END;
            end;
        }
        field(33019834;"Version No.";Integer)
        {
        }
        field(33019835;"Doc. No. Occurrence";Integer)
        {
        }
        field(33019836;"Archive Header No.";Code[20])
        {
        }
        field(33019840;Issued;Boolean)
        {
        }
        field(99000750;"Routing No.";Code[20])
        {
            Caption = 'Routing No.';
            TableRelation = "Routing Header";

            trigger OnValidate()
            var
                RtngDate: Date;
            begin
            end;
        }
        field(99000751;"Operation No.";Code[10])
        {
            Caption = 'Operation No.';
            TableRelation = "Prod. Order Routing Line"."Operation No." WHERE (Status=CONST(Released),
                                                                              Prod. Order No.=FIELD(Prod. Order No.),
                                                                              Routing No.=FIELD(Routing No.));

            trigger OnValidate()
            var
                ProdOrderRtngLine: Record "5409";
            begin
            end;
        }
        field(99000752;"Work Center No.";Code[20])
        {
            Caption = 'Work Center No.';
            TableRelation = "Work Center";
        }
        field(99000754;"Prod. Order Line No.";Integer)
        {
            Caption = 'Prod. Order Line No.';
            Editable = false;
            TableRelation = "Prod. Order Line"."Line No." WHERE (Status=CONST(Finished),
                                                                 Prod. Order No.=FIELD(Prod. Order No.));
        }
        field(99000755;"MPS Order";Boolean)
        {
            Caption = 'MPS Order';
        }
        field(99000756;"Planning Flexibility";Option)
        {
            Caption = 'Planning Flexibility';
            OptionCaption = 'Unlimited,None';
            OptionMembers = Unlimited,"None";
        }
        field(99000757;"Routing Reference No.";Integer)
        {
            Caption = 'Routing Reference No.';
        }
        field(99000882;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(99000883;"Gen. Business Posting Group";Code[10])
        {
            Caption = 'Gen. Business Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(99000884;"Low-Level Code";Integer)
        {
            Caption = 'Low-Level Code';
            Editable = false;
        }
        field(99000885;"Production BOM Version Code";Code[10])
        {
            Caption = 'Production BOM Version Code';
            TableRelation = "Production BOM Version"."Version Code" WHERE (Production BOM No.=FIELD(Production BOM No.));
        }
        field(99000886;"Routing Version Code";Code[10])
        {
            Caption = 'Routing Version Code';
            TableRelation = "Routing Version"."Version Code" WHERE (Routing No.=FIELD(Routing No.));
        }
        field(99000887;"Routing Type";Option)
        {
            Caption = 'Routing Type';
            OptionCaption = 'Serial,Parallel';
            OptionMembers = Serial,Parallel;
        }
        field(99000888;"Original Quantity";Decimal)
        {
            BlankZero = true;
            Caption = 'Original Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(99000889;"Finished Quantity";Decimal)
        {
            Caption = 'Finished Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
            MinValue = 0;
        }
        field(99000890;"Remaining Quantity";Decimal)
        {
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
            MinValue = 0;
        }
        field(99000891;"Original Due Date";Date)
        {
            Caption = 'Original Due Date';
            Editable = false;
        }
        field(99000892;"Scrap %";Decimal)
        {
            Caption = 'Scrap %';
            DecimalPlaces = 0:5;
        }
        field(99000894;"Starting Date";Date)
        {
            Caption = 'Starting Date';
        }
        field(99000895;"Starting Time";Time)
        {
            Caption = 'Starting Time';
        }
        field(99000896;"Ending Date";Date)
        {
            Caption = 'Ending Date';
        }
        field(99000897;"Ending Time";Time)
        {
            Caption = 'Ending Time';
        }
        field(99000898;"Production BOM No.";Code[20])
        {
            Caption = 'Production BOM No.';
            TableRelation = "Production BOM Header".No. WHERE (Status=CONST(Certified));

            trigger OnValidate()
            var
                BOMDate: Date;
            begin
            end;
        }
        field(99000899;"Indirect Cost %";Decimal)
        {
            Caption = 'Indirect Cost %';
            DecimalPlaces = 0:5;
        }
        field(99000900;"Overhead Rate";Decimal)
        {
            Caption = 'Overhead Rate';
            DecimalPlaces = 0:5;
        }
        field(99000901;"Unit Cost";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;
        }
        field(99000902;"Cost Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount';
            Editable = false;
            MinValue = 0;
        }
        field(99000903;"Replenishment System";Option)
        {
            Caption = 'Replenishment System';
            OptionCaption = 'Purchase,Prod. Order,Transfer, ';
            OptionMembers = Purchase,"Prod. Order",Transfer," ";
        }
        field(99000904;"Ref. Order No.";Code[20])
        {
            Caption = 'Ref. Order No.';
            Editable = false;
            TableRelation = IF (Ref. Order Type=CONST(Prod. Order)) "Production Order".No. WHERE (Status=FIELD(Ref. Order Status))
                            ELSE IF (Ref. Order Type=CONST(Purchase)) "Purchase Header".No. WHERE (Document Type=CONST(Order))
                            ELSE IF (Ref. Order Type=CONST(Transfer)) "Transfer Header".No. WHERE (No.=FIELD(Ref. Order No.));
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                PurchHeader: Record "38";
                ProdOrder: Record "5405";
                TransHeader: Record "5740";
            begin
            end;
        }
        field(99000905;"Ref. Order Type";Option)
        {
            Caption = 'Ref. Order Type';
            Editable = false;
            OptionCaption = ' ,Purchase,Prod. Order,Transfer';
            OptionMembers = " ",Purchase,"Prod. Order",Transfer;
        }
        field(99000906;"Ref. Order Status";Option)
        {
            BlankZero = true;
            Caption = 'Ref. Order Status';
            Editable = false;
            OptionCaption = ',Planned,Firm Planned,Released';
            OptionMembers = ,Planned,"Firm Planned",Released;
        }
        field(99000907;"Ref. Line No.";Integer)
        {
            BlankZero = true;
            Caption = 'Ref. Line No.';
            Editable = false;
        }
        field(99000908;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(99000909;"Expected Operation Cost Amt.";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Planning Routing Line"."Expected Operation Cost Amt." WHERE (Worksheet Template Name=FIELD(Worksheet Template Name),
                                                                                            Worksheet Batch Name=FIELD(Journal Batch Name),
                                                                                            Worksheet Line No.=FIELD(Line No.)));
            Caption = 'Expected Operation Cost Amt.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000910;"Expected Component Cost Amt.";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Planning Component"."Cost Amount" WHERE (Worksheet Template Name=FIELD(Worksheet Template Name),
                                                                        Worksheet Batch Name=FIELD(Journal Batch Name),
                                                                        Worksheet Line No.=FIELD(Line No.)));
            Caption = 'Expected Component Cost Amt.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000911;"Finished Qty. (Base)";Decimal)
        {
            Caption = 'Finished Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(99000912;"Remaining Qty. (Base)";Decimal)
        {
            Caption = 'Remaining Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(99000913;"Related to Planning Line";Integer)
        {
            Caption = 'Related to Planning Line';
            Editable = false;
        }
        field(99000914;"Planning Level";Integer)
        {
            Caption = 'Planning Level';
            Editable = false;
        }
        field(99000915;"Planning Line Origin";Option)
        {
            Caption = 'Planning Line Origin';
            Editable = false;
            OptionCaption = ' ,Action Message,Planning,Order Planning';
            OptionMembers = " ","Action Message",Planning,"Order Planning";
        }
        field(99000916;"Action Message";Option)
        {
            Caption = 'Action Message';
            OptionCaption = ' ,New,Change Qty.,Reschedule,Resched. & Chg. Qty.,Cancel';
            OptionMembers = " ",New,"Change Qty.",Reschedule,"Resched. & Chg. Qty.",Cancel;
        }
        field(99000917;"Accept Action Message";Boolean)
        {
            Caption = 'Accept Action Message';
        }
        field(99000918;"Net Quantity (Base)";Decimal)
        {
            Caption = 'Net Quantity (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(99000919;"Starting Date-Time";DateTime)
        {
            Caption = 'Starting Date-Time';
        }
        field(99000920;"Ending Date-Time";DateTime)
        {
            Caption = 'Ending Date-Time';
        }
        field(99000921;"Order Promising ID";Code[20])
        {
            Caption = 'Order Promising ID';
        }
        field(99000922;"Order Promising Line No.";Integer)
        {
            Caption = 'Order Promising Line No.';
        }
        field(99000923;"Order Promising Line ID";Integer)
        {
            Caption = 'Order Promising Line ID';
        }
    }

    keys
    {
        key(Key1;"Worksheet Template Name","Journal Batch Name","Line No.","Doc. No. Occurrence","Version No.","Archive Header No.")
        {
            Clustered = true;
        }
        key(Key2;"Archive Header No.")
        {
        }
    }

    fieldgroups
    {
    }
}


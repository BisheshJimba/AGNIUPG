tableextension 50113 tableextension50113 extends "Requisition Line"
{
    // 27.05.2016 EB.P30 T036
    //   Modified function UpdateDescription
    // 
    // 03.11.2015 EB.P7 #T002
    //   Function UpdateDescription modified.
    // 
    // 06.06.2014 Elva Baltic P8 #F0001 EDMS7.10
    //   * Add fill value of "Ordering Price Type Code"
    //   * Add to local key "Ordering Price Type Code"
    // 
    // 07.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added key:
    //     Worksheet Template Name,Journal Batch Name,Vendor No.,Sell-to Customer No.,Ship-to Code,Order Address Code,Currency Code,Location Code,Transfer-from Code,Type,No.
    // 
    // 28.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added function:
    //     GetReservForInfo
    // 
    // 18.01.2013 EDMS P8
    //   * Added fields: Service Order No., Service Order Line No.
    // 
    // 06.08.2008 EDMS P1
    //  *Added field "Order Promising Type"
    //  *Field "Order Promising Type" added to key "Order Promising ID,Order Promising Line ID,Order Promising Line No."
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Item)) Item WHERE (Type=CONST(Inventory));
        }

        //Unsupported feature: Property Insertion (Editable) on ""Requester ID"(Field 13)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity"(Field 31)".


        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

        modify("Bin Code")
        {
            TableRelation = Bin.Code WHERE(Location Code=FIELD(Location Code),
                                            Item Filter=FIELD(No.),
                                            Variant Filter=FIELD(Variant Code));
        }
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. (Base)"(Field 5431)".

        modify("Supply From")
        {
            TableRelation = IF (Replenishment System=CONST(Purchase)) Vendor
                            ELSE IF (Replenishment System=CONST(Transfer)) Location WHERE (Use As In-Transit=CONST(No));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Blanket Purch. Order Exists"(Field 7100)".

        modify("Operation No.")
        {
            TableRelation = "Prod. Order Routing Line"."Operation No." WHERE (Status=CONST(Released),
                                                                              Prod. Order No.=FIELD(Prod. Order No.),
                                                                              Routing No.=FIELD(Routing No.));
        }
        modify("Prod. Order Line No.")
        {
            TableRelation = "Prod. Order Line"."Line No." WHERE (Status=CONST(Finished),
                                                                 Prod. Order No.=FIELD(Prod. Order No.));
        }
        modify("Ref. Order No.")
        {
            TableRelation = IF (Ref. Order Type=CONST(Prod. Order)) "Production Order".No. WHERE (Status=FIELD(Ref. Order Status))
                            ELSE IF (Ref. Order Type=CONST(Purchase)) "Purchase Header".No. WHERE (Document Type=CONST(Order))
                            ELSE IF (Ref. Order Type=CONST(Transfer)) "Transfer Header".No. WHERE (No.=FIELD(Ref. Order No.))
                            ELSE IF (Ref. Order Type=CONST(Assembly)) "Assembly Header".No. WHERE (Document Type=CONST(Order));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Expected Operation Cost Amt."(Field 99000909)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Expected Component Cost Amt."(Field 99000910)".



        //Unsupported feature: Code Modification on "Type(Field 4).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF Type <> xRec.Type THEN BEGIN
              NewType := Type;

            #4..7
              "Location Code" := '';
              "Prod. Order No." := '';
              ReserveReqLine.VerifyChange(Rec,xRec);
              AddOnIntegrMgt.ResetReqLineFields(Rec);
              INIT;
              Type := NewType;
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..10
              //20.03.2013 EDMS >>
              LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
              LicensePermission.SETRANGE("Object Number",CODEUNIT::"Req. Line-Veh. Reserve");
              LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
              ApprAllowed := NOT LicensePermission.ISEMPTY;
              //20.03.2013 EDMS <<
            #11..14
            */
        //end;


        //Unsupported feature: Code Modification on ""No."(Field 5).OnValidate".

        //trigger "(Field 5)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            CheckActionMessageNew;
            ReserveReqLine.VerifyChange(Rec,xRec);
            DeleteRelations;

            IF "No." = '' THEN BEGIN
            #6..68
            CreateDim(
              DimMgt.TypeToTableID3(Type),
              "No.",DATABASE::Vendor,"Vendor No.");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            CheckActionMessageNew;
            ReserveReqLine.VerifyChange(Rec,xRec);
            //20.03.2013 EDMS >>
            LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
            LicensePermission.SETRANGE("Object Number",CODEUNIT::"Req. Line-Veh. Reserve");
            LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
            //22.10.2015 NAV2016 Merge>>
            //ApprAllowed := NOT LicensePermission.ISEMPTY;
            //22.10.2015 NAV2016 Merge<<
            //20.03.2013 EDMS <<
            #3..71
            */
        //end;


        //Unsupported feature: Code Modification on ""Location Code"(Field 17).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            ValidateLocationChange;
            CheckActionMessageNew;
            "Bin Code" := '';
            ReserveReqLine.VerifyChange(Rec,xRec);

            IF Type = Type::Item THEN BEGIN
              GetPlanningParameters.AtSKU(TempSKU,"No.","Variant Code","Location Code");
              IF Subcontracting THEN
            #9..20
                "Vendor Item No." := ItemVend."Vendor Item No.";
            END;
            GetDirectCost(FIELDNO("Location Code"));
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..4
            //20.03.2013 EDMS >>
            LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
            LicensePermission.SETRANGE("Object Number",CODEUNIT::"Req. Line-Veh. Reserve");
            LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
            ApprAllowed := NOT LicensePermission.ISEMPTY;
              //20.03.2013 EDMS <<
            #6..23
            */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Sales Order No."(Field 23).OnValidate".

        //trigger (Variable: ApprAllowed)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on ""Sales Order No."(Field 23).OnValidate".

        //trigger "(Field 23)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            ReserveReqLine.VerifyChange(Rec,xRec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            ReserveReqLine.VerifyChange(Rec,xRec);
            //20.03.2013 EDMS >>
            LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
            LicensePermission.SETRANGE("Object Number",CODEUNIT::"Req. Line-Veh. Reserve");
            LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
            ApprAllowed := NOT LicensePermission.ISEMPTY;
            //20.03.2013 EDMS <<
            */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Sales Order Line No."(Field 24).OnValidate".

        //trigger (Variable: ApprAllowed)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on ""Sales Order Line No."(Field 24).OnValidate".

        //trigger "(Field 24)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            ReserveReqLine.VerifyChange(Rec,xRec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            ReserveReqLine.VerifyChange(Rec,xRec);
            //20.03.2013 EDMS >>
            LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
            LicensePermission.SETRANGE("Object Number",CODEUNIT::"Req. Line-Veh. Reserve");
            LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
            ApprAllowed := NOT LicensePermission.ISEMPTY;

            //20.03.2013 EDMS <<
            */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Sell-to Customer No."(Field 25).OnValidate".

        //trigger (Variable: ApprAllowed)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on ""Sell-to Customer No."(Field 25).OnValidate".

        //trigger "(Field 25)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "Sell-to Customer No." = '' THEN
              "Ship-to Code" := ''
            ELSE
              VALIDATE("Ship-to Code",'');

            ReserveReqLine.VerifyChange(Rec,xRec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..6
            //20.03.2013 EDMS >>
            LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
            LicensePermission.SETRANGE("Object Number",CODEUNIT::"Req. Line-Veh. Reserve");
            LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
            ApprAllowed := NOT LicensePermission.ISEMPTY;
            //20.03.2013 EDMS <<
            */
        //end;


        //Unsupported feature: Code Modification on ""Variant Code"(Field 5402).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "Variant Code" <> '' THEN
              TESTFIELD(Type,Type::Item);
            CheckActionMessageNew;
            ReserveReqLine.VerifyChange(Rec,xRec);

            CALCFIELDS("Reserved Qty. (Base)");
            TESTFIELD("Reserved Qty. (Base)",0);

            #9..24
                "Vendor Item No." := ItemVend."Vendor Item No.";
            END ELSE
              VALIDATE("No.");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..5
            //20.03.2013 EDMS >>
            LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
            LicensePermission.SETRANGE("Object Number",CODEUNIT::"Req. Line-Veh. Reserve");
            LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
            ApprAllowed := NOT LicensePermission.ISEMPTY;
            //20.03.2013 EDMS <<

            #6..27
            */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Bin Code"(Field 5403).OnValidate".

        //trigger (Variable: ApprAllowed)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on ""Bin Code"(Field 5403).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            CheckActionMessageNew;
            IF (CurrFieldNo = FIELDNO("Bin Code")) AND
               ("Action Message" <> "Action Message"::" ")
            #4..12
              TESTFIELD("Location Code",Bin."Location Code");
            END;
            ReserveReqLine.VerifyChange(Rec,xRec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..15

            //20.03.2013 EDMS >>
            LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
            LicensePermission.SETRANGE("Object Number",CODEUNIT::"Req. Line-Veh. Reserve");
            LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
            ApprAllowed := NOT LicensePermission.ISEMPTY;
            //20.03.2013 EDMS <<
            */
        //end;
        field(50002;"Battery Job No.";Code[20])
        {
        }
        field(50003;"Order Promising Date";Date)
        {
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

            trigger OnValidate()
            begin
                IF "Deal Type Code" <> '' THEN
                 BEGIN
                  CreateDim(
                   DimMgt.TypeToTableID3(Type),
                    "No.",DATABASE::Vendor,"Vendor No.");
                  CreateDim(
                   DimMgt.TypeToTableID3(Type),
                   "No.",DATABASE::"Deal Type","Deal Type Code");
                 END;
            end;
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
        field(25006020;"Reorder Point";Decimal)
        {
            CalcFormula = Lookup(Item."Reorder Point" WHERE (No.=FIELD(No.)));
            Caption = 'Minimum Quantity';
            FieldClass = FlowField;
        }
        field(25006021;"Maximum Quantity";Decimal)
        {
            CalcFormula = Lookup(Item."Maximum Inventory" WHERE (No.=FIELD(No.)));
            FieldClass = FlowField;
        }
        field(25006100;"Service Order No.";Code[20])
        {
            Caption = 'Sales Order No.';
            Editable = false;
            TableRelation = "Service Header EDMS".No. WHERE (Document Type=CONST(Order));

            trigger OnValidate()
            var
                ApprAllowed: Boolean;
            begin
                ReserveReqLine.VerifyChange(Rec,xRec);

                LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
                LicensePermission.SETRANGE("Object Number",CODEUNIT::"Req. Line-Veh. Reserve");
                LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
                ApprAllowed := NOT LicensePermission.ISEMPTY;
            end;
        }
        field(25006101;"Service Order Line No.";Integer)
        {
            Caption = 'Sales Order Line No.';
            Editable = false;

            trigger OnValidate()
            var
                ApprAllowed: Boolean;
            begin
                ReserveReqLine.VerifyChange(Rec,xRec);

                LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
                LicensePermission.SETRANGE("Object Number",CODEUNIT::"Req. Line-Veh. Reserve");
                LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
                ApprAllowed := NOT LicensePermission.ISEMPTY;
            end;
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
                IF ("Model Code" <> xRec."Model Code") AND ("Model Version No." <> '') THEN
                 BEGIN
                  VALIDATE("Model Version No.",'');
                 END;
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
                  VIN := Vehicle.VIN;
                 END;
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
            var
                recVehicle: Record "25006005";
            begin
                  IF "Model Version No." = '' THEN
                   BEGIN
                    VALIDATE("No.","Model Version No.");
                    VIN := '';
                    "Vehicle Serial No." := '';
                    //"Vehicle Accounting Cycle No." := '';
                   END
                  ELSE
                   VALIDATE("No.","Model Version No.");
            end;
        }
        field(25006375;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';

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
        }
        field(25006376;"Vehicle Assembly ID";Code[20])
        {
            Caption = 'Vehicle Assembly ID';

            trigger OnValidate()
            var
                tcAMT001: Label 'Vehicle assembly list %1 is not empty.';
            begin
                TESTFIELD("Vehicle Serial No.");
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
                VehAccCycle.RESET;
                IF LookUpMgt.LookUpVehicleAccCycle(VehAccCycle,"Vehicle Serial No.","Vehicle Accounting Cycle No.") THEN
                 VALIDATE("Vehicle Accounting Cycle No.",VehAccCycle."No.");
            end;

            trigger OnValidate()
            var
                VehAccCycle: Codeunit "25006303";
            begin
                VehAccCycle.CheckCycleRelation("Vehicle Serial No.","Vehicle Accounting Cycle No.");
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
        field(25006700;"Ordering Price Type Code";Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(99000924;"Inventory Posting Group";Text[30])
        {
            CalcFormula = Lookup(Item."Inventory Posting Group" WHERE (No.=FIELD(No.)));
            Caption = 'Inventory Posting Group';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on ""Order Promising ID,Order Promising Line ID,Order Promising Line No."(Key)".

        key(Key1;"Order Promising ID","Order Promising Line ID","Order Promising Line No.","Order Promising Type")
        {
        }
        key(Key2;"Worksheet Template Name","Journal Batch Name","Vendor No.","Sell-to Customer No.","Ship-to Code","Order Address Code","Currency Code","Location Code","Transfer-from Code",Type,"Ordering Price Type Code","No.")
        {
        }
    }


    //Unsupported feature: Code Insertion (VariableCollection) on "OnDelete".

    //trigger (Variable: ApprAllowed)()
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
        ReqLine.RESET;
        ReqLine.GET("Worksheet Template Name","Journal Batch Name","Line No.");
        WHILE (ReqLine.NEXT <> 0) AND (ReqLine.Level > Level) DO
          ReqLine.DELETE(TRUE);

        ReserveReqLine.DeleteLine(Rec);

        CALCFIELDS("Reserved Qty. (Base)");
        TESTFIELD("Reserved Qty. (Base)",0);

        DeleteRelations;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..6
        //20.03.2013 EDMS >>
        LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
        LicensePermission.SETRANGE("Object Number",CODEUNIT::"Req. Line-Veh. Reserve");
        LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
        ApprAllowed := NOT LicensePermission.ISEMPTY;
        //20.03.2013 EDMS <<
        IF ApprAllowed THEN
          VehReserveReqLine.DeleteLine(Rec);
        #7..11
        */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnInsert".

    //trigger (Variable: ApprAllowed)()
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
        IF CURRENTKEY <> Rec2.CURRENTKEY THEN BEGIN
          Rec2 := Rec;
          Rec2.SETRECFILTER;
        #4..6
        END;

        ReserveReqLine.VerifyQuantity(Rec,xRec);

        ReqWkshTmpl.GET("Worksheet Template Name");
        ReqWkshName.GET("Worksheet Template Name","Journal Batch Name");

        ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..9
        //20.03.2013 EDMS >>
        LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
        LicensePermission.SETRANGE("Object Number",CODEUNIT::"Req. Line-Veh. Reserve");
        LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
        ApprAllowed := NOT LicensePermission.ISEMPTY;
        //20.03.2013 EDMS <<
        #11..15
        */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnModify".

    //trigger (Variable: ApprAllowed)()
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
        ReserveReqLine.VerifyChange(Rec,xRec);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        ReserveReqLine.VerifyChange(Rec,xRec);
        //20.03.2013 EDMS >>
        LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
        LicensePermission.SETRANGE("Object Number",CODEUNIT::"Req. Line-Veh. Reserve");
        LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
        ApprAllowed := NOT LicensePermission.ISEMPTY;
        //20.03.2013 EDMS <<
        */
    //end;


    //Unsupported feature: Code Modification on "UpdateDescription(PROCEDURE 8)".

    //procedure UpdateDescription();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF (Type <> Type::Item) OR ("No." = '') THEN
          EXIT;
        IF "Variant Code" = '' THEN BEGIN
        #4..32
           ("Planning Line Origin" = "Planning Line Origin"::" ")
        THEN
          IF ("Vendor No." <> '') AND NOT IsDropShipment THEN
            "Location Code" := Vend."Location Code"
          ELSE
            "Location Code" := '';
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..35
            //03.11.2015 EB.P7 #T002 >>
            IF Vend."Location Code" <> '' THEN
            //03.11.2015 EB.P7 #T002 <<
            "Location Code" := Vend."Location Code"
          ELSE;
          //  27.05.2016 EB.P30 T036 >>
          // ELSE
          //  "Location Code" := '';
          //  27.05.2016 EB.P30 T036 <<
        */
    //end;


    //Unsupported feature: Code Modification on "CreateDim(PROCEDURE 2)".

    //procedure CreateDim();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        #4..13

        IF "Ref. Order No." <> '' THEN
          GetDimFromRefOrderLine(TRUE);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        // Sipradi-YS GEN6.1.0 Following lines are commented to retrieve default user dimension from user setup.
        {
        #1..16
        }
        */
    //end;

    //Unsupported feature: Variable Insertion (Variable: ApprAllowed) (VariableCollection) on "CheckEndingDate(PROCEDURE 26)".



    //Unsupported feature: Code Modification on "CheckEndingDate(PROCEDURE 26)".

    //procedure CheckEndingDate();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CheckDateConflict.ReqLineCheck(Rec,ShowWarning);
        ReserveReqLine.VerifyChange(Rec,xRec);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        CheckDateConflict.ReqLineCheck(Rec,ShowWarning);
        ReserveReqLine.VerifyChange(Rec,xRec);
        //20.03.2013 EDMS >>
        LicensePermission.SETRANGE("Object Type",LicensePermission."Object Type"::Codeunit);
        LicensePermission.SETRANGE("Object Number",CODEUNIT::"Req. Line-Veh. Reserve");
        LicensePermission.SETFILTER("Execute Permission",'<>%1',LicensePermission."Execute Permission"::" ");
        ApprAllowed := NOT LicensePermission.ISEMPTY;
        //20.03.2013 EDMS <<
        */
    //end;

    procedure ShowVehReservation()
    var
        VehReservation: Page "25006529";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        CLEAR(VehReservation);
        VehReservation.SetReqLine(Rec);
        VehReservation.RUNMODAL;
    end;

    procedure ShowVehReservationEntries(Modal: Boolean)
    var
        VehReservEngineMgt: Codeunit "25006316";
        VehReservEntry: Record "25006392";
        VehReserveReqLine: Codeunit "25006318";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        VehReservEngineMgt.InitFilterAndSortingLookupFor(VehReservEntry);
        VehReserveReqLine.FilterReservFor(VehReservEntry,Rec);
        IF Modal THEN
         PAGE.RUNMODAL(PAGE::"Vehicle Reservation Entries",VehReservEntry)
        ELSE
         PAGE.RUN(PAGE::"Vehicle Reservation Entries",VehReservEntry);
    end;

    procedure NewVehAssemblyNo()
    var
        InvSetup: Record "313";
        NoSeriesMgt: Codeunit "396";
        AssemblyNo: Code[20];
    begin
         IF "Document Profile" = "Document Profile"::"Vehicles Trade" THEN
          BEGIN
           InvSetup.GET;
           InvSetup.TESTFIELD("Vehicle Assembly Nos.");
           NoSeriesMgt.InitSeries(InvSetup."Vehicle Assembly Nos.",InvSetup."Vehicle Assembly Nos.",
              WORKDATE,AssemblyNo,InvSetup."Vehicle Assembly Nos.");
           VALIDATE("Vehicle Assembly ID",AssemblyNo);
          END;
    end;

    procedure VehicleAssembly()
    var
        VehicleAssemby: Record "25006380";
        VehAssemblyWorksheet: Page "25006490";
                                  VehPriceMgt: Codeunit "25006301";
                                  VehOptMgt: Codeunit "25006304";
    begin
        IF "Document Profile" <> "Document Profile"::"Vehicles Trade" THEN
         EXIT;

        TESTFIELD("No.");
        TESTFIELD("Vehicle Serial No.");

        TESTFIELD("Make Code");
        TESTFIELD("Model Code");
        TESTFIELD("Model Version No.");

        IF "Vehicle Assembly ID" = '' THEN
         NewVehAssemblyNo;

        VehPriceMgt.ChkAssemblyHdrReqLine(Rec);
        VehOptMgt.FillVehAssembly("Vehicle Serial No.","Vehicle Assembly ID","Make Code","Model Code","Model Version No.");



        VehicleAssemby.SETRANGE("Assembly ID","Vehicle Assembly ID");
        VehicleAssemby.SETRANGE("Make Code","Make Code");
        VehicleAssemby.SETRANGE("Model Code","Model Code");
        VehicleAssemby.SETRANGE("Model Version No.","Model Version No.");
        VehicleAssemby.SETRANGE("Serial No.","Vehicle Serial No.");

        CLEAR(VehAssemblyWorksheet);
        VehAssemblyWorksheet.SETTABLEVIEW(VehicleAssemby);
        VehAssemblyWorksheet.RUN;
    end;

    procedure GetReservForInfo(ReturnValue: Option CustomerNo,VIN,DealType,CustomerName,OrderingPriceType): Text[50]
    begin
        EXIT(ReservEngineMgt.GetReservInfoForFactBox(ReturnValue, "Worksheet Template Name", "Line No.", DATABASE::"Requisition Line", 0, 0, "Journal Batch Name"));
    end;

    procedure SetPriceTypeCode()
    begin
        //06.06.2014 EDMS P8 >>
        IF "Ordering Price Type Code" = '' THEN
          VALIDATE("Ordering Price Type Code", GetReservForInfo(4)); //CustomerNo,VIN,DealType,CustomerName,OrderingPriceType
        //06.06.2014 EDMS P8 <<
    end;

    var
        ApprAllowed: Boolean;

    var
        ApprAllowed: Boolean;

    var
        ApprAllowed: Boolean;

    var
        ApprAllowed: Boolean;

    var
        ApprAllowed: Boolean;

    var
        ApprAllowed: Boolean;

    var
        ApprAllowed: Boolean;

    var
        ApprAllowed: Boolean;

    var
        ApprAllowed: Boolean;

    var
        ApprAllowed: Boolean;


    //Unsupported feature: Property Modification (Id) on "ReplenishmentErr(Variable 1073)".

    //var
        //>>>> ORIGINAL VALUE:
        //ReplenishmentErr : 1073;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //ReplenishmentErr : 1001073;
        //Variable type has not been exported.

    var
        CompanyInformation: Record "79";

    var
        LookUpMgt: Codeunit "25006003";
        VehReserveReqLine: Codeunit "25006318";
        LicensePermission: Record "2000000043";
        ResponsibilityCenter: Record "5714";
        UserSetup: Record "91";
        Locations: Record "14";
        NotValidLocation: Label 'Your Location (%1) is not valid Store Location.';
}


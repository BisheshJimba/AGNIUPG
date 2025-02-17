tableextension 50473 tableextension50473 extends "Item Journal Line"
{
    // 26.07.2007. EDMS P2
    //   * Added new key "Journal Template Name,Journal Batch Name,Item Category Code,Product Group Code"
    // 
    // 31.05.2007. EDMS P2
    //   *Added code to Model Version No. - OnValidate()
    fields
    {
        modify("Source No.")
        {
            TableRelation = IF (Source Type=CONST(Customer)) Customer
                            ELSE IF (Source Type=CONST(Vendor)) Vendor
                            ELSE IF (Source Type=CONST(Item)) Item;
        }

        //Unsupported feature: Property Modification (Data type) on "Description(Field 8)".

        modify("Source Posting Group")
        {
            TableRelation = IF (Source Type=CONST(Customer)) "Customer Posting Group"
                            ELSE IF (Source Type=CONST(Vendor)) "Vendor Posting Group"
                            ELSE IF (Source Type=CONST(Item)) "Inventory Posting Group";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity"(Field 68)".

        modify("Order Line No.")
        {
            TableRelation = IF (Order Type=CONST(Production)) "Prod. Order Line"."Line No." WHERE (Status=CONST(Released),
                                                                                                   Prod. Order No.=FIELD(Order No.));
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

        modify("Bin Code")
        {
            TableRelation = IF (Entry Type=FILTER(Purchase|Positive Adjmt.|Output),
                                Quantity=FILTER(>=0)) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                      Item Filter=FIELD(Item No.),
                                                                      Variant Filter=FIELD(Variant Code))
                                                                      ELSE IF (Entry Type=FILTER(Purchase|Positive Adjmt.|Output),
                                                                               Quantity=FILTER(<0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                    Item No.=FIELD(Item No.),
                                                                                                                                    Variant Code=FIELD(Variant Code))
                                                                                                                                    ELSE IF (Entry Type=FILTER(Sale|Negative Adjmt.|Transfer|Consumption),
                                                                                                                                             Quantity=FILTER(>0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                                                  Item No.=FIELD(Item No.),
                                                                                                                                                                                                  Variant Code=FIELD(Variant Code))
                                                                                                                                                                                                  ELSE IF (Entry Type=FILTER(Sale|Negative Adjmt.|Transfer|Consumption),
                                                                                                                                                                                                           Quantity=FILTER(<=0)) Bin.Code WHERE (Location Code=FIELD(Location Code),
                                                                                                                                                                                                                                                 Item Filter=FIELD(Item No.),
                                                                                                                                                                                                                                                 Variant Filter=FIELD(Variant Code));
        }
        modify("New Bin Code")
        {
            TableRelation = Bin.Code WHERE (Location Code=FIELD(New Location Code),
                                            Item Filter=FIELD(Item No.),
                                            Variant Filter=FIELD(Variant Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Qty. (Base)"(Field 5468)".

        modify("Invoice-to Source No.")
        {
            TableRelation = IF (Source Type=CONST(Customer)) Customer
                            ELSE IF (Source Type=CONST(Vendor)) Vendor;
        }
        modify("No.")
        {
            TableRelation = IF (Type=CONST(Machine Center)) "Machine Center"
                            ELSE IF (Type=CONST(Work Center)) "Work Center"
                            ELSE IF (Type=CONST(Resource)) Resource;
        }
        modify("Operation No.")
        {
            TableRelation = IF (Order Type=CONST(Production)) "Prod. Order Routing Line"."Operation No." WHERE (Status=CONST(Released),
                                                                                                                Prod. Order No.=FIELD(Order No.),
                                                                                                                Routing No.=FIELD(Routing No.),
                                                                                                                Routing Reference No.=FIELD(Routing Reference No.));
        }
        modify("Cap. Unit of Measure Code")
        {
            TableRelation = IF (Type=CONST(Resource)) "Resource Unit of Measure".Code WHERE (Resource No.=FIELD(No.))
                            ELSE "Capacity Unit of Measure";
        }
        modify("Prod. Order Comp. Line No.")
        {
            TableRelation = IF (Order Type=CONST(Production)) "Prod. Order Component"."Line No." WHERE (Status=CONST(Released),
                                                                                                        Prod. Order No.=FIELD(Order No.),
                                                                                                        Prod. Order Line No.=FIELD(Order Line No.));
        }


        //Unsupported feature: Code Modification on ""Item No."(Field 3).OnValidate".

        //trigger "(Field 3)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "Item No." <> xRec."Item No." THEN BEGIN
              "Variant Code" := '';
              "Bin Code" := '';
            #4..32
            "Item Category Code" := Item."Item Category Code";
            "Product Group Code" := Item."Product Group Code";

            IF ("Value Entry Type" <> "Value Entry Type"::"Direct Cost") OR
               ("Item Charge No." <> '')
            THEN BEGIN
            #39..145
                DATABASE::"Work Center","Work Center No.");

            ReserveItemJnlLine.VerifyChange(Rec,xRec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            //EDMS1.0.00 >>
              IF ItemJnlBatch.GET("Journal Template Name","Journal Batch Name") THEN
              BEGIN
                IF ItemJnlBatch."Location Code" <> '' THEN
                  VALIDATE("Location Code",ItemJnlBatch."Location Code");
                IF ItemJnlBatch."New Location Code" <> '' THEN
                  VALIDATE("New Location Code",ItemJnlBatch."New Location Code");
              END;
            //EDMS1.0.00 <<

            #1..35
            //EDMS1.0.00 >>
             "Product Subgroup Code" := Item."Product Subgroup Code";
             "Item Type" := Item."Item Type";
             IF "Item Type" = "Item Type"::"Model Version" THEN
              BEGIN
               "Make Code" := Item."Make Code";
               "Model Code" := Item."Model Code";
               "Model Version No." := Item."No.";
              END;
            //EDMS1.0.00 <<

            #36..148
            */
        //end;


        //Unsupported feature: Code Modification on ""Location Code"(Field 9).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "Entry Type" <= "Entry Type"::Transfer THEN
              TESTFIELD("Item No.");

            #4..31
            VALIDATE("Unit of Measure Code");

            ReserveItemJnlLine.VerifyChange(Rec,xRec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            UserSetup.GET(USERID); //Min 1.23.2020
            IF "Location Code" <> '' THEN
              IF Rec."Location Code" <> UserSetup."Default Location" THEN
               ERROR(ReclassConfirm,Rec."Location Code");

            #1..34
            */
        //end;
        field(50001;"Import Invoice No.";Code[20])
        {
            TableRelation = "Purch. Inv. Header".No.;
        }
        field(50055;"Invertor Serial No.";Code[20])
        {
            Caption = 'Invertor Serial No.';
            TableRelation = "Serial No. Information"."Serial No.";
        }
        field(70000;"Supplier Code";Code[10])
        {
        }
        field(70001;"Parent Lot No.";Code[30])
        {
        }
        field(70002;"QR Code";Code[250])
        {
        }
        field(70003;"Package No.";Code[20])
        {
        }
        field(70004;Id;Guid)
        {
        }
        field(25006000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade";
        }
        field(25006001;"Item Type";Option)
        {
            Caption = 'Item Type';
            OptionCaption = ' ,Item,Model Version';
            OptionMembers = ,Item,"Model Version";
        }
        field(25006002;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006003;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(25006004;"Model Version No.";Code[20])
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
                IF cuLookUpMgt.LookUpModelVersion(recItem,"Model Version No.","Make Code","Model Code") THEN
                 VALIDATE("Model Version No.",recItem."No.");
            end;

            trigger OnValidate()
            begin
                IF "Model Version No." = '' THEN
                  EXIT;
                VALIDATE("Item No.","Model Version No.");
            end;
        }
        field(25006005;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vehicle;

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
            begin
                recVehicle.RESET;
                IF cuLookUpMgt.LookUpVehicleAMT(recVehicle,"Vehicle Serial No.") THEN
                 BEGIN
                  VALIDATE("Vehicle Serial No.",recVehicle."Serial No.");
                  VIN := recVehicle.VIN;
                 END;
            end;
        }
        field(25006010;"Deal Type Code";Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006025;"External Document No. 2";Code[20])
        {
            Caption = 'External Document No. 2';
        }
        field(25006030;"Campaign No.";Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(25006160;"Transfer Source Type";Integer)
        {
            Caption = 'Transfer Source Type';
            Editable = false;
        }
        field(25006166;"Transfer Source Subtype";Option)
        {
            Caption = 'Transfer Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(25006170;"Vehicle Registration No.";Code[50])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;

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
                  MESSAGE(STRSUBSTNO(Text100, "Vehicle Registration No."), '');
            end;
        }
        field(25006200;"Transfer Source No.";Code[20])
        {
            Caption = 'Transfer Source No.';
            TableRelation = IF (Transfer Source Type=CONST(25006145)) "Service Header EDMS".No. WHERE (Document Type=FIELD(Transfer Source Subtype),
                                                                                                       No.=FIELD(Transfer Source No.));
        }
        field(25006373;"Vehicle Assembly No.";Code[20])
        {
            Caption = 'Vehicle Assembly No.';
        }
        field(25006375;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
            begin
                recVehicle.RESET;
                IF cuLookUpMgt.LookUpVehicleAMT(recVehicle,"Vehicle Serial No.") THEN
                 BEGIN
                  VALIDATE("Vehicle Serial No.",recVehicle."Serial No.");
                  VIN := recVehicle.VIN;
                 END;
            end;

            trigger OnValidate()
            var
                recVehicle: Record "25006005";
                codSerialNoPre: Code[20];
                codDefCycle: Code[20];
                cuVehAccCycle: Codeunit "25006303";
                vehi: Record "33019823";
            begin
                IF "Vehicle Serial No." = '' THEN
                 BEGIN
                  VIN := '';
                  "Vehicle Accounting Cycle No." := '';
                  "Vehicle Registration No." := '';
                 END
                ELSE
                 BEGIN
                  IF recVehicle.GET("Vehicle Serial No.") THEN
                   BEGIN
                    codSerialNoPre := "Vehicle Serial No.";
                    VALIDATE("Make Code",recVehicle."Make Code");
                    VALIDATE("Model Code",recVehicle."Model Code");
                    VALIDATE("Model Version No.",recVehicle."Model Version No.");
                    VIN := recVehicle.VIN;
                    "Vehicle Serial No." := codSerialNoPre;
                    "Vehicle Registration No." := recVehicle."Registration No.";
                    IF vehi.GET("Vehicle Serial No.") THEN;
                    vehi.CALCFIELDS("Default Vehicle Acc. Cycle No.");
                    VALIDATE("Vehicle Accounting Cycle No.",vehi."Default Vehicle Acc. Cycle No.");
                   END
                  ELSE
                   BEGIN
                    VIN := '';
                    codDefCycle := cuVehAccCycle.GetDefaultCycle("Vehicle Serial No.","Vehicle Accounting Cycle No.");
                    VALIDATE("Vehicle Accounting Cycle No.",codDefCycle);
                   END;
                 END;
            end;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle".No.;

            trigger OnLookup()
            var
                recVehAccCycle: Record "25006024";
            begin
                recVehAccCycle.RESET;
                IF cuLookUpMgt.LookUpVehicleAccCycle(recVehAccCycle,"Vehicle Serial No.","Vehicle Accounting Cycle No.") THEN
                 VALIDATE("Vehicle Accounting Cycle No.",recVehAccCycle."No.");
            end;
        }
        field(25006382;Reserved;Boolean)
        {
            CalcFormula = Exist("Vehicle Reservation Entry" WHERE (Source Ref. No.=FIELD(Line No.),
                                                                   Source ID=FIELD(Journal Template Name),
                                                                   Source Batch Name=FIELD(Journal Batch Name),
                                                                   Source Type=CONST(83),
                                                                   Source Subtype=FIELD(Entry Type)));
            Caption = 'Reserved';
            Description = 'Only for Vehicles';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006670;"Product Subgroup Code";Code[10])
        {
            Caption = 'Product Subgroup Code';
            TableRelation = "Product Subgroup".Code WHERE (Item Category Code=FIELD(Item Category Code),
                                                           Product Group Code=FIELD(Product Group Code));
        }
        field(25006680;"Not To Post";Boolean)
        {
            Caption = 'Not To Post';
        }
        field(33019810;"Summary No.";Code[20])
        {
        }
        field(33020011;"Sys. LC No.";Code[20])
        {
            Caption = 'LC No.';

            trigger OnValidate()
            var
                LCAmendDetail: Record "33020013";
                LCDetail: Record "33020012";
                Text33020011: Label 'LC Amendment is not released.';
                Text33020012: Label 'LC Amendment is closed.';
                Text33020013: Label 'LC Details is not released.';
                Text33020014: Label 'LC Details is closed.';
            begin
            end;
        }
        field(33020012;"Bank LC No.";Code[20])
        {
        }
        field(33020013;"LC Amend No.";Code[20])
        {
        }
        field(33020163;"CC Memo No.";Code[20])
        {
        }
        field(33020164;"PP No.";Code[20])
        {
        }
        field(33020252;"Scheme Code";Code[20])
        {
            TableRelation = "Service Scheme Header";
        }
        field(33020253;"Membership No.";Code[20])
        {
            TableRelation = "Membership Details";
        }
    }
    keys
    {
        key(Key1;"Journal Template Name","Journal Batch Name","Item Category Code","Product Group Code")
        {
        }
        key(Key2;"Location Code","Bin Code")
        {
        }
    }


    //Unsupported feature: Code Insertion (VariableCollection) on "OnDelete".

    //trigger (Variable: SlsLine)()
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
        ReserveItemJnlLine.DeleteLine(Rec);

        CALCFIELDS("Reserved Qty. (Base)");
        TESTFIELD("Reserved Qty. (Base)",0);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*

        #1..4
        */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        LOCKTABLE;
        ItemJnlTemplate.GET("Journal Template Name");
        ItemJnlBatch.GET("Journal Template Name","Journal Batch Name");

        ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
        ValidateNewShortcutDimCode(1,"New Shortcut Dimension 1 Code");
        ValidateNewShortcutDimCode(2,"New Shortcut Dimension 2 Code");

        CheckPlanningAssignment;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..4
        UserSetup.GET(USERID);
        VALIDATE("Shortcut Dimension 1 Code",UserSetup."Shortcut Dimension 1 Code");
        VALIDATE("Shortcut Dimension 2 Code",UserSetup."Shortcut Dimension 2 Code");
        #5..10
        */
    //end;


    //Unsupported feature: Code Modification on "CopyFromSalesHeader(PROCEDURE 58)".

    //procedure CopyFromSalesHeader();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Posting Date" := SalesHeader."Posting Date";
        "Document Date" := SalesHeader."Document Date";
        "Order Date" := SalesHeader."Order Date";
        "Source Posting Group" := SalesHeader."Customer Posting Group";
        "Salespers./Purch. Code" := SalesHeader."Salesperson Code";
        "Reason Code" := SalesHeader."Reason Code";
        "Source Currency Code" := SalesHeader."Currency Code";
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..7

        "Sys. LC No." := SalesHeader."Sys. LC No."; //LC Integration.
        "Bank LC No." := SalesHeader."Bank LC No.";
        "LC Amend No." := SalesHeader."LC Amend No.";
        "Invertor Serial No." := SalesHeader."Invertor Serial No."; //Agile Chandra 01 Sep 2015
        */
    //end;


    //Unsupported feature: Code Modification on "CopyFromSalesLine(PROCEDURE 12)".

    //procedure CopyFromSalesLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Item No." := SalesLine."No.";
        Description := SalesLine.Description;
        "Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
        #4..35
        "Source Type" := "Source Type"::Customer;
        "Source No." := SalesLine."Sell-to Customer No.";
        "Invoice-to Source No." := SalesLine."Bill-to Customer No.";
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..38

        //SS1.00
        "Scheme Code" := SalesLine."Scheme Code";
        "Membership No." := SalesLine."Membership No.";
        //SS1.00
        */
    //end;


    //Unsupported feature: Code Modification on "CopyFromPurchHeader(PROCEDURE 57)".

    //procedure CopyFromPurchHeader();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Posting Date" := PurchHeader."Posting Date";
        "Document Date" := PurchHeader."Document Date";
        "Source Posting Group" := PurchHeader."Vendor Posting Group";
        "Salespers./Purch. Code" := PurchHeader."Purchaser Code";
        "Country/Region Code" := PurchHeader."Buy-from Country/Region Code";
        "Reason Code" := PurchHeader."Reason Code";
        "Source Currency Code" := PurchHeader."Currency Code";
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..7
        //AGNI UPG 2009>>
        "Import Invoice No." := PurchHeader."Import Invoice No."; // Sipradi-YS 7.14.2012
        //AGNI UPG 2009<<
        */
    //end;


    //Unsupported feature: Code Modification on "CopyFromPurchLine(PROCEDURE 160)".

    //procedure CopyFromPurchLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Item No." := PurchLine."No.";
        Description := PurchLine.Description;
        "Shortcut Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
        #4..7
        "Variant Code" := PurchLine."Variant Code";
        "Item Category Code" := PurchLine."Item Category Code";
        "Product Group Code" := PurchLine."Product Group Code";
        "Inventory Posting Group" := PurchLine."Posting Group";
        "Gen. Bus. Posting Group" := PurchLine."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := PurchLine."Gen. Prod. Posting Group";
        #14..41
        "Indirect Cost %" := PurchLine."Indirect Cost %";
        "Overhead Rate" := PurchLine."Overhead Rate";
        "Return Reason Code" := PurchLine."Return Reason Code";
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..10


        //AGNI UPG 2009>>
        //Agile6.1.0 >> Sangam.
        PurchLine.CALCFIELDS("Sys. LC No.","Bank LC No.","LC Amend No.");
        "Sys. LC No." := PurchLine."Sys. LC No.";
        "Bank LC No." := PurchLine."Bank LC No.";
        "LC Amend No." := PurchLine."LC Amend No.";
        "Summary No." := PurchLine."Summary No.";
        //Agile6.1.0 >>
        //AGNI UPG 2009<<

        #11..44
        */
    //end;

    //Unsupported feature: Variable Insertion (Variable: UnitCost2) (VariableCollection) on "RetrieveCosts(PROCEDURE 5803)".



    //Unsupported feature: Code Modification on "RetrieveCosts(PROCEDURE 5803)".

    //procedure RetrieveCosts();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF ("Value Entry Type" <> "Value Entry Type"::"Direct Cost") OR
           ("Item Charge No." <> '')
        THEN
        #4..9
        ELSE
          UnitCost := Item."Unit Cost";

        IF "Entry Type" = "Entry Type"::Transfer THEN
          UnitCost := 0
        ELSE
          IF Item."Costing Method" <> Item."Costing Method"::Standard THEN
            UnitCost := ROUND(UnitCost,GLSetup."Unit-Amount Rounding Precision");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..12
        //07.11.2007. EDMS P2 >>
         IF (Item."Item Type" = Item."Item Type"::"Model Version") AND ("Vehicle Serial No." <> '')  THEN BEGIN
          UnitCost2 := CalcVehicleUnitCost("Vehicle Serial No.", VehAdditionalExpenses);
          IF UnitCost2 <> 0 THEN
           UnitCost := UnitCost2;
          END;
        //07.11.2007. EDMS P2 <<

        #13..17
        */
    //end;


    //Unsupported feature: Code Modification on "LookupItemNo(PROCEDURE 37)".

    //procedure LookupItemNo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CASE "Entry Type" OF
          "Entry Type"::Consumption:
            LookupProdOrderComp;
          "Entry Type"::Output:
            LookupProdOrderLine;
          ELSE BEGIN
            ItemList.LOOKUPMODE := TRUE;
            IF ItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
              ItemList.GETRECORD(Item);
              VALIDATE("Item No.",Item."No.");
            END;
          END;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..6
            //20.11.2014 EB.P8 MERGE
            //EDMS1.0.00 >>
            //ItemList.LOOKUPMODE := TRUE;
            //IF ItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            //  ItemList.GETRECORD(Item);
            //  VALIDATE("Item No.",Item."No.");
            //END;
            Item.RESET;
            IF cuLookUpMgt.LookUpItemREZ(Item, "Item No.") THEN
              VALIDATE("Item No.",Item."No.");
            //EDMS1.0.00 <<
          END;
        END;
        */
    //end;

    procedure CalcVehicleUnitCost(VehSerialNo: Code[20];AddAdditionalExpenses: Boolean): Decimal
    var
        ValueEntry: Record "5802";
        ItemLedgerEntry: Record "32";
        InventoryPostingGroup: Record "94";
        UnitCostLoc: Decimal;
    begin
        UnitCostLoc := 0;
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETCURRENTKEY("Serial No.");
        ItemLedgerEntry.SETRANGE("Serial No.", VehSerialNo);
        ItemLedgerEntry.SETRANGE(Open, TRUE);
        IF ItemLedgerEntry.FINDFIRST THEN
         REPEAT
          ValueEntry.RESET;
          ValueEntry.SETCURRENTKEY("Item Ledger Entry No.");
          ValueEntry.SETRANGE("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
          IF ValueEntry.FINDFIRST THEN
           REPEAT
            IF InventoryPostingGroup.GET(ValueEntry."Inventory Posting Group") THEN;
              IF AddAdditionalExpenses OR NOT(InventoryPostingGroup."Vehicle Additional Expenses") THEN
                UnitCostLoc += ValueEntry."Cost Amount (Actual)";
           UNTIL ValueEntry.NEXT = 0;
         UNTIL ItemLedgerEntry.NEXT = 0;

         EXIT(UnitCostLoc);
    end;

    procedure SetVehAdditionalExpenses(VehAdditionalExpenses1: Boolean)
    begin
        VehAdditionalExpenses := VehAdditionalExpenses1;
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

    var
        SlsLine: Record "37";

    var
        cuLookUpMgt: Codeunit "25006003";

    var
        VehAdditionalExpenses: Boolean;
        Text100: Label 'There is no vehicle with Registration No. %1';
        LookUpMgt: Codeunit "25006003";
        UserSetup: Record "91";
        ReclassConfirm: Label 'You are not authorized to Reclass Journal From Location Code %1.';
}


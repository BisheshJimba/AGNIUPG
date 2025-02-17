tableextension 50154 tableextension50154 extends "Item Ledger Entry"
{
    // 29.01.2010 EDMS P2
    //   * Added key "Campaign No.,Entry Type"
    // 
    // 19.09.2007. EDMS P2
    //   * Added SumIndexField Quantity to key "Location Code,Serial No.,Item Type,Posting Date"
    // 
    // 20.06.2007. EDMS P2
    //   * Added key Location Code, Serial No., Item Type, Posting Date
    fields
    {
        modify("Source No.")
        {
            TableRelation = IF (Source Type=CONST(Customer)) Customer
                            ELSE IF (Source Type=CONST(Vendor)) Vendor
                            ELSE IF (Source Type=CONST(Item)) Item;
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Reserved Quantity"(Field 70)".


        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".


        //Unsupported feature: Property Deletion (TableRelation) on ""Dimension Set ID"(Field 480)".

        field(50000; "Item For"; Option)
        {
            Editable = false;
            OptionMembers = " ",GPD,SPD,VHD,BTD,LBD,CVD,PCD;
        }
        field(50001; "Import Invoice No."; Code[20])
        {
            Editable = false;
            TableRelation = "Purch. Inv. Header".No.;
        }
        field(50055; "Invertor Serial No."; Code[20])
        {
            Caption = 'Invertor Serial No.';
            TableRelation = "Serial No. Information"."Serial No.";
        }
        field(70000; "QR Code Text"; Code[250])
        {
            Description = 'QR19.00';
        }
        field(70001; "QR Code Blob"; BLOB)
        {
            Description = 'QR19.00';
            SubType = Bitmap;
        }
        field(70002; "QR Code Printed"; Boolean)
        {
            Description = 'QR19.00';
        }
        field(70003; "QR No. of Times Printed"; Integer)
        {
            Description = 'QR19.00';
        }
        field(70004; "QR Status"; Option)
        {
            Description = 'QR19.00';
            OptionCaption = ' ,Verified,Lost';
            OptionMembers = " ",Verified,Lost;
        }
        field(70005; "Package No."; Code[20])
        {
        }
        field(70006; "Supplier Code"; Code[10])
        {
        }
        field(70007; "Parent Lot No."; Code[30])
        {
        }
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001; "Item Type"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = ' ,Item,Model Version';
            OptionMembers = " ",Item,"Model Version";
        }
        field(25006002; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006003; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
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
                recItem.SETCURRENTKEY("Item Type","Make Code","Model Code");
                recItem.SETRANGE("Item Type",recItem."Item Type"::"Model Version");
                recItem.SETRANGE("Make Code","Make Code");
                recItem.SETRANGE("Model Code","Model Code");
                IF PAGE.RUNMODAL(PAGE::"Item List",recItem) = ACTION::LookupOK THEN //30.10.2012 EDMS
                 BEGIN
                  VALIDATE("Model Version No.",recItem."No.");
                 END;
            end;
        }
        field(25006005;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Serial No.)));
            Caption = 'VIN';
            FieldClass = FlowField;
            TableRelation = Vehicle;
        }
        field(25006007;"Value Entry Reason Code";Code[10])
        {
            CalcFormula = Lookup("Value Entry"."Reason Code" WHERE (Item Ledger Entry No.=FIELD(Entry No.)));
            Caption = 'Value Entry Reason Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006008;"Value Entry Document No.";Code[20])
        {
            CalcFormula = Lookup("Value Entry"."Document No." WHERE (Item Ledger Entry No.=FIELD(Entry No.)));
            Caption = 'Value Entry Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006009;"Value Entry Salespers. Code";Code[10])
        {
            CalcFormula = Lookup("Value Entry"."Salespers./Purch. Code" WHERE (Item Ledger Entry No.=FIELD(Entry No.)));
            Caption = 'Value Entry Salespers. Code';
            Editable = false;
            FieldClass = FlowField;
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
        field(25006170;"Vehicle Registration No.";Code[30])
        {
            CalcFormula = Lookup(Vehicle."Registration No." WHERE (Serial No.=FIELD(Serial No.)));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006200;"Transfer Source No.";Code[20])
        {
            Caption = 'Transfer Source No.';
            TableRelation = IF (Transfer Source Type=CONST(25006145)) "Service Header EDMS".No. WHERE (Document Type=FIELD(Transfer Source Subtype),
                                                                                                       No.=FIELD(Transfer Source No.));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle".No.;

            trigger OnLookup()
            var
                recVehAccCycleNo: Record "25006024";
                cuLookupMgt: Codeunit "25006003";
            begin
                recVehAccCycleNo.RESET;
                IF cuLookupMgt.LookUpVehicleAccCycle(recVehAccCycleNo,"Serial No.","Vehicle Accounting Cycle No.") THEN;
            end;
        }
        field(25006382;Reserved;Boolean)
        {
            CalcFormula = Exist("Vehicle Reservation Entry" WHERE (Source Type=CONST(32),
                                                                   Source Ref. No.=FIELD(Entry No.)));
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
        field(25006690;"Exchange Unit";Boolean)
        {
            CalcFormula = Lookup(Item."Exchange Unit" WHERE (No.=FIELD(Item No.)));
            Caption = 'Exchange Unit';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33019884;Scrap;Boolean)
        {
        }
        field(33020011;"System LC No.";Code[20])
        {
            Caption = 'LC No.';
        }
        field(33020012;"Bank LC No.";Code[20])
        {
        }
        field(33020013;"LC Amend No.";Code[20])
        {
        }
        field(33020014;"VC No.";Code[20])
        {
        }
        field(33020015;"Summary No.";Code[20])
        {
            Description = 'Store Requisition Summary No.';
        }
        field(33020163;"CC Memo No.";Code[20])
        {
        }
        field(33020164;"PP No.";Code[20])
        {
        }
        field(33020165;"Balance at Date";Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE (Posting Date=FIELD(FILTER(Date Filter)),
                                                                  Location Code=FIELD(Location Code),
                                                                  Item No.=FIELD(Item No.)));
            FieldClass = FlowField;
        }
        field(33020166;"Date Filter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(33020167;"Post Sales Created";Boolean)
        {
            Description = 'To indicate vehicles whose 7th contact has been already created and to skip next time';
            Editable = false;
        }
        field(33020252;"Scheme Code";Code[20])
        {
            TableRelation = "Service Scheme Header";
        }
        field(33020253;"Membership No.";Code[20])
        {
            TableRelation = "Membership Details";
        }
        field(33020254;Updated;Boolean)
        {
            Description = 'Temporary';
        }
    }
    keys
    {

        //Unsupported feature: Property Deletion (Enabled) on ""Item No.,Entry Type,Variant Code,Drop Shipment,Global Dimension 1 Code,Global Dimension 2 Code,Location Code,Posting Date"(Key)".


        //Unsupported feature: Property Deletion (Enabled) on ""Source Type,Source No.,Global Dimension 1 Code,Global Dimension 2 Code,Item No.,Variant Code,Posting Date"(Key)".


        //Unsupported feature: Property Deletion (Enabled) on ""Entry Type,Nonstock,Item No.,Posting Date"(Key)".


        //Unsupported feature: Property Deletion (Enabled) on ""Item No.,Location Code,Open,Variant Code,Unit of Measure Code,Lot No.,Serial No."(Key)".


        //Unsupported feature: Property Deletion (Enabled) on ""Item No.,Open,Variant Code,Positive,Lot No.,Serial No."(Key)".


        //Unsupported feature: Property Deletion (Enabled) on ""Lot No."(Key)".


        //Unsupported feature: Property Deletion (Enabled) on ""Serial No."(Key)".

        key(Key1;"Serial No.","Vehicle Accounting Cycle No.","Item Type")
        {
        }
        key(Key2;"Item Type")
        {
        }
        key(Key3;"Location Code","Serial No.","Item Type","Posting Date")
        {
            SumIndexFields = Quantity;
        }
        key(Key4;"Campaign No.","Entry Type")
        {
        }
        key(Key5;"Document No.","Posting Date")
        {
        }
        key(Key6;"Entry Type","System LC No.","LC Amend No.","VC No.")
        {
            SumIndexFields = Quantity;
        }
        key(Key7;"Location Code","Item No.","Posting Date")
        {
            SumIndexFields = Quantity;
        }
        key(Key8;"System LC No.","Variant Code")
        {
            SumIndexFields = Quantity;
        }
        key(Key9;"Serial No.","Make Code")
        {
        }
        key(Key10;"Transfer Source No.","Item No.")
        {
        }
        key(Key11;"Item No.","Document No.","Entry Type","Document Type","Location Code",Open,"Remaining Quantity","Package No.")
        {
            SumIndexFields = Quantity;
        }
        key(Key12;"QR Code Text")
        {
        }
        key(Key13;"Item No.",Positive,"Variant Code","Lot No.")
        {
            SumIndexFields = Quantity;
        }
        key(Key14;"Item No.","Location Code","Variant Code","Lot No.")
        {
            SumIndexFields = Quantity;
        }
        key(Key15;"Supplier Code","Item No.","Parent Lot No.")
        {
        }
    }


    //Unsupported feature: Code Modification on "VerifyOnInventory(PROCEDURE 9)".

    //procedure VerifyOnInventory();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF NOT Open THEN
          EXIT;
        IF Quantity >= 0 THEN
          EXIT;
        CASE "Entry Type" OF
          "Entry Type"::Consumption,"Entry Type"::"Assembly Consumption","Entry Type"::Transfer:
            ERROR(IsNotOnInventoryErr,"Item No.");
          ELSE BEGIN
            Item.GET("Item No.");
            IF Item.PreventNegativeInventory THEN
              ERROR(IsNotOnInventoryErr,"Item No.");
          END;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..5
          "Entry Type"::Consumption,"Entry Type"::"Assembly Consumption","Entry Type"::Transfer,"Entry Type"::Sale,"Entry Type"::"Negative Adjmt.": // Entry Type Sale,-ve adjmt Added UPG.17.12
            ERROR(IsNotOnInventoryErr,"Item No.");  //ratan temp
        #8..13
        */
    //end;
}


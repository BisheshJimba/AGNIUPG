tableextension 50405 tableextension50405 extends "Return Receipt Line"
{
    // 22.10.2015 NAV2016 Merge
    //   ShowItemSalesCrMemoLines, ShowLineComments set to public
    // 
    // 08.04.2013 EDMS P8
    //   * Deleted fields: 'Mechanic No.', 'Transfer Item Ledger Entry No.'
    // 
    // 28.12.2007 EDMS P5
    //         * Changed property "OptionString" for field "Type"
    //           from  ",G/L Account,Item,Resource,Fixed Asset,Charge (Item)"
    //           to " ,G/L Account,Item,Resource,Fixed Asset,Charge (Item),,External Service"
    // 
    //         * Changed property "TableRelation" for field "No."
    //           from "IF (Type=CONST(G/L Account)) "G/L Account"
    //               ELSE IF (Type=CONST(Item)) Item
    //               ELSE IF (Type=CONST(Resource)) Resource
    //               ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
    //               ELSE IF (Type=CONST("Charge (Item)")) "Item Charge""
    //           to "IF (Type=CONST(G/L Account)) "G/L Account"
    //               ELSE IF (Type=CONST(Item)) Item
    //               ELSE IF (Type=CONST(Resource)) Resource
    //               ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
    //               ELSE IF (Type=CONST("Charge (Item)")) "Item Charge"
    //               ELSE IF (Type=CONST(External Service)) "External Service EDMS""
    // 
    //         * Added new field
    //           25006130 "Ext. Service Tracking No."
    fields
    {
        modify(Type)
        {
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item),,External Service';

            //Unsupported feature: Property Modification (OptionString) on "Type(Field 5)".

        }
        modify("No.")
        {
            TableRelation = IF (Type = CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST(Resource)) Resource
                            ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                            ELSE IF (Type=CONST("Charge (Item)")) "Item Charge"
                            ELSE IF (Type=CONST(External Service)) "External Service";
        }
        modify("Posting Group")
        {
            TableRelation = IF (Type=CONST(Item)) "Inventory Posting Group"
                            ELSE IF (Type=CONST(Fixed Asset)) "FA Posting Group";
        }
        modify("Blanket Order Line No.")
        {
            TableRelation = "Sales Line"."Line No." WHERE (Document Type=CONST(Blanket Order),
                                                           Document No.=FIELD(Blanket Order No.));
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

        modify("Bin Code")
        {
            TableRelation = Bin.Code WHERE (Location Code=FIELD(Location Code),
                                            Item Filter=FIELD(No.),
                                            Variant Filter=FIELD(Variant Code));
        }
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }

        //Unsupported feature: Property Deletion (Editable) on ""Return Order No."(Field 6602)".


        //Unsupported feature: Property Deletion (Editable) on ""Return Order Line No."(Field 6603)".

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
        field(25006000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001;"Deal Type Code";Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006002;"Payment Method Code";Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(25006010;"Item No. for Print";Code[20])
        {
            Caption = 'Item No. for Print';
            TableRelation = Item;
            ValidateTableRelation = false;
        }
        field(25006015;Prepayment;Boolean)
        {
            Caption = 'Prepayment';
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
        field(25006128;"Real Time (Hours)";Decimal)
        {
            BlankZero = true;
            Caption = 'Real Time (Hours)';
        }
        field(25006130;"Ext. Service Tracking No.";Code[20])
        {
            Caption = 'Ext. Service Tracking No.';
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
        field(25006150;"Called to Customer Date";Date)
        {
            Caption = 'Called to Customer Date';
        }
        field(25006155;"Real Time";Decimal)
        {
            BlankZero = true;
            Caption = 'Real Time';
            Description = 'Only Service';
        }
        field(25006170;"Vehicle Registration No.";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Registration No." WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006187;"Transfer Item Ledger Entry No.";Integer)
        {
            BlankZero = true;
            Caption = 'Transfer Item Ledger Entry No.';
            Description = 'Only Service';
            TableRelation = "Item Ledger Entry";
        }
        field(25006190;"Mechanic No.";Code[20])
        {
            Caption = 'Mechanic No.';
            Description = 'Only Service';
            TableRelation = Resource;
        }
        field(25006370;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006371;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(25006372;"Line Type";Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,G/L Account,Item,Labor,Ext. Service,Materials,Vehicle,Own Option,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Labor,"Ext. Service",Materials,Vehicle,"Own Option","Charge (Item)";
        }
        field(25006373;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006374;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=CONST(Model Version));
        }
        field(25006375;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
        }
        field(25006376;"Vehicle Assembly ID";Code[20])
        {
            Caption = 'Vehicle Assembly ID';
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
                IF cuLookUpMgt.LookUpVehicleAccCycle(recVehAccCycle,"Vehicle Serial No.","Vehicle Accounting Cycle No.") THEN;
            end;
        }
        field(25006380;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006700;"Ordering Price Type Code";Code[10])
        {
            Caption = 'Ordering Price Type Code';
        }
        field(25006710;"Amount Enter In Line No.";Integer)
        {
            Caption = 'Amount Enter In Line No.';
            TableRelation = "Sales Invoice Line"."Line No." WHERE (Document No.=FIELD(Document No.));
        }
        field(25006730;"Print in Order";Boolean)
        {
            Caption = 'Print in Order';
        }
        field(25006740;"Backorder Date";Date)
        {
            Caption = 'Backorder Date';
        }
        field(33019961;"Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020011;"Sys. LC No.";Code[20])
        {
            CalcFormula = Lookup("Return Receipt Header"."Sys. LC No." WHERE (No.=FIELD(Document No.)));
            Caption = 'LC No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020012;"Bank LC No.";Code[20])
        {
            CalcFormula = Lookup("Return Receipt Header"."Bank LC No." WHERE (No.=FIELD(Document No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020013;"LC Amend No.";Code[20])
        {
            CalcFormula = Lookup("Return Receipt Header"."LC Amend No." WHERE (No.=FIELD(Document No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020602;"Board Minute Code";Code[20])
        {
            TableRelation = "Board Minute Master";
        }
        field(33020603;"Returned Invoice No.";Code[20])
        {
        }
        field(33020620;"HS Code";Code[20])
        {
        }
        field(99000760;"Tax Purchase Type";Option)
        {
            OptionCaption = ' ,ServicePurchaseCapital,ServicePurchaseOthers,GoodPurchaseCapital,GoodPurchaseOthers';
            OptionMembers = " ",ServicePurchaseCapital,ServicePurchaseOthers,GoodPurchaseCapital,GoodPurchaseOthers;
        }
    }

    var
        cuLookUpMgt: Codeunit "25006003";
}


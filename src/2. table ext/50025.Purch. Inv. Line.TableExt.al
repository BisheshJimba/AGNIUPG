tableextension 50025 tableextension50025 extends "Purch. Inv. Line"
{
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
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item),,External Service';

            //Unsupported feature: Property Modification (OptionString) on "Type(Field 5)".

        }
        modify("No.")
        {
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE IF (Type = CONST(Item)) Item
            ELSE IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE IF (Type = CONST("Charge (Item)")) "Item Charge";
            // ELSE IF (Type = CONST("External Service")) "External Service";//need to add option
        }
        modify("Posting Group")
        {
            TableRelation = IF (Type = CONST(Item)) "Inventory Posting Group"
            ELSE IF (Type = CONST("Fixed Asset")) "FA Posting Group";
        }
        modify("Blanket Order Line No.")
        {
            TableRelation = "Purchase Line"."Line No." WHERE("Document Type" = CONST("Blanket Order"),
                                                              "Document No." = FIELD("Blanket Order No."));
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

        modify("Bin Code")
        {
            TableRelation = Bin.Code WHERE("Location Code" = FIELD("Location Code"),
                                            "Item Filter" = FIELD("No."),
                                            "Variant Filter" = FIELD("Variant Code"));
        }
        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            "Unit of Measure";
        }
        modify("Operation No.")
        {
            TableRelation = "Prod. Order Routing Line"."Operation No." WHERE(Status = FILTER(Released ..),
                                                                              "Prod. Order No." = FIELD("Prod. Order No."),
                                                                              "Routing No." = FIELD("Routing No."));
        }
        modify("Prod. Order Line No.")
        {
            TableRelation = "Prod. Order Line"."Line No." WHERE(Status = FILTER(Released ..),
                                                                 "Prod. Order No." = FIELD("Prod. Order No."));
        }
        field(50000; "Requisition No."; Code[20])
        {
        }
        field(50001; "VIN - COGS"; Code[20])
        {
            TableRelation = Vehicle.VIN;
        }
        field(50053; "Commercial Invoice No."; Code[20])
        {
            Description = 'to add in vechile create';

            trigger OnLookup()
            var
                recVehicle: Record Vehicle;
            begin
            end;
        }
        field(50054; "Production Years"; Code[4])
        {
            Description = 'to add in vechile create';

            trigger OnLookup()
            var
                recVehicle: Record Vehicle;
            begin
            end;

            trigger OnValidate()
            var
                recVehicle: Record Vehicle;
            begin
            end;
        }
        field(50097; "COGS Type"; Option)
        {
            Description = 'Used for Alternative of way of Item Charge';
            OptionCaption = ' ,ACCESSORIES-CV,ACCESSORIES-PC,BANK CHARGE-CV,BANK CHARGE-PC,BATTERY-CV,BATTERY-PC,BODY BUILDING-CV,BODY BUILDING-PC,CHASSIS REGISTR-CV,CHASSIS REGISTR-PC,CLEARING & FORW-CV,CLEARING & FORW-PC,CUSTOM DUTY-CV,CUSTOM DUTY-PC,DENT / PENT-CV,DENT / PENT-PC,DRIVER-CV,DRIVER-PC,FOREIGN CHARGE-CV,FOREIGN CHARGE-PC,FUEL & OIL-CV,FUEL & OIL-PC,INSURANCE MANAG-CV,INSURANCE MANAG-PC,INSURANCE-CV,INSURANCE-PC,,L/C & BANK CHAR-CV,L/C & BANK CHAR-PC,LUBRICANTS-CV,LUBRICANTS-PC,NEW CHASSIS REP-CV,NEW CHASSIS REP-PC,PARKING CHARGE-CV,PARKING CHARGE-PC,PRAGYANPAN-CV,PRAGYANPAN-PC,SERVICE CHARGE-CV,SERVICE CHARGE-PC,SPARES-CV,SPARES-PC,TRANSPORTATION-CV,TRANSPORTATION-PC,VEHICLE LOGISTI-CV,VEHICLE LOGISTI-PC,VEHICLE TAX-CV,VEHICLE TAX-PC';
            OptionMembers = " ","ACCESSORIES-CV","ACCESSORIES-PC","BANK CHARGE-CV","BANK CHARGE-PC","BATTERY-CV","BATTERY-PC","BODY BUILDING-CV","BODY BUILDING-PC","CHASSIS REGISTR-CV","CHASSIS REGISTR-PC","CLEARING & FORW-CV","CLEARING & FORW-PC","CUSTOM DUTY-CV","CUSTOM DUTY-PC","DENT / PENT-CV","DENT / PENT-PC","DRIVER-CV","DRIVER-PC","FOREIGN CHARGE-CV","FOREIGN CHARGE-PC","FUEL & OIL-CV","FUEL & OIL-PC","INSURANCE MANAG-CV","INSURANCE MANAG-PC","INSURANCE-CV","INSURANCE-PC",,"L/C & BANK CHAR-CV","L/C & BANK CHAR-PC","LUBRICANTS-CV","LUBRICANTS-PC","NEW CHASSIS REP-CV","NEW CHASSIS REP-PC","PARKING CHARGE-CV","PARKING CHARGE-PC","PRAGYANPAN-CV","PRAGYANPAN-PC","SERVICE CHARGE-CV","SERVICE CHARGE-PC","SPARES-CV","SPARES-PC","TRANSPORTATION-CV","TRANSPORTATION-PC","VEHICLE LOGISTI-CV","VEHICLE LOGISTI-PC","VEHICLE TAX-CV","VEHICLE TAX-PC";
        }
        field(50098; "Document Class"; Option)
        {
            Caption = 'Document Class';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Assets';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Assets";
        }
        field(50099; "Document Subclass"; Code[20])
        {
            Caption = 'Document Subclass';
            TableRelation = IF ("Document Class" = CONST(Customer)) Customer
            ELSE IF ("Document Class" = CONST(Vendor)) Vendor
            ELSE IF ("Document Class" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Document Class" = CONST("Fixed Assets")) "Fixed Asset";
        }
        field(59000; "TDS Group"; Code[20])
        {
            TableRelation = "TDS Posting Group";
        }
        field(59001; "TDS%"; Decimal)
        {
        }
        field(59002; "TDS Type"; Option)
        {
            OptionCaption = ' ,Purchase TDS,Sales TDS';
            OptionMembers = " ","Purchase TDS","Sales TDS";
        }
        field(59003; "TDS Amount"; Decimal)
        {
        }
        field(59004; "TDS Base Amount"; Decimal)
        {
        }
        field(59005; ABC; Option)
        {
            Editable = false;
            OptionCaption = ' ,A,B,C,D,E';
            OptionMembers = " ",A,B,C,D,E;
        }
        field(59006; "Cost Type"; Option)
        {
            OptionCaption = ' ,Fixed Cost,Variable Cost';
            OptionMembers = " ","Fixed Cost","Variable Cost";
        }
        field(70000; "Supplier Code"; Code[10])
        {
            Description = ' QR19.00';
            // TableRelation = Table70000;//no table with this id in nav
        }
        field(70001; "Lot No. Prefix"; Code[20])
        {
            Description = ' QR19.00';
        }
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006006; "Vendor Order No."; Code[20])
        {
            Caption = 'Vendor Order No.';
        }
        field(25006130; "External Serv. Tracking No."; Code[20])
        {
            Caption = 'External Serv. Tracking No.';
            // TableRelation = IF (Type = FILTER("External Service")) "External Serv. Tracking No."."External Serv. Tracking No." WHERE("External Service No." = FIELD("No."));//need to add option
        }
        field(25006170; "Vehicle Registration No."; Code[30])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Vehicle."Registration No." WHERE("Serial No." = FIELD("Vehicle Serial No.")));//need to solve table error
        }
        field(25006370; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006371; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE("Make Code" = FIELD("Make Code"));
        }
        field(25006372; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,Vehicle,Own Option,Item,Charge (Item)';
            OptionMembers = " ",Vehicle,"Own Option",Item,"Charge (Item)";
        }
        field(25006373; VIN; Code[20])
        {
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vehicle;
            CalcFormula = Lookup(Vehicle.VIN WHERE("Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(25006374; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            // TableRelation = Item."No." WHERE("Make Code" = FIELD("Make Code"),
            //                                 "Model Code" = FIELD("Model Code"),
            //                                 "Item Type" = CONST("Model Version"));//need to add field

            trigger OnLookup()
            var
                recItem: Record Item;
            begin
                recItem.RESET;
                // IF cuLookupMgt.LookUpModelVersion(recItem, "No.", "Make Code", "Model Code") THEN//internal scope error
                VALIDATE("Model Version No.", recItem."No.");
            end;
        }
        field(25006375; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';

            trigger OnLookup()
            var
                recVehicle: Record Vehicle;
            begin
                recVehicle.RESET;
                // IF cuLookupMgt.LookUpVehicleAMT(recVehicle, "Vehicle Serial No.") THEN;//internal scope error
            end;
        }
        field(25006376; "Vehicle Assembly No."; Code[20])
        {
            Caption = 'Vehicle Assembly No.';
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle"."No.";

            trigger OnLookup()
            var
                recVehAccCycle: Record "Vehicle Accounting Cycle";
            begin
                recVehAccCycle.RESET;
                // IF cuLookupMgt.LookUpVehicleAccCycle(recVehAccCycle, "Vehicle Serial No.", "Vehicle Accounting Cycle No.") THEN;//internal a=scope error
            end;
        }
        field(25006380; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006386; "Vehicle Body Color Code"; Code[10])
        {
            Caption = 'Vehicle Body Color Code';
            TableRelation = "Body Color";
        }
        field(25006388; "Vehicle Interior Code"; Code[10])
        {
            Caption = 'Vehicle Interior Code';
            TableRelation = "Vehicle Interior";
        }
        field(25006700; "Ordering Price Type Code"; Code[20])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(33019810; "Summary No."; Code[20])
        {
            Description = 'Store  Requisition Summary No.';
        }
        field(33019832; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';
        }
        field(33019833; "Issue No."; Code[20])
        {
            Description = '//Used for Fuel Expense';
            TableRelation = "Vehicle Fuel Exp. Line"."Document No";
        }
        field(33019834; "Issue Line No."; Integer)
        {
            Description = '//Used for Fuel Expense';
            // TableRelation = "Vehicle Fuel Exp. Line"."Line No.";//need to solve table error
        }
        field(33019869; "Import Purch. Order"; Boolean)
        {
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020011; "Sys. LC No."; Code[20])
        {
            Caption = 'LC No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Purch. Inv. Header"."Sys. LC No." WHERE("No." = FIELD("Document No.")));
        }
        field(33020012; "Bank LC No."; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Purch. Inv. Header"."Bank LC No." WHERE("No." = FIELD("Document No.")));
        }
        field(33020013; "LC Amend No."; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Purch. Inv. Header"."LC Amend No." WHERE("No." = FIELD("Document No.")));
        }
        field(33020014; "Account Name"; Text[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("No.")));
        }
        field(33020015; "PI/ARE Code"; Code[20])
        {
            TableRelation = "LC Value Allotment"."PI Code" WHERE("LC Code" = FIELD("Sys. LC No."));

            trigger OnLookup()
            var
                RecLCValueAllotment: Record "LC Value Allotment";
                LCValueEntries: Record "LC Value Entries";
                ItemCharge: Record "Item Charge";
                ItemChargeValue: Decimal;
                LCDetails: Record "LC Details";
            begin
            end;

            trigger OnValidate()
            var
                ItemChargeValue: Decimal;
                LCDetails: Record "LC Details";
                RecLCValueAllotment: Record "LC Value Allotment";
                Text001: Label 'You cannot enter invalid PI/ARE Code.';
            begin
            end;
        }
        field(33020235; "Service Order No."; Code[20])
        {
            Description = '//Used for Ext. Service';
        }
        field(33020236; "Service Order Line No."; Integer)
        {
            Description = '//Used for Ext. Service';
        }
        field(33020238; "Engine No."; Code[20])
        {
        }
        field(99000760; "Tax Purchase Type"; Option)
        {
            OptionCaption = ' ,ServicePurchaseCapital,ServicePurchaseOthers,GoodPurchaseCapital,GoodPurchaseOthers';
            OptionMembers = " ",ServicePurchaseCapital,ServicePurchaseOthers,GoodPurchaseCapital,GoodPurchaseOthers;
        }
        field(99000761; "Port Code"; Code[20])
        {
            TableRelation = "Port Master";
        }
        field(99000762; "Localized VAT Identifier"; Option)
        {
            Description = 'VAT1.00';
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";
        }
    }
    keys
    {
        // key(Key1; Type, "Line Type", "Vehicle Serial No.", "Vehicle Accounting Cycle No.")//original
        key(Key1; "Line Type", "Vehicle Serial No.", "Vehicle Accounting Cycle No.")
        {
        }
    }

    var
        cuLookupMgt: Codeunit LookUpManagement;
}


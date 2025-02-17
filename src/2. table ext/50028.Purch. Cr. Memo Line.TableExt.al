tableextension 50028 tableextension50028 extends "Purch. Cr. Memo Line"
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

        //Unsupported feature: Property Modification (OptionString) on "Type(Field 5)".

        modify("No.")
        {
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE IF (Type = CONST(Item)) Item
            ELSE IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE IF (Type = CONST("Charge (Item)")) "Item Charge";
            // ELSE IF (Type=CONST("External Service")) "External Service";//need to add option
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
        field(50053; "Commercial Invoice No."; Code[20])
        {
            Description = 'to add in vechile create';

            trigger OnLookup()
            var
                recVehicle: Record 25006005;
            begin
            end;
        }
        field(50054; "Production Years"; Code[4])
        {
            Description = 'to add in vechile create';

            trigger OnLookup()
            var
                recVehicle: Record 25006005;
            begin
            end;

            trigger OnValidate()
            var
                recVehicle: Record 25006005;
            begin
            end;
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
        field(70000; "Package No."; Code[20])
        {
            Description = 'QR19.00';
        }
        field(25006000; "Document Profile"; Option)
        {
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
            // CalcFormula = Lookup(Vehicle."Registration No." WHERE("Serial No." = FIELD("Vehicle Serial No.")));//need to solve table 
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
            //                                 "Item Type" = CONST("Model Version"));//need to add model code

            trigger OnLookup()
            var
                recItem: Record Item;
            begin
                recItem.RESET;
                // IF cuLookupMgt.LookUpModelVersion(recItem, "No.", "Make Code", "Model Code") THEN//internal scope issue
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
                // IF cuLookupMgt.LookUpVehicleAMT(recVehicle, "Vehicle Serial No.") THEN;//internal scope issue
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
                recVehAccCycle: Record 25006024;
            begin
                recVehAccCycle.RESET;
                // IF cuLookupMgt.LookUpVehicleAccCycle(recVehAccCycle, "Vehicle Serial No.", "Vehicle Accounting Cycle No.") THEN;//internal scope issue
            end;
        }
        field(25006380; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006386; "Vehicle Body Color Code"; Code[10])
        {
            Caption = 'Vehicle Body Colur Code';
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
        field(33019832; "Vendor Invoice No."; Code[20])
        {
            Caption = 'Vendor Invoice No.';
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
            CalcFormula = Lookup("Purch. Cr. Memo Hdr."."Sys. LC No." WHERE("No." = FIELD("Document No.")));
        }
        field(33020012; "Bank LC No."; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Purch. Cr. Memo Hdr."."Bank LC No." WHERE("No." = FIELD("Document No.")));
        }
        field(33020013; "LC Amend No."; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Purch. Cr. Memo Hdr."."LC Amend No." WHERE("No." = FIELD("Document No.")));
        }
        field(33020015; "PI/ARE Code"; Code[20])
        {

            trigger OnLookup()
            var
                RecLCValueAllotment: Record 33020024;
                LCValueEntries: Record 33020023;
                ItemCharge: Record 5800;
                ItemChargeValue: Decimal;
                LCDetails: Record 33020012;
            begin
            end;

            trigger OnValidate()
            var
                ItemChargeValue: Decimal;
                LCDetails: Record 33020012;
                RecLCValueAllotment: Record 33020024;
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
        field(99000763; CBM; Decimal)
        {
            DecimalPlaces = 0 : 6;

            trigger OnValidate()
            var
                Itm: Record Item;
            begin
            end;
        }
    }
    keys
    {
        // key(Key1;Type,"Line Type","Vehicle Serial No.","Vehicle Accounting Cycle No.")//original
        key(Key1; "Line Type", "Vehicle Serial No.", "Vehicle Accounting Cycle No.")
        {
        }
    }

    var
        cuLookupMgt: Codeunit 25006003;
}


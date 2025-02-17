tableextension 50403 tableextension50403 extends "Return Shipment Line"
{
    // 22.10.2015 NAV2016 Merge
    //   ShowItemPurchCrMemoLines, ShowLineComments set to public
    // 
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
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item),,External Service';

            //Unsupported feature: Property Modification (OptionString) on "Type(Field 5)".

        }
        modify("No.")
        {
            TableRelation = IF (Type = CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Item)) Item
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
        }
        field(25006006;"Vendor Order No.";Code[20])
        {
            Caption = 'Vendor Order No.';
        }
        field(25006130;"Ext. Service Tracking No.";Code[20])
        {
            Caption = 'Ext. Service Tracking No.';
            TableRelation = IF (Type=FILTER(External Service)) "External Serv. Tracking No."."External Serv. Tracking No." WHERE (External Service No.=FIELD(No.));
        }
        field(25006170;"Vehicle Registration No.";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Registration No." WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
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
            OptionCaption = ' ,Vehicle,Own Option,Item,Charge (Item)';
            OptionMembers = " ",Vehicle,"Own Option",Item,"Charge (Item)";
        }
        field(25006373;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vehicle;
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
                IF cuLookupMgt.LookUpModelVersion(recItem,"No.","Make Code","Model Code") THEN
                 VALIDATE("Model Version No.",recItem."No.");
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
                IF cuLookupMgt.LookUpVehicleAMT(recVehicle,"Vehicle Serial No.") THEN;
            end;
        }
        field(25006376;"Vehicle Assembly No.";Code[20])
        {
            Caption = 'Vehicle Assembly No.';
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
                IF cuLookupMgt.LookUpVehicleAccCycle(recVehAccCycle,"Vehicle Serial No.","Vehicle Accounting Cycle No.") THEN;
            end;
        }
        field(25006380;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006700;"Ordering Price Type Code";Code[20])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(33019961;"Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020011;"Sys. LC No.";Code[20])
        {
            CalcFormula = Lookup("Return Shipment Header"."Sys. LC No." WHERE (No.=FIELD(Document No.)));
            Caption = 'LC No.';
            FieldClass = FlowField;

            trigger OnValidate()
            var
                LCDetail: Record "33020012";
                LCAmendDetail: Record "33020013";
                Text000: Label 'LC Amendment is not released.';
                Text001: Label 'LC Amendment is closed.';
                Text002: Label 'LC Details is not released.';
                Text003: Label 'LC Details is closed.';
            begin
            end;
        }
        field(33020012;"Bank LC No.";Code[20])
        {
            CalcFormula = Lookup("Return Shipment Header"."Bank LC No." WHERE (No.=FIELD(Document No.)));
            FieldClass = FlowField;
        }
        field(33020013;"LC Amend No.";Code[20])
        {
            CalcFormula = Lookup("Return Shipment Header"."LC Amend No." WHERE (No.=FIELD(Document No.)));
            FieldClass = FlowField;
        }
    }

    var
        cuLookupMgt: Codeunit "25006003";
}


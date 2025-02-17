tableextension 50015 tableextension50015 extends "Sales Invoice Line"
{
    // 25.01.2016 EB.P30 #T031
    //   Modified field "Vehicle Body Color Code" lenght to 20 characters
    // 
    // 08.04.2013 EDMS P8
    //   * Deleted fields: 'Mechanic No.', 'Transfer Item Ledger Entry No.'
    // 
    // 23.01.2013 EDMS P8
    //   * Changed type of field: Resources
    // 
    // 16.01.2008 EDMS P3
    //   * Added function ApplyDealDocuments
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
    // 
    // 09-02-2007 Elva Baltic J.Fedorovich
    //    * Added field 25006377 - EDMS No. (also in nonposted line)
    fields
    {

        //Unsupported feature: Property Modification (OptionString) on "Type(Field 5)".

        modify("No.")
        {
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE IF (Type = CONST(Item)) Item
            ELSE IF (Type = CONST(Resource)) Resource
            ELSE IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE IF (Type = CONST("Charge (Item)")) "Item Charge";
            // ELSE IF (Type=CONST("External Service")) "External Service"; //need to add external service option
        }
        modify("Posting Group")
        {
            TableRelation = IF (Type = CONST(Item)) "Inventory Posting Group"
            ELSE IF (Type = CONST("Fixed Asset")) "FA Posting Group";
        }

        //Unsupported feature: Property Modification (Data type) on ""Unit of Measure"(Field 13)".

        modify("Blanket Order Line No.")
        {
            TableRelation = "Sales Line"."Line No." WHERE("Document Type" = CONST("Blanket Order"),
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
        field(50000; "VIN-COGS"; Code[20])
        {
        }
        field(50006; "DRP No./ARE1 No."; Code[20])
        {
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Vehicle."DRP No./ARE1 No." WHERE("Serial No." = FIELD("Vehicle Serial No."))); //need to solve table error
        }
        field(60000; "Allotment Date"; Date)
        {
        }
        field(60001; "Allotment Time"; Time)
        {
        }
        field(60002; "System Allotment"; Boolean)
        {
        }
        field(60003; "Confirmed Time"; Time)
        {
        }
        field(60004; "Allotment Due Date"; Date)
        {
        }
        field(60005; "Confirmed Date"; Date)
        {
        }
        field(60006; ABC; Option)
        {
            Editable = false;
            OptionCaption = ' ,A,B,C,D,E';
            OptionMembers = " ",A,B,C,D,E;
        }
        field(70000; "Dealer PO No."; Code[20])
        {
            Description = 'For Dealer Portal';
        }
        field(70001; "Dealer Tenant ID"; Code[30])
        {
            Description = 'For Dealer Portal';
        }
        field(70002; "Dealer Line No."; Integer)
        {
            Description = 'For Dealer Portal';
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
        field(25006002; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(25006006; Group; Boolean)
        {
            Caption = 'Group';
        }
        field(25006007; "Group ID"; Integer)
        {
            Caption = 'Group ID';
        }
        field(25006008; "Group Description"; Text[100])
        {
            Caption = 'Group Description';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Invoice Line".Description WHERE("Document No." = FIELD("Document No."),
                                                                         "Line No." = FIELD("Group ID")));
        }
        field(25006010; "Item No. for Print"; Code[20])
        {
            Caption = 'Item No. for Print';
            TableRelation = Item;
            ValidateTableRelation = false;
        }
        field(25006015; Prepayment; Boolean)
        {
            Caption = 'Prepayment';
        }
        field(25006020; "Item Description for Print"; Text[30])
        {
            Caption = 'Item Description for Print';
        }
        field(25006030; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(25006050; "Resources (Serv.)"; Code[100])
        {
            Caption = 'Resources (Serv.)';
        }
        field(25006060; "Standard Time"; Decimal)
        {
            BlankZero = true;
            Caption = 'Standard Time';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(25006128; "Real Time (Hours)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Real Time (Hours)';
        }
        field(25006130; "External Serv. Tracking No."; Code[20])
        {
            Caption = 'External Serv. Tracking No.';
            // TableRelation = IF (Type=FILTER("External Service")) "External Serv. Tracking No."."External Serv. Tracking No." WHERE ("External Service No."=FIELD("No.")); //need to add enternal service option
        }
        field(25006135; "Service Order No. EDMS"; Code[20])
        {
            Caption = 'Service Order No. EDMS';
            Description = 'Only Service';
        }
        field(25006137; "Service Order Line No. EDMS"; Integer)
        {
            Caption = 'Service Order Line No. EDMS';
        }
        field(25006140; "Order Line Type No."; Code[20])
        {
            Caption = 'Order Line Type No.';
            Description = 'Only Service';
            // TableRelation = IF ("Line Type"=CONST(" ")) "Standard Text"
            //                 ELSE IF (Line Type=CONST(G/L Account)) "G/L Account"
            //                 ELSE IF (Line Type=CONST(Item)) Item
            //                 ELSE IF (Line Type=CONST(Labor)) "Service Labor"
            //                 ELSE IF (Line Type=CONST(Ext. Service)) "External Service"; //need to add line type
        }
        field(25006150; "Called to Customer Date"; Date)
        {
            Caption = 'Called to Customer Date';
        }
        field(25006155; "Real Time"; Decimal)
        {
            BlankZero = true;
            Caption = 'Real Time';
            Description = 'Only Service';
        }
        field(25006170; "Vehicle Registration No."; Code[30])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;
            // FieldClass = FlowField;
            // CalcFormula = Lookup(Vehicle."Registration No." WHERE("Serial No." = FIELD("Vehicle Serial No."))); //need to solve table error
        }
        field(25006187; "Transfer Item Ledger Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'Transfer Item Ledger Entry No.';
            Description = 'Only Service';
            TableRelation = "Item Ledger Entry";
        }
        field(25006190; "Mechanic No."; Code[20])
        {
            Caption = 'Mechanic No.';
            Description = 'Only Service';
            TableRelation = Resource;
        }
        field(25006210; "Package No."; Code[20])
        {
            Caption = 'Package No.';
            Editable = false;
            TableRelation = "Service Package"."No.";
        }
        field(25006300; "Package Version No."; Integer)
        {
            Caption = 'Package Version No.';
            Editable = false;
            TableRelation = "Service Package Version"."Version No." WHERE("Package No." = FIELD("Package No."));
        }
        field(25006310; "Package Version Spec. Line No."; Integer)
        {
            Caption = 'Package Version Spec. Line No.';
            Editable = false;
            NotBlank = true;
            // TableRelation = "Service Package Version Line"."Line No." WHERE("Package No." = FIELD("Package No."),
            //                                                                  "Version No." = FIELD("Package Version No.")); //need to solve table error
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
            OptionCaption = ' ,G/L Account,Item,Labor,Ext. Service,Materials,Vehicle,Own Option,Charge (Item),Fixed Asset';
            OptionMembers = " ","G/L Account",Item,Labor,"Ext. Service",Materials,Vehicle,"Own Option","Charge (Item)","Fixed Asset";
        }
        field(25006373; VIN; Code[20])
        {
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(Vehicle.VIN WHERE("Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(25006374; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            // TableRelation = Item."No." WHERE("Make Code" = FIELD("Make Code"), //need to add make code in item
            //                                 "Model Code" = FIELD("Model Code"),
            //                                 "Item Type" = CONST("Model Version"));
        }
        field(25006375; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle."Serial No." WHERE("Serial No." = FIELD("Vehicle Serial No."));
        }
        field(25006376; "Vehicle Assembly ID"; Code[20])
        {
            Caption = 'Vehicle Assembly ID';
        }
        field(25006377; "Service No."; Code[20])
        {
            Caption = 'Service No.';
            TableRelation = IF ("Line Type" = CONST(" ")) "Standard Text"
            ELSE IF ("Line Type" = CONST(Labor)) "Service Labor"
            ELSE IF ("Line Type" = CONST("Ext. Service")) "External Service";
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
                // IF cuLookUpMgt.LookUpVehicleAccCycle(recVehAccCycle, "Vehicle Serial No.", "Vehicle Accounting Cycle No.") THEN; //internal scope issue
            end;
        }
        field(25006380; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006386; "Vehicle Body Color Code"; Code[20])
        {
            Caption = 'Vehicle Body Color Code';
            TableRelation = "Body Color";
        }
        field(25006388; "Vehicle Interior Code"; Code[10])
        {
            Caption = 'Vehicle Interior Code';
            TableRelation = "Vehicle Interior";
        }
        field(25006389; Kilometrage; Integer)
        {
        }
        field(25006390; "Vehicle Trade-In Line"; Boolean)
        {
            Caption = 'Vehicle Trade-In Line';
        }
        field(25006391; "Applies-to Veh. Serial No."; Code[20])
        {
            Caption = 'Applies-to Veh. Serial No.';
        }
        field(25006392; "Applies-to Veh. Cycle No."; Code[20])
        {
            Caption = 'Applies-to Veh. Cycle No.';
        }
        field(25006578; "Include In Veh. Sales Amt."; Boolean)
        {
            Caption = 'Include In Veh. Sales Amt.';
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
        }
        field(25006710; "Amount Enter In Line No."; Integer)
        {
            Caption = 'Amount Enter In Line No.';
            TableRelation = "Sales Invoice Line"."Line No." WHERE("Document No." = FIELD("Document No."));
        }
        field(25006730; "Print in Order"; Boolean)
        {
            Caption = 'Print in Order';
        }
        field(25006740; "Backorder Date"; Date)
        {
            Caption = 'Backorder Date';
        }
        field(25006996; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,113,25006996';
        }
        field(25006997; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,113,25006997';
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
            CalcFormula = Lookup("Sales Invoice Header"."Sys. LC No." WHERE("No." = FIELD("Document No.")));
        }
        field(33020012; "Bank LC No."; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Invoice Header"."Bank LC No." WHERE("No." = FIELD("Document No.")));
        }
        field(33020013; "LC Amend No."; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Invoice Header"."LC Amend No." WHERE("No." = FIELD("Document No.")));
        }
        field(33020234; "Job Category"; Option)
        {
            OptionCaption = ' ,Under Warranty,Post Warranty,Accidental Repair,PDI';
            OptionMembers = " ","Under Warranty","Post Warranty","Accidental Repair",PDI;
        }
        field(33020235; "Job Type"; Code[20])
        {
        }
        field(33020252; "Scheme Code"; Code[20])
        {
            TableRelation = "Service Scheme Header";
        }
        field(33020253; "Membership No."; Code[20])
        {
            TableRelation = "Membership Details";
        }
        field(33020260; "Booked Date"; Date)
        {
        }
        field(33020602; "Board Minute Code"; Code[20])
        {
            TableRelation = "Board Minute Master";
        }
        field(33020603; "Returned Invoice No."; Code[20])
        {
        }
        field(33020605; "Forward Accountability Center"; Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020606; "Forward Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(33020607; "Quote Forwarded"; Boolean)
        {
            Description = 'true if the line is forwarded';
        }
        field(33020608; CBM; Decimal)
        {
            DecimalPlaces = 10 : 10;
        }
        field(33020620; "HS Code"; Code[20])
        {
        }
    }
    keys
    {
        // key(Key1; Type, "Line Type", "Vehicle Serial No.", "Vehicle Accounting Cycle No.") //original
        key(Key1; "Line Type", "Vehicle Serial No.", "Vehicle Accounting Cycle No.")
        {
        }
        key(Key2; "Service Order No. EDMS", "Service Order Line No. EDMS")
        {
        }
        // key(Key3; "Posting Date", "Location Code")
        // {
        // } //original
    }


    //Unsupported feature: Code Modification on "InitFromSalesLine(PROCEDURE 12)".

    //procedure InitFromSalesLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    INIT;
    TRANSFERFIELDS(SalesLine);
    IF ("No." = '') AND (Type IN [Type::"G/L Account"..Type::"Charge (Item)"]) THEN
      Type := Type::" ";
    "Posting Date" := SalesInvHeader."Posting Date";
    "Document No." := SalesInvHeader."No.";
    Quantity := SalesLine."Qty. to Invoice";
    "Quantity (Base)" := SalesLine."Qty. to Invoice (Base)";
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8

    //24.02.2012 Sipradi-YS BEGIN
    "Job Type" := SalesLine."Job Type";
    //24.02.2012 Sipradi-YS END
    */
    //end;

    procedure ApplyDealDocuments()
    var
        // DealDocApplication: Page 25006084;
        CustLedgEntry: Record "Cust. Ledger Entry";
        SalesInvHeader: Record "Sales Invoice Header";
        DCLedgEntry: Record "Cust. Ledg. Entry Link";
    begin
        SalesInvHeader.GET("Document No.");
        DCLedgEntry.SETCURRENTKEY("Document Type", "Document No.", "Posting Date", "Document Line No.");
        DCLedgEntry.SETRANGE("Document Type", CustLedgEntry."Document Type"::Invoice);
        DCLedgEntry.SETRANGE("Document No.", "Document No.");
        DCLedgEntry.SETRANGE("Posting Date", SalesInvHeader."Posting Date");
        DCLedgEntry.SETRANGE("Document Line No.", "Line No.");
        IF DCLedgEntry.FINDFIRST THEN BEGIN
            // DealDocApplication.SetApplication(1, DCLedgEntry."Entry No.", 6, DCLedgEntry."Document No.", DCLedgEntry."Document Line No.");
            // DealDocApplication.RUNMODAL //need page
        END ELSE
            ERROR(Text100, DCLedgEntry.TABLECAPTION)
    end;

    var
        cuLookUpMgt: Codeunit LookUpManagement;
        Text100: Label '%1 doesn''t exist for this line.';
}


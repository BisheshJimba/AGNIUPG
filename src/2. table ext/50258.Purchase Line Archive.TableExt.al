tableextension 50258 tableextension50258 extends "Purchase Line Archive"
{
    // 05.11.2012 EDMS P8
    //   * Added field: "Vehicle Assembly Version No."
    // 
    // 23.02.2012 EDMS P8
    //   * Add function ShowShortcutDimCode
    fields
    {
        modify("Document No.")
        {
            TableRelation = "Purchase Header Archive".No. WHERE(Document Type=FIELD(Document Type),
                                                                 Version No.=FIELD(Version No.));
        }
        modify(Type)
        {
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item),,External Service';

            //Unsupported feature: Property Modification (OptionString) on "Type(Field 5)".

        }
        modify("No.")
        {
            TableRelation = IF (Type=CONST(" ")) "Standard Text"
                            ELSE IF (Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST(3)) Resource
                            ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                            ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
        }
        modify("Posting Group")
        {
            TableRelation = IF (Type=CONST(Item)) "Inventory Posting Group"
                            ELSE IF (Type=CONST(Fixed Asset)) "FA Posting Group";
        }
        modify("Sales Order Line No.")
        {
            TableRelation = IF (Drop Shipment=CONST(Yes)) "Sales Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                         Document No.=FIELD(Sales Order No.));
        }
        modify("Attached to Line No.")
        {
            TableRelation = "Purchase Line Archive"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                                      Document No.=FIELD(Document No.),
                                                                      Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                                                      Version No.=FIELD(Version No.));
        }
        modify("Blanket Order Line No.")
        {
            TableRelation = "Purchase Line"."Line No." WHERE (Document Type=CONST(Blanket Order),
                                                              Document No.=FIELD(Blanket Order No.));
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }
        modify("Special Order Sales Line No.")
        {
            TableRelation = IF (Special Order=CONST(Yes)) "Sales Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                         Document No.=FIELD(Special Order Sales No.));
        }
        modify("Operation No.")
        {
            TableRelation = "Prod. Order Routing Line"."Operation No." WHERE (Status=CONST(Released),
                                                                              Prod. Order No.=FIELD(Prod. Order No.),
                                                                              Routing No.=FIELD(Routing No.));
        }
        modify("Prod. Order Line No.")
        {
            TableRelation = "Prod. Order Line"."Line No." WHERE (Status=FILTER(Released..),
                                                                 Prod. Order No.=FIELD(Prod. Order No.));
        }
        field(50000;"Indent No.";Code[10])
        {
        }
        field(50098;"Document Class";Option)
        {
            Caption = 'Document Class';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Assets';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Assets";
        }
        field(50099;"Document Subclass";Code[20])
        {
            Caption = 'Document Subclass';
            TableRelation = IF (Document Class=CONST(Customer)) Customer
                            ELSE IF (Document Class=CONST(Vendor)) Vendor
                            ELSE IF (Document Class=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Document Class=CONST(Fixed Assets)) "Fixed Asset";
        }
        field(59000;"TDS Group";Code[20])
        {
            TableRelation = "TDS Posting Group";
        }
        field(59001;"TDS%";Decimal)
        {
        }
        field(59002;"TDS Type";Option)
        {
            OptionCaption = ' ,Purchase TDS,Sales TDS';
            OptionMembers = " ","Purchase TDS","Sales TDS";
        }
        field(59003;"TDS Amount";Decimal)
        {
        }
        field(59004;"TDS Base Amount";Decimal)
        {
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
        field(25006010;"Reservation Entry No.";Integer)
        {
            BlankZero = true;
            CalcFormula = Lookup("Reservation Entry"."Entry No." WHERE (Source Type=CONST(39),
                                                                        Source Subtype=FIELD(Document Type),
                                                                        Source ID=FIELD(Document No.),
                                                                        Source Ref. No.=FIELD(Line No.),
                                                                        Reservation Status=CONST(Reservation)));
            Caption = 'Reservation Entry No.';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006011;"Reservation Source Type";Integer)
        {
            BlankZero = true;
            CalcFormula = Lookup("Reservation Entry"."Source Type" WHERE (Entry No.=FIELD(Reservation Entry No.),
                                                                          Positive=CONST(No)));
            Caption = 'Reservation Source Type';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006012;"Reservation Source Subtype";Option)
        {
            BlankZero = true;
            CalcFormula = Lookup("Reservation Entry"."Source Subtype" WHERE (Entry No.=FIELD(Reservation Entry No.),
                                                                             Positive=CONST(No)));
            Caption = 'Reservation Source Subtype';
            Description = 'Tracking';
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
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006014;"Reservation Source Ref. No.";Integer)
        {
            BlankZero = true;
            CalcFormula = Lookup("Reservation Entry"."Source Ref. No." WHERE (Entry No.=FIELD(Reservation Entry No.),
                                                                              Positive=CONST(No)));
            Caption = 'Reservation Source Ref. No.';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006015;"Reservation VIN";Code[20])
        {
            CalcFormula = Lookup("Sales Line".VIN WHERE (Document Type=FIELD(Reservation Source Subtype),
                                                         Document No.=FIELD(Reservation Source ID),
                                                         Line No.=FIELD(Reservation Source Ref. No.)));
            Caption = 'Reservation VIN';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006016;"Reservation Customer No.";Code[20])
        {
            CalcFormula = Lookup("Sales Line"."Sell-to Customer No." WHERE (Document Type=FIELD(Reservation Source Subtype),
                                                                            Document No.=FIELD(Reservation Source ID),
                                                                            Line No.=FIELD(Reservation Source Ref. No.)));
            Caption = 'Reservation Customer No.';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006100;"Special Order Service No.";Code[20])
        {
            Caption = 'Special Order Service No.';
            Description = 'P15';
            Editable = false;
            TableRelation = "Service Header EDMS".No. WHERE (Document Type=CONST(Order));

            trigger OnValidate()
            var
                ApprAllowed: Boolean;
            begin
            end;
        }
        field(25006101;"Special Order Service Line No.";Integer)
        {
            Caption = 'Sales Order Line No.';
            Editable = false;

            trigger OnValidate()
            var
                ApprAllowed: Boolean;
            begin
            end;
        }
        field(25006130;"External Serv. Tracking No.";Code[20])
        {
            Caption = 'External Serv. Tracking No.';
            TableRelation = IF (Type=FILTER(External Service)) "External Serv. Tracking No."."External Serv. Tracking No." WHERE (External Service No.=FIELD(No.));
        }
        field(25006170;"Vehicle Registration No.";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Registration No." WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006310;"Link Trade-In Entry";Integer)
        {
            Caption = 'Link Trade-In Entry';
        }
        field(25006370;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            var
                recModel: Record "25006001";
            begin
            end;
        }
        field(25006371;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(25006372;"Line Type";Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,Vehicle,,,Charge (Item),G/L Account';
            OptionMembers = " ",Vehicle,,Item,"Charge (Item)","G/L Account";

            trigger OnValidate()
            var
                DocMgtDMS: Codeunit "25006000";
                Opt: Integer;
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
                recVehicle: Record "25006005";
                frmVehicleList: Page "25006033";
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
        }
        field(25006375;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
            begin
            end;

            trigger OnValidate()
            var
                recReservationEntry: Record "337";
                iEntryNo: Integer;
                frmItemTrackingLines: Page "6510";
                                          cPurchLineReserve: Codeunit "99000834";
                                          recVehicle: Record "25006005";
                                          codSerialNoPre: Code[20];
                                          codDefCycle: Code[20];
                                          cuVehSN: Codeunit "25006006";
                                          TextAssignNewCycle: Label 'Do you want to assign new %1?';
                VehAccCycleMgt: Codeunit "25006303";
                VheAccCycle: Record "25006024";
            begin
            end;
        }
        field(25006376;"Vehicle Assembly ID";Code[20])
        {
            Caption = 'Vehicle Assembly ID';

            trigger OnValidate()
            var
                recVehAssembly: Record "25006380";
                tcAMT001: Label 'Vehicle assembly list %1 is not empty.';
            begin
            end;
        }
        field(25006378;"Vehicle Exists";Boolean)
        {
            CalcFormula = Exist(Vehicle WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Vehicle Exists';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle".No. WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.));
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                recVehAccCycle: Record "25006024";
            begin
            end;
        }
        field(25006380;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;

            trigger OnValidate()
            var
                recDimValue: Record "349";
            begin
            end;
        }
        field(25006382;Reserved;Boolean)
        {
            CalcFormula = Exist("Vehicle Reservation Entry" WHERE (Source Type=CONST(39),
                                                                   Source Subtype=FIELD(Document Type),
                                                                   Source ID=FIELD(Document No.),
                                                                   Source Ref. No.=FIELD(Line No.)));
            Caption = 'Reserved';
            Description = 'Only for Vehicles';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006386;"Vehicle Body Color Code";Code[10])
        {
            Caption = 'Vehicle Body Color Code';
            TableRelation = "Body Color".Code;
        }
        field(25006388;"Vehicle Interior Code";Code[10])
        {
            Caption = 'Vehicle Interior Code';
            TableRelation = "Vehicle Interior";
        }
        field(25006700;"Ordering Price Type Code";Code[20])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006710;"Qty. on Back Order";Decimal)
        {
            Caption = 'Qty. on Back Order';
        }
        field(25006720;"Back Order Date";Date)
        {
            Caption = 'Back Order Date';
        }
        field(25006730;"Item No. Changed";Boolean)
        {
            Caption = 'Item No. Changed';
        }
        field(33019832;"Vendor Invoice No.";Code[20])
        {
            Caption = 'Vendor Invoice No.';
        }
        field(33019961;"Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020011;"System LC No.";Code[20])
        {
            CalcFormula = Lookup("Purchase Header Archive"."System LC No." WHERE (Document Type=FIELD(Document Type),
                                                                                  No.=FIELD(Document No.)));
            Caption = 'LC No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020012;"Bank LC No.";Code[20])
        {
            CalcFormula = Lookup("Purchase Header Archive"."Bank LC No." WHERE (Document Type=FIELD(Document Type),
                                                                                No.=FIELD(Document No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020013;"LC Amend No.";Code[20])
        {
            CalcFormula = Lookup("Purchase Header Archive"."LC Amend No." WHERE (Document Type=FIELD(Document Type),
                                                                                 No.=FIELD(Document No.)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    var
        cuLookUpMgt: Codeunit "25006003";
}


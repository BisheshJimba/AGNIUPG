tableextension 50256 tableextension50256 extends "Sales Line Archive"
{
    // 20.02.2015 EB.P7 #Arch. Return Ord.
    //   Renewed EDMS fields from Sales Line
    // 
    // 08.04.2013 EDMS P8
    //   * Deleted fields: 'Mechanic No.'
    // 
    // 05.11.2012 EDMS P8
    //   * Added field: "Vehicle Assembly Version No."
    fields
    {
        modify("Document No.")
        {
            TableRelation = "Sales Header Archive".No. WHERE(Document Type=FIELD(Document Type),
                                                              Version No.=FIELD(Version No.));
        }
        modify(Type)
        {
            OptionCaption = ' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item),,External Service';

            //Unsupported feature: Property Modification (OptionString) on "Type(Field 5)".

        }
        modify("No.")
        {
            TableRelation = IF (Type=CONST(" ")) "Standard Text"
                            ELSE IF (Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Item)) Item
                            ELSE IF (Type=CONST(Resource)) Resource
                            ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
                            ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
        }
        modify("Posting Group")
        {
            TableRelation = IF (Type=CONST(Item)) "Inventory Posting Group"
                            ELSE IF (Type=CONST(Fixed Asset)) "FA Posting Group";
        }
        modify("Purch. Order Line No.")
        {
            TableRelation = IF (Drop Shipment=CONST(Yes)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                            Document No.=FIELD(Purchase Order No.));
        }
        modify("Attached to Line No.")
        {
            TableRelation = "Sales Line Archive"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                                   Document No.=FIELD(Document No.),
                                                                   Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                                                   Version No.=FIELD(Version No.));
        }
        modify("Blanket Order Line No.")
        {
            TableRelation = "Sales Line"."Line No." WHERE (Document Type=CONST(Blanket Order),
                                                           Document No.=FIELD(Blanket Order No.));
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5402)".

        modify("Unit of Measure Code")
        {
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.))
                            ELSE "Unit of Measure";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Substitution Available"(Field 5702)".

        modify("Special Order Purch. Line No.")
        {
            TableRelation = IF (Special Order=CONST(Yes)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Order),
                                                                                            Document No.=FIELD(Special Order Purchase No.));
        }
        modify("Service Contract No.")
        {
            TableRelation = "Service Contract Header"."Contract No." WHERE (Contract Type=CONST(Contract),
                                                                            Customer No.=FIELD(Sell-to Customer No.),
                                                                            Bill-to Customer No.=FIELD(Bill-to Customer No.));
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
        field(25006002;"Payment Method Code";Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(25006006;Group;Boolean)
        {
            Caption = 'Group';
        }
        field(25006007;"Group ID";Integer)
        {
            Caption = 'Group ID';
            TableRelation = "Sales Line"."Line No." WHERE (Document Type=FIELD(Document Type),
                                                           Document No.=FIELD(Document No.),
                                                           Group=CONST(Yes));
        }
        field(25006010;"Item No. for Print";Code[20])
        {
            Caption = 'Item No. for Print';
            TableRelation = Item;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                recItem: Record "27";
            begin
                IF "Item No. for Print" <> '' THEN
                 BEGIN
                  IF recItem.GET("Item No. for Print") THEN
                    "Item Description for Print" := recItem.Description;
                 END
                ELSE
                 "Item Description for Print" := '';
            end;
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
        field(25006060;"Standard Time";Decimal)
        {
            BlankZero = true;
            Caption = 'Standard Time';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(25006128;"Real Time (Hours)";Decimal)
        {
            BlankZero = true;
            Caption = 'Real Time (Hours)';
        }
        field(25006130;"External Serv. Tracking No.";Code[20])
        {
            Caption = 'External Serv. Tracking No.';
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
            Description = 'Only Service';
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
        field(25006150;"Customer Notification Date";Date)
        {
            Caption = 'Customer Notification Date';
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
        field(25006190;"Mechanic No.";Code[20])
        {
            Caption = 'Mechanic No.';
            Description = 'Only Service';
            TableRelation = Resource;
        }
        field(25006210;"Package No.";Code[20])
        {
            Caption = 'Package No.';
            Editable = false;
            TableRelation = "Service Package".No.;
        }
        field(25006300;"Package Version No.";Integer)
        {
            Caption = 'Package Version No.';
            Editable = false;
            TableRelation = "Service Package Version"."Version No." WHERE (Package No.=FIELD(Package No.));
        }
        field(25006310;"Package Version Spec. Line No.";Integer)
        {
            Caption = 'Package Version Spec. Line No.';
            Editable = false;
            NotBlank = true;
            TableRelation = "Service Package Version Line"."Line No." WHERE (Package No.=FIELD(Package No.),
                                                                             Version No.=FIELD(Package Version No.));
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

            trigger OnValidate()
            var
                recVehicle: Record "25006005";
                recItem: Record "27";
            begin
            end;
        }
        field(25006372;"Line Type";Option)
        {
            Caption = 'Line Type';
            OptionCaption = ' ,G/L Account,Item,Labor,Ext. Service,Materials,Vehicle,Own Option,Charge (Item),Fixed Asset';
            OptionMembers = " ","G/L Account",Item,Labor,"Ext. Service",Materials,Vehicle,"Own Option","Charge (Item)","Fixed Asset";

            trigger OnValidate()
            var
                cuDocMgtDMS: Codeunit "25006000";
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

            trigger OnLookup()
            var
                Vehicle: Record "25006005";
            begin
            end;

            trigger OnValidate()
            var
                ReservationEntry: Record "337";
                SalesLine: Record "37";
                EntryNo: Integer;
                frmItemTrackingLines: Page "6510";
                                          SalesLineReserve: Codeunit "99000832";
                                          Vehicle: Record "25006005";
                                          SerialNoPre: Code[20];
                                          DefCycle: Code[20];
                                          VehAccCycleMgt: Codeunit "25006303";
                                          VehSerialNo: Code[20];
            begin
            end;
        }
        field(25006376;"Vehicle Assembly ID";Code[20])
        {
            Caption = 'Vehicle Assembly ID';

            trigger OnValidate()
            var
                VehAssembly: Record "25006380";
                tcAMT001: Label 'Vehicle assembly list %1 is not empty.';
            begin
            end;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle".No.;

            trigger OnLookup()
            var
                recVehAccCycle: Record "25006024";
            begin
            end;

            trigger OnValidate()
            var
                cuVehAccCycle: Codeunit "25006303";
            begin
            end;
        }
        field(25006380;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
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
        field(25006389;Kilometrage;Integer)
        {
        }
        field(25006390;"Vehicle Trade-In Line";Boolean)
        {
            Caption = 'Vehicle Trade-In Line';
        }
        field(25006391;"Applies-to Veh. Serial No.";Code[20])
        {
            Caption = 'Applies-to Veh. Serial No.';
        }
        field(25006392;"Applies-to Veh. Cycle No.";Code[20])
        {
            Caption = 'Applies-to Veh. Cycle No.';
        }
        field(25006578;"Include In Veh. Sales Amt.";Boolean)
        {
            Caption = 'Include In Veh. Sales Amt.';
        }
        field(25006680;"Contract No.";Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";

            trigger OnLookup()
            var
                Customer: Record "18";
                ContractTemp: Record "25006016" temporary;
            begin
            end;
        }
        field(25006700;"Ordering Price Type Code";Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";

            trigger OnValidate()
            var
                OrderingPriceType: Record "25006763";
            begin
            end;
        }
        field(25006730;"Print in Order";Boolean)
        {
            Caption = 'Print in Order';
        }
        field(25006740;"Backorder Date";Date)
        {
            Caption = 'Backorder Date';
        }
        field(25006800;"Variable Field 25006800";Code[20])
        {
            CaptionClass = '7,37,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
            end;
        }
        field(25006801;"Variable Field 25006801";Code[20])
        {
            CaptionClass = '7,37,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
            end;
        }
        field(25006802;"Variable Field 25006802";Code[20])
        {
            CaptionClass = '7,37,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
            end;
        }
        field(25006996;"Variable Field Run 2";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,37,25006996';
        }
        field(25006997;"Variable Field Run 3";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,37,25006997';
        }
        field(33019961;"Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33020235;"Job Type";Code[20])
        {
            TableRelation = "Job Type Master".No. WHERE (Type=CONST(Job));
        }
        field(33020236;"Warranty Approved";Boolean)
        {
        }
        field(33020237;"Approved Date";Date)
        {
        }
        field(33020238;Inventory;Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE (Item No.=FIELD(No.),
                                                                  Location Code=FIELD(Location Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020252;"Scheme Code";Code[20])
        {
            TableRelation = "Service Scheme Header";
        }
        field(33020253;"Membership No.";Code[20])
        {
            TableRelation = "Membership Details";
        }
        field(33020260;"Booked Date";Date)
        {
        }
        field(33020600;"See Reserve Entries";Boolean)
        {
            CalcFormula = Exist("Vehicle Accounting Cycle" WHERE (No.=FIELD(Vehicle Accounting Cycle No.),
                                                                  Vehicle Serial No.=FIELD(Vehicle Serial No.)));
            Description = 'To look up (vehicle reserve entries) vehicle accounting cycle page';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020601;"Sell-to Customer Name 2";Text[70])
        {
            Description = 'Only used for Vehicle Reserve Entries (Vehicle Accounting Cycle)';
        }
        field(33020602;"Board Minute Code";Code[20])
        {
            TableRelation = "Board Minute Master";
        }
    }

    var
        cuLookUpMgt: Codeunit "25006003";
}


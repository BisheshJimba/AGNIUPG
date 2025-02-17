table 25006024 "Vehicle Accounting Cycle"
{
    Caption = 'Vehicle Accounting Cycle';
    DataPerCompany = false;
    DrillDownPageID = "Vehicle Accounting Cycles";
    LookupPageID = "Vehicle Accounting Cycles";

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(30; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
        }
        field(40; VIN; Code[20])
        {
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vehicle;
            CalcFormula = Lookup(Vehicle.VIN WHERE("Serial No." = FIELD("Vehicle Serial No.")));

            trigger OnLookup()
            begin
                RecVehicle.RESET;
                IF LookUpMgt.LookUpVehicleAMT(RecVehicle, "Vehicle Serial No.") THEN BEGIN
                    VALIDATE("Vehicle Serial No.", RecVehicle."Serial No.");
                    VIN := RecVehicle.VIN;
                END;
            end;
        }
        field(50; Default; Boolean)
        {
            Caption = 'Default';
        }
        field(33020235; "Sales order"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Line"."Document No." WHERE("Document Type" = CONST(Order),
                                                                    "Document Profile" = CONST("Vehicles Trade"),
                                                                    "Vehicle Serial No." = FIELD("Vehicle Serial No."),
                                                                    "Vehicle Accounting Cycle No." = FIELD("No.")));
        }
        field(33020236; "Purchase order"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Line"."Document No." WHERE("Document Type" = CONST(Order),
                                                                       "Document Profile" = CONST("Vehicles Trade"),
                                                                       "Vehicle Serial No." = FIELD("Vehicle Serial No."),
                                                                       "Vehicle Accounting Cycle No." = FIELD("No.")));
        }
        field(33020237; "Customer No"; Code[10])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Line"."Sell-to Customer No." WHERE("Document Type" = CONST(Order),
                                                                            "Document Profile" = CONST("Vehicles Trade"),
                                                                            "Vehicle Serial No." = FIELD("Vehicle Serial No."),
                                                                            "Vehicle Accounting Cycle No." = FIELD("No.")));
        }
        field(33020238; "Customer Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Line"."Sell-to Customer Name 2" WHERE("Document Type" = CONST(Order),
                                                                               "Document Profile" = CONST("Vehicles Trade"),
                                                                               "Vehicle Serial No." = FIELD("Vehicle Serial No."),
                                                                               "Vehicle Accounting Cycle No." = FIELD("No.")));
        }
        field(33020239; "Vehicle In"; Decimal)
        {
            Description = 'Qty 1 in item ledger entry';
            FieldClass = FlowField;
            CalcFormula = Lookup("Item Ledger Entry".Quantity WHERE("Entry Type" = CONST(Purchase),
                                                                     "Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(33020240; "Vehicle Out"; Decimal)
        {
            Description = 'Qty -1 in item ledger entry';
            FieldClass = FlowField;
            CalcFormula = Lookup("Item Ledger Entry".Quantity WHERE("Entry Type" = CONST(Sale),
                                                                     "Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(33020241; Make; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Line"."Make Code" WHERE("Document Type" = CONST(Order),
                                                                 "Document Profile" = CONST("Vehicles Trade"),
                                                                 "Vehicle Serial No." = FIELD("Vehicle Serial No."),
                                                                 "Vehicle Accounting Cycle No." = FIELD("No.")));
        }
        field(33020242; Model; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Line"."Model Code" WHERE("Document Type" = CONST(Order),
                                                                  "Document Profile" = CONST("Vehicles Trade"),
                                                                  "Vehicle Serial No." = FIELD("Vehicle Serial No."),
                                                                  "Vehicle Accounting Cycle No." = FIELD("No.")));
        }
        field(33020243; "Model Version No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Line"."Model Version No." WHERE("Document Type" = CONST(Order),
                                                                         "Document Profile" = CONST("Vehicles Trade"),
                                                                         "Vehicle Serial No." = FIELD("Vehicle Serial No."),
                                                                         "Vehicle Accounting Cycle No." = FIELD("No.")));
        }
        field(33020244; "Requisition Line"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Requisition Line"."Line No." WHERE("Document Profile" = CONST("Vehicles Trade"),
                                                                      "Vehicle Serial No." = FIELD("Vehicle Serial No."),
                                                                      "Vehicle Accounting Cycle No." = FIELD("No.")));
        }
        field(33020245; "Variant Code"; Code[20])
        {
            Description = 'if exits in sales line';
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Line"."Variant Code" WHERE("Document Type" = CONST(Order),
                                                                    "Document Profile" = CONST("Vehicles Trade"),
                                                                    "Vehicle Serial No." = FIELD("Vehicle Serial No."),
                                                                    "Vehicle Accounting Cycle No." = FIELD("No.")));
        }
        field(33020246; "Booked Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Sales Line"."Booked Date" WHERE("Document Type" = CONST(Order),
                                                                   "Document Profile" = CONST("Vehicles Trade"),
                                                                   "Vehicle Serial No." = FIELD("Vehicle Serial No."),
                                                                   "Vehicle Accounting Cycle No." = FIELD("No.")));
        }
        field(33020247; "PDI Status"; Option)
        {
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Open,Closed';
            OptionMembers = Open,Closed;
            CalcFormula = Lookup("PDI Header".Status WHERE("Vehicle Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(33020248; "PDI Type"; Option)
        {
            FieldClass = FlowField;
            OptionCaption = ' ,Regular PDI,Accidental Repair';
            OptionMembers = " ","Regular PDI","Accidental Repair";
            CalcFormula = Lookup("PDI Header"."PDI Type" WHERE("Vehicle Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(33020249; "Location Code"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Item Ledger Entry"."Location Code" WHERE("Serial No." = FIELD("Vehicle Serial No.")));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Vehicle Serial No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        RecVehicle: Record Vehicle;
        LookUpMgt: Codeunit 25006003;
}


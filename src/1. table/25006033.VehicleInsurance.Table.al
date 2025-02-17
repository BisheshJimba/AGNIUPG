table 25006033 "Vehicle Insurance"
{
    Caption = 'Vehicle Insurance';
    LookupPageID = "Vehicle Insurance";

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; "Insurance Policy No."; Code[50])
        {
            Caption = 'Insurance Policy No.';
            NotBlank = true;
        }
        field(40; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(50; "Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
            TableRelation = Customer;
        }
        field(60; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            NotBlank = true;

            trigger OnValidate()
            begin
                "Ending Date" := CALCDATE('1Y-1D', "Starting Date");
            end;
        }
        field(70; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(80; Type; Code[20])
        {
            Caption = 'Type';
            NotBlank = true;
            TableRelation = "Vehicle Insurance Type";

            trigger OnValidate()
            begin
                recInsucMemoLine.RESET;
                recInsucMemoLine.SETRANGE(recInsucMemoLine."Vehicle Serial No.", "Vehicle Serial No.");
                recInsucMemoLine.SETRANGE(Canceled, FALSE);
                IF recInsucMemoLine.FINDFIRST THEN BEGIN
                    recInsucMemoHdr.RESET;
                    recInsucMemoHdr.SETRANGE(recInsucMemoHdr."Reference No.", recInsucMemoLine."Reference No.");
                    IF recInsucMemoHdr.FINDFIRST THEN BEGIN
                        "Ins. Company Code" := recInsucMemoHdr."Ins. Company Code";
                        "Ins. Company Name" := recInsucMemoHdr."Ins. Company Name";
                    END;
                END;
                CALCFIELDS("Ins. Company Name");
                recILE.SETCURRENTKEY("Serial No.");
                recILE.SETRANGE(recILE."Serial No.", "Vehicle Serial No.");
                recILE.SETRANGE(recILE."Entry Type", recILE."Entry Type"::Sale);
                recILE.SETFILTER(recILE.Quantity, '>0');
                IF recILE.FINDLAST THEN BEGIN
                    "Customer Code" := recILE."Source No.";
                    CALCFIELDS("Customer Name");
                END;
            end;
        }
        field(50000; "Payment Memo Generated"; Boolean)
        {
            Editable = true;
        }
        field(50001; Paid; Boolean)
        {
        }
        field(50002; "Payment Date"; Date)
        {
        }
        field(50003; "Paid by Check No."; Code[30])
        {
        }
        field(50004; Cancelled; Boolean)
        {
            Editable = true;
        }
        field(50005; "Cancellation Date"; Date)
        {
            Editable = true;
        }
        field(50006; "DRP/ARE-1 No."; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(Vehicle."DRP No./ARE1 No." WHERE("Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(50007; "Model Version No."; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(Vehicle."Model Version No." WHERE("Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(50008; "Proceed for Ins. Payment"; Boolean)
        {
            Editable = true;
        }
        field(50009; "Make Code"; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(Vehicle."Make Code" WHERE("Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(50010; "Reason for Cancellation"; Text[50])
        {
            Editable = false;
        }
        field(50011; "Insured Value"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Ins. Memo Line".Amount WHERE("Chasis No." = FIELD(VIN)));
        }
        field(50012; "Insured by Customer"; Boolean)
        {
            Description = '//for vehicle finance department';
        }
        field(50013; "Insured by Veh. Finance Dept."; Boolean)
        {
            Description = '//for vehicle finance department';
        }
        field(50014; "Insurance Activity"; Option)
        {
            OptionCaption = 'New Policy,Body Addition,Value Addition,Renewal,Cancellation,Passenger';
            OptionMembers = "New Policy","Body Addition","Value Addition",Renewal,Cancellation,Passenger;
        }
        field(33020042; "Ins. Company Code"; Code[20])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                CALCFIELDS("Ins. Company Name");
            end;
        }
        field(33020043; "Ins. Company Name"; Text[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Ins. Company Code")));
        }
        field(33020044; "Bill No."; Code[20])
        {
        }
        field(33020045; "Bill Date"; Date)
        {
        }
        field(33020046; "Customer Name"; Text[50])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer Code")));
        }
        field(33020047; "Ins. Prem Value (with VAT)"; Decimal)
        {
            Editable = false;
        }
        field(33020048; "Insurance Basic"; Decimal)
        {

            trigger OnValidate()
            begin
                "VAT(Insurance)" := ("Insurance Basic" + "Other Insurance") * 0.13;
                "Ins. Prem Value (with VAT)" := "VAT(Insurance)" + "Insurance Basic" + "Other Insurance"
            end;
        }
        field(33020049; "Other Insurance"; Decimal)
        {

            trigger OnValidate()
            begin
                "VAT(Insurance)" := ("Insurance Basic" + "Other Insurance") * 0.13;
                "Ins. Prem Value (with VAT)" := "VAT(Insurance)" + "Insurance Basic" + "Other Insurance"
            end;
        }
        field(33020050; "VAT(Insurance)"; Decimal)
        {
            Editable = false;
        }
        field(33020051; "Proforma Invoice No"; Code[20])
        {
        }
        field(33020052; VIN; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(Vehicle.VIN WHERE("Serial No." = FIELD("Vehicle Serial No.")));

            trigger OnLookup()
            var
                recVehicle: Record Vehicle;
                frmVehicleList: Page 25006033;
                LookUpMgt: Codeunit 25006003;
                recSalesRecSetup: Record "Sales & Receivables Setup";
            begin
                /*
                recVehicle.RESET;
                recSalesRecSetup.GET;
                recVehicle.SETRANGE(recVehicle."Current Location of VIN",recSalesRecSetup."Custom Application Location");
                IF LookUpMgt.LookUpVehicleAMT(recVehicle,"Vehicle Serial No.") THEN
                 BEGIN
                  VALIDATE("Vehicle Serial No.",recVehicle."Serial No.");
                  "Chasis No." := recVehicle.VIN;
                  "Engine No." := recVehicle."Engine No.";
                  "DRP No." := recVehicle."DRP No./ARE1 No.";
                  Model := recVehicle."Model Code";
                  "Model Version" := recVehicle."Model Version No.";
                
                 END;
                */

            end;
        }
        field(33020053; "Ins. Payment Memo No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Max("Ins. Payment Memo Line".No. WHERE("Vehicle Serial No." = FIELD("Vehicle Serial No."),
                                                                  "Insurance Policy No." = FIELD("Insurance Policy No."),
                                                                  Cancelled = CONST(false)));
        }
        field(33020054; "Cancelled Adjustment Memo No."; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Max("Ins. Payment Memo Line".No. WHERE("Vehicle Serial No." = FIELD("Vehicle Serial No."),
                                                                  "Insurance Policy No." = FIELD("Insurance Policy No."),
                                                                  Cancelled = CONST(true)));
        }
        field(33020055; Expired; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Vehicle Serial No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Ending Date")
        {
        }
        key(Key3; "Ins. Company Code")
        {
        }
        key(Key4; "Insurance Policy No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DrillDown; "Insurance Policy No.", VIN, "Starting Date", "Ending Date", "Ins. Company Name")
        {
        }
    }

    trigger OnDelete()
    begin
        IF Cancelled THEN
            ERROR(Text001);
    end;

    trigger OnInsert()
    begin
        Vehicle.RESET;
        Vehicle.SETRANGE("Serial No.", "Vehicle Serial No.");
        IF Vehicle.FINDFIRST THEN BEGIN
            "Make Code" := Vehicle."Make Code";
        END;
    end;

    trigger OnModify()
    begin
        IF Cancelled THEN
            ERROR(Text000);
    end;

    var
        recInsucMemoHdr: Record "Ins. Memo Header";
        recInsucMemoLine: Record "Ins. Memo Line";
        recILE: Record "Item Ledger Entry";
        Vehicle: Record Vehicle;
        Text000: Label 'You cannot edit Cancelled Insurances.';
        Text001: Label 'You cannot delete Cancelled Insurances.';

    [Scope('Internal')]
    procedure DuplicatePolicyChcek()
    var
        VehInsurance: Record "Vehicle Insurance";
        DuplicateFound: Label 'Duplicate Insurance Policy Found in Vehicle %1.';
    begin
        VehInsurance.RESET;
        VehInsurance.SETCURRENTKEY("Insurance Policy No.");
        VehInsurance.SETRANGE("Insurance Policy No.", "Insurance Policy No.");
        IF VehInsurance.FINDFIRST THEN BEGIN
            VehInsurance.CALCFIELDS(VIN);
            ERROR(DuplicateFound, VehInsurance.VIN);
        END;
    end;
}


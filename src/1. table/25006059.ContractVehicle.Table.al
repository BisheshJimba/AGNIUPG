table 25006059 "Contract Vehicle"
{
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added CaptionML to field:
    //     "Vehicle Serial No."
    // 
    // 07.04.2014 Elva Balticv P15 # MMG7.00
    //   * initial creation

    Caption = 'Contract Vehicle';
    LookupPageID = 50015;

    fields
    {
        field(5; "Contract Type"; Option)
        {
            Caption = 'Contract Type';
            OptionCaption = 'Quote,Contract';
            OptionMembers = Quote,Contract;
        }
        field(10; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No." WHERE(Contract Type=FIELD(Contract Type));
        }
        field(20;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(30;"Veh. Make Code";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Make Code" WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Make Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40;"Veh. Model Code";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Model Code" WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50;"Veh. Model Version No.";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Model Version No." WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Model Version No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'VIN';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Contract Type","Contract No.","Vehicle Serial No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


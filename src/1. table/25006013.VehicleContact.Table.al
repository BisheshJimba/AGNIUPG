table 25006013 "Vehicle Contact"
{
    Caption = 'Vehicle Contact';
    DrillDownPageID = 25006036;
    LookupPageID = 25006036;

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(20; "Relationship Code"; Code[20])
        {
            Caption = 'Relationship Code';
            TableRelation = "Vehicle-Contact Relationship";
        }
        field(30; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact;

            trigger OnValidate()
            begin
                CALCFIELDS("Contact Name");
            end;
        }
        field(40; "Contact Name"; Text[100])
        {
            Caption = 'Contact Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(Contact.Name WHERE("No." = FIELD("Contact No.")));
        }
        field(60; VIN; Code[20])
        {
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(Vehicle.VIN WHERE("Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(70; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Make;
            CalcFormula = Lookup(Vehicle."Make Code" WHERE("Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(72; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Lookup(Vehicle."Model Code" WHERE("Serial No." = FIELD("Vehicle Serial No.")));
        }
        field(100; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(50000; "Transfer Date"; Date)
        {
        }
        field(50001; "Customer No"; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Contact Business Relation"."No." WHERE("Contact No." = FIELD("Contact No.")));
        }
    }

    keys
    {
        key(Key1; "Vehicle Serial No.", "Relationship Code", "Contact No.")
        {
            Clustered = true;
        }
        key(Key2; "Contact No.")
        {
        }
        key(Key3; "Vehicle Serial No.", "Transfer Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Transfer Date" <> 0D THEN
            "Transfer Date" := TODAY;
    end;
}


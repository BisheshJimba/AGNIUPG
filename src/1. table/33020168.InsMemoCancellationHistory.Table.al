table 33020168 "Ins. Memo Cancellation History"
{

    fields
    {
        field(1; "Insurance Memo No."; Code[20])
        {
        }
        field(2; "Vehicle Serial No."; Code[20])
        {
        }
        field(3; "Chesis No."; Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Editable = false;
                FieldClass = FlowField;
        }
        field(4; "Reason for Cancellation"; Text[50])
        {

            trigger OnValidate()
            begin
                TESTFIELD("Date of cancellation", 0D);
            end;
        }
        field(5; "Date of cancellation"; Date)
        {
        }
        field(6; "Cancelled By"; Code[50])
        {
        }
    }

    keys
    {
        key(Key1; "Insurance Memo No.", "Vehicle Serial No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


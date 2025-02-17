table 33019870 "Service Reminder Subform"
{

    fields
    {
        field(1; "Vehicle Serial No."; Code[20])
        {
        }
        field(2; Remarks; Text[150])
        {
        }
        field(3; "Next Service Date"; Date)
        {
        }
        field(4; Kilometrage; Decimal)
        {
        }
        field(5; "Line No."; Integer)
        {
        }
        field(6; "Job Card No."; Code[20])
        {
            TableRelation = "Service Header EDMS".No. WHERE(Vehicle Serial No.=FIELD(Vehicle Serial No.));
        }
        field(7; "Posted Job Card No."; Code[20])
        {
            CalcFormula = Lookup("Posted Serv. Order Header".No. WHERE(Order No.=FIELD(Job Card No.)));
                Editable = false;
                FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Vehicle Serial No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


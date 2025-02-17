table 25006186 "Tire Mgt Cue"
{
    Caption = 'Tire Mgt Cue';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "Service Lines Count"; Integer)
        {
            CalcFormula = Count("Service Line EDMS" WHERE(Tire Operation Type=FILTER(>' ')));
            Caption = 'Service Lines Count';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30;"Put on Tires Count";Integer)
        {
            CalcFormula = Count("Tire Entry" WHERE (Open=CONST(Yes)));
            Caption = 'Put on Tires Count';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


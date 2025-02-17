table 33019892 "Jobs Cue"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Open Jobs"; Integer)
        {
            CalcFormula = Count("Posted Battery Job Header" WHERE(Exide Claim=CONST(No),
                                                                   Action=CONST(" "),
                                                                   Responsibility Center=FIELD(Responsibility Center),
                                                                   Location Code=FIELD(Location)));
            FieldClass = FlowField;
        }
        field(3;"Exide Claims";Integer)
        {
            CalcFormula = Count("Exide Claim" WHERE (Issued=CONST(No),
                                                     Responsibility Center=FIELD(Responsibility Center),
                                                     Location Code=FIELD(Location)));
            FieldClass = FlowField;
        }
        field(4;Recharged;Integer)
        {
            CalcFormula = Count("Posted Battery Job Header" WHERE (Action=CONST(Recharge),
                                                                   Responsibility Center=FIELD(Responsibility Center),
                                                                   Location Code=FIELD(Location)));
            FieldClass = FlowField;
        }
        field(5;Issued;Integer)
        {
            CalcFormula = Count("Exide Claim" WHERE (Issued=CONST(Yes),
                                                     Responsibility Center=FIELD(Responsibility Center),
                                                     Location Code=FIELD(Location),
                                                     Sales Order Posted=CONST(Yes)));
            FieldClass = FlowField;
        }
        field(6;BatteryList;Integer)
        {
            CalcFormula = Count(Item WHERE (Item For=CONST(BTD)));
            FieldClass = FlowField;
        }
        field(7;"Pre Exide Claims";Integer)
        {
            CalcFormula = Count("Posted Battery Job Header" WHERE (Exide Claim=CONST(No),
                                                                   Action=CONST(Replace),
                                                                   Responsibility Center=FIELD(Responsibility Center),
                                                                   Location Code=FIELD(Location)));
            FieldClass = FlowField;
        }
        field(8;Rejected;Integer)
        {
            CalcFormula = Count("Posted Battery Job Header" WHERE (Action=CONST(Reject),
                                                                   Responsibility Center=FIELD(Responsibility Center),
                                                                   Location Code=FIELD(Location)));
            FieldClass = FlowField;
        }
        field(9;"Posted Jobs List";Integer)
        {
            CalcFormula = Count("Posted Battery Job Header" WHERE (Exide Claim=CONST(Yes),
                                                                   Responsibility Center=FIELD(Responsibility Center),
                                                                   Location Code=FIELD(Location)));
            FieldClass = FlowField;
        }
        field(10;"Sales Order";Integer)
        {
            FieldClass = Normal;
        }
        field(11;"Issued Warranty";Integer)
        {
            CalcFormula = Count("Exide Claim" WHERE (Issued=CONST(Yes),
                                                     Sales Order Posted=CONST(Yes),
                                                     GRN=CONST(No),
                                                     Responsibility Center=FIELD(Responsibility Center),
                                                     Location Code=FIELD(Location)));
            FieldClass = FlowField;
        }
        field(12;"Opening Jobs";Integer)
        {
            CalcFormula = Count("Batt-Service Job Card Table" WHERE (Exide Claim=CONST(No),
                                                                     Action=CONST(" "),
                                                                     Responsibility Center=FIELD(Responsibility Center),
                                                                     Location Code=FIELD(Location)));
            FieldClass = FlowField;
        }
        field(13;"All Posted Open Jobs";Integer)
        {
            CalcFormula = Count("Posted Battery Job Header" WHERE (Action=CONST(" "),
                                                                   Exide Claim=CONST(No)));
            FieldClass = FlowField;
        }
        field(14;"Request From Service";Integer)
        {
            CalcFormula = Count("Battery From Store");
            FieldClass = FlowField;
        }
        field(50000;"Not Attend Jobs";Integer)
        {
            CalcFormula = Count("Posted Battery Job Header" WHERE (Action=CONST(Others),
                                                                   Responsibility Center=FIELD(Responsibility Center),
                                                                   Location Code=FIELD(Location)));
            FieldClass = FlowField;
        }
        field(50001;"All Jobs";Integer)
        {
            CalcFormula = Count("Posted Battery Job Header");
            FieldClass = FlowField;
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
        field(33020236;"Responsibility Center";Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Responsibility Center";
        }
        field(33020237;Location;Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(33020238;"Pending Jobs";Integer)
        {
            CalcFormula = Count("Posted Battery Job Header" WHERE (Action=CONST(Pending),
                                                                   Responsibility Center=FIELD(Responsibility Center),
                                                                   Location Code=FIELD(Location)));
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


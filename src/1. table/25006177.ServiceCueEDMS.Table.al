table 25006177 "Service Cue EDMS"
{
    Caption = 'Service Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Service Orders - In Process"; Integer)
        {
            CalcFormula = Count("Service Header EDMS" WHERE(Document Type=FILTER(Order),
                                                             Work Status (System)=FILTER(In Process),
                                                             Responsibility Center=FIELD(Responsibility Center),
                                                             Location Code=FIELD(Location)));
            Caption = 'Service Orders - in Process';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3;"Service Orders - Finished";Integer)
        {
            CalcFormula = Count("Service Header EDMS" WHERE (Document Type=FILTER(Order),
                                                             Work Status (System)=FILTER(Finished),
                                                             Responsibility Center=FIELD(Responsibility Center),
                                                             Location Code=FIELD(Location)));
            Caption = 'Service Orders - Finished';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4;"Service Orders - Inactive";Integer)
        {
            CalcFormula = Count("Service Header EDMS" WHERE (Document Type=FILTER(Order),
                                                             Work Status (System)=FILTER(On Hold|' '),
                                                             Responsibility Center=FIELD(Responsibility Center),
                                                             Location Code=FIELD(Location)));
            Caption = 'Service Orders - Inactive';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"Open Service Quotes";Integer)
        {
            CalcFormula = Count("Service Header EDMS" WHERE (Document Type=CONST(Quote),
                                                             Status=CONST(Open),
                                                             Responsibility Center=FIELD(Responsibility Center),
                                                             Location Code=FIELD(Location)));
            Caption = 'Open Service Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Service Orders - Today";Integer)
        {
            CalcFormula = Count("Service Header EDMS" WHERE (Document Type=FILTER(Order),
                                                             Planned Service Date=FIELD(Date Filter),
                                                             Responsibility Center=FIELD(Responsibility Center),
                                                             Location Code=FIELD(Location)));
            Caption = 'Service Orders - Today';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;"Service Orders - to Follow-up";Integer)
        {
            CalcFormula = Count("Service Header" WHERE (Document Type=FILTER(Order),
                                                        Status=FILTER(In Process),
                                                        Responsibility Center=FIELD(Responsibility Center),
                                                        Location Code=FIELD(Location)));
            Caption = 'Service Orders - to Follow-up';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"My Tasks EC";Integer)
        {
            Caption = 'My Tasks';
            Editable = false;
        }
        field(20;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(30;"My Group Tasks EC";Integer)
        {
            Caption = 'My Group Tasks';
            Editable = false;
        }
        field(40;"My Orders EC";Integer)
        {
            CalcFormula = Count("Service Header EDMS" WHERE (Document Type=CONST(Order)));
            Caption = 'My Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            FieldClass = FlowFilter;
            TableRelation = "Accountability Center";
        }
        field(33020235;"Service Orders - Booking";Integer)
        {
            CalcFormula = Count("Service Header EDMS" WHERE (Document Type=FILTER(Order),
                                                             Work Status (System)=FILTER(Booking|Pending),
                                                             Responsibility Center=FIELD(Responsibility Center),
                                                             Location Code=FIELD(Location),
                                                             Accountability Center=FIELD(Accountability Center)));
            Editable = false;
            FieldClass = FlowField;
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


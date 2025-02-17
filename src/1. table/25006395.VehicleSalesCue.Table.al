table 25006395 "Vehicle Sales Cue"
{
    Caption = 'Vehicle Sales Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Sales Quotes - Open"; Integer)
        {
            CalcFormula = Count("Sales Header" WHERE(Document Type=FILTER(Quote),
                                                      Status=FILTER(Open),
                                                      Document Profile=CONST(Vehicles Trade)));
            Caption = 'Sales Quotes - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3;"Sales Orders - Open";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Order),
                                                      Status=FILTER(Open),
                                                      Document Profile=CONST(Vehicles Trade)));
            Caption = 'Sales Orders - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4;"Ready to Ship";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Order),
                                                      Status=FILTER(Released),
                                                      Ship=FILTER(No),
                                                      Shipment Date=FIELD(Date Filter2),
                                                      Document Profile=CONST(Vehicles Trade)));
            Caption = 'Ready to Ship';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;Delayed;Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Order),
                                                      Status=FILTER(Released),
                                                      Shipment Date=FIELD(Date Filter),
                                                      Document Profile=CONST(Vehicles Trade)));
            Caption = 'Delayed';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Sales Return Orders - All";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Return Order),
                                                      Status=FILTER(Open),
                                                      Document Profile=CONST(Vehicles Trade)));
            Caption = 'Sales Return Orders - All';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Sales Credit Memos - All";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Credit Memo),
                                                      Status=FILTER(Open),
                                                      Document Profile=CONST(Vehicles Trade)));
            Caption = 'Sales Credit Memos - All';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Partially Shipped";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Order),
                                                      Status=FILTER(Released),
                                                      Ship=FILTER(Yes),
                                                      Completely Shipped=FILTER(No),
                                                      Shipment Date=FIELD(Date Filter2),
                                                      Document Profile=CONST(Vehicles Trade)));
            Caption = 'Partially Shipped';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(21;"Date Filter2";Date)
        {
            Caption = 'Date Filter2';
            Editable = false;
            FieldClass = FlowFilter;
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


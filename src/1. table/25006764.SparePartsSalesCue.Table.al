table 25006764 "Spare Parts Sales Cue"
{
    Caption = 'Spare Parts Sales Cue';

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
                                                      Document Profile=CONST(Spare Parts Trade)));
            Caption = 'Sales Quotes - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3;"Sales Orders - Open";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Order),
                                                      Status=FILTER(Open),
                                                      Document Profile=CONST(Spare Parts Trade)));
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
                                                      Document Profile=CONST(Spare Parts Trade)));
            Caption = 'Ready to Ship';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;Delayed;Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Order),
                                                      Status=FILTER(Released),
                                                      Shipment Date=FIELD(Date Filter),
                                                      Document Profile=CONST(Spare Parts Trade)));
            Caption = 'Delayed';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Sales Return Orders - All";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Return Order),
                                                      Status=FILTER(Open),
                                                      Document Profile=CONST(Spare Parts Trade)));
            Caption = 'Sales Return Orders - All';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Sales Credit Memos - All";Integer)
        {
            CalcFormula = Count("Sales Header" WHERE (Document Type=FILTER(Credit Memo),
                                                      Status=FILTER(Open),
                                                      Document Profile=CONST(Spare Parts Trade)));
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
                                                      Document Profile=CONST(Spare Parts Trade)));
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
        field(33019831;"Receive from Branch";Integer)
        {
            CalcFormula = Count("Transfer Header" WHERE (Document Profile=CONST(Spare Parts Trade),
                                                         Location Filter=FIELD(Location Filter),
                                                         Transfer-to Code=FIELD(Location Filter),
                                                         Completely Received=CONST(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33019832;"Receive from Service";Integer)
        {
            CalcFormula = Count("Transfer Header" WHERE (Document Profile=CONST(Service),
                                                         Location Filter=FIELD(Location Filter),
                                                         Transfer-to Code=FIELD(Location Filter),
                                                         Completely Received=CONST(No)));
            FieldClass = FlowField;
        }
        field(33019833;"Pending Shipment (Service)";Integer)
        {
            CalcFormula = Count("Transfer Header" WHERE (Document Profile=CONST(Service),
                                                         Location Filter=FIELD(Location Filter),
                                                         Transfer-from Code=FIELD(Location Filter),
                                                         Completely Shipped=CONST(No),
                                                         Job Open=CONST(Yes)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33019834;"Location Filter";Code[10])
        {
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(33019835;"Responsibility Center Filter";Code[10])
        {
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(33019836;"Pending Shipment (Branch)";Integer)
        {
            CalcFormula = Count("Transfer Header" WHERE (Document Profile=CONST(Spare Parts Trade),
                                                         Location Filter=FIELD(Location Filter),
                                                         Transfer-from Code=FIELD(Location Filter),
                                                         Completely Shipped=CONST(No)));
            FieldClass = FlowField;
        }
        field(33019961;"Accountability Center Filter";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
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


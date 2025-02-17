table 25006765 "Spare Parts Purchase Cue"
{
    Caption = 'Spare Parts Purchase Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "To Send or Confirm"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE(Document Type=FILTER(Order),
                                                         Status=FILTER(Open),
                                                         Document Profile=CONST(Spare Parts Trade)));
            Caption = 'To Send or Confirm';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3;"Upcoming Orders";Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE (Document Type=FILTER(Order),
                                                         Status=FILTER(Released),
                                                         Expected Receipt Date=FIELD(Date Filter),
                                                         Document Profile=CONST(Spare Parts Trade)));
            Caption = 'Upcoming Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4;"Outstanding Purchase Orders";Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE (Document Type=FILTER(Order),
                                                         Status=FILTER(Released),
                                                         Receive=FILTER(Yes),
                                                         Completely Received=FILTER(No),
                                                         Document Profile=CONST(Spare Parts Trade)));
            Caption = 'Outstanding Purchase Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"Purchase Return Orders - All";Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE (Document Type=FILTER(Return Order),
                                                         Document Profile=CONST(Spare Parts Trade)));
            Caption = 'Purchase Return Orders - All';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Not Invoiced";Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE (Document Type=FILTER(Order),
                                                         Completely Received=FILTER(Yes),
                                                         Invoice=FILTER(No),
                                                         Document Profile=CONST(Spare Parts Trade)));
            Caption = 'Not Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Partially Invoiced";Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE (Document Type=FILTER(Order),
                                                         Completely Received=FILTER(Yes),
                                                         Invoice=FILTER(Yes),
                                                         Document Profile=CONST(Spare Parts Trade)));
            Caption = 'Partially Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20;"Date Filter";Date)
        {
            Caption = 'Date Filter';
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
                                                         Completely Shipped=CONST(No)));
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


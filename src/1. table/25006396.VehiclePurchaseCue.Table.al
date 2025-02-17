table 25006396 "Vehicle Purchase Cue"
{
    Caption = 'Vehicle Purchase Cue';

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


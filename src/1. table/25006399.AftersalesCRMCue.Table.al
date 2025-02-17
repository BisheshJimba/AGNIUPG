table 25006399 "Aftersales CRM Cue"
{

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "Campaign Active"; Integer)
        {
            CalcFormula = Count(Campaign WHERE(Activated = FILTER(Yes)));
            Caption = 'Active Campaign ';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "My To-do This Week"; Integer)
        {
            CalcFormula = Count(To-do WHERE (Date=FIELD(Date Filter 1),
                                             Salesperson Code=FIELD(Salesperson Code)));
            Caption = 'My To-do This Week';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40;"My To-do Next Week";Integer)
        {
            CalcFormula = Count(To-do WHERE (Date=FIELD(Date Filter 2),
                                             Salesperson Code=FIELD(Salesperson Code)));
            Caption = 'My To-do Next Week';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50;"My Segments";Integer)
        {
            CalcFormula = Count("Segment Header" WHERE (Salesperson Code=FIELD(Salesperson Code)));
            Caption = 'My Segments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60;"My Contacts";Integer)
        {
            CalcFormula = Count(Contact WHERE (Salesperson Code=FIELD(Salesperson Code)));
            Caption = 'My Contacts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70;"Date Filter 1";Date)
        {
            Caption = 'Date Filter 1';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(80;"Date Filter 2";Date)
        {
            Caption = 'Date Filter 2';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(90;"My Customers";Integer)
        {
            CalcFormula = Count(Customer WHERE (Salesperson Code=FIELD(Salesperson Code)));
            Caption = 'My Customers';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100;"My Contracts";Integer)
        {
            CalcFormula = Count(Contract WHERE (Salesperson Code=FIELD(Salesperson Code)));
            Caption = 'My Contracts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110;"Salesperson Code";Code[10])
        {
            Caption = 'Salesperson Code';
            FieldClass = FlowFilter;
        }
        field(120;"My To-do";Integer)
        {
            CalcFormula = Count(To-do WHERE (Salesperson Code=FIELD(Salesperson Code)));
            Caption = 'My To-do';
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


table 33019860 "Customer Allocation Entry"
{

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Sales Order No."; Code[20])
        {
            Editable = false;
        }
        field(3; "Model Version No."; Code[20])
        {
            Editable = false;
            TableRelation = Item WHERE(Item Type=FILTER(Model Version));

            trigger OnValidate()
            begin
                CALCFIELDS("Model Version Desc");
            end;
        }
        field(4;"Model Version Desc";Text[30])
        {
            CalcFormula = Lookup(Item.Description WHERE (Item Type=CONST(Model Version),
                                                         No.=FIELD(Model Version No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"Customer No.";Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate()
            begin
                CALCFIELDS(Name);
            end;
        }
        field(6;Name;Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE (No.=FIELD(Customer No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Booked Date";Date)
        {
            Editable = false;
        }
        field(8;"User ID";Code[50])
        {
            Editable = false;
        }
        field(9;Applied;Boolean)
        {
            Editable = false;
        }
        field(10;"Quote No.";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User ID" := USERID;
    end;
}


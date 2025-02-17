table 33020331 "Allotment Deallotment History"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; Type; Option)
        {
            OptionCaption = 'Allotment,Deallotment';
            OptionMembers = Allotment,Deallotment;
        }
        field(3; "Vehicle Serial No."; Code[20])
        {
            TableRelation = Vehicle;
        }
        field(4; VIN; Code[20])
        {
        }
        field(5; "Model Version No."; Code[20])
        {
            TableRelation = Item.No. WHERE(Item Type=CONST(Model Version));
        }
        field(6; Date; Date)
        {
        }
        field(7; Time; Time)
        {
        }
        field(8; "Document No."; Code[20])
        {
        }
        field(9; Link; Option)
        {
            OptionCaption = ' ,Transfer Order,Sales Order';
            OptionMembers = " ","Transfer Order","Sales Order";
        }
        field(10; "Customer No."; Code[20])
        {
            CalcFormula = Lookup("Sales Header"."Bill-to Customer No." WHERE(No.=FIELD(Document No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11;"Customer Name";Text[50])
        {
            CalcFormula = Lookup("Sales Header"."Bill-to Name" WHERE (No.=FIELD(Document No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12;"Location Code";Code[10])
        {
            CalcFormula = Lookup("Transfer Header"."Transfer-to Code" WHERE (No.=FIELD(Document No.)));
            FieldClass = FlowField;
        }
        field(13;"Current Locatoin of Vehicle";Code[20])
        {
            CalcFormula = Lookup("Item Ledger Entry"."Location Code" WHERE (Serial No.=FIELD(Vehicle Serial No.),
                                                                            Remaining Quantity=CONST(1),
                                                                            Open=CONST(Yes)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


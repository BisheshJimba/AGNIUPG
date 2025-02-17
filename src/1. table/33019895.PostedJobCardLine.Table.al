table 33019895 "Posted Job Card Line"
{

    fields
    {
        field(1; "Job Card No."; Code[20])
        {
        }
        field(2; Cell; Integer)
        {
            Enabled = true;
            TableRelation = "Cell Template".Cell;
        }
        field(3; "Initial SG"; Decimal)
        {
        }
        field(4; "Final SG"; Decimal)
        {
        }
        field(5; Voltage; Decimal)
        {
        }
        field(6; "High Rate Disch."; Decimal)
        {
        }
        field(7; "Responsibility Center"; Code[20])
        {
        }
        field(8; "Location Code"; Code[20])
        {
        }
        field(9; "Dimension 1"; Code[20])
        {
        }
        field(10; "Dimension 2"; Code[20])
        {
        }
        field(11; "User ID"; Code[50])
        {
        }
        field(12; "Midtronic Test"; Decimal)
        {
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(33019961; "Accountability Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1; "Job Card No.", Cell)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*JobCardLine.TESTFIELD(Cell);   */

    end;

    var
        JobCardLine: Record "33019885";
}


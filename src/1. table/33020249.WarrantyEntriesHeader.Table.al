table 33020249 "Warranty Entries Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = true;

            trigger OnValidate()
            begin
                WarrantyReg.RESET;
                WarrantyReg.SETRANGE("No.", xRec."No.");
                IF WarrantyReg.FINDSET THEN BEGIN
                    REPEAT
                        WarrantyReg."No." := "No.";
                        WarrantyReg.MODIFY(TRUE);
                    UNTIL WarrantyReg.NEXT = 0;
                END
            end;
        }
        field(2; "Service Order No."; Code[20])
        {
            Editable = false;
            TableRelation = "Posted Serv. Order Header";
        }
        field(3; "Responsibility Center"; Code[10])
        {
            Editable = false;
        }
        field(4; "Location Code"; Code[10])
        {
            Editable = false;
        }
        field(5; Exported; Boolean)
        {
            Editable = true;
        }
        field(6; "Prowac Year"; Integer)
        {
            Editable = true;
        }
        field(7; "Claim No."; Code[20])
        {
            Editable = false;
        }
        field(8; "Make Code"; Code[20])
        {
            TableRelation = Make;
        }
        field(20; VIN; Code[20])
        {
            CalcFormula = Lookup("Warranty Register".VIN WHERE(No.=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vehicle.VIN;
        }
        field(40;"Sell to Customer No.";Code[20])
        {
            TableRelation = Customer;
        }
        field(45;"Bill to Customer No.";Code[20])
        {
            TableRelation = Customer;
        }
        field(163;"PCR Date";Date)
        {
            CalcFormula = Lookup("Posted Serv. Order Header"."Posting Date" WHERE (Order No.=FIELD(Service Order No.)));
            Description = 'Job Closed Date';
            Editable = true;
            FieldClass = FlowField;
        }
        field(164;"Job Close Date";Date)
        {
        }
        field(165;Settled;Boolean)
        {
            CalcFormula = Lookup("Warranty Settlement".Settled WHERE (PCR No.=FIELD(No.),
                                                                      Year=FIELD(Prowac Year)));
            FieldClass = FlowField;
        }
        field(166;Hide;Boolean)
        {
        }
        field(167;"Hidden Reason";Text[100])
        {
        }
        field(168;"Prowac Dealer Code";Code[30])
        {
            Editable = false;
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
        field(33019962;"Claim/Ref No.";Code[20])
        {
        }
        field(33019963;"Claim Status";Boolean)
        {
        }
        field(33019964;"Claimed Date";Date)
        {
        }
        field(33019965;"Sell to Customer Name";Text[70])
        {
            CalcFormula = Lookup(Customer.Name WHERE (No.=FIELD(Sell to Customer No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33019966;"Bill to Customer Name";Text[70])
        {
            CalcFormula = Lookup(Customer.Name WHERE (No.=FIELD(Bill to Customer No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33019967;"Engine No.";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Engine No." WHERE (VIN=FIELD(VIN)));
            FieldClass = FlowField;
        }
        field(33019968;"Vehicle Registration No.";Code[30])
        {
            CalcFormula = Lookup("Warranty Register"."Veh. Regd. No." WHERE (No.=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33019969;"Model Code";Code[20])
        {
            CalcFormula = Lookup("Warranty Register"."Model Code" WHERE (No.=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33019970;"Model Version No.";Code[20])
        {
            CalcFormula = Lookup("Warranty Register"."Model Version No." WHERE (No.=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
        key(Key2;"Job Close Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        WarrantyReg: Record "33020238";
}


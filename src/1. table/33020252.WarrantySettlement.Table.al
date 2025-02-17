table 33020252 "Warranty Settlement"
{

    fields
    {
        field(1; "PCR No."; Code[20])
        {
            TableRelation = "Warranty Entries Header";
        }
        field(2; Year; Integer)
        {
        }
        field(3; "Credit Amount"; Decimal)
        {
        }
        field(4; "Credit Note No."; Code[20])
        {
        }
        field(5; "Settled Date"; Date)
        {
        }
        field(6; "Pre-Assigned No."; Code[20])
        {
            Editable = false;
        }
        field(7; "Invoice No."; Code[20])
        {
            CalcFormula = Lookup("Sales Invoice Header".No. WHERE(Pre-Assigned No.=FIELD(Pre-Assigned No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;Apply;Boolean)
        {
        }
        field(9;Settled;Boolean)
        {
            Editable = false;
        }
        field(10;"Claim Amount";Decimal)
        {
            Description = '//Incomplete';
        }
        field(11;"Prowac Dealer Code";Text[30])
        {
        }
    }

    keys
    {
        key(Key1;"Prowac Dealer Code","PCR No.",Year,"Settled Date")
        {
            Clustered = true;
        }
        key(Key2;"Credit Note No.")
        {
        }
    }

    fieldgroups
    {
    }

    [Scope('Internal')]
    procedure ApplyPreAssignedNo(PreAssignedNo: Code[20])
    begin
        "Pre-Assigned No." := PreAssignedNo;
    end;

    [Scope('Internal')]
    procedure ModifyAll(Apply: Boolean;var WarrantySettlement: Record "33020252";PreAssignNo: Code[20])
    var
        ReWarSettle: Record "33020252";
    begin
        ReWarSettle.COPYFILTERS(WarrantySettlement);
        IF ReWarSettle.FINDFIRST THEN REPEAT
          ReWarSettle.TESTFIELD(Settled,FALSE);
          ReWarSettle.Apply := Apply;
          IF Apply THEN
            ReWarSettle."Pre-Assigned No." := PreAssignNo
          ELSE
            ReWarSettle."Pre-Assigned No." := '';
          ReWarSettle.MODIFY;
        UNTIL ReWarSettle.NEXT=0;
    end;
}


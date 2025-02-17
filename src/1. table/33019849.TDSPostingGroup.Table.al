table 33019849 "TDS Posting Group"
{
    LookupPageID = 33020055;

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "TDS%"; Decimal)
        {
        }
        field(4; "GL Account No."; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(5; Type; Option)
        {
            OptionCaption = ' ,Purchase TDS,Sales TDS';
            OptionMembers = " ","Purchase TDS","Sales TDS";
        }
        field(6; "Effective From"; Date)
        {
        }
        field(7; Blocked; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('Internal')]
    procedure FindTDSGroup(TDSGroup: Code[20]; EffectiveDate: Date): Boolean
    begin
        //TDS2.00
        RESET;
        SETRANGE(Code, TDSGroup);
        SETRANGE(Blocked, FALSE);
        //SETFILTER("Effective From",'<%1',EffectiveDate);
        EXIT(FINDLAST);
    end;
}


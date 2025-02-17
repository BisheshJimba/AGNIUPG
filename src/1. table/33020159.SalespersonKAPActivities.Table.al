table 33020159 "Salesperson KAP Activities"
{

    fields
    {
        field(1; "Salesperson Code"; Code[10])
        {
            TableRelation = Salesperson/Purchaser;
        }
        field(2;Year;Integer)
        {
            NotBlank = true;
            TableRelation = "English Year";
        }
        field(3;Month;Option)
        {
            NotBlank = true;
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(4;"No. of Activities Planned";Integer)
        {
            CalcFormula = Count("Salesperson KAP Details" WHERE (Salesperson Code=FIELD(Salesperson Code),
                                                                 Year=FIELD(Year),
                                                                 Month=FIELD(Month),
                                                                 Week No=FIELD(Week No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"No. of Activities Completed";Integer)
        {
            CalcFormula = Count("Salesperson KAP Details" WHERE (Salesperson Code=FIELD(Salesperson Code),
                                                                 Year=FIELD(Year),
                                                                 Month=FIELD(Month),
                                                                 Week No=FIELD(Week No),
                                                                 KAP Status=CONST(Done)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Week No";Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Salesperson Code",Year,Month,"Week No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


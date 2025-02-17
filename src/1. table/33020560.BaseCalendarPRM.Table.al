table 33020560 "Base Calendar PRM"
{
    Caption = 'Base Calendar';
    DataCaptionFields = "Code", Name;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Name; Text[30])
        {
            Caption = 'Name';
        }
        field(3; "Customized Changes Exist"; Boolean)
        {
            CalcFormula = Exist("Customized Calendar Change" WHERE(Base Calendar Code=FIELD(Code)));
            Caption = 'Customized Changes Exist';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CustCalendarChange.RESET;
        CustCalendarChange.SETRANGE("Base Calendar Code",Code);
        IF CustCalendarChange.FIND('-') THEN
          ERROR(Text001,Code);

        BaseCalendarLine.RESET;
        BaseCalendarLine.SETRANGE("Base Calendar Code",Code);
        BaseCalendarLine.DELETEALL;
    end;

    var
        CustCalendarChange: Record "7602";
        BaseCalendarLine: Record "7601";
        Text001: Label 'You cannot delete this record. Customized calendar changes exist for calendar code=<%1>.';
}


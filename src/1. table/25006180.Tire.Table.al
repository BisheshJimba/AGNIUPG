table 25006180 Tire
{
    Caption = 'Tire';
    DrillDownPageID = 25006267;
    LookupPageID = 25006267;

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(30; "Variable Field Run 1"; Decimal)
        {
            CalcFormula = Sum("Tire Entry"."Variable Field Run 1" WHERE(Tire Code=FIELD(Code)));
            CaptionClass = '7,25006180,30';
            Description = 'that works correctly only for MngSetup."Check Tire Unique" = true';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40;Available;Boolean)
        {
            CalcFormula = -Exist("Tire Entry" WHERE (Tire Code=FIELD(Code),
                                                     Open=CONST(Yes)));
            Caption = 'Available';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60;"Current Vehicle Serial No.";Code[20])
        {
            CalcFormula = Lookup("Tire Entry"."Vehicle Serial No." WHERE (Tire Code=FIELD(Code),
                                                                          Open=CONST(Yes)));
            Caption = 'Current Vehicle Serial No.';
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
        TireEntry.RESET;
        TireEntry.SETRANGE("Tire Code", Code);
        IF TireEntry.FINDFIRST THEN
          ERROR(Text001, Rec.TABLECAPTION, Code, TireEntry.TABLECAPTION);
    end;

    var
        TireEntry: Record "25006181";
        Text001: Label 'You cannot delete %1 %2 because there are one or records in %3.';
}


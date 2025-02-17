table 25006028 "Process Checklist Line"
{
    Caption = 'Process Checklist Line';
    LookupPageID = 25006021;

    fields
    {
        field(10; "Process Checklist No."; Code[10])
        {
            Caption = 'Process Checklist No.';
            TableRelation = "Process Checklist Header";
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; "Type Code"; Code[20])
        {
            Caption = 'Type Code';
            TableRelation = "Variable Field";

            trigger OnValidate()
            begin
                IF "Type Code" <> xRec."Type Code" THEN
                    VALIDATE(Value, '');
            end;
        }
        field(40; Value; Code[20])
        {
            Caption = 'Value';
            TableRelation = "Variable Field Options".Code WHERE(Make Code=FILTER(''),
                                                                 Variable Field Code=FIELD(Type Code));
            ValidateTableRelation = false;
        }
        field(50;"Type Description";Text[30])
        {
            CalcFormula = Lookup("Variable Field".Caption WHERE (Code=FIELD(Type Code)));
            Caption = 'Type Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60;"Value Description";Text[30])
        {
            CalcFormula = Lookup("Variable Field Options".Description WHERE (Make Code=FILTER(''),
                                                                             Variable Field Code=FIELD(Type Code),
                                                                             Code=FIELD(Value)));
            Caption = 'Value Description';
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                CALCFIELDS("Value Description");
            end;
        }
        field(50001;"Damage Remarks";Text[250])
        {
            Description = 'To write any demage remarks obsered during receiving of vehicle';
        }
        field(50002;"Vehicle Serial No.";Code[20])
        {
            CalcFormula = Lookup("Process Checklist Header"."Vehicle Serial No." WHERE (No.=FIELD(Process Checklist No.)));
            Description = 'Chandra 27/10/2013 (for jet reports)';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Process Checklist No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


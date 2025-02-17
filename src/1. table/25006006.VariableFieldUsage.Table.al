table 25006006 "Variable Field Usage"
{
    Caption = 'Variable Field Usage';
    LookupPageID = "Variable Field Usage";

    fields
    {
        field(10; "Table No."; Integer)
        {
            Caption = 'Table No.';
            TableRelation = Object.ID WHERE(Type = CONST(Table));

            trigger OnLookup()
            begin
                LookUpMgt.LookUpVariableUsageObject("Table No.");
                VALIDATE("Table No.");
            end;
        }
        field(20; "Field No."; Integer)
        {
            Caption = 'Field No.';
            TableRelation = Field."No." WHERE(TableNo = FIELD("Table No."));

            trigger OnLookup()
            begin
                LookUpMgt.LookUpVariableUsageField("Field No.", "Table No.");
                VALIDATE("Field No.");
            end;
        }
        field(27; "Variable Field Group Code"; Code[10])
        {
            Caption = 'Variable Field Group Code';
            TableRelation = "Variable Field Group";

            trigger OnValidate()
            begin
                IF Rec."Variable Field Group Code" <> xRec."Variable Field Group Code" THEN
                    "Variable Field Code" := ''
            end;
        }
        field(30; "Variable Field Code"; Code[10])
        {
            Caption = 'Variable Field Code';
            TableRelation = "Variable Field" WHERE("Variable Field Group Code" = FIELD("Variable Field Group Code"));

            trigger OnValidate()
            var
                VF: Record "Variable Field";
            begin
                IF VF.GET("Variable Field Code") THEN
                    "Variable Field Group Code" := VF."Variable Field Group Code";
            end;
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.")
        {
            Clustered = true;
        }
        key(Key2; "Variable Field Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Rec.TESTFIELD("Variable Field Code")
    end;

    trigger OnModify()
    begin
        Rec.TESTFIELD("Variable Field Code")
    end;

    var
        LookUpMgt: Codeunit 25006003;
}


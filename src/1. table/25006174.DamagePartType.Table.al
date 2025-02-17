table 25006174 "Damage Part Type"
{
    Caption = 'Damage Part Type';
    LookupPageID = 25006249;

    fields
    {
        field(10; "Damage Part Code"; Code[10])
        {
            Caption = 'Damage Part Code';
            TableRelation = "Service Plan Comment Line";
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006174,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Damage Part Type", FIELDNO("Variable Field 25006800"),
                  '', "Variable Field 25006800") THEN BEGIN
                    VALIDATE("Variable Field 25006800", VFOptions.Code);
                END;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006174,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Damage Part Type", FIELDNO("Variable Field 25006801"),
                  '', "Variable Field 25006801") THEN BEGIN
                    VALIDATE("Variable Field 25006801", VFOptions.Code);
                END;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006174,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Damage Part Type", FIELDNO("Variable Field 25006802"),
                  '', "Variable Field 25006802") THEN BEGIN
                    VALIDATE("Variable Field 25006802", VFOptions.Code);
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Damage Part Code", "Variable Field 25006800", "Variable Field 25006801", "Variable Field 25006802")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        cuVFMgt: Codeunit "25006004";
        cuLookupMgt: Codeunit "25006003";

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(cuVFMgt);
        EXIT(cuVFMgt.IsVFActive(DATABASE::"Damage Part Type", intFieldNo));
    end;
}


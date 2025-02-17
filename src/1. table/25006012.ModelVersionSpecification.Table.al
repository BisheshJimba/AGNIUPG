table 25006012 "Model Version Specification"
{
    // 04.06.2007. EDMS P2
    //   * Created table

    Caption = 'Model Version Specification';

    fields
    {
        field(1; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(4; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE("Make Code" = FIELD("Make Code"));
        }
        field(10; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." WHERE("Item Type" = CONST("Model Version"),
                                            "Make Code" = FIELD("Make Code"),
                                            "Model Code" = FIELD("Model Code"));

            trigger OnLookup()
            var
                recItem: Record Item;
            begin
                recItem.RESET;
                IF cuLookupMgt.LookUpModelVersion(recItem, "Model Version No.", "Make Code", "Model Code") THEN
                    "Model Version No." := recItem."No.";
            end;
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006012,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") THEN BEGIN
                    VALIDATE("Variable Field 25006800", VFOptions.Code);
                END;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006012,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") THEN BEGIN
                    VALIDATE("Variable Field 25006801", VFOptions.Code);
                END;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006012,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") THEN BEGIN
                    VALIDATE("Variable Field 25006802", VFOptions.Code);
                END;
            end;
        }
        field(25006803; "Variable Field 25006803"; Code[20])
        {
            CaptionClass = '7,25006012,25006803';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006803"),
                  "Make Code", "Variable Field 25006803") THEN BEGIN
                    VALIDATE("Variable Field 25006803", VFOptions.Code);
                END;
            end;
        }
        field(25006804; "Variable Field 25006804"; Code[20])
        {
            CaptionClass = '7,25006012,25006804';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006804"),
                  "Make Code", "Variable Field 25006804") THEN BEGIN
                    VALIDATE("Variable Field 25006804", VFOptions.Code);
                END;
            end;
        }
        field(25006805; "Variable Field 25006805"; Code[20])
        {
            CaptionClass = '7,25006012,25006805';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006805"),
                  "Make Code", "Variable Field 25006805") THEN BEGIN
                    VALIDATE("Variable Field 25006805", VFOptions.Code);
                END;
            end;
        }
        field(25006806; "Variable Field 25006806"; Code[20])
        {
            CaptionClass = '7,25006012,25006806';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006806"),
                  "Make Code", "Variable Field 25006806") THEN BEGIN
                    VALIDATE("Variable Field 25006806", VFOptions.Code);
                END;
            end;
        }
        field(25006807; "Variable Field 25006807"; Code[20])
        {
            CaptionClass = '7,25006012,25006807';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006807"),
                  "Make Code", "Variable Field 25006807") THEN BEGIN
                    VALIDATE("Variable Field 25006807", VFOptions.Code);
                END;
            end;
        }
        field(25006808; "Variable Field 25006808"; Code[20])
        {
            CaptionClass = '7,25006012,25006808';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006808"),
                  "Make Code", "Variable Field 25006808") THEN BEGIN
                    VALIDATE("Variable Field 25006808", VFOptions.Code);
                END;
            end;
        }
        field(25006809; "Variable Field 25006809"; Code[20])
        {
            CaptionClass = '7,25006012,25006809';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006809"),
                  "Make Code", "Variable Field 25006809") THEN BEGIN
                    VALIDATE("Variable Field 25006809", VFOptions.Code);
                END;
            end;
        }
        field(25006810; "Variable Field 25006810"; Code[20])
        {
            CaptionClass = '7,25006012,25006810';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006810"),
                  "Make Code", "Variable Field 25006810") THEN BEGIN
                    VALIDATE("Variable Field 25006810", VFOptions.Code);
                END;
            end;
        }
        field(25006811; "Variable Field 25006811"; Code[20])
        {
            CaptionClass = '7,25006012,25006811';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006811"),
                  "Make Code", "Variable Field 25006811") THEN BEGIN
                    VALIDATE("Variable Field 25006811", VFOptions.Code);
                END;
            end;
        }
        field(25006812; "Variable Field 25006812"; Code[20])
        {
            CaptionClass = '7,25006012,25006812';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006812"),
                  "Make Code", "Variable Field 25006812") THEN BEGIN
                    VALIDATE("Variable Field 25006812", VFOptions.Code);
                END;
            end;
        }
        field(25006813; "Variable Field 25006813"; Code[20])
        {
            CaptionClass = '7,25006012,25006813';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006813"),
                  "Make Code", "Variable Field 25006813") THEN BEGIN
                    VALIDATE("Variable Field 25006813", VFOptions.Code);
                END;
            end;
        }
        field(25006814; "Variable Field 25006814"; Code[20])
        {
            CaptionClass = '7,25006012,25006814';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006814"),
                  "Make Code", "Variable Field 25006814") THEN BEGIN
                    VALIDATE("Variable Field 25006814", VFOptions.Code);
                END;
            end;
        }
        field(25006815; "Variable Field 25006815"; Code[20])
        {
            CaptionClass = '7,25006012,25006815';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006815"),
                  "Make Code", "Variable Field 25006815") THEN BEGIN
                    VALIDATE("Variable Field 25006815", VFOptions.Code);
                END;
            end;
        }
        field(25006816; "Variable Field 25006816"; Code[20])
        {
            CaptionClass = '7,25006012,25006816';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006816"),
                  "Make Code", "Variable Field 25006816") THEN BEGIN
                    VALIDATE("Variable Field 25006816", VFOptions.Code);
                END;
            end;
        }
        field(25006817; "Variable Field 25006817"; Code[20])
        {
            CaptionClass = '7,25006012,25006817';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006817"),
                  "Make Code", "Variable Field 25006817") THEN BEGIN
                    VALIDATE("Variable Field 25006817", VFOptions.Code);
                END;
            end;
        }
        field(25006818; "Variable Field 25006818"; Code[20])
        {
            CaptionClass = '7,25006012,25006818';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006818"),
                  "Make Code", "Variable Field 25006818") THEN BEGIN
                    VALIDATE("Variable Field 25006818", VFOptions.Code);
                END;
            end;
        }
        field(25006819; "Variable Field 25006819"; Code[20])
        {
            CaptionClass = '7,25006012,25006819';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006819"),
                  "Make Code", "Variable Field 25006819") THEN BEGIN
                    VALIDATE("Variable Field 25006819", VFOptions.Code);
                END;
            end;
        }
        field(25006820; "Variable Field 25006820"; Code[20])
        {
            CaptionClass = '7,25006012,25006820';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Model Version Specification", FIELDNO("Variable Field 25006820"),
                  "Make Code", "Variable Field 25006820") THEN BEGIN
                    VALIDATE("Variable Field 25006820", VFOptions.Code);
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Make Code", "Model Code", "Model Version No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        cuLookupMgt: Codeunit 25006003;
        cuVFMgt: Codeunit 25006004;

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(cuVFMgt);
        EXIT(cuVFMgt.IsVFActive(DATABASE::"Model Version Specification", intFieldNo));
    end;
}


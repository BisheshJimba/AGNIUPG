table 25006135 "Service Package Version"
{
    // 26.03.2014 Elva Baltic P8 #S0010 MMG7.00
    //   * Added fields:
    //     'Variable Field 25006805'
    //     'Variable Field 25006806'
    //     'Variable Field 25006807'
    // 
    // 09.05.2008. EDMS P2
    //   * Added code Make Code - OnValidate

    Caption = 'Service Package Version';
    LookupPageID = 25006164;

    fields
    {
        field(4; "Package No."; Code[20])
        {
            Caption = 'Package No.';
            TableRelation = "Service Package".No.;

            trigger OnValidate()
            var
                ServicePackage: Record "25006134";
            begin
                ServicePackage.RESET;
                IF ServicePackage.GET("Package No.") THEN
                    "Make Code" := ServicePackage."Make Code";
            end;
        }
        field(6; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
        field(8; "Package Type"; Option)
        {
            Caption = 'Package Type';
            OptionCaption = 'Campaign Service Package,Service Package,Instruction';
            OptionMembers = "Campaign Service Package","Service Package",Instruction;
        }
        field(9; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            begin
                //09.05.2008. EDMS P2 >>
                IF "Make Code" <> xRec."Make Code" THEN
                    "Model Code" := '';
                //09.05.2008. EDMS P2<<
            end;
        }
        field(20; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(30;"Prod. Year From";Code[4])
        {
            Caption = 'Prod. Year From';
        }
        field(40;"Prod. Year To";Code[4])
        {
            Caption = 'Prod. Year To';
        }
        field(50;"VIN From";Code[20])
        {
            Caption = 'VIN From';
        }
        field(60;"VIN To";Code[20])
        {
            Caption = 'VIN To';
        }
        field(70;"Kilometrage To";Integer)
        {
            CaptionClass = '7,25006135,70';
            Caption = 'Kilometrage To';
            Description = 'Kilometrage To';
        }
        field(71;"Variable Field Run 2";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006135,71';
        }
        field(72;"Variable Field Run 3";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006135,72';
        }
        field(80;"Manufact. Compens. for Job %";Decimal)
        {
            Caption = 'Manufact. Compens. for Job %';
        }
        field(90;"Manufact. Compens. for Item %";Decimal)
        {
            Caption = 'Manufact. Compens. for Item %';
        }
        field(140;"Symptom Code";Code[20])
        {
            Caption = 'Symptom Code';
            TableRelation = "Service Symptom EDMS".Code WHERE (Make Code=FIELD(Make Code),
                                                               Code=FIELD(Symptom Code));
        }
        field(150;"Cause Code";Code[20])
        {
            Caption = 'Cause Code';
            TableRelation = "Vehicle Service Plan Stage"."Plan No." WHERE (Plan No.=FIELD(Cause Code));
        }
        field(210;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(253;Amount;Decimal)
        {
            CalcFormula = Sum("Service Package Version Line"."Line Amount" WHERE (Version No.=FIELD(Version No.),
                                                                                  Package No.=FIELD(Package No.)));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(300;"Package Description";Text[50])
        {
            CalcFormula = Lookup("Service Package".Description WHERE (No.=FIELD(Package No.)));
            Caption = 'Package Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006800;"Variable Field 25006800";Code[20])
        {
            CaptionClass = '7,25006135,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions,DATABASE::"Service Package Version",FIELDNO("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006800",VFOptions.Code);
                 END;
            end;
        }
        field(25006801;"Variable Field 25006801";Code[20])
        {
            CaptionClass = '7,25006135,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions,DATABASE::"Service Package Version",FIELDNO("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006801",VFOptions.Code);
                 END;
            end;
        }
        field(25006802;"Variable Field 25006802";Code[20])
        {
            CaptionClass = '7,25006135,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions,DATABASE::"Service Package Version",FIELDNO("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006802",VFOptions.Code);
                 END;
            end;
        }
        field(25006803;"Variable Field 25006803";Code[20])
        {
            CaptionClass = '7,25006135,25006803';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions,DATABASE::"Service Package Version",FIELDNO("Variable Field 25006803"),
                  "Make Code", "Variable Field 25006803") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006803",VFOptions.Code);
                 END;
            end;
        }
        field(25006804;"Variable Field 25006804";Code[20])
        {
            CaptionClass = '7,25006135,25006804';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions,DATABASE::"Service Package Version",FIELDNO("Variable Field 25006804"),
                  "Make Code", "Variable Field 25006804") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006804",VFOptions.Code);
                 END;
            end;
        }
        field(25006805;"Variable Field 25006805";Code[20])
        {
            CaptionClass = '7,25006135,25006805';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions,DATABASE::"Service Package Version",FIELDNO("Variable Field 25006805"),
                  "Make Code", "Variable Field 25006805") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006805",VFOptions.Code);
                 END;
            end;
        }
        field(25006806;"Variable Field 25006806";Code[20])
        {
            CaptionClass = '7,25006135,25006806';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions,DATABASE::"Service Package Version",FIELDNO("Variable Field 25006806"),
                  "Make Code", "Variable Field 25006806") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006806",VFOptions.Code);
                 END;
            end;
        }
        field(25006807;"Variable Field 25006807";Code[20])
        {
            CaptionClass = '7,25006135,25006807';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions,DATABASE::"Service Package Version",FIELDNO("Variable Field 25006807"),
                  "Make Code", "Variable Field 25006807") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006807",VFOptions.Code);
                 END;
            end;
        }
    }

    keys
    {
        key(Key1;"Package No.","Version No.")
        {
            Clustered = true;
        }
        key(Key2;"Package Type","Make Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        SPVersionSpecification.RESET;
        SPVersionSpecification.SETRANGE("Package No.", "Package No.");
        SPVersionSpecification.SETRANGE("Version No.", "Version No.");
        SPVersionSpecification.DELETEALL(TRUE);
    end;

    var
        cuVFMgt: Codeunit "25006004";
        cuLookupMgt: Codeunit "25006003";
        SPVersionSpecification: Record "25006136";

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(cuVFMgt);
        EXIT(cuVFMgt.IsVFActive(DATABASE::"Service Package Version",intFieldNo));
    end;
}


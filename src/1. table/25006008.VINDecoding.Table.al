table 25006008 "VIN Decoding"
{
    // 30.03.2007. EDMS P2
    //   *Added new code on function fGetRightField for right working if not put "Make code" in table "Variable Field Usage"
    // 
    // 25.01.2007. EDMS P2
    //   added new fields
    // 
    // 24.01.2007. EDMS P2
    //   added new fields
    //   added new functions
    // 
    // 23.01.2007. EDMS P2
    //  deleted old fields and added new fields
    //  added new function FDecode which takes VIN of vehicle and fill needed fields

    Caption = 'VIN Decoding';
    DrillDownPageID = "Resource Skills EDMS";
    LookupPageID = "Resource Skills EDMS";

    fields
    {
        field(3; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(5; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; Position; Code[10])
        {
            Caption = 'Position';
            NotBlank = true;
        }
        field(20; Combination; Code[10])
        {
            Caption = 'Combination';
        }
        field(30; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code;
        }
        field(35; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No.";
        }
        field(45; "Parent Entry No."; Integer)
        {
            Caption = 'Parent Entry No.';
        }
        field(55; "Primary Entry"; Boolean)
        {
            Caption = 'Primary Entry';
        }
        field(65; "Combination Value Field"; Code[10])
        {
            Caption = 'Combination Value Field';
            TableRelation = "Variable Field";
        }
        field(75; "Forbidden Symbols Field"; Text[250])
        {
            Caption = 'Forbidden Symbols Field';
        }
        field(85; "VIN Lenght"; Integer)
        {
            Caption = 'VIN Lenght';
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006008,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"VIN Decoding", FIELDNO("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") THEN BEGIN
                    VALIDATE("Variable Field 25006800", VFOptions.Code);
                END;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006008,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"VIN Decoding", FIELDNO("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") THEN BEGIN
                    VALIDATE("Variable Field 25006801", VFOptions.Code);
                END;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006008,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"VIN Decoding", FIELDNO("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") THEN BEGIN
                    VALIDATE("Variable Field 25006802", VFOptions.Code);
                END;
            end;
        }
        field(25006803; "Variable Field 25006803"; Code[20])
        {
            CaptionClass = '7,25006008,25006803';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"VIN Decoding", FIELDNO("Variable Field 25006803"),
                  "Make Code", "Variable Field 25006803") THEN BEGIN
                    VALIDATE("Variable Field 25006803", VFOptions.Code);
                END;
            end;
        }
        field(25006804; "Variable Field 25006804"; Code[20])
        {
            CaptionClass = '7,25006008,25006804';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"VIN Decoding", FIELDNO("Variable Field 25006804"),
                  "Make Code", "Variable Field 25006804") THEN BEGIN
                    VALIDATE("Variable Field 25006804", VFOptions.Code);
                END;
            end;
        }
        field(25006805; "Variable Field 25006805"; Code[20])
        {
            CaptionClass = '7,25006008,25006805';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"VIN Decoding", FIELDNO("Variable Field 25006805"),
                  "Make Code", "Variable Field 25006805") THEN BEGIN
                    VALIDATE("Variable Field 25006805", VFOptions.Code);
                END;
            end;
        }
        field(25006806; "Variable Field 25006806"; Code[20])
        {
            CaptionClass = '7,25006008,25006806';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"VIN Decoding", FIELDNO("Variable Field 25006806"),
                  "Make Code", "Variable Field 25006806") THEN BEGIN
                    VALIDATE("Variable Field 25006806", VFOptions.Code);
                END;
            end;
        }
        field(25006807; "Variable Field 25006807"; Code[20])
        {
            CaptionClass = '7,25006008,25006807';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"VIN Decoding", FIELDNO("Variable Field 25006807"),
                  "Make Code", "Variable Field 25006807") THEN BEGIN
                    VALIDATE("Variable Field 25006807", VFOptions.Code);
                END;
            end;
        }
        field(25006808; "Variable Field 25006808"; Code[20])
        {
            CaptionClass = '7,25006008,25006808';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"VIN Decoding", FIELDNO("Variable Field 25006808"),
                  "Make Code", "Variable Field 25006808") THEN BEGIN
                    VALIDATE("Variable Field 25006808", VFOptions.Code);
                END;
            end;
        }
        field(25006809; "Variable Field 25006809"; Code[20])
        {
            CaptionClass = '7,25006008,25006809';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"VIN Decoding", FIELDNO("Variable Field 25006809"),
                  "Make Code", "Variable Field 25006809") THEN BEGIN
                    VALIDATE("Variable Field 25006809", VFOptions.Code);
                END;
            end;
        }
        field(25006810; "Variable Field 25006810"; Code[20])
        {
            CaptionClass = '7,25006008,25006810';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"VIN Decoding", FIELDNO("Variable Field 25006810"),
                  "Make Code", "Variable Field 25006810") THEN BEGIN
                    VALIDATE("Variable Field 25006810", VFOptions.Code);
                END;
            end;
        }
        field(25006811; "Variable Field 25006811"; Code[20])
        {
            CaptionClass = '7,25006008,25006811';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"VIN Decoding", FIELDNO("Variable Field 25006811"),
                  "Make Code", "Variable Field 25006811") THEN BEGIN
                    VALIDATE("Variable Field 25006811", VFOptions.Code);
                END;
            end;
        }
        field(25006812; "Variable Field 25006812"; Code[20])
        {
            CaptionClass = '7,25006008,25006812';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"VIN Decoding", FIELDNO("Variable Field 25006812"),
                  "Make Code", "Variable Field 25006812") THEN BEGIN
                    VALIDATE("Variable Field 25006812", VFOptions.Code);
                END;
            end;
        }
        field(25006813; "Variable Field 25006813"; Code[20])
        {
            CaptionClass = '7,25006008,25006813';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"VIN Decoding", FIELDNO("Variable Field 25006813"),
                  "Make Code", "Variable Field 25006813") THEN BEGIN
                    VALIDATE("Variable Field 25006813", VFOptions.Code);
                END;
            end;
        }
        field(25006814; "Variable Field 25006814"; Code[20])
        {
            CaptionClass = '7,25006008,25006814';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"VIN Decoding", FIELDNO("Variable Field 25006814"),
                  "Make Code", "Variable Field 25006814") THEN BEGIN
                    VALIDATE("Variable Field 25006814", VFOptions.Code);
                END;
            end;
        }
        field(25006815; "Variable Field 25006815"; Code[20])
        {
            CaptionClass = '7,25006008,25006815';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"VIN Decoding", FIELDNO("Variable Field 25006815"),
                  "Make Code", "Variable Field 25006815") THEN BEGIN
                    VALIDATE("Variable Field 25006815", VFOptions.Code);
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Make Code", "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        VFMgt: Codeunit 25006004;
        LookupMgt: Codeunit 25006003;
        VINDecoding: Record "VIN Decoding";
        MakeCode: Code[20];
        VINWithoutMAT: Code[20];

    [Scope('Internal')]
    procedure Decode2(var recVehicle: Record Vehicle)
    var
        intParent: Integer;
    begin
        intParent := FindMakeCode(recVehicle);
        CheckVINLenght(recVehicle, intParent);
        IF intParent <> -1 THEN
            FindChilds(recVehicle, intParent);
    end;

    [Scope('Internal')]
    procedure CheckVINLenght(recVehicle: Record Vehicle; intEntryNo: Integer)
    var
        intVINLenght: Integer;
        txtDMS100: Label 'Quantity of VIN symbols must be %1.';
        i: Integer;
        i2: Integer;
        i3: Integer;
        codForbiddenSymbol: Code[17];
        intForbiddenSymbol: Integer;
        txtDMS101: Label 'VIN must not consist from %1.';
        recVINDecoding: Record "VIN Decoding";
        test: Text[30];
    begin
        intVINLenght := STRLEN(recVehicle.VIN);
        recVINDecoding.RESET;
        IF recVINDecoding.GET(MakeCode, intEntryNo) THEN;
        IF (intVINLenght <> recVINDecoding."VIN Lenght") AND (recVINDecoding."VIN Lenght" <> 0) THEN
            ERROR(STRSUBSTNO(txtDMS100, recVINDecoding."VIN Lenght"));


        IF recVINDecoding."Forbidden Symbols Field" <> '' THEN BEGIN

            FOR i := 1 TO intVINLenght DO
                IF COPYSTR(recVehicle.VIN, i, 1) = ',' THEN
                    ERROR(STRSUBSTNO(txtDMS101, ','));

            FOR i := 1 TO STRLEN(recVINDecoding."Forbidden Symbols Field") + 1 DO BEGIN
                IF (COPYSTR(recVINDecoding."Forbidden Symbols Field", i, 1) = ',') OR
                 (i = STRLEN(recVINDecoding."Forbidden Symbols Field") + 1) THEN BEGIN
                    intForbiddenSymbol := STRLEN(codForbiddenSymbol);
                    FOR i2 := 1 TO intVINLenght - intForbiddenSymbol + 1 DO BEGIN
                        IF COPYSTR(recVehicle.VIN, i2, intForbiddenSymbol) = codForbiddenSymbol THEN
                            ERROR(STRSUBSTNO(txtDMS101, codForbiddenSymbol));
                    END;
                    codForbiddenSymbol := '';
                END
                ELSE
                    codForbiddenSymbol := codForbiddenSymbol + COPYSTR(recVINDecoding."Forbidden Symbols Field", i, 1);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure FindMakeCode(var recVehicle: Record Vehicle): Integer
    var
        recVINDecoding: Record "VIN Decoding";
        intReturnValue: Integer;
    begin
        recVINDecoding.RESET;
        recVINDecoding.SETRANGE("Primary Entry", TRUE);
        IF recVINDecoding.FINDSET THEN
            REPEAT
                IF CheckValues(recVehicle, recVINDecoding) THEN BEGIN
                    MakeCode := recVINDecoding."Make Code";
                    recVehicle."Make Code" := recVINDecoding."Make Code";
                    intReturnValue := recVINDecoding."Entry No.";
                    EXIT(intReturnValue);
                END;
            UNTIL recVINDecoding.NEXT = 0;
        EXIT(-1);
    end;

    [Scope('Internal')]
    procedure FindChilds(var recVehicle: Record Vehicle; intParent: Integer)
    var
        recVINDecoding: Record "VIN Decoding";
        codVINValue: Code[17];
    begin
        recVINDecoding.RESET;
        recVINDecoding.SETRANGE("Primary Entry", FALSE);
        recVINDecoding.SETRANGE("Make Code", MakeCode);
        recVINDecoding.SETRANGE("Parent Entry No.", intParent);
        IF recVINDecoding.FINDSET THEN
            REPEAT
                IF recVINDecoding."Combination Value Field" <> '' THEN BEGIN
                    codVINValue := CheckValues2(recVehicle, recVINDecoding);
                    GetRightField2(recVehicle, recVINDecoding."Combination Value Field", codVINValue);
                END
                ELSE
                    IF CheckValues(recVehicle, recVINDecoding) THEN BEGIN
                        IF (recVINDecoding."Model Code" <> '') THEN
                            recVehicle."Model Code" := recVINDecoding."Model Code";
                        IF (recVINDecoding."Model Version No." <> '') THEN
                            recVehicle."Model Version No." := recVINDecoding."Model Version No.";

                        IF (recVINDecoding."Variable Field 25006800" <> '') THEN
                            GetRightField(recVehicle, recVINDecoding.FIELDNO("Variable Field 25006800"),
                             recVINDecoding."Variable Field 25006800");
                        IF (recVINDecoding."Variable Field 25006801" <> '') THEN
                            GetRightField(recVehicle, recVINDecoding.FIELDNO("Variable Field 25006801"),
                             recVINDecoding."Variable Field 25006801");
                        IF (recVINDecoding."Variable Field 25006802" <> '') THEN
                            GetRightField(recVehicle, recVINDecoding.FIELDNO("Variable Field 25006802"),
                             recVINDecoding."Variable Field 25006802");
                        IF (recVINDecoding."Variable Field 25006803" <> '') THEN
                            GetRightField(recVehicle, recVINDecoding.FIELDNO("Variable Field 25006803"),
                             recVINDecoding."Variable Field 25006803");
                        IF (recVINDecoding."Variable Field 25006804" <> '') THEN
                            GetRightField(recVehicle, recVINDecoding.FIELDNO("Variable Field 25006804"),
                             recVINDecoding."Variable Field 25006804");
                        IF (recVINDecoding."Variable Field 25006805" <> '') THEN
                            GetRightField(recVehicle, recVINDecoding.FIELDNO("Variable Field 25006805"),
                             recVINDecoding."Variable Field 25006805");
                        IF (recVINDecoding."Variable Field 25006806" <> '') THEN
                            GetRightField(recVehicle, recVINDecoding.FIELDNO("Variable Field 25006806"),
                             recVINDecoding."Variable Field 25006806");
                        IF (recVINDecoding."Variable Field 25006807" <> '') THEN
                            GetRightField(recVehicle, recVINDecoding.FIELDNO("Variable Field 25006807"),
                             recVINDecoding."Variable Field 25006807");
                        IF (recVINDecoding."Variable Field 25006808" <> '') THEN
                            GetRightField(recVehicle, recVINDecoding.FIELDNO("Variable Field 25006808"),
                             recVINDecoding."Variable Field 25006808");
                        IF (recVINDecoding."Variable Field 25006809" <> '') THEN
                            GetRightField(recVehicle, recVINDecoding.FIELDNO("Variable Field 25006809"),
                             recVINDecoding."Variable Field 25006809");
                        IF (recVINDecoding."Variable Field 25006810" <> '') THEN
                            GetRightField(recVehicle, recVINDecoding.FIELDNO("Variable Field 25006810"),
                             recVINDecoding."Variable Field 25006810");
                        IF (recVINDecoding."Variable Field 25006811" <> '') THEN
                            GetRightField(recVehicle, recVINDecoding.FIELDNO("Variable Field 25006811"),
                             recVINDecoding."Variable Field 25006811");
                        IF (recVINDecoding."Variable Field 25006812" <> '') THEN
                            GetRightField(recVehicle, recVINDecoding.FIELDNO("Variable Field 25006812"),
                             recVINDecoding."Variable Field 25006812");
                        IF (recVINDecoding."Variable Field 25006813" <> '') THEN
                            GetRightField(recVehicle, recVINDecoding.FIELDNO("Variable Field 25006813"),
                             recVINDecoding."Variable Field 25006813");
                        IF (recVINDecoding."Variable Field 25006814" <> '') THEN
                            GetRightField(recVehicle, recVINDecoding.FIELDNO("Variable Field 25006814"),
                             recVINDecoding."Variable Field 25006814");
                        IF (recVINDecoding."Variable Field 25006815" <> '') THEN
                            GetRightField(recVehicle, recVINDecoding.FIELDNO("Variable Field 25006815"),
                             recVINDecoding."Variable Field 25006815");

                        FindChilds(recVehicle, recVINDecoding."Entry No.");
                    END;
            UNTIL recVINDecoding.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.IsVFActive(DATABASE::"VIN Decoding", intFieldNo));
    end;

    [Scope('Internal')]
    procedure GetRightField(var recVehicle: Record Vehicle; intFieldNo: Integer; codValue: Code[20])
    var
        refRecordRef2: RecordRef;
        refFieldRef: FieldRef;
        recVFUsage: Record "Variable Field Usage";
        recVFUsage1: Record "Variable Field Usage";
    begin
        //MK DMS 24.01.2007. -->
        refRecordRef2.OPEN(DATABASE::Vehicle);
        refRecordRef2.GETTABLE(recVehicle);
        recVFUsage.RESET;
        recVFUsage.SETRANGE("Table No.", DATABASE::"VIN Decoding");
        recVFUsage.SETRANGE("Field No.", intFieldNo);

        IF recVFUsage.FINDFIRST THEN
            REPEAT
                recVFUsage1.RESET;
                recVFUsage1.SETCURRENTKEY("Variable Field Code");
                recVFUsage1.SETRANGE("Table No.", DATABASE::Vehicle);
                recVFUsage1.SETRANGE("Variable Field Code", recVFUsage."Variable Field Code");
                IF recVFUsage1.FINDFIRST THEN BEGIN
                    refFieldRef := refRecordRef2.FIELD(recVFUsage1."Field No.");
                    refFieldRef.VALUE(codValue);
                END;
            UNTIL recVFUsage.NEXT = 0;
        refRecordRef2.SETTABLE(recVehicle);
    end;

    [Scope('Internal')]
    procedure GetRightField2(var recVehicle: Record Vehicle; codVariableField: Code[10]; codVINValue: Code[17])
    var
        refRecordRef2: RecordRef;
        refFieldRef: FieldRef;
        recVFUsage1: Record "Variable Field Usage";
    begin
        refRecordRef2.OPEN(DATABASE::Vehicle);
        refRecordRef2.GETTABLE(recVehicle);

        recVFUsage1.RESET;
        recVFUsage1.SETCURRENTKEY("Variable Field Code");
        recVFUsage1.SETRANGE("Table No.", DATABASE::Vehicle);
        recVFUsage1.SETRANGE("Variable Field Code", codVariableField);

        IF recVFUsage1.FINDFIRST THEN BEGIN
            refFieldRef := refRecordRef2.FIELD(recVFUsage1."Field No.");
            refFieldRef.VALUE(codVINValue);
        END;
        refRecordRef2.SETTABLE(recVehicle);
    end;

    [Scope('Internal')]
    procedure CheckValues(recVehicle: Record Vehicle; recVINDecoding: Record "VIN Decoding"): Boolean
    var
        intLenght: Integer;
        i: Integer;
        intValue: Integer;
        codPosition: Code[2];
        codVehiclePosVal: Code[17];
    begin
        codVehiclePosVal := '';
        CLEAR(codPosition);
        intLenght := STRLEN(recVINDecoding.Position);
        FOR i := 1 TO intLenght DO BEGIN
            codPosition := COPYSTR(recVINDecoding.Position, i, 1);
            IF codPosition = 'A' THEN codPosition := '10';
            IF codPosition = 'B' THEN codPosition := '11';
            IF codPosition = 'C' THEN codPosition := '12';
            IF codPosition = 'D' THEN codPosition := '13';
            IF codPosition = 'E' THEN codPosition := '14';
            IF codPosition = 'F' THEN codPosition := '15';
            IF codPosition = 'G' THEN codPosition := '16';
            IF codPosition = 'H' THEN codPosition := '17';
            EVALUATE(intValue, codPosition);
            IF CheckVINWithMAT(recVehicle.VIN) THEN
                codVehiclePosVal := codVehiclePosVal + COPYSTR(VINWithoutMAT, intValue, 1)
            ELSE
                codVehiclePosVal := codVehiclePosVal + COPYSTR(recVehicle.VIN, intValue, 1);
        END;
        IF codVehiclePosVal = recVINDecoding.Combination THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    [Scope('Internal')]
    procedure CheckValues2(recVehicle: Record Vehicle; recVINDecoding: Record "VIN Decoding"): Code[17]
    var
        intLenght: Integer;
        i: Integer;
        codVehiclePosVal: Code[17];
        intValue: Integer;
        codPosition: Code[2];
    begin
        codVehiclePosVal := '';
        CLEAR(codPosition);
        intLenght := STRLEN(recVINDecoding.Position);
        FOR i := 1 TO intLenght DO BEGIN
            codPosition := COPYSTR(recVINDecoding.Position, i, 1);
            IF codPosition = 'A' THEN codPosition := '10';
            IF codPosition = 'B' THEN codPosition := '11';
            IF codPosition = 'C' THEN codPosition := '12';
            IF codPosition = 'D' THEN codPosition := '13';
            IF codPosition = 'E' THEN codPosition := '14';
            IF codPosition = 'F' THEN codPosition := '15';
            IF codPosition = 'G' THEN codPosition := '16';
            IF codPosition = 'H' THEN codPosition := '17';
            EVALUATE(intValue, codPosition);
            IF CheckVINWithMAT(recVehicle.VIN) THEN
                codVehiclePosVal := codVehiclePosVal + COPYSTR(VINWithoutMAT, intValue, 1)
            ELSE
                codVehiclePosVal := codVehiclePosVal + COPYSTR(recVehicle.VIN, intValue, 1);
        END;
        EXIT(codVehiclePosVal);
    end;

    [Scope('Internal')]
    procedure CheckVINWithMAT(VIN: Code[20]): Boolean
    var
        MATPosition: Integer;
    begin
        VINWithoutMAT := '';
        MATPosition := STRPOS(VIN, 'MAT');
        IF MATPosition > 0 THEN BEGIN
            VINWithoutMAT := DELSTR(VIN, MATPosition, 3);
            EXIT(TRUE);
        END;
        EXIT(FALSE);
    end;
}


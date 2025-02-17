table 33020517 "Payroll Variable Field Usage"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*

    Caption = 'Variable Field Usage';

    fields
    {
        field(10; "Table No."; Integer)
        {
            Caption = 'Table No.';
            TableRelation = Object.ID WHERE(Type = CONST(Table));

            trigger OnLookup()
            begin
                LookUpVariableUsageObject("Table No.");
                VALIDATE("Table No.");
            end;
        }
        field(20; "Field No."; Integer)
        {
            Caption = 'Field No.';
            TableRelation = Field.No. WHERE(TableNo = FIELD(Table No.));

            trigger OnLookup()
            begin
                LookUpVariableUsageField("Field No.", "Table No.");
                VALIDATE("Field No.");
            end;
        }
        field(30; "Variable Field Code"; Code[100])
        {
            Caption = 'Variable Field Code';
            NotBlank = true;
            TableRelation = "Payroll Component";

            trigger OnValidate()
            var
                PayrollVF: Record "33020517";
            begin
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
        key(Key3; "Table No.", "Variable Field Code")
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

    [Scope('Internal')]
    procedure LookUpVariableUsageObject(var ObjectID: Integer)
    var
        TempObject: Record "2000000001" temporary;
        TempField: Record "2000000041" temporary;
        WhatToFind: Option "Object","Field";
    begin
        TempObject.RESET;
        TempObject.DELETEALL;

        WhatToFind := WhatToFind::Object;
        VariableFieldObjectNoList(TempObject, TempField, WhatToFind);

        IF PAGE.RUNMODAL(PAGE::Objects, TempObject) = ACTION::LookupOK THEN
            ObjectID := TempObject.ID;
    end;

    [Scope('Internal')]
    procedure VariableFieldObjectNoList(var TempObject: Record "2000000001" temporary; var TempField: Record "2000000041" temporary; WhatToFind: Option "Object","Field")
    var
        "Object": Record "2000000001";
        "Field": Record "2000000041";
        NumberOfObjects: Integer;
        NumberOfFields: Integer;
        TableIDArray: array[27] of Integer;
        FieldIDArray: array[27, 33] of Integer;
        Index: Integer;
        TableIndex: Integer;
    begin
        NumberOfObjects := 2;
        NumberOfFields := 20;
        CLEAR(TableIDArray);

        TableIDArray[1] := DATABASE::"Salary Line";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 1, 20, 33020500, 1);

        TableIDArray[2] := DATABASE::"Posted Salary Line";
        IF WhatToFind = WhatToFind::Field THEN
            FillFieldIDArray(FieldIDArray, 2, 20, 33020500, 1);

        IF WhatToFind = WhatToFind::Object THEN BEGIN
            Object.SETRANGE(Type, Object.Type::Table);
            FOR Index := 1 TO NumberOfObjects DO BEGIN
                Object.SETRANGE(Object.ID, TableIDArray[Index]);
                IF Object.FINDFIRST THEN BEGIN
                    TempObject := Object;
                    TempObject.INSERT;
                END;
            END;
        END ELSE BEGIN
            TableIndex := 0;
            FOR Index := 1 TO NumberOfObjects DO
                IF TableIDArray[Index] = TempObject.ID THEN
                    TableIndex := Index;
            IF TableIndex = 0 THEN
                EXIT;
            Field.SETRANGE(TableNo, TempObject.ID);
            FOR Index := 1 TO NumberOfFields DO BEGIN
                IF (FieldIDArray[TableIndex] [Index] <> 0) THEN BEGIN
                    Field.SETRANGE("No.", FieldIDArray[TableIndex] [Index]);
                    IF Field.FINDFIRST THEN BEGIN
                        TempField := Field;
                        TempField.INSERT;
                    END;
                END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure FillFieldIDArray(var FieldIDArray: array[2, 20] of Integer; TableID: Integer; FieldQty: Integer; StartNumber: Integer; FieldStep: Integer)
    var
        i: Integer;
    begin
        FOR i := 1 TO FieldQty DO
            FieldIDArray[TableID] [i] := StartNumber + (i - 1) * FieldStep;
    end;

    [Scope('Internal')]
    procedure LookUpVariableUsageField(var FieldID: Integer; TableID: Integer)
    var
        TempObject: Record "2000000001" temporary;
        TempField: Record "2000000041" temporary;
        "Object": Record "2000000001";
        WhatToFind: Option "Object","Field";
    begin
        TempField.RESET;
        TempField.DELETEALL;

        Object.SETRANGE(Type, Object.Type::Table);
        Object.SETRANGE(ID, TableID);
        IF Object.FINDFIRST THEN
            TempObject := Object;

        WhatToFind := WhatToFind::Field;
        VariableFieldObjectNoList(TempObject, TempField, WhatToFind);

        IF PAGE.RUNMODAL(PAGE::"Fields Payroll", TempField) = ACTION::LookupOK THEN
            FieldID := TempField."No.";
    end;
}


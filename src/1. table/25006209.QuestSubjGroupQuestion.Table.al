table 25006209 "Quest. Subj. Group Question"
{
    Caption = 'Quest. Subj. Group Question';

    fields
    {
        field(10; "Questionary Subject Group Code"; Code[20])
        {
            Caption = 'Questionary Subject Group Code';
            NotBlank = true;
            TableRelation = "Questionary Subject Group".Code;
        }
        field(20; "No."; Integer)
        {
            Caption = 'No.';
            MinValue = 1;
        }
        field(100; "Question Text"; Text[250])
        {
            Caption = 'Question Text';
        }
        field(110; "Answer Type"; Option)
        {
            Caption = 'Answer Type';
            OptionCaption = ' ,Option,Dictionary,Boolean,Integer,Decimal,Percent,Date';
            OptionMembers = " ",Option,Dictionary,Boolean,"Integer",Decimal,Percent,Date;

            trigger OnValidate()
            begin
                IF xRec."Answer Type" = "Answer Type" THEN
                    EXIT;

                VALIDATE("MIN Constrain", '');
                VALIDATE("MAX Constrain", '');
                VALIDATE("Default Value", '');

                IF ("Answer Type" = "Answer Type"::Boolean) OR
                   NOT ("Answer Type" IN ["Answer Type"::Option, "Answer Type"::Dictionary])
                THEN BEGIN
                    QAnswer.RESET;
                    QAnswer.SETRANGE("Questionary Subject Group Code", "Questionary Subject Group Code");
                    QAnswer.SETRANGE("Question No.", "No.");
                    QAnswer.DELETEALL;
                END;

                IF ("Answer Type" = "Answer Type"::Boolean) THEN BEGIN
                    QAnswer.RESET;
                    QAnswer.INIT;
                    QAnswer."Questionary Subject Group Code" := "Questionary Subject Group Code";
                    QAnswer."Question No." := "No.";
                    QAnswer."Answer Text" := 'YES';
                    QAnswer."Sorting No." := 1;
                    QAnswer.INSERT;
                    QAnswer."Answer Text" := 'NO';
                    QAnswer."Sorting No." := 2;
                    QAnswer.INSERT;
                END;
            end;
        }
        field(200; "MIN Constrain"; Text[50])
        {
            Caption = 'MIN Constrain';

            trigger OnValidate()
            begin
                IF "MIN Constrain" = '' THEN BEGIN
                    "Min Date" := 0D;
                    "Min Dec" := 0;
                    "Min Int" := 0;
                    EXIT;
                END;

                IF NOT IsTypeAllowedToConstrain THEN
                    ERROR(TypeIsNotAllowedToConstrainErr, "Answer Type");

                "MIN Constrain" := SetValue("MIN Constrain", 1);
            end;
        }
        field(210; "MAX Constrain"; Text[50])
        {
            Caption = 'MAX Constrain';

            trigger OnValidate()
            begin
                IF "MAX Constrain" = '' THEN BEGIN
                    "Max Date" := 0D;
                    "Max Dec" := 0;
                    "Max Int" := 0;
                    EXIT;
                END;

                IF NOT IsTypeAllowedToConstrain THEN
                    ERROR(TypeIsNotAllowedToConstrainErr, "Answer Type");

                "MAX Constrain" := SetValue("MAX Constrain", 2);
            end;
        }
        field(300; "Default Value"; Text[50])
        {

            trigger OnLookup()
            begin
                IF LookupAnswer("Questionary Subject Group Code", "No.", "Default Value") THEN
                    VALIDATE("Default Value");
            end;

            trigger OnValidate()
            begin
                IF "Default Value" = '' THEN BEGIN
                    "Value Date" := 0D;
                    "Value Dec" := 0;
                    "Value Int" := 0;
                    "Value Bool" := FALSE;
                    EXIT;
                END;

                "Default Value" := SetValue("Default Value", 0);
            end;
        }
        field(1000; "Value Int"; Integer)
        {
        }
        field(1010; "Min Int"; Integer)
        {
        }
        field(1020; "Max Int"; Integer)
        {
        }
        field(1100; "Value Dec"; Decimal)
        {
        }
        field(1110; "Min Dec"; Decimal)
        {
        }
        field(1120; "Max Dec"; Decimal)
        {
        }
        field(1200; "Value Date"; Date)
        {
        }
        field(1210; "Min Date"; Date)
        {
        }
        field(1220; "Max Date"; Date)
        {
        }
        field(1330; "Value Bool"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Questionary Subject Group Code", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = 0 THEN
            "No." := GetNo("Questionary Subject Group Code");
    end;

    var
        TypeIsNotAllowedToConstrainErr: Label '%1 is not allowed to constrain';
        ValueIsNotDateErr: Label '%1 is not date';
        ValueIsNotDecimalErr: Label '%1 is not decimal';
        ValueIsNotIntegerErr: Label '%1 is not integer';
        ValueIsNotPercentErr: Label '%1 is not percent';
        ValueIsNotBoolErr: Label '%1 is not boolean';
        IncorrectMinMaxErr: Label 'Incorrect min (%1) and max (%2) values';
        DefaultValueOutOfRangeErr: Label 'Default value (%1) is out of range';
        QAnswer: Record "25006210";

    local procedure GetNo(GroupCode: Code[20]): Integer
    var
        Rec2: Record "25006209";
    begin
        IF GroupCode = '' THEN
            EXIT(0);

        Rec2.RESET;
        Rec2.SETRANGE("Questionary Subject Group Code", GroupCode);
        IF Rec2.FINDLAST THEN
            EXIT(Rec2."No." + 1);

        EXIT(1);
    end;

    [Scope('Internal')]
    procedure IsTypeAllowedToConstrain(): Boolean
    begin
        EXIT("Answer Type" IN ["Answer Type"::Date, "Answer Type"::Decimal,
                               "Answer Type"::Integer, "Answer Type"::Percent]);
    end;

    [Scope('Internal')]
    procedure IsDateConst(InText: Text): Boolean
    begin
        EXIT(UPPERCASE(InText) IN ['TODAY']);
    end;

    local procedure SetValue(NewValue: Text; ValueType: Option Default,"Min","Max"): Text
    var
        DateX: Date;
        IntX: Integer;
        DecX: Decimal;
        ValueX: Variant;
    begin
        ConvertValue("Answer Type", NewValue, FALSE, ValueX);

        CASE "Answer Type" OF
            "Answer Type"::Date:
                BEGIN
                    DateX := ValueX;
                    CASE ValueType OF
                        ValueType::Default:
                            VALIDATE("Value Date", DateX);
                        ValueType::Min:
                            VALIDATE("Min Date", DateX);
                        ValueType::Max:
                            VALIDATE("Max Date", DateX);
                    END;
                    CheckDate;
                END;
            "Answer Type"::Decimal:
                BEGIN
                    DecX := ValueX;
                    CASE ValueType OF
                        ValueType::Default:
                            VALIDATE("Value Dec", DecX);
                        ValueType::Min:
                            VALIDATE("Min Dec", DecX);
                        ValueType::Max:
                            VALIDATE("Max Dec", DecX);
                    END;
                    CheckDec;
                END;
            "Answer Type"::Integer,
            "Answer Type"::Percent:
                BEGIN
                    IntX := ValueX;
                    CASE ValueType OF
                        ValueType::Default:
                            VALIDATE("Value Int", IntX);
                        ValueType::Min:
                            VALIDATE("Min Int", IntX);
                        ValueType::Max:
                            VALIDATE("Max Int", IntX);
                    END;
                    CheckInt;
                END;
            "Answer Type"::Option:
                BEGIN
                    IF NewValue <> '' THEN BEGIN
                        QAnswer.GET("Questionary Subject Group Code", "No.", NewValue);
                    END;
                END;
            "Answer Type"::Boolean:
                BEGIN
                    IF ValueType = ValueType::Default THEN
                        "Value Bool" := ValueX;
                END;
        END;
        EXIT(NewValue);
    end;

    local procedure CheckInt()
    begin
        IF ("MIN Constrain" <> '') AND ("MAX Constrain" <> '') THEN
            IF "Min Int" > "Max Int" THEN
                ERROR(IncorrectMinMaxErr, "Min Int", "Max Int");

        IF "Default Value" <> '' THEN BEGIN
            IF ("MIN Constrain" <> '') AND ("Value Int" < "Min Int") OR
               ("MAX Constrain" <> '') AND ("Value Int" > "Max Int")
            THEN
                MESSAGE(DefaultValueOutOfRangeErr, "Value Int");
        END;
    end;

    local procedure CheckDate()
    begin
        IF ("MIN Constrain" <> '') AND NOT IsDateConst("MIN Constrain") AND
           ("MAX Constrain" <> '') AND NOT IsDateConst("MAX Constrain")
        THEN
            IF "Min Date" > "Max Date" THEN
                ERROR(IncorrectMinMaxErr, "Min Date", "Max Date");

        IF ("Default Value" <> '') AND NOT IsDateConst("Default Value") THEN BEGIN
            IF ("MIN Constrain" <> '') AND ("Value Date" < "Min Date") AND NOT IsDateConst("MIN Constrain") OR
               ("MAX Constrain" <> '') AND ("Value Date" > "Max Date") AND NOT IsDateConst("MAX Constrain")
            THEN
                MESSAGE(DefaultValueOutOfRangeErr, "Value Date");
        END;
    end;

    local procedure CheckDec()
    begin
        IF ("MIN Constrain" <> '') AND ("MAX Constrain" <> '') THEN
            IF "Min Dec" > "Max Dec" THEN
                ERROR(IncorrectMinMaxErr, "Min Dec", "Max Dec");

        IF "Default Value" <> '' THEN BEGIN
            IF ("MIN Constrain" <> '') AND ("Value Dec" < "Min Dec") OR
               ("MAX Constrain" <> '') AND ("Value Dec" > "Max Dec")
            THEN
                MESSAGE(DefaultValueOutOfRangeErr, "Value Dec");
        END;
    end;

    [Scope('Internal')]
    procedure ConvertValue(ValueType: Option " ",Option,Dictionary,Boolean,"Integer",Decimal,Percent,Date; var ValueText: Text; ReplaceConst: Boolean; var ValueX: Variant)
    var
        BoolStr: Text;
        DateX: Date;
        IntX: Integer;
        DecX: Decimal;
    begin
        CLEAR(ValueX);

        CASE ValueType OF
            ValueType::Option:
                BEGIN
                    ValueText := UPPERCASE(ValueText);
                    ValueX := ValueText;
                END;
            ValueType::Boolean:
                BEGIN
                    ValueText := UPPERCASE(ValueText);
                    IF ValueText IN ['1', 'T', 'Y', 'TRUE'] THEN
                        ValueText := 'YES';
                    IF ValueText IN ['0', 'F', 'N', 'FALSE'] THEN
                        ValueText := 'NO';
                    IF NOT (ValueText IN ['YES', 'NO']) THEN
                        ERROR(ValueIsNotBoolErr, ValueText);
                    ValueX := ValueText = 'YES';
                END;

            ValueType::Integer,
            ValueType::Percent:
                BEGIN
                    IF NOT EVALUATE(IntX, ValueText) THEN
                        ERROR(ValueIsNotIntegerErr, ValueText);
                    IF (ValueType = ValueType::Percent) AND
                       ((IntX < 0) OR (IntX > 100))
                    THEN
                        ERROR(ValueIsNotPercentErr, ValueText);
                    ValueX := IntX;
                END;

            ValueType::Decimal:
                BEGIN
                    IF NOT EVALUATE(DecX, ValueText) THEN
                        ERROR(ValueIsNotDecimalErr, ValueText);
                    ValueX := DecX;
                END;

            ValueType::Date:
                BEGIN
                    ValueText := UPPERCASE(ValueText);
                    IF ValueText IN ['T'] THEN
                        ValueText := 'TODAY';
                    IF IsDateConst(ValueText) THEN BEGIN
                        DateX := 0D;
                        IF ReplaceConst THEN
                            DateX := GetDateConstValue(ValueText, TODAY);
                    END ELSE
                        IF NOT EVALUATE(DateX, ValueText) THEN
                            ERROR(ValueIsNotDateErr, ValueText);
                    ValueX := DateX;
                END;
            ELSE
                ValueX := ValueText;
        END;
    end;

    [Scope('Internal')]
    procedure GetValuesAsText(ValueType: Option " ",Option,Dictionary,Boolean,"Integer",Decimal,Percent,Date; ValueX: Variant) ValueText: Text
    var
        BoolX: Boolean;
        IntX: Integer;
        DecX: Decimal;
        DateX: Date;
    begin
        ValueText := '';

        CASE ValueType OF
            ValueType::" ",
            ValueType::Option:
                BEGIN
                    ValueText := ValueX;
                    ValueText := UPPERCASE(ValueText);
                END;

            ValueType::Dictionary:
                ValueText := ValueX;

            ValueType::Boolean:
                BEGIN
                    BoolX := ValueX;
                    IF BoolX THEN
                        ValueText := 'YES'
                    ELSE
                        ValueText := 'NO';
                END;

            ValueType::Integer,
            ValueType::Percent:
                BEGIN
                    IntX := ValueX;
                    ValueText := FORMAT(IntX);
                END;

            ValueType::Decimal:
                BEGIN
                    DecX := ValueX;
                    ValueText := FORMAT(DecX);
                END;

            ValueType::Date:
                BEGIN
                    DateX := ValueX;
                    ValueText := FORMAT(DateX);
                END;
            ELSE
                ValueX := ValueText;
        END;
    end;

    [Scope('Internal')]
    procedure GetDateConstValue(ConstValue: Text; DateX: Date): Date
    begin
        CASE ConstValue OF
            'TODAY':
                EXIT(TODAY);
            ELSE
                EXIT(0D);
        END;
    end;

    [Scope('Internal')]
    procedure LookupAnswer(SubjGroupCode: Code[20]; QuestionNo: Integer; var Value: Text[250]): Boolean
    var
        Rec2: Record "25006209";
    begin
        Rec2.GET(SubjGroupCode, QuestionNo);
        IF NOT (Rec2."Answer Type" IN ["Answer Type"::Dictionary, "Answer Type"::Option, "Answer Type"::Boolean]) THEN
            EXIT;

        QAnswer.RESET;
        QAnswer.SETRANGE("Questionary Subject Group Code", SubjGroupCode);
        QAnswer.SETRANGE("Question No.", QuestionNo);
        IF QAnswer.GET(SubjGroupCode, QuestionNo, COPYSTR(Value, 1, MAXSTRLEN(QAnswer."Answer Text"))) THEN;
        IF PAGE.RUNMODAL(0, QAnswer) <> ACTION::LookupOK THEN
            EXIT(FALSE);

        Value := QAnswer."Answer Text";
        EXIT(TRUE);
    end;
}


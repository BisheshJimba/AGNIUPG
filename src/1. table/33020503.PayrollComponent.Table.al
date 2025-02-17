table 33020503 "Payroll Component"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*

    DrillDownPageID = 33020507;
    LookupPageID = 33020507;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
        }
        field(3; Type; Option)
        {
            Description = 'Benefits,Deduction,Employer Contribution,Non Payment';
            OptionCaption = 'Benefits,Deduction,Employer Contribution,Non Payment';
            OptionMembers = Benefits,Deduction,"Employer Contribution","Non Payment";

            trigger OnValidate()
            begin
                ClearAll;
                IF (xRec.Type <> Rec.Type) THEN BEGIN
                    PayrollCompUsage.RESET;
                    PayrollCompUsage.SETCURRENTKEY("Payroll Component Code");
                    PayrollCompUsage.SETRANGE("Payroll Component Code", Code);
                    IF PayrollCompUsage.FINDSET THEN
                        PayrollCompUsage.MODIFYALL("Payroll Type", Type);
                    CompGroupLine.RESET;
                    CompGroupLine.SETCURRENTKEY("Component Code");
                    CompGroupLine.SETRANGE("Component Code", Code);
                    IF CompGroupLine.FINDSET THEN
                        CompGroupLine.MODIFYALL(Type, Type);
                END;
            end;
        }
        field(4; Subtype; Option)
        {
            Description = ' ,Retirement,Advance,Loan';
            OptionCaption = ' ,Retirement,Advance,Loan';
            OptionMembers = " ",Retirement,Advance,Loan;

            trigger OnValidate()
            begin
                IF (xRec.Subtype <> Rec.Subtype) THEN BEGIN
                    PayrollCompUsage.RESET;
                    PayrollCompUsage.SETCURRENTKEY("Payroll Component Code");
                    PayrollCompUsage.SETRANGE("Payroll Component Code", Code);
                    IF PayrollCompUsage.FINDSET THEN
                        PayrollCompUsage.MODIFYALL("Payroll Subtype", Subtype);
                    CompGroupLine.RESET;
                    CompGroupLine.SETCURRENTKEY("Component Code");
                    CompGroupLine.SETRANGE("Component Code", Code);
                    IF CompGroupLine.FINDSET THEN
                        CompGroupLine.MODIFYALL(Subtype, Subtype);
                END;
            end;
        }
        field(5; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(6; "Applicable Month"; Option)
        {
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December,NA';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December,NA;

            trigger OnValidate()
            begin
                IF "Applicable Month" <> "Applicable Month"::" " THEN
                    "Apply Every Month" := FALSE;
            end;
        }
        field(7; "Applicable from"; Date)
        {

            trigger OnValidate()
            begin
                IF ("Applicable to" <> 0D) AND ("Applicable from" <> 0D) THEN
                    IF "Applicable from" >= "Applicable to" THEN
                        ERROR(Text000, FIELDCAPTION("Applicable from"), FIELDCAPTION("Applicable to"), 'greater');

                IF "Applicable from" <> 0D THEN
                    "Apply Every Month" := FALSE;
            end;
        }
        field(8; "Applicable to"; Date)
        {

            trigger OnValidate()
            begin
                IF ("Applicable to" <> 0D) AND ("Applicable from" <> 0D) THEN
                    IF "Applicable from" >= "Applicable to" THEN
                        ERROR(Text000, FIELDCAPTION("Applicable to"), FIELDCAPTION("Applicable from"), 'lesser');

                IF "Applicable to" <> 0D THEN
                    "Apply Every Month" := FALSE;
            end;
        }
        field(9; "Column Name"; Code[10])
        {
        }
        field(10; "Column No."; Integer)
        {
        }
        field(11; Formula; Code[100])
        {

            trigger OnValidate()
            begin
                CheckFormula(Formula);
            end;
        }
        field(12; "Usage Flexible"; Boolean)
        {
        }
        field(13; "Plan Flexible"; Boolean)
        {
        }
        field(14; Status; Option)
        {
            OptionCaption = 'Active,Inactive';
            OptionMembers = Active,Inactive;
        }
        field(15; "Apply Every Month"; Boolean)
        {

            trigger OnValidate()
            begin
                IF "Apply Every Month" THEN BEGIN
                    "Applicable Month" := "Applicable Month"::" ";
                    "Applicable from" := 0D;
                    "Applicable to" := 0D;
                END;
            end;
        }
        field(16; "Deduct on Absent"; Boolean)
        {
        }
        field(17; "Tax Credit Amount"; Decimal)
        {
            Description = 'Valid for type Benefit and Non Payment';

            trigger OnValidate()
            begin
                IF "Tax Credit Amount" <> 0 THEN
                    IF (Type <> Type::Benefits) AND (Type <> Type::"Non Payment") THEN
                        ERROR(Text001);
            end;
        }
        field(18; "Tax Credit %"; Decimal)
        {
            Description = 'Valid for type Benefit and Non Payment';

            trigger OnValidate()
            begin
                IF "Tax Credit %" <> 0 THEN
                    IF (Type <> Type::Benefits) AND (Type <> Type::"Non Payment") THEN
                        ERROR(Text001);
            end;
        }
        field(19; "Irregular Process"; Boolean)
        {
            Description = 'Valid for type Benefit only';

            trigger OnValidate()
            begin
                IF "Irregular Process" THEN
                    TESTFIELD(Type, Type::Benefits);
            end;
        }
        field(21; "Posting Method"; Option)
        {
            OptionCaption = ' ,Employee Wise';
            OptionMembers = " ","Employee Wise";
        }
        field(22; "Create Total"; Boolean)
        {
        }
        field(23; "Retirement Investment"; Boolean)
        {
            Description = 'For the components like CIT';
        }
        field(24; "Fixed"; Boolean)
        {
        }
        field(50000; "Current Month Tax Application"; Boolean)
        {
        }
        field(50001; "Enable % wise calculation"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Column No.")
        {
        }
        key(Key3; "Retirement Investment")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        PayComp: Record "33020503";
        LastColumnName: Code[10];
    begin
        PayComp.RESET;
        PayComp.SETCURRENTKEY("Column No.");
        IF PayComp.FINDLAST THEN BEGIN
            LastColumnName := PayComp."Column Name";
            IF (STRLEN(LastColumnName) = 1) AND (LastColumnName <> 'Z') THEN BEGIN
                IF INCSTR(LastColumnName) = '' THEN BEGIN
                    LastColumnName[STRLEN(LastColumnName)] := LastColumnName[STRLEN(LastColumnName)] + 1;
                END ELSE
                    LastColumnName := INCSTR(LastColumnName);
            END
            ELSE
                IF LastColumnName = 'Z' THEN BEGIN
                    LastColumnName := 'AA';
                END
                ELSE BEGIN
                    IF INCSTR(LastColumnName) = '' THEN BEGIN
                        LastColumnName[STRLEN(LastColumnName)] := LastColumnName[STRLEN(LastColumnName)] + 1;
                    END ELSE
                        LastColumnName := INCSTR(LastColumnName);
                END;
            "Column No." := PayComp."Column No." + 1;
        END
        ELSE BEGIN
            LastColumnName := 'A';
            "Column No." := 1;
        END;
        "Column Name" := LastColumnName;
    end;

    var
        Text000: Label '"%1" cannot be %3 than %2.';
        PayrollCompUsage: Record "33020504";
        CompGroupLine: Record "33020516";
        Text001: Label 'Tax Credit is only valid for "Type" Benefits or Non Payment.';

    [Scope('Internal')]
    procedure ModifyUsage()
    begin
    end;

    [Scope('Internal')]
    procedure ClearAll()
    begin
        "Tax Credit Amount" := 0;
        "Tax Credit %" := 0;
        "Irregular Process" := FALSE;
    end;

    [Scope('Internal')]
    procedure CheckFormula(Formula: Code[80])
    var
        i: Integer;
        ParenthesesLevel: Integer;
        HasOperator: Boolean;
        Text001: Label 'The parenthesis at position %1 is misplaced.';
        Text002: Label 'You cannot have two consecutive operators. The error occurred at position %1.';
        Text003: Label 'There is an operand missing after position %1.';
        Text004: Label 'There are more left parentheses than right parentheses.';
        Text005: Label 'There are more right parentheses than left parentheses.';
    begin
        ParenthesesLevel := 0;
        FOR i := 1 TO STRLEN(Formula) DO BEGIN
            IF Formula[i] = '(' THEN
                ParenthesesLevel := ParenthesesLevel + 1
            ELSE
                IF Formula[i] = ')' THEN
                    ParenthesesLevel := ParenthesesLevel - 1;
            IF ParenthesesLevel < 0 THEN
                ERROR(Text001, i);
            IF Formula[i] IN ['+', '-', '*', '/', '^'] THEN BEGIN
                IF HasOperator THEN
                    ERROR(Text002, i)
                ELSE
                    HasOperator := TRUE;
                IF i = STRLEN(Formula) THEN
                    ERROR(Text003, i)
                ELSE
                    IF Formula[i + 1] = ')' THEN
                        ERROR(Text003, i);
            END ELSE
                HasOperator := FALSE;
        END;
        IF ParenthesesLevel > 0 THEN
            ERROR(Text004)
        ELSE
            IF ParenthesesLevel < 0 THEN
                ERROR(Text005);
    end;
}


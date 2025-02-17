table 33020504 "Payroll Component Usage"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*


    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(2; "Payroll Component Code"; Code[20])
        {
            TableRelation = "Payroll Component";

            trigger OnValidate()
            begin
                "Payroll Component Description" := '';
                CLEAR("Payroll Type");
                "Payroll Subtype" := "Payroll Subtype"::" ";
                "Column Name" := '';
                "Column No." := 0;
                Formula := '';
                Amount := 0;
                IF PayrollComponent.GET("Payroll Component Code") THEN BEGIN
                    "Payroll Component Description" := PayrollComponent.Description;
                    "Payroll Type" := PayrollComponent.Type;
                    "Payroll Subtype" := PayrollComponent.Subtype;
                    "Applicable Month" := PayrollComponent."Applicable Month";
                    "Applicable from" := PayrollComponent."Applicable from";
                    "Applicable to" := PayrollComponent."Applicable to";
                    "Column Name" := PayrollComponent."Column Name";
                    "Column No." := PayrollComponent."Column No.";
                    Fixed := PayrollComponent.Fixed;
                    VALIDATE(Formula, PayrollComponent.Formula);
                END;
            end;
        }
        field(3; "Payroll Component Description"; Text[100])
        {
            Editable = false;
        }
        field(4; "Payroll Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Benefits,Deduction,Employer Contribution,Non Payment';
            OptionMembers = Benefits,Deduction,"Employer Contribution","Non Payment";
        }
        field(5; Formula; Code[100])
        {

            trigger OnValidate()
            begin
                CheckFormula(Formula);
            end;
        }
        field(6; Amount; Decimal)
        {
        }
        field(7; "Payroll Subtype"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Retirement,Advance,Loan';
            OptionMembers = " ",Retirement,Advance,Loan;
        }
        field(8; "Column Name"; Code[10])
        {
            Editable = false;
        }
        field(9; "Column No."; Integer)
        {
        }
        field(10; "Applicable Month"; Option)
        {
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December,NA';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December,NA;
        }
        field(11; "Applicable from"; Date)
        {
        }
        field(12; "Applicable to"; Date)
        {
        }
        field(50; "G/L Account"; Code[20])
        {
            CalcFormula = Lookup("Payroll Component"."G/L Account" WHERE(Code = FIELD(Payroll Component Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "Deduct on Leave"; Boolean)
        {
            CalcFormula = Lookup("Payroll Component"."Deduct on Absent" WHERE(Code = FIELD(Payroll Component Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(52; "Fixed"; Boolean)
        {
        }
        field(53; "Retirement Investment"; Boolean)
        {
            CalcFormula = Lookup("Payroll Component"."Retirement Investment" WHERE(Code = FIELD(Payroll Component Code)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Payroll Component Code")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.", "Column No.")
        {
        }
        key(Key3; "Payroll Component Code")
        {
        }
        key(Key4; "Employee No.", "Column Name")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PayrollComponent: Record "33020503";

    [Scope('Internal')]
    procedure InsertGroup()
    var
        CompGroup: Record "33020515";
        PayrollMgmt: Codeunit "33020503";
    begin
        IF PAGE.RUNMODAL(PAGE::"Component Group Selection", CompGroup) = ACTION::LookupOK THEN BEGIN
            PayrollMgmt.CreateComponenetUsage(CompGroup, "Employee No.")
        END;
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


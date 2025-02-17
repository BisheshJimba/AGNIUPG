table 33020514 "Salary Credit Assign"
{
    // *PAYROLL 6.1.0 YURAN@AGILE*


    fields
    {
        field(1; "Salary Header No."; Code[20])
        {
        }
        field(2; Type; Option)
        {
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";

            trigger OnValidate()
            begin
                IF Rec.Type <> xRec.Type THEN BEGIN
                    Code := '';
                    Name := '';
                    Amount := 0;
                END;
            end;
        }
        field(3; "Code"; Code[20])
        {
            TableRelation = IF (Type = CONST(G/L Account)) "G/L Account"
                            ELSE IF (Type=CONST(Bank Account)) "Bank Account";

            trigger OnValidate()
            begin
                Name := '';
                IF Type = Type::"G/L Account" THEN BEGIN
                    IF GLAccount.GET(Code) THEN BEGIN
                        GLAccount.TESTFIELD("Account Type", GLAccount."Account Type"::Posting);
                        GLAccount.TESTFIELD(Blocked, FALSE);
                        Name := GLAccount.Name;
                    END;
                END
                ELSE
                    IF Type = Type::"Bank Account" THEN BEGIN
                        IF BankAcc.GET(Code) THEN
                            BankAcc.TESTFIELD(Blocked, FALSE);
                        Name := BankAcc.Name;
                    END;
            end;
        }
        field(4; Name; Text[50])
        {
            Editable = false;
        }
        field(5; Amount; Decimal)
        {
        }
        field(6; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(7; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(8; "Total Assigned"; Decimal)
        {
            CalcFormula = Sum("Salary Credit Assign".Amount WHERE(Salary Header No.=FIELD(Salary Header No.)));
                Editable = false;
                FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Salary Header No.", Type, "Code")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        GetTotal
    end;

    trigger OnRename()
    begin
        GetTotal
    end;

    var
        BankAcc: Record "270";
        GLAccount: Record "15";
        SalaryHeader: Record "33020510";

    [Scope('Internal')]
    procedure GetTotal()
    var
        SalaryCredit: Record "33020514";
        AssignedAmt: Decimal;
    begin
        SalaryHeader.RESET;
        SalaryHeader.SETRANGE("No.", "Salary Header No.");
        IF SalaryHeader.FINDFIRST THEN BEGIN
            SalaryHeader.CALCFIELDS("Salary in Hand");
            SalaryCredit.RESET;
            SalaryCredit.SETRANGE("Salary Header No.", "Salary Header No.");
            IF SalaryCredit.FINDSET THEN
                SalaryCredit.CALCFIELDS("Total Assigned");
            AssignedAmt := SalaryCredit."Total Assigned";
            IF Amount = 0 THEN
                Amount := SalaryHeader."Salary in Hand" - AssignedAmt;
        END;
    end;
}


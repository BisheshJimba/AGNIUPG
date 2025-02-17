table 2000000 "Procurement Budget Analysis"
{

    fields
    {
        field(1; "Memo No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "G/L Account No."; Code[20])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            var
                GLBudgetEntry: Record "G/L Budget Entry";
            begin
                CalculateBudget;//Aakrista 12/13/2021 to Calculate Yearly Budget and Budget Till Date
                Balance := "Yearly Budget" - "Budget Till Date" - "New Reccomendation";
            end;
        }
        field(4; "Budget Till Date"; Decimal)
        {
            Editable = false;
        }
        field(5; "Yearly Budget"; Decimal)
        {
            Editable = false;
        }
        field(6; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(7; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(8; Balance; Decimal)
        {
            Editable = false;
        }
        field(9; "New Reccomendation"; Decimal)
        {
            Editable = false;
        }
        field(10; "Fiscal Year"; Text[50])
        {
        }
        field(50000; "Vendor Code"; Code[20])
        {
        }
        field(50001; "G/L Account Name"; Text[50])
        {
            Editable = false;
        }
        field(50002; VIN; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Memo No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ProcMemo.GET("Memo No.");
        VendorLine.RESET;//Aakrista 5/18/2022
        VendorLine.SETRANGE("Memo No.", "Memo No.");
        IF ProcMemo."Procurement Type" = ProcMemo."Procurement Type"::Purchase THEN
            VendorLine.SETRANGE("Vendor Code", "Vendor Code")
        ELSE
            IF ProcMemo."Procurement Type" = ProcMemo."Procurement Type"::Sales THEN
                VendorLine.SETRANGE("Customer Code", "Vendor Code");
        VendorLine.SETRANGE("G/L Account No.", "G/L Account No.");
        VendorLine.SETRANGE("Global Dimension 1 Code", "Global Dimension 1 Code");
        VendorLine.SETRANGE("Global Dimension 2 Code", "Global Dimension 2 Code");
        IF VendorLine.FINDFIRST THEN BEGIN
            VendorLine.Selected := FALSE;
            VendorLine.MODIFY;
        END;
    end;

    var
        AccountingPeriods: Record "Accounting Period";
        GLEntry: Record "G/L Entry";
        GLBudgetEntry: Record "G/L Budget Entry";
        ProcurementMemo: Record "Procurement Memo";
        EngNepDate: Record "Eng-Nep Date";
        FiscalYear: Text;
        EngNepDate1: Record "Eng-Nep Date";
        StartingFiscalYrDate: Date;
        EndingFiscalYrDate: Date;
        EngNepDate2: Record "Eng-Nep Date";
        GLAccount: Record "G/L Account";
        VendorLine: Record "Vendor Line";
        BudgetAnalysis: Record "Procurement Budget Analysis";
        ProcMemo: Record "Procurement Memo";

    local procedure CalculateBudget()
    begin
        ProcurementMemo.GET("Memo No.");
        EngNepDate.RESET;
        EngNepDate.SETRANGE("English Date", ProcurementMemo."Document Date");
        IF EngNepDate.FINDFIRST THEN
            "Fiscal Year" := EngNepDate."Fiscal Year";
        EngNepDate1.RESET;
        EngNepDate1.SETRANGE("Fiscal Year", "Fiscal Year");
        IF EngNepDate1.FINDFIRST THEN
            StartingFiscalYrDate := EngNepDate1."English Date";
        EngNepDate2.RESET;
        EngNepDate2.SETRANGE("Fiscal Year", "Fiscal Year");
        IF EngNepDate2.FINDLAST THEN
            EndingFiscalYrDate := EngNepDate2."English Date";
        GLAccount.RESET;
        GLAccount.SETRANGE("No.", "G/L Account No.");
        GLAccount.SETFILTER("Global Dimension 1 Filter", "Global Dimension 1 Code");
        GLAccount.SETFILTER("Global Dimension 2 Filter", "Global Dimension 2 Code");
        GLAccount.SETFILTER("Date Filter", '%1..%2', StartingFiscalYrDate, EndingFiscalYrDate);
        GLAccount.FINDFIRST;
        GLAccount.CALCFIELDS("Net Change", "Budgeted Amount");
        "Budget Till Date" := GLAccount."Net Change";
        "Yearly Budget" := GLAccount."Budgeted Amount";
    end;

    local procedure GetNextAccPeriodStartDate(CurrentStartDate: Date): Date
    begin
        AccountingPeriods.RESET;
        AccountingPeriods.SETFILTER("Starting Date", '>%1', CurrentStartDate);
        IF AccountingPeriods.FINDFIRST THEN
            EXIT(AccountingPeriods."Starting Date");
    end;

    [Scope('Internal')]
    procedure GetNewLineNo(MemoNo: Code[20]): Integer
    begin
        BudgetAnalysis.SETRANGE("Memo No.", MemoNo);
        IF BudgetAnalysis.FINDLAST THEN;
        BudgetAnalysis."Line No." := BudgetAnalysis."Line No." + 1000;
        EXIT(BudgetAnalysis."Line No.");
    end;
}


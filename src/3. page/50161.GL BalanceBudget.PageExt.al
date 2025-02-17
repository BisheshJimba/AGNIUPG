pageextension 50161 pageextension50161 extends "G/L Balance/Budget"
{
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Caption = 'PERCENTAGE';

    //Unsupported feature: Property Insertion (Name) on ""G/L Balance/Budget"(Page 422)".

    layout
    {
        addafter("Control 14")
        {
            field(DateFilter; DateFilter)
            {
                Caption = 'Date Filter';

                trigger OnValidate()
                begin
                    IF DateFilter <> '' THEN BEGIN
                        Rec.SETFILTER("Date Filter", DateFilter)
                    END ELSE
                        Rec.SETFILTER("Date Filter", DateFilter);
                    CurrPage.UPDATE;
                end;
            }
            field(GLAccountFilter; GLAccountFilter)
            {
                Caption = 'GLAccount Filter';
                TableRelation = "G/L Account";

                trigger OnValidate()
                begin
                    IF GLAccountFilter <> '' THEN
                        Rec.SETFILTER("No.", GLAccountFilter)
                    ELSE
                        Rec.SETFILTER("No.", GLAccountFilter);
                    CurrPage.UPDATE;
                end;
            }
        }
        addafter("Control 8")
        {
            field(BUDGET; Budget)
            {
                Caption = 'BUDGET';
            }
            field(ACTUAL; Expenses)
            {
                Caption = 'ACTUAL';
            }
            field(VARIANCE; Rec.Balance)
            {
                Caption = 'VARIANCE';
            }
        }
        addafter("Control 35")
        {
            field(Balance; Rec.Balance)
            {
                Visible = false;
            }
        }
        moveafter("Control 8"; "Control 26")
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 28".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 42".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 184".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 43".

    }

    var
        GLAccountFilter: Text;
        GLAccount: Record "15";
        DateFilter: Text;
        Budget: Decimal;
        Balance: Decimal;
        Expenses: Decimal;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CODEUNIT.RUN(CODEUNIT::"GLBudget-Open",Rec);
    FindPeriod('');
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    CODEUNIT.RUN(CODEUNIT::"GLBudget-Open",Rec);
    FindPeriod('');
    CLEAR(GLAccountFilter);
    CLEAR(DateFilter);
    */
    //end;


    //Unsupported feature: Code Modification on "CalcFormFields(PROCEDURE 2)".

    //procedure CalcFormFields();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    CALCFIELDS("Net Change","Budgeted Amount");
    IF "Net Change" >= 0 THEN BEGIN
      "Debit Amount" := "Net Change";
      "Credit Amount" := 0;
    END ELSE BEGIN
      "Debit Amount" := 0;
      "Credit Amount" := -"Net Change";
    END;
    IF "Budgeted Amount" >= 0 THEN BEGIN
      "Budgeted Debit Amount" := "Budgeted Amount";
      "Budgeted Credit Amount" := 0;
    END ELSE BEGIN
      "Budgeted Debit Amount" := 0;
      "Budgeted Credit Amount" := -"Budgeted Amount";
    END;
    IF "Budgeted Amount" = 0 THEN
      BudgetPct := 0
    ELSE
      BudgetPct := "Net Change" / "Budgeted Amount" * 100;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    CALCFIELDS("Net Change","Budgeted Amount");
    IF "Net Change" >= 0 THEN BEGIN
     // "Debit Amount" := "Net Change";
     //"Credit Amount" := 0;
     Budget := "Net Change";
    END ELSE BEGIN
      //"Debit Amount" := 0;
      //"Credit Amount" := -"Net Change";
      Budget := - "Net Change";
    END;
    IF "Budgeted Amount" >= 0 THEN BEGIN
      //"Budgeted Debit Amount" := "Budgeted Amount";
      //"Budgeted Credit Amount" := 0;
      Expenses := "Budgeted Amount";
    END ELSE BEGIN
      //"Budgeted Debit Amount" := 0;
      //"Budgeted Credit Amount" := -"Budgeted Amount";
      Expenses := - "Budgeted Amount";
    #15..19

    Balance := 0;
    Balance := Budget - Expenses;
    */
    //end;
}


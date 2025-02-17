codeunit 33020302 "Manpower_Budget Mangement"
{

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure CreateBudgetLines(PrmFiscalYear: Code[10]; PrmTestYear: Text[30]; PrmTestYear1: Code[10])
    var
        LclDepartment: Record "33020337";
        LclMnpwrBdgtLine: Record "33020377";
    begin
        //Inserting Department code and description in Manpower Budget Lines.
        LclDepartment.RESET;
        LclDepartment.SETFILTER(Blocked, 'No');
        IF LclDepartment.FIND('-') THEN BEGIN
            REPEAT
                LclMnpwrBdgtLine.INIT;
                LclMnpwrBdgtLine."Fiscal Year" := PrmFiscalYear;
                LclMnpwrBdgtLine."Department Code" := LclDepartment.Code;
                LclMnpwrBdgtLine."Department Name" := LclDepartment.Description;
                LclMnpwrBdgtLine.TestYear := PrmTestYear;
                LclMnpwrBdgtLine.TestYear1 := PrmTestYear1;
                LclMnpwrBdgtLine.INSERT;
            UNTIL LclDepartment.NEXT = 0;
        END;
    end;
}


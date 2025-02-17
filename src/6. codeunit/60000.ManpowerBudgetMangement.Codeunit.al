codeunit 60000 "Manpower Budget Mangement"
{

    trigger OnRun()
    begin
    end;

    [Scope('Internal')]
    procedure CreateBudgetLines(PrmFiscalYear: Code[10])
    var
        LclDepartment: Record "33020337";
        LclMnpwrBdgtLine: Record "60001";
    begin
        //Inserting Department code and description in Manpower Budget Lines.
        LclDepartment.RESET;
        IF LclDepartment.FIND('-') THEN BEGIN
            REPEAT
                LclMnpwrBdgtLine.INIT;
                LclMnpwrBdgtLine."Fiscal Year" := PrmFiscalYear;
                LclMnpwrBdgtLine."Department Code" := LclDepartment.Code;
                LclMnpwrBdgtLine."Department Name" := LclDepartment.Description;
                LclMnpwrBdgtLine.INSERT;
            UNTIL LclDepartment.NEXT = 0;
        END;
    end;
}


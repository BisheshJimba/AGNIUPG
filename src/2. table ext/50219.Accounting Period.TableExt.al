tableextension 50219 tableextension50219 extends "Accounting Period"
{
    fields
    {

        //Unsupported feature: Property Modification (Editable) on "Closed(Field 4)".


        //Unsupported feature: Property Modification (Editable) on ""Date Locked"(Field 5)".

        field(50000; "Nepali Fiscal Year"; Text[30])
        {
        }
        field(50001; "English Fiscal Year"; Text[30])
        {
            Description = 'QR19.00';
        }
    }

    procedure VerifyAndSetNepaliFiscalyear(PostingDate: Date)
    var
        AccountingPeriodPage: Page "100";
        AccountingPeriod: Record "50";
        NoNepaliFiscalYearInfoQst: Label 'No Nepali Fiscal Year is provided in %1. Do you want to update it now?';
        NoNepaliFiscalYearInfoMsg: Label 'No Nepali Fiscal Year information is provided in %1. Review the report.';
    begin
        AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
        AccountingPeriod.SETRANGE("Starting Date", 0D, PostingDate);
        IF (AccountingPeriod.FINDLAST) AND (AccountingPeriod."Nepali Fiscal Year" <> '') THEN
            EXIT;
        IF CONFIRM(NoNepaliFiscalYearInfoQst, TRUE, AccountingPeriod.TABLECAPTION) THEN BEGIN
            AccountingPeriodPage.SETRECORD(AccountingPeriod);
            AccountingPeriodPage.EDITABLE(TRUE);
            IF AccountingPeriodPage.RUNMODAL = ACTION::OK THEN
                AccountingPeriodPage.GETRECORD(AccountingPeriod);
        END;
        IF NOT (AccountingPeriod.FINDLAST) AND (AccountingPeriod."Nepali Fiscal Year" <> '') THEN
            ERROR(NoNepaliFiscalYearInfoMsg, AccountingPeriod.TABLECAPTION);
    end;
}


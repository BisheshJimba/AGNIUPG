table 60000 "Manpower Budget Header"
{
    // This HR Budget is designed and developed by
    //   Er. Sangam Shrestha
    //   11 April 2012
    //   9.30 PM.
    // 
    // Developed for Sipradi Trading Pvt. Ltd. - HR Division.


    fields
    {
        field(1; "Fiscal Year"; Code[10])
        {

            trigger OnValidate()
            begin
                //Checking Fiscal Year format.
                checkFiscalYearFormat("Fiscal Year");

                //Inserting Department details in Lines.
                GblMnpwrBdgtMngt.CreateBudgetLines("Fiscal Year");
            end;
        }
        field(2; Description; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Fiscal Year")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        GblMnpwrBdgtLine.RESET;
        GblMnpwrBdgtLine.SETRANGE("Fiscal Year", "Fiscal Year");
        IF GblMnpwrBdgtLine.FIND('-') THEN
            GblMnpwrBdgtLine.DELETEALL;

        GblMnpwrBdgtEntry.RESET;
        GblMnpwrBdgtEntry.SETRANGE("Fiscal Year", "Fiscal Year");
        IF GblMnpwrBdgtEntry.FIND('-') THEN
            GblMnpwrBdgtEntry.DELETEALL;
    end;

    var
        GblMnpwrBdgtMngt: Codeunit "Manpower Budget Mangement";
        GblMnpwrBdgtLine: Record "Manpower Budget Line";
        GblMnpwrBdgtEntry: Record "Manpower Budget Entry";

    [Scope('Internal')]
    procedure checkFiscalYearFormat(PrmFiscalYear: Code[10])
    var
        Text001: Label 'Fiscal Year format must be of "0000/0000" - format you entered is not valid. Please enter correct format. Ex. - "2068/2069". Or contact your system administrator.';
        FYLength: Integer;
    begin
        //Calculating Fiscal Year characters and displaying error if is less then 10 char.
        FYLength := STRLEN(PrmFiscalYear);

        IF (FYLength <> 9) THEN
            ERROR(Text001);
    end;
}


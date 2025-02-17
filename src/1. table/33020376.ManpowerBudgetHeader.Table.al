table 33020376 "Manpower Budget_Header"
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

                //sm to split fiscal year
                Position := STRPOS("Fiscal Year", '/');
                NewString := COPYSTR("Fiscal Year", Position + 1, 4);
                NewString1 := COPYSTR("Fiscal Year", Position - 4, 4);
                TestYear := NewString;
                TestYear1 := NewString1;


                //Inserting Department details in Lines.
                GblMnpwrBdgtMngt.CreateBudgetLines("Fiscal Year", TestYear, TestYear1);
            end;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; TestYear; Code[10])
        {
        }
        field(4; TestYear1; Code[10])
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
        GblMnpwrBdgtMngt: Codeunit "33020302";
        GblMnpwrBdgtLine: Record "33020377";
        GblMnpwrBdgtEntry: Record "33020378";
        Position: Integer;
        NewString: Code[10];
        NewString1: Code[10];

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


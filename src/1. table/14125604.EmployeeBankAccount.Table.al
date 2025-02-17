table 14125604 "Employee Bank Account"
{

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(2; "Code"; Code[10])
        {
        }
        field(3; Name; Text[50])
        {
        }
        field(4; "Name 2"; Text[50])
        {
        }
        field(5; Address; Text[30])
        {
        }
        field(6; "Address 2"; Text[50])
        {
        }
        field(7; City; Text[30])
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.ValidateCity(City, "Post Code", Country, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(8; Contact; Text[50])
        {
        }
        field(9; "Phone No."; Text[30])
        {
        }
        field(10; "Telex No."; Text[30])
        {
        }
        field(11; "Bank Branch No."; Text[20])
        {
            Caption = 'Bank Branch No.';
            Description = 'NCHL-NPI_1.00 (to be used as Branch ID for NCHL-NPI_1.00)';

            trigger OnLookup()
            var
                CIPSWebServiceMgt: Codeunit "NCHL-NPI Web Service Mgt.";
                CIPSBankList: Page "NCHL-NPI Bank-Branch Lists";
                TempCIPSBankAccount: Record "NCHL-NPI Entry";
                CompanyInfo: Record "Company Information";
            begin
                //NCHL-NPI_1.00 >>
                CompanyInfo.GET;
                IF NOT CompanyInfo."Enable NCHL-NPI Integration" THEN
                    EXIT;

                TESTFIELD("Bank ID");
                CIPSWebServiceMgt.GetCIPSBankBranchList("Bank ID");
                CLEAR(CIPSBankList);
                TempCIPSBankAccount.RESET;
                TempCIPSBankAccount.SETCURRENTKEY(Agent, "Line No.");
                TempCIPSBankAccount.SETASCENDING("Line No.", TRUE);
                TempCIPSBankAccount.SETFILTER("End to End ID", 'CIPSBANKLISTS');
                CIPSBankList.SETRECORD(TempCIPSBankAccount);
                CIPSBankList.SETTABLEVIEW(TempCIPSBankAccount);
                CIPSBankList.LOOKUPMODE(TRUE);
                COMMIT();
                IF CIPSBankList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    CIPSBankList.GETRECORD(TempCIPSBankAccount);
                    "Bank Branch No." := TempCIPSBankAccount.Branch;
                    "Bank Branch Name" := TempCIPSBankAccount.Name;
                END;
                TempCIPSBankAccount.RESET;
                TempCIPSBankAccount.SETFILTER("End to End ID", 'CIPSBANKLISTS');
                IF TempCIPSBankAccount.FINDFIRST THEN
                    TempCIPSBankAccount.DELETEALL;
                //NCHL-NPI_1.00 <<
            end;
        }
        field(12; "Bank Account No."; Text[30])
        {
        }
        field(13; "Transit No."; Text[30])
        {
        }
        field(14; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(15; "Post Code"; Code[10])
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".Code WHERE("Country/Region Code" = FIELD("Country/Region Code"));

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.ValidateCity(City, "Post Code", Country, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(16; "Country/Region Code"; Code[10])
        {
        }
        field(17; Country; Text[30])
        {
        }
        field(18; "Fax No."; Text[30])
        {
        }
        field(19; "Telex Answer back"; Text[30])
        {
        }
        field(20; "Language Code"; Code[10])
        {
            TableRelation = Language;
        }
        field(21; "E-Mail"; Text[100])
        {
        }
        field(22; "Home Page"; Text[80])
        {
        }
        field(23; IBAN; Code[50])
        {
            Description = 'Not done validate code';
        }
        field(24; "SWIFT Code"; Code[10])
        {
        }
        field(25; "Bank Clearing Code"; Text[30])
        {
        }
        field(26; "Bank Clearing standred"; Text[50])
        {
        }
        field(10000; "Bank ID"; Text[10])
        {
            Description = 'NCHL-NPI_1.00';

            trigger OnLookup()
            var
                CIPSWebServiceMgt: Codeunit "NCHL-NPI Web Service Mgt.";
                CIPSBankList: Page "NCHL-NPI Bank-Branch Lists";
                TempCIPSBankAccount: Record "NCHL-NPI Entry";
                CompanyInfo: Record "Company Information";
            begin
                //NCHL-NPI_1.00 >>
                CompanyInfo.GET;
                IF NOT CompanyInfo."Enable NCHL-NPI Integration" THEN
                    EXIT;

                CIPSWebServiceMgt.GetCIPSBankList;
                CLEAR(CIPSBankList);
                TempCIPSBankAccount.RESET;
                TempCIPSBankAccount.SETCURRENTKEY(Agent, Branch, "Line No.");
                TempCIPSBankAccount.SETASCENDING(Branch, TRUE);
                TempCIPSBankAccount.SETFILTER("End to End ID", 'CIPSBANKLISTS');
                CIPSBankList.SETRECORD(TempCIPSBankAccount);
                CIPSBankList.SETTABLEVIEW(TempCIPSBankAccount);
                CIPSBankList.LOOKUPMODE(TRUE);
                COMMIT();
                IF CIPSBankList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    CIPSBankList.GETRECORD(TempCIPSBankAccount);
                    "Bank ID" := TempCIPSBankAccount.Agent;
                    "Bank Name" := TempCIPSBankAccount.Name;
                END;
                TempCIPSBankAccount.RESET;
                TempCIPSBankAccount.SETFILTER("End to End ID", 'CIPSBANKLISTS');
                IF TempCIPSBankAccount.FINDFIRST THEN
                    TempCIPSBankAccount.DELETEALL;
                //NCHL-NPI_1.00 <<
            end;
        }
        field(10001; "Bank Branch Name"; Text[80])
        {
            Description = 'NCHL-NPI_1.00';
        }
        field(10002; "Bank Account Name"; Text[100])
        {
            Description = 'NCHL-NPI_1.00';
        }
        field(10003; "Bank Name"; Text[100])
        {
            Description = 'NCHL-NPI_1.00';
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        VendLedg: Record "Vendor Ledger Entry";
    begin
        VendLedg.SETRANGE("Vendor No.", "Employee No.");
        VendLedg.SETRANGE("Recipient Bank Account", Code);
        IF NOT VendLedg.ISEMPTY THEN
            ERROR(BankAccDel);
    end;

    var
        CompInfo: Record "Company Information";
        CIPSWebServiceMgt: Codeunit "NCHL-NPI Web Service Mgt.";
        TempCIPSBankAccount: Record "NCHL-NPI Entry";
        BankAccIdentifierIsEmptyErr: Label 'You must specify either a Bank Account No. or an IBAN.';
        BankAccDel: Label 'You cannot delete this bank account because there are one or more ledger entries associated with the bank account.';

    local procedure GetBankAccNoWithCheck() AccNo: Text
    begin
        AccNo := GetBankAccNo;
        IF AccNo = '' THEN
            ERROR(BankAccDel);
    end;

    local procedure GetBankAccNo(): Text
    begin
        IF "Bank Account No." <> '' THEN
            EXIT("Bank Account No.");
    end;
}


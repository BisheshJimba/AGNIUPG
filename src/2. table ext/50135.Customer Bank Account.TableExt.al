tableextension 50135 tableextension50135 extends "Customer Bank Account"
{
    fields
    {
        modify(City)
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
        }
        modify("Post Code")
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
        }

        //Unsupported feature: Code Insertion on ""Bank Branch No."(Field 13)".

        //trigger OnLookup(var Text: Text): Boolean
        //begin
            /*
            //NCHL-NPI_1.00 >>
            CompanyInfo.GET;
            IF NOT CompanyInfo."Enable NCHL-NPI Integration" THEN
              EXIT;

            TESTFIELD("Bank ID");
            CIPSWebServiceMgt.GetCIPSBankBranchList("Bank ID");
            CLEAR(CIPSBankList);
            TempCIPSBankAccount.RESET;
            TempCIPSBankAccount.SETCURRENTKEY(Agent,"Line No.");
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
            */
        //end;
        field(10000;"Bank ID";Text[10])
        {
            Description = 'NCHL-NPI_1.00';

            trigger OnLookup()
            var
                CIPSWebServiceMgt: Codeunit "33019811";
                CIPSBankList: Page "33019815";
                                  TempCIPSBankAccount: Record "33019814";
                                  CompanyInfo: Record "79";
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
                  Name := TempCIPSBankAccount.Name;
                END;
                TempCIPSBankAccount.RESET;
                TempCIPSBankAccount.SETFILTER("End to End ID", 'CIPSBANKLISTS');
                IF TempCIPSBankAccount.FINDFIRST THEN
                  TempCIPSBankAccount.DELETEALL;
                //NCHL-NPI_1.00 <<
            end;
        }
        field(10001;"Bank Branch Name";Text[80])
        {
            Description = 'NCHL-NPI_1.00';
        }
        field(10002;"Bank Account Name";Text[100])
        {
            Description = 'NCHL-NPI_1.00';
        }
        field(10003;"Bank Name";Text[100])
        {
            Description = 'NCHL-NPI_1.00';
        }
    }

    var
        CompanyInfo: Record "79";
        CIPSWebServiceMgt: Codeunit "33019811";
        CIPSBankList: Page "33019815";
                          TempCIPSBankAccount: Record "33019814";
                          "Bank Id": Code[10];
                          "Bank Name": Code[10];
}


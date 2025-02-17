tableextension 50125 tableextension50125 extends "Bank Account"
{
    fields
    {
        modify(City)
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
        }
        modify("Territory Code")
        {
            TableRelation = "Dealer Segment Type";
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 38)".


        //Unsupported feature: Property Modification (CalcFormula) on "Balance(Field 58)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Balance (LCY)"(Field 59)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Net Change"(Field 60)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Net Change (LCY)"(Field 61)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Total on Checks"(Field 62)".

        modify("Post Code")
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Balance at Date"(Field 95)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Balance at Date (LCY)"(Field 96)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Debit Amount"(Field 97)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Credit Amount"(Field 98)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Debit Amount (LCY)"(Field 99)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Credit Amount (LCY)"(Field 100)".

        modify("Bank Branch No.")
        {
            Description = 'NCHL-NPI_1.00 (to be used as Branch ID for NCHL-NPI_1.00)';
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Check Report Name"(Field 109)".


        //Unsupported feature: Code Insertion on ""Phone No."(Field 9)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            IF STRLEN("Phone No.") > 20 THEN
              ERROR(Text005);
            */
        //end;


        //Unsupported feature: Code Insertion on ""Bank Branch No."(Field 101)".

        //trigger OnLookup(var Text: Text): Boolean
        //var
            //CIPSWebServiceMgt: Codeunit "33019811";
            //CIPSBankList: Page "33019815";
            //TempCIPSBankAccount: Record "33019814";
            //CompanyInfo: Record "79";
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
                  "Bank Name" := TempCIPSBankAccount.Name;
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
        field(50000;"VF Loan No. Filter";Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(50001;Saved;Boolean)
        {
        }
        field(50002;"Old Bank No.";Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                  GLSetup.GET;
                  NoSeriesMgt.TestManual(GLSetup."Bank Account Nos.");
                  "No. Series" := '';
                END;
            end;
        }
        field(52003;"Interest Rate";Decimal)
        {
        }
        field(52004;"Payment Account No.";Text[30])
        {
        }
        field(52005;Limit;Decimal)
        {
        }
        field(52006;"Remaining Limit";Decimal)
        {
        }
    }
    keys
    {
        key(Key1;Name)
        {
        }
    }


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Last Date Modified" := TODAY;

        IF (Name <> xRec.Name) OR
        #4..26
            IF FIND THEN;
          END;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..29
        IF Saved THEN BEGIN   //<< MIN 4/30/2019
          UserSetup.GET(USERID);
          IF NOT UserSetup."Can Edit Bank Card" THEN
           ERROR(NoModifyPermissionErr);
        END;
        */
    //end;

    var
        NoModifyPermissionErr: Label 'You do not have permission to modify Bank card Page.';
        UserSetup: Record "91";
        PicureUpload: Boolean;
        Text005: Label 'Phone No. cannot be greater than 20 digits.';
}


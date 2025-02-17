tableextension 50105 tableextension50105 extends Vendor
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on "Name(Field 2)".


        //Unsupported feature: Property Modification (Data type) on ""Search Name"(Field 3)".


        //Unsupported feature: Property Modification (Data type) on ""Name 2"(Field 4)".

        modify(City)
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
        }

        //Unsupported feature: Property Modification (Data type) on ""Phone No."(Field 9)".

        modify("Territory Code")
        {
            TableRelation = "Dealer Segment Type";
        }

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 38)".


        //Unsupported feature: Property Modification (CalcFormula) on "Balance(Field 58)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Balance (LCY)"(Field 59)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Net Change"(Field 60)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Net Change (LCY)"(Field 61)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Purchases (LCY)"(Field 62)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Inv. Discounts (LCY)"(Field 64)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pmt. Discounts (LCY)"(Field 65)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Balance Due"(Field 66)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Balance Due (LCY)"(Field 67)".


        //Unsupported feature: Property Modification (CalcFormula) on "Payments(Field 69)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Invoice Amounts"(Field 70)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Cr. Memo Amounts"(Field 71)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Finance Charge Memo Amounts"(Field 72)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Payments (LCY)"(Field 74)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Inv. Amounts (LCY)"(Field 75)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Cr. Memo Amounts (LCY)"(Field 76)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Fin. Charge Memo Amounts (LCY)"(Field 77)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Outstanding Orders"(Field 78)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Amt. Rcd. Not Invoiced"(Field 79)".


        //Unsupported feature: Property Insertion (Editable) on ""VAT Registration No."(Field 86)".

        modify("Post Code")
        {
            TableRelation = IF (Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Debit Amount"(Field 97)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Credit Amount"(Field 98)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Debit Amount (LCY)"(Field 99)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Credit Amount (LCY)"(Field 100)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reminder Amounts"(Field 104)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Reminder Amounts (LCY)"(Field 105)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Outstanding Orders (LCY)"(Field 113)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Amt. Rcd. Not Invoiced (LCY)"(Field 114)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pmt. Disc. Tolerance (LCY)"(Field 117)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pmt. Tolerance (LCY)"(Field 118)".


        //Unsupported feature: Property Modification (CalcFormula) on "Refunds(Field 120)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Refunds (LCY)"(Field 121)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Other Amounts"(Field 122)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Other Amounts (LCY)"(Field 123)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Outstanding Invoices"(Field 125)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Outstanding Invoices (LCY)"(Field 126)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pay-to No. Of Archived Doc."(Field 130)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Buy-from No. Of Archived Doc."(Field 131)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pay-to No. of Orders"(Field 7181)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pay-to No. of Invoices"(Field 7182)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pay-to No. of Return Orders"(Field 7183)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pay-to No. of Credit Memos"(Field 7184)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Quotes"(Field 7189)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Blanket Orders"(Field 7190)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Orders"(Field 7191)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Invoices"(Field 7192)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Return Orders"(Field 7193)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Credit Memos"(Field 7194)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pay-to No. of Quotes"(Field 7196)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pay-to No. of Blanket Orders"(Field 7197)".


        //Unsupported feature: Code Insertion on ""Phone No."(Field 9)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            IF (STRLEN("Phone No.") > 20) THEN
              ERROR(Text012);
            */
        //end;


        //Unsupported feature: Code Modification on ""VAT Registration No."(Field 86).OnValidate".

        //trigger "(Field 86)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF VATRegNoFormat.Test("VAT Registration No.","Country/Region Code","No.",DATABASE::Vendor) THEN
              IF "VAT Registration No." <> xRec."VAT Registration No." THEN
                VATRegistrationLogMgt.LogVendor(Rec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..3

            TESTFIELD("Vendor Posting Group");
            VendPostingGrp.GET("Vendor Posting Group");
            IF "VAT Registration No." <> '' THEN BEGIN
              IF VendPostingGrp."Check Duplicate VAT Reg. No." THEN
                AgniMgt.CheckDuplicateVATRegNo(DATABASE::Vendor,"VAT Registration No.","No.");
            END;
            */
        //end;


        //Unsupported feature: Code Modification on ""Primary Contact No."(Field 5049).OnValidate".

        //trigger "(Field 5049)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            Contact := '';
            IF "Primary Contact No." <> '' THEN BEGIN
              Cont.GET("Primary Contact No.");
            #4..9
              IF Cont."Company No." <> ContBusRel."Contact No." THEN
                ERROR(Text004,Cont."No.",Cont.Name,"No.",Name);

              IF Cont.Type = Cont.Type::Person THEN
                Contact := Cont.Name
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..12
              IF Cont.Type = Cont.Type::Company THEN
                Contact := Cont.Name
            END;
            */
        //end;
        field(10005;Category;Code[20])
        {
            Description = 'PAY1.0';

            trigger OnLookup()
            var
                NCHLServiceMgt: Codeunit "33019811";
                NCHLOffice: Page "33019830";
                                TempNCHLOffice: Record "33019814";
                                CompanyInfo: Record "79";
            begin
                CompanyInfo.GET;
                IF NOT CompanyInfo."Enable NCHL-NPI Integration" THEN
                  ERROR('NCHL is not enabled.');
                NCHLServiceMgt.getListOfCategory;
                CLEAR(NCHLOffice);
                TempNCHLOffice.RESET;
                TempNCHLOffice.SETCURRENTKEY(Agent);
                TempNCHLOffice.SETRANGE("End to End ID",'TEMPCATEGORY');
                NCHLOffice.SETRECORD(TempNCHLOffice);
                NCHLOffice.SETTABLEVIEW(TempNCHLOffice);
                NCHLOffice.LOOKUPMODE(TRUE);
                COMMIT;
                IF NCHLOffice.RUNMODAL = ACTION::LookupOK THEN BEGIN
                  NCHLOffice.GETRECORD(TempNCHLOffice);
                  Category := TempNCHLOffice.Agent;
                  END;

                TempNCHLOffice.RESET;
                TempNCHLOffice.SETRANGE("End to End ID",'TEMPCATEGORY');
                TempNCHLOffice.DELETEALL;
            end;
        }
        field(10006;"App Id";Code[20])
        {
            Description = 'PAY1.0';

            trigger OnLookup()
            var
                CompanyInfo: Record "79";
                NCHLServiceMgt: Codeunit "33019811";
                NCHLOffice: Page "33019830";
                                TempNCHLOffice: Record "33019814";
            begin
                TESTFIELD(Category);

                CompanyInfo.GET;
                IF NOT CompanyInfo."Enable NCHL-NPI Integration" THEN
                  ERROR('NCHL is not enabled.');

                NCHLServiceMgt.getListOfApps(Category);
                CLEAR(NCHLOffice);
                TempNCHLOffice.RESET;
                TempNCHLOffice.SETCURRENTKEY(Agent);
                TempNCHLOffice.SETRANGE("End to End ID",'TEMPAPPS');
                NCHLOffice.SETRECORD(TempNCHLOffice);
                NCHLOffice.SETTABLEVIEW(TempNCHLOffice);
                NCHLOffice.LOOKUPMODE(TRUE);
                COMMIT;
                IF NCHLOffice.RUNMODAL = ACTION::LookupOK THEN BEGIN
                  NCHLOffice.GETRECORD(TempNCHLOffice);

                  "App Id" := TempNCHLOffice.Agent;
                  "App Group" := TempNCHLOffice.Name;
                  END;

                TempNCHLOffice.RESET;
                TempNCHLOffice.SETRANGE("End to End ID",'TEMPAPPS');
                TempNCHLOffice.DELETEALL;
            end;
        }
        field(10007;"App Group";Text[50])
        {
            Description = 'PAY1.0';
        }
        field(10008;"List of Custom";Text[100])
        {
            Description = 'PAY1.0';

            trigger OnLookup()
            var
                CompanyInfo: Record "79";
                NCHLServiceMgt: Codeunit "33019811";
                NCHLOffice: Page "33019830";
                                TempNCHLOffice: Record "33019814";
            begin
                CompanyInfo.GET;
                IF NOT CompanyInfo."Enable NCHL-NPI Integration" THEN
                  ERROR('NCHL is not enabled.');

                NCHLServiceMgt.getListOfCustom("App Id","App Group");
                CLEAR(NCHLOffice);
                TempNCHLOffice.RESET;
                TempNCHLOffice.SETCURRENTKEY(Agent);
                TempNCHLOffice.SETRANGE("End to End ID",'TEMPCUSTOMOFFICE');
                NCHLOffice.SETRECORD(TempNCHLOffice);
                NCHLOffice.SETTABLEVIEW(TempNCHLOffice);
                NCHLOffice.LOOKUPMODE(TRUE);
                COMMIT;
                IF NCHLOffice.RUNMODAL = ACTION::LookupOK THEN BEGIN
                  NCHLOffice.GETRECORD(TempNCHLOffice);
                  "List of Custom" := TempNCHLOffice.Agent;
                  END;

                TempNCHLOffice.RESET;
                TempNCHLOffice.SETRANGE("End to End ID",'TEMPCUSTOMOFFICE');
                TempNCHLOffice.DELETEALL;
            end;
        }
        field(50000;"Mobile No.";Text[20])
        {

            trigger OnValidate()
            begin
                IF STRLEN("Mobile No.") > 20 THEN
                  ERROR(Text013);
            end;
        }
        field(50010;"Block Credit Memo Posting";Boolean)
        {
            Description = 'Block creating credit memo, specially for foreign vendors';
        }
        field(50011;"Pragyapan Patra Mandatory";Boolean)
        {
            Description = 'Make mandatory for custom clerance agents';
        }
        field(50012;"Import VAT Compulsory";Boolean)
        {
        }
        field(50013;Internal;Boolean)
        {
        }
        field(55000;"TDS Balance";Decimal)
        {
            CalcFormula = Sum("TDS Entry"."TDS Amount" WHERE (Source Type=CONST(Vendor),
                                                              Bill-to/Pay-to No.=FILTER(NO.),
                                                              Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                              Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                              Closed=FIELD(TDS Entry Closed Filter),
                                                              TDS Type=CONST(Purchase TDS),
                                                              Posting Date=FIELD(Date Filter)));
            FieldClass = FlowField;
        }
        field(55001;"TDS Entry Closed Filter";Boolean)
        {
            FieldClass = FlowFilter;
        }
        field(55002;"TDS Balance (Open)";Decimal)
        {
            CalcFormula = Sum("TDS Entry"."TDS Amount" WHERE (Source Type=CONST(Vendor),
                                                              Bill-to/Pay-to No.=FIELD(No.),
                                                              Shortcut Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                              Shortcut Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                              Closed=CONST(No),
                                                              TDS Type=CONST(Purchase TDS),
                                                              Posting Date=FIELD(Date Filter),
                                                              Reversed=CONST(No)));
            FieldClass = FlowField;
        }
        field(33019810;"Vendor Category";Option)
        {
            OptionCaption = ' ,GPD,SPD,VHD,BTD,LBD';
            OptionMembers = " ",GPD,SPD,VHD,BTD,LBD;
        }
        field(33019811;"Vendor Level (SOR)";Code[10])
        {
            TableRelation = "NCHL-NPI Entry";
        }
        field(33019812;"Vendor Product Category";Code[10])
        {
            TableRelation = "Vendor Product Category";
        }
        field(33019961;"Accountability Center";Code[10])
        {
            TableRelation = "Accountability Center";
        }
        field(33019962;"TDS Posting Group";Code[20])
        {
            TableRelation = "TDS Posting Group".Code;
        }
        field(33019963;"Vendor Type";Option)
        {
            Editable = true;
            OptionCaption = ' ,LC,TR Loan,Other Loan';
            OptionMembers = " ",LC,"TR Loan","Other Loan";
        }
        field(33019964;"Interest Rate";Decimal)
        {
            Description = 'For TR Loan @Agni';
        }
        field(33019965;"Maturity Date";Date)
        {
            Description = 'For TR Loan @Agni';
        }
        field(33019966;"Maturity Period";DateFormula)
        {
            Description = 'For TR Loan @Agni';
        }
        field(33019967;"Sys LC No.";Code[20])
        {
            Description = 'For TR Loan @Agni';
            TableRelation = "LC Details".No. WHERE (Transaction Type=FILTER(Purchase),
                                                    Released=FILTER(Yes));
        }
        field(33019968;"Deal Date";Date)
        {
            Description = 'For TR Loan @Agni';
        }
        field(33019969;"Other Loan Type";Code[20])
        {
            TableRelation = "Other Loan Types";
        }
        field(33019970;"Repayment Schedule";Option)
        {
            OptionCaption = ' ,Monthly,Quarterly';
            OptionMembers = " ",Monthly,Quarterly;
        }
        field(33019971;Saved;Boolean)
        {
        }
        field(33019972;Disbursed;Boolean)
        {
        }
        field(33019975;"Province No.";Option)
        {
            OptionCaption = ' ,PROVINCE 1,PROVINCE 2,BAGMATI PROVINCE,GANDAKI PROVINCE,PROVINCE 5,KARNALI PROVINCE,SUDUR PACHIM PROVINCE';
            OptionMembers = " ","PROVINCE 1"," PROVINCE 2"," BAGMATI PROVINCE"," GANDAKI PROVINCE"," PROVINCE 5"," KARNALI PROVINCE"," SUDUR PACHIM PROVINCE";
        }
        field(33019976;"Customer Code";Code[20])
        {
            TableRelation = Customer;
        }
        field(33019977;"Bank Account";Code[20])
        {
            TableRelation = "Bank Account".No.;
        }
    }


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF "No." = '' THEN BEGIN
          PurchSetup.GET;
          PurchSetup.TESTFIELD("Vendor Nos.");
          NoSeriesMgt.InitSeries(PurchSetup."Vendor Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;

        IF "Invoice Disc. Code" = '' THEN
          "Invoice Disc. Code" := "No.";
        #9..12
        DimMgt.UpdateDefaultDim(
          DATABASE::Vendor,"No.",
          "Global Dimension 1 Code","Global Dimension 2 Code");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..5
        //--------@yuran 19-jul-2013 Syncs No. Series in all companies>>
        //AgniMgt.SyncMasterData(DATABASE::Vendor,"No.","No. Series");
        //--------@yuran 19-jul-2013 Syncs No. Series in all companies<<
        #6..15
        */
    //end;


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Last Date Modified" := TODAY;

        IF (Name <> xRec.Name) OR
        #4..27
            IF FIND THEN;
          END;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..30
        IF Saved THEN BEGIN       // << MIN 4/30/2019
          UserSetup.GET(USERID);
          IF NOT UserSetup."Can Edit Vendor Card" THEN
           ERROR(NoModifyPermissionErr);
        END;
        */
    //end;


    //Unsupported feature: Code Modification on "CreateAndShowNewCreditMemo(PROCEDURE 22)".

    //procedure CreateAndShowNewCreditMemo();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Credit Memo";
        PurchaseHeader.SETRANGE("Buy-from Vendor No.","No.");
        PurchaseHeader.INSERT(TRUE);
        COMMIT;
        PAGE.RUN(PAGE::"Purchase Credit Memo",PurchaseHeader)
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..4
        PAGE.RUN(PAGE::"Debit Memo",PurchaseHeader)
        */
    //end;

    //Unsupported feature: Property Modification (Length) on "CreateNewVendor(PROCEDURE 59).VendorName(Parameter 1000)".


    var
        AgniMgt: Codeunit "50000";
        VendPostingGrp: Record "93";
        NoModifyPermissionErr: Label 'You do not have permission to modify vendor card.';
        UserSetup: Record "91";
        Text012: Label 'Phone no. cannot be more than 20 digits.';
        Text013: Label 'Mobile no cannot be more than 20 digits.';
        CompanyInfo: Record "79";
        CIPSWebServiceMgt: Codeunit "33019811";
        CIPSBankList: Page "33019815";
                          TempCIPSBankAccount: Record "33019814";
}


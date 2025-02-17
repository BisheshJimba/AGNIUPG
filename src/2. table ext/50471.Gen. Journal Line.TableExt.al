tableextension 50471 tableextension50471 extends "Gen. Journal Line"
{
    // 30.07.2007. EDMS P2
    //    * Commented lines in trigger Account No. - OnValidate()
    // 
    // 23.07.2007. EDMS P2
    //   * Added functions
    //      GetLedgDim
    //      InsertJournDim
    //   * Added code in trigger
    //      Applies-to Doc. No. - OnLookup()
    // 
    // 22.06.2007. EDMS P2
    //   * Added functions
    //        ApplyLines
    //        UpdateBankCode
    //        SplitDocNo
    //        ExtractDocSer
    //        ExtractDocNo
    //        AppendStr
    // 
    // //03-04-2007 EDMS P3 Cost
    //  Added field Vehicle Cost Group
    //  Changed standart onvalidate code for gen.prod.group and gen.bus.group
    // //16-04-2007 EDMS P3 Obsolete ^
    fields
    {
        modify("Account No.")
        {
            TableRelation = IF (Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting),
                                                                                      Blocked=CONST(No))
                                                                                      ELSE IF (Account Type=CONST(Customer)) Customer
                                                                                      ELSE IF (Account Type=CONST(Vendor)) Vendor
                                                                                      ELSE IF (Account Type=CONST(Bank Account)) "Bank Account"
                                                                                      ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                      ELSE IF (Account Type=CONST(IC Partner)) "IC Partner";
        }
        modify("Document Type")
        {
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund,TDS ';

            //Unsupported feature: Property Modification (OptionString) on ""Document Type"(Field 6)".

        }

        //Unsupported feature: Property Modification (Data type) on "Description(Field 8)".

        modify("Bal. Account No.")
        {
            TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting),
                                                                                           Blocked=CONST(No))
                                                                                           ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                                                                                           ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor
                                                                                           ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account"
                                                                                           ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset"
                                                                                           ELSE IF (Bal. Account Type=CONST(IC Partner)) "IC Partner";
        }
        modify("Bill-to/Pay-to No.")
        {
            TableRelation = IF (Account Type=CONST(Customer)) Customer
                            ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                            ELSE IF (Account Type=CONST(Vendor)) Vendor
                            ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor;
        }
        modify("Posting Group")
        {
            TableRelation = IF (Account Type=CONST(Customer)) "Customer Posting Group"
                            ELSE IF (Account Type=CONST(Vendor)) "Vendor Posting Group"
                            ELSE IF (Account Type=CONST(Fixed Asset)) "FA Posting Group";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Allocated Amt. (LCY)"(Field 56)".

        modify("Bank Payment Type")
        {
            OptionCaption = ' ,Computer Check,Manual Check,NCHL';

            //Unsupported feature: Property Modification (OptionString) on ""Bank Payment Type"(Field 70)".

        }
        modify("Source No.")
        {
            TableRelation = IF (Source Type=CONST(Customer)) Customer
                            ELSE IF (Source Type=CONST(Vendor)) Vendor
                            ELSE IF (Source Type=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Source Type=CONST(Fixed Asset)) "Fixed Asset";
        }
        modify("Ship-to/Order Address Code")
        {
            TableRelation = IF (Account Type=CONST(Customer)) "Ship-to Address".Code WHERE (Customer No.=FIELD(Bill-to/Pay-to No.))
                            ELSE IF (Account Type=CONST(Vendor)) "Order Address".Code WHERE (Vendor No.=FIELD(Bill-to/Pay-to No.))
                            ELSE IF (Bal. Account Type=CONST(Customer)) "Ship-to Address".Code WHERE (Customer No.=FIELD(Bill-to/Pay-to No.))
                            ELSE IF (Bal. Account Type=CONST(Vendor)) "Order Address".Code WHERE (Vendor No.=FIELD(Bill-to/Pay-to No.));
        }
        modify("Sell-to/Buy-from No.")
        {
            TableRelation = IF (Account Type=CONST(Customer)) Customer
                            ELSE IF (Bal. Account Type=CONST(Customer)) Customer
                            ELSE IF (Account Type=CONST(Vendor)) Vendor
                            ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor;
        }
        modify("Recipient Bank Account")
        {
            TableRelation = IF (Account Type=CONST(Customer)) "Customer Bank Account".Code WHERE (Customer No.=FIELD(Account No.))
                            ELSE IF (Account Type=CONST(Vendor)) "Vendor Bank Account".Code WHERE (Vendor No.=FIELD(Account No.))
                            ELSE IF (Bal. Account Type=CONST(Customer)) "Customer Bank Account".Code WHERE (Customer No.=FIELD(Bal. Account No.))
                            ELSE IF (Bal. Account Type=CONST(Vendor)) "Vendor Bank Account".Code WHERE (Vendor No.=FIELD(Bal. Account No.));
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Has Payment Export Error"(Field 291)".



        //Unsupported feature: Code Modification on ""Account No."(Field 4).OnValidate".

        //trigger "(Field 4)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "Account No." <> xRec."Account No." THEN BEGIN
              ClearAppliedAutomatically;
              VALIDATE("Job No.",'');
            #4..10
              EXIT;
            END;

            CASE "Account Type" OF
              "Account Type"::"G/L Account":
                GetGLAccount;
            #17..38

            VALIDATE("IC Partner G/L Acc. No.",GetDefaultICPartnerGLAccNo);
            ValidateApplyRequirements(Rec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            CheckLCMandatory; //Agile CP 15 Feb 2017
            #1..13
            Description := '';

            #14..41
            */
        //end;


        //Unsupported feature: Code Modification on ""Bal. Account No."(Field 11).OnValidate".

        //trigger  Account No()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            VALIDATE("Job No.",'');

            IF xRec."Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,
            #4..52

            VALIDATE("IC Partner G/L Acc. No.",GetDefaultICPartnerGLAccNo);
            ValidateApplyRequirements(Rec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            CheckLCMandatory; //Agile CP 15 Feb 2017
            #1..55
            */
        //end;


        //Unsupported feature: Code Modification on "Amount(Field 13).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            GetCurrency;
            IF "Currency Code" = '' THEN
              "Amount (LCY)" := Amount
            #4..34
              CreateTempJobJnlLine;
              UpdatePricesFromJobJnlLine;
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..37


            CalculateTDSAmount; //TDS2.00
            TestfieldLoanPostingType; //Agile Cp 16 Fen 2017
            */
        //end;


        //Unsupported feature: Code Modification on ""Debit Amount"(Field 14).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            GetCurrency;
            "Debit Amount" := ROUND("Debit Amount",Currency."Amount Rounding Precision");
            Correction := "Debit Amount" < 0;
            Amount := "Debit Amount";
            VALIDATE(Amount);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..5

            CalculateTDSAmount; //TDS2.00
            TestfieldLoanPostingType; //Agile Cp 16 Fen 2017
            */
        //end;


        //Unsupported feature: Code Modification on ""Credit Amount"(Field 15).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            GetCurrency;
            "Credit Amount" := ROUND("Credit Amount",Currency."Amount Rounding Precision");
            Correction := "Credit Amount" < 0;
            Amount := -"Credit Amount";
            VALIDATE(Amount);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..5


            CalculateTDSAmount; //TDS2.00
            TestfieldLoanPostingType; //Agile Cp 16 Fen 2017
            */
        //end;


        //Unsupported feature: Code Modification on ""Applies-to Doc. No."(Field 36).OnValidate".

        //trigger  No()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "Applies-to Doc. No." <> xRec."Applies-to Doc. No." THEN
              ClearCustVendApplnEntry;

            #4..60

            ValidateApplyRequirements(Rec);
            SetJournalLineFieldsFromApplication;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..63
            //08.04.2014 Elva Baltic P1 #RX MMG7.00 >>
            SetDefSalesperson;
            //08.04.2014 Elva Baltic P1 #RX MMG7.00 <<
            */
        //end;


        //Unsupported feature: Code Modification on ""VAT Amount"(Field 44).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
            GenJnlBatch.TESTFIELD("Allow VAT Difference",TRUE);
            IF NOT ("VAT Calculation Type" IN
            #4..41

            UpdateSalesPurchLCY;

            IF JobTaskIsSet THEN BEGIN
              CreateTempJobJnlLine;
              UpdatePricesFromJobJnlLine;
            END;

            IF "Deferral Code" <> '' THEN
              VALIDATE("Deferral Code");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..44
            CalculateTDSAmount; //TDS2.00

            #45..51
            */
        //end;
        field(10000;"CIPS Category Purpose";Code[30])
        {
            Description = 'NCHL-NPI_1.00';
            TableRelation = "NCHL-NPI Category Purpose";
        }
        field(10001;"Bank Account Code";Code[20])
        {
            Description = 'NCHL-NPI_1.00';
            TableRelation = IF (Account Type=CONST(Vendor)) "Vendor Bank Account".Code WHERE (Vendor No.=FIELD(Account No.))
                            ELSE IF (Account Type=CONST(Customer)) "Customer Bank Account".Code WHERE (Customer No.=FIELD(Account No.))
                            ELSE IF (Document Class=CONST(Vendor)) "Vendor Bank Account".Code
                            ELSE IF (Document Class=CONST(Employee)) "Employee Bank Account".Code WHERE (Employee No.=FIELD(Document Subclass));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                IF ("Bank Account Code" <> '') AND ("Account Type" <> "Account Type"::Customer) THEN BEGIN
                  IF ("Account Type" <> "Account Type"::"G/L Account") AND ("Document Class" = "Document Class"::" ") THEN
                     TESTFIELD("Account Type","Account Type"::Vendor);
                END;
            end;
        }
        field(10002;Status;Option)
        {
            OptionCaption = 'Open,Approved,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Approved,"Pending Approval","Pending Prepayment";
        }
        field(10005;"Pre-Assigned No.";Code[20])
        {
            Description = 'NCHL-NPI_1.00';
        }
        field(10006;"Registration Year";Code[4])
        {
            Description = 'NPI-DOCS1.00';
            Numeric = true;
        }
        field(10007;"Registration No.";Code[35])
        {
            Description = 'NPI-DOCS1.00';
        }
        field(10009;"Payment Types";Option)
        {
            OptionMembers = " ",IRD,CIT,Custom;
        }
        field(10010;"Registration Serial";Code[5])
        {
            Description = 'PAY1.0';

            trigger OnLookup()
            var
                NCHLServiceMgt: Codeunit "33019811";
                NCHLOffice: Page "33019814";
                                TempNCHLOffice: Record "33019814";
                                CompanyInfo: Record "79";
            begin
                CompanyInfo.GET;
                IF NOT CompanyInfo."Enable NCHL-NPI Integration" THEN
                  ERROR('NCHL is not enabled.');

                NCHLServiceMgt.getListOfRegistrationSerial;
                CLEAR(NCHLOffice);
                TempNCHLOffice.RESET;
                TempNCHLOffice.SETCURRENTKEY(Agent);
                TempNCHLOffice.SETRANGE("End to End ID",'TEMPREDGSERIAL');
                NCHLOffice.SETRECORD(TempNCHLOffice);
                NCHLOffice.SETTABLEVIEW(TempNCHLOffice);
                NCHLOffice.LOOKUPMODE(TRUE);
                COMMIT;
                IF NCHLOffice.RUNMODAL = ACTION::LookupOK THEN BEGIN
                  NCHLOffice.GETRECORD(TempNCHLOffice);
                  "Registration Serial" := TempNCHLOffice.Agent;
                  END;

                TempNCHLOffice.RESET;
                TempNCHLOffice.SETRANGE("End to End ID",'TEMPREDGSERIAL');
                TempNCHLOffice.DELETEALL;
            end;
        }
        field(10011;"Custom Office";Code[20])
        {
            Description = 'PAY1.0';
        }
        field(10012;"Ref Id";Text[30])
        {
            Description = 'IRD,CIT Submission No.';

            trigger OnValidate()
            begin
                IF "Ref Id" <> '' THEN
                  TESTFIELD("Payment Types");
            end;
        }
        field(10014;"Office Code";Text[30])
        {
            Description = 'CIT';

            trigger OnValidate()
            begin
                IF "Office Code" <> '' THEN
                  TESTFIELD("Payment Types");
            end;
        }
        field(50000;"Cheque No.";Code[30])
        {
        }
        field(50001;"Document Class";Option)
        {
            Caption = 'Document Class';
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Assets,Employee';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Assets",Employee;

            trigger OnValidate()
            begin
                //chandra 01.09.2015 to avoid errors e.g. if user select vendor in document class after selecting Customer No. in Document subclass
                VALIDATE("Document Subclass",'');
            end;
        }
        field(50002;"Document Subclass";Code[20])
        {
            Caption = 'Document Subclass';
            TableRelation = IF (Document Class=CONST(Customer)) Customer
                            ELSE IF (Document Class=CONST(Vendor)) Vendor
                            ELSE IF (Document Class=CONST(Bank Account)) "Bank Account"
                            ELSE IF (Document Class=CONST(Fixed Assets)) "Fixed Asset"
                            ELSE IF (Document Class=CONST(Employee)) Employee;

            trigger OnValidate()
            begin
                IF "Document Class"= "Document Class"::Employee THEN
                  //VALIDATE() //sp
            end;
        }
        field(50003;"Account Name";Text[70])
        {
            Editable = false;
        }
        field(50004;"Sales Order No.";Code[20])
        {
            TableRelation = "Sales Header".No. WHERE (Document Type=CONST(Order),
                                                      Document Profile=CONST(Vehicles Trade));
        }
        field(50005;"VIN - COGS";Code[20])
        {
            TableRelation = Vehicle.VIN;

            trigger OnLookup()
            begin
                recVehicle.RESET;
                IF LookUpMgt.LookUpVehicleAMT(recVehicle,"Vehicle Serial No.") THEN
                 BEGIN
                  //VALIDATE("Vehicle Serial No.",recVehicle."Serial No.");
                  "VIN - COGS" := recVehicle.VIN;
                 END;
            end;
        }
        field(50006;"Created by";Code[50])
        {
            Editable = false;
        }
        field(50007;"Narration 2";Text[200])
        {
        }
        field(50008;"Payment Type";Code[10])
        {
        }
        field(50009;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            Description = 'NP15.1001';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(50055;"Invertor Serial No.";Code[20])
        {
            Caption = 'Invertor Serial No.';
            TableRelation = "Serial No. Information"."Serial No.";
        }
        field(50097;"COGS Type";Option)
        {
            Description = 'Used for Alternative of way of Item Charge';
            OptionCaption = ' ,ACCESSORIES-CV,ACCESSORIES-PC,BANK CHARGE-CV,BANK CHARGE-PC,BATTERY-CV,BATTERY-PC,BODY BUILDING-CV,BODY BUILDING-PC,CHASSIS REGISTR-CV,CHASSIS REGISTR-PC,CLEARING & FORW-CV,CLEARING & FORW-PC,CUSTOM DUTY-CV,CUSTOM DUTY-PC,DENT / PENT-CV,DENT / PENT-PC,DRIVER-CV,DRIVER-PC,FOREIGN CHARGE-CV,FOREIGN CHARGE-PC,FUEL & OIL-CV,FUEL & OIL-PC,INSURANCE MANAG-CV,INSURANCE MANAG-PC,INSURANCE-CV,INSURANCE-PC,,L/C & BANK CHAR-CV,L/C & BANK CHAR-PC,LUBRICANTS-CV,LUBRICANTS-PC,NEW CHASSIS REP-CV,NEW CHASSIS REP-PC,PARKING CHARGE-CV,PARKING CHARGE-PC,PRAGYANPAN-CV,PRAGYANPAN-PC,SERVICE CHARGE-CV,SERVICE CHARGE-PC,SPARES-CV,SPARES-PC,TRANSPORTATION-CV,TRANSPORTATION-PC,VEHICLE LOGISTI-CV,VEHICLE LOGISTI-PC,VEHICLE TAX-CV,VEHICLE TAX-PC';
            OptionMembers = " ","ACCESSORIES-CV","ACCESSORIES-PC","BANK CHARGE-CV","BANK CHARGE-PC","BATTERY-CV","BATTERY-PC","BODY BUILDING-CV","BODY BUILDING-PC","CHASSIS REGISTR-CV","CHASSIS REGISTR-PC","CLEARING & FORW-CV","CLEARING & FORW-PC","CUSTOM DUTY-CV","CUSTOM DUTY-PC","DENT / PENT-CV","DENT / PENT-PC","DRIVER-CV","DRIVER-PC","FOREIGN CHARGE-CV","FOREIGN CHARGE-PC","FUEL & OIL-CV","FUEL & OIL-PC","INSURANCE MANAG-CV","INSURANCE MANAG-PC","INSURANCE-CV","INSURANCE-PC",,"L/C & BANK CHAR-CV","L/C & BANK CHAR-PC","LUBRICANTS-CV","LUBRICANTS-PC","NEW CHASSIS REP-CV","NEW CHASSIS REP-PC","PARKING CHARGE-CV","PARKING CHARGE-PC","PRAGYANPAN-CV","PRAGYANPAN-PC","SERVICE CHARGE-CV","SERVICE CHARGE-PC","SPARES-CV","SPARES-PC","TRANSPORTATION-CV","TRANSPORTATION-PC","VEHICLE LOGISTI-CV","VEHICLE LOGISTI-PC","VEHICLE TAX-CV","VEHICLE TAX-PC";
        }
        field(50099;"Sales Invoice No.";Code[20])
        {
            TableRelation = "Sales Invoice Header".No.;

            trigger OnLookup()
            var
                SalesInvHeader: Record "112";
                SalesInvList: Page "50018";
                                  InvHeader: Record "112";
            begin
                CLEAR(SalesInvList);
                IF "Sales Invoice No." <> '' THEN
                 IF SalesInvHeader.GET("Sales Invoice No.") THEN
                  SalesInvList.SETRECORD(SalesInvHeader);
                SalesInvList.SETTABLEVIEW(SalesInvHeader);
                SalesInvList.LOOKUPMODE(TRUE);
                IF SalesInvList.RUNMODAL = ACTION::LookupOK THEN
                 BEGIN
                  SalesInvList.GETRECORD(SalesInvHeader);
                  VALIDATE("Sales Invoice No.",SalesInvHeader."No.");
                 END;
            end;

            trigger OnValidate()
            var
                UserSetup2: Record "91";
                SalesInvHeader: Record "112";
                Text000: Label 'You are not authorised to post multiple commission for same Invoice.';
                Text001: Label 'Commission for Invoice %1 has already been posted. Do you want to proceed again?';
                Text002: Label 'Process cancelled by user.';
                InvHeader: Record "112";
            begin
                /*UserSetup2.GET(USERID);
                SalesInvHeader.GET("Sales Invoice No.");
                IF SalesInvHeader."Commission Posted" THEN BEGIN
                  IF NOT UserSetup2."Allow Post.Multiple Commission" THEN
                    ERROR(Text000)
                  ELSE
                    IF NOT CONFIRM(Text001,FALSE,SalesInvHeader."No.") THEN BEGIN
                      "Sales Invoice No." := '';
                    END;
                END;
                */
                InvHeader.RESET;
                InvHeader.SETRANGE("No.","Sales Invoice No.");
                IF InvHeader.FINDFIRST THEN
                  InvHeader.CALCFIELDS("VIN - Vehicle Sales");
                VALIDATE(VIN,InvHeader."VIN - Vehicle Sales");

            end;
        }
        field(50100;"Cheque Type";Option)
        {
            Description = 'CNY1.0';
            OptionCaption = ' ,A/C Payee,& Co.,Bearer ';
            OptionMembers = " ","A/C Payee","& Co.","Bearer ";
        }
        field(50505;"Serial No.";Code[20])
        {
            TableRelation = "Service Item";
        }
        field(50602;"Payroll Reversed";Boolean)
        {
        }
        field(51020;Intransit;Boolean)
        {
        }
        field(59000;"TDS Group";Code[20])
        {
            TableRelation = "TDS Posting Group";

            trigger OnValidate()
            begin
                CalculateTDSAmount; //TDS2.00
            end;
        }
        field(59001;"TDS%";Decimal)
        {
            Editable = false;
        }
        field(59002;"TDS Type";Option)
        {
            Editable = false;
            OptionCaption = ' ,Purchase TDS,Sales TDS';
            OptionMembers = " ","Purchase TDS","Sales TDS";
        }
        field(59003;"TDS Amount";Decimal)
        {
            Editable = false;
        }
        field(59004;"TDS Base Amount";Decimal)
        {
            Editable = false;
        }
        field(59007;"TDS Line";Boolean)
        {
        }
        field(59050;"Commercial Invoice No";Code[20])
        {
            Caption = 'Commercial Invoice No';
            TableRelation = "Commercial Invoice Header".No WHERE (Sys. LC No.=FIELD(Sys. LC No.));

            trigger OnValidate()
            begin
                //Agile CP 16 Feb 2017
                TESTFIELD("Sys. LC No.");
                CheckCommericalInvOutstanding;
                //Agile CP 16 Feb 2017
            end;
        }
        field(59055;"Loan Posting Type";Option)
        {
            OptionMembers = " ","Loan Invoice","Loan Payment","Loan Interest Charges";

            trigger OnValidate()
            begin
                TestfieldLoanPostingType; //Agile Cp 16 Fen 2017
                CheckCommericalInvOutstanding;
            end;
        }
        field(70071;"Procument Memo No.";Code[20])
        {
            Description = 'Procument Memo';
        }
        field(80004;"Receipt Type";Option)
        {
            OptionCaption = ' ,Booking,Part Payment,Retention Amount,Finance Amount,Invoice,Installment,Deposit,Tendor Amount,LC Amount,Cheque Returned,VF Payment,Advance,Inter-Party Journal';
            OptionMembers = " ",Booking,"Part Payment","Retention Amount","Finance Amount",Invoice,Installment,Deposit,"Tendor Amount","LC Amount","Cheque Returned","VF Payment",Advance,"Inter-Party Journal";
        }
        field(80023;"Loan Installment No.";Integer)
        {
        }
        field(80024;"Loan Clear Entry";Boolean)
        {
        }
        field(90001;"Transaction Date";Date)
        {
        }
        field(90002;"Cost Type";Option)
        {
            OptionCaption = ' ,Fixed Cost,Variable Cost';
            OptionMembers = " ","Fixed Cost","Variable Cost";
        }
        field(90003;"Is From Sugg Vendor";Boolean)
        {
        }
        field(25006001;VIN;Code[20])
        {
            Caption = 'VIN';

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
            begin
                recVehicle.RESET;
                IF cuLookUpMgt.LookUpVehicleAMT(recVehicle,VIN) THEN
                 BEGIN
                  VALIDATE(VIN,recVehicle.VIN);
                 END;
            end;

            trigger OnValidate()
            var
                recSalesLine: Record "37";
                tcAMT001: Label 'This VIN is being used in %1. Are you shore that you want to use exactly this VIN?';
                Vehicle: Record "25006005";
                tcAMT002: Label 'Serial No. in Vehicle table differs from Serial No. in Sales Line.';
            begin
                IF VIN <> '' THEN
                 BEGIN
                  Vehicle.RESET;
                  Vehicle.SETCURRENTKEY(VIN);
                  Vehicle.SETRANGE(VIN, VIN);
                  IF Vehicle.FINDFIRST THEN BEGIN
                    VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
                    VALIDATE("Make Code",Vehicle."Make Code");
                  END;
                 END
                ELSE
                 BEGIN
                  VALIDATE("Vehicle Serial No.",'');
                  VALIDATE("Make Code",'');
                 END;
            end;
        }
        field(25006002;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006003;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(25006004;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=CONST(Model Version));

            trigger OnLookup()
            var
                recItem: Record "27";
            begin
                /*recItem.RESET;
                IF cuLookUpMgt.fLookUpModelVersion(recItem,"Model Version No.","Make Code","Model Code") THEN
                 VALIDATE("Model Version No.",recItem."No.");
                 */

            end;

            trigger OnValidate()
            begin
                //VALIDATE("Item No.","Model Version No.");
            end;
        }
        field(25006050;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No';
            TableRelation = Vehicle."Serial No.";

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
                vehi: Record "33019823";
            begin
                IF "Vehicle Serial No." = '' THEN BEGIN
                 VALIDATE("Vehicle Accounting Cycle No.",'');
                 "Vehicle Registration No." := '';
                END ELSE BEGIN
                  IF Vehicle.GET("Vehicle Serial No.") THEN BEGIN
                    "Vehicle Registration No." := Vehicle."Registration No.";
                    IF vehi.GET("Vehicle Serial No.") THEN;
                    vehi.CALCFIELDS("Default Vehicle Acc. Cycle No.");
                    VALIDATE("Vehicle Accounting Cycle No.",vehi."Default Vehicle Acc. Cycle No.");
                  END;
                END;
            end;
        }
        field(25006051;"G/L Entry To Close (Veh. Cost)";Integer)
        {
            BlankZero = true;
            Caption = 'G/L Entry To Close (Veh. Cost)';
            Description = 'Vehicle Cost Support';
            TableRelation = "G/L Entry";
        }
        field(25006170;"Vehicle Registration No.";Code[50])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;

            trigger OnLookup()
            begin
                OnLookupVehicleRegistrationNo;
            end;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
            begin
                IF "Vehicle Registration No." = '' THEN BEGIN
                  VALIDATE("Vehicle Serial No.",'');
                  EXIT;
                END;

                Vehicle.RESET;
                Vehicle.SETCURRENTKEY("Registration No.");
                Vehicle.SETRANGE("Registration No.","Vehicle Registration No.");
                IF Vehicle.FINDFIRST THEN BEGIN
                  IF "Vehicle Serial No." <> Vehicle."Serial No." THEN
                    VALIDATE("Vehicle Serial No.",Vehicle."Serial No.")
                END ELSE
                  MESSAGE(STRSUBSTNO(Text100, "Vehicle Registration No."), '');
            end;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(33020011;"Sys. LC No.";Code[20])
        {
            TableRelation = IF (Account Type=CONST(Customer),
                                Credit Type=CONST(LC)) "LC Details".No. WHERE (Closed=CONST(No),
                                                                               Released=CONST(Yes),
                                                                               Issued To/Received From=FIELD(Account No.),
                                                                               Type=CONST(LC))
                                                                               ELSE IF (Account Type=CONST(G/L Account)) "LC Details".No.
                                                                               ELSE IF (Account Type=CONST(Vendor)) "LC Details".No. WHERE (Transaction Type=CONST(Purchase),
                                                                                                                                            Closed=CONST(No),
                                                                                                                                            Released=CONST(Yes))
                                                                                                                                            ELSE IF (Account Type=CONST(Customer),
                                                                                                                                                     Credit Type=CONST(BG)) "LC Details".No. WHERE (Closed=CONST(No),
                                                                                                                                                                                                    Released=CONST(Yes),
                                                                                                                                                                                                    Issued To/Received From=FIELD(Account No.),
                                                                                                                                                                                                    Type=CONST(BG));

            trigger OnValidate()
            var
                LCAmendDetail: Record "33020013";
                LCDetail: Record "33020012";
                Text33020011: Label 'LC Amendment is not released.';
                Text33020012: Label 'LC Amendment is closed.';
                Text33020013: Label 'LC Details is not released.';
                Text33020014: Label 'LC Details is closed.';
            begin
                CheckLCMandatory; //Agile CP 15 Feb 2017
                //Code to check for LC Amendment and insert Bank LC No. and LC Amend No. (LC Version No.) if LC is amended atleast once.
                LCAmendDetail.RESET;
                LCAmendDetail.SETRANGE("No.","Sys. LC No.");
                IF LCAmendDetail.FIND('+') THEN BEGIN
                  IF NOT LCAmendDetail.Closed THEN BEGIN
                    IF LCAmendDetail.Released THEN BEGIN
                      "Bank LC No." := LCAmendDetail."Bank Amended No.";
                      "LC Amend No." := LCAmendDetail."Version No.";
                    END ELSE
                      ERROR(Text33020011);
                  END ELSE
                    ERROR(Text33020012);
                END ELSE BEGIN
                  LCDetail.RESET;
                  LCDetail.SETRANGE("No.","Sys. LC No.");
                  IF LCDetail.FIND('-') THEN BEGIN
                    IF NOT LCDetail.Closed THEN BEGIN
                      IF LCDetail.Released THEN BEGIN
                        "Bank LC No." := LCDetail."LC\DO No.";
                      IF LCDetail.Type = LCDetail.Type::BG THEN
                        "Credit Type" := "Credit Type"::BG;
                      IF LCDetail.Type = LCDetail.Type::LC THEN
                        "Credit Type" := "Credit Type"::LC;
                      END ELSE
                        ERROR(Text33020013);
                    END ELSE
                      ERROR(Text33020014);
                  END;
                END;
            end;
        }
        field(33020012;"Bank LC No.";Code[20])
        {
        }
        field(33020013;"LC Amend No.";Code[20])
        {
            Editable = false;
        }
        field(33020017;"Financed By";Code[20])
        {
            Description = 'Financed Bank';
            TableRelation = Contact;
        }
        field(33020018;"Re-Financed By";Code[20])
        {
            Description = 'To Account';
            TableRelation = Contact;
        }
        field(33020019;"Financed Amount";Decimal)
        {
        }
        field(33020062;"VF Loan File No.";Code[20])
        {
            Description = 'Vehicle Finance Loan File Number';
            TableRelation = "Vehicle Finance Header";
        }
        field(33020063;"VF Posting Type";Option)
        {
            OptionCaption = ' ,Principal,Interest,Penalty,Service Charge,Insurance,Other Charges,Prepayment,Insurance Interest,Interest on CAD,Capitalization';
            OptionMembers = " ",Principal,Interest,Penalty,"Service Charge",Insurance,"Other Charges",Prepayment,"Insurance Interest","Interest on CAD",Capitalization;
        }
        field(33020064;"VF Loan Disburse Entry";Boolean)
        {
        }
        field(33020065;Narration;Text[210])
        {
        }
        field(33020066;"Import Invoice No.";Code[20])
        {
        }
        field(33020067;"VF Installment No.";Integer)
        {
        }
        field(33020068;"Pre Assigned No.";Code[20])
        {
        }
        field(33020240;"Exempt Purchase No.";Code[20])
        {
            TableRelation = "Exempt Purchase Nos.";
        }
        field(33020241;"Salary Error Line No.";Integer)
        {
        }
        field(33020242;"Scheme Code";Code[20])
        {
            TableRelation = "Service Scheme Header";
        }
        field(33020243;"Membership No.";Code[20])
        {
            TableRelation = "Membership Details";
        }
        field(33020249;"Service Order No.";Code[20])
        {
            Description = 'Used for External Service Order';
            Editable = true;
            TableRelation = "Posted Serv. Order Header";
            ValidateTableRelation = false;
        }
        field(33020250;"Loan File No.";Code[20])
        {
            Description = 'Vehicle Finance Loan File Number';
            TableRelation = "Vehicle Finance Header";
        }
        field(33020251;"Loan Disburse Entry";Boolean)
        {
        }
        field(33020252;"VF Loan Clear Entry";Boolean)
        {
        }
        field(33020253;"Trace ID/Ref ID";Text[120])
        {
            Description = 'SRT';
        }
        field(33020254;"Credit Type";Option)
        {
            OptionCaption = ' ,BG,LC,Normal';
            OptionMembers = " ",BG,LC,Normal;

            trigger OnValidate()
            begin
                IF "Credit Type" <> xRec."Credit Type" THEN
                  CLEAR("Sys. LC No.");
            end;
        }
        field(33020255;"Receipt Against";Option)
        {
            OptionCaption = 'Normal,LC,BG';
            OptionMembers = Normal,LC,BG;
        }
        field(33020256;"Ship-to Code";Code[10])
        {
            Caption = 'Ship-to Code';

            trigger OnValidate()
            var
                ShipToAddr: Record "222";
            begin
            end;
        }
        field(33020257;"Ship-to Address";Text[50])
        {
            Caption = 'Ship-to Address';
        }
        field(33020258;"Ship-to Address 2";Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(33020259;"Ship-to City";Text[30])
        {
            Caption = 'Ship-to City';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(33020260;"Ship-to Country";Text[30])
        {
        }
        field(33020261;"Province No.";Option)
        {
            OptionCaption = ' ,Province 1, Province 2, Bagmati Province, Gandaki Province, Province 5, Karnali Province, Sudur Pachim Province ';
            OptionMembers = " ","Province 1"," Province 2"," Bagmati Province"," Gandaki Province"," Province 5"," Karnali Province"," Sudur Pachim Province";
        }
        field(33020262;"Localized VAT Identifier";Option)
        {
            Description = 'VAT1.00';
            OptionCaption = ' ,Taxable Import Purchase,Exempt Purchase,Taxable Local Purchase,Taxable Capex Purchase,Taxable Sales,Non Taxable Sales,Exempt Sales';
            OptionMembers = " ","Taxable Import Purchase","Exempt Purchase","Taxable Local Purchase","Taxable Capex Purchase","Taxable Sales","Non Taxable Sales","Exempt Sales";
        }
    }


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        GenJnlAlloc.LOCKTABLE;
        LOCKTABLE;
        GenJnlTemplate.GET("Journal Template Name");
        GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
        "Posting No. Series" := GenJnlBatch."Posting No. Series";
        "Check Printed" := FALSE;

        ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..6
        "Created by" := USERID;
        ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
        */
    //end;


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        TESTFIELD("Check Printed",FALSE);
        IF ("Applies-to ID" = '') AND (xRec."Applies-to ID" <> '') THEN
          ClearCustVendApplnEntry;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        TESTFIELD("Check Printed",FALSE);
        //TESTFIELD(Status,Status::Open); //NCHL-NPI_1.00;
        IF ("Applies-to ID" = '') AND (xRec."Applies-to ID" <> '') THEN
          ClearCustVendApplnEntry;
        */
    //end;


    //Unsupported feature: Code Modification on "SetUpNewLine(PROCEDURE 9)".

    //procedure SetUpNewLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        GenJnlTemplate.GET("Journal Template Name");
        GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
        GenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
        #4..6
          "Document Date" := LastGenJnlLine."Posting Date";
          "Document No." := LastGenJnlLine."Document No.";
          IF BottomLine AND
             (Balance - LastGenJnlLine."Balance (LCY)" = 0) AND
             NOT LastGenJnlLine.EmptyLine
          THEN
            IncrementDocumentNo;
        #14..43
        Description := '';
        IF GenJnlBatch."Suggest Balancing Amount" THEN
          SuggestBalancingAmount(LastGenJnlLine,BottomLine);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..9
             (Balance - (LastGenJnlLine."Balance (LCY)" - LastGenJnlLine."TDS Amount") = 0) AND //TDS2.00
        #11..46
        */
    //end;


    //Unsupported feature: Code Modification on "UpdateDescription(PROCEDURE 43)".

    //procedure UpdateDescription();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF NOT IsAdHocDescription THEN
          Description := Name;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        IF NOT IsAdHocDescription THEN BEGIN
          Description := Name;
          "Account Name" := Name;
        END;
        */
    //end;


    //Unsupported feature: Code Modification on "CopyFromGenJnlAllocation(PROCEDURE 113)".

    //procedure CopyFromGenJnlAllocation();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Account No." := GenJnlAlloc."Account No.";
        "Shortcut Dimension 1 Code" := GenJnlAlloc."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := GenJnlAlloc."Shortcut Dimension 2 Code";
        #4..17
        "Source Currency Amount" := GenJnlAlloc."Additional-Currency Amount";
        Amount := GenJnlAlloc.Amount;
        "Amount (LCY)" := GenJnlAlloc.Amount;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..20
        //ASPL >>
        "Document Class" := GenJnlAlloc."Document Class";
        "Document Subclass" := GenJnlAlloc."Document Subclass";
        //ASPL <<
        */
    //end;


    //Unsupported feature: Code Modification on "CopyFromInvoicePostBuffer(PROCEDURE 112)".

    //procedure CopyFromInvoicePostBuffer();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Account No." := InvoicePostBuffer."G/L Account";
        "System-Created Entry" := InvoicePostBuffer."System-Created Entry";
        "Gen. Bus. Posting Group" := InvoicePostBuffer."Gen. Bus. Posting Group";
        #4..21
        "VAT Amount" := InvoicePostBuffer."VAT Amount";
        "Source Curr. VAT Amount" := InvoicePostBuffer."VAT Amount (ACY)";
        "VAT Difference" := InvoicePostBuffer."VAT Difference";
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..24

        //SS1.00
        "Scheme Code" := InvoicePostBuffer."Scheme Code";
        "Membership No." := InvoicePostBuffer."Membership No.";
        //SS1.00


        "VIN - COGS" := InvoicePostBuffer."VIN - COGS";
        "Vehicle Serial No." := InvoicePostBuffer."Vehicle Serial No."; //suman
        "Vehicle Accounting Cycle No." := InvoicePostBuffer."Vehicle Accounting Cycle No.";  //suman
        //**SM 25 10 2013 to flow document class and subclass in gen jnl lines
        "Document Class" := InvoicePostBuffer."Document Class";
        "Document Subclass" := InvoicePostBuffer."Document Subclass";
        //**SM 25 10 2013 to flow document class and subclass in gen jnl lines

        "Cost Type" := InvoicePostBuffer."Cost Type";

        //TDS2.00
        "TDS Group" := InvoicePostBuffer."TDS Group";
        "TDS%" := InvoicePostBuffer."TDS%";
        "TDS Type" := InvoicePostBuffer."TDS Type";
        "TDS Amount" := InvoicePostBuffer."TDS Amount";
        "TDS Base Amount" := InvoicePostBuffer."TDS Base Amount";
        //TDS2.00
        "Localized VAT Identifier" := InvoicePostBuffer."Localized VAT Identifier";//aakrista
        */
    //end;


    //Unsupported feature: Code Modification on "CopyFromPurchHeader(PROCEDURE 109)".

    //procedure CopyFromPurchHeader();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Source Currency Code" := PurchHeader."Currency Code";
        "Currency Factor" := PurchHeader."Currency Factor";
        Correction := PurchHeader.Correction;
        #4..12
        "Ship-to/Order Address Code" := PurchHeader."Order Address Code";
        "Salespers./Purch. Code" := PurchHeader."Purchaser Code";
        "On Hold" := PurchHeader."On Hold";
        IF "Account Type" = "Account Type"::Vendor THEN
          "Posting Group" := PurchHeader."Vendor Posting Group";
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..15
        "Service Order No." := PurchHeader."Service Order No."; //Min 6/20/2019
        IF "Account Type" = "Account Type"::Vendor THEN
          "Posting Group" := PurchHeader."Vendor Posting Group";

        //LC6.1.0 >>
        "Sys. LC No." := PurchHeader."Sys. LC No.";
        "Bank LC No." := PurchHeader."Bank LC No.";
        "LC Amend No." := PurchHeader."LC Amend No.";
        "Exempt Purchase No." := PurchHeader."Purch. VAT No.";
        //LC6.1.0 >>
        "Import Invoice No." := PurchHeader."Import Invoice No.";

        //RL 7/23/19  >> to flow narration to GL
        Narration := PurchHeader.Narration;
        //"Cost Type" := PurchHeader."Cost Type";

        "Procument Memo No." := PurchHeader."Procument Memo No."; //PM1.0
        */
    //end;


    //Unsupported feature: Code Modification on "CopyFromSalesHeader(PROCEDURE 103)".

    //procedure CopyFromSalesHeader();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Source Currency Code" := SalesHeader."Currency Code";
        "Currency Factor" := SalesHeader."Currency Factor";
        "VAT Base Discount %" := SalesHeader."VAT Base Discount %";
        #4..15
        "On Hold" := SalesHeader."On Hold";
        IF "Account Type" = "Account Type"::Customer THEN
          "Posting Group" := SalesHeader."Customer Posting Group";
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..18
        "Sys. LC No." := SalesHeader."Sys. LC No.";      //LC Integration.
        "Bank LC No." := SalesHeader."Bank LC No.";
        "Invertor Serial No." := SalesHeader."Invertor Serial No.";  //Agile Chandra 01 Sep 2015
        "LC Amend No." := SalesHeader."LC Amend No.";
        //SS1.00
        "Scheme Code" := SalesHeader."Scheme Code";
        "Membership No." := SalesHeader."Membership No.";
        //SS1.00
        "Invertor Serial No." := SalesHeader."Invertor Serial No.";  //Agile Chandra 01 Sep 2011
        "Financed By":=SalesHeader."Financed By No.";
        "Re-Financed By":=SalesHeader."Re-Financed By";
        "Financed Amount":=SalesHeader."Financed Amount";
        "Ship-to Code" := SalesHeader."Ship-to Code";  //Min >>
        "Ship-to Address" := SalesHeader."Ship-to Address";
        "Ship-to Address 2" := SalesHeader."Ship-to Address 2";
        "Ship-to City" := SalesHeader."Ship-to City";
        "Ship-to Country" := SalesHeader."Ship-to County";
        "Province No." := SalesHeader."Province No.";
        */
    //end;

    procedure ApplyLines()
    var
        VendLE: Record "25";
        Invoices: Record "122";
        pvnentry: Record "254";
        BankAcc: Record "270";
        Valkurss: Record "330";
        old_nr: Code[20];
        LastSerNo: Code[20];
        old: Code[20];
        DokNr: Text[1024];
        PrefixNo: Text[30];
        Val_src: Text[10];
        Val_dst: Text[10];
        kurss_dst: Decimal;
        kurss_src: Decimal;
        PVNsum: Decimal;
        pvnamount: Decimal;
    begin
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Apply",Rec);
        old:='';
        old_nr:='';
        DokNr:='';
        LastSerNo:='';
        PVNsum:=0;
        IF "Account Type"="Account Type"::Vendor THEN BEGIN
          VendLE.SETFILTER(VendLE."Vendor No.",'=%1',"Account No.");
          VendLE.SETFILTER(VendLE."Applies-to ID",'=%1',"Document No.");
          IF VendLE.FINDSET THEN BEGIN
            REPEAT
              IF DokNr='' THEN
                PrefixNo:= 'R. '
              ELSE
                PrefixNo:= '';
              IF LastSerNo=ExtractDocSer(VendLE."External Document No.") THEN
                DokNr:= AppendStr( DokNr, PrefixNo+ExtractDocNo(VendLE."External Document No."), ' ', MAXSTRLEN(DokNr) )
              ELSE BEGIN
                DokNr:= AppendStr( DokNr, PrefixNo+VendLE."External Document No.", '; ', MAXSTRLEN(DokNr) );
                LastSerNo:=ExtractDocSer(VendLE."External Document No.");
              END;

              Invoices.SETFILTER (Invoices."No.",'%1',VendLE."Document No.");
              IF Invoices.FINDFIRST THEN
                Invoices.CALCFIELDS(Invoices."Amount Including VAT",Invoices.Amount);

              Val_src:=Rec."Currency Code";
              IF Val_src='' THEN BEGIN
                Val_src:='LVL';
                kurss_src:=1;
              END ELSE BEGIN
                Valkurss.RESET;
                Valkurss.SETFILTER(Valkurss."Currency Code",'%1',Rec."Currency Code");
                Valkurss.SETFILTER(Valkurss."Starting Date",'%1',Rec."Posting Date");
                Valkurss.FINDFIRST;
                kurss_src:=Valkurss."Exchange Rate Amount";
              END;

              Val_dst := '';
              IF Val_dst='' THEN BEGIN
                Val_dst:='LVL';
                kurss_dst:=1;
              END ELSE BEGIN
                Valkurss.RESET;
                Valkurss.SETFILTER(Valkurss."Currency Code",'%1',Val_dst);
                Valkurss.SETFILTER(Valkurss."Starting Date",'%1',VendLE."Posting Date");
                Valkurss.FINDFIRST;
                kurss_dst:=Valkurss."Exchange Rate Amount";
              END;
         // Look for VAt
              pvnentry.RESET;
              pvnentry.SETCURRENTKEY("Document No.","Posting Date");
              pvnentry.SETRANGE(pvnentry."Document No.",VendLE."Document No.");
              pvnamount := 0;
              IF pvnentry.FINDSET THEN BEGIN
                REPEAT
                  IF pvnentry.Amount <> 0 THEN
                    pvnamount+=pvnentry.Amount
                  ELSE
                    pvnamount+=pvnentry."Unrealized Amount";
                UNTIL pvnentry.NEXT = 0;
              END;
              VendLE.CALCFIELDS(VendLE."Remaining Amount",VendLE.Amount);

              PVNsum:=PVNsum+(pvnamount*VendLE."Remaining Amount"/VendLE.Amount)*kurss_dst/kurss_src;
            UNTIL VendLE.NEXT=0;
            MODIFY;
          END;
        END;
    end;

    procedure ExtractDocSer(pDocNo: Code[35]) Result: Code[35]
    var
        s: Code[35];
    begin
        SplitDocNo( pDocNo, Result, s )
    end;

    procedure ExtractDocNo(pDocNo: Code[35]) Result: Code[35]
    var
        s: Code[35];
    begin
        SplitDocNo( pDocNo, s, Result )
    end;

    procedure AppendStr(s1: Text[1024];s2: Text[1024];Separator: Text[1024];MaxLen: Integer) Result: Text[1024]
    begin
        Result:= s1;
        IF s2='' THEN
          EXIT;

        IF s1<>'' THEN
          IF STRLEN(Result)+STRLEN(Separator)<=MaxLen THEN
            Result:=s1+Separator;

        IF STRLEN(Result)+STRLEN(s2)<=MaxLen THEN
          Result:=Result+s2;
    end;

    procedure SetDefSalesperson()
    var
        UserSetup: Record "91";
    begin
        //08.04.2014 Elva Baltic P1 #RX MMG7.00 - added
        IF UserSetup.GET(USERID) THEN
          VALIDATE("Salespers./Purch. Code",UserSetup."Salespers./Purch. Code")
    end;

    procedure SplitDocNo(pDocNo: Code[20];var pSer: Code[20];var pNo: Code[20])
    var
        n: Integer;
    begin
        pSer:='';
        pNo:= pDocNo;
        n:= STRPOS( pDocNo, ' ' );
        IF n>0 THEN
        BEGIN
          pSer:= DELCHR( COPYSTR( pDocNo, 1, n-1 ), '<>', ' ' ) ;
          pNo:= DELCHR( COPYSTR( pDocNo, n+1, MAXSTRLEN(pDocNo)-n+1), '<>', ' ' );
        END;
    end;

    procedure OnLookupVehicleRegistrationNo()
    var
        Vehicle: Record "25006005";
        LookUpMgt: Codeunit "25006003";
    begin
        IF "Vehicle Registration No." <> '' THEN BEGIN
          Vehicle.RESET;
          Vehicle.SETCURRENTKEY("Registration No.");
          Vehicle.SETRANGE("Registration No.","Vehicle Registration No.");
          IF Vehicle.FINDFIRST THEN;
          Vehicle.SETRANGE("Registration No.");
        END;

        IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
         VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
    end;

    procedure CalculateTDSAmount()
    var
        AmountNegativeOrZero: Label 'Amount is Negative or Zero. Do you want to Reverse Purchase TDS Entries?';
        TDSTypeBlank: Label 'TDS Type of %1 cannot be Blank in TDS Posting Group.';
        AmountPositiveOrZero: Label 'Amount is Positive or Zero. Do you want to Reverse Sale TDS Entries?';
    begin
        //TDS2.00
        //for Purchase TDS
        //MESSAGE('findtdstype-->'+FORMAT(FindTDSType));
        IF "TDS Group" <> '' THEN BEGIN
          IF (FindTDSType = 1) AND (Amount >= 0) THEN
          CalculateTDSAmount2
          ELSE
          IF (FindTDSType = 1) AND (Amount < 0) THEN //amount less than zero in case of manual reverse
          BEGIN
            IF NOT CONFIRM(AmountNegativeOrZero,FALSE) THEN
            EXIT;
            CalculateTDSAmount2;
          END;

          //for blank
          IF (FindTDSType = 0) THEN
          ERROR(TDSTypeBlank,"TDS Group");

          //for Sales TDS
          IF (FindTDSType = 2) AND (Amount <= 0) THEN
          CalculateTDSAmount2
          ELSE
          IF (FindTDSType = 2) AND (Amount > 0) THEN //amount greater than zero in case of manual reverse
          BEGIN
            IF NOT CONFIRM(AmountPositiveOrZero,FALSE) THEN
            EXIT;
            CalculateTDSAmount2;
          END;
        END
        ELSE
        ClearTDSFields;
        //TDS2.00
    end;

    procedure CalculateTDSAmount2()
    var
        TDSSetup2: Record "33019849";
    begin
        //TDS2.00
        GetCurrency;

        ClearTDSFields;
        TDSSetup2.RESET;
        TDSSetup2.SETRANGE(Code,"TDS Group");
        IF TDSSetup2.FINDFIRST THEN BEGIN
         "TDS%" := TDSSetup2."TDS%";
         "TDS Type" := TDSSetup2.Type;
         "TDS Base Amount" := "VAT Base Amount";
         "TDS Amount" := ROUND(TDSSetup2."TDS%"/100 * "VAT Base Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
        END;
        //TDS2.00
    end;

    procedure ClearTDSFields()
    begin
        //TDS2.00
        "TDS%" := 0;
        "TDS Type" := "TDS Type"::" ";
        "TDS Amount" := 0;
        "TDS Base Amount" := 0;
    end;

    procedure FindTDSType(): Integer
    var
        TDSSetup2: Record "33019849";
    begin
        //TDS2.00
        TDSSetup2.RESET;
        TDSSetup2.SETRANGE(Code,"TDS Group");
        IF TDSSetup2.FINDFIRST THEN
        EXIT(TDSSetup2.Type);
    end;

    procedure NotAllowTDSAccountinJournal()
    var
        TDSPostingGroup: Record "33019849";
        UserSetUp: Record "91";
    begin
        //TDS2.00 <<
        UserSetUp.GET(USERID);
        IF ("Account Type" = "Account Type"::"G/L Account") AND (NOT UserSetUp."Allow TDS A/C Direct Posting") THEN BEGIN
          TDSPostingGroup.RESET;
          TDSPostingGroup.SETRANGE("GL Account No.","Account No.");
          IF TDSPostingGroup.FINDFIRST THEN
          ERROR('You cannot select TDS Account No. %1 in journal lines',"Account No.");
        END;
        //TDS2.00 <<
    end;

    procedure CheckLCMandatory()
    var
        LCDetail: Record "33020012";
        GLAccount: Record "15";
        ErrorLCCheck: Label 'G/L Account No %3 has LC No Mandatory type "%1".LC No. %4  has Transaction Type "%2".It should be same.';
    begin
        //code to check LC Mandatory While posting from journal         //Agile Cp 15 Feb 2017 >>>
        IF (("Source Code" <> 'SALES') AND ("Source Code" <> 'SERVICE') AND ("Source Code" <> 'PURCHASES')) THEN BEGIN
          IF "Sys. LC No." <> '' THEN BEGIN
            LCDetail.GET("Sys. LC No.");
            IF ("Account Type" = "Account Type"::"G/L Account") AND ("Account No." <> '') THEN BEGIN
              GLAccount.GET("Account No.");
              IF NOT ((GLAccount."LC No Mandatory" - 1) = LCDetail."Transaction Type") THEN
                ERROR(ErrorLCCheck,GLAccount."LC No Mandatory",LCDetail."Transaction Type","Account No.","Sys. LC No.");
            END;
            IF ("Bal. Account Type" = "Bal. Account Type"::"G/L Account") AND ("Bal. Account No." <> '') THEN BEGIN
              GLAccount.GET("Bal. Account No.");
              IF NOT ((GLAccount."LC No Mandatory" - 1) = LCDetail."Transaction Type") THEN
                ERROR(ErrorLCCheck,GLAccount."LC No Mandatory",LCDetail."Transaction Type","Bal. Account No.","Sys. LC No.");
            END;
          END;
        END;
        //Agile Cp 15 Feb 2017 <<<<
    end;

    procedure CheckCommericalInvOutstanding()
    var
        CommercialInvHeader: Record "33020185";
        GLAccount: Record "15";
        ErrorLCCheck: Label 'G/L Account No %3 has LC No Mandatory type "%1".LC No. %4  has Transaction Type "%2".It should be same.';
    begin
        //code to check Commerical Invoice Mandatory While posting from journal         //Agile Cp 15 Feb 2017 >>>
        IF (("Source Code" <> 'SALES') AND ("Source Code" <> 'SERVICE') AND ("Source Code" <> 'PURCHASES')) THEN BEGIN
          IF "Commercial Invoice No" <> '' THEN BEGIN
            CommercialInvHeader.GET("Commercial Invoice No");
            IF ("Account Type" = "Account Type"::"G/L Account") AND ("Account No." <> '') THEN BEGIN
              GLAccount.GET("Account No.");
              IF GLAccount."Commercial Invoice Mandatory" THEN
                CompareComInvAmtWithLoanNegAmt;
            END;
            IF ("Bal. Account Type" = "Bal. Account Type"::"G/L Account") AND ("Bal. Account No." <> '') THEN BEGIN
              GLAccount.GET("Bal. Account No.");
              IF GLAccount."Commercial Invoice Mandatory" THEN
                CompareComInvAmtWithLoanNegAmt;
            END;
          END;
        END;
        //Agile Cp 15 Feb 2017 <<<<
    end;

    procedure CompareComInvAmtWithLoanNegAmt()
    var
        GLEntry: Record "17";
        CommercialInvLine: Record "33020186";
        SalesInvHeader: Record "112";
        GLEntryLoanAmount: Decimal;
        CommercialInvoiceAmount: Decimal;
        GLEntryLoanAmountSettled: Decimal;
        GLEntry2: Record "17";
    begin
        //Agile Cp 15 Feb 2017 >>>
        CLEAR(GLEntryLoanAmount);
        CLEAR(GLEntryLoanAmountSettled);
        CLEAR(CommercialInvoiceAmount);

        GLEntry.RESET;
        GLEntry.SETCURRENTKEY("Commercial Invoice No","Loan Posting Type");
        GLEntry.SETRANGE("Commercial Invoice No","Commercial Invoice No");
        GLEntry.SETRANGE("Loan Posting Type",GLEntry."Loan Posting Type"::"Loan Invoice");
        //GLEntry.SETRANGE("G/L Account No.","Account No.");
        GLEntry.SETRANGE("G/L Account No.",'204461','204669');   //*FindGLAcc
        IF GLEntry.FINDSET THEN REPEAT
          GLEntryLoanAmount += GLEntry.Amount
        UNTIL GLEntry.NEXT = 0;

        CommercialInvLine.RESET;
        CommercialInvLine.SETRANGE("Document No.","Commercial Invoice No");
        IF CommercialInvLine.FINDSET THEN REPEAT
          SalesInvHeader.GET(CommercialInvLine."Sales Invoice No.");
          SalesInvHeader.CALCFIELDS("Amount Including VAT");
          CommercialInvoiceAmount += SalesInvHeader."Amount Including VAT";
        UNTIL CommercialInvLine.NEXT = 0;

        GLEntry2.RESET;
        GLEntry2.SETCURRENTKEY("Commercial Invoice No","Loan Posting Type");
        GLEntry2.SETRANGE("Commercial Invoice No","Commercial Invoice No");
        GLEntry2.SETRANGE("Loan Posting Type",GLEntry."Loan Posting Type"::"Loan Payment");
        //GLEntry2.SETRANGE("G/L Account No.","Account No.");
        GLEntry.SETRANGE("G/L Account No.",'204461','204669');   //*FindGLAcc
        IF GLEntry2.FINDSET THEN REPEAT
          GLEntryLoanAmountSettled += GLEntry2.Amount
        UNTIL GLEntry2.NEXT = 0;


        IF ((ABS(GLEntryLoanAmount) > 0)
           AND ("Loan Posting Type" = "Loan Posting Type"::"Loan Invoice")) THEN //check if Loan Invoice is already posted
         ERROR('Commercial Invoice No %1 of Nrs. %2 is already settled by Laon Invoice No. %3 of Nrs. %4',
                "Commercial Invoice No",CommercialInvoiceAmount,GLEntry."Document No.",GLEntryLoanAmount);

        IF ((ABS(GLEntryLoanAmount) = ABS(GLEntryLoanAmountSettled))
           AND ("Loan Posting Type" = "Loan Posting Type"::"Loan Payment")) THEN    //check if Loan Payment is already posted
         ERROR('Loan Invoice No %1 of Nrs. %2 is already settled by Laon Payment No. %3 of Nrs. %4',
                GLEntry."Document No.",GLEntryLoanAmount,GLEntry2."Document No.",GLEntryLoanAmountSettled);

        IF CommercialInvoiceAmount <> ABS(Amount)  THEN       //Check both cases of debit and credit in general journal
         ERROR(
         'Commercial Invoice No %1 of Nrs. %2 should be settled by Document No. %3 of equal Amount',
                "Commercial Invoice No",CommercialInvoiceAmount,"Document No.");
        //Agile Cp 15 Feb 2017 >>>
    end;

    procedure TestfieldLoanPostingType()
    begin
        //Agile CP 16 Feb 2017
        IF "Loan Posting Type" = "Loan Posting Type"::"Loan Invoice" THEN BEGIN
          TESTFIELD("Credit Amount");
          TESTFIELD("Commercial Invoice No");
        END;
        IF "Loan Posting Type" IN ["Loan Posting Type"::"Loan Payment","Loan Posting Type"::"Loan Interest Charges"] THEN BEGIN
          TESTFIELD("Debit Amount");
          TESTFIELD("Commercial Invoice No");
        END;
        //Agile CP 16 Feb 2017
    end;

    procedure FindGLAcc() GLFilter: Text[250]
    var
        GLAccount: Record "15";
    begin
        //*FindGLAcc //Agile CP 16 Feb 2017
        CLEAR(GLFilter);
        GLAccount.RESET;
        GLAccount.SETRANGE("Account Type",GLAccount."Account Type"::Posting);
        GLAccount.SETRANGE("Commercial Invoice Mandatory",TRUE);
        IF GLAccount.FINDSET THEN
        REPEAT
         GLFilter += '|' + GLAccount."No.";
        UNTIL GLAccount.NEXT = 0;
        EXIT(GLFilter);
        //Agile CP 16 Feb 2017
    end;


    //Unsupported feature: Property Modification (Id) on "GenJnlShowCTEntries(Variable 1039)".

    //var
        //>>>> ORIGINAL VALUE:
        //GenJnlShowCTEntries : 1039;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //GenJnlShowCTEntries : 1090;
        //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "Text016(Variable 1062)".

    //var
        //>>>> ORIGINAL VALUE:
        //Text016 : 1062;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //Text016 : 1001062;
        //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "ExportAgainQst(Variable 1038)".

    //var
        //>>>> ORIGINAL VALUE:
        //ExportAgainQst : 1038;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //ExportAgainQst : 1080;
        //Variable type has not been exported.

    var
        ApplyCustEntries: Page "232";
                              ApplyVendEntries: Page "233";

    var
        AccNo: Code[20];

    var
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";

    var
        Text12800: Label 'Do You want change "Order Printed" status?';
        Text12801: Label 'Incl. VAT';
        Text12802: Label 'Reset Order?';
        Text100: Label 'Payment for I.%1 of %2 ';
        ErrVendNoIINPayer: Label 'Vendor %1 is not %2. You mustn''t enter %3! ';
        TxtIncomeTax: Label 'Is it Phys. Person Incomes Tax? ';
        cuLookUpMgt: Codeunit "25006003";
        recVehicle: Record "25006005";
        LookUpMgt: Codeunit "25006003";
        ShipToAddress: Record "222";
        IsEditable: Boolean;
}


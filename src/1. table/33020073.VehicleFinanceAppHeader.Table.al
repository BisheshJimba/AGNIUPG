table 33020073 "Vehicle Finance App. Header"
{
    DataCaptionFields = "Application No.", "Customer Name";

    fields
    {
        field(1; "Application No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Application No." <> xRec."Application No." THEN BEGIN
                    VFSetup.GET;
                    NoSeriesMgt.TestManual(VFSetup."Application Nos.");
                    "No. Series" := '';
                END;

                //insert loan approval setup check list
                /*
                CheckListSetup.GET;
                IF CheckListSetup.FINDFIRST THEN BEGIN
                  REPEAT
                    CheckList.SETRANGE("Check List Code",CheckListSetup.Code);
                    CheckList.SETRANGE("Application No.","Application No.");
                    IF NOT CheckList.FINDFIRST THEN BEGIN
                      CheckList.INIT;
                      CheckList."Application No." := "Application No.";
                      CheckList."Check List Code" := CheckListSetup.Code;
                      CheckList.INSERT;
                    END;
                  UNTIL CheckListSetup.NEXT =0;
                END;
                */

            end;
        }
        field(2; "Customer No."; Code[20])
        {
            TableRelation = Customer.No.;

            trigger OnValidate()
            begin
                VFSetup.GET;
                VFSetup.TESTFIELD(VFSetup."Shortcut Dimension 2 Code");
                "Shortcut Dimension 2 Code" := VFSetup."Shortcut Dimension 2 Code";
                IF NOT SkipSellToContact THEN
                    UpdateSellToCont("Customer No.");
                CALCFIELDS("Contact Name");
            end;
        }
        field(3; "Vehicle No."; Code[20])
        {
            TableRelation = Vehicle."Serial No." WHERE(Make Code=FIELD(Make Code),
                                                        Model Code=FIELD(Model Code),
                                                        Model Version No.=FIELD(Model Version));
        }
        field(4;"Vehicle Cost";Decimal)
        {

            trigger OnValidate()
            begin
                IF "Down Payment" >= "Vehicle Cost" THEN
                  ERROR('Down payment should not be higher than the Vehicle cost.');

                "Loan Amount" := "Vehicle Cost" - "Down Payment";

                VALIDATE("Disbursement Date");
            end;
        }
        field(5;"Down Payment";Decimal)
        {

            trigger OnValidate()
            begin
                IF "Down Payment" >= "Vehicle Cost" THEN
                  ERROR('Down payment should not be higher than the Vehicle cost.');

                "Loan Amount" := "Vehicle Cost" - "Down Payment";
                VALIDATE("Disbursement Date");
            end;
        }
        field(6;"Loan Amount";Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                IF ("First Installment Date"<>0D) AND ("Disbursement Date"<>0D) THEN
                IF ((("First Installment Date" - CALCDATE('1M',"Disbursement Date") > 0 )))THEN BEGIN
                "Credit Allowded Days (CAD)":=("First Installment Date"- CALCDATE('1M',"Disbursement Date"));
                "Interest on CAD":=("Loan Amount"*"Credit Allowded Days (CAD)"*"Interest Rate")/(100*365);
                END ELSE BEGIN
                "Credit Allowded Days (CAD)":=0;
                "Interest on CAD":=0;
                END;
            end;
        }
        field(7;"Interest Rate";Decimal)
        {

            trigger OnValidate()
            begin
                VFSetup.GET;
                //"Penalty %" := "Interest Rate" + VFSetup."Penalty % - Interest %";  //ZM dec 6, 2016
                "Interest on CAD" :=  "Interest Rate";
            end;
        }
        field(8;"Tenure in Months";Decimal)
        {
        }
        field(9;"Disbursement Date";Date)
        {

            trigger OnValidate()
            begin
                UserSetup.GET(USERID);
                IF ("Disbursement Date" > TODAY) AND ( NOT UserSetup."Can Reschedule Loan") THEN
                  ERROR('You don''t have permission to disburse loan at future date.');                   //ZM Apr 26, 2017

                IF ("First Installment Date"<>0D) AND ("Disbursement Date"<>0D) THEN BEGIN
                  IF "Disbursement Date" > "First Installment Date" THEN
                    ERROR('%1 cannot be greater than %2.',FIELDCAPTION("Disbursement Date"),FIELDCAPTION("First Installment Date"));     //ZM Apr 26, 2017
                  IF ((("First Installment Date" - CALCDATE('1M',"Disbursement Date") > 0 )))THEN BEGIN
                  "Credit Allowded Days (CAD)":=("First Installment Date"- CALCDATE('1M',"Disbursement Date"));
                  "Interest on CAD":=("Loan Amount"*"Credit Allowded Days (CAD)"*"Interest Rate")/(100*365);
                  END ELSE BEGIN
                  "Credit Allowded Days (CAD)":=0;
                  "Interest on CAD":=0;
                  END;
                END;
            end;
        }
        field(10;"First Installment Date";Date)
        {

            trigger OnValidate()
            begin
                IF ("First Installment Date"<>0D) AND ("Disbursement Date"<>0D) THEN BEGIN
                  IF "Disbursement Date" > "First Installment Date" THEN
                    ERROR('%1 cannot be greater than %2.',FIELDCAPTION("Disbursement Date"),FIELDCAPTION("First Installment Date"));    //ZM Apr 26, 2017

                  IF ((("First Installment Date" - CALCDATE('1M',"Disbursement Date") > 0 )))THEN BEGIN
                  "Credit Allowded Days (CAD)":=("First Installment Date"- CALCDATE('1M',"Disbursement Date"));
                  "Interest on CAD":=("Loan Amount"*"Credit Allowded Days (CAD)"*"Interest Rate")/(100*365);
                  END ELSE BEGIN
                  "Credit Allowded Days (CAD)":=0;
                  "Interest on CAD":=0;
                  END;
                END;
            end;
        }
        field(11;"EMI Type";Option)
        {
            OptionMembers = Monthly,Quarterly;
        }
        field(12;"Service Charge";Decimal)
        {
        }
        field(13;"Other Charges";Decimal)
        {
        }
        field(14;"Credit Allowded Days (CAD)";Integer)
        {
        }
        field(15;"Interest on CAD";Decimal)
        {
        }
        field(16;"Customer Name";Text[50])
        {
            CalcFormula = Lookup(Customer.Name WHERE (No.=FIELD(Customer No.)));
            FieldClass = FlowField;
        }
        field(17;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle No.)));
            FieldClass = FlowField;
        }
        field(18;"Registration No.";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Registration No." WHERE (Serial No.=FIELD(Vehicle No.)));
            FieldClass = FlowField;
        }
        field(19;"Responsibility Center";Code[10])
        {
        }
        field(20;"Location Code";Code[10])
        {
        }
        field(21;"No. Series";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(22;Approved;Boolean)
        {
            Editable = false;
        }
        field(23;"Approved By";Code[50])
        {
            Editable = false;
        }
        field(24;"Approved Date";Date)
        {
            Editable = false;
        }
        field(25;"Last Date Modified";Date)
        {
            Editable = false;
        }
        field(26;Blocked;Boolean)
        {
        }
        field(27;"Financing Bank No.";Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                IF NOT "Loan Disbursed" THEN BEGIN
                  IF "Financing Bank No." <> '' THEN BEGIN
                    IF BankAccount.GET("Financing Bank No.") THEN
                      "Bank Interest Rate" := BankAccount."Interest Rate"
                    ELSE
                      "Bank Interest Rate" := 0;
                  END ELSE
                    "Bank Interest Rate" := 0;
                END;
                VehicleFinanceSetup.GET;
                "Interest Rate" := "Bank Interest Rate" + VehicleFinanceSetup."Penalty % - Interest %";
                "Penalty %" := VehicleFinanceSetup."Penalty %"; //Min
                "Actual Interest Rate" := "Bank Interest Rate" + VehicleFinanceSetup."Penalty % - Interest %"; //Min
            end;
        }
        field(28;"Bank Name";Text[50])
        {
            CalcFormula = Lookup("Bank Account".Name WHERE (No.=FIELD(Financing Bank No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(29;"Bank Interest Rate";Decimal)
        {
        }
        field(30;"Loan Status";Option)
        {
            Editable = false;
            OptionCaption = 'Performing,Substandard,Doubtful,Critical';
            OptionMembers = Performing,Substandard,Doubtful,Critical;
        }
        field(31;"Net Realization Value";Decimal)
        {
            Editable = false;
        }
        field(32;"NRV Calculation Date";Date)
        {
            Editable = false;
        }
        field(33;"NRV Status";Option)
        {
            Editable = false;
            OptionMembers = "Risk Free",Risky;
        }
        field(34;"Loan Released";Boolean)
        {
        }
        field(35;"Principal Due";Decimal)
        {
            Editable = false;
        }
        field(36;"Interest Due";Decimal)
        {
            Editable = false;
        }
        field(37;"Penalty Due";Decimal)
        {
            Editable = false;
        }
        field(42;"Sales Invoice Date";Date)
        {
        }
        field(43;"Due Installments";Integer)
        {
            Editable = false;
        }
        field(44;"No of Due Days";Integer)
        {
        }
        field(45;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(46;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(47;"Penalty %";Decimal)
        {
        }
        field(48;"Difference Interest";Decimal)
        {
        }
        field(49;"Sales Invoice No.";Code[20])
        {
            TableRelation = "Sales Invoice Header".No. WHERE (Sell-to Customer No.=FIELD(Customer No.));
        }
        field(50;"Contact No.";Code[20])
        {
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record "5050";
                ContBusinessRelation: Record "5054";
            begin
                IF "Customer No." <> '' THEN BEGIN
                  IF Cont.GET("Contact No.") THEN
                    Cont.SETRANGE("Company No.",Cont."Company No.")
                  ELSE BEGIN
                    ContBusinessRelation.RESET;
                    ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                    ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
                    ContBusinessRelation.SETRANGE("No.","Customer No.");
                    IF ContBusinessRelation.FINDFIRST THEN
                      Cont.SETRANGE("Company No.",ContBusinessRelation."Contact No.")
                    ELSE
                      Cont.SETRANGE("No.",'');
                  END;
                END;

                IF "Contact No." <> '' THEN
                  IF Cont.GET("Contact No.") THEN ;
                IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                  xRec := Rec;
                  VALIDATE("Contact No.",Cont."No.");
                END;
            end;

            trigger OnValidate()
            var
                Cont: Record "5050";
                ContBusinessRelation: Record "5054";
            begin
                VFSetup.GET;
                VFSetup.TESTFIELD(VFSetup."Shortcut Dimension 2 Code");
                "Shortcut Dimension 2 Code":=VFSetup."Shortcut Dimension 2 Code";
                IF ("Customer No." <> '') AND ("Contact No." <> '') THEN BEGIN
                  Cont.GET("Contact No.");
                  ContBusinessRelation.RESET;
                  ContBusinessRelation.SETCURRENTKEY("Link to Table","No.");
                  ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
                  ContBusinessRelation.SETRANGE("No.","Customer No.");
                  IF ContBusinessRelation.FINDFIRST THEN
                    IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                      ERROR(Text038,Cont."No.",Cont.Name,"Customer No.");
                END;

                UpdateSellToCust("Contact No.");

                CALCFIELDS("Contact Name");
            end;
        }
        field(51;"Contact Name";Text[50])
        {
            CalcFormula = Lookup(Contact.Name WHERE (No.=FIELD(Contact No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(1000;"Loan Disbursed";Boolean)
        {
        }
        field(1001;Closed;Boolean)
        {
        }
        field(1002;"Service Invoice Posted";Boolean)
        {
        }
        field(1003;"TEMP VIN";Code[20])
        {
        }
        field(1004;"Responsible Person Code";Code[20])
        {
            TableRelation = Salesperson/Purchaser.Code;
        }
        field(1005;"Responsible Person Name";Text[50])
        {
            CalcFormula = Lookup(Salesperson/Purchaser.Name WHERE (Code=FIELD(Responsible Person Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000;Defaulter;Boolean)
        {
        }
        field(50001;"Delivery Date";Date)
        {
        }
        field(50002;"Service Charge %";Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Loan Amount");
                VALIDATE("Service Charge",("Service Charge %"/100) * "Loan Amount");
            end;
        }
        field(50003;"Temp Delay Days";Integer)
        {
        }
        field(50004;"Temp Penalty";Decimal)
        {
        }
        field(50005;"Due Installment as of Today";Integer)
        {
        }
        field(50006;"Due Principal as of Today";Decimal)
        {
        }
        field(50007;"Total Due as of Today";Decimal)
        {
        }
        field(50008;"Vehicle Regd. No.";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Registration No." WHERE (Serial No.=FIELD(Vehicle No.)));
            FieldClass = FlowField;
        }
        field(50009;"Temp Cash Receipt No.";Code[20])
        {
        }
        field(50010;"Temp Payment Amount";Decimal)
        {
        }
        field(50011;"Temp Payment Method";Option)
        {
            OptionMembers = Cash,Check;
        }
        field(50012;"Temp Check Bank Account";Text[50])
        {
        }
        field(50013;"Temp Check No.";Code[30])
        {
        }
        field(50030;"Application Status";Code[50])
        {
            TableRelation = "Hire Purchase Setup Master".Code WHERE (Type=CONST(Application Status));

            trigger OnValidate()
            begin
                VerifyCheckList;
                IF "Application Status" = 'Rejected' THEN
                  TESTFIELD("Reason For Loan Rejection");
            end;
        }
        field(50031;"Financing Option";Code[50])
        {
            TableRelation = "Hire Purchase Setup Master".Code WHERE (Type=CONST(Financing Option));
        }
        field(50032;Purpose;Code[50])
        {
            TableRelation = "Hire Purchase Setup Master".Code WHERE (Type=CONST(Purpose));
        }
        field(50035;"Requested By";Text[30])
        {
            Description = 'SRT';
        }
        field(50036;"Request Type";Text[30])
        {
            Description = 'SRT';
        }
        field(50037;"Subventions/Loss Assurances";Text[100])
        {
            Description = 'SRT';
        }
        field(50038;"Special Financing period";Text[50])
        {
            Description = 'SRT';
        }
        field(50039;Remarks;Text[250])
        {
            Description = 'SRT';
        }
        field(50050;"Application Open Date";Date)
        {
            Editable = false;
        }
        field(50051;"Rejection Date";Date)
        {
            Editable = false;
        }
        field(50099;"Discontinued Loan No.";Code[20])
        {
            Editable = false;
        }
        field(50100;"Make Code";Code[20])
        {
            TableRelation = Make;
        }
        field(50101;"Model Code";Code[20])
        {
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(50102;"Model Version";Code[20])
        {
            TableRelation = Item.No. WHERE (Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=CONST(Model Version));

            trigger OnValidate()
            begin
                "Model Version No. 2" := '';
                IF Item.GET("Model Version") THEN
                  "Model Version No. 2" := Item."No. 2";
            end;
        }
        field(50103;Description;Text[150])
        {
        }
        field(50104;Rejected;Boolean)
        {
            Editable = true;
        }
        field(50105;"Reason For Loan Rejection";Text[150])
        {
            TableRelation = "Reason Code".Code WHERE (Group=FILTER(Hire Purchase));
        }
        field(50106;"Vehicle Application";Code[50])
        {
            TableRelation = "Hire Purchase Setup Master".Code WHERE (Type=CONST(Vehicle Application));
        }
        field(50107;"Dealer Code";Code[20])
        {
            TableRelation = Customer.No. WHERE (Is Dealer=CONST(Yes));
        }
        field(50108;"Model Version No. 2";Code[20])
        {
            Editable = false;
            TableRelation = Item."No. 2" WHERE (Make Code=FIELD(Make Code),
                                                Model Code=FIELD(Model Code),
                                                Item Type=CONST(Model Version));
        }
        field(50302;"RAM Percentage";Decimal)
        {

            trigger OnValidate()
            begin
                /*IF ("RAM Percentage" >= 0) AND ("RAM Percentage" <= 49.99) THEN
                 "Risk Grade" := "Risk Grade"::Poor
                ELSE  IF ("RAM Percentage" >= 50) AND ("RAM Percentage" <=59.99) THEN
                 "Risk Grade" := "Risk Grade"::Doubtful;
                {ELSE IF ("RAM Percentage" >= 60) AND ("RAM Percentage" <=69.99) THEN
                 "Risk Grade" := "Risk Grade"::Fair
                ELSE IF ("RAM Percentage" >= 70) AND ("RAM Percentage" <= 79.99) THEN
                 "Risk Grade" := "Risk Grade"::Good
                ELSE IF ("RAM Percentage" >= 80) AND ("RAM Percentage" <= 89.99) THEN
                 "Risk Grade" := "Risk Grade"::"Very good"
                ELSE
                 "Risk Grade" := "Risk Grade"::Excellent;}
                 */

            end;
        }
        field(50303;"SOL Identity";Code[20])
        {
            TableRelation = "Business Relation".Code;

            trigger OnValidate()
            begin
                IF "SOL Identity" <> '' THEN BEGIN
                  IF CheckSOLValues(Rec) THEN
                    MESSAGE('Total finance value will exceed the Exposure value!');
                END;
            end;
        }
        field(50306;"OT Date";Date)
        {
        }
        field(50307;Guarantor;Code[20])
        {
            TableRelation = Contact.No. WHERE (Guarantor=CONST(Yes));

            trigger OnValidate()
            begin
                "Guarantor Name" := '';
                "Guarantor Address" := '';
                "Guarantor Mobile No." := '';
                "Guarantor Contact Person" := '';

                IF Contact.GET(Guarantor) THEN BEGIN
                  "Guarantor Name" := Contact.Name;
                  "Guarantor Address" := Contact.Address;
                  "Guarantor Mobile No." := Contact."Mobile Phone No.";
                  "Guarantor Contact Person" := Contact."Contact Person";
                END;
            end;
        }
        field(50308;"Guarantor Name";Text[50])
        {
        }
        field(50309;"Guarantor Address";Text[50])
        {
        }
        field(50310;"Guarantor Mobile No.";Text[30])
        {
        }
        field(50311;"Guarantor Contact Person";Text[50])
        {
        }
        field(50312;"BlueBook Renew Date";Date)
        {
        }
        field(50313;"Incoming Document Entry No.";Integer)
        {
            Caption = 'Incoming Document Entry No.';
            TableRelation = "Incoming Document";

            trigger OnValidate()
            var
                IncomingDocument: Record "130";
            begin
                IF "Incoming Document Entry No." = xRec."Incoming Document Entry No." THEN
                  EXIT;
                IF "Incoming Document Entry No." = 0 THEN
                  IncomingDocument.RemoveReferenceToWorkingDocument(xRec."Incoming Document Entry No.")
                ELSE
                  IncomingDocument.SetHirePurchDoc(Rec);
            end;
        }
        field(60003;"Customer's Guarantor";Text[150])
        {
        }
        field(60018;"Nominee Account No.";Code[20])
        {
            Editable = false;
            TableRelation = Customer.No.;
        }
        field(60019;"Nominee Account Name";Text[50])
        {
            Editable = false;
        }
        field(60050;"Mortgage NRV";Decimal)
        {
        }
        field(60051;"Mortgage Details";Text[50])
        {
        }
        field(60052;"Application Submitted";Boolean)
        {

            trigger OnValidate()
            var
                LoanProcessTraking: Record "33020084";
                LoanApprovalCheckList: Record "33020069";
            begin
                IF "Application Submitted" THEN BEGIN
                  VFSetup.GET;
                  IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN BEGIN
                    LoanApprovalCheckList.RESET;
                    LoanApprovalCheckList.SETRANGE("Document Type",LoanApprovalCheckList."Document Type"::Application);
                    LoanApprovalCheckList.SETRANGE("Document No.","Application No.");
                    LoanApprovalCheckList.FINDFIRST;

                    LoanApprovalCheckList.SETRANGE("Is Accomplished?",FALSE);
                    LoanApprovalCheckList.SETRANGE(Exceptional,FALSE);
                    IF LoanApprovalCheckList.FINDFIRST THEN
                      ERROR(ErrLoanAppChekList);

                    LoanProcessTraking.RESET;
                    LoanProcessTraking.SETRANGE("Application No.","Application No.");
                    LoanProcessTraking.SETRANGE(Components,'SITE VISIT');
                    LoanProcessTraking.SETRANGE(Processed,TRUE);
                    IF NOT LoanProcessTraking.FINDFIRST THEN
                      ERROR(ErrLoanProcessTrackSheet);
                  END;
                END;
            end;
        }
        field(70052;"Created By";Code[50])
        {
        }
        field(70054;"Land Area";Text[30])
        {
        }
        field(70055;"Building Area";Decimal)
        {
        }
        field(70056;"Market Value";Decimal)
        {
        }
        field(70057;"Distress Value";Decimal)
        {
        }
        field(70058;"Valued Date";Date)
        {
        }
        field(70059;"Valued By";Text[50])
        {
        }
        field(70060;"Property Address";Text[50])
        {
        }
        field(70061;"Actual Interest Rate";Decimal)
        {
        }
        field(70062;"Owner Name";Text[50])
        {
        }
        field(70063;"Verified By";Code[50])
        {
        }
        field(70064;Verified;Boolean)
        {
        }
        field(70065;"Verified Date";Date)
        {
        }
        field(70066;"Disbursed By";Code[50])
        {
        }
        field(70067;"Insurance Expiry Date";Date)
        {
        }
        field(70068;"Insurance Company Name";Text[50])
        {
        }
        field(70069;"Insurance Company Code";Code[20])
        {
            TableRelation = Vendor.No.;

            trigger OnValidate()
            var
                Vendor: Record "23";
            begin
                IF Vendor.GET("Insurance Company Code") THEN
                  "Insurance Company Name" := Vendor.Name
                ELSE
                  "Insurance Company Name" := '';
            end;
        }
        field(70070;"Risk Grade";Option)
        {
            Editable = false;
            OptionCaption = ' ,Excellent,Very good,Good,Fair,Doubtful,Poor';
            OptionMembers = " ",Excellent,"Very good",Good,Fair,Doubtful,Poor;
        }
        field(70071;"Agni Branches";Text[30])
        {
        }
        field(33010062;"Credit Facility Type";Text[50])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE (Type=CONST(Credit Facility Type));
        }
        field(33010063;"Purpose of Credit Facility";Text[30])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE (Type=CONST(Purpose of Credit Facility));
        }
        field(33010064;"Ownership Type";Text[30])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE (Type=CONST(Ownership Type));
        }
        field(33010065;"Customer Credit Limit";Decimal)
        {
            Description = 'KSKL 1.0';
        }
        field(33010066;"Currency Code";Text[30])
        {
            Description = 'KSKL 1.0';
            TableRelation = Currency;
        }
        field(33010067;"Repayment Frequency";Text[30])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE (Type=CONST(Repayment Frequency));
        }
        field(33010068;"Credit Facility Status";Text[30])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE (Type=CONST(Credit Facility Status));
        }
        field(33010069;"Reason for Closure";Text[30])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE (Type=CONST(Reason for Closure));
        }
        field(33010070;"Security Coverage Flag";Boolean)
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE (Type=CONST(Secutity Coverage Flag));
        }
        field(33010071;"Credit Facility Sanction Curr";Text[30])
        {
            Description = 'KSKL1.0';
            TableRelation = Currency;
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
        field(33019962;PAN;Code[20])
        {
            CalcFormula = Lookup(Customer.PAN WHERE (No.=FIELD(Customer No.)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Application No.")
        {
            Clustered = true;
        }
        key(Key2;"Customer No.","Loan Amount")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Application No." = '' THEN BEGIN
          VFSetup.GET;
          VFSetup.TESTFIELD("Application Nos.");
          NoSeriesMgt.InitSeries(VFSetup."Application Nos.",xRec."No. Series",0D,"Application No.","No. Series");
        END;
        InitRec;
        "Created By" := USERID;
    end;

    var
        VFRec: Record "33020073";
        VFSetup: Record "33020064";
        NoSeriesMgt: Codeunit "396";
        CheckListSetup: Record "33020068";
        CheckList: Record "33020069";
        UserMgt: Codeunit "5700";
        Text038: Label 'Contact %1 %2 is related to a different company than customer %3.';
        Text037: Label 'Contact %1 %2 is not related to customer %3.';
        SkipSellToContact: Boolean;
        HPSetup: Record "33020080";
        Text001: Label 'Nominee account already exists for customer %1.';
        Text002: Label 'Do you want to create Nominee Account for Customer %1?';
        Text003: Label 'Nominee account %1 created for customer %2.';
        UserSetup: Record "91";
        VehicleFinanceHeader: Record "33020062";
        VehicleFinanceLine: Record "33020063";
        VehicleFinanceSetup: Record "33020064";
        PaidUpCapital: Decimal;
        TotalFinanceValue: Decimal;
        AvailableLimit: Decimal;
        BankAccount: Record "270";
        ErrLoanAppChekList: Label 'Loan apporval checklist is not filled completely!';
        ErrLoanProcessTrackSheet: Label 'Site Vist must have value in Loan Process Tracking Sheet!';
        Contact: Record "5050";
        Item: Record "27";
        VehFinanceSetup: Record "33020064";

    [Scope('Internal')]
    procedure AssistEdit(OldFinanceHeader: Record "33020073"): Boolean
    begin
        WITH VFRec DO BEGIN
          VFRec := Rec;
          VFSetup.GET;
          VFSetup.TESTFIELD("Application Nos.");
          IF NoSeriesMgt.SelectSeries(VFSetup."Application Nos.",OldFinanceHeader."No. Series","No. Series") THEN BEGIN
            VFSetup.GET;
            VFSetup.TESTFIELD("Application Nos.");
            NoSeriesMgt.SetSeries("Application No.");
            Rec := VFRec;
            EXIT(TRUE);
          END;
        END;
    end;

    [Scope('Internal')]
    procedure InitRec()
    begin
        "Responsibility Center" := UserMgt.GetRespCenter(0,"Responsibility Center");
        "Application Open Date" := TODAY;
    end;

    [Scope('Internal')]
    procedure UpdateSellToCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "5054";
        Cust: Record "18";
    begin
        "Contact No." := '';
        IF Cust.GET(CustomerNo) THEN BEGIN
          IF Cust."Primary Contact No." <> '' THEN
            "Contact No." := Cust."Primary Contact No."
          ELSE BEGIN
            ContBusRel.RESET;
            ContBusRel.SETCURRENTKEY("Link to Table","No.");
            ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
            ContBusRel.SETRANGE("No.","Customer No.");
            IF ContBusRel.FINDFIRST THEN BEGIN
              "Contact No." := ContBusRel."Contact No.";
            END ELSE
              "Contact No." := '';
          END;
        END;
    end;

    [Scope('Internal')]
    procedure UpdateSellToCust(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "5054";
        Customer: Record "18";
        Cont: Record "5050";
        CustTemplate: Record "5105";
        ContComp: Record "5050";
    begin
        IF Cont.GET(ContactNo) THEN
          "Contact No." := Cont."No."
        ELSE BEGIN
          EXIT;
        END;

        ContBusinessRelation.RESET;
        ContBusinessRelation.SETCURRENTKEY("Link to Table","Contact No.");
        ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
        ContBusinessRelation.SETRANGE("Contact No.",Cont."Company No.");
        IF ContBusinessRelation.FINDFIRST THEN BEGIN
          IF ("Customer No." <> '') AND
             ("Customer No." <> ContBusinessRelation."No.")
          THEN
            ERROR(Text037,Cont."No.",Cont.Name,"Customer No.")
          ELSE IF "Customer No." = '' THEN BEGIN
              SkipSellToContact := TRUE;
              VALIDATE("Customer No.",ContBusinessRelation."No.");
              SkipSellToContact := FALSE;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure VerifyCheckList()
    var
        VFSetup: Record "33020064";
        CheckListMaster: Record "33020068";
        LoanApprovalCheckList: Record "33020069";
        HirePurchaseSetupMaster: Record "33020080";
    begin
        IF "Application Status" <> '' THEN BEGIN
          VFSetup.GET;
          IF VFSetup."Check Application Status" THEN BEGIN
            LoanApprovalCheckList.RESET;
            LoanApprovalCheckList.SETRANGE("Document Type",LoanApprovalCheckList."Document Type"::Application);
            LoanApprovalCheckList.SETRANGE("Document No.","Application No.");
            IF NOT LoanApprovalCheckList.FINDFIRST THEN BEGIN
              CheckListMaster.RESET;
              IF CheckListMaster.FINDSET THEN REPEAT
                LoanApprovalCheckList.INIT;
                LoanApprovalCheckList."Document Type" := LoanApprovalCheckList."Document Type"::Application;
                LoanApprovalCheckList."Document No." := "Application No.";
                LoanApprovalCheckList."Check List Code" := CheckListMaster.Code;
                LoanApprovalCheckList.Description := CheckListMaster.Description;
                LoanApprovalCheckList."Description 2" := CheckListMaster."Description 2";
                LoanApprovalCheckList.INSERT;
              UNTIL CheckListMaster.NEXT = 0;
            END;
            HirePurchaseSetupMaster.GET(HirePurchaseSetupMaster.Type::"Application Status","Application Status");
            HirePurchaseSetupMaster.SETCURRENTKEY(Type,Sequence);
            HirePurchaseSetupMaster.SETRANGE(Type,HirePurchaseSetupMaster.Type::"Application Status");
            HirePurchaseSetupMaster.SETFILTER(Sequence,'..%1',HirePurchaseSetupMaster.Sequence);
            IF HirePurchaseSetupMaster.FINDFIRST THEN REPEAT
              LoanApprovalCheckList.RESET;
              LoanApprovalCheckList.SETRANGE("Document Type",LoanApprovalCheckList."Document Type"::Application);
              LoanApprovalCheckList.SETRANGE("Document No.","Application No.");
              LoanApprovalCheckList.SETRANGE("Application Status",HirePurchaseSetupMaster.Code);
              IF LoanApprovalCheckList.FINDSET THEN REPEAT
                LoanApprovalCheckList.CALCFIELDS("Is Mandatory?","Application Status");
                IF (LoanApprovalCheckList."Is Mandatory?") AND (NOT LoanApprovalCheckList."Is Accomplished?") THEN
                  IF NOT LoanApprovalCheckList.Exceptional THEN
                    ERROR('Checklist %1 must be accomplished before the Application Status is changed to %2.',
                            LoanApprovalCheckList."Check List Code","Application Status");
              UNTIL LoanApprovalCheckList.NEXT = 0;
            UNTIL HirePurchaseSetupMaster.NEXT = 0;
          END;
        END;
    end;

    [Scope('Internal')]
    procedure CheckSOLValues(VehicleFinanceAppHeader: Record "33020073"): Boolean
    var
        VehicleFinanceHeader: Record "33020062";
        VehicleFinanceLine: Record "33020063";
        VehicleFinanceSetup: Record "33020064";
        PaidUpCapital: Decimal;
        TotalFinanceValue: Decimal;
        AvailableLimit: Decimal;
    begin
        VehicleFinanceSetup.GET;
        PaidUpCapital := VehicleFinanceSetup."Exposure Value";
        //TESTFIELD("SOL Identity");
        VehicleFinanceHeader.RESET;
        VehicleFinanceHeader.SETRANGE("SOL Identity","SOL Identity");
        IF VehicleFinanceHeader.FINDFIRST THEN BEGIN
          REPEAT
            VehicleFinanceLine.RESET;
            VehicleFinanceLine.SETRANGE("Loan No.",VehicleFinanceHeader."Loan No.");
            VehicleFinanceLine.SETRANGE("Line Cleared",FALSE);
            IF VehicleFinanceLine.FINDFIRST THEN BEGIN
              TotalFinanceValue := VehicleFinanceLine."Remaining Principal Amount"
            END;
          UNTIL VehicleFinanceHeader.NEXT = 0;
        END;
        TotalFinanceValue += "Loan Amount";

        AvailableLimit := PaidUpCapital  - TotalFinanceValue;
        IF AvailableLimit < 0 THEN
          EXIT(TRUE)
        ELSE
          EXIT(FALSE);
    end;
}


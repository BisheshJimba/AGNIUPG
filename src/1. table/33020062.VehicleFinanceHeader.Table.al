table 33020062 "Vehicle Finance Header"
{
    DataCaptionFields = "Loan No.", "Customer Name";

    fields
    {
        field(1; "Loan No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "Loan No." <> xRec."Loan No." THEN BEGIN
                    VFSetup.GET;
                    NoSeriesMgt.TestManual(VFSetup."Loan Nos.");
                    "No. Series" := '';
                END;
                /*
                //insert loan approval setup check list
                CheckListSetup.RESET;
                CheckListSetup.SETRANGE(Blocked,FALSE);
                IF CheckListSetup.FINDFIRST THEN BEGIN
                  REPEAT
                    CheckList.SETRANGE("Check List Code",CheckListSetup.Code);
                    CheckList.SETRANGE("Document No.","Loan No.");
                    IF NOT CheckList.FINDFIRST THEN BEGIN
                      CheckList.INIT;
                      CheckList."Document No." := "Loan No.";
                      CheckList."Check List Code" := CheckListSetup.Code;
                      CheckList.INSERT;
                    END;
                  UNTIL CheckListSetup.NEXT =0;
                END;
                */ //NOT required, Will be created from Loan Application.

            end;
        }
        field(2; "Customer No."; Code[20])
        {
            TableRelation = Customer.No.;

            trigger OnValidate()
            begin
                Customer.RESET;
                Customer.SETRANGE("No.", "Customer No.");
                IF Customer.FINDFIRST THEN
                    "Customer Name" := Customer.Name;

                VFSetup.GET;
                VFSetup.TESTFIELD(VFSetup."Shortcut Dimension 2 Code");
                "Shortcut Dimension 2 Code" := VFSetup."Shortcut Dimension 2 Code";
            end;
        }
        field(3; "Vehicle No."; Code[20])
        {
            TableRelation = Vehicle."Serial No." WHERE(Make Code=FIELD(Make Code),
                                                        Model Code=FIELD(Model Code),
                                                        Model Version No.=FIELD(Model Version No.));

            trigger OnValidate()
            begin
                IF Vehicle.GET("Vehicle No.") THEN
                  "Sales Invoice Date" := Vehicle."Sales Date"
                ELSE
                  "Sales Invoice Date" := 0D;
            end;
        }
        field(4;"Vehicle Cost";Decimal)
        {

            trigger OnValidate()
            begin
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
                IF ("First Installment Date"<>0D) AND ("Disbursement Date"<>0D) THEN BEGIN
                  IF "Disbursement Date" > "First Installment Date" THEN
                    ERROR('%1 cannot be greater than %2.',FIELDCAPTION("Disbursement Date"),FIELDCAPTION("First Installment Date"));

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
        field(7;"Interest Rate";Decimal)
        {

            trigger OnValidate()
            begin
                VFSetup.GET;
                "Penalty %" := "Interest Rate" + VFSetup."Penalty % - Interest %";  //ZM dec 6, 2016
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
                  ERROR('You don''t have permission to disburse loan at future date.');

                IF ("First Installment Date"<>0D) AND ("Disbursement Date"<>0D) THEN BEGIN
                  IF "Disbursement Date" > "First Installment Date" THEN
                    ERROR('%1 cannot be greater than %2.',FIELDCAPTION("Disbursement Date"),FIELDCAPTION("First Installment Date"));

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
                    ERROR('%1 cannot be greater than %2.',FIELDCAPTION("Disbursement Date"),FIELDCAPTION("First Installment Date"));

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
            Editable = false;
        }
        field(27;"Financing Bank No.";Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            var
                BankAccount: Record "270";
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
            OptionCaption = 'Performing,Substandard,Doubtful,Critical,Watch list 1,Watch list 2';
            OptionMembers = Performing,Substandard,Doubtful,Critical,"Watch list 1","Watch list 2";
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
            Caption = 'Total Principal Due to clear loan';
            DecimalPlaces = 2:2;
            Editable = false;
        }
        field(36;"Interest Due";Decimal)
        {
            Caption = 'Interest Matured & Due as on Calc Date';
            Editable = false;
        }
        field(37;"Penalty Due";Decimal)
        {
            Caption = 'Penalty Due as on Calc Date';
            Editable = false;
        }
        field(38;"Insurance Due";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Payment Lines"."Insurance Paid" WHERE (Loan No.=FIELD(Loan No.),
                                                                                      Installment No.=CONST(0),
                                                                                      Insurance Paid=FILTER(<>0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39;"Other Amount Due";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Payment Lines"."Other Charges Paid" WHERE (Loan No.=FIELD(Loan No.),
                                                                                          Installment No.=CONST(0),
                                                                                          Other Charges Paid=FILTER(<>0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(40;"Due Calculated as of";Date)
        {
            Caption = 'Due Calculated as of Date';
            Editable = false;
        }
        field(41;"Total Due";Decimal)
        {
            Caption = 'Total Due to clear loan';
            Description = 'Total Due to clear loan';
            Editable = false;
        }
        field(42;"Sales Invoice Date";Date)
        {
        }
        field(43;"Due Installments";Integer)
        {
            Caption = 'Remainining Installments to clear loan';
            Editable = false;
        }
        field(44;"No of Due Days";Integer)
        {
            Caption = 'No of Days since last clearance';
            Editable = false;
        }
        field(45;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1),
                                                          Blocked=CONST(No));
        }
        field(46;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2),
                                                          Blocked=CONST(No));
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
        field(50;"Last Payment Date";Date)
        {
            CalcFormula = Max("Vehicle Finance Lines"."Last Payment Date" WHERE (Loan No.=FIELD(Loan No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51;"Model Version";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Model Version No." WHERE (Serial No.=FIELD(Vehicle No.)));
            FieldClass = FlowField;
        }
        field(52;"Blocked by";Code[20])
        {
            Editable = false;
        }
        field(53;"Blocked Date";Date)
        {
            Editable = false;
        }
        field(54;Captured;Boolean)
        {
            Editable = false;
        }
        field(55;"Captured Date";Date)
        {
            Editable = false;
        }
        field(56;"Capture Updated by";Code[20])
        {
            Editable = false;
        }
        field(57;"Days since Captured";Integer)
        {
        }
        field(58;"Followed Up in Last 30 Days";Boolean)
        {
            Editable = false;
        }
        field(59;"Bank EMI";Decimal)
        {
        }
        field(60;"Shortcut Dimension 3 Code";Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE (Dimension Code=CONST(3),
                                                          Blocked=CONST(No));
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
        field(1006;"Closed Date";Date)
        {
            Editable = false;
        }
        field(1007;"Closed by";Code[30])
        {
            Editable = false;
        }
        field(1008;Rejected;Boolean)
        {
            Editable = true;
        }
        field(1009;"Rejected Date";Date)
        {
            Editable = true;
        }
        field(1010;"Rejected by";Code[30])
        {
            Editable = true;
        }
        field(50000;Defaulter;Boolean)
        {
        }
        field(50001;"Delivery Date";Date)
        {
        }
        field(50002;"Service Charge Percent";Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Loan Amount");
                VALIDATE("Service Charge",("Service Charge Percent"/100) * "Loan Amount");
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
            Caption = 'Due Installment as on Calc Date';
            Editable = false;
        }
        field(50006;"Due Principal";Decimal)
        {
            Caption = 'Due Principal as on Calc Date';
            Editable = false;
        }
        field(50007;"Total Due as of Today";Decimal)
        {
            Caption = 'Total Due as on Calc Date';
            Editable = false;
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
        field(50014;"EMI Amount";Decimal)
        {
        }
        field(50015;"Total Principal Paid";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Payment Lines"."Principal Paid" WHERE (Loan No.=FIELD(Loan No.)));
            FieldClass = FlowField;
        }
        field(50016;"Application No.";Code[20])
        {
        }
        field(50017;"Temp Payment Description";Text[120])
        {
            Description = 'SRT';
        }
        field(50018;"Payment Receipt Date";Date)
        {
        }
        field(50019;"Exclude from Calculation";Boolean)
        {
        }
        field(50020;"Transfered Loan No.";Code[20])
        {
            Editable = false;
        }
        field(50021;"Back Date Calculated";Boolean)
        {
        }
        field(50022;"Principal Outstanding in Bank";Decimal)
        {
            CalcFormula = Sum("Bank Account Ledger Entry".Amount WHERE (VF Loan File No.=FIELD(Loan No.),
                                                                        VF Posting Type=CONST(Principal),
                                                                        Bank Account No.=FIELD(Financing Bank No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50023;"Interest Paid to Bank";Decimal)
        {
            CalcFormula = Sum("Bank Account Ledger Entry"."Credit Amount" WHERE (VF Loan File No.=FIELD(Loan No.),
                                                                                 VF Posting Type=CONST(Interest)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50024;"Interest Paid by Customer";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Payment Lines"."Interest Paid" WHERE (Loan No.=FIELD(Loan No.),
                                                                                     G/L Posting Date=FIELD(FILTER(Date Filter))));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50025;"Date to Clear Loan";Date)
        {
            CalcFormula = Max("Vehicle Finance Lines"."EMI Mature Date" WHERE (Loan No.=FIELD(Loan No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50026;"Principal Paid by Customer";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Payment Lines"."Principal Paid" WHERE (Loan No.=FIELD(Loan No.),
                                                                                      G/L Posting Date=FIELD(FILTER(Date Filter))));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50030;"Application Status";Code[50])
        {
            TableRelation = "Hire Purchase Setup Master".Code WHERE (Type=CONST(Application Status));
        }
        field(50031;"Financing Option";Code[50])
        {
            TableRelation = "Hire Purchase Setup Master".Code WHERE (Type=CONST(Financing Option));
        }
        field(50032;Purpose;Code[50])
        {
            TableRelation = "Hire Purchase Setup Master".Code WHERE (Type=CONST(Purpose));
        }
        field(50033;"Interest Due on Insurance";Decimal)
        {
            Editable = false;
        }
        field(50034;"Interest Paid on Insurance";Decimal)
        {
            CalcFormula = -Sum("Vehicle Finance Payment Lines"."Insurance Interest Paid" WHERE (Loan No.=FIELD(Loan No.),
                                                                                                Installment No.=CONST(0),
                                                                                                Insurance Interest Paid=FILTER(<>0)));
            Editable = false;
            FieldClass = FlowField;
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
        field(50100;"Make Code";Code[20])
        {
            Editable = true;
            TableRelation = Make;
        }
        field(50101;"Model Code";Code[20])
        {
            Editable = true;
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(50102;"Model Version No.";Code[20])
        {
            Editable = true;
            TableRelation = Item.No. WHERE (Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=CONST(Model Version));

            trigger OnValidate()
            begin
                //SRT Dec 5th 2019 >>
                IF Item.GET("Model Version No.") THEN
                  "Model Version No. 2" := Item."No. 2"
                ELSE
                 "Model Version No. 2" := '';
                //SRT Dec 5th 2019 <<
            end;
        }
        field(50103;Description;Text[150])
        {
        }
        field(50107;"Dealer Code";Code[20])
        {
            TableRelation = Customer WHERE (Is Dealer=CONST(Yes));
        }
        field(50108;"Model Version No. 2";Code[20])
        {
            Editable = false;
            TableRelation = Item."No. 2" WHERE (Make Code=FIELD(Make Code),
                                                Model Code=FIELD(Model Code),
                                                Item Type=CONST(Model Version));
        }
        field(50200;"Market Price";Decimal)
        {
            Description = 'Used for NRV calculation';
        }
        field(50201;"Depreciation Rate";Decimal)
        {
            Description = 'Used for NRV calculation';
        }
        field(50202;"System Sales Price";Decimal)
        {
            Description = 'Used for NRV calculation';
        }
        field(50300;"Blocked Remarks";Text[100])
        {
        }
        field(50301;"UnBlocked Remarks";Text[100])
        {

            trigger OnLookup()
            begin
                //Risk Grade Should be:  0-49.99 Poor,
                // 50 to 59.99 doubtful,
                //60 to 69.99 fair,
                // 70 to 79.99 good,
                // 80 to 89.99 very good and
                //90 to 100 excellent hunu parne
            end;
        }
        field(50302;"RAM Percentage";Decimal)
        {

            trigger OnValidate()
            begin
                //Amisha 4/23/2021
                /*
                IF "RAM Percentage"<=50 THEN
                 "Risk Grade" := "Risk Grade"::Excellent
                ELSE IF ("RAM Percentage">50) AND ("RAM Percentage"<=60) THEN
                  "Risk Grade" := "Risk Grade"::"Very good"
                ELSE IF ("RAM Percentage">60) AND ("RAM Percentage"<=70) THEN
                  "Risk Grade" := "Risk Grade"::Good
                ELSE IF ("RAM Percentage">70) AND ("RAM Percentage"<=80)THEN
                  "Risk Grade" := "Risk Grade"::Fair
                ELSE IF ("RAM Percentage">80) AND ("RAM Percentage"<=90) THEN
                  "Risk Grade" := "Risk Grade"::Doubtful
                ELSE IF ("RAM Percentage">90) AND ("RAM Percentage"<=100) THEN
                  "Risk Grade" := "Risk Grade"::Poor
                  */
                
                IF ("RAM Percentage" >= 0) AND ("RAM Percentage" <= 49.99) THEN
                 "Risk Grade" := "Risk Grade"::Poor
                ELSE IF ("RAM Percentage" >= 50) AND ("RAM Percentage" <=59.99) THEN
                 "Risk Grade" := "Risk Grade"::Doubtful
                ELSE IF ("RAM Percentage" >=60) AND ("RAM Percentage" <=69.99) THEN
                 "Risk Grade" := "Risk Grade"::Fair
                ELSE IF ("RAM Percentage" >= 70) AND ("RAM Percentage" <= 79.99) THEN
                 "Risk Grade" := "Risk Grade"::Good
                ELSE IF ("RAM Percentage" >= 80) AND ("RAM Percentage" <= 89.99) THEN
                 "Risk Grade" := "Risk Grade"::"Very good"
                ELSE
                 "Risk Grade" := "Risk Grade"::Excellent;

            end;
        }
        field(50303;"SOL Identity";Code[20])
        {
            TableRelation = "Business Relation".Code;
        }
        field(50304;"Vehicle Captured Location";Text[50])
        {
        }
        field(50305;"Captured Veh. Phy. Location";Text[50])
        {
        }
        field(50306;"Namsari Date";Date)
        {
            CalcFormula = Lookup(Vehicle."Namsari Date" WHERE (Serial No.=FIELD(Vehicle No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50307;Guarantor;Code[20])
        {
            TableRelation = Contact.No. WHERE (Guarantor=CONST(Yes));

            trigger OnValidate()
            begin
                IF "Loan Disbursed" THEN
                  ERROR('You cannot modify Gurantor of Disbursed Loan.');

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
        field(50312;"BlueBook Expire Date";Date)
        {
        }
        field(50313;"Incoming Document";Integer)
        {
        }
        field(50314;"Customer Cheque No. And  Bank";Text[75])
        {
        }
        field(60000;"Date Filter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(60001;"Expected Interest";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Lines"."Calculated Interest" WHERE (Loan No.=FIELD(Loan No.),
                                                                                   EMI Mature Date=FIELD(Date Filter)));
            FieldClass = FlowField;
        }
        field(60002;"Expected Principal";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Lines"."Calculated Principal" WHERE (Loan No.=FIELD(Loan No.),
                                                                                    EMI Mature Date=FIELD(Date Filter)));
            FieldClass = FlowField;
        }
        field(60003;"Customer's Guarantor";Text[150])
        {
        }
        field(60004;"Penalty Paid by Customer";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Payment Lines"."Penalty Paid" WHERE (Loan No.=FIELD(Loan No.),
                                                                                    G/L Posting Date=FIELD(FILTER(Date Filter))));
            FieldClass = FlowField;
        }
        field(60005;"Disbursed To";Code[20])
        {
            TableRelation = Vendor.No.;

            trigger OnLookup()
            begin
                //Min
                VFSetup.GET;
                Vendor.RESET;
                Vendor.SETCURRENTKEY("Vendor Posting Group");
                Vendor.SETFILTER("Vendor Posting Group",VFSetup."Vendor Posting Group");
                IF LookUpVendor(Vendor,"Disbursed To") THEN
                  VALIDATE("Disbursed To",Vendor."No.");
            end;
        }
        field(60006;"Date Last Line Cleared";Date)
        {
            CalcFormula = Max("Vehicle Finance Lines"."EMI Mature Date" WHERE (Loan No.=FIELD(Loan No.),
                                                                               Line Cleared=CONST(Yes)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60007;"EMI Maturity Date";Date)
        {
            CalcFormula = Min("Vehicle Finance Lines"."EMI Mature Date" WHERE (Loan No.=FIELD(Loan No.),
                                                                               Line Cleared=CONST(No)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60008;"Interest Due Defered";Decimal)
        {
            Caption = 'Add. Int. due to realize to clear loan as on Calc Date';
            Description = 'Add. Int. due to realize to clear loan as on Calc Date';
            Editable = false;
        }
        field(60009;"Total Int. Due to clear Loan";Decimal)
        {
            Caption = 'Total Interest Due to clear Loan as on Calc. Date';
            Description = 'Total Interest Due to clear Loan as on Calc. Date';
            Editable = false;
        }
        field(60010;"Due Installment Days";Integer)
        {
            Caption = 'Due Installment Days for calculation of Unrealzed Interest';
            Description = 'Due Installment Days for calculation of Unrealzed Interest';
            Editable = false;
        }
        field(60011;"Vendor No.";Code[20])
        {
            TableRelation = Vendor;
        }
        field(60012;"Due Days Crossed Maturity";Integer)
        {
        }
        field(60013;"Delivery Order No.";Code[20])
        {
            Editable = false;
        }
        field(60014;"Delivery Order Date";DateTime)
        {
            Editable = false;
        }
        field(60015;"Printed By";Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(60016;"Rejection Reason";Code[10])
        {
            TableRelation = "Reason Code".Code WHERE (Group=FILTER(Hire Purchase));
        }
        field(60017;"Vehicle Application";Code[50])
        {
        }
        field(60018;"Nominee Account No.";Code[20])
        {
            TableRelation = Customer.No. WHERE (Type=CONST(Nominee));

            trigger OnValidate()
            begin
                "Nominee Account Name" := '';
                Customer.RESET;
                Customer.SETRANGE("No.","Nominee Account No.");
                IF Customer.FINDFIRST THEN
                  "Nominee Account Name" := Customer.Name;
            end;
        }
        field(60019;"Nominee Account Name";Text[50])
        {
            Editable = false;
        }
        field(60020;"Interest Due on CAD";Decimal)
        {
        }
        field(60021;"Total Interest Paid on CAD";Decimal)
        {
            CalcFormula = Sum("Vehicle Finance Payment Lines"."CAD Interest Paid" WHERE (Loan No.=FIELD(Loan No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60022;"Legal Amount";Decimal)
        {
        }
        field(60023;"DO %";Decimal)
        {
        }
        field(60024;"DO Amount";Decimal)
        {
        }
        field(60050;"Mortgage NRV";Decimal)
        {
        }
        field(60051;"Mortgage Details";Text[50])
        {
        }
        field(60052;"Application Submitted";Boolean)
        {
        }
        field(60053;"Temp Trace ID/Ref ID";Text[120])
        {
            Description = 'SRT';
        }
        field(70052;"Created By";Code[50])
        {
        }
        field(70053;"Accidental Remarks";Text[150])
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
            Editable = false;
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
        field(90001;"Credit Facility Type";Text[10])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE (Type=CONST(Credit Facility Type));
        }
        field(90002;"Purpose of Credit Facility";Text[20])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE (Type=CONST(Purpose of Credit Facility));
        }
        field(90003;"Ownership Type";Text[10])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE (Type=CONST(Ownership Type));
        }
        field(90005;"Currency Code";Text[10])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master" WHERE (Type=CONST(Currency));
        }
        field(90006;"Repayment Frequency";Text[10])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE (Type=CONST(Repayment Frequency));
        }
        field(90007;"Credit Facility Status";Text[10])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE (Type=CONST(Credit Facility Status));
        }
        field(90008;"Reason for Closure";Text[10])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE (Type=CONST(Reason for Closure));
        }
        field(90009;"Security Coverage Flag";Text[10])
        {
            Description = 'KSKL 1.0';
            TableRelation = "Catalogues Master".Code WHERE (Type=CONST(Secutity Coverage Flag));
        }
        field(90010;"Credit Facility Sanction Curr";Text[10])
        {
            Description = 'KSKL1.0';
            TableRelation = "Catalogues Master" WHERE (Type=CONST(Currency));
        }
        field(90011;"Amount Overdue KSKL";Decimal)
        {
        }
        field(90012;"Amount Overdue 1 30 KSKL";Decimal)
        {
        }
        field(90013;"Amount Overdue 31 60 KSKL";Decimal)
        {
        }
        field(90014;"Amount Overdue 61 90 KSKL";Decimal)
        {
        }
        field(90015;"Amount Overdue 91 120 KSKL";Decimal)
        {
        }
        field(90016;"Amount Overdue 121 150 KSKL";Decimal)
        {
        }
        field(90017;"Amount Overdue 151 180 KSKL";Decimal)
        {
        }
        field(90018;"Amount Overdue 181 Above KSKL";Decimal)
        {
        }
        field(90019;"Payemnt Delay Days KSKL";Integer)
        {
        }
        field(90020;"No of Payemnt Installments KSK";Integer)
        {
        }
        field(90021;"No of Days Overdue KSKL";Integer)
        {
        }
        field(90022;"Last Repayment Amount KSKL";Decimal)
        {
        }
        field(90023;"Date of Lastpay KSKL";Date)
        {
        }
        field(90024;"Immidate Preceeding Date KSKL";Date)
        {
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
        field(33020078;"Accidental Under Insurance";Boolean)
        {
            CalcFormula = Lookup(Vehicle."Accidental Under Insurance" WHERE (Serial No.=FIELD(Vehicle No.)));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                UserSetup.GET(USERID);
                UserSetup.TESTFIELD("Can modify Accidental Ins.");
            end;
        }
        field(33020083;"Accidental Vehicle";Boolean)
        {
            CalcFormula = Lookup(Vehicle."Accidental Vehicle" WHERE (Serial No.=FIELD(Vehicle No.)));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                UserSetup.GET(USERID);
                UserSetup.TESTFIELD("Can modify Accidental Vehicle");
            end;
        }
        field(33020084;"Nature of Data";Code[10])
        {
        }
        field(33020085;"Asset Claasification";Code[10])
        {
            TableRelation = "Catalogues Master" WHERE (Type=CONST(Asset Classification));
        }
        field(33020086;"Payment Dealy History Flag";Code[10])
        {
            TableRelation = "Catalogues Master" WHERE (Type=CONST(Payment Delay History Flag));
        }
    }

    keys
    {
        key(Key1;"Loan No.")
        {
            Clustered = true;
        }
        key(Key2;"Customer No.","Loan Amount")
        {
        }
        key(Key3;"Customer Name")
        {
        }
        key(Key4;"Loan Status",Closed)
        {
            SumIndexFields = "Principal Due","Loan Amount";
        }
        key(Key5;"Transfered Loan No.")
        {
        }
        key(Key6;"Loan Disbursed","Loan Status",Closed)
        {
            SumIndexFields = "Principal Due","Loan Amount";
        }
        key(Key7;"Vehicle No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Loan No.","Customer No.","Customer Name","Vehicle Regd. No.")
        {
        }
    }

    trigger OnInsert()
    begin
        IF "Loan No." = '' THEN BEGIN
          VFSetup.GET;
          VFSetup.TESTFIELD("Loan Nos.");
          NoSeriesMgt.InitSeries(VFSetup."Loan Nos.",xRec."No. Series",0D,"Loan No.","No. Series");
        END;
        InitRec;
        "Last Date Modified" := TODAY;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := TODAY;
    end;

    var
        VFRec: Record "33020062";
        VFSetup: Record "33020064";
        NoSeriesMgt: Codeunit "396";
        CheckListSetup: Record "33020068";
        CheckList: Record "33020069";
        UserMgt: Codeunit "5700";
        Customer: Record "18";
        UserSetup: Record "91";
        Vehicle: Record "25006005";
        Contact: Record "5050";
        Item: Record "27";
        Vendor: Record "23";

    [Scope('Internal')]
    procedure AssistEdit(OldFinanceHeader: Record "33020062"): Boolean
    begin
        WITH VFRec DO BEGIN
          VFRec := Rec;
          VFSetup.GET;
          VFSetup.TESTFIELD("Loan Nos.");
          IF NoSeriesMgt.SelectSeries(VFSetup."Loan Nos.",OldFinanceHeader."No. Series","No. Series") THEN BEGIN
            VFSetup.GET;
            VFSetup.TESTFIELD("Loan Nos.");
            NoSeriesMgt.SetSeries("Loan No.");
            Rec := VFRec;
            EXIT(TRUE);
          END;
        END;
    end;

    [Scope('Internal')]
    procedure InitRec()
    begin
        "Responsibility Center" := UserMgt.GetRespCenter(0,"Responsibility Center");
    end;

    [Scope('Internal')]
    procedure SetLineSelection(var VehFinanceHeader: Record "33020062"): Boolean
    var
        VehFURegister: Record "33020075";
        Text000: Label 'Follow Up for Loan No. %1 already exist for today''s Date.';
    begin
        IF VehFinanceHeader.FINDFIRST THEN
        REPEAT
          IF VehFURegister.GET(VehFinanceHeader."Loan No.",TODAY,VehFURegister."Plan Type"::Call) THEN
            ERROR(Text000,VehFinanceHeader."Loan No.");
          CLEAR(VehFURegister);
          VehFURegister.RESET;
          VehFURegister.INIT;
          VehFURegister."Loan No." := VehFinanceHeader."Loan No.";
          VehFURegister."Follow-Up Date" := TODAY;
          VehFURegister."Plan Type" := VehFURegister."Plan Type"::Call;
          VehFURegister."Responsible Person Code" := VehFinanceHeader."Responsible Person Code";
          VehFURegister."Customer No." := VehFinanceHeader."Customer No.";
          VehFinanceHeader.CALCFIELDS("Last Payment Date");
          VehFURegister."Last Payment Date" := VehFinanceHeader."Last Payment Date";
          VehFURegister.INSERT;
        UNTIL VehFinanceHeader.NEXT = 0;
        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure TransferLoan(var VehFinHeader: Record "33020062")
    var
        Text000: Label 'Last Calculation of Dues & NRV was run on %1, Please Update Dues & NRV as of today.';
        Text001: Label 'Do you want to transfer Remaining Dues to New Customer?';
        VehLoanTransfer: Report "33020069";
    begin
        IF CONFIRM(Text001,TRUE) THEN BEGIN
            VehFinHeader.TESTFIELD("Principal Due");
            IF VehFinHeader."Due Calculated as of" <> TODAY THEN
              ERROR(Text000,VehFinHeader."Due Calculated as of");
            ERROR(FORMAT(VehFinHeader.COUNT));
            VehLoanTransfer.SETTABLEVIEW(VehFinHeader);
            VehLoanTransfer.RUN;
        END;
    end;

    [Scope('Internal')]
    procedure GetNewParametersForRescheduleEMI(LoanNo: Code[20];var NewInstallmentNo: Integer;var NewEffectiveDate: Date;var NewPrincipal: Decimal)
    var
        VFLine: Record "33020063";
    begin
        VFLine.RESET;
        VFLine.SETRANGE("Loan No.",LoanNo);
        VFLine.SETRANGE("Line Cleared",FALSE);
        IF VFLine.FINDFIRST THEN BEGIN
          NewInstallmentNo := VFLine."Installment No.";
          NewEffectiveDate := VFLine."EMI Mature Date";
        //  NewPrincipal := VFLine."Remaining Principal Amount";
        END;

        VFLine.RESET;
        VFLine.SETRANGE("Loan No.",LoanNo);
        VFLine.SETRANGE("Line Cleared",TRUE);
        IF VFLine.FINDLAST THEN BEGIN
          NewPrincipal := VFLine."Remaining Principal Amount";
        END;
    end;

    [Scope('Internal')]
    procedure GetNewPrincipal(LoanNo: Code[20];PrepaymentAmount: Decimal) NewPrincipal: Decimal
    var
        VFLine: Record "33020063";
    begin
        NewPrincipal := 0;
        VFLine.RESET;
        VFLine.SETRANGE("Loan No.",LoanNo);
        VFLine.SETRANGE("Line Cleared",FALSE);
        IF VFLine.FINDFIRST THEN BEGIN
          NewPrincipal := VFLine."Remaining Principal Amount";
        END;

        IF NewPrincipal >= PrepaymentAmount THEN
          EXIT(NewPrincipal - PrepaymentAmount)
        ELSE IF NewPrincipal < PrepaymentAmount THEN
          ERROR('Prepayment Amount cannot be greater than %1',NewPrincipal);
    end;

    [Scope('Internal')]
    procedure ViewSMSDetails()
    var
        SMSDetails: Record "33020258";
        SMSDetailsPage: Page "52042";
                            SMSDetailsNew: Record "33020258";
    begin
        SMSDetails.RESET;
        SMSDetails.CHANGECOMPANY('AGNI INCORPORATED PVT. LTD.');
        SMSDetails.SETRANGE("Document No.","Loan No.");
        IF SMSDetails.FINDFIRST THEN BEGIN

          SMSDetailsNew.RESET;
          IF SMSDetailsNew.FINDFIRST THEN BEGIN
            IF (SMSDetailsNew.COUNT > 100) OR (COMPANYNAME = 'AGNI INCORPORATED PVT. LTD.') THEN
              ERROR('You cannot run this page!');
            SMSDetailsNew.DELETEALL;
          END;
          REPEAT
            SMSDetailsNew.INIT;
            SMSDetailsNew."Entry No."  := SMSDetails."Entry No.";
            SMSDetailsNew."Message Type" := SMSDetails."Message Type";
            SMSDetailsNew."Mobile Number"  := SMSDetails."Mobile Number";
            SMSDetailsNew."Creation Date" := SMSDetails."Creation Date";
            SMSDetailsNew."Message Text" := SMSDetails."Message Text";
            SMSDetailsNew.Status := SMSDetails.Status;
            SMSDetailsNew."Last Modified Date"  := SMSDetails."Last Modified Date";
            SMSDetailsNew.Comment := SMSDetails.Comment;
            SMSDetailsNew."Location Code" := SMSDetails."Location Code";
            SMSDetailsNew."Document No." := SMSDetails."Document No.";
            SMSDetailsNew.Amount := SMSDetails.Amount;
            SMSDetailsNew.Company := SMSDetails.Company;
            SMSDetailsNew.INSERT;
          UNTIL SMSDetails.NEXT =0;
        END;
        SMSDetailsNew.RESET;
        SMSDetailsNew.SETRANGE("Document No.","Loan No.");
        IF SMSDetailsNew.FINDFIRST THEN;

        SMSDetailsPage.SETRECORD(SMSDetailsNew);
        SMSDetailsPage.SETTABLEVIEW(SMSDetailsNew);
        SMSDetailsPage.EDITABLE(FALSE);
        SMSDetailsPage.RUN;
    end;

    [Scope('Internal')]
    procedure LookUpVendor(var recVendor: Record "23";codCode: Code[20]): Boolean
    var
        frmVendorList: Page "27";
    begin
        CLEAR(frmVendorList);
        IF codCode <> '' THEN
         IF recVendor.GET(codCode) THEN
          frmVendorList.SETRECORD(recVendor);
        frmVendorList.SETTABLEVIEW(recVendor);
        frmVendorList.LOOKUPMODE(TRUE);
        IF frmVendorList.RUNMODAL = ACTION::LookupOK THEN
         BEGIN
          frmVendorList.GETRECORD(recVendor);
          EXIT(TRUE)
        END;
        EXIT(FALSE)
    end;
}


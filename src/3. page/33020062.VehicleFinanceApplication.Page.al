page 33020062 "Vehicle Finance Application"
{
    Caption = 'Vehicle Finance Application';
    DeleteAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Reschedule,Category5_caption,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    RefreshOnActivate = true;
    SourceTable = Table33020073;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Application No."; "Application No.")
                {

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Application Open Date"; "Application Open Date")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Contact No."; "Contact No.")
                {
                }
                field("Contact Name"; "Contact Name")
                {
                }
                field(PAN; PAN)
                {
                    Editable = false;
                    ToolTip = 'Update PAN in customer card';
                }
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version"; "Model Version")
                {
                }
                field("Model Version No. 2"; "Model Version No. 2")
                {
                    Visible = false;
                }
                field("Vehicle No."; "Vehicle No.")
                {
                    Importance = Promoted;
                }
                field(Description; Description)
                {
                }
                field("Interest Rate"; "Interest Rate")
                {
                    Caption = 'Discounted Interest % ';
                    Editable = InterestEditable;
                }
                field("Actual Interest Rate"; "Actual Interest Rate")
                {
                    Editable = false;
                }
                field("Penalty %"; "Penalty %")
                {
                    Editable = true;
                }
                field("Tenure in Months"; "Tenure in Months")
                {
                }
                field("Disbursement Date"; "Disbursement Date")
                {
                }
                field("First Installment Date"; "First Installment Date")
                {
                }
                field("EMI Type"; "EMI Type")
                {
                }
                field("Loan Status"; "Loan Status")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Vehicle Cost"; "Vehicle Cost")
                {
                }
                field("Down Payment"; "Down Payment")
                {
                }
                field("Loan Amount"; "Loan Amount")
                {
                }
                field("Credit Allowded Days (CAD)"; "Credit Allowded Days (CAD)")
                {
                    Editable = false;
                }
                field("Interest on CAD"; "Interest on CAD")
                {
                    Editable = false;
                }
                field("Responsible Person Code"; "Responsible Person Code")
                {
                    Caption = 'Credit Officer''s Code';
                }
                field("Responsible Person Name"; "Responsible Person Name")
                {
                    Caption = 'Credit Officer''s Name';
                }
                field("Application Submitted"; "Application Submitted")
                {
                    Visible = IsHirePurchase;
                }
                field("Application Status"; "Application Status")
                {
                    Editable = false;
                    Visible = IsHirePurchase;
                }
                field("Financing Option"; "Financing Option")
                {
                }
                field(Purpose; Purpose)
                {
                }
                field("Vehicle Application"; "Vehicle Application")
                {
                }
                field("Dealer Code"; "Dealer Code")
                {
                }
                field("Rejection Date"; "Rejection Date")
                {
                }
                field("Reason For Loan Rejection"; "Reason For Loan Rejection")
                {
                }
                field("RAM Percentage"; "RAM Percentage")
                {
                    Editable = false;
                }
                field("Risk Grade"; "Risk Grade")
                {
                }
                field("Property NRV"; "Mortgage NRV")
                {
                    Caption = 'Property NRV';
                }
                field("Property Details"; "Mortgage Details")
                {
                    Caption = 'Property Details';
                }
                field("Created By"; "Created By")
                {
                }
                field("Verified By"; "Verified By")
                {
                    Editable = false;
                }
                field(Verified; Verified)
                {
                    Editable = false;
                }
                field("Verified Date"; "Verified Date")
                {
                }
                field("Agni Branches"; "Agni Branches")
                {
                }
                field("SOL Identity"; "SOL Identity")
                {
                    Visible = false;
                }
            }
            part(FinanceLine; 33020063)
            {
                SubPageLink = Application No.=FIELD(Application No.);
                    SubPageView = SORTING(Application No.,Line No.)
                              ORDER(Ascending);
            }
            group("Guarantor Details ")
            {
                field(Guarantor; Guarantor)
                {
                }
                field(Name; "Guarantor Name")
                {
                }
                field(Address; "Guarantor Address")
                {
                }
                field("Mobile No."; "Guarantor Mobile No.")
                {
                }
                field("Contact Person"; "Guarantor Contact Person")
                {
                }
                field("Customer's Guarantor"; "Customer's Guarantor")
                {
                }
            }
            group(Mortgage)
            {
                field("Owner Name"; "Owner Name")
                {
                }
                field("Property Address"; "Property Address")
                {
                }
                field("Land Area"; "Land Area")
                {
                }
                field("Building Area"; "Building Area")
                {
                }
                field("Market Value"; "Market Value")
                {
                }
                field("Distress Value"; "Distress Value")
                {
                }
                field("Valued Date"; "Valued Date")
                {
                }
                field("Valued By"; "Valued By")
                {
                }
            }
            group("Bank Detail")
            {
                Visible = ShowBankDetail;
                field("Financing Bank No."; "Financing Bank No.")
                {

                    trigger OnValidate()
                    begin
                        //CALCFIELDS("Bank Name");
                    end;
                }
                field("Bank Name"; "Bank Name")
                {
                    Editable = false;
                }
                field("Bank Interest Rate"; "Bank Interest Rate")
                {
                    Editable = false;
                }
            }
            group("Special Cases")
            {
                field("Requested By"; "Requested By")
                {
                }
                field("Request Type"; "Request Type")
                {
                }
                field("Subventions/Loss Assurances"; "Subventions/Loss Assurances")
                {
                }
                field("Special Financing period"; "Special Financing period")
                {
                }
                field(Remarks; Remarks)
                {
                }
            }
            group("KSKL Loan")
            {
                field("Credit Facility Type"; "Credit Facility Type")
                {
                }
                field("Purpose of Credit Facility"; "Purpose of Credit Facility")
                {
                }
                field("Ownership Type"; "Ownership Type")
                {
                }
                field("Customer Credit Limit"; "Customer Credit Limit")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Repayment Frequency"; "Repayment Frequency")
                {
                }
                field("Credit Facility Status"; "Credit Facility Status")
                {
                }
                field("Reason for Closure"; "Reason for Closure")
                {
                }
                field("Security Coverage Flag"; "Security Coverage Flag")
                {
                }
                field("Credit Facility Sanction Curr"; "Credit Facility Sanction Curr")
                {
                }
            }
        }
        area(factboxes)
        {
            part(; 9084)
            {
                SubPageLink = No.=FIELD(Customer No.);
            }
            part(; 33020065)
            {
                SubPageLink = Serial No.=FIELD(Vehicle No.);
            }
            systempart(; Links)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1102159026>")
            {
                Caption = 'Function';
                action("Create Nominee Account")
                {
                    Image = CreateForm;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = IsHirePurchase;

                    trigger OnAction()
                    begin
                        CalculateEMI.CreateNomineeAccount("Customer No.", "Nominee Account No.", "Nominee Account Name");
                    end;
                }
                action("Calculate EMI")
                {
                    Ellipsis = true;
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    begin
                        VFSetup.GET;
                        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN
                            CalculateEMI.CalculateEMI("Loan Amount", "Interest Rate", "Tenure in Months", "Application No.", FALSE)
                        ELSE
                            CalculateEMI_VF.CalculateEMI("Loan Amount", "Interest Rate", "Tenure in Months", "Application No.", FALSE);
                        MESSAGE('Repayment schedule and EMI calculated successfully.');
                    end;
                }
                action("Verify Loan")
                {
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    var
                        VFSetup: Record "33020064";
                    begin
                        OK := CONFIRM('Do you want to verify this loan?');
                        IF OK THEN BEGIN
                            UserSetup.SETRANGE(UserSetup."User ID", USERID);
                            IF UserSetup.FINDFIRST THEN BEGIN
                                //ZM feb 9, 2017 >>
                                LoanProcTracking.RESET;
                                LoanProcTracking.SETRANGE("Application No.", "Application No.");
                                IF NOT LoanProcTracking.FINDFIRST THEN
                                    ERROR('Loan Process Tracking sheet has not been created yet!');
                                //ZM feb 9, 2017 <<
                                IF NOT UserSetup."Can Verify Loan" THEN
                                    ERROR('You do not have the permission to Verify loan.');
                                IF "Contact No." = '' THEN
                                    TESTFIELD("Customer No.")
                                ELSE BEGIN
                                    Contact.SETRANGE("No.", "Contact No.");
                                    IF Contact.FINDFIRST THEN BEGIN
                                        ContactRelation.SETRANGE("Contact No.", "Contact No.");
                                        ContactRelation.SETRANGE("Link to Table", ContactRelation."Link to Table"::Customer);
                                        IF ContactRelation.FINDFIRST THEN
                                            "Customer No." := ContactRelation."No."
                                        ELSE
                                            ERROR('No customer has been created for Contact No. %1. Please open Contact Card and convert'
                                                    + ' it as Customer', "Contact No.");
                                    END;
                                END;
                                /*
                               IF "Service Charge" = 0 THEN
                                 OK := CONFIRM('There is no service charge assigned for this loan application. Are you sure to proceed it?');
                                 IF NOT OK THEN
                                   ERROR('No any action taken.');
                                   */

                                //TESTFIELD("SOL Identity"); Temporarily disabled on 20-07-2017 as per request from Mr. Saurabh Bhandari
                                /*IF CheckSOLValues(Rec) THEN //Commented no need for Agni HP
                                  IF NOT CONFIRM('Total finance value will exceed the Exposure value.Do you want to continue ?') THEN
                                    ERROR('Aborted by user!');*/

                                TestCheckList("Application No.");
                                TESTFIELD("Interest Rate");
                                TESTFIELD("Penalty %");
                                TESTFIELD("Tenure in Months");
                                TESTFIELD("Vehicle Cost");
                                TESTFIELD("Down Payment");
                                TESTFIELD("Loan Amount");
                                //TESTFIELD("Disbursement Date");
                                //TESTFIELD("First Installment Date");
                                //TESTFIELD("Service Charge");
                                //TESTFIELD("Sales Invoice Date");
                                TESTFIELD("Responsible Person Code");

                                /*IF VFSetup.GET THEN
                                  IF VFSetup."Policy Type" <> VFSetup."Policy Type"::"Hire Purchase" THEN    //Oct 11, 2017
                                    TESTFIELD("Application Status");*/

                                TESTFIELD("Financing Option");
                                TESTFIELD(Purpose);
                                TESTFIELD("Vehicle Application");
                                TESTFIELD("Financing Bank No.");
                                TESTFIELD("Bank Interest Rate");

                                IF VFSetup.GET THEN BEGIN
                                    IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN BEGIN
                                        TESTFIELD("Shortcut Dimension 1 Code");
                                        TESTFIELD("Shortcut Dimension 2 Code");
                                        TESTFIELD("Application Submitted");  //Oct 11, 2017
                                    END;
                                END;

                                IF ("Model Version" = '') AND (Description = '') THEN
                                    ERROR('You must specify either Model Version or Description.');
                                IF "Model Version" <> '' THEN BEGIN
                                    TESTFIELD("Make Code");
                                    TESTFIELD("Model Code");
                                    TESTFIELD("Model Version");

                                END;
                                Verified := TRUE;
                                "Verified By" := USERID;
                                "Verified Date" := WORKDATE;
                                "Application Status" := 'LOAN VERIFIED';
                                MODIFY;
                                /*
                                VFSetup.GET;
                                VFHeader.INIT;
                                VFHeader.TRANSFERFIELDS(Rec,TRUE);
                                NewLoanNo := NoSeriesMgt.GetNextNo(VFSetup."Loan Nos.",TODAY,TRUE);
                                NewDeliveryNo := NoSeriesMgt.GetNextNo(VFSetup."Delivery Order Nos.",TODAY,TRUE); //Min
                                VFHeader."Loan No." := NewLoanNo;
                                VFHeader."Delivery Order No." := NewDeliveryNo; //Min
                                VFHeader."Delivery Order Date" := CURRENTDATETIME; //Min
                                VFHeader."Application No." := "Application No.";
                                IF Customer.GET("Customer No.") THEN
                                  VFHeader."Customer Name" := Customer.Name;
                                VFHeader."Make Code" := "Make Code";
                                VFHeader."Model Code" := "Model Code";
                                VFHeader."Model Version No." := "Model Version";
                                VFHeader."Vehicle Application" := "Vehicle Application";
                                VFHeader."Dealer Code" := "Dealer Code"; //SM 15 Feb 2016
                                VFHeader."RAM Percentage" := "RAM Percentage"; //ZM Aug 11, 2016
                                VFHeader."Customer's Guarantor" := "Customer's Guarantor"; //ZM Aug 31, 2016
                                VFHeader.VALIDATE("Nominee Account No.",Customer."Nominee Account");
                                IF Vehicle.GET(VFHeader."Vehicle No.") THEN BEGIN   //ZM Sep 13, 2017
                                  VFHeader."Sales Invoice Date" := Vehicle."Sales Date";
                                  VFHeader."Delivery Date" := Vehicle."Vehicle Delivery Date";
                                  VFHeader."Namsari Date" := Vehicle."Namsari Date";
                                END;

                                //SRT Sept 19th 2019 >>
                                VFHeader."Requested By" := "Requested By";//: (say CV/PV/SASPL/SEMPL)
                                VFHeader."Request Type" := "Request Type"; //: (say Bulk Financing/ Sector Financing)
                                VFHeader."Subventions/Loss Assurances" := "Subventions/Loss Assurances";// (1% additional Loss pool/ Assurance to indemnify losses)
                                VFHeader."Special Financing period" := "Special Financing period"; //:(1 month starting, June, 2019)
                                VFHeader.Remarks := Remarks; //: (the no of characters should be more in this field, as description for the case may be required)
                                //SRT Sept 19th 2019 <<

                                VFHeader.INSERT;*/
                                VFAppLine.RESET;
                                VFAppLine.SETRANGE("Application No.", "Application No.");
                                IF NOT VFAppLine.FINDFIRST THEN
                                    ERROR('No EMI has been generated. Please calculate EMI first and verify.');

                                /*LoanProcTracking.RESET;
                                LoanProcTracking.SETRANGE("Application No.","Application No.");
                                LoanProcTracking.SETRANGE(Components,'LOAN APPROVED');
                                IF LoanProcTracking.FINDFIRST THEN BEGIN
                                  LoanProcTracking.VALIDATE(Processed,TRUE);
                                  LoanProcTracking.MODIFY;
                                END;

                                TransferChecklist("Application No.");*/
                                MESSAGE(Text0001);
                            END;
                        END;
                        CurrPage.CLOSE;

                    end;
                }
                action("Approve Loan")
                {
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    var
                        VFSetup: Record "33020064";
                    begin
                        OK := CONFIRM('Do you want to approve this loan?');
                        IF OK THEN BEGIN
                            IF NOT Verified THEN //Min
                                ERROR(Text0003);
                            //<< prabesh  12-6-23
                            IF Rec."Loan Amount" >= 2500000 THEN BEGIN
                                Rec.CALCFIELDS(PAN);
                                IF Rec.PAN = '' THEN
                                    ERROR('PAN Number is Blank. Update Customer Card.');
                            END;
                            //prabesh >>
                            UserSetup.SETRANGE(UserSetup."User ID", USERID);
                            IF UserSetup.FINDFIRST THEN BEGIN
                                //ZM feb 9, 2017 >>
                                /*LoanProcTracking.RESET;
                                LoanProcTracking.SETRANGE("Application No.","Application No.");
                                IF NOT LoanProcTracking.FINDFIRST THEN
                                  ERROR('Loan Process Tracking sheet has not been created yet!');*/
                                //ZM feb 9, 2017 <<
                                IF NOT UserSetup."Can Approve Vehicle Loan" THEN
                                    ERROR('You do not have the permission to approve loan.');
                                /*IF "Contact No." = '' THEN
                                  TESTFIELD("Customer No.")
                                ELSE BEGIN
                                  Contact.SETRANGE("No.","Contact No.");
                                  IF Contact.FINDFIRST THEN BEGIN
                                    ContactRelation.SETRANGE("Contact No.","Contact No.");
                                    ContactRelation.SETRANGE("Link to Table",ContactRelation."Link to Table"::Customer);
                                    IF ContactRelation.FINDFIRST THEN
                                      "Customer No." := ContactRelation."No."
                                    ELSE
                                      ERROR('No customer has been created for Contact No. %1. Please open Contact Card and convert'
                                              + ' it as Customer',"Contact No.");
                                  END;
                                END;
                                 {
                                IF "Service Charge" = 0 THEN
                                  OK := CONFIRM('There is no service charge assigned for this loan application. Are you sure to proceed it?');
                                  IF NOT OK THEN
                                    ERROR('No any action taken.');
                                    }

                                //TESTFIELD("SOL Identity"); Temporarily disabled on 20-07-2017 as per request from Mr. Saurabh Bhandari
                                IF CheckSOLValues(Rec) THEN
                                  IF NOT CONFIRM('Total finance value will exceed the Exposure value.Do you want to continue ?') THEN
                                    ERROR('Aborted by user!');

                                TestCheckList("Application No.");
                                TESTFIELD("Interest Rate");
                                TESTFIELD("Penalty %");
                                TESTFIELD("Tenure in Months");
                                TESTFIELD("Vehicle Cost");
                                TESTFIELD("Down Payment");
                                TESTFIELD("Loan Amount");
                                //TESTFIELD("Disbursement Date");
                                //TESTFIELD("First Installment Date");
                                //TESTFIELD("Service Charge");
                                //TESTFIELD("Sales Invoice Date");
                                TESTFIELD("Responsible Person Code");

                                IF VFSetup.GET THEN
                                  IF VFSetup."Policy Type" <> VFSetup."Policy Type"::"Hire Purchase" THEN    //Oct 11, 2017
                                    TESTFIELD("Application Status");

                                TESTFIELD("Financing Option");
                                TESTFIELD(Purpose);
                                TESTFIELD("Vehicle Application");
                                TESTFIELD("Financing Bank No.");
                                TESTFIELD("Bank Interest Rate");

                                IF VFSetup.GET THEN BEGIN
                                  IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN BEGIN
                                    TESTFIELD("Shortcut Dimension 1 Code");
                                    TESTFIELD("Shortcut Dimension 2 Code");
                                    TESTFIELD("Application Submitted");  //Oct 11, 2017
                                  END;
                                END;

                                    IF ("Model Version" = '') AND (Description = '') THEN
                                  ERROR('You must specify either Model Version or Description.');
                                IF "Model Version" <> '' THEN BEGIN
                                  TESTFIELD("Make Code");
                                  TESTFIELD("Model Code");
                                  TESTFIELD("Model Version");

                                END;*/
                                TESTFIELD("Agni Branches");//aakrista
                                Approved := TRUE;
                                "Approved By" := USERID;
                                "Approved Date" := WORKDATE;
                                "Application Status" := 'LOAN APPROVED';
                                MODIFY;

                                VFSetup.GET;
                                VFHeader.INIT;
                                VFHeader.TRANSFERFIELDS(Rec, TRUE);
                                NewLoanNo := NoSeriesMgt.GetNextNo(VFSetup."Loan Nos.", TODAY, TRUE);
                                NewDeliveryNo := NoSeriesMgt.GetNextNo(VFSetup."Delivery Order Nos.", TODAY, TRUE); //Min
                                VFHeader."Loan No." := NewLoanNo;
                                VFHeader."Delivery Order No." := NewDeliveryNo; //Min
                                VFHeader."Delivery Order Date" := CURRENTDATETIME; //Min
                                VFHeader."Application No." := "Application No.";
                                IF Customer.GET("Customer No.") THEN
                                    VFHeader."Customer Name" := Customer.Name;
                                VFHeader."Make Code" := "Make Code";
                                VFHeader."Model Code" := "Model Code";
                                VFHeader."Model Version No." := "Model Version";
                                VFHeader."Vehicle Application" := "Vehicle Application";
                                VFHeader."Dealer Code" := "Dealer Code"; //SM 15 Feb 2016
                                VFHeader."RAM Percentage" := "RAM Percentage"; //ZM Aug 11, 2016
                                VFHeader."Customer's Guarantor" := "Customer's Guarantor"; //ZM Aug 31, 2016
                                VFHeader.VALIDATE("Nominee Account No.", Customer."Nominee Account");
                                IF Vehicle.GET(VFHeader."Vehicle No.") THEN BEGIN   //ZM Sep 13, 2017
                                    VFHeader."Sales Invoice Date" := Vehicle."Sales Date";
                                    VFHeader."Delivery Date" := Vehicle."Vehicle Delivery Date";
                                    VFHeader."Namsari Date" := Vehicle."Namsari Date";
                                END;

                                //SRT Sept 19th 2019 >>
                                VFHeader."Requested By" := "Requested By";//: (say CV/PV/SASPL/SEMPL)
                                VFHeader."Request Type" := "Request Type"; //: (say Bulk Financing/ Sector Financing)
                                VFHeader."Subventions/Loss Assurances" := "Subventions/Loss Assurances";// (1% additional Loss pool/ Assurance to indemnify losses)
                                VFHeader."Special Financing period" := "Special Financing period"; //:(1 month starting, June, 2019)
                                VFHeader.Remarks := Remarks; //: (the no of characters should be more in this field, as description for the case may be required)
                                                             //SRT Sept 19th 2019 <<

                                VFHeader.INSERT;
                                VFAppLine.SETRANGE("Application No.", "Application No.");
                                IF VFAppLine.FINDFIRST THEN BEGIN
                                    REPEAT
                                        VFLine.INIT;
                                        VFLine."Loan No." := NewLoanNo;
                                        VFLine."Installment No." := VFAppLine."Installment No.";
                                        VFLine."Line No." := VFAppLine."Line No.";
                                        VFLine."EMI Mature Date" := VFAppLine."EMI Mature Date";
                                        VFLine."EMI Amount" := VFAppLine."EMI Amount";
                                        VFLine."Calculated Principal" := VFAppLine."Calculated Principal";
                                        VFLine."Calculated Interest" := VFAppLine."Calculated Interest";
                                        VFLine.Balance := VFAppLine.Balance;
                                        VFLine."Remaining Principal Amount" := "Loan Amount";
                                        VFLine.INSERT;
                                    UNTIL VFAppLine.NEXT = 0;
                                END ELSE
                                    ERROR('No EMI has been generated. Please calculate EMI first and approve.');

                                LoanProcTracking.RESET;
                                LoanProcTracking.SETRANGE("Application No.", "Application No.");
                                LoanProcTracking.SETRANGE(Components, 'LOAN APPROVED');
                                IF LoanProcTracking.FINDFIRST THEN BEGIN
                                    LoanProcTracking.VALIDATE(Processed, TRUE);
                                    LoanProcTracking.MODIFY;
                                END;

                                TransferChecklist("Application No.");
                                MESSAGE(Text0002, NewLoanNo);
                            END;
                        END;
                        CurrPage.CLOSE;

                    end;
                }
                action("Loan Approval Checklist")
                {
                    Image = CheckRulesSyntax;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    begin
                        LoanApprovalCheckList.RESET;
                        LoanApprovalCheckList.SETRANGE("Document Type", LoanApprovalCheckList."Document Type"::Application);
                        LoanApprovalCheckList.SETRANGE("Document No.", "Application No.");
                        IF NOT LoanApprovalCheckList.FINDFIRST THEN BEGIN
                            CheckListMaster.RESET;
                            CheckListMaster.SETRANGE(Blocked, FALSE);  //ZM Apr 12 2018
                            IF CheckListMaster.FINDSET THEN
                                REPEAT
                                    LoanApprovalCheckList.INIT;
                                    LoanApprovalCheckList."Document Type" := LoanApprovalCheckList."Document Type"::Application;
                                    LoanApprovalCheckList."Document No." := "Application No.";
                                    LoanApprovalCheckList."Check List Code" := CheckListMaster.Code;
                                    LoanApprovalCheckList.Description := CheckListMaster.Description;
                                    LoanApprovalCheckList."Description 2" := CheckListMaster."Description 2";
                                    LoanApprovalCheckList.INSERT;
                                UNTIL CheckListMaster.NEXT = 0;
                        END;
                        LoanApprovalCheckList.SETRANGE("Document Type", LoanApprovalCheckList."Document Type"::Application);
                        LoanApprovalCheckList.SETRANGE("Document No.", "Application No.");
                        LoanApprovalCheckListPage.SETTABLEVIEW(LoanApprovalCheckList);
                        LoanApprovalCheckListPage.RUN;
                    end;
                }
                action("Reject Loan")
                {
                    Visible = EditLoan;

                    trigger OnAction()
                    begin
                        OK := CONFIRM('Are you sure you want to reject this loan application?');
                        TESTFIELD("Reason For Loan Rejection");
                        IF OK THEN BEGIN
                            Rejected := TRUE;
                            "Rejection Date" := TODAY;
                            MODIFY;
                            MESSAGE('Loan application rejected successfully.');
                        END;
                    end;
                }
                action("Risk Assessment")
                {
                    Image = MaintenanceLedgerEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        VehicleFinanceHeader: Record "33020062";
                    begin
                        VehicleFinanceHeader.RESET;
                        VehicleFinanceHeader.SETRANGE("Application No.", "Application No.");
                        IF VehicleFinanceHeader.FINDFIRST THEN BEGIN
                            RiskAssessment.RESET;
                            RiskAssessment.SETRANGE("Loan No.", VehicleFinanceHeader."Loan No.");
                            IF RiskAssessment.FINDFIRST THEN BEGIN
                                RiskAssessment.SETRANGE("Loan No.", VehicleFinanceHeader."Loan No.");
                                LoanRiskAssessmentList.SETTABLEVIEW(RiskAssessment);
                                LoanRiskAssessmentList.RUN;
                            END ELSE BEGIN
                                RiskAssessment.RESET;
                                RiskAssessment.SETRANGE("Loan No.", "Application No.");
                                IF NOT RiskAssessment.FINDFIRST THEN BEGIN
                                    RiskAssessmentSetup.RESET;
                                    IF RiskAssessmentSetup.FINDSET THEN
                                        REPEAT
                                            RiskAssessment.INIT;
                                            RiskAssessment."Loan No." := "Application No.";
                                            RiskAssessment.Code := RiskAssessmentSetup.Code;
                                            RiskAssessment.Description := RiskAssessmentSetup.Description;
                                            RiskAssessment.VALIDATE("Weightage (A)", RiskAssessmentSetup."Weightage (A)");
                                            RiskAssessment.VALIDATE("Score (B)", RiskAssessmentSetup."Score (B)");
                                            RiskAssessment.INSERT;
                                        UNTIL RiskAssessmentSetup.NEXT = 0;
                                END;
                                RiskAssessment.SETRANGE("Loan No.", "Application No.");
                                LoanRiskAssessmentList.SETTABLEVIEW(RiskAssessment);
                                LoanRiskAssessmentList.RUN;
                            END;
                        END ELSE BEGIN
                            RiskAssessment.RESET;
                            RiskAssessment.SETRANGE("Loan No.", "Application No.");
                            IF NOT RiskAssessment.FINDFIRST THEN BEGIN
                                RiskAssessmentSetup.RESET;
                                IF RiskAssessmentSetup.FINDSET THEN
                                    REPEAT
                                        RiskAssessment.INIT;
                                        RiskAssessment."Loan No." := "Application No.";
                                        RiskAssessment.Code := RiskAssessmentSetup.Code;
                                        RiskAssessment.Description := RiskAssessmentSetup.Description;
                                        RiskAssessment.VALIDATE("Weightage (A)", RiskAssessmentSetup."Weightage (A)");
                                        RiskAssessment.VALIDATE("Score (B)", RiskAssessmentSetup."Score (B)");
                                        RiskAssessment.INSERT;
                                    UNTIL RiskAssessmentSetup.NEXT = 0;
                            END;
                            RiskAssessment.SETRANGE("Loan No.", "Application No.");
                            LoanRiskAssessmentList.SETTABLEVIEW(RiskAssessment);
                            LoanRiskAssessmentList.RUN;
                        END;
                    end;
                }
                action("RAM Calculation Report")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        RiskAssessmentRec: Record "33020082";
                        VehicleFinanceAppHeader: Record "33020073";
                    begin
                        VehicleFinanceAppHeader.RESET;
                        VehicleFinanceAppHeader.SETRANGE("Application No.", "Application No.");
                        IF VehicleFinanceAppHeader.FINDFIRST THEN;

                        RiskAssessmentRec.RESET;
                        RiskAssessmentRec.SETRANGE("Loan No.", "Application No.");
                        IF RiskAssessmentRec.FINDSET THEN
                            REPORT.RUNMODAL(33020178, TRUE, FALSE, RiskAssessmentRec);
                    end;
                }
                action("Loan Processing Tracking Sheet")
                {
                    Image = Timesheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        LoanProcTracking: Record "33020084";
                        LoanProcTrackingSheet: Page "33020286";
                        GeneralMaster: Record "33020061";
                        LoanProcTrackingRec: Record "33020084";
                        LineNo: Integer;
                    begin
                        LoanProcTracking.RESET;
                        LoanProcTracking.SETRANGE("Application No.", "Application No.");
                        IF LoanProcTracking.FINDFIRST THEN BEGIN
                            InsertMissingLoanTrackingMaster(Rec); //SRT Dec 5th 2019
                            LoanProcTrackingSheet.SETRECORD(LoanProcTracking);
                            LoanProcTrackingSheet.SETTABLEVIEW(LoanProcTracking);
                            LoanProcTrackingSheet.RUN;
                        END ELSE BEGIN
                            GeneralMaster.RESET;
                            GeneralMaster.SETRANGE(Category, 'Vehicle Loan');
                            GeneralMaster.SETRANGE("Sub Category", 'Components');
                            GeneralMaster.SETRANGE(Disable, FALSE);
                            GeneralMaster.SETCURRENTKEY("Sequence No.");
                            IF GeneralMaster.FINDFIRST THEN BEGIN
                                LineNo := 10000;
                                REPEAT
                                    LoanProcTrackingRec.INIT;
                                    LoanProcTrackingRec."Application No." := "Application No.";
                                    LoanProcTrackingRec."Line No." := LineNo;
                                    LoanProcTrackingRec.Components := GeneralMaster.Code;
                                    LoanProcTrackingRec."Components Description" := GeneralMaster.Description;
                                    IF LoanProcTrackingRec."Line No." = 10000 THEN BEGIN
                                        LoanProcTrackingRec.Processed := TRUE;
                                        LoanProcTrackingRec."Processing Time" := 0;
                                        LoanProcTrackingRec."User Id" := "Created By";
                                        LoanProcTrackingRec.Date := "Application Open Date";
                                    END;
                                    LoanProcTrackingRec.INSERT;
                                    LineNo := LineNo + 10000;

                                UNTIL GeneralMaster.NEXT = 0;
                            END;
                            LoanProcTracking.RESET;
                            LoanProcTracking.SETRANGE("Application No.", "Application No.");
                            IF LoanProcTracking.FINDFIRST THEN BEGIN
                                LoanProcTrackingSheet.SETRECORD(LoanProcTracking);
                                LoanProcTrackingSheet.SETTABLEVIEW(LoanProcTracking);
                                LoanProcTrackingSheet.RUN;
                            END;
                        END;
                    end;
                }
                action(SOL)
                {
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        VehicleFinanceApp.RESET;
                        VehicleFinanceApp.SETRANGE("Application No.", "Application No.");
                        IF VehicleFinanceApp.FINDFIRST THEN BEGIN
                            SOLReport.SETTABLEVIEW(VehicleFinanceApp);
                            SOLReport.RUN;
                        END;
                    end;
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                action("Payment Schedule")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        rept: Report "33020064";
                    begin
                        //rept.SETTABLEVIEW(Rec);
                        //rept.RUN;
                        CurrPage.SETSELECTIONFILTER(VFAppHeader);
                        REPORT.RUN(33020065, TRUE, FALSE, VFAppHeader);
                    end;
                }
            }
            group(IncomingDocument)
            {
                Caption = 'Incoming Document';
                Image = Documents;
                action(IncomingDocCard)
                {
                    ApplicationArea = Suite;
                    Caption = 'View Incoming Document';
                    Enabled = HasIncomingDocument;
                    Image = ViewOrder;
                    ToolTip = 'View any incoming document records and file attachments that exist for the entry or document, for example for auditing purposes';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "130";
                    begin
                        IncomingDocument.ShowCardFromEntryNo("Incoming Document Entry No.");
                    end;
                }
                action(SelectIncomingDoc)
                {
                    AccessByPermission = TableData 130 = R;
                    ApplicationArea = Suite;
                    Caption = 'Select Incoming Document';
                    Image = SelectLineToApply;
                    //The property 'ToolTip' cannot be empty.
                    //ToolTip = '';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "130";
                    begin
                        VALIDATE("Incoming Document Entry No.", IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.", RECORDID));
                    end;
                }
                action(IncomingDocAttachFile)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Incoming Document from File';
                    Ellipsis = true;
                    Enabled = CreateIncomingDocumentEnabled;
                    Image = Attach;
                    ToolTip = 'Create an incoming document from a file that you select from the disk. The file will be attached to the incoming document record.';

                    trigger OnAction()
                    var
                        IncomingDocumentAttachment: Record "133";
                    begin
                        IncomingDocumentAttachment.NewAttachmentFromHirepurchaseAppDocument(Rec);
                    end;
                }
                action(RemoveIncomingDoc)
                {
                    ApplicationArea = Suite;
                    Caption = 'Remove Incoming Document';
                    Enabled = HasIncomingDocument;
                    Image = RemoveLine;
                    //The property 'ToolTip' cannot be empty.
                    //ToolTip = '';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "130";
                    begin
                        IF IncomingDocument.GET("Incoming Document Entry No.") THEN
                            IncomingDocument.RemoveLinkToRelatedRecord;
                        "Incoming Document Entry No." := 0;
                        MODIFY(TRUE);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CALCFIELDS("Customer Name", "Registration No.", VIN, "Responsible Person Name");
        IF Rejected THEN BEGIN
            CurrPage.EDITABLE := FALSE;
            EditLoan := FALSE;
        END ELSE BEGIN
            CurrPage.EDITABLE := TRUE;
            EditLoan := TRUE;
        END;
        HasIncomingDocument := "Incoming Document Entry No." <> 0;
        CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND ("Application No." <> '');
        UserSetup.GET(USERID); //Min
        IF NOT UserSetup."Can Edit Interest" THEN
            InterestEditable := FALSE
        ELSE
            InterestEditable := TRUE;
        UserSetup.GET(USERID); //Aakrista 4/3/2021
        IF NOT UserSetup."Can  Show HP Bank Details" THEN
            ShowBankDetail := FALSE
        ELSE
            ShowBankDetail := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        VFSetup.GET;
        "Interest Rate" := VFSetup."Penalty % - Interest %";
    end;

    trigger OnOpenPage()
    begin

        IF Rejected THEN BEGIN
            CurrPage.EDITABLE := FALSE;
            EditLoan := FALSE;
        END ELSE BEGIN
            CurrPage.EDITABLE := TRUE;
            EditLoan := TRUE;
        END;

        VFSetup.GET;
        IsHirePurchase := VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase";
    end;

    var
        CalculateEMI: Codeunit "33020062";
        CalculateEMI_VF: Codeunit "33020065";
        OK: Boolean;
        UserSetup: Record "91";
        VFHeader: Record "33020062";
        NoSeriesMgt: Codeunit "396";
        VFSetup: Record "33020064";
        VFLine: Record "33020063";
        VFAppLine: Record "33020074";
        NewLoanNo: Code[20];
        Text0001: Label 'This Loan Application has been successfully verified.';
        Contact: Record "5050";
        ContactRelation: Record "5054";
        VFAppHeader: Record "33020073";
        Customer: Record "18";
        LoanApprovalCheckListPage: Page "33020121";
        LoanApprovalCheckList: Record "33020069";
        CheckListMaster: Record "33020068";
        LoanCheckList: Record "33020069";
        [InDataSet]
        EditLoan: Boolean;
        [InDataSet]
        IsHirePurchase: Boolean;
        RiskAssessmentSetup: Record "33020081";
        RiskAssessment: Record "33020082";
        LoanRiskAssessmentList: Page "33020123";
        LoanProcTracking: Record "33020084";
        SOLReport: Report "33020061";
        VehicleFinanceApp: Record "33020073";
        Vehicle: Record "25006005";
        NewDeliveryNo: Code[20];
        HasIncomingDocument: Boolean;
        CreateIncomingDocumentEnabled: Boolean;
        ErrorHP: Label 'You Do Not Have Permission to Edit Discounted Interest %.';
        InterestEditable: Boolean;
        Text0002: Label 'This Loan Application has been approved and successfully transfered to Loan File List. The new Loan File  No. is %1.';
        Text0003: Label 'You must first Verify Loan before Loan Approve.';
        ShowBankDetail: Boolean;

    [Scope('Internal')]
    procedure TestCheckList(ApplicationNo: Code[20])
    var
        HirePurchaseSetup: Record "33020080";
    begin
        LoanApprovalCheckList.RESET;
        LoanApprovalCheckList.SETRANGE("Document Type", LoanApprovalCheckList."Document Type"::Application);
        LoanApprovalCheckList.SETRANGE("Document No.", ApplicationNo);
        IF NOT LoanApprovalCheckList.FINDFIRST THEN BEGIN
            CheckListMaster.RESET;
            IF CheckListMaster.FINDSET THEN
                REPEAT
                    LoanApprovalCheckList.INIT;
                    LoanApprovalCheckList."Document Type" := LoanApprovalCheckList."Document Type"::Application;
                    LoanApprovalCheckList."Document No." := ApplicationNo;
                    LoanApprovalCheckList."Check List Code" := CheckListMaster.Code;
                    LoanApprovalCheckList.Description := CheckListMaster.Description;
                    LoanApprovalCheckList."Description 2" := CheckListMaster."Description 2";
                    LoanApprovalCheckList.INSERT;
                UNTIL CheckListMaster.NEXT = 0;
        END;

        LoanApprovalCheckList.RESET;
        LoanApprovalCheckList.SETRANGE("Document Type", LoanApprovalCheckList."Document Type"::Application);
        LoanApprovalCheckList.SETRANGE("Document No.", ApplicationNo);
        IF LoanApprovalCheckList.FINDSET THEN
            REPEAT
                LoanApprovalCheckList.CALCFIELDS("Is Mandatory?");
                IF (LoanApprovalCheckList."Is Mandatory?") AND (NOT LoanApprovalCheckList."Is Accomplished?") THEN
                    IF NOT LoanApprovalCheckList.Exceptional THEN BEGIN
                        IF HirePurchaseSetup.GET(HirePurchaseSetup.Type::"Application Status", LoanApprovalCheckList."Check List Code") THEN BEGIN
                            IF NOT HirePurchaseSetup."Skip Checking When Loan App." THEN
                                ERROR('Checklist %1 must be accomplished before loan approval.', LoanApprovalCheckList."Check List Code");
                        END;
                    END;
            UNTIL LoanApprovalCheckList.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure TransferChecklist(ApplicationNo: Code[20])
    begin
        LoanApprovalCheckList.RESET;
        LoanApprovalCheckList.SETRANGE("Document Type", LoanApprovalCheckList."Document Type"::Application);
        LoanApprovalCheckList.SETRANGE("Document No.", ApplicationNo);
        IF LoanApprovalCheckList.FINDSET THEN
            REPEAT
                LoanCheckList.INIT;
                LoanCheckList.TRANSFERFIELDS(LoanApprovalCheckList);
                LoanCheckList."Document No." := NewLoanNo;
                LoanCheckList."Document Type" := LoanCheckList."Document Type"::Loan;
                LoanCheckList.INSERT;
            UNTIL LoanApprovalCheckList.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure InsertMissingLoanTrackingMaster(VehicleFinanceAppHeader: Record "33020073")
    var
        GeneralMaster: Record "33020061";
        LoanProcTrackingRec: Record "33020084";
        lineno: Integer;
    begin
        //SRT Dec 5th 2019 >>
        GeneralMaster.RESET;
        GeneralMaster.SETRANGE(Category, 'Vehicle Loan');
        GeneralMaster.SETRANGE("Sub Category", 'Components');
        GeneralMaster.SETRANGE(Disable, FALSE);
        GeneralMaster.SETCURRENTKEY("Sequence No.");
        IF GeneralMaster.FINDFIRST THEN BEGIN
            LoanProcTrackingRec.RESET;
            LoanProcTrackingRec.SETRANGE("Application No.", VehicleFinanceAppHeader."Application No.");
            IF LoanProcTrackingRec.FINDLAST THEN
                lineno := LoanProcTrackingRec."Line No." + 10000;
            REPEAT
                LoanProcTrackingRec.RESET;
                LoanProcTrackingRec.SETRANGE("Application No.", VehicleFinanceAppHeader."Application No.");
                LoanProcTrackingRec.SETRANGE(Components, GeneralMaster.Code);
                IF NOT LoanProcTrackingRec.FINDFIRST THEN BEGIN
                    LoanProcTrackingRec.INIT;
                    LoanProcTrackingRec."Application No." := VehicleFinanceAppHeader."Application No.";
                    LoanProcTrackingRec."Line No." := lineno;
                    LoanProcTrackingRec.Components := GeneralMaster.Code;
                    LoanProcTrackingRec."Components Description" := GeneralMaster.Description;
                    IF LoanProcTrackingRec."Line No." = 10000 THEN BEGIN
                        LoanProcTrackingRec.Processed := TRUE;
                        LoanProcTrackingRec."Processing Time" := 0;
                        LoanProcTrackingRec.Date := TODAY;
                        LoanProcTrackingRec."User Id" := USERID;
                    END;
                    LoanProcTrackingRec.INSERT;
                    lineno := lineno + 10000;
                END;
            UNTIL GeneralMaster.NEXT = 0;
        END;
        //SRT Dec 5th 2019 <<
    end;
}


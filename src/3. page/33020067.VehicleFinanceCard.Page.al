page 33020067 "Vehicle Finance Card"
{
    Caption = 'Vehicle Finance';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Reschedule,Transfer and Reschedule,Category6_caption,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    RefreshOnActivate = true;
    SourceTable = Table33020062;
    SourceTableView = SORTING(Loan No.)
                      ORDER(Ascending)
                      WHERE(Approved = CONST(Yes));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Loan No."; "Loan No.")
                {
                    Editable = false;
                    ShowMandatory = true;

                    trigger OnAssistEdit()
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Application No."; "Application No.")
                {
                    Caption = 'Application No.';
                    Editable = false;
                }
                field("Application Open Date"; "Application Open Date")
                {
                    ShowMandatory = true;
                }
                field("Customer No."; "Customer No.")
                {
                    ShowMandatory = true;
                }
                field("Customer Name"; "Customer Name")
                {
                    Editable = false;
                }
                field("Nominee Account No."; "Nominee Account No.")
                {
                }
                field("Nominee Account Name"; "Nominee Account Name")
                {
                }
                field("Nature of Data"; "Nature of Data")
                {
                }
                field("Make Code"; "Make Code")
                {
                    Editable = true;
                }
                field("Model Code"; "Model Code")
                {
                    Editable = true;
                }
                field("Model Version No."; "Model Version No.")
                {
                    Editable = true;
                }
                field("Model Version No. 2"; "Model Version No. 2")
                {
                    Visible = false;
                }
                field("Vehicle No."; "Vehicle No.")
                {
                    Importance = Promoted;
                }
                field("Registration No."; "Registration No.")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                }
                field("Interest Rate"; "Interest Rate")
                {
                    Caption = 'Discounted Interest %';
                    Editable = NOT "Loan Disbursed";
                }
                field("Actual Interest Rate"; "Actual Interest Rate")
                {
                }
                field("Penalty %"; "Penalty %")
                {
                    Editable = false;
                }
                field("Tenure in Months"; "Tenure in Months")
                {
                    Editable = NOT "Loan Disbursed";
                }
                field("Disbursement Date"; "Disbursement Date")
                {
                    Editable = NOT "Loan Disbursed";
                }
                field("First Installment Date"; "First Installment Date")
                {
                    Editable = NOT "Loan Disbursed";
                }
                field("Interest on CAD"; "Interest on CAD")
                {
                    Editable = false;
                }
                field("EMI Type"; "EMI Type")
                {
                }
                field("Other Charges"; "Other Charges")
                {
                }
                field("Service Charge"; "Service Charge")
                {
                }
                field("Credit Allowded Days (CAD)"; "Credit Allowded Days (CAD)")
                {
                    Editable = false;
                }
                field("Vehicle Cost"; "Vehicle Cost")
                {
                    Editable = NOT "Loan Disbursed";
                }
                field("Down Payment"; "Down Payment")
                {
                    Editable = NOT "Loan Disbursed";
                }
                field("Loan Amount"; "Loan Amount")
                {
                    ShowMandatory = true;
                }
                field("Sales Invoice Date"; "Sales Invoice Date")
                {
                    ToolTip = 'Used in calculation of NRV';
                }
                field("Namsari Date"; "Namsari Date")
                {
                }
                field("Delivery Date"; "Delivery Date")
                {
                    ToolTip = 'Physical Vehicle Delivery Date as per Delivery Order';
                }
                field("BlueBook Expire Date"; "BlueBook Expire Date")
                {
                }
                field("Insurance Expiry Date"; "Insurance Expiry Date")
                {
                }
                field("Insurance Company Code"; "Insurance Company Code")
                {
                }
                field("Insurance Company Name"; "Insurance Company Name")
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
                field("Vendor No."; "Vendor No.")
                {
                    ToolTip = 'Comission Vendor (Vendor for Purchase Credit Memo)';
                    Visible = false;
                }
                field("Dealer Code"; "Dealer Code")
                {
                    ToolTip = 'Company for which Vehicle DO is provided!';
                    Visible = false;
                }
                field("Disbursed To"; "Disbursed To")
                {
                    ToolTip = 'Company for which DO is provided. This name is displayed on Veh. DO.';
                    Visible = true;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ShowMandatory = true;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Application Status"; "Application Status")
                {
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
                field("Delivery Order No."; "Delivery Order No.")
                {
                }
                field("Delivery Order Date"; "Delivery Order Date")
                {
                }
                field("Printed By"; "Printed By")
                {
                }
                field("Rejection Reason"; "Rejection Reason")
                {
                }
                field("Followed Up in Last 30 Days"; "Followed Up in Last 30 Days")
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
                field("RAM Percentage"; "RAM Percentage")
                {
                }
                field("Risk Grade"; "Risk Grade")
                {
                }
                field("Property NRV"; "Mortgage NRV")
                {
                    Caption = 'Property NRV';
                    Editable = false;
                }
                field("Property Details"; "Mortgage Details")
                {
                    Caption = 'Property Details';
                    Editable = false;
                }
                field("SOL Identity"; "SOL Identity")
                {
                }
                field("Legal Amount"; "Legal Amount")
                {
                }
                field("DO %"; "DO %")
                {
                    Editable = false;
                }
                field("Agni Branches"; "Agni Branches")
                {
                }
                field("DO Amount"; "DO Amount")
                {
                    Editable = false;
                }
            }
            part(FinanceLine; 33020077)
            {
                SubPageLink = Loan No.=FIELD(Loan No.);
                    SubPageView = SORTING(Installment No.)
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
                field("Financing Bank No."; "Financing Bank No.")
                {
                }
                field("Bank Name"; "Bank Name")
                {
                }
                field("Bank Interest Rate"; "Bank Interest Rate")
                {
                    Editable = false;
                }
                field("Bank EMI"; "Bank EMI")
                {
                }
                field("Principal Outstanding in Bank"; "Principal Outstanding in Bank")
                {
                }
                field("Interest Paid to Bank"; "Interest Paid to Bank")
                {
                }
            }
            group("NRV Statistics")
            {
                field("Market Price"; "Market Price")
                {
                }
                field("Depreciation Rate"; "Depreciation Rate")
                {
                }
                field("Loan Status"; "Loan Status")
                {
                    Editable = false;
                    ShowMandatory = true;
                }
                field("Net Realization Value"; "Net Realization Value")
                {
                    Editable = false;
                }
                field("NRV Calculation Date"; "NRV Calculation Date")
                {
                    Editable = false;
                }
                field("NRV Status"; "NRV Status")
                {
                }
            }
            group("Loan Statistics as on Calc Date")
            {
                field("Due Calculated as of"; "Due Calculated as of")
                {
                    Caption = 'Due Calculated as of Date';
                }
                field("No of Due Days"; "No of Due Days")
                {
                    Caption = 'No of Days since last clearance';
                }
                field("Due Days Crossed Maturity"; "Due Days Crossed Maturity")
                {
                    Editable = false;
                }
                field("Due Installment as of Today"; "Due Installment as of Today")
                {
                    Caption = 'Due Installment as on Calc Date';
                }
                field("Due Principal"; "Due Principal")
                {
                    Caption = 'Due Principal as on Calc Date';
                }
                field("Interest Due"; "Interest Due")
                {
                    Caption = 'Interest Matured & Due as on Calc Date';
                }
                field("Penalty Due"; "Penalty Due")
                {
                    Caption = 'Penalty Due as on Calc Date';
                }
                field("Insurance Due"; "Insurance Due")
                {
                    Caption = 'Insurance Due';
                }
                field("Interest Due on Insurance"; "Interest Due on Insurance")
                {
                }
                field("Interest Due on CAD"; "Interest Due on CAD")
                {
                    Editable = false;
                }
                field("Other Amount Due"; "Other Amount Due")
                {
                    Caption = 'Other Amount Due';
                }
                field("Total Due as of Today"; "Total Due as of Today")
                {
                    Caption = 'Total Due as on Calc Date';
                    ShowMandatory = true;
                }
            }
            group("Loan Statistics to Clear Loan")
            {
                Visible = IsHirePurchase;
                field("Date to Clear Loan"; "Date to Clear Loan")
                {
                    ShowMandatory = true;
                }
                field("Due Installments"; "Due Installments")
                {
                    Caption = 'Remainining Installments to clear loan';
                }
                field("Principal Due"; "Principal Due")
                {
                    Caption = 'Total Principal Due to clear loan';
                }
                field("Interest Due Defered"; "Interest Due Defered")
                {
                    Caption = 'Add. Int. due to realize to clear loan as on Calc Date';
                }
                field("Total Int. Due to clear Loan"; "Total Int. Due to clear Loan")
                {
                    ShowMandatory = true;
                }
                field("Total Due"; "Total Due")
                {
                    Caption = 'Total Due to clear loan';
                }
            }
            group("Blocked & Captured")
            {
                field(Blocked; Blocked)
                {
                }
                field("Blocked by"; "Blocked by")
                {
                }
                field("Blocked Date"; "Blocked Date")
                {
                }
                field("Blocked Remarks"; "Blocked Remarks")
                {
                }
                field("UnBlocked Remarks"; "UnBlocked Remarks")
                {
                }
                field(Captured; Captured)
                {
                }
                field("Captured Date"; "Captured Date")
                {
                }
                field("Vehicle Captured Location"; "Vehicle Captured Location")
                {
                }
                field("Captured Veh. Phy. Location"; "Captured Veh. Phy. Location")
                {
                }
                field("Capture Updated by"; "Capture Updated by")
                {
                }
                field(DaysSinceCaptured; DaysSinceCaptured)
                {
                    Caption = 'Days since Captured';
                    Editable = false;
                }
                field("Accidental Remarks"; "Accidental Remarks")
                {
                }
                field("Accidental Vehicle"; "Accidental Vehicle")
                {
                }
                field("Accidental Under Insurance"; "Accidental Under Insurance")
                {
                }
            }
            group("Other Details")
            {
                field(Closed; Closed)
                {
                    Editable = false;
                }
                field("Closed by"; "Closed by")
                {
                }
                field("Closed Date"; "Closed Date")
                {
                }
                field(Rejected; Rejected)
                {
                    Editable = false;
                }
                field("Rejected by"; "Rejected by")
                {
                    Editable = false;
                }
                field("Rejected Date"; "Rejected Date")
                {
                    Editable = false;
                }
                field(Approved; Approved)
                {
                }
                field("Approved By"; "Approved By")
                {
                }
                field("Approved Date"; "Approved Date")
                {
                }
                field("Disbursed By"; "Disbursed By")
                {
                    Editable = false;
                }
                field("Loan Disbursed"; "Loan Disbursed")
                {
                    Editable = false;
                }
                field(Verified; Verified)
                {
                }
                field("Verified By"; "Verified By")
                {
                    Editable = false;
                }
                field("Verified Date"; "Verified Date")
                {
                    Editable = false;
                }
                field("Created By"; "Created By")
                {
                    Editable = false;
                }
            }
            group("Special Cases")
            {
                Editable = SpecialCasesEditable;
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
            group(KSKL)
            {
                field("Credit Facility Type"; "Credit Facility Type")
                {
                    ShowMandatory = true;
                }
                field("Purpose of Credit Facility"; "Purpose of Credit Facility")
                {
                    ShowMandatory = true;
                }
                field("Ownership Type"; "Ownership Type")
                {
                    ShowMandatory = true;
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Repayment Frequency"; "Repayment Frequency")
                {
                }
                field("Credit Facility Status"; "Credit Facility Status")
                {
                    ShowMandatory = true;
                }
                field("Reason for Closure"; "Reason for Closure")
                {
                }
                field("Security Coverage Flag"; "Security Coverage Flag")
                {
                    ShowMandatory = true;
                }
                field("Payment Receipt Date"; "Payment Receipt Date")
                {
                    ShowMandatory = true;
                }
                field("Payment Dealy History Flag"; "Payment Dealy History Flag")
                {
                }
                field("Asset Claasification"; "Asset Claasification")
                {
                }
                field("Credit Facility Sanction Curr"; "Credit Facility Sanction Curr")
                {
                    ShowMandatory = true;
                }
            }
            group(Amounts)
            {
                Caption = 'Amounts';
                field("Amount Overdue KSKL"; "Amount Overdue KSKL")
                {
                }
                field("Amount Overdue 1 30 KSKL"; "Amount Overdue 1 30 KSKL")
                {
                }
                field("Amount Overdue 31 60 KSKL"; "Amount Overdue 31 60 KSKL")
                {
                }
                field("Amount Overdue 61 90 KSKL"; "Amount Overdue 61 90 KSKL")
                {
                }
                field("Amount Overdue 91 120 KSKL"; "Amount Overdue 91 120 KSKL")
                {
                }
                field("Amount Overdue 121 150 KSKL"; "Amount Overdue 121 150 KSKL")
                {
                }
                field("Amount Overdue 151 180 KSKL"; "Amount Overdue 151 180 KSKL")
                {
                }
                field("Amount Overdue 181 Above KSKL"; "Amount Overdue 181 Above KSKL")
                {
                }
                field("Payemnt Delay Days KSKL"; "Payemnt Delay Days KSKL")
                {
                }
                field("No of Payemnt Installments KSK"; "No of Payemnt Installments KSK")
                {
                }
                field("No of Days Overdue KSKL"; "No of Days Overdue KSKL")
                {
                }
                field("Last Repayment Amount KSKL"; "Last Repayment Amount KSKL")
                {
                }
                field("Date of Lastpay KSKL"; "Date of Lastpay KSKL")
                {
                }
                field("Immidate Preceeding Date KSKL"; "Immidate Preceeding Date KSKL")
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
            part(; 33020287)
            {
                SubPageLink = No.=FIELD(Nominee Account No.);
            }
            part(; 33020293)
            {
                SubPageLink = Loan No.=FIELD(Loan No.);
            }
            part(; 33020065)
            {
                SubPageLink = Serial No.=FIELD(Vehicle No.);
            }
            systempart(; Links)
            {
            }
            systempart(; Notes)
            {
                Visible = true;
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
                action("Day End Log")
                {
                    Image = Log;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    RunObject = Page 33020128;
                    RunPageLink = Loan No.=FIELD(Loan No.);
                    RunPageView = SORTING(Entry No)
                                  ORDER(Descending);
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
                    var
                        PrvDuedate: Date;
                    begin
                        IF (Closed) OR ("Loan Disbursed") THEN
                          ERROR(Text0001,"Loan No.");

                        VFSetup.GET;
                        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN BEGIN
                          CLEAR(CalculateEMI);
                          CalculateEMI.CalculateEMIAfterApproval("Loan Amount","Interest Rate","Tenure in Months","Loan No.",FALSE);
                        END
                        ELSE BEGIN
                          CLEAR(CalculateEMI_VF);
                          CalculateEMI.CalculateEMI("Loan Amount","Interest Rate","Tenure in Months","Loan No.",FALSE);
                        END;
                    end;
                }
                action("Process Day End")
                {
                    Image = Recalculate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        HPDayEnd: Report "33020074";
                                      VFHeader: Record "33020062";
                    begin
                        VFSetup.GET;
                        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN BEGIN
                          COMMIT;
                          CurrPage.SETSELECTIONFILTER(VFHeader);
                          CLEAR(HPDayEnd);
                          HPDayEnd.SETTABLEVIEW(VFHeader);
                          HPDayEnd.RUN;
                        END;
                    end;
                }
                action("Create Nominee Account")
                {
                    Image = CreateForm;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = IsHirePurchase;

                    trigger OnAction()
                    begin
                        CalculateEMI.CreateNomineeAccount("Customer No.","Nominee Account No.","Nominee Account Name");
                    end;
                }
                action("Disburse Loan")
                {
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    var
                        KSKLMgmt: Codeunit "33020069";
                    begin
                        KSKLMgmt.showMandatory(Rec."Loan No.");
                        VFSetup.GET;
                        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN
                          DisburseLoan_HP
                        ELSE
                          DisburseLoan_VF;
                    end;
                }
                action("Close Loan")
                {
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+F9';
                    Visible = EditLoan;

                    trigger OnAction()
                    var
                        VFHeader: Record "33020062";
                        CloseLoanFile: Report "33020076";
                    begin
                        IF CONFIRM('Are you sure to close this loan file?',FALSE) THEN BEGIN
                          VFSetup.GET;
                          IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN BEGIN
                            COMMIT;
                            CurrPage.SETSELECTIONFILTER(VFHeader);
                            CLEAR(CloseLoanFile);
                            CloseLoanFile.SETTABLEVIEW(VFHeader);
                            CloseLoanFile.RUN;
                          END ELSE BEGIN
                            //ZM Nov 14 2017 >>
                            CALCFIELDS("Total Principal Paid");
                            //message('%1 %2',ROUND("Total Principal Paid",1,'>'), ROUND("Loan Amount",1,'>'));
                            IF ROUND("Total Principal Paid" + GetVFPrepaymentAmount("Loan No."),1,'>') < ROUND("Loan Amount",1,'>') THEN
                              ERROR('This Loan File can not be closed. Total principal paid is less then loan amount.');
                            IF "Interest Due" > 0 THEN
                              ERROR('This Loan File can not be closed. There is outstanding interest to be cleared for this loan file.');
                        
                            IF Blocked THEN      //ZM Nov 16, 2016
                              ERROR('Vehicle has been Blocked!');
                        
                            IF "Penalty Due" > 0 THEN BEGIN
                              OK := CONFIRM('There is outstanding penalty to cleared. Are you sure to proceed with loan closure process?');
                              IF OK THEN BEGIN
                                Closed := TRUE;
                                "Closed Date" := TODAY;
                                "Closed by" := USERID;
                                MODIFY;
                                CurrPage.CLOSE;
                                MESSAGE('This loan file has been closed and transfered to Closed list.');
                              END;
                            END ELSE BEGIN
                              Closed := TRUE;
                              "Closed Date" := TODAY;
                              "Closed by" := USERID;
                              MODIFY;
                              ACtivityLog("Loan No.",ActivityRec."Activity Type"::"Loan Closed");
                              MESSAGE('This loan file has been closed and transfered to Closed list.');
                              CurrPage.CLOSE;
                            END;
                          END;
                          //ZM Nov 14 2017 <<
                        END;
                        CurrPage.CLOSE;
                        /*OK := CONFIRM('Are you sure to close this loan file?');
                        IF OK THEN BEGIN
                          CALCFIELDS("Total Principal Paid");
                          //message('%1 %2',ROUND("Total Principal Paid",1,'>'), ROUND("Loan Amount",1,'>'));
                          IF ROUND("Total Principal Paid" + GetVFPrepaymentAmount("Loan No."),1,'>') < ROUND("Loan Amount",1,'>') THEN
                            ERROR('This Loan File can not be closed. Total principal paid is less then loan amount.');
                          IF "Interest Due" > 0 THEN
                            ERROR('This Loan File can not be closed. There is outstanding interest to be cleared for this loan file.');
                        
                          IF Blocked THEN      //ZM Nov 16, 2016
                            ERROR('Vehicle has been Blocked!');
                        
                          IF "Penalty Due" > 0 THEN BEGIN
                            OK := CONFIRM('There is outstanding penalty to cleared. Are you sure to proceed with loan closure process?');
                            IF OK THEN BEGIN
                              Closed := TRUE;
                              "Closed Date" := TODAY;
                              "Closed by" := USERID;
                              MODIFY;
                              CurrPage.CLOSE;
                              MESSAGE('This loan file has been closed and transfered to Closed list.');
                            END;
                          END ELSE BEGIN
                            Closed := TRUE;
                            "Closed Date" := TODAY;
                            "Closed by" := USERID;
                            MODIFY;
                            ACtivityLog("Loan No.",ActivityRec."Activity Type"::"Loan Closed");
                            MESSAGE('This loan file has been closed and transfered to Closed list.');
                            CurrPage.CLOSE;
                          END;
                        END;
                        */

                    end;
                }
                action("Reopen Loan")
                {
                    Visible = EditLoan;

                    trigger OnAction()
                    begin
                        IF NOT Closed THEN
                          ERROR('This loan file is already opened.');

                        IF Closed THEN
                          TESTFIELD("Transfered Loan No.",'');
                          OK := CONFIRM('Are you sure to Reopen this Loan file?');
                          IF OK THEN BEGIN
                            Closed := FALSE;
                            MODIFY;
                            ACtivityLog("Loan No.",ActivityRec."Activity Type"::"Loan Reopen");
                            MESSAGE('This Loan file has been Reopened and moved to Approved list.');
                          END;
                    end;
                }
            }
            group(Finance)
            {
                Caption = 'Finance';
                action("Calculate Dues && NRV")
                {
                    Image = CalculateInvoiceDiscount;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    begin
                        IF Closed THEN
                          ERROR(Text0001,"Loan No.");

                        CurrPage.SETSELECTIONFILTER(VFHeader);
                        REPORT.RUN(33020063,TRUE,TRUE,VFHeader);
                    end;
                }
                action("Waive Penalty")
                {
                    Caption = 'Waive Penalty';
                    Image = CalculateRegenerativePlan;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(VFHeader);
                        REPORT.RUN(33020072,TRUE,FALSE,VFHeader);
                    end;
                }
                action("Process Cash Receipt")
                {
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 33020127;
                                    RunPageLink = Loan No.=FIELD(Loan No.);
                    RunPageView = SORTING(Loan No.)
                                  ORDER(Ascending);

                    trigger OnAction()
                    begin
                        //OK := CONFIRM('Do you want to approve this loan?');
                    end;
                }
                action("Process Nominee Receipt")
                {
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 33020127;
                                    RunPageLink = Loan No.=FIELD(Loan No.);
                    RunPageView = SORTING(Loan No.)
                                  ORDER(Ascending);
                    Visible = IsHirePurchase;

                    trigger OnAction()
                    begin
                        //OK := CONFIRM('Do you want to approve this loan?');
                    end;
                }
                action("Cash Receipt Journal")
                {
                    Image = Journals;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CashRcptJnl.RUN;
                    end;
                }
            }
            group(Vehicle)
            {
                Caption = 'Vehicle';
                action("Block VIN")
                {
                    Visible = EditLoan;

                    trigger OnAction()
                    begin
                        BlockUnblockVIN(TRUE);
                    end;
                }
                action("UnBlock VIN")
                {
                    Visible = EditLoan;

                    trigger OnAction()
                    begin
                        BlockUnblockVIN(FALSE);
                    end;
                }
                action("Capture VIN")
                {
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    Visible = EditLoan;

                    trigger OnAction()
                    begin
                        CaptureUnCaptureVIN(TRUE);
                    end;
                }
                action("UnCapture VIN")
                {
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    Visible = EditLoan;

                    trigger OnAction()
                    begin
                        CaptureUnCaptureVIN(FALSE);
                    end;
                }
                action("Accidental VIN")
                {

                    trigger OnAction()
                    begin
                        //SRT Dec 5th 2019 >>
                        IF "Accidental Vehicle" THEN BEGIN
                          IF NOT CONFIRM('Loan Document %1 is already related to accidental vehicle. Do you want to make it unaccidental?',FALSE,"Loan No.") THEN
                            EXIT;
                          AccidentalVIN(FALSE);
                        END
                        ELSE BEGIN
                          IF NOT CONFIRM('Do you want to make loan document accidental?',FALSE) THEN
                            EXIT;
                          AccidentalVIN(TRUE);
                        END;
                        //SRT Dec 5th 2019 <<
                    end;
                }
            }
            group(Process)
            {
                Caption = 'Process';
                action("Mark as Defaulter")
                {
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    Visible = EditLoan;

                    trigger OnAction()
                    begin
                        MarkDefaulter(TRUE);
                    end;
                }
                action("Unmark as Defaulter")
                {
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    Visible = EditLoan;

                    trigger OnAction()
                    begin
                        MarkDefaulter(FALSE);
                    end;
                }
                action("Capture Activity Log")
                {
                    Image = "Copy- Works";
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 33020081;
                                    RunPageLink = Loan No.=FIELD(Loan No.);
                    ShortCutKey = 'Ctrl+F9';
                    Visible = EditLoan;

                    trigger OnAction()
                    var
                        ReleaseSalesDoc: Codeunit "414";
                    begin
                    end;
                }
                action("Change Installment Date")
                {
                    Image = ChangeDates;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = Canchangedates;

                    trigger OnAction()
                    var
                        VFHeader: Record "33020062";
                    begin
                        OK := CONFIRM('Are you sure to change the installment date?');
                        IF OK THEN BEGIN
                          CLEAR(VFDocModification);
                          CurrPage.SETSELECTIONFILTER(VFHeader);
                          VFDocModification.UpdateInstDisbDates("First Installment Date","Disbursement Date");
                          VFDocModification.SETTABLEVIEW(VFHeader);
                          VFDocModification.RUNMODAL;
                        END ELSE
                          MESSAGE('Process aborted by user!!');
                    end;
                }
                action("Insurance Policies")
                {
                    Image = Journals;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    var
                        lrecVFLines: Record "33020063";
                        RecalculateAmount: Decimal;
                        RecVehInsurance: Record "25006033";
                        PageVehInsurance: Page "25006053";
                    begin
                        IF Closed THEN
                          ERROR(Text0001,"Loan No.");
                        RecVehInsurance.RESET;
                        FILTERGROUP(3);
                        RecVehInsurance.SETRANGE("Vehicle Serial No.","Vehicle No.");
                        PageVehInsurance.SETTABLEVIEW(RecVehInsurance);
                        PageVehInsurance.RUNMODAL;
                    end;
                }
                action("Loan Checklist")
                {
                    Image = CheckRulesSyntax;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    begin
                        LoanApprovalCheckList.RESET;
                        LoanApprovalCheckList.SETRANGE("Document Type",LoanApprovalCheckList."Document Type"::Loan);
                        LoanApprovalCheckList.SETRANGE("Document No.","Loan No.");
                        IF NOT LoanApprovalCheckList.FINDFIRST THEN BEGIN
                          CheckListMaster.RESET;
                          CheckListMaster.SETRANGE(Blocked,FALSE);  //ZM Apr 12 2018
                          IF CheckListMaster.FINDSET THEN REPEAT
                            LoanApprovalCheckList.INIT;
                            LoanApprovalCheckList."Document Type" := LoanApprovalCheckList."Document Type"::Loan;
                            LoanApprovalCheckList."Document No." := "Loan No.";
                            LoanApprovalCheckList."Check List Code" := CheckListMaster.Code;
                            LoanApprovalCheckList.Description := CheckListMaster.Description;
                            LoanApprovalCheckList."Description 2" := CheckListMaster."Description 2";
                            LoanApprovalCheckList.INSERT;
                          UNTIL CheckListMaster.NEXT = 0;
                        END;
                        LoanApprovalCheckList.SETRANGE("Document Type",LoanApprovalCheckList."Document Type"::Loan);
                        LoanApprovalCheckList.SETRANGE("Document No.","Loan No.");
                        LoanApprovalCheckListPage.SETTABLEVIEW(LoanApprovalCheckList);
                        LoanApprovalCheckListPage.RUN;
                    end;
                }
                action("Risk Assessment")
                {
                    Image = MaintenanceLedgerEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    var
                        VehicleFinanceApp: Record "33020073";
                    begin
                        RiskAssessment.RESET;
                        RiskAssessment.SETRANGE("Loan No.","Application No.");
                        IF NOT RiskAssessment.FINDFIRST THEN BEGIN
                          RiskAssessment.RESET;
                          RiskAssessment.SETRANGE("Loan No.","Loan No.");
                          IF NOT RiskAssessment.FINDFIRST THEN BEGIN
                            RiskAssessmentSetup.RESET;
                            IF RiskAssessmentSetup.FINDSET THEN REPEAT
                              RiskAssessment.INIT;
                              RiskAssessment."Loan No." := "Loan No.";
                              RiskAssessment.Code := RiskAssessmentSetup.Code;
                              RiskAssessment.Description := RiskAssessmentSetup.Description;
                              RiskAssessment.VALIDATE("Weightage (A)",RiskAssessmentSetup."Weightage (A)");
                              RiskAssessment.VALIDATE("Score (B)",RiskAssessmentSetup."Score (B)");
                              RiskAssessment.INSERT;
                            UNTIL RiskAssessmentSetup.NEXT = 0;
                          END;
                        END;
                        RiskAssessment.RESET;
                        RiskAssessment.SETRANGE("Loan No.","Application No.");
                        IF RiskAssessment.FINDFIRST THEN BEGIN
                          RiskAssessment.SETRANGE("Loan No.","Application No.");
                          LoanRiskAssessmentList.SETTABLEVIEW(RiskAssessment);
                          LoanRiskAssessmentList.RUN;
                        END ELSE BEGIN
                          RiskAssessment.RESET;
                          RiskAssessment.SETRANGE("Loan No.","Loan No.");
                          LoanRiskAssessmentList.SETTABLEVIEW(RiskAssessment);
                          LoanRiskAssessmentList.RUN;
                        END;
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
                        LoanProcTracking.SETRANGE("Application No.","Application No.");
                        IF LoanProcTracking.FINDFIRST THEN BEGIN
                          LoanProcTrackingSheet.SETRECORD(LoanProcTracking);
                          LoanProcTrackingSheet.SETTABLEVIEW(LoanProcTracking);
                          LoanProcTrackingSheet.RUN;
                        END ELSE BEGIN
                          GeneralMaster.RESET;
                          GeneralMaster.SETRANGE(Category,'Vehicle Loan');
                          GeneralMaster.SETRANGE("Sub Category",'Components');
                          GeneralMaster.SETRANGE(Disable,FALSE);
                          GeneralMaster.SETCURRENTKEY("Sequence No.");
                          IF GeneralMaster.FINDFIRST THEN BEGIN
                           LineNo := 10000;
                           REPEAT
                             LoanProcTrackingRec.INIT;
                             LoanProcTrackingRec."Application No." := "Application No.";
                             LoanProcTrackingRec."Line No."  := LineNo;
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
                          LoanProcTracking.SETRANGE("Application No.","Application No.");
                          IF LoanProcTracking.FINDFIRST THEN BEGIN
                            LoanProcTrackingSheet.SETRECORD(LoanProcTracking);
                            LoanProcTrackingSheet.SETTABLEVIEW(LoanProcTracking);
                            LoanProcTrackingSheet.RUN;
                          END;
                        END;
                    end;
                }
                action("SMS Details View")
                {
                    Image = Log;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = IsHirePurchase;

                    trigger OnAction()
                    begin
                        ViewSMSDetails;
                    end;
                }
                action("Accured Interest calc")
                {
                    Image = "Report";
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        VehFinanceHeader: Record "33020062";
                    begin
                        //ratan 12.30.2020
                        //VehFinanceHeader.GET("Loan No.");
                        VehFinanceHeader.RESET;
                        VehFinanceHeader.SETRANGE("Loan No.","Loan No.");
                        IF VehFinanceHeader.FINDFIRST THEN
                          REPORT.RUN(REPORT::"Accured Interest Calculation",TRUE,FALSE,VehFinanceHeader);
                    end;
                }
            }
            group()
            {
                action("Create Vehicle Insurance")
                {
                    Image = CreateDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CLEAR(VehicleInsuranceMgt);
                        //VehicleInsuranceMgt.CreateVehicleInsurance(Rec);
                        VehicleInsuranceMgt2.CreateVehicleInsurance(Rec);
                    end;
                }
                action("Posted Vehicle Insurance List")
                {
                    Image = List;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        PostedVehicleInsList: Page "33020290";
                                                  VehicleInsurance: Record "33020085";
                    begin
                        VehicleInsurance.RESET;
                        VehicleInsurance.SETRANGE("Loan No.","Loan No.");
                        IF VehicleInsurance.FINDFIRST THEN BEGIN
                          PostedVehicleInsList.SETRECORD(VehicleInsurance);
                          PostedVehicleInsList.SETTABLEVIEW(VehicleInsurance);
                          PostedVehicleInsList.EDITABLE(FALSE);
                          PostedVehicleInsList.RUN;
                        END;
                    end;
                }
            }
            group("<Action1000000059>")
            {
                Caption = 'Reject Loan';
                action("Reject Loan")
                {
                    Visible = EditLoan;

                    trigger OnAction()
                    begin
                        IF "Rejection Reason" ='' THEN
                          ERROR('Please fill the Rejection Reason!');
                        OK := CONFIRM('Are you sure to reject this loan file?');
                        IF OK THEN BEGIN
                          Rejected := TRUE;
                          "Rejected Date" := TODAY;
                          "Rejected by" := USERID;
                        END;
                    end;
                }
                action(ReopenLoan)
                {
                    Caption = 'Reopen Loan';
                }
            }
            group(Reschedule)
            {
                Caption = 'Reschedule';
                action("Reschedule EMI")
                {
                    Ellipsis = true;
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    var
                        VehFinHeader: Record "33020062";
                        VehReschedule: Page "33020083";
                    begin
                        UserSetup.GET(USERID);
                        IF NOT UserSetup."Can Reschedule Loan" THEN
                          ERROR('You are not authorized to reschedule vehicle loan.');

                        IF Closed THEN
                          ERROR(Text0001,"Loan No.");

                        OK := CONFIRM('Are you sure to reschedule this Loan file?');
                        IF NOT OK THEN
                          ERROR('Process aborted by user!!');

                        SetRecSelectionFilter(VehFinHeader);
                        VehReschedule.SETTABLEVIEW(VehFinHeader);
                        VehReschedule.RUN;
                    end;
                }
                action("Reschedule Tenure")
                {
                    Ellipsis = true;
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    var
                        VehFinHeader: Record "33020062";
                        VehReschedule: Page "33020126";
                    begin
                        UserSetup.GET(USERID);
                        IF NOT UserSetup."Can Reschedule Loan" THEN
                          ERROR('You are not authorized to reschedule tenure of vehicle loan.');

                        IF Closed THEN
                          ERROR(Text0001,"Loan No.");

                        OK := CONFIRM('Are you sure to reschedule tenure of this Loan file?');
                        IF NOT OK THEN
                          ERROR('Process aborted by user!!');

                        SetRecSelectionFilter(VehFinHeader);
                        VehReschedule.SETTABLEVIEW(VehFinHeader);
                        VehReschedule.RUN;
                    end;
                }
                action("Defer Principal")
                {
                    Image = Allocations;

                    trigger OnAction()
                    var
                        VehFinHeader: Record "33020062";
                        DifferPrincipal: Page "33020099";
                    begin
                        UserSetup.GET(USERID);
                        IF NOT UserSetup."Can Reschedule Loan" THEN
                          ERROR('You are not authorized to reschedule vehicle loan.');

                        IF Closed THEN
                          ERROR(Text0001,"Loan No.");

                        OK := CONFIRM('Are you sure to defer the selected installment(s) for this Loan file?');
                        IF NOT OK THEN
                          ERROR('Process aborted by user!!');

                        SetRecSelectionFilter(VehFinHeader);
                        DifferPrincipal.SETTABLEVIEW(VehFinHeader);
                        DifferPrincipal.RUN;
                    end;
                }
                action("Loan Capitalization")
                {
                    Image = AdjustEntries;
                    Promoted = true;

                    trigger OnAction()
                    var
                        VehFinHeader: Record "33020062";
                        CapitalizeLoan: Page "33020133";
                    begin
                        UserSetup.GET(USERID);
                        IF NOT UserSetup."Can Reschedule Loan" THEN
                          ERROR('You are not authorized to reschedule vehicle loan.');

                        IF Closed THEN
                          ERROR(Text0001,"Loan No.");

                        OK := CONFIRM('Are you sure to run loan capitalization process for this Loan file?');
                        IF NOT OK THEN
                          ERROR('Process aborted by user!!');

                        SetRecSelectionFilter(VehFinHeader);
                        CapitalizeLoan.SETTABLEVIEW(VehFinHeader);
                        CapitalizeLoan.RUN;
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
                    RunObject = Report 33020062;
                                    RunPageOnRec = true;
                                    Visible = false;
                }
                action("Customer Ledger Entries")
                {
                    Caption = 'Customer Ledger E&ntries';
                    Image = CustomerLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 25;
                                    RunPageLink = Customer No.=FIELD(Customer No.);
                    RunPageView = SORTING(Customer No.);
                    ShortCutKey = 'Ctrl+F7';
                    Visible = EditLoan;
                }
                action("General Ledger Entries")
                {
                    Caption = 'G/L Entries';
                    RunObject = Page 20;
                                    RunPageLink = Loan File No.=FIELD(Loan No.);
                    RunPageView = SORTING(Entry No.)
                                  ORDER(Ascending);
                    Visible = EditLoan;
                }
                action(CustomerStatement)
                {
                    Caption = 'Customer Statement';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    var
                        VFSetup: Record "33020064";
                    begin
                        CurrPage.SETSELECTIONFILTER(VFHeader);
                        VFSetup.GET;
                        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN
                          REPORT.RUN(33020179,TRUE,FALSE,VFHeader)
                        ELSE IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Vehicle Finance" THEN
                          REPORT.RUN(33020180,TRUE,FALSE,VFHeader)
                    end;
                }
                action(PaymentSchedule)
                {
                    Caption = 'Payment Schedule';
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(VFHeader);
                        REPORT.RUN(33020064,TRUE,FALSE,VFHeader);
                    end;
                }
                action(DeliveryOrder)
                {
                    Caption = 'Delivery Order';
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(VFHeader);
                        VFSetup.GET;
                        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN
                          REPORT.RUN(33020073,TRUE,FALSE,VFHeader)
                        ELSE
                          REPORT.RUN(33020067,TRUE,FALSE,VFHeader);
                    end;
                }
                action("VF Activity Log")
                {
                    RunObject = Page 33020119;
                                    RunPageLink = Loan No.=FIELD(Loan No.);
                }
                action(SOL)
                {
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        VehicleFinanceApp.RESET;
                        VehicleFinanceApp.SETRANGE("Application No.","Loan No.");
                        IF VehicleFinanceApp.FINDFIRST THEN BEGIN
                          SOLReport.SETTABLEVIEW(VehicleFinanceApp);
                          SOLReport.RUN;
                        END;
                    end;
                }
                action("RAM Calculation Report")
                {
                    Image = Print;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;

                    trigger OnAction()
                    var
                        RiskAssessmentRec: Record "33020082";
                    begin
                        RiskAssessmentRec.RESET;
                        RiskAssessmentRec.SETRANGE("Loan No.","Application No.");
                        IF RiskAssessmentRec.FINDSET THEN
                          REPORT.RUNMODAL(33020178,TRUE,FALSE,RiskAssessmentRec);
                    end;
                }
            }
            group("<Action1000000033>")
            {
                Caption = 'Loan Transfer';
                action(Transfer)
                {
                    Caption = 'Transfer';
                    Image = CopyToTask;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    var
                        VehFinHeader: Record "33020062";
                        VehLoanTransfer: Report "33020069";
                                             Text001: Label 'Do you want to transfer Remaining Dues to New Customer?';
                        UserSetup: Record "91";
                        Text000: Label 'You have no permission to transfer Vehicle Loan.';
                    begin
                        UserSetup.GET(USERID);
                        IF UserSetup."Can Transfer Vehicle Loan" THEN BEGIN
                          IF CONFIRM(Text001,TRUE) THEN BEGIN
                            SetRecSelectionFilter(VehFinHeader);
                            VehLoanTransfer.SETTABLEVIEW(VehFinHeader);
                            VehLoanTransfer.RUN;
                          END;
                        END
                        ELSE
                          ERROR(Text000);
                    end;
                }
            }
            group(IncomingDocument)
            {
                Caption = 'Incoming Document';
                Image = Documents;
                action(IncomingDocCard)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'View Incoming Document';
                    Image = ViewOrder;
                    ToolTip = 'View any incoming document records and file attachments that exist for the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "130";
                    begin
                        IncomingDocument.ShowCard("Loan No.","Approved Date");
                    end;
                }
                action(SelectIncomingDoc)
                {
                    AccessByPermission = TableData 130=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'Select Incoming Document';
                    Image = SelectLineToApply;
                    ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "130";
                    begin
                        IncomingDocument.SelectIncomingDocumentForPostedDocument("Loan No.","Approved Date",RECORDID);
                    end;
                }
                action(IncomingDocAttachFile)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Create Incoming Document from File';
                    Ellipsis = true;
                    Image = Attach;
                    ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocumentAttachment: Record "133";
                    begin
                        IncomingDocumentAttachment.NewAttachmentFromPostedDocument("Loan No.","Approved Date");
                    end;
                }
                action(SendSMSNotificationBeforeSevenDays)
                {
                    Caption = 'Send EMI Mature Date SMS Notification Before Seven Days';
                    Image = SendMail;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        SMSWebService.SendCustomerDueNotificationBeforeSevenDays;
                    end;
                }
                action(SendSMSNotificationBeforeThreeDays)
                {
                    Caption = 'Send EMI Mature Date SMS Notification Before Three Days';
                    Image = SendMail;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        SMSWebService.SendCustomerDueNotificationBeforeThreeDays;
                    end;
                }
                action(SendExpirySMSNotificationBeforeThirtyDays)
                {
                    Caption = 'Send Insurance Expiry Date SMS Notification Before Thirty Days';
                    Image = SendMail;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        SMSWebService.SendInsuranceExpiryNotification;
                    end;
                }
                action("Verify KSKL Amount")
                {
                    Image = AssemblyOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        KSKL: Codeunit "33020069";
                    begin
                        KSKL.getAllOverduesUpdated(Rec);
                    end;
                }
                action("Update Penalty Percent")
                {

                    trigger OnAction()
                    var
                        Vehiclefinance: Record "33020062";
                        Vfsetup: Record "33020064";
                    begin
                        Vfsetup.GET();
                        Vehiclefinance.RESET();
                        IF Vehiclefinance.FINDSET() THEN REPEAT
                          Vehiclefinance."Penalty %":= Vfsetup."Penalty %";
                          Vehiclefinance.MODIFY(TRUE);
                          UNTIL Vehiclefinance.NEXT()=0;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlProperty; //SRT Sept 19th 2019
    end;

    trigger OnAfterGetRecord()
    begin
        CALCFIELDS("Registration No.",VIN,"Accidental Under Insurance","Accidental Vehicle","Namsari Date");
        IF Closed THEN
          CurrPage.EDITABLE := FALSE;

        IF "Captured Date" <> 0D THEN
          DaysSinceCaptured := TODAY - "Captured Date";

        IF Captured THEN
          IsCaptured := FALSE
        ELSE
          IsCaptured := TRUE;
        SetControlProperty; //SRT Sept 19th 2019
    end;

    trigger OnOpenPage()
    begin
        IF Closed OR Rejected THEN
          CurrPage.EDITABLE := FALSE;

        IF Rejected THEN
          EditLoan := FALSE
        ELSE
          EditLoan := TRUE;

        VFSetup.GET;
        IsHirePurchase := VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase";
        CanChangeDates := VFDocModification.CanChangeInstDates;
    end;

    var
        CalculateEMI: Codeunit "33020062";
        CalculateEMI_VF: Codeunit "33020065";
        OK: Boolean;
        DifferentialDays: Integer;
        DifferentialInterest: Decimal;
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        VFSetup: Record "33020064";
        VFPostingType: Option " ",Principal,Interest,Penalty,"Service Charge","Other Charge";
        VFLines: Record "33020063";
        EMIDelayDays: Integer;
        DueAmountPrincipal: Decimal;
        DueAmountInterest: Decimal;
        DueAmountPenalty: Decimal;
        VFHeader: Record "33020062";
        Text0001: Label 'The loan file %1 is already closed or loan is disbursed. You can not make any changes on this file.';
        BatchName: Code[30];
        Text0002: Label 'Loan disbursement entries has been created. Please open and post Purch. Credit Memo No. %2 and Cash Receipt Journal to complete this process.';
        InvoiceNo: Code[20];
        Vehicle: Record "25006005";
        DaysSinceCaptured: Integer;
        IsCaptured: Boolean;
        LastInstallmentDate: Date;
        UserSetup: Record "91";
        ActivityRec: Record "33020077";
        LoanApprovalCheckListPage: Page "33020121";
                                       LoanApprovalCheckList: Record "33020069";
                                       CheckListMaster: Record "33020068";
                                       RiskAssessmentSetup: Record "33020081";
                                       RiskAssessment: Record "33020082";
                                       LoanRiskAssessmentList: Page "33020123";
                                       Text0003: Label 'Loan has not been disbursed.';
        [InDataSet]
        EditLoan: Boolean;
        CashRcptJnl: Page "255";
    [InDataSet]

    IsHirePurchase: Boolean;
    PurchHdr: Record "38";
    PurchLine: Record "39";
    NetRealValueSetup: Record "33020066";
    LoanProcTracking: Record "33020084";
        [InDataSet]
        CanChangeDates: Boolean;
        VFDocModification: Report "33020075";
                               VehicleFinanceApp: Record "33020073";
                               SOLReport: Report "33020061";
                               SalesInvHdr: Record "112";
                               SalesHdr: Record "36";
                               VehicleInsuranceMgt: Codeunit "25006200";
                               SpecialCasesEditable: Boolean;
                               LoanDisbursedEditable: Boolean;
                               VehicleInsuranceMgt2: Codeunit "25006200";
                               HasIncomingDocument: Boolean;
                               SMSWebService: Codeunit "50002";
                               varFilterPageBuilder: FilterPageBuilder;
                               FinVehHeaderTxt: Label 'Vehicle Finance Header Table';

    [Scope('Internal')]
    procedure CreateSalesOrder()
    var
        lSalesHeader: Record "36";
        lSalesLine: Record "37";
        luserSetup: Record "91";
        lResponsibilityCenter: Record "33019846";
        NoSeriesMngt: Codeunit "396";
        lVFSetup: Record "33020064";
        ServiceChrgAmount: Decimal;
    begin
        luserSetup.GET(USERID);
        luserSetup.TESTFIELD("Default Accountability Center"); //Min
        lResponsibilityCenter.GET(luserSetup."Default Accountability Center"); //Min
        lVFSetup.GET;
        lVFSetup.TESTFIELD("Service Charges Account");
        lSalesHeader.INIT;
        lSalesHeader."Document Type":=lSalesHeader."Document Type"::Invoice;
        lSalesHeader."No.":=NoSeriesMngt.GetNextNo(lResponsibilityCenter."Sales Invoice Nos.",TODAY,TRUE);
        InvoiceNo := lSalesHeader."No.";
        lSalesHeader.VALIDATE(lSalesHeader."Posting Date",TODAY);
        lSalesHeader.INSERT;
        lSalesHeader.VALIDATE("Sell-to Customer No.","Customer No.");

        lSalesHeader."VF Loan No":="Loan No.";
        lSalesHeader.VALIDATE(lSalesHeader."Accountability Center",luserSetup."Default Accountability Center"); //Min
        lSalesHeader.VALIDATE(lSalesHeader."Location Code",luserSetup."Default Location");
        //lSalesHeader.VALIDATE("Prices Including VAT",TRUE);
        lSalesHeader.MODIFY(TRUE);

        lSalesLine.INIT;
        lSalesLine.VALIDATE("Document Type",lSalesLine."Document Type"::Invoice);
        lSalesLine.VALIDATE("Document No.",lSalesHeader."No.");
        lSalesLine.VALIDATE(lSalesLine."Sell-to Customer No.",lSalesHeader."Sell-to Customer No.");
        lSalesLine.VALIDATE(lSalesLine.Type,lSalesLine.Type::"G/L Account");
        lSalesLine.VALIDATE("No.",lVFSetup."Service Charges Account");
        lSalesLine.VALIDATE("Location Code",lSalesHeader."Location Code");
        lSalesLine.VALIDATE(Quantity,1);
        //ServiceChrgAmount
        lSalesLine.VALIDATE("Unit Price",ROUND("Service Charge"/1.13));
        lSalesLine.INSERT(TRUE);
    end;

    [Scope('Internal')]
    procedure BlockUnblockVIN(Block: Boolean)
    var
        VehicleNextCompany: Record "25006005";
        BlockHistoryNextCompany: Record "50009";
    begin
        IF Block THEN BEGIN
          IF Blocked THEN
            ERROR('This Vehicle has already been blocked by %1!', "Blocked by");
          TESTFIELD("Blocked Remarks");
        END ELSE
          TESTFIELD("UnBlocked Remarks");
        
        Vehicle.RESET;
        Vehicle.SETRANGE("Serial No.","Vehicle No.");
        IF Vehicle.FINDFIRST THEN BEGIN
          Vehicle."Blocked by VFD" := Block;
          Vehicle.MODIFY;
        END;
        
        // Block vehicle in STPL >>
        VehicleNextCompany.CHANGECOMPANY('AGNI INCORPORATED PVT. LTD.');
        BlockHistoryNextCompany.CHANGECOMPANY('AGNI INCORPORATED PVT. LTD.');
        
        //ZM June 05, 2018 >>
        VehicleNextCompany.RESET;
        VehicleNextCompany.SETRANGE(VIN,Vehicle.VIN);
        IF NOT VehicleNextCompany.FINDFIRST THEN BEGIN
          VehicleNextCompany.CHANGECOMPANY('AGNI INCORPORATED PVT. LTD.');
          BlockHistoryNextCompany.CHANGECOMPANY('AGNI INCORPORATED PVT. LTD.');
        END;
        //ZM June 05, 2018 <<
        
        VehicleNextCompany.RESET;
        VehicleNextCompany.SETRANGE(VIN,Vehicle.VIN);
        IF VehicleNextCompany.FINDFIRST THEN BEGIN
          VehicleNextCompany."Blocked by VFD" := Block;
          VehicleNextCompany.MODIFY(TRUE);
          BlockHistoryNextCompany.RESET;
          IF BlockHistoryNextCompany.FINDLAST THEN
            BlockHistoryNextCompany."Entry No." += 1
          ELSE
            BlockHistoryNextCompany."Entry No." := 1;
          BlockHistoryNextCompany.LOCKTABLE;
          BlockHistoryNextCompany.INIT;
          BlockHistoryNextCompany.Date := TODAY;
          BlockHistoryNextCompany.Table := BlockHistoryNextCompany.Table::Vehicle;
          IF Block THEN BEGIN
            BlockHistoryNextCompany.Reason := "Blocked Remarks";
            BlockHistoryNextCompany."Block Type" := BlockHistoryNextCompany."Block Type"::All;
            BlockHistoryNextCompany."Blocked By VFD" := TRUE;
          END ELSE BEGIN
            BlockHistoryNextCompany.Reason := "UnBlocked Remarks";
            BlockHistoryNextCompany."Block Type" := BlockHistoryNextCompany."Block Type"::Unblock;
          END;
          BlockHistoryNextCompany."User ID" := USERID;
          BlockHistoryNextCompany.Company := COMPANYNAME;
          BlockHistoryNextCompany."Record No." := VehicleNextCompany."Serial No.";
          BlockHistoryNextCompany.INSERT;
          /*VehicleNextCompany."Blocked by VFD" := Block;  //ZM Feb 20, 2017
          VehicleNextCompany.MODIFY;*/  //ZM Feb 20, 2017
        END;
        
        // Block vehicle in STPL <<
        
        IF Block THEN BEGIN
          Blocked := TRUE;
          "Blocked by" := USERID;
          "Blocked Date" := TODAY;
          MODIFY;
          ACtivityLog("Loan No.",ActivityRec."Activity Type"::"VIN Blocked");
          MESSAGE('This Vehicle has been Blocked Successfully!');
        END ELSE BEGIN
          Blocked := FALSE;
          "Blocked by" := '';
          //"blocked date" := OD;
          ACtivityLog("Loan No.",ActivityRec."Activity Type"::"VIN Unblocked");
          MODIFY;
          MESSAGE('This Vehicle has been Unblocked Successfully!');
        END;

    end;

    [Scope('Internal')]
    procedure CaptureUnCaptureVIN(Block: Boolean)
    begin
        IF Block THEN BEGIN
          Captured := TRUE;
          "Capture Updated by" := USERID;
          "Captured Date" := TODAY;
          MODIFY;
          ACtivityLog("Loan No.",ActivityRec."Activity Type"::"Vehicle Captured");
        END ELSE BEGIN
          Captured := FALSE;
          "Capture Updated by" := '';
          "Captured Date" := 0D;
          MODIFY;
          ACtivityLog("Loan No.",ActivityRec."Activity Type"::"Vehicle Uncaptured");
        END;
    end;

    [Scope('Internal')]
    procedure MarkDefaulter(MarkUnmark: Boolean)
    begin
        IF MarkUnmark THEN BEGIN
          Defaulter := TRUE;
          MODIFY;
          ACtivityLog("Loan No.",ActivityRec."Activity Type"::"Marked Defaulter");
        END ELSE BEGIN
          Defaulter := FALSE;
          MODIFY;
          ACtivityLog("Loan No.",ActivityRec."Activity Type"::"Unmarked Defaulter");
        END;
    end;

    [Scope('Internal')]
    procedure SetRecSelectionFilter(var VehFinHeader: Record "33020062")
    begin
        CurrPage.SETSELECTIONFILTER(VehFinHeader);
    end;

    [Scope('Internal')]
    procedure ACtivityLog(LoanNo: Code[20];ActivityType: Option " ","VIN Blocked","VIN Unblocked","Vehicle Captured","Vechicle Uncaptured","Loan Closed","Loan Reopen","Marked Defaulter","Unmarked Defaulter",Rescheduled,Transfered,Accidental)
    var
        EntryNo: Integer;
    begin
        ActivityRec.RESET;
        IF ActivityRec.FINDLAST THEN
          EntryNo := ActivityRec."Entry No." + 1
        ELSE
          EntryNo := 1;

        ActivityRec.RESET;
        ActivityRec.INIT;
        ActivityRec."Entry No." := EntryNo;
        ActivityRec."Loan No." := LoanNo;
        ActivityRec.Date := TODAY;
        ActivityRec."User ID" := USERID;
        ActivityRec."Activity Type" := ActivityType;
        ActivityRec.Remarks := "Blocked Remarks";      //ZM Feb 20, 2017
        //SRT Dec 5th 2019 >>
        IF ActivityType = ActivityType::Accidental THEN
          ActivityRec.Remarks := "Accidental Remarks";
        //SRT Dec 5th 2019 <<
        ActivityRec.INSERT;
    end;

    [Scope('Internal')]
    procedure TestCheckList(ApplicationNo: Code[20])
    begin
        LoanApprovalCheckList.RESET;
        LoanApprovalCheckList.SETRANGE("Document Type",LoanApprovalCheckList."Document Type"::Loan);
        LoanApprovalCheckList.SETRANGE("Document No.",ApplicationNo);
        IF NOT LoanApprovalCheckList.FINDFIRST THEN BEGIN
          CheckListMaster.RESET;
          IF CheckListMaster.FINDSET THEN REPEAT
            LoanApprovalCheckList.INIT;
            LoanApprovalCheckList."Document Type" := LoanApprovalCheckList."Document Type"::Loan;
            LoanApprovalCheckList."Document No." := ApplicationNo;
            LoanApprovalCheckList."Check List Code" := CheckListMaster.Code;
            LoanApprovalCheckList.Description := CheckListMaster.Description;
            LoanApprovalCheckList."Description 2" := CheckListMaster."Description 2";
            LoanApprovalCheckList.INSERT;
          UNTIL CheckListMaster.NEXT = 0;
        END;

        LoanApprovalCheckList.RESET;
        LoanApprovalCheckList.SETRANGE("Document Type",LoanApprovalCheckList."Document Type"::Loan);
        LoanApprovalCheckList.SETRANGE("Document No.",ApplicationNo);
        IF LoanApprovalCheckList.FINDSET THEN REPEAT
          LoanApprovalCheckList.CALCFIELDS("Is Mandatory?");
          IF (LoanApprovalCheckList."Is Mandatory?") AND (NOT LoanApprovalCheckList."Is Accomplished?") THEN
             IF NOT LoanApprovalCheckList.Exceptional THEN
                ERROR('Checklist %1 must be accomplished before loan disbursement.',LoanApprovalCheckList."Check List Code");
        UNTIL LoanApprovalCheckList.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure GetVFPrepaymentAmount(LoanNo: Code[20]) PrepaymentAmount: Decimal
    var
        VFPaymentLine: Record "33020072";
    begin
        //STPL.15.08 >>
        PrepaymentAmount := 0;
        VFPaymentLine.RESET;
        VFPaymentLine.SETRANGE("Loan No.",LoanNo);
        VFPaymentLine.SETRANGE("Posting Type",VFPaymentLine."Posting Type"::Prepayment);
        IF VFPaymentLine.FINDFIRST THEN REPEAT
          PrepaymentAmount += VFPaymentLine."Prepayment Paid";
        UNTIL VFPaymentLine.NEXT = 0;
        EXIT(PrepaymentAmount);
        //STPL.15.08 <<
    end;

    [Scope('Internal')]
    procedure DisburseLoan_HP()
    var
        CreateVFJournal: Codeunit "33020063";
        ReceiptType: Option " ",Booking,"Part Payment","Retention Amount","Finance Amount",Invoice,Installment,Deposit,"Tendor Amount","LC Amount","Cheque Returned","VF Payment",Advance;
        SalesHeader: Record "36";
        SalesLine: Record "37";
        Vendor: Record "23";
    begin
        IF Closed THEN
          ERROR(Text0001,"Loan No.");
        TESTFIELD("Shortcut Dimension 1 Code");
        TESTFIELD("Shortcut Dimension 2 Code");
        //TESTFIELD("Shortcut Dimension 3 Code");
        TESTFIELD("Nominee Account No.");
        TESTFIELD("Nominee Account Name");
        TESTFIELD("Disbursed To");
        //TESTFIELD("Incoming Document");
        IF "Loan Disbursed" THEN
          ERROR('Loan has already been disbursed for this Loan File.');
        OK := CONFIRM('Do you want to create loan sanction journals for this loan?');
        IF OK THEN BEGIN
          TestCheckList("Loan No.");
          //calculate differencial interest
          VFSetup.GET;
          VFSetup.TESTFIELD("VB Journal Batch Name");
          VFSetup.TESTFIELD("Commission Income Account"); // 21 Aug 2015 SM
          NetRealValueSetup.GET("Model Version No."); // 21 Aug 2015 SM
          //NetRealValueSetup.TESTFIELD("Commission Rate"); // 21 Aug 2015 SM
          BatchName := VFSetup."VB Journal Batch Name";
          DifferentialDays := "First Installment Date" - "Disbursement Date";
          DifferentialInterest := ROUND("Loan Amount" * (("Interest Rate"/100)/365) * DifferentialDays,0.01,'=');
        
          //create princial receivable journal
          CreateVFJournal.SetReceiptType(ReceiptType::"VF Payment");
        
          CreateVFJournal.LoanApproval(TODAY,AccountType::Customer,"Customer No.",'Principal receivable against Vehicle Financing',
            "Loan Amount","Loan No.",VIN,BatchName,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code"
            ,0,VFPostingType::Principal,TRUE,FALSE,TODAY,TRUE,'','',"Shortcut Dimension 3 Code");
        
          CreateVFJournal.LoanApproval(TODAY,AccountType::Vendor,"Disbursed To",'Loan disburement of File No. ' + "Loan No.",
          - "Loan Amount","Loan No.",VIN,BatchName,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code"
            ,0,VFPostingType::Principal,TRUE,FALSE,TODAY,TRUE,'','',"Shortcut Dimension 3 Code");
        
          //create differential interest receivable
          /*
          IF "Interest on CAD" > 0 THEN BEGIN
            CreateVFJournal.LoanApproval(TODAY,AccountType::Customer,"Customer No.",'Differential interest',
              "Interest on CAD","Loan No.",VIN,BatchName,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code"
              ,0,VFPostingType::Interest,TRUE,FALSE,TODAY,TRUE,'','',"Shortcut Dimension 3 Code");
        
            CreateVFJournal.LoanApproval(TODAY,AccountType::"G/L Account",VFSetup."Interest Posting Account"
              ,'Differential interest',
              -"Interest on CAD","Loan No.",VIN,BatchName,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",
              0,VFPostingType::Interest,TRUE,FALSE,TODAY,TRUE,'','',"Shortcut Dimension 3 Code");
          END;
           */
          //create service charge entries
          /*
          CreateVFJournal.LoanApproval(TODAY,AccountType::Customer,"Customer No.",'Service Charge Payment',
            -"Service Charge","Loan No.",VIN,BatchName,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code"
            ,0,VFPostingType::"Service Charge",TRUE,FALSE,TODAY,TRUE,'');
        
          CreateVFJournal.LoanApproval(TODAY,AccountType::"G/L Account",VFSetup."Service Charges Account"
            ,'Service charge receivable',
            "Service Charge","Loan No.",VIN,BatchName,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code"
            ,0,VFPostingType::"Service Charge",TRUE,FALSE,TODAY,TRUE,'');
          */
          IF ("Service Charge" <> 0) AND ("Other Charges" <> 0) THEN
            CreateSalesOrder;
        
         /*
         //create other charges entries
          CreateVFJournal.LoanApproval(TODAY,AccountType::Customer,"Customer No.",'Other charges receivable',
            "Other Charges","Loan No.",'xxxxxx',batchname,'','',0,VFPostingType::"Other Charge",TRUE,FALSE,today);
        
          CreateVFJournal.LoanApproval(TODAY,AccountType::"G/L Account",VFSetup."Other Charges Account"
            ,'Principal receivable against vehicle loan sanction',
            -"Other Charges","Loan No.",'xxxxxx',batchname,'','',0,VFPostingType::"Other Charge",TRUE,FALSE,today);
          */
        
          // 21 Aug 2015 SM to create credit memo
          IF "Vendor No." <> '' THEN BEGIN
            Vendor.GET("Vendor No.");
            Vendor.TESTFIELD("Customer Code");
            CALCFIELDS(VIN);
            CLEAR(SalesHeader);
            CLEAR(SalesLine);
        
            SalesInvHdr.RESET;
            SalesInvHdr.SETRANGE("External Document No.","Loan No.");
            IF NOT SalesInvHdr.FINDFIRST THEN BEGIN
              SalesHdr.RESET;
              SalesHdr.SETRANGE("External Document No.","Loan No.");
              IF NOT SalesHdr.FINDFIRST THEN BEGIN
                SalesHeader.INIT;
                SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                SalesHeader.INSERT(TRUE);
        
                SalesHeader.VALIDATE("Sell-to Customer No.",Vendor."Customer Code");
                SalesHeader.VALIDATE("Posting Date",TODAY);
                SalesHeader.VALIDATE("External Document No.","Loan No.");
                SalesHeader.VALIDATE("Salesperson Code","Responsible Person Code");
                SalesHeader.MODIFY(TRUE);
        
                SalesLine.INIT;
                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := 10000;
                SalesLine.VALIDATE(Type,SalesLine.Type::"G/L Account");
                SalesLine.VALIDATE("No.",VFSetup."Commission Income Account");
                SalesLine.VALIDATE(Description,VIN);
                SalesLine.VALIDATE("Unit Price",NetRealValueSetup."Commission Rate");
                SalesLine.VALIDATE("Location Code",SalesHeader."Location Code");
                SalesLine."Make Code" := "Make Code";
                SalesLine."Model Code" := "Model Code";
                SalesLine."Model Version No." := "Model Version No.";
                //SalesLine."VIN - COGS" := VIN;//for Min dai
                SalesLine.VALIDATE(Quantity,1);
                SalesLine.VALIDATE("Unit of Measure Code",'UNIT');
                SalesLine.INSERT(TRUE);
              END;
            END;
          END;
          /*
          CLEAR(PurchHdr);
          CLEAR(PurchLine);
        
          PurchHdr.INIT;
          PurchHdr.VALIDATE("Document Type",PurchHdr."Document Type"::"Credit Memo");
          PurchHdr.INSERT(TRUE);
        
          PurchHdr.VALIDATE("Buy-from Vendor No.","Vendor No.");
          PurchHdr.VALIDATE("Pay-to Vendor No.","Vendor No.");
          PurchHdr.VALIDATE("Vendor Cr. Memo No.","Loan No.");
          PurchHdr."Posting Description" := "Customer Name";  //May 18, 2017
          PurchHdr."Posting Date" := TODAY;
          PurchHdr."Document Date" := TODAY;
          PurchHdr."Order Date" := TODAY;
        
          PurchHdr.MODIFY;
        
          PurchLine.INIT;
          PurchLine.VALIDATE("Document Type",PurchLine."Document Type"::"Credit Memo");
          PurchLine.VALIDATE("Document No.",PurchHdr."No.");
          PurchLine."Line No." := 10000;
          PurchLine.VALIDATE(Type,PurchLine.Type::"G/L Account");
          PurchLine.VALIDATE("No.",VFSetup."Commission Income Account");
          PurchLine.VALIDATE("Direct Unit Cost",NetRealValueSetup."Commission Rate");
          PurchLine.VALIDATE("Location Code",PurchHdr."Location Code");
          PurchLine."Make Code" := "Make Code";
          PurchLine."Model Code" := "Model Code";
          PurchLine."Model Version No." := "Model Version No.";
          PurchLine."VIN - COGS" := VIN;
          PurchLine.VALIDATE(Quantity,1);
          PurchLine.VALIDATE("Unit of Measure Code",'UNIT');
          PurchLine.INSERT(TRUE);
          // 21 Aug 2015 SM to create credit memo
          */
          "Application Status" := 'LOAN DISBURSEMENT'; //Min
          "Disbursed By" := USERID;
          MODIFY;
          MESSAGE(Text0002,InvoiceNo,PurchHdr."No.");  // june 4, 2015,  ZM
        
          LoanProcTracking.RESET;
          LoanProcTracking.SETRANGE("Application No.","Application No.");
          LoanProcTracking.SETRANGE(Components,'DISBURSEMENT');
          IF LoanProcTracking.FINDFIRST THEN BEGIN
            LoanProcTracking.VALIDATE(Processed,TRUE);
            LoanProcTracking.MODIFY;
          END;
        
        END ELSE
          MESSAGE(Text0003);   // june 4, 2015,  ZM
        
        //CreateFollowupDetails(Rec); //Feb 27, 2019 follow up will be created when journal is posted so commented over here.  SRT May 22th 2019
        ACtivityLog("Loan No.",ActivityRec."Activity Type"::"Loan Disbursed");

    end;

    [Scope('Internal')]
    procedure DisburseLoan_VF()
    var
        CreateVFJournal: Codeunit "33020066";
    begin
        IF Closed THEN
          ERROR(Text0001,"Loan No.");
        
        IF "Loan Disbursed" THEN
          ERROR('Loan has been already disbursed for this Loan File.');
        OK := CONFIRM('Do you want to create loan sanction journals for this loan?');
        IF OK THEN BEGIN
          TestCheckList("Loan No.");
          //calculate differencial interest
          VFSetup.GET;
          VFSetup.TESTFIELD("VB Journal Batch Name");
          BatchName := VFSetup."VB Journal Batch Name";
          DifferentialDays := "First Installment Date" - "Disbursement Date";
          DifferentialInterest := ROUND("Loan Amount" * (("Interest Rate"/100)/365) * DifferentialDays,0.01,'=');
        
          //create princial receivable journal
          CreateVFJournal.LoanApproval(TODAY,AccountType::Customer,"Customer No.",'Principal receivable against Vehicle Financing',
            "Loan Amount","Loan No.",VIN,BatchName,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code"
            ,0,VFPostingType::Principal,TRUE,FALSE,TODAY,TRUE,'','',"Shortcut Dimension 3 Code");
        
          CreateVFJournal.LoanApproval(TODAY,AccountType::Vendor,"Disbursed To"
            ,'Loan disburement ot File No. ' + "Loan No.",
            -"Loan Amount","Loan No.",VIN,BatchName,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code"
            ,0,VFPostingType::Principal,TRUE,FALSE,TODAY,TRUE,'','',"Shortcut Dimension 3 Code");
        
          //create differential interest receivable
          /*
          IF "Interest on CAD" > 0 THEN BEGIN
            CreateVFJournal.LoanApproval(TODAY,AccountType::Customer,"Customer No.",'Differential interest',
              "Interest on CAD","Loan No.",VIN,BatchName,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code"
              ,0,VFPostingType::Interest,TRUE,FALSE,TODAY,TRUE,'','',"Shortcut Dimension 3 Code");
        
            CreateVFJournal.LoanApproval(TODAY,AccountType::Vendor,"Disbursed To"
              ,'Differential interest',
              -"Interest on CAD","Loan No.",VIN,BatchName,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",
              0,VFPostingType::Interest,TRUE,FALSE,TODAY,TRUE,'','',"Shortcut Dimension 3 Code");
          END;
           */
        
          //create service charge entries
          /*
          CreateVFJournal.LoanApproval(TODAY,AccountType::Customer,"Customer No.",'Service Charge Payment',
            -"Service Charge","Loan No.",VIN,BatchName,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code"
            ,0,VFPostingType::"Service Charge",TRUE,FALSE,TODAY,TRUE,'');
        
          CreateVFJournal.LoanApproval(TODAY,AccountType::"G/L Account",VFSetup."Service Charges Account"
            ,'Service charge receivable',
            "Service Charge","Loan No.",VIN,BatchName,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code"
            ,0,VFPostingType::"Service Charge",TRUE,FALSE,TODAY,TRUE,'');
          */
          IF ("Service Charge" <> 0) AND ("Other Charges" <> 0) THEN
            CreateSalesOrder;
         /*
         //create other charges entries
          CreateVFJournal.LoanApproval(TODAY,AccountType::Customer,"Customer No.",'Other charges receivable',
            "Other Charges","Loan No.",'xxxxxx',batchname,'','',0,VFPostingType::"Other Charge",TRUE,FALSE,today);
        
          CreateVFJournal.LoanApproval(TODAY,AccountType::"G/L Account",VFSetup."Other Charges Account"
            ,'Principal receivable against vehicle loan sanction',
            -"Other Charges","Loan No.",'xxxxxx',batchname,'','',0,VFPostingType::"Other Charge",TRUE,FALSE,today);
          */
        END;
          "Application Status" := 'LOAN DISBURSEMENT'; //Min
          "Disbursed By" := USERID;
          MODIFY;
        ACtivityLog("Loan No.",ActivityRec."Activity Type"::"Loan Disbursed");
        MESSAGE(Text0002,InvoiceNo);

    end;

    [Scope('Internal')]
    procedure CreateFollowupDetails(var VehicleFinanceHeader: Record "33020062")
    var
        FollowupDetails: Record "33020086";
        Customer: Record "18";
        Vehicle: Record "25006005";
        VFSetup: Record "33020064";
    begin
        WITH VehicleFinanceHeader DO BEGIN
          FollowupDetails.INIT;
          FollowupDetails.Type := FollowupDetails.Type::Sales;
          FollowupDetails."No." := "Loan No.";
          FollowupDetails."Sell-to Customer No." := "Customer No.";
          FollowupDetails."Sell-to Customer Name" := "Customer Name";

          FollowupDetails."Bill-to Customer No." := "Customer No.";
          FollowupDetails."Bill-to Name"  := "Customer Name";
          FollowupDetails."Bill Amount" := "Loan Amount";
          Customer.GET("Customer No.");

          FollowupDetails."Contact Phone No." :=  Customer."Phone No.";
          IF Customer."Mobile No." <> '' THEN
            FollowupDetails."Contact Phone No." := FollowupDetails."Contact Phone No." +','+ Customer."Mobile No.";

          FollowupDetails."Sell-to Address" := Customer.Address;
          FollowupDetails."Bill-to Address" := Customer.Address;

          FollowupDetails."Posting Date"  := "Disbursement Date";
          FollowupDetails."Delivered Date" := VehicleFinanceHeader."First Installment Date";
          FollowupDetails."Delivered By User ID" := FollowupDetails."Delivered By User ID";

          Vehicle.GET("Vehicle No.");
          FollowupDetails."Vehicle Serial No." := "Vehicle No.";
          FollowupDetails.VIN := Vehicle.VIN;
          FollowupDetails."Vehicle Registration No." := Vehicle."Registration No.";
          FollowupDetails."Make Code"  := Vehicle."Make Code";
          FollowupDetails."Model Code" := Vehicle."Model Code";
          FollowupDetails."Model Version No." := Vehicle."Model Version No.";

          VFSetup.GET;
          FollowupDetails."Probable Follow Up Date" := "Disbursement Date" + VFSetup."Probable Followup Days";

          FollowupDetails."SalesPerson Code" := "Responsible Person Code";
          FollowupDetails.INSERT;
        END;
    end;

    [Scope('Internal')]
    procedure "--SRT--"()
    begin
    end;

    [Scope('Internal')]
    procedure SetControlProperty()
    var
        LoanProcTracking: Record "33020084";
        VehicleFinanceSetup: Record "33020064";
    begin
        //SRT Sept 19th 2019
        LoanProcTracking.RESET;
        LoanProcTracking.SETRANGE("Application No.","Application No.");
        LoanProcTracking.SETRANGE(Components,'DISBURSEMENT');
        IF NOT LoanProcTracking.FINDFIRST THEN
         SpecialCasesEditable := TRUE
        ELSE
          SpecialCasesEditable := FALSE;

        //SRT Dec 5th 2019 >>
        LoanDisbursedEditable := FALSE;
        VehicleFinanceSetup.GET;
        UserSetup.GET(USERID);
        IF VehicleFinanceSetup."Loan Disbursed" = UserSetup."User ID" THEN
          LoanDisbursedEditable := TRUE
        //SRT Ded 5th 2019 <<
    end;

    [Scope('Internal')]
    procedure AccidentalVIN(IsAccidental: Boolean)
    var
        Vehicle: Record "25006005";
    begin
        //SRT Dec 5th 2019 >>
        IF IsAccidental THEN BEGIN
          TESTFIELD("Accidental Remarks");
          IF Vehicle.GET("Vehicle No.") THEN BEGIN
            Vehicle."Accidental Vehicle" := TRUE;
            Vehicle.MODIFY;
          END;
          ACtivityLog("Loan No.",ActivityRec."Activity Type"::Accidental);
        END ELSE BEGIN
          IF Vehicle.GET("Vehicle No.") THEN BEGIN
            Vehicle."Accidental Vehicle" := FALSE;
            Vehicle.MODIFY;
          END;
          ACtivityLog("Loan No.",ActivityRec."Activity Type"::Accidental);
        END
        //SRT Dec 5th 2019 <<
    end;
}


page 33020068 "Approved Vehicle Finance List"
{
    CardPageID = "Vehicle Finance Card";
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020062;
    SourceTableView = SORTING(Loan No.)
                      ORDER(Ascending)
                      WHERE(Approved = CONST(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan Status"; "Loan Status")
                {
                }
                field("NRV Status"; "NRV Status")
                {
                }
                field("Loan No."; "Loan No.")
                {
                }
                field("Customer No."; "Customer No.")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Nominee Account No."; "Nominee Account No.")
                {
                }
                field("Model Version"; "Model Version")
                {
                }
                field("Model Version No. 2"; "Model Version No. 2")
                {
                }
                field("Vehicle Regd. No."; "Vehicle Regd. No.")
                {
                }
                field("Make Code"; "Make Code")
                {
                }
                field(VIN; VIN)
                {
                }
                field("Followed Up in Last 30 Days"; "Followed Up in Last 30 Days")
                {
                }
                field("Interest Rate"; "Interest Rate")
                {
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
                field("EMI Amount"; "EMI Amount")
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
                field("Principal Due"; "Principal Due")
                {
                }
                field("Interest Due"; "Interest Due")
                {
                }
                field("Interest Due Defered"; "Interest Due Defered")
                {
                }
                field("Penalty Due"; "Penalty Due")
                {
                }
                field("Insurance Due"; "Insurance Due")
                {
                }
                field("Other Amount Due"; "Other Amount Due")
                {
                }
                field("Total Due"; "Total Due")
                {
                }
                field("Penalty %"; "Penalty %")
                {
                }
                field("Net Realization Value"; "Net Realization Value")
                {
                }
                field("Due Installments"; "Due Installments")
                {
                }
                field("No of Due Days"; "No of Due Days")
                {
                }
                field("Due Days Crossed Maturity"; "Due Days Crossed Maturity")
                {
                }
                field("Due Installment as of Today"; "Due Installment as of Today")
                {
                }
                field("Due Principal"; "Due Principal")
                {
                }
                field("Total Due as of Today"; "Total Due as of Today")
                {
                }
                field("Due Calculated as of"; "Due Calculated as of")
                {
                }
                field("Last Payment Date"; "Last Payment Date")
                {
                }
                field("Responsible Person Name"; "Responsible Person Name")
                {
                }
                field("Back Date Calculated"; "Back Date Calculated")
                {
                }
                field("Date to Clear Loan"; "Date to Clear Loan")
                {
                }
                field("Expected Interest"; "Expected Interest")
                {
                    Visible = false;
                }
                field("Expected Principal"; "Expected Principal")
                {
                    Visible = false;
                }
                field("Interest Paid by Customer"; "Interest Paid by Customer")
                {
                }
                field("Principal Paid by Customer"; "Principal Paid by Customer")
                {
                }
                field("Penalty Paid by Customer"; "Penalty Paid by Customer")
                {
                    Editable = false;
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
                field(Rejected; Rejected)
                {
                }
                field("Rejected Date"; "Rejected Date")
                {
                }
                field("Rejected by"; "Rejected by")
                {
                }
                field("Rejection Reason"; "Rejection Reason")
                {
                }
                field("Approved By"; "Approved By")
                {
                }
                field("Approved Date"; "Approved Date")
                {
                }
                field("Application Open Date"; "Application Open Date")
                {
                }
                field("Disbursed To"; "Disbursed To")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
                field("Dealer Code"; "Dealer Code")
                {
                }
                field("Vehicle Application"; "Vehicle Application")
                {
                }
                field("RAM Percentage"; "RAM Percentage")
                {
                }
                field("Customer's Guarantor"; "Customer's Guarantor")
                {
                }
                field(Guarantor; Guarantor)
                {
                }
                field("Property NRV"; "Mortgage NRV")
                {
                    Caption = 'Property NRV';
                }
                field("Insurance Expiry Date"; "Insurance Expiry Date")
                {
                }
                field("BlueBook Expire Date"; "BlueBook Expire Date")
                {
                }
                field("Property Address"; "Property Address")
                {
                }
                field("Building Area"; "Building Area")
                {
                }
                field("Financing Bank No."; "Financing Bank No.")
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
                field("Land Area"; "Land Area")
                {
                }
                field("Insurance Company Name"; "Insurance Company Name")
                {
                }
                field("Property Details"; "Mortgage Details")
                {
                    Caption = 'Property Details';
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
            part("<VF FactBox>"; 33020125)
            {
                Caption = 'VF FactBox';
                SubPageLink = Loan No.=FIELD(Loan No.);
            }
            part(; 33020293)
            {
                SubPageLink = Loan No.=FIELD(Loan No.);
            }
            systempart(; Notes)
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
                            ERROR(Text0001, "Loan No.");

                        CurrPage.SETSELECTIONFILTER(VFHeader);
                        REPORT.RUN(33020063, TRUE, TRUE, VFHeader);
                    end;
                }
                action("Process Cash Receipt")
                {
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 33020071;
                    RunPageLink = Loan No.=FIELD(Loan No.);
                    RunPageView = SORTING(Loan No.)
                                  ORDER(Ascending);
                    Visible = NOT IsHirePurchase;

                    trigger OnAction()
                    begin
                        //OK := CONFIRM('Do you want to approve this loan?');
                    end;
                }
                action("Process Nominee Receipt")
                {
                    Caption = 'Process Cash Receipt';
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
                action("Send To Follow Up")
                {
                    Caption = '&Send To Follow Up';
                    Image = TeamSales;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    var
                        VehFin: Record "33020062";
                    begin
                        SetRecSelectionFilter(VehFin);
                        IF SetLineSelection(VehFin) THEN
                          MESSAGE('List has been Registered for Follow Up.');
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
                          InsertMissingLoanTrackingMaster(Rec); //SRT Dec 5th 2019
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
                              LoanProcTrackingRec.Date := TODAY;
                              LoanProcTrackingRec."User Id" := USERID;
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
            }
            group("<Action1102159021>")
            {
                Caption = 'Reschedule';
                action("Reschedule Loan")
                {
                    Ellipsis = true;
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        IF Closed THEN
                          ERROR(Text0001,"Loan No.");

                        VFSetup.GET;
                        IF VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase" THEN
                          CalculateEMI.CalculateEMI("Loan Amount","Interest Rate","Tenure in Months","Loan No.",FALSE)
                        ELSE
                          CalculateEMI_VF.CalculateEMI("Loan Amount","Interest Rate","Tenure in Months","Loan No.",FALSE);
                    end;
                }
            }
            group("<Action1102159036>")
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
                                    RunPageLink = Customer No.=FIELD(No. Series);
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
                action("<Action1000000003>")
                {
                    Caption = 'Customer Statement';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    Visible = EditLoan;

                    trigger OnAction()
                    var
                        HirePurchaseSetup: Record "33020064";
                    begin
                        //message('11');
                        CurrPage.SETSELECTIONFILTER(VFHeader);
                        HirePurchaseSetup.GET;
                        IF HirePurchaseSetup."Policy Type" = HirePurchaseSetup."Policy Type"::"Hire Purchase" THEN
                          //REPORT.RUN(50046,TRUE,FALSE,VFHeader)
                            REPORT.RUN(50045,TRUE,FALSE,VFHeader)
                        ELSE IF HirePurchaseSetup."Policy Type" = HirePurchaseSetup."Policy Type"::"Vehicle Finance" THEN
                          REPORT.RUN(50081,TRUE,FALSE,VFHeader);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF Rejected THEN
          EditLoan := FALSE
        ELSE
          EditLoan := TRUE;
    end;

    trigger OnOpenPage()
    begin
        VFSetup.GET;
        IsHirePurchase := VFSetup."Policy Type" = VFSetup."Policy Type"::"Hire Purchase";
    end;

    var
        Text0001: Label 'The loan file %1 is already closed. You can not make any changes on this file.';
        Text0002: Label 'Loan disbursement entries has been created. Please open and post Sales Invoice No. %1 and Cash Receipt Journal to complete this process.';
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
        BatchName: Code[20];
        InvoiceNo: Code[20];
        [InDataSet]
        EditLoan: Boolean;
        CashRcptJnl: Page "255";
    [InDataSet]

    IsHirePurchase: Boolean;
    Vehicle: Record "25006005";

    [Scope('Internal')]
    procedure SetRecSelectionFilter(var VehicleFinance: Record "33020062")
    begin
        CurrPage.SETSELECTIONFILTER(VehicleFinance);
    end;

    [Scope('Internal')]
    procedure InsertMissingLoanTrackingMaster(VehicleFinanceHeader: Record "33020062")
    var
        GeneralMaster: Record "33020061";
        LoanProcTrackingRec: Record "33020084";
        lineno: Integer;
    begin
        //SRT Dec 5th 2019 >>
        WITH VehicleFinanceHeader DO BEGIN
          GeneralMaster.RESET;
          GeneralMaster.SETRANGE(Category,'Vehicle Loan');
          GeneralMaster.SETRANGE("Sub Category",'Components');
          GeneralMaster.SETRANGE(Disable,FALSE);
          GeneralMaster.SETCURRENTKEY("Sequence No.");
          IF GeneralMaster.FINDFIRST THEN BEGIN
           LoanProcTrackingRec.RESET;
           LoanProcTrackingRec.SETRANGE("Application No.","Application No.");
           IF LoanProcTrackingRec.FINDLAST THEN
            lineno := LoanProcTrackingRec."Line No." + 10000;
           REPEAT
            LoanProcTrackingRec.RESET;
            LoanProcTrackingRec.SETRANGE("Application No.","Application No.");
            LoanProcTrackingRec.SETRANGE(Components,GeneralMaster.Code);
            IF NOT LoanProcTrackingRec.FINDFIRST THEN BEGIN
             LoanProcTrackingRec.INIT;
             LoanProcTrackingRec."Application No." := "Application No.";
             LoanProcTrackingRec."Line No."  := lineno;
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
        END;
        //SRT Dec 5th 2019 <<
    end;
}


pageextension 50092 pageextension50092 extends "Customer Card"
{
    // 09.03.2015 EDMS P21
    //   Added field:
    //     "Item Charge Invoice Deal Type"
    // 
    // 28.06.2013 EDMS P8
    //   * Added action 'Vehicles'
    // 
    // 2012.02.17 EDMS P8
    //   * add to open "Contract List EDMS"
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 122".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 12".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 35".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 27".


        //Unsupported feature: Property Modification (SubPageLink) on "SalesHistSelltoFactBox(Control 1903720907)".


        //Unsupported feature: Property Modification (SubPageLink) on "SalesHistBilltoFactBox(Control 1907234507)".


        //Unsupported feature: Property Modification (SubPageLink) on "CustomerStatisticsFactBox(Control 1902018507)".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1905532107".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1907829707".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1902613707".

        modify("Control 42")
        {
            Visible = false;
        }
        modify("Control 50")
        {
            Visible = false;
        }
        addafter("Control 4")
        {
            field("Name 2"; Rec."Name 2")
            {
            }
        }
        addafter("Control 18")
        {
            field("Phone No."; Rec."Phone No.")
            {
            }
            field("Primary Contact No."; Rec."Primary Contact No.")
            {
                Visible = false;
            }
            field(Contact; Rec.Contact)
            {
                Caption = 'Contact Person';
                Editable = true;
                Importance = Promoted;

                trigger OnValidate()
                begin
                    ContactOnAfterValidate;
                end;
            }
        }
        addafter("Control 24")
        {
            field("Accountability Center"; "Accountability Center")
            {
                Visible = false;
            }
        }
        addafter("Control 72")
        {
            field("Sys LC No."; "Sys LC No.")
            {
            }
        }
        addafter("Control 28")
        {
            field("<Type>"; Type)
            {
                Caption = 'Type';
            }
            field("Is Dealer"; "Is Dealer")
            {
            }
            field("Is Privilage"; "Is Privilage")
            {
            }
            field("Dealer Segment Type"; "Dealer Segment Type")
            {
            }
            field(Saved; Saved)
            {
                Editable = false;
                Visible = true;
            }
            field("Skip Mahindra Customer"; "Skip Mahindra Customer")
            {
                Editable = false;
            }
            field("SMS Not Required"; "SMS Not Required")
            {
            }
            field("WH Code"; "WH Code")
            {
            }
            field("Prevent BG Credit Limit"; "Prevent BG Credit Limit")
            {
            }
            field("Payment Terms Code"; Rec."Payment Terms Code")
            {
                ApplicationArea = Basic, Suite;
                Importance = Promoted;
                ShowMandatory = true;
                ToolTip = 'Specifies a code that indicates the payment terms that you require of the customer.';
            }
        }
        addafter("Control 90")
        {
            field("Province No."; "Province No.")
            {
            }
        }
        addafter("Control 29")
        {
            field(IRD; IRD)
            {
                Caption = 'Check VAT Registration';
                Editable = false;
                ExtendedDatatype = URL;
            }
        }
        addafter("Control 36")
        {
            field("Invoice Disc. Code"; Rec."Invoice Disc. Code")
            {
                Visible = false;
            }
        }
        addafter("Control 46")
        {
            field("Non-Billable"; "Non-Billable")
            {
                Visible = false;
            }
        }
        addafter(PricesandDiscounts)
        {
            field(Internal; Internal)
            {
                Visible = false;
            }
            field("Corresponding Vendor No."; "Corresponding Vendor No.")
            {
                Visible = false;
            }
            field("Default Service Item Charge"; "Default Service Item Charge")
            {
                Visible = false;
            }
            field("Item Charge Invoice Deal Type"; "Item Charge Invoice Deal Type")
            {
                Visible = false;
            }
        }
        addafter("Control 1906801201")
        {
            group("Student Details")
            {
                Caption = 'Student Details';
                field(Student_No; Rec."No.")
                {
                }
                field(Student_Class; Class)
                {
                    Caption = 'Class';
                }
                field(Section; Section)
                {
                }
                field(StudentName; Rec.Name)
                {
                }
                field(StudentName2; Rec."Name 2")
                {
                }
                field(Status; Status)
                {
                }
                field(Student_Address; Rec.Address)
                {
                }
                field(Student_Address2; Rec."Address 2")
                {
                }
                field(Student_City; Rec.City)
                {
                }
                field(Student_Contact; Rec.Contact)
                {
                }
                field(Student_PhoneNo; Rec."Phone No.")
                {
                }
                field(Student_MobileNo; "Mobile No.")
                {
                    Caption = 'Mobile No';
                }
                field("Student_E-mail"; Rec."E-Mail")
                {
                }
                field(Gender; Gender)
                {
                    ShowMandatory = true;
                }
                field("Father's Name"; "Father's Name")
                {
                }
                field("Mother's Name"; "Mother's Name")
                {
                }
                field("Guardian's Name"; "Guardian's Name")
                {
                }
                field(Caste; Caste)
                {
                }
                field("Student_Bank Account Name"; "Bank Account Name")
                {
                    Caption = 'Bank Account Name';
                }
                field("Student Left  Date"; "Student Left  Date")
                {
                }
                field("Student Joining Date"; "Student Joining Date")
                {
                }
                field(Student_BankAccNo; "Bank Account No.")
                {
                    Caption = 'Bank Account No.';
                }
            }
            group("KSKL KYC")
            {
                Caption = 'KSKL KYC';
                Visible = showKSKL;
                field("Nature of Data"; "Nature of Data")
                {
                    ToolTip = 'Type of Customer';
                }
                field("Legal Action Taken"; "Legal Action Taken")
                {
                }
                field("Legal Status"; "Legal Status")
                {
                    ShowMandatory = true;
                }
                field("Date of Company Redg"; "Date of Company Redg")
                {
                    Caption = 'Date of Company Redg/Date of Birth';
                    ShowMandatory = true;
                }
                field("Citizenship No."; "Citizenship No.")
                {
                    ShowMandatory = true;
                }
                field("Citizenship Issued Date"; "Citizenship Issued Date")
                {
                    ToolTip = 'Nepali Date in Format: YYYY-MM-DD';
                }
                field("Citizenship Issued District"; "Citizenship Issued District")
                {
                    ShowMandatory = true;
                }
                field(PAN; PAN)
                {
                }
                field("Previous PAN"; "Previous PAN")
                {
                }
                field("PAN Issue Date"; "PAN Issue Date")
                {
                    ToolTip = 'Issued Date of Pan in BS with Format: YYYY-MM-DD';
                }
                field("PAN Issue District"; "PAN Issue District")
                {
                }
                field("Voter ID"; "Voter ID")
                {
                }
                field("Voter ID issued Date"; "Voter ID issued Date")
                {
                    ToolTip = 'Date in BS with format: YYYY-MM-DD';
                }
                field("Company  Redg No."; "Company  Redg No.")
                {
                    ShowMandatory = true;
                }
                field("Comp Regd No Issud Authority"; "Comp Regd No Issud Authority")
                {
                }
                field("Address Type"; "Address Type")
                {
                    ShowMandatory = true;
                }
                field("Address 1 Line 1"; "Address 1 Line 1")
                {
                    ShowMandatory = true;
                }
                field("Street Adress And Tole"; "Street Adress And Tole")
                {
                }
                field("Ward No."; "Ward No.")
                {
                }
                field("City VDC Municipality"; "City VDC Municipality")
                {
                }
                field("Address District"; "Address District")
                {
                    ShowMandatory = true;
                }
                field("Address 2 Type"; "Address 2 Type")
                {
                    ShowMandatory = true;
                }
                field("Address 2 Line 1"; "Address 2 Line 1")
                {
                    ShowMandatory = true;
                }
                field("Address 2 District"; "Address 2 District")
                {
                    ShowMandatory = true;
                }
                field("PO Box"; "PO Box")
                {
                }
                field(Country; Country)
                {
                }
                field("Telephone No."; "Telephone No.")
                {
                }
                field("Business Activity Code"; "Business Activity Code")
                {
                }
                field("Fax 1"; "Fax 1")
                {
                }
                field(Group; Group)
                {
                }
                field("Type of Security"; "Type of Security")
                {
                }
                field("Security Ownership Type"; "Security Ownership Type")
                {
                }
                field("Date of Regestration"; "Date of Regestration")
                {
                }
                field(Passport; Passport)
                {
                }
                field("Passport Expiry Date"; "Passport Expiry Date")
                {
                }
                field("Indian Ebassy Reg Date"; "Indian Ebassy Reg Date")
                {
                }
                field("Gurantee Type"; "Gurantee Type")
                {
                }
                field("Date of Leaving"; "Date of Leaving")
                {
                }
                field("Fathers Name"; "Fathers Name")
                {
                    ShowMandatory = true;
                }
                field("Subject Name"; "Subject Name")
                {
                    ShowMandatory = true;
                }
                field("Subject Nationality"; "Subject Nationality")
                {
                    ShowMandatory = true;
                }
                field("Employment Type"; "Employment Type")
                {
                    ShowMandatory = true;
                }
                field("Employer Name"; "Employer Name")
                {
                }
                field("Monthly Income"; "Monthly Income")
                {
                }
                field("Employment Commer Register ID"; "Employment Commer Register ID")
                {
                }
                field("Subject Employer Address"; "Subject Employer Address")
                {
                }
                field(Designation; Designation)
                {
                }
                field("Customer Credit Limit"; "Customer Credit Limit")
                {
                    ShowMandatory = true;
                }
                field("Related Entity Number"; "Related Entity Number")
                {
                }
            }
        }
        moveafter(ContactDetails; "Control 12")
        moveafter("Control 12"; ContactName)
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 84".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 94".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 78".


        //Unsupported feature: Property Modification (RunPageView) on "Action 80".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 76".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 79".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 77".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 112".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 113".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 136".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 162".

        addafter(Contact)
        {
            action("&Vehicles")
            {
                Caption = '&Vehicles';
                Image = Delivery;

                trigger OnAction()
                begin
                    ShowVehicles;
                end;
            }
        }
        addafter(CustomerReportSelections)
        {
            action(Save)
            {
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    IF CONFIRM('Do you want to save the customer card?') THEN BEGIN //MIN 4/12/2019
                        Saved := TRUE;
                        Rec.MODIFY;
                    END;
                    Rec.TESTFIELD(Name);
                    Rec.TESTFIELD(Address);
                    Rec.TESTFIELD(City);
                    Rec.TESTFIELD("Mobile No.");
                    Rec.TESTFIELD("Customer Posting Group");
                    Rec.TESTFIELD("Gen. Bus. Posting Group");
                    Rec.TESTFIELD("Province No.");
                end;
            }
        }
        addfirst("Prices and Discounts")
        {
            action("<Action1101904003>")
            {
                Caption = 'Con&tracts';
                Image = ServiceAgreement;
                RunObject = Page 25006046;
                RunPageLink = Bill-to Customer No.=FIELD(No.);
                RunPageView = SORTING(Bill-to Customer No.);
            }
            group("S&ales")
            {
                Caption = 'S&ales';
                Image = Sales;
                action("&Credit Limit")
                {
                    Caption = '&Credit Limit';

                    trigger OnAction()
                    var
                        CustCreditDetail: Record "50007";
                        CustRec: Record "18";
                        CustCreditDetail2: Record "50007";
                    begin
                        //ratan 8.31.2020
                        UserSetup.GET(USERID);
                        CustRec.RESET;
                        CustRec.SETRANGE("No.","No.");
                        CustRec.SETFILTER("Customer Posting Group",UserSetup."Customer Posting Group");
                        IF NOT CustRec.FINDFIRST THEN BEGIN
                           ERROR(CustPostGrpError,"Customer Posting Group","No.");
                          END ELSE BEGIN
                            CustCreditDetail.RESET;
                            CustCreditDetail.SETRANGE("Customer No.","No.");
                            IF CustCreditDetail.FINDFIRST THEN BEGIN
                              PAGE.RUN(PAGE::"Customer Credit Limit",CustCreditDetail);
                              EXIT;
                              END
                            ELSE BEGIN
                            IF NOT CONFIRM('Do you want to create credit limit for this customer',FALSE) THEN
                              EXIT;
                            CLEAR(CustCreditDetail);
                            CustCreditDetail.INIT;
                            UserSetup.GET(USERID);
                            CustCreditDetail.VALIDATE("Customer No.","No.");
                            CustCreditDetail."Accountability Center" := UserSetup."Default Accountability Center";
                            CustCreditDetail."Global Dimension 1 Code" := UserSetup."Shortcut Dimension 1 Code";
                            CustCreditDetail."Global Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
                            CustCreditDetail.INSERT(TRUE);
                            COMMIT;
                            CustCreditDetail2.RESET;
                            CustCreditDetail2.SETRANGE("Customer No.","No.");
                            IF CustCreditDetail2.FINDLAST THEN BEGIN
                              PAGE.RUN(PAGE::"Customer Credit Limit",CustCreditDetail2);
                              EXIT;
                            END;
                            END;
                           END;
                    end;
                }
            }
        }
        addafter("Report Statement")
        {
            action("Customer Related Entity")
            {
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                RunPageMode = View;

                trigger OnAction()
                var
                    CusRE: Record "33019804";
                    CusREPage: Page "33019804";
                begin
                    CusRE.RESET;
                    CusRE.SETRANGE("Customer No.",Rec."No.");
                    CusREPage.setCustomer(Rec."No.");
                    //CusREPage.SETTABLEVIEW(CusRE);
                    CusREPage.RUN;
                end;
            }
        }
    }

    var
        CompInfo: Record "79";

    var
        IRD: Text[250];
        CustPostingGrp: Record "92";
        UserSetup: Record "91";
        SaveCustomerPageConf: Label 'You must first save the customer page before close it.';
        CustPostGrpError: Label 'You do not have permission to allow credit limit of Cust. Posting Group %1 Customer No. %2.';
        NomineeDetails: Text;
        DocumentNoVisibility: Codeunit "1400";
        showKSKL: Boolean;


    //Unsupported feature: Code Modification on "OnAfterGetCurrRecord".

    //trigger OnAfterGetCurrRecord()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CreateCustomerFromTemplate;
        ActivateFields;
        StyleTxt := SetStyle;
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RECORDID);
        CRMIsCoupledToRecord := CRMIntegrationEnabled AND CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
        GetSalesPricesAndSalesLineDisc;
        DynamicEditable := CurrPage.EDITABLE;

        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);

        EventFilter := WorkflowEventHandling.RunWorkflowOnSendCustomerForApprovalCode + '|' +
          WorkflowEventHandling.RunWorkflowOnCustomerChangedCode;

        EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::Customer,EventFilter);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..7
        //GetSalesPricesAndSalesLineDisc;
        #9..16
        */
    //end;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        ActivateFields;
        StyleTxt := SetStyle;
        BlockedCustomer := (Blocked = Blocked::All);
        BalanceExhausted := 10000 <= CalcCreditLimitLCYExpendedPct;
        DaysPastDueDate := AgedAccReceivable.InvoicePaymentDaysAverage("No.");
        AttentionToPaidDay := DaysPastDueDate > 0;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..6

        //OnAfterGetCurrRecord;
        IRD :='https://ird.gov.np/PanSearch?pan='+"VAT Registration No.";
        */
    //end;


    //Unsupported feature: Code Insertion on "OnClosePage".

    //trigger OnClosePage()
    //begin
        /*

        CustPostingGrp.GET("Customer Posting Group");
        IF CustPostingGrp."Check Duplicate VAT Reg. No." THEN BEGIN
        IF "VAT Registration No." = '' THEN BEGIN
          MESSAGE('Please enter VAT Registration No. before closing the Customer Card.');
          PAGE.RUNMODAL(21,Rec);
        END;
        END;
        */
    //end;


    //Unsupported feature: Code Modification on "OnNewRecord".

    //trigger OnNewRecord(BelowxRec: Boolean)
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF GUIALLOWED THEN
          IF "No." = '' THEN
            IF DocumentNoVisibility.CustomerNoSeriesIsDefault THEN
              NewMode := TRUE;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..4
        CASE NomineeDetails OF
            FORMAT(Type::Individual): BEGIN
              Type := Type::Individual
            END;
            FORMAT(Type::Institutional): BEGIN
              Type := Type::Institutional
            END;
            FORMAT(Type::Nominee): BEGIN
              Type := Type::Nominee;
            END;
        END;
        */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnOpenPage".

    //trigger (Variable: CompInfo)()
    //Parameters and return type have not been exported.
    //begin
        /*
        */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        ActivateFields;

        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
        #4..11
          CurrPage.AgedAccReceivableChart2.PAGE.SetPerCustomer;
        END;
        SETFILTER("Date Filter",CustomerMgt.GetCurrentYearFilter);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..14
        FILTERGROUP(3);
        NomineeDetails := GETFILTER(Type);
        FILTERGROUP(0);

        IF CompInfo.GET THEN
          IF CompInfo."Agni Hire Purchase Company" THEN
            showKSKL := TRUE;
        */
    //end;


    //Unsupported feature: Code Insertion on "OnQueryClosePage".

    //trigger OnQueryClosePage(CloseAction: Action): Boolean
    //begin
        /*
        IF NOT Saved THEN //MIN 4/12/2019
          ERROR(SaveCustomerPageConf);
        */
    //end;


    //Unsupported feature: Code Modification on "ActivateFields(PROCEDURE 3)".

    //procedure ActivateFields();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SetSocialListeningFactboxVisibility;
        ContactEditable := "Primary Contact No." = '';
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        SetSocialListeningFactboxVisibility;
        NoFieldVisible := DocumentNoVisibility.CustomerNoIsVisible;
        ContactEditable := "Primary Contact No." = '';
        */
    //end;

    //Unsupported feature: Property Deletion (CaptionML) on "Control122".


    //Unsupported feature: Property Deletion (ToolTipML) on "Control122".


    //Unsupported feature: Property Deletion (ApplicationArea) on "Control122".


    //Unsupported feature: Property Deletion (ToolTipML) on "Control12".


    //Unsupported feature: Property Deletion (ApplicationArea) on "Control12".

}


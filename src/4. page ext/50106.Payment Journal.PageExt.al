pageextension 50106 pageextension50106 extends "Payment Journal"
{
    // 24.04.2014 Elva Baltic P8 #S039 MMG7.00
    //   * Added fields:
    //     "Vehicle Serial No."
    //     "Vehicle Accounting Cycle No."
    //     VIN
    //     "Make Code"
    //     "Source Type"
    //     "Source No."
    Editable = PostFunctionVisible;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = true;
    Editable = true;
    Editable = true;
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 11".


        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".


        //Unsupported feature: Property Modification (SourceExpr) on "Balance(Control 25)".


        //Unsupported feature: Property Modification (SourceExpr) on "TotalBalance(Control 27)".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 7".



        //Unsupported feature: Code Modification on "Control 10.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
        ShowShortcutDimCode(ShortcutDimCode);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
        ShowShortcutDimCode(ShortcutDimCode);
         // CNY.RK >>
        IF "Account Type" = "Account Type" :: "Bank Account" THEN BEGIN
          ChequeEnt_G.RESET;
          ChequeEnt_G.SETCURRENTKEY("Cheque No.");
          ChequeEnt_G.SETRANGE("Bank No.","Account No.");
          ChequeEnt_G.SETRANGE(Posted,FALSE);
          ChequeEnt_G.SETRANGE(Void,FALSE);
          ChequeEnt_G.SETRANGE(Assigned,FALSE);
          IF ChequeEnt_G.FINDFIRST THEN
            "Cheque No." := ChequeEnt_G."Cheque No.";
        END;
        // CNY.RK <<
        NotAllowTDSAccountinJournal;  //TDS1.00
        */
        //end;


        //Unsupported feature: Code Modification on "Control 16.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
        ShowShortcutDimCode(ShortcutDimCode);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
        ShowShortcutDimCode(ShortcutDimCode);
        NotAllowTDSAccountinJournal; //TDS2.00
        */
        //end;
        addafter("Control 6")
        {
            field("Document Class"; "Document Class")
            {
            }
            field("Document Subclass"; "Document Subclass")
            {

                trigger OnValidate()
                begin
                    IF "Document Class" = "Document Class"::Employee THEN BEGIN
                        ShortcutDimCode[3] := "Document Subclass";
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    END;
                end;
            }
            field("Sales Invoice No."; "Sales Invoice No.")
            {
            }
        }
        addafter("Control 9")
        {
            field(Status; Status)
            {
                Editable = true;
            }
        }
        addafter("Control 10")
        {
            field("Account Name"; "Account Name")
            {
            }
        }
        addafter("Control 13")
        {
            field("Message to Recipient"; Rec."Message to Recipient")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the message exported to the payment file when you use the Export Payments to File function in the Payment Journal window.';
            }
        }
        addafter("Control 87")
        {
            field("Posting Group"; Rec."Posting Group")
            {
            }
        }
        addafter("Control 1001")
        {
            field("Cheque No."; "Cheque No.")
            {

                trigger OnValidate()
                begin
                    // CNY.RK >>
                    IF Rec."Account Type" = Rec."Account Type"::"Bank Account" THEN BEGIN
                        ChequeEnt_G.RESET;
                        ChequeEnt_G.SETCURRENTKEY("Bank No.", Posted, Void);
                        ChequeEnt_G.SETRANGE("Bank No.", Rec."Account No.");
                        ChequeEnt_G.SETRANGE(Posted, FALSE);
                        ChequeEnt_G.SETRANGE(Void, FALSE);
                        ChequeEnt_G.SETRANGE(Assigned, FALSE);
                        IF PAGE.RUNMODAL(33019980, ChequeEnt_G) = ACTION::LookupOK THEN
                            "Cheque No." := ChequeEnt_G."Cheque No.";
                    END;
                    // CNY.RK <<
                end;
            }
        }
        addafter("Control 300")
        {
            field("Employee Name"; GetEmployeeName)
            {
                Editable = false;
                Enabled = true;
            }
        }
        addafter("Control 69")
        {
            field(VIN; VIN)
            {
                Visible = false;
            }
            field(Narration; Narration)
            {
            }
            field("VF Loan File No."; "VF Loan File No.")
            {
            }
            field("VF Posting Type"; "VF Posting Type")
            {
            }
            field("VF Installment No."; "VF Installment No.")
            {
            }
            field("Sys. LC No."; "Sys. LC No.")
            {
            }
            field("Sales Order No."; "Sales Order No.")
            {
            }
            field("TDS Group"; "TDS Group")
            {
            }
            field("TDS%"; "TDS%")
            {
            }
            field("TDS Type"; "TDS Type")
            {
            }
            field("TDS Amount"; "TDS Amount")
            {
            }
            field("TDS Base Amount"; "TDS Base Amount")
            {
            }
        }
        addafter("Control 11")
        {
            field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
            {
                Visible = false;
            }
        }
        addafter("Control 17")
        {
            field("CIPS Category Purpose"; "CIPS Category Purpose")
            {
                Visible = NPIVisible;
            }
            field("Registration No."; "Registration No.")
            {
            }
            field("Registration Year"; "Registration Year")
            {
            }
            field("Registration Serial"; "Registration Serial")
            {
            }
            field("Payment Types"; "Payment Types")
            {
            }
            field("Bank Account Code"; "Bank Account Code")
            {
                Visible = NPIVisible;
            }
            field("Cost Type"; "Cost Type")
            {
            }
            field("Ref Id"; "Ref Id")
            {
                ToolTip = 'Used for CIT and IRD';
            }
            field("Office Code"; "Office Code")
            {
            }
        }
        moveafter("Control 13"; "Control 12")
        moveafter("Control 87"; "Control 1000")
        moveafter("Control 1001"; "Control 100")
        moveafter("Control 14"; "Control 97")
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "PreviewCheck(Action 63)".

        modify(Post)
        {
            Visible = PostFunctionVisible;
        }


        //Unsupported feature: Code Modification on "SendApprovalRequestJournalLine(Action 74).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        GetCurrentlySelectedLines(GenJournalLine);
        ApprovalsMgmt.TrySendJournalLineApprovalRequests(GenJournalLine);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        CompanyInformation.GET; //NCHL-NPI_1.00
        IF CompanyInformation."Enable NCHL-NPI Integration" THEN BEGIN
          NCHLNPIIntegrationMgt.SendJournalApprovalRequest("Journal Template Name","Journal Batch Name","Document No.");
        END ELSE BEGIN
          GetCurrentlySelectedLines(GenJournalLine);
          ApprovalsMgmt.TrySendJournalLineApprovalRequests(GenJournalLine);
        END;
        */
        //end;


        //Unsupported feature: Code Modification on "CancelApprovalRequestJournalLine(Action 96).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        GetCurrentlySelectedLines(GenJournalLine);
        ApprovalsMgmt.TryCancelJournalLineApprovalRequests(GenJournalLine);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        CompanyInformation.GET; //NCHL-NPI_1.00
        IF CompanyInformation."Enable NCHL-NPI Integration" THEN BEGIN
          NCHLNPIIntegrationMgt.CancelJournalApprovalRequest("Journal Template Name","Journal Batch Name","Document No.");
        END ELSE BEGIN
          GetCurrentlySelectedLines(GenJournalLine);
          ApprovalsMgmt.TryCancelJournalLineApprovalRequests(GenJournalLine);
        END;
        */
        //end;


        //Unsupported feature: Code Modification on "Approve(Action 70).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ApprovalsMgmt.ApproveGenJournalLineRequest(Rec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        CompanyInformation.GET;
        IF CompanyInformation."Enable NCHL-NPI Integration" THEN BEGIN //NCHL-NPI_1.00
          NCHLNPIIntegrationMgt.ApproveJournalApprovalRequest("Journal Template Name","Journal Batch Name","Document No.");
        END ELSE BEGIN
          ApprovalsMgmt.ApproveGenJournalLineRequest(Rec);
        END;
        */
        //end;


        //Unsupported feature: Code Modification on "Reject(Action 62).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ApprovalsMgmt.RejectGenJournalLineRequest(Rec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        CompanyInformation.GET;
        IF CompanyInformation."Enable NCHL-NPI Integration" THEN BEGIN //NCHL-NPI_1.00
          NCHLNPIIntegrationMgt.RejectJournalApprovalRequest("Journal Template Name","Journal Batch Name","Document No.");
        END ELSE BEGIN
          ApprovalsMgmt.RejectGenJournalLineRequest(Rec);
        END;
        */
        //end;
        addfirst("Action 43")
        {
            action(Print_PV)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    LocalGenJrnlLine: Record "81";
                begin
                    //Printing payment voucher.
                    LocalGenJrnlLine.RESET;
                    LocalGenJrnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    LocalGenJrnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    LocalGenJrnlLine.SETRANGE("Document No.", Rec."Document No.");
                    LocalGenJrnlLine.SETRANGE("Posting Date", Rec."Posting Date");
                    REPORT.RUN(50002, TRUE, TRUE, LocalGenJrnlLine);
                end;
            }
            separator()
            {
            }
        }
        addafter("Action 72")
        {
            group("Connect IPS")
            {
                Caption = 'Connect IPS';
                action("Get Details (Department Of Custom)")
                {
                    Caption = 'Get Details (Department Of Custom)';
                    Image = GetLines;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        NCHLNPIIntegrationMgt.GetDetailsFromDepartmentofCustom(Rec."Journal Template Name", Rec."Journal Batch Name", Rec."Document No.");
                    end;
                }
            }
        }
    }

    var
        "filter": Text;
        SysMgt: Codeunit "50014";

    var
        BankAccNo: Text[30];
        EmployeeName: Text[50];
        DimName: Record "349";
        ChequeEnt_G: Record "33019971";
        UserSetup: Record "91";
        PostFunctionVisible: Boolean;
        TDSBalance: Decimal;
        TotalTDSBalance: Decimal;
        ShowTDSBalance: Boolean;
        ShowTotalTDSBalance: Boolean;
        TDSBalanceVisible: Boolean;
        TotalTDSBalanceVisible: Boolean;
        "--NCHL-NPI_1.00": Integer;
        CompanyInformation: Record "79";
        NCHLNPIIntegrationMgt: Codeunit "33019810";
        NPIVisible: Boolean;


    //Unsupported feature: Code Modification on "OnAfterGetCurrRecord".

    //trigger OnAfterGetCurrRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetControlAppearance;
    StyleTxt := GetOverdueDateInteractions(OverdueWarningText);
    GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
    #4..9

    EventFilter := WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode;
    EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::"Gen. Journal Line",EventFilter);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..12
    GetEmployeeName; //SRT March 13 2019
    */
    //end;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    StyleTxt := GetOverdueDateInteractions(OverdueWarningText);
    ShowShortcutDimCode(ShortcutDimCode);
    HasPmtFileErr := HasPaymentFileErrors;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
    GetEmployeeName; //SRT March 13 2019
    SetVisibleProperty; //NCHL_NPI Nov 1st 2020
    */
    //end;


    //Unsupported feature: Code Modification on "OnInit".

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    TotalBalanceVisible := TRUE;
    BalanceVisible := TRUE;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    TotalBalanceVisible := TRUE;
    BalanceVisible := TRUE;
    TotalTDSBalanceVisible := TRUE; //TDS2.00
    TDSBalanceVisible := TRUE; //TDS2.00
    */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnOpenPage".

    //trigger (Variable: filter)()
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
    BalAccName := '';

    IF IsOpenedFromBatch THEN BEGIN
    #4..10
      ERROR('');
    GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
    SetControlAppearance;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..13
    //**SM 07-08-2013 to make post and post&print function visible for authorised users only
    UserSetup.GET(USERID);
    UserSetup.SETRANGE("User ID",USERID);
    IF UserSetup.FINDFIRST THEN BEGIN
      IF UserSetup."Payment and General Jnl Post" THEN
          PostFunctionVisible := TRUE;
    END;
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateBalance(PROCEDURE 1)".

    //procedure UpdateBalance();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GenJnlManagement.CalcBalance(
      Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
    BalanceVisible := ShowBalance;
    TotalBalanceVisible := ShowTotalBalance;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    GenJnlManagement.CalcBalance(
      Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
    GenJnlManagement.CalcTDSBalance(Rec,xRec,TDSBalance,TotalTDSBalance,ShowTDSBalance,ShowTotalTDSBalance); //TDS2.00
    BalanceVisible := ShowBalance;
    TotalBalanceVisible := ShowTotalBalance;
    TDSBalanceVisible := ShowTDSBalance;  //TDS2.00
    TotalTDSBalanceVisible := ShowTotalTDSBalance; //TDS2.00
    */
    //end;

    local procedure "--SRT--"()
    begin
    end;

    local procedure GetEmployeeName(): Text[50]
    var
        EmployeeName: Text[50];
        DimName: Record "349";
        GLSetup: Record "98";
    begin
        //AGNI2017CU8 >>
        GLSetup.GET;
        DimName.RESET;
        DimName.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        DimName.SETRANGE(Code, ShortcutDimCode[3]);
        IF DimName.FINDFIRST THEN
            EXIT(DimName.Name)
        ELSE
            EXIT('');
        //AGNI2017CU8 <<
    end;

    local procedure SetVisibleProperty()
    begin
        CompanyInformation.GET;
        NPIVisible := CompanyInformation."Enable NCHL-NPI Integration";
    end;

    //Unsupported feature: Property Deletion (ToolTipML) on "Control11".


    //Unsupported feature: Property Deletion (ApplicationArea) on "Control11".

}


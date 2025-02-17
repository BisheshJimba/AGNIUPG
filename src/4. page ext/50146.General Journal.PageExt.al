pageextension 50146 pageextension50146 extends "General Journal"
{
    // 24.04.2014 Elva Baltic P8 #S039 MMG7.00
    //   * Added fields:
    //     Source Type
    //     Source No.
    //     VIN
    // 
    // 03.04.2014 Elva Baltic P8 S00
    //   * Added fields:
    //     "Vehicle Serial No."
    //     "Vehicle Accounting Cycle No."
    //     VIN
    //     "Make Code"
    //     "Source Type"
    //     "Source No."
    Editable = false;
    Editable = false;

    //Unsupported feature: Property Insertion (Name) on ""General Journal"(Page 39)".

    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    Editable = false;
    PromotedActionCategories = 'New,Process,Report,Voucher';
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 15".


        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".


        //Unsupported feature: Property Modification (SourceExpr) on "Balance(Control 31)".


        //Unsupported feature: Property Modification (SourceExpr) on "TotalBalance(Control 33)".



        //Unsupported feature: Code Modification on "Control 10.OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
        ShowShortcutDimCode(ShortcutDimCode);
        SetUserInteractions;
        CurrPage.UPDATE;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
        ShowShortcutDimCode(ShortcutDimCode);
        NotAllowTDSAccountinJournal; //TDS2.00
        SetUserInteractions;
        CurrPage.UPDATE;
        */
        //end;

        //Unsupported feature: Property Deletion (ToolTipML) on "Control 15".


        //Unsupported feature: Property Deletion (StyleExpr) on "Control 15".

        modify("Control 1000")
        {
            Visible = false;
        }
        modify("Control 1001")
        {
            Visible = false;
        }


        //Unsupported feature: Code Modification on "Control 55.OnValidate".

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

        //Unsupported feature: Property Deletion (Visible) on "Control 300".

        addafter("Control 10")
        {
            field("Line No."; Rec."Line No.")
            {
                Editable = false;
                Visible = false;
            }
            field("Account Name"; "Account Name")
            {
            }
            field("Debit Amount"; Rec."Debit Amount")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the total amount (including VAT) that the journal line consists of, if it is a debit amount.';
                Visible = false;
            }
            field("Credit Amount"; Rec."Credit Amount")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the total amount (including VAT) that the journal line consists of, if it is a credit amount.';
                Visible = false;
            }
            field("Document Class"; "Document Class")
            {
            }
            field("Document Subclass"; "Document Subclass")
            {
            }
            field("Posting Group"; Rec."Posting Group")
            {
            }
        }
        addafter("Control 12")
        {
            field(Narration; Narration)
            {
            }
        }
        addafter("Control 17")
        {
            field("Transaction Information"; Rec."Transaction Information")
            {
                StyleExpr = StyleTxt;
                ToolTip = 'Specifies transaction information that is imported with the bank statement file.';
                Visible = false;
            }
        }
        addafter("Control 85")
        {
            field("Posting Group "; Rec."Posting Group")
            {
                Visible = false;
            }
        }
        addafter("Control 40")
        {
            field(Correction; Rec.Correction)
            {
                Editable = true;
                Visible = false;
            }
        }
        addafter("Control 18")
        {
            field("Sys. LC No."; "Sys. LC No.")
            {
            }
        }
        addafter("Control 300")
        {
            field("Employee Name"; GetEmployeeName)
            {
            }
        }
        addafter("Control 73")
        {
            field("VIN - COGS"; "VIN - COGS")
            {
            }
            field("Sales Invoice No."; "Sales Invoice No.")
            {
                Visible = false;
            }
            field("Source Type"; Rec."Source Type")
            {
            }
            field("Source No."; Rec."Source No.")
            {
            }
            field(VIN; VIN)
            {
                Visible = false;
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
            field("Sys. LC No. "; "Sys. LC No.")
            {
                Visible = false;
            }
            field("Commercial Invoice No"; "Commercial Invoice No")
            {
                Visible = false;
            }
            field("Loan Posting Type"; "Loan Posting Type")
            {
                Visible = false;
            }
        }
        addafter("Control 7")
        {
            field("Vehicle Serial No."; "Vehicle Serial No.")
            {
                Visible = false;
            }
            field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
            {
                Visible = false;
            }
        }
        addafter("Control 38")
        {
            field("Credit Type"; "Credit Type")
            {
            }
            field("VF Posting Type"; "VF Posting Type")
            {
            }
            field("Receipt Type"; "Receipt Type")
            {
            }
            field("Loan File No."; "Loan File No.")
            {
            }
            field("Cost Type"; "Cost Type")
            {
            }
        }
        moveafter("Control 17"; "Control 71")
    }
    actions
    {
        modify(Post)
        {
            Visible = PostFunctionVisible;
        }
        modify(PostAndPrint)
        {
            Visible = PostFunctionVisible;
        }

        //Unsupported feature: Property Modification (RunPageLink) on "ShowStatementLineDetails(Action 21)".



        //Unsupported feature: Code Modification on "Post(Action 50).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",Rec);
        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
        CurrPage.UPDATE(FALSE);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        //**SM 07-08-2013 to make post and post&print function visible for authorised users only
        UserSetup.GET(USERID);
        UserSetup.SETRANGE("User ID",USERID);
        IF UserSetup.FINDFIRST THEN BEGIN
           IF NOT UserSetup."Payment and General Jnl Post" THEN
              ERROR('You do not have permission to post the journal lines. Please contact system administrator!!!');
        END;

        #1..3
        */
        //end;


        //Unsupported feature: Code Modification on "SendApprovalRequestJournalLine(Action 84).OnAction".

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
        CompanyInformation.GET; //CIPS1.00
        IF CompanyInformation."Enable NCHL-NPI Integration" THEN BEGIN
          NCHLNPIIntegrationMgt.SendJournalApprovalRequest("Journal Template Name","Journal Batch Name","Document No.");
        END ELSE BEGIN
        GetCurrentlySelectedLines(GenJournalLine);
        ApprovalsMgmt.TrySendJournalLineApprovalRequests(GenJournalLine);
        END
        */
        //end;


        //Unsupported feature: Code Modification on "CancelApprovalRequestJournalLine(Action 88).OnAction".

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
        CompanyInformation.GET; //CIPS1.00
        IF CompanyInformation."Enable NCHL-NPI Integration" THEN BEGIN
          NCHLNPIIntegrationMgt.CancelJournalApprovalRequest("Journal Template Name","Journal Batch Name","Document No.");
        END ELSE BEGIN
          GetCurrentlySelectedLines(GenJournalLine);
          ApprovalsMgmt.TryCancelJournalLineApprovalRequests(GenJournalLine);
        END;
        */
        //end;


        //Unsupported feature: Code Modification on "Approve(Action 74).OnAction".

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
        IF CompanyInformation."Enable NCHL-NPI Integration" THEN BEGIN //CIPS1.00
          NCHLNPIIntegrationMgt.ApproveJournalApprovalRequest("Journal Template Name","Journal Batch Name","Document No.");
        END ELSE
          ApprovalsMgmt.ApproveGenJournalLineRequest(Rec);
        */
        //end;


        //Unsupported feature: Code Modification on "Reject(Action 72).OnAction".

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
        IF CompanyInformation."Enable NCHL-NPI Integration" THEN BEGIN //CIPS1.00
          NCHLNPIIntegrationMgt.RejectJournalApprovalRequest("Journal Template Name","Journal Batch Name","Document No.");
        END ELSE
          ApprovalsMgmt.RejectGenJournalLineRequest(Rec);
        */
        //end;
        addafter(SaveAsStandardJournal)
        {
            action(Print_JV)
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
                    //Printing journal voucher.
                    LocalGenJrnlLine.RESET;
                    LocalGenJrnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    LocalGenJrnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    LocalGenJrnlLine.SETRANGE("Document No.", Rec."Document No.");
                    LocalGenJrnlLine.SETRANGE("Posting Date", Rec."Posting Date");
                    REPORT.RUN(50000, TRUE, TRUE, LocalGenJrnlLine);
                end;
            }
            separator()
            {
            }
        }
    }

    var
        UserSetup: Record "91";
        [InDataSet]
        PostFunctionVisible: Boolean;
        EmployeeCode: Code[20];
        TDSBalance: Decimal;
        TotalTDSBalance: Decimal;
        ShowTDSBalance: Boolean;
        ShowTotalTDSBalance: Boolean;
        [InDataSet]
        TDSBalanceVisible: Boolean;
        [InDataSet]
        TotalTDSBalanceVisible: Boolean;
        "--NCHL-NPI_1.00": Integer;
        CompanyInformation: Record "79";
        NCHLNPIIntegrationMgt: Codeunit "33019810";


    //Unsupported feature: Code Modification on "OnAfterGetCurrRecord".

    //trigger OnAfterGetCurrRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
    UpdateBalance;
    SetControlAppearance;
    CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4
    GetEmployeeName; //SRT March 13 2019
    */
    //end;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ShowShortcutDimCode(ShortcutDimCode);
    HasIncomingDocument := "Incoming Document Entry No." <> 0;
    SetUserInteractions;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
    GetEmployeeName; //SRT March 13 2019
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


    //Unsupported feature: Code Modification on "OnNewRecord".

    //trigger OnNewRecord(BelowxRec: Boolean)
    //>>>> ORIGINAL CODE:
    //begin
    /*
    UpdateBalance;
    SetUpNewLine(xRec,Balance,BelowxRec);
    CLEAR(ShortcutDimCode);
    CLEAR(AccName);
    SetUserInteractions;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    UpdateBalance;
    //SetUpNewLine(xRec,Balance,BelowxRec);
    SetUpNewLine(xRec,(Balance-TDSBalance),BelowxRec); //TDS2.00
    #3..5
    */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    BalAccName := '';
    IF IsOpenedFromBatch THEN BEGIN
      CurrentJnlBatchName := "Journal Batch Name";
    #4..9
      ERROR('');
    GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
    SetControlAppearance;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..12

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
    GenJnlManagement.CalcBalance(Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
    BalanceVisible := ShowBalance;
    TotalBalanceVisible := ShowTotalBalance;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    GenJnlManagement.CalcBalance(Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
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

    //Unsupported feature: Property Deletion (Editable) on "Control61".


    //Unsupported feature: Property Deletion (Editable) on "Control63".

}


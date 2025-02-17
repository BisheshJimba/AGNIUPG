pageextension 50105 pageextension50105 extends "Cash Receipt Journal"
{
    // 24.04.2014 Elva Baltic P8 #S039 MMG7.00
    //   * Added fields:
    //     "Vehicle Serial No."
    //     "Vehicle Accounting Cycle No."
    //     VIN
    // 
    // 07.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added fields "Source Type", "Source No."

    //Unsupported feature: Property Modification (Visible) on ""Cash Receipt Journal"(Page 255)".


    //Unsupported feature: Property Modification (Visible) on ""Cash Receipt Journal"(Page 255)".


    //Unsupported feature: Property Modification (Visible) on ""Cash Receipt Journal"(Page 255)".


    //Unsupported feature: Property Modification (Visible) on ""Cash Receipt Journal"(Page 255)".


    //Unsupported feature: Property Modification (Visible) on ""Cash Receipt Journal"(Page 255)".


    //Unsupported feature: Property Modification (TableRelation) on ""Cash Receipt Journal"(Page 255)".

    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".


        //Unsupported feature: Property Modification (SourceExpr) on "Balance(Control 25)".


        //Unsupported feature: Property Modification (SourceExpr) on "TotalBalance(Control 27)".



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
        NotAllowTDSAccountinJournal; //TDS2.00

        //prabesh 10-18-23
        CLEAR(Rec."Ship-to Address");
        IF Rec."Account Type" = Rec."Account Type"::Customer THEN BEGIN
          ShipToAddress.RESET;
          IF cuLookUpMgt.LookUpShipToAddress(ShipToAddress, Rec."Account No.") THEN
            VALIDATE(Rec."Ship-to Address", ShipToAddress.Address);
        END;
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
        addafter("Control 10")
        {
            field("Account Name"; "Account Name")
            {
            }
            field("Document Class"; "Document Class")
            {
            }
            field("Document Subclass"; "Document Subclass")
            {
            }
        }
        addafter("Control 77")
        {
            field("Posting Group"; Rec."Posting Group")
            {
                Visible = false;
            }
        }
        addafter("Control 1001")
        {
            field("Cheque No."; "Cheque No.")
            {
            }
        }
        addafter("Control 89")
        {
            field("Credit Type"; "Credit Type")
            {
            }
            field("Sys. LC No."; "Sys. LC No.")
            {
            }
        }
        addafter("Control 16")
        {
            field("Sales Invoice No."; "Sales Invoice No.")
            {
            }
        }
        addafter("Control 300")
        {
            field("Employee Name"; GetEmployeeName)
            {
                Visible = false;
            }
        }
        addafter("Control 57")
        {
            field("Sales Order No."; "Sales Order No.")
            {
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
        addafter("Control 5")
        {
            field("Source No."; Rec."Source No.")
            {
            }
            field("Vehicle Serial No."; "Vehicle Serial No.")
            {
                Visible = false;
            }
            field("Vehicle Accounting Cycle No."; "Vehicle Accounting Cycle No.")
            {
                Visible = false;
            }
            field(VIN; VIN)
            {
                Visible = false;
            }
        }
        addafter("Control 11")
        {
            field("Receipt Against"; "Receipt Against")
            {
                Visible = false;
            }
            field("Ship-to Address"; "Ship-to Address")
            {
                Enabled = IsEditable;
            }
        }
    }
    actions
    {
        addafter("Action 45")
        {
            action(Print_RV)
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
                    //Printing Receipt voucher.
                    LocalGenJrnlLine.RESET;
                    LocalGenJrnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    LocalGenJrnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    LocalGenJrnlLine.SETRANGE("Document No.", Rec."Document No.");
                    LocalGenJrnlLine.SETRANGE("Posting Date", Rec."Posting Date");
                    REPORT.RUN(50001, TRUE, TRUE, LocalGenJrnlLine);
                    //REPORT.RUN(2000001,TRUE,TRUE,LocalGenJrnlLine);
                end;
            }
            separator()
            {
            }
        }
    }

    var
        UserSetup: Record "91";
        PostFunctionVisible: Boolean;
        TDSBalance: Decimal;
        TotalTDSBalance: Decimal;
        ShowTDSBalance: Boolean;
        ShowTotalTDSBalance: Boolean;
        TDSBalanceVisible: Boolean;
        TotalTDSBalanceVisible: Boolean;
        IsEditable: Boolean;
        ShipToAddress: Record "222";
        cuLookUpMgt: Codeunit "25006003";


    //Unsupported feature: Code Modification on "OnAfterGetCurrRecord".

    //trigger OnAfterGetCurrRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetControlAppearance;
    GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
    UpdateBalance;
    CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

    IF GenJournalBatch.GET("Journal Template Name","Journal Batch Name") THEN
      ShowWorkflowStatusOnBatch := CurrPage.WorkflowStatusBatch.PAGE.SetFilterOnWorkflowRecord(GenJournalBatch.RECORDID);
    ShowWorkflowStatusOnLine := CurrPage.WorkflowStatusLine.PAGE.SetFilterOnWorkflowRecord(RECORDID);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..8
    GetEmployeeName; //SRT March 13 2019
    */
    //end;


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ShowShortcutDimCode(ShortcutDimCode);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ShowShortcutDimCode(ShortcutDimCode);
    GetEmployeeName; //SRT March 13 2019
    //prabesh 10-17-23
    IF Rec."Account Type" = Rec."Account Type"::Customer THEN
      IsEditable := TRUE
    ELSE
      IsEditable := FALSE;
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
    {
    //**SM 07-08-2013 to make post and post&print function visible for authorised users only
    UserSetup.GET(USERID);
    UserSetup.SETRANGE("User ID",USERID);
    IF UserSetup.FINDFIRST THEN BEGIN
      IF UserSetup."Journal Post" THEN
          PostFunctionVisible := TRUE;
    END;
    }
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
}


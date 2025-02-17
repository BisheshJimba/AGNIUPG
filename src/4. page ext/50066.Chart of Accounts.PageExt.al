pageextension 50066 pageextension50066 extends "Chart of Accounts"
{

    //Unsupported feature: Property Insertion (ApplicationArea) on ""Chart of Accounts"(Page 16)".

    Editable = true;
    Editable = IsVisible;

    //Unsupported feature: Property Modification (ApplicationArea) on ""Chart of Accounts"(Page 16)".

    Editable = true;
    Editable = IsVisible;
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on "Control 3".


        //Unsupported feature: Property Modification (SourceExpr) on "Control 7".


        //Unsupported feature: Property Modification (SubPageLink) on "Control 1905532107".

        modify("Control 9")
        {
            Visible = false;
        }
        modify("Control 11")
        {
            Visible = false;
        }
        modify("Control 8")
        {
            Visible = false;
        }
        modify("Control 26")
        {
            Visible = false;
        }
        modify("Control 10")
        {
            Visible = false;
        }
        modify("Control 12")
        {
            Visible = false;
        }
        modify("Control 37")
        {
            Visible = false;
        }
        modify("Control 14")
        {
            Visible = false;
        }
        modify("Control 32")
        {
            Visible = false;
        }
        modify("Control 44")
        {
            Visible = false;
        }
        modify("Control 16")
        {
            Visible = false;
        }
        modify("Control 59")
        {
            Visible = false;
        }
        modify("Control 18")
        {
            Visible = false;
        }
        modify("Control 46")
        {
            Visible = false;
        }
        modify("Control 48")
        {
            Visible = false;
        }
        modify("Control 50")
        {
            Visible = false;
        }
        modify("Control 39")
        {
            Visible = false;
        }
        modify("Control 41")
        {
            Visible = false;
        }
        modify("Control 61")
        {
            Visible = false;
        }
        modify("Control 57")
        {
            Visible = false;
        }
        addafter("Control 6")
        {
            field("Account Category"; Rec."Account Category")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the category of the G/L account.';
                Visible = false;
            }
            field("Account Subcategory Descript."; Rec."Account Subcategory Descript.")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Account Subcategory';
                ToolTip = 'Specifies the subcategory of the account category of the G/L account.';
            }
            field("Account Type"; Rec."Account Type")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the purpose of the account. Newly created accounts are automatically assigned the Posting account type, but you can change this.';
            }
            field("Direct Posting"; Rec."Direct Posting")
            {
                ToolTip = 'Specifies whether you will be able to post directly or only indirectly to this general ledger account.';
                Visible = false;
            }
            field("Vehicle ID Mandatory"; Rec."Vehicle ID Mandatory")
            {
            }
            field("Document Class Mandatory"; Rec."Document Class Mandatory")
            {
            }
            field("LC No Mandatory"; Rec."LC No Mandatory")
            {
                Visible = false;
            }
            field("Commercial Invoice Mandatory"; Rec."Commercial Invoice Mandatory")
            {
            }
            field(Totaling; Rec.Totaling)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies an account interval or a list of account numbers.';

                trigger OnLookup(var Text: Text): Boolean
                var
                    GLaccList: Page "18";
                begin
                    GLaccList.LOOKUPMODE(TRUE);
                    IF NOT (GLaccList.RUNMODAL = ACTION::LookupOK) THEN
                        EXIT(FALSE);

                    Text := GLaccList.GetSelectionFilter;
                    EXIT(TRUE);
                end;
            }
            field("Gen. Posting Type"; Rec."Gen. Posting Type")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the general posting type to use when posting to this account.';
            }
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the general business posting group that applies to the entry.';
            }
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies a general product posting group code.';
            }
            field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
            {
                ToolTip = 'Specifies a VAT Bus. Posting Group.';
                Visible = false;
            }
            field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
            {
                ToolTip = 'Specifies a VAT Prod. Posting Group code.';
                Visible = false;
            }
            field("Net Change"; Rec."Net Change")
            {
                ApplicationArea = Basic, Suite;
                BlankZero = true;
                ToolTip = 'Specifies the net change in the account balance during the time period in the Date Filter field.';
                Visible = IsVisible;
            }
        }
        addafter("Control 7")
        {
            field("Additional-Currency Net Change"; Rec."Additional-Currency Net Change")
            {
                BlankZero = true;
                ToolTip = 'Specifies the net change in the account balance.';
                Visible = IsVisible;
            }
            field("Add.-Currency Balance at Date"; Rec."Add.-Currency Balance at Date")
            {
                BlankZero = true;
                ToolTip = 'Specifies the G/L account balance (in the additional reporting currency) on the last date included in the Date Filter field.';
                Visible = IsVisible;
            }
            field("Additional-Currency Balance"; Rec."Additional-Currency Balance")
            {
                BlankZero = true;
                ToolTip = 'Specifies the balance on this account, in the additional reporting currency.';
                Visible = IsVisible;
            }
            field("Consol. Debit Acc."; Rec."Consol. Debit Acc.")
            {
                ToolTip = 'Specifies the account number in a consolidated company to transfer credit balances.';
                Visible = false;
            }
            field("Consol. Credit Acc."; Rec."Consol. Credit Acc.")
            {
                ToolTip = 'Specifies if amounts without any payment tolerance amount from the customer and vendor ledger entries are used.';
                Visible = false;
            }
            field("Cost Type No."; Rec."Cost Type No.")
            {
                ToolTip = 'Specifies a cost type number to establish which cost type a general ledger account belongs to.';
            }
            field("Consol. Translation Method"; Rec."Consol. Translation Method")
            {
                ToolTip = 'Specifies the consolidation translation method that will be used for the account.';
                Visible = false;
            }
            field("Default IC Partner G/L Acc. No"; Rec."Default IC Partner G/L Acc. No")
            {
                ToolTip = 'Specifies accounts that you often enter in the Bal. Account No. field on intercompany journal or document lines.';
                Visible = false;
            }
            field("Default Deferral Template Code"; Rec."Default Deferral Template Code")
            {
                ApplicationArea = Suite;
                Caption = 'Default Deferral Template';
                ToolTip = 'Specifies the default deferral template that governs how to defer revenues and expenses to the periods when they occurred.';
            }
            field("Description VAT Book"; Rec."Description VAT Book")
            {
            }
            field("Budgeted Amount"; Rec."Budgeted Amount")
            {
            }
        }
    }
    actions
    {

        //Unsupported feature: Property Modification (RunPageLink) on "Action 25".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 84".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 23".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 36".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 132".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 53".


        //Unsupported feature: Property Modification (RunPageLink) on "Action 35".

    }

    var
        [InDataSet]
        BoldValue: Boolean;
        [InDataSet]
        ISVisible: Boolean;
        UserSetup: Record "91";


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    NoEmphasize := "Account Type" <> "Account Type"::Posting;
    NameIndent := Indentation;
    NameEmphasize := "Account Type" <> "Account Type"::Posting;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3


    NameIndent := 0;
    NoOnFormat;
    NameOnFormat;

    //To show bold lines if condition is true. Sangam on 25 August 2011.
    BoldLine("Account Type");

    //sandeep 21-nov-2021
    FILTERGROUP(10);
    UserSetup.GET(USERID);
    IF UserSetup."GL Account Department" =UserSetup."GL Account Department"::"Service and Spareparts" THEN
      SETRANGE("No.",'301001','307999');
    IF UserSetup."GL Account Department"=UserSetup."GL Account Department"::HR THEN
      SETRANGE("No.",'500500','599999');
    IF UserSetup."GL Account Department"= UserSetup."GL Account Department"::Marketing THEN
      SETRANGE("No.",'701000','701099');
    IF UserSetup."GL Account Department"=UserSetup."GL Account Department"::Admin THEN BEGIN
      SETFILTER("No.",'100501..100599|601000..603999|703000..703999');
      END;
    FILTERGROUP(0);
    */
    //end;


    //Unsupported feature: Code Insertion on "OnInit".

    //trigger OnInit()
    //Parameters and return type have not been exported.
    //begin
    /*

    UserSetup.GET(USERID);
    IF UserSetup."Can See Cost" THEN
      ISVisible :=TRUE
    ELSE
      ISVisible := FALSE;
    */
    //end;

    local procedure NoOnFormat()
    begin
        NoEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
    end;

    local procedure NameOnFormat()
    begin
        NameIndent := Rec.Indentation;
        NameEmphasize := Rec."Account Type" <> Rec."Account Type"::Posting;
    end;

    procedure BoldLine(AccountType: Option Posting,Heading,Total,"Begin-Total","End-Total")
    begin
        //To show bold lines if condition is true.
        IF (AccountType = AccountType::Heading) OR (AccountType = AccountType::Total) OR (AccountType = AccountType::"Begin-Total")
          OR (AccountType = AccountType::"End-Total") THEN
            BoldValue := TRUE
        ELSE
            BoldValue := FALSE;
    end;

    //Unsupported feature: Property Deletion (ToolTipML) on "Control3".


    //Unsupported feature: Property Deletion (CaptionML) on "Control7".


    //Unsupported feature: Property Deletion (ToolTipML) on "Control7".

}


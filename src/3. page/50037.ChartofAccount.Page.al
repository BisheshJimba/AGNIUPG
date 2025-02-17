page 50037 "Chart of Account"
{
    Caption = 'Chart of Accounts';
    CardPageID = "G/L Account Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Periodic Activities';
    RefreshOnActivate = true;
    SourceTable = Table15;

    layout
    {
        area(content)
        {
            repeater()
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("No."; "No.")
                {
                    ApplicationArea = Basic, Suite;
                    Style = Strong;
                    StyleExpr = NoEmphasize;
                    ToolTip = 'Specifies the No. of the G/L Account you are setting up.';
                }
                field(Name; Name)
                {
                    ApplicationArea = Basic, Suite;
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ToolTip = 'Specifies the name of the general ledger account.';
                }
                field("Income/Balance"; "Income/Balance")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether a general ledger account is an income statement account or a balance sheet account.';
                }
                field("Account Category"; "Account Category")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the category of the G/L account.';
                    Visible = false;
                }
                field("Account Subcategory Descript."; "Account Subcategory Descript.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Account Subcategory';
                    ToolTip = 'Specifies the subcategory of the account category of the G/L account.';
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the purpose of the account. Newly created accounts are automatically assigned the Posting account type, but you can change this.';
                }
                field("Direct Posting"; "Direct Posting")
                {
                    ToolTip = 'Specifies whether you will be able to post directly or only indirectly to this general ledger account.';
                    Visible = false;
                }
                field("Vehicle ID Mandatory"; "Vehicle ID Mandatory")
                {
                }
                field("Document Class Mandatory"; "Document Class Mandatory")
                {
                }
                field("LC No Mandatory"; "LC No Mandatory")
                {
                    Visible = false;
                }
                field("Commercial Invoice Mandatory"; "Commercial Invoice Mandatory")
                {
                }
                field(Totaling; Totaling)
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
                field("Gen. Posting Type"; "Gen. Posting Type")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the general posting type to use when posting to this account.';
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the general business posting group that applies to the entry.';
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a general product posting group code.';
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                    ToolTip = 'Specifies a VAT Bus. Posting Group.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    ToolTip = 'Specifies a VAT Prod. Posting Group code.';
                    Visible = false;
                }
                field("Net Change"; "Net Change")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the net change in the account balance during the time period in the Date Filter field.';
                    Visible = IsVisible;
                }
                field("Balance at Date"; "Balance at Date")
                {
                    BlankZero = true;
                    ToolTip = 'Specifies the G/L account balance on the last date included in the Date Filter field.';
                    Visible = IsVisible;
                }
                field(Balance; Balance)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the balance on this account.';
                    Visible = IsVisible;
                }
                field("Debit Amount"; "Debit Amount")
                {
                    Visible = false;
                }
                field("Credit Amount"; "Credit Amount")
                {
                    Visible = false;
                }
                field("Additional-Currency Net Change"; "Additional-Currency Net Change")
                {
                    BlankZero = true;
                    ToolTip = 'Specifies the net change in the account balance.';
                    Visible = IsVisible;
                }
                field("Add.-Currency Balance at Date"; "Add.-Currency Balance at Date")
                {
                    BlankZero = true;
                    ToolTip = 'Specifies the G/L account balance (in the additional reporting currency) on the last date included in the Date Filter field.';
                    Visible = IsVisible;
                }
                field("Additional-Currency Balance"; "Additional-Currency Balance")
                {
                    BlankZero = true;
                    ToolTip = 'Specifies the balance on this account, in the additional reporting currency.';
                    Visible = IsVisible;
                }
                field("Consol. Debit Acc."; "Consol. Debit Acc.")
                {
                    ToolTip = 'Specifies the account number in a consolidated company to transfer credit balances.';
                    Visible = false;
                }
                field("Consol. Credit Acc."; "Consol. Credit Acc.")
                {
                    ToolTip = 'Specifies if amounts without any payment tolerance amount from the customer and vendor ledger entries are used.';
                    Visible = false;
                }
                field("Cost Type No."; "Cost Type No.")
                {
                    ToolTip = 'Specifies a cost type number to establish which cost type a general ledger account belongs to.';
                }
                field("Consol. Translation Method"; "Consol. Translation Method")
                {
                    ToolTip = 'Specifies the consolidation translation method that will be used for the account.';
                    Visible = false;
                }
                field("Default IC Partner G/L Acc. No"; "Default IC Partner G/L Acc. No")
                {
                    ToolTip = 'Specifies accounts that you often enter in the Bal. Account No. field on intercompany journal or document lines.';
                    Visible = false;
                }
                field("Default Deferral Template Code"; "Default Deferral Template Code")
                {
                    ApplicationArea = Suite;
                    Caption = 'Default Deferral Template';
                    ToolTip = 'Specifies the default deferral template that governs how to defer revenues and expenses to the periods when they occurred.';
                }
            }
        }
        area(factboxes)
        {
            part(; 9083)
            {
                SubPageLink = Table ID=CONST(15),
                              No.=FIELD(No.);
                                      Visible = false;
            }
            systempart(; Links)
            {
                Visible = false;
            }
            systempart(; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("A&ccount")
            {
                Caption = 'A&ccount';
                Image = ChartOfAccounts;
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ledger E&ntries';
                    Image = GLRegisters;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 20;
                    RunPageLink = G/L Account No.=FIELD(No.);
                    RunPageView = SORTING(G/L Account No.);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 124;
                                    RunPageLink = Table Name=CONST(G/L Account),
                                  No.=FIELD(No.);
                    ToolTip = 'Show or add comments.';
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page 540;
                                        RunPageLink = Table ID=CONST(15),
                                      No.=FIELD(No.);
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData 348=R;
                        ApplicationArea = Suite;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            GLAcc: Record "15";
                            DefaultDimMultiple: Page "542";
                        begin
                            CurrPage.SETSELECTIONFILTER(GLAcc);
                            DefaultDimMultiple.SetMultiGLAcc(GLAcc);
                            DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
                action("E&xtended Texts")
                {
                    ApplicationArea = Suite;
                    Caption = 'E&xtended Texts';
                    Image = Text;
                    RunObject = Page 391;
                                    RunPageLink = Table Name=CONST(G/L Account),
                                  No.=FIELD(No.);
                    RunPageView = SORTING(Table Name,No.,Language Code,All Language Codes,Starting Date,Ending Date);
                    ToolTip = 'View additional information that has been added to the description for the current account.';
                }
                action("Receivables-Payables")
                {
                    ApplicationArea = Suite;
                    Caption = 'Receivables-Payables';
                    Image = ReceivablesPayables;
                    RunObject = Page 159;
                                    ToolTip = 'Show a summary of receivables and payables.';
                }
                action("Where-Used List")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Where-Used List';
                    Image = Track;
                    ToolTip = 'Show setup tables where the current account is used.';

                    trigger OnAction()
                    var
                        CalcGLAccWhereUsed: Codeunit "100";
                    begin
                        CalcGLAccWhereUsed.CheckGLAcc("No.");
                    end;
                }
            }
            group("&Balance")
            {
                Caption = '&Balance';
                Image = Balance;
                action("G/L &Account Balance")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'G/L &Account Balance';
                    Image = GLAccountBalance;
                    RunObject = Page 415;
                                    RunPageLink = No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Business Unit Filter=FIELD(Business Unit Filter);
                    ToolTip = 'View a summary of the debit and credit balances for different time periods for the current account.';
                }
                action("G/L &Balance")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'G/L &Balance';
                    Image = GLBalance;
                    RunObject = Page 414;
                                    RunPageLink = Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Business Unit Filter=FIELD(Business Unit Filter);
                    RunPageOnRec = true;
                    ToolTip = 'View a summary of the debit and credit balances for different time periods for all accounts.';
                }
                action("G/L Balance by &Dimension")
                {
                    ApplicationArea = Suite;
                    Caption = 'G/L Balance by &Dimension';
                    Image = GLBalanceDimension;
                    RunObject = Page 408;
                                    ToolTip = 'View a summary of the debit and credit balances by dimensions for all accounts.';
                }
                separator()
                {
                    Caption = '';
                }
                action("G/L Account Balance/Bud&get")
                {
                    ApplicationArea = Suite;
                    Caption = 'G/L Account Balance/Bud&get';
                    Image = Period;
                    RunObject = Page 154;
                                    RunPageLink = No.=FIELD(No.),
                                  Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Business Unit Filter=FIELD(Business Unit Filter),
                                  Budget Filter=FIELD(Budget Filter);
                    ToolTip = 'View a summary of the debit and credit balances and the budgeted amounts for different time periods for the current account.';
                }
                action("G/L Balance/B&udget")
                {
                    ApplicationArea = Suite;
                    Caption = 'G/L Balance/B&udget';
                    Image = ChartOfAccounts;
                    RunObject = Page 422;
                                    RunPageLink = Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter),
                                  Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter),
                                  Business Unit Filter=FIELD(Business Unit Filter),
                                  Budget Filter=FIELD(Budget Filter);
                    RunPageOnRec = true;
                    ToolTip = 'View a summary of the debit and credit balances and the budgeted amounts for different time periods for the current account.';
                }
                separator()
                {
                }
                action("Chart of Accounts &Overview")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Chart of Accounts &Overview';
                    Image = Accounts;
                    RunObject = Page 634;
                                    ToolTip = 'View the chart of accounts with different levels of detail where you can expand or collapse a section of the chart of accounts.';
                }
            }
            action("G/L Register")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'G/L Register';
                Image = GLRegisters;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page 116;
                                ToolTip = 'View posted G/L entries.';
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(IndentChartOfAccounts)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Indent Chart of Accounts';
                    Image = IndentChartOfAccounts;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Codeunit 3;
                    ToolTip = 'Indent accounts between a Begin-Total and the matching End-Total one level to make the chart of accounts easier to read.';
                }
            }
            group("Periodic Activities")
            {
                Caption = 'Periodic Activities';
                action("General Journal")
                {
                    Caption = 'General Journal';
                    Image = Journal;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page 39;
                                    ToolTip = 'Open the general journal, for example, to record or post a payment that has no related document.';
                }
                action("Close Income Statement")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Close Income Statement';
                    Image = CloseYear;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Report 94;
                                    ToolTip = 'Start the transfer of the year''s result to an account in the balance sheet and close the income statement accounts.';
                }
                action(DocsWithoutIC)
                {
                    Caption = 'Posted Documents without Incoming Document';
                    Image = Documents;
                    ToolTip = 'Show a list of posted purchase and sales documents under the G/L account that do not have related incoming document records.';

                    trigger OnAction()
                    var
                        PostedDocsWithNoIncBuf: Record "134";
                    begin
                        IF "Account Type" = "Account Type"::Posting THEN
                          PostedDocsWithNoIncBuf.SETRANGE("G/L Account No. Filter","No.")
                        ELSE
                          IF Totaling <> '' THEN
                            PostedDocsWithNoIncBuf.SETFILTER("G/L Account No. Filter",Totaling)
                          ELSE
                            EXIT;
                        PAGE.RUN(PAGE::"Posted Docs. With No Inc. Doc.",PostedDocsWithNoIncBuf);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Detail Trial Balance")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Detail Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report 4;
                                ToolTip = 'View a detail trial balance for the general ledger accounts that you specify.';
            }
            action("Trial Balance")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report 6;
                                ToolTip = 'View the chart of accounts that have balances and net changes.';
            }
            action("Trial Balance by Period")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Trial Balance by Period';
                Image = "Report";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 38;
                                ToolTip = 'View the opening balance by general ledger account, the movements in the selected period of month, quarter, or year, and the resulting closing balance.';
            }
            action("G/L Register")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'G/L Register';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report 3;
                                ToolTip = 'View posted G/L entries.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NoEmphasize := "Account Type" <> "Account Type"::Posting;
        NameIndent := Indentation;
        NameEmphasize := "Account Type" <> "Account Type"::Posting;


        NameIndent := 0;
        NoOnFormat;
        NameOnFormat;

        //To show bold lines if condition is true. Sangam on 25 August 2011.
        BoldLine("Account Type");
    end;

    trigger OnInit()
    begin

        UserSetup.GET(USERID);
        IF UserSetup."Can See Cost" THEN
          ISVisible :=TRUE
        ELSE
          ISVisible := FALSE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetupNewGLAcc(xRec,BelowxRec);
    end;

    var
        [InDataSet]
        NoEmphasize: Boolean;
        [InDataSet]
        NameEmphasize: Boolean;
        [InDataSet]
        NameIndent: Integer;
        [InDataSet]
        BoldValue: Boolean;
        [InDataSet]
        ISVisible: Boolean;
        UserSetup: Record "91";

    local procedure NoOnFormat()
    begin
        NoEmphasize := "Account Type" <> "Account Type"::Posting;
    end;

    local procedure NameOnFormat()
    begin
        NameIndent := Indentation;
        NameEmphasize := "Account Type" <> "Account Type"::Posting;
    end;

    [Scope('Internal')]
    procedure BoldLine(AccountType: Option Posting,Heading,Total,"Begin-Total","End-Total")
    begin
        //To show bold lines if condition is true.
        IF (AccountType = AccountType::Heading) OR (AccountType = AccountType::Total) OR (AccountType = AccountType::"Begin-Total")
          OR (AccountType = AccountType::"End-Total") THEN
            BoldValue := TRUE
        ELSE
          BoldValue := FALSE;
    end;
}


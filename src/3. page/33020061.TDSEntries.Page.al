page 33020061 "TDS Entries"
{
    Editable = false;
    PageType = List;
    SourceTable = Table33019850;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    Visible = false;
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Document Type"; "Document Type")
                {
                    Visible = false;
                }
                field("Source Type"; "Source Type")
                {
                }
                field("Bill-to/Pay-to No."; "Bill-to/Pay-to No.")
                {
                }
                field(Base; Base)
                {
                }
                field("TDS Amount"; "TDS Amount")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Source Code"; "Source Code")
                {
                    Visible = false;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    Visible = false;
                }
                field("Transaction No."; "Transaction No.")
                {
                    Visible = false;
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("No. Series"; "No. Series")
                {
                    Visible = false;
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("TDS Type"; "TDS Type")
                {
                }
                field("TDS Posting Group"; "TDS Posting Group")
                {
                    Visible = false;
                }
                field("TDS%"; "TDS%")
                {
                }
                field("Accountability Center"; "Accountability Center")
                {
                }
                field("GL Account Name"; "GL Account Name")
                {
                    Visible = false;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    Visible = false;
                }
                field("Reversed Entry No."; "Reversed Entry No.")
                {
                }
                field(Reversed; Reversed)
                {
                }
                field("Reversed by Entry No."; "Reversed by Entry No.")
                {
                }
            }
            group()
            {
                fixed()
                {
                    group(Balance)
                    {
                        Caption = 'Balance';
                        field(TDS; TDSBalance + "TDS Amount" - xRec."TDS Amount")
                        {
                            AutoFormatType = 1;
                            Caption = 'TDS';
                            Editable = false;
                            Visible = TDSBalanceVisible;
                        }
                        field("TDS Base"; BaseBalance + Base - xRec.Base)
                        {
                            Caption = 'TDS Base';
                        }
                    }
                    group("Total Balance")
                    {
                        Caption = 'Total Balance';
                        field("Total TDS"; TotalTDSBalance + "TDS Amount" - xRec."TDS Amount")
                        {
                            AutoFormatType = 1;
                            Caption = 'Total TDS';
                            Editable = false;
                            Visible = TotalTDSBalanceVisible;
                        }
                        field("Total TDS Base"; TotalBaseBalance + Base - xRec.Base)
                        {
                            Caption = 'Total TDS Base';
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Navigate)
            {
                Caption = 'Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Navigate; //TDS2.00
                end;
            }
        }
    }

    trigger OnInit()
    begin

        TotalTDSBalanceVisible := TRUE; //TDS2.00
        TDSBalanceVisible := TRUE; //TDS2.00
        TotalBaseBalanceVisible := TRUE; //TDS2.00
        BaseBalanceVisible := TRUE; //TDS2.00
    end;

    trigger OnOpenPage()
    begin
        //SETFILTER("TDS Amount",'>%1',0);
        //SETFILTER("Source Type",'<>%1',"Source Type"::" ");
        FILTERGROUP(2);
        SETFILTER("TDS Amount", '<>%1', 0);
    end;

    var
        Filters: Text[100];
        TDSentry: Record "33019850";
        TDSBalance: Decimal;
        TotalTDSBalance: Decimal;
        [InDataSet]
        ShowTDSBalance: Boolean;
        [InDataSet]
        ShowTotalTDSBalance: Boolean;
        [InDataSet]
        TDSBalanceVisible: Boolean;
        [InDataSet]
        TotalTDSBalanceVisible: Boolean;
        GenJnlManagement: Codeunit "230";
        BaseBalance: Decimal;
        TotalBaseBalance: Decimal;
        [InDataSet]
        ShowBaseBalance: Boolean;
        [InDataSet]
        ShowTotalBaseBalance: Boolean;
        [InDataSet]
        BaseBalanceVisible: Boolean;
        [InDataSet]
        TotalBaseBalanceVisible: Boolean;

    [Scope('Internal')]
    procedure UpdateBalance()
    begin
        //TDS2.00
        GenJnlManagement.CalcTDSEntryTDSBalance(Rec, xRec, TDSBalance, TotalTDSBalance, ShowTDSBalance, ShowTotalTDSBalance); //TDS1.00
        TDSBalanceVisible := ShowTDSBalance;  //TDS1.00
        TotalTDSBalanceVisible := ShowTotalTDSBalance; //TDS1.00
        GenJnlManagement.CalcTDSEntryBaseBalance(Rec, xRec, BaseBalance, TotalBaseBalance, ShowBaseBalance, ShowTotalBaseBalance); //TDS1.00
        BaseBalanceVisible := ShowBaseBalance;  //TDS1.00
        TotalBaseBalanceVisible := ShowTotalBaseBalance; //TDS1.00
        //TDS2.00
    end;
}


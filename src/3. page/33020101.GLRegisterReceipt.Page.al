page 33020101 "G/L Register Receipt"
{
    Caption = 'G/L Registers';
    Editable = false;
    PageType = List;
    SourceTable = Table45;
    SourceTableView = WHERE(Source Code=CONST(CASHRECJNL));

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field("Creation Date"; "Creation Date")
                {
                }
                field("User ID"; "User ID")
                {
                }
                field("Source Code"; "Source Code")
                {
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                }
                field(Reversed; Reversed)
                {
                    Visible = false;
                }
                field("From Entry No."; "From Entry No.")
                {
                }
                field("To Entry No."; "To Entry No.")
                {
                }
                field("From VAT Entry No."; "From VAT Entry No.")
                {
                }
                field("To VAT Entry No."; "To VAT Entry No.")
                {
                }
                field(DocNo; DocNo)
                {
                    Caption = 'Document No.';
                }
            }
        }
        area(factboxes)
        {
            systempart(; Links)
            {
                Visible = false;
            }
            systempart(; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Register")
            {
                Caption = '&Register';
                action("General Ledger")
                {
                    Caption = 'General Ledger';
                    Image = GLRegisters;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit 235;
                }
                action("Customer &Ledger")
                {
                    Caption = 'Customer &Ledger';
                    Image = CustomerLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit 236;
                }
                action("Ven&dor Ledger")
                {
                    Caption = 'Ven&dor Ledger';
                    Image = VendorLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit 237;
                }
                action("Bank Account Ledger")
                {
                    Caption = 'Bank Account Ledger';
                    Image = BankAccountLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit 377;
                }
                action("Fixed &Asset Ledger")
                {
                    Caption = 'Fixed &Asset Ledger';
                    Image = FixedAssetLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit 5619;
                }
                action("Maintenance Ledger")
                {
                    Caption = 'Maintenance Ledger';
                    Image = MaintenanceLedgerEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit 5649;
                }
                action("VAT Entries")
                {
                    Caption = 'VAT Entries';
                    Image = VATLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit 238;
                }
                action("Item Ledger Relation")
                {
                    Caption = 'Item Ledger Relation';
                    RunObject = Page 5823;
                    RunPageLink = G/L Register No.=FIELD(No.);
                    RunPageView = SORTING(G/L Register No.);
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Reverse Register")
                {
                    Caption = 'Reverse Register';
                    Ellipsis = true;
                    Image = ReverseRegister;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ReversalEntry: Record "179";
                    begin
                        /*
                        TESTFIELD("No.");
                        ReversalEntry.ReverseRegister("No.");
                        */

                    end;
                }
            }
        }
        area(reporting)
        {
            action("Detail Trial Balance")
            {
                Caption = 'Detail Trial Balance';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 4;
            }
            action("Trial Balance")
            {
                Caption = 'Trial Balance';
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report 8;
            }
            action("Trial Balance by Period")
            {
                Caption = 'Trial Balance by Period';
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 38;
            }
            action("G/L Register")
            {
                Caption = 'G/L Register';
                Image = GLRegisters;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report 3;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //sm to get related decument no.
        GLEntry.SETRANGE(GLEntry."Entry No.","From Entry No.");
        IF GLEntry.FIND('-') THEN  BEGIN
           DocNo := GLEntry."Document No.";
        END;
    end;

    var
        GLEntry: Record "17";
        DocNo: Code[20];
}


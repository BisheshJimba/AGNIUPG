page 25006750 "Special Invt. Equipment List"
{
    Caption = 'Special Invt. Equipment List';
    CardPageID = "Special Invt. Equipment Card";
    Editable = false;
    PageType = List;
    SourceTable = Table25006700;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Vendor; Vendor)
                {
                }
                field(Active; Active)
                {
                }
                field("Control Unit"; "Control Unit")
                {
                    Visible = false;
                }
                field("Control Unit Name"; "Control Unit Name")
                {
                    Visible = false;
                }
                field("DSN Name"; "DSN Name")
                {
                    Visible = false;
                }
                field("Last Tran Date"; "Last Tran Date")
                {
                }
                field("Last Tran Time"; "Last Tran Time")
                {
                }
                field("Posting Unit"; "Posting Unit")
                {
                    Visible = false;
                }
                field("Mand.1 Field"; "Mand.1 Field")
                {
                    Visible = false;
                }
                field("Mand.2 Field"; "Mand.2 Field")
                {
                    Visible = false;
                }
                field("Mand.3 Field"; "Mand.3 Field")
                {
                    Visible = false;
                }
                field("Mand.4 Field"; "Mand.4 Field")
                {
                    Visible = false;
                }
                field("Mand.5 Field"; "Mand.5 Field")
                {
                    Visible = false;
                }
                field(SystemCode; SystemCode)
                {
                    Visible = false;
                }
                field("Check 1"; "Check 1")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(SIE)
            {
                Caption = 'SIE';
                Image = Item;
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page 25006753;
                    RunPageLink = No.=FIELD(No.);
                    ShortCutKey = 'Shift+F7';
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = LedgerEntries;
                    RunObject = Page 25006751;
                                    RunPageLink = SIE No.=FIELD(No.);
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Journal Lines")
                {
                    Caption = 'Journal Lines';
                    Image = Journal;
                    RunObject = Page 25006760;
                                    RunPageLink = SIE No.=FIELD(No.);
                    RunPageView = SORTING(SIE No.,Date 1,Time 1)
                                  ORDER(Ascending);
                }
                action(Synchronize)
                {
                    Caption = 'Synchronize';
                    Image = Copy;

                    trigger OnAction()
                    begin
                        SIEMgt.SIESinhronize(Rec)
                    end;
                }
                action(Categories)
                {
                    Caption = 'Categories';
                    Image = Category;
                    RunObject = Page 25006759;
                                    RunPageLink = SIE No.=FIELD(No.);
                }
            }
        }
    }

    var
        SIEMgt: Codeunit "25006700";
}


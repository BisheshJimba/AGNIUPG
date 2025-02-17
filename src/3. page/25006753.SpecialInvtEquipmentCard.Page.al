page 25006753 "Special Invt. Equipment Card"
{
    Caption = 'Special Invt. Equipment Card';
    PageType = Card;
    SourceTable = Table25006700;

    layout
    {
        area(content)
        {
            group(General)
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
                field("Check 1"; "Check 1")
                {
                }
                field("Check 1 Show Reminder"; "Check 1 Show Reminder")
                {
                }
                field("Check 1 Reminder Msg"; "Check 1 Reminder Msg")
                {
                }
            }
            group(Advanced)
            {
                field(SystemCode; SystemCode)
                {
                }
                field("DSN Name"; "DSN Name")
                {
                }
                field("Control Unit"; "Control Unit")
                {
                }
                field("Control Unit Name"; "Control Unit Name")
                {
                }
                field("Posting Unit"; "Posting Unit")
                {
                }
            }
            group("Mandatory F.")
            {
                field("Mand.1 Field"; "Mand.1 Field")
                {
                }
                field("Mand.2 Field"; "Mand.2 Field")
                {
                }
                field("Mand.3 Field"; "Mand.3 Field")
                {
                }
                field("Mand.4 Field"; "Mand.4 Field")
                {
                }
                field("Mand.5 Field"; "Mand.5 Field")
                {
                }
            }
        }
        area(factboxes)
        {
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
            group(SIE)
            {
                Caption = 'SIE';
                Image = History;
                action(SIELedgerEntries)
                {
                    Image = LedgerEntries;
                    RunObject = Page 25006751;
                    RunPageLink = SIE No.=FIELD(No.);
                    RunPageView = SORTING(SIE No.,External Document No.,No. Series);
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
    }
}


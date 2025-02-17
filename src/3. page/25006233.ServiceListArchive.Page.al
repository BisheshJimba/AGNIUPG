page 25006233 "Service List Archive"
{
    Caption = 'Service List Archive';
    Editable = false;
    PageType = List;
    SourceTable = Table25006169;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Version No."; "Version No.")
                {
                }
                field("Date Archived"; "Date Archived")
                {
                }
                field("Time Archived"; "Time Archived")
                {
                }
                field("Archived By"; "Archived By")
                {
                }
                field("Interaction Exist"; "Interaction Exist")
                {
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                }
                field("Sell-to Country/Region Code"; "Sell-to Country/Region Code")
                {
                }
                field("Bill-to Contact No."; "Bill-to Contact No.")
                {
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                }
                field("Bill-to Country/Region Code"; "Bill-to Country/Region Code")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Service Advisor"; "Service Advisor")
                {
                }
                field("Currency Code"; "Currency Code")
                {
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
            group("&Line")
            {
                Caption = '&Line';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        CASE "Document Type" OF
                            "Document Type"::Order:
                                PAGE.RUN(PAGE::"Service Order Archive", Rec);
                            "Document Type"::Quote:
                                PAGE.RUN(PAGE::"Service Quote Archive", Rec);
                            "Document Type"::"Return Order":
                                PAGE.RUN(PAGE::"Service Return Order Arc", Rec);
                        END;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        FilterOnRecord
    end;

    [Scope('Internal')]
    procedure FilterOnRecord()
    var
        UserMgt: Codeunit "5700";
        UserProfileSetup: Record "25006067";
        UserSetup: Record "91";
    begin
        FILTERGROUP(2);
        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserSetup."Service Resp. Ctr. Filter EDMS" <> '' THEN
                SETRANGE("Responsibility Center", UserSetup."Service Resp. Ctr. Filter EDMS");
        END;
        FILTERGROUP(0);
    end;
}


page 25006062 "Contract List Archive"
{
    Caption = 'Contract List Archive';
    CardPageID = "Contract Archive";
    Editable = false;
    PageType = List;
    SourceTable = Table25006045;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Contract No."; "Contract No.")
                {
                }
                field("Doc. No. Occurrence"; "Doc. No. Occurrence")
                {
                }
                field("Version No."; "Version No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                }
                field(Status; Status)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Contract")
            {
                Caption = '&Contract';
                action(Card)
                {
                    Caption = 'Card';
                    Image = Card;
                    Promoted = true;
                    RunObject = Page 25006063;
                    RunPageLink = Contract Type=FIELD(Contract Type),
                                  Contract No.=FIELD(Contract No.),
                                  Doc. No. Occurrence=FIELD(Doc. No. Occurrence),
                                  Version No.=FIELD(Version No.);
                    RunPageView = SORTING(Contract Type,Contract No.,Doc. No. Occurrence,Version No.);
                    ShortCutKey = 'Shift+F5';
                }
            }
        }
    }
}


page 25006350 "Schedule Resource Groups"
{
    Caption = 'Schedule Resource Groups';
    DelayedInsert = true;
    PageType = List;
    SourceTable = Table25006274;

    layout
    {
        area(content)
        {
            repeater()
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field(Workplace; Workplace)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Resource Group")
            {
                Caption = 'Resource Group';
                action(Specification)
                {
                    Caption = 'Specification';
                    Image = ExternalDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page 25006351;
                    RunPageLink = Group Code=FIELD(Code);
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SETRANGE(Workplace,FilterOnView);
    end;
}


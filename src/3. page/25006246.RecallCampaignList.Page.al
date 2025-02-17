page 25006246 "Recall Campaign List"
{
    Caption = 'Recall Campaign List';
    CardPageID = "Recall Campaign Card";
    PageType = List;
    SourceTable = Table25006162;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                }
                field("Search Description"; "Search Description")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                    Visible = false;
                }
                field("Ending Date"; "Ending Date")
                {
                    Visible = false;
                }
                field("External No."; "External No.")
                {
                    Visible = false;
                }
                field(Active; Active)
                {
                    Visible = true;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("C&ampaign")
            {
                Caption = 'C&ampaign';
                action(Card)
                {
                    Caption = 'Card';
                    Image = Card;
                    Promoted = true;
                    RunObject = Page 25006245;
                    RunPageLink = No.=FIELD(No.);
                    ShortCutKey = 'Shift+F5';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page 5072;
                                    RunPageLink = Table Name=CONST(Recall Campaign),
                                  No.=FIELD(No.);
                }
                action(Vehicles)
                {
                    Caption = 'Vehicles';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page 25006247;
                                    RunPageLink = Campaign No.=FIELD(No.);
                }
                action("<Action1190015>")
                {
                    Caption = 'Service Packages';
                    Image = ServiceItemGroup;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ServPackage: Record "25006134";
                    begin
                        ServPackage.RESET;
                        ServPackage.SETCURRENTKEY("Recall Campaign No.");
                        ServPackage.SETRANGE("Recall Campaign No.","No.");
                        IF ServPackage.COUNT = 1 THEN
                          PAGE.RUNMODAL(PAGE::"Service Package Card", ServPackage)
                        ELSE
                          PAGE.RUNMODAL(PAGE::"Service Package List", ServPackage);
                    end;
                }
            }
        }
    }

    [Scope('Internal')]
    procedure GetSelectionFilter(): Code[80]
    var
        Campaign: Record "5071";
        FirstCampaign: Code[30];
        LastCampaign: Code[30];
        SelectionFilter: Code[250];
        CampaignCount: Integer;
        More: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(Campaign);
        CampaignCount := Campaign.COUNT;
        IF CampaignCount > 0 THEN BEGIN
          Campaign.FINDSET;
          WHILE CampaignCount > 0 DO BEGIN
            CampaignCount := CampaignCount - 1;
            Campaign.MARKEDONLY(FALSE);
            FirstCampaign := Campaign."No.";
            LastCampaign := FirstCampaign;
            More := (CampaignCount > 0);
            WHILE More DO
              IF Campaign.NEXT = 0 THEN
                More := FALSE
              ELSE
                IF NOT Campaign.MARK THEN
                  More := FALSE
                ELSE BEGIN
                  LastCampaign := Campaign."No.";
                  CampaignCount := CampaignCount - 1;
                  IF CampaignCount = 0 THEN
                    More := FALSE;
                END;
            IF SelectionFilter <> '' THEN
              SelectionFilter := SelectionFilter + '|';
            IF FirstCampaign = LastCampaign THEN
              SelectionFilter := SelectionFilter + FirstCampaign
            ELSE
              SelectionFilter := SelectionFilter + FirstCampaign + '..' + LastCampaign;
            IF CampaignCount > 0 THEN BEGIN
              Campaign.MARKEDONLY(TRUE);
              Campaign.NEXT;
            END;
          END;
        END;
        EXIT(SelectionFilter);
    end;
}


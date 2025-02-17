page 25006152 "Service Labor List"
{
    // 22.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     "Description in LVI"

    Caption = 'Service Labor List';
    CardPageID = "Service Labor Card";
    Editable = false;
    PageType = List;
    SourceTable = Table25006121;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Make Code"; "Make Code")
                {
                }
                field("Model Code"; "Model Code")
                {
                }
                field("Model Version No."; "Model Version No.")
                {
                }
                field("Group Code"; "Group Code")
                {
                }
                field("Subgroup Code"; "Subgroup Code")
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                    Visible = false;
                }
                field("Search Description"; "Search Description")
                {
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    Visible = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    Visible = false;
                }
                field("Free of Charge"; "Free of Charge")
                {
                    Visible = false;
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                    Visible = false;
                }
                field(Blocked; Blocked)
                {
                    Visible = false;
                }
                field("Standard Time (Hours)"; "Standard Time (Hours)")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Labor)
            {
                Caption = 'Labor';
                action(Translations)
                {
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page 25006203;
                    RunPageLink = No.=FIELD(No.);
                }
                action("&Standard Times")
                {
                    Caption = '&Standard Times';
                    Image = Timeline;
                    RunObject = Page 25006153;
                                    RunPageLink = Labor No.=FIELD(No.);
                }
                action("<Action1190000>")
                {
                    Caption = 'Sales Prices';
                    Image = SalesPrices;
                    RunObject = Page 25006154;
                                    RunPageLink = Code=FIELD(No.),
                                  Type=CONST(Labor);
                }
            }
        }
    }

    [Scope('Internal')]
    procedure GetSelectionFilter(): Code[80]
    var
        Labor: Record "25006121";
        FirstItem: Code[30];
        LastItem: Code[30];
        SelectionFilter: Code[250];
        ItemCount: Integer;
        More: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(Labor);
        ItemCount := Labor.COUNT;
        IF ItemCount > 0 THEN BEGIN
          Labor.FINDSET;
          WHILE ItemCount > 0 DO BEGIN
            ItemCount := ItemCount - 1;
            Labor.MARKEDONLY(FALSE);
            FirstItem := Labor."No.";
            LastItem := FirstItem;
            More := (ItemCount > 0);
            WHILE More DO
              IF Labor.NEXT = 0 THEN
                More := FALSE
              ELSE
                IF NOT Labor.MARK THEN
                  More := FALSE
                ELSE BEGIN
                  LastItem := Labor."No.";
                  ItemCount := ItemCount - 1;
                  IF ItemCount = 0 THEN
                    More := FALSE;
                END;
            IF SelectionFilter <> '' THEN
              SelectionFilter := SelectionFilter + '|';
            IF FirstItem = LastItem THEN
              SelectionFilter := SelectionFilter + FirstItem
            ELSE
              SelectionFilter := SelectionFilter + FirstItem + '..' + LastItem;
            IF ItemCount > 0 THEN BEGIN
              Labor.MARKEDONLY(TRUE);
              Labor.NEXT;
            END;
          END;
        END;
        EXIT(SelectionFilter);
    end;
}


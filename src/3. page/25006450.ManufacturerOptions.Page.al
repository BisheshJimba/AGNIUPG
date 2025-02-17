page 25006450 "Manufacturer Options"
{
    Caption = 'Manufacturer Options';
    PageType = List;
    SourceTable = Table25006370;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Make Code"; "Make Code")
                {
                    Visible = false;
                }
                field("Model Code"; "Model Code")
                {
                    Visible = false;
                }
                field("Model Version No."; "Model Version No.")
                {
                    Visible = false;
                }
                field(Type; Type)
                {
                }
                field("Option Code"; "Option Code")
                {
                }
                field("External Code"; "External Code")
                {
                    Visible = false;
                }
                field(Standard; Standard)
                {
                }
                field("Bill of Materials"; "Bill of Materials")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                    Visible = false;
                }
                field("Class Code"; "Class Code")
                {
                    Visible = false;
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
                field("No. Series"; "No. Series")
                {
                    Visible = false;
                }
                field(SalesPrice; GetCurrentPrice)
                {
                    Caption = 'Sales Price';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Sales Prices")
            {
                Caption = 'Sales Prices';
                Image = SalesPrices;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 25006519;
                RunPageLink = Option Type=CONST(Manufacturer Option),
                              Make Code=FIELD(Make Code),
                              Model Code=FIELD(Model Code),
                              Model Version No.=FIELD(Model Version No.),
                              Option Code=FIELD(Option Code);
            }
            action("<Action1101904016>")
            {
                Caption = 'Sales Discounts';
                Image = SalesLineDisc;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 25006502;
                                RunPageLink = Option Type=CONST(Manufacturer Option),
                              Make Code=FIELD(Make Code),
                              Model Code=FIELD(Model Code),
                              Model Version No.=FIELD(Model Version No.),
                              Option Code=FIELD(Option Code);
            }
            action("<Page Option Purchase Prices>")
            {
                Caption = 'Purchase Prices';
                Image = SalesPrices;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 25006040;
                                RunPageLink = Option Type=CONST(Manufacturer Option),
                              Make Code=FIELD(Make Code),
                              Model Code=FIELD(Model Code),
                              Model Version No.=FIELD(Model Version No.),
                              Option Code=FIELD(Option Code);
            }
            action("Purchase Discounts")
            {
                Caption = 'Purchase Discounts';
                Image = SalesLineDisc;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page 25006039;
                                RunPageLink = Option Type=CONST(Manufacturer Option),
                              Make Code=FIELD(Make Code),
                              Model Code=FIELD(Model Code),
                              Model Version No.=FIELD(Model Version No.),
                              Option Code=FIELD(Option Code);
            }
            action("<Action1101904020>")
            {
                Caption = 'Conditions';
                Image = Worksheet;
                RunObject = Page 25006491;
                                RunPageLink = Make Code=FIELD(Make Code),
                              Model Code=FIELD(Model Code),
                              Model Version No.=FIELD(Model Version No.),
                              Option Code=FIELD(Option Code);
            }
            action(Translations)
            {
                Caption = 'Translations';
                Image = Translations;
                RunObject = Page 25006530;
                                RunPageLink = Option Type=CONST(Manufacturer Option),
                              Make Code=FIELD(Make Code),
                              Model Code=FIELD(Model Code),
                              Model Version No.=FIELD(Model Version No.),
                              Option Code=FIELD(Option Code);
            }
            action(ActionCopyOptions)
            {
                Caption = 'Copy Options';
                Ellipsis = true;
                Image = CopyDocument;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Item.GET("Model Version No.");
                    CopyOptions.SetItem(Item);
                    CopyOptions.RUN;
                    CLEAR(CopyOptions);
                end;
            }
            group("Assembly List")
            {
                Caption = 'Assembly List';
                action("<Action1101904024>")
                {
                    Caption = 'Assembly List';
                    Image = List;
                    RunObject = Page 25006452;
                                    RunPageLink = Make Code=FIELD(Make Code),
                                  Model Code=FIELD(Model Code),
                                  Model Version No.=FIELD(Model Version No.),
                                  Parent Option Code=FIELD(Option Code);
                }
                action("<Action1101904025>")
                {
                    Caption = 'Where-Used List';
                    Image = List;
                    RunObject = Page 25006452;
                                    RunPageLink = Make Code=FIELD(Make Code),
                                  Model Code=FIELD(Model Code),
                                  Model Version No.=FIELD(Model Version No.),
                                  Option Code=FIELD(Option Code);
                }
            }
        }
    }

    var
        Item: Record "27";
        CopyOptions: Report "25006308";
                         Text001: Label 'Sales Price';

    [Scope('Internal')]
    procedure GetSelectionFilter(): Code[80]
    var
        recManOption: Record "25006370";
        codFirstManOption: Code[30];
        codLastManOption: Code[30];
        SelectionFilter: Code[250];
        iManOptionCount: Integer;
        More: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(recManOption);
        iManOptionCount := recManOption.COUNT;
        IF iManOptionCount > 0 THEN BEGIN
          recManOption.FINDSET;
          WHILE iManOptionCount > 0 DO BEGIN
            iManOptionCount := iManOptionCount - 1;
            recManOption.MARKEDONLY(FALSE);
            codFirstManOption := recManOption."Option Code";
            codLastManOption := codFirstManOption;
            More := (iManOptionCount > 0);
            WHILE More DO
              IF recManOption.NEXT = 0 THEN
                More := FALSE
              ELSE
                IF NOT recManOption.MARK THEN
                  More := FALSE
                ELSE BEGIN
                  codLastManOption := recManOption."Option Code";
                  iManOptionCount := iManOptionCount - 1;
                  IF iManOptionCount = 0 THEN
                    More := FALSE;
                END;
            IF SelectionFilter <> '' THEN
              SelectionFilter := SelectionFilter + '|';
            IF codFirstManOption = codLastManOption THEN
              SelectionFilter := SelectionFilter + codFirstManOption
            ELSE
              SelectionFilter := SelectionFilter + codFirstManOption + '..' + codLastManOption;
            IF iManOptionCount > 0 THEN BEGIN
              recManOption.MARKEDONLY(TRUE);
              recManOption.NEXT;
            END;
          END;
        END;
        EXIT(SelectionFilter);
    end;

    local procedure GetCaptionClassUnitPrice(): Text[80]
    var
        SalesSetup: Record "311";
        SalesPricesIncVar: Integer;
    begin
        SalesSetup.GET;
        IF SalesSetup."Def. Sales Price Include VAT" THEN
          SalesPricesIncVar := 1
        ELSE
          SalesPricesIncVar := 0;
        CLEAR(SalesSetup);
        EXIT('2,'+FORMAT(SalesPricesIncVar)+',' + Text001);
    end;
}


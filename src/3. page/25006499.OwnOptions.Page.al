page 25006499 "Own Options"
{
    // 27.08.2008. EDMS P2
    //   * Added Menu Item "Own Option" -> Copy Own Options
    //                     "Own Option" -> Paste Own Options

    Caption = 'Own Options';
    DataCaptionFields = "Make Code", "Model Code";
    DelayedInsert = true;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = Table25006372;

    layout
    {
        area(content)
        {
            repeater()
            {
                field("Make Code"; "Make Code")
                {
                    Visible = false;
                }
                field("Model Code"; "Model Code")
                {
                    Visible = false;
                }
                field("Option Code"; "Option Code")
                {
                }
                field(Description; Description)
                {
                }
                field("Description 2"; "Description 2")
                {
                    Visible = false;
                }
                field("Package No."; "Package No.")
                {
                    Visible = false;
                }
                field(SalesPrice; GetCurrentPrice)
                {
                    Caption = 'Sales Price';
                }
                field("Unit Cost"; "Unit Cost")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Own Option")
            {
                Caption = 'Own Option';
                action(Translations)
                {
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page 25006530;
                    RunPageLink = Option Type=CONST(Own Option),
                                  Make Code=FIELD(Make Code),
                                  Model Code=FIELD(Model Code),
                                  Option Code=FIELD(Option Code);
                }
                action("Sales Price")
                {
                    Caption = 'Sales Price';
                    Image = SalesPrices;
                    RunObject = Page 25006519;
                                    RunPageLink = Make Code=FIELD(Make Code),
                                  Model Code=FIELD(Model Code),
                                  Option Code=FIELD(Option Code),
                                  Option Type=CONST(Own Option),
                                  Sales Type=CONST(All Customers);
                }
                action("Sales Discounts")
                {
                    Caption = 'Sales Discounts';
                    Image = SalesLineDisc;
                    RunObject = Page 25006502;
                                    RunPageLink = Make Code=FIELD(Make Code),
                                  Model Code=FIELD(Model Code),
                                  Option Code=FIELD(Option Code),
                                  Option Type=CONST(Own Option),
                                  Sales Type=CONST(All Customers);
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
                        Model.GET("Make Code", "Model Code");
                        CopyOptions.SetModel(Model);
                        CopyOptions.RUNMODAL;
                        CLEAR(CopyOptions);
                    end;
                }
            }
        }
    }

    var
        CopyOptions: Report "25006308";
                         Model: Record "25006001";

    [Scope('Internal')]
    procedure GetSelectionFilter(): Code[80]
    var
        recOwnOption: Record "25006372";
        codFirstOwnOption: Code[30];
        codLastOwnOption: Code[30];
        SelectionFilter: Code[250];
        iOwnOptionCount: Integer;
        More: Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(recOwnOption);
        iOwnOptionCount := recOwnOption.COUNT;
        IF iOwnOptionCount > 0 THEN BEGIN
            recOwnOption.FINDSET;
            WHILE iOwnOptionCount > 0 DO BEGIN
                iOwnOptionCount := iOwnOptionCount - 1;
                recOwnOption.MARKEDONLY(FALSE);
                codFirstOwnOption := recOwnOption."Option Code";
                codLastOwnOption := codFirstOwnOption;
                More := (iOwnOptionCount > 0);
                WHILE More DO
                    IF recOwnOption.NEXT = 0 THEN
                        More := FALSE
                    ELSE
                        IF NOT recOwnOption.MARK THEN
                            More := FALSE
                        ELSE BEGIN
                            codLastOwnOption := recOwnOption."Option Code";
                            iOwnOptionCount := iOwnOptionCount - 1;
                            IF iOwnOptionCount = 0 THEN
                                More := FALSE;
                        END;
                IF SelectionFilter <> '' THEN
                    SelectionFilter := SelectionFilter + '|';
                IF codFirstOwnOption = codLastOwnOption THEN
                    SelectionFilter := SelectionFilter + codFirstOwnOption
                ELSE
                    SelectionFilter := SelectionFilter + codFirstOwnOption + '..' + codLastOwnOption;
                IF iOwnOptionCount > 0 THEN BEGIN
                    recOwnOption.MARKEDONLY(TRUE);
                    recOwnOption.NEXT;
                END;
            END;
        END;
        EXIT(SelectionFilter);
    end;
}


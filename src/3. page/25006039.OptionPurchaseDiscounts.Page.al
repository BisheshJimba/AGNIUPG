page 25006039 "Option Purchase Discounts"
{
    Caption = 'Option Sales Discounts';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = Worksheet;
    PopulateAllFields = true;
    SaveValues = true;
    SourceTable = Table25006039;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ItemTypeFilter; ItemTypeFilter)
                {
                    Caption = 'Option Type Filter';
                    Editable = true;
                    OptionCaption = 'Manufacturer Option,Own Option,None';

                    trigger OnValidate()
                    begin
                        ItemTypeFilterOnAfterValidate;
                    end;
                }
                field(CodeFilterCtrl; CodeFilter)
                {
                    Caption = 'Option Code Filter';
                    Enabled = CodeFilterCtrlEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CASE "Option Type" OF
                            "Option Type"::"Manufacturer Option":
                                BEGIN
                                    frmManOptions.LOOKUPMODE := TRUE;
                                    IF frmManOptions.RUNMODAL = ACTION::LookupOK THEN
                                        Text := frmManOptions.GetSelectionFilter
                                    ELSE
                                        EXIT(FALSE);
                                END;
                            "Option Type"::"Own Option":
                                BEGIN
                                    frmOwnOptions.LOOKUPMODE := TRUE;
                                    IF frmOwnOptions.RUNMODAL = ACTION::LookupOK THEN
                                        Text := frmOwnOptions.GetSelectionFilter
                                    ELSE
                                        EXIT(FALSE);
                                END;
                        END;

                        EXIT(TRUE);
                    end;

                    trigger OnValidate()
                    begin
                        CodeFilterOnAfterValidate;
                    end;
                }
                field(StartingDateFilter; StartingDateFilter)
                {
                    Caption = 'Starting Date Filter';

                    trigger OnValidate()
                    var
                        ApplicationMgt: Codeunit "1";
                    begin
                        IF ApplicationMgt.MakeDateFilter(StartingDateFilter) = 0 THEN;
                        StartingDateFilterOnAfterValid;
                    end;
                }
            }
            repeater()
            {
                field("Vendor No."; "Vendor No.")
                {
                }
                field("Option Type"; "Option Type")
                {
                    Visible = false;
                }
                field("Option Subtype"; "Option Subtype")
                {
                }
                field("Option Code"; "Option Code")
                {
                    Visible = false;
                }
                field("Minimum Quantity"; "Minimum Quantity")
                {
                }
                field("Line Discount %"; "Line Discount %")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Ending Date"; "Ending Date")
                {
                }
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
                    Editable = ModelVersionNoEditable;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        CodeFilterCtrlEnable := TRUE;
        //SalesCodeFilterCtrlEnable := TRUE;
        ModelVersionNoEditable := TRUE;
        //SalesCodeEditable := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        GetRecFilters;
        SetRecFilters;
    end;

    var
        Cust: Record "18";
        CustDiscGr: Record "340";
        Campaign: Record "5071";
        Item: Record "27";
        ItemDiscGr: Record "341";
        CustList: Page "22";
        CustDiscGrList: Page "512";
        CampaignList: Page "5087";
        frmManOptions: Page "25006450";
        frmOwnOptions: Page "25006499";
        ItemTypeFilter: Option "Manufacturer Option","Own Option","None";
        CodeFilter: Text[250];
        StartingDateFilter: Text[30];
        Text000: Label 'All Customers';
        [InDataSet]
        ModelVersionNoEditable: Boolean;
        [InDataSet]
        CodeFilterCtrlEnable: Boolean;

    [Scope('Internal')]
    procedure GetRecFilters()
    begin
        IF GETFILTERS <> '' THEN BEGIN
            //IF GETFILTER("Sales Type") <> '' THEN
            //  SalesTypeFilter := "Sales Type"
            //ELSE
            //  SalesTypeFilter := SalesTypeFilter::None;

            IF GETFILTER("Option Type") <> '' THEN
                ItemTypeFilter := "Option Type"
            ELSE
                ItemTypeFilter := ItemTypeFilter::None;

            //SalesCodeFilter := GETFILTER("Sales Code");
            CodeFilter := GETFILTER("Option Code");
            EVALUATE(StartingDateFilter, GETFILTER("Starting Date"));
        END;
    end;

    [Scope('Internal')]
    procedure SetRecFilters()
    begin
        CodeFilterCtrlEnable := TRUE;

        IF ItemTypeFilter <> ItemTypeFilter::None THEN
            SETRANGE("Option Type", ItemTypeFilter)
        ELSE
            SETRANGE("Option Type");


        IF ItemTypeFilter = ItemTypeFilter::None THEN BEGIN
            CodeFilterCtrlEnable := FALSE;
            CodeFilter := '';
        END;

        IF CodeFilter <> '' THEN BEGIN
            SETFILTER("Option Code", CodeFilter);
        END ELSE
            SETRANGE("Option Code");

        IF StartingDateFilter <> '' THEN
            SETFILTER("Starting Date", StartingDateFilter)
        ELSE
            SETRANGE("Starting Date");

        CurrPage.UPDATE(FALSE);
    end;

    [Scope('Internal')]
    procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "377";
        SourceTableName: Text[100];
        SalesSrcTableName: Text[100];
        Description: Text[250];
    begin
        GetRecFilters;
        //SalesCodeEditable := "Sales Type" <> "Sales Type"::"All Customers";
        ModelVersionNoEditable := "Option Type" <> "Option Type"::"Own Option";

        SourceTableName := '';
        CASE ItemTypeFilter OF
            ItemTypeFilter::"Manufacturer Option":
                BEGIN
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 25006370);
                    //Item."No." := CodeFilter;
                END;
            ItemTypeFilter::"Own Option":
                BEGIN
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table, 25006372);
                    //ItemDiscGr.Code := CodeFilter;
                END;
        END;
        /*
        SalesSrcTableName := '';
        CASE SalesTypeFilter OF
          SalesTypeFilter::Customer:
            BEGIN
              SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,18);
              Cust."No." := SalesCodeFilter;
              IF Cust.FIND THEN
                Description := Cust.Name;
            END;
          SalesTypeFilter::"Customer Discount Group":
            BEGIN
              SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,340);
              CustDiscGr.Code := SalesCodeFilter;
              IF CustDiscGr.FIND THEN
                Description := CustDiscGr.Description;
            END;
          SalesTypeFilter::Campaign:
            BEGIN
              SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,5071);
              Campaign."No." := SalesCodeFilter;
              IF Campaign.FIND THEN
                Description := Campaign.Description;
            END;
        
          SalesTypeFilter::"All Customers":
            BEGIN
              SalesSrcTableName := Text000;
              Description := '';
            END;
        END;
        */
        //IF SalesSrcTableName = Text000 THEN
        //  EXIT(STRSUBSTNO('%1 %2 %3 %4 %5',SalesSrcTableName,SalesCodeFilter,Description,SourceTableName,CodeFilter));
        //EXIT(STRSUBSTNO('%1 %2 %3 %4 %5',SalesSrcTableName,SalesCodeFilter,Description,SourceTableName,CodeFilter));

    end;

    local procedure SalesCodeFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    local procedure SalesTypeFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        //SalesCodeFilter := '';
        SetRecFilters;
    end;

    local procedure StartingDateFilterOnAfterValid()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    local procedure ItemTypeFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        CodeFilter := '';
        SetRecFilters;
    end;

    local procedure CodeFilterOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        SetRecFilters;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        //SalesCodeEditable := "Sales Type" <> "Sales Type"::"All Customers";
        ModelVersionNoEditable := "Option Type" <> "Option Type"::"Own Option";
    end;
}


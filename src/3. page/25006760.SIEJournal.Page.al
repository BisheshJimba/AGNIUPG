page 25006760 "SIE Journal"
{
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009

    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = Table25006702;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SAVERECORD;
                    SIEExchMgt.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.UPDATE(FALSE);
                end;

                trigger OnValidate()
                begin
                    SIEExchMgt.CheckName(CurrentJnlBatchName, Rec);
                    //CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Group)
            {
                field("Posting Date"; "Posting Date")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("SIE No."; "SIE No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Int 1"; "Int 1")
                {
                    Visible = Int1Visible;
                }
                field("Int 2"; "Int 2")
                {
                    Visible = Int2Visible;
                }
                field("Int 3"; "Int 3")
                {
                    Visible = Int3Visible;
                }
                field("Int 4"; "Int 4")
                {
                    Visible = Int4Visible;
                }
                field("Int 5"; "Int 5")
                {
                    Visible = Int5Visible;
                }
                field("Int 6"; "Int 6")
                {
                    Visible = Int6Visible;
                }
                field("Int 7"; "Int 7")
                {
                    Visible = Int7Visible;
                }
                field("Int 8"; "Int 8")
                {
                    Visible = Int8Visible;
                }
                field("Decimal 1"; "Decimal 1")
                {
                    Visible = Dec1Visible;
                }
                field("Decimal 2"; "Decimal 2")
                {
                    Visible = Dec2Visible;
                }
                field("Decimal 3"; "Decimal 3")
                {
                    Visible = Dec3Visible;
                }
                field("Decimal 4"; "Decimal 4")
                {
                    Visible = Dec4Visible;
                }
                field("Decimal 5"; "Decimal 5")
                {
                    Visible = Dec5Visible;
                }
                field("Decimal 6"; "Decimal 6")
                {
                    Visible = Dec6Visible;
                }
                field("Decimal 7"; "Decimal 7")
                {
                    Visible = Dec7Visible;
                }
                field("Decimal 8"; "Decimal 8")
                {
                    Visible = Dec8Visible;
                }
                field("Date 1"; "Date 1")
                {
                    Visible = Date1Visible;
                }
                field("Date 2"; "Date 2")
                {
                    Visible = Date2Visible;
                }
                field("Date 3"; "Date 3")
                {
                    Visible = Date3Visible;
                }
                field("Date 4"; "Date 4")
                {
                    Visible = Date4Visible;
                }
                field("Time 1"; "Time 1")
                {
                    Visible = Time1Visible;
                }
                field("Time 2"; "Time 2")
                {
                    Visible = Time2Visible;
                }
                field("Text50 1"; "Text50 1")
                {
                    Visible = Text50_1Visible;
                }
                field("Text50 2"; "Text50 2")
                {
                    Visible = Text50_2Visible;
                }
                field("Text100 1"; "Text100 1")
                {
                    Visible = Text100_1Visible;
                }
                field("Code10 1"; "Code10 1")
                {
                    Visible = Code10_1Visible;
                }
                field("Code10 2"; "Code10 2")
                {
                    Visible = Code10_2Visible;
                }
                field("Code10 3"; "Code10 3")
                {
                    Visible = Code10_3Visible;
                }
                field("Code20 1"; "Code20 1")
                {
                    Visible = Code20_1Visible;
                }
                field("Code20 2"; "Code20 2")
                {
                    Visible = Code20_2Visible;
                }
                field("Code20 3"; "Code20 3")
                {
                    Visible = Code20_3Visible;
                }
                field("Text10 1"; "Text10 1")
                {
                    Visible = Text10_1Visible;
                }
                field("Text10 2"; "Text10 2")
                {
                    Visible = Text10_2Visible;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action61>")
            {
                Caption = '&Line';
                action("<Action62>")
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                        CurrPage.SAVERECORD;
                    end;
                }
            }
            group("<Action37>")
            {
                Caption = '&SIE';
                action("<Action42>")
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page 25006753;
                    RunPageLink = No.=FIELD(SIE No.);
                    ShortCutKey = 'Shift+F7';
                }
                action("<Action45>")
                {
                    Caption = 'Ledger E&ntries';
                    Image = ResourceLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page 25006751;
                                    RunPageLink = SIE No.=FIELD(SIE No.);
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            group("<Action36>")
            {
                Caption = 'P&osting';
                action("<Action48>")
                {
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        SIEMgt.SIEPostJnl(Rec);
                        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(FALSE);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetVariableFields;
        SIEExchMgt.GetSIE("SIE No.",SIEDescription);
        OpenedFromBatch := ("Journal Batch Name" <> '') AND ("Journal Template Name" = '');
        IF OpenedFromBatch THEN BEGIN
          CurrentJnlBatchName := "Journal Batch Name";
          SIEExchMgt.OpenJournal(CurrentJnlBatchName,Rec);
          EXIT;
        END;
        SIEExchMgt.TemplateSelection(PAGE::"SIE Journal",FALSE,Rec,JnlSelected);
        IF NOT JnlSelected THEN
          ERROR('');
        SIEExchMgt.OpenJournal(CurrentJnlBatchName,Rec);
    end;

    var
        CurrentJnlBatchName: Code[20];
        SIEExchMgt: Codeunit "25006701";
        SIEDescription: Text[50];
        SIEMgt: Codeunit "25006700";
        [InDataSet]
        Int1Visible: Boolean;
        [InDataSet]
        Int2Visible: Boolean;
        [InDataSet]
        Int3Visible: Boolean;
        [InDataSet]
        Int4Visible: Boolean;
        [InDataSet]
        Int5Visible: Boolean;
        [InDataSet]
        Int6Visible: Boolean;
        [InDataSet]
        Int7Visible: Boolean;
        [InDataSet]
        Int8Visible: Boolean;
        [InDataSet]
        Dec1Visible: Boolean;
        [InDataSet]
        Dec2Visible: Boolean;
        [InDataSet]
        Dec3Visible: Boolean;
        [InDataSet]
        Dec4Visible: Boolean;
        [InDataSet]
        Dec5Visible: Boolean;
        [InDataSet]
        Dec6Visible: Boolean;
        [InDataSet]
        Dec7Visible: Boolean;
        [InDataSet]
        Dec8Visible: Boolean;
        [InDataSet]
        Date1Visible: Boolean;
        [InDataSet]
        Date2Visible: Boolean;
        [InDataSet]
        Date3Visible: Boolean;
        [InDataSet]
        Date4Visible: Boolean;
        [InDataSet]
        Time1Visible: Boolean;
        [InDataSet]
        Time2Visible: Boolean;
        [InDataSet]
        Text50_1Visible: Boolean;
        [InDataSet]
        Text50_2Visible: Boolean;
        [InDataSet]
        Text100_1Visible: Boolean;
        [InDataSet]
        Code10_1Visible: Boolean;
        [InDataSet]
        Code10_2Visible: Boolean;
        [InDataSet]
        Code10_3Visible: Boolean;
        [InDataSet]
        Code20_1Visible: Boolean;
        [InDataSet]
        Code20_2Visible: Boolean;
        [InDataSet]
        Code20_3Visible: Boolean;
        [InDataSet]
        Text10_1Visible: Boolean;
        [InDataSet]
        Text10_2Visible: Boolean;
        OpenedFromBatch: Boolean;
        JnlSelected: Boolean;

    [Scope('Internal')]
    procedure SetVariableFields()
    begin
        Int1Visible := IsVFActive(FIELDNO("Int 1"));
        Int2Visible := IsVFActive(FIELDNO("Int 2"));
        Int3Visible := IsVFActive(FIELDNO("Int 3"));
        Int4Visible := IsVFActive(FIELDNO("Int 4"));
        Int5Visible := IsVFActive(FIELDNO("Int 5"));
        Int6Visible := IsVFActive(FIELDNO("Int 6"));
        Int7Visible := IsVFActive(FIELDNO("Int 7"));
        Int8Visible := IsVFActive(FIELDNO("Int 8"));

        Dec1Visible := IsVFActive(FIELDNO("Decimal 1"));
        Dec2Visible := IsVFActive(FIELDNO("Decimal 2"));
        Dec3Visible := IsVFActive(FIELDNO("Decimal 3"));
        Dec4Visible := IsVFActive(FIELDNO("Decimal 4"));
        Dec5Visible := IsVFActive(FIELDNO("Decimal 5"));
        Dec6Visible := IsVFActive(FIELDNO("Decimal 6"));
        Dec7Visible := IsVFActive(FIELDNO("Decimal 7"));
        Dec8Visible := IsVFActive(FIELDNO("Decimal 8"));

        Date1Visible := IsVFActive(FIELDNO("Date 1"));
        Date2Visible := IsVFActive(FIELDNO("Date 2"));
        Date3Visible := IsVFActive(FIELDNO("Date 3"));
        Date4Visible := IsVFActive(FIELDNO("Date 4"));

        Time1Visible := IsVFActive(FIELDNO("Time 1"));
        Time2Visible := IsVFActive(FIELDNO("Time 2"));

        Text50_1Visible := IsVFActive(FIELDNO("Text50 1"));
        Text50_2Visible := IsVFActive(FIELDNO("Text50 2"));

        Text100_1Visible := IsVFActive(FIELDNO("Text100 1"));

        Code10_1Visible := IsVFActive(FIELDNO("Code10 1"));
        Code10_2Visible := IsVFActive(FIELDNO("Code10 2"));
        Code10_3Visible := IsVFActive(FIELDNO("Code10 3"));

        Code20_1Visible := IsVFActive(FIELDNO("Code20 1"));
        Code20_2Visible := IsVFActive(FIELDNO("Code20 2"));
        Code20_3Visible := IsVFActive(FIELDNO("Code20 3"));

        Text10_1Visible := IsVFActive(FIELDNO("Text10 1"));
        Text10_2Visible := IsVFActive(FIELDNO("Text10 2"));
    end;
}


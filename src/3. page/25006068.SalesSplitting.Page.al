page 25006068 "Sales Splitting"
{
    Caption = 'Sales Splitting';
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table25006042;
    SourceTableView = SORTING(Document Type, Document No., Temp. Document No., Line, Temp. Line No.)
                      ORDER(Ascending)
                      WHERE(Document Type=CONST(Order),
                            Line=CONST(No));

    layout
    {
        area(content)
        {
            repeater(Headers)
            {
                field("Document No."; "Document No.")
                {
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }
                field("Temp. Document No."; "Temp. Document No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Quantity Share %"; "Quantity Share %")
                {
                }
                field("Amount Share %"; "Amount Share %")
                {
                    Editable = false;
                    Visible = false;
                }
                field("New Amount"; "New Amount")
                {
                    Editable = false;
                    Visible = false;
                }
            }
            part(; 25006069)
            {
                SubPageLink = Document Type=FIELD(Document Type),
                              Document No.=FIELD(Document No.),
                              Temp. Document No.=FIELD(Temp. Document No.);
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("<Action1101904006>")
            {
                Caption = 'New document';
                Image = NewDocument;
                Promoted = true;

                trigger OnAction()
                begin
                    SalesSplittingHeaderTmp := Rec;
                    ApplyInsertAsWholeDoc;
                    ApplyFilter2(SalesSplittingHeaderTmp);
                    FINDLAST;
                end;
            }
        }
        area(processing)
        {
            action(Split)
            {
                Caption = 'Split';
                Image = Apply;
                Promoted = true;

                trigger OnAction()
                begin
                    //at first do compare values
                    DiffAmt := CheckDocTotalAmount(SrcAmt, DstAmt);
                    GLSetup.GET;
                    IF DiffAmt <> 0 THEN
                      IF NOT CONFIRM(STRSUBSTNO(Text104, SrcAmt, DstAmt, GLSetup."LCY Code"), TRUE) THEN
                        EXIT;
                    ProceedDocSplit;
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnClosePage()
    begin
        SalesSplittingLine.SETRANGE(Line, FALSE);
        SalesSplittingLine.SETRANGE("Document Type", "Document Type");
        SalesSplittingLine.SETRANGE("Document No.", "Document No.");
        IF SalesSplittingLine.FINDFIRST THEN BEGIN
          IF CONFIRM(Text103, TRUE) THEN BEGIN
            DeleteDocSplit;
          END;
        END;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //ApplyFilter;
    end;

    trigger OnOpenPage()
    begin
        CreateSpliting;
    end;

    var
        SalesSplittingLine: Record "25006042";
        SalesSplittingHeaderTmp: Record "25006042" temporary;
        FilterText: Text[250];
        GLSetup: Record "98";
        SrcAmt: Decimal;
        DstAmt: Decimal;
        DiffAmt: Decimal;
        Text103: Label 'Would you like to delete created split prepare lines?';
        Text104: Label 'There is difference in amounts: in source document %1 %3, in split %2 %3. Are you sure to continue?';

    [Scope('Internal')]
    procedure ApplyFilter()
    var
        ServiceSplittingLineTmpL: Record "25006128";
    begin
        SETRANGE(Line, FALSE);
        SETRANGE("Document Type", "Document Type");
        SETRANGE("Document No.", "Document No.");
    end;

    [Scope('Internal')]
    procedure ApplyFilter2(SalesSplittingLinePar: Record "25006042")
    var
        ServiceSplittingLineTmpL: Record "25006128";
    begin
        SETRANGE(Line, FALSE);
        SETRANGE("Document Type", SalesSplittingLinePar."Document Type");
        SETRANGE("Document No.", SalesSplittingLinePar."Document No.");
    end;

    [Scope('Internal')]
    procedure CreateSpliting(var SalesHeaderPar: Record "36")
    begin
        SalesSplittingLine.RESET;
        SalesSplittingLine.SETRANGE(Line, FALSE);
        SalesSplittingLine.SETRANGE("Document Type", SalesHeaderPar."Document Type");
        SalesSplittingLine.SETRANGE("Document No.", SalesHeaderPar."No.");
        IF NOT SalesSplittingLine.FINDFIRST THEN
          ApplyInsertAsHeaderByDoc(SalesHeaderPar."Document Type", SalesHeaderPar."No.");
        IF SalesSplittingLine.FINDFIRST THEN BEGIN
          GET(SalesSplittingLine."Document Type", SalesSplittingLine."Document No.",
            SalesSplittingLine."Temp. Document No.", SalesSplittingLine.Line, SalesSplittingLine."Temp. Line No.");
        END;
        ApplyFilter;
    end;
}


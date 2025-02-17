page 25006259 "Service Splitting"
{
    // 06.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Changed Visible and Editable properties of some fields
    // 
    // 22.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Commented in trigger:
    //     OnClosePage()
    // 
    // 04.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Commented in trigger:
    //     <Action1101904014> - OnAction() (Split)
    // 
    // 05.01.2012 EDMS P8
    //   * Is not supported amount changes, but only quantity

    Caption = 'Service Splitting';
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Table25006128;
    SourceTableView = SORTING(Document Type, Document No., Temp. Document No., Line, Temp. Line No.)
                      ORDER(Ascending)
                      WHERE(Document Type=CONST(Order),
                            Line=CONST(No));

    layout
    {
        area(content)
        {
            group()
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
                    field("Quantity Share %"; "Quantity Share %")
                    {
                        Editable = false;
                        Visible = false;
                    }
                    field("Amount Share %"; "Amount Share %")
                    {
                        Editable = false;
                        Visible = false;
                    }
                    field("Document Amount"; "Document Amount")
                    {
                    }
                }
            }
            part(; 25006260)
            {
                SubPageLink = Document Type=FIELD(Document Type),
                              Document No.=FIELD(Document No.),
                              Temp. Document No.=FIELD(Temp. Document No.);
                UpdatePropagation = Both;
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
                    ServiceSplittingHeaderTmp := Rec;
                    ApplyInsertAsWholeDoc;
                    ApplyFilter2(ServiceSplittingHeaderTmp);
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
                    // 04.04.2014 Elva Baltic P21 >>
                    /*
                    //at first do compare values
                    DiffAmt := CheckDocTotalAmount(SrcAmt, DstAmt);
                    GLSetup.GET;
                    IF DiffAmt <> 0 THEN
                      IF NOT CONFIRM(STRSUBSTNO(Text104, SrcAmt, DstAmt, GLSetup."LCY Code"), TRUE) THEN
                        EXIT;
                    */
                    // 04.04.2014 Elva Baltic P21 <<
                    
                    ProceedDocSplit;
                    CurrPage.CLOSE;

                end;
            }
        }
    }

    trigger OnClosePage()
    begin
        ServiceSplittingLine.SETRANGE(Line, FALSE);
        ServiceSplittingLine.SETRANGE("Document Type", "Document Type");
        ServiceSplittingLine.SETRANGE("Document No.", "Document No.");
        IF ServiceSplittingLine.FINDFIRST THEN BEGIN
          // IF CONFIRM(Text103, TRUE) THEN BEGIN                             // 22.04.2014 Elva Baltic P21
          DeleteDocSplit;
          // END;                                                             // 22.04.2014 Elva Baltic P21
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
        ServiceSplittingLine: Record "25006128";
        ServiceSplittingHeaderTmp: Record "25006128" temporary;
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
    procedure ApplyFilter2(ServiceSplittingLinePar: Record "25006128")
    var
        ServiceSplittingLineTmpL: Record "25006128";
    begin
        SETRANGE(Line, FALSE);
        SETRANGE("Document Type", ServiceSplittingLinePar."Document Type");
        SETRANGE("Document No.", ServiceSplittingLinePar."Document No.");
    end;

    [Scope('Internal')]
    procedure CreateSpliting(var ServiceHeaderPar: Record "25006145")
    begin
        ServiceSplittingLine.RESET;
        ServiceSplittingLine.SETRANGE(Line, FALSE);
        ServiceSplittingLine.SETRANGE("Document Type", ServiceHeaderPar."Document Type");
        ServiceSplittingLine.SETRANGE("Document No.", ServiceHeaderPar."No.");
        IF NOT ServiceSplittingLine.FINDFIRST THEN
          ApplyInsertAsHeaderByServDoc(ServiceHeaderPar."Document Type", ServiceHeaderPar."No.");
        IF ServiceSplittingLine.FINDFIRST THEN BEGIN
          GET(ServiceSplittingLine."Document Type", ServiceSplittingLine."Document No.",
            ServiceSplittingLine."Temp. Document No.", ServiceSplittingLine.Line, ServiceSplittingLine."Temp. Line No.");
        END;
        ApplyFilter;
    end;
}


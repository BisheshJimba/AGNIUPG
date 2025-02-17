page 25006084 "Deal Document Application"
{
    Caption = 'Deal Document Application';
    InsertAllowed = false;
    PageType = List;
    SourceTable = Table25006053;

    layout
    {
        area(content)
        {
            field(DocType; DocType)
            {
                Caption = 'Document Type';
                Editable = false;
            }
            field(DocNo; DocNo)
            {
                Caption = 'Document No.';
                Editable = false;
            }
            field(Descr; Descr)
            {
                Caption = 'Description';
                Editable = false;
            }
            field(Amount; Amount)
            {
                Caption = 'Amount';
                Editable = false;
            }
            field(CurrCode; CurrCode)
            {
                Caption = 'Currency Code';
                Editable = false;
            }
            repeater()
            {
                field("Document Type"; "Document Type")
                {
                    Editable = false;
                }
                field("Document No."; "Document No.")
                {
                    Editable = false;
                }
                field("Doc. Line No."; "Doc. Line No.")
                {
                    Caption = 'Line No.';
                    Editable = false;
                }
                field(LineDescr; LineDescr)
                {
                    Caption = 'Description';
                    Editable = false;
                }
                field(LineCurrCode; LineCurrCode)
                {
                    Caption = 'Currency Code';
                    Editable = false;
                }
                field(LineAmount; LineAmount)
                {
                    Caption = 'Line Amount';
                    Editable = false;
                }
                field(Application; Application)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action("Find Documents")
                {
                    Caption = 'Find Documents';
                    Image = Find;
                    Promoted = true;
                    ShortCutKey = 'Ctrl+F';

                    trigger OnAction()
                    begin
                        FindDocs(DealApplEntry)
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF "Det. Cust. Ledg. Entry EDMS" = 0 THEN BEGIN
            SalesLine.GET("Document Type", "Document No.", "Doc. Line No.");
            LineDescr := SalesLine.Description;
            IF SalesLine."Amount Including VAT" = 0 THEN
                LineAmount := SalesLine."Line Amount"
            ELSE
                LineAmount := SalesLine."Amount Including VAT";
            LineCurrCode := SalesLine."Currency Code";
        END ELSE BEGIN
            DCLedgEntry.GET("Det. Cust. Ledg. Entry EDMS");
            //CustLedgEntry.GET(DCLedgEntry."Cust. Ledger Entry No.");
            LineDescr := DCLedgEntry.Description;
            LineAmount := DCLedgEntry.Amount;
            LineCurrCode := ''
        END
    end;

    trigger OnClosePage()
    begin
        DealApplEntry.COPY(Rec);
        //DealApplEntry.SETRANGE("Entry No.");
        DealApplEntry.SETRANGE(Application, TRUE);
        IF DealApplEntry.COUNT > 1 THEN BEGIN
            DealApplEntry.SETRANGE(Application, FALSE)
        END ELSE
            DealApplEntry.SETRANGE(Application);
        DealApplEntry.DELETEALL
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Applies-to Entry No." := DealApplEntry."Applies-to Entry No."
    end;

    trigger OnOpenPage()
    begin
        DealApplEntry.InitApplication(DealType, DCLedgEntryNo, DocType, DocNo, DocLineNo);
        SETCURRENTKEY("Applies-to Entry No.");
        SETRANGE("Applies-to Entry No.", DealApplEntry."Applies-to Entry No.");

        //SETFILTER("Entry No.",'<>%1',DealApplEntry."Entry No.");

        FillFields;
    end;

    var
        DCLedgEntryNo: Integer;
        DealType: Option " ",Leasing;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Posted Invoice","Posted C.Memo";
        DocNo: Code[20];
        DocLineNo: Integer;
        Amount: Decimal;
        DealApplEntry: Record "25006053";
        Descr: Text[50];
        LineDescr: Text[50];
        LineAmount: Decimal;
        SalesLine: Record "37";
        DCLedgEntry: Record "25006054";
        LineCurrCode: Code[10];
        CustLedgEntry: Record "21";
        CurrCode: Code[10];

    [Scope('Internal')]
    procedure SetApplication(NewType: Option " ",Leasing; NewDCLedgEntryNo: Integer; NewDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; NewDocNo: Code[20]; NewDocLineNo: Integer)
    begin
        DealType := NewType;
        DCLedgEntryNo := NewDCLedgEntryNo;
        DocType := NewDocType;
        DocNo := NewDocNo;
        DocLineNo := NewDocLineNo
    end;

    [Scope('Internal')]
    procedure FillFields()
    begin
        IF DCLedgEntryNo = 0 THEN BEGIN
            IF SalesLine.GET(DocType, DocNo, DocLineNo) THEN BEGIN
                Descr := SalesLine.Description;
                IF SalesLine."Amount Including VAT" = 0 THEN
                    Amount := SalesLine."Line Amount"
                ELSE
                    Amount := SalesLine."Amount Including VAT";
                CurrCode := SalesLine."Currency Code"
            END
        END ELSE BEGIN
            DCLedgEntry.GET(DCLedgEntryNo);
            CustLedgEntry.GET(DCLedgEntry."Cust. Ledger Entry No.");
            Descr := DCLedgEntry.Description;
            DocType := DCLedgEntry."Document Type";
            DocNo := DCLedgEntry."Document No.";
            Amount := DCLedgEntry.Amount;
            CurrCode := CustLedgEntry."Currency Code"
        END
    end;
}


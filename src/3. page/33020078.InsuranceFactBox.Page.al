page 33020078 "Insurance FactBox"
{
    Caption = 'Insurance Detail';
    PageType = CardPart;
    SourceTable = Table25006033;
    SourceTableView = SORTING(Ending Date)
                      ORDER(Descending)
                      WHERE(Cancelled = CONST(No),
                            Expired = CONST(No));

    layout
    {
        area(content)
        {
            field(DaysToExpire; DaysToExpire)
            {
                Caption = 'Days to Expire';
                Style = Strong;
                StyleExpr = TRUE;
            }
            field("Ins. Company Name"; "Ins. Company Name")
            {
            }
            field("Insurance Policy No."; "Insurance Policy No.")
            {
                Lookup = true;
                TableRelation = "Vehicle Insurance"."Insurance Policy No." WHERE(Insurance Policy No.=FIELD(Insurance Policy No.));
            }
            field("Starting Date"; "Starting Date")
            {
            }
            field("Ending Date"; "Ending Date")
            {
            }
            field("Bill No."; "Bill No.")
            {
            }
            field("Bill Date"; "Bill Date")
            {
            }
            field("Ins. Prem Value (with VAT)"; "Ins. Prem Value (with VAT)")
            {
                Caption = 'Amount Inc. VAT';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        IF "Ending Date" <> 0D THEN
            DaysToExpire := "Ending Date" - TODAY;
    end;

    var
        DaysToExpire: Integer;
}


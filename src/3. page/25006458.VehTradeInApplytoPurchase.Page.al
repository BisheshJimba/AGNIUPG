page 25006458 "Veh.Trade-In Apply to Purchase"
{
    Caption = 'Veh.Trade-In Apply to Purchase';
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group("Vehicle Information")
            {
                Caption = 'Vehicle Information';
                fixed()
                {
                    group(Sales)
                    {
                        Caption = 'Sales';
                        field(SalesLine."Make Code";
                            SalesLine."Make Code")
                        {
                            Caption = 'Make Code';
                        }
                        field(SalesLine."Model Code";
                            SalesLine."Model Code")
                        {
                            Caption = 'Model Code';
                        }
                        field(SalesLine.VIN;
                            SalesLine.VIN)
                        {
                            Caption = 'VIN';
                            Editable = false;
                        }
                    }
                    group(Purchase)
                    {
                        Caption = 'Purchase';
                        field(TradeInMakeCode; TradeInMakeCode)
                        {
                        }
                        field(TradeInModelCode; TradeInModelCode)
                        {
                        }
                        field(TradeInVIN; TradeInVIN)
                        {
                            Caption = 'Vehicle Trade In VIN';
                            Editable = false;
                        }
                    }
                }
            }
            group(Amounts)
            {
                Caption = 'Amounts';
                field(TradeInAmount; TradeInAmount)
                {
                    Caption = 'Trade-In Amount';
                }
            }
        }
    }

    actions
    {
    }

    var
        TradeIn: Record "25006391";
        SalesLine: Record "37";
        TradeInMakeCode: Code[20];
        TradeInModelCode: Code[20];
        TradeInVIN: Text[30];
        TradeInAmount: Decimal;

    [Scope('Internal')]
    procedure SetVariables(TradeIn1: Record "25006391"; SalesLine1: Record "37")
    var
        Vehicle: Record "25006005";
    begin
        SalesLine := SalesLine1;

        TradeIn.RESET;
        TradeIn.SETRANGE("Entry Type", TradeIn1."Entry Type");
        TradeIn.SETRANGE("Vehicle Serial No.", TradeIn1."Vehicle Serial No.");
        TradeIn.SETRANGE("Vehicle Accounting Cycle No.", TradeIn1."Vehicle Accounting Cycle No.");
        IF TradeIn.FINDFIRST THEN
            REPEAT
                TradeInAmount += TradeIn."Amount (LCY)";
            UNTIL TradeIn.NEXT = 0;

        IF Vehicle.GET(TradeIn1."Vehicle Serial No.") THEN;
        TradeInVIN := Vehicle.VIN;
        TradeInMakeCode := Vehicle."Make Code";
        TradeInModelCode := Vehicle."Model Code";
    end;

    [Scope('Internal')]
    procedure GetTradeInAmount(): Decimal
    begin
        EXIT(TradeInAmount);
    end;
}


codeunit 33019833 "Items Analysis Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        TotalOrderQty: Decimal;
        TotalSupplyQty: Decimal;
        FillRate: Decimal;
        FillRateCalcBuffer: Record "33019839";

    [Scope('Internal')]
    procedure CalculateFillRate()
    begin
        TotalOrderQty := 0;
        TotalSupplyQty := 0;
        FillRate := 0;
        FillRateCalcBuffer.RESET;
        IF FillRateCalcBuffer.FINDFIRST THEN BEGIN
            REPEAT
                TotalOrderQty := TotalOrderQty + FillRateCalcBuffer."Ordered Qty.";
                TotalSupplyQty := TotalSupplyQty + FillRateCalcBuffer."Supply Qty.";
            UNTIL FillRateCalcBuffer.NEXT = 0;
            FillRate := (TotalSupplyQty / TotalOrderQty) * 100;
        END;
    end;

    [Scope('Internal')]
    procedure GetOrderQty(): Decimal
    begin
        EXIT(TotalOrderQty);
    end;

    [Scope('Internal')]
    procedure GetSupplyQty(): Decimal
    begin
        EXIT(TotalSupplyQty);
    end;

    [Scope('Internal')]
    procedure GetFillRate(): Decimal
    begin
        EXIT(FillRate);
    end;
}


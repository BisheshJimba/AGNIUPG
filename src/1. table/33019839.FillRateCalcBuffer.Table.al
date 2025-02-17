table 33019839 "Fill Rate Calc Buffer"
{

    fields
    {
        field(1; "Order No."; Code[20])
        {
        }
        field(2; "Item No."; Code[20])
        {
        }
        field(3; "Line No"; Integer)
        {
        }
        field(4; "Item Description"; Text[50])
        {
            CalcFormula = Lookup(Item.Description WHERE(No.=FIELD(Item No.)));
            FieldClass = FlowField;
        }
        field(5;"Ordered Qty.";Decimal)
        {
        }
        field(6;"Supply Qty.";Decimal)
        {

            trigger OnValidate()
            begin
                "Item Value" := "Supply Qty." * Rate;
            end;
        }
        field(7;"Order Date";Date)
        {
        }
        field(8;"Invoice Date";Date)
        {

            trigger OnValidate()
            begin
                IF "Invoice Date" > "Order Date" THEN
                  "Invoice Gap" := "Invoice Date" - "Order Date";
                /*
                ELSE IF "Order Date" > "Invoice Date" THEN
                  ERROR(OrderDateError,"Item No.","Order No.");
                */

            end;
        }
        field(9;"Vendor Invoice No.";Code[20])
        {
        }
        field(10;"Vendor Order No.";Code[20])
        {
        }
        field(11;Rate;Decimal)
        {

            trigger OnValidate()
            begin
                "Item Value" := "Supply Qty." * Rate;
            end;
        }
        field(12;"Invoice Gap";Integer)
        {
            FieldClass = Normal;
        }
        field(13;"Item Value";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Order No.","Item No.","Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        OrderDateError: Label 'Order Date Cannot be Greater than Invoice Date in %1 item of %2 Order.';
        TotalOrderQty: Decimal;
        TotalSupplyQty: Decimal;
        FillRate: Decimal;
        FillRateCalcBuffer: Record "33019839";

    [Scope('Internal')]
    procedure CalculateFillRate()
    begin
        TotalOrderQty := 0;
        TotalSupplyQty := 0;
        RESET;
        IF FINDFIRST THEN BEGIN
          REPEAT
            TotalOrderQty += TotalOrderQty + "Ordered Qty.";
            TotalSupplyQty += TotalSupplyQty + "Supply Qty.";
          UNTIL NEXT = 0;
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


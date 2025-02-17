table 25006192 "Service Order WIP Header"
{
    Caption = 'Service Order WIP Header';
    DataCaptionFields = "Service Order No.";

    fields
    {
        field(20; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
        }
        field(30; "Service Order Date"; Date)
        {
            Caption = 'Service Order Date';
        }
        field(40; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(50; "Sell-to Customer Name"; Text[30])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(60; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(70; "WIP Date"; Date)
        {
            Caption = 'WIP Date';
        }
        field(80; "Item Cost Amt."; Decimal)
        {
            CalcFormula = Sum("Service Order WIP Line"."Recognized Cost Amount" WHERE(Service Order No.=FIELD(Service Order No.),
                                                                                       Type=CONST(Item)));
                Caption = 'Item Cost Amount';
                FieldClass = FlowField;
        }
        field(90; "Item Sales Amt."; Decimal)
        {
            CalcFormula = Sum("Service Order WIP Line"."Recognized Sales Amount" WHERE(Service Order No.=FIELD(Service Order No.),
                                                                                        Type=CONST(Item)));
                Caption = 'Item Sales Amount';
                FieldClass = FlowField;
        }
        field(100; "Labor Cost Amt."; Decimal)
        {
            CalcFormula = Sum("Service Order WIP Line"."Recognized Cost Amount" WHERE(Service Order No.=FIELD(Service Order No.),
                                                                                       Type=CONST(Labor)));
                Caption = 'Labor Cost Amount';
                FieldClass = FlowField;
        }
        field(110; "Labor Sales Amt."; Decimal)
        {
            CalcFormula = Sum("Service Order WIP Line"."Recognized Sales Amount" WHERE(Service Order No.=FIELD(Service Order No.),
                                                                                        Type=CONST(Labor)));
                Caption = 'Labor Sales Amount';
                FieldClass = FlowField;
        }
        field(120; "Ext. S. Cost Amt."; Decimal)
        {
            CalcFormula = Sum("Service Order WIP Line"."Recognized Cost Amount" WHERE(Service Order No.=FIELD(Service Order No.),
                                                                                       Type=CONST(External Service)));
                Caption = 'Ext. Service Cost Amount';
                FieldClass = FlowField;
        }
        field(130; "Ext. S. Sales Amt."; Decimal)
        {
            CalcFormula = Sum("Service Order WIP Line"."Recognized Sales Amount" WHERE(Service Order No.=FIELD(Service Order No.),
                                                                                        Type=CONST(External Service)));
                Caption = 'Ext. Service Sales Amount';
                FieldClass = FlowField;
        }
        field(140; "Total Cost Amt."; Decimal)
        {
            CalcFormula = Sum("Service Order WIP Line"."Recognized Cost Amount" WHERE(Service Order No.=FIELD(Service Order No.)));
                Caption = 'Total Cost Amount';
                FieldClass = FlowField;
        }
        field(150; "Total Sales Amt."; Decimal)
        {
            CalcFormula = Sum("Service Order WIP Line"."Recognized Sales Amount" WHERE(Service Order No.=FIELD(Service Order No.)));
                Caption = 'Total Sales Amount';
                FieldClass = FlowField;
        }
        field(160; "WIP Document No."; Code[20])
        {
            Caption = 'WIP Document No.';
        }
        field(170; "WIP Document No. Series"; Code[10])
        {
            Caption = 'WIP Document No. Series';
        }
        field(180; Amount; Decimal)
        {
            CalcFormula = Sum("Service Order WIP Line".Amount WHERE(Service Order No.=FIELD(Service Order No.)));
                Caption = 'Amount';
                FieldClass = FlowField;
        }
        field(190; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(200; "Bill-to Name"; Text[50])
        {
            Caption = 'Bill-to Name';
        }
        field(210; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(220; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(230; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
        }
        field(240; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';
        }
        field(250; VIN; Code[20])
        {
            Caption = 'VIN';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(260; "Vehicle Registration No."; Code[11])
        {
            Caption = 'Vehicle Registration No.';
        }
        field(270; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(280; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
        }
        field(290;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(300;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
    }

    keys
    {
        key(Key1;"Service Order No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ServiceOrderWIPLine.RESET;
        ServiceOrderWIPLine.SETRANGE("Service Order No.", "Service Order No.");
        ServiceOrderWIPLine.DELETEALL;
    end;

    var
        ServiceOrderWIPLine: Record "25006193";
}


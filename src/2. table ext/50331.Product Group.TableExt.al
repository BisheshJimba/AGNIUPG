tableextension 50331 tableextension50331 extends "Product Group"
{
    // 15.08.2007. EDMS P2
    //   * Added new fields
    //        Date Filter
    //        Global Dimension 1 Filter
    //        Global Dimension 2 Filter
    //        Location Filter
    //        Sales (LCY)
    //        COGS (LCY)
    //        Cost Amount Net Change
    fields
    {
        field(25006671; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(25006672; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(1));
        }
        field(25006673; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE(Global Dimension No.=CONST(2));
        }
        field(25006674; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(25006681; "Sales (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Value Entry"."Sales Amount (Actual)" WHERE(Item Ledger Entry Type=CONST(Sale),
                                                                           Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                           Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Posting Date=FIELD(Date Filter),
                                                                           Item Category Code=FIELD(Item Category Code),
                                                                           Product Group Code=FIELD(Code)));
            Caption = 'Sales (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006682;"COGS (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = -Sum("Value Entry"."Cost Amount (Actual)" WHERE (Item Ledger Entry Type=CONST(Sale),
                                                                           Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                           Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                           Location Code=FIELD(Location Filter),
                                                                           Posting Date=FIELD(Date Filter),
                                                                           Item Category Code=FIELD(Item Category Code),
                                                                           Product Group Code=FIELD(Code)));
            Caption = 'COGS (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006683;"Cost Amount Net Change";Decimal)
        {
            CalcFormula = Sum("Value Entry"."Cost Amount (Actual)" WHERE (Posting Date=FIELD(Date Filter),
                                                                          Location Code=FIELD(Location Filter),
                                                                          Item Category Code=FIELD(Item Category Code),
                                                                          Product Group Code=FIELD(Code)));
            Caption = 'Cost Amount Net Change';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020142;"Vehicle Division";Option)
        {
            OptionCaption = ' ,CVD,PCD';
            OptionMembers = " ",CVD,PCD;
        }
    }
}


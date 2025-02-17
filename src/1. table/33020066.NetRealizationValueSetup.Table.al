table 33020066 "Net Realization Value Setup"
{
    // recItem.RESET;
    // IF LookUpMgt.LookUpModelVersion(recItem,"Model Version",'TATA',"Model Code") THEN
    //   VALIDATE("Model Version",recItem."No.");


    fields
    {
        field(1; "Model Version"; Code[20])
        {
            TableRelation = Item.No. WHERE(Item Type=CONST(Model Version));
        }
        field(2; "Market Price"; Decimal)
        {
        }
        field(3; "Depreciation Rate"; Decimal)
        {
        }
        field(4; Description; Text[50])
        {
            CalcFormula = Lookup(Item.Description WHERE(No.=FIELD(Model Version)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5;"System Sales Price";Decimal)
        {
            CalcFormula = Max("Sales Price"."Unit Price" WHERE (Item No.=FIELD(Model Version),
                                                                Sales Type=CONST(All Customers)));
            Caption = 'System Sales Price w/o VAT';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Sales Price"."Item No." WHERE (Item No.=FIELD(Model Version));
        }
        field(6;"Commission Rate";Decimal)
        {
        }
        field(7;"Model Version No. 2";Code[20])
        {
            CalcFormula = Lookup(Item."No. 2" WHERE (No.=FIELD(Model Version)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Model Version")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        recItem: Record "27";
        LookUpMgt: Codeunit "25006003";
}


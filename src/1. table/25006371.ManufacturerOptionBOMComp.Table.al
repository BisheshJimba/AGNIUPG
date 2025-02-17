table 25006371 "Manufacturer Option BOM Comp."
{
    Caption = 'Manufacturer Option BOM Component';
    DrillDownPageID = 25006452;
    LookupPageID = 25006452;

    fields
    {
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(20; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
        }
        field(25;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Item Type=CONST(Model Version),
                                            Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code));

            trigger OnLookup()
            var
                recItem: Record "27";
            begin
                recItem.SETCURRENTKEY("Item Type","Make Code","Model Code");
                recItem.SETRANGE("Item Type",recItem."Item Type"::"Model Version");
                recItem.SETRANGE("Make Code","Make Code");
                recItem.SETRANGE("Model Code","Model Code");
                IF PAGE.RUNMODAL(PAGE::"Item List",recItem) = ACTION::LookupOK THEN //30.10.2012 EDMS
                 BEGIN
                  "Model Code" := recItem."No.";
                 END;
            end;
        }
        field(30;"Parent Option Code";Code[50])
        {
            Caption = 'Parent Option Code';
            NotBlank = true;
            TableRelation = "Manufacturer Option"."Option Code" WHERE (Make Code=FIELD(Make Code),
                                                                       Model Code=FIELD(Model Code),
                                                                       Model Version No.=FIELD(Model Version No.),
                                                                       Type=CONST(Option));
        }
        field(40;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(45;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(50;"Option Code";Code[50])
        {
            Caption = 'Option Code';
            TableRelation = "Manufacturer Option"."Option Code" WHERE (Make Code=FIELD(Make Code),
                                                                       Model Code=FIELD(Model Code),
                                                                       Model Version No.=FIELD(Model Version No.),
                                                                       Type=FIELD(Type));
        }
        field(60;"Bill of Materials";Boolean)
        {
            CalcFormula = Exist("Manufacturer Option BOM Comp." WHERE (Make Code=FIELD(Make Code),
                                                                       Model Code=FIELD(Model Code),
                                                                       Model Version No.=FIELD(Model Version No.),
                                                                       Parent Option Code=FIELD(Option Code)));
            Caption = 'Bill of Materials';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70;Description;Text[30])
        {
            Caption = 'Description';
        }
        field(80;"BOM Description";Text[30])
        {
            Caption = 'BOM Description';
            Editable = false;
            Enabled = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Make Code","Model Code","Model Version No.","Parent Option Code","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


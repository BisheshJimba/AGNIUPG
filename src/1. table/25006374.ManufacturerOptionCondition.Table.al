table 25006374 "Manufacturer Option Condition"
{
    // 11.04.2013 EDMS P8
    //   * added field Type. That field added to primary code.

    Caption = 'Manufacturer Option Condition';

    fields
    {
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            begin
                IF ("Make Code" <> xRec."Make Code") AND (xRec."Make Code" <> '') AND
                   ("Condition Option Code" <> '') AND ("Option Code" <> '')
                THEN BEGIN
                    DeleteConnectiveEntries(xRec."Make Code", "Model Code", "Model Version No.",
                                            "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                    CreateConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                            "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                END;
            end;
        }
        field(20; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));

            trigger OnValidate()
            begin
                IF ("Model Code" <> xRec."Model Code") AND (xRec."Model Code"<>'') AND
                   ("Condition Option Code" <> '') AND ("Option Code" <> '')
                THEN BEGIN
                  DeleteConnectiveEntries("Make Code", xRec."Model Code", "Model Version No.",
                                          "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                  CreateConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                          "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                END;
            end;
        }
        field(25;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Item Type=CONST(Model Version),
                                            Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code));

            trigger OnLookup()
            var
                Item: Record "27";
            begin
                Item.SETCURRENTKEY("Item Type","Make Code","Model Code");
                Item.SETRANGE("Item Type",Item."Item Type"::"Model Version");
                Item.SETRANGE("Make Code","Make Code");
                Item.SETRANGE("Model Code","Model Code");
                IF PAGE.RUNMODAL(PAGE::"Item List",Item) = ACTION::LookupOK THEN //30.10.2012 EDMS
                 BEGIN
                  "Model Code" := Item."No.";
                 END;
            end;

            trigger OnValidate()
            begin
                IF ("Model Version No." <> xRec."Model Version No.") AND (xRec."Model Version No."<>'') AND
                   ("Condition Option Code" <> '') AND ("Option Code" <> '')
                THEN BEGIN
                  DeleteConnectiveEntries("Make Code", "Model Code", xRec."Model Version No.",
                                          "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                  CreateConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                          "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                END;
            end;
        }
        field(26;"Option Type";Option)
        {
            Caption = 'Option Type';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(30;"Option Code";Code[50])
        {
            Caption = 'Option Code';
            TableRelation = "Manufacturer Option"."Option Code" WHERE (Make Code=FIELD(Make Code),
                                                                       Model Code=FIELD(Model Code),
                                                                       Model Version No.=FIELD(Model Version No.),
                                                                       Type=FIELD(Option Type));

            trigger OnValidate()
            begin
                IF ("Option Code" <> xRec."Option Code") AND (xRec."Option Code"<>'') AND
                   ("Condition Option Code" <> '') AND ("Option Code" <> '')
                THEN BEGIN
                  DeleteConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                          "Condition Option Type", "Condition Option Code", "Condition Type", xRec."Option Type", xRec."Option Code");
                  CreateConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                          "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                END;
            end;
        }
        field(35;"Option Description";Text[250])
        {
            CalcFormula = Lookup("Manufacturer Option".Description WHERE (Make Code=FIELD(Make Code),
                                                                          Model Code=FIELD(Model Code),
                                                                          Model Version No.=FIELD(Model Version No.),
                                                                          Option Code=FIELD(Option Code)));
            Caption = 'Option Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(50;"Option External Code";Code[20])
        {
            CalcFormula = Lookup("Manufacturer Option"."External Code" WHERE (Make Code=FIELD(Make Code),
                                                                              Model Code=FIELD(Model Code),
                                                                              Model Version No.=FIELD(Model Version No.)));
            Caption = 'Option External Code';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70;"Condition Type";Option)
        {
            Caption = 'Condition Type';
            OptionCaption = 'Only with,Not with';
            OptionMembers = "Only with","Not with";

            trigger OnValidate()
            begin
                IF ("Condition Type" <> xRec."Condition Type") AND
                   ("Condition Option Code" <> '') AND ("Option Code" <> '')
                THEN BEGIN
                  DeleteConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                          "Condition Option Type", "Condition Option Code", xRec."Condition Type", "Option Type", "Option Code");
                  CreateConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                          "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                END;
            end;
        }
        field(76;"Condition Option Type";Option)
        {
            Caption = 'Condition Option Type';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(80;"Condition Option Code";Code[20])
        {
            Caption = 'Condition Option Code';
            TableRelation = "Manufacturer Option"."Option Code" WHERE (Make Code=FIELD(Make Code),
                                                                       Model Code=FIELD(Model Code),
                                                                       Model Version No.=FIELD(Model Version No.));

            trigger OnValidate()
            var
                ManufacturerOptionCondition: Record "25006374";
            begin
                IF ("Condition Option Code" <> xRec."Condition Option Code") AND
                   ("Condition Option Code" <> '') AND ("Option Code" <> '')
                THEN BEGIN
                  DeleteConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                          xRec."Condition Option Type", xRec."Condition Option Code", "Condition Type", "Option Type", "Option Code");
                  CreateConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                          "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
                END;
            end;
        }
        field(85;"Condition Option Description";Text[250])
        {
            CalcFormula = Lookup("Manufacturer Option".Description WHERE (Make Code=FIELD(Make Code),
                                                                          Model Code=FIELD(Model Code),
                                                                          Model Version No.=FIELD(Model Version No.),
                                                                          Option Code=FIELD(Condition Option Code)));
            Caption = 'Condition Option Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Make Code","Model Code","Model Version No.","Option Type","Option Code","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        DeleteConnectiveEntries("Make Code", "Model Code", "Model Version No.",
                                "Condition Option Type", "Condition Option Code", "Condition Type", "Option Type", "Option Code");
    end;

    [Scope('Internal')]
    procedure CreateConnectiveEntries(MakeCode: Code[20];ModelCode: Code[20];ModelVersionNo: Code[20];OptionType: Integer;OptionCode: Code[20];ConditionType: Integer;ConditionOptionType: Integer;ConditionOptionCode: Code[20])
    var
        Condition: Record "25006374";
        LineNo: Integer;
    begin
        IF ConditionType <> "Condition Type"::"Not with" THEN
          EXIT;
        Condition.RESET;
        Condition.SETRANGE("Make Code", MakeCode);
        Condition.SETRANGE("Model Code", ModelCode);
        Condition.SETRANGE("Model Version No.", ModelVersionNo);
        Condition.SETRANGE("Option Type", OptionType);
        Condition.SETRANGE("Option Code", OptionCode);
        IF Condition.FINDLAST THEN
          LineNo := Condition."Line No." + 10000
        ELSE
          LineNo := 10000;

        Condition.INIT;
        Condition."Make Code" := MakeCode;
        Condition."Model Code" := ModelCode;
        Condition."Model Version No." := ModelVersionNo;
        Condition."Option Type" := OptionType;
        Condition."Option Code" := OptionCode;
        Condition."Line No." := LineNo;
        Condition."Condition Type" := ConditionType;
        Condition."Condition Option Type" := ConditionOptionType;
        Condition."Condition Option Code" := ConditionOptionCode;
        IF Condition.INSERT THEN;
    end;

    [Scope('Internal')]
    procedure DeleteConnectiveEntries(MakeCode: Code[20];ModelCode: Code[20];ModelVersionNo: Code[20];OptionType: Integer;OptionCode: Code[20];ConditionType: Integer;ConditionOptionType: Integer;ConditionOptionCode: Code[20])
    var
        Condition: Record "25006374";
    begin
        Condition.SETRANGE("Make Code", MakeCode);
        Condition.SETRANGE("Model Code", ModelCode);
        Condition.SETRANGE("Model Version No.", ModelVersionNo);
        Condition.SETRANGE("Option Type", OptionType);
        Condition.SETRANGE("Option Code", OptionCode);
        Condition.SETRANGE("Condition Type", ConditionType);
        Condition.SETRANGE("Condition Option Type", ConditionOptionType);
        Condition.SETRANGE("Condition Option Code", ConditionOptionCode);
        Condition.DELETEALL;
    end;
}


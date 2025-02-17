table 25006370 "Manufacturer Option"
{
    // 30.05.2013 Elva Baltic P15
    //   * Option Code - Upholstery: "Vehicle Interior" table using instead of "Interior Upholstery"

    Caption = 'Manufacturer Option';
    DrillDownPageID = 25006450;
    LookupPageID = 25006450;

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
        field(23;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Item Type=CONST(Model Version),
                                            Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code));

            trigger OnLookup()
            var
                Item: Record "27";
                LookUpMgt: Codeunit "25006003";
            begin
                Item.RESET;
                IF LookUpMgt.LookUpModelVersion(Item,"Model Version No.","Make Code","Model Code") THEN
                 VALIDATE("Model Version No.",Item."No.")
            end;
        }
        field(30;"Option Code";Code[50])
        {
            Caption = 'Option Code';
            NotBlank = true;
            TableRelation = IF (Type=CONST(Color)) "Body Color".Code WHERE (Make Code=FIELD(Make Code))
                            ELSE IF (Type=CONST(Upholstery)) "Vehicle Interior".Code WHERE (Make Code=FIELD(Make Code));

            trigger OnLookup()
            var
                ExteriorColor: Record "25006032";
                VehicleInterior: Record "25006052";
            begin
                CASE Type OF
                  Type::Option:
                    BEGIN

                    END;
                  Type::Color:
                    BEGIN
                      ExteriorColor.SETRANGE("Make Code","Make Code");
                      IF PAGE.RUNMODAL(PAGE::"Body Colors",ExteriorColor) = ACTION::LookupOK THEN
                        VALIDATE("Option Code",ExteriorColor.Code);
                    END;
                  Type::Upholstery:
                    BEGIN
                      //30.05.2013 Elva Baltic P15 >>
                      VehicleInterior.SETRANGE("Make Code","Make Code");
                      IF PAGE.RUNMODAL(PAGE::"Vehicle Interiors",VehicleInterior) = ACTION::LookupOK THEN
                        VALIDATE("Option Code",VehicleInterior.Code);

                      //30.05.2013 Elva Baltic P15 <<
                    END;
                END;
            end;

            trigger OnValidate()
            var
                recExteriorColor: Record "25006032";
                recInteriorUpholstery: Record "25006020";
            begin
                IF Standard THEN BEGIN
                  NoSeriesMgt.TestManual("No. Series");
                END ELSE BEGIN
                  "External Code" := "Option Code";
                END;
            end;
        }
        field(40;"External Code";Code[50])
        {
            Caption = 'External Code';
        }
        field(50;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(60;Standard;Boolean)
        {
            Caption = 'Standard';

            trigger OnValidate()
            var
                Make: Record "25006000";
                MakeSetup: Record "25006050";
            begin
                IF Standard AND ("Make Code" <> '') AND (Type = Type::Option) THEN BEGIN
                 IF MakeSetup.GET("Make Code") THEN
                  IF "Option Code" = '' THEN BEGIN
                    "No. Series" := MakeSetup."Standard Option Nos.";
                    NoSeriesMgt.InitSeries("No. Series","No. Series",WORKDATE,"Option Code","No. Series");
                  END;
                END;
            end;
        }
        field(70;"Bill of Materials";Boolean)
        {
            CalcFormula = Exist("Manufacturer Option BOM Comp." WHERE (Make Code=FIELD(Make Code),
                                                                       Model Code=FIELD(Model Code),
                                                                       Model Version No.=FIELD(Model Version No.),
                                                                       Parent Option Code=FIELD(Option Code)));
            Caption = 'Bill of Materials';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80;Description;Text[250])
        {
            Caption = 'Description';
        }
        field(90;"Description 2";Text[250])
        {
            Caption = 'Description 2';
        }
        field(100;"Class Code";Code[10])
        {
            Caption = 'Class Code';
            TableRelation = "Option Class".Code WHERE (Make Code=FIELD(Make Code));
        }
        field(110;"Starting Date";Date)
        {
            Caption = 'Starting Date';
        }
        field(120;"Ending Date";Date)
        {
            Caption = 'Ending Date';
        }
        field(140;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series".Code;
        }
        field(160;Condition;Boolean)
        {
            CalcFormula = Exist("Manufacturer Option Condition" WHERE (Make Code=FIELD(Make Code),
                                                                       Model Code=FIELD(Model Code),
                                                                       Model Version No.=FIELD(Model Version No.),
                                                                       Option Code=FIELD(Option Code)));
            Caption = 'Condition';
            Editable = false;
            FieldClass = FlowField;
        }
        field(170;Exclude;Boolean)
        {
            Caption = 'Exclude';
        }
    }

    keys
    {
        key(Key1;"Make Code","Model Code","Model Version No.",Type,"Option Code")
        {
            Clustered = true;
        }
        key(Key2;Standard)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        OptionSalesPrice: Record "25006382";
        OptionSaleDiscount: Record "25006376";
    begin
        OptionSalesPrice.RESET;
        OptionSalesPrice.SETRANGE("Make Code", "Make Code");
        OptionSalesPrice.SETRANGE("Model Code", "Model Code");
        OptionSalesPrice.SETRANGE("Model Version No.", "Model Version No.");
        OptionSalesPrice.SETRANGE("Option Type", OptionSalesPrice."Option Type"::"Manufacturer Option");
        OptionSalesPrice.SETRANGE("Option Code", "Option Code");
        OptionSalesPrice.DELETEALL(TRUE);

        OptionSaleDiscount.RESET;
        OptionSaleDiscount.SETRANGE("Make Code", "Make Code");
        OptionSaleDiscount.SETRANGE("Model Code", "Model Code");
        OptionSaleDiscount.SETRANGE("Model Version No.", "Model Version No.");
        OptionSaleDiscount.SETRANGE("Option Type", OptionSaleDiscount."Option Type"::"Manufacturer Option");
        OptionSaleDiscount.SETRANGE("Option Code", "Option Code");
        OptionSaleDiscount.DELETEALL(TRUE);
    end;

    var
        NoSeriesMgt: Codeunit "396";

    [Scope('Internal')]
    procedure GetCurrentPrice() CurrPrice: Decimal
    var
        OptionSalesPrice: Record "25006382";
    begin
        OptionSalesPrice.RESET;
        OptionSalesPrice.SETRANGE("Option Code","Option Code");
        OptionSalesPrice.SETRANGE("Sales Type",OptionSalesPrice."Sales Type"::"All Customers");
        OptionSalesPrice.SETFILTER("Starting Date", '<=%1', WORKDATE);
        OptionSalesPrice.SETFILTER("Ending Date", '''''|>=%1', WORKDATE);
        IF OptionSalesPrice.FINDLAST THEN
          CurrPrice := OptionSalesPrice."Unit Price";
    end;
}


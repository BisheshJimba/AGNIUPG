table 25006375 "Option Translation"
{
    // 11.04.2013 EDMS P8
    //   * added field 'Option Subtype', to primary as well

    Caption = 'Option Translation';
    LookupPageID = 25006530;

    fields
    {
        field(10; "Option Type"; Option)
        {
            Caption = 'Option Type';
            OptionCaption = 'Manufacturer Option,Own Option';
            OptionMembers = "Manufacturer Option","Own Option","Vehicle Base";
        }
        field(20; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(30; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
        }
        field(40;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';

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
        field(45;"Option Subtype";Option)
        {
            Caption = 'Option Subtype';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(50;"Option Code";Code[50])
        {
            Caption = 'Option Code';
            TableRelation = IF (Option Type=CONST(Manufacturer Option)) "Manufacturer Option"."Option Code" WHERE (Make Code=FIELD(Make Code),
                                                                                                                   Model Code=FIELD(Model Code),
                                                                                                                   Model Version No.=FIELD(Model Version No.),
                                                                                                                   Type=FIELD(Option Subtype))
                                                                                                                   ELSE IF (Option Type=CONST(Vehicle Base)) Item.No. WHERE (Item Type=CONST(Model Version))
                                                                                                                   ELSE IF (Option Type=CONST(Own Option)) "Own Option"."Option Code" WHERE (Make Code=FIELD(Make Code),
                                                                                                                                                                                             Model Code=FIELD(Model Code));
        }
        field(200;"Language Code";Code[10])
        {
            Caption = 'Language Code';
            NotBlank = true;
            TableRelation = Language;
        }
        field(300;Description;Text[250])
        {
            Caption = 'Description';
        }
        field(400;"Description 2";Text[250])
        {
            Caption = 'Description 2';
        }
    }

    keys
    {
        key(Key1;"Option Type","Make Code","Model Code","Model Version No.","Option Subtype","Option Code","Language Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TESTFIELD("Make Code");
        TESTFIELD("Model Code");
        IF "Option Type" = "Option Type"::"Manufacturer Option" THEN
         TESTFIELD("Model Version No.");
        TESTFIELD("Option Code");
        TESTFIELD("Language Code");
    end;
}


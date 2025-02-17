table 25006755 "Item Vehicle Model"
{
    Caption = 'Item Vehicle Model';
    LookupPageID = 25006857;

    fields
    {
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Item,Nonstock Item';
            OptionMembers = Item,"Nonstock Item";
        }
        field(10; "No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Nonstock Item)) "Nonstock Item";
        }
        field(20; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(30; "Model No."; Code[30])
        {
            Caption = 'Model No.';
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make Code));
        }
        field(40;"External Code";Code[20])
        {
            Caption = 'External Code';
        }
        field(33019831;Quantity;Integer)
        {
        }
        field(33019832;"Model Version";Code[20])
        {
            TableRelation = Item.No. WHERE (Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model No.),
                                            Item Type=FILTER(Model Version));
        }
    }

    keys
    {
        key(Key1;Type,"No.","Make Code","Model No.","External Code")
        {
            Clustered = true;
        }
        key(Key2;Type,"Make Code","Model No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        DeleteModelFilter;
    end;

    trigger OnInsert()
    begin
        UpdateModelFilter;
    end;

    trigger OnRename()
    begin
        ModifyModelFilter
    end;

    var
        Item: Record "27";

    [Scope('Internal')]
    procedure UpdateModelFilter()
    begin
        Item.RESET;
        Item.SETCURRENTKEY("No.");
        Item.SETRANGE("No.","No.");
        IF Item.FINDFIRST THEN BEGIN
          IF (Item."Model Filter 1" <>'') AND (STRLEN(Item."Model Filter 1") < 230) THEN BEGIN
            IF STRPOS(Item."Model Filter 1",'|'+"Model No.") =0 THEN
              Item."Model Filter 1" := Item."Model Filter 1"+'|'+"Model No."
          END
          ELSE IF Item."Model Filter 1" = '' THEN
            Item."Model Filter 1" := "Model No."
          ELSE IF (Item."Model Filter 2" <>'') AND (STRLEN(Item."Model Filter 2") < 230) THEN BEGIN
            IF STRPOS(Item."Model Filter 2",'|'+"Model No.") =0 THEN
              Item."Model Filter 2" := Item."Model Filter 2"+'|'+"Model No."
          END
          ELSE IF Item."Model Filter 2" = '' THEN
            Item."Model Filter 2" := "Model No."
        END;
        Item.MODIFY;
    end;

    [Scope('Internal')]
    procedure DeleteModelFilter()
    var
        TempModelFilter1: Code[250];
        TempModelFilter2: Code[250];
    begin
        Item.RESET;
        Item.SETCURRENTKEY("No.");
        Item.SETRANGE("No.","No.");
        IF Item.FINDFIRST THEN BEGIN
          IF STRPOS(Item."Model Filter 1",'|'+"Model No.") <> 0 THEN BEGIN
            TempModelFilter1 := DELSTR(Item."Model Filter 1",STRPOS(Item."Model Filter 1",'|'+"Model No."),
                                       STRLEN('|'+"Model No."));
            Item."Model Filter 1" := TempModelFilter1;
            Item.MODIFY;
          END;
          IF STRPOS(Item."Model Filter 2",'|'+"Model No.") <> 0 THEN BEGIN
            TempModelFilter2 := DELSTR(Item."Model Filter 2",STRPOS(Item."Model Filter 2",'|'+"Model No."),
                                       STRLEN('|'+"Model No."));
            Item."Model Filter 2" := TempModelFilter2;
            Item.MODIFY;
          END;
        END;
    end;

    [Scope('Internal')]
    procedure ModifyModelFilter()
    var
        TempModelFilter1: Code[250];
        TempModelFilter2: Code[250];
    begin
        Item.RESET;
        Item.SETCURRENTKEY("No.");
        Item.SETRANGE("No.","No.");
        IF Item.FINDFIRST THEN BEGIN
          IF STRPOS(Item."Model Filter 1",'|'+xRec."Model No.") <> 0 THEN BEGIN
            TempModelFilter1 := DELSTR(Item."Model Filter 1",STRPOS(Item."Model Filter 1",'|'+xRec."Model No."),
                                       STRLEN('|'+xRec."Model No."));
            Item."Model Filter 1" := TempModelFilter1;
            Item.MODIFY;
          END;
          IF STRPOS(Item."Model Filter 2",'|'+xRec."Model No.") <> 0 THEN BEGIN
            TempModelFilter2 := DELSTR(Item."Model Filter 2",STRPOS(Item."Model Filter 2",'|'+xRec."Model No."),
                                       STRLEN('|'+xRec."Model No."));
            Item."Model Filter 2" := TempModelFilter2;
            Item.MODIFY;
          END;
        END;
        UpdateModelFilter;
    end;

    [Scope('Internal')]
    procedure CheckModelConsistency(MakeCode: Code[20];ModelCode: Code[20]): Boolean
    var
        Model: Record "25006001";
    begin
        Model.RESET;
        Model.SETCURRENTKEY("Make Code",Code);
        Model.SETRANGE("Make Code",MakeCode);
        Model.SETRANGE(Code,ModelCode);
        IF Model.FINDFIRST THEN
          EXIT(TRUE)
        ELSE
          EXIT(FALSE);
    end;
}


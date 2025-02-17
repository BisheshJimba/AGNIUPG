table 25006769 "Item Group Default Dimension"
{
    // 
    // 05.06.2015 EB.P21 #T0047
    //   Added "Dimension Code" to primary key
    // 
    // 10.05.2007 EDMS P2
    //   * Added fields: "Product Group Code" and "Product Subgroup Code"
    //   * Changed primary key
    //   * Added function "FillItemCategoryDim"

    Caption = 'Item Group Default Dimension';

    fields
    {
        field(10; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(15; "Product Group Code"; Code[20])
        {
            Caption = 'Product Group Code';
            TableRelation = "Product Group".Code WHERE(Item Category Code=FIELD(Item Category Code));
        }
        field(17; "Product Subgroup Code"; Code[20])
        {
            Caption = 'Product Subgroup Code';
            TableRelation = "Product Subgroup".Code WHERE(Item Category Code=FIELD(Item Category Code));
        }
        field(20; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            TableRelation = Dimension;
        }
        field(30; "Dimension Value Code"; Code[20])
        {
            Caption = 'Dimension Value Code';
            TableRelation = "Dimension Value".Code WHERE(Dimension Code=FIELD(Dimension Code));
        }
    }

    keys
    {
        key(Key1;"Item Category Code","Product Group Code","Product Subgroup Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('Internal')]
    procedure FillItemCategoryDim(Item: Record "27";Item2: Record "27")
    var
        recDefDim: Record "352";
        recInvSetup: Record "313";
    begin
        recInvSetup.GET;
        IF NOT recInvSetup."Fill Item Group Def. Dimension" THEN
         EXIT;

        IF GET(Item2."Item Category Code", Item2."Product Group Code", Item2."Product Subgroup Code")
          AND ("Dimension Value Code" <> '')THEN
           BEGIN
            recDefDim.RESET;
            recDefDim.SETRANGE("Table ID",DATABASE::Item);
            recDefDim.SETRANGE("No.",Item2."No.");
            recDefDim.SETRANGE("Dimension Code","Dimension Code");
            IF recDefDim.FINDSET THEN
              recDefDim.DELETE;
           END;

        IF (NOT GET(Item."Item Category Code", Item."Product Group Code", Item."Product Subgroup Code"))
          OR ("Dimension Value Code" = '') THEN
            EXIT;

        recDefDim.RESET;
        recDefDim.SETRANGE("Table ID",DATABASE::Item);
        recDefDim.SETRANGE("No.",Item."No.");
        recDefDim.SETRANGE("Dimension Code","Dimension Code");
        IF recDefDim.FINDSET THEN
         BEGIN
          recDefDim."Dimension Value Code" := "Dimension Value Code";
          recDefDim."Value Posting":=recDefDim."Value Posting"::" ";
          recDefDim.MODIFY;
         END
        ELSE
         BEGIN
          recDefDim.INIT;
          recDefDim."Table ID":=DATABASE::Item;
          recDefDim."No.":=Item."No.";
          recDefDim."Dimension Code":="Dimension Code";
          recDefDim."Dimension Value Code":="Dimension Value Code";
          recDefDim."Value Posting":=recDefDim."Value Posting"::" ";
          recDefDim.INSERT;
         END;
    end;
}


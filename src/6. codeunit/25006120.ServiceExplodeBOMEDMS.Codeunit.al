codeunit 25006120 "Service-Explode BOM EDMS"
{
    TableNo = 25006146;

    trigger OnRun()
    var
        DimMgt: Codeunit "408";
        Selection: Integer;
    begin
        Rec.TESTFIELD(Type, Type::Item);

        IF "Purch. Order Line No." <> 0 THEN
            ERROR(
              Text000,
              "Purchase Order No.");

        ServiceHeader.GET(Rec."Document Type", Rec."Document No.");
        ServiceHeader.TESTFIELD(Status, ServiceHeader.Status::Open);
        FromBOMComp.SETRANGE("Parent Item No.", "No.");
        NoOfBOMComp := FromBOMComp.COUNT;
        IF NoOfBOMComp = 0 THEN
            ERROR(
              Text001,
              "No.");

        Selection := STRMENU(Text004, 2);
        IF Selection = 0 THEN
            EXIT;

        ToServLine.RESET;
        ToServLine.SETRANGE("Document Type", Rec."Document Type");
        ToServLine.SETRANGE("Document No.", Rec."Document No.");
        ToServLine := Rec;
        IF ToServLine.FIND('>') THEN BEGIN
            LineSpacing := (ToServLine."Line No." - "Line No.") DIV (1 + NoOfBOMComp);
            IF LineSpacing = 0 THEN
                ERROR(Text003);
        END ELSE
            LineSpacing := 10000;

        IF Rec."Document Type" IN [Rec."Document Type"::Order] THEN BEGIN
            ToServLine := Rec;
            FromBOMComp.SETRANGE(Type, FromBOMComp.Type::Item);
            FromBOMComp.SETFILTER("No.", '<>%1', '');
            IF FromBOMComp.FINDSET THEN
                REPEAT
                    FromBOMComp.TESTFIELD(Type, FromBOMComp.Type::Item);
                    Item.GET(FromBOMComp."No.");
                    ToServLine."Line No." := 0;
                    ToServLine."No." := FromBOMComp."No.";
                    ToServLine."Variant Code" := FromBOMComp."Variant Code";
                    ToServLine."Unit of Measure Code" := FromBOMComp."Unit of Measure Code";
                    ToServLine."Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, FromBOMComp."Unit of Measure Code");
                UNTIL FromBOMComp.NEXT = 0;
        END;

        IF "BOM Item No." = '' THEN
            BOMItemNo := "No."
        ELSE
            BOMItemNo := "BOM Item No.";

        ToServLine := Rec;
        ToServLine.INIT;
        ToServLine.Description := Description;
        ToServLine."Description 2" := "Description 2";
        ToServLine."BOM Item No." := BOMItemNo;
        ToServLine.MODIFY;

        FromBOMComp.RESET;
        FromBOMComp.SETRANGE("Parent Item No.", "No.");
        FromBOMComp.SETFILTER(Type, '<>%1', FromBOMComp.Type::Resource); //Temporary, until service don't work with resources
        FromBOMComp.FINDSET;
        NextLineNo := "Line No.";
        REPEAT
            ToServLine.INIT;
            NextLineNo := NextLineNo + LineSpacing;
            ToServLine."Line No." := NextLineNo;
            CASE FromBOMComp.Type OF
                FromBOMComp.Type::" ":
                    ToServLine.Type := ToServLine.Type::" ";
                FromBOMComp.Type::Item:
                    ToServLine.Type := ToServLine.Type::Item;
            // FromBOMComp.Type::Resource:
            // ToServLine.Type := ToServLine.Type::Resource;
            END;
            IF ToServLine.Type <> ToServLine.Type::" " THEN BEGIN
                FromBOMComp.TESTFIELD("No.");
                ToServLine.VALIDATE("No.", FromBOMComp."No.");
                IF ServiceHeader."Location Code" <> "Location Code" THEN
                    ToServLine.VALIDATE("Location Code", "Location Code");
                IF FromBOMComp."Variant Code" <> '' THEN
                    ToServLine.VALIDATE("Variant Code", FromBOMComp."Variant Code");
                IF ToServLine.Type = ToServLine.Type::Item THEN BEGIN
                    ToServLine."Drop Shipment" := "Drop Shipment";
                    Item.GET(FromBOMComp."No.");
                    ToServLine.VALIDATE(Quantity,
                      ROUND(
                        "Quantity (Base)" * FromBOMComp."Quantity per" *
                        UOMMgt.GetQtyPerUnitOfMeasure(Item, FromBOMComp."Unit of Measure Code") /
                        ToServLine."Qty. per Unit of Measure",
                        0.00001));
                END ELSE
                    ToServLine.VALIDATE(Quantity, "Quantity (Base)" * FromBOMComp."Quantity per");

            END;
            IF ServiceHeader."Language Code" = '' THEN
                ToServLine.Description := FromBOMComp.Description
            ELSE
                IF NOT ItemTranslation.GET(FromBOMComp."No.", FromBOMComp."Variant Code", ServiceHeader."Language Code") THEN
                    ToServLine.Description := FromBOMComp.Description;

            ToServLine."BOM Item No." := BOMItemNo;
            ToServLine.INSERT;

            IF Selection = 1 THEN BEGIN
                ToServLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                ToServLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                ToServLine.MODIFY;


            END;
        UNTIL FromBOMComp.NEXT = 0;
    end;

    var
        Text000: Label 'The BOM cannot be exploded on the sales lines because it is associated with purchase order %1.';
        Text001: Label 'Item %1 is not a bill of materials.';
        Text003: Label 'There is not enough space to explode the BOM.';
        Text004: Label '&Copy dimensions from BOM,&Retrieve dimensions from components';
        ToServLine: Record "25006146";
        FromBOMComp: Record "90";
        ServiceHeader: Record "25006145";
        ItemTranslation: Record "30";
        Item: Record "27";
        UOMMgt: Codeunit "5402";
        BOMItemNo: Code[20];
        LineSpacing: Integer;
        NextLineNo: Integer;
        NoOfBOMComp: Integer;
}


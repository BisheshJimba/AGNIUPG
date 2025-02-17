codeunit 25006513 "Item Substitution Sync"
{
    // 28.08.2014 EDMS P8
    //   * Use of new page "Item Replacement Overview"
    // 
    // 03.04.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Added func: ShowReplacementOverview
    // 
    // 26.03.2014 Elva baltic P15 #F124 MMG7.00
    //   * Added Func: GetNextReplacementNo
    // 
    // 08.04.2008. EDMS P2
    //   * Added code InsertItemSub
    // 
    // 16.10.2007. EDMS P2
    //   * Created


    trigger OnRun()
    begin
    end;

    var
        ItemSync: Record "27";
        ItemSync2: Record "27";
        NonstockItemSync: Record "5718";
        NonstockItemSync2: Record "5718";
        ItemSubSync: Record "5715";
        ItemSubSync2: Record "5715";
        SubContentSync: Record "5716";
        SubContentSync2: Record "5716";
        ChooseReplacementTxt: Label 'Please choose the replacement condition group:';
        SalesSetup: Record "311";
        ReplaceInfoTxt: Label 'Item %1 replaced by %2';
        ReplaceConfirmInvTxt: Label 'Item %1 is in inventory. Would you like to apply replacements?';
        ServiceSetup: Record "25006120";
        PurchaseSetup: Record "312";

    [Scope('Internal')]
    procedure InsertItemSub(ItemSub: Record "5715")
    begin
        ItemSubSync.DontDeleteInterchangeableItem; //08.04.2008. EDMS P2
        IF (ItemSub.Type = ItemSub.Type::Item) AND (ItemSub."Substitute Type" = ItemSub."Substitute Type"::Item) THEN BEGIN
            NonstockItemSync.RESET;
            NonstockItemSync2.RESET;
            NonstockItemSync.SETCURRENTKEY("Item No.");
            NonstockItemSync2.SETCURRENTKEY("Item No.");
            NonstockItemSync.SETRANGE("Item No.", ItemSub."No.");
            NonstockItemSync2.SETRANGE("Item No.", ItemSub."Substitute No.");
            IF NonstockItemSync.FINDFIRST AND NonstockItemSync2.FINDFIRST THEN BEGIN
                ItemSubSync.Type := ItemSubSync.Type::"Nonstock Item";
                ItemSubSync."No." := NonstockItemSync."Entry No.";
                ItemSubSync."Substitute Type" := ItemSubSync."Substitute Type"::"Nonstock Item";
                ItemSubSync."Substitute No." := NonstockItemSync2."Entry No.";
                IF ItemSubSync.FIND THEN
                    EXIT;

                ItemSubSync.INIT;
                ItemSubSync.TRANSFERFIELDS(ItemSub);
                ItemSubSync.VALIDATE(Type, ItemSubSync.Type::"Nonstock Item");
                ItemSubSync.VALIDATE("No.", NonstockItemSync."Entry No.");
                ItemSubSync.VALIDATE("Substitute Type", ItemSubSync."Substitute Type"::"Nonstock Item");
                ItemSubSync.VALIDATE("Substitute No.", NonstockItemSync2."Entry No.");
                ItemSubSync.Interchangeable := ItemSub.Interchangeable;
                ItemSubSync.INSERT;
            END;
        END;

        IF (ItemSub.Type = ItemSub.Type::"Nonstock Item") AND
           (ItemSub."Substitute Type" = ItemSub."Substitute Type"::"Nonstock Item")
        THEN BEGIN
            NonstockItemSync.GET(ItemSub."No.");
            NonstockItemSync2.GET(ItemSub."Substitute No.");
            IF ItemSync.GET(NonstockItemSync."Item No.") AND ItemSync2.GET(NonstockItemSync2."Item No.") THEN BEGIN
                ItemSubSync.Type := ItemSubSync.Type::Item;
                ItemSubSync."No." := ItemSync."No.";
                ItemSubSync."Substitute Type" := ItemSubSync."Substitute Type"::Item;
                ItemSubSync."Substitute No." := ItemSync2."No.";
                IF ItemSubSync.FIND THEN
                    EXIT;

                ItemSubSync.INIT;
                ItemSubSync.TRANSFERFIELDS(ItemSub);
                ItemSubSync.VALIDATE(Type, ItemSubSync.Type::Item);
                ItemSubSync.VALIDATE("No.", ItemSync."No.");
                ItemSubSync.VALIDATE("Substitute Type", ItemSubSync."Substitute Type"::Item);
                ItemSubSync.VALIDATE("Substitute No.", ItemSync2."No.");
                ItemSubSync.Interchangeable := ItemSub.Interchangeable;
                ItemSubSync.INSERT;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure ModifyItemSub(ItemSub: Record "5715")
    begin
        IF (ItemSub.Type = ItemSub.Type::Item) AND (ItemSub."Substitute Type" = ItemSub."Substitute Type"::Item) THEN BEGIN
            NonstockItemSync.RESET;
            NonstockItemSync2.RESET;
            NonstockItemSync.SETCURRENTKEY("Item No.");
            NonstockItemSync2.SETCURRENTKEY("Item No.");
            NonstockItemSync.SETRANGE("Item No.", ItemSub."No.");
            NonstockItemSync2.SETRANGE("Item No.", ItemSub."Substitute No.");
            IF NonstockItemSync.FINDFIRST AND NonstockItemSync2.FINDFIRST THEN BEGIN
                ItemSubSync.Type := ItemSubSync.Type::"Nonstock Item";
                ItemSubSync."No." := NonstockItemSync."Entry No.";
                ItemSubSync."Substitute Type" := ItemSubSync."Substitute Type"::"Nonstock Item";
                ItemSubSync."Substitute No." := NonstockItemSync2."Entry No.";
                IF NOT ItemSubSync.FIND THEN
                    EXIT;

                ItemSubSync.VALIDATE(Description, ItemSub.Description);
                ItemSubSync.VALIDATE(Interchangeable, ItemSub.Interchangeable);
                ItemSubSync.VALIDATE("Quantity Avail. on Shpt. Date", ItemSub."Quantity Avail. on Shpt. Date");
                ItemSubSync.VALIDATE("Shipment Date", ItemSub."Shipment Date");
                ItemSubSync.VALIDATE("Replacement Info.", ItemSub."Replacement Info.");
                ItemSubSync.MODIFY;
            END;
        END;

        IF (ItemSub.Type = ItemSub.Type::"Nonstock Item") AND
           (ItemSub."Substitute Type" = ItemSub."Substitute Type"::"Nonstock Item")
        THEN BEGIN
            NonstockItemSync.GET(ItemSub."No.");
            NonstockItemSync2.GET(ItemSub."Substitute No.");
            IF ItemSync.GET(NonstockItemSync."Item No.") AND ItemSync2.GET(NonstockItemSync2."Item No.") THEN BEGIN
                ItemSubSync.Type := ItemSubSync.Type::Item;
                ItemSubSync."No." := ItemSync."No.";
                ItemSubSync."Substitute Type" := ItemSubSync."Substitute Type"::Item;
                ItemSubSync."Substitute No." := ItemSync2."No.";
                IF NOT ItemSubSync.FIND THEN
                    EXIT;

                ItemSubSync.VALIDATE(Description, ItemSub.Description);
                ItemSubSync.VALIDATE(Interchangeable, ItemSub.Interchangeable);
                ItemSubSync.VALIDATE("Quantity Avail. on Shpt. Date", ItemSub."Quantity Avail. on Shpt. Date");
                ItemSubSync.VALIDATE("Shipment Date", ItemSub."Shipment Date");
                ItemSubSync.VALIDATE("Replacement Info.", ItemSub."Replacement Info.");
                ItemSubSync.MODIFY;

            END;
        END;
    end;

    [Scope('Internal')]
    procedure DeleteItemSub(ItemSub: Record "5715"; DeleteInterItem: Boolean)
    var
        SubCondition: Record "5716";
    begin
        IF (ItemSub.Type = ItemSub.Type::Item) AND (ItemSub."Substitute Type" = ItemSub."Substitute Type"::Item) THEN BEGIN
            NonstockItemSync.RESET;
            NonstockItemSync2.RESET;
            NonstockItemSync.SETCURRENTKEY("Item No.");
            NonstockItemSync2.SETCURRENTKEY("Item No.");
            NonstockItemSync.SETRANGE("Item No.", ItemSub."No.");
            NonstockItemSync2.SETRANGE("Item No.", ItemSub."Substitute No.");
            IF NonstockItemSync.FINDFIRST AND NonstockItemSync2.FINDFIRST THEN BEGIN
                ItemSubSync.Type := ItemSubSync.Type::"Nonstock Item";
                ItemSubSync."No." := NonstockItemSync."Entry No.";
                ItemSubSync."Substitute Type" := ItemSubSync."Substitute Type"::"Nonstock Item";
                ItemSubSync."Substitute No." := NonstockItemSync2."Entry No.";
                IF NOT ItemSubSync.FIND THEN
                    EXIT;

                IF ItemSubSync.Interchangeable THEN
                    IF DeleteInterItem THEN
                        ItemSubSync.DeleteInterchangeableItem(ItemSubSync.Type, ItemSubSync."No.", ItemSubSync."Variant Code",
                               ItemSubSync."Substitute Type", ItemSubSync."Substitute No.", ItemSubSync."Substitute Variant Code")
                    ELSE
                        IF ItemSub.GET(ItemSubSync."Substitute Type", ItemSubSync."Substitute No.", ItemSubSync."Substitute Variant Code",
                                      ItemSubSync.Type, ItemSubSync."No.", ItemSubSync."Variant Code")
                        THEN BEGIN
                            ItemSub.Interchangeable := FALSE;
                            ItemSub.MODIFY;
                        END;

                ItemSubSync.CALCFIELDS(Condition);
                IF ItemSubSync.Condition THEN BEGIN
                    SubCondition.SETRANGE(Type, ItemSubSync.Type);
                    SubCondition.SETRANGE("No.", ItemSubSync."No.");
                    SubCondition.SETRANGE("Variant Code", ItemSubSync."Variant Code");
                    SubCondition.SETRANGE("Substitute Type", ItemSubSync."Substitute Type");
                    SubCondition.SETRANGE("Substitute No.", ItemSubSync."Substitute No.");
                    SubCondition.SETRANGE("Substitute Variant Code", ItemSubSync."Substitute Variant Code");
                    SubCondition.DELETEALL;
                END;

                ItemSubSync.DELETE;
            END;
        END;

        IF (ItemSub.Type = ItemSub.Type::"Nonstock Item") AND
           (ItemSub."Substitute Type" = ItemSub."Substitute Type"::"Nonstock Item")
        THEN BEGIN
            IF NonstockItemSync.GET(ItemSub."No.") THEN;
            IF (NonstockItemSync.GET(ItemSub."No.")) AND (NonstockItemSync2.GET(ItemSub."Substitute No.")) THEN BEGIN
                ItemSubSync.Type := ItemSubSync.Type::Item;
                ItemSubSync."No." := NonstockItemSync."Item No.";
                ItemSubSync."Substitute Type" := ItemSubSync."Substitute Type"::Item;
                ItemSubSync."Substitute No." := NonstockItemSync2."Item No.";
                IF NOT ItemSubSync.FIND THEN
                    EXIT;

                IF ItemSubSync.Interchangeable THEN
                    IF DeleteInterItem THEN
                        ItemSubSync.DeleteInterchangeableItem(ItemSubSync.Type, ItemSubSync."No.", ItemSubSync."Variant Code",
                               ItemSubSync."Substitute Type", ItemSubSync."Substitute No.", ItemSubSync."Substitute Variant Code")
                    ELSE
                        IF ItemSub.GET(ItemSubSync."Substitute Type", ItemSubSync."Substitute No.", ItemSubSync."Substitute Variant Code",
                                      ItemSubSync.Type, ItemSubSync."No.", ItemSubSync."Variant Code")
                        THEN BEGIN
                            ItemSub.Interchangeable := FALSE;
                            ItemSub.MODIFY;
                        END;

                ItemSubSync.CALCFIELDS(Condition);
                IF ItemSubSync.Condition THEN BEGIN
                    SubCondition.SETRANGE(Type, ItemSubSync.Type);
                    SubCondition.SETRANGE("No.", ItemSubSync."No.");
                    SubCondition.SETRANGE("Variant Code", ItemSubSync."Variant Code");
                    SubCondition.SETRANGE("Substitute Type", ItemSubSync."Substitute Type");
                    SubCondition.SETRANGE("Substitute No.", ItemSubSync."Substitute No.");
                    SubCondition.SETRANGE("Substitute Variant Code", ItemSubSync."Substitute Variant Code");
                    SubCondition.DELETEALL;
                END;

                ItemSubSync.DELETE(TRUE);
            END;
        END;
    end;

    [Scope('Internal')]
    procedure RenameItemSub(ItemSubNew: Record "5715"; ItemSubOld: Record "5715")
    var
        SubCondition: Record "5716";
        SubCondition2: Record "5716";
    begin
        IF (ItemSubNew.Type = ItemSubNew.Type::Item) AND (ItemSubNew."Substitute Type" = ItemSubNew."Substitute Type"::Item) THEN BEGIN
            NonstockItemSync.RESET;
            NonstockItemSync2.RESET;
            NonstockItemSync.SETCURRENTKEY("Item No.");
            NonstockItemSync2.SETCURRENTKEY("Item No.");
            NonstockItemSync.SETRANGE("Item No.", ItemSubNew."No.");
            NonstockItemSync2.SETRANGE("Item No.", ItemSubNew."Substitute No.");
            IF NonstockItemSync.FINDFIRST AND NonstockItemSync2.FINDFIRST THEN BEGIN
                ItemSubSync.Type := ItemSubSync.Type::"Nonstock Item";
                ItemSubSync."No." := ItemSubOld."No.";
                ItemSubSync."Substitute Type" := ItemSubSync."Substitute Type"::"Nonstock Item";
                ItemSubSync."Substitute No." := ItemSubOld."Substitute No.";
                IF NOT ItemSubSync.FIND THEN
                    EXIT;

                ItemSubSync2.INIT;
                ItemSubSync2.TRANSFERFIELDS(ItemSubSync);
                ItemSubSync2.VALIDATE("No.", NonstockItemSync."Entry No.");
                ItemSubSync2.VALIDATE("Substitute No.", NonstockItemSync2."Entry No.");
                IF ItemSubSync2.INSERT THEN;

                ItemSubSync.CALCFIELDS(Condition);
                IF ItemSubSync.Condition THEN BEGIN
                    SubCondition.SETRANGE(Type, ItemSubSync.Type);
                    SubCondition.SETRANGE("No.", ItemSubSync."No.");
                    SubCondition.SETRANGE("Variant Code", ItemSubSync."Variant Code");
                    SubCondition.SETRANGE("Substitute Type", ItemSubSync."Substitute Type");
                    SubCondition.SETRANGE("Substitute No.", ItemSubSync."Substitute No.");
                    SubCondition.SETRANGE("Substitute Variant Code", ItemSubSync."Substitute Variant Code");
                    IF SubCondition.FINDFIRST THEN
                        REPEAT
                            SubCondition2.INIT;
                            SubCondition2.TRANSFERFIELDS(SubCondition);
                            SubCondition2.VALIDATE("No.", NonstockItemSync."Entry No.");
                            SubCondition2.VALIDATE("Substitute No.", NonstockItemSync2."Entry No.");
                            IF SubCondition2.INSERT THEN;
                        UNTIL SubCondition.NEXT = 0;
                    SubCondition.DELETEALL;
                END;

                ItemSubSync.DELETE;
            END;
        END;

        IF (ItemSubNew.Type = ItemSubNew.Type::"Nonstock Item") AND
           (ItemSubNew."Substitute Type" = ItemSubNew."Substitute Type"::"Nonstock Item")
        THEN BEGIN
            NonstockItemSync.GET(ItemSubNew."No.");
            NonstockItemSync2.GET(ItemSubNew."Substitute No.");
            IF ItemSync.GET(NonstockItemSync."Item No.") AND ItemSync2.GET(NonstockItemSync2."Item No.") THEN BEGIN
                ItemSubSync.Type := ItemSubSync.Type::Item;
                ItemSubSync."No." := ItemSubOld."No.";
                ItemSubSync."Substitute Type" := ItemSubSync."Substitute Type"::Item;
                ItemSubSync."Substitute No." := ItemSubOld."Substitute No.";
                IF NOT ItemSubSync.FIND THEN
                    EXIT;

                ItemSubSync2.INIT;
                ItemSubSync2.TRANSFERFIELDS(ItemSubSync);
                ItemSubSync2.VALIDATE("No.", ItemSync."No.");
                ItemSubSync2.VALIDATE("Substitute No.", ItemSync2."No.");
                IF ItemSubSync2.INSERT THEN;

                ItemSubSync.CALCFIELDS(Condition);
                IF ItemSubSync.Condition THEN BEGIN
                    SubCondition.SETRANGE(Type, ItemSubSync.Type);
                    SubCondition.SETRANGE("No.", ItemSubSync."No.");
                    SubCondition.SETRANGE("Variant Code", ItemSubSync."Variant Code");
                    SubCondition.SETRANGE("Substitute Type", ItemSubSync."Substitute Type");
                    SubCondition.SETRANGE("Substitute No.", ItemSubSync."Substitute No.");
                    SubCondition.SETRANGE("Substitute Variant Code", ItemSubSync."Substitute Variant Code");
                    IF SubCondition.FINDFIRST THEN
                        REPEAT
                            SubCondition2.INIT;
                            SubCondition2.TRANSFERFIELDS(SubCondition);
                            SubCondition2.VALIDATE("No.", ItemSync."No.");
                            SubCondition2.VALIDATE("Substitute No.", ItemSync2."No.");
                            IF SubCondition2.INSERT THEN;
                        UNTIL SubCondition.NEXT = 0;
                    SubCondition.DELETEALL;
                END;

                ItemSubSync.DELETE;

            END;
        END;
    end;

    [Scope('Internal')]
    procedure SyncSubContent(SubContent: Record "5716"; NotDelete: Boolean)
    begin
        IF (SubContent.Type = SubContent.Type::Item) AND (SubContent."Substitute Type" = SubContent."Substitute Type"::Item) THEN BEGIN
            SubContentSync.RESET;
            SubContentSync.SETRANGE(Type, SubContentSync.Type::"Nonstock Item");
            SubContentSync.SETRANGE("No.", SubContent."No.");
            SubContentSync.SETRANGE("Variant Code", SubContent."Variant Code");
            SubContentSync.SETRANGE("Substitute Type", SubContentSync."Substitute Type"::"Nonstock Item");
            SubContentSync.SETRANGE("Substitute No.", SubContent."Substitute No.");
            SubContentSync.DELETEALL;

            IF ItemSubSync.GET(ItemSubSync.Type::"Nonstock Item", SubContent."No.", SubContent."Variant Code",
                         ItemSubSync."Substitute Type"::"Nonstock Item", SubContent."Substitute No.", SubContent."Substitute Variant Code")
            THEN BEGIN
                SubContentSync.RESET;
                SubContentSync.SETRANGE(Type, SubContent.Type);
                SubContentSync.SETRANGE("No.", SubContent."No.");
                SubContentSync.SETRANGE("Variant Code", SubContent."Variant Code");
                SubContentSync.SETRANGE("Substitute Type", SubContent."Substitute Type");
                SubContentSync.SETRANGE("Substitute No.", SubContent."Substitute No.");
                IF SubContentSync.FINDFIRST THEN
                    REPEAT
                        SubContentSync2.INIT;
                        SubContentSync2.TRANSFERFIELDS(SubContentSync);
                        SubContentSync2.VALIDATE(Type, SubContentSync2.Type::"Nonstock Item");
                        SubContentSync2.VALIDATE("Substitute Type", SubContentSync2."Substitute Type"::"Nonstock Item");
                        SubContentSync2.INSERT;
                    UNTIL SubContentSync.NEXT = 0;

                IF NotDelete THEN BEGIN
                    ItemSubSync2.RESET;
                    IF SubContentSync2.GET(SubContentSync2.Type::"Nonstock Item", SubContent."No.", SubContent."Variant Code",
                        SubContentSync2."Substitute Type"::"Nonstock Item", SubContent."Substitute No.", SubContent."Substitute Variant Code",
                        SubContent."Line No.")
                    THEN BEGIN
                        SubContentSync2.Condition := SubContent.Condition;
                        SubContentSync2.MODIFY;
                    END ELSE BEGIN
                        SubContentSync2.TRANSFERFIELDS(SubContent);
                        SubContentSync2.VALIDATE(Type, SubContentSync2.Type::"Nonstock Item");
                        SubContentSync2.VALIDATE("Substitute Type", SubContentSync2."Substitute Type"::"Nonstock Item");
                        SubContentSync2.INSERT;
                    END;
                END ELSE
                    IF SubContentSync2.GET(SubContentSync2.Type::"Nonstock Item", SubContent."No.", SubContent."Variant Code",
                        SubContentSync2."Substitute Type"::"Nonstock Item", SubContent."Substitute No.", SubContent."Substitute Variant Code",
                        SubContent."Line No.")
                    THEN
                        SubContentSync2.DELETE;

            END;
        END;

        IF (SubContent.Type = SubContent.Type::"Nonstock Item") AND
           (SubContent."Substitute Type" = SubContent."Substitute Type"::"Nonstock Item")
        THEN BEGIN
            SubContentSync.RESET;
            SubContentSync.SETRANGE(Type, SubContentSync.Type::Item);
            SubContentSync.SETRANGE("No.", SubContent."No.");
            SubContentSync.SETRANGE("Variant Code", SubContent."Variant Code");
            SubContentSync.SETRANGE("Substitute Type", SubContentSync."Substitute Type"::Item);
            SubContentSync.SETRANGE("Substitute No.", SubContent."Substitute No.");
            SubContentSync.DELETEALL;

            IF ItemSubSync.GET(ItemSubSync.Type::Item, SubContent."No.", SubContent."Variant Code",
                       ItemSubSync."Substitute Type"::Item, SubContent."Substitute No.", SubContent."Substitute Variant Code")
            THEN BEGIN

                SubContentSync.RESET;
                SubContentSync.SETRANGE(Type, SubContent.Type);
                SubContentSync.SETRANGE("No.", SubContent."No.");
                SubContentSync.SETRANGE("Variant Code", SubContent."Variant Code");
                SubContentSync.SETRANGE("Substitute Type", SubContent."Substitute Type");
                SubContentSync.SETRANGE("Substitute No.", SubContent."Substitute No.");
                IF SubContentSync.FINDFIRST THEN
                    REPEAT
                        SubContentSync2.INIT;
                        SubContentSync2.TRANSFERFIELDS(SubContentSync);
                        SubContentSync2.VALIDATE(Type, SubContentSync2.Type::Item);
                        SubContentSync2.VALIDATE("Substitute Type", SubContentSync2."Substitute Type"::Item);
                        SubContentSync2.INSERT;
                    UNTIL SubContentSync.NEXT = 0;

                IF NotDelete THEN BEGIN
                    ItemSubSync2.RESET;
                    IF SubContentSync2.GET(SubContentSync2.Type::Item, SubContent."No.", SubContent."Variant Code",
                        SubContentSync2."Substitute Type"::Item, SubContent."Substitute No.", SubContent."Substitute Variant Code",
                        SubContent."Line No.")
                    THEN BEGIN
                        SubContentSync2.Condition := SubContent.Condition;
                        SubContentSync2.MODIFY;
                    END ELSE BEGIN
                        SubContentSync2.TRANSFERFIELDS(SubContent);
                        SubContentSync2.VALIDATE(Type, SubContentSync2.Type::Item);
                        SubContentSync2.VALIDATE("Substitute Type", SubContentSync2."Substitute Type"::Item);
                        SubContentSync2.INSERT;
                    END;
                END ELSE
                    IF SubContentSync2.GET(SubContentSync2.Type::Item, SubContent."No.", SubContent."Variant Code",
                        SubContentSync2."Substitute Type"::Item, SubContent."Substitute No.", SubContent."Substitute Variant Code",
                        SubContent."Line No.")
                    THEN
                        SubContentSync2.DELETE;


            END;
        END;
    end;

    [Scope('Internal')]
    procedure GetNextReplacementNo(var TypePar: Option Item,"Nonstock Item"; var NoPar: Code[20]; var VariantCodePar: Code[10]; ReplInfoPar: Option " ",Replace,Replacement)
    var
        ItemSubst: Record "5715";
    begin
        //26.03.2014 Elva baltic P15 #F124 MMG7.00 - created

        // Option ReplInfoPar means: Replace = "Replaced by" (forward direction); Replacement = "Replaces" (backward)
        ItemSubst.RESET;
        ItemSubst.SETRANGE("Entry Type", ItemSubst."Entry Type"::Replacement);  //Only Replacement entry
        ItemSubst.SETRANGE(Type, TypePar);

        ItemSubst.SETRANGE("Variant Code", VariantCodePar);
        ItemSubst.SETRANGE("Replacement Info.", ReplInfoPar); //search direction (backward/forward)

        ItemSubst.SETRANGE("No.", NoPar);
        IF ItemSubst.FINDFIRST THEN;
        TypePar := ItemSubst."Substitute Type";
        NoPar := ItemSubst."Substitute No.";
        VariantCodePar := ItemSubst."Substitute Variant Code";
        //10 rows
    end;

    [Scope('Internal')]
    procedure ShowReplacementOverview(Type1: Option; No1: Code[20]; VarCode1: Code[10])
    var
        ItemSubstSync: Codeunit "25006513";
        ReplInfoPar: Option " ",Replace,Replacement;
        TypePar: Option Item,"Nonstock Item";
        NoPar: Code[20];
        VariantCodePar: Code[10];
        PrevTypePar: Option Item,"Nonstock Item";
        PrevNoPar: Code[20];
        PrevVariantCodePar: Code[10];
        CurrKey: Integer;
        DataBuffer: Record "25006004" temporary;
        ItemReplOverview: Page "25006094";
    begin
        //03.04.2014 Elva Baltic P15 #F124 MMG7.00 >>
        DataBuffer.RESET;
        DataBuffer.DELETEALL;

        //set search values
        TypePar := Type1;
        NoPar := No1;
        VariantCodePar := VarCode1;

        CurrKey := 0;
        ReplInfoPar := ReplInfoPar::Replacement; //about turn and forward (i.e. backward)
        REPEAT
            PrevTypePar := TypePar;
            PrevNoPar := NoPar;
            PrevVariantCodePar := VariantCodePar;

            ItemSubstSync.GetNextReplacementNo(TypePar, NoPar, VariantCodePar, ReplInfoPar);
            IF NoPar <> '' THEN BEGIN
                CurrKey -= 1;
                DataBuffer.INIT;
                DataBuffer.VALIDATE("Entry No.", CurrKey);
                DataBuffer.VALIDATE("Text Field 1", FORMAT(TypePar));
                DataBuffer.VALIDATE("Code Field 1", NoPar);
                DataBuffer.VALIDATE("Code Field 2", VariantCodePar);
                DataBuffer.VALIDATE("Text Field 2", FORMAT(PrevTypePar));
                DataBuffer.VALIDATE("Code Field 3", PrevNoPar);
                DataBuffer.VALIDATE("Code Field 4", PrevVariantCodePar);
                DataBuffer.INSERT(TRUE);
            END;
        UNTIL NoPar = '';

        //restore initial search values
        TypePar := Type1;
        NoPar := No1;
        VariantCodePar := VarCode1;

        ReplInfoPar := ReplInfoPar::Replace; //forward
        CurrKey := 0;
        REPEAT
            PrevTypePar := TypePar;
            PrevNoPar := NoPar;
            PrevVariantCodePar := VariantCodePar;

            ItemSubstSync.GetNextReplacementNo(TypePar, NoPar, VariantCodePar, ReplInfoPar);
            IF NoPar <> '' THEN BEGIN
                CurrKey += 1;
                DataBuffer.INIT;
                DataBuffer.VALIDATE("Entry No.", CurrKey);
                DataBuffer.VALIDATE("Text Field 1", FORMAT(PrevTypePar));
                DataBuffer.VALIDATE("Code Field 1", PrevNoPar);
                DataBuffer.VALIDATE("Code Field 2", PrevVariantCodePar);
                DataBuffer.VALIDATE("Text Field 2", FORMAT(TypePar));
                DataBuffer.VALIDATE("Code Field 3", NoPar);
                DataBuffer.VALIDATE("Code Field 4", VariantCodePar);
                DataBuffer.INSERT(TRUE);
            END;
        UNTIL NoPar = '';
        PAGE.RUN(PAGE::"Item Replacement Overview", DataBuffer);

        // 03.04.2014 Elva Baltic P15 #F124 MMG7.00 <<
    end;

    [EventSubscriber(ObjectType::Table, 37, 'OnAfterValidateEvent', 'No.', false, false)]
    [Scope('Internal')]
    procedure CheckItemReplacementOnSalesLineNoValidate(var Rec: Record "37"; var xRec: Record "37"; CurrFieldNo: Integer)
    var
        NonstockItem: Record "5718";
    begin
        IF Rec.Type = Rec.Type::Item THEN BEGIN
            NonstockItem.RESET;
            NonstockItem.SETRANGE("Item No.", Rec."No.");
            IF NonstockItem.FINDFIRST THEN
                Rec."Has Replacement" := CheckReplacementsByNonstockEntryNo(NonstockItem."Entry No.");
        END;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnAfterValidateEvent', 'No.', false, false)]
    [Scope('Internal')]
    procedure CheckItemReplacementOnPurchaseLineNoValidate(var Rec: Record "39"; var xRec: Record "39"; CurrFieldNo: Integer)
    var
        NonstockItem: Record "5718";
    begin
        IF Rec.Type = Rec.Type::Item THEN BEGIN
            NonstockItem.RESET;
            NonstockItem.SETRANGE("Item No.", Rec."No.");
            IF NonstockItem.FINDFIRST THEN
                Rec."Has Replacement" := CheckReplacementsByNonstockEntryNo(NonstockItem."Entry No.");
        END;
    end;

    [EventSubscriber(ObjectType::Table, 25006146, 'OnAfterValidateEvent', 'No.', false, false)]
    [Scope('Internal')]
    procedure CheckItemReplacementOnServiceLineNoValidate(var Rec: Record "25006146"; var xRec: Record "25006146"; CurrFieldNo: Integer)
    var
        NonstockItem: Record "5718";
    begin
        IF Rec.Type = Rec.Type::Item THEN BEGIN
            NonstockItem.RESET;
            NonstockItem.SETRANGE("Item No.", Rec."No.");
            IF NonstockItem.FINDFIRST THEN
                Rec."Has Replacement" := CheckReplacementsByNonstockEntryNo(NonstockItem."Entry No.");
        END;
    end;

    [Scope('Internal')]
    procedure ReplaceSalesLineItemNo(var SalesLine: Record "37")
    var
        ReplacementsFound: Boolean;
        FirstLine: Boolean;
        Replacements: Record "5715" temporary;
        NonstockItem: Record "5718";
        NonstockItem2: Record "5718";
        NonstockItemMgt: Codeunit "5703";
        SalesLineNo: Integer;
        SalesLine2: Record "37";
        ReplacementInfo: Text[250];
        OldItemNo: Code[20];
        OldItemQty: Decimal;
        NextSalseLine: Integer;
        OldItem: Record "27";
        OldItemInventory: Decimal;
        RequestedItemNo: Code[20];
    begin
        SalesSetup.GET;
        IF NOT SalesSetup."Auto Apply Replacements" THEN
            EXIT;

        IF SalesLine.Type = SalesLine.Type::Item THEN BEGIN
            OldItemNo := SalesLine."No.";
            OldItemQty := SalesLine.Quantity;
            OldItem.GET(OldItemNo);
            OldItem.CALCFIELDS(Inventory);
            OldItemInventory := OldItem.Inventory;

            IF SalesLine."Requested Item No." <> '' THEN
                RequestedItemNo := SalesLine."Requested Item No."
            ELSE
                RequestedItemNo := OldItemNo;

            //Check inventory
            IF (OldItemInventory > 0) AND SalesLine."Has Replacement" THEN
                IF NOT DIALOG.CONFIRM(ReplaceConfirmInvTxt, FALSE, OldItemNo) THEN
                    EXIT;

            NonstockItem.RESET;
            NonstockItem.SETRANGE("Item No.", SalesLine."No.");
            IF NonstockItem.FINDFIRST THEN BEGIN
                GetReplacementsByNonstockEntryNo(NonstockItem."Entry No.", Replacements, OldItemQty);
                IF Replacements.FINDFIRST THEN BEGIN
                    FirstLine := TRUE;
                    SalesLine2.COPYFILTERS(SalesLine);
                    SalesLine2.FINDLAST;
                    SalesLineNo := SalesLine2."Line No.";
                    REPEAT

                        //Generate Item from Nonstock if needed to get Item No.
                        NonstockItem2.GET(Replacements."Substitute No.");
                        IF NonstockItem2."Item No." = '' THEN
                            NonstockItemMgt.NonstockAutoItem(NonstockItem2);
                        NonstockItem.GET(NonstockItem2."Entry No.");

                        //Apply replacement to line
                        IF FirstLine THEN BEGIN
                            //Modify Existing line
                            SalesLine.VALIDATE("No.", NonstockItem."Item No.");
                            SalesLine.VALIDATE(Quantity, Replacements."Superseding Quantity");
                            IF SalesLine."Line No." <> 0 THEN BEGIN
                                SalesLine."Requested Item No." := RequestedItemNo;
                                SalesLine.MODIFY;
                            END ELSE BEGIN
                                SalesLineNo := SalesLineNo + 10000;
                                SalesLine."Line No." := SalesLineNo;
                                SalesLine."Requested Item No." := RequestedItemNo;
                                SalesLine.INSERT;
                            END;
                        END ELSE BEGIN
                            // Create New Lines
                            SalesLineNo := SalesLineNo + 10000;
                            SalesLine2.INIT;
                            SalesLine2."Line No." := SalesLineNo;
                            SalesLine2.VALIDATE(Type, SalesLine2.Type::Item);
                            SalesLine2.VALIDATE("No.", NonstockItem."Item No.");
                            SalesLine2.VALIDATE(Quantity, Replacements."Superseding Quantity");
                            SalesLine2."Requested Item No." := RequestedItemNo;
                            SalesLine2.INSERT;
                        END;
                        ReplacementInfo += FORMAT(NonstockItem."Item No.") + ',';
                        FirstLine := FALSE;

                    UNTIL Replacements.NEXT = 0;
                END;
            END;

            IF (SalesSetup."Item No. Replacement Warnings") AND (ReplacementInfo <> '') THEN BEGIN
                ReplacementInfo := DELCHR(ReplacementInfo, '>', ',');
                MESSAGE(ReplaceInfoTxt, OldItemNo, ReplacementInfo);
            END;



        END;
    end;

    [Scope('Internal')]
    procedure ReplaceServiceLineItemNo(var ServiceLine: Record "25006146")
    var
        ReplacementsFound: Boolean;
        FirstLine: Boolean;
        Replacements: Record "5715" temporary;
        NonstockItem: Record "5718";
        NonstockItem2: Record "5718";
        NonstockItemMgt: Codeunit "5703";
        ServiceLineNo: Integer;
        ServiceLine2: Record "25006146";
        ReplacementInfo: Text[250];
        OldItemNo: Code[20];
        OldItemQty: Decimal;
        NextServiceLine: Integer;
        OldItem: Record "27";
        OldItemInventory: Decimal;
        RequestedItemNo: Code[20];
    begin
        ServiceSetup.GET;
        IF NOT ServiceSetup."Auto Apply Replacements" THEN
            EXIT;

        IF ServiceLine.Type = ServiceLine.Type::Item THEN BEGIN
            OldItemNo := ServiceLine."No.";
            OldItemQty := ServiceLine.Quantity;
            OldItem.GET(OldItemNo);
            OldItem.CALCFIELDS(Inventory);
            OldItemInventory := OldItem.Inventory;

            IF ServiceLine."Requested Item No." <> '' THEN
                RequestedItemNo := ServiceLine."Requested Item No."
            ELSE
                RequestedItemNo := OldItemNo;

            //Check inventory
            IF (OldItemInventory > 0) AND ServiceLine."Has Replacement" THEN
                IF NOT DIALOG.CONFIRM(ReplaceConfirmInvTxt, FALSE, OldItemNo) THEN
                    EXIT;

            NonstockItem.RESET;
            NonstockItem.SETRANGE("Item No.", ServiceLine."No.");
            IF NonstockItem.FINDFIRST THEN BEGIN
                GetReplacementsByNonstockEntryNo(NonstockItem."Entry No.", Replacements, OldItemQty);
                IF Replacements.FINDFIRST THEN BEGIN
                    FirstLine := TRUE;
                    ServiceLine2.COPYFILTERS(ServiceLine);
                    IF ServiceLine2.FINDLAST THEN
                        ServiceLineNo := ServiceLine2."Line No.";
                    REPEAT

                        //Generate Item from Nonstock if needed to get Item No.
                        NonstockItem2.GET(Replacements."Substitute No.");
                        IF NonstockItem2."Item No." = '' THEN
                            NonstockItemMgt.NonstockAutoItem(NonstockItem2);
                        NonstockItem.GET(NonstockItem2."Entry No.");

                        //Apply replacement to line
                        IF FirstLine THEN BEGIN
                            //Modify Existing line
                            ServiceLine.VALIDATE("No.", NonstockItem."Item No.");
                            ServiceLine.VALIDATE(Quantity, Replacements."Superseding Quantity");
                            IF ServiceLine."Line No." <> 0 THEN BEGIN
                                ServiceLine."Requested Item No." := RequestedItemNo;
                                ServiceLine.MODIFY;
                            END ELSE BEGIN
                                ServiceLineNo := ServiceLineNo + 10000;
                                ServiceLine."Line No." := ServiceLineNo;
                                ServiceLine."Requested Item No." := RequestedItemNo;
                                ServiceLine.INSERT;
                            END;
                        END ELSE BEGIN
                            // Create New Lines
                            ServiceLineNo := ServiceLineNo + 10000;
                            ServiceLine2.INIT;
                            ServiceLine2."Line No." := ServiceLineNo;
                            ServiceLine2."Document Type" := ServiceLine."Document Type";
                            ServiceLine2."Document No." := ServiceLine."Document No.";
                            ServiceLine2.VALIDATE(Type, ServiceLine2.Type::Item);
                            ServiceLine2.VALIDATE("No.", NonstockItem."Item No.");
                            ServiceLine2.VALIDATE(Quantity, Replacements."Superseding Quantity");
                            ServiceLine2."Requested Item No." := RequestedItemNo;
                            ServiceLine2.INSERT;
                        END;
                        ReplacementInfo += FORMAT(NonstockItem."Item No.") + ',';
                        FirstLine := FALSE;

                    UNTIL Replacements.NEXT = 0;
                END;
            END;

            IF (ServiceSetup."Item No. Replacement Warnings") AND (ReplacementInfo <> '') THEN BEGIN
                ReplacementInfo := DELCHR(ReplacementInfo, '>', ',');
                MESSAGE(ReplaceInfoTxt, OldItemNo, ReplacementInfo);
            END;



        END;
    end;

    [Scope('Internal')]
    procedure ReplacePurchaseLineItemNo(var PurchaseLine: Record "39")
    var
        ReplacementsFound: Boolean;
        FirstLine: Boolean;
        Replacements: Record "5715" temporary;
        NonstockItem: Record "5718";
        NonstockItem2: Record "5718";
        NonstockItemMgt: Codeunit "5703";
        PurchaseLineNo: Integer;
        PurchaseLine2: Record "39";
        ReplacementInfo: Text[250];
        OldItemNo: Code[20];
        OldItemQty: Decimal;
        NextPurchaseLine: Integer;
        RequestedItemNo: Code[20];
    begin
        PurchaseSetup.GET;
        IF NOT PurchaseSetup."Auto Apply Replacements" THEN
            EXIT;

        IF PurchaseLine.Type = PurchaseLine.Type::Item THEN BEGIN
            OldItemNo := PurchaseLine."No.";
            OldItemQty := PurchaseLine.Quantity;

            IF PurchaseLine."Requested Item No." <> '' THEN
                RequestedItemNo := PurchaseLine."Requested Item No."
            ELSE
                RequestedItemNo := OldItemNo;

            NonstockItem.RESET;
            NonstockItem.SETRANGE("Item No.", PurchaseLine."No.");
            IF NonstockItem.FINDFIRST THEN BEGIN
                GetReplacementsByNonstockEntryNo(NonstockItem."Entry No.", Replacements, OldItemQty);
                IF Replacements.FINDFIRST THEN BEGIN
                    FirstLine := TRUE;
                    PurchaseLine2.COPYFILTERS(PurchaseLine);
                    PurchaseLine2.FINDLAST;
                    PurchaseLineNo := PurchaseLine2."Line No.";
                    REPEAT

                        //Generate Item from Nonstock if needed to get Item No.
                        NonstockItem2.GET(Replacements."Substitute No.");
                        IF NonstockItem2."Item No." = '' THEN
                            NonstockItemMgt.NonstockAutoItem(NonstockItem2);
                        NonstockItem.GET(NonstockItem2."Entry No.");

                        //Apply replacement to line
                        IF FirstLine THEN BEGIN
                            //Modify Existing line
                            PurchaseLine.VALIDATE("No.", NonstockItem."Item No.");
                            PurchaseLine.VALIDATE(Quantity, Replacements."Superseding Quantity");
                            IF PurchaseLine."Line No." <> 0 THEN BEGIN
                                PurchaseLine."Requested Item No." := RequestedItemNo;
                                PurchaseLine.MODIFY;
                            END ELSE BEGIN
                                PurchaseLineNo := PurchaseLineNo + 10000;
                                PurchaseLine."Line No." := PurchaseLineNo;
                                PurchaseLine."Requested Item No." := RequestedItemNo;
                                PurchaseLine.INSERT;
                            END;
                        END ELSE BEGIN
                            // Create New Lines
                            PurchaseLineNo := PurchaseLineNo + 10000;
                            PurchaseLine2.INIT;
                            PurchaseLine2."Line No." := PurchaseLineNo;
                            PurchaseLine2.VALIDATE(Type, PurchaseLine2.Type::Item);
                            PurchaseLine2.VALIDATE("No.", NonstockItem."Item No.");
                            PurchaseLine2.VALIDATE(Quantity, Replacements."Superseding Quantity");
                            PurchaseLine2."Requested Item No." := RequestedItemNo;
                            PurchaseLine2.INSERT;
                        END;
                        ReplacementInfo += FORMAT(NonstockItem."Item No.") + ',';
                        FirstLine := FALSE;

                    UNTIL Replacements.NEXT = 0;
                END;
            END;

            IF (SalesSetup."Item No. Replacement Warnings") AND (ReplacementInfo <> '') THEN BEGIN
                ReplacementInfo := DELCHR(ReplacementInfo, '>', ',');
                MESSAGE(ReplaceInfoTxt, OldItemNo, ReplacementInfo);
            END;



        END;
    end;

    [Scope('Internal')]
    procedure GetReplacementsByNonstockEntryNo(EntryNo: Code[20]; var ReplacementsEntryNo: Record "5715"; Qty: Decimal) ReplacementsFound: Boolean
    var
        ItemSubst: Record "5715";
        ItemTmp: Record "27" temporary;
        ReplacementGroupsTmp: Record "5715" temporary;
        ConditionGroups: Text[250];
        ConditionSelected: Integer;
        ConditionGroupsArr: array[100] of Text[50];
        i: Integer;
        CalculatedQty: Decimal;
    begin
        //Get Unconditions ungrouped items
        ItemSubst.SETRANGE("Entry Type", ItemSubst."Entry Type"::Replacement);
        ItemSubst.SETRANGE(Type, ItemSubst.Type::"Nonstock Item");
        ItemSubst.SETRANGE("Replacement Info.", ItemSubst."Replacement Info."::Replace);
        ItemSubst.SETRANGE("Condition Group", '');
        ItemSubst.SETRANGE("No.", EntryNo);
        IF ItemSubst.FINDFIRST THEN BEGIN
            ReplacementsFound := TRUE;
            REPEAT
                IF ItemSubst."Superseding Quantity" = 0 THEN
                    ItemSubst."Superseding Quantity" := 1;
                CalculatedQty := Qty * ItemSubst."Superseding Quantity";

                IF NOT GetReplacementsByNonstockEntryNo(ItemSubst."Substitute No.", ReplacementsEntryNo, CalculatedQty) THEN BEGIN
                    ReplacementsEntryNo.INIT;
                    ReplacementsEntryNo := ItemSubst;
                    ReplacementsEntryNo."Superseding Quantity" := CalculatedQty;
                    ReplacementsEntryNo.INSERT;
                END;
            UNTIL ItemSubst.NEXT = 0;
        END;

        //Get groups
        ItemSubst.RESET;
        ItemSubst.SETRANGE("Entry Type", ItemSubst."Entry Type"::Replacement);
        ItemSubst.SETRANGE(Type, ItemSubst.Type::"Nonstock Item");
        ItemSubst.SETRANGE("Replacement Info.", ItemSubst."Replacement Info."::Replace);
        ItemSubst.SETFILTER("Condition Group", '<>%1', '');
        ItemSubst.SETRANGE("No.", EntryNo);

        IF ItemSubst.FINDFIRST THEN BEGIN
            REPEAT
                ReplacementGroupsTmp.RESET;
                ReplacementGroupsTmp.SETRANGE("Condition Group", ItemSubst."Condition Group");
                IF NOT ReplacementGroupsTmp.FINDFIRST THEN BEGIN
                    i += 1;
                    ReplacementGroupsTmp.INIT;
                    ReplacementGroupsTmp := ItemSubst;
                    ReplacementGroupsTmp.INSERT;

                    ConditionGroups += FORMAT(ReplacementGroupsTmp."Condition Group") + ',';
                    ConditionGroupsArr[i] := FORMAT(ReplacementGroupsTmp."Condition Group");
                END;
            UNTIL ItemSubst.NEXT = 0;

            //Choose one group
            IF i > 1 THEN BEGIN
                IF ConditionGroups <> '' THEN BEGIN
                    ConditionSelected := DIALOG.STRMENU(ConditionGroups, 1, ChooseReplacementTxt);
                END;
            END ELSE
                ConditionSelected := 1;

            //Selected group items
            IF ConditionSelected > 0 THEN BEGIN
                ItemSubst.RESET;
                ItemSubst.SETRANGE("Entry Type", ItemSubst."Entry Type"::Replacement);
                ItemSubst.SETRANGE(Type, ItemSubst.Type::"Nonstock Item");
                ItemSubst.SETRANGE("Replacement Info.", ItemSubst."Replacement Info."::Replace);
                ItemSubst.SETRANGE("Condition Group", ConditionGroupsArr[ConditionSelected]);
                ItemSubst.SETRANGE("No.", EntryNo);
                IF ItemSubst.FINDFIRST THEN BEGIN
                    ReplacementsFound := TRUE;
                    REPEAT
                        IF ItemSubst."Superseding Quantity" = 0 THEN
                            ItemSubst."Superseding Quantity" := 1;
                        CalculatedQty := Qty * ItemSubst."Superseding Quantity";
                        IF NOT GetReplacementsByNonstockEntryNo(ItemSubst."Substitute No.", ReplacementsEntryNo, CalculatedQty) THEN BEGIN
                            ReplacementsEntryNo.INIT;
                            ReplacementsEntryNo := ItemSubst;
                            ReplacementsEntryNo."Superseding Quantity" := CalculatedQty;
                            ReplacementsEntryNo.INSERT;
                        END;
                    UNTIL ItemSubst.NEXT = 0;
                END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure CheckReplacementsByNonstockEntryNo(EntryNo: Code[20]) ReplacementsFound: Boolean
    var
        ItemSubst: Record "5715";
        ItemTmp: Record "27" temporary;
        ReplacementGroupsTmp: Record "5715" temporary;
        ConditionGroups: Text[250];
        ConditionSelected: Integer;
    begin
        //Get Unconditions ungrouped items
        ItemSubst.SETRANGE("Entry Type", ItemSubst."Entry Type"::Replacement);
        ItemSubst.SETRANGE(Type, ItemSubst.Type::"Nonstock Item");
        ItemSubst.SETRANGE("Replacement Info.", ItemSubst."Replacement Info."::Replace);
        ItemSubst.SETRANGE("No.", EntryNo);
        IF ItemSubst.FINDFIRST THEN
            ReplacementsFound := TRUE;
    end;
}


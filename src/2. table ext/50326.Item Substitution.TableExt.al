tableextension 50326 tableextension50326 extends "Item Substitution"
{
    // 23.05.2016 EB.RC POD.DMS.Parts P439.PAR28
    //   Fields added:
    //     25006070Superseding Quantity
    //     25006080Condition Group
    // 
    // 10.05.2016 EB.P7 #PAR_28
    //   Fields added
    //     Superseding Quantity
    //     Condition Group
    // 
    // 05.05.2016 EB.P7 #PAR_96
    //   OnInsert Trigger modified
    // 
    // 01.04.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Fixed bug. Disabled call of ItemSubSync.Functions:
    //     - InsertItemSub
    //     - ModifyItemSub
    //     - DeleteItemSub
    //     - RenameItemSub
    // 
    // 27.03.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Added field: Posting Date
    // 
    // 25.03.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Changed "Type" - OnValidate trigger
    // 
    // 20.03.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Changed "Substitute Type" - OnValidate
    //   * Changed "Substitute No." - OnValidate
    //   * Modified function SetItemVariantDescription
    // 
    // 19.03.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Added field: "Entry Type" - Option: Substitution, Replacement
    // 
    // 24.02.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Added F:MakeItemReplmntOneToOne
    // 
    // 08.04.2008. EDMS P2
    //   * Added new function DontDeleteInterchangableItem
    //   * Added new global variable DontDelete
    // 
    // 17.10.2007. EDMS P2
    //   * Added field Substitute
    // 
    // 16.10.2007. EDMS P2
    //   * Added code OnInsert, OnModify, OnDelete, OnRename
    fields
    {
        modify("No.")
        {
            TableRelation = IF (Type = CONST(Item)) Item.No.
                            ELSE IF (Type = CONST(Nonstock Item)) "Nonstock Item"."Entry No.";
        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 2)".

        modify("Substitute No.")
        {
            TableRelation = IF (Substitute Type=CONST(Item)) Item.No.
                            ELSE IF (Substitute Type=CONST(Nonstock Item)) "Nonstock Item"."Entry No.";
        }

        //Unsupported feature: Property Insertion (Editable) on "Inventory(Field 6)".


        //Unsupported feature: Property Modification (CalcFormula) on "Condition(Field 8)".



        //Unsupported feature: Code Modification on ""No."(Field 1).OnValidate".

        //trigger "(Field 1)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "No." <> xRec."No." THEN BEGIN
          "Variant Code" := '';
          IF Interchangeable THEN
            DeleteInterchangeableItem(
              Type,
              xRec."No.",
              "Variant Code",
              "Substitute Type",
              "Substitute No.",
              "Substitute Variant Code");
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        IF "No." <> xRec."No." THEN BEGIN
          "Variant Code" := '';
          IF Interchangeable
            AND NOT DontDelete THEN //20.03.2013 EDMS
        #4..11
        */
        //end;


        //Unsupported feature: Code Modification on ""Substitute No."(Field 3).OnValidate".

        //trigger "(Field 3)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF (Type = "Substitute Type") AND
           ("No." = "Substitute No.") AND
           ("Variant Code" = "Substitute Variant Code")
        THEN
          ERROR(Text000);

        IF "Substitute No." <> xRec."Substitute No." THEN
          IF Interchangeable THEN
            DeleteInterchangeableItem(
              Type,
              "No.",
        #12..14
              "Substitute Variant Code");

        SetItemVariantDescription("Substitute Type","Substitute No.","Substitute Variant Code",Description);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        IF (Type = "Substitute Type") AND
           ("No." = "Substitute No.") AND
           //20.03.2014 Elva Baltic P15 #F124 MMG7.00 >>
           //("Variant Code" = "Substitute Variant Code")
           ("Variant Code" = "Substitute Variant Code") AND
           ("No." <> '')
           //20.03.2014 Elva Baltic P15 #F124 MMG7.00 <<
        #4..7
          IF Interchangeable
            AND NOT DontDelete THEN //20.03.2013 EDMS
        #9..17
        //EDMS >>
         //CALCFIELDS(Inventory);
         CALCFIELDS("Reserved Qty. on Inventory");
        //EDMS <<
        */
        //end;


        //Unsupported feature: Code Modification on "Type(Field 100).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF Type <> xRec.Type THEN BEGIN
          IF Interchangeable THEN
            DeleteInterchangeableItem(
              xRec.Type,
              "No.",
        #6..10
            VALIDATE("No.",'');
          VALIDATE("Substitute No.",'');
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //25.03.2014 Elva Baltic P15 #F124 MMG7.00 >>
        //IF Type <> xRec.Type THEN BEGIN
        IF (Type <> xRec.Type) AND (xRec."No." <> '') THEN BEGIN
        //25.03.2014 Elva Baltic P15 #F124 MMG7.00 <<

          IF Interchangeable
            AND NOT DontDelete THEN //20.03.2013 EDMS

        #3..13
        */
        //end;


        //Unsupported feature: Code Modification on ""Substitute Type"(Field 101).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF (Type = "Substitute Type") AND
           ("No." = "Substitute No.") AND
           ("Variant Code" = "Substitute Variant Code")
        THEN
          ERROR(Text000);

        IF "Substitute Type" <> xRec."Substitute Type" THEN BEGIN
          IF Interchangeable THEN
            DeleteInterchangeableItem(
              Type,
              "No.",
        #12..17
          "Substitute No." := '';
          Interchangeable := FALSE;
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        IF (Type = "Substitute Type") AND
           ("No." = "Substitute No.") AND
           //20.03.2014 Elva Baltic P15 #F124 MMG7.00 >>
           //("Variant Code" = "Substitute Variant Code")
           ("Variant Code" = "Substitute Variant Code") AND
           ("No." <> '')
           //20.03.2014 Elva Baltic P15 #F124 MMG7.00 <<
        #4..7
          IF Interchangeable
            AND NOT DontDelete THEN //20.03.2013 EDMS

        #9..20
        */
        //end;
        field(50000; "Item Description"; Text[50])
        {
            CalcFormula = Lookup(Item.Description WHERE(No.=FIELD(No.)));
            FieldClass = FlowField;
        }
        field(25006000;"Replacement Info.";Option)
        {
            Caption = 'Replacement Info.';
            OptionCaption = ' ,Replaced by,Replaces';
            OptionMembers = " ",Replace,Replacement;

            trigger OnValidate()
            begin
                //17.10.2007. EDMS P2 >>
                IF "Replacement Info." <> xRec."Replacement Info." THEN
                  //19.03.2014 Elva Baltiv P15 #F124 MMG7.00 >>
                  IF "Replacement Info." = "Replacement Info."::" " THEN
                    "Entry Type" := "Entry Type"::Substitution
                  ELSE
                    "Entry Type" := "Entry Type"::Replacement;
                  //19.03.2014 Elva Baltiv P15 #F124 MMG7.00 <<

                  IF ItemSub.GET("Substitute Type", "Substitute No.", "Substitute Variant Code",
                                Type, "No.", "Variant Code")
                  THEN BEGIN
                    IF "Replacement Info." = "Replacement Info."::" " THEN BEGIN
                      ItemSub."Replacement Info." := ItemSub."Replacement Info."::" ";
                      ItemSub."Entry Type" := ItemSub."Entry Type"::Substitution; //19.03.2014 Elva Baltiv P15 #F124 MMG7.00
                      ItemSub.MODIFY;
                    END;
                    IF "Replacement Info." = "Replacement Info."::Replace THEN BEGIN
                      ItemSub."Replacement Info." := ItemSub."Replacement Info."::Replacement;
                      ItemSub."Entry Type" := ItemSub."Entry Type"::Replacement; //19.03.2014 Elva Baltiv P15 #F124 MMG7.00
                      ItemSub.MODIFY;
                    END;
                    IF "Replacement Info." = "Replacement Info.":: Replacement THEN BEGIN
                      ItemSub."Replacement Info." := ItemSub."Replacement Info."::Replace;
                      ItemSub."Entry Type" := ItemSub."Entry Type"::Replacement; //19.03.2014 Elva Baltiv P15 #F124 MMG7.00
                      ItemSub.MODIFY;
                    END;
                  END;

                //17.10.2007. EDMS P2 <<
            end;
        }
        field(25006020;"Global Dimension 1 Filter";Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(25006030;"Global Dimension 2 Filter";Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(25006040;"Reserved Qty. on Inventory";Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(Substitute No.),
                                                                           Source Type=CONST(32),
                                                                           Source Subtype=CONST(0),
                                                                           Reservation Status=CONST(Reservation),
                                                                           Location Code=FIELD(Location Filter)));
            Caption = 'Reserved Qty. on Inventory';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006050;"Entry Type";Option)
        {
            Caption = 'Entry Type';
            Description = 'P15';
            OptionCaption = 'Substitution,Replacement';
            OptionMembers = Substitution,Replacement;

            trigger OnValidate()
            begin
                IF Rec."Entry Type" <> xRec."Entry Type" THEN
                  IF "Entry Type" = "Entry Type"::Substitution THEN
                    VALIDATE("Replacement Info.", "Replacement Info."::" ");
            end;
        }
        field(25006060;"Posting Date";Date)
        {
            Description = 'P15';
        }
        field(25006070;"Superseding Quantity";Decimal)
        {
            Caption = 'Superseding Quantity';
            Description = 'Replacement Qty';
        }
        field(25006080;"Condition Group";Text[50])
        {
            Caption = 'Condition Group';
            Description = 'Replacment Condition Group';
        }
    }


    //Unsupported feature: Code Insertion (VariableCollection) on "OnDelete".

    //trigger (Variable: ItemSubTemp)()
    //Parameters and return type have not been exported.
    //begin
        /*
        */
    //end;


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF Interchangeable THEN
          IF CONFIRM(Text001 + Text002) THEN
            DeleteInterchangeableItem(Type,"No.","Variant Code","Substitute Type","Substitute No.","Substitute Variant Code")
          ELSE
            IF ItemSubstitution.GET(
                 "Substitute Type",
                 "Substitute No.",
        #8..22
          SubCondition.SETRANGE("Substitute Variant Code","Substitute Variant Code");
          SubCondition.DELETEALL;
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        //16.10.2007. EDMS P2 >>
        ItemSubTemp := Rec;
        DeleteInterItem := FALSE;
        //16.10.2007. EDMS P2 <<

        IF Interchangeable THEN
          IF CONFIRM(Text001 + Text002) THEN BEGIN
            DeleteInterchangeableItem(Type,"No.","Variant Code","Substitute Type","Substitute No.","Substitute Variant Code");
            DeleteInterItem := TRUE;
          END ELSE
        #5..25

        //16.10.2007. EDMS P2 >>
        //ItemSubSync.DeleteItemSub(ItemSubTemp, DeleteInterItem); //01.04.2014 Elva Baltic P15 #F124 MMG7.00
        //16.10.2007. EDMS P2 <<
        */
    //end;


    //Unsupported feature: Code Insertion on "OnInsert".

    //trigger OnInsert()
    //begin
        /*
        //16.10.2007. EDMS P2 >>
        //ItemSubSync.InsertItemSub(Rec); //01.04.2014 Elva Baltic P15 #F124 MMG7.00
        //16.10.2007. EDMS P2 <<

        //05.05.2016 EB.P7 #PAR_96 >>
        IF "Posting Date" = 0D THEN
            "Posting Date" := WORKDATE;
        //05.05.2016 EB.P7 #PAR_96 <<
        */
    //end;


    //Unsupported feature: Code Insertion on "OnModify".

    //trigger OnModify()
    //begin
        /*
        //16.10.2007. EDMS P2 >>
        //ItemSubSync.InsertItemSub(Rec); //01.04.2014 Elva Baltic P15 #F124 MMG7.00
        //ItemSubSync.ModifyItemSub(Rec); //01.04.2014 Elva Baltic P15 #F124 MMG7.00
        //16.10.2007. EDMS P2 <<
        */
    //end;


    //Unsupported feature: Code Insertion on "OnRename".

    //trigger OnRename()
    //begin
        /*
        //16.10.2007. EDMS P2 >>
        // ItemSubSync.RenameItemSub(Rec, xRec);  //01.04.2014 Elva Baltic P15 #F124 MMG7.00
        //16.10.2007. EDMS P2 <<
        */
    //end;


    //Unsupported feature: Code Modification on "CreateInterchangeableItem(PROCEDURE 1)".

    //procedure CreateInterchangeableItem();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        ItemSubstitution.Type := "Substitute Type";
        ItemSubstitution."No." := "Substitute No.";
        ItemSubstitution."Variant Code" := "Substitute Variant Code";
        ItemSubstitution."Substitute Type" := Type;
        ItemSubstitution."Substitute No." := "No.";
        ItemSubstitution."Substitute Variant Code" := "Variant Code";
        SetDescription(Type,"No.",ItemSubstitution.Description);
        ItemSubstitution.Interchangeable := TRUE;
        IF ItemSubstitution.FIND THEN
          ItemSubstitution.MODIFY
        ELSE
          ItemSubstitution.INSERT;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..6
        SetDescription(Type,"No.",Description);
        ItemSubstitution.Interchangeable := TRUE;

        //17.10.2007. EDMS P2 >>
        ItemSubstitution."Entry Type" := "Entry Type";      // 19.03.2014 Elva Baltic P15 #F124 MMG7.00
        ItemSubstitution."Posting Date" := "Posting Date";  // 27.03.2014 Elva Baltic P15 #F124 MMG7.00
        IF "Replacement Info." = "Replacement Info."::Replace THEN
          ItemSubstitution."Replacement Info." := ItemSubstitution."Replacement Info."::Replacement;
        IF "Replacement Info." = "Replacement Info.":: Replacement THEN
          ItemSubstitution."Replacement Info." := ItemSubstitution."Replacement Info."::Replace;
        //17.10.2007. EDMS P2 <<

        #9..12
        */
    //end;

    //Unsupported feature: Property Deletion (Local) on "DeleteInterchangeableItem(PROCEDURE 2)".


    procedure DontDeleteInterchangeableItem()
    begin
        DontDelete := TRUE;
    end;

    procedure MakeSubstitutionOneToOne(codNonstockItemEntryNoOld: Code[20];codNonstockItemEntryNoNew: Code[20])
    begin
        /**
        recItemReplJnlLine.RESET;
        recItemReplJnlLine.INIT;
        recItemReplJnlLine."Document No." := 'PURCHLINE';
        recItemReplJnlLine."Posting Date" := WORKDATE;
        recItemReplJnlLine.VALIDATE("Nonstock Item Entry No.",codNonstockItemEntryNoOld);
        recItemReplJnlLine.VALIDATE("New Nonstock Item Entry No.",codNonstockItemEntryNoNew);
        cuItemReplPostLine.RUN(recItemReplJnlLine);
        **/

    end;

    procedure CreateReplacement(Type1: Option Item,"Nonstock Item";No1: Code[20];VariantCode1: Code[10];Type2: Option Item,"Nonstock Item";No2: Code[20];VariantCode2: Code[10];InterchangeablePar: Boolean) RetVal: Boolean
    begin
        RetVal := FALSE;
        INIT;
        Type := Type1;
        "No." := No1;
        "Variant Code" := VariantCode1;

        "Substitute Type" := Type2;
        VALIDATE("Substitute No.", No2);
        "Substitute Variant Code" := VariantCode2;
        "Entry Type" := "Entry Type"::Replacement;
        "Replacement Info." := "Replacement Info."::Replace;
        "Posting Date" := WORKDATE;

        IF NOT INSERT(TRUE) THEN
          MODIFY(TRUE);

        IF InterchangeablePar THEN BEGIN
          VALIDATE(Interchangeable, InterchangeablePar);
          MODIFY(TRUE);
        END;
        RetVal := TRUE;
    end;

    //Unsupported feature: Property Modification (Length) on "DeleteInterchangeableItem(PROCEDURE 2).XVariantCode(Parameter 1002)".


    //Unsupported feature: Property Modification (Length) on "DeleteInterchangeableItem(PROCEDURE 2).XSubstVariantCode(Parameter 1005)".


    //Unsupported feature: Property Modification (Length) on "RecreateSubstEntry(PROCEDURE 3).XVariantCode(Parameter 1000)".


    //Unsupported feature: Property Modification (Length) on "RecreateSubstEntry(PROCEDURE 3).XSubstVariantCode(Parameter 1001)".


    var
        ItemSubTemp: Record "5715" temporary;
        DeleteInterItem: Boolean;

    var
        ItemSubSync: Codeunit "25006513";
        DontDelete: Boolean;
        ItemSub: Record "5715";
}


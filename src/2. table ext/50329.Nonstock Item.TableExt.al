tableextension 50329 tableextension50329 extends "Nonstock Item"
{
    // 
    // 07.02.2017 EB.P7 EDMS Upgrade 2017
    //   Field added "Item Category Code"
    // 
    // 25.11.2015 EB.P7 #T017
    //   OnDeleted code moved to events
    // 
    // 11.02.2014 EDMS P21
    //   Added field:
    //     25006910 "Item Disc. Group"
    // 
    // 28.08.2014 EDMS P8
    //   * Added field "Replacements Exist"
    // 
    // 03.01.2008. EDMS P2
    //   Addded field "Tariff No."
    fields
    {

        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 53)".



        //Unsupported feature: Code Insertion on ""Item No."(Field 16)".

        //trigger OnLookup(var Text: Text): Boolean
        //var
        //Item: Record "27";
        //LookupMgt: Codeunit "25006003";
        //begin
        /*
        //EDMS1.0.00 >>
         Item.RESET;
         IF LookupMgt.LookUpItemREZ(Item,"Item No.") THEN;
        //EDMS1.0.00 <<
        */
        //end;
        field(25006670; "Item Type"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = ',Item,Vehicle';
            OptionMembers = " ",Item,Vehicle;
        }
        field(25006671; "Product Subgroup Code"; Code[10])
        {
            Caption = 'Product Subgroup Code';
            TableRelation = "Product Subgroup".Code WHERE(Item Category Code=FIELD(Item Category Code),
                                                           Product Group Code=FIELD(Product Group Code));
        }
        field(25006672;"Published Cost Currency Code";Code[10])
        {
            AutoFormatType = 1;
            Caption = 'Published Cost Currency Code';
            TableRelation = Currency;
        }
        field(25006673;"Unit Volume";Decimal)
        {
            Caption = 'Unit Volume';
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(25006674;"Replacements Exist";Boolean)
        {
            CalcFormula = Exist("Item Substitution" WHERE (Type=CONST(Nonstock Item),
                                                           No.=FIELD(Entry No.),
                                                           Entry Type=CONST(Replacement),
                                                           Substitute Type=CONST(Nonstock Item)));
            Caption = 'Replacements Exist';
            FieldClass = FlowField;
        }
        field(25006675;"Replacement Status";Option)
        {
            Caption = 'Replacement Status';
            OptionCaption = ' ,Is Being Replaced,Replaced';
            OptionMembers = " ",Replaced;
        }
        field(25006685;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(25006686;"Global Dimension 1 Filter";Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(25006687;"Global Dimension 2 Filter";Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(25006688;"Location Filter";Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(25006689;Inventory;Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE (Item No.=FIELD(Entry No.),
                                                                  Global Dimension 1 Code=FIELD(Global Dimension 1 Filter),
                                                                  Global Dimension 2 Code=FIELD(Global Dimension 2 Filter),
                                                                  Location Code=FIELD(Location Filter)));
            Caption = 'Inventory';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006690;"Exchange Unit";Boolean)
        {
            Caption = 'Exchange Unit';

            trigger OnValidate()
            var
                recItem: Record "27";
            begin
                IF "Item No." <> '' THEN
                 BEGIN
                  recItem.GET("Item No.");
                  recItem."Exchange Unit" := "Exchange Unit";
                  recItem.MODIFY;
                 END;
            end;
        }
        field(25006696;"Reserved Qty. on Inventory";Decimal)
        {
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Item No.=FIELD(Item No.),
                                                                           Source Type=CONST(32),
                                                                           Source Subtype=CONST(0),
                                                                           Reservation Status=CONST(Reservation),
                                                                           Location Code=FIELD(Location Filter)));
            Caption = 'Reserved Qty. on Inventory';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006700;"Substitutes Exist";Boolean)
        {
            CalcFormula = Exist("Item Substitution" WHERE (Type=CONST(Nonstock Item),
                                                           No.=FIELD(Entry No.)));
            Caption = 'Substitutes Exist';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006710;"No. of Substitutes";Integer)
        {
            CalcFormula = Count("Item Substitution" WHERE (Type=CONST(Nonstock Item),
                                                           No.=FIELD(Entry No.)));
            Caption = 'No. of Substitutes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006720;"Tariff No.";Code[10])
        {
            Caption = 'Tariff No.';
            TableRelation = "Tariff Number";
        }
        field(25006900;"Item Price Group Code";Code[10])
        {
            Caption = 'Item Price Group Code';
            TableRelation = "Item Price Group";
        }
        field(25006910;"Item Disc. Group";Code[20])
        {
            Caption = 'Item Disc. Group';
            TableRelation = "Item Discount Group";
        }
        field(25006911;"Item Category Code";Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";

            trigger OnValidate()
            begin
                IF ("Item Category Code" <> xRec."Item Category Code") AND
                   ("Item No." <> '')
                THEN
                  ERROR(Text001);

                "Product Group Code" := '';
            end;
        }
    }

    procedure ShowVehModels()
    var
        ItemVehicleModel: Record "25006755";
    begin
        ItemVehicleModel.SETRANGE(Type,ItemVehicleModel.Type::"Nonstock Item");
        ItemVehicleModel.SETRANGE("No.","Entry No.");
        IF (NOT ItemVehicleModel.FINDFIRST) AND ("Item No." <> '') THEN BEGIN
          ItemVehicleModel.RESET;
          ItemVehicleModel.SETRANGE(Type,ItemVehicleModel.Type::Item);
          ItemVehicleModel.SETRANGE("No.","Item No.");
        END;
        PAGE.RUN(PAGE::"Item Vehicle Models",ItemVehicleModel);
    end;
}


tableextension 50409 tableextension50409 extends "Sales Line Discount"
{
    // 04.02.2016 EB.P30 #T032
    //   Change relations for fields:
    //     "Item Category Code"
    //     "Product Group Code"
    //     "Product Subgroup Code"
    //   Modified triggers:
    //     OnInsert
    //     OnRename
    // 
    // 26.11.2015 EB.P7 #T017
    //   Code from triggers moved to events
    // 
    // 05.12.2013 EDMS P8
    //   * Added options to Type field
    // 
    // 21.11.2013 EDMS P8
    //   * Added EDMS fields
    fields
    {
        modify("Code")
        {
            TableRelation = IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST(Item Disc.Group)) "Item Discount Group"
                            ELSE IF (Type=CONST(All)) "Item Category".Code;

            //Unsupported feature: Property Modification (NotBlank) on "Code(Field 1)".

        }
        modify("Sales Code")
        {
            TableRelation = IF (Sales Type=CONST(Customer Disc. Group)) "Customer Discount Group"
                            ELSE IF (Sales Type=CONST(Customer)) Customer
                            ELSE IF (Sales Type=CONST(Campaign)) Campaign
                            ELSE IF (Sales Type=CONST(Contract)) Contract."Contract No."
                            ELSE IF (Sales Type=CONST(Assembly)) "Vehicle Assembly Header"."Assembly ID"
                            ELSE IF (Sales Type=CONST(SPackage)) "Service Package".No.;
        }
        modify("Sales Type")
        {
            OptionCaption = 'Customer,Customer Disc. Group,All Customers,Campaign,Contract,Assembly,SPackage';

            //Unsupported feature: Property Modification (OptionString) on ""Sales Type"(Field 13)".

        }
        modify(Type)
        {
            OptionCaption = 'Item,Item Disc. Group,All';

            //Unsupported feature: Property Modification (OptionString) on "Type(Field 21)".

        }

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 5700)".



        //Unsupported feature: Code Modification on "Code(Field 1).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF xRec.Code <> Code THEN BEGIN
              "Unit of Measure Code" := '';
              "Variant Code" := '';

              IF Type = Type::Item THEN
                IF Item.GET(Code) THEN
                  "Unit of Measure Code" := Item."Sales Unit of Measure"
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..5
                IF Item.GET(Code) THEN BEGIN
                  "Unit of Measure Code" := Item."Sales Unit of Measure";
                  ABC := Item.ABC; //Min 3.10.2020
                  END;
              IF Type = Type::All THEN
                "Item Category Code" := Code;
            END;
            */
        //end;


        //Unsupported feature: Code Modification on "Type(Field 21).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF xRec.Type <> Type THEN
              VALIDATE(Code,'');
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            IF xRec.Type <> Type THEN
              VALIDATE(Code,'');
            IF Type = Type::All THEN
              VALIDATE(Code,'');
            IF Type = Type::Item THEN BEGIN
              VALIDATE("Item Category Code",'');
              VALIDATE("Product Group Code",'');
              VALIDATE("Product Subgroup Code",'');
            END;
            */
        //end;
        field(60006;ABC;Option)
        {
            Editable = false;
            OptionCaption = ' ,A,B,C,D,E';
            OptionMembers = " ",A,B,C,D,E;
        }
        field(25006000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006002;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006003;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006007;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(25006010;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Item Type=CONST(Model Version),
                                            Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code));
        }
        field(25006120;"Source Type";Option)
        {
            Caption = 'Source Type';
            Editable = false;
            OptionCaption = 'User,Contract';
            OptionMembers = User,Contract;
        }
        field(25006130;"Source No.";Code[20])
        {
            Caption = 'Source No.';
            Editable = false;
        }
        field(25006140;"Source Ref. No.";Integer)
        {
            Caption = 'Source Ref. No.';
        }
        field(25006373;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
        }
        field(25006390;"Item Category Code";Code[10])
        {
            TableRelation = IF (Type=CONST(Item)) "Item Category"
                            ELSE IF (Type=CONST(All)) "Item Category";
        }
        field(25006400;"Product Group Code";Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = IF (Type=CONST(Item)) "Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code))
                            ELSE IF (Type=CONST(All)) "Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));

            trigger OnValidate()
            var
                ProductSubgrp: Record "25006746";
            begin
            end;
        }
        field(25006401;"Product Subgroup Code";Code[10])
        {
            Caption = 'Product Subgroup Code';
            TableRelation = IF (Type=CONST(Item)) "Product Subgroup".Code WHERE (Item Category Code=FIELD(Item Category Code),
                                                                                 Product Group Code=FIELD(Product Group Code))
                                                                                 ELSE IF (Type=CONST(All)) "Product Subgroup".Code WHERE (Item Category Code=FIELD(Item Category Code),
                                                                                                                                          Product Group Code=FIELD(Product Group Code));
        }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on ""Type,Code,Sales Type,Sales Code,Starting Date,Currency Code,Variant Code,Unit of Measure Code,Minimum Quantity"(Key)".

        key(Key1;Type,"Code","Sales Type","Sales Code","Starting Date","Currency Code","Variant Code","Unit of Measure Code","Minimum Quantity","Vehicle Status Code","Document Profile","Vehicle Serial No.","Make Code","Product Group Code","Product Subgroup Code","Item Category Code")
        {
            Clustered = true;
        }
    }


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF "Sales Type" = "Sales Type"::"All Customers" THEN
          "Sales Code" := ''
        ELSE
          TESTFIELD("Sales Code");
        TESTFIELD(Code);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..4
        //TESTFIELD(Code);                      // 04.02.2016 EB.P30 #T032
        */
    //end;


    //Unsupported feature: Code Modification on "OnRename".

    //trigger OnRename()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF "Sales Type" <> "Sales Type"::"All Customers" THEN
          TESTFIELD("Sales Code");
        TESTFIELD(Code);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        IF "Sales Type" <> "Sales Type"::"All Customers" THEN
          TESTFIELD("Sales Code");
        //TESTFIELD(Code);                      // 04.02.2016 EB.P30 #T032
        */
    //end;
}


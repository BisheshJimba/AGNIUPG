table 25006057 "Labor Sales Line Discount"
{
    Caption = 'Labor Sales Line Discount';
    LookupPageID = 25006077;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = IF (Type = CONST(Labor)) "Service Labor"
            ELSE
            IF (Type = CONST(Labor Discount Group)) "Service Labor Discount Group";
        }
        field(2; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = IF (Sales Type=CONST(Customer Disc. Group)) "Customer Discount Group"
                            ELSE IF (Sales Type=CONST(Customer)) Customer
                            ELSE IF (Sales Type=CONST(Campaign)) Campaign
                            ELSE IF (Sales Type=CONST(SPackage)) "Service Package"
                            ELSE IF (Sales Type=CONST(Contract)) Contract."Contract No.";

            trigger OnValidate()
            begin
                IF "Sales Code" <> '' THEN
                  CASE "Sales Type" OF
                    "Sales Type"::"All Customers":
                      ERROR(Text001,FIELDCAPTION("Sales Code"));
                    "Sales Type"::Campaign:
                      BEGIN
                        Campaign.GET("Sales Code");
                        "Starting Date" := Campaign."Starting Date";
                        "Ending Date" := Campaign."Ending Date";
                      END;
                  END;
            end;
        }
        field(3;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(4;"Starting Date";Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
                  ERROR(Text000,FIELDCAPTION("Starting Date"),FIELDCAPTION("Ending Date"));

                IF CurrFieldNo = 0 THEN
                  EXIT;
                IF "Sales Type" = "Sales Type"::Campaign THEN
                  ERROR(Text003,FIELDCAPTION("Starting Date"),FIELDCAPTION("Ending Date"),FIELDCAPTION("Sales Type"),"Sales Type");
            end;
        }
        field(5;"Line Discount %";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Line Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(13;"Sales Type";Option)
        {
            Caption = 'Sales Type';
            OptionCaption = 'Customer,Customer Disc. Group,All Customers,Campaign,Contract,Assembly,SPackage';
            OptionMembers = Customer,"Customer Disc. Group","All Customers",Campaign,Contract,Assembly,SPackage;

            trigger OnValidate()
            begin
                IF "Sales Type" <> xRec."Sales Type" THEN
                  VALIDATE("Sales Code",'');
            end;
        }
        field(14;"Minimum Quantity";Decimal)
        {
            Caption = 'Minimum Quantity';
            MinValue = 0;
        }
        field(15;"Ending Date";Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                VALIDATE("Starting Date");

                IF CurrFieldNo = 0 THEN
                  EXIT;
                IF "Sales Type" = "Sales Type"::Campaign THEN
                  ERROR(Text003,FIELDCAPTION("Starting Date"),FIELDCAPTION("Ending Date"),FIELDCAPTION("Sales Type"),"Sales Type");
            end;
        }
        field(21;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Labor,Labor Discount Group,All';
            OptionMembers = Labor,"Labor Discount Group",All;

            trigger OnValidate()
            begin
                IF xRec.Type <> Type THEN
                  VALIDATE(Code,'');
                IF Type = Type::All THEN
                  VALIDATE(Code,'');
                IF Type = Type::Labor THEN BEGIN
                  VALIDATE("Labor Group Code",'');
                  VALIDATE("Labor Subgroup Code",'');
                END;
            end;
        }
        field(101;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(102;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(103;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(104;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Item Type=CONST(Model Version),
                                            Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code));
        }
        field(108;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle."Serial No.";
        }
        field(120;"Labor Group Code";Code[10])
        {
            Caption = 'Labor Group Code';
            TableRelation = IF (Type=CONST(All)) "Service Labor Group";

            trigger OnValidate()
            var
                ProductSubgrp: Record "25006746";
            begin
            end;
        }
        field(121;"Labor Subgroup Code";Code[10])
        {
            Caption = 'Labor Subgroup Code';
            TableRelation = IF (Type=CONST(All)) "Service Labor Subgroup" WHERE (Group Code=FIELD(Labor Group Code));
        }
    }

    keys
    {
        key(Key1;Type,"Code","Sales Type","Sales Code","Starting Date","Currency Code","Minimum Quantity","Vehicle Status Code","Vehicle Serial No.")
        {
            Clustered = true;
        }
        key(Key2;"Sales Type","Sales Code",Type,"Code","Starting Date","Currency Code","Minimum Quantity")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "Sales Type" = "Sales Type"::"All Customers" THEN
          "Sales Code" := ''
        ELSE
          TESTFIELD("Sales Code");
        TESTFIELD(Code);
    end;

    trigger OnRename()
    begin
        IF "Sales Type" <> "Sales Type"::"All Customers" THEN
          TESTFIELD("Sales Code");
        TESTFIELD(Code);
    end;

    var
        Text000: Label '%1 cannot be after %2';
        Text001: Label '%1 must be blank.';
        Campaign: Record "5071";
        Text003: Label 'You can only change the %1 and %2 from the Campaign Card when %3 = %4.';
}


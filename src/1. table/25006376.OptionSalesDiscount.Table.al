table 25006376 "Option Sales Discount"
{
    // 11.04.2013 EDMS P8
    //   * added field 'Option Subtype', to primary as well
    // 
    // 08.02.05 AB
    // *Jauns lauks Payment Method Code

    Caption = 'Option Sales Discount';
    LookupPageID = 7004;

    fields
    {
        field(10; "Option Code"; Code[50])
        {
            Caption = 'Option Code';
            NotBlank = true;
            TableRelation = IF (Option Type=CONST(Manufacturer Option)) "Manufacturer Option"."Option Code" WHERE (Make Code=FIELD(Make Code),
                                                                                                                   Model Code=FIELD(Model Code),
                                                                                                                   Model Version No.=FIELD(Model Version No.))
                                                                                                                   ELSE IF (Option Type=CONST(Own Option)) "Own Option"."Option Code" WHERE (Make Code=FIELD(Make Code),
                                                                                                                                                                                             Model Code=FIELD(Model Code));
        }
        field(20;"Sales Code";Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = IF (Sales Type=CONST(Customer Disc. Group)) "Customer Discount Group"
                            ELSE IF (Sales Type=CONST(Customer)) Customer
                            ELSE IF (Sales Type=CONST(Campaign)) Campaign;

            trigger OnValidate()
            begin
                IF "Sales Code" <> '' THEN BEGIN
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
                END;
            end;
        }
        field(30;"Starting Date";Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
                  ERROR(Text000,FIELDCAPTION("Starting Date"),FIELDCAPTION("Ending Date"));

                IF CurrFieldNo = 0 THEN
                  EXIT ELSE
                    IF "Sales Type" = "Sales Type"::Campaign THEN
                      ERROR(Text003,FIELDCAPTION("Starting Date"),FIELDCAPTION("Ending Date"),FIELDCAPTION("Sales Type"),("Sales Type"));
            end;
        }
        field(40;"Line Discount %";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Line Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50;"Sales Type";Option)
        {
            Caption = 'Sales Type';
            OptionCaption = 'Customer,Customer Disc. Group,All Customers,Campaign';
            OptionMembers = Customer,"Customer Disc. Group","All Customers",Campaign;

            trigger OnValidate()
            begin
                IF "Sales Type" <> xRec."Sales Type" THEN
                  VALIDATE("Sales Code",'');
            end;
        }
        field(60;"Ending Date";Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                VALIDATE("Starting Date");

                IF CurrFieldNo = 0 THEN
                  EXIT ELSE
                    IF "Sales Type" = "Sales Type"::Campaign THEN
                      ERROR(Text003,FIELDCAPTION("Starting Date"),FIELDCAPTION("Ending Date"),FIELDCAPTION("Sales Type"),("Sales Type"));
            end;
        }
        field(70;"Option Type";Option)
        {
            Caption = 'Option Type';
            OptionCaption = 'Manufacturer Option,Own Option';
            OptionMembers = "Manufacturer Option","Own Option";

            trigger OnValidate()
            begin
                IF xRec."Option Type" <> "Option Type" THEN
                  VALIDATE("Option Code",'');
            end;
        }
        field(75;"Option Subtype";Option)
        {
            Caption = 'Option Subtype';
            OptionCaption = 'Option,Color,Upholstery';
            OptionMembers = Option,Color,Upholstery;
        }
        field(80;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(90;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(100;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item.No. WHERE (Item Type=CONST(Model Version),
                                            Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code));
        }
        field(110;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
    }

    keys
    {
        key(Key1;"Make Code","Model Code","Model Version No.","Option Type","Option Subtype","Option Code","Sales Type","Sales Code","Starting Date")
        {
            Clustered = true;
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
        TESTFIELD("Option Code");
    end;

    trigger OnRename()
    begin
        IF "Sales Type" <> "Sales Type"::"All Customers" THEN
          TESTFIELD("Sales Code");
        TESTFIELD("Option Code");
    end;

    var
        Text000: Label '%1 cannot be after %2';
        Cust: Record "18";
        Text001: Label '%1 must be blank.';
        Campaign: Record "5071";
        Text003: Label 'You can only change the %1 and %2 from the Campaign Card when %3 = %4';
}


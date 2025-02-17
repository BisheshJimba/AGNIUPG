table 25006123 "Service Price"
{
    // 30.03.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added field "Make Code", also added to  the primary key
    //   * Added field "Location Code", also added to  the primary key
    // 
    // 08.02.05 AB

    Caption = 'Service Price';

    fields
    {
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Service Labor,Serv. Labor group,External Service';
            OptionMembers = Labor,"Labor Group","Ext.Serv.";
        }
        field(5; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = IF (Type = CONST(Labor)) "Service Labor"
            ELSE
            IF (Type = CONST(Labor Group)) "Service Labor Price Group"
                            ELSE IF (Type=CONST(Ext.Serv.)) "External Service";
        }
        field(7; "Sales Type"; Option)
        {
            Caption = 'Sales Type';
            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign,Markup,Assembly,Contract,Serv. Pack';
            OptionMembers = Customer,"Customer Price Group","All Customers",Campaign,Markup,Assembly,Contract,SPackage;

            trigger OnValidate()
            begin
                IF "Sales Type" <> xRec."Sales Type" THEN
                    VALIDATE("Sales Code", '');
            end;
        }
        field(8; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = IF (Sales Type=CONST(Customer Price Group)) "Customer Price Group"
                            ELSE IF (Sales Type=CONST(Customer)) Customer
                            ELSE IF (Sales Type=CONST(Campaign)) Campaign
                            ELSE IF (Sales Type=CONST(SPackage)) "Service Package"
                            ELSE IF (Sales Type=CONST(Contract)) Contract."Contract No.";

            trigger OnValidate()
            begin
                IF "Sales Code" <> '' THEN BEGIN
                  CASE "Sales Type" OF
                    "Sales Type"::"All Customers":
                      ERROR(Text001,FIELDCAPTION("Sales Code"));
                    "Sales Type"::"Customer Price Group":
                      BEGIN
                        CustPriceGr.GET("Sales Code");
                        "Price Includes VAT" := CustPriceGr."Price Includes VAT";
                        "VAT Bus. Posting Gr. (Price)" := CustPriceGr."VAT Bus. Posting Gr. (Price)";
                        "Allow Line Disc." := CustPriceGr."Allow Line Disc.";
                        "Allow Invoice Disc." := CustPriceGr."Allow Invoice Disc.";
                      END;
                    "Sales Type"::Customer:
                      BEGIN
                        Cust.GET("Sales Code");
                        "Currency Code" := Cust."Currency Code";
                        "Price Includes VAT" := Cust."Prices Including VAT";
                        "Allow Line Disc." := Cust."Allow Line Disc.";
                      END;
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
        field(50;"Starting Date";Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
                  ERROR(Text000,FIELDCAPTION("Ending Date"),FIELDCAPTION("Starting Date"));
            end;
        }
        field(60;"Ending Date";Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                VALIDATE("Starting Date");
            end;
        }
        field(70;Price;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;
        }
        field(80;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(90;"Price Includes VAT";Boolean)
        {
            Caption = 'Price Includes VAT';
        }
        field(100;"VAT Bus. Posting Gr. (Price)";Code[10])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";
        }
        field(110;"Allow Line Disc.";Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(120;"Allow Invoice Disc.";Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(5400;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(5410;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006770;"Location Code";Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(25006800;"Variable Field 25006800";Code[20])
        {
            CaptionClass = '7,25006123,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                VFOptions.RESET;
                IF LookUpMgt.LookUpVariableField(VFOptions,DATABASE::"Service Price",FIELDNO("Variable Field 25006800"),
                  '', "Variable Field 25006800") THEN
                 BEGIN
                  VALIDATE("Variable Field 25006800",VFOptions.Code);
                 END;
            end;
        }
    }

    keys
    {
        key(Key1;Type,"Code","Sales Type","Sales Code","Starting Date","Currency Code","Unit of Measure Code","Variable Field 25006800","Location Code","Make Code")
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
    end;

    trigger OnRename()
    begin
        IF "Sales Type" <> "Sales Type"::"All Customers" THEN
          TESTFIELD("Sales Code");
    end;

    var
        Text000: Label '%1 cannot be after %2';
        Text001: Label '%1 must be blank.';
        CustPriceGr: Record "6";
        Cust: Record "18";
        Campaign: Record "5071";
        LookUpMgt: Codeunit "25006003";
        VFMgt: Codeunit "25006004";

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.IsVFActive(DATABASE::"Service Price",intFieldNo));
    end;
}


table 25006741 "Sales/Serv. Item Markup"
{
    // 08.02.05 AB

    Caption = 'Sales/Serv. Item Markup';

    fields
    {
        field(2; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = IF (Sales Type=CONST(Customer Price Group)) "Customer Price Group"
                            ELSE IF (Sales Type=CONST(Customer)) Customer
                            ELSE IF (Sales Type=CONST(Campaign)) Campaign;

            trigger OnValidate()
            begin
                IF "Sales Code" <> '' THEN BEGIN
                  CASE "Sales Type" OF
                    "Sales Type"::"All Customers":
                      ERROR(Text001,FIELDCAPTION("Sales Code"));
                    "Sales Type"::"Customer Price Group":
                      BEGIN
                        CustPriceGr.GET("Sales Code");
                        "Allow Line Disc." := CustPriceGr."Allow Line Disc.";
                        "Allow Invoice Disc." := CustPriceGr."Allow Invoice Disc.";
                      END;
                    "Sales Type"::Customer:
                      BEGIN
                        Cust.GET("Sales Code");
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
        field(13;"Sales Type";Option)
        {
            Caption = 'Sales Type';
            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign';
            OptionMembers = Customer,"Customer Price Group","All Customers",Campaign;

            trigger OnValidate()
            begin
                IF "Sales Type" <> xRec."Sales Type" THEN
                  VALIDATE("Sales Code",'');
            end;
        }
        field(15;"Item Category Code";Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(40;"Starting Date";Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
                  ERROR(Text000,FIELDCAPTION("Starting Date"),FIELDCAPTION("Ending Date"));
            end;
        }
        field(50;"Ending Date";Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                VALIDATE("Starting Date");
            end;
        }
        field(60;"Markup %";Decimal)
        {
            Caption = 'Markup %';
        }
        field(70;Base;Option)
        {
            Caption = 'Base';
            OptionCaption = 'Unit Cost';
            OptionMembers = "Unit Cost";
        }
        field(80;"Allow Line Disc.";Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(90;"Allow Invoice Disc.";Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
    }

    keys
    {
        key(Key1;"Item Category Code","Sales Type","Sales Code","Starting Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label '%1 cannot be after %2';
        Text001: Label '%1 must be blank.';
        CustPriceGr: Record "6";
        Cust: Record "18";
        Campaign: Record "5071";
}


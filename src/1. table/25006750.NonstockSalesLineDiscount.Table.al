table 25006750 "Nonstock Sales Line Discount"
{
    Caption = 'Nonstock Item Sales Line Discount';
    LookupPageID = 7004;

    fields
    {
        field(1; "Nonstock Item Entry No."; Code[20])
        {
            Caption = 'Nonstock Item Entry No.';
            NotBlank = true;
            TableRelation = "Nonstock Item";

            trigger OnValidate()
            begin
                IF xRec."Nonstock Item Entry No." <> "Nonstock Item Entry No." THEN BEGIN
                    "Unit of Measure Code" := '';
                END;
            end;
        }
        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
                    ERROR(Text000, FIELDCAPTION("Starting Date"), FIELDCAPTION("Ending Date"));

                IF CurrFieldNo = 0 THEN
                    EXIT;
            end;
        }
        field(5; "Line Discount %"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Line Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(8; "Sales Code"; Code[20])
        {
            Caption = 'Sales Code';
            TableRelation = IF (Sales Type=CONST(Customer Price Group)) "Customer Price Group"
                            ELSE IF (Sales Type=CONST(Customer)) Customer
                            ELSE IF (Sales Type=CONST(Campaign)) Campaign
                            ELSE IF (Sales Type=CONST(Contract)) Contract."Contract No." WHERE (Contract Type=CONST(Contract));
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnValidate()
            var
                CustPriceGr: Record "6";
                Cust: Record "18";
                Campaign: Record "5071";
            begin
                IF "Sales Code" <> '' THEN BEGIN
                  CASE "Sales Type" OF
                    "Sales Type"::"All Customers":
                      ERROR(Text001,FIELDCAPTION("Sales Code"));
                    "Sales Type"::"Customer Price Group":
                      BEGIN
                      END;
                    "Sales Type"::Customer:
                      BEGIN
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
        field(9;"Sales Type";Option)
        {
            Caption = 'Sales Type';
            InitValue = "All Customers";
            OptionCaption = ',,All Customers,Campaign,Contract';
            OptionMembers = Customer,"Customer Price Group","All Customers",Campaign,Contract;

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
            end;
        }
        field(5400;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(25006000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006003;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006120;"Source Type";Option)
        {
            Caption = 'Source Type';
            Editable = false;
            OptionCaption = 'User,Contract';
            OptionMembers = User,Contract;
        }
        field(25006130;Source;Code[20])
        {
            Caption = 'Source';
            Editable = false;
        }
        field(25006140;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
    }

    keys
    {
        key(Key1;"Nonstock Item Entry No.","Sales Type","Sales Code","Starting Date","Currency Code","Unit of Measure Code","Minimum Quantity","Vehicle Status Code","Document Profile")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        cuSalesPriceCalcMgt.NonstockSalesLineDiscToItem(Rec,xRec,3);
    end;

    trigger OnInsert()
    begin
        TESTFIELD("Nonstock Item Entry No.");
        "Source Type":="Source Type"::User;
        Source:=USERID;

        cuSalesPriceCalcMgt.NonstockSalesLineDiscToItem(Rec,xRec,0);
    end;

    trigger OnModify()
    begin
        cuSalesPriceCalcMgt.NonstockSalesLineDiscToItem(Rec,xRec,1);
    end;

    trigger OnRename()
    begin
        TESTFIELD("Nonstock Item Entry No.");

        cuSalesPriceCalcMgt.NonstockSalesLineDiscToItem(Rec,xRec,2);
    end;

    var
        Text000: Label '%1 cannot be after %2';
        Text001: Label '%1 must be blank.';
        cuSalesPriceCalcMgt: Codeunit "7000";
}


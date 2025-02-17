table 25006383 "Vehicle Assembly Header Arch."
{
    Caption = 'Vehicle Assembly Header Arch.';

    fields
    {
        field(10; "Assembly ID"; Code[20])
        {
            Caption = 'Assembly ID';
        }
        field(20; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                IF "Currency Code" <> xRec."Currency Code" THEN
                    UpdateAssemblyLines(FIELDCAPTION("Currency Code"), FALSE);
            end;
        }
        field(30; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Currency Factor" <> xRec."Currency Factor" THEN
                    UpdateAssemblyLines(FIELDCAPTION("Currency Factor"), FALSE);
            end;
        }
        field(40; "Exchange Date"; Date)
        {
            Caption = 'Exchange Date';
        }
        field(50; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                Currency: Record "4";
                RecalculatePrice: Boolean;
            begin
                IF "Prices Including VAT" <> xRec."Prices Including VAT" THEN BEGIN
                    VehAssembly.RESET;
                    VehAssembly.SETRANGE("Assembly ID", "Assembly ID");
                    VehAssembly.SETFILTER("Sales Price", '<>%1', 0);

                    IF VehAssembly.FINDSET(TRUE, FALSE) THEN BEGIN
                        RecalculatePrice := TRUE;
                        VehAssembly.SetAssemblyHeader(Rec);

                        IF "Currency Code" = '' THEN
                            Currency.InitRoundingPrecision
                        ELSE
                            Currency.GET("Currency Code");

                        REPEAT

                            IF "Prices Including VAT" THEN BEGIN
                                VehAssembly."Sales Price" :=
                                  ROUND(
                                    VehAssembly."Sales Price" * (1 + ("VAT %" / 100)),
                                    Currency."Unit-Amount Rounding Precision");
                                VehAssembly."Line Discount Amount" :=
                                  ROUND(
                                    VehAssembly."Sales Price" * VehAssembly."Line Discount %" / 100,
                                    Currency."Amount Rounding Precision");
                            END ELSE BEGIN
                                VehAssembly."Sales Price" :=
                                  ROUND(
                                    VehAssembly."Sales Price" / (1 + ("VAT %" / 100)),
                                    Currency."Unit-Amount Rounding Precision");

                                VehAssembly."Line Discount Amount" :=
                                  ROUND(
                                    VehAssembly."Sales Price" * VehAssembly."Line Discount %" / 100,
                                    Currency."Amount Rounding Precision");
                            END;
                            VehAssembly.UpdateAmounts;
                            VehAssembly.MODIFY;
                        UNTIL VehAssembly.NEXT = 0;
                    END;
                END;
            end;
        }
        field(60; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(70; "VAT Calculation Type"; Option)
        {
            Caption = 'VAT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(80; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(90; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(100; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(110; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(120; "Allow Invoice Disc."; Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(130; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(140; "Bill-to Contact No."; Code[20])
        {
            Caption = 'Bill-to Contact No.';
            TableRelation = Contact;
        }
        field(150; "Customer Price Group"; Code[10])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(160; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE(Use As In-Transit=CONST(No));
        }
        field(170; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
        }
        field(180; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(190; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(200; "Customer Disc. Group"; Code[10])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";

            trigger OnValidate()
            begin
                IF "Customer Disc. Group" <> xRec."Customer Disc. Group" THEN
                    UpdateAssemblyLines(FIELDCAPTION("Customer Disc. Group"), FALSE)
            end;
        }
        field(210; "Time Archived"; Time)
        {
            Caption = 'Time Archived';
        }
        field(211; "Date Archived"; Date)
        {
            Caption = 'Date Archived';
        }
        field(220; "Archived By"; Code[20])
        {
            Caption = 'Archived By';
        }
        field(230; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
    }

    keys
    {
        key(Key1; "Assembly ID", "Version No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        VehAssembly: Record "25006384";
        Text001: Label 'You have modified %1.\\';
        Text002: Label 'Do you want to update the lines?';
        Text003: Label '%1 and %2 cannot both be empty when %3 is used.';
        Text004: Label 'You cannot change %1 if the item charge has already been posted.';

    [Scope('Internal')]
    procedure UpdateAmounts(CalledByFieldNo: Integer)
    begin
        IF (CalledByFieldNo <> CurrFieldNo) AND (CurrFieldNo <> 0) THEN
            EXIT;
    end;

    [Scope('Internal')]
    procedure UpdateAssemblyLines(ChangedFieldName: Text[100]; AskQuestion: Boolean)
    var
        Question: Text[250];
        UpdateLines: Boolean;
    begin
        IF AssemblyLinesExist AND AskQuestion THEN BEGIN
            Question := STRSUBSTNO(
              Text001 +
              Text002, ChangedFieldName);
            IF GUIALLOWED AND NOT DIALOG.CONFIRM(Question, TRUE) THEN
                EXIT
            ELSE
                UpdateLines := TRUE;
        END;
        IF AssemblyLinesExist THEN BEGIN
            VehAssembly.LOCKTABLE;
            MODIFY;

            VehAssembly.RESET;
            VehAssembly.SETRANGE("Assembly ID", "Assembly ID");
            IF VehAssembly.FINDSET THEN
                REPEAT
                    CASE ChangedFieldName OF
                        FIELDCAPTION("Currency Factor"):
                            VehAssembly.VALIDATE("Sales Price");
                    END;

                    VehAssembly.MODIFY(TRUE);
                UNTIL VehAssembly.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure AssemblyLinesExist(): Boolean
    begin
        VehAssembly.RESET;
        VehAssembly.SETRANGE(VehAssembly."Assembly ID");
        EXIT(VehAssembly.FINDFIRST)
    end;
}


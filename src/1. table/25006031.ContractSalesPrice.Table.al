table 25006031 "Contract Sales Price"
{
    // 23.08.2013 EDMS P8
    //   * New type "Labor Price Group" in field Type

    Caption = 'Contract Sales Price';
    LookupPageID = 25006056;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = IF (Type = CONST(Item)) Item WHERE(Item Type=CONST(Item))
                            ELSE IF (Type=CONST(Labor)) "Service Labor".No.
                            ELSE IF (Type=CONST(Labor Price Group)) "Service Labor Price Group";

            trigger OnValidate()
            begin
                TestStatusOpen;
                IF Code <> xRec.Code THEN BEGIN
                  "Unit of Measure Code" := '';
                  "Variant Code" := '';
                END;
            end;
        }
        field(3;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(4;"Starting Date";Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                TestStatusOpen;
                IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
                  ERROR(Text000,FIELDCAPTION("Starting Date"),FIELDCAPTION("Ending Date"));
            end;
        }
        field(5;"Unit Price";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(7;"Price Includes VAT";Boolean)
        {
            Caption = 'Price Includes VAT';

            trigger OnValidate()
            begin
                TestStatusOpen;
                IF ("Price Includes VAT" <> xRec."Price Includes VAT") AND "Price Includes VAT" THEN
                  MESSAGE(Text100,FIELDCAPTION("VAT Bus. Posting Gr. (Price)"))
            end;
        }
        field(10;"Allow Invoice Disc.";Boolean)
        {
            Caption = 'Allow Invoice Disc.';
            InitValue = true;
        }
        field(11;"VAT Bus. Posting Gr. (Price)";Code[10])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";
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
                TestStatusOpen;
                IF CurrFieldNo = 0 THEN
                  EXIT;

                VALIDATE("Starting Date");
            end;
        }
        field(20;"Contract Type";Option)
        {
            Caption = 'Contract Type';
            Description = 'Not Supported. Reserved for future.';
            OptionCaption = 'Quote,Contract';
            OptionMembers = Quote,Contract;
        }
        field(30;"Contract No.";Code[20])
        {
            Caption = 'Contract No.';
        }
        field(40;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Item,Labor,Labor Price Group';
            OptionMembers = Item,Labor,"Labor Price Group";
        }
        field(60;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                Vehicle.RESET;
                IF cuLookupMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") THEN
                 BEGIN
                  VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
                  VIN := Vehicle.VIN;
                 END;
            end;
        }
        field(65;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
            begin
                recVehicle.RESET;
                IF cuLookupMgt.LookUpVehicleAMT(recVehicle,"Vehicle Serial No.") THEN
                 BEGIN
                  VALIDATE("Vehicle Serial No.",recVehicle."Serial No.");
                  VIN := recVehicle.VIN;
                 END;
            end;

            trigger OnValidate()
            var
                recReservationEntry: Record "337";
                iEntryNo: Integer;
                cSalesLineReserve: Codeunit "99000832";
                recVehicle: Record "25006005";
                codSerialNoPre: Code[20];
                codDefCycle: Code[20];
                cuVehAccCycle: Codeunit "25006303";
            begin
                TestStatusOpen;
                IF "Vehicle Serial No." = '' THEN
                 BEGIN
                  VIN := '';
                 END
                ELSE
                 BEGIN
                  Vehicle.RESET;
                  IF Vehicle.GET("Vehicle Serial No.") THEN
                   BEGIN
                    codSerialNoPre := "Vehicle Serial No.";
                    VIN := Vehicle.VIN;
                    "Vehicle Serial No." := codSerialNoPre;
                   END;
                 END;
            end;
        }
        field(5400;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(Code))
                            ELSE IF (Type=CONST(Labor)) "Unit of Measure".Code;
        }
        field(5700;"Variant Code";Code[20])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(Code));
        }
        field(7001;"Allow Line Disc.";Boolean)
        {
            Caption = 'Allow Line Disc.';
            InitValue = true;
        }
        field(25006000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Service';
            OptionMembers = " ","Spare Parts Trade",Service;
        }
        field(25006700;"Ordering Price Type Code";Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006770;"Location Code";Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
    }

    keys
    {
        key(Key1;"Contract Type","Contract No.",Type,"Code","Starting Date","Currency Code","Variant Code","Unit of Measure Code","Minimum Quantity","Ordering Price Type Code","Location Code","Document Profile","Vehicle Serial No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label '%1 cannot be after %2';
        Cust: Record "18";
        Campaign: Record "5071";
        Item: Record "27";
        Vehicle: Record "25006005";
        Contract: Record "25006016";
        cuLookupMgt: Codeunit "25006003";
        Text100: Label 'Don''t forget to set %1';

    local procedure TestStatusOpen()
    begin
        Contract.TESTFIELD(Status,Contract.Status::Inactive);
    end;
}


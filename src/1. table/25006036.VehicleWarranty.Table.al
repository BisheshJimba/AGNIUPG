table 25006036 "Vehicle Warranty"
{
    // 30.01.2014 Elva Baltic P8 #F038 MMG7.00
    //   * Added field Description, "Ending Date"

    Caption = 'Vehicle Warranty';
    DataPerCompany = false;
    LookupPageID = 25006027;

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(20; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    ServiceSetup.GET;
                    NoSeriesMgt.TestManual(ServiceSetup."Warranty Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(30; "Warranty Type Code"; Code[20])
        {
            Caption = 'Warranty Type Code';
            TableRelation = "Vehicle Warranty Type";

            trigger OnValidate()
            var
                VehicleWarrantyType: Record "25006035";
            begin
                IF VehicleWarrantyType.GET("Warranty Type Code") THEN BEGIN
                    "Term Date Formula" := VehicleWarrantyType."Term Date Formula";
                    "Kilometrage Limit" := VehicleWarrantyType."Variable Field Run 1";
                    "Variable Field Run 2" := VehicleWarrantyType."Variable Field Run 2";
                    "Variable Field Run 3" := VehicleWarrantyType."Variable Field Run 3";
                END;
            end;
        }
        field(40; VIN; Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Caption = 'VIN';
                Editable = false;
                FieldClass = FlowField;
        }
        field(50; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                IF ("Starting Date" <> 0D) AND (FORMAT("Term Date Formula") <> '') THEN BEGIN
                    "Ending Date" := CALCDATE("Term Date Formula", "Starting Date");
                END;
            end;
        }
        field(60; "Term Date Formula"; DateFormula)
        {
            Caption = 'Term Date Formula';

            trigger OnValidate()
            begin
                IF ("Starting Date" <> 0D) AND (FORMAT("Term Date Formula") <> '') THEN BEGIN
                    "Ending Date" := CALCDATE("Term Date Formula", "Starting Date");
                END;
            end;
        }
        field(70; "Kilometrage Limit"; Integer)
        {
            Description = 'Kilometrage Limit';
        }
        field(71; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006036,71';
        }
        field(72; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006036,72';
        }
        field(80; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Active,Not Active';
            OptionMembers = Active,"Not Active";
        }
        field(140; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(200; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(210; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006036,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
                Vehicle: Record "25006005";
            begin
                IF Vehicle.GET("Vehicle Serial No.") THEN;
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"Vehicle Warranty", FIELDNO("Variable Field 25006800"),
                  Vehicle."Make Code", "Variable Field 25006800") THEN BEGIN
                    VALIDATE("Variable Field 25006800", VFOptions.Code);
                END;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006036,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
                Vehicle: Record "25006005";
            begin
                IF Vehicle.GET("Vehicle Serial No.") THEN;
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"Vehicle Warranty", FIELDNO("Variable Field 25006801"),
                  Vehicle."Make Code", "Variable Field 25006801") THEN BEGIN
                    VALIDATE("Variable Field 25006801", VFOptions.Code);
                END;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006036,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
                Vehicle: Record "25006005";
            begin
                IF Vehicle.GET("Vehicle Serial No.") THEN;
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"Vehicle Warranty", FIELDNO("Variable Field 25006802"),
                  Vehicle."Make Code", "Variable Field 25006802") THEN BEGIN
                    VALIDATE("Variable Field 25006802", VFOptions.Code);
                END;
            end;
        }
        field(25006803; "Variable Field 25006803"; Code[20])
        {
            CaptionClass = '7,25006036,25006803';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
                Vehicle: Record "25006005";
            begin
                IF Vehicle.GET("Vehicle Serial No.") THEN;
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"Vehicle Warranty", FIELDNO("Variable Field 25006803"),
                  Vehicle."Make Code", "Variable Field 25006803") THEN BEGIN
                    VALIDATE("Variable Field 25006803", VFOptions.Code);
                END;
            end;
        }
        field(25006804; "Variable Field 25006804"; Code[20])
        {
            CaptionClass = '7,25006036,25006804';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
                Vehicle: Record "25006005";
            begin
                IF Vehicle.GET("Vehicle Serial No.") THEN;
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"Vehicle Warranty", FIELDNO("Variable Field 25006804"),
                  Vehicle."Make Code", "Variable Field 25006804") THEN BEGIN
                    VALIDATE("Variable Field 25006804", VFOptions.Code);
                END;
            end;
        }
        field(25006805; "Variable Field 25006805"; Code[20])
        {
            CaptionClass = '7,25006036,25006805';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
                Vehicle: Record "25006005";
            begin
                IF Vehicle.GET("Vehicle Serial No.") THEN;
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"Vehicle Warranty", FIELDNO("Variable Field 25006805"),
                  Vehicle."Make Code", "Variable Field 25006805") THEN BEGIN
                    VALIDATE("Variable Field 25006805", VFOptions.Code);
                END;
            end;
        }
        field(25006806; "Variable Field 25006806"; Code[20])
        {
            CaptionClass = '7,25006036,25006806';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
                Vehicle: Record "25006005";
            begin
                IF Vehicle.GET("Vehicle Serial No.") THEN;
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"Vehicle Warranty", FIELDNO("Variable Field 25006806"),
                  Vehicle."Make Code", "Variable Field 25006806") THEN BEGIN
                    VALIDATE("Variable Field 25006806", VFOptions.Code);
                END;
            end;
        }
        field(25006807; "Variable Field 25006807"; Code[20])
        {
            CaptionClass = '7,25006036,25006807';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
                Vehicle: Record "25006005";
            begin
                IF Vehicle.GET("Vehicle Serial No.") THEN;
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"Vehicle Warranty", FIELDNO("Variable Field 25006807"),
                  Vehicle."Make Code", "Variable Field 25006807") THEN BEGIN
                    VALIDATE("Variable Field 25006807", VFOptions.Code);
                END;
            end;
        }
        field(25006808; "Variable Field 25006808"; Code[20])
        {
            CaptionClass = '7,25006036,25006808';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
                Vehicle: Record "25006005";
            begin
                IF Vehicle.GET("Vehicle Serial No.") THEN;
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"Vehicle Warranty", FIELDNO("Variable Field 25006808"),
                  Vehicle."Make Code", "Variable Field 25006808") THEN BEGIN
                    VALIDATE("Variable Field 25006808", VFOptions.Code);
                END;
            end;
        }
        field(25006809; "Variable Field 25006809"; Code[20])
        {
            CaptionClass = '7,25006036,25006809';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
                Vehicle: Record "25006005";
            begin
                IF Vehicle.GET("Vehicle Serial No.") THEN;
                VFOptions.RESET;
                IF LookupMgt.LookUpVariableField(VFOptions, DATABASE::"Vehicle Warranty", FIELDNO("Variable Field 25006809"),
                  Vehicle."Make Code", "Variable Field 25006809") THEN BEGIN
                    VALIDATE("Variable Field 25006809", VFOptions.Code);
                END;
            end;
        }
        field(33020235; "Spare Warranty"; Boolean)
        {
        }
        field(33020236; Item; Code[20])
        {
            TableRelation = IF (Spare Warranty=CONST(Yes)) Item WHERE (Item Type=CONST(Item));
        }
    }

    keys
    {
        key(Key1; "Vehicle Serial No.", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            ServiceSetup.GET;
            ServiceSetup.TESTFIELD("Warranty Nos.");
            NoSeriesMgt.InitSeries(ServiceSetup."Warranty Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
    end;

    var
        VFMgt: Codeunit "25006004";
        LookupMgt: Codeunit "25006003";
        ServiceSetup: Record "25006120";
        NoSeriesMgt: Codeunit "396";
        VehWarranty: Record "25006036";

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        CLEAR(VFMgt);
        EXIT(VFMgt.IsVFActive(DATABASE::"Vehicle Warranty", intFieldNo));
    end;

    [Scope('Internal')]
    procedure AssistEdit(OldWarranty: Record "25006036"): Boolean
    begin
        VehWarranty := Rec;
        ServiceSetup.GET;
        ServiceSetup.TESTFIELD("Warranty Nos.");
        IF NoSeriesMgt.SelectSeries(ServiceSetup."Warranty Nos.", OldWarranty."No. Series", VehWarranty."No. Series") THEN BEGIN
            ServiceSetup.GET;
            ServiceSetup.TESTFIELD("Warranty Nos.");
            NoSeriesMgt.SetSeries(VehWarranty."No.");
            Rec := VehWarranty;
            EXIT(TRUE);
        END;
    end;
}


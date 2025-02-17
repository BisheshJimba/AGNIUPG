table 25006017 "Contract Sales Line Discount"
{
    // 16.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified triggers:
    //     Type - OnValidate()
    //     No. - OnValidate()
    // 
    // 30.01.2014 Elva Baltic P8 #F038 MMG7.00
    //   * Added Key
    // 
    // 09.10.2013 EDMS P8
    //   * Added fields: Make Code, Group
    // 
    // 23.08.2013
    //   * new option in Type: "Labor Discount Group"

    Caption = 'Contract Sales Line Discount';
    DrillDownPageID = "Contract Sales Line Discount";
    LookupPageID = "Contract Sales Line Discount";

    fields
    {
        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(5; "Contract Type"; Option)
        {
            Caption = 'Contract Type';
            Description = 'Not Supported. Reserved for future.';
            OptionCaption = 'Quote,Contract';
            OptionMembers = Quote,Contract;
        }
        field(10; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = IF ("Contract Type" = CONST(Contract)) Contract."Contract No.";
        }
        field(14; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            MinValue = 0;
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(40; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Item Category,Labor,Labor Discount Group';
            OptionMembers = "Item Category",Labor,"Labor Discount Group";

            trigger OnValidate()
            begin
                // TestStatusOpen;                                                            // 16.04.2014 Elva Baltic P21
                "No." := '';
                IF Type <> Type::"Item Category" THEN BEGIN
                    VALIDATE("Product Group Code", '');
                    VALIDATE("Product Subgroup Code", '');
                END;
            end;
        }
        field(50; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(Labor)) "Service Labor".No.
                            ELSE IF (Type = CONST("Item Category")) "Item Category".Code
            ELSE IF (Type = CONST("Labor Discount Group")) "Service Labor Discount Group".Code;

            trigger OnValidate()
            begin
                // TestStatusOpen;                                                            // 16.04.2014 Elva Baltic P21
                CASE Type OF
                    Type::"Item Category":
                        IF recItemGroup.GET("No.") THEN
                            Description := recItemGroup.Description;
                    Type::"Labor Discount Group":
                        IF ServiceLaborDiscountGroup.GET("No.") THEN
                            Description := ServiceLaborDiscountGroup.Description;
                    Type::Labor:
                        BEGIN
                            //"No.":='';
                        END;
                END;
            end;
        }
        field(60; VIN; Code[20])
        {
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;

            CalcFormula = Lookup(Vehicle.VIN WHERE("Serial No." = FIELD("Vehicle Serial No.")));
            trigger OnLookup()
            begin
                recVehicle.RESET;
                IF cuLookUpMgt.LookUpVehicleAMT(recVehicle, "Vehicle Serial No.") THEN BEGIN
                    VALIDATE("Vehicle Serial No.", recVehicle."Serial No.");
                    VIN := recVehicle.VIN;
                END;
            end;
        }
        field(65; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';

            trigger OnLookup()
            var
                recVehicle: Record Vehicle;
            begin
                recVehicle.RESET;
                IF cuLookUpMgt.LookUpVehicleAMT(recVehicle, "Vehicle Serial No.") THEN BEGIN
                    VALIDATE("Vehicle Serial No.", recVehicle."Serial No.");
                    VIN := recVehicle.VIN;
                END;
            end;

            trigger OnValidate()
            var
                recReservationEntry: Record "Reservation Entry";
                iEntryNo: Integer;
                cSalesLineReserve: Codeunit "Sales Line-Reserve";
                recVehicle: Record Vehicle;
                codSerialNoPre: Code[20];
                codDefCycle: Code[20];
                cuVehAccCycle: Codeunit 25006303;
            begin
                TestStatusOpen;

                IF "Vehicle Serial No." = '' THEN BEGIN
                    VIN := '';
                END
                ELSE BEGIN
                    recVehicle.RESET;
                    IF recVehicle.GET("Vehicle Serial No.") THEN BEGIN
                        codSerialNoPre := "Vehicle Serial No.";
                        VIN := recVehicle.VIN;
                        "Vehicle Serial No." := codSerialNoPre;
                    END;
                END;
            end;
        }
        field(70; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(190; "Contract Expiration Date"; Date)
        {
            Caption = 'Contract Expiration Date';
        }
        field(220; "Line Discount %"; Decimal)
        {
            AutoFormatType = 2;
            BlankZero = true;
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(240; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            Editable = false;
        }
        field(250; "Ending Date"; Date)
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
        field(5400; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(5410; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = IF (Type = CONST("Item Category")) "Product Group".Code WHERE("Item Category Code" = FIELD("No."));

            trigger OnValidate()
            var
                ProductSubgrp: Record "Product Subgroup";
            begin
                IF NOT ProductSubgrp.GET("No.", "Product Group Code", "Product Subgroup Code") THEN
                    VALIDATE("Product Subgroup Code", '')
                ELSE
                    VALIDATE("Product Subgroup Code");
            end;
        }
        field(5420; "Product Subgroup Code"; Code[10])
        {
            Caption = 'Product Subgroup Code';
            TableRelation = IF (Type = CONST("Item Category")) "Product Subgroup".Code WHERE("Item Category Code" = FIELD("No."),
                                                                                          "Product Group Code" = FIELD("Product Group Code"));
        }
        field(5430; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Service';
            OptionMembers = " ","Spare Parts Trade",Service;
        }
        field(25006770; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
    }

    keys
    {
        key(Key1; "Contract Type", "Contract No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Vehicle Serial No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        recItemGroup: Record "Item Discount Group";
        ServiceLaborDiscountGroup: Record "Service Labor Discount Group";
        ContractSalesLineDiscount: Record "Contract Sales Line Discount";
        StatusCheckSuspended: Boolean;
        Contract: Record Contract;
        recVehicle: Record Vehicle;
        cuLookUpMgt: Codeunit 25006003;

    local procedure TestStatusOpen()
    begin
        IF StatusCheckSuspended THEN
            EXIT;
        Contract.GET("Contract Type", "Contract No.");
        Contract.TESTFIELD(Status, Contract.Status::Inactive);
    end;

    [Scope('Internal')]
    procedure fNewRec()
    begin
        IF ("Line No." = 0) AND ("Contract No." <> '') THEN BEGIN
            Contract.GET("Contract Type", "Contract No.");
        END;
    end;

    [Scope('Internal')]
    procedure UpdateCust(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Cust: Record Customer;
        Cont: Record Contact;
        CustTemplate: Record "Customer Template";
        ContComp: Record Contact;
        recContrHeader: Record Contract;
    begin
        recContrHeader.GET(ContactNo);
        IF NOT MODIFY THEN
            INSERT
    end;

    [Scope('Internal')]
    procedure UpdateCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
        Cust: Record Customer;
        ServOrderMgt: Codeunit 5900;
        ContactNo: Code[20];
        recContrHeader: Record Contract;
    begin
        recContrHeader.GET("Contract No.");
        IF Cust.GET(CustomerNo) THEN BEGIN
            CLEAR(ServOrderMgt);
            ContactNo := ServOrderMgt.FindContactInformation(Cust."No.");
        END;
    end;

    [Scope('Internal')]
    procedure ShowSigners()
    var
        recContractSigners: Record "Contract Signer";
        PageContractSigners: Page "Contract Signers";
    begin
        TESTFIELD("Contract No.");
        TESTFIELD("Line No.");
        recContractSigners.RESET;
        recContractSigners.SETRANGE("Contract Type", "Contract Type");
        recContractSigners.SETRANGE("Contract No.", "Contract No.");
        recContractSigners.SETRANGE("Contract Line No.", "Line No.");
        PageContractSigners.SETTABLEVIEW(recContractSigners);
        PageContractSigners.RUNMODAL;
    end;
}


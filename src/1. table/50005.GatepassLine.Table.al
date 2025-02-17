table 50005 "Gatepass Line"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = ' ,Admin,Spare Parts Trade,Vehicle Trade,Vehicle Service';
            OptionMembers = " ",Admin,"Spare Parts Trade","Vehicle Trade","Vehicle Service";
        }
        field(2; "Document No."; Code[20])
        {
            TableRelation = "Gatepass Header"."Document No";
        }
        field(3; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(4; "Item No."; Code[20])
        {
            TableRelation = IF ("Item Type" = CONST(Vehicle)) Vehicle."Serial No."
            ELSE IF ("Item Type" = CONST(Spares)) Item."No."
            ELSE IF ("Item Type" = CONST("Fixed Asset")) "Fixed Asset"."No.";

            trigger OnValidate()
            var
                LclVehicle: Record Vehicle;
                Item: Record Item;
                Labor: Record "Service Labor";
                ExtServ: Record "External Service";
            begin
                //IF Item Type is Vehicle then get vehicle details.
                IF "Item Type" = "Item Type"::Vehicle THEN BEGIN
                    LclVehicle.RESET;
                    LclVehicle.SETRANGE("Serial No.", "Item No.");
                    IF LclVehicle.FIND('-') THEN BEGIN
                        "Vehicle Chassis No." := LclVehicle.VIN;
                        // "Vehicle Reg. No." := LclVehicle."Registration No."; //need to solve table error
                    END;
                END;
                IF "Item Type" = "Item Type"::Spares THEN BEGIN
                    IF Item.GET("Item No.") THEN BEGIN
                        "Item Description" := Item.Description;
                    END;
                END ELSE IF "Item Type" = "Item Type"::Labor THEN BEGIN
                    IF Labor.GET("Item No.") THEN
                        "Item Description" := Labor.Description;
                END ELSE IF "Item Type" = "Item Type"::"Ext. Service" THEN BEGIN
                    IF ExtServ.GET("Item No.") THEN
                        "Item Description" := ExtServ.Description;
                END;
            end;
        }
        field(5; "Item Description"; Text[50])
        {
        }
        field(6; Quantity; Decimal)
        {

            trigger OnValidate()
            var
                Text000: Label 'When Item Type is "Vehicle", quantity must be equal to 1 (One).';
            begin
                IF "Item Type" = "Item Type"::Vehicle THEN BEGIN
                    IF (Quantity > 1) THEN
                        ERROR(Text000);
                END;
            end;
        }
        field(7; "Item Type"; Option)
        {
            OptionCaption = ' ,Vehicle,Spares,Fixed Asset,Labor,Ext. Service';
            OptionMembers = " ",Vehicle,Spares,"Fixed Asset",Labor,"Ext. Service";
        }
        field(8; "Vehicle Reg. No."; Code[20])
        {
        }
        field(9; "Vehicle Chassis No."; Code[20])
        {
        }
        field(10; "Service Line Print"; Boolean)
        {
        }
        field(11; "Ext Document No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


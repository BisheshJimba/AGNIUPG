table 50009 "Dispatch Buffer"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; Month; Code[20])
        {
        }
        field(3; "Document No."; Code[20])
        {
        }
        field(4; "Delivery No."; Code[20])
        {
        }
        field(5; Custom_IVL; Code[20])
        {
        }
        field(6; "Document Date"; Date)
        {
        }
        field(7; Quantity; Decimal)
        {
        }
        field(8; "Model Version No."; Code[20])
        {
            // TableRelation = Item.No. WHERE (Item Type=CONST(Model Version));
            TableRelation = Item."No." WHERE(Type = filter('Model Version'));
        }
        field(9; Description; Text[50])
        {
        }
        field(10; "Plant Code"; Code[10])
        {
        }
        field(11; VIN; Code[20])
        {

            trigger OnLookup()
            var
                recVehicle: Record Vehicle;
                LookUpMgt: Codeunit LookUpManagement;
            begin
                recVehicle.RESET;
                // IF LookUpMgt.LookUpVehicleAMT(recVehicle, "Vehicle Serial No.") THEN //internal scope error
                BEGIN
                    VALIDATE("Vehicle Serial No.", recVehicle."Serial No.");
                    VIN := recVehicle.VIN;
                END;
            end;
        }
        field(12; "Transmission No."; Code[20])
        {
        }
        field(13; "Sales Order No."; Code[20])
        {
        }
        field(14; "Del. Name"; Text[50])
        {
        }
        field(15; "Del. City"; Text[30])
        {
        }
        field(16; "Ship To"; Code[10])
        {
        }
        field(17; "Sold To"; Code[10])
        {
        }
        field(18; Region; Text[30])
        {
        }
        field(19; "Bill Type"; Code[10])
        {
        }
        field(20; "LC No."; Code[20])
        {
        }
        field(21; "Make Code"; Code[20])
        {
            TableRelation = Make;
        }
        field(22; "Model Code"; Code[20])
        {
            TableRelation = Model;
        }
        field(23; "PO No."; Code[20])
        {
        }
        field(24; "Variant Code"; Code[20])
        {
        }
        field(25; "Engine No."; Code[20])
        {
        }
        field(26; "Serial No."; Code[20])
        {
        }
        field(50000; "VIN Allocated"; Boolean)
        {
        }
        field(50001; "Vehicle Created"; Boolean)
        {
        }
        field(50002; "Allocated Document No."; Code[20])
        {
        }
        field(50003; "Tender\Damaged"; Option)
        {
            OptionCaption = ' ,Tender,Damaged';
            OptionMembers = " ",Tender,Damaged;
        }
        field(50004; "Vehicle Serial No."; Code[20])
        {
        }
        field(50005; "Imported By"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(50006; "Vehicle Location"; Code[20])
        {
            TableRelation = Location;
        }
        field(50007; "Document Received"; Boolean)
        {
        }
        field(50008; "Vehicle Received"; Boolean)
        {
        }
        field(60000; "Gross Invoice"; Decimal)
        {
        }
        field(60001; "Freight Amount"; Decimal)
        {
        }
        field(60002; "Production Year"; Code[10])
        {
        }
        field(60003; Date; Date)
        {
        }
        field(60004; "Table"; Option)
        {
            OptionCaption = ' ,Customer,Vendor,Item/Model Version,Vehicle,Bank Account,Fixed Assets,Salesperson/Purchaser,Global Contacts';
            OptionMembers = " ",Customer,Vendor,"Item/Model Version",Vehicle,"Bank Account","Fixed Assets","Salesperson/Purchaser","Global Contacts";
        }
        field(60005; Reason; Text[100])
        {
        }
        field(60006; "Block Type"; Option)
        {
            OptionCaption = 'Unblock,Ship,Invoice,Payment,All';
            OptionMembers = Unblock,Ship,Invoice,Payment,All;
        }
        field(60007; "Record No."; Code[20])
        {
        }
        field(60008; Company; Text[50])
        {
        }
        field(60009; "Blocked By VFD"; Boolean)
        {
        }
        field(60010; "Blocked For"; Code[20])
        {
            TableRelation = "General Master".Code WHERE(Category = CONST('BLOCK'),
                                                         "Sub Category" = CONST('VEHICLE'));
        }
        field(60011; "Blocked by Recovery"; Boolean)
        {
        }
        field(60012; "User ID"; Code[50])
        {
        }
    }

    keys
    {
        key(Key1; VIN)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Imported By" := USERID;
    end;
}


tableextension 50336 tableextension50336 extends "Transfer Shipment Line"
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 21)".

        modify("Transfer-from Bin Code")
        {
            TableRelation = Bin.Code WHERE(Location Code=FIELD(Transfer-from Code),
                                            Item Filter=FIELD(Item No.),
                                            Variant Filter=FIELD(Variant Code));
        }
        field(50000;Confirmed;Boolean)
        {
            Editable = false;
        }
        field(50001;"Confirmed Date";Date)
        {
            Editable = false;
        }
        field(50002;"Confirmed Time";Time)
        {
            Editable = false;
        }
        field(50003;"Confirmed By";Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(60000;"Allotment Date";Date)
        {
        }
        field(60001;"Allotment Time";Time)
        {
        }
        field(60002;"System Allotment";Boolean)
        {
        }
        field(60004;"Allotment Due Date";Date)
        {
        }
        field(60005;"Sys. LC No.";Code[20])
        {
            TableRelation = "LC Details".No. WHERE (Transaction Type=CONST(Sale),
                                                    Released=CONST(Yes),
                                                    Closed=CONST(No));

            trigger OnValidate()
            var
                LCAmendDetail: Record "33020013";
                LCDetail: Record "33020012";
                Text33020011: Label 'LC has amendments and amendment is not released.';
                Text33020012: Label 'LC has amendments and  amendment is closed.';
                Text33020013: Label 'LC Details is not released.';
                Text33020014: Label 'LC Details is closed.';
            begin
            end;
        }
        field(60006;"Bank LC No.";Code[20])
        {
        }
        field(70000;"Supplier Code";Code[10])
        {
            Description = 'QR19.00';
        }
        field(25006000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006170;"Vehicle Registration No.";Code[20])
        {
            CalcFormula = Lookup(Vehicle."Registration No." WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006370;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
            TableRelation = Make;
        }
        field(25006371;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            Editable = false;
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(25006373;VIN;Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
            begin
                recVehicle.RESET;
                IF PAGE.RUNMODAL(PAGE::"Vehicle Assembly Worksh. Arch.",recVehicle) = ACTION::LookupOK THEN
                 VALIDATE(VIN,recVehicle.VIN);
            end;
        }
        field(25006374;"Model Version No.";Code[20])
        {
            Caption = 'Model Version No.';
            Editable = false;
            TableRelation = Item.No. WHERE (Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=CONST(Model Version));

            trigger OnLookup()
            var
                recItem: Record "27";
            begin
                recItem.RESET;
                IF cuLookUpMgt.LookUpModelVersion(recItem,"Item No.","Make Code","Model Code") THEN
                  VALIDATE("Model Version No.",recItem."No.");
            end;
        }
        field(25006375;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle".No.;

            trigger OnLookup()
            var
                recVehAccCycle: Record "25006024";
            begin
                recVehAccCycle.RESET;
                IF cuLookUpMgt.LookUpVehicleAccCycle(recVehAccCycle,"Vehicle Serial No.","Vehicle Accounting Cycle No.") THEN;
            end;
        }
        field(25006380;"Vehicle Status Code";Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006390;Kilometrage;Integer)
        {
        }
        field(25006996;"Variable Field Run 2";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,5745,25006996';
        }
        field(25006997;"Variable Field Run 3";Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,5745,25006997';
        }
        field(33019831;"Reason Code";Code[20])
        {
            TableRelation = "Transfer Reason Code".No.;
        }
        field(33019834;"Unit Price";Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(33019835;Amount;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
        }
        field(33019836;"Requisition Date";Date)
        {
            Editable = false;
        }
        field(33020163;"CC Memo No.";Code[20])
        {
            TableRelation = "CC Memo Header"."Reference No." WHERE (Posted=CONST(Yes));
        }
        field(33020164;"PP No.";Code[20])
        {
        }
        field(33020165;"Source No.";Code[20])
        {
            CalcFormula = Lookup("Transfer Shipment Header"."Source No." WHERE (No.=FIELD(Document No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020166;"Document Date";Date)
        {
        }
        field(99000757;CBM;Decimal)
        {
            DecimalPlaces = 0:6;
        }
    }


    //Unsupported feature: Code Modification on "CopyFromTransferLine(PROCEDURE 1)".

    //procedure CopyFromTransferLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        "Line No." := TransLine."Line No.";
        "Item No." := TransLine."Item No.";
        Description := TransLine.Description;
        #4..17
        "Units per Parcel" := TransLine."Units per Parcel";
        "Description 2" := TransLine."Description 2";
        "Transfer Order No." := TransLine."Document No.";
        "Shipment Date" := TransLine."Shipment Date";
        "Shipping Agent Code" := TransLine."Shipping Agent Code";
        "Shipping Agent Service Code" := TransLine."Shipping Agent Service Code";
        "In-Transit Code" := TransLine."In-Transit Code";
        #25..27
        "Shipping Time" := TransLine."Shipping Time";
        "Item Category Code" := TransLine."Item Category Code";
        "Product Group Code" := TransLine."Product Group Code";
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..20
        "Shipment Date" := TODAY;
        #22..30
        "Unit Price" := TransLine."Unit Price";
        Amount := TransLine.Amount;
        "Document Date" := TransLine."Document Date"; //MIN 5/6/2019
        "Supplier Code" := TransLine."Supplier Code";  //QR19.00 May 29th 2019
        */
    //end;

    var
        cuLookUpMgt: Codeunit "25006003";
}


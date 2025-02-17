tableextension 50338 tableextension50338 extends "Transfer Receipt Line"
{
    // 20.01.2017 EDMS Upgrade 2017
    //   Modified function CopyFromTransferLine
    // 
    // 29.04.2014 Elva Baltic P8 #F037 MMG7.00
    //   * Added fields:"Vehicle Status Code"
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Variant Code"(Field 21)".

        modify("Transfer-To Bin Code")
        {
            TableRelation = Bin.Code WHERE(Location Code=FIELD(Transfer-to Code),
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
            CalcFormula = Lookup("Transfer Receipt Header"."Source No." WHERE (No.=FIELD(Document No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020166;"Line Exist in Job";Boolean)
        {
            CalcFormula = Exist("Service Line EDMS" WHERE (Document Type=CONST(Order),
                                                           Document No.=FIELD(Source No.),
                                                           No.=FIELD(Item No.)));
            Description = 'temporary use for checking whether the item has been used or not (Service Module)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020167;"Document Date";Date)
        {
        }
        field(99000757;CBM;Decimal)
        {
            DecimalPlaces = 10:10;
        }
    }
    keys
    {
        key(Key1;"Vehicle Serial No.","Vehicle Accounting Cycle No.","Receipt Date")
        {
        }
    }

    //Unsupported feature: Variable Insertion (Variable: Vehicle) (VariableCollection) on "CopyFromTransferLine(PROCEDURE 1)".



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
        "Receipt Date" := TransLine."Receipt Date";
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
        "Receipt Date" := TODAY;
        #22..30
        "Unit Price" := TransLine."Unit Price";
        Amount := TransLine.Amount;
        "Document Date" := TransLine."Document Date"; //MIN 5/6/2019
        //VHT6.1.0 - 14 FEB 2012 Agile
        "CC Memo No." := TransLine."CC Memo No.";
        "PP No." := TransLine."PP No.";
        //VHT6.1.0 - 14 FEB 2012 Agile
        "Requisition Date" := TransLine."Requisition Date"; // VSW 6.1.0 19 NOV 2012
        //20.01.2017 EDMS Upgrade 2017 >>
        IF TransLine."To Location Dimension 1 Code" <> '' THEN
          "Shortcut Dimension 1 Code" := TransLine."To Location Dimension 1 Code"
        ELSE
          "Shortcut Dimension 1 Code" := TransLine."Shortcut Dimension 1 Code";
        IF TransLine."To Location Dimension 2 Code" <> '' THEN
          "Shortcut Dimension 2 Code" := TransLine."To Location Dimension 2 Code"
        ELSE
          "Shortcut Dimension 2 Code" := TransLine."Shortcut Dimension 2 Code";

        "Document Profile" := TransLine."Document Profile";
        "Make Code" := TransLine."Make Code";
        "Model Code" := TransLine."Model Code";
        "Model Version No." := TransLine."Model Version No.";
        VIN := TransLine.VIN;
        "Vehicle Serial No." := TransLine."Vehicle Serial No.";
        "Vehicle Accounting Cycle No." := TransLine."Vehicle Accounting Cycle No.";
        "Vehicle Status Code" := TransLine."Vehicle Status Code";
        "Supplier Code" := TransLine."Supplier Code"; //QR19.00 May 29th 2019
        {
        IF Vehicle.GET(TransLine."Vehicle Serial No.") THEN BEGIN
          Vehicle.VALIDATE("Status Code", "Vehicle Status Code");
          Vehicle.MODIFY;
        END;
        }
        //20.01.2017 EDMS Upgrade 2017 <<
        */
    //end;

    var
        cuLookUpMgt: Codeunit "25006003";
}


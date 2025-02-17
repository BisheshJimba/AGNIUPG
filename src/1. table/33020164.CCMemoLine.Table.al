table 33020164 "CC Memo Line"
{

    fields
    {
        field(1; "Reference No."; Code[20])
        {
            TableRelation = "CC Memo Header"."Reference No.";
        }
        field(2; "Chasis No."; Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Editable = false;
                FieldClass = FlowField;

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
                LookUpMgt: Codeunit "25006003";
                recSalesRecSetup: Record "311";
            begin
                recVehicle.RESET;
                recSalesRecSetup.GET;
                recVehicle.SETRANGE(recVehicle."Current Location of VIN", recSalesRecSetup."Custom Application Location 1",
                                    recSalesRecSetup."Custom Application Location 2");
                //***SM 30-06-2013 since they have two custom app. location
                IF LookUpMgt.LookUpVehicleAMT(recVehicle, "Vehicle Serial No.") THEN BEGIN
                    recVehicle.CALCFIELDS(Inventory);
                    recVehicle.TESTFIELD(Inventory, 1);
                    VALIDATE("Vehicle Serial No.", recVehicle."Serial No.");
                    "Chasis No." := recVehicle.VIN;
                    "Engine No." := recVehicle."Engine No.";
                    "ARE1 No." := recVehicle."DRP No./ARE1 No.";
                    Model := recVehicle."Model Code";
                    "Model Version" := recVehicle."Model Version No.";

                END;
            end;
        }
        field(3; "ARE1 No."; Code[20])
        {
        }
        field(4; "Engine No."; Code[20])
        {
        }
        field(5; "To Branch"; Code[10])
        {
            TableRelation = Location WHERE(Code = FILTER(*VH*));
        }
        field(6; Model; Code[20])
        {
            TableRelation = Model.Code;

            trigger OnValidate()
            begin
                CALCFIELDS("Model Name");
            end;
        }
        field(7; "Model Name"; Text[50])
        {
            CalcFormula = Lookup(Model."Commercial Name" WHERE(Code = FIELD(Model)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Model Version"; Code[20])
        {

            trigger OnLookup()
            begin
                GblItem.RESET;
                IF GblLookupMgt.LookUpModelVersion(GblItem, "Model Version", GblItem."Make Code", Model) THEN
                    VALIDATE("Model Version", GblItem."No.");
            end;

            trigger OnValidate()
            begin
                CALCFIELDS("Model Version Desc.");
            end;
        }
        field(9; "Model Version Desc."; Text[50])
        {
            CalcFormula = Lookup(Item.Description WHERE(No.=FIELD(Model Version),
                                                         Item Type=CONST(Model Version)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"Veh. Reg No.";Code[20])
        {
        }
        field(11;"C & F Date";Date)
        {

            trigger OnValidate()
            begin
                "C & F Date (BS)" := GblSTPLSysMngt.getNepaliDate("C & F Date");
            end;
        }
        field(12;"C & F Date (BS)";Code[10])
        {

            trigger OnValidate()
            begin
                "C & F Date" := GblSTPLSysMngt.getEngDate("C & F Date (BS)");
            end;
        }
        field(13;Remarks;Text[120])
        {
        }
        field(14;"Ins. Memo No.";Code[20])
        {
            Editable = false;
            TableRelation = "Ins. Memo Header"."Reference No." WHERE (Posted=CONST(Yes));

            trigger OnValidate()
            begin
                GblInsMemo.RESET;
                GblInsMemo.SETRANGE("Reference No.","Ins. Memo No.");
                IF GblInsMemo.FIND('-') THEN BEGIN
                  VALIDATE("Ins. Memo Date",GblInsMemo."Memo Date");
                  MODIFY;
                END;
            end;
        }
        field(15;"Ins. Memo Date";Date)
        {
            Editable = true;

            trigger OnValidate()
            begin
                "Ins. Memo Date (BS)" := GblSTPLSysMngt.getNepaliDate("Ins. Memo Date");
            end;
        }
        field(16;"Ins. Memo Date (BS)";Code[10])
        {
            Editable = true;

            trigger OnValidate()
            begin
                "Ins. Memo Date" := GblSTPLSysMngt.getEngDate("Ins. Memo Date (BS)");
            end;
        }
        field(17;"Vehicle Serial No.";Code[20])
        {
            TableRelation = Vehicle;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                recInsuranceMemoLine: Record "33020166";
                recInsuranceMemoHdr: Record "33020165";
            begin
                recCCMemoLine.RESET;
                recCCMemoLine.SETRANGE(recCCMemoLine."Vehicle Serial No.","Vehicle Serial No.");
                IF recCCMemoLine.FINDFIRST THEN BEGIN
                   recCCMemoLine.CALCFIELDS("Chasis No.");
                   ERROR('Chasis No. '+recCCMemoLine."Chasis No."+' already exist in the Custom memo No. '+recCCMemoLine."Reference No.");
                END;
                recInsuranceMemoLine.SETRANGE(recInsuranceMemoLine."Vehicle Serial No.","Vehicle Serial No.");
                recInsuranceMemoLine.SETRANGE(recInsuranceMemoLine.Canceled,FALSE);
                IF recInsuranceMemoLine.FINDFIRST THEN BEGIN
                   "Ins. Memo No.":=recInsuranceMemoLine."Reference No.";
                    recInsuranceMemoHdr.SETRANGE(recInsuranceMemoHdr."Reference No.",recInsuranceMemoLine."Reference No.");
                    IF recInsuranceMemoHdr.FINDFIRST THEN  BEGIN
                    "Ins. Memo Date":=recInsuranceMemoHdr."Memo Date";
                    "Ins. Memo Date (BS)":=recInsuranceMemoHdr."Memo Date (BS)";
                    END;
                END;
            end;
        }
        field(18;"PP No.";Code[20])
        {
            Description = 'Pragyapan Patra';
            Editable = true;
        }
        field(19;"PP Date";Date)
        {
            Description = 'Pragyapan Patra Date';
            Editable = true;
        }
        field(20;"INS Memo No.";Code[20])
        {
            CalcFormula = Lookup("Ins. Memo Line"."Reference No." WHERE (Chasis No.=FIELD(Chasis No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21;"INS Memo Date";Date)
        {
            CalcFormula = Lookup("Ins. Memo Header"."Memo Date" WHERE (Reference No.=FIELD(Reference No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(22;"INS Memo Date (BS)";Code[10])
        {
            CalcFormula = Lookup("Ins. Memo Header"."Memo Date (BS)" WHERE (Reference No.=FIELD(Reference No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50000;"Insurance Memo Exists";Boolean)
        {
            CalcFormula = Exist("Ins. Memo Line" WHERE (Vehicle Serial No.=FIELD(Vehicle Serial No.)));
            FieldClass = FlowField;
        }
        field(50001;"C & F Amount";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Reference No.","Vehicle Serial No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GblSTPLSysMngt: Codeunit "50000";
        GblVehicle: Record "25006005";
        GblInsMemo: Record "33020165";
        GblItem: Record "27";
        GblLookupMgt: Codeunit "25006003";
        recCCMemoLine: Record "33020164";

    [Scope('Internal')]
    procedure DuplicateVINAllowed()
    var
        Text000: Label 'Vehicle already %1 on Memo No. %2';
        Text001: Label 'Vehicle already %1 on Memo No. %2, do you want to proceed.';
        CCMemoHeader: Record "33020163";
        CCMemoLine: Record "33020164";
    begin
        CCMemoLine.RESET;
        CCMemoLine.SETRANGE("Vehicle Serial No.","Vehicle Serial No.");
        IF CCMemoLine.FINDFIRST THEN BEGIN
          CCMemoHeader.RESET;
          CCMemoHeader.SETRANGE("Reference No.",CCMemoLine."Reference No.");
          IF CCMemoHeader.FINDFIRST THEN BEGIN
            //if CCMemoHeader.Posted then begin
              ERROR(Text000,'Posted',FORMAT(CCMemoHeader."Reference No."));
            /*end
            else begin
              if confirm(Text001) then begin
              end
              else
                error(Text000,'Exist',CCMemoHeader."Reference No.");
            end;
            */
          END;
        END;

    end;
}


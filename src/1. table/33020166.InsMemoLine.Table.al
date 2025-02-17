table 33020166 "Ins. Memo Line"
{

    fields
    {
        field(1; "Reference No."; Code[20])
        {
            TableRelation = "Ins. Memo Header"."Reference No.";
        }
        field(2; "Chasis No."; Code[20])
        {
            CalcFormula = Lookup(Vehicle.VIN WHERE(Serial No.=FIELD(Vehicle Serial No.)));
                Editable = false;
                FieldClass = FlowField;

            trigger OnLookup()
            var
                recVehicle: Record "25006005";
                recSalesRecSetup: Record "311";
                LookUpMgt: Codeunit "25006003";
            begin
                recVehicle.RESET;
                recSalesRecSetup.GET;
                //recVehicle.SETRANGE(recVehicle."Current Location of VIN",recSalesRecSetup."Custom Application Location");

                IF LookUpMgt.LookUpVehicleAMT(recVehicle, "Vehicle Serial No.") THEN BEGIN
                    VALIDATE("Vehicle Serial No.", recVehicle."Serial No.");
                    "Chasis No." := recVehicle.VIN;
                    "Engine No." := recVehicle."Engine No.";
                    "DRP No." := recVehicle."DRP No./ARE1 No.";
                    Model := recVehicle."Model Code";
                    "Model Version" := recVehicle."Model Version No.";
                    "Production Years" := recVehicle."Production Years";

                END;
            end;

            trigger OnValidate()
            begin
                //Retrieving vehicle information.
                /*GblVehicle.RESET;
                GblVehicle.SETRANGE(VIN,"Chasis No.");
                IF GblVehicle.FIND('-') THEN BEGIN
                  "Engine No." := GblVehicle."Engine No.";
                  "DRP No." := GblVehicle."DRP No.";
                  Model := GblVehicle."Model Code";
                  "Model Version" := GblVehicle."Model Version No.";
                  "Vehicle Serial No.":=GblVehicle."Serial No.";
                  "Production years.":=GblVehicle."Production years.";
                END;
                 */

            end;
        }
        field(3; "Engine No."; Code[20])
        {
        }
        field(4; "DRP No."; Code[20])
        {
        }
        field(5; Model; Code[20])
        {
            TableRelation = Model.Code;

            trigger OnValidate()
            begin
                CALCFIELDS("Model Description");
            end;
        }
        field(6; "Model Description"; Text[50])
        {
            CalcFormula = Lookup(Model."Commercial Name" WHERE(Code = FIELD(Model)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Model Version"; Code[20])
        {

            trigger OnLookup()
            begin
                GblItem.RESET;
                IF GblLookupMgt.LookUpModelVersion(GblItem, "Model Version", GblItem."Make Code", Model) THEN
                    VALIDATE("Model Version", GblItem."No.");
            end;

            trigger OnValidate()
            begin
                CALCFIELDS("Model Description");
            end;
        }
        field(8; "Model Version Desc."; Text[50])
        {
            CalcFormula = Lookup(Item.Description WHERE(No.=FIELD(Model Version)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;Amount;Decimal)
        {
        }
        field(10;"Vehicle Serial No.";Code[20])
        {
            TableRelation = Vehicle;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                recInsMemoLine: Record "33020166";
            begin
                //*** SM 26-06-2013 to check the valid period of the created insurance memo for the specific vehicles
                
                InsMemoLine.RESET;
                InsMemoLine.SETRANGE("Vehicle Serial No.","Vehicle Serial No.");
                IF InsMemoLine.FINDLAST THEN BEGIN
                   REPEAT
                      RefNo := InsMemoLine."Reference No.";
                      InsMemoHdr.RESET;
                      InsMemoHdr.SETRANGE("Reference No.",RefNo);
                      IF InsMemoHdr.FINDLAST THEN BEGIN
                         CheckDate := CALCDATE('+' +FORMAT(InsMemoHdr."Valid Period"),InsMemoHdr."Memo Date");
                         MESSAGE(FORMAT(CheckDate));
                         IF WORKDATE < CheckDate THEN
                            ERROR('Chasis no already exists in the valid Insurance memo no '+FORMAT(recInsMemoLine."Reference No."));
                      END;
                   UNTIL InsMemoLine.NEXT = 0;
                END;
                //*** SM 26-06-2013 to check the valid period of the created insurance memo for the specific vehicles
                
                
                //commented as approval and cancellation functionality has been discarded SM 02-07-2013
                /*
                recInsMemoLine.RESET;
                recInsMemoLine.SETRANGE(recInsMemoLine."Vehicle Serial No.","Vehicle Serial No.");
                recInsMemoLine.SETRANGE(recInsMemoLine.Canceled,FALSE);
                IF recInsMemoLine.FINDFIRST THEN
                   ERROR('Chassis no already exists in the Insurance memo no '+FORMAT(recInsMemoLine."Reference No."))
                */

            end;
        }
        field(11;Canceled;Boolean)
        {
        }
        field(12;Ton;Decimal)
        {
            CalcFormula = Lookup(Item.Ton WHERE (No.=FIELD(Model Version)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13;CC;Integer)
        {
            CalcFormula = Lookup(Item.CC WHERE (No.=FIELD(Model Version)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14;"Seat Capacity";Integer)
        {
            CalcFormula = Lookup(Item."Seat Capacity" WHERE (No.=FIELD(Model Version)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15;"Variant Code";Code[20])
        {
            CalcFormula = Min("Item Ledger Entry"."Variant Code" WHERE (Serial No.=FIELD(Vehicle Serial No.)));
            FieldClass = FlowField;
        }
        field(16;"Production Years";Code[4])
        {
            Editable = false;
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
        GblVehicle: Record "25006005";
        GblItem: Record "27";
        GblLookupMgt: Codeunit "25006003";
        InsMemoLine: Record "33020166";
        RefNo: Code[20];
        InsMemoHdr: Record "33020165";
        CheckDate: Date;
        "Production Year": Record "25006005";

    [Scope('Internal')]
    procedure DuplicateVINAllowed()
    var
        Text000: Label 'Vehicle already %1 on Memo No. %2';
        Text001: Label 'Vehicle already %1 on Memo No. %2, do you want to proceed.';
        InsMemoHeader: Record "33020165";
        InsMemoLine: Record "33020166";
    begin
        InsMemoLine.RESET;
        InsMemoLine.SETRANGE("Vehicle Serial No.","Vehicle Serial No.");
        IF InsMemoLine.FINDFIRST THEN BEGIN
          InsMemoHeader.RESET;
          InsMemoHeader.SETRANGE("Reference No.",InsMemoLine."Reference No.");
          IF InsMemoHeader.FINDFIRST THEN BEGIN
            //if CCMemoHeader.Posted then begin
              ERROR(Text000,'Posted',FORMAT(InsMemoHeader."Reference No."));
            /*end
            else begin
              if confirm(Text001) then begin
              end
              else
                error(Text000,'Exist',insMemoHeader."Reference No.");
            end;
            */
          END;
        END;

    end;
}


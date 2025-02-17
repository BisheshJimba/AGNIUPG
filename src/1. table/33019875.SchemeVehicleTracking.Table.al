table 33019875 "Scheme Vehicle Tracking"
{

    fields
    {
        field(1; "Membership Card No."; Code[20])
        {
        }
        field(2; "Make Code"; Code[20])
        {
            Editable = false;
            TableRelation = Make;
        }
        field(3; "Model Code"; Code[20])
        {
            Editable = false;
            TableRelation = Model;
        }
        field(4; "Model Version No."; Code[20])
        {
            Editable = false;
            TableRelation = Item.No. WHERE(Item Type=FILTER(Model Version));
        }
        field(5;"Vehicle Serial No.";Code[20])
        {
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehi: Record "33019823";
            begin
                IF "Vehicle Serial No." = '' THEN BEGIN
                   "Make Code" := '';
                   "Model Code" := '';
                   "Model Version No." := '';
                   VIN := '';
                   "Vehicle Accounting Cycle No." := '';
                   "Vehicle Reg. No." := '';
                END ELSE BEGIN
                   Vehicle.RESET;
                   Vehicle.SETRANGE("Serial No.","Vehicle Serial No.");
                   IF Vehicle.FINDFIRST THEN BEGIN
                   "Make Code" := Vehicle."Make Code";
                   "Model Code" := Vehicle."Model Code";
                   "Model Version No." := Vehicle."Model Version No.";
                   IF Vehi.GET("Vehicle Serial No.") THEN;
                   "Vehicle Accounting Cycle No." := Vehi."Default Vehicle Acc. Cycle No."; //v2
                   "Vehicle Reg. No." := Vehicle."Registration No.";
                   VIN := Vehicle.VIN;
                   END;
                   MemberDetails.RESET;
                   MemberDetails.SETRANGE("Membership Card No.","Membership Card No.");
                   IF MemberDetails.FINDFIRST THEN BEGIN
                      "Scheme Code" := MemberDetails."Scheme Code";
                      MODIFY;
                   END;
                END;
            end;
        }
        field(6;VIN;Code[20])
        {
            Editable = false;

            trigger OnLookup()
            begin
                Vehicle.RESET;
                IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
                 BEGIN
                  VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
                  //CALCFIELDS(VIN);
                 END;
            end;
        }
        field(7;"Vehicle Accounting Cycle No.";Code[20])
        {
            Editable = false;
        }
        field(8;Status;Option)
        {
            OptionCaption = ' ,Primary,Secondary';
            OptionMembers = " ",Primary,Secondary;
        }
        field(9;"Line No.";Integer)
        {
        }
        field(10;"Scheme Code";Code[20])
        {
            Editable = false;
            FieldClass = Normal;
            TableRelation = "Service Scheme Header";
        }
        field(11;"Vehicle Reg. No.";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Membership Card No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Vehicle: Record "25006005";
        LookUpMgt: Codeunit "25006003";
        MemberDetails: Record "33019864";
}


table 33020151 "Prospect Veh. Info."
{

    fields
    {
        field(1; "Used For"; Option)
        {
            OptionCaption = ' ,PVInfo,NAppPln';
            OptionMembers = " ",PVInfo,NAppPln;
        }
        field(2; "Prospect No."; Code[20])
        {
            TableRelation = Contact;
        }
        field(3; "Model No."; Code[20])
        {
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make));
        }
        field(4;"Model Version No.";Code[20])
        {

            trigger OnLookup()
            begin
                //Lookup Model Version.
                GblItem.RESET;
                IF GblLookupMgt.LookUpModelVersion(GblItem,"Model Version No.",Make,"Model No.") THEN
                 VALIDATE("Model Version No.",GblItem."No.");
            end;

            trigger OnValidate()
            begin
                //Code to bring model version name.
                GblItem.RESET;
                GblItem.SETRANGE("No.","Model Version No.");
                IF GblItem.FIND('-') THEN
                  "Model Version Name" := GblItem.Description;
            end;
        }
        field(5;"Model Version Name";Text[50])
        {
        }
        field(6;"Fuel Type";Code[10])
        {
            TableRelation = "CRM Master Template".Code WHERE (Master Options=CONST(FuelPreference));
        }
        field(7;Date;Date)
        {
        }
        field(8;Time;Time)
        {
        }
        field(9;"Line No.";Integer)
        {
            AutoIncrement = true;
        }
        field(10;Venue;Text[50])
        {
        }
        field(11;Make;Code[20])
        {
            TableRelation = Make;
        }
    }

    keys
    {
        key(Key1;"Used For","Prospect No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GblLookupMgt: Codeunit "25006003";
        GblItem: Record "27";
}


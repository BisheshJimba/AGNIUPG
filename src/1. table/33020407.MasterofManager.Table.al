table 33020407 "Master of Manager"
{

    fields
    {
        field(1; "Department Code"; Code[10])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Department),
                                                          Blocked = CONST(No));

            trigger OnValidate()
            begin
                DimensionRec.RESET;
                DimensionRec.SETRANGE(Code, "Department Code");
                IF DimensionRec.FINDFIRST THEN BEGIN
                    "Department Name" := DimensionRec.Description;
                END;
            end;
        }
        field(2; "Department Name"; Text[50])
        {
        }
        field(3; Desgination; Option)
        {
            Description = ' ,HOD,Reporting 1,Reporting 2,Reporting 3,Reporting 4,Reporting 5,Reporting 6,Reporting 7,Reporting 8,Reporting 9,Reporting 10,VP,GM,CEO,EC,Reporting 11,Reporting 12,Reporting 13,Reporting 14,Reporting 15';
            OptionCaption = ' ,HOD,Reporting 1,Reporting 2,Reporting 3,Reporting 4,Reporting 5,Reporting 6,Reporting 7,Reporting 8,Reporting 9,Reporting 10,VP,GM,CEO,EC,Reporting 11,Reporting 12,Reporting 13,Reporting 14,Reporting 15';
            OptionMembers = " ",HOD,"Reporting 1","Reporting 2","Reporting 3","Reporting 4","Reporting 5","Reporting 6","Reporting 7","Reporting 8","Reporting 9","Reporting 10",VP,GM,CEO,EC,"Reporting 11","Reporting 12","Reporting 13","Reporting 14","Reporting 15";
        }
        field(4; "Manager ID"; Code[20])
        {
            TableRelation = Employee.No.;

            trigger OnValidate()
            begin
                EmployeeRec.RESET;
                EmployeeRec.SETRANGE("No.", "Manager ID");
                IF EmployeeRec.FINDFIRST THEN BEGIN
                    "Manager Name" := EmployeeRec."Full Name";
                END;
            end;
        }
        field(5; "Manager Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Department Code", Desgination)
        {
            Clustered = true;
        }
        key(Key2; Desgination, "Department Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        DimensionRec: Record "33020337";
        EmployeeRec: Record "5200";
}


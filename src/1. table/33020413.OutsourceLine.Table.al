table 33020413 "Outsource Line"
{

    fields
    {
        field(1; "Outsource No."; Code[20])
        {
        }
        field(2; Company; Code[20])
        {
            TableRelation = "Outsource Service-Company".Code WHERE(Type = CONST(Company));

            trigger OnValidate()
            begin
                OutsourceRec.RESET;
                OutsourceRec.SETRANGE(Code, Company);
                IF OutsourceRec.FINDFIRST THEN BEGIN
                    "Company Name" := OutsourceRec.Description;
                END;
                IF OutsourceRec.COUNT = 0 THEN
                    "Company Name" := '';
            end;
        }
        field(3; Service; Code[20])
        {
            TableRelation = "Outsource Service-Company".Code WHERE(Type = CONST(Service));

            trigger OnValidate()
            begin
                OutsourceRec.RESET;
                OutsourceRec.SETRANGE(Code, Service);
                IF OutsourceRec.FINDFIRST THEN BEGIN
                    "Service Name" := OutsourceRec.Description;
                END;
                IF OutsourceRec.COUNT = 0 THEN
                    "Service Name" := '';
            end;
        }
        field(4; Branch; Code[20])
        {
            TableRelation = "Location Master".Code WHERE(Type = CONST(Branch));

            trigger OnValidate()
            begin
                DimensionRec.RESET;
                DimensionRec.SETRANGE(Code, Branch);
                IF DimensionRec.FINDFIRST THEN BEGIN
                    "Branch Name" := DimensionRec.Description;
                END;
                IF DimensionRec.COUNT = 0 THEN
                    "Branch Name" := '';
            end;
        }
        field(5; "Outsource Employee Code"; Code[20])
        {
            TableRelation = "Outsource Employee"."Outsource Employee No.";

            trigger OnValidate()
            begin
                OutsourceEmpRec.RESET;
                OutsourceEmpRec.SETRANGE("Outsource Employee No.", "Outsource Employee Code");
                IF OutsourceEmpRec.FINDFIRST THEN
                    "Outsource Employee Name" := OutsourceEmpRec."Full Name";
                IF OutsourceEmpRec.COUNT = 0 THEN
                    "Outsource Employee Name" := '';
            end;
        }
        field(7; "Effective Date"; Date)
        {
        }
        field(8; Amount; Decimal)
        {
        }
        field(9; Date; Date)
        {
        }
        field(10; "Company Name"; Text[80])
        {
        }
        field(11; "Service Name"; Text[80])
        {
        }
        field(12; "Branch Name"; Text[30])
        {
        }
        field(13; "Outsource Employee Name"; Text[80])
        {
        }
        field(14; "Home Leave"; Decimal)
        {
        }
        field(15; "Sick Leave"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Outsource No.", Date, "Outsource Employee Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        DimensionRec: Record "33020337";
        OutsourceRec: Record "33020321";
        OutsourceEmpRec: Record "33020414";
}


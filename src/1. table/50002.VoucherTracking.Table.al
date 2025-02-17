table 50002 "Voucher Tracking"
{

    fields
    {
        field(1; "Fiscal Year"; Code[10])
        {
        }
        field(2; "From Voucher No."; Code[20])
        {
        }
        field(3; "To Voucher No."; Code[20])
        {
        }
        field(4; "File No."; Code[10])
        {
        }
        field(5; "Rack No."; Code[20])
        {
        }
        field(6; "File Location"; Code[10])
        {
            TableRelation = "File Rack Location"."Phy. Location";
        }
        field(7; Subject; Text[50])
        {
        }
        field(8; "Responsible Person"; Text[50])
        {
        }
        field(9; Manager; Text[50])
        {
        }
        field(10; "Keep Date"; Date)
        {

            trigger OnValidate()
            begin
                // "Keep Date (BS)" := GblSTPLSysMngt.getNepaliDate("Keep Date"); //getNepaliDate
            end;
        }
        field(11; "Keep Date (BS)"; Code[10])
        {

            trigger OnValidate()
            begin
                // "Keep Date" := GblSTPLSysMngt.getEngDate("Keep Date (BS)"); //getNepaliDate
            end;
        }
        field(12; "Phy. Location"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Fiscal Year", "From Voucher No.", "To Voucher No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GblSTPLSysMngt: Codeunit "STPL System Management";
}


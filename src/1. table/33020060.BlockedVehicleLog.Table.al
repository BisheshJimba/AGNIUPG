table 33020060 "Blocked Vehicle Log"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Service Item No."; Code[20])
        {
        }
        field(3; "Customer No."; Code[20])
        {
            TableRelation = Customer.No.;
        }
        field(4; Date; Date)
        {
        }
        field(5; Time; Time)
        {
        }
        field(6; "Document Type"; Option)
        {
            OptionCaption = 'Sales,Service,Complaint';
            OptionMembers = Sales,Service,Complaint;
        }
        field(7; "Document No."; Code[20])
        {
        }
        field(8; "User ID"; Code[50])
        {
        }
        field(9; "Location Code"; Code[10])
        {
        }
        field(10; Branch; Code[10])
        {
        }
        field(11; "Table"; Option)
        {
            OptionCaption = ' ,Vehicle';
            OptionMembers = " ",Vehicle;
        }
        field(12; Reason; Text[100])
        {
        }
        field(13; "Block Type"; Option)
        {
            OptionCaption = ' ,All,Unblock';
            OptionMembers = " ",All,Unblock;
        }
        field(14; "Blocked by VFD"; Boolean)
        {
        }
        field(16; Company; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('Internal')]
    procedure GetEntryNo(): Integer
    var
        ItemBlockLog: Record "33020060";
    begin
        ItemBlockLog.RESET;
        ItemBlockLog.SETCURRENTKEY(ItemBlockLog."Entry No.");
        ItemBlockLog.SETASCENDING("Entry No.", FALSE);
        IF ItemBlockLog.FINDFIRST THEN
            EXIT(ItemBlockLog."Entry No." + 1)
        ELSE
            EXIT(1);
    end;
}


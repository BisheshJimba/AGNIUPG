table 33020258 "SMS Details"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Mobile Number"; Text[20])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(3; "Creation Date"; DateTime)
        {
        }
        field(4; "Message Type"; Option)
        {
            OptionCaption = 'Bill,Job,Birthday,Service Reminder,Revised Job,KAM,Service Booking,Service Booking Reminder,Credit Bill,Credit Bill Due Date Reminder,Credit Bill Due Date Crossed Reminder,EMI Due Reminder,Credit Bill Follow up,Apporximate Estimate,Reschedule EMI,Reschedule Tenure';
            OptionMembers = Bill,Job,Birthday,"Service Reminder","Revised Job",KAM,"Service Booking","Service Booking Reminder"," redit Bill Due Date Reminder","Credit Bill Due Date Crossed Reminder","EMI Due Reminder","Credit Bill Follow up"," stimate","Reschedule EMI","Reschedule Tenure";
        }
        field(5; "Message Text"; Text[250])
        {
        }
        field(6; Status; Option)
        {
            OptionCaption = 'New,Processed,Failed,Sent';
            OptionMembers = New,Processed,Failed,Sent;
        }
        field(7; "Last Modified Date"; DateTime)
        {
        }
        field(8; Comment; Text[250])
        {
        }
        field(9; "Document No."; Code[20])
        {
        }
        field(10; Amount; Decimal)
        {
        }
        field(11; Company; Text[30])
        {
            Editable = false;
        }
        field(12; MessageID; Text[250])
        {
        }
        field(13; "Location Code"; Code[10])
        {
            TableRelation = Location;
        }
        field(14; Scheduled; Boolean)
        {
        }
        field(15; "SMS API Response"; Code[250])
        {
        }
        field(16; "Policy No."; Text[100])
        {
        }
        field(17; "Message Text 2"; Text[250])
        {
        }
        field(50000; "Message Length"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Message Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


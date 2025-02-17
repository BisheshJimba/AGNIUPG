table 33020257 "SMS Templates"
{

    fields
    {
        field(1; "Document Profile"; Option)
        {
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service,Battery Sales';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service,"Battery Sales";
        }
        field(2; Type; Option)
        {
            OptionCaption = 'Bill,Job,Birthday,Service Reminder,Revised Job,KAM,Service Booking,Service Booking Reminder,Credit Bill,Credit Bill Due Date Reminder,Credit Bill Due Date Crossed Reminder,EMI Due Reminder,Credit Bill Follow up,Apporximate Estimate,Reschedule EMI,Reschedule Tenure,Insurance Reminder,Customer Due Notification 1,Customer Due Notification 2,Insurance Expiry Notification,Customer Due Notification 3,Service Feedback';
            OptionMembers = Bill,Job,Birthday,"Service Reminder","Revised Job",KAM,"Service Booking","Service Booking Reminder","Credit Bill","Credit Bill Due Date Reminder"," ue Date Crossed Reminder","EMI Due Reminder","Credit Bill Follow up","Apporximate Estimate","Reschedule EMI","Reschedule Tenure","Insurance Reminder","Customer Due Notification 1","Customer Due Notification 2","Insurance Expiry Notification","Customer Due Notification 3","Service Feedback";
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "Message Text"; Text[250])
        {
        }
        field(5; "Message Text 2"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Document Profile", Type, "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


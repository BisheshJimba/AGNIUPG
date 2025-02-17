table 33019811 "NCHL-NPI Integration Service"
{
    Caption = 'NCHL-NPI Integration Service';

    fields
    {
        field(1; "Service Type"; Option)
        {
            OptionCaption = ' ,Access Token,CIPS,NCHLIPS,CIPS Bank List,Bank Account Validation,CIPS App List,DOC Details,Realtime Lodge Bill,Realtime Confirm Bill,Custom Office,Status,Category,Redg Serial,Non Real Lodge Bill,Non Real Confirm,NonRealtime Report,Realtime Report';
            OptionMembers = " ","Access Token",CIPS,NCHLIPS,"CIPS Bank List","Bank Account Validation","CIPS App List","DOC Details","Realtime Lodge Bill","Realtime Confirm Bill","Custom Office",Status,Category,"Redg Serial","Non Real Lodge Bill","Non Real Confirm","NonRealtime Report","Realtime Report";
        }
        field(2; "Service Name"; Text[80])
        {
        }
    }

    keys
    {
        key(Key1; "Service Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}


page 25006402 "SMS Batch Queue Entries"
{
    PageType = List;
    SourceTable = Table25006402;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                }
                field("Entry Type"; "Entry Type")
                {
                }
                field(Status; Status)
                {
                }
                field("Request Attempts"; "Request Attempts")
                {
                }
                field("Last Request Attempt"; "Last Request Attempt")
                {
                }
                field("Expire Date Time"; "Expire Date Time")
                {
                }
                field("Provider BatchId"; "Provider BatchId")
                {
                }
                field("SMS Repliable"; "SMS Repliable")
                {
                }
                field("SMS SenderId"; "SMS SenderId")
                {
                }
                field("Entry Created"; "Entry Created")
                {
                }
                field("Provider Batch Cost"; "Provider Batch Cost")
                {
                }
                field("SMS Entry Count"; "SMS Entry Count")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Show SMS Entries")
            {
            }
        }
    }
}


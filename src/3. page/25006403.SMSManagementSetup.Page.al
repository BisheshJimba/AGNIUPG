page 25006403 "SMS Management Setup"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Table25006403;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("SMS Provider Username"; "SMS Provider Username")
                {
                }
                field("SMS Provider Password"; "SMS Provider Password")
                {
                }
                field("Sms Batch Queue Expire Period"; "Sms Batch Queue Expire Period")
                {
                }
                field("Sms Batch Queue Arch. Period"; "Sms Batch Queue Arch. Period")
                {
                }
                field("Enable Repliable SMS"; "Enable Repliable SMS")
                {
                }
                field("SMS Sender Id"; "SMS Sender Id")
                {
                }
                field("Provider URL"; "Provider URL")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;
    end;
}


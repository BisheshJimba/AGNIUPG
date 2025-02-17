page 33020579 "SMS Setup"
{
    PageType = Card;
    SourceTable = Table50006;

    layout
    {
        area(content)
        {
            group("SMS Configure")
            {
                field("Enable Agile SMS Gateway"; "Enable Agile SMS Gateway")
                {
                }
            }
            group(General)
            {
                field("User Name"; "User Name")
                {
                }
                field(PasswordTemp; PasswordTemp)
                {
                    Caption = 'Password';

                    trigger OnValidate()
                    begin
                        SetPassword(PasswordTemp);
                        COMMIT;
                        CurrPage.UPDATE;
                    end;
                }
                field(Token; Token)
                {
                }
                field(Identity; Identity)
                {
                }
                field("SMS Text Length"; "SMS Text Length")
                {
                }
                field("Base URL"; "Base URL")
                {
                }
                field(Method; Method)
                {
                }
                field(RESTMethod; RESTMethod)
                {
                }
            }
            group("Agile SMS")
            {
                field("Agile User Name"; "Agile User Name")
                {
                }
                field("Agile Password Key"; "Agile Password Key")
                {
                }
                field("Agile Base URL"; "Agile Base URL")
                {
                }
                field("Agile Client Code"; "Agile Client Code")
                {
                }
                field("Agile Method"; "Agile Method")
                {
                }
                field("Agile RESTMethod"; "Agile RESTMethod")
                {
                }
                field("Customer Due Notification 1"; "Customer Due Notification 1")
                {
                    Caption = 'Customer Due Notification Before 7 Days';
                }
                field("Customer Due Notification 2"; "Customer Due Notification 2")
                {
                    Caption = 'Customer Due Notification Before 3 Days';
                }
                field("Customer Due Notification 3"; "Customer Due Notification 3")
                {
                    Caption = 'Customer Due Notification After 3 Days';
                }
                field("Insurance Expiry Notification"; "Insurance Expiry Notification")
                {
                }
            }
            group("SMS Length")
            {
                field("Agile SMS Length (1st)"; "Agile SMS Length (1st)")
                {
                }
                field("Agile SMS Length (2nd & above)"; "Agile SMS Length (2nd & above)")
                {
                }
                field("SMS Length (1st) Unicode"; "SMS Length (1st) Unicode")
                {
                }
                field("SMS Length (2nd & above) Unico"; "SMS Length (2nd & above) Unico")
                {
                }
            }
            group(TEST)
            {
                field("TEST Phone  No."; "TEST Phone  No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Test SMS")
            {

                trigger OnAction()
                var
                    Rep: Codeunit "50002";
                    sms: Codeunit "50002";
                    MessageID: Text;
                begin
                    //Rep.SendCustomerDueNotificationAfterThreeDays11(Rec."TEST Phone  No.");
                    IF sms.SendSMS("TEST Phone  No.", 'TEST', MessageID) THEN
                        MESSAGE('sent');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        PasswordTemp := '';
        IF ("User Name" <> '') AND (NOT ISNULLGUID("Password Key")) THEN
            PasswordTemp := '**********';
    end;

    trigger OnOpenPage()
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;
    end;

    var
        PasswordTemp: Text;
}


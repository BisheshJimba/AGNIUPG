table 50006 "SMS Setup"
{
    Caption = 'SMS Setup';
    Permissions = TableData 1261 = rim;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(3; "User Name"; Text[250])
        {
        }
        field(4; "Password Key"; Guid)
        {
        }
        field(5; Token; Text[250])
        {
        }
        field(6; Identity; Text[250])
        {
        }
        field(7; "SMS Text Length"; Integer)
        {
        }
        field(8; "Base URL"; Text[250])
        {
        }
        field(9; Method; Text[30])
        {
        }
        field(10; RESTMethod; Option)
        {
            OptionCaption = 'GET,POST,PUT,DELETE';
            OptionMembers = GET,POST,PUT,DELETE;
        }
        field(50000; Keywords; Integer)
        {
            Description = 'For cut off first 6 digit of mesage';
        }
        field(50001; "Enable Agile SMS Gateway"; Boolean)
        {
        }
        field(50002; "Agile User Name"; Text[50])
        {
        }
        field(50003; "Agile Password Key"; Text[100])
        {
            ExtendedDatatype = Masked;
        }
        field(50004; "Agile Base URL"; Text[250])
        {
        }
        field(50005; "Agile Method"; Text[30])
        {
        }
        field(50006; "Agile RESTMethod"; Option)
        {
            OptionCaption = 'GET,POST,PUT,DELETE';
            OptionMembers = GET,POST,PUT,DELETE;
        }
        field(50007; "Agile SMS Length (1st)"; Integer)
        {
            Description = 'For non-unicode';
        }
        field(50008; "Agile SMS Length (2nd & above)"; Integer)
        {
            Description = 'For non-unicode';
        }
        field(50009; "SMS Length (1st) Unicode"; Integer)
        {
            Description = 'For unicode';
        }
        field(50010; "SMS Length (2nd & above) Unico"; Integer)
        {
            Description = 'For unicode';
        }
        field(50011; "Agile Client Code"; Code[20])
        {
        }
        field(50012; "Customer Due Notification 1"; Integer)
        {
        }
        field(50013; "Customer Due Notification 2"; Integer)
        {
        }
        field(50014; "Insurance Expiry Notification"; Integer)
        {
        }
        field(50015; "Customer Due Notification 3"; Integer)
        {
        }
        field(50016; "TEST Phone  No."; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ExchangeAccountNotConfiguredErr: Label 'The Exchange account is not configured.';
        Text001: Label 'Autodiscovery of Exchange Service failed.';

    [Scope('Internal')]
    procedure SetPassword(PasswordText: Text)
    var
        ServicePassword: Record "Service Password";
    begin
        IF ISNULLGUID("Password Key") OR NOT ServicePassword.GET("Password Key") THEN BEGIN
            ServicePassword.SavePassword(PasswordText);
            ServicePassword.INSERT(TRUE);
            "Password Key" := ServicePassword.Key;
        END ELSE BEGIN
            ServicePassword.SavePassword(PasswordText);
            ServicePassword.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure GetPassword(): Text
    var
        ServicePassword: Record "Service Password";
    begin
        IF NOT ISNULLGUID("Password Key") THEN
            IF ServicePassword.GET("Password Key") THEN
                EXIT(ServicePassword.GetPassword());
    end;
}


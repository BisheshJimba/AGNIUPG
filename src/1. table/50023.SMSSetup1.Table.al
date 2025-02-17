table 50023 "SMS Setup 1"
{
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

